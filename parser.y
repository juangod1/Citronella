%{

#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(char *errormsg);

%}

%token HI STRING_TYPE

%%

program:
         hi string_type
        ;

hi:
        HI     { printf("Hello World\n");   }
        ;

string_type:
        STRING_TYPE { printf("string"); }
        ;

%%

extern FILE *yyin;

int main(void)
{
   yyparse();
   return 0;
}

int yywrap(void)
{
   return 0;
}

// Error function from
// https://stackoverflow.com/questions/5456011/how-to-compile-lex-yacc-files-on-windows/5545924#5545924
int yyerror(char *errormsg)
{
    fprintf(stderr, "%s\n", errormsg);
    exit(1);
}
