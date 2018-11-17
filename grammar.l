%{

#include "y.tab.h"
int yyerror(char *errormsg);

%}

%%

"hi"       { return HI;  }
"text"      { return STRING_TYPE; }
"num"       { return INTEGER_TYPE; }
"bool"      { return BOOLEAN_TYPE; }
"show"      { return PRINT; }
"or"        { return OR; }
"and"       { return AND; }
"not"       { return NOT; }
"eq"       { return EQUALS; }
"!="        { return NOT_EQUALS; }
">"         { return GREATER; }
">="        { return GREATER_EQ; }
"<"         { return LESSER; }
"<="        { return LESSER_EQ; }
"+"        { return SUM; }
"-"         { return SUB; }
"*"        { return MUL; }
"/"        { return DIV; }
"%"         { return MOD; }
"="         { return ASSIGN; }
"\n"        { return END_LINE; }
"repeat"    { return WHILE; }
"until"     { return DO; }
"("       { return PARENTHESIS_OPENED; }
")"        { return PARENTHESIS_CLOSED; }
.         { yyerror("Unknown char");  }

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
