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
				r=yyleng-1;//初始化边界
				while ((yytext[r]==' '|yytext[r]=='\''|yytext[r]=='\"'|yytext[r]=='\n'|yytext[r]=='\r')&&(r>0)) r=r-1;//确定右边界
				while ((yytext[l]==' '|yytext[l]=='\''|yytext[l]=='\"')&&(l<r)) l=l+1;//确定左边界
				while ((yytext[l]=='\n'|yytext[l]=='\r')&&(l<r)) l=l+1;//如果注释第一行没有具体内容就删除
				if (l<r) putchar('#');//放置注释符
				for (i=l;i<=r;i++)
					if (yytext[i]=='\r'|yytext[i]=='\n')
					{
							if (yytext[i-1]!='\r'&&yytext[i-1]!='\n')//为了适应不同的换行符使用了两层条件
							{
								putchar('\n');//使用新的换行符
								putchar('#');//放置注释符
							}
					}
					else putchar(yytext[i]);//非特殊情况输出注释内容
				putchar('\n');}//结尾换行
{string}       {ECHO;}//字符串原样输出
{endspace}     {len=yyleng-1;
				while ((yytext[len]==' '|yytext[len]=='\r'|yytext[len]=='\n')&&(len>0)) len=len-1;//过滤各种换行符，确定右边界，防止有多个空格
				for (i=0;i<len;i++) putchar(yytext[i]);//输出正常内容
				//putchar('#');
				putchar('\n');}//补回换行符
{extraspace}   {putchar(yytext[0]);//讲规则中匹配到的第一个非特殊字符输出
				for (i=1;i<yyleng;i++)
					if ((yytext[i]!=yytext[i-1])|(yytext[i]!=' ')) putchar(yytext[i]);}//如果是连续空格就不输出


%%

void main(void)
{
   yylex();
}

