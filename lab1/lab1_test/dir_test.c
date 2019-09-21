#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <string.h>
#include <libgen.h>

void display_dir(char *path){
    if(strcmp(path, ".")==0 || strcmp(path, "..")==0)
        return;
    DIR *dir_ptr;
    struct dirent *file_info;

    dir_ptr = opendir(path);
    if(dir_ptr == NULL)
        return;
    
    int dir_len = strlen(path);
    if(path[dir_len-1] == '/')
        path[dir_len-1] = '\0';
    char sub_dir[512] = {0};
    while(file_info = readdir(dir_ptr)){
        switch(file_info->d_type){
            case DT_DIR:printf("%s dir\n",file_info->d_name);break;
            case DT_BLK:printf("%s blk\n",file_info->d_name);break;
            case DT_CHR:printf("%s chr\n",file_info->d_name);break;
            case DT_FIFO:printf("%s fifo\n",file_info->d_name);break;
            case DT_LNK:printf("%s lnk\n",file_info->d_name);break;
            case DT_SOCK:printf("%s sock\n",file_info->d_name);break;
            case DT_REG:printf("%s reg\n",file_info->d_name);break;
            case DT_UNKNOWN:printf("%s other\n",file_info->d_name);break;
            default:printf("%s default\n", file_info->d_name);break;
        }
    }
    closedir(dir_ptr);
}

int main(int argc, char *argv[])
{
	//main函数参数在执行时传进来，比如./hello jack  argc=2,argc[0]=./hello,argv[1]=jack
	if(argc != 2)
	{
		printf("argc error!\n");
		return -1;
	}
 
	display_dir( argv[1] );//调用目录打印函数
 
	return 0;
}