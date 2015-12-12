org 100h
mov ax, -1
jmp LBL_main
LBL_prelude:
section .data
    dw 8
DATA_0: db "org 100h"
section .text
push ax
mov ax, DATA_0
call prints
pop ax
call println
section .data
    dw 10
DATA_1: db "mov ax, -1"
section .text
push ax
mov ax, DATA_1
call prints
pop ax
call println
ret
LBL_end:
section .data
    dw 13
DATA_2: db "mov ax,0x4c00"
section .text
push ax
mov ax, DATA_2
call prints
pop ax
call println
section .data
    dw 8
DATA_3: db "int 0x21"
section .text
push ax
mov ax, DATA_3
call prints
pop ax
call println
ret
LBL_getChar:
push ax
call inputc
mov [INT_nextChar], ax
pop ax
ret
LBL_skipSpaces:
push ax
mov ax, [INT_nextChar]
push ax
mov ax,0
pop bx
cmp bx, ax
pop ax
jl LBL_skip.e
push ax
mov ax, [INT_nextChar]
push ax
mov ax,32
pop bx
cmp bx, ax
pop ax
jg LBL_skip.e
call LBL_getChar
jmp LBL_skipSpaces
LBL_skip.e:
ret
LBL_skipLine:
push ax
mov ax, [INT_nextChar]
push ax
mov ax,0
pop bx
cmp bx, ax
pop ax
jl LBL_skl.e
push ax
mov ax, [INT_nextChar]
push ax
mov ax,10
pop bx
cmp bx, ax
pop ax
je LBL_skl.e
push ax
mov ax, [INT_nextChar]
push ax
mov ax,13
pop bx
cmp bx, ax
pop ax
je LBL_skl.e
call LBL_getChar
jmp LBL_skipLine
LBL_skl.e:
ret
LBL_getWord:
call LBL_skipSpaces
push ax
mov ax,0
mov [INT_wordI], ax
pop ax
push ax
mov ax,0
mov [INT_isString], ax
pop ax
push ax
mov ax, [INT_nextChar]
push ax
mov ax,59
pop bx
cmp bx, ax
pop ax
je LBL_word.c
push ax
mov ax, [INT_nextChar]
push ax
mov ax,34
pop bx
cmp bx, ax
pop ax
je LBL_word.s
LBL_word.l:
push ax
mov ax, [INT_nextChar]
push ax
mov ax,32
pop bx
cmp bx, ax
pop ax
jle LBL_word.e
push ax
mov ax, [INT_nextChar]
push ax
mov ax, [INT_wordI]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_wordI], ax
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,100
pop bx
cmp bx, ax
pop ax
jge LBL_word.e
call LBL_getChar
jmp LBL_word.l
LBL_word.s:
push ax
mov ax, [INT_nextChar]
push ax
mov ax, [INT_wordI]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_wordI], ax
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,100
pop bx
cmp bx, ax
pop ax
jge LBL_word.e
call LBL_getChar
push ax
mov ax, [INT_nextChar]
push ax
mov ax,34
pop bx
cmp bx, ax
pop ax
je LBL_word.get
push ax
mov ax, [INT_nextChar]
push ax
mov ax,10
pop bx
cmp bx, ax
pop ax
je LBL_word.se
push ax
mov ax, [INT_nextChar]
push ax
mov ax,13
pop bx
cmp bx, ax
pop ax
je LBL_word.se
push ax
mov ax, [INT_nextChar]
push ax
mov ax,1
neg ax
pop bx
cmp bx, ax
pop ax
je LBL_word.se
jmp LBL_word.s
LBL_word.get:
call LBL_getChar
LBL_word.se:
push ax
mov ax,1
mov [INT_isString], ax
pop ax
jmp LBL_word.e
LBL_word.c:
push ax
mov ax, [INT_nextChar]
push ax
mov ax, [INT_wordI]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_wordI], ax
pop ax
call LBL_skipLine
LBL_word.e:
push ax
mov ax, [INT_wordI]
push ax
mov ax,0
push ax
mov ax, STR_lastWord
push ax
mov ax,2
mov bx, ax
pop ax
sub ax, bx
mov bx, ax
pop si
shl si, 1
pop ax
mov [bx+si], ax
pop ax
ret
LBL_isInteger:
push ax
mov ax,0
mov [INT_isInteger], ax
pop ax
push ax
mov ax,0
mov [INT_i], ax
pop ax
LBL_isi.l:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,48
pop bx
cmp bx, ax
pop ax
jl LBL_isi.e
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,57
pop bx
cmp bx, ax
pop ax
jg LBL_isi.e
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_wordI]
pop bx
cmp bx, ax
pop ax
jl LBL_isi.l
push ax
mov ax,1
mov [INT_isInteger], ax
pop ax
LBL_isi.e:
ret
LBL_isName:
push ax
mov ax,0
mov [INT_isName], ax
pop ax
push ax
mov ax,0
mov [INT_i], ax
pop ax
jmp LBL_isn.l
LBL_isn.d:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,48
pop bx
cmp bx, ax
pop ax
jl LBL_isn.l
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,57
pop bx
cmp bx, ax
pop ax
jg LBL_isn.l
jmp LBL_isn.ok
LBL_isn.l:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,97
pop bx
cmp bx, ax
pop ax
jl LBL_isn.u
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,122
pop bx
cmp bx, ax
pop ax
jg LBL_isn.u
jmp LBL_isn.ok
LBL_isn.u:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,65
pop bx
cmp bx, ax
pop ax
jl LBL_isn.e
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,90
pop bx
cmp bx, ax
pop ax
jg LBL_isn.e
LBL_isn.ok:
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_wordI]
pop bx
cmp bx, ax
pop ax
jl LBL_isn.d
push ax
mov ax,1
mov [INT_isName], ax
pop ax
LBL_isn.e:
ret
LBL_newVar:
push ax
mov ax,0
push ax
mov ax, STR_varNames
push ax
mov ax,2
mov bx, ax
pop ax
sub ax, bx
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
mov [INT_oldSize], ax
pop ax
push ax
mov ax, [INT_oldSize]
push ax
mov ax,4
mov bx, ax
pop ax
add ax, bx
push ax
mov ax, [INT_wordI]
mov bx, ax
pop ax
add ax, bx
push ax
push ax
mov ax,0
push ax
mov ax, STR_varNames
push ax
mov ax,4
mov bx, ax
pop ax
sub ax, bx
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
pop bx
cmp bx, ax
pop ax
jg LBL_errSymbolsFull
push ax
mov ax,0
push ax
mov ax, STR_varNames
push ax
mov ax,2
mov bx, ax
pop ax
sub ax, bx
mov bx, ax
pop si
shl si, 1
pop ax
mov [bx+si], ax
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,0
push ax
mov ax, STR_varNames
push ax
mov ax, [INT_oldSize]
mov bx, ax
pop ax
add ax, bx
mov bx, ax
pop si
shl si, 1
pop ax
mov [bx+si], ax
pop ax
push ax
mov ax,0
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_oldSize]
push ax
mov ax,4
mov bx, ax
pop ax
add ax, bx
mov [INT_dest], ax
pop ax
LBL_newVar.l:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax, [INT_dest]
push ax
mov ax, [INT_i]
mov bx, ax
pop ax
add ax, bx
push ax
mov ax, STR_varNames
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_wordI]
pop bx
cmp bx, ax
pop ax
jl LBL_newVar.l
push ax
mov ax, [INT_wordI]
push ax
mov ax,0
push ax
mov ax, STR_varNames
push ax
mov ax, [INT_oldSize]
mov bx, ax
pop ax
add ax, bx
push ax
mov ax,2
mov bx, ax
pop ax
add ax, bx
mov bx, ax
pop si
shl si, 1
pop ax
mov [bx+si], ax
pop ax
push ax
mov ax, [INT_oldSize]
push ax
mov ax,4
mov bx, ax
pop ax
add ax, bx
push ax
mov ax, [INT_varXLen]
push ax
mov ax, ARR_varX
mov bx, ax
pop si
shl si, 1
pop ax
mov [bx+si], ax
pop ax
push ax
mov ax, [INT_varXLen]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_varXLen], ax
pop ax
ret
LBL_errSymbolsFull:
section .data
    dw 27
