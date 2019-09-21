%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
int files_count = 0;
int lines;
int pos_start;
int pos_end;

enum cminus_token_type{
	ERROR = 258,
	ADD = 259,
	SUB = 260,
	MUL = 261,
	DIV = 262,
	LT = 263,
	LTE = 264,
	GT = 265,
	GTE = 266,
	EQ = 267,
	NEQ = 268,
	ASSIN = 269,
	SEMICOLON = 270,
	COMMA = 271,
	LPARENTHESE = 272,
	RPARENTHESE = 273,
	LBRACKET = 274,
	RBRACKET = 275,
	LBRACE = 276,
	RBRACE = 277,
	ELSE = 278,
	IF = 279,
	INT = 280,
	RETURN = 281,
	VOID = 282,
	WHILE = 283,
	IDENTIFIER = 284,
	NUMBER = 285,
	LETTER = 286,
	ARRAY = 287,
	EOL = 288,
	COMMENT = 289,
	BLANK = 290
};
%}
/**********Arithmetic operator*********/
_add \+
_sub \-
_mul \*
_div \/

/*********Relational operator**********/
_lt <
_lte <=
_gt >
_gte >=
_eq ==
_neq !=

/*******Assign operater(only =)********/
_assign =

/**************punctuation*************/
_semicolon ;
_comma ,
_lparenthese \(
_rparenthese \)
_lbracket \[
_rbracket \]
_lbrace \{
_rbrace \}

/***************keyword***************/
_else else
_if if
_int int
_return return
_void void
_while while

/**************identifier*************/
_id [a-zA-Z][a-zA-Z]*
_num [0-9][0-9]*
_array [[0-9][0-9]*]

/****************space****************/
_eol \n
_comment (\/\/.*)|(\/\*(.|\n)*\/)
/*_space*/ 
_tab \t

/*****************end*****************/

%%

 /****请在此补全所有flex的模式与动作  start******/
{_add} {pos_start+=1;pos_end=pos_start+1;return ADD;}
{_sub} {pos_start+=1;pos_end=pos_start+1;return SUB;}
{_mul} {pos_start+=1;pos_end=pos_start+1;return MUL;}
{_div} {pos_start+=1;pos_end=pos_start+1;return DIV;}

{_lt} {pos_start+=1;pos_end=pos_start+1;return LT;}
{_lte} {pos_start+=1;pos_end=pos_start+2;return LTE;}
{_gt} {pos_start+=1;pos_end=pos_start+1;return GT;}
{_gte} {pos_start+=1;pos_end=pos_start+2;return GTE;}
{_eq} {pos_start+=1;pos_end=pos_start+1;return EQ;}
{_neq} {pos_start+=1;pos_end=pos_start+2;return NEQ;}

{_assign} {pos_start+=1;pos_end=pos_start+1;return ASSIN;}

{_semicolon} {pos_start+=1;pos_end=pos_start+1;return SEMICOLON;}
{_comma} {pos_start+=1;pos_end=pos_start+1;return COMMA;}
{_lparenthese} {pos_start+=1;pos_end=pos_start+1;return LPARENTHESE;}
{_rparenthese} {pos_start+=1;pos_end=pos_start+1;return RPARENTHESE;}
{_lbracket} {pos_start+=1;pos_end=pos_start+1;return LBRACKET;}
{_rbracket} {pos_start+=1;pos_end=pos_start+1;return RBRACKET;}
{_lbrace} {pos_start+=1;pos_end=pos_start+1;return LBRACE;}
{_rbrace} {pos_start+=1;pos_end=pos_start+1;return RBRACE;}

{_else} {pos_start+=1;pos_end=pos_start+4;return ELSE;}
{_if} {pos_start+=1;pos_end=pos_start+2;return IF;}
{_int} {pos_start+=1;pos_end=pos_start+3;return INT;}
{_return} {pos_start+=1;pos_end=pos_start+6;return RETURN;}
{_void} {pos_start+=1;pos_end=pos_start+4;return VOID;}
{_while} {pos_start+=1;pos_end=pos_start+5;return WHILE;}

{_id} {pos_start+=1;pos_end=pos_start+2;return IDENTIFIER;}
{_num} {pos_start+=1;pos_end=pos_start+3;return NUMBER;}
{_array} {pos_start+=1;pos_end=pos_start+5;return ARRAY;}

. {return ERROR;}


 /****  end******/
%%

/****************请按需求补全C代码 start*************/

/// \brief analysize a *.cminus file
///
///	\param input_file_name
/// \param output_file_name
/// \todo student should fill this function
void analyzer(char* input_file_name, char* output_file_name){
	char input_path[256] = "./testcase/";
	strcat(input_path, input_file_name);
	char output_path[256] = "./tokens/";
	strcat(output_path, output_file_name);
	if(!(yyin = fopen(input_path,"r"))){
		printf("[ERR] No input file\n");
		exit(1);
	}
	printf("[START]: Read from: %s\n", input_file_name);
	FILE *fp = fopen(output_path,"w+");
	int token;
	while(token = yylex()){
		switch(token){
			case ERROR:
				fprintf(fp, "[ERR]: unable to analysize %s at %d line, from %d to %d\n", yytext, lines, pos_start, pos_end);
				break;
			case COMMENT:
			case BLANK:
				break;
			case EOL:
				break;
			default :
				puts(yytext);
				fprintf(fp, "%s\t%d\t%d\t%d\t%d\n",yytext, token, lines, pos_start, pos_end);
		}
	}
	fclose(fp);
	printf("[END]: Analysis completed.\n");
}

/// \brief get all file paths under 'testcase' directory
///
/// under 'testcase' directory, there could be many *.cminus files.
/// \todo student should fill this function
void getAllTestcase(char filename[][256]){
	char dir_path[512] = "./testcase";
	int i = 0;

	DIR *ptr;
	struct dirent *file_info;

	ptr = opendir(dir_path);
	if(ptr == NULL)
		return;
	while(file_info = readdir(ptr)){
		switch(file_info->d_type){
            case DT_DIR:break;
            case DT_BLK:break;
            case DT_CHR:break;
            case DT_FIFO:break;
            case DT_LNK:break;
            case DT_SOCK:break;
            case DT_REG:files_count++;strcpy(filename[i], file_info->d_name);i++;break;
            case DT_UNKNOWN:break;
            default:break;
        }
	}
	closedir(ptr);
}

/// \brief process all *.cminus file
///
/// note that: use relative path for all i/o operations
///	process all *.cminus files under 'testcase' directory,
/// then create *.tokens files under 'tokens' directory
/// \todo student should fill this function
int main(int argc, char **argv){
	char filename[10][256];
	char output_file_name[256];
	char suffix[] = ".tokens";
	getAllTestcase(filename);
	for(int i = 0; i < files_count; i++){
		if(!strstr(filename[i], ".cminus"))
			continue;
		int j;
		for(j=strlen(filename[i])-1;j>=0;j--){
			if(filename[i][j] == '.')
				break;
		}
		strncpy(output_file_name, filename[i], j);
		output_file_name[j] = '\0';
		strcat(output_file_name,suffix);
		analyzer(filename[i],output_file_name);
	}
	return 0;
}
/**************** end*************/
