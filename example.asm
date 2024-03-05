;Proiectant: ing. Vlad Bartolomei
;Nume Proiect: Joc de Table
;Subiect: PLA / ASC

;--------------------------------------------------------------------------
;vreau sa incrementez variabila lungime_linie cu 4. cum fac? vezi biblioteca_test
;CÂTĂ CÂRPEALĂĂĂĂ BĂĂĂ FRATEEEE
;ATÂT DE APROAPE DE A FI GATAAAAAAA
;--------------------------------------------------------------------------

.586 ;ca sa pot folosi rdtsc
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc
extern fprintf: proc
extern fflush: proc
extern fopen: proc
includelib canvas.lib
include biblioteca_desen.asm
include amplasare_piese.asm
extern BeginDrawing: proc

;pentru INCLUDE-uri mergi mai jos sub declararile de var
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
numefis db "fisier_verificare.txt", 0
mod_open db "w", 0
fmt db "Unde am apasat punctul = %d", 13, 10, 0
file_pointer dd 0

X 			dd ?
Y 			dd ?
numarator 	dd ?
DIR 		dd 1
var1 		db ?
var2 		dd ?
var3 		dd ?
zar1		dd 0
zar2		dd 0
cate_mutari dd 2
x_click		dd ?
y_click		dd ?
CheckIfGameEnded dd 0 ;0 pt NU, 1 pt DA
var_semafor 		dd 1
UndeAmApasat 		dd 0 
Comutare_Jucator 	dd 1 	;de fiecare data cand comut jucatorul, il trag pe 0. Astfel, cand valoarea este 1, deci muta acelasi jucator, zarurile nu se arunca
							;putem spune ca aruncarea zarurilor este activa pe 0 logic
;1-24 - puncte pe tabla, 25 - pe rama tablei, 0 - nimic 
;---------------------------------------------------------------------------
structura struct
	albe	dd	?
	negre	dd	?
structura ends

joc					structura {2, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 5}
					structura {0, 0}, {0, 3}, {0, 0}, {0, 0}, {0, 0}, {5, 0}
					structura {0, 5}, {0, 0}, {0, 0}, {0, 0}, {3, 0}, {0, 0}
					structura {5, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 2}
sizeof_joc			EQU ($ - joc)/8   
sizeof_component	EQU 8
comutaPeAlb			EQU -1
comutaPeNegru   	EQU 1
comutaJucator 		DD 1
scoaseAlbe 			DD 0
scoaseNegre 		DD 0
AlbeTerminate		DD 0
NegreTerminate 		DD 0
zar_ales			DD 0
; --------------------------------------------------------------------------
window_title 	DB "Table, Valea Oltului Edition", 0
area_width 		EQU 1152
area_height 	EQU 770
area 			DD 	0

counter 		DD 0 ; numara evenimentele de tip timer

arg1 			EQU 8
arg2 			EQU 12
arg3 			EQU 16
arg4 			EQU 20

;	buton Iesire
button_x 		 equ 1014
button_y 		 equ 27
button_size_lung equ 110
button_size_lat  equ 30

zar_width 		EQU 40
zar_height 		EQU 40
daba_width 		EQU 22
daba_height 	EQU 20
piesa_width 	EQU 40
piesa_height 	EQU 40
symbol_width 	EQU 10
symbol_height 	EQU 20


fmt_mesaj db "element[%d][%d] = %d", 13, 10, 0
;draw
;evt_timer
;evt_click
include digits.inc
include letters.inc
include piesa_alba.inc
include podbal.inc
include ghinda.inc
include zaruri.inc
.code
M_zona_click MACRO x_click, y_click, x_stg_sus, x_drt_jos, y_stg_sus, y_drt_jos, return_caz_fericit
; DOCUMENTATIE: functia va returna in EAX un numar [1, 24] care va desemna
				; in ce zona s-a dat click