DATA_4: db "ERROR: symbol table is full"
section .text
push ax
mov ax, DATA_4
call prints
pop ax
call println
section .data
    dw 17
DATA_5: db "DEBUG: lastWord: "
section .text
push ax
mov ax, DATA_5
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
jmp LBL__end
LBL_getType:
push ax
mov ax,0
mov [CHR_type], al
pop ax
push ax
mov ax,0
mov [INT_i], ax
pop ax
LBL_gt.l:
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_varX
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
push ax
mov ax, STR_varNames
mov bx, ax
pop ax
add ax, bx
push ax
mov ax, STR_lastWord
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gt.f
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_varXLen]
pop bx
cmp bx, ax
pop ax
jl LBL_gt.l
jmp LBL_gt.e
LBL_gt.f:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
mov [CHR_type], al
pop ax
LBL_gt.e:
ret
LBL_genName:
call LBL_getType
push ax
mov al, [CHR_type]
xor ah, ah
push ax
mov ax,1
pop bx
cmp bx, ax
pop ax
je LBL_getInt
push ax
mov al, [CHR_type]
xor ah, ah
push ax
mov ax,2
pop bx
cmp bx, ax
pop ax
je LBL_getChr
push ax
mov al, [CHR_type]
xor ah, ah
push ax
mov ax,11
pop bx
cmp bx, ax
pop ax
je LBL_getArrRef
push ax
mov al, [CHR_type]
xor ah, ah
push ax
mov ax,12
pop bx
cmp bx, ax
pop ax
je LBL_getStrRef
section .data
    dw 7
