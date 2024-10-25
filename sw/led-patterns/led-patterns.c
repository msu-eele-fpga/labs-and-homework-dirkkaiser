/*
 * Dirk Kaiser - EELE467 Lab 8 "Creating LED Patterns with a C Program Using /dev/mem in Linux"
 * Montana State University - Fall 2024
 * 
 * This program will let you use the linux terminal to write different patterns to the 
 * Altera Cyclone V SoC FPGA. This part of the continued developement of our HW/SW codesign
 * project. 
 * 
 * I am really only puting this header here to see if Trevor even checks.
 * 
 *      /\     /\
 *     {  `---'  }
 *     {  O   O  }
 *     ~~>  V  <~~
 *       `-----'____
 *       /     \    \_
 *      {       }\  )_\
 *      |  \_/  ) / /
 *       \__/  /(_/  
 *         (__/
 * 
 *      Go Bobcats!
 * 
 */

//-----------------------------------------------------------------------------

// Standard shi
#include <stdio.h> 
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
// Other Libraries used
#include <sys/mman.h> // for mmap
#include <fcntl.h>    // for file open flags
#include <unistd.h>   // for getting the page size
#include <ctype.h>    // for optget
#include <signal.h>   // for exiting with ^C
#include <string.h>   // for strcpy and strtoul

//-----------------------------------------------------------------------------
// Some Functions:

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
 * dectobin(dec, bin) - function for converting decimal to binary
 * @dec: decimal number input
 * @bin: binary output array
 *
 * Converts a decimal uint32_t (like the one you get from strtoul) to binary character
 * and stores the output in a char array. This is really here just for the verbose function.
 *
 */
void dectobin(uint32_t dec, char *binArray)
{
    int bits = 8; // this should probably be done with a some sort of sizeof() function
    // but that wasnt working so it's now just 8 cause every pattern is only 8 bits
    for (int i = 0; i < bits; i++)
    {
        binArray[bits - 1 - i] = (dec & (1UL << i)) ? '1' : '0';
    }
    binArray[bits] = '\0'; // Null-terminate the string
}

/*
 * verbose(pattern, time) - prints patterns verbosely.
 * @pattern: pattern you want to print in binary.
 * @time: time you want to print.
 *
 * This with achieve requirement 3 -v (printing verbosely).
 * This will print out the pattern that is being displayed as well as the
 * time it is being displayed
 * Example: verbose(0x0f, 1500) => "LED pattern = 00001111 Display time = 1500 msec"
 *
 */
void verbose(uint32_t pattern, uint32_t time)
{
    //patterns will only be 8 bits max + 1 for null character
    char pattern_binArray[9];
    dectobin(pattern, pattern_binArray);
    fprintf(stdout, "LED pattern = %s Display time = %u msec\n", pattern_binArray, time);
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
    fprintf(stdout, "\n Do you really want to quit? [y/n] \n");
    c = getchar();
    if (c == 'y' || c == 'Y')
    {
        // I think this is where I would set the device back into hardware control
        fprintf(stdout, "Setting back to hardware control.\n");
        exit(0);
    }
    else
    {
        signal(SIGINT, INThandler);
        getchar(); // Get new line character
    }
}

/*
 * devmem(pattern) - uses devmem to write patterns to leds.
 * @pattern: pattern you want to write to led.
 *
 * This function is heavily based off of Prof Trevors devmem.c code...
 * It should take in the hex value for the pattern and write it to our custom hardware.
 *
 */
void devmem(uint32_t pattern)
{
    // This is the size of a page of memory in the system. Typically 4095 bytes.
    const size_t PAGE_SIZE = sysconf(_SC_PAGE_SIZE);
    // Open the /dev/mem file, which is an image of the main system memory
    // We use synchronous write operations (0_SYNC) to ensure that the value
	// is fully written to the underlying hardware before the write call returns.
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	if (fd == -1)
	{
		fprintf(stderr, "failed to open /dev/mem.\n");
		return 1;
	}
    uint32_t page_aligned_addr = ADDRESS & ~(PAGE_SIZE - 1);

    // Map a page of physical memory into virtual memory. See the mmap man page
	uint32_t *page_virtual_addr = (uint32_t *)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_aligned_addr);
	if (page_virtual_addr == MAP_FAILED)
	{
		fprintf(stderr, "failed to map memory.\n");
		return 1;
	}
    uint32_t offset_in_page = ADDRESS & (PAGE_SIZE - 1);
    volatile uint32_t *target_virtual_addr = page_virtual_addr + offset_in_page/sizeof(uint32_t*);
    *target_virtual_addr = pattern;
}

//-----------------------------------------------------------------------------
// Our Main Program
int main(int argc, char **argv)
{

    int vflag = 0;
    int pflag = 0;
    int fflag = 0;

    int ptn_cnt = 0; // pattern and time count int for p flag

    //  Static definition of arrays for arguments
    char fvalue[128];
    uint32_t patterns[128];
    uint32_t times[128];

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
            ptn_cnt = (argc - (optind - 1)) / 2; // number of pattern time pairs
            if ((argc - optind - 1) % 2 == 1)     // checks if odd number of args
            {
                fprintf(stderr, "TIME value needed after each PATTERN\n");
                usage();
                return 1;
            }
            for (int i = optind - 1; i < argc; i = i + 2) // grabs every other arg
            {
                patterns[(i - optind + 1) / 2] = strtoul(argv[i], NULL, 0);
                // fprintf(stderr, "Pattern[%d/2] = %x\n",i,patterns[i/2]);
            }
            for (int j = optind; j < argc; j = j + 2) // grabs the other every other arg
            {
                times[(j - optind) / 2] = strtoul(argv[j], NULL, 0);
                // fprintf(stderr, "Time[%d/2] = %u\n",j,times[j/2]);
            }
            break;
        case 'f':                   // file
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
    
    if (argc == 1) // no arguments
    {
        usage();
        return 1;
    }
    if (pflag == 1 && fflag == 1) // both -p and -f is a no no
    {
        fprintf(stderr, "Cannout use option -p and -f at the same time.\n\n");
        usage();
        return 1;
    }

    int line_cnt = 0; // counter for lines in file
    if (fflag == 1)
    {
    // opening the file from -f if there is one
    FILE *file = fopen(fvalue, "r"); // Open the file for reading
    char line[128]; // Buffer to hold each line
    const char *delim = " ,"; // Delimiters: space and comma
    char *token; // for holding patterns and time

    while (fgets(line, sizeof(line), file) != NULL) // counting how many lines there are
    {
        line_cnt++;
    }
    rewind(file); // reset to top of the file

    for (int i = 0; i < line_cnt; i++) // for each line add to our patterns and times to arrays
    {
        fgets(line, sizeof(line), file);
        token = strtok(line, delim);
        patterns[i] = strtoul(token, NULL, 0);
        token = strtok(NULL, delim);
        times[i] = strtoul(token, NULL, 0);
    }
    fclose(file); // Close the file
    }

    signal(SIGINT, INThandler); // allow for exit with ^C
    while (1)
    {
        if (pflag == 1)
        {
            for (int i = 0; i < ptn_cnt; i++)
            {
                if (vflag == 1)
                {
                    verbose(patterns[i], times[i]);
                }
                devmem(patterns[i]);
                sleep(times[i]*1000);
            }
        }
        else if (fflag == 1)
        {
            for (int i = 0; i < line_cnt; i++)
            {   
                if (vflag == 1)
                {
                    verbose(patterns[i], times[i]);
                }
                devmem(patterns[i]);
                sleep(times[i]*1000);
            }
        }
    }
    return 0;
}
