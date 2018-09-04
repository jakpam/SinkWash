org 100h

start:
        finit
        mov     al,13h
        int     10h
        push    word 0A000h
        pop     es

        mov cx,256
palloop:
        mov dx,3c8h
        mov ax,cx
        out dx,al
        shr al,2
        inc dx
        out dx,al
        out dx,al
        out dx,al
        loop palloop

mainloop:
        mov     ax, word [frameNo]
        add     ax, 10
        mov     word [frameNo], ax

        xor     di, di
        mov     bx, 200
_loopy:
        mov     ax, word [frameNo]
        add     ax, bx
        mov     word [tmpy],ax
        fild    word [tmpy]
        fild    word [consty]
        fdivp
        fsin

        mov     cx,320
_loopx:
        mov     word [tmpx], cx
        fild    word [tmpx]
        fild    word [constx]
        fdivp
        fadd    st1
        fsin
        fld1
        faddp
        fild    word [tmp1]
        fmulp
        fistp   word [tmp]
        mov     al, byte [tmp]

        mov     byte [es:di],al
        inc     di

        dec     cx
        jnz     _loopx

        fstp    dword [yyy]
        dec     bx
        jnz     _loopy

        call    vsync

        in      al,60h
        dec     al
        jnz     mainloop

        mov     al,03
        int     10h
        ret

vsync:
    mov     dx,03dah
wai1:
    in      al,dx
    test    al,8
    je      wai1
wai2:
    in      al,dx
    test    al,8
    jne     wai2
    ret

tmp     dw 0
tmpx    dw 0
tmpy    dw 0
tmp1    dw 127
tmp2    dw 255
consty  dw 20
constx  dw 10
yyy     dd 0
frameNo dw 0

