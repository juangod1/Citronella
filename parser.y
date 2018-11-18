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
  int bool;
}

%token <str> ADD SUBSTRACT DIVIDE MULTIPLY LESSER GREATER LESSER_EQ GREATER_EQ AND OR NOT
%token <str> STRING_TYPE VARIABLE EQUALS CONSTANT_STRING SHOW
%token <num> NUM_TYPE CONSTANT_NUM
%token <bool> BOOL_TYPE CONSTANT_BOOL
%type <str> statement
%type <num> numeric_expression
%type <bool> boolean_expression

%start start

%%

start: statement
     | boolean_expression
     | numeric_expression
     ;

statement: STRING_TYPE VARIABLE EQUALS CONSTANT_STRING { printf("Valid statement: Assigning %s to %s.",$4,$2); }
         | NUM_TYPE VARIABLE EQUALS numeric_expression { printf("Valid statement: Assigning %d to %s.",$4,$2); }
         | BOOL_TYPE VARIABLE EQUALS boolean_expression { printf("Valid statement: Assigning %d to %s.",$4,$2); }
         | SHOW VARIABLE {printf("printing variable %s", $2);}
         | SHOW CONSTANT_STRING {printf("printing constant string %s", $2);}
         | SHOW boolean_expression {printf("printing expression %d", $2);}
         | SHOW numeric_expression {printf("printing expression %d", $2);}
         ;


boolean_expression: VARIABLE {$$ = atoi($1);}
          | CONSTANT_BOOL;
          | boolean_expression AND boolean_expression
          | boolean_expression OR boolean_expression
          | NOT boolean_expression {$$==0?1:0;}
          ;

numeric_expression: VARIABLE {$$ = atoi($1);}
          | CONSTANT_NUM;
          | numeric_expression ADD numeric_expression
          | numeric_expression SUBSTRACT numeric_expression
          | numeric_expression DIVIDE numeric_expression
          | numeric_expression MULTIPLY numeric_expression
          | numeric_expression LESSER numeric_expression
          | numeric_expression GREATER numeric_expression
          | numeric_expression LESSER_EQ numeric_expression
          | numeric_expression GREATER_EQ numeric_expression
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
