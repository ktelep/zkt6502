    .setcpu "6502"

    VIA2_ORB = $B100
    VIA2_ORA = $B101
    VIA2_DDRB = $B102
    VIA2_DDRA = $B103
    VIA2_T1CL = $B104
    VIA2_T1CH = $B105
    VIA2_ACR = $B10B
    VIA2_IER = $B10E

    .segment "VECTORS"

    .word   nmi
    .word   reset
    .word   irq

    .code

reset:  jmp main

nmi:    rti

irq:      bit VIA2_T1CL   ; clear interrupt flag
          dec CNT
          bne skip
          pha 
          lda ledstatus   ; Check our led status
          cmp #1          ; is it 1?
          beq cont0       ; if it is, we wanna turn things OFF
          lda #$ff        ; otherwise turn them on
          sta VIA2_ORB
          lda #$00
          sta VIA2_ORA
          lda #1          ; set status to ON
          sta ledstatus
          jmp done        ; jump to finish up
cont0:    lda #$00        ; Turn all LEDs off
          sta VIA2_ORB
          lda #$ff
          sta VIA2_ORA
          lda #0          ; reset status to off
          sta ledstatus
done:     lda #$10        ; reset our counter
          sta CNT 
          pla
skip:     rti

main:     lda #$ff        ; setup the VIA all outputs
          sta VIA2_DDRB
          sta VIA2_DDRA
          lda #$0         ; Everything off
          sta VIA2_ORB
          sta VIA2_ORA
          lda #0          ; Ledstatus starts at 0
          sta ledstatus
          lda #$10
          sta CNT
          lda #$ff
          sta VIA2_T1CL   ; Setup our timer
          sta VIA2_T1CH
          lda #$40
          sta VIA2_ACR    ; ACR set to free run
          lda #$3f        ; Disable all IER interrupts
          sta VIA2_IER    ;
          lda #$c0        ; Enable just what we want
          sta VIA2_IER    ; 
          cli

loop:     jmp loop

    .bss
ledstatus:  .byte $0
CNT:        .byte $0