LOCAL punkt_fail
	pusha
	mov ebx, x_click
	cmp ebx, x_stg_sus
	jl punkt_fail
	cmp ebx, x_drt_jos
	jg punkt_fail
	mov ebx, y_click
	cmp ebx, y_stg_sus
	jl punkt_fail
	cmp ebx, y_drt_jos
	jg punkt_fail
	; daca trece de toate filtrele
	mov UndeAmApasat, return_caz_fericit
punkt_fail:
	popa
ENDM

M_unde_am_apasat MACRO
pusha 
	mov eax, x_click
	mov ebx, y_click
	;vf punct 1
	M_zona_click eax, ebx, 777, 835, 70, 299, 1 
	;vf punct 2
	M_zona_click eax, ebx, 718, 776, 70, 299, 2 
	;vf punct 3
	M_zona_click eax, ebx, 658, 717, 70, 299, 3
	;vf punct 4
	M_zona_click eax, ebx, 600, 657, 70, 299, 4 
	;vf punct 5
	M_zona_click eax, ebx, 540, 599, 70, 299, 5 
	;vf punct 6
	M_zona_click eax, ebx, 482, 539, 70, 299, 6
	;vf punct 7
	M_zona_click eax, ebx, 361, 419, 70, 299, 7
	;vf punct 8
	M_zona_click eax, ebx, 303, 360, 70, 299, 8
	;vf punct 9
	M_zona_click eax, ebx, 243, 302, 70, 299, 9
	;vf punct 10
	M_zona_click eax, ebx, 185, 242, 70, 299, 10
	;vf punct 11
	M_zona_click eax, ebx, 126, 184, 70, 299, 11
	;vf punct 12
	M_zona_click eax, ebx, 66, 125, 70, 299, 12
	;vf punct 13
	M_zona_click eax, ebx, 66, 125, 441, 671, 13
	;vf punct 14
	M_zona_click eax, ebx, 126, 184, 441, 671, 14
	;vf punct 15
	M_zona_click eax, ebx, 185, 242, 441, 671, 15
	;vf punct 16
	M_zona_click eax, ebx, 243, 300, 441, 671, 16
	;vf punct 17
	M_zona_click eax, ebx, 301, 360, 441, 671, 17
	;vf punct 18
	M_zona_click eax, ebx, 361, 414, 441, 671, 18
	;vf punct 19
	M_zona_click eax, ebx, 482, 542, 441, 671, 19
	;vf punct 20
	M_zona_click eax, ebx, 543, 599, 441, 671, 20
	;vf punct 21
	M_zona_click eax, ebx, 600, 658, 441, 671, 21
	;vf punct 22
	M_zona_click eax, ebx, 659, 716, 441, 671, 22
	;vf punct 23
	M_zona_click eax, ebx, 717, 777, 441, 671, 23
	;vf punct 24
	M_zona_click eax, ebx, 778, 835, 441, 671, 24
	;vf punct 25
	M_zona_click eax, ebx, 430, 469, 441, 671, 25
	; pusha
	; push UndeAmApasat
	; push offset fmt
	; push file_pointer
	; call fprintf
	; add esp, 12
	; popa
	; pusha
	; push file_pointer
	; call fflush
	; popa
	;make_text_macro UndeAmApasat, area, 300, 210
popa
ENDM

M_check_if_game_ended MACRO
LOCAL verif_albe_situatia_1, verifica_situatia_2, deja_am_decis_castigatorul, nu_afisa_MARTI1, nu_afisa_MARTI2
pusha
	;Cazul in care un jucator scoate toate piesele inaintea celuilalt
	mov eax, NegreTerminate
	mov ebx, AlbeTerminate
	
	cmp eax, 15
	jnz verif_albe_situatia_1
	cmp ebx, 0
	jnz nu_afisa_MARTI1
	;display text MARTI
	M_scrie_MARTI
nu_afisa_MARTI1:
	;display GHINDA before NEGRU
	make_podbal_macro 2, area, 930, 714
	mov CheckIfGameEnded, 1
	jmp deja_am_decis_castigatorul
