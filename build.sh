bison -dy parser.y
flex grammar.l
gcc -lfl lex.yy.c y.tab.c -o ./Citronella