DATA_6: db "ERROR: "
section .text
push ax
mov ax, DATA_6
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
section .data
    dw 16
DATA_7: db " is not declared"
section .text
push ax
mov ax, DATA_7
call prints
pop ax
call println
ret
LBL_getInt:
call LBL_pushAX
call LBL_movAX
section .data
    dw 6
DATA_8: db " [INT_"
section .text
push ax
mov ax, DATA_8
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
push ax
mov ax,93
call printc
pop ax
call println
ret
LBL_getChr:
call LBL_pushAX
section .data
    dw 13
DATA_9: db "mov al, [CHR_"
section .text
push ax
mov ax, DATA_9
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
push ax
mov ax,93
call printc
pop ax
call println
jmp LBL_xorAHAH
LBL_getArrRef:
call LBL_pushAX
call LBL_movAX
section .data
    dw 5
DATA_10: db " ARR_"
section .text
push ax
mov ax, DATA_10
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_getStrRef:
call LBL_pushAX
call LBL_movAX
section .data
    dw 5
DATA_11: db " STR_"
section .text
push ax
mov ax, DATA_11
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_generate:
push ax
mov ax, [INT_wordI]
push ax
mov ax,0
pop bx
cmp bx, ax
pop ax
je LBL_generate.e
push ax
mov ax, [INT_isString]
push ax
mov ax,1
pop bx
cmp bx, ax
pop ax
je LBL_gPushString
call LBL_isInteger
push ax
mov ax, [INT_isInteger]
push ax
mov ax,1
pop bx
cmp bx, ax
pop ax
je LBL_gPushInt
push ax
mov ax,0
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
mov [CHR_c0], al
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,1
pop bx
cmp bx, ax
pop ax
jg LBL_generate.2
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,59
pop bx
cmp bx, ax
pop ax
je LBL_generate.e
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,46
pop bx
cmp bx, ax
pop ax
je LBL_gPrintI
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,43
pop bx
cmp bx, ax
pop ax
je LBL_gAddI
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,45
pop bx
cmp bx, ax
pop ax
je LBL_gSubI
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,42
pop bx
cmp bx, ax
pop ax
je LBL_gMulI
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,47
pop bx
cmp bx, ax
pop ax
je LBL_gDivI
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,126
pop bx
cmp bx, ax
pop ax
je LBL_negAX
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,35
pop bx
cmp bx, ax
pop ax
je LBL_declInt
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,58
pop bx
cmp bx, ax
pop ax
je LBL_gLabel
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,61
pop bx
cmp bx, ax
pop ax
je LBL_gE
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,60
pop bx
cmp bx, ax
pop ax
je LBL_gL
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,62
pop bx
cmp bx, ax
pop ax
je LBL_gG
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,63
pop bx
cmp bx, ax
pop ax
je LBL_gInI
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,33
pop bx
cmp bx, ax
pop ax
je LBL_gSetIntArr
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,64
pop bx
cmp bx, ax
pop ax
je LBL_gGetIntArr
LBL_generate.2:
push ax
mov ax,1
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
mov [CHR_c1], al
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,2
pop bx
cmp bx, ax
pop ax
jg LBL_generate.3
push ax
mov al, [CHR_c0]
xor ah, ah
push ax
mov ax,39
pop bx
cmp bx, ax
pop ax
je LBL_pushChar
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_12: db ".c"
section .text
push ax
mov ax, DATA_12
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gPrintC
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_13: db ".s"
section .text
push ax
mov ax, DATA_13
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gPrintS
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_14: db ".n"
section .text
push ax
mov ax, DATA_14
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gPrintLn
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_15: db "->"
section .text
push ax
mov ax, DATA_15
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gSetVar
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_16: db "if"
section .text
push ax
mov ax, DATA_16
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gIf
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_17: db "<="
section .text
push ax
mov ax, DATA_17
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gLE
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_18: db ">="
section .text
push ax
mov ax, DATA_18
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gGE
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_19: db "<>"
section .text
push ax
mov ax, DATA_19
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gNE
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_20: db "##"
section .text
push ax
mov ax, DATA_20
mov bx, ax
pop ax
call compstr
pop ax
je LBL_declArr
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_21: db "#s"
section .text
push ax
mov ax, DATA_21
mov bx, ax
pop ax
call compstr
pop ax
je LBL_declStr
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_22: db "#c"
section .text
push ax
mov ax, DATA_22
mov bx, ax
pop ax
call compstr
pop ax
je LBL_declChr
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_23: db "!s"
section .text
push ax
mov ax, DATA_23
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gSetChrArr
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_24: db "@s"
section .text
push ax
mov ax, DATA_24
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gGetChrArr
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_25: db "%%"
section .text
push ax
mov ax, DATA_25
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gRefSize
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_26: db "?s"
section .text
push ax
mov ax, DATA_26
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gInS
push ax
mov ax, STR_lastWord
section .data
    dw 2