verif_albe_situatia_1:
	cmp ebx, 15
	jnz verifica_situatia_2
	cmp eax, 0
	jnz nu_afisa_MARTI2
	;display text MARTI
	M_scrie_MARTI
nu_afisa_MARTI2:
	;display GHINDA before ALB
	make_podbal_macro 2, area, 930, 694	
	mov CheckIfGameEnded, 1
	jmp deja_am_decis_castigatorul
	;Cazul unui MARTI TEHNIC
		;NOTA: facem macro separat, daca mai facem...
verifica_situatia_2:
deja_am_decis_castigatorul:
popa
ENDM

M_mutare_1 MACRO zar_ales, cine_muta, Pi, DIR
LOCAL nu_comuta_pe_negre, reselecteaza_Pi, final, avoid_this_procedure
	mov Comutare_Jucator, 1
	;Pi = pozitie initial
	;Pf = pozitie final. Comentariu: am nevoie doar de pozitia initiala si de zarul ales
pusha
	;cine_muta este 4, daca muta albul, caz 
	lea ebx, joc
	mov eax, cine_muta
	cmp eax, 2
	;verific cine_muta cu 2
	;1 pt albe, 2 pt negre
	jnz nu_comuta_pe_negre
	add ebx, 4
	;am adaugat 4 bytes ca sa trec pe campul cu piese negre
nu_comuta_pe_negre:
	;Task:trebuie sa ma deplasez la pozitia selectata →
	;fac asta prin 	add ebx, sizeof_component*(Pi - 1)
	;pregatesc sizeof_component(Pi-1)
	mov eax, Pi
	dec eax
	mov esi, sizeof_component
	mul esi
	add ebx, eax
	;de la inceput, ma duc pe punctul selectat
	;Task:vom verifica daca nu cumva am ales din greseala o pozitie unde nu am piese cu care joc
	mov eax, [ebx]
	cmp eax, 0
	jz reselecteaza_Pi
	;Task:vom verifica daca pe pozitia Pi + zar_ales avem sau nu piesa_neagra
	mov edx, ebx 
	;copiem pozitia curenta in edx, pe care o modificam ca sa ajungem la final
	push edx ;ca sa nu pierd copia pozitiei. imi trebuie edx gol pentru un MUL
	;Task: add edx, DIR*zar_ales*sizeof_component
	mov ecx, DIR
	mov eax, zar_ales
	xor edx, edx
	mul ecx
	mov ecx, sizeof_component
	xor edx, edx
	mul ecx
	pop edx ;we retrieve edx, e safe, inmultirile sunt gata
	
	add edx, eax
	;ne deplasam pe pozitia pe care noi am dori-o finala

	;Task: cmp [edx+4*DIR], 2
	;ducem expresia edx+4*DIR in EAX
	push edx
	mov eax, 4
	mov ecx, DIR
	mul ecx
	pop edx
	add eax, edx
	mov ecx, [eax]
	cmp ecx, 2
	;compar pozitia presumably finala, campul cu piese de culoare opusa, cu 2
	;adica eu is cu albele. daca pe negre am mai mult de doua piese, →
	jge reselecteaza_Pi
	;Task: facem mutarea. Adica decrementam numarul de piese din initial [ebx], incrementam in final [edx]
	mov eax, [ebx]
	dec eax
	mov [ebx], eax
	;am decrementat la vechea pozitie
	mov eax, [edx]
	inc eax
	mov [edx], eax
	;am incrementat la noua pozitie.
	;Task:sa ne ocupam de campul advers de bataie
	;Task:lea ecx, [edx+4*DIR]
	;aveam calculat mai sus eax←edx+4*DIR, ecx←[edx+4*DIR]
	
	cmp ecx, 1
	jnz avoid_this_procedure
	dec ecx
	mov [eax], ecx
	mov eax, scoaseNegre
	inc eax
	mov scoaseNegre, eax
