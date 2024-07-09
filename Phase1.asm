.data
    prompt:      .asciiz "Select Operations to proceed:\n1. Addition\n2. Subtraction\n3. Multiplication\n4. Decimal to binary\n5. Decimal to hexadecimal\n6. Binary to Decimal\n7. Binary to hexadecimal\n8. Hexadecimal to binary\n9. Hexadecimal to decimal\nEnter your choice: "
    promptNum:   .asciiz "Enter the number: "
    newline:     .asciiz "\n"
    promptNum1:  .asciiz "Enter the first number: "
    promptNum2:  .asciiz "Enter the second number: "
    resultMsg:   .asciiz "Result: "
    buffer: .space 33  # Space for binary input (32 bits + null terminator)
    binResult:   .space 33     # 32 bits + null terminator
    hexResult:   .space 9      # 8 hex digits + null terminator
    

.text
.globl main

main:
    # Exibir o menu
    li $v0, 4
    la $a0, prompt
    syscall

    # Ler a escolha do utilizador
    li $v0, 5
    syscall
    move $t0, $v0

    bgez $t0, dispatch
    j main

dispatch:
    # Verificar a escolha do utilizador e direcionar para a operação correspondente
    li $t1, 1
    beq $t0, $t1, addition
    li $t1, 2
    beq $t0, $t1, subtraction
    li $t1, 3
    beq $t0, $t1, multiplication
    li $t1, 4
    beq $t0, $t1, dec_to_bin  
    li $t1, 5
    beq $t0, $t1, dec_to_hex
    li $t1, 6
    beq $t0, $t1, bin_to_dec  
    li $t1, 7
    beq $t0, $t1, bin_to_hex
    li $t1, 8
    beq $t0, $t1, hex_to_bin
    li $t1, 9
    beq $t0, $t1, hex_to_dec
    j main

addition:
    # Adição
    li $v0, 4
    la $a0, promptNum1
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    li $v0, 4
    la $a0, promptNum2
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    add $t3, $t1, $t2

    li $v0, 4
    la $a0, resultMsg
    syscall
    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    j main

subtraction:
    # Subtração
    li $v0, 4
    la $a0, promptNum1
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    li $v0, 4
    la $a0, promptNum2
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    sub $t3, $t1, $t2

    li $v0, 4
    la $a0, resultMsg
    syscall
    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    j main

multiplication:
    # Multiplicação
    li $v0, 4
    la $a0, promptNum1
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    li $v0, 4
    la $a0, promptNum2
    syscall
    li $v0, 5
    syscall
    move $t2, $v0

    mul $t3, $t1, $t2

    li $v0, 4
    la $a0, resultMsg
    syscall
    li $v0, 1
    move $a0, $t3
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    j main

dec_to_bin:
    # Decimal para Binário
    li $v0, 4
    la $a0, promptNum
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    la $t2, binResult
    addi $t2, $t2, 32

bin_loop:
    li $t0, 2
    div $t1, $t0
    mfhi $t3
    addi $t3, $t3, '0'
    sb $t3, 0($t2)
    addi $t2, $t2, -1
    mflo $t1
    bnez $t1, bin_loop

    addi $t2, $t2, 1

    li $v0, 4
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j main

dec_to_hex:
    # Decimal para Hexadecimal
    li $v0, 4
    la $a0, promptNum
    syscall
    li $v0, 5
    syscall
    move $t1, $v0

    la $t2, hexResult
    addi $t2, $t2, 8

hex_loop:
    li $t0, 16
    div $t1, $t0
    mfhi $t3
    addi $t3, $t3, '0'
    blt $t3, '9', hex_digit
    addi $t3, $t3, 7

hex_digit:
    sb $t3, 0($t2)
    addi $t2, $t2, -1
    mflo $t1
    bnez $t1, hex_loop

    addi $t2, $t2, 1
    sb $zero, 8($t2)

    li $v0, 4
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j main

bin_to_dec:
    # Binário para Decimal
    li $v0, 4
    la $a0, promptNum
    syscall

    li $v0, 8
    la $a0, buffer
    li $a1, 33
    syscall

    move $t1, $zero
    la $t2, buffer

