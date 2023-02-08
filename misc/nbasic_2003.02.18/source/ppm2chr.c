#include <stdio.h>
#include <stdlib.h>

int colorshift=0;

struct rgb
{
   unsigned char r;
   unsigned char g;
   unsigned char b;
};

void error(const char *s)
{
   printf("%s\n",s);
   exit(0);
}

char getachar(FILE *f)
{
   return getc(f);
}

unsigned char getuchar(FILE *f)
{
   return getc(f);
}

int match(struct rgb a, struct rgb b)
{
   return (a.r==b.r && a.g==b.g && a.b==b.b);
}

char *readstring(FILE *f)
{
   char *s=(char*)malloc(20);
   char c;
   int i=0;
   c=getachar(f);
   while ( ('a'<=c && c<='z') ||
           ('A'<=c && c<='Z') ||
           ('0'<=c && c<='9') )
   {
      s[i]=c;
      i++;
      c=getachar(f);
   }
   s[i]=0;
   return s;
}

unsigned char* makesprite(FILE *f, int w, int h)
{
	struct rgb palette[16];
	struct rgb raw[w][h];
	unsigned char *spt=(unsigned char*)malloc(w*h);
	int i,j,x,y;
	int maxpal=0;
	
	printf("making sprite\n");
	for(y=0;y<h;y++)
	{
		for(x=0;x<w;x++)
		{
			raw[x][y].r=getuchar(f);
			raw[x][y].g=getuchar(f);
			raw[x][y].b=getuchar(f);
			i=0;
			while( (!match(raw[x][y],palette[i])) && i<maxpal)
				i++;
			if(i==maxpal)
			{
				maxpal++;
				palette[i]=raw[x][y];
			}
			if(colorshift) i=(i+colorshift)%4;
			printf("%d",i);
			spt[y*w+x]=i;
			printf("%d",i);
		}
	printf("\n");
	}
	printf("Sprite contains %d colors\n",maxpal);
	return spt;
}

void writechr(const char *filename, unsigned char *spt, int w, int h)
{
	FILE *f=fopen(filename,"w");
	int i,j,x,y;
	unsigned char c;
	
	if(f<=0) error("Error opening file for output");
	for(j=0;j<h;j+=8)
	for(i=0;i<w;i+=8)
	{
	//low bit
		for(y=j;y<j+8;y++)
		{
			c=0;
			for(x=i;x<i+8;x++)
			{
		//		printf("%d",spt[y*w+x]);
				c*=2;
				c+=(spt[y*w+x]&1);
			}
			putc(c,f);
		//	printf("\n");
		}
	//high bit
		for(y=j;y<j+8;y++)
		{
			c=0;
			for(x=i;x<i+8;x++)
			{
				c*=2;
				c+=((spt[y*w+x]>>1)&1);
			}
			putc(c,f);
		}
	
	
	
	}

	fclose(f);
}

int main(int argn, char** argv)
{
   char *infile;
   char *outfile;
   char *s;
   FILE *f;
   int width, height, maxcol;
   unsigned char *sprite;

   if(argn!=3 && argn!=4)
      error("Usage: ppm2chr [input.ppm] [output.chr]\nOptional Flag: [anything] (shift colors up one)\n");
   if (argn==4)
   {
      colorshift=atoi(argv[3]);
      printf("colorshift mode\n");
   }
   infile=argv[1];
   outfile=argv[2];
   f=fopen(infile, "r");
   if (f<0) error("error opening input file");
   s=readstring(f);
   if(strcmp(s,"P6")!=0) error("not type P6 ppm file");
   s=readstring(f);
   width=atoi(s);
   s=readstring(f);
   height=atoi(s);
   s=readstring(f);
   maxcol=atoi(s);
   if (maxcol!=255) error("ppm color depth must be 255 per element");
   printf("Sprite size is %dx%d\n",width,height);
   sprite=makesprite(f,width,height);
   fclose(f);
   writechr(outfile,sprite,width,height);
}
