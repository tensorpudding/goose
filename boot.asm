[BITS 16]
[ORG 0x7C00]
	; We start in 16-bit real mode, fresh from the BIOS
	; We want to first jump into protected mode. 
	; First, we create a Global Descriptor Table
	
get_vesa:
	mov ax, 4F00h
	int 10h			; send interrupt to vesa controller
	cmp 0, ah		; check the flag (00 success)
	jne gdt			; if not success, give up

	mov ax, 4F01h
	mov cx, 106h		; test 1280x1024 at 16bit color
	int 10h
	cmp 4Fh, al
	je print_message
	jmp gdt

print_message:
	mov bx, 106h
	int 10h
	
	
gdt:				; We make three basic tables
gdt_null:			; a null table 
	dq 0			; a code table, and a data table

gdt_code:
	dw 0FFFFh 		; lower 16 bits of limit (4 GB)
	dw 0			; lower 16 bits of base
	db 0			; middle byte of base
	db 09Ah			; access byte
	db 0CFh			; flags + upper limit
	db 0			; upper byte of base

gdt_data:
	dw 0FFFFh 		; lower 16 bits of limit
	dw 0			; lower 16 bits of base
	db 0			; middle byte of base
	db 092h			; access byte
	db 0CFh			; flags + upper limit
	db 0			; upper byte of base

gdt_end:	

gdt_desc:
	db gdt_end - gdt
	dw gdt

load_gdt:
	cli
	xor ax, ax		; clear the ds register through ax
	mov ds, ax
	lgdt [gdt_desc]		; finally loading the GDT

idt:
interrupt_dummy:		; let's create some dummy interrupts
	dw	0x0000
	dw	0x10
	dw	0x8E00
	dw	0x20
interrupt_two:
	dw	0x0000
	dw	0x10
	dw	0x8E00
	dw	0x30
idt_end:
idt_pointer:
	dw idt_end - idt - 1
	dd idt
	
load_idt:
	lidt	[idt_pointer]
enter_pmode:
	mov eax, cr0		; set cr0 to 1, enabling protected mode
	or al, 1
	mov cr0, eax
	jmp 08h:flush		; enter protected mode after far jump

[BITS 32]

flush:
	mov ax, 08h		; now that we are in protected mode, we
	mov ds, ax		; clear the registers 
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	
start:
	
	jmp start

	times 510- ($-$$) db 0 	; fill the remains of the sector with 0
	dw 0xAA55		; add the boot signature at the very end
