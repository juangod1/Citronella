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

statement: STRING_TYPE VARIABLE EQUALS expression { printf("Valid statement: Assigning %s to %s.",$4,$2); }
         | NUM_TYPE VARIABLE EQUALS expression { printf("Valid statement: Assigning %d to %s.",$4,$2); }
         | BOOL_TYPE VARIABLE EQUALS expression { printf("Valid statement: Assigning %d to %s.",$4,$2); }
         | SHOW VARIABLE {printf("printing variable %s", $2);}
         ;

expression: VARIABLE ;
          | CONSTANT_NUM;
          | CONSTANT_BOOL;
          | CONSTANT_STRING;
          | expression ADD expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression SUBSTRACT expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression DIVIDE expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression MULTIPLY expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression LESSER expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression GREATER expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression LESSER_EQ expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression GREATER_EQ expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression AND expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | expression OR expression {printf("Expression: %s %s (%s)\n",$1,$2,$3);strcat($$,$2);strcat($$,$3);}
          | NOT expression {printf("Expression: %s (%s)\n",$1,$2);}
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
