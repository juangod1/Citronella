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
%token <str> STRING_TYPE VARIABLE EQUALS CONSTANT_STRING SHOW CONDITIONAL CONDITIONAL_ELSE
%token <str> NUM_TYPE CONSTANT_NUM
%token <str> BOOL_TYPE CONSTANT_BOOL
%type <str> statement chained_statements cond_else numeric_expression boolean_expression

%start start

%%

start: statement
     | boolean_expression
     | numeric_expression
     ;

statement: STRING_TYPE VARIABLE EQUALS CONSTANT_STRING {printf("String %s = %s;\n",$2,$4);}
         | boolean_expression CONDITIONAL chained_statements cond_else
         | NUM_TYPE VARIABLE EQUALS numeric_expression {printf("int %s = %s;\n",$2,$4);}
         | BOOL_TYPE VARIABLE EQUALS boolean_expression {printf("boolean %s = %s;\n",$2,$4);}
         | SHOW VARIABLE {printf("System.out.println(%s)",$2);}
         | SHOW CONSTANT_STRING {printf("System.out.println(%s)",$2);}
         | SHOW boolean_expression {printf("System.out.println(%s)",$2);}
         | SHOW numeric_expression {printf("System.out.println(%s)",$2);}
         ;

chained_statements: statement
          | statement chained_statements
          ;

cond_else: CONDITIONAL_ELSE statement
    ;

boolean_expression: VARIABLE
          | CONSTANT_BOOL
          | boolean_expression AND boolean_expression {printf("%s&&%s",$1,$3);}
          | boolean_expression OR boolean_expression {printf("%s||%s",$1,$3);}
          | NOT boolean_expression {printf("!%s",$2);}
          | numeric_expression LESSER numeric_expression {printf("%s<%s",$1,$3);}
          | numeric_expression GREATER numeric_expression {printf("%s>%s",$1,$3);}
          | numeric_expression LESSER_EQ numeric_expression {printf("%s<=%s",$1,$3);}
          | numeric_expression GREATER_EQ numeric_expression {printf("%s>=%s",$1,$3);}
          ;

numeric_expression: VARIABLE
          | CONSTANT_NUM
          | numeric_expression ADD numeric_expression {printf("%s+%s",$1,$3);}
          | numeric_expression SUBSTRACT numeric_expression {printf("%s-%s",$1,$3);}
          | numeric_expression DIVIDE numeric_expression {printf("%s/%s",$1,$3);}
          | numeric_expression MULTIPLY numeric_expression {printf("%s*%s",$1,$3);}
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
