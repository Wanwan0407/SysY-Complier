%{
/*************************
expr1.y
YACC file
Date: xxxx/xx/xx
xxxxx <xxxxx@nbjl.nankai.edu.cn>
***************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char idStr[50];
char numStr[50];
int yylex ();
extern int yyparse();
FILE* yyin ;
void yyerror(const char* s );
%}

%token NUMBER
%token ID
%token ADD
%token SUB
%token MUL
%token DIV
%token LEFTP 
%token RIGHTP
%left ADD SUB
%left MUL DIV
%left LEFTP RIGHTP
%right UMINUS

%%

lines   :   lines expr ';' { printf("%s\n", $2); }
        |   lines ';'
        |
        ;

expr    :   expr ADD expr { $$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$,$1);
                            strcat($$,$3); 
                            strcat($$,"+ "); }
        |   expr SUB expr { $$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$,$1);
                            strcat($$,$3); 
                            strcat($$,"- "); }
        |   expr MUL expr { $$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$,$1);
                            strcat($$,$3); 
                            strcat($$,"* "); }
        |   expr DIV expr { $$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$,$1);
                            strcat($$,$3); 
                            strcat($$,"/ "); }

        |   NUMBER        { $$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$,$1);
                            strcat($$," ");
                            
                            }
        |   ID            { $$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$,$1);
                            strcat($$," ");
                            }                  

        |   LEFTP expr RIGHTP { $$ = (char*)malloc(50 * sizeof(char));
                                strcpy($$,$2);
                                }

        |   SUB expr %prec UMINUS { $$ = (char*)malloc(50 * sizeof(char));
                                    strcpy($$,$1);
                                    strcat($$,$2);
                                    strcat($$," ");
                                    }
        ;

%%

    // programs section

int yylex()
{
    // place your token retrieving code here
    int t;
    while(1) {
        t = getchar();
        if (t == ' ' || t =='\t' || t == '\n') {
            //do nothing
        } else if (t >= '0' && t <= '9') {
            int ti = 0;
            while (t >= '0' && t <= '9') {
                numStr[ti]=t;
                t = getchar();
                ti++;
            }
            numStr[ti] = '\0';
            yylval = numStr;
            ungetc(t,stdin);
            return NUMBER;
        } else if ((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_') || (t >= '0' && t <= '9')) {
            int ti = 0;
            while ((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_') || (t >= '0' && t <= '9')) {
                idStr[ti] = t;
                ti++;
                t = getchar();
            }
            idStr[ti] = '\0';
            yylval = idStr;
            ungetc(t,stdin);
            return ID;
        } else {
            switch(t){
                case '+': return ADD;
                case '-': return SUB;
                case '*': return MUL;
                case '/': return DIV;
                case '(': return LEFTP;
                case ')': return RIGHTP;
                default: return t;
            }
        }
    }
}

int main(void)
{
    yyin = stdin ;

    do {
        yyparse();
    } while (! feof (yyin));
        return 0;
}
void yyerror(const char* s) {
    fprintf (stderr , "Parse error : %s\n", s );
    exit (1);
}
