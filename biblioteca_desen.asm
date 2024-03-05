make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

make_zar_macro macro zar, drawArea, x, y
	push y
	push x
	push drawArea
	push zar
	call make_zaruri
	add esp, 16
endm

make_piesa_macro macro piesa, drawArea, x, y
local fa_piesa_neagra, curata_stiva
	push eax
	mov eax, piesa
	cmp eax, 2
	je fa_piesa_neagra
	pop eax
	push y
	push x
	push drawArea
	push piesa
	call make_piesa_alba
	jmp curata_stiva
fa_piesa_neagra:
	pop eax
	push y
	push x
	push drawArea
	push piesa
	call make_piesa_neagra
curata_stiva:
	add esp, 16
endm

make_podbal_macro macro podbal, drawArea, x, y
	push y
	push x
	push drawArea
	push podbal
	call make_daba
	add esp, 16
endm

m_triunghi_vf_sus macro x, y, lungime_linie, farba, height
local et_triunghi45, et_aceeasi_linie, et_increment
	mov eax,	y				;1.EAX = y
	mov ebx,	area_width
	mul ebx						;2.EAX = y*area_width
	add eax,	x				;3.EAX = y*area_width + x
	shl eax,	2				;4.EAX = (y*area_width + x) * 4
	add eax,	area
	;pregatire for-uri:
	mov ecx, height
	mov edx, 0 ; signal edx in range (1 to lungime_linie)
	mov ebx, lungime_linie
et_triunghi45:
	
et_aceeasi_linie:
	;corp
	inc edx
	shl edx, 2
	mov dword ptr [eax], farba
	sub eax, edx
	mov dword ptr [eax], farba ; pune farba la eax - edx(deplasamentul)
	add eax, edx
	add eax, edx
	mov dword ptr [eax], farba ; 0DAC809h ; pune farba la eax + edx(deplasamentul)
	sub eax, edx
	shr edx, 2
	;acuma sa si umplem
	cmp edx, ebx
	jl et_aceeasi_linie
	;end corp	
	add eax, 4*area_width 
	mov edx, 0
	;incrementam ebx, adica lungime linie, doar daca suntem pe o linie de forma 4k+ceva(adica ecx):
	;test ecx, 01h
	;jnz et_increment
	push eax
	push edx
	mov edx, 0
	mov eax, ecx
	mov esi, 8
	div esi
	cmp edx, 0
	jnz et_increment

	add ebx, 1
et_increment:
	pop edx
	pop eax
	loop et_triunghi45
endm

m_triunghi_vf_jos macro x, y, lungime_linie, farba, height
local et_triunghi45, et_aceeasi_linie, et_increment
	mov eax,	y				;1.EAX = y
	mov ebx,	area_width
	mul ebx						;2.EAX = y*area_width
	add eax,	x				;3.EAX = y*area_width + x
	shl eax,	2				;4.EAX = (y*area_width + x) * 4
	add eax,	area
	;pregatire for-uri:
	mov ecx, height
	mov edx, 0 ; signal edx in range (1 to lungime_linie)
	mov ebx, lungime_linie
et_triunghi45:
	
et_aceeasi_linie:
	;corp
	inc edx
	shl edx, 2
	mov dword ptr [eax], farba
	sub eax, edx
	mov dword ptr [eax], farba ; pune farba la eax - edx(deplasamentul)
	add eax, edx
	add eax, edx
	mov dword ptr [eax], farba ; 0DAC809h ; pune farba la eax + edx(deplasamentul)
	sub eax, edx
	shr edx, 2
	;acuma sa si umplem
	cmp edx, ebx
	jl et_aceeasi_linie
	;end corp	
	sub eax, 4*area_width 
	mov edx, 0
	;incrementam ebx, adica lungime linie, doar daca suntem pe o linie de forma 4k+ceva(adica ecx):
	;test ecx, 01h
	;jnz et_increment
	push eax
	push edx
	mov edx, 0
	mov eax, ecx
	mov esi, 8
	div esi
	cmp edx, 0
	jnz et_increment

	add ebx, 1
et_increment:
	pop edx
	pop eax
	loop et_triunghi45
endm

suprafata_sase_triunghiuri macro farba_1, farba_2, origine
local et_loop, et_par, et_impar, et_final
	;---------------------------------------
	;farba_1 = 0h (negru)
	;farba_2 = 0fda855h (light orange)
	;stas standard y pt triunghiurile de sus (vf in jos) = 300
	;stas standard y pt triunghiurile de jos (vf in sus) = 440
	;stas standard y pt ambele tipuri de triunghiuri = 95
	;stas standard pt lungime_linie = 0
	;stas standard pt height = 230
	;---------------------------------------
	;m_triunghi_vf_jos (x, y, lungime_linie, farba, height)
	;m_triunghi_vf_sus (x, y, lungime_linie, farba, height)