DATA_27: db "?c"
section .text
push ax
mov ax, DATA_27
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gInC
LBL_generate.3:
push ax
mov ax,2
push ax
mov ax, STR_lastWord
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
mov [CHR_c2], al
pop ax
push ax
mov ax, [INT_wordI]
push ax
mov ax,3
pop bx
cmp bx, ax
pop ax
jg LBL_generate.4
push ax
mov ax, STR_lastWord
section .data
    dw 3
DATA_28: db "dup"
section .text
push ax
mov ax, DATA_28
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gDup
push ax
mov ax, STR_lastWord
section .data
    dw 3
DATA_29: db "ifs"
section .text
push ax
mov ax, DATA_29
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gCompStr
push ax
mov ax, STR_lastWord
section .data
    dw 3
DATA_30: db "->>"
section .text
push ax
mov ax, DATA_30
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gCopyStr
push ax
mov ax, STR_lastWord
section .data
    dw 3
DATA_31: db "s2i"
section .text
push ax
mov ax, DATA_31
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gS2I
LBL_generate.4:
push ax
mov ax, STR_lastWord
section .data
    dw 4
DATA_32: db "swap"
section .text
push ax
mov ax, DATA_32
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gSwap
push ax
mov ax, STR_lastWord
section .data
    dw 4
DATA_33: db "drop"
section .text
push ax
mov ax, DATA_33
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gDrop
push ax
mov ax, STR_lastWord
section .data
    dw 4
DATA_34: db "goto"
section .text
push ax
mov ax, DATA_34
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gGoto
push ax
mov ax, STR_lastWord
section .data
    dw 5
DATA_35: db "gosub"
section .text
push ax
mov ax, DATA_35
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gGosub
push ax
mov ax, STR_lastWord
section .data
    dw 6
DATA_36: db "return"
section .text
push ax
mov ax, DATA_36
mov bx, ax
pop ax
call compstr
pop ax
je LBL_gReturn
call LBL_isName
push ax
mov ax, [INT_isName]
push ax
mov ax,1
pop bx
cmp bx, ax
pop ax
je LBL_genName
section .data
    dw 9
DATA_37: db "UNKNOWN: "
section .text
push ax
mov ax, DATA_37
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
LBL_generate.e:
ret
LBL_declInt:
call LBL_getWord
call LBL_newVar
push ax
mov ax,1
push ax
mov ax, [INT_varXLen]
push ax
mov ax,1
mov bx, ax
pop ax
sub ax, bx
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
ret
LBL_declChr:
call LBL_getWord
call LBL_newVar
push ax
mov ax,2
push ax
mov ax, [INT_varXLen]
push ax
mov ax,1
mov bx, ax
pop ax
sub ax, bx
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
ret
LBL_declArr:
call LBL_getWord
call LBL_newVar
push ax
mov ax,11
push ax
mov ax, [INT_varXLen]
push ax
mov ax,1
mov bx, ax
pop ax
sub ax, bx
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
call LBL_getWord
push ax
mov ax, STR_lastWord
call s2int
push ax
mov ax, [INT_varXLen]
push ax
mov ax,1
mov bx, ax
pop ax
sub ax, bx
push ax
mov ax, ARR_arrSizes
mov bx, ax
pop si
shl si, 1
pop ax
mov [bx+si], ax
pop ax
ret
LBL_declStr:
call LBL_getWord
call LBL_newVar
push ax
mov ax,12
push ax
mov ax, [INT_varXLen]
push ax
mov ax,1
mov bx, ax
pop ax
sub ax, bx
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
pop ax
mov [bx+si], al
pop ax
call LBL_getWord
push ax
mov ax, STR_lastWord
call s2int
push ax
mov ax, [INT_varXLen]
push ax
mov ax,1
mov bx, ax
pop ax
sub ax, bx
push ax
mov ax, ARR_arrSizes
mov bx, ax
pop si
shl si, 1
pop ax
mov [bx+si], ax
pop ax
ret
LBL_pushChar:
call LBL_pushAX
call LBL_movAX
push ax
mov al, [CHR_c1]
xor ah, ah
call printi
pop ax
call println
ret
LBL_gDup:
jmp LBL_pushAX
LBL_gDrop:
jmp LBL_popAX
LBL_gSwap:
call LBL_movBXAX
call LBL_popAX
jmp LBL_pushBX
LBL_gPushInt:
call LBL_pushAX
call LBL_movAX
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gPushString:
call LBL_sectionData
call LBL_dataW
push ax
mov ax, [INT_wordI]
push ax
mov ax,1
mov bx, ax
pop ax
sub ax, bx
call printi
pop ax
call println
section .data
    dw 5
