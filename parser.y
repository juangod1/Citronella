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
%token <str> STRING_TYPE VARIABLE ASSIGN CONSTANT_STRING SHOW CONDITIONAL CONDITIONAL_ELSE LOOP LOOP_CONDITION PARENTHESIS_OPENED PARENTHESIS_CLOSED READ
%token <str> NUM_TYPE CONSTANT_NUM
%token <str> BOOL_TYPE CONSTANT_BOOL
%type <str> statement chained_statements numeric_expression boolean_expression

%start start

%%

start: chained_statements {printf("%s",$1);free($1);}
     | boolean_expression NEW_LINE {printf("%s;\n",$1);free($1);}
     | numeric_expression NEW_LINE {printf("%s;\n",$1);free($1);}
     ;

statement: STRING_TYPE VARIABLE ASSIGN CONSTANT_STRING NEW_LINE
         {$$=calloc(1,13+strlen($2)+strlen($4));strcat($$,"char * ");strcat($$,$2);strcat($$," = ");strcat($$,$4);strcat($$,";\n");} /*TODO: Chequear hashmap que NO exista y crear la entry con text*/
         | boolean_expression CONDITIONAL chained_statements CONDITIONAL_ELSE chained_statements
         {$$=calloc(1,27+strlen($1)+strlen($3)+strlen($5));strcat($$,"if (");strcat($$,$1);strcat($$,") {\n\t");strcat($$,$3);strcat($$,"} else {\n\t");strcat($$,$5);strcat($$,"}\n");}
         | NUM_TYPE VARIABLE ASSIGN numeric_expression NEW_LINE
         {$$=calloc(1,14+strlen($2)+strlen($4));strcat($$,"int ");strcat($$,$2);strcat($$," = ");strcat($$,$4);strcat($$,";\n");} /*TODO: Chequear hashmap que NO exista y crear la entry con num*/
         | BOOL_TYPE VARIABLE ASSIGN boolean_expression NEW_LINE
         {$$=calloc(1,14+strlen($2)+strlen($4));strcat($$,"int ");strcat($$,$2);strcat($$," = ");strcat($$,(strcmp($4,"true"))?"0":"1");strcat($$,";\n");} /*TODO: Chequear hashmap que NO exista y crear la entry con bool*/
         | VARIABLE ASSIGN CONSTANT_STRING NEW_LINE
         {$$=calloc(1,13+strlen($1)+strlen($3));strcat($$,$1);strcat($$," = ");strcat($$,$3);strcat($$,";\n");} /*TODO: Chequear hashmap si es text y si existe*/
         | VARIABLE ASSIGN numeric_expression NEW_LINE
         {$$=calloc(1,14+strlen($1)+strlen($3));strcat($$,$1);strcat($$," = ");strcat($$,$3);strcat($$,";\n");} /*TODO: Chequear hashmap si es num y si existe*/
         | VARIABLE ASSIGN boolean_expression NEW_LINE
         {$$=calloc(1,14+strlen($1)+strlen($3));strcat($$,$1);strcat($$," = ");strcat($$,$3);strcat($$,";\n");} /*TODO: Chequear hashmap si es bool y si existe*/
         | SHOW VARIABLE NEW_LINE
         {$$=calloc(1,23+strlen($2));strcat($$,"printf(\"%d\\n\",");strcat($$,$2);strcat($$,");\n");} /*TODO: DEPENDE DEL HASHMAP IMPRIME DISTINTO (%d o %s)*/
         | SHOW CONSTANT_STRING NEW_LINE
         {$$=calloc(1,23+strlen($2));strcat($$,"printf(\"%s\\n\",");strcat($$,$2);strcat($$,");\n");}
         | SHOW boolean_expression NEW_LINE
         {$$=calloc(1,23+strlen($2));strcat($$,"printf(\"%d\\n\",");strcat($$,$2);strcat($$,");\n");}
         | SHOW numeric_expression NEW_LINE
         {$$=calloc(1,23+strlen($2));strcat($$,"printf(\"%d\\n\",");strcat($$,$2);strcat($$,");\n");}
         | LOOP chained_statements LOOP_CONDITION boolean_expression NEW_LINE
         {$$=calloc(1,20+strlen($2)+strlen($4));strcat($$,"do {\n\t");strcat($$,$2);strcat($$,"} while (");strcat($$,$4);strcat($$,");\n");}
         | READ NEW_LINE { $$=calloc(1,50);strcat($$,"char read[100]; scanf(\"%s\",read);printf(\"%s\\n\",read);\n");} /* TODO: chequear que la variable exista y sea de tipo string */
         ;

chained_statements: statement
          | statement chained_statements {strcat($$,$2);}
          ;

boolean_expression: VARIABLE { $$ = $1; } /*TODO: Chequear hashmap si es bool y si existe*/
          | CONSTANT_BOOL
          | PARENTHESIS_OPENED boolean_expression PARENTHESIS_CLOSED {$$=calloc(1,3+strlen($2));strcat($$,"(");strcat($$,$2);strcat($$,")");}
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


numeric_expression: VARIABLE  { $$ = $1; } /*TODO: Chequear hashmap si es num y si existe*/
          | CONSTANT_NUM
          | PARENTHESIS_OPENED numeric_expression PARENTHESIS_CLOSED {$$=calloc(1,3+strlen($2));strcat($$,"(");strcat($$,$2);strcat($$,")");}
          | numeric_expression ADD numeric_expression {strcat($$,"+");strcat($$,$3);}
          | numeric_expression SUBSTRACT numeric_expression {strcat($$,"-");strcat($$,$3);}
          | numeric_expression DIVIDE numeric_expression {strcat($$,"/");strcat($$,$3);}
          | numeric_expression MULTIPLY numeric_expression {strcat($$,"*");strcat($$,$3);}
          ;

%%

int main(void)
{
   printf("#include <stdio.h>\n");
   printf("int main(){\n");
   yyparse();
   printf("}\n");
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
