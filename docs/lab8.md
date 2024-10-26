# Lab 8 : Creating LED Patterns with a C Program Using /dev/mem in Linux

Dirk Kaiser - Montana State University - Fall 2024

 
       /\     /\
      {  `---'  }
      {  O   O  }
      ~~>  V  <~~
        `-----'____
        /     \    \_
       {       }\  )_\
       |  \_/  ) / /
        \__/  /(_/
          (__/
        Go Bobcats!

In this lab we were tasked with writing a program that will let you use the linux terminal to write different patterns to the Altera Cyclone V SoC FPGA. This part of the continued developement of our HW/SW codesign
project.

For more information please read the [README](../sw/led-patterns/README.md) as I did spend some actual time writing it. 

## Calculating Physical Addresses of our Component's Registers:

Part of this lab was writing to our custom hardware using software in our HPS. This entailed knowing what address our custom registers were at. When we created our Avalon component we knew we had three 32 bit registers with addresses `0x0000 0x0004 0x0008`

We also know that our Lightweight HPS-to-FPGA Bridge has a base address of `0xff20_0000` 

This lets us calculate our physical addresses of our componenet registers by adding the two together getting

`0xff200000 0xff200004 0xff200008`


