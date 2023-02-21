bits 32
section .text

global _keyboard_handler
global _read_port
global _write_port
global _load_idt
global _reboot
global _videomode
global _outb

extern ___driver_kb_keyboard_handler_main

_read_port:
	mov edx, [esp + 4]
	in al, dx
	ret

_write_port:
	mov   edx, [esp + 4]    
	mov   al, [esp + 4 + 4]  
	out   dx, al  
	ret

_load_idt:
	mov edx, [esp + 4]
	lidt [edx]
	sti
	ret

_keyboard_handler:                 
	call    ___driver_kb_keyboard_handler_main
	iretd

_reboot:
WKC:
    xor al, al
    in al, 0x64
    test al, 0x02
    jnz WKC

    mov al, 0xFC
    out 0x64, al

_videomode:
    mov ah,01h
    mov al,13h
    mov ah,0ch
	mov cx,160
	mov dx,100
	mov al,4
	
_outb:
    mov al, [esp + 8]    ; move the data to be sent into the al register
    mov dx, [esp + 4]    ; move the address of the I/O port into the dx register
    out dx, al           ; send the data to the I/O port
    ret   
section .bss
resb 8192; 8KB for stack
stack_space:
