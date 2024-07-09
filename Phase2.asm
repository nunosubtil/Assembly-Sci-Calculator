.data
    input_num: .float 0.0
    angle: .float 0.785398  # Ângulo em radianos (aproximadamente 45 graus)
    msgOperations: .asciiz "\n\nOperations:\n1. Power\n2. Root\n3. Sine\n4. Cosine\n5. Log base 2\n6. Log base 10\n\nEnter the number to perform all the operations above: "
    msg1: .asciiz "\nSquare: "
    msg2: .asciiz "\nRoot: "
    msg3: .asciiz "\nSine: "
    msg4: .asciiz "\nCosine: "
    msgLn2: .asciiz "\nLog base 2: "
    msgLn10: .asciiz "\nLog base 10: "
    zero: .float 0.0
    one: .float 1.0
    two: .float 2.0
    three: .float 3.0
    four: .float 4.0
    six: .float 6.0
    ten: .float 10.0
    half: .float 0.5
    twentyfour: .float 24.0
    onehundredtwenty: .float 120.0
    epsilon: .float 0.00001
    ln10: .float 2.30258509 # Logaritmo natural de 10

.text
.globl main

main:
main_loop:
    # Mostrar operações e pedir input
    li $v0, 4
    la $a0, msgOperations
    syscall

    # Obter input do utilizador
    li $v0, 6
    syscall
    swc1 $f0, input_num

    # Calcular e mostrar quadrado
    l.s $f12, input_num
    mul.s $f0, $f12, $f12
    li $v0, 4
    la $a0, msg1
    syscall
    li $v0, 2
    mov.s $f12, $f0
    syscall

    # Calcular e mostrar raiz quadrada
    l.s $f12, input_num
    jal root
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 2
    mov.s $f12, $f0
    syscall

    # Calcular e mostrar seno
    l.s $f12, angle
    jal sine
    li $v0, 4
    la $a0, msg3
    syscall
    li $v0, 2
    mov.s $f12, $f0
    syscall

    # Calcular e mostrar cosseno
    l.s $f12, angle
    jal cosine
    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 2
    mov.s $f12, $f0
    syscall

    # Calcular e mostrar log base 2
    l.s $f12, input_num
    jal log_base_2
    li $v0, 4
    la $a0, msgLn2
    syscall
    li $v0, 2
    mov.s $f12, $f0
    syscall

    # Calcular e mostrar log base 10
    l.s $f12, input_num
    jal log_base_10
    li $v0, 4
    la $a0, msgLn10
    syscall
    li $v0, 2
    mov.s $f12, $f0
    syscall

    j main_loop

# Cálculo da raiz quadrada usando o método de Newton
root:
    l.s $f0, one
    l.s $f1, input_num

root_loop:
    div.s $f2, $f1, $f0
    add.s $f3, $f2, $f0
    l.s $f4, half
    mul.s $f0, $f3, $f4
    sub.s $f5, $f0, $f2
    abs.s $f5, $f5
    l.s $f6, epsilon
    c.lt.s $f5, $f6
    bc1t root_done
    j root_loop

root_done:
    jr $ra

# Função seno através da expansão de Taylor
sine:
    mov.s $f0, $f12
    mul.s $f2, $f12, $f12
    mul.s $f3, $f2, $f12
    l.s $f4, six
    div.s $f3, $f3, $f4
    sub.s $f0, $f0, $f3
    mul.s $f5, $f2, $f2
    mul.s $f5, $f5, $f12
    l.s $f6, onehundredtwenty
    div.s $f5, $f5, $f6
    add.s $f0, $f0, $f5
    jr $ra

# Função cosseno através da expansão de Taylor
cosine:
    l.s $f0, one
    mul.s $f2, $f12, $f12
    l.s $f3, two
    div.s $f2, $f2, $f3
    sub.s $f0, $f0, $f2
    mul.s $f4, $f2, $f12
    mul.s $f4, $f4, $f12
    l.s $f5, twentyfour
    div.s $f4, $f4, $f5
    add.s $f0, $f0, $f4
    jr $ra

# Função logaritmo base 2
log_base_2:
    l.s $f3, zero
    l.s $f4, two
    l.s $f2, input_num

log_loop:
    c.lt.s $f2, $f4
    bc1t log_fractional
    div.s $f2, $f2, $f4
    l.s $f5, one
    add.s $f3, $f3, $f5
    j log_loop

log_fractional:
    l.s $f5, one
    sub.s $f6, $f2, $f5
    add.s $f3, $f3, $f6
    mov.s $f0, $f3
    jr $ra

# Função logaritmo base 10
log_base_10:
    l.s $f2, input_num
    l.s $f3, zero
    l.s $f4, ten
    l.s $f5, one
    l.s $f6, ln10

log10_loop:
    c.lt.s $f2, $f5
    bc1t log10_fraction
    c.lt.s $f4, $f2
    bc1f log10_fraction
    div.s $f2, $f2, $f4
    add.s $f3, $f3, $f5
    j log10_loop

log10_fraction:
    sub.s $f2, $f2, $f5
    add.s $f7, $f2, $f5
    div.s $f2, $f2, $f7
    mov.s $f7, $f2
    l.s $f8, two
    div.s $f9, $f7, $f8
    add.s $f2, $f2, $f9

    mul.s $f7, $f7, $f7
    l.s $f8, three
    div.s $f9, $f7, $f8
    add.s $f2, $f2, $f9

    mul.s $f7, $f7, $f7
    l.s $f8, four
    div.s $f9, $f7, $f8
    add.s $f2, $f2, $f9

    div.s $f2, $f2, $f6
    add.s $f0, $f3, $f2

    jr $ra