bits 16
org 0x7c00

jmp start

strprint:           ; prints a string loaded into SI to the terminal
	mov ah, 0x0e
.loop:
	lodsb
	cmp al, 0
	je .end
	int 0x10
	jmp .loop
.end:
	ret 

strinput:           ; takes input from the keyboard and loads it into keyboard_buffer
    mov di, keyboard_buffer
.loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0d
    je .return
    stosb
    mov ah, 0x0e
    int 0x10
    jmp .loop     
.return:
    mov ah, 0x0e
    mov al, 0x0a
    int 0x10
    mov al, 0x0d
    int 0x10
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
	mov si, keyboard_buffer
    call strprint
    mov ah, 0x0e
    mov al, 0x0a
    int 0x10
    mov al, 0x0d
    int 0x10
    jmp .loop

string: db "Hello, World!", 0x0a, 0x0d, 0x00
string2: db "NandOS", 0x00

keyboard_buffer times 50 DB ' ', 0x00
	
times 510-($-$$) db 0
dw 0xaa55