DATA_38: db "DATA_"
section .text
push ax
mov ax, DATA_38
call prints
pop ax
push ax
mov ax, [INT_dataCount]
call printi
pop ax
section .data
    dw 5
DATA_39: db ": db "
section .text
push ax
mov ax, DATA_39
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
push ax
mov ax,34
call printc
pop ax
call println
call LBL_sectionText
call LBL_pushAX
call LBL_movAX
section .data
    dw 6
DATA_40: db " DATA_"
section .text
push ax
mov ax, DATA_40
call prints
pop ax
push ax
mov ax, [INT_dataCount]
call printi
pop ax
call println
push ax
mov ax, [INT_dataCount]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_dataCount], ax
pop ax
ret
LBL_gPrintC:
section .data
    dw 11
DATA_41: db "call printc"
section .text
push ax
mov ax, DATA_41
call prints
pop ax
call println
jmp LBL_popAX
LBL_gPrintS:
section .data
    dw 11
DATA_42: db "call prints"
section .text
push ax
mov ax, DATA_42
call prints
pop ax
call println
jmp LBL_popAX
LBL_gPrintI:
section .data
    dw 11
DATA_43: db "call printi"
section .text
push ax
mov ax, DATA_43
call prints
pop ax
call println
jmp LBL_popAX
LBL_gPrintLn:
section .data
    dw 12
DATA_44: db "call println"
section .text
push ax
mov ax, DATA_44
call prints
pop ax
call println
ret
LBL_gS2I:
section .data
    dw 10
DATA_45: db "call s2int"
section .text
push ax
mov ax, DATA_45
call prints
pop ax
call println
ret
LBL_gAddI:
call LBL_movBXAX
call LBL_popAX
section .data
    dw 10
DATA_46: db "add ax, bx"
section .text
push ax
mov ax, DATA_46
call prints
pop ax
call println
ret
LBL_gSubI:
call LBL_movBXAX
call LBL_popAX
section .data
    dw 10
DATA_47: db "sub ax, bx"
section .text
push ax
mov ax, DATA_47
call prints
pop ax
call println
ret
LBL_gMulI:
call LBL_movBXAX
call LBL_popAX
section .data
    dw 11
DATA_48: db "imul ax, bx"
section .text
push ax
mov ax, DATA_48
call prints
pop ax
call println
ret
LBL_gDivI:
call LBL_movBXAX
call LBL_popAX
section .data
    dw 3
DATA_49: db "cwd"
section .text
push ax
mov ax, DATA_49
call prints
pop ax
call println
section .data
    dw 7
DATA_50: db "idiv bx"
section .text
push ax
mov ax, DATA_50
call prints
pop ax
call println
ret
LBL_gCopyStr:
call LBL_movBXAX
call LBL_popAX
section .data
    dw 12
DATA_51: db "call copystr"
section .text
push ax
mov ax, DATA_51
call prints
pop ax
call println
jmp LBL_popAX
LBL_gCompStr:
call LBL_movBXAX
call LBL_popAX
section .data
    dw 12
DATA_52: db "call compstr"
section .text
push ax
mov ax, DATA_52
call prints
pop ax
call println
jmp LBL_popAX
LBL_gSetVar:
call LBL_getWord
call LBL_getType
push ax
mov al, [CHR_type]
xor ah, ah
push ax
mov ax,0
pop bx
cmp bx, ax
pop ax
je LBL_sv.n
push ax
mov al, [CHR_type]
xor ah, ah
push ax
mov ax,1
pop bx
cmp bx, ax
pop ax
je LBL_gSetInt
push ax
mov al, [CHR_type]
xor ah, ah
push ax
mov ax,2
pop bx
cmp bx, ax
pop ax
je LBL_gSetChr
section .data
    dw 28
