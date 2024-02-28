%{

#include <stdio.h>
#define _USE_MATH_DEFINES
#include <math.h>
#include <string.h>
#include <main.h>
#include <stdbool.h>

#define OT 0.3333333333
double fact(const double);
int yylex(void);
void yyerror(const char *);
bool egg, close_parser;
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
%token FACT EGG PIG 
%type <value> exp

%left PLUS MINUS
%left MUL DIV 
%left TAN SIN COS
%left EXP LOG LN LG 
%left ROOT SQRT CBRT
%left FACT EGG ACTV 
%left C_ERROR QUIT HELP

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

c_errors:
  c_errors C_ERROR 
  | exp c_errors 
  | c_errors exp
  | C_ERROR
  ;
        
line: 
  exp NEWLINE
  {
    if($1 != $1) yyerror("math");
    else {
      print_lcdd($1);
      printf("result: %lf\n",$1);
    }
  }
  | ACTV NEWLINE
  {
    if(egg) egg = false;
    else egg = true;
    yyerror("egg");
  }
  | c_errors NEWLINE
  {
    yyerror(" ");
    fflush(stdin);
    return 0; 
  }
  | QUIT NEWLINE
  {
    close_parser = true;
    return 0;
  }
  | HELP NEWLINE
  {
    printf("Welcome to a miosix calculator\n");
    printf("To start just type anything you want to calcultae\n");
    printf("The result will be shown on the LCD display\n\n");
    printf("Avaiable operations are:\n");
    printf("x + y\n");
    printf("x - y\n");
    printf("x * y\n");
    printf("x / y\n");
    printf("sin x\n");
    printf("cos x\n");
    printf("tan x\n");
    printf("x^2\n");
    printf("x^3\n");
    printf("y^x      -- y at the power of x\n");
    printf("10^x     -- 10 at the power of x\n");
    printf("e^x      -- e at the power of x\n");
    printf("sqrt x   -- square root of x\n");
    printf("cbrt x   -- cube root of x\n");
    printf("y root x -- y-th root of x\n");
    printf("log(x)   -- logarithm base 10\n");
    printf("ln(x)    -- logarithm base e\n");
    printf("lg(x)    -- logarithm base 2\n");
    printf("x!       -- factorial\n");
    printf("\n\n");
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
  | EGG
  {
    if(egg) $$ = 5;
    else $$ = 4;
  }
  | PIG
  {
    $$ = M_PI;
  }
  | EUL
  {
    $$ = M_E;
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
    fflush(stdin);
    fflush(stdout);
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
  | exp FACT
  {
    $$ = fact($1);
  }
;
  

%%

double fact(const double z) {
  if(ceil(z) != floor(z)) return tgamma(z+1);
  double tmp = z, acc = 1;
  while(tmp!=1){
    acc = acc*tmp;
    tmp--;
  }
  return acc;
}

void yyerror(const char *msg)
{
  if(!strcmp(msg, "math")){
    print_lcds("Math Error\n");
    printf("Math Error\n");
  }else if(!strcmp(msg, "egg")) printf("don't leave me dry\n");
  else {
    print_lcds("Syntax Error\n");
    printf("Syntax Error\n");
  }
}
/*
int main()
{
  egg = false;
  close = false;
  while(!close){
    yyparse();
    fflush(stdin);
    fflush(stdout);
  }
  return 0;
}
*/
