        .setcpu 6502

        .include "ACIAdefs.s"
        .include "VIAdefs.s"

        .segment VECTORS

nmi:    .word
reset:  .word
irq:    .word

        .code

reset:  jmp main

nmi:    rti

irq:    rti

main:  
        lda #hello
        sta args
        jsr wstring
        jmp main

wstring:   ;string address stored in A
        ldx #0
wchar:  
        lda #args,x
        beq wstring_done
        jsr wacia1
        inx
        jmp wchar

wstring_done:
        rts
                
racia1: lda ACIA1_STATUS
        and #%00001000   ; Check if recv buffer full
        beq racia1

        lda ACIA1_DATA
        pha
        lda ACIA1_STATUS
        pla
        rts

wacia1: php
        lda ACIA1_STATUS
        and #%00010000  ; check if transmit buffer empty
        bne wacia1

        pla
        sta ACIA1_DATA
        plp
        rts

        .data 

prompt:     .byte   "> ", $0
hello:      .byte   "---- Welcome to the ZKT-1 Designed and Built By Kurt Telep ----", $0

        .bss

args:       .byte   $0