avoid_this_procedure:
	call redesenare_tabla
	mov eax, cate_mutari
	dec eax
	mov cate_mutari, eax
	jmp final
reselecteaza_Pi:
	M_scrie_text_invalid
final:
popa
endm

;M_af_zaruri s-a mutat in biblioteca_desen.asm
redesenare_tabla proc
	push EBP
	mov EBP, ESP
	;sub ESP, <dimensiune_variabile_locale>
	
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	
	;if(muta alb)
	;	then push 255
	;else
	;	(muta negru)
	;	push 170
	push 170
	push area
	call memset
	add esp, 12
	
	;	Desenam suprafata de joc si butonul de iesire
	suprafata_de_joc
	buton_iesire
	
	
	push eax
	mov eax, Comutare_Jucator
	cmp eax, 0
	je nu_genera_noi_zaruri
	
	;	Macro-ul "buton_roll_dices" apelat genereaza strict butonul de Roll Dices si il face interactable
	buton_roll_dices
nu_genera_noi_zaruri:
	mov Comutare_Jucator, 0
	pop eax
	
	;	Macro-ul "M_press_buton_zaruri" apelat verifica daca butonul Roll Dices este actionat;
	;	In caz afirmativ, se zarurile si se memoreaza valorile aferente in variabilele zar1, zar2
	M_press_buton_zaruri x_click, y_click
	
	;	Se genereaza triunghiurile de pe tabla de joc
	suprafata_sase_triunghiuri 0h, 0fda855h, 95
	suprafata_sase_triunghiuri 0h, 0fda855h, 511
	
	;	Daca avem piese scoase permanent afara, le afisam
	mov eax, AlbeTerminate
	cmp eax, 0
	je urmatorul
	M_amplasare_piese_punkt AlbeTerminate, 1, 1034, 246, 1, area, area_width
	sub eax, 5
	cmp eax, 0
	jl urmatorul
	M_pre_pune_numar_pe_piese AlbeTerminate, 1034, 246
urmatorul:
	mov eax, NegreTerminate
	cmp eax, 0
	jng next_afisare
	M_amplasare_piese_punkt NegreTerminate, 2, 1094, 246, 1, area, area_width
	sub eax, 5
	cmp eax, 0
	jl next_afisare
	M_pre_pune_numar_pe_piese NegreTerminate, 1094, 246
	;	Aici se incheie afisarea pieselor deja scoase
next_afisare:

	;	Daca avem piese scoase TEMPORAR afara (acolo puse pe rama), le afisam
	mov eax, scoaseAlbe
	cmp eax, 0
	je urmatorul2
	make_piesa_macro 1, area, 430, 313
	sub eax, 1
	cmp eax, 0
	jl urmatorul2
	add eax, 6
	M_pre_pune_numar_pe_piese eax, 445, 103
urmatorul2:
	mov eax, scoaseNegre
	cmp eax, 0
	jng next_afisare2
	make_piesa_macro 2, area, 430, 369
	sub eax, 1
	cmp eax, 0
	jl next_afisare2
	add eax, 6
	M_pre_pune_numar_pe_piese eax, 445, 159
next_afisare2:

	;	Scrie Text Scoase Afara
	M_scrie_text_scoase_afara
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;M_af_zaruri
	
	;	Tot rahatul asta care urmeaza parcurge tabla de joc implementata la nivel de memorie si afiseaza piesa cu piesa (daca e cazul)
	;	Comparatiile din pre_traverse_struct verifica daca suntem pe colturile tablei, caz in care trebuie sa modificam X_origine si Y_origine pe care le transmitem in desenare elemente
	
	lea ebx, joc
	;add ebx, 4*8
	mov ecx, 48	; sizeof_joc*4
	mov esi, 1
	;vom folosi esi pe post de index, cu valori in range (1 to 24); el ne spune pe ce Punkt ne aflam
