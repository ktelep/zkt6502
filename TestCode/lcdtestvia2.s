    .setcpu "6502"

    VIA1_ORB = $B100
    VIA1_ORA = $B101
    VIA1_DDRB = $B102
    VIA1_DDRA = $B103

    .segment "VECTORS"

    .word   nmi
    .word   reset
    .word   irq

    .zeropage

tmp1:   .byte  $00
spinchar: .byte $00

    .code

reset:  jmp main

nmi:    rti

irq:    rti

main:   jsr reset_lcd
        ldx #$4
        ldy #$2
        jsr set_lcd_add
        ldx #$0
loop:   lda hello,x
        beq hold
        jsr send_lcd_data
        inx
        jmp loop
 
hold: 
        ldx #$0
        ldy #$0
        jsr set_lcd_add
        ldx spinchar
        lda spinner, X
        bne show
        ldx 0
        stx spinchar
        lda spinner, X
show:
        jsr send_lcd_data   
        lda #10
        jsr _delay_ms
        jmp hold


set_lcd_add:
        ; Line 0 - 00 - 13
        ; Line 1 - 40 - 53
        ; Line 2 - 14 - 27
        ; Line 3 - 54 - 67
        ; there are 20 characters per line   
        ; X is x column
        ; Y is the row
        pha
        txa
        sta tmp1 
        cpy #0
        beq row0
        cpy #1
        beq row1
        cpy #2
        beq row2
row3:   lda #$54
        jmp addy
row2:   lda #$14
        jmp addy
row1:   lda #$40
        jmp addy
row0:   lda #$0
addy:   CLC
        adc tmp1
        ORA #$80    ; Set it as a character address 
        jsr send_lcd_instr
        pla 
        rts

set_lcd_cursor_on:
        pha
        lda #$0D 
        jsr send_lcd_instr
        pla
        rts

set_lcd_cursor_off:
        pha
        lda #$0C
        jsr send_lcd_instr
        pla
        rts

set_lcd_clear:
        pha
        lda #$01
        jsr send_lcd_instr
        lda #5
        jsr _delay_ms
        pla
        rts

send_lcd_nibble:
         ; XD XD EN RS D7 D6 D5 D4
         ; write the nibble
         sta VIA1_ORA
         ora #%00100000    ; Turn on enable pin
         sta VIA1_ORA
         AND #%11011111    ; Turn off enable pin
         sta VIA1_ORA
         RTS

send_lcd_instr:
         pha
         lsr A
         lsr A
         lsr A
         lsr A
         jsr send_lcd_nibble
         PLA
         AND #%00001111
         JMP send_lcd_nibble

send_lcd_data:
        pha
        LSR A
        LSR A
        LSR A
        LSR A
        ora #%00010000
        JSR send_lcd_nibble
        PLA
        AND #%00001111
        ORA #%00010000
        jmp send_lcd_nibble

reset_lcd:
        lda #$FF
        sta VIA1_DDRA
        lda #$00
        sta VIA1_ORA
        lda #100
        jsr _delay_ms

        lda #$03       ;0011 - Do Setup
        sta VIA1_ORA
        ldx #$23       ;100011  - Same value, but with enable
        stx VIA1_ORA   ; Do the Enable
        sta VIA1_ORA   ; Send again without enable
        lda #10
        jsr _delay_ms

        ldx #$23    
        stx VIA1_ORA   ; with enable
        lda #$03      
        sta VIA1_ORA   ; wihtout enable
        lda #1
        jsr _delay_ms

        ldx #$23    
        stx VIA1_ORA   ; with enable
        lda #$03      
        sta VIA1_ORA   ; wihtout enable
        lda #1
        jsr _delay_ms

        lda #$02 
        sta VIA1_ORA   ; 4 - bit address (0010), 
        ldx #$22       ; 
        stx VIA1_ORA   ; 4 - bit address (with enable)
        sta VIA1_ORA   ; 4 - bit address (no enable)
        lda #1
        jsr _delay_ms

        lda #$2B
        jsr send_lcd_instr    ; two line display, 5x8 font
        lda #1
        jsr _delay_ms

        lda #$0C         
        jsr send_lcd_instr    ; Display on, no cursur, no blink
        lda #1
        jsr _delay_ms

        lda #$01
        jsr send_lcd_instr    ; Clear the screen
        lda #1
        jsr _delay_ms

        lda #$06
        sta send_lcd_instr    ; 
        lda #1
        jsr _delay_ms

        lda #$02
        sta send_lcd_instr    ; 

        rts


; stole this from somewhere, it's hardcoded for 1MHz
_delay_ms:          sta tmp1      ; 3
                    txa           ; 2
                    pha           ; 3
                    tya           ; 2
                    pha           ; 3
                    ldx tmp1      ; 3

                    ldy #190      ; 2
@loop1:             dey           ; 190 * 2
                    bne @loop1    ; 190 * 3 - 1

@loop2:             dex           ; 2
                    beq @return   ; (x - 1) * 2 + 3

                    nop           ; 2
                    ldy #198      ; 2
@loop3:             dey           ; 198 * 2
                    bne @loop3    ; 198 * 3 - 1

                    jmp @loop2    ; 3

@return:            pla           ; 4
                    tay           ; 2
                    pla           ; 4
                    tax           ; 2
                    lda tmp1      ; 3
                    rts           ; 6 (+ 6 for JSR)


hello:      .byte       "Hello, World!",$00
spinner:    .byte       "\|/-", $00
