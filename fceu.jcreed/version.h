#define VERSION_NUMERIC 97
#define VERSION_STRING "0.97.5"

#if PSS_STYLE==2

#define PSS "\\"
#define PS '\\'

#elif PSS_STYLE==1

#define PSS "/"
#define PS '/'

#elif PSS_STYLE==3

#define PSS "\\"
#define PS '\\'

#elif PSS_STYLE==4

#define PSS ":"
#define PS ':'

#endif

#ifdef NOSTDOUT
#define puts(x) 
#define printf(x,...)
#endif
