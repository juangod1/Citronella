%{

#include "y.tab.h"
extern int yyerror(char *errormsg);

%}

%%

[\t ]+             ;
\n                {return 0;}

"num"             {return NUM_TYPE;}

[0-9]+              {   yylval.num = atoi(yytext);
                        return CONSTANT_NUM;}

"text"            { return STRING_TYPE; }

\".*\"|\'.*\'            { yylval.str = strdup(yytext);
                    return CONSTANT_STRING; }

[a-zA-Z0-9]+              {  yylval.str = strdup(yytext);
                    return VARIABLE; }

=                    {return EQUALS;}

%%
