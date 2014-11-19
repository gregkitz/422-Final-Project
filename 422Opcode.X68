*-----------------------------------------------------------
* Title      : Week 1 OP Code
* Written by : Dallas Van Ess
* Date       : 11/18/2014
* Description: Code for Week 1 
*-----------------------------------------------------------

* Equates Section
CR          EQU         $0D             * Hex value for Carriage Return
LF          EQU         $0A             * Hex value for New Line Read
START       EQU         $400            * Address for ORG
start_addr  EQU         $00007000       * Starting address where the program is stored
msb_mask    EQU         $FF00           * Most Significant Byte Mask  
end_addr    EQU         $00008000       * Ending address where the program is stored
test_str    EQU         $3C2A4440       * A test string
nop_str     EQU         $4E71           * Hex value for NOP
neg_str     EQU         $44             * Hex value for NEG
jsr_str     EQU         $13A            * Hex value for JSR
rts_str     EQU         $4E75           * Hex value for RTS
bcc_str     EQU         $6              * Hex value for BCC
bcs_str     EQU         $5              * Hex value for BCS
bge_str     EQU         $C              * Hex value for BGE
blt_str     EQU         $D              * Hex value for BLT
bvc_str     EQU         $8              * Hex value for BVC
bra_str     EQU         $60             * Hex value for BRA
EXIT        EQU         $2700           * Simulator Stop code

* Code Section
            ORG         START
            MOVE.L      #test_str,D3    * store test string
            MOVE.L      D3,D4           * copy string
            ANDI.w      #msb_mask,D4    * get most significant byte          
            CMP         #nop_str,D0     * is it NOP?
            BEQ         NOP_RT          * If so, branch to NOP subroutine
            CMP         #neg_str,D0     * is it NEG?
            BEQ         NEG_RT          * If so, branch to NEG subroutine
            CMP         #jsr_str,D0     * is it JSR?
            BEQ         JSR_RT          * If so, branch to JSR subroutine
            CMP         #rts_str,D0     * is it RTS?
            BEQ         RTS_RT          * If so, branch to RTS subroutine
            CMP         #bcc_str,D0     * is it BCC?
            BEQ         BCC_RT          * If so, branch to BCC subroutine
            CMP         #bra_str,D0     * is it BRA?
            BEQ         BRA_RT          * If so, branch to BRA subroutine
* 32 BITS STORED IN MEMORY, GRAB 16 BITS, CHECK IF THERES A MATCH, IF NOT, GRAB 8 BITS, THEN 4 BITS
            
NOP_RT:     LEA         nop_message,A1  * Print NOP
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BRA         FINISH
NEG_RT:     LEA         neg_message,A1  * Print NEG
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here
            BRA         FINISH
JSR_RT:     LEA         jsr_message,A1  * Print JSR
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BRA         FINISH
RTS_RT:     LEA         rts_message,A1  * Print RTS
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BRA         FINISH
BCC_RT:     LEA         bcc_message,A1  * Print BCC
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
            BRA         FINISH
BRA_RT:     LEA         bra_message,A1  * Print BRA
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here
            BRA         FINISH
FINISH:     LEA         finished,A1
            MOVE.B      #14,D0
            TRAP        #15            
            
            STOP        #EXIT           * Halt Execution                                            
           
* Data Section
nop_message DC.B        'NOP',CR,LF,0
neg_message DC.B        'NEG',CR,LF,0
jsr_message DC.B        'JSR',CR,LF,0
rts_message DC.B        'RTS',CR,LF,0
bcc_message DC.B        'BCC',CR,LF,0
bcs_message DC.B        'BCS',CR,LF,0
bge_message DC.B        'BGE',CR,LF,0
blt_message DC.B        'BLT',CR,LF,0
bvc_message DC.B        'BVC',CR,LF,0
bra_message DC.B        'BRA',CR,LF,0
finished    DC.B        'Finished',CR,LF,0

data        DC.B        'DATA ',0    


            END         START





   


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
