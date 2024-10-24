#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h>   // for mmap
#include <fcntl.h>      // for file open flags
#include <unistd.h>     // for getting the page size
#include <ctype.h>      // for optget
#include <signal.h>     // for exiting with ^C
#include <string.h>     // for strcpy and strtoul

/*
 * usage() - prints help message.
 *
 * Instead of re-writing the help message everytime it needs to be printed
 * it is now a function!!
 *
 */
void usage()
{
    fprintf(stderr, "usage: led-patterns [-h] [-v] [-p] [-f] [<args>]\n");
    fprintf(stderr, "display a PATTERN for a TIME duration and loop until Ctrl-C is pressed\n");
    fprintf(stderr, "PATTERN is default an eight bit hexadecimal value\n");
    fprintf(stderr, "TIME is default an interger value for millisecond duration\n");
    fprintf(stderr, "Example: led-patterns -v -p 0x50 500 0xff 1000\n\n");
    fprintf(stderr, "options:\n");
    fprintf(stderr, " -h    display this help text and exit\n");
    fprintf(stderr, " -v    verbosely print PATTERN and TIME\n");
    fprintf(stderr, " -p    PATTERN and TIME to be displayed\n");
    fprintf(stderr, " -f    text file for which PATTERN and TIME will be read from\n\n");
}



/*
 * verbose() - prints patterns verbosely.
 * @arg1: Describe the first argument.
 * @arg2: Describe the second argument.
 *
 * A longer description, with more discussion of the function function_name()
 * that might be useful to those using or modifying it. Begins with an
 * empty comment line, and may include additional embedded empty
 * comment lines.
 * Return: Describe the return value of foobar.
 *
 */
void verbose()
{

}

/*
 * INThandler() - function for the exiting using ^C.
 *
 * I totally just copied this from the example referenced in the book.
 * I'm not to sure what the argument even does.
 *
 */
void INThandler(int sig)
{
    char c;

    signal(sig, SIG_IGN);
    printf("\nOUCH, did you hit Ctrl-C?\n"
           "Do you really want to quit? [y/n] \n");
    c = getchar();
    if (c == 'y' || c == 'Y')
        // I think this is where I would set the device back into hardware control
        exit(0);
    else
        signal(SIGINT, INThandler);
    getchar(); // Get new line character
}

int main(int argc, char **argv)
{

    int vflag = 0;
    int pflag = 0;
    int fflag = 0;

    //  Static definition of arrays for arguments
    char fvalue[128];
    uint32_t patterns[128];
    uint32_t times[128];

    int index;
    int opt;

    opterr = 0;

    while ((opt = getopt(argc, argv, "hvp:f:")) != -1) // get options - taken from GNU example
        switch (opt)
        {
        case 'h': // help
            usage();
            return 1;
            break;
        case 'v': // verbose
            vflag = 1;
            break;
        case 'p': // pattern
            // strcpy(pvalue, optarg, sizeof(pvalue)-1);
            pflag = 1;
            if (argc - optind - 1 % 2 == 1) // checks if odd number of args
            {
                fprintf(stderr, "TIME value needed after each PATTERN\n");
                usage();
                return 1;
            }
            for (int i = optind - 1; i < argc; i = i + 2) // grabs every other arg
            {
                patterns[i / 2] = strtoul(argv[i], NULL, 0);
                fprintf(stderr, "Pattern[%d] = %d"i/2,patterns[i/2]);
            }
            for (int j = optind; j < argc; j = j + 2) // grabs the other every other arg
            {
                times[j / 2] = strtoul(argv[j], NULL, 0);
                fprintf(stderr, "Time[%d] = %d"j/2,patterns[j/2]);
            }
            break;
        case 'f': // file
            strcpy(fvalue, optarg); // copy file name
            fflag = 1;
            break;
        case '?': // others
            if (optopt == 'p' || optopt == 'f')
            {
                fprintf(stderr, "Option -%c requires an argument.\n\n", optopt);
                usage();
                return 1;
            }
            else if (isprint(optopt))
            {
                fprintf(stderr, "Unknown option `-%c'.\n\n", optopt);
                usage();
                return 1;
            }
            else
            {
                fprintf(stderr, "Unknown option character `\\x%x'.\n", optopt);
                usage();
                return 1;
            }
        default:
            usage();
            return 1;
        }
    if (argc == 1)
    {
        usage();
        return 1;
    }
    if (pflag == 1 && fflag == 1)
    {
        fprintf(stderr, "Cannout use option -p and -f at the same time.\n\n");
        usage();
        return 1;
    }
    for (index = optind; index < argc; index++)
    {
        printf("Non-option argument %s\n", argv[index]);
        usage();
        return 1;
    }
    signal(SIGINT, INThandler); // allow for exit with ^C
    while (1)
    {
        if (pflag == 1)
        {

            if (vflag == 1)
            {
                verbose();
            }
            else
            {
            // write patterns
            }
        }
        else if (fflag == 1)
        {
            if (vflag == 1)
            {
                verbose();
            }
            else
            {
            // read file
            // write patterns
            }
        }
    }
    return 0;
}
