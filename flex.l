%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string.h>
int len = 0;
int i = 0;
int l = 0;
int r = 0;
%}

spaceline (\r[ \t]*\n)|(\r[ \t]*\r)|(\n[ \t]*\n)
overlines [^\n]*[\'\"]{3}[^\']*[\'\"]{3}[^\t\n]*[\n]
string [\'\"]([^\'\"].*)|([\'\"].*)[\'\"]
defiend [\n\r]+
endspace [ ]+{defiend}
extraspace [^ \t\n\r\'\"]([ \t]+[^ \n\r\'\"]+)+

%%

{overlines}    {l=0;
					r=yyleng-1;
					while ((yytext[r]==' '|yytext[r]=='\''|yytext[r]=='\"'|yytext[r]=='\n'|yytext[r]=='\r')&&(r>0)) r=r-1;
					while ((yytext[l]==' '|yytext[l]=='\''|yytext[l]=='\"')&&(l<r)) l=l+1;
					while ((yytext[l]=='\n'|yytext[l]=='\r')&&(l<r)) l=l+1;
					if (l<r) putchar('#');
					for (i=l;i<=r;i++)
						if (yytext[i]=='\r'|yytext[i]=='\n')
						{
								if (yytext[i-1]!='\r'&&yytext[i-1]!='\n')
								{
									putchar('\n');
									putchar('#');
								}
						}
						else putchar(yytext[i]);
					putchar('\n');}
{string}       {ECHO;}
{endspace}     {len=yyleng-1;
					while ((yytext[len]==' '|yytext[len]=='\r'|yytext[len]=='\n')&&(len>0)) len=len-1;
					for (i=0;i<len;i++) putchar(yytext[i]);
					//putchar('#');
					putchar('\n');}
{extraspace}   {putchar(yytext[0]);
					for (i=1;i<yyleng;i++)
						if ((yytext[i]!=yytext[i-1])|(yytext[i]!=' ')) putchar(yytext[i]);}


%%

void main(void)
{
   yylex();
}

