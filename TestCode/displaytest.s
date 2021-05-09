    .setcpu "6502"

    VIA2_ORB = $B200
    VIA2_ORA = $B201
    VIA2_DDRB = $B202
    VIA2_DDRA = $B203
    VIA2_T1CL = $B204
    VIA2_T1CH = $B205
    VIA2_ACR = $B20B
    VIA2_IER = $B20E



    .segment "VECTORS"

    .word   nmi
    .word   reset
    .word   irq

    .code

reset:  jmp main

nmi:    rti

irq:      rti

main:     lda #$ff        ; setup the VIA all outputs
          sta VIA2_DDRB
          sta VIA2_DDRA
          lda #$0         ; Everything off
          sta VIA2_ORB
          sta VIA2_ORA

          ; setup the screen
          
          
loop:     jmp loop

    .data
text:   .byte "Hello, World", $00

    .bss
ledstatus:  .byte $0
CNT:        .byte $0