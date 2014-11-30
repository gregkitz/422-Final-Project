* Title      : Disassembler OP Code                              |
* Written by : Dallas Van Ess                                    |  
* Date       : 11/30/2014                                        |   
* Description: Code for distinguishing Opcodes in an instruction |     
* TODO:         Work with Greg to implement ADDA                 |
*-----------------------------------------------------------------


*------------------
* Equates Section |
*------------------

CR          EQU         $0D             * Hex value for Carriage Return
LF          EQU         $0A             * Hex value for New Line Read
START       EQU         $400            * Address for ORG
start_addr  EQU         $00007000       * Starting address where the program is stored
test_bit1   EQU         $3200           * A Value to be used for testing 
test_bit2   EQU         $E459           * A Value to be used for testing  
holder      EQU         $3F0            * Location of lines to test
nop_str     EQU         $4E71           * Hex value for NOP
neg_str     EQU         $44             * Hex value for NEG
jsr_str     EQU         $13A            * Hex value for JSR
rts_str     EQU         $4E75           * Hex value for RTS
bcs_str     EQU         $65             * Hex value for BCS
bge_str     EQU         $6C             * Hex value for BGE
blt_str     EQU         $6D             * Hex value for BLT
bvc_str     EQU         $68             * Hex value for BVC
bra_str     EQU         $60             * Hex value for BRA
add_str     EQU         $D              * Hex value for ADD
bov_str     EQU         $1              * Hex value for MOVE.B
wov_str     EQU         $3              * Hex value for MOVE.W
lov_str     EQU         $2              * Hex value for MOVE.L
mmo_str     EQU         $91             * Hex value for MOVEM(Register to memory)
rmo_str     EQU         $99             * Hex value for MOVEM(Memory to register)
sub_str     EQU         $9              * Hex value for SUB
qsu_str     EQU         $5              * Hex value for SUBQ
mul_str     EQU         $C              * Hex value for MULS
div_str     EQU         $8              * Hex value for DIVS (Look for 111 after the register)
lea_str     EQU         $4              * Hex value for LEA
or_str      EQU         $8              * Hex value for OR
ori_str     EQU         $00             * Hex value for ORI
eor_str     EQU         $B              * Hex value for EOR
eoi_str     EQU         $A              * Hex value for EORI
shf_str     EQU         $E              * Hex value for Logical Shifts (Need to check the rest of the bits to determine which shift bits 4 and 3 are 1 0 if its a shift, 11 if a rotate)
bcl_str     EQU         $0              * Hex value for BCLR

EXIT        EQU         $2700           * Simulator Stop code

*------------------
* Code Section    |
*------------------
            ORG         START
            LEA         holder,A0       * Store pattern to find     
            MOVE.L     #test_bit1,(A0)  * Store test bit         
            MOVE.L      (A0),D0         * Move the entire line into D0
            MOVE.L      D0,D2           * Save initial D0 for later use                                             

WORD:       CMP         #nop_str,D0     * is it NOP?
            BEQ         NOP_RT          * IF so, branch to NOP subroutine
            CMP         #rts_str,D0     * is it RTS?
            BEQ         RTS_RT          * If so, branch to RTS subroutine
            MOVE.W      D0,D3
            * ---CHECKING 12 BIT LONG OPCODES--- *            
            ANDI.B      #$F0,D3         * Clear very last digit
            ASR.W       #4,D3           * Shift remaining digits right 
            CMP         #jsr_str,D3     * is it JSR?
            BEQ         JSR_RT          * If so, branch to JSR subroutine
            

