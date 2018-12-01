%{
#include "hashmap.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define KEY_MAX_LENGTH (256)

void print_variable(char * str, char * var);
void variable_create(char * type, char * var);
void type_check(char * type, char * var);
char * hashmap_gets(char * name);
int hashmap_exists(char * name);
void hashmap_puts(char * name, char * type);
int yylex(void);
int yyerror(char *errormsg);
extern char yytext[];

static map_t varmap;

static int read=0;

%}

%union {
  char * str;
  int num;
  int bool;
}

%token <str> NEW_LINE
%token <str> ADD SUBSTRACT DIVIDE MULTIPLY LESSER GREATER LESSER_EQ GREATER_EQ EQUALS AND OR NOT
%token <str> STRING_TYPE VARIABLE ASSIGN CONSTANT_STRING SHOW CONDITIONAL CONDITIONAL_ELSE LOOP LOOP_CONDITION PARENTHESIS_OPENED PARENTHESIS_CLOSED READ ENTRY END
%token <str> NUM_TYPE CONSTANT_NUM
%token <str> BOOL_TYPE CONSTANT_BOOL
%type <str> statement chained_statements numeric_expression boolean_expression code

%start start

%%

start: ENTRY NEW_LINE code END {printf("#include <stdio.h>\n"); printf("int main(){\n"); printf("%s",$3); printf("}\n"); return 0;}

code: chained_statements
     | boolean_expression NEW_LINE {$$=calloc(1,3+strlen($1));strcat($$,$1);strcat($$,";\n");}
     | numeric_expression NEW_LINE {$$=calloc(1,3+strlen($1));strcat($$,$1);strcat($$,";\n");}
     ;

statement: STRING_TYPE VARIABLE ASSIGN CONSTANT_STRING NEW_LINE
         {variable_create("text",$2);$$=calloc(1,13+strlen($2)+strlen($4));strcat($$,"char * ");strcat($$,$2);strcat($$," = ");strcat($$,$4);strcat($$,";\n");} /*Chequear hashmap que NO exista y crear la entry con text*/
         | boolean_expression NEW_LINE CONDITIONAL chained_statements CONDITIONAL_ELSE chained_statements
         {$$=calloc(1,27+strlen($1)+strlen($3)+strlen($5));strcat($$,"if (");strcat($$,$1);strcat($$,") {\n\t");strcat($$,$4);strcat($$,"} else {\n\t");strcat($$,$6);strcat($$,"}\n");}
         | NUM_TYPE VARIABLE ASSIGN numeric_expression NEW_LINE
         {variable_create("num",$2);$$=calloc(1,14+strlen($2)+strlen($4));strcat($$,"int ");strcat($$,$2);strcat($$," = ");strcat($$,$4);strcat($$,";\n");} /*Chequear hashmap que NO exista y crear la entry con num*/
         | BOOL_TYPE VARIABLE ASSIGN boolean_expression NEW_LINE
         {variable_create("bool",$2);$$=calloc(1,14+strlen($2)+strlen($4));strcat($$,"int ");strcat($$,$2);strcat($$," = ");strcat($$,$4);strcat($$,";\n");} /*Chequear hashmap que NO exista y crear la entry con bool*/
         | VARIABLE ASSIGN CONSTANT_STRING NEW_LINE
         {type_check("text",$1);$$=calloc(1,13+strlen($1)+strlen($3));strcat($$,$1);strcat($$," = ");strcat($$,$3);strcat($$,";\n");} /*Chequear hashmap si es text y si existe*/
         | VARIABLE ASSIGN numeric_expression NEW_LINE
         {type_check("num",$1);$$=calloc(1,14+strlen($1)+strlen($3));strcat($$,$1);strcat($$," = ");strcat($$,$3);strcat($$,";\n");} /*Chequear hashmap si es num y si existe*/
         | VARIABLE ASSIGN boolean_expression NEW_LINE
         {type_check("bool",$1);$$=calloc(1,14+strlen($1)+strlen($3));strcat($$,$1);strcat($$," = ");strcat($$,$3);strcat($$,";\n");} /*Chequear hashmap si es bool y si existe*/
         | SHOW VARIABLE NEW_LINE
         {$$=calloc(1,23+strlen($2));print_variable($$,$2);strcat($$,$2);strcat($$,");\n");} /*DEPENDE DEL HASHMAP IMPRIME DISTINTO (%d o %s)*/
         | SHOW CONSTANT_STRING NEW_LINE
         {$$=calloc(1,23+strlen($2));strcat($$,"printf(\"%s\\n\",");strcat($$,$2);strcat($$,");\n");}
         | SHOW boolean_expression NEW_LINE
         {$$=calloc(1,23+strlen($2));strcat($$,"printf(\"%d\\n\",");strcat($$,$2);strcat($$,");\n");}
         | SHOW numeric_expression NEW_LINE
         {$$=calloc(1,23+strlen($2));strcat($$,"printf(\"%d\\n\",");strcat($$,$2);strcat($$,");\n");}
         | LOOP chained_statements LOOP_CONDITION boolean_expression NEW_LINE
         {$$=calloc(1,20+strlen($2)+strlen($4));strcat($$,"do {\n\t");strcat($$,$2);strcat($$,"} while (");strcat($$,$4);strcat($$,");\n");}
         | READ NEW_LINE {$$=calloc(1,60);if(!read){strcat($$,"char read[1000];  "); read=1;};strcat($$,"scanf(\"%s\",read);  printf(\"%s\\n\",read);\n");}
         ;

