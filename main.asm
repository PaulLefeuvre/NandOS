bits 16
org 0x7c00

jmp start

strprint:
	mov ah, 0x0e
.loop:
	lodsb
	cmp al, 0
	je .end
	int 0x10
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

	mov si, string
	call strprint
	mov si, string2
	call strprint 


string: db "Hello, World!", 0x0a, 0x0d,  0x00
string2: db "NandOS", 0x00
	
times 510-($-$$) db 0
dw 0xaa55
