/* FCE Ultra - NES/Famicom Emulator
 *
 * Copyright notice for this file:
 *  Copyright (C) 2002 Xodnizel
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "types.h"
#include "x6502.h"
#include "version.h"
#include "fce.h"
#include "fds.h"
#include "svga.h"
#include "sound.h"
#include "general.h"
#include "state.h"
#include "file.h"
#include "memory.h"
#include "cart.h"

/*	TODO:  Add code to put a delay in between the time a disk is inserted
	and the when it can be successfully read/written to.  This should
	prevent writes to wrong places OR add code to prevent disk ejects
	when the virtual motor is on(mmm...virtual motor).
*/

static DECLFR(FDSRead4030);
static DECLFR(FDSRead4031);
static DECLFR(FDSRead4032);
static DECLFR(FDSRead4033);

static DECLFW(FDSWrite);

static DECLFW(FDSWaveWrite);
static DECLFR(FDSWaveRead);

static DECLFR(FDSSRead);
static DECLFW(FDSSWrite);
static DECLFR(FDSBIOSRead);
static DECLFR(FDSRAMRead);
static DECLFW(FDSRAMWrite);
static void FDSInit(void);
static void FP_FASTAPASS(1) FDSFix(int a);

#define FDSRAM GameMemBlock
#define CHRRAM   (GameMemBlock+32768)

static uint8 FDSRegs[6];
static int32 IRQLatch,IRQCount;
static uint8 IRQa;
static void FDSClose(void);
static uint8 header[16];
static char FDSSaveName[2048];

uint8 FDSBIOS[8192];
uint8 *diskdata[4]={0,0,0,0};

static uint8 writeskip;
static uint32 DiskPtr;
static int32 DiskSeekIRQ;
static uint8 SelectDisk,InDisk;

#define DC_INC		1

void FDSGI(int h)
{
 switch(h)
 {
  case GI_CLOSE: FDSClose();break;
  case GI_POWER: FDSInit();break;
 }
}

static void FDSStateRestore(int version)
{ 
 setmirror(((FDSRegs[5]&8)>>3)^1);
}

void FDSSound();
void FDSSoundReset(void);
void FDSSoundStateAdd(void);
static void RenderSound(void);
static void RenderSoundHQ(void);

static void FDSInit(void)
{
 memset(FDSRegs,0,sizeof(FDSRegs));
 writeskip=DiskPtr=DiskSeekIRQ=0;
 setmirror(1);

 setprg8r(0,0xe000,0);          // BIOS
 setprg32r(1,0x6000,0);         // 32KB RAM
 setchr8(0);           // 8KB CHR RAM

 MapIRQHook=FDSFix;
 GameStateRestore=FDSStateRestore;

 SetReadHandler(0x4030,0x4030,FDSRead4030);
 SetReadHandler(0x4031,0x4031,FDSRead4031);
 SetReadHandler(0x4032,0x4032,FDSRead4032);
 SetReadHandler(0x4033,0x4033,FDSRead4033);

 SetWriteHandler(0x4020,0x4025,FDSWrite); 

 SetWriteHandler(0x6000,0xdfff,FDSRAMWrite);
 SetReadHandler(0x6000,0xdfff,FDSRAMRead);
 SetReadHandler(0xE000,0xFFFF,FDSBIOSRead);
 IRQCount=IRQLatch=IRQa=0;

 FDSSoundReset();
 InDisk=0;
 SelectDisk=0;
}

void FDSControl(int what)
{
 switch(what)
 {
  case FDS_IDISK:if(InDisk==255)
		 {
		  FCEU_DispMessage("Disk %d Side %s Inserted",
		  SelectDisk>>1,(SelectDisk&1)?"B":"A");
		  InDisk=SelectDisk;
		 }
		 else
		 {
		  FCEU_DispMessage("Disk %d Side %s Ejected",SelectDisk>>1,(SelectDisk&1)?"B":"A");
		  InDisk=255;
		 }
		 break;
  case FDS_SELECT:
		  if(InDisk!=255)
		  {
		   FCEU_DispMessage("Eject disk before selecting.");
		   break;
		  }
		  SelectDisk=((SelectDisk+1)%header[4])&3;
		  FCEU_DispMessage("Disk %d Side %s Selected",
			SelectDisk>>1,(SelectDisk&1)?"B":"A");
		  break;
 }
}