Pre_traverse_struct:
	cmp esi, 1
	jne et_comp2 ;de la comparatie
	;ce sa faca daca esi = '1'?
	;mov comutaJucator, 1
	mov DIR, 1
	mov eax, 788
	mov Y, 71
	jmp traverse_struct
et_comp2:	
	cmp esi, 7
	jne et_comp3
	;ce sa faca daca esi = '7'?
	;mov comutaJucator, 1
	mov DIR, 1
	mov eax, 370
	mov Y, 71
	jmp traverse_struct
et_comp3:
	cmp esi, 13
	jne et_comp4
	;ce sa faca daca esi = '13'?
	;mov comutaJucator, 1
	mov DIR, -1
	mov eax, 75
	mov Y, 630
	jmp traverse_struct
et_comp4:
	cmp esi, 19
	jne traverse_struct
	;ce sa faca daca esi = '19'?
	;mov comutaJucator, 1
	mov DIR, -1
	mov eax, 493
	mov Y, 630
traverse_struct:

	pusha
		mov edx, [ebx]		;vezi linia 113, cu lea ebx, joc
		;in edx mi-am pus elementul curent
		;PROTOTYPE: nr_piese, tip_piesa, X, Y, dir, area, area_width
		mov X, eax
		cmp edx, 0
		je et_increment
		;daca elementul curent este 0, nu are sens sa afisam pe punkt (sa mai extindem macrourile <pestii>)
		cmp DIR, 1
		jne celalalt_apel_M_amplasare
		M_amplasare_piese_punkt edx, comutaJucator, X, Y, 1, area, area_width
;NOTA: incearca sa pui numere direct in traverse_struct
			sub edx, 5 ;din numarul total de piese scad cate piese am pus deja
			cmp edx, 0	;daca nu pun mai mult de 5 piese
			jl et_increment ;nu trebuie sa pun numere
			;deja aici trebe sa pun numere
			;inc edx	;acel numar ramas de piese + 1
			push eax
			mov eax, Y
			add eax, 42 * 5 ;(vezi linia 47, amplasare_piese.asm)
			add eax, 10
			;transmit pozitiile X si Y cu un deplasament: x+15, y+10 
			;ca numarul sa fie reprezentat pe centrul piesei
			;adaug lui X un mic deplasament (X+15, cum am zis) printr-o Combinatie:
			push ebx
				mov ebx, X
				add ebx, 15
				mov X, ebx
			pop ebx
			M_pune_numar_pe_piese edx, X, eax
			;call macro pune numere
			pop eax
		jmp et_increment
	celalalt_apel_M_amplasare:
		M_amplasare_piese_punkt edx, comutaJucator, X, Y, -1, area, area_width
			sub edx, 5 ;din numarul total de piese scad cate piese am pus deja
			cmp edx, 0	;daca nu pun mai mult de 5 piese
			jl et_increment ;nu trebuie sa pun numere
			;deja aici trebe sa pun numere
			;inc edx	;acel numar ramas de piese + 1
			push eax
			mov eax, Y
			sub eax, 42 * 5 ;(vezi linia 47, amplasare_piese.asm)
			add eax, 10
			;transmit pozitiile X si Y cu un deplasament: x+15, y+10 
			;ca numarul sa fie reprezentat pe centrul piesei
			;adaug lui X un mic deplasament (X+15, cum am zis) printr-o Combinatie:
			push ebx
				mov ebx, X
				add ebx, 15
				mov X, ebx
			pop ebx
			M_pune_numar_pe_piese edx, X, eax
			;call macro pune numere
			pop eax
et_increment:
	popa
	add ebx, 4;    sizeof_component / 2
	;fluxul de date va fi alb-negru-alb-negru-alb-... => verificam daca suntem pe piese albe sau negre
	cmp comutaJucator, 1
	je treci_in_2
	cmp comutaJucator, 2
	je treci_in_1
	
