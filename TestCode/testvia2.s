    .setcpu "6502"

    VIA2_ORB = $B200
    VIA2_ORA = $B201
    VIA2_DDRB = $B202
    VIA2_DDRA = $B203

    .segment "VECTORS"

    .word   nmi
    .word   reset
    .word   irq

    .code

reset:  jmp main

nmi:    rti

irq:    rti

main:     lda #$ff
          sta VIA2_DDRB
          sta VIA2_DDRA
          lda #$00
          sta VIA2_ORB
          sta ledstatus
          lda #$ff
          sta VIA2_ORA
          

loop:     jsr delay
          jsr flip
          jmp loop

flip:     lda #$1
          cmp ledstatus
          bne state1
          jmp state2

state1:   lda #$ff
          sta VIA2_ORB
          lda #$00
          sta VIA2_ORA
          lda #$1
          sta ledstatus
          rts

state2:   lda #$00
          sta VIA2_ORB
          lda #$ff
          sta VIA2_ORA
          lda #$0
          sta ledstatus
          rts

delay:      ldx #200
@delay2:    ldy #0
@delay1:    dey
            bne @delay1
            dex
            bne @delay2
            rts

    .data

ledstatus:  