DATA_53: db "ERROR Type not implemented: "
section .text
push ax
mov ax, DATA_53
call prints
pop ax
push ax
mov al, [CHR_type]
xor ah, ah
call printi
pop ax
call println
jmp LBL__end
LBL_sv.n:
section .data
    dw 28
DATA_54: db "ERROR Variable not defined: "
section .text
push ax
mov ax, DATA_54
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
jmp LBL__end
LBL_gSetInt:
section .data
    dw 9
DATA_55: db "mov [INT_"
section .text
push ax
mov ax, DATA_55
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
section .data
    dw 5
DATA_56: db "], ax"
section .text
push ax
mov ax, DATA_56
call prints
pop ax
call println
call LBL_popAX
ret
LBL_gSetChr:
section .data
    dw 9
DATA_57: db "mov [CHR_"
section .text
push ax
mov ax, DATA_57
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
section .data
    dw 5
DATA_58: db "], al"
section .text
push ax
mov ax, DATA_58
call prints
pop ax
call println
call LBL_popAX
ret
LBL_gSetIntArr:
call LBL_movBXAX
call LBL_popSI
call LBL_shlSI1
call LBL_popAX
section .data
    dw 15
DATA_59: db "mov [bx+si], ax"
section .text
push ax
mov ax, DATA_59
call prints
pop ax
call println
jmp LBL_popAX
LBL_gSetChrArr:
call LBL_movBXAX
call LBL_popSI
call LBL_popAX
section .data
    dw 15
DATA_60: db "mov [bx+si], al"
section .text
push ax
mov ax, DATA_60
call prints
pop ax
call println
jmp LBL_popAX
LBL_gGetIntArr:
call LBL_movBXAX
call LBL_popSI
call LBL_shlSI1
section .data
    dw 15
DATA_61: db "mov ax, [bx+si]"
section .text
push ax
mov ax, DATA_61
call prints
pop ax
call println
ret
LBL_gGetChrArr:
call LBL_movBXAX
call LBL_popSI
section .data
    dw 15
DATA_62: db "mov al, [bx+si]"
section .text
push ax
mov ax, DATA_62
call prints
pop ax
call println
jmp LBL_xorAHAH
LBL_gLabel:
call LBL_getWord
section .data
    dw 4
DATA_63: db "LBL_"
section .text
push ax
mov ax, DATA_63
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
push ax
mov ax,58
call printc
pop ax
call println
ret
LBL_gGoto:
call LBL_getWord
section .data
    dw 8
DATA_64: db "jmp LBL_"
section .text
push ax
mov ax, DATA_64
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gGosub:
call LBL_getWord
section .data
    dw 9
DATA_65: db "call LBL_"
section .text
push ax
mov ax, DATA_65
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gReturn:
section .data
    dw 3
DATA_66: db "ret"
section .text
push ax
mov ax, DATA_66
call prints
pop ax
call println
ret
LBL_gIf:
call LBL_popBX
call LBL_cmpBXAX
jmp LBL_popAX
LBL_gE:
call LBL_getWord
section .data
    dw 7
DATA_67: db "je LBL_"
section .text
push ax
mov ax, DATA_67
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gL:
call LBL_getWord
section .data
    dw 7
DATA_68: db "jl LBL_"
section .text
push ax
mov ax, DATA_68
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gG:
call LBL_getWord
section .data
    dw 7
DATA_69: db "jg LBL_"
section .text
push ax
mov ax, DATA_69
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gLE:
call LBL_getWord
section .data
    dw 8
DATA_70: db "jle LBL_"
section .text
push ax
mov ax, DATA_70
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gGE:
call LBL_getWord
section .data
    dw 8
DATA_71: db "jge LBL_"
section .text
push ax
mov ax, DATA_71
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gNE:
call LBL_getWord
section .data
    dw 8
DATA_72: db "jne LBL_"
section .text
push ax
mov ax, DATA_72
call prints
pop ax
push ax
mov ax, STR_lastWord
call prints
pop ax
call println
ret
LBL_gInI:
call LBL_pushAX
section .data
    dw 11
DATA_73: db "call inputi"
section .text
push ax
mov ax, DATA_73
call prints
pop ax
call println
ret
LBL_gInC:
call LBL_pushAX
section .data
    dw 11
DATA_74: db "call inputc"
section .text
push ax
mov ax, DATA_74
call prints
pop ax
call println
ret
LBL_gInS:
call LBL_pushAX
section .data
    dw 11
DATA_75: db "call inputs"
section .text
push ax
mov ax, DATA_75
call prints
pop ax
call println
section .data
    dw 12
DATA_76: db "call println"
section .text
push ax
mov ax, DATA_76
call prints
pop ax
call println
ret
LBL_gRefSize:
call LBL_movBXAX
call LBL_movAX
section .data
    dw 7
