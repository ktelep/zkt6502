        .setcpu "6502"

        ACIA_DATA = $B300
        ACIA_STATUS = $B301
        ACIA_COMMAND = $B302
        ACIA_CONTROL = $B303

        .segment "VECTORS"

        .word   nmi
        .word   reset
        .word   irq

        .code

reset:  jmp main

nmi:    rti

irq:    rti

main:
init_acia:      lda #%00001011   ; No Parity, no Echo, no Interrupt
                sta ACIA_COMMAND
                lda #%00011111   ; No stop bit, 8 data bits, 19200 bps
                sta ACIA_CONTROL
        
write:          ldx #0
next_char:
wait_txd_empty: lda ACIA_STATUS
                and #$10             ; Check if TXD empty flag set
                beq wait_txd_empty
                lda text, x
                beq read
                sta ACIA_DATA
                inx
                jmp next_char
read:
wait_rxd_full:  lda ACIA_STATUS
                and #$08
                beq wait_rxd_full
                lda ACIA_DATA
                jmp write

text:           .byte "Hello World!", $0d, $0a, $00



