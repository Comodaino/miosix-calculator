%{

#include <stdio.h>
#include <math.h>
#include <string.h>
#include <main.h>

#define E 2.7182818284
#define PI 3.1415926535
#define OT 0.3333333333
double fact(const double);
int yylex(void);
void yyerror(const char *);
%}

%union {
  double value;
}

%start program

%token <value> NUMBER
%token NEWLINE PLUS MINUS
%token MUL DIV RPAR LPAR
%token SIN COS TAN EUL
%token EXP LOG LN LG 
%token ROOT SQRT CBRT
%token FACT
%type <value> exp

%left PLUS MINUS
%left MUL DIV
%left TAN SIN COS
%left EXP LOG LN LG 
%left ROOT SQRT CBRT
%left FACT

%%

program:
  lines NEWLINE
  {
  }
;

lines:
  lines line
  | %empty
  ;
        
line: 
  exp NEWLINE
  {
    if($1 != $1) yyerror("math");
    else print_lcdd($1);
  }
  | NEWLINE
  {

  }
;

exp:
  NUMBER
  {
    $$ = $1;
  }
  | exp PLUS exp
  {
    $$ = $1 + $3;
  }
  | exp MINUS exp
  {
    $$ = $1 - $3;
  }
  | exp MUL exp
  {
    $$ = $1 * $3;
  }
  | exp DIV exp
  {
    $$ = $1 / $3;
  }
  | LPAR exp RPAR
  {
    $$ = $2;
  }
  | SIN exp
  {
    $$ = sin($2);
  }
  | COS exp
  {
    $$ = cos($2);
  }
  | TAN exp
  {
    $$ = tan($2);
  }
  | exp EXP exp
  {
    $$ = pow($1, $3);
  }
  | EUL EXP exp
  {
    $$ = exp($3);
  }
  | SQRT exp
  {
    $$ = pow($2, 0.5);
  }
  | CBRT exp
  {
    $$ = pow($2, OT);
  }
  | exp ROOT exp
  {
    if($1 == 0) $$ = NAN;
    else $$ = pow($3, 1.0/$1);
  }
  | LOG exp
  {
    $$ = log10($2);
  }
  | LN exp
  {
    $$ = log($2);
  }
  | LG exp
  {
    $$ = log($2) / log(2);
  }
  | FACT exp
  {
    $$ = fact($2);
  }
;
  

%%

double fact(const double z) {
  return sqrt(2 * PI / z) * pow((1 / E) * (z + 1 / (12 * z - 1 / (10 * z))), z);
}

void yyerror(const char *msg)
{
  if(!strcmp(msg, "math")) print_lcds("Math Error");
  else print_lcds("Syntax Error");
}

/*
int main(int argc, char *argv[])
{
  main_fun();
  return 0;
}
*/