;NU MERGE CODUL DE SMECHERI AJUTOOOR
	; mov ecx, 7
	; mov edi, 95
; et_loop:
	; dec ecx
	; test ecx, 01h
	; jnz et_impar
; et_par:
	; m_triunghi_vf_jos edi, 300, 0, farba_1, 230
	; m_triunghi_vf_sus edi, 440, 0, farba_2, 230
	; jmp et_final
; et_impar:
	; m_triunghi_vf_jos edi, 300, 0, farba_2, 230
	; m_triunghi_vf_sus edi, 440, 0, farba_1, 230
; et_final:
	; add edi, 10
	; cmp ecx, 0
	; jg et_loop
	mov edi, origine
	m_triunghi_vf_jos edi, 300, 0, farba_1, 230
	m_triunghi_vf_sus edi, 440, 0, farba_2, 230
	add edi, 59
	m_triunghi_vf_jos edi, 300, 0, farba_2, 230
	m_triunghi_vf_sus edi, 440, 0, farba_1, 230
	add edi, 59
	m_triunghi_vf_jos edi, 300, 0, farba_1, 230
	m_triunghi_vf_sus edi, 440, 0, farba_2, 230
	add edi, 59
	m_triunghi_vf_jos edi, 300, 0, farba_2, 230
	m_triunghi_vf_sus edi, 440, 0, farba_1, 230
	add edi, 59
	m_triunghi_vf_jos edi, 300, 0, farba_1, 230
	m_triunghi_vf_sus edi, 440, 0, farba_2, 230
	add edi, 59
	m_triunghi_vf_jos edi, 300, 0, farba_2, 230
	m_triunghi_vf_sus edi, 440, 0, farba_1, 230
endm



suprafata_oriz macro x, y, lungime, culoare
local et_bucla
	mov eax,	y				;1.EAX = y
	mov ebx,	area_width
	mul ebx						;2.EAX = y*area_width
	add eax,	x				;3.EAX = y*area_width + x
	shl eax,	2				;4.EAX = (y*area_width + x) * 4
	add eax,	area
	;am obtinut o adresa de inceput la pixelul de la care vrem sa inceapa linia
	mov ecx, lungime
et_bucla:
	mov dword ptr[eax],		culoare
	add eax, 4
	loop et_bucla
endm

suprafata_vert macro x, y, lungime, culoare
local et_bucla
	mov eax,	y				;1.EAX = y
	mov ebx,	area_width
	mul ebx						;2.EAX = y*area_width
	add eax,	x				;3.EAX = y*area_width + x
	shl eax,	2				;4.EAX = (y*area_width + x) * 4
	add eax,	area
	;am obtinut o adresa de inceput la pixelul de la care vrem sa inceapa linia
	mov ecx, lungime
et_bucla:
	mov dword ptr[eax],		culoare
	add eax,	area_width*4
	loop et_bucla
endm

