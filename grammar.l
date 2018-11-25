%{

#include "y.tab.h"
extern int yyerror(char *errormsg);

%}

%%

 /***************************************************
 ******          Whitespace and newlines       ******
 ****************************************************/

[\t ]+             ;

[\n]+       {return NEW_LINE;}

 /***************************************************
 ******          Statements                    ******
 ****************************************************/
"repeat" {return LOOP;}

"until" {return LOOP_CONDITION;}

"exit" {return 0;}

"!"            {return CONDITIONAL_ELSE;}

"?\n"            {return CONDITIONAL;}

=             {return ASSIGN;}

"show"           {return SHOW;}

"("        { return PARENTHESIS_OPENED; }

")"        { return PARENTHESIS_CLOSED; } 

 /***************************************************
 ******          Data Types                    ******
 ****************************************************/

"bool"            { return BOOL_TYPE;}

true|false        { yylval.str = strdup(yytext);
                    return CONSTANT_BOOL;}

"num"             {return NUM_TYPE;}

[0-9]+              {  yylval.str = strdup(yytext);
                        return CONSTANT_NUM;}

"text"            { return STRING_TYPE; }

\".*\"|\'.*\'            { yylval.str = strdup(yytext);
                          return CONSTANT_STRING; }

[a-zA-Z0-9]+              {  yylval.str = strdup(yytext);
                            return VARIABLE; }

  /***************************************************
  ******          Expressions                   ******
  ****************************************************/

"+" {yylval.str="+";return ADD;}

"-" {yylval.str="-";return SUBSTRACT;}

"/" {yylval.str="/";return DIVIDE;}

"." {yylval.str=".";return MULTIPLY;}

"<" {yylval.str="<";return LESSER;}

">" {yylval.str=">";return GREATER;}

"<=" {yylval.str="<=";return LESSER_EQ;}

">=" {yylval.str=">=";return GREATER_EQ;}

"==" {yylval.str="==";return EQUALS;}

" and " {yylval.str="and";return AND;}

" or " {yylval.str="or";return OR;}

"not " {yylval.str="not";return NOT;}
%%
