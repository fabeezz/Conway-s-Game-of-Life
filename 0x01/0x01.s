.data
matrix: .space 400
copie_matrix: .space 1600
cheie: .space 1600
        dummy: .space 400
nr_linii: .space 4
nr_coloane: .space 4
nr_cel_vii: .space 4
nr_iteratii: .space 4
linia: .space 4
coloana: .space 4
lineIndex: .long 1
columnIndex: .long 1
start: .space 4
finish: .space 4
suma_vecini: .space 4

mod: .space 4
parola: .space 100
parola_biti: .space 400
parola_criptata: .space 400
l_parola: .space 4
i: .long 0
i_afis: .long 0
q_mul: .space 4
l_cheie: .space 4
indice_cheie_full: .space 4
indice_cheie_initiala: .space 4
cod: .space 4
numar: .space 4

parola_biti_2: .space 400

    pairScanf: .asciz "%d %d"
    integerScanf: .asciz "%d" 
    integerPrintf: .asciz "%d "
    textScanf: .asciz "%s"
    textPrintf: .asciz "%s"
    inceputHexa: .asciz "0x"
    hexaPrintf: .asciz "%X"
    charPrintf: .asciz "%c"
    newline: .asciz "\n"
.text

.global main
main:

    pushl $nr_coloane
    pushl $nr_linii
    pushl $pairScanf
    call scanf
    popl %edx
    popl %edx
    popl %edx

    pushl $nr_cel_vii
    pushl $integerScanf
    call scanf
    popl %edx
    popl %edx

    mov $0, %ecx
loop_citire_matrix:
    cmp  nr_cel_vii, %ecx
    jge exit_loop_citire

    pushl %ecx # printf si scanf schimba pe %ecx

    pushl $coloana
    pushl $linia
    pushl $pairScanf
    call scanf
    popl %edx
    popl %edx
    popl %edx

    movl linia, %eax
    incl %eax
    movl nr_coloane, %ebx
    mull %ebx
    add coloana, %eax
    incl %eax

    lea matrix, %edi
    movb $1, (%edi, %eax, 4)

    popl %ecx

    inc %ecx
    jmp loop_citire_matrix
exit_loop_citire:

#citire nr_iteratii
pushl $nr_iteratii
pushl $integerScanf
call scanf
popl %edx
popl %edx

movl $1, lineIndex
movl $1, columnIndex

#pozitia de start: nr_coloane+1
        movl nr_coloane, %eax
        incl %eax
        movl %eax, start
        addl $2, start

#pozitia de finish: (nr_linii+1)*(nr_coloane+2)-2
        movl nr_linii, %eax
        incl %eax
        movl nr_coloane, %ebx
        addl $2, %ebx
        movl $0, %edx
        mull %ebx
        subl $2, %eax
        movl %eax, finish

mutare_matrix:
    for_lines_matrix:
        movl lineIndex, %ecx
        cmp nr_linii, %ecx
        jg mutare_matrix_out

        movl $1, columnIndex
            for_columns_matrix:
                movl columnIndex, %ecx
                cmp nr_coloane, %ecx
                jg nc
                # indexul este lineIndex*n + columnIndex
                movl lineIndex, %eax
                movl $0, %edx
                movl nr_coloane, %ebx
                mull %ebx
                addl columnIndex, %eax
                # %eax = lineIndex*n +columnIndex
                
                lea matrix, %edi
                movl (%edi, %eax, 4), %ebx

                movl start, %eax

                lea cheie, %edi
                movl %ebx, (%edi, %eax, 4)

                movl (%edi, %eax, 4), %ebx
                
                #pushl %eax
                #pushl $integerPrintf
                #call printf
                #popl %ebx
                #popl %ebx

                incl columnIndex
                incl start
                jmp for_columns_matrix
nc:
incl lineIndex
addl $2, start
jmp for_lines_matrix

mutare_matrix_out:

#pozitia de start: nr_coloane+1
        movl nr_coloane, %eax
        incl %eax
        movl %eax, start
        addl $2, start

#pozitia de finish: (nr_linii+1)*(nr_coloane+2)-2
        movl nr_linii, %eax
        incl %eax
        movl nr_coloane, %ebx
        addl $2, %ebx
        movl $0, %edx
        mull %ebx
        subl $2, %eax
        movl %eax, finish

movl $1, %eax
loop_iteratii:

cmp nr_iteratii, %eax
jg iteratii_exit

pushl %eax

#pozitia de start: nr_coloane+1
        movl nr_coloane, %eax
        incl %eax
        movl %eax, start
        addl $2, start

#pozitia de finish: (nr_linii+1)*(nr_coloane+2)-2
        movl nr_linii, %eax
        incl %eax
        movl nr_coloane, %ebx
        addl $2, %ebx
        movl $0, %edx
        mull %ebx
        subl $2, %eax
        movl %eax, finish

