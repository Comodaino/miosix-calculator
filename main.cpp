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

#define BUFF_L 20
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

int lcd_buffer[BUFF_L];
int i;

void print_lcdd(const double x){
  /*
  for(i = 0; i < BUFF_L; i++){
    lcd_buffer[i] = 0;
  }
  double tmp =0.0;
  int r =0;

  tmp = x;
  while(tmp > 1){
    r = tmp % 10;
    tmp = tmp / 10;
    for(i=1; i<BUFF_L; i++){
      lcd_buffer[i] = lcd_buffer[i-1];
    }
    lcd_buffer[0] = r;
  }
  */
  display.clear();
  display.go(0,0);
  /*
  for(i = BUFF_L; i>= 0; i++){
    display.printf("%d",lcd_buffer[i]);
    display.go(i,0);
  }*/
  //display.go(0,1);
  display.printf("%lf", x);
}

void print_lcds(const char * x){
  display.clear();
  display.go(0,0);
  display.printf("%s", x);
}

int main()
{
  close_parser = false;
  egg = false;
  display.clear();
  display.go(0,0);
  display.printf("Nyaaa :3");
  while(!close_parser){
    yyparse();
    fflush(stdin);
    fflush(stdout);
  }
  return 0;
}