treci_in_2:   ;comuta 1->2
	mov comutaJucator, 2
	make_podbal_macro 1, area, 1018, 691
	mov Comutare_Jucator, 1
	jmp next_step
treci_in_1:   ;comuta 2->1
	mov comutaJucator, 1
	make_podbal_macro 1, area, 1018, 711
	mov Comutare_Jucator, 1
	inc esi
	
	cmp esi, 12
	ja creste_eax_nu_scade
	sub eax, 59
	jmp next_step
creste_eax_nu_scade:
	add eax, 59
next_step:	
	dec ecx
	;mergem mai departe in bucla
	cmp ecx, 0
	jnz Pre_traverse_struct
clean_manual_eroare_pune_numere:
	suprafata_vert 0, 277, 300, 0aaaaaah
	suprafata_vert 1, 277, 300, 0aaaaaah
	suprafata_vert 2, 277, 300, 0aaaaaah
	suprafata_vert 3, 277, 300, 0aaaaaah
	suprafata_vert 4, 277, 300, 0aaaaaah
	suprafata_vert 5, 277, 300, 0aaaaaah
	suprafata_vert 6, 277, 300, 0aaaaaah
	suprafata_vert 7, 277, 300, 0aaaaaah
	suprafata_vert 8, 277, 300, 0aaaaaah
	suprafata_vert 9, 277, 300, 0aaaaaah
	suprafata_vert 10, 277, 300, 0aaaaaah
	suprafata_vert 11, 277, 300, 0aaaaaah
	;la final, verificam daca jocul e gata
	M_check_if_game_ended
	;end PROC:
	mov ESP, EBP
	pop EBP
	ret
redesenare_tabla ENDP

; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_fundal
	cmp byte ptr [esi], 1
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_fundal:
	mov dword ptr [edi], 0004225h
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

make_zaruri proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim zarul de afisat
	sub eax, 1
	lea esi, ZAR
	
draw_zaruri:
	mov ebx, zar_width
	mul ebx
	mov ebx, zar_height
	mul ebx
	add esi, eax
	mov ecx, zar_height
bucla_zar_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, zar_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, zar_width
bucla_zar_coloane:
	cmp byte ptr [esi], 0
	je zar_pixel_alb
	mov dword ptr [edi], 0
	jmp zar_pixel_next
zar_pixel_alb:
	mov dword ptr [edi], 0ffffffh;0c49a9ah
zar_pixel_next:
	inc esi
	add edi, 4
	loop bucla_zar_coloane
	pop ecx
	loop bucla_zar_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_zaruri endp

make_piesa_neagra proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim piesaul de afisat
	sub eax, 2
	lea esi, white_stone
	
draw_piesa:
	mov ebx, piesa_width
	mul ebx
	mov ebx, piesa_height
	mul ebx
	add esi, eax
	mov ecx, piesa_height
bucla_piesa_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, piesa_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, piesa_width
bucla_piesa_coloane:
	cmp byte ptr [esi], 0
	je piesa_pixel_next
	cmp byte ptr [esi], 1
	je piesa_pixel_contur
	cmp byte ptr [esi], 2
	je piesa_pixel_interior
	cmp byte ptr [esi], 3
	je piesa_pixel_dungi_deschise
	cmp byte ptr [esi], 4
	je piesa_pixel_dungi_inchise
	cmp byte ptr [esi], 5
	je piesa_pixel_gri
	
	mov dword ptr [edi], 0
	jmp piesa_pixel_next
; piesa_pixel_alb:
	; mov dword ptr [edi], 0ffffffh
	; jmp piesa_pixel_next
piesa_pixel_gri:
	mov dword ptr [edi], 0222222h
	jmp piesa_pixel_next
piesa_pixel_dungi_inchise:
	mov dword ptr [edi], 06f5c5ch
	jmp piesa_pixel_next
piesa_pixel_dungi_deschise:
	mov dword ptr [edi], 0846a6ah
	jmp piesa_pixel_next