DATA_77: db " [bx-2]"
section .text
push ax
mov ax, DATA_77
call prints
pop ax
call println
ret
LBL_pushAX:
section .data
    dw 7
DATA_78: db "push ax"
section .text
push ax
mov ax, DATA_78
call prints
pop ax
call println
ret
LBL_popAX:
section .data
    dw 6
DATA_79: db "pop ax"
section .text
push ax
mov ax, DATA_79
call prints
pop ax
call println
ret
LBL_pushBX:
section .data
    dw 7
DATA_80: db "push bx"
section .text
push ax
mov ax, DATA_80
call prints
pop ax
call println
ret
LBL_popBX:
section .data
    dw 6
DATA_81: db "pop bx"
section .text
push ax
mov ax, DATA_81
call prints
pop ax
call println
ret
LBL_popSI:
section .data
    dw 6
DATA_82: db "pop si"
section .text
push ax
mov ax, DATA_82
call prints
pop ax
call println
ret
LBL_negAX:
section .data
    dw 6
DATA_83: db "neg ax"
section .text
push ax
mov ax, DATA_83
call prints
pop ax
call println
ret
LBL_shlSI1:
section .data
    dw 9
DATA_84: db "shl si, 1"
section .text
push ax
mov ax, DATA_84
call prints
pop ax
call println
ret
LBL_movAX:
section .data
    dw 7
DATA_85: db "mov ax,"
section .text
push ax
mov ax, DATA_85
call prints
pop ax
ret
LBL_movBXAX:
section .data
    dw 10
DATA_86: db "mov bx, ax"
section .text
push ax
mov ax, DATA_86
call prints
pop ax
call println
ret
LBL_cmpBXAX:
section .data
    dw 10
DATA_87: db "cmp bx, ax"
section .text
push ax
mov ax, DATA_87
call prints
pop ax
call println
ret
LBL_xorAHAH:
section .data
    dw 10
DATA_88: db "xor ah, ah"
section .text
push ax
mov ax, DATA_88
call prints
pop ax
call println
ret
LBL_sectionData:
section .data
    dw 13
DATA_89: db "section .data"
section .text
push ax
mov ax, DATA_89
call prints
pop ax
call println
ret
LBL_sectionText:
section .data
    dw 13
DATA_90: db "section .text"
section .text
push ax
mov ax, DATA_90
call prints
pop ax
call println
ret
LBL_dataB:
section .data
    dw 7
DATA_91: db "    db "
section .text
push ax
mov ax, DATA_91
call prints
pop ax
ret
LBL_dataW:
section .data
    dw 7
DATA_92: db "    dw "
section .text
push ax
mov ax, DATA_92
call prints
pop ax
ret
LBL_printIntSyms:
section .data
    dw 16
DATA_93: db "DEBUG int vars: "
section .text
push ax
mov ax, DATA_93
call prints
pop ax
push ax
mov ax, STR_varNames
call prints
pop ax
call println
push ax
mov ax,0
mov [INT_i], ax
pop ax
LBL_sym.l:
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_varX
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
push ax
call printi
pop ax
push ax
mov ax,32
call printc
pop ax
push ax
mov ax, STR_varNames
mov bx, ax
pop ax
add ax, bx
call prints
pop ax
call println
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_varXLen]
pop bx
cmp bx, ax
pop ax
jl LBL_sym.l
ret
LBL_gVarsAndArrays:
push ax
mov ax, [INT_varXLen]
push ax
mov ax,0
pop bx
cmp bx, ax
pop ax
je LBL_vaa.e
section .data
    dw 13
DATA_94: db "section .data"
section .text
push ax
mov ax, DATA_94
call prints
pop ax
call println
call LBL_gIntSpace
call LBL_gChrSpace
call LBL_gArrSpace
call LBL_gStrSpace
section .data
    dw 13
DATA_95: db "section .text"
section .text
push ax
mov ax, DATA_95
call prints
pop ax
call println
LBL_vaa.e:
ret
LBL_gIntSpace:
push ax
mov ax,0
mov [INT_i], ax
pop ax
LBL_gis:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,1
pop bx
cmp bx, ax
pop ax
jne LBL_gis.n
section .data
    dw 4
DATA_96: db "INT_"
section .text
push ax
mov ax, DATA_96
call prints
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_varX
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
push ax
mov ax, STR_varNames
mov bx, ax
pop ax
add ax, bx
call prints
pop ax
section .data
    dw 6
