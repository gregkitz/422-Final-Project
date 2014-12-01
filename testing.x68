*-----------------------------------------------------------
* Title      :   Full Test Code
* Written by :   Luke Selbeck
* Date       :   November 27th, 2014
* Description:   Full test code for the decompiler, goes through
*                all possible suuported instructions.  Follows
*                the Supported Instructions table from the week
*                10 progress report, in alphabetical order.
*-----------------------------------------------------------
  
START:  ORG    $6000
    
        * inital data for testing
        MOVE        #5,D1
        MOVE        #3,D2
        
        *all ea for ADD
        ADD         D1,D3
        ADD         A1,D3
        ADD         (A1),D3
        ADD         (A1)+,D3
        ADD         -(A1),D3
        ADD         #-10,D3

        ADD         D3,A1
        ADD         D3,(A1)
        ADD         D3,(A1)+
        ADD         D3,-(A1)
        *test different sizes
        ADD.B       D1,D3
        ADD.W       D1,D3
        ADD.L       D1,D3
        
        
        *all ea for ADDA
        ADDA        D1,A3
        ADDA        A1,A3
        ADDA        (A1),A3
        ADDA        (A1)+,A3
        ADDA        -(A1),A3
        ADDA        #-10,A3
        *test different sizes
        ADDA.W      #-10,A3
        ADDA.L      #-10,A3
        
        
        *all ea for ASL
        ASL         D1,D2
        
        ASL         #1,D1
        
        ASL         (A1)
        ASL         (A1)+
        ASL         -(A1)
        *test different sizes
        ASL.W       -(A1)
        ASL.L       #1,D1
        
        
        *all ea for ASR
        ASR         D1,D2
        
        ASR         #1,D1
        
        ASR         (A1)
        ASR         (A1)+
        ASR         -(A1)
        *test different sizes
        ASR.B       #1,D1
        ASR.W       #1,D1
        ASR.L       #1,D1


        *all ea for BCLR
        BCLR        D3,(A1)
        BCLR        D3,(A1)+
        BCLR        D3,-(A1)

        BCLR        #3,(A1)
        BCLR        #3,(A1)+
        BCLR        #3,-(A1)
        *test different sizes
        BCLR.B      #3,-(A2)
        
        
        *all Bcc
        BCS Dear
Dear    BGE Greg
Greg    BLT and
and     BRA Dallas
Dallas  BVC HIII


        MOVE.L      #$FFFF0000,(A1)   *reset A1 for use later


        *all ea for CMP
