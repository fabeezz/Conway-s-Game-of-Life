.data
cheie: .long 0,0,0,0,0,0
       .long 0,0,1,0,0,0
       .long 0,0,0,0,1,0
       .long 0,0,0,0,0,0
       .long 0,0,0,0,0,0
array: .space 400

parola: .asciz "parola"
textScanf: .asciz "%s"
textPrintf: .asciz "%s\n"
integerPrintf: .asciz "%d "

i: .long 0
.text

.global main
main:

##citire parola
#pushl $parola
#pushl $textScanf
#call scanf
#popl %edx
#popl %edx

lea array, %edi
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



afis_array:
movl i, %ecx
cmp $47, %ecx
jg afis_array_end

lea array, %edi
movl (%edi, %ecx, 4), %eax

pushl %eax
pushl $integerPrintf
call printf
popl %edx
popl %edx

pushl $0
call fflush
popl %edx

incl i
jmp afis_array

afis_array_end:
##afisare parola
#pushl $parola
#pushl $textPrintf
#call printf
#popl %edx
#popl %edx

et_exit:
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80