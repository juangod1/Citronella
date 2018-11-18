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
%type <str> statement expression

%start start

%%

start: statement
     | expression
     ;

statement: STRING_TYPE VARIABLE EQUALS CONSTANT_STRING { printf("Valid statement: Assigning %s to %s.",$4,$2); }
         | NUM_TYPE VARIABLE EQUALS CONSTANT_NUM { printf("Valid statement: Assigning %d to %s.",$4,$2); }
         | BOOL_TYPE VARIABLE EQUALS CONSTANT_BOOL { printf("Valid statement: Assigning %d to %s.",$4,$2); }
         | SHOW VARIABLE {printf("printing variable %s", $2);}
         ;

expression: VARIABLE ADD VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE SUBSTRACT VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE DIVIDE VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE MULTIPLY VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE LESSER VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE GREATER VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE LESSER_EQ VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE GREATER_EQ VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE AND VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE OR VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
          | VARIABLE NOT VARIABLE {printf("Expression: %s %s %s",$1,$2,$3);}
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
