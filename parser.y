%{

#include <stdio.h>

int yylex(void);
int yyerror(const char *s);

%}

%token <string> STRING_TYPE
%token <string> INTEGER_TYPE
%token <string> BOOLEAN_TYPE
%token <cmd> END_LINE PRINT
%token <cmd> PARENTHESIS_OPEN PARENTHESIS_CLOSE
%token <cmd> MUL DIV MOD SUM SUB
%token <cmd> ASSIGN GREATER GREATER_EQU LOWER LOWER_EQU EQUALS NOT_EQUALS
%token <cmd> NOT AND OR
%token <cmd> IF THEN ELSE END_IF WHILE DO END_WHILE

%%

program:
         hi
        ;

hi:
        HI     { printf("Hello World\n");   }
        ;
