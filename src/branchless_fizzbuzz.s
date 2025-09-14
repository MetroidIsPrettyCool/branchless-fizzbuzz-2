%assign BUFF_SIZE 30

section .text                   ; start of text section, elided from html

global bfb_fill_buffer
bfb_fill_buffer:

;; initial setup
        mov rax, rsi            ; move our number into the bottom half of the rdx:rax register pair
        mov rcx, 10             ; we're doing a base 10 itoa
;; repeat for every digit
%assign i BUFF_SIZE - 2
%rep BUFF_SIZE - 8 - 1 - 1      ; the size of the buffer, minus strlen("FizzBuzz\0"), minus the final NULL terminator
        xor rdx, rdx            ; zero the top half of rdx:rax
        div rcx                 ; rax now contains the quotient, and rdx the remainder
        add rdx, '0'
        mov byte [rdi + i], dl  ; write to the buffer
%assign i i-1
%endrep
;; cleanup
        mov byte [rdi + BUFF_SIZE - 1], 0 ; null-terminate the buffer

;;
        mov rcx, 15             ; magic constant, see aforementioned blog post
        xor rdx, rdx            ; zero upper half of rdx:rax
        mov rax, rsi
        div rcx
        xchg rdx, rax
        xor rdx, rdx            ; rdx:rax = rsi mod 15

        mul rax                 ; rdx:rax = (rsi mod 15)^2
        mul rax                 ; rdx:rax = (rsi mod 15)^4
        div rcx                 ; rdx = (rsi^4) mod 15
        mov rcx, rdx            ; copy the result into rcx for safekeeping

;; determine if rdx (rcx) is 1 or not
        mov rdx, rcx            ; restore rdx
        dec edx
        neg rdx
        shr rdx, 63             ; rdx is now 00h if it was 1, and 01h otherwise
        dec rdx
        not rdx                 ; rdx is now 00h if it was 1, and FFFFFFFFFFFFFFFFh otherwise

;; set rax to '0' if rdx is 1, and NULL otherwise
        mov rax, rdx
        not rax
        and rax, '0'

;; set rdx to '0' if it was 1, and 'z' otherwise
        and rdx, 'z' - '0'
        add rdx, '0'

;; write our bytes
        mov byte [rdi + 2], dl
        mov byte [rdi + 3], dl
        mov byte [rdi + 6], dl
        mov byte [rdi + 7], dl
        mov byte [rdi + 8], al

mov rdx, rcx            ; restore rdx
        xor rax, rax            ; zero rax, we'll compose our result in here
;; set up as though this weren't 6 or 10
        dec rdx                 ; rdx is now 00h if it was 1, and FFFFFFFFFFFFFFFFh if it was 0
        mov rax, 'B'
        and rax, rdx            ; rax is now 'B' if rdx was 0 and 00h if rdx was 1
        not rdx
        and rdx, '0'
        or rax, rdx             ; rax is now '0' if rdx was 1 and unchanged if rdx was 0
;; "is it 0 or 1" mask
        mov rdx, rcx            ; restore rdx
        and rdx, 00000010b
        sub rdx, 00000010b      ; rdx is now 00h if it was > 1, else FFFFFFFFFFFFFFFFh
        and rax, rdx            ; rax is now 00h (NULL) if rdx was > 1
;; write our byte
        mov byte [rdi + 4], al

;; is it 0 or 6? or is it something else?
        dec rcx
        mov rax, rcx
        and rax, 00000100b      ; rax now contains 04h if rcx was 0 or 6, and 00h if it was 1 or 10
        mov rdx, rax
        or rax, 'B'             ; rax now contains 'F' if rcx was 0 or 6, and 'B' if it was 1 or 10

        shr rdx, 2
        dec rdx                 ; rdx now contains 00h if rcx was 0 or 6, and FFFFFFFFFFFFFFFFh if it was 1 or 10
        mov r8, 'u' - '0'
        and r8, rdx             ; r8 now contains 'u' - '0' if rcx was 1 or 10, and 00h if it was 0 or 6
        not rdx
        mov r11, rdx
        and rdx, 'i' - '0'
        or r8, rdx              ; r8 now contains 'i' - '0' if rcx was 0 or 6, and is unchanged if it was 1 or 10

        and r11, 'u'
        or r11, '0'              ; r11 now contains 'u' if rcx was 0 or 6, and '0' if it was 1 or 10
;; write byte 5
        mov byte [rdi + 5], r11b

;; but was it 1 all along?
        not rcx
        and rcx, 00000001b      ; rcx now contains 01h if it was 1, and 00h otherwise
        dec rcx                 ; rcx now contains 00h if our initial rcx value was 1, and FFFFFFFFFFFFFFFFh otherwise

        and r8, rcx
        add r8, '0'             ; r8 now contains '0' if our initial rcx value was 1, 'u' if it was 10, and 'i' if it was 0 or 6

;; write byte 1
        mov byte [rdi + 1], r8b

;; wrap up "was it 1 all along?"
        not rcx                 ; rcx now contains FFFFFFFFFFFFFFFFh if our initial rcx value was 1, and 00h otherwise

        mov rdx, rcx
        and rdx, '0'            ; our *set* mask
        and rcx, rax            ; our *unset* mask


        xor rax, rcx            ; sets rax to 0 if our initial rcx value was 1, otherwise leaves it unchanged
        or rax, rdx             ; sets rax to '0' if our initial rcx value was 1, otherwise leaves it unchanged

;; write byte 0
        mov byte [rdi], al

ret
