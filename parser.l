%{
#include <stdlib.h>
#include "parser.tab.h"
%}
%option noyywrap

%%
[2][ ]*[+][ ]*[2]    { return EGG; }
^"leave me high"$ { return ACTV; }
^"quit"$      { return QUIT; }
^"help"$      { return HELP; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return MUL; }
"/"           { return DIV; }
"sin"         { return SIN; }
"cos"         { return COS; }
"tan"         { return TAN; }
"^"           { return EXP; }
"e"           { return EUL; }
"pi"          { return PIG; }
"log"         { return LOG; }
"ln"          { return LN; }
"lg"          { return LG; }
"sqrt"        { return SQRT; }
"cbrt"        { return CBRT; }
"root"        { return ROOT; }
"!"           { return FACT; }
"("           { return LPAR; }
")"           { return RPAR; }
"\n"          { return NEWLINE; }
[-]{0,1}[0-9]+[.]{0,1}[0-9]* { yylval.value = atof(yytext);
                return NUMBER; }
[ \t\r]+
<*>.          { return C_ERROR; } 
