; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    in al,61h
    mov ah,al
    or al,00000011b
    out 61h,al
    
    mov cx,33144
    call waitf
    
    mov al,ah
    out 61h,al
    
waitf proc near
    push ax
waitf1:
    in al,61h
    and al,10h
    cmp al,ah
    je waitf1
    mov ah,al
    loop waitf1
    pop ax
    ret
waitf endp

    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
