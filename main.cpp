#include <cstdio>
#include <miosix.h>
#include <string>
#include <iostream>
#include <util/lcd44780.h>
#include <parser.tab.c>
#include <parser.tab.h>
#include <lex.yy.c>
#include <main.h>
using namespace miosix;
using namespace std;

typedef Gpio<GPIOD_BASE,11> d4;
typedef Gpio<GPIOD_BASE,12> d5;
typedef Gpio<GPIOD_BASE,13> d6;
typedef Gpio<GPIOD_BASE,14> d7;
typedef Gpio<GPIOC_BASE,1> rs;
typedef Gpio<GPIOC_BASE,3> e;
typedef Gpio<GPIOA_BASE,1> rxd;
typedef Gpio<GPIOA_BASE,3> txd;

Lcd44780 display(rs::getPin(),e::getPin(),d4::getPin(),
                  d5::getPin(),d6::getPin(),d7::getPin(),2,16);

void print_lcdd(const double x){
  display.clear();
  display.go(0,0);
  display.printf("%lf", x);
}

void print_lcds(const char * x){
  display.clear();
  display.go(0,0);
  display.printf("%s", x);
}

int main()
{
  display.clear();
  display.go(0,0);
  display.printf("Nyaaa :3");
  yyparse();
  return 0;
}