static void FP_FASTAPASS(1) FDSFix(int a)
{
 if((IRQa&2) && IRQCount)
 {
  IRQCount-=a;
  if(IRQCount<=0)
  {
   if(!(IRQa&1))
    IRQa&=~2;
   IRQCount=IRQLatch; //0xFFFF;
   X6502_IRQBegin(FCEU_IQEXT);
//   printf("IRQ: %d\n",scanline);
  }
 }
 if(DiskSeekIRQ>0) 
 {
  DiskSeekIRQ-=a;
  if(DiskSeekIRQ<=0)
  {
   if(FDSRegs[5]&0x80)
   {
    X6502_IRQBegin(FCEU_IQEXT2);
   }
  }
 }
}

static DECLFR(FDSRead4030)
{
	uint8 ret=0;

	/* Cheap hack. */
	if(X.IRQlow&FCEU_IQEXT) ret|=1;
	if(X.IRQlow&FCEU_IQEXT2) ret|=2;

	if(!fceuindbg)
	{
	 X6502_IRQEnd(FCEU_IQEXT);
	 X6502_IRQEnd(FCEU_IQEXT2);
	}
	return ret;
}

static DECLFR(FDSRead4031)
{
	static uint8 z=0;
	if(InDisk!=255)
	{
         z=diskdata[InDisk][DiskPtr];
	 if(!fceuindbg)
	 {
          if(DiskPtr<64999) DiskPtr++;
          DiskSeekIRQ=150;
          X6502_IRQEnd(FCEU_IQEXT2);
	 }
	}
        return z;
}
static DECLFR(FDSRead4032)
{       
        uint8 ret;

        ret=X.DB&~7;
        if(InDisk==255)
         ret|=5;

        if(InDisk==255 || !(FDSRegs[5]&1) || (FDSRegs[5]&2))        
         ret|=2;
        return ret;
}

static DECLFR(FDSRead4033)
{
	return 0x80; // battery
}

static DECLFW(FDSRAMWrite)
{
 (FDSRAM-0x6000)[A]=V;
}

static DECLFR(FDSBIOSRead)
{
 return (FDSBIOS-0xE000)[A];
}

static DECLFR(FDSRAMRead)
{
 return (FDSRAM-0x6000)[A];
}

/* Begin FDS sound */

#define FDSClock (1789772.7272727272727272/2)

typedef struct {
        int64 cycles;           // Cycles per PCM sample
        int64 count;		// Cycle counter
	int64 envcount;		// Envelope cycle counter
	uint32 b19shiftreg60;
	uint32 b24adder66;
	uint32 b24latch68;
	uint32 b17latch76;
        int32 clockcount;	// Counter to divide frequency by 8.
	uint8 b8shiftreg88;	// Modulation register.
	uint8 amplitude[2];	// Current amplitudes.
	uint8 mwcount;
	uint8 mwstart;
        uint8 mwave[0x20];      // Modulation waveform
        uint8 cwave[0x40];      // Game-defined waveform(carrier)
        uint8 SPSG[0xB];
} FDSSOUND;

static FDSSOUND fdso;

#define	SPSG	fdso.SPSG
#define b19shiftreg60	fdso.b19shiftreg60
#define b24adder66	fdso.b24adder66
#define b24latch68	fdso.b24latch68
#define b17latch76	fdso.b17latch76
#define b8shiftreg88	fdso.b8shiftreg88
#define clockcount	fdso.clockcount
#define amplitude	fdso.amplitude

void FDSSoundStateAdd(void)
{
 AddExState(fdso.cwave,64,0,"WAVE");
 AddExState(fdso.mwave,32,0,"MWAV");
 AddExState(amplitude,2,0,"AMPL");
 AddExState(SPSG,0xB,0,"SPSG");

 AddExState(&b8shiftreg88,1,0,"B88");

 AddExState(&clockcount, 4, 1, "CLOC");
 AddExState(&b19shiftreg60,4,1,"B60");
 AddExState(&b24adder66,4,1,"B66");
 AddExState(&b24latch68,4,1,"B68");
 AddExState(&b17latch76,4,1,"B76");

}

static DECLFR(FDSSRead)
{
 switch(A&0xF)
 {
  case 0x0:return(amplitude[0]|(X.DB&0xC0));
  case 0x2:return(amplitude[1]|(X.DB&0xC0));
 }
 return(X.DB);
}

