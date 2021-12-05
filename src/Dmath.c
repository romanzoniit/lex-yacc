#include "Delete6.h"

#define MAXVARS 4
static int nVars = 0;
static int N = 0;
static Variable** vars=NULL;
extern int setvalnull;



extern
int ReduceDiv(int a, int b, YYLTYPE *bloc) {
  if (  b == 0  ) {
     PrintError("division by zero! Line %d:c%d to %d:c%d",
                        bloc->first_line, bloc->first_column,
                        bloc->last_line, bloc->last_column);   
                        setvalnull = 1;    
    return INT_MAX;
  }
  return a / b;
}

static
Variable* findVar(char* varname) {
    int i, j;
    if (varname == NULL)
        return NULL;
    if (N == 1) {
        for (j = 0; j < nVars; j++) {
            if (strcmp(vars[0][j].name, varname) == 0)
                return (*(vars)+j);          
        }
    }
    else if (N == 0)  return NULL;
    
    else
    {
        for (i = 0; i < N; i++)
            for (j = 0; j < MAXVARS; j++) 
            {
                if (i * MAXVARS + j >= nVars + (N - 1) * MAXVARS)
                    return NULL;

                if (strcmp(vars[i][j].name, varname) == 0) 
                    return (*(vars + i) + j);
               
            }
    }
    return NULL;
} 

static
Variable* addVar(char* varname) {

    
    if (varname == NULL)
        return NULL;
    if ((nVars == MAXVARS)||(N == 0)) {
        nVars = 0;
        vars = (Variable**)realloc(vars, (N + 1) * sizeof(Variable*));
        vars[N] = (Variable*)malloc(MAXVARS * sizeof(Variable));
        N += 1;
    }
    vars[N-1][nVars].value = 0;
    vars[N-1][nVars].init = 0;
    vars[N-1][nVars].name = malloc(strlen(varname) + 1);
    

    if (vars[N-1][nVars].name == NULL) {
        PrintError("internal error creating variable '%s'", varname);
        return NULL;
    }

    strcpy(vars[N-1][nVars].name, varname);
    nVars += 1;
    return (*(vars +  (N - 1)) + (nVars - 1));
}

extern
Variable* VarGet(char* varname, YYLTYPE* bloc) {

    Variable* var;
   
    var = findVar(varname);    
    if (var == NULL)
        var = addVar(varname);

    return var;
}

extern
void VarSetValue(Variable* var, int value) {
   if ( var == NULL )
        return;
    if ( setvalnull == 1)
    {
        var->value = 0;   
        var->init = 0; 
        setvalnull = 0;
        return;
    }
    var->value = value;   
    var->init = 1;
    return;
}

extern
int VarGetValue(char* varname, YYLTYPE* bloc) {

    Variable* var = NULL;

    //find Variable
    var = findVar(varname);
    //if hasn`t Varialbe by "varname" do create new variable
    if (var == NULL) {
        PrintError("reference to unknown variable '%s'", varname);
        var = addVar(varname);
        setvalnull = 1;
        return 0;
    }
    if (var->init == 0){
        PrintError("variable not init %s", varname);
        setvalnull = 1;
        return 0;
    }
    return var->value;
} 

extern
void DumpVariables(char* prefix, int errorcount) {
    int i,j;
    int used = 0;
    printf("%s Name------------------ Value----------\n", prefix);
    for (i = 0; i < N-1; i++) {
        for (j = 0; j < MAXVARS; j++) {
            if (vars[i][j].init == 1)
            {
            printf("%d\t: %-20.20s: %d\n", i*MAXVARS+j+1,
                vars[i][j].name, vars[i][j].value);
                used++;
            }
            else 
            printf("%d\t: %-20.20s: %s\n", i*MAXVARS+j+1,
                vars[i][j].name, "NULL");
        }
    }
    for (i = N-1; i < N; i++) {
        for (j = 0; j < nVars; j++) {
            if (vars[i][j].init == 1)
            {
            printf("%d\t: %-20.20s: %d\n", i*MAXVARS+j+1,
                vars[i][j].name, vars[i][j].value);
                used++;
            }
            else 
            printf("%d\t: %-20.20s: %s\n", i*MAXVARS+j+1,
                vars[i][j].name, "NULL");
        }
    }
    printf("STATISTICS: \n");
    printf("COUNT OF VARIBLES ===== %d \n", (N-1)*MAXVARS+j + 1);
    printf("COUNT OF USED VAR ===== %d \n", used);
    printf("COUNT OF UNUSED VAR ===== %d \n", (N-1)*MAXVARS+j + 1 - used);
    printf("COUNT OF ERRORS ===== %d \n",errorcount);
    return;
}
