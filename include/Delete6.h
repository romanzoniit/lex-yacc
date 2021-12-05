#ifndef DELETE6_H_
#define DELETE6_H_

#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include <string.h>
#include <memory.h>
#include <stdlib.h>
#include <stdarg.h>
#include <malloc.h>
#include <limits.h>
#include "y.tab.h"


extern int debug;

extern int yylex(void);
extern int yyparse(void);
extern void yyerror(char*);

extern void DumpRow(void); 
extern int GetNextChar(char *b, int maxBuffer);
extern void BeginToken(char*);
extern void PrintError(char *s, ...);

typedef struct _Variable {
  char* name;
  int   value;
  int   init;
} Variable;


extern int ReduceDiv(int, int, YYLTYPE*);

extern Variable *VarGet(char*, YYLTYPE*);
extern void VarSetValue(Variable*, int);
extern int VarGetValue(char*, YYLTYPE*);
extern void DumpVariables(char *prefix, int errorcount);


#endif /*CCALC_H_*/
