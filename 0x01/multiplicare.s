.data
cheie: .long 0,0,0,0,0,0
       .long 0,0,1,0,0,0
       .long 0,0,0,0,1,0
       .long 0,0,0,0,0,0
       .long 0,0,0,0,0,0
dummy: .space 1600
parola_biti: .space 400

nr_linii: .long 3
nr_coloane: .long 4

parola: .space 10
parola_criptata: .space 400

textScanf: .asciz "%s"
textPrintf: .asciz "%s\n"
integerPrintf: .asciz "%d "

l_parola: .space 4
i: .long 0
i_afis: .long 0
q_mul: .space 4
l_cheie: .space 4
indice_cheie_full: .space 4
indice_cheie_initiala: .space 4
cod: .space 4

.text

.global main
main:

#citire parola
pushl $parola
pushl $textScanf
call scanf
popl %edx
popl %edx

lea parola_biti, %edi
movl $parola, %ecx           # pun adresa parolei in ecx
movl $7, %edx                # index pt array

loop_start:
xorl %eax, %eax
movb (%ecx), %al             # mut byte-ul in al
test %al, %al                # final de string
jz loop_end

movl $8, %ebx                #counter pt biti

bit_loop:
movl %eax, %esi
andl $1, %esi                # 0000.0001 & 1001.0010 = 0 (scoate ultimul bit)
mov %esi, (%edi, %edx, 4)    # mut lsb in array pe poz 7, dupa 6... pana la 0
decl %edx
shrl %eax                    # trec la urm bit

dec %ebx
jnz bit_loop

addl $16, %edx               # ajung pe pozitia 15 in array, plasez pana la poz 8, etc
inc %ecx
jmp loop_start
loop_end:

#l_parola = 47 (calculata inainte)

subl $8, %edx
movl %edx, l_parola

# l_cheie = (nr_linii+2)*(nr_coloane+2)-1 = 29 (pt ex nostru)
movl nr_linii, %eax
addl $2, %eax
movl nr_coloane, %ebx
addl $2, %ebx
xorl %edx, %edx
mull %ebx
decl %eax
movl %eax, l_cheie

# q_mul = l_parola // l_cheie
movl l_parola, %eax
movl l_cheie, %ebx
xorl %edx, %edx
divl %ebx
movl %eax, q_mul

#pushl l_parola
#pushl $integerPrintf
#call printf
#popl %edx
#popl %edx
#
#pushl $0
#call fflush
#popl %edx

multiplicari:
movl $0, indice_cheie_initiala

movl q_mul, %ecx
cmp $0, %ecx
je multiplicari_exit

copiere_cheie:
movl indice_cheie_initiala, %ecx
cmp l_cheie, %ecx
jg copiere_cheie_end

# formula: indice_cheie_full = 
#       (l_cheie_intiala + 1) * q_mul + indice_cheie_initiala
movl l_cheie, %eax
addl $1, %eax
movl q_mul, %ebx
xorl %edx, %edx
mull %ebx
addl indice_cheie_initiala, %eax
movl %eax, indice_cheie_full

lea cheie, %edi
movl indice_cheie_initiala, %ebx
movl (%edi, %ebx, 4), %edx
movl indice_cheie_full, %ebx
movl %edx, (%edi, %ebx, 4)

incl indice_cheie_initiala
jmp copiere_cheie
copiere_cheie_end:

decl q_mul
jmp multiplicari
multiplicari_exit:

criptare:
movl i, %ecx
cmp l_parola, %ecx
jg criptare_exit


lea parola_biti, %edi
movl i, %ecx
movl (%edi, %ecx, 4), %eax

lea cheie, %esi
movl i, %ecx
movl (%esi, %ecx, 4), %ebx

xorl %ebx, %eax
movl %eax, cod

lea parola_criptata, %esi
movl i, %ecx
movl cod, %eax
movl %eax, (%esi, %ecx, 4)

incl i
jmp criptare
criptare_exit:

#in parola_criptata avem cript

afis_array:
movl i_afis, %ecx
cmp l_parola, %ecx
jg afis_array_end

lea parola_criptata, %esi
movl (%esi, %ecx, 4), %eax

pushl %eax
pushl $integerPrintf
call printf
popl %edx
popl %edx

pushl $0
call fflush
popl %edx

incl i_afis
jmp afis_array
afis_array_end:

et_exit:
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
