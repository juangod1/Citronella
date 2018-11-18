%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *errormsg);
extern char yytext[];

%}

%union {
  char * str;
  int num;
}

%token <str> STRING_TYPE VARIABLE EQUALS CONSTANT_STRING
%token <num> NUM_TYPE CONSTANT_NUM
%type <str> statement

%%

statement: STRING_TYPE VARIABLE EQUALS CONSTANT_STRING { printf("Valid statement: Assigning %s to %s.",$4,$2); }
         | NUM_TYPE VARIABLE EQUALS CONSTANT_NUM { printf("Valid statement: Assigning %d to %s.",$4,$2); }
         ;

%%

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