static DECLFW(FDSSWrite)
{
 if(FSettings.SndRate)
 {
  if(FSettings.soundq>=1)
   RenderSoundHQ();
  else
   RenderSound();
 }
 A-=0x4080;
 switch(A)
 {
  case 0x0: 
  case 0x4:
	    if(V&0x80)
	     amplitude[(A&0xF)>>2]=V&0x3F; //)>0x20?0x20:(V&0x3F);
	    break;
  case 0x7: b17latch76=0;SPSG[0x5]=0;break;
  case 0x8:
	   b17latch76=0;
	//   printf("%d:$%02x, $%02x\n",SPSG[0x5],V,b17latch76);
	   fdso.mwave[SPSG[0x5]&0x1F]=V&0x7;
           SPSG[0x5]=(SPSG[0x5]+1)&0x1F;
	   break;
 }
 //if(A>=0x7 && A!=0x8 && A<=0xF)
 //if(A==0xA || A==0x9) 
 //printf("$%04x:$%02x\n",A,V);
 SPSG[A]=V;
}

// $4080 - Fundamental wave amplitude data register 92
// $4082 - Fundamental wave frequency data register 58
// $4083 - Same as $4082($4083 is the upper 4 bits).

// $4084 - Modulation amplitude data register 78
// $4086 - Modulation frequency data register 72
// $4087 - Same as $4086($4087 is the upper 4 bits)


static void DoEnv()
{
 int x;

 for(x=0;x<2;x++)
  if(!(SPSG[x<<2]&0x80) && !(SPSG[0x3]&0x40))
  {
   static int counto[2]={0,0};

   if(counto[x]<=0)
   {
    if(!(SPSG[x<<2]&0x80))
    {
     if(SPSG[x<<2]&0x40)
     {
      if(amplitude[x]<0x3F)
       amplitude[x]++;
     }
     else
     {
      if(amplitude[x]>0)
       amplitude[x]--;
     }
    }
    counto[x]=(SPSG[x<<2]&0x3F);
   }
   else
    counto[x]--;
  }
}

static DECLFR(FDSWaveRead)
{
 return(fdso.cwave[A&0x3f]|(X.DB&0xC0));
}

static DECLFW(FDSWaveWrite)
{
 //printf("$%04x:$%02x, %d\n",A,V,SPSG[0x9]&0x80);
 if(SPSG[0x9]&0x80)
  fdso.cwave[A&0x3f]=V&0x3F;
}

static int ta;
static INLINE void ClockRise(void)
{
 if(!clockcount)
 {
  ta++;

  b19shiftreg60=(SPSG[0x2]|((SPSG[0x3]&0xF)<<8));
  b17latch76=(SPSG[0x6]|((SPSG[0x07]&0xF)<<8))+b17latch76;

  if(!(SPSG[0x7]&0x80)) 
  {
   int t=fdso.mwave[(b17latch76>>13)&0x1F]&7;
   //printf("%d %d, ",b17latch76>>13,(fdso.cwave[b24latch68>>18]*amplitude[0])*4/((SPSG[0x9]&0x3)+2));
   //t=(b17latch76>>12)&7;
   //FCEU_DispMessage("%2d %2d %d",t,amplitude[1],(b17latch76>>12)&0x1F);
   
   {
    int t2=amplitude[1];
//    if(t2>15) t2=15;
    t2&=31;
//    printf("%d:%02x ",t2,t);
    if(t&4)
     t=0x80-((t&3))*t2;
    else
     t=0x80+((t&3))*t2; //(0x80+(t&3))*(amplitude[1]); //t; //amplitude[1]*3; //t; //(amplitude[1])*(fdso.mwave[(b17latch76>>13)&0x1F]&7);
   }
//   if(t<0x80) t=0x80;
   //if(t<0) t=0;
   //if(t>0xff) t=0xfF;
   //t=0x80+amplitude[1]*((t&7));
   b8shiftreg88=t; //(t+0x80)*(amplitude[1]);

   // t=0;
   //t=(t-4)*(amplitude[1]);
   //FCEU_DispMessage("%d",amplitude[1]);
   //b8shiftreg88=((fdso.mwave[(b17latch76>>11)&0x1F]&7))|(amplitude[1]<<3);
  }
  else
  { 
   b8shiftreg88=0x80;
  }
  //b8shiftreg88=0x80;
 }
 else
 {
  b19shiftreg60<<=1;  
  b8shiftreg88>>=1;
 }
// b24adder66=(b24latch68+b19shiftreg60)&0x3FFFFFF;
 b24adder66=(b24latch68+b19shiftreg60)&0x1FFFFFF;
}

