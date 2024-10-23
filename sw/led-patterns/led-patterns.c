#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h> // for mmap
#include <fcntl.h> // for file open flags
#include <unistd.h> // for getting the page size
#include <ctype.h>


void usage() // function to print help msg
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

void  INThandler(int sig) // function for the exiting using ^C 
// I totally just copied this from the stackoverflow post referenced in the book
{
     char  c;

     signal(sig, SIG_IGN);
     printf("OUCH, did you hit Ctrl-C?\n"
            "Do you really want to quit? [y/n] ");
     c = getchar();
     if (c == 'y' || c == 'Y')
          // I think this is where I would set the device back into hardware control
          exit(0);
     else
          signal(SIGINT, INThandler);
     getchar(); // Get new line character
}

int main (int argc, char **argv)
{
  int vflag = 0;
  char *pvalue = NULL;
  char *fvalue = NULL;
  int index;
  int opt;

  opterr = 0;


  while ((opt = getopt (argc, argv, "hvp:f:")) != -1)
    switch (opt)
      {
      case 'h':
        usage();
        break;
      case 'v':
        vflag = 1;
        break;
      case 'p':
        pvalue = optarg;
        break;
      case 'f':
        fvalue = optarg;
        break;
      case '?':
        if (optopt == 'p' || optopt == 'f')
        {
          fprintf (stderr, "Option -%c requires an argument.\n\n", optopt);
          usage();
          return 1;
        }
        if (optopt == 'p' && optopt == 'f')
        {
          fprintf (stderr, "Cannout use option -p and -f at the same time.\n\n");
          usage();
          return 1;
        }
        else if (isprint (optopt))
        {
          fprintf (stderr, "Unknown option `-%c'.\n\n", optopt);
          usage();
          return 1;
        }
        else
        {
          fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
          usage();
          return 1;
        }
      default:
        abort ();
      }

  for (index = optind; index < argc; index++)
    printf ("Non-option argument %s\n", argv[index]);

  signal(SIGINT, INThandler);
  while(1)
  {

  }
  return 0;
}


