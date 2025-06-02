        # Compute sum of numbers from 0 to 10
        # Result is in a0 (x10)
        # Enter infinite loop when complete
start:
        xor a0,a0,a0
        xor t0,t0,t0
        addi t0,t0,10
loop:
        add a0,a0,t0
        addi t0,t0,-1
        blt zero,t0,loop
        ecall
halt:
        beq zero, zero, halt    # beq instead of j to reduce number of needed instructions