static INLINE void ClockFall(void)
{
 //if(!(SPSG[0x7]&0x80))
 {
  if((b8shiftreg88&1))
   b24latch68=b24adder66;
 }
 clockcount=(clockcount+1)&7;
}

static INLINE int32 FDSDoSound(void)
{
 fdso.count+=fdso.cycles;
 if(fdso.count>=((int64)1<<40))
 {
  dogk:
  fdso.count-=(int64)1<<40;
  ClockRise();
  ClockFall();
  fdso.envcount--;
  if(fdso.envcount<=0)
  {
   fdso.envcount+=SPSG[0xA]*2;
   DoEnv(); 
  }
 }
 if(fdso.count>=32768) goto dogk;

 // Might need to emulate applying the amplitude to the waveform a bit better...
 {
  int k=amplitude[0];
  if(k>0x20) k=0x20;
  return (fdso.cwave[b24latch68>>19]*k)*4/((SPSG[0x9]&0x3)+2);
 }
}

static int32 FBC=0;

static void RenderSound(void)
{
 int32 end, start;
 int32 x;

 start=FBC;
 end=(timestamp<<16)/soundtsinc;
 if(end<=start)
  return;
 FBC=end;

 if(!(SPSG[0x9]&0x80))
  for(x=start;x<end;x++)
  {
   uint32 t=FDSDoSound();
   t+=t>>1;
   t>>=4;
   Wave[x>>4]+=t; //(t>>2)-(t>>3); //>>3;
  }
}

static void RenderSoundHQ(void)
{
 int32 x;
  
 if(!(SPSG[0x9]&0x80))
  for(x=FBC;x<timestamp;x++)
  {
   uint32 t=FDSDoSound();
   t+=t>>1;
   WaveHi[x]+=t; //(t<<2)-(t<<1);
  }
 FBC=timestamp;
}

static void HQSync(int32 ts)
{
 FBC=ts;
}

void FDSSound(int c)
{
  RenderSound();
  FBC=c;
}

static void FDS_ESI(void)
{
 if(FSettings.SndRate)
 {
  if(FSettings.soundq>=1)
  {
   fdso.cycles=(int64)1<<39;
  }
  else
  {
   fdso.cycles=((int64)1<<40)*FDSClock;
   fdso.cycles/=FSettings.SndRate *16;
  }
 }
//  fdso.cycles=(int64)32768*FDSClock/(FSettings.SndRate *16);
 SetReadHandler(0x4040,0x407f,FDSWaveRead);
 SetWriteHandler(0x4040,0x407f,FDSWaveWrite);
 SetWriteHandler(0x4080,0x408A,FDSSWrite);
 SetReadHandler(0x4090,0x4092,FDSSRead);
}

void FDSSoundReset(void)
{
 memset(&fdso,0,sizeof(fdso));
 FDS_ESI();
 GameExpSound.HiSync=HQSync;
 GameExpSound.HiFill=RenderSoundHQ;
 GameExpSound.Fill=FDSSound;
 GameExpSound.RChange=FDS_ESI;
}

static DECLFW(FDSWrite)
{
// FCEU_printf("$%04x:$%02x, %d\n",A,V,scanline);
 switch(A)
 {
  case 0x4020:
	X6502_IRQEnd(FCEU_IQEXT);
	IRQLatch&=0xFF00;
	IRQLatch|=V;
	//printf("$%04x:$%02x\n",A,V);
        break;
  case 0x4021:
        X6502_IRQEnd(FCEU_IQEXT);
	IRQLatch&=0xFF;
	IRQLatch|=V<<8;
	//printf("$%04x:$%02x\n",A,V);
        break;
  case 0x4022:
	X6502_IRQEnd(FCEU_IQEXT);
	IRQCount=IRQLatch;
	IRQa=V&3;
	//printf("$%04x:$%02x\n",A,V);
        break;
  case 0x4023:break;
  case 0x4024:
        if(InDisk!=255 && !(FDSRegs[5]&0x4) && (FDSRegs[3]&0x1))
        {
         if(DiskPtr>=0 && DiskPtr<65000)
         {
          if(writeskip) writeskip--;
          else if(DiskPtr>=2)
          {
           diskdata[InDisk][DiskPtr-2]=V;
          }
         }
        }
        break;
  case 0x4025:
	X6502_IRQEnd(FCEU_IQEXT2);
	if(InDisk!=255)
	{
         if(!(V&0x40))
         {
          if(FDSRegs[5]&0x40 && !(V&0x10))
          {
           DiskSeekIRQ=200;
           DiskPtr-=2;
          }
          if(DiskPtr<0) DiskPtr=0;
         }
         if(!(V&0x4)) writeskip=2;
         if(V&2) {DiskPtr=0;DiskSeekIRQ=200;}
         if(V&0x40) DiskSeekIRQ=200;
	}
        setmirror(((V>>3)&1)^1);
        break;
 }
 FDSRegs[A&7]=V;
}

