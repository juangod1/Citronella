bison -dy parser.y
flex grammar.l
gcc lex.yy.c y.tab.c -o Citronella
