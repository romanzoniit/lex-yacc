%option noyywrap 

%{
#include "Delete6.h"

#define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if (  result <= 0  ) \
      result = YY_NULL; \
    }

%}
Identifier  [_a-zA-Z][_a-zA-Z0-9]*
Number      0|([1-9][0-9]*)
delete      [Dd][Ee][Ll][Ee][Tt][Ee]
next        [Nn][Ee][Xx][Tt]
rest        [Rr][Ee][Ss][Tt]
nooptimize  [Nn][Oo][Oo][Pp][Tt][Ii][Mm][Ii][Zz][Ee]
record      [Rr][Ee][Cc][Oo][Rr][Dd]
for         [Ff][Oo][Rr]
while       [Ww][Hh][Ii][Ll][Ee]
in          [Ii][Nn]
all         [Aa][Ll][Ll]
and         [Aa][Nn][Dd]
or          [Oo][Rr]
not         [Nn][Oo][Tt]

%%
\xD;
{delete}   			{ BeginToken(yytext);  return(yDELETE);}
{next}     			{ BeginToken(yytext);  return(yNEXT);}
{rest}     			{ BeginToken(yytext);  return(yREST);}
{nooptimize}   	{ BeginToken(yytext);  return(yNOOPTIMIZE);}
{for}      			{ BeginToken(yytext);  return(yFOR);}
{record}   			{ BeginToken(yytext);  return(yRECORD);}
{while}    			{ BeginToken(yytext);  return(yWHILE);}
{in}       			{ BeginToken(yytext);  return(yIN);}
{all}      			{ BeginToken(yytext);  return(yALL);}
{and}      			{ BeginToken(yytext);  return(yAND);}
{or}       			{ BeginToken(yytext);  return(yOR);}
{not}      			{ BeginToken(yytext);  return(yNOT);}
\/       			  { BeginToken(yytext);  return(SIGNDIV);}
\+       			  { BeginToken(yytext);  return(SIGNPLUS);}
\-       			  { BeginToken(yytext);  return(SIGNMINUS);}
\*       			  { BeginToken(yytext);  return(SIGNMULT);}
\<       			  { BeginToken(yytext);  return(SIGNLESS);}
\>       			  { BeginToken(yytext);  return(SIGNMORE);}
\=       			  { BeginToken(yytext);  return(SIGNEQ);}
\(       			  { BeginToken(yytext);  return(SYMLP);}
\)       		  	{ BeginToken(yytext);  return(SYMRP);}
"<="     			  { BeginToken(yytext);  return(SIGNLEQ);}
">="     			  { BeginToken(yytext);  return(SIGNMEQ);}
"=="     			  { BeginToken(yytext);  return(SIGNEQQ);}
"!="|"<>"    		{ BeginToken(yytext);  return(SIGNNEQ);}

{Number}      	{
                 BeginToken(yytext); 
                 yylval.value = atoi(yytext);
                 return(NUMBER);
				}
{Identifier}  	{
                if(yyleng>30) PrintError("the name of variable is too long");
                else{
                yylval.string = malloc(strlen(yytext)+1);
                strcpy(yylval.string, yytext);
                BeginToken(yytext); 
                return (IDENTIFIER);
					}
				}

[ \r\t\n]+  	{ BeginToken(yytext);};
\;        		{ BeginToken(yytext); return(ySEMICOLON);}
.         		{ BeginToken(yytext); return(yytext[0]);};

%%
