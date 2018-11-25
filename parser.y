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
%token <str> STRING_TYPE VARIABLE ASSIGN CONSTANT_STRING SHOW CONDITIONAL CONDITIONAL_ELSE LOOP LOOP_CONDITION
%token <str> NUM_TYPE CONSTANT_NUM
%token <str> BOOL_TYPE CONSTANT_BOOL
%type <str> statement chained_statements cond_else numeric_expression numeric boolean_expression boolean

%start start

%%

start: statement
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
         | LOOP chained_statements LOOP_CONDITION boolean_expression NEW_LINE {printf("loopy loop");}
         ;

chained_statements: statement
          | statement chained_statements
          ;

cond_else: CONDITIONAL_ELSE statement
    ;

boolean_expression: boolean {printf("%s",$1);}
          | boolean_expression AND boolean {printf("&&%s",$3);}
          | boolean_expression OR boolean {printf("||%s",$3);}
          | NOT boolean_expression {printf("!%s",$2);}
          | numeric_expression LESSER numeric {printf("<%s",$3);}
          | numeric_expression GREATER numeric {printf(">%s",$3);}
          | numeric_expression LESSER_EQ numeric {printf("<=%s",$3);}
          | numeric_expression GREATER_EQ numeric {printf(">=%s",$3);}
          | boolean_expression EQUALS boolean {printf("==%s",$3);}
          | numeric_expression EQUALS numeric {printf("==%s",$3);}
          ;

boolean: VARIABLE
          | CONSTANT_BOOL

numeric_expression: numeric {printf("%s",$1);}
          | numeric_expression ADD numeric {printf("+%s",$3);}
          | numeric_expression SUBSTRACT numeric {printf("-%s",$3);}
          | numeric_expression DIVIDE numeric {printf("/%s",$3);}
          | numeric_expression MULTIPLY numeric {printf("*%s",$3);}
          ;

numeric: VARIABLE
          | CONSTANT_NUM

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