DATA_97: db ": dw 0"
section .text
push ax
mov ax, DATA_97
call prints
pop ax
call println
LBL_gis.n:
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_varXLen]
pop bx
cmp bx, ax
pop ax
jl LBL_gis
ret
LBL_gChrSpace:
push ax
mov ax,0
mov [INT_i], ax
pop ax
LBL_gcs:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,2
pop bx
cmp bx, ax
pop ax
jne LBL_gcs.n
section .data
    dw 4
DATA_98: db "CHR_"
section .text
push ax
mov ax, DATA_98
call prints
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_varX
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
push ax
mov ax, STR_varNames
mov bx, ax
pop ax
add ax, bx
call prints
pop ax
section .data
    dw 6
DATA_99: db ": db 0"
section .text
push ax
mov ax, DATA_99
call prints
pop ax
call println
LBL_gcs.n:
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_varXLen]
pop bx
cmp bx, ax
pop ax
jl LBL_gcs
ret
LBL_gArrSpace:
push ax
mov ax,0
mov [INT_i], ax
pop ax
LBL_gas:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,11
pop bx
cmp bx, ax
pop ax
jne LBL_gas.n
section .data
    dw 4
DATA_100: db "ARR_"
section .text
push ax
mov ax, DATA_100
call prints
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_varX
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
push ax
mov ax, STR_varNames
mov bx, ax
pop ax
add ax, bx
call prints
pop ax
section .data
    dw 8
DATA_101: db ": times "
section .text
push ax
mov ax, DATA_101
call prints
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_arrSizes
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
call printi
pop ax
section .data
    dw 5
DATA_102: db " dw 0"
section .text
push ax
mov ax, DATA_102
call prints
pop ax
call println
LBL_gas.n:
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_varXLen]
pop bx
cmp bx, ax
pop ax
jl LBL_gas
ret
LBL_gStrSpace:
push ax
mov ax,0
mov [INT_i], ax
pop ax
LBL_gss:
push ax
mov ax, [INT_i]
push ax
mov ax, STR_varTypes
mov bx, ax
pop si
mov al, [bx+si]
xor ah, ah
push ax
mov ax,12
pop bx
cmp bx, ax
pop ax
jne LBL_gss.n
section .data
    dw 3
DATA_103: db "dw "
section .text
push ax
mov ax, DATA_103
call prints
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_arrSizes
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
call printi
pop ax
call println
section .data
    dw 4
DATA_104: db "dw 0"
section .text
push ax
mov ax, DATA_104
call prints
pop ax
call println
section .data
    dw 4
DATA_105: db "STR_"
section .text
push ax
mov ax, DATA_105
call prints
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_varX
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
push ax
mov ax, STR_varNames
mov bx, ax
pop ax
add ax, bx
call prints
pop ax
section .data
    dw 8
DATA_106: db ": times "
section .text
push ax
mov ax, DATA_106
call prints
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, ARR_arrSizes
mov bx, ax
pop si
shl si, 1
mov ax, [bx+si]
call printi
pop ax
section .data
    dw 5
DATA_107: db " db 0"
section .text
push ax
mov ax, DATA_107
call prints
pop ax
call println
LBL_gss.n:
push ax
mov ax, [INT_i]
push ax
mov ax,1
mov bx, ax
pop ax
add ax, bx
mov [INT_i], ax
pop ax
push ax
mov ax, [INT_i]
push ax
mov ax, [INT_varXLen]
pop bx
cmp bx, ax
pop ax
jl LBL_gss
ret
LBL_main:
push ax
mov ax,0
mov [INT_dataCount], ax
pop ax
push ax
mov ax,0
mov [INT_varXLen], ax
pop ax
call LBL_prelude
call LBL_getChar
LBL_loop:
call LBL_getWord
push ax
mov ax, STR_lastWord
mov bx, ax
mov ax, [bx-2]
push ax
mov ax,0
pop bx
cmp bx, ax
pop ax
je LBL__end
call LBL_generate
jmp LBL_loop
LBL__end:
call LBL_end
call LBL_gVarsAndArrays
mov ax,0x4c00
int 0x21
section .data
INT_nextChar: dw 0
INT_wordI: dw 0
INT_isString: dw 0
INT_isInteger: dw 0
INT_i: dw 0
INT_isName: dw 0
INT_varXLen: dw 0
INT_oldSize: dw 0
INT_dest: dw 0
INT_dataCount: dw 0
CHR_type: db 0
CHR_c0: db 0
CHR_c1: db 0
CHR_c2: db 0
ARR_varX: times 100 dw 0
ARR_arrSizes: times 100 dw 0
dw 100
dw 0
STR_lastWord: times 100 db 0
dw 100
dw 0
STR_varTypes: times 100 db 0
dw 1200
dw 0
STR_varNames: times 1200 db 0
section .text

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
