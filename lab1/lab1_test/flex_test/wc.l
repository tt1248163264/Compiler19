%{
//在%{和%}中的代码会被原样照抄到生成的lex.yy.c文件的开头，您可以在这里书写声明与定义
#include <string.h>
int chars = 0;
int words = 0;
%}

%%

[a-zA-Z]+ { chars += strlen(yytext);words++;}
 /*你可以在这里使用你熟悉的正则表达式来编写模式*/
 /*你可以用C代码来指定模式匹配时对应的动作*/
 /*yytext指针指向本次匹配的输入文本*/

. {}
 /*对其他所有字符，不做处理，继续执行*/

%%

int main(int argc, char **argv){
    yylex();
    //yylex()是flex提供的词法分析例程，默认读取stdin                                                                     
    printf("look, I find %d words of %d chars\n", words, chars);
    return 0;
}