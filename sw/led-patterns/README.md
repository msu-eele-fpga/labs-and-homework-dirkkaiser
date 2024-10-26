# led-patterns READ ME
 
This program will let you use the linux terminal to write different patterns to the
Altera Cyclone V SoC FPGA. This part of the continued developement of our HW/SW codesign
project.
 
## Usage
`led-patterns [-h] [-v] [-p] [-f] [<args>]`

This will display a PATTERN for a TIME duration and loop until Ctrl-C is pressed or the end of the file is reached.

PATTERN is default an eight bit hexadecimal value

TIME is default an interger value for millisecond duration

### Example: 
`./led-patterns -v -p 0x50 500 0xff 1000`

`./led-patterns -f patterns.txt`


### options:
`-h` will display this help text and exit 

`-v` will verbosely print PATTERN and TIME

`-p` will allow for aurguments of PATTERN and TIME to be displayed

`-f` for the text file for which PATTERN and TIME could be read from

## Building

This program is made up of C-code which is intended to be compiled on a linux system and implemented on an ARM SoC FPGA. Because of this compiling requires special instructions.
First, this requires a Cyclone V SoC FPGA to have the proper bitstream downloaded which creates an HPS to Fabric Avalon Bridge. In the case of this lab this was done using a pre-compiled raw binary file on the SoC Linux FAT32 system.
The Avalon Bridge must have memory mapped registers in which LEDs are wired to. Furthermore, the appropriate cross compiler is needed, which can be installed on your linux system with: 

`sudo apt install gcc-arm-linux-gnueabihf`

 With all prereqs out of the way, this program can be built as follows:

 `arm-linux-gnueabihf-gcc -o led-patterns -Wall -static led-patterns.c`
