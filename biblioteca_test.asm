; deseneaza_imagini proc
	; ;---------------------------------------
	; ; arg1 - simbolul de afisat ("puc alb"->'P', "puc negru"->'Q', "bata"->'B', "ghinda"->'G')(codificari)
	; ; arg2 - pointer la vectorul de pixeli
	; ; arg3 - pos_x
	; ; arg4 - pos_y
	; ;---------------------------------------
	; push EBP
	; mov EBP, ESP
	; ;sub ESP, <dimensiune_variabile_locale> -> ca n-avem variabile locale
	; ; <corpul_procedurii>
	
	; mov eax, [ebp+arg1]
	; cmp eax, 'P'
	; jz et_piesa_A
	; cmp eax, 'Q'
	; jz et_piesa_N
	; cmp eax, 'G'
	; jnz et_podbal
; et_ghinda:
	; ;...
	; jmp somewhere
; et_podbal:
	; ;...
	; jmp somewhere
; et_piesa_A:
	; ;...
	; jmp somewhere
; et_piesa_N:
	; ;...
	
OPEN_FILE macro nume, mod_f
;local etichete
	push offset mod_f
	push offset nume
	call fopen
	add esp, 8
endm
	;jmp automat
	; gata corpul_procedurii
	
	mov ESP, EBP
	pop EBP
	ret [<dimensiune_parametri>]
deseneaza_imagini endp

ornamente macro

endm