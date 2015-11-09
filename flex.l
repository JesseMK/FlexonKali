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
int str = 0;
%}

spaceline (\n[ \t]*\r)|(\r[ \t]*\r)|(\n[ \t]*\n)
defiend [\n\r]+
overline1 [\']{3}([\r\n]|.)*[\']{3}
overline2 [\"]{3}([\r\n]|.)*[\"]{3}
overlines [^\n\r]*({overline1}|{overline2})[^\n\r]*{defiend}
str1 ([^\'].*)|(.*[^\'])
str2 ([^\"].*)|(.*[^\"])
string1 ([\']{1,2}{str1}[\']{1,2})
string2 ([\"]{1,2}{str2}[\"]{1,2})
string {string1}|{string2}
endspace [ ]+{defiend}
extraspace ([^ \t\n\r\'\"][ \t]{2,}([^\n\r\'\"]|{string}))|([ \t]{2,}#[ \t]*)

%%

{overlines}    {l=0;
					r=yyleng-1;//初始化边界
					while ((yytext[r]==' '|yytext[r]=='\''|yytext[r]=='\"'|yytext[r]=='\n'|yytext[r]=='\r')&&(r>0)) r=r-1;//确定右边界
					while ((yytext[l]==' '|yytext[l]=='\''|yytext[l]=='\"')&&(l<r)) l=l+1;//确定左边界
					while ((yytext[l]=='\n'|yytext[l]=='\r')&&(l<r)) l=l+1;//如果注释第一行没有具体内容就删除
					while (yytext[l]==' ')
					{
						l=l+1;
						putchar(' ');
					}
					putchar('#');//放置注释符
					for (i=l;i<=r;i++)
						if (yytext[i]!='\r'&&yytext[i]!='\n')
							if (yytext[i-1]=='\r'|yytext[i-1]=='\n')//为了适应不同的换行符使用了两层条件
							{
								if (i!=l) putchar('\n');//使用新的换行符
								while (yytext[i]==' ')
								{
									i=i+1;
									putchar(' ');
								}
								putchar('#');//放置注释符
								putchar(yytext[i]);
							}
							else putchar(yytext[i]);//非特殊情况输出注释内容
					putchar('\n');}//结尾换行
{string}       {ECHO;}//字符串原样输出
{endspace}     {putchar('\n');}//补回换行符
{extraspace}   {putchar(yytext[0]);//规则中匹配到的第一个非特殊字符输出
					str=0;
					for (i=1;i<yyleng;i++)
					{
						if ((yytext[i]=='\'')|(yytext[i]=='\"')) str=1;
						if ((str==1)|(yytext[i]!=yytext[i-1])|(yytext[i]!=' ')) putchar(yytext[i]);
					}}//如果是连续空格就不输出

%%

void main(void)
{
   yylex();
}