chained_statements: statement
          | statement chained_statements {strcat($$,$2);}
          ;

boolean_expression: VARIABLE { type_check("bool",$1);$$ = $1; } /*Chequear hashmap si es bool y si existe*/
          | CONSTANT_BOOL {$$=calloc(1,2);strcat($$,(strcmp($1,"true"))?"0":"1");}
          | PARENTHESIS_OPENED boolean_expression PARENTHESIS_CLOSED {$$=calloc(1,3+strlen($2));strcat($$,"(");strcat($$,$2);strcat($$,")");}
          | boolean_expression AND boolean_expression {strcat($$,"&&");strcat($$,$3);}
          | boolean_expression OR boolean_expression {strcat($$,"||");strcat($$,$3);}
          | NOT boolean_expression {$$=calloc(1,2+strlen($2));strcat($$,"!");strcat($$,$2);}
          | numeric_expression LESSER numeric_expression {strcat($$,"<");strcat($$,$3);}
          | numeric_expression GREATER numeric_expression {strcat($$,">");strcat($$,$3);}
          | numeric_expression LESSER_EQ numeric_expression {strcat($$,"<=");strcat($$,$3);}
          | numeric_expression GREATER_EQ numeric_expression {strcat($$,">=");strcat($$,$3);}
          | boolean_expression EQUALS boolean_expression {strcat($$,"==");strcat($$,$3);}
          | numeric_expression EQUALS numeric_expression {strcat($$,"==");strcat($$,$3);}
          | VARIABLE EQUALS numeric_expression {strcat($$,"==");strcat($$,$3);}
          ;


numeric_expression: VARIABLE  { type_check("num",$1);$$ = $1; } /*Chequear hashmap si es num y si existe*/
          | CONSTANT_NUM {$$=calloc(1,strlen($1));strcat($$,$1);}
          | PARENTHESIS_OPENED numeric_expression PARENTHESIS_CLOSED {$$=calloc(1,3+strlen($2));strcat($$,"(");strcat($$,$2);strcat($$,")");}
          | numeric_expression ADD numeric_expression {strcat($$,"+");strcat($$,$3);}
          | numeric_expression SUBSTRACT numeric_expression {strcat($$,"-");strcat($$,$3);}
          | numeric_expression DIVIDE numeric_expression {strcat($$,"/");strcat($$,$3);}
          | numeric_expression MULTIPLY numeric_expression {strcat($$,"*");strcat($$,$3);}
          ;

%%

void print_variable(char * str, char * var){
  char * type = malloc(5);
  hashmap_get(varmap, var, (void**)(&type));
  if(!strcmp(type,"text")){
    strcat(str,"printf(\"%s\\n\",");
  }
  else{
    strcat(str,"printf(\"%d\\n\",");
  }
}

void variable_create(char * type, char * var){
  if(hashmap_exists(var)){
    yyerror("Variable already exists");
  }
  else{
    hashmap_puts(var,type);
  }
}

void type_check(char * type, char * var){
  if(strcmp(type,hashmap_gets(var))){
    yyerror("Data Type mismatch");
  }
}

char * hashmap_gets(char * name){
  char * type = malloc(5);
  int error = hashmap_get(varmap, name, (void**)(&type));
  if(!(error==MAP_OK)){
      yyerror("Data Type error");
  }

  return type;
}

int hashmap_exists(char * name){
  char * type = malloc(5);
  int error = hashmap_get(varmap, name, (void**)(&type));
  free(type);
  return !(error==MAP_MISSING);
}

void hashmap_puts(char * name, char * type){
  int error = hashmap_put(varmap, name, type);
  if(!(error==MAP_OK)){
    yyerror("Data Type error");
  }
}

int main(void)
{
  varmap = hashmap_new();
  yyparse();
  hashmap_free(varmap);
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
