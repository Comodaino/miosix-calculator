LEX_SRC = parser.l
YACC_SRC = parser.y
C_SRC = lex.yy.c $(patsubst %.y, %.tab.c, $(YACC_SRC))
EXEC_NAME = parser

all: $(EXEC_NAME)

$(EXEC_NAME): $(C_SRC)
	cc -Wall -Wextra -pedantic -o $@ $^ -lm

%.tab.c: %.y
	bison -d -Wconflicts-sr $<

%.tab.h: %.tab.c

lex.yy.c: $(LEX_SRC)
	flex $<

clean:
	rm -rf *.c *.o *.h $(EXEC_NAME)