loop_matrix:

        movl start, %ecx
        cmp finish, %ecx
        jg loop_exit
        
        lea cheie, %edi
        
        movl $0, %esi
        #NV: 
        movl start, %ebx
        subl nr_coloane, %ebx
        subl $3, %ebx
        addl (%edi, %ebx, 4), %esi

        #N:
        movl start, %ebx
        subl nr_coloane, %ebx
        subl $2, %ebx
        addl (%edi, %ebx, 4), %esi

        #NE:
        movl start, %ebx
        subl nr_coloane, %ebx
        subl $1, %ebx
        addl (%edi, %ebx, 4), %esi

        #V:
        movl start, %ebx
        subl $1, %ebx
        addl (%edi, %ebx, 4), %esi

        #E:
        movl start, %ebx
        incl %ebx
        addl (%edi, %ebx, 4), %esi

        #SV:
        movl start, %ebx
        addl nr_coloane, %ebx
        addl $1, %ebx
        addl (%edi, %ebx, 4), %esi

        #S:
        movl start, %ebx
        addl nr_coloane, %ebx
        addl $2, %ebx
        addl (%edi, %ebx, 4), %esi

        #SE:
        movl start, %ebx
        addl nr_coloane, %ebx
        addl $3, %ebx
        addl (%edi, %ebx, 4), %esi

        movl %esi, suma_vecini

    movl (%edi, %ecx, 4), %eax
    lea copie_matrix, %edi # trecem pe matricea copie
    cmp $1, %eax
    je celula_vie
    
    celula_not_vie:
    
    movl suma_vecini, %eax
    cmp $3, %eax
    je atribuire_1
    
    jmp atribuire_0
    
    celula_vie:
    
    movl suma_vecini, %eax
    
    cmp $2, %eax # suma_vecini<2 ?
    jb atribuire_0
    
    cmp $3, %eax # suma_vecini>3 ?
    jg atribuire_0 
    
    #trecem pe cazul in care 2 <= suma_vecini <= 3
    atribuire_1:
    movb $1, (%edi, %ecx, 4)
    jmp if_exit
    
    atribuire_0:
    movb $0, (%edi, %ecx, 4)
    jmp if_exit
    
    if_exit:
        movl start, %eax # daca este final de linie (M_n+2 - 2)
        addl $2, %eax
        movl nr_coloane, %ebx
        addl $2, %ebx # in ebx avem n+2
        xorl %edx, %edx
        divl %ebx

        cmp $0, %edx
        je salt_de_3

salt_clasic:
        incl start
        jmp loop_matrix

salt_de_3:
        addl $3, start
        jmp loop_matrix

loop_exit:

#pozitia de start: nr_coloane+1
        movl nr_coloane, %eax
        incl %eax
        movl %eax, start
        addl $2, start

#pozitia de finish: (nr_linii+1)*(nr_coloane+2)-2
        movl nr_linii, %eax
        incl %eax
        movl nr_coloane, %ebx
        addl $2, %ebx
        movl $0, %edx
        mull %ebx
        subl $2, %eax
        movl %eax, finish

copiere_matrix:

        movl start, %ecx
        cmp finish, %ecx
        jg copiere_exit
        
        lea copie_matrix, %edi
        movl (%edi, %ecx, 4), %eax

        lea cheie, %esi
        movl %eax, (%esi, %ecx, 4)

        movl start, %eax # daca este final de linie (M_n+2 - 2)
        addl $2, %eax
        movl $0, %edx
        movl nr_coloane, %ebx
        addl $2, %ebx # in ebx avem n+2
        divl %ebx

        cmp $0, %edx
        je salt_de_3x

salt_clasicx:
        incl start
        jmp copiere_matrix

salt_de_3x:
        addl $3, start
        jmp copiere_matrix

copiere_exit:

popl %eax
incl %eax
jmp loop_iteratii
iteratii_exit:

#citire mod (criptare/decriptare)
pushl $mod
pushl $integerScanf
call scanf
popl %edx
popl %edx

#citire parola
pushl $parola
pushl $textScanf
call scanf
popl %edx
popl %edx

movl mod, %eax
cmp $1, %eax
je DECRIPTARE

CRIPTARE:
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
inc %ecx                     # trec la urmatorul caracter
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

#afisare "0x"
pushl $inceputHexa
pushl $textPrintf
call printf
popl %edx
popl %edx

pushl $0
call fflush
popl %edx

# BIN -> DEC -> HEX
movl $3, i
toHexa:
movl i, %ecx
cmp l_parola, %ecx
jg toHexa_end
    
    lea parola_criptata, %edi
    xorl %ebx, %ebx
    movl $0, numar
#011(1) - p=0
    movl (%edi, %ecx, 4), %ebx
    addl %ebx, numar
    decl %ecx
#01(1)1 - p=1
    movl (%edi, %ecx, 4), %ebx
    shll $1, %ebx
    addl %ebx, numar
    decl %ecx
#0(1)11 - p=2
    movl (%edi, %ecx, 4), %ebx
    shll $2, %ebx
    addl %ebx, numar
    decl %ecx
#(0)111 - p=3
    movl (%edi, %ecx, 4), %ebx
    shll $3, %ebx
    addl %ebx, numar

movl %ecx, i

