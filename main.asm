extern printf
extern exit

; includes
%include "functions.asm"

section .data
	; windowing functionality
	window_width: dd 800
	window_height: dd 600
	window_title: db "3D", 0

	; colors
	WHITE: db 255, 255, 255, 255
	RED: db 255, 0, 0, 255
	GREEN: db 0, 255, 0, 255
	MAROON: db 190, 33, 55, 255
	BLACK: db 0, 0, 0, 255

	; camera
	camera: 
		dd 10.0 
		dd 10.0 
		dd 10.0										; camera position
		dd 0.0 
		dd 0.0 
		dd 0.0										; camera target
		dd 0.0 
		dd 1.0 
		dd 0.0										; camera up
		dd 45.0										; fov
		dd 0										; camera type

	; grid
	grid:
		dd 10
		dd 1.0

	; cube
	cube_position:
		dd 0.0
		dd 0.5
		dd 0.0										; position
	cube_size:
		dd 1.0
		dd 1.0
		dd 1.0										; size

	; text
	text_message:
		db "This is a Cube", 0
	text:
		dd 318
		dd 100
		dd 24

section .text
global main

main:
	push rbp										; allocate new stack frame
	mov	rbp, rsp

	mov	ecx, dword [window_width]				; set ecx to VALUE of window_width
	mov	edx, dword [window_height]				; set edx to VALUE of window_height
	mov	r8, window_title						; set r8 to ADDRESS of window_title
	call InitWindow								; call InitWindow
	
	jmp .render_loop								; jump to .render_jump

.render_loop:
	call WindowShouldClose						; call WindowShouldClose
	test al, al									; test al, against al
	jnz	.main_end								; jump to .main_end, if not equal to zero

	call BeginDrawing							; call BeginDrawing

	mov	ecx, dword [WHITE]						; set ecx to VALUE of WHITE
	call ClearBackground							; call ClearBackground
	
	; ----------------------------------------------------------------------------------------------
	sub	rsp, 48									; allocate 48 bytes
	movd xmm0, dword [camera]					; pos.x
	movd [rsp], dword xmm0
	movd xmm0, dword [camera + 4]				; pos.y
	movd [rsp + 4], dword xmm0	
	movd xmm0, dword [camera + 8]				; pos.z
	movd [rsp + 8], dword xmm0
	movd xmm0, dword [camera + 12]				; t.x
	movd [rsp + 12], dword xmm0	
	movd xmm0, dword [camera + 16]				; t.y
	movd [rsp + 16], dword xmm0	
	movd xmm0, dword [camera + 20]				; t.z
	movd [rsp + 20], dword xmm0	
	movd xmm0, dword [camera + 24]				; up.x
	movd [rsp + 24], dword xmm0	
	movd xmm0, dword [camera + 28]				; up.y
	movd [rsp + 28], dword xmm0	
	movd xmm0, dword [camera + 32]				; up.z
	movd [rsp + 32], dword xmm0	
	movd xmm0, dword [camera + 36]				; fov
	movd [rsp + 36], dword xmm0	
	movd xmm0, dword [camera + 40]				; type
	movd [rsp + 40], dword xmm0	
	lea	rcx, [rsp]								; load effective ADDRESS of rsp into rcx
	call BeginMode3D								; call BeginMode3D
	add	rsp, 48									; deallocate 48 bytes
	
	; ---------------------------------------------------------------------------------------------------
	mov	ecx,  dword [grid]						; set ecx to VALUE of grid
	movd xmm1, dword [grid + 4]					; set edx to VALUE of grid + 4
	call DrawGrid								; call DrawGrid	

	; --------------------------------------------------------------------------------------------------
	sub	rsp, 32									; allocate 32 bytes
	movd xmm0, dword [cube_position]				; position.x
	movd xmm1, dword [cube_position + 4]			; position.y
	movd xmm2, dword [cube_position + 8]			; position.z
	movd [rsp], dword xmm0
	movd [rsp + 4], dword xmm1
	movd [rsp + 8], dword xmm2
	lea	rcx, [rsp]								; move the effective address of rsp into rcx
	movd xmm0, dword [cube_size]					; size.x
	movd xmm1, dword [cube_size + 4]				; size.y
	movd xmm2, dword [cube_size + 8]				; size.z
	movd [rsp + 12], dword xmm0
	movd [rsp + 16], dword xmm1
	movd [rsp + 20], dword xmm2
	lea	rdx, [rsp + 12]							; move the effective address of rsp + 12 into rcx
	mov	r8d, dword [RED]
	call DrawCubeV								; call DrawCubeV
	add	rsp, 32									; deallocate 32 bytes

	; --------------------------------------------------------------------------------------------------
	sub	rsp, 32									; allocate 32 bytes
	movd xmm0, dword [cube_position]				; position.x
	movd xmm1, dword [cube_position + 4]			; position.y
	movd xmm2, dword [cube_position + 8]			; position.z
	movd [rsp], dword xmm0
	movd [rsp + 4], dword xmm1
	movd [rsp + 8], dword xmm2
	lea	rcx, [rsp]								; move the effective address of rsp into rcx
	movd xmm0, dword [cube_size]					; size.x
	movd xmm1, dword [cube_size + 4]				; size.y
	movd xmm2, dword [cube_size + 8]				; size.z
	movd [rsp + 12], dword xmm0
	movd [rsp + 16], dword xmm1
	movd [rsp + 20], dword xmm2
	lea	rdx, [rsp + 12]							; move the effective address of rsp + 12 into rcx
	mov	r8d, dword [MAROON]
	call DrawCubeWiresV							; call DrawCubeWiresV
	add	rsp, 32									; deallocate 32 bytes

	; --------------------------------------------------------------------------------------------------
	call EndMode3D								; call EndMode3D

	; --------------------------------------------------------------------------------------------------
	sub rsp, 32 + 16								; allocate 48 bytes
	lea rcx, [text_message]							; move the effect address of text_message into rcx
	mov edx, dword [text]							; position.x
	mov r8d, dword [text + 4]						; position.y
	mov r9d, dword [text + 8]						; font size
	mov eax, dword [BLACK]							; move BLACK into eax
	mov [rsp + 32], eax								; move eax into [rsp + 32]
	call DrawText									; call DrawText
	add rsp, 32 + 16								; deallocate 48 bytes

	; -------------------------------------------------------------------------------------------------
	call EndDrawing								; call EndDrawing

	jmp	.render_loop							; jump to .render_loop

.main_end:
	call CloseWindow								; call CloseWindow 

	mov	rsp, rbp								; deallocate current stack frame
	pop	rbp

	mov	rax, 0
	ret
