    .setcpu "6502"

    VIA_DDRA = $3B03
    VIA_ORB  = $3B01

    .segment "VECTORS"

    .word   nmi
    .word   reset
    .word   irq

    .code

reset:  jmp main

nmi:    rti

irq:    rti

main:     lda #$ff
          sta VIA_DDRA
          lda #$00
          sta VIA_ORB

delay:    ldx #200
@delay2:  ldy #0
@delay1:  dey
          bne @delay1
          dex
          bne @delay2

          lda #$ff
          sta VIA_ORB

delay3:   ldx #200
@delay4:  ldy #0
@delay5:  dey
          bne @delay4
          dex
          bne @delay5

          jmp main