; Assembly routines to control LED's
    
    .include "xc.inc"
    
    ;Assemly directive to tell compiler to put code in text segment of memory
    .text 
    .global _ledOff
    .global _ledPattern1
    .global _blinky

    .equ ledPattern1, 0x69
    .equ ledPattern2, 0x96

_ledOff:
    mov #0xFF, w0 ;Needs to be high-byte
    call _ledOut
    return
    
_ledPattern1:
    mov #ledPattern1, w0
    call _ledOut
    return
    
; ledOut() writes to LED port
; 
; input: w0 8-bit value to write
; returns: nothing
_ledOut:
    com w0, w0 ;write inverted value back on top of itself
    sl w0, #8, w0 ;shift left back into w0 register
    mov w0, PORTB
    return
    
;ledLoop() is a time delay routine for the LED lights
;
; input: w0, w1, w2
; returns: nothing
_ledLoop:
    ; 0x1000 -> 1 minute, 24 seconds
    ; 0x0100 -> 5 seconds
    ; 0x0080 -> 3 seconds
    ; 0x0040 -> 1.1 seconds
    
    mov #0x0040, w0
1:
    mov #0xffff, w1
2:
    dec w1,w1 ;decrement w1 until it reaches 0
    bra Z, 3f ;If w1 on 0, branch forward to 3
    bra 2b  ;Else, branch back to 2
3:
    com w0,w2 ;want to see if w0 is already 0
    bra Z, 4f ;If it is a 0, branch forward to 4
    dec w0, w0 ; decrement w0
    bra 1b ;branch back to 1b
    
4: 
    return
    
_blinky:
    mov #ledPattern1, w0
    call _ledOut
    call _ledLoop
    mov #ledPattern2, w0
    call _ledOut
    call _ledLoop
    bra _blinky
    
    return
    
    
    .end

