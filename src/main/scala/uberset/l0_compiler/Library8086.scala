/*
  Author: uberset
  Date: 2015-11-28
  Licence: GPL v2
*/

package uberset.l0_compiler

import scala.collection.mutable.ListBuffer

object Library8086 {

    def library(out: ListBuffer[String]): Unit = {
        out.append(
            prints,
            println,
            printi,
            int2decimal,
            inputs,
            inputi
        )
    }

    val prints =
"""
prints:	; (AX)->()
        ; print a string to stdout
        ; string start address in AX
        ; string must be terminated with null

        mov bx, ax
.l:
        mov dl,[bx]     ; load character
        cmp dl, 0
        jz  .end
        mov ah,2		; output char to stdout (ah: 02, dl: char)
        int 0x21		; DOS
        inc bx
        jmp .l
.end:	ret
"""

    val println =
"""
println:; ()->()
        ; put CR LF to stdout

        push ax ; save
        mov ax, .line
        call prints
        pop ax  ; restore
        ret
.line:	db 0x0A, 0x0D, 0
"""

    val printi =
"""
printi: ; (AX)->()
        ; print a signed integer (16 bit) to stdout
        call int2decimal
        call prints
        ret
"""

    val int2decimal =
"""
int2decimal:
        ; (AX)->(AX)
        ; convert a signed integer (16 bit) to a buffer
        mov dl, '+'	; sign
        cmp	ax,0
        jge .unsigned
        neg ax
        mov dl, '-'
.unsigned:
        mov bx, .buffer
        mov [bx], dl	; sign
        mov cx, .endbuf-2
.next:	mov dx, 0
        mov bx, 10
        div bx	; ax = (dx, ax) / bx
                ; dx = remainder
        mov bx, cx
        add dl, '0'
        mov [bx], dl	; digit
        dec cx
        cmp ax, 0
        jne .next
        ; move sign if necessary
        ; BX points to the first digit now
        mov dl, [.buffer]	; sign '+' or '-'
        cmp dl, '-'
        jne .end    ; no sign
        dec bx
        mov [bx], dl    ; copy sign
.end:   mov ax, bx      ; result
        ret

section .data
.buffer	db		"-", "12345", 0
.endbuf:
section .text
"""

    val inputs =
"""
inputs: ; ()->(AX)
        ; get string from stdin
        ; max size len + 1 (CR)
        ; return startaddress
        ; user can edit text
        mov bx, .buff
        mov dx, bx
        mov ah, 0ah
        int 21h
		mov al, [bx+1]	; actual length
		add al, 2		; offset
		xor ah, ah		; 0
		add bx, ax
		mov [bx], byte 0; terminate string
        mov ax, .buff+2	; result
        ret

section	.data
.len 	equ 80
.buff:	db .len+1	; max size (including CR)
        db 0		; actual size
times .len db 0		; the string
        db 0		; CR (or 0)
section .text

"""

    val inputi =
"""
inputi: ; ()->(AX)
        call inputs
        call s2int
        push ax         ; save
        call println
        pop ax          ; restore
        ret

s2int:  ; (AX)->(AX)
        ; convert string to signed int (16-bit)
        ; regexp: [+-]?[0..9]*
        ; parameter AX: string addr
        ; result in AX
        ; CH: sign
        ; CL: char
        mov bx, ax
        mov ax, 0	; accu
        mov ch, 0	; sign
        mov cl, [bx]
        inc bx
        cmp cl, '+'
        je .next
        cmp cl, '-'
        jne .digits
        mov ch, -1
.next:	mov cl, [bx]
        inc bx
.digits:
        cmp cl, '0'
        jl .sign
        cmp cl, '9'
        jg .sign
        mov dx, 10
        mul dx
        sub cl, '0'
        mov dl, cl
        xor dh, dh
        add ax, dx
        jmp .next
.sign:	cmp ch, 0	; sign
        jge .end
        neg ax
.end:	ret
"""
    /*
            out.append(
"""




"""     )
    */

}
