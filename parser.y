%{

#include <stdio.h>

int yylex(void);
int yyerror(const char *s);

%}

%token HI STRING_TYPE

%%

program:
         hi string_type
        ;

hi:
        HI     { printf("Hello World\n");   }
        ;

string_type:
        STRING_TYPE { printf("string"); }
        ;

%%
