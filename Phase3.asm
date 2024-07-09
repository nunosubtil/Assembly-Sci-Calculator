.data
    menu:       .asciiz "Help Topics:\n1. How to calculate power?\n2. How to calculate root?\n3. How to calculate sine?\nEnter choice: "
    newline:    .asciiz "\n"
    response:   .asciiz "Response: "
    help1:      .asciiz "To calculate power, use the power(base, exponent) function which multiplies the base by itself exponent times.\n\n"
    help2_text: .asciiz "To calculate root, use the root(number) function which approximates the square root of a number using iterative averaging.\n\n"
    help3_text: .asciiz "To calculate sine, use the sine(angle) function which approximates the sine of an angle using Taylor series expansion.\n\n"
    error_msg:  .asciiz "Invalid choice. Please try again.\n"
    buf:        .space 2             # Buffer para entrada do utilizador

.text
.globl main

main:
    li $v0, 4
    la $a0, menu              # Carregar endereço do menu
    syscall
    
    li $v0, 8
    la $a0, buf               # Buffer para armazenar entrada
    li $a1, 2                 # Número máximo de caracteres para ler (incluindo nova linha)
    syscall

    li $v0, 4                 # Imprimir nova linha após a entrada
    la $a0, newline
    syscall

    lb $t0, buf               # Carregar byte do buffer
    li $t1, '0'               # Valor ASCII para '0'
    sub $t0, $t0, $t1         # Subtrair '0' para converter ASCII para inteiro

    li $v0, 4                 # Preparar para imprimir mensagem
    bge $t0, 1, check2        # Verificar se entrada é 1 ou maior
    la $a0, response          # Imprimir "Response:" antes da mensagem de erro
    syscall
    la $a0, error_msg
    syscall
    j newline_main

check2:
    ble $t0, 3, display_help  # Se escolha está entre 1 e 3, exibir ajuda
    la $a0, response          # Imprimir "Response:" antes da mensagem de erro
    syscall
    la $a0, error_msg
    syscall
    j newline_main

display_help:
    la $a0, response          # Imprimir "Response:" antes da mensagem de ajuda
    syscall
    beq $t0, 1, help1_case    # Se escolha é 1, ir para help1_case
    beq $t0, 2, help2_case    # Se escolha é 2, ir para help2_case
    beq $t0, 3, help3_case    # Se escolha é 3, ir para help3_case
    j error                   # Qualquer outro caso é erro (verificação redundante)

help1_case:
    la $a0, help1
    j print_help

help2_case:
    la $a0, help2_text
    j print_help

help3_case:
    la $a0, help3_text
    j print_help

print_help:
    syscall                   # Imprimir mensagem de ajuda
    j newline_main            # Ir para nova linha após a mensagem de ajuda

error:
    la $a0, response          # Imprimir "Response:" antes da mensagem de erro
    syscall
    la $a0, error_msg
    syscall
    j newline_main            # Ir para nova linha após a mensagem de erro

newline_main:
    li $v0, 4                 # Imprimir nova linha
    la $a0, newline
    syscall
    j main                    # Retornar ao menu principal
