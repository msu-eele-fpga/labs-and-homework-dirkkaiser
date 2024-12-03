

# Lab 11: Platform Device Driver (AKA the very long lab)

## Overview
In this lab, we created a device driver for our LED patterns component. We created the device
driver from scratch, building it up bit-by-bit and learning about each and every piece along the way.

### Questions 
>1. What is the purpose of the platform bus?

The platform bus is there so that the operating system can find hardware that is not discoverable.

>2. Why is the device driver’s compatible property important?

 It determines which devices can be bound to our driver

 >3. What is the probe function’s purpose?

  Once a device has been bound to the driver, the driver’s probe function
gets called. The probe function is responsible for initializing the hardware.

>4. How does your driver know what memory addresses are associated with your device?

The driver knows the memory addresses because of the device tree.

>5. What are the two ways we can write to our device’s registers? In other words, what subsystems do
we use to write to our registers?

Two ways we can write to the registers is with a C program or with sysfs.

>6. What is the purpose of our struct led_patterns_dev state container?

The purpose of our struct is to have pointers to each of our registers.