static void FreeFDSMemory(void)
{
 int x;

 for(x=0;x<header[4];x++)
  if(diskdata[x])
  {
   free(diskdata[x]);
   diskdata[x]=0;
  }
}

int FDSLoad(char *name, FCEUFILE *fp)
{
 FILE *zp;
 int x;

 FCEU_fseek(fp,0,SEEK_SET);
 FCEU_fread(header,16,1,fp);

 if(memcmp(header,"FDS\x1a",4)) 
 {
  if(!(memcmp(header+1,"*NINTENDO-HVC*",14)))
  {
   long t;   
   t=FCEU_fgetsize(fp);
   if(t<65500)
    t=65500;
   header[4]=t/65500;
   header[0]=0;
   FCEU_fseek(fp,0,SEEK_SET);
  }
  else
   return(0); 
 } 

 if(header[4]>4) header[4]=4;
 if(!header[4]) header[4]|=1;
 for(x=0;x<header[4];x++)
 {
  diskdata[x]=FCEU_malloc(65500);
  if(!diskdata[x]) 
  {
   int zol;
   for(zol=0;zol<x;zol++)
    free(diskdata[zol]);
   return 0;
  }
  FCEU_fread(diskdata[x],1,65500,fp);
 }

 if(!(zp=fopen(FCEU_MakeFName(FCEUMKF_FDSROM,0,0),"rb"))) 
 {
  FCEU_PrintError("FDS BIOS ROM image missing!");
  FreeFDSMemory();
  return 0;
 }

 if(fread(FDSBIOS,1,8192,zp)!=8192)
 {
  fclose(zp);
  FreeFDSMemory();
  FCEU_PrintError("Error reading FDS BIOS ROM image.");
  return 0;
 }

 fclose(zp);

 FCEUGameInfo.type=GIT_FDS;
 strcpy(FDSSaveName,name);
 GameInterface=FDSGI;

 SelectDisk=0;
 InDisk=255;

 ResetExState();
 FDSSoundStateAdd();

 for(x=0;x<header[4];x++)
 {
  char temp[5];
  sprintf(temp,"DDT%d",x);
  AddExState(diskdata[x],65500,0,temp);
 }

 AddExState(FDSRAM,32768,0,"FDSR");
 AddExState(FDSRegs,sizeof(FDSRegs),0,"FREG");
 AddExState(CHRRAM,8192,0,"CHRR");
 AddExState(&IRQCount, 4, 1, "IRQC");
 AddExState(&IRQLatch, 4, 1, "IQL1");
 AddExState(&IRQa, 1, 0, "IRQA");
 AddExState(&writeskip,1,0,"WSKI");
 AddExState(&DiskPtr,4,1,"DPTR");
 AddExState(&DiskSeekIRQ,4,1,"DSIR");
 AddExState(&SelectDisk,1,0,"SELD");
 AddExState(&InDisk,1,0,"INDI");
 ResetCartMapping();

 SetupCartCHRMapping(0,CHRRAM,8192,1);
 SetupCartMirroring(0,0,0);
 memset(CHRRAM,0,8192);
 memset(FDSRAM,0,32768);

 FCEU_printf(" Sides: %d\n Format: %s\n\n",header[4],header[0]?"fwNES":"iNES");
 return 1;
}

void FDSClose(void)
{
  FCEUFILE *fp;
  int x;

  fp=FCEU_fopen(FDSSaveName,"wb",0);
  if(!fp) return;

  if(header[0])			// Does it have a 16-byte FWNES-style header?
   if(FCEU_fwrite(header,1,16,fp)!=16) // Write it out.  Should be nicer than fseek()'ing if the file is compressed.  Hopefully...
    goto fdswerr;

  for(x=0;x<header[4];x++)
  {
   if(FCEU_fwrite(diskdata[x],1,65500,fp)!=65500) 
   {
    fdswerr:
    FCEU_PrintError("Error writing FDS image \"%s\"!",FDSSaveName);
    FCEU_fclose(fp);
    return;
   }
  }
  FreeFDSMemory();
  FCEU_fclose(fp);
}