suprafata_de_joc macro
	;indexam fiecare punct (adica triunghi)
	;make_text_macro macro symbol, drawArea, x, y
	make_text_macro '1', area, 808, 40
	make_text_macro '2', area, 747, 40
	make_text_macro '3', area, 687, 40
	make_text_macro '4', area, 623, 40
	make_text_macro '5', area, 562, 40
	make_text_macro '6', area, 503, 40
	make_text_macro '7', area, 383, 40;383,324,272,220
	make_text_macro '8', area, 324, 40
	make_text_macro '9', area, 272, 40
	;de aici devine interesant
	;'10'
	make_text_macro '1', area, 202, 40
	make_text_macro '0', area, 212, 40
	;'11'
	make_text_macro '1', area, 148, 40
	make_text_macro '1', area, 158, 40
	;'12'
	make_text_macro '1', area, 84, 40
	make_text_macro '2', area, 94, 40
	;'13'
	make_text_macro '1', area, 79, 684
	make_text_macro '3', area, 89, 684
	;'14'
	make_text_macro '1', area, 135, 684
	make_text_macro '4', area, 145, 684
	;'15'
	make_text_macro '1', area, 199, 684
	make_text_macro '5', area, 209, 684
	;'16'
	make_text_macro '1', area, 256, 684
	make_text_macro '6', area, 266, 684
	;'17'
	make_text_macro '1', area, 317, 684
	make_text_macro '7', area, 327, 684
	;'18'
	make_text_macro '1', area, 379, 684
	make_text_macro '8', area, 389, 684
	;'19'
	make_text_macro '1', area, 495, 684
	make_text_macro '9', area, 505, 684
	;'20'
	make_text_macro '2', area, 556, 684
	make_text_macro '0', area, 566, 684
	;'21'
	make_text_macro '2', area, 614, 684
	make_text_macro '1', area, 624, 684
	;'22'
	make_text_macro '2', area, 675, 684
	make_text_macro '2', area, 685, 684
	;'23'
	make_text_macro '2', area, 731, 684
	make_text_macro '3', area, 741, 684
	;'24'
	make_text_macro '2', area, 792, 684
	make_text_macro '4', area, 802, 684

	; suprafata_oriz MACRO x, y, lungime, culoare
	suprafata_oriz 65, 70, 770, 088723Fh	;banda orizontala sus
	suprafata_oriz 65, 670, 770, 088723Fh	;banda orizontala jos
	suprafata_vert 835, 70, 600, 088723Fh	;banda verticala stanga
	suprafata_vert 65, 70, 600, 088723Fh	;banda verticala dreapta
	
	;	mijlocul tablei
	;	umbra stanga mijloc
	suprafata_vert 430, 70, 600, 06F5D32h
	suprafata_vert 431, 70, 600, 06F5D32h
	suprafata_vert 432, 70, 600, 06F5D32h
	suprafata_vert 433, 70, 600, 06F5D32h
	suprafata_vert 434, 70, 600, 06F5D32h
	
	suprafata_vert 435, 70, 600, 088723Fh
	suprafata_vert 436, 70, 600, 088723Fh
	suprafata_vert 437, 70, 600, 088723Fh
	suprafata_vert 438, 70, 600, 088723Fh
	suprafata_vert 439, 70, 600, 088723Fh
	suprafata_vert 440, 70, 600, 088723Fh
	suprafata_vert 441, 70, 600, 088723Fh
	suprafata_vert 442, 70, 600, 088723Fh
	suprafata_vert 443, 70, 600, 088723Fh
	suprafata_vert 444, 70, 600, 088723Fh
	suprafata_vert 445, 70, 600, 088723Fh
	suprafata_vert 446, 70, 600, 088723Fh
	suprafata_vert 447, 70, 600, 088723Fh
	suprafata_vert 448, 70, 600, 088723Fh
	suprafata_vert 449, 70, 600, 088723Fh
	
	suprafata_vert 450, 70, 600, 0h
	
	suprafata_vert 451, 70, 600, 088723Fh
	suprafata_vert 452, 70, 600, 088723Fh
	suprafata_vert 453, 70, 600, 088723Fh
	suprafata_vert 454, 70, 600, 088723Fh
	suprafata_vert 455, 70, 600, 088723Fh
	suprafata_vert 456, 70, 600, 088723Fh
	suprafata_vert 457, 70, 600, 088723Fh
	suprafata_vert 458, 70, 600, 088723Fh
	suprafata_vert 459, 70, 600, 088723Fh
	suprafata_vert 460, 70, 600, 088723Fh
	suprafata_vert 461, 70, 600, 088723Fh
	suprafata_vert 462, 70, 600, 088723Fh
	suprafata_vert 463, 70, 600, 088723Fh
	suprafata_vert 464, 70, 600, 088723Fh
	suprafata_vert 465, 70, 600, 088723Fh
	
	;	umbra dreapta mijloc
	suprafata_vert 466, 70, 600, 06F5D32h
	suprafata_vert 467, 70, 600, 06F5D32h
	suprafata_vert 468, 70, 600, 06F5D32h
	suprafata_vert 469, 70, 600, 06F5D32h
	suprafata_vert 470, 70, 600, 06F5D32h

	;	marginea inferioara (jos)
	suprafata_oriz 65, 670, 770, 0685C40H
	suprafata_oriz 65, 671, 770, 0685C40H
	suprafata_oriz 65, 672, 770, 0685C40H
	suprafata_oriz 65, 673, 770, 0685C40H
	suprafata_oriz 65, 674, 770, 0685C40H
	suprafata_oriz 65, 675, 770, 0685C40H
	suprafata_oriz 65, 676, 770, 0685C40H
	suprafata_oriz 65, 677, 770, 0685C40H
	
	;	marginea superioara (sus)
	suprafata_oriz 65, 69, 770, 0685C40H
	suprafata_oriz 65, 68, 770, 0685C40H
	suprafata_oriz 65, 67, 770, 0685C40H
	suprafata_oriz 65, 66, 770, 0685C40H
	suprafata_oriz 65, 65, 770, 0685C40H
	suprafata_oriz 65, 64, 770, 0685C40H
	suprafata_oriz 65, 63, 770, 0685C40H
	suprafata_oriz 65, 62, 770, 0685C40H
	
	;	marginea dreapta
	suprafata_vert 836, 70, 600, 0685c40h
	suprafata_vert 837, 70, 600, 0685c40h
	suprafata_vert 838, 70, 600, 0685c40h
	suprafata_vert 839, 70, 600, 0685c40h
	suprafata_vert 840, 70, 600, 0685c40h
	suprafata_vert 841, 70, 600, 0685c40h
	suprafata_vert 842, 70, 600, 0685c40h
	suprafata_vert 843, 70, 600, 0685c40h

	;	marginea stanga
	suprafata_vert 64, 70, 600, 0685c40h
	suprafata_vert 63, 70, 600, 0685c40h
	suprafata_vert 62, 70, 600, 0685c40h
	suprafata_vert 61, 70, 600, 0685c40h
	suprafata_vert 60, 70, 600, 0685c40h
	suprafata_vert 59, 70, 600, 0685c40h
	suprafata_vert 58, 70, 600, 0685c40h
	suprafata_vert 57, 70, 600, 0887B5Dh	
	
	; colt stanga sus al tablei
	suprafata_oriz 57, 70, 9, 0443C28h
	suprafata_oriz 57, 69, 9, 0443C28h
	suprafata_oriz 57, 68, 9, 0443C28h
	suprafata_vert 57, 62, 9, 0443c28h
	suprafata_vert 58, 62, 9, 0443c28h
	suprafata_vert 59, 62, 6, 0887B5Dh
	suprafata_vert 60, 62, 6, 0887B5Dh
	suprafata_vert 61, 62, 6, 0887B5Dh
	suprafata_vert 62, 62, 6, 0887B5Dh
	suprafata_vert 63, 62, 6, 0887B5Dh
	suprafata_vert 64, 62, 6, 0887B5Dh
	
	;	balama sus
	suprafata_vert 449, 151, 20, 0E7C900h
	suprafata_vert 450, 151, 20, 0E7C900h
	suprafata_vert 451, 151, 20, 0E7C900h
	suprafata_vert 449, 172, 20, 0E7C900h
	suprafata_vert 450, 172, 20, 0E7C900h
	suprafata_vert 451, 172, 20, 0E7C900h

	;	balama jos
	suprafata_vert 449, 520, 20, 0E7C900h
	suprafata_vert 450, 520, 20, 0E7C900h
	suprafata_vert 451, 520, 20, 0E7C900h
	suprafata_vert 449, 541, 20, 0E7C900h
	suprafata_vert 450, 541, 20, 0E7C900h
	suprafata_vert 451, 541, 20, 0E7C900h
	;dâbe / bâte
	make_podbal_macro 1, area, 442, 28
	make_podbal_macro 1, area, 442, 693