pusha
    pushl numar
    pushl $hexaPrintf
    call printf
    popl %edx
    popl %edx
    pushl $0
    call fflush
    popl %edx
popa

addl $7, i
jmp toHexa
toHexa_end:
    
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80

jmp et_exit

DECRIPTARE:

movl $parola, %ecx           # pun adresa parolei in ecx
addl $2, %ecx                # sar "0x"
movl $3, %edx                # index pt parola_biti_2

for_caractere:
xorl %eax, %eax
movb (%ecx), %al             # mut byte-ul in al
test %al, %al                # final de string
jz for_caractere_end

#pusha
#pushl %eax
#pushl $integerPrintf
#call printf
#popl %edx
#popl %edx
#
#pushl $0
#call fflush
#popl %edx
#popa

#verificam ce caracter este
cmp $48, %al
je char0
cmp $49, %al
je char1
cmp $50, %al
je char2
cmp $51, %al
je char3
cmp $52, %al
je char4
cmp $53, %al
je char5
cmp $54, %al
je char6
cmp $55, %al
je char7
cmp $56, %al
je char8
cmp $57, %al
je char9
cmp $65, %al
je charA
cmp $66, %al
je charB
cmp $67, %al
je charC
cmp $68, %al
je charD
cmp $69, %al
je charE
cmp $70, %al
je charF

#punem in parola_biti_2 bitii specifici
char0:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char1:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char2:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char3:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char4:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char5:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char6:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char7:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
jmp char_end

char8:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

char9:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

charA:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

charB:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

charC:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

charD:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

charE:
lea parola_biti_2, %edi
movb $0, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

charF:
lea parola_biti_2, %edi
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
decl %edx
movb $1, (%edi, %edx, 4)
jmp char_end

char_end:

addl $7, %edx               # ajung pe pozitia 7 in array, plasez pana la poz 4, etc
inc %ecx                    # trec la urmatorul caracter
jmp for_caractere
for_caractere_end:

#l_parola = 47 (calculata inainte)

subl $4, %edx
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

pushl q_mul # am salvat q_mul

multiplicari2:
movl $0, indice_cheie_initiala

movl q_mul, %ecx
cmp $0, %ecx
je multiplicari2_exit

copiere_cheie2:
movl indice_cheie_initiala, %ecx
cmp l_cheie, %ecx
jg copiere_cheie2_end

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
jmp copiere_cheie2
copiere_cheie2_end:


decl q_mul
jmp multiplicari2
multiplicari2_exit:

popl q_mul # am salvat q_mul

xorl %edx, %edx
movl l_cheie, %eax
incl %eax
movl q_mul, %ebx
incl %ebx
mull %ebx
decl %eax
movl %eax, l_cheie

criptare2:
movl i, %ecx
cmp l_parola, %ecx
jg criptare2_exit


lea parola_biti_2, %edi
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
jmp criptare2
criptare2_exit:

#in :parola criptata: avem pe biti decriptat mesajul

# BIN -> ASCII -> CHAR
movl $7, i
toChar:
movl i, %ecx
cmp l_parola, %ecx
jg toChar_end
    
    lea parola_criptata, %edi
    xorl %ebx, %ebx
    movl $0, numar
#0 1 1 0 1 1 0 (1) - p=0
    movl (%edi, %ecx, 4), %ebx
    addl %ebx, numar
    decl %ecx
#0 1 1 0 1 1 (0) 1 - p=1
    movl (%edi, %ecx, 4), %ebx
    shll $1, %ebx
    addl %ebx, numar
    decl %ecx
#0 1 1 0 1 (1) 0 1 - p=2
    movl (%edi, %ecx, 4), %ebx
    shll $2, %ebx
    addl %ebx, numar
    decl %ecx
#0 1 1 0 (1) 1 0 1 - p=3
    movl (%edi, %ecx, 4), %ebx
    shll $3, %ebx
    addl %ebx, numar
    decl %ecx
#0 1 1 (0) 1 1 0 1 - p=4
    movl (%edi, %ecx, 4), %ebx
    shll $4, %ebx
    addl %ebx, numar
    decl %ecx
#0 1 (1) 0 1 1 0 1 - p=5
    movl (%edi, %ecx, 4), %ebx
    shll $5, %ebx
    addl %ebx, numar
    decl %ecx
#0 (1) 1 0 1 1 0 1 - p=6
    movl (%edi, %ecx, 4), %ebx
    shll $6, %ebx
    addl %ebx, numar
    decl %ecx
#(0) 1 1 0 1 1 0 1 - p=7
    movl (%edi, %ecx, 4), %ebx
    shll $7, %ebx
    addl %ebx, numar

movl %ecx, i

pusha
    pushl numar
    pushl $charPrintf
    call printf
    popl %edx
    popl %edx
    pushl $0
    call fflush
    popl %edx
popa

addl $15, i
jmp toChar
toChar_end:
    
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80

#afis_array:
#movl i_afis, %ecx
#cmp l_parola, %ecx
#jg afis_array_end
#
#lea parola_criptata, %esi
#movl (%esi, %ecx, 4), %eax
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
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
