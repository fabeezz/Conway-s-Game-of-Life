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
    
pairScanf: .asciz "%d %d"
integerScanf: .asciz "%d " 
pairPrintf: .asciz "%d %d\n"
integerPrintf: .asciz "%d "
newlinePrintf: .asciz "\n"
newline: .asciz "\n"

    start: .space 4
    finish: .space 4
    suma_vecini: .space 4

pointer_in: .space 4
pointer_out: .space 4
read: .asciz "r"
write: .asciz "w"
inputFile: .asciz "in.txt"
outputFile: .asciz "out.txt"
.text

.global main
main:

pushl $read
pushl $inputFile
call fopen
popl %edx
popl %edx

in:
mov %eax, pointer_in

pushl $nr_linii
pushl $integerScanf
pushl pointer_in
call fscanf
popl %edx
popl %edx
popl %edx

pushl $nr_coloane
pushl $integerScanf
pushl pointer_in
call fscanf
popl %edx
popl %edx
popl %edx

pushl $nr_cel_vii
pushl $integerScanf
pushl pointer_in
call fscanf
popl %edx
popl %edx
popl %edx

mov $0, %ecx
loop_citire_matrix:
    cmp  nr_cel_vii, %ecx
    jge exit_loop_citire

    pushl %ecx # printf si scanf schimba pe %ecx

pushl $linia
pushl $integerScanf
pushl pointer_in
call fscanf
popl %edx
popl %edx
popl %edx

pushl $coloana
pushl $integerScanf
pushl pointer_in
call fscanf
popl %edx
popl %edx
popl %edx

# eax=(linia+1)*nr_coloane+(coloana+1) - aici punem cel_vie
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

#pushl $write
#pushl $outputFile
#call fopen
#popl %edx
#popl %edx

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

#out:
#mov %eax, pointer_out
#
#pushl n
#pushl $integerPrintf
#pushl pointer_out
#call fprintf
#popl %edx
#popl %edx
#popl %edx
#
#pushl $0
#call fflush
#popl %edx
#
#pushl m
#pushl $integerPrintf
#pushl pointer_out
#call fprintf
#popl %edx
#popl %edx
#popl %edx
#
#pushl $0
#call fflush
#popl %edx

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
