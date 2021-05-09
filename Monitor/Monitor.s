        .setcpu "6502"

        .include  "ACIAdefs.s"
        .include  "VIAdefs.s"

        PRTPTR = $CB

        .segment "VECTORS"

        .word  nmi
        .word  reset
        .word  irq

        .code

reset:  jmp main

nmi:    rti

irq:    rti

main:  
        lda #%00001011    ; Initialize the ACIA
        sta ACIA1_COMMAND
        lda #%00011111
        sta ACIA1_CONTROL

        lda #>logo       ; Load the low byte of the logo
        ldx #<logo       ; high byte
        jsr wstring      ; show string
        lda #>motd
        ldx #<motd
        jsr wstring

getinput:
        lda #>prompt     ; Display the prompt
        ldx #<prompt 
        jsr wstring
        ldy #$18         ; Max command length (24 chars)
inputloop:
        jsr racia1       ; Wait for kepressed
        cmp #CR         ; We pressed enter, execute
        beq execute
        cmp #BS          ; We pressed Backspace, clean up
        beq backspace
        cmp #BS2
        beq backspace
        jsr wacia1       ; Otherwise, display character
        ldx inputlen
        sta inputbuf, x  ; Store in our input buffer
        inx              
        stx inputlen     ; Keep track of our input length
        dey              ; check our char length
        bne inputloop    ; if we still have room, loop back, otherwise error

cmdlengtherror:
        lda #>CRLF
        ldx #<CRLF
        jsr wstring
        lda #>Error
        ldx #<Error 
        jsr wstring
        lda #$0           ; reset our input buffer
        sta inputbuf 
        sta inputlen
        jmp getinput

execute:
       jsr wacia1
       lda #LF
       jsr wacia1
       lda #>Executing
       ldx #<Executing
       ; Parse our command
       ; convert address to actual address
       ; convert value to hex value (if write)
       ; if read, fetch data and convert to ascii

       jsr wstring
       lda #$0             ; Reset our input buffer
       sta inputbuf 
       sta inputlen
       jmp getinput

backspace:
       ldx inputlen
       beq inputloop       ; Go right back if we're all the way to the left
       dex                 
       iny
       lda #$0
       sta inputbuf, x
       stx inputlen
       lda #>MVLEFT
       ldx #<MVLEFT
       jsr wstring
       lda #SPACE
       jsr wacia1
       lda #>MVLEFT
       ldx #<MVLEFT
       jsr wstring
       jmp inputloop     ; we hop back into the input loo

wstring:                 ;string address stored in A and x
        stx PRTPTR       ; Store them in the zero page pointer
        sta PRTPTR+1
        tya
        pha
        ldy #0
wchar:  
        lda (PRTPTR),y
        beq wstring_done
        jsr wacia1
        iny
        jmp wchar

wstring_done:
        pla
        tay
        rts
                
racia1: lda ACIA1_STATUS
        and #%00001000   ; Check if recv buffer full
        beq racia1
        lda ACIA1_DATA
        rts

wacia1: pha
wait:   lda ACIA1_STATUS
        and #%00010000  ; check if transmit buffer empty
        beq wait
        pla
        sta ACIA1_DATA
        rts
        
prompt:     .byte   "> ", EOS
Executing:  .byte   "Executing...", CR, LF, EOS
Error:      .byte   "Error... too many chars", CR, LF, EOS
CRLF:       .byte   CR, LF
MVLEFT:     .byte   $1B, $5B, $31, $44, $00
logo:       .byte   "    _/_/_/_/_/  _/    _/  _/_/_/_/_/            _/", CR, LF
logo1:      .byte   "         _/    _/  _/        _/              _/_/", CR, LF
logo2:      .byte   "      _/      _/_/          _/  _/_/_/_/_/    _/", CR, LF
logo3:      .byte   "   _/        _/  _/        _/                _/", CR, LF
logo4:      .byte   "_/_/_/_/_/  _/    _/      _/                _/", CR, LF, LF, EOS
motd:       .byte   "---- Welcome to the ZKT-1 Computer Designed and Built By Kurt Telep ----", CR, LF, EOS
                                                     
        .bss
inputlen:   .res    1,$00
inputbuf:   .res    24,$00
