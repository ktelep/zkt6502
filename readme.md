# zkt6502 Single Board Computer

Simple 6502 based computer that I've wanted to build for 14 years....

Supports 32k of RAM, 2 VIAs, 2 ACIAs, and up to 16k of ROM, at least, that's the 
memory map configured in the GAL.  You can change it as you wish.

Note, if you use the GAL as designed and use a 28C256 ROM, you'll need to program it starting
at 4000, not at 0000.  This avoids having to disconnect pin 14 on the board.