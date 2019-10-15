bits 16
org 0x7c00

jmp start

strprint:                   ; prints a string loaded into SI to the terminal
	mov ah, 0x0e
.loop:
	lodsb
	cmp al, 0
	je .end
	int 0x10
	jmp .loop
.end:
	ret 

strinput:                   ; takes input from the keyboard and loads it into input_buffer
    mov di, input_buffer
.loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0d            ; if the ENTER key is pressed, exit the input loop
    je .return
    stosb
    mov ah, 0x0e
    int 0x10
    jmp .loop     
.return:
    mov ah, 0x0e            ; enter a newline before returning
    mov al, 0x0a
    int 0x10
    mov al, 0x0d
    int 0x10
    ret

strclear:                   ; clears a string put in DI and with a size stored in BL
    mov al, 0x00
.loop:
    dec bl
    jz .end
    stosb
    jmp .loop
.end:
    ret
    

start:
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov sp, 0x9c00
.loop:
    call strinput
	mov si, input_buffer
    call strprint           ; echo the text input right before
    mov ah, 0x0e
    mov al, 0x0a
    int 0x10
    mov al, 0x0d
    int 0x10
    mov di, input_buffer
    mov bl, input_len
    call strclear
    jmp .loop

string: db "Hello, World!", 0x0a, 0x0d, 0x00
string2: db "NandOS", 0x00

input_buffer times 50 DB ' ', 0x00
input_len equ $-input_buffer
	
times 510-($-$$) db 0
dw 0xaa55
