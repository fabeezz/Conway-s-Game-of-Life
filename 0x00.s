.data
matrix: .space 400
copie_matrix: .space 400
matrix_opt: .space 400

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
    pairScanf: .asciz "%d %d"
    integerScanf: .asciz "%d " 
    pairPrintf: .asciz "%d %d\n"
    integerPrintf: .asciz "%d "
    newlinePrintf: .asciz "\n"
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

                lea matrix_opt, %edi
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
        
        lea matrix_opt, %edi
        
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

        lea matrix_opt, %esi
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

movl $1, lineIndex
movl $1, columnIndex
afis_matrix:
    for_lines:
        movl lineIndex, %ecx
        cmp nr_linii, %ecx
        jg et_exit

        movl $1, columnIndex
            for_columns:
                movl columnIndex, %ecx
                cmp nr_coloane, %ecx
                jg nl
                # indexul este lineIndex*n + columnIndex
                movl lineIndex, %eax
                
                movl $0, %edx
                movl nr_coloane, %ebx
                addl $2 ,%ebx
                mull %ebx
                addl columnIndex, %eax
                # %eax = lineIndex*n +columnIndex
                
                lea matrix_opt, %edi
                movl (%edi, %eax, 4), %ebx
                
                pushl %ebx
                pushl $integerPrintf
                call printf
                popl %edx
                popl %edx
               
                pushl $0
                call fflush
                popl %edx

                incl columnIndex
                jmp for_columns
nl:
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $2, %edx
    int $0x80

incl lineIndex
jmp for_lines

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
