#include <cmath>
#include <cstdio>
#include <miosix.h>
#include <string.h>
#include <iostream>
#include <sys/types.h>
#include <util/lcd44780.h>
#include <parser.tab.c>
#include <parser.tab.h>
#include <lex.yy.c>
#include <main.h>
using namespace miosix;
using namespace std;

#define BUFF_L 16
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

char lcd_buffer[BUFF_L], lcd_inv[BUFF_L];
int i;


void print_smalld(const double x){
  int buff = BUFF_L;
  long long int tmpl = 0;
  double tmpdouble = 0.0;
  long long int tmp = 0;
  int l = 0;
  int ld = 0;
  int index = 0;

  if(x<0) {
    buff = buff--;
    tmp = -1*x;
  }else tmp = x;

  for(i = 0; i <= BUFF_L; i++){
    lcd_buffer[i] = ' ';
  }
  if(tmp != 0)  l = ceil( log10(tmp) );
  else l = 1;

  if(l < buff){
    if(x<0) tmpdouble = -1*x - floor(-1*x);
    else tmpdouble = x - floor(x);
    if (tmpdouble > 0.0){
      ld = buff - (l + 1);
      if(ld > 0){
        tmpdouble = tmpdouble * pow(10,ld);
      }
    }
  }

  tmpl = (long long int)tmpdouble;
  for(i=0; i<ld && tmpl%10 == 0; i++){
    tmpl = tmpl/10;
  }
  ld = ld - (i-1);
  if(ceil(x) == floor(x)) ld =0;
  printf("l: %d\nld: %d\ntmp: %d\ntmpl: %ld \ntmpdouble: %lf\n\n", l, ld, tmp, tmpl, tmpdouble);
  for(i=0;i<ld;i++){
    lcd_buffer[i] = (tmpl % 10) + '0';
    tmpl = tmpl/10;
    index = i;
  }
  if(ld != 0){
	  lcd_buffer[index] = '.';
  	index++;
  }
  for(i=index; i<BUFF_L;i++){
    lcd_buffer[i] = (tmp % 10) + '0';
    tmp = tmp/10;
    index = i;
  }
  
  for(i=0; i<ld+l; i++){
    lcd_inv[i]=lcd_buffer[ld+l -i -1];
  }

  printf("------\n");
  for(int i=0; i<l+ld; i++){
    printf("%c",lcd_buffer[i]);
  }
  printf("\n");
  for(int i=0; i<=l+ld; i++){
    printf("%c",lcd_inv[i]);
  }
  printf("\n----\n");

  display.clear();
  for(i = 0; i<=l+ld; i++){
    display.go(BUFF_L + i - (l+ld),0);
    display.printf("%c",lcd_inv[i]);
  }
  if(x<0){
    display.go(BUFF_L - (l+ld+1), 0);
    printf("negative");
    display.printf("%c", '-');
  }
  //display.clear();
  //display.go(0,0);
  //display.printf("%s", strrev(lcd_buffer));

  //display.go(0,2);
  //display.printf("%lf", x);
}

void print_lcds(const char * x){
  display.clear();
  display.go(0,0);
  display.printf("%s", x);
}

void print_lcdd(const double x){
  print_smalld(x);
}

int main()
{
  close_parser = false;
  egg = false;
  display.clear();
  display.go(0,0);
  display.printf("Scemo chi legge");
  while(!close_parser){
    yyparse();
    fflush(stdin);
    fflush(stdout);
  }
  return 0;
}
