.data
cheie: .long 0,0,0,0,0,0
       .long 0,0,1,0,0,0
       .long 0,0,0,0,1,0
       .long 0,0,0,0,0,0
       .long 0,0,0,0,0,0
array: .space 400
parola: .asciz "parola"
parola_criptata: .space 400
parola_biti: .space 80

nr_linii: .long 3
nr_coloane: .long 4
l_cheie: .space 4
l_parola: .space 4
indexCheie: .long 0
indexParola: .long 0

textScanf: .asciz "%s"
textPrintf: .asciz "%s\n"
integerPrintf: .asciz "%d "

i: .long 0
i_afis: .long 0
.text

.global main
main:

##citire parola
#pushl $parola
#pushl $textScanf
#call scanf
#popl %edx
#popl %edx

lea parola_biti, %edi
movl $parola, %ecx           # pun adresa parolei in ecx
movl $7, %edx                # index pt array

loop_start:
movb (%ecx), %al             # mut byte-ul in al
test %al, %al                # final de string
jz loop_end

movl $8, %ebx                #counter pt biti

bit_loop:
movl %eax, %esi
andl $1, %esi                # 0000.0001 & 1001.0010 = 0 (scoate ultimul bit)
mov %esi, (%edi,%edx,4)      # mut lsb in array pe poz 7, dupa 6... pana la 0
decl %edx
shrl %eax                    # trec la urm bit

dec %ebx
jnz bit_loop

addl $16, %edx               # ajung pe pozitia 15 in array, plasez pana la poz 8, etc
inc %ecx
jmp loop_start
loop_end:

#l_parola = total_array - 8 (din metoda mea de atribuire :o)
subl $8, %edx
movl %edx, l_parola

#l_cheie  = (nr_linii+2)*(nr_coloane+2)-1 = 29 (pt ex nostru)
movl nr_linii, %eax
addl $2, %eax
movl nr_coloane, %ebx
addl $2, %ebx
xorl %edx, %edx
mull %ebx
decl %eax
movl %eax, l_cheie

# indexCheie <= l_cheie
# indexParola <= l_parola

pushl l_parola
pushl $integerPrintf
call printf
popl %edx
popl %edx

pushl $0
call fflush
popl %edx

#criptare:
#movl i, %ecx
#cmp l_parola, %ecx
#jg criptare_exit
#
#lea parola_biti, %edi
#movl i, %ecx
#movl (%edi, %ecx, 4), %eax
#
#lea cheie, %esi
#movl i, %ecx
#movl (%esi, %ecx, 4), %ebx
#
#xorl %ebx, %eax
#
#lea parola_criptata, %esi
#movl i, %ecx
#movl %eax, (%esi, %ecx, 4)
#
#incl i
#jmp criptare
#criptare_exit:

#afis_array:
#movl i_afis, %ecx
#cmp l_parola, %ecx
#jg afis_array_end
#
#lea parola_biti, %edi
#movl (%edi, %ecx, 4), %eax
#
#pushl %eax
#pushl $integerPrintf
#call printf
#popl %edx
#popl %edx
#
#pushl $0
#call fflush
#popl %edx
#
#incl i_afis
#jmp afis_array
#afis_array_end:

et_exit:
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
