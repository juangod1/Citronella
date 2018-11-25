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

%token <str> NEW_LINE
%token <str> ADD SUBSTRACT DIVIDE MULTIPLY LESSER GREATER LESSER_EQ GREATER_EQ EQUALS AND OR NOT
%token <str> STRING_TYPE VARIABLE ASSIGN CONSTANT_STRING SHOW CONDITIONAL CONDITIONAL_ELSE LOOP LOOP_CONDITION PARENTHESIS_OPENED PARENTHESIS_CLOSED
%token <str> NUM_TYPE CONSTANT_NUM
%token <str> BOOL_TYPE CONSTANT_BOOL
%type <str> statement chained_statements cond_else numeric_expression boolean_expression

%start start

%%

start: chained_statements
     | boolean_expression
     | numeric_expression

     ;

statement: STRING_TYPE VARIABLE ASSIGN CONSTANT_STRING NEW_LINE {printf("String %s = %s;\n",$2,$4);}
         | boolean_expression CONDITIONAL chained_statements cond_else NEW_LINE {printf("elseif");}
         | NUM_TYPE VARIABLE ASSIGN numeric_expression NEW_LINE {printf("int %s = %s;\n",$2,$4);}
         | BOOL_TYPE VARIABLE ASSIGN boolean_expression NEW_LINE {printf("boolean %s = %s;\n",$2,$4);}
         | SHOW VARIABLE NEW_LINE {printf("System.out.println(%s)",$2);}
         | SHOW CONSTANT_STRING NEW_LINE {printf("System.out.println(%s)",$2);}
         | SHOW boolean_expression NEW_LINE {printf("System.out.println(%s)",$2);}
         | SHOW numeric_expression NEW_LINE {printf("System.out.println(%s)",$2);}
         | LOOP chained_statements LOOP_CONDITION boolean_expression NEW_LINE {printf("do{%s}while(%s);",$2,$4);}
         ;

chained_statements: statement
          | chained_statements statement
          ;

cond_else: CONDITIONAL_ELSE statement
    ;

boolean_expression: VARIABLE
          | CONSTANT_BOOL
          | PARENTHESIS_OPENED boolean_expression PARENTHESIS_CLOSED {strcat($$,"(");strcat($$,$2);strcat($$,")");}
          | boolean_expression AND boolean_expression {strcat($$,"&&");strcat($$,$3);}
          | boolean_expression OR boolean_expression {strcat($$,"||");strcat($$,$3);}
          | NOT boolean_expression {strcat($$,"!");strcat($$,$2);}
          | numeric_expression LESSER numeric_expression {strcat($$,"<");strcat($$,$3);}
          | numeric_expression GREATER numeric_expression {strcat($$,">");strcat($$,$3);}
          | numeric_expression LESSER_EQ numeric_expression {strcat($$,"<=");strcat($$,$3);}
          | numeric_expression GREATER_EQ numeric_expression {strcat($$,">=");strcat($$,$3);}
          | boolean_expression EQUALS boolean_expression {strcat($$,"==");strcat($$,$3);}
          | numeric_expression EQUALS numeric_expression {strcat($$,"==");strcat($$,$3);}
          ;


numeric_expression: VARIABLE
          | CONSTANT_NUM
          | numeric_expression ADD numeric_expression {strcat($$,"+");strcat($$,$3);}
          | numeric_expression SUBSTRACT numeric_expression {strcat($$,"-");strcat($$,$3);}
          | numeric_expression DIVIDE numeric_expression {strcat($$,"/");strcat($$,$3);}
          | numeric_expression MULTIPLY numeric_expression {strcat($$,"*");strcat($$,$3);}
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
