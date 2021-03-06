org 100h
mov ax, -1
LBL_10:
section .data
    dw 6
DATA_0: db "Hello "
section .text
push ax
mov ax, DATA_0
call prints
pop ax
jmp LBL_10
mov ax,0x4c00
int 0x21

printc:	; (AL)->()
        ; print a char to stdout
        mov dl, al      ; load character
        mov ah, 2		; output char to stdout (ah: 02, dl: char)
        int 0x21		; DOS
.end:	ret

prints:	; (AX)->()
        ; print a string to stdout
        ; string start address in AX
        ; string length at [AX-2]

        mov bx, ax
        mov cx, [bx-2]  ; length
        cmp cx, 0
        je  .end
.loop:
        mov dl,[bx]     ; load character
        mov ah,2		; output char to stdout (ah: 02, dl: char)
        int 0x21		; DOS
        inc bx
        loop .loop
.end:	ret

println:; ()->()
        ; put CR LF to stdout

        push ax ; save
        mov ax, .line
        call prints
        pop ax  ; restore
        ret
.size:  dw 2
.line:	db 0x0D, 0x0A

printi: ; (AX)->()
        ; print a signed integer (16 bit) to stdout
        call int2decimal
        call prints
        ret

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
        mov cx, .endbuf-1
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
.end:   mov ax, .endbuf
        sub ax, bx      ; size
        mov [bx-2], ax
        mov ax, bx      ; pointer
        ret

section .data
        dw      0 ; size
.buffer	db		"-", "12345"
.endbuf:
section .text

inputc:	; ()->(AX)
        ; get a char from stdout
        mov ah, 0x3F	; read file
        mov bx, 0       ; filehandle stdin
        mov cx, 1       ; 1 byte
        mov dx, .buf    ; buffer
        int 0x21		; DOS
        jc  .fail       ; error
        cmp ax, 0
        je  .fail       ; EOF
        mov al, [.buf]
        xor ah, ah      ; result one byte
.end:	ret
.fail:  mov ax, -1
        ret

.buf    db 0

inputs: ; ()->(AX)
        ; get string from stdin
        ; user can edit text
        ; max size: len + 1 (CR)
        ; return startaddress
        ; length (16 bit) at startaddress-2
        mov bx, .buff
        mov al, .len
        add al, 1
        mov [bx], al    ; maximum length (8 bit)
        mov dx, bx
        mov ah, 0ah
        int 21h
		mov al, [bx+1]	; actual length (8 bit)
		xor ah, ah		; 0
		mov [bx], ax	; actual length (16 bit)
        mov ax, .buff+2	; result
        ret

section	.data
.len 	equ 80
.buff:	db .len+1	; max size (including CR)
        db 0		; actual size
times .len db 0		; the string
        db 0		; CR (or 0)
section .text


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

copystr:; (AX, BX)->()
        ; copy from a string reference to a string buffer
        ; AX: source
        ; BX: destination
        ; check length
        mov si, ax
        mov di, bx
        mov cx, [si-2]  ; src size
        mov bx, [di-4]  ; dst max size
        cmp cx, bx
        jbe .size_ok
        mov cx, bx      ; cut string
.size_ok:
        mov [di-2], cx  ; size to dst
        cld             ; direction: inc
        rep
        movsb           ; loop copy
        sub bx, 2
        mov [bx], cx    ; size
        ret

compstr:; (AX, BX)->(FLAGS)
        ; compare two strings from two references
        ; AX: first
        ; BX: second
        ; check length
        mov si, ax
        mov di, bx
        mov ax, [si-2]  ; first size
        mov bx, [di-2]  ; second size
        mov cx, ax      ; loop size
        cmp cx, bx
        jbe .size_ok
        mov cx, bx      ; minimum length
.size_ok:
        cld             ; direction: inc
        repe
        cmpsb           ; loop compare
        jne .end
        ; substrings are equal, compare size
        cmp ax, bx
.end:   ret
