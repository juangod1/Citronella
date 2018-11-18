%{

#include "y.tab.h"
extern int yyerror(char *errormsg);

%}

%%

 /***************************************************
 ******          Whitespace and newlines       ******
 ****************************************************/

[\t ]+             ;
\n                {return 0;}

 /***************************************************
 ******          Statements                    ******
 ****************************************************/

=             {return EQUALS;}

"show"           {return SHOW;}

 /***************************************************
 ******          Data Types                    ******
 ****************************************************/

"bool"            { return BOOL_TYPE;}

true|false        {if(!strcmp(yytext,"true")){
                      yylval.bool = 1;
                    }
                    else if(!strcmp(yytext,"false")){
                      yylval.bool = 0;
                    }
                    return CONSTANT_BOOL;}

"num"             {return NUM_TYPE;}

[0-9]+              {   yylval.num = atoi(yytext);
                        return CONSTANT_NUM;}

"text"            { return STRING_TYPE; }

\".*\"|\'.*\'            { yylval.str = strdup(yytext);
                    return CONSTANT_STRING; }

[a-zA-Z0-9]+              {  yylval.str = strdup(yytext);
                    return VARIABLE; }

%%
