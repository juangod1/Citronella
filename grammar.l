%{

#include "y.tab.h"
int yyerror(char *errormsg);

%}

%%

"hi"       { return HI;  }
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
