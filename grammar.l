%{

#include "y.tab.h"
extern int yyerror(char *errormsg);

%}

%%

[\t ]+      {;}
"hi"       { return HI;  }
"text"      { return STRING_TYPE; }
.         { yyerror("Unknown char");  }
.\n         {printf("end of line");}

%%
