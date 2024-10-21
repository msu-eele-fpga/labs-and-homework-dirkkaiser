# Homework 7: Linux CLI Practice
## Overview
The objective of this homework is to familiarize ourselves with the linux comand line and practice using different commands.

## Deliverables
### Problem 1
`wc -w lorem_ipsum.txt`

![problem 1](assets/hw-7/hw-7_1.png)
### Problem 2
`wc -m lorem_ipsum.txt`

![problem 2](assets/hw-7/hw-7_2.png)
### Problem 3
`wc -l lorem_ipsum.txt`

![problem 3](assets/hw-7/hw-7_3.png)
### Problem 4
`sort -h file-sizes.txt`

![problem 4](assets/hw-7/hw-7_4.png)
The output of this command was too long to include the whole thing
### Problem 5
`sort -h -r file-sizes.txt`

![problem 5](assets/hw-7/hw-7_5.png)
Again, the output of this command was too long to include the whole thing.
### Problem 6
`vim log.csv` 

To find the column corresponding to ip addresses

`cut -d ',' -f 3 log.csv`

![problem 6](assets/hw-7/hw-7_6.png)
### Problem 7
`cut -d ',' -f 2-3 log.csv`

![problem 7](assets/hw-7/hw-7_7.png)
### Problem 8
`cut -d ',' -f 1,4 log.csv`

![problem 8](assets/hw-7/hw-7_8.png)
### Problem 9
`heads -n 3 gibberish.txt`

![problem 9](assets/hw-7/hw-7_9.png)
### Problem 10
`tail -n 2 gibberish.txt`

![problem 10](assets/hw-7/hw-7_10.png)
### Problem 11
`tail -n+2 log.csv`

![problem 11](assets/hw-7/hw-7_11.png)
### Problem 12
`grep 'and' gibberish.txt`

![problem 12](assets/hw-7/hw-7_12.png)
### Problem 13
`grep -o -n 'we' gibberish.txt`

![problem 13](assets/hw-7/hw-7_13.png)
### Problem 14
`grep -o -i -P 'to [\w]+' gibberish.txt`

![problem 14](assets/hw-7/hw-7_14.png)
### Problem 15
`grep -i -o -c 'fpgas' fpgas.txt`

![problem 15](assets/hw-7/hw-7_15.png)
### Problem 16
`grep -i -P 'hot|not|cower|tower|smile|compile' fpgas.txt`

![problem 16](assets/hw-7/hw-7_16.png)
### Problem 17
`grep -c -P '^\s*--' ../../hdl/*/*.vhd`

![problem 17](assets/hw-7/hw-7_17.png)
### Problem 18
`ls > ls-output.txt | cat ls_output.txt`

![problem 18](assets/hw-7/hw-7_18.png)
### Problem 19
`sudo dmesg | grep 'CPU topo'`

This didn't output anything because there is no 'CPU topo' in the dmesg. So instead I just did this instead:

`sudo dmesg | grep 'CPU'`

![problem 19](assets/hw-7/hw-7_19.png)
### Problem 20
`find ../../hdl -iname '*.vhd' | wc -l`

![problem 20](assets/hw-7/hw-7_20.png)
### Problem 21
`grep -r '[--]' ../../hdl/*/*.vhd | wc -l`

![problem 21](assets/hw-7/hw-7_21.png)
### Problem 22
`grep -n FPGAs -i fpgas.txt | cut -d ':' -f 1`

![problem 22](assets/hw-7/hw-7_22.png)
### Problem 23
`du -h * | sort -h`

![problem 23](assets/hw-7/hw-7_23.png)