ENDM

buton_iesire macro 
	; suprafata_oriz MACRO x, y, lungime, culoare
	suprafata_oriz 1014, 27, 110, 0FF0000h
	suprafata_vert 1014, 27, 30, 0FF0000h
	suprafata_oriz 1014, 57, 110, 0FF0000h
	suprafata_vert 1124, 27, 30, 0FF0000h
	
	make_text_macro 'T', area, 1026, 30
	make_text_macro 'E', area, 1036, 30
	make_text_macro 'R', area, 1046, 30
	make_text_macro 'M', area, 1056, 30
	make_text_macro 'I', area, 1066, 30
	make_text_macro 'N', area, 1076, 30
	make_text_macro 'A', area, 1086, 30
	make_text_macro 'T', area, 1096, 30
	make_text_macro 'E', area, 1106, 30
endm

DICES macro
	rdtsc
et_loop:
	pusha
	mov ecx, 10
	mov edx, 0
	div ecx	;restul se memoreaza in dx. El ne intereseaza

	mov ecx, 7
	mov edx, 0
	div ecx

	test dx, 0Fh
	jz et_loop
	popa
endm

M_scrie_text_invalid MACRO
	make_text_macro 'I', area, 410, 737
	make_text_macro 'N', area, 420, 737
	make_text_macro 'V', area, 430, 737
	make_text_macro 'A', area, 440, 737
	make_text_macro 'L', area, 450, 737
	make_text_macro 'I', area, 460, 737
	make_text_macro 'D', area, 470, 737
endm