piesa_pixel_interior:
	mov dword ptr [edi], 09e8181h
	jmp piesa_pixel_next
piesa_pixel_contur:
	mov dword ptr [edi], 0c49a9ah
	
piesa_pixel_next:
	inc esi
	add edi, 4
	loop bucla_piesa_coloane
	pop ecx
	loop bucla_piesa_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_piesa_neagra endp

make_piesa_alba proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim piesa de afisat
	sub eax, 1
	lea esi, white_stone
	
draw_piesa:
	mov ebx, piesa_width
	mul ebx
	mov ebx, piesa_height
	mul ebx
	add esi, eax
	mov ecx, piesa_height
bucla_piesa_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, piesa_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, piesa_width
bucla_piesa_coloane:
	cmp byte ptr [esi], 0
	je piesa_pixel_next
	cmp byte ptr [esi], 1
	je piesa_pixel_contur
	cmp byte ptr [esi], 2
	je piesa_pixel_dungi_inchise
	cmp byte ptr [esi], 3
	je piesa_pixel_dungi_deschise
	cmp byte ptr [esi], 4
	je piesa_pixel_interior
	cmp byte ptr [esi], 5
	je piesa_pixel_gri
	
	mov dword ptr [edi], 0
	jmp piesa_pixel_next
piesa_pixel_gri:
	mov dword ptr [edi], 0222222h
	jmp piesa_pixel_next
piesa_pixel_dungi_inchise:
	mov dword ptr [edi], 0d3ab84h
	jmp piesa_pixel_next
piesa_pixel_dungi_deschise:
	mov dword ptr [edi], 0f1dcb1h
	jmp piesa_pixel_next
piesa_pixel_interior:
	mov dword ptr [edi], 0f4e8d4h
	jmp piesa_pixel_next
piesa_pixel_contur:
	mov dword ptr [edi], 0eed1a2h
	
piesa_pixel_next:
	inc esi
	add edi, 4
	loop bucla_piesa_coloane
	pop ecx
	loop bucla_piesa_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_piesa_alba endp

make_daba proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim daba de afisat
	sub eax, 1
	lea esi, podbal
	
draw_daba:
	mov ebx, daba_width
	mul ebx
	mov ebx, daba_height
	mul ebx
	add esi, eax
	mov ecx, daba_height
bucla_daba_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, daba_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, daba_width
bucla_daba_coloane:
	cmp byte ptr [esi], 0
	je daba_pixel_next
	cmp byte ptr [esi], 1
	je daba_pixel_galben
	cmp byte ptr [esi], 2
	je daba_pixel_maro_doi
	cmp byte ptr [esi], 3
	je daba_pixel_maro_trei
	cmp byte ptr [esi], 4
	je daba_pixel_maro_patru
	cmp byte ptr [esi], 5
	je daba_pixel_maro_cinci
	cmp byte ptr [esi], 6
	je daba_pixel_kaki
	cmp byte ptr [esi], 7
	je daba_pixel_verde_deschis
	cmp byte ptr [esi], 8
	je daba_pixel_verde_inchis
	
	mov dword ptr [edi], 0
	jmp daba_pixel_next
daba_pixel_galben:
	mov dword ptr [edi], 0eed03bh
	jmp daba_pixel_next
daba_pixel_maro_doi:
	mov dword ptr [edi], 03d361ch
	jmp daba_pixel_next
daba_pixel_maro_trei:
	mov dword ptr [edi], 09e3d27h
	jmp daba_pixel_next
daba_pixel_maro_patru:
	mov dword ptr [edi], 06c342ah
	jmp daba_pixel_next
daba_pixel_maro_cinci:
	mov dword ptr [edi], 02c251eh
	jmp daba_pixel_next
daba_pixel_kaki:
	mov dword ptr [edi], 0766624h
	jmp daba_pixel_next
daba_pixel_verde_deschis:
	mov dword ptr [edi], 04d6943h
	jmp daba_pixel_next
