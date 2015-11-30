section .data
INT_len: dw 0
INT_i: dw 0
CHR_c: db 0
       dw    100
       dw    0
STR_str:   times 100 db 0
section .text
org 100h
mov ax, -1
push ax
call inputs
call println
push ax
mov ax, STR_str
mov bx, ax
pop ax
call copystr
pop ax
push ax
mov ax, STR_str
mov bx, ax
mov ax, [bx-2]
mov [INT_len], ax
pop ax
section .data
    dw 5
DATA_0: db "len: "
section .text
push ax
mov ax, DATA_0
call prints
pop ax
push ax
mov ax, [INT_len]
call printi
pop ax
call println
push ax
mov ax ,0
mov [INT_i], ax
pop ax
LBL_L:
push ax
mov ax, STR_str
push ax
mov ax, [INT_i]
mov bx, ax
pop si
mov al, [bx + si]
xor ah, ah
mov [CHR_c], al
pop ax
push ax
mov al, [CHR_c]
xor ah, ah
call printc
pop ax
call println
push ax
mov ax, [INT_i]
push ax
mov ax ,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_len]
pop bx
cmp bx, ax
pop ax
jl LBL_L
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
.line:	db 0x0A, 0x0D

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
        ret