M_amplasare_piese_punkt macro nr_piese, tip_piesa, X, Y, dir, area, area_width
local et_bucla, et_final, pune_numar, final_final
pusha
	mov ecx, 	1
	mov eax, 	Y
	; cmp nr_piese, 0
	; jz final_final
et_bucla:
	make_piesa_macro tip_piesa, area, X, eax
	cmp ecx, 6
	je pune_numar
	add eax, 42*dir		;diametrul unei piese e 40, (deci raza 20), dir e directia: -1 sus, +1 jos
	jmp et_final
pune_numar:
	; mov edx, nr_piese
	; sub edx, ecx ;din numarul total de piese scad cate piese am pus deja
	; inc edx	;acel numar + 1
	; add eax, 10
	; ;transmit pozitiile X si Y cu un deplasament: x+15, y+10 
	; ;ca numarul sa fie reprezentat pe centrul piesei
	; M_pune_numar_pe_piese edx, X+15, eax
	jmp final_final
et_final:	
	inc ecx
	cmp ecx, nr_piese
	jbe et_bucla
final_final:
popa
endm

M_pune_numar_pe_piese macro numar, x, y
local pune_1, pune_2, pune_3, pune_4, pune_5, pune_6, pune_7, pune_8, pune_9, pune_10, final
pusha
	mov edx, numar
	cmp edx, '1'
	je pune_1
	cmp edx, 2
	je pune_2
	cmp edx, 3
	je pune_3
	cmp edx, 4
	je pune_4
	cmp edx, 5
	je pune_5
	cmp edx, 6
	je pune_6
	cmp edx, 7
	je pune_7
	cmp edx, 8
	je pune_8
	cmp edx, 9
	je pune_9
	;cazul ramas e cand edx == 10
	jmp pune_10
pune_1:
	make_text_macro '1', area, x, y
	jmp final
pune_2:
	make_text_macro '2', area, x, y
	jmp final
pune_3:
	make_text_macro '3', area, x, y
	jmp final
pune_4:
	make_text_macro '4', area, x, y
	jmp final
pune_5:
	make_text_macro '5', area, x, y
	jmp final
pune_6:
	make_text_macro '6', area, x, y
	jmp final
pune_7:
	make_text_macro '7', area, x, y
	jmp final
pune_8:
	make_text_macro '8', area, x, y
	jmp final
pune_9:
	make_text_macro '9', area, x, y
	jmp final
pune_10:
	make_text_macro '1', area, x-5, y
	make_text_macro '0', area, x+5, y
final:
popa
endm

M_pre_pune_numar_pe_piese macro Terminate, X, Y
pusha
	mov eax, Terminate
	sub eax, 5
	mov edx, eax
			mov eax, Y
			add eax, 42 * 5 ;(vezi linia 47, amplasare_piese.asm)
			add eax, 10
			;transmit pozitiile X si Y cu un deplasament: x+15, y+10 
			;ca numarul sa fie reprezentat pe centrul piesei
			M_pune_numar_pe_piese edx, X+15, eax
			;call macro pune numere
popa
endm