daba_pixel_verde_inchis:
	mov dword ptr [edi], 0212c23h
daba_pixel_next:
	inc esi
	add edi, 4
	loop bucla_daba_coloane
	pop ecx
	dec ecx
	cmp ecx, 0
	jnz bucla_daba_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_daba endp

; un macro ca sa apelam mai usor desenarea simbolului
;OBS: make_text_macro l-am mutat in biblioteca_desen.asm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y

draw proc
	push ebp
	mov ebp, esp
	pusha
	
	; cmp file_pointer, 0
	; jnz sari
	; pusha
	; push offset mod_open
	; push offset numefis
	; call fopen
	; add esp, 8
	; mov file_pointer, eax
	; popa
; sari:	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 170
	push area
	call memset
	add esp, 12
	jmp afisare_litere
	
evt_click:
	suprafata_oriz [ebp+arg2], [ebp+arg3], 80, 04255h
	suprafata_vert [ebp+arg2], [ebp+arg3], 40, 04225h
	; suprafata_sase_triunghiuri 0h, 0fda855h, 95
	; suprafata_sase_triunghiuri 0h, 0fda855h, 511
	; M_zona_click 66, 70, 120, 301, 8
	;make_text_macro eax, area, 20, 10
	push eax
	mov eax, [ebp+arg2]
	mov x_click, eax
	mov eax, [ebp+arg3]
	mov y_click, eax
	pop eax
	;retin in cele doua variabile DD unde am dat click
	
	
	mov eax, [ebp + arg2] ;	in functia draw, x = arg2
	cmp eax, button_x
	jl et_button_fail
	cmp eax, button_x + button_size_lung
	jg et_button_fail
	mov eax, [ebp + arg3] ;	in functia draw, y = arg3
	cmp eax, button_y
	jl et_button_fail
	cmp eax, button_y + button_size_lat
	jg et_button_fail
	int 21h		;	oprirea programului: INTerrupt cu comanda 21h
et_button_fail:	
	
	; ;Task:gasim indexul punctului pe care apasam
	; mov eax, x_click
	; cmp eax, 887
	; jl et_zar1_fail
	; add eax, 40
	; cmp eax, 927
	; jg et_zar1_fail
	; mov eax, y_click
	; cmp eax, 347
	; jl et_zar1_fail
	; add eax, 40
	; cmp eax, 387
	; jg et_zar1_fail
	; ;*
	; mov eax, zar1
	; mov zar_ales, eax
; et_zar1_fail:
	; ;Task: daca dau click pe zar2, zar_ales<-zar2
	; mov eax, x_click
	; cmp eax, 959
	; jl et_zar2_fail
	; add eax, 40
	; cmp eax, 999
	; jg et_zar2_fail
	; mov eax, y_click
	; cmp eax, 347
	; jl et_zar2_fail
	; add eax, 40
	; cmp eax, 387
	; jg et_zar2_fail
	; ;*
	; mov eax, zar2
	; mov zar_ales, eax
; et_zar2_fail:


	jmp afisare_litere
	
evt_timer:
	inc counter
	
afisare_litere:
	; ;afisam valoarea counter-ului curent (sute, zeci si unitati)
	; mov ebx, 10
	; mov eax, counter
	; ;cifra unitatilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 30, 10
	; ;cifra zecilor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 20, 10
	; ;cifra sutelor
	; mov edx, 0
	; div ebx
	; add edx, '0'
	; make_text_macro edx, area, 10, 10
	
	call redesenare_tabla
	;		M_mutare_1 MACRO zar_ales, cine_muta, Pi, DIR
	mov eax, zar1
	mov zar_ales, eax
	;M_mutare_1 5, 1, 12, 1
	;M_mutare_1 6, 2, 13, -1
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:

	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;aici pot incepe testarile
	
	;terminarea programului
	push 0
	call exit
end start

; rdtsc -> edx:eax ; Nota: foloseste doar eax, sau doar ax
