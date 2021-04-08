# Memory Decoder

This is the WinCUPL code for the memory decoding logic for my 6502 computer,  I use a GAL20V8A to reduce the amount of logic needed, and allow me to be more granular in my selection of memory locations for peripherals while keeping propogation delays to the minimum.

This is my first experience with CUPL and this type of design, but it works!  I'm sure it could be optimized.  Designed the code using Atmel's WinCUPL tool on windows 10, and I had no issues programming the GAL with a TL866ii Plus programmer.


```
/* Memory Map    */
/* 0x0000 - 0x0FFF  RAM   */
/* 0x1000 - 0x1FFF  RAM   */
/* 0x2000 - 0x2FFF  RAM   */
/* 0x3000 - 0x3FFF  RAM   */
/* 0x4000 - 0x4FFF  RAM   */
/* 0x5000 - 0x5FFF  RAM   */
/* 0x6000 - 0x6FFF  RAM   */
/* 0x7000 - 0x7FFF  RAM   */
/* 0x8000 - 0x8FFF  RES for more RAM?  */
/* 0x9000 - 0x9FFF  RES for more RAM?  */
/* 0xA000 - 0xAFFF  RES for more RAM?  */
/* 0xB000 - 0xB0FF  RES for Video?     */
/* 0xB100 - 0xB1FF  VIA1   */
/* 0xB200 - 0xB2FF  VIA2   */
/* 0xB300 - 0xB3FF  ACIA1  */
/* 0xB400 - 0xB4FF  ACIA2  */
/* 0xC000 - 0xCFFF  RES for more ROM?   */
/* 0xD000 - 0xDFFF  RES for more ROM?   */
/* 0xE000 - 0xEFFF  ROM    */
/* 0xF000 - 0xFFFF  ROM    */

===============================================================================
                                 Chip Diagram
===============================================================================

                               ______________
                              | 6502_Decoder |
                          x---|1           24|---x Vcc                      
                    addr8 x---|2           23|---x                          
                    addr9 x---|3           22|---x                          
                   addr10 x---|4           21|---x                          
                   addr11 x---|5           20|---x !ACIA2_sel               
                   addr12 x---|6           19|---x !ACIA1_sel               
                   addr13 x---|7           18|---x !RAM_sel                 
                   addr14 x---|8           17|---x !VIA2_sel                
                   addr15 x---|9           16|---x !VIA1_sel                
                  p2clock x---|10          15|---x !ROM_sel                 
                          x---|11          14|---x                          
                      GND x---|12          13|---x                          
                              |______________|
```