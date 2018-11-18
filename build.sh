bison -dy parser.y
flex grammar.l
cc -c lex.yy.c y.tab.c
cc -o Citronella lex.yy.o y.tab.o