M_sterge_text_invalid macro
	suprafata_oriz 410, 737, 70, 0aaaaaah
	suprafata_oriz 410, 738, 70, 0aaaaaah
	suprafata_oriz 410, 739, 70, 0aaaaaah
	suprafata_oriz 410, 740, 70, 0aaaaaah
	suprafata_oriz 410, 741, 70, 0aaaaaah
	suprafata_oriz 410, 742, 70, 0aaaaaah
	suprafata_oriz 410, 743, 70, 0aaaaaah
	suprafata_oriz 410, 744, 70, 0aaaaaah
	suprafata_oriz 410, 745, 70, 0aaaaaah
	suprafata_oriz 410, 746, 70, 0aaaaaah
	suprafata_oriz 410, 747, 70, 0aaaaaah
	suprafata_oriz 410, 748, 70, 0aaaaaah
	suprafata_oriz 410, 749, 70, 0aaaaaah
	suprafata_oriz 410, 750, 70, 0aaaaaah
	suprafata_oriz 410, 751, 70, 0aaaaaah
	suprafata_oriz 410, 752, 70, 0aaaaaah
	suprafata_oriz 410, 753, 70, 0aaaaaah
	suprafata_oriz 410, 754, 70, 0aaaaaah
	suprafata_oriz 410, 755, 70, 0aaaaaah
	suprafata_oriz 410, 756, 70, 0aaaaaah
endm

M_scrie_text_scoase_afara macro
	make_text_macro 'S', area, 1046, 182 
	make_text_macro 'C', area, 1056, 182
	make_text_macro 'O', area, 1066, 182
	make_text_macro 'A', area, 1076, 182
	make_text_macro 'S', area, 1086, 182
	make_text_macro 'E', area, 1096, 182
	make_text_macro 'A', area, 1056, 202 
	make_text_macro 'F', area, 1066, 202
	make_text_macro 'A', area, 1076, 202
	make_text_macro 'R', area, 1086, 202
	make_text_macro 'A', area, 1096, 202
;mai scrie Alb, Negru
	make_text_macro 'A', area, 978, 691 
	make_text_macro 'L', area, 988, 691
	make_text_macro 'B', area, 998, 691
	make_text_macro 'N', area, 958, 711
	
	make_text_macro 'E', area, 968, 711
	make_text_macro 'G', area, 978, 711
	make_text_macro 'R', area, 988, 711
	make_text_macro 'U', area, 998, 711
endm

M_scrie_MARTI macro
	make_text_macro 'M', area, 1063, 704
	make_text_macro 'A', area, 1073, 704
	make_text_macro 'R', area, 1083, 704
	make_text_macro 'T', area, 1093, 704
	make_text_macro 'I', area, 1103, 704	
endm

buton_roll_dices macro
	make_text_macro 'R', area, 896, 283
	make_text_macro 'O', area, 906, 283
	make_text_macro 'L', area, 916, 283
	make_text_macro 'L', area, 926, 283
	make_text_macro ' ', area, 936, 283
	make_text_macro 'D', area, 946, 283
	make_text_macro 'I', area, 956, 283
	make_text_macro 'C', area, 966, 283
	make_text_macro 'E', area, 976, 283
	make_text_macro 'S', area, 986, 283
	
	suprafata_oriz 885, 272, 117, 000f5fch
	suprafata_oriz 885, 302, 117, 000f5fch
	suprafata_vert 885, 272, 30, 000f5fch
	suprafata_vert 1002, 272, 30, 000f5fch
endm

	;	Acest macro genereaza random zaruri si le afiseaza
M_af_zaruri macro
local ET1
pusha
	rdtsc
ET1:
	mov ecx, 6
	mov edx, 0
	div ecx	;restul (remainder-ul) se memoreaza in dx. El ne intereseaza

	add dx, 1
	xor eax, eax
	mov ax, dx
	make_zar_macro eax, area, 888, 347
	
	;	Memoram valoarea zarului generat in variabila "zar1"
	mov zar1, eax
	rdtsc
; ET2:
	mov ecx, 6
	mov edx, 0
	div ecx	;restul (remainder-ul) se memoreaza in dx. El ne intereseaza

	add dx, 1
	xor eax, eax
	mov ax, dx
	make_zar_macro eax, area, 960, 347
	
	;	Memoram valoarea zarului generat in variabila "zar2"
	mov zar2, eax
popa
endm

M_press_buton_zaruri macro xClick, yClick
local final
	pusha
	cmp xClick, 885
	jl final
	cmp xClick, 1002
	jg final
	cmp yClick, 272
	jl final
	cmp yClick, 302
	jg final
	M_af_zaruri
final:
	popa
endm
