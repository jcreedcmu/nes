typedef struct {
        void *fp;       // FILE* or ptr to ZIPWRAP
        uint32 type;    // 0=normal file, 1=gzip, 2=zip
} FCEUFILE;

FCEUFILE *FCEU_fopen(char *path, char *mode, char *ext);
int FCEU_fclose(FCEUFILE*);
uint64 FCEU_fread(void *ptr, size_t size, size_t nmemb, FCEUFILE*);
uint64 FCEU_fwrite(void *ptr, size_t size, size_t nmemb, FCEUFILE*);
int FCEU_fseek(FCEUFILE*, long offset, int whence);
uint64 FCEU_ftell(FCEUFILE*);
void FCEU_rewind(FCEUFILE*);
int FCEU_read32(void *Bufo, FCEUFILE*);
int FCEU_read16(uint16 *Bufo, FCEUFILE*);
int FCEU_fgetc(FCEUFILE*);
uint64 FCEU_fgetsize(FCEUFILE*);
int FCEU_fisarchive(FCEUFILE*);