BYTE:       ANDI.W      #$FF00,D2       * Remove last 2 characters
            LSR         #8,D2
            CMP         #bcs_str,D2     * is it BCS?
            BEQ         BCS_RT          * If so, branch to BCS subroutine
            CMP         #bge_str,D2     * is it BGE?
            BEQ         BGE_RT          * If so, branch to BGE subroutine
            CMP         #blt_str,D2     * is it BLT?
            BEQ         BLT_RT          * If so, branch to BLT subroutine
            CMP         #bvc_str,D2     * is it BVC?
            BEQ         BVC_RT          * If so, branch to BVC subroutine
            CMP         #bra_str,D2     * is it BRA?
            BEQ         BRA_RT          * If so, branch to BRA subroutine
            CMP         #neg_str,D2     * is it NEG?
            BEQ         NEG_RT          * If so, branch to NEG subroutine            
            CMP         #mmo_str,D2     * is it MOVEM?
            BEQ         MMO_RT          * If so, branch to MOVEM subroutine            
            CMP         #rmo_str,D2     * is it MOVEM?
            BEQ         RMO_RT          * If so, branch to MOVEM subroutine            
            CMP         #ori_str,D2     * is it ORI?
            BEQ         ORI_RT          * If so, branch to ORI subroutine            


            

NIBBLE:     MOVE.W      D0,D2
            ANDI.W      #$F000,D2
            ASR.L       #8,D2
            ASR.L       #4,D2
            CMPI        #eor_str,D2     * Is it EOR?
            BEQ         EOR_RT
            CMPI        #shf_str,D2     * Is it a shift?
            BEQ         SHF_RT                  
            CMPI        #lea_str,D2     * Is it LEA?
            BEQ         FOU_RT                                           
            CMPI        #or_str,D2      * Is it OR?
            BEQ         OR_RT
            CMPI        #bcl_str,D2     * Is it BCLR?
            BEQ         ZER_RT
            CMPI        #add_str,D2     * Is it ADD?
            BEQ         ADD_RT
            CMPI        #sub_str,D2     * Is it SUB?
            BEQ         SUB_RT
            CMPI        #mul_str,D2     * Is it MULS?
            BEQ         MUL_RT
            CMPI        #div_str,D2     * Is it DIVS?
            BEQ         DIV_RT
            CMPI        #qsu_str,D2     * Is it SUBQ?
            BEQ         QSU_RT
            CMPI        #bov_str,D2     * Is it MOVE.B?
            BEQ         BOV_RT
            CMPI        #wov_str,D2     * Is it MOVE.W?
            BEQ         WOV_RT
            CMPI        #lov_str,D2     * Is it MOVE.L?
            BEQ         LOV_RT
            BRA         N_FOUND
            
            
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
BCS_RT:     LEA         bcs_message,A1  * Print BCS
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
            BRA         FINISH
BGE_RT:     LEA         bge_message,A1  * Print BGE
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
            BRA         FINISH
BLT_RT:     LEA         blt_message,A1  * Print BLT
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
            BRA         FINISH
BVC_RT:     LEA         bvc_message,A1  * Print BVC
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
            BRA         FINISH                                                
BRA_RT:     LEA         bra_message,A1  * Print BRA
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here
            BRA         FINISH                        
           
EOR_RT     LSR         #6,D2           * Remove the last 6 bits from the string          
           MOVE.B      D2,D3           * Copy current string
           ANDI.B      #$0F,D3         * Clear second to last digit
           SUB         #8,D3           * Subtract 8 from string
           CMPI        #4,D3           * Is is a CMP function? 
           BLT         CMP_RT          * Branch to CMP routine
           LEA         eor_message,A1  * Otherwise it's an EOR function 
           MOVE.B      #14,D0
           TRAP        #15
           BRA         FINISH 
           
CMP_RT     LEA         cmp_message,A1
           MOVE.B      #14,D0
           TRAP        #15
           BRA         FINISH
           
SHF_RT      MOVE.W      D0,D2
            MOVE.B      D2,D3          * Copy string for manipulation
            MOVE.B      D3,D4          * Copy again 
            ANDI.B      #$0F,D4        * Clear second to last digit
            DIVS        #8,D4          * Get the least significant bit
            CMPI.W      #0,D4          * Is is zero?
            BEQ         AS_RT          * If so, its an Arithemetic shift
            BRA         LS_RT          * Otherwise, Logical Shift
            