HIII    CMP         D1,D2
        CMP         A1,D2
        CMP         (A1),D2
        CMP         (A1)+,D2
        CMP         -(A1),D2
        CMP         #-10,D2
        *test different sizes
        CMP.B       #-10,D2
        CMP.W       #-10,D2
        CMP.L       #-10,D2
        
        
        *all ea for CMPI
        CMPI        #5,D3
        CMPI        #5,(A1)
        CMPI        #5,(A1)+
        CMPI        #5,-(A1)
        *test different sizes
        CMPI.B      #5,D3
        CMPI.W      #5,D3
        CMPI.L      #5,D3
        
        
        *all ea for DIVS
        DIVS        D1,D3
        DIVS        (A1),D3
        DIVS        (A1)+,D3
        DIVS        -(A1),D3
        DIVS        #-10,D3
        *test different sizes
        DIVS.W      #-10,D3
        
        
        *all ea for EOR
        EOR         D1,D3
        EOR         D3,(A1)
        EOR         D3,(A1)+
        EOR         D3,-(A1)
        *test different sizes
        EOR.B       D1,D3
        EOR.W       D1,D3
        EOR.L       D1,D3
        
        
        *JSR has been moved to the bottom for program
        *branching convenience
        
        
        *all ea for LEA
        LEA         (A1),A3
        *test different sizes
        LEA.L       (A1),A3
        
        
        *all ea for LSL
        LSL         D1,D2
        
        LSL         #1,D1
        
        LSL         (A1)
        LSL         (A1)+
        LSL         -(A1)
        *test different sizes
        LSL.B       #1,D1
        LSL.W       #1,D1
        LSL.L       #1,D1
        
        
        *all ea for LSR
        LSR         D1,D2
        
        LSR         #1,D1
        
        LSR         (A1)
        LSR         (A1)+
        LSR         -(A1)
        *test different sizes
        LSR.B       #1,D1
        LSR.W       #1,D1
        LSR.L       #1,D1
        
        
        *all ea for MOVE        
        MOVE        D1,D3
        MOVE        D1,A1
        MOVE.L      #$FFFF0000,A1   *reset A1 for use later
        MOVE        D1,(A1)
        MOVE        D1,(A1)+
        MOVE        D1,-(A1)
        
        MOVE        A1,D3
        MOVE        A1,A1
        MOVE        A1,(A1)
        MOVE        A1,(A1)+
        MOVE        A1,-(A1)
        
        MOVE        (A1),D3
        MOVE        (A1),A1
        MOVE        (A1),(A1)
        MOVE        (A1),(A1)+
        MOVE        (A1),-(A1)
        
        MOVE        (A1)+,D3
        MOVE        (A1)+,A2
        MOVE.L      #$FFFF0000,A2   *reset A2 for use later
        MOVE.L      #$FFFF0000,(A1) *reset A1 for use later
        MOVE        (A1)+,(A2)
        MOVE        (A1)+,(A2)+
        MOVE        (A1)+,-(A2)
        
        MOVE        -(A1),D3
        MOVE        -(A1),A2
        MOVE        -(A1),(A2)
        MOVE        -(A1),(A2)+
        MOVE        -(A1),-(A2)
        
        MOVE        #6,D3
        MOVE        #6,A2
        MOVE        #6,(A2)
        MOVE        #6,(A2)+
        MOVE        #6,-(A2)
        *test different sizes
        MOVE.B      #6,D3
        MOVE.W      #6,D3
        MOVE.L      #6,D3
        
        
        *all ea for MOVEA
        MOVEA       D1,A3
        MOVEA       A1,A3
        MOVEA       (A1),A3
        MOVEA       (A1)+,A3
        MOVEA       -(A1),A3
        MOVEA       #4,A3
        *test different sizes
        MOVEA.W     #4,A3
        MOVEA.L     #4,A3


        *all ea for MOVEM
        MOVEM       D0-D7,(A1)
        MOVEM       D0-D7,-(A1)
        
        MOVEM       (A1),D0-D7
        MOVEM       (A1)+,D0-D7
        *test different sizes
        MOVEM.W     (A1)+,D0-D7
        MOVEM.L     (A1)+,D0-D7
        
        
        *all ea for MULS
        MULS        D1,D1
        MULS        (A1),D1
        MULS        (A1)+,D1
        MULS        -(A1),D1
        MULS        #4,D1
        *test different sizes
        MULS.W      #4,D1
        
        
        *all ea for NEG
        NEG         D1
        NEG         (A1)
        NEG         (A1)+
        NEG         -(A1)
        *test different sizes
        NEG.B       D1
        NEG.W       D1
        NEG.L       D1
        
        
        *all ea for OR
        OR          D1,D1
        OR          (A1),D1
        OR          (A1)+,D1
        OR          -(A1),D1
        OR          #$A,D1
        
        OR          D2,D3
        OR          D2,(A1)
        OR          D2,(A1)+
        OR          D2,-(A1)
        *test different sizes
        OR.B        D2,D3
        OR.W        D2,D3
        OR.L        D2,D3
        
        
        *all ea for ORI
        ORI         #$F,D3
        ORI         #$F,(A1)
        ORI         #$F,(A1)+
        ORI         #$F,-(A1)
        *test different sizes
        ORI.B       #$F,D3
        ORI.W       #$F,D3
        ORI.L       #$F,D3
        
        
        *all ea for ROL
        ROL         D1,D2
        ROL         #2,D1
        *test different sizes
        ROL.B       #2,D1
        ROL.W       #2,D1
        ROL.L       #2,D1
        
        
        *all ea for ROR
        ROR         D1,D2
        ROR         #2,D1
        *test different sizes
        ROR.B       #2,D1
        ROR.W       #2,D1
        ROR.L       #2,D1
        
        
        *RTS has been moved to the bottom for program
        *branching convenience
        
        
        *all ea for SUB
        SUB          D1,D1
        SUB         A1,D1
        SUB         (A1),D1
        SUB         (A1)+,D1
        SUB         -(A1),D1
        SUB         #$A,D1
        
        SUB         D2,D3
        SUB         D2,A1
        MOVE.L      #$FFFF0000,A1   *reset A1 for use later
        SUB         D2,(A1)
        MOVE.L      #$FFFF0000,A1   *reset A1 for use later
        SUB         D2,(A1)+
        SUB         D2,-(A1)
        *test different sizes
        SUB.B       D2,D3
        SUB.W       D2,D3
        SUB.L       D2,D3
        
        
        *all ea for SUBQ
        SUBQ        #4,D3
        SUBQ        #4,A1
        SUBQ        #4,(A1)
        SUBQ        #4,(A1)+
        SUBQ        #4,-(A1)
        *test different sizes
        SUBQ.B      #4,D3
        SUBQ.W      #4,D3
        SUBQ.L      #4,D3
        
        
        *JSR
        JSR         next
        BRA         finish


        *RTS
next    RTS       
        
        
        *end of test code
finish  SIMHALT
        END    START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
