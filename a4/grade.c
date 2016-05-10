#include <strings.h>

main(int argc, char *argv[])
{
int i;
char cmd[1024]="./grade.sh";
for (i=1; i < argc; i++){
        strcat (cmd, " ");
        strcat (cmd, argv[i]);
}
system (cmd);
}