AS_RT      MOVE.B       D2,D3          * Copy string 
           ANDI.B       #00,D2         * Clear second half of the byte
           LSR          #8,D2          * Shift digits all the way right
           ANDI.B       #$0F,D2        * Clear second to last digit
           LSR.W        #1,D2          * Shift one bit to the right
           BCS          LA_RT          * If it's even, we have ASL
           BRA          RA_RT          * Otherwise, it's ASR
           
LA_RT     LEA           asl_message,A1
          MOVE.B        #14,D0
          TRAP          #15
          BRA           FINISH

RA_RT     LEA           asr_message,A1
          MOVE.B        #14,D0
          TRAP          #15
          BRA           FINISH
            
                       
LS_RT      MOVE.B       D3,D7          * Copy string to check if its a Rotate
           ANDI         #$F0,D7        * Clear last character
           LSR          #4,D7          * Shift 4 bits to the right
           CMP          #5,D7          * If its a 5, we have a rotate
           BEQ          RO_RT          * Branch to Rotate
           MOVE.B       D2,D3          * Copy string 
           ANDI.B       #00,D2         * Clear second half of the byte 
           LSR          #8,D2          * Shift digits all the way right
           ANDI.B       #$0F,D2        * Clear second to last digit
           LSR.W        #1,D2          * Shift least significant bit into the carry bit
           BCS          LL_RT          * If its the LSBit was 1, we have LSL
           BRA          RL_RT          * Otherwise, its LSR
           
LL_RT     LEA           lsl_message,A1
          MOVE.B        #14,D0
          TRAP          #15
          BRA           FINISH

RL_RT     LEA           lsr_message,A1
          MOVE.B        #14,D0
          TRAP          #15
          BRA           FINISH
          
RO_RT     MOVE.B       D2,D3          * Copy string 
          ANDI.B       #00,D2         * Clear second half of the byte 
          LSR          #8,D2          * Shift digits all the way right
          ANDI.B       #$0F,D2        * Clear second to last digit
          LSR.W        #1,D2          * Shift least significant bit into the carry bit
          BCS          LR_RT          * If its the LSBit was 1, we have ROL
          BRA          RR_RT          * Otherwise, its ROR

          
LR_RT    LEA           rol_message,A1
         MOVE.B        #14,D0
         TRAP          #15
         BRA           FINISH   

RR_RT    LEA           ror_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH

FOU_RT   ANDI          #$0F0,D3        * Checking 2nd most significant nibble 
         LSR.W         #4,D3           * Shift for consistency
         LSR.B         #1,D3           * Shift 1 bit right to check parity bit
         BCS           LEA_RT          * If odd, its LEA
         BRA           MM_RT           * Otherwise it's MOVEM
         
         
LEA_RT   LEA           lea_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
          
OR_RT    LEA           or_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
ZER_RT   MOVE.W        D0,D1           * Copy original string
         ANDI.W        #$FF00,D1        * Clear the lower byte 
         LSR.W         #8,D1           * Shift for consistency
         LSR.B         #1,D1           * Move the lowest bit into the carry bit
         BCS           BCL_RT          * If its a 1, its BCLR 
         BRA           ICM_RT          * Otherwise its CMPI
         
BCL_RT   LEA           bcl_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH

ICM_RT   LEA           icm_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
      

ADD_RT   LEA           add_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH

SUB_RT   LEA           sub_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
MUL_RT   LEA           mul_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH

DIV_RT   LEA           div_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
BOV_RT   LEA           bov_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
WOV_RT   MOVE          D0,D1           * Copy original string
         ANDI.W        #$0FF0,D1       * Clear top and bottom nibbles
         LSR.W         #4,D1           * Shift for consistency 
         LSR.B         #2,D1           * Shift last 2 bits out to check Destination mode 
         ANDI.B        #$0F,D1         * Clear top nibble of the last byte 
         CMPI.B        #1,D1           * If bottom nibble is 1, its MOVEA.W 
         BEQ           AWO_RT          * Branch to MOVEA.W routine 
         LEA           wov_message,A1  * Other wise it's just MOVE.W
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH

         
LOV_RT   MOVE          D0,D1           * Copy original string
         ANDI.W        #$0FF0,D1       * Clear top and bottom nibbles
         LSR.W         #4,D1           * Shift for consistency 
         LSR.B         #2,D1           * Shift last 2 bits out to check Destination mode 
         ANDI.B        #$0F,D1         * Clear top nibble of the last byte 
         CMPI.B        #1,D1           * If bottom nibble is 1, its MOVEA.L 
         BEQ           ALO_RT          * Branch to MOVEA.L routine 
         LEA           lov_message,A1  * Other wise it's just MOVE.L
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
AWO_RT   LEA           awo_message,A1  
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH

ALO_RT   LEA           alo_message,A1  
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
MM_RT    MOVE          D0,D1        * New copy of the original string
         ANDI.W        #$FF00,D1    * Get the upper byte
         LSR.W         #8,D1        * Shift for consistency
         LSR.B         #2,D1        * Shift 2 bits first
         LSR.B         #1,D1        * Shift 1 more bit to check which MOVEM
         BCS           MMO_RT       * If the 10th bit is set, its a MOVEM from memory to register
         BRA           RMO_RT       * Otherwise, its a MOVEM from register to memory         
MMO_RT   LEA           mmo_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
RMO_RT   LEA           rmo_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
           
QSU_RT   LEA           qsu_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
         
ORI_RT   LEA           ori_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BRA           FINISH
             
N_FOUND:    LEA         not_found,A1
            MOVE.B      #14,D0
            TRAP        #15
            BRA         FINISH 
    
FINISH:     LEA         finished,A1
            MOVE.B      #14,D0
            TRAP        #15                       
            STOP        #EXIT           * Halt Execution                                            
           
           
           
          EOR         D1,D3
          ASL         #2,D1
          ASR         #2,D1
          LSL         #2,D1
          LSR         #2,D1
          ROR         #2,D1
          ROL         #2,D1
          LEA         (A3),A0
          LEA         (A3),A1
          LEA         (A3),A2
          LEA         (A3),A3
          LEA         (A3),A4
          LEA         (A3),A5
          LEA         (A3),A6
          BCS          FINISH
          BCLR          D0,D1
          MOVE.W       D0,D1
          NEG           D0
          ADD          D0,D1
          MOVEM        D0-D7,(SP)-
          MOVEM        (SP)+,D0-D7
          SUBQ          #4,D1
          ORI           #2,D0
          CMPI          #2,D0        
          ORI           #3,D0
          MOVEA.W         A1,A2
          
*------------------
* Data Section |
*------------------

finished    DC.B        'Finished',CR,LF,0
not_found   DC.B        'No Opcodes were found',CR,LF,0
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
eor_message DC.B        'EOR',CR,LF,0
cmp_message DC.B        'CMP',CR,LF,0
asr_message DC.B        'ASR',CR,LF,0
asl_message DC.B        'ASL',CR,LF,0
lsr_message DC.B        'LSR',CR,LF,0
lsl_message DC.B        'LSL',CR,LF,0
rol_message DC.B        'ROL',CR,LF,0
ror_message DC.B        'ROR',CR,LF,0
lea_message DC.B        'LEA',CR,LF,0
or_message DC.B         'OR',CR,LF,0
bcl_message DC.B        'BCLR',CR,LF,0
add_message DC.B        'ADD',CR,LF,0
sub_message DC.B        'SUB',CR,LF,0
mul_message DC.B        'MULS',CR,LF,0
div_message DC.B        'DIVS',CR,LF,0
bov_message DC.B        'MOVE.B',CR,LF,0
wov_message DC.B        'MOVE.W',CR,LF,0
lov_message DC.B        'MOVE.L',CR,LF,0
awo_message DC.B        'MOVEA.W',CR,LF,0
alo_message DC.B        'MOVEA.L',CR,LF,0
mmo_message DC.B        'MOVEM (Memory to Register)',CR,LF,0
rmo_message DC.B        'MOVEM (Register to Memory)',CR,LF,0
qsu_message DC.B        'SUBQ',CR,LF,0
ori_message DC.B        'ORI',CR,LF,0
icm_message DC.B        'CMPI',CR,LF,0
data        DC.B        'DATA ',0    


            END         START





   







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