read_digit:
    lb $t3, 0($t2)
    beq $t3, $zero, prepare_output

    andi $t3, $t3, 0x1

    sll $t1, $t1, 1
    add $t1, $t1, $t3

    addi $t2, $t2, 1
    j read_digit

prepare_output:
    sra $t1, $t1, 1

display_result:
    li $v0, 4
    la $a0, resultMsg
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j main

bin_to_hex:
    # Binário para Hexadecimal
    li $v0, 4
    la $a0, promptNum
    syscall

    li $v0, 8
    la $a0, buffer
    li $a1, 33
    syscall

    move $t1, $zero
    la $t2, buffer

bin_to_dec_loop:
    lb $t3, 0($t2)
    beq $t3, $zero, prepare_conversion
    andi $t3, $t3, 0x1

    sll $t1, $t1, 1
    add $t1, $t1, $t3

    addi $t2, $t2, 1
    j bin_to_dec_loop

prepare_conversion:
    sra $t1, $t1, 1

bin_to_hex_convert:
    move $t4, $t1
    la $t2, hexResult
    addi $t2, $t2, 8

dec_to_hex_loop:
    li $t0, 16
    div $t4, $t0
    mfhi $t3
    addi $t3, $t3, '0'
    blt $t3, '9', hex_digit_handle
    addi $t3, $t3, 7

hex_digit_handle:
    sb $t3, 0($t2)
    addi $t2, $t2, -1
    mflo $t4
    bnez $t4, dec_to_hex_loop

    addi $t2, $t2, 1
    sb $zero, 8($t2)

    li $v0, 4
    move $a0, $t2
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j main

hex_to_bin:
    # Hexadecimal para Binário
    li $v0, 4
    la $a0, promptNum
    syscall

    li $v0, 8
    la $a0, hexResult
    li $a1, 9
    syscall

    la $t0, hexResult
    la $t1, binResult
    li $t2, 0

hex_to_bin_loop:
    lb $t3, 0($t0)
    beq $t3, $zero, display_binary_result

    # Converter dígito hexadecimal para binário
    li $t4, 4
    move $t5, $t3

    blt $t3, 48, next_char
    bgt $t3, 102, next_char
    blt $t3, 58, convert_numeric
    blt $t3, 65, next_char
    blt $t3, 71, convert_upper_hex
    blt $t3, 97, next_char
    ble $t3, 102, convert_lower_hex

convert_numeric:
    addi $t5, $t3, -48
    j convert_to_binary

convert_upper_hex:
    addi $t5, $t3, -55
    j convert_to_binary

convert_lower_hex:
    addi $t5, $t3, -87

convert_to_binary:
    li $t6, 8
    li $t7, 3

convert_loop:
    and $t8, $t5, $t6
    srlv $t8, $t8, $t7
    addi $t8, $t8, '0'
    sb $t8, 0($t1)
    addi $t1, $t1, 1
    srl $t6, $t6, 1
    addi $t7, $t7, -1
    bgez $t7, convert_loop

next_char:
    addi $t0, $t0, 1
    j hex_to_bin_loop

display_binary_result:
    li $v0, 4
    la $a0, resultMsg
    syscall

    li $v0, 4
    la $a0, binResult
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j main

hex_to_dec:
    # Hexadecimal para Decimal
    li $v0, 4
    la $a0, promptNum
    syscall

    li $v0, 8
    la $a0, hexResult
    li $a1, 9
    syscall

    la $t1, hexResult
    li $t2, 0

read_hex_digit:
    lb $t3, 0($t1)
    beq $t3, $zero, display_hex_dec_result

    blt $t3, 48, skip_digit
    bgt $t3, 102, skip_digit
    blt $t3, 58, numeric
    blt $t3, 65, skip_digit
    blt $t3, 71, upper_case
    blt $t3, 97, skip_digit
    bgt $t3, 102, skip_digit
    j lower_case

numeric:
    addi $t4, $t3, -48
    j calculate

upper_case:
    addi $t4, $t3, -55
    j calculate

lower_case:
    addi $t4, $t3, -87

calculate:
    sll $t2, $t2, 4
    add $t2, $t2, $t4
    addi $t1, $t1, 1
    j read_hex_digit

skip_digit:
    addi $t1, $t1, 1
    j read_hex_digit

display_hex_dec_result:
    li $v0, 4
    la $a0, resultMsg
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j main
