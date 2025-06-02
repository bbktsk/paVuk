# one of each instruction to test the decoder

l1:     beq x1,x2,l1
        bne x3,x4,l1
        blt x5,x6,l2
        bge x6,x6,l1
l2:     bltu x7,x8,l1
        bgeu x0,x31,l2

        addi x1,x2,1
        slti x3,x4,-2
        sltiu x9,x2,11
        xori x15,x1,23
        ori x30,x29,-1
        andi x22,x23,1234
        slli x2,x1,3
        srli x9,x9,9
        srai x10,x11,31

        add x1,x2,x3
        sub x1,x0,x4
        sll x1,x9,x8
        slt x9,x10,x11
        sltu x11,x12,x13
        xor x1,x1,x1
        srl x9,x2,x0
        sra x22,x23,x24
        or x31,x30,x29
        and x28,x27,x26
