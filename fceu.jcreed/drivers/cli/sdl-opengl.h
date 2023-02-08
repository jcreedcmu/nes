#define JCREED_SSIZE  240
#define JCREED_SIZE   256
#define JCREED_SIZE2  512

void SetOpenGLPalette(uint8 *data);
void BlitOpenGL(uint8 *buf);
void KillOpenGL(void);
int InitOpenGL(int l, int r, int t, int b, double xscale,double yscale, int efx,
                int stretchx, int stretchy, SDL_Surface *screen);

