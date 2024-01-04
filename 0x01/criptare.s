.data
cheie: .long 0,0,0,0,0,0
       .long 0,0,1,0,0,0
       .long 0,0,0,0,1,0
       .long 0,0,0,0,0,0
       .long 0,0,0,0,0,0
       .long 0,0,0,0,0,0
       .long 0,0,1,0,0,0
       .long 0,0,0,0,1,0
       .long 0,0,0,0,0,0
       .long 0,0,0,0,0,0
parola_biti: .long 0 ,1 ,1 ,1 ,0 ,0 ,0 ,0 ,0 ,1 ,1  ,0  ,0  ,0  ,0  ,1  ,0  ,1  ,1  ,1  ,0  ,0  ,1  ,0  ,0  ,1  ,1  ,0  ,1  ,1  ,  1  ,1  ,0  ,1  ,1  ,0  ,1  ,1  ,0  ,0  ,0  ,1  ,1  ,0  ,0  ,0  ,0  ,1

nr_linii: .long 3
nr_coloane: .long 4

parola: .space 10
parola_criptata: .space 400

textScanf: .asciz "%s"
textPrintf: .asciz "%s\n"
integerPrintf: .asciz "%d "

l_parola: .long 47
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

afis_array:
movl i_afis, %ecx
cmp l_parola, %ecx
jg afis_array_end

lea parola_criptata, %edi
movl (%edi, %ecx, 4), %eax

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
