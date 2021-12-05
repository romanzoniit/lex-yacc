%{
#include "Delete6.h"

static Variable *var;
void HandleError(char*s);
int setvalnull = 0;
int count = 0;

%}


%union {
  int   value;
  char  *string;
}

%token <string>   IDENTIFIER
%token <value>    NUMBER
%type <value>     expr 
%token yIN yFOR yALL yNEXT yREST yRECORD yWHILE yDELETE yNOOPTIMIZE SYMLP SYMRP yAND yNOT yOR ySEMICOLON SIGNEQ 
    /*  in  for  all  next  rest  record  while  delete  nooptimize   (     )    and  not  or       ;       =  */

%left yAND

%left yOR

%left yNOT

%left SIGNEQQ SIGNNEQ
    /*  ==     != <>                                    */ 
%left SIGNLESS SIGNMORE SIGNLEQ SIGNMEQ
    /*   <        >       <=      >=                    */
%left SIGNPLUS SIGNMINUS
    /*   +         -                                    */
%left SIGNMULT SIGNDIV
    /*   *       /                                      */
%left SIGNPOW
    /*   ^                                              */

%start program


%%
program: 
         stat ySEMICOLON {count = 0; setvalnull = 0; } |
         program stat ySEMICOLON {count = 0; setvalnull = 0; };

stat   : error {HandleError("wrong syntax");}
       | yDELETE scope forexpr whileexpr inn nooptim 
       | IDENTIFIER { var = VarGet($1, &@1);} SIGNEQ expr { if ($4 == -1) setvalnull=1; VarSetValue(var, $4);} 
       | IDENTIFIER error{HandleError("wrong identifier");};

scope  :              
       | yALL         
       | yREST        
       | yNEXT expr   
       | yRECORD expr ;

forexpr       :                
              | yFOR expr;
  
whileexpr     :    
              | yWHILE expr;

inn           :                    
              | yIN expr;

nooptim       :
              |yNOOPTIMIZE;     
   
expr   : SYMLP expr SYMRP      { $$ = $2; }     
       | SIGNMINUS expr        { $$ = -$2; }
       | expr SIGNPLUS expr    { $$ = $1 + $3;  }
       | expr SIGNMINUS expr   { $$ = $1 - $3;  } 
       | expr SIGNMULT expr    { $$ = $1 * $3;  } 
       | expr SIGNDIV  expr    { $$=ReduceDiv($1, $3, &@3);  } 
       | NUMBER                { $$=$1; } 
       | NUMBER error          { HandleError("wrong number"); $$=-1;}
       | error                 { HandleError("wrong arifmetic expression"); $$=-1;}
       | IDENTIFIER error      { HandleError("wrong identifier"); $$=-1; setvalnull = 0;}
       | IDENTIFIER            { $$ = VarGetValue($1, &@1); };
       | expr SIGNEQQ expr     {   $$=$1==$3; }
       | expr SIGNNEQ expr     {   $$=$1!=$3; }
       | expr SIGNLESS expr    {   $$=$1<$3 ; }
       | expr SIGNMORE expr    {   $$=$1>$3 ; }
       | expr SIGNLEQ expr     {   $$=$1<=$3; }
       | expr SIGNMEQ expr     {   $$=$1>=$3; }
       | expr yAND expr        {   $$=$1&&$3; }
       | expr yOR expr         {   $$=$1||$3; }
       | yNOT expr             {   $$=!$2   ; }
       ;    

%%
void HandleError(char*s)
{
if(count==0)
{PrintError(s);}
count++;
}
/*
static int
yyreport_syntax_error (const yypcontext_t *ctx)
{
  int res = 0;
  return res;
}
*/
extern 
void yyerror(char *s)
{
    PrintError(s);
}
