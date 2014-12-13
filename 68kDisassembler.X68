*-----------------------------------------------------------
* Title      : 422 Project Code
* Written by : Luke Selbeck, Greg Kitzmiller, Dallas Van Ess
* Date       : Starting from 11/17/2014
* Description: 68k Disassembler
*-----------------------------------------------------------

* Equates Section

EAbuffer    EQU         $00070000    
Exit        EQU         $2700
TestLoc     EQU         $6000 
CR          EQU         $0D             * Hex value for Carriage Return
LF          EQU         $0A             * Hex value for New Line Read
START       EQU         $400            * Address for ORG
start_addr  EQU         $6000           * Starting address where the program is stored
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

* Code Section
            ORG         START                      
            LEA         prompt1,A1       * Load starting address prompt into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15  
            
            MOVE.B      #2,D0            * Load input task
            TRAP        #15              * Store user input in A0
            
            * Convert to hex
            MOVE.L      A1,A3            * Use A3 for computations
            
SADDR_LOOP  MOVE.B      (A3)+,D3         * Get a byte from the string in A3
            CMP.B       #0,D3            * Check if you're at the end
            BEQ         END_ADDR_PT      * If you're at the end, get out of the loop
            CMP.B       #$40,D3          * Check if the cur char is a num or letter
            BGT         SLTTR_UP         * Use differet conversion for num vs letter
            CMP.B       #$60,D3          * Use different conversion for upper vs lowercase
            BGT         SLTTR_LW         * Branch to lowercase conversion
            ADDI.B      #-$30,D3         * Convert string to number
            BRA         SCOMPILE         * Use differet conversion for num vs letter
SLTTR_UP    ADDI.B      #-$37,D3         * Convert string to number
            BRA         SCOMPILE         
SLTTR_LW    ADDI.B      #-$3D,D3         * Convert string to number 
SCOMPILE    ASL.L       #4,D4            * Shift left one hex digit to make room
            ADD.L       D3,D4            * Add converted number to result
            BRA SADDR_LOOP
            
END_ADDR_PT MOVE.L      D4,A6            * move the start addr result into proper place
            CLR.L       D4               * Reset registers for second address
            CLR.L       D3               * Reset registers for second address
            
            LEA         prompt2,A1       * Load starting address prompt into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15
            
            MOVE.B      #2,D0            * Load input task
            TRAP        #15              * Store user input in A0
            
            MOVE.L      A1,A3            * Use A3 for computations

            
EADDR_LOOP  MOVE.B      (A3)+,D3         * Get a byte from the string in A3
            CMP.B       #0,D3            * Check if you're at the end
            BEQ         MAIN             * If you're at the end, get out of the loop
            CMP.B       #$40,D3          * Check if the cur char is a num or letter
            BGT         ELTTR_UP         * Use differet conversion for num vs letter
            CMP.B       #$60,D3          * Use different conversion for upper vs lowercase
            BGT         ELTTR_LW         * Branch to lowercase conversion
            ADDI.B      #-$30,D3         * Convert string to number
            BRA         ECOMPILE         * Use differet conversion for num vs letter
ELTTR_UP    ADDI.B      #-$37,D3         * Convert string to number
            BRA         ECOMPILE         
ELTTR_LW    ADDI.B      #-$3D,D3         * Convert string to number
ECOMPILE    ASL.L       #4,D4            * Shift left one hex digit to make room
            ADD.L       D3,D4            * Add converted number to result
            BRA EADDR_LOOP
            
MAIN:
            MOVE.L      D4,A5
            MOVE.B      #0,D1            * This is the line counter to display one page
            CMPA.L      A5,A6            * Check if out of range
            BGT         FINISH           * If out of range, Branch
            MOVE.L      (A6)+,D0         * Store the data in D0 and increment
            
            MOVEM.L     D1/A5-A6,-(SP)      * Store registers before jumping
            * JSR         OPCODE           * Jump to the opcode section to start decoding
            MOVEM.L     (SP)+,D1/A5-A6      * Restore registers after returning
            
            * MOVE.B      #13,D0           * Trap code for output
            * TRAP        #15              * Output decoded line in A1
            
            ADDI        #1,D1            * Increment line counter
            CMP.L       #29,D1           * Check if we've printed a page
            BGT         PAGE_REQ         * If we've printed a page, ask to print more
            
            BRA         MAIN             * Else restart loop   
            
            
PAGE_REQ    CLR.L       D1               * Reset line counter
            MOVE.L      #$00000000,A1    * Clear previous messages

            LEA         page_mss,A1      * Load page request into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15
            
            MOVE.B      #4,D0            * Load input task
            TRAP        #15              * Wait until user presses enter
            BRA MAIN                     * Print more
            
            
            
FINISH:     LEA         end_message,A1   * Load ending message into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15     
        
                      
            
OPCODE:     MOVE.W      (A6),D0             * Move the entire line into D0
            MOVE.L      D0,D2               * Save initial D0 for later use       
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
            BSR         NOP            
*            BRA         FINISH
            RTS
            
NEG_RT:     LEA         neg_message,A1  * Print NEG
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here
            BSR         NEG
*            BRA         FINISH
            RTS
            
JSR_RT:     LEA         jsr_message,A1  * Print JSR
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BSR         JSR             * Branch to JSR EA Subroutine
*            BRA         FINISH
            RTS
            
RTS_RT:     LEA         rts_message,A1  * Print RTS
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here            
            BSR         RTS             * Branch to RTS EA Subroutine
*            BRA         FINISH
            RTS
            
BCC_RT:     LEA         bcc_message,A1  * Print BCC
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
*            BRA         FINISH
            RTS
            
BCS_RT:     LEA         bcs_message,A1  * Print BCS
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
*            BRA         FINISH
            RTS
            
BGE_RT:     LEA         bge_message,A1  * Print BGE
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
*            BRA         FINISH
            RTS
            
BLT_RT:     LEA         blt_message,A1  * Print BLT
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
*            BRA         FINISH
            RTS
            
BVC_RT:     LEA         bvc_message,A1  * Print BVC
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here         
*            BRA         FINISH                                                
            RTS
            
BRA_RT:     LEA         bra_message,A1  * Print BRA
            MOVE.B      #14,D0
            TRAP        #15
            * Will branch to EA here
*            BRA         FINISH                        
            RTS
           
EOR_RT     MOVE.B      D2,D3           * Copy current string
           LSR         #6,D3           * Remove the last 6 bits from the string                   
           ANDI.B      #$0F,D3         * Clear second to last digit
           SUB         #8,D3           * Subtract 8 from string
           CMPI        #4,D3           * Is is a CMP function? 
           BLT         CMP_RT          * Branch to CMP routine
           LEA         eor_message,A1  * Otherwise it's an EOR function 
           MOVE.B      #14,D0
           TRAP        #15
           BSR         EOR
*           BRA         FINISH 
           RTS
           
CMP_RT     LEA         cmp_message,A1
           MOVE.B      #14,D0
           TRAP        #15
           BSR         CMP
*           BRA         FINISH
           RTS
           
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
          bsr           ROR
*          BRA           FINISH
          RTS

RA_RT     LEA           asr_message,A1
          MOVE.B        #14,D0
          TRAP          #15
          bsr           ROR
*          BRA           FINISH
          RTS
            
                       
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
          bsr           ROR
*          BRA           FINISH
          RTS

RL_RT     LEA           lsr_message,A1
          MOVE.B        #14,D0
          TRAP          #15
          bsr           ROR
*          BRA           FINISH
          RTS
          
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
         bsr           ROR
*         BRA           FINISH   
         RTS

RR_RT    LEA           ror_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         bsr           ROR
*         BRA           FINISH
         RTS

FOU_RT   ANDI          #$0F0,D3        * Checking 2nd most significant nibble 
         LSR.W         #4,D3           * Shift for consistency
         LSR.B         #1,D3           * Shift 1 bit right to check parity bit
         BCS           LEA_RT          * If odd, its LEA
         BRA           MM_RT           * Otherwise it's MOVEM
         
         
LEA_RT   LEA           lea_message,A1
         MOVE.B        #14,D0
         TRAP          #15  
         BSR           LEA 
*         BRA           FINISH
         RTS
          
OR_RT    LEA           or_message,A1
         MOVE.B        #14,D0
         TRAP          #15  
         BSR           OR 
*         BRA           FINISH
         RTS
         
ZER_RT   MOVE.W        D0,D1           * Copy original string
         ANDI.W        #$FF00,D1        * Clear the lower byte 
         LSR.W         #8,D1           * Shift for consistency
         LSR.B         #1,D1           * Move the lowest bit into the carry bit
         BCS           BCL_RT          * If its a 1, its BCLR 
         BRA           ICM_RT          * Otherwise its CMPI
         
BCL_RT   LEA           bcl_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS

ICM_RT   LEA           icm_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS
      

ADD_RT   LEA           add_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS

SUB_RT   LEA           sub_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS
         
MUL_RT   LEA           mul_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS

DIV_RT   LEA           div_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS
         
BOV_RT   LEA           bov_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
         BSR           MOVE
*         BRA           FINISH
         RTS
         
WOV_RT   *MOVE          D0,D1           * Copy original string
*         ANDI.W        #$0FF0,D1       * Clear top and bottom nibbles
*         LSR.W         #4,D1           * Shift for consistency 
*         LSR.B         #2,D1           * Shift last 2 bits out to check Destination mode 
*         ANDI.B        #$0F,D1         * Clear top nibble of the last byte 
*         CMPI.B        #1,D1           * If bottom nibble is 1, its MOVEA.W 
*         BEQ           AWO_RT          * Branch to MOVEA.W routine 
         LEA           wov_message,A1  * Other wise it's just MOVE.W
         MOVE.B        #14,D0
         TRAP          #15   
         BSR           MOVE
*         BRA           FINISH
         RTS

         
LOV_RT   *MOVE          D0,D1           * Copy original string
*         ANDI.W        #$0FF0,D1       * Clear top and bottom nibbles
*         LSR.W         #4,D1           * Shift for consistency 
*         LSR.B         #2,D1           * Shift last 2 bits out to check Destination mode 
*         ANDI.B        #$0F,D1         * Clear top nibble of the last byte 
*         CMPI.B        #1,D1           * If bottom nibble is 1, its MOVEA.L 
*         BEQ           ALO_RT          * Branch to MOVEA.L routine 
         LEA           lov_message,A1  * Other wise it's just MOVE.L
         MOVE.B        #14,D0
         TRAP          #15   
         BSR           MOVE
*         BRA           FINISH
         RTS
         
AWO_RT   LEA           awo_message,A1  
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS

ALO_RT   LEA           alo_message,A1  
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS
         
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
*         BRA           FINISH
         RTS
         
RMO_RT   LEA           rmo_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS
           
QSU_RT   LEA           qsu_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS
         
ORI_RT   LEA           ori_message,A1
         MOVE.B        #14,D0
         TRAP          #15   
*         BRA           FINISH
         RTS
             
N_FOUND:    LEA         not_found,A1
            MOVE.B      #14,D0
            TRAP        #15
*            BRA         FINISH 
            RTS
    
*FINISH:     LEA         finished,A1
*            MOVE.B      #14,D0
*            TRAP        #15                       
*            STOP        #EXIT           * Halt Execution            
   
   
   *bsr   EXIT_TEST
*-----------------------
EXIT_TEST
   STOP   #Exit
*-----------------------
Initialize_EA
   lea   EAbuffer,A4   loads the ea loc into a4
   rts
*------------------------ 
Initialize_EA_Test_Pointer
   lea   TestLoc,A6   testing pointer (procedure not used) 
   rts
*------------------------  
*  A4 points to the string 
Print_EA_String
                bsr   Initialize_EA
             P_LOOP:   move.l      A4,A1
                cmp.l       #$ffffffff,(A1)      stop printing when empty    
                beq         Exit_Sr              exit
                move.l      #14,D0
                trap        #15                  print 
                adda.l      #$00000004,A4        increment a4
                bra         P_LOOP     loop
*------------------------
Exit_Sr
   LEA      empty_lin,A1
   MOVE.B   #14,D0
   TRAP     #15
   RTS
*------------------------
Decode_SIZE   *  register D3 has size bits
*---   sizes are byte:00, word:01, long:10
    cmp.l   #$00000000,d3   cmp 0 w/ it 
    beq   PRINT_DOT_B   go concatonate ".B"
    cmp.l  #$00000001,d3   compare 1
    beq   Print_DOT_W   go concatonate ".W"
    cmp.l   #$00000002,d3
    beq   Print_DOT_L   go concatonate ".L"
    bra   ERROR_SIZE
*------------------------
Decode_Size_Two   *---used in move
*---- some sizes don't use the same mappings, very annoying 
*---- 1 is byte, 11 is word, 10 is long
    cmp.l   #$00000001,d3
    beq   PRINT_DOT_B
    cmp.l  #$00000003,d3
    beq   Print_DOT_W
    cmp.l   #$00000002,d3
    beq   Print_DOT_L
    bra   ERROR_SIZE

*------------------------
ERROR_SIZE     *--- error SR, needs to do the generic error
*---- printing and increment 
   rts 
*------------------------
*---- passes size back in d3
Grab_Size_Bits_Seven_Eight  *--- a6 points to where size bits
      
    move.w    (a6),d3  
    andi.w   #$00C0,d3     these are generally size bits
    ror   #6,d3     rotate so it can conveniently be read
   rts  
*-----------------------
*----d3 will have bits
Grab_Six_And_Seven            *   size bits for some ops
    move.w    (a6),d3      reads from a6
    andi.w   #$0060,d3        AND masks for the particular bits
    ror   #5,d3               and rotates so they can be read
   rts  

*-----------------------
Grab_Eight       *grabs just the eigth bit
   clr   d4
   move.w    (a6),d4
    andi.w   #$0080,d4  
    ror   #5,d4
   rts  
*-----------------------
Grab_Five     *grabs just the fifth bit
   move.w    (a6),d4
    andi.w   #$0010,d4  
    ror   #4,d4
   rts
*------------------------
Grab_Size_Bits_Two
   move.b   (a6),d3
   andi.b   #$30,d3
   ror   #7,d3
   rts

*------------------------
Grab_Mode_Bits *--- grabs mode bits and stores in d3
   clr   d3
   move.w   (a6),d3
   andi.w   #%0000000000111000,d3    *lazy so just used bits
   ror   #3,d3    *rors so they can be printed/read
   rts 
*------------------------
Grab_Dest_Mode_Bits     *---used in a lot of op's
   clr   d3
   move.w   (a6),d3
   andi.w   #%0000000111000000,d3    *---there's the mask, easy to see what bits im grabbing
   ror   #6,d3
   rts
*------------------------
Grab_Source_Mode_Bits
   clr   d3
   move.w   (a6),d3
   andi.w   #%00000000000111000,d3
   ror   #3,d3
   rts
*------------------------
PRINT_DOT_B                      *--- generic printing function 
   move.b   #'.',(a4)+       dot to print
   move.b   #'B',(a4)+       "B" to print 
   move.b   #$09,(a4)+       prints spaces 
   move.b   #$00,(a4)+
   rts
*------------------------
Print_DOT_W
   move.b   #'.',(a4)+      dot to print
   move.b   #'W',(a4)+      "W" to print   
   move.b   #$09,(a4)+      prints spaces   
   move.b   #$00,(a4)+
   rts
*------------------------
Print_DOT_L
   move.b   #'.',(a4)+      dot to print
   move.b   #'L',(a4)+      "W" to print 
   move.b   #$09,(a4)+      prints spaces
   move.b   #$00,(a4)+
   rts
*------------------------
Print_Comma     
   move.b   #',',(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+   *--- add 00's so the print loop isn't misaligned
   move.b   #$00,(a4)+
   rts
*------------------------
Grab_Source_Reg  *--- grabs and puts into d4
   clr   d4
   move.w  (a6),d4 
   andi.w   #%0000000000000111,d4    *--- first three bits
   rts

*------------------------
Grab_Dest_Reg   *--- grabs and puts into d4
   clr   d4
   move.w  (a6),d4 
   andi.w   #%0000111000000000,d4   *--- used a lot 
   ror   #8,d4
   ror   #1,d4
   rts
*------------------------
Close_String   *--- probably a depricated mthod 
   move.b   #$00,(a4)
   rts
*------------------------
Decode_DRD  *-- d4 has the reg     
*---- does the printing for data register direct
   addi.b   #$30,d4
   move.b   #'D',(a4)+
   move.b   d4,(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   rts
*------------------------
Decode_ARD  *-- d4 has the reg
*---- pretty much same of as DRD
   addi.b   #$30,d4
   move.b   #'A',(a4)+
   move.b   d4,(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   rts

*------------------------
Mode_Jump_Table *-- d3 has mode 
    cmp.b   #$00,d3     *drd
    beq   Decode_DRD
    cmp.b   #$01,d3
    beq   Decode_ARD     *ard
    cmp.b   #$02,d3      *ari
    beq   Decode_ARI
    cmp.b   #$03,d3     *ari pi
    beq   Decode_ARI_PI
    cmp.b   #$04,d3     *ari pd
    beq   Decode_ARI_PD
    cmp.b   #$07,d3      *ari
    beq     Absolute_Router
    bra   Mode_Error 
*------------------------
Decode_ARI
    addi.b   #$30,d4
    move.b   #'(',(a4)+
    move.b   #'A',(a4)+
    move.b   d4,(a4)+
    move.b   #')',(a4)+
    move.b   #$00,(a4)+
  
   rts
*------------------------
Mode_Error
   rts    *think ill do generic 'error' subroutine
*------------------------
Decode_ARI_PI
    
    addi.b   #$30,d4
    move.b   #'(',(a4)+
    move.b   #'A',(a4)+
    move.b   d4,(a4)+
    move.b   #$00,(a4)+
    move.b   #')',(a4)+
    move.b   #'+',(a4)+
    move.b   #$00,(a4)+   adds the string makes sure its aligned
    move.b   #$00,(a4)+
    rts


*------------------------
Decode_ARI_PD
    
    addi.b   #$30,d4
    move.b   #'-',(a4)+
    move.b   #'(',(a4)+
    move.b   #'A',(a4)+
    move.b   #$00,(a4)+
    move.b   d4,(a4)+
    move.b   #')',(a4)+
    move.b   #$00,(a4)+
    move.b   #$00,(a4)+
    rts
*------------------------
Decode_IMM    *--- other procedures can be used instead of this
   
   bsr   Decode_Number   might need to do some incrementing 
   rts   
*------------------------
Decode_ABS_LONG    *---code reuse, will make separate procudure if time 
   clr   d1   *---- uses all the registers to convert the numbers and print 
   clr   d2
   clr   d3
   clr   d4
   clr   d5
   adda.l   #$00000002,a6
   move.w   (a6)+,d3
   move.w   d3,d4
   move.w   d3,d2
   move.w   d3,d5
   move.w   d3,d1
   andi.l   #$0000F000,d2
   ror      #8,d2
   ror      #4,d2
   
   addi.b   #$30,d2
   andi.l   #$00000F00,d3
   ror      #8,d3
   addi.b   #$30,d3   convert to ASCII
   andi.l   #$000000F0,d4
   ror      #4,d4
   addi.b   #$30,d4   convert to ASCII
   andi.l   #$0000000F,d5
   addi.b   #$30,d5   convert to ASCII
   move.l   #'ab.l',(a4)+   generic message 
   move.l   #$00000000,(a4)+
   move.b   d2,(a4)+
   move.b   d3,(a4)+
   move.w   #$0000,(a4)+
   move.b   d4,(a4)+
   move.b   d5,(a4)+
   move.w   #$0000,(a4)+
   
   
   
   clr   d1
   clr   d2
   clr   d3
   clr   d4
   clr   d5
   move.w   (a6)+,d3
   move.w   d3,d4
   move.w   d3,d2
   move.w   d3,d5
   move.w   d3,d1
   andi.l   #$0000F000,d2
   ror      #8,d2
   ror      #4,d2
   
   addi.b   #$30,d2   convert to ASCII
   andi.l   #$00000F00,d3
   ror      #8,d3
   addi.b   #$30,d3   convert to ASCII
   andi.l   #$000000F0,d4
   ror      #4,d4
   addi.b   #$30,d4
   andi.l   #$0000000F,d5
   addi.b   #$30,d5   convert to ASCII
   move.b   d2,(a4)+
   move.b   d3,(a4)+
   move.w   #$0000,(a4)+
   move.b   d4,(a4)+
   move.b   d5,(a4)+
   move.w   #$0000,(a4)+
   rts
   

*------------------------
Absolute_Router  *-- branches to word or long subprocedures based on register info 
    clr      d3
    move.b   (a6),d3
    andi.b   #%00000111,d3  grabs the register
    cmp.b   #$00,d3   if it's zero its a word
    beq   DECODE_ABS_WORD
    cmp.b   #$01,d3   if its one its a long 
    beq   DECODE_ABS_LONG
    bra   Absolute_Error
*------------------------
DECODE_ABS_WORD
   clr   d1
   clr   d2   clear registers (hope they're saved!!!)
   clr   d3
   clr   d4
   clr   d5
   adda.l   #$00000002,a6   increment a6
   move.w   (a6)+,d3
   move.w   d3,d4
   move.w   d3,d2
   move.w   d3,d5
   move.w   d3,d1
   andi.l   #$0000F000,d2
   ror      #8,d2
   ror      #4,d2
   
   addi.b   #$30,d2
   andi.l   #$00000F00,d3
   ror      #8,d3
   addi.b   #$30,d3
   andi.l   #$000000F0,d4
   ror      #4,d4
   addi.b   #$30,d4
   andi.l   #$0000000F,d5
   addi.b   #$30,d5
   move.l   #'ab.w',(a4)+
   move.l   #$00000000,(a4)+
   move.b   d2,(a4)+
   move.b   d3,(a4)+
   move.w   #$0000,(a4)+
   move.b   d4,(a4)+
   move.b   d5,(a4)+
   move.w   #$0000,(a4)+
   rts
*------------------------
Absolute_Error

*------------------------
Decode_Number   *--- prints out numbers in d4
   addi.b   #$30,d4
   move.b   #'#',(a4)+
   move.b   d4,(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
    
   rts

*------------------------
NOP    *--- best EA
   bsr   Increment_Word
   rts
*------------------------
NEG
   bsr   Initialize_EA
   bsr   Grab_Size_Bits_Seven_Eight
   bsr   Decode_SIZE
   bsr   Grab_Mode_Bits
   bsr   Grab_Source_reg
   bsr   Mode_Jump_Table
   bsr   Print_EA_String
   bsr   Increment_Word
   rts

*------------------------
Determine_MOVEA
   bsr   Grab_Dest_Mode_Bits
   cmp.b  #$1,d3
   beq   Print_A
   rts
*------------------------
Print_A
   move.b   #'A',(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   rts 
*------------------------
MOVE:
   bsr   Initialize_EA
   bsr   Determine_MOVEA
   bsr   Grab_Size_Bits_Two
   bsr   Decode_SIZE_Two
   bsr   Grab_Source_Mode_Bits
   bsr   Grab_Source_Reg
   bsr   Mode_Jump_Table
   bsr   Print_Comma
   bsr   Grab_Dest_Mode_Bits
   bsr   Grab_Dest_reg 
   bsr   Mode_Jump_Table
   bsr   Print_EA_String
   bsr   Increment_Word
*B   adda.w   #$2,a6
   rts
*------------------------
Movem_Mask_Loop    *---- d4 has the loop counter 
   clr   d3
   bsr   Increment_Word
   move.w   (a6)+,d3   move the mask to d3

Start_Loop_M
   cmp   #17,d4   *end of mask
   beq   Quit_Loop
   move.l   d4,d2   moves to d2 so i can mask it 
   andi.l   #$00000001,d2   masks for LSB
   cmp.l   #$000000001,d2
   beq   Print_Loop_Count
   ror   #1,d3

Print_Loop_Count
   cmp   #7,d4
   bgt   Print_A
   move.b   #'D',(a4)+   adds d to string
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   bsr   Decode_Number   decodes  and prints count at d4
   bsr   Print_Comma   then prints a comma
   addi.b   #1,d4   increment the counter
   bra   Start_Loop_M   then reenters the loops

Print_A
    move.b   #'D',(a4)+   adds d to string
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   move.b   #$00,(a4)+
   subi.b   #8,d4
   bsr   Decode_Number   decodes  and prints count at d4
   bsr   Print_Comma   then prints a comma
   addi.b   #8,d4
   addi.b   #1,d4   increment the counter
   bra   Start_Loop_M   then reenters the loops


Quit_Loop
   rts
*------------------------
MOVEM
   bsr   Initialize_EA
   bsr   Increment_Word
   bsr   Start_Loop_M
   rts  
*------------------------
ADD
   bsr   Initialize_EA
   
   bsr   Grab_Source_Reg
   bsr   Decode_Number
   bsr   Print_Comma
   bsr   Grab_Dest_reg 
   bsr   Grab_Dest_Mode_Bits
   bsr   Mode_Jump_Table

   bsr   Print_EA_String
   bsr   Increment_Word
   rts
*------------------------
ADDA
   
   bsr   ADD
   rts

*------------------------
SUB
   bsr   ADD
   rts
*------------------------
MULS
   bsr   ADD
   rts
*------------------------
DIVS
   bsr   ADD
   rts
*------------------------
LEA:
   bsr   Initialize_EA 
   bsr   Grab_Source_Reg
   bsr   Grab_Source_Mode_Bits
   bsr   Mode_Jump_Table
   bsr   Print_Comma
   bsr   Grab_Dest_reg 
   bsr   Grab_Dest_Mode_Bits
   bsr   Mode_Jump_Table
   bsr   Print_EA_String
   bsr   Increment_Word
   rts

*------------------------
OR:
   bsr   Initialize_EA 
   bsr   Grab_Source_Reg
   bsr   Grab_Source_Mode_Bits
   bsr   Mode_Jump_Table
   bsr   Print_Comma
   bsr   Grab_Dest_Mode_Bits
   bsr   Grab_Dest_reg 
   bsr   Decode_DRD         * CMP requires that the register specified by bits 11, 10, and 9 be data register direct
   bsr   Print_EA_String
   bsr   Increment_Word
   rts

* IT LOOKS LIKE ADDRESS_REGISTER_INDIRECT CAUSES AN EXTRA COMMA TO BE PRINTED * 
*------------------------
ORI
   bsr   Grab_Six_And_Seven
   cmp.b   #$00,d3
   beq   Increment_Byte
   cmp.b   #$01,d3
   beq  Increment_Word
   cmp.b   #02,d3
   beq  Increment_Long
   bsr   Increment_Word
   rts
*------------------------
EOR:
   bsr   Initialize_EA 
   bsr   Grab_Source_Reg
   bsr   Grab_Source_Mode_Bits
   bsr   Mode_Jump_Table
   bsr   Print_Comma
   bsr   Grab_Dest_Mode_Bits
   bsr   Grab_Dest_reg 
   bsr   Decode_DRD         * CMP requires that the register specified by bits 11, 10, and 9 be data register direct
   bsr   Print_EA_String
   bsr   Increment_Word
   rts
    
*------------------------
LSR
   bsr   Register_EA
   rts

*------------------------
LSL
   bsr   Register_EA
   rts
*------------------------
ASR
   bsr   Register_EA
   rts
*------------------------
ROL
   bsr   Register_EA
   rts
*------------------------
ROR
   bsr   Register_EA
   rts
*-------------------------
Register_EA
*   bsr   Initialize_EA 
*   bsr   Grab_Dest_reg *grab destination reg 
*   bsr   Decode_DRD 
*   bsr   Print_Comma
*   bsr   Grab_Source_Reg
*   bsr   Grab_Source_Mode_Bits
*   bsr   Mode_Jump_Table
*   bsr   Print_EA_String
*   rts

   bsr   Initialize_EA
   bsr   Grab_Eight
   cmp.b   #$00,d4
   bgt  Register_EA_D  *its a register not an immediate
   bsr   Grab_Dest_Reg 
   bsr   Decode_Number
   bsr   Print_Comma
   bsr   Grab_Source_Reg
   bsr   Decode_DRD  
   bsr   Print_EA_String
   bsr   Increment_Word
   rts


*------------------------
Register_EA_D

    bsr   Decode_DRD
    bsr   Increment_Word
    rts
*------------------------
BCLR
   bsr  Register_EA
   rts
*------------------------
CMP:
   bsr   Initialize_EA 
   bsr   Grab_Source_Reg
   bsr   Grab_Source_Mode_Bits
   bsr   Mode_Jump_Table
   bsr   Print_Comma
   bsr   Grab_Dest_Mode_Bits
   bsr   Grab_Dest_reg 
   bsr   Decode_DRD         * CMP requires that the register specified by bits 11, 10, and 9 be data register direct
   bsr   Print_EA_String
   bsr   Increment_Word
   rts
   * NOTE: THIS SUBROUTINE HAS AN EXTRA COMMA IN THE EA STRING FOR SOME REASON *

*------------------------
CMPI
   bsr   Initialize_EA 
   bsr   Grab_Size_Bits_Seven_Eight
   bsr   Decode_SIZE
   
   bsr   JSR
      *   d3 has size, grab immediate based on what it is 
   bsr  Absolute_Router   *this will at least do words and longs similarly 
   bsr   Print_EA_String
   bsr   Increment_Word
   rts
   

*------------------------
BCS
   bsr  Branches
   rts
*------------------------
Branches 
   clr   d4
   move.b    (a6),d4
   cmp.b   #$00,d4
   BEQ   Increment_Word
   cmp.b   #$FF, d4
   BEQ   Increment_Long
   bsr   Increment
   rts 
*------------------------
Increment_Word
   adda.l      #$00000004,a6
   rts
*------------------------
Increment_Long
   adda.l      #$00000008,a6
   rts
*------------------------
Increment_Byte

   adda.l    #$00000001,a6
   rts
*------------------------
Increment
   adda.l      #$00000002,a6
   rts
*------------------------
BGE
   bsr  Branches
   rts
*------------------------
BLT
   bsr  Branches
   rts
*------------------------
BVC
   bsr  Branches
   
   rts
*------------------------
JSR
    bsr   Initialize_EA 
    bsr   Grab_Source_Reg
    bsr   Grab_Source_Mode_Bits
    bsr   Mode_Jump_Table
    bsr   Print_EA_String
    RTS
*------------------------
RTS
    BSR EXIT_SR
    bsr   Increment_Word
    RTS
*------------------------
            SIMHALT                              
        
* Data Section
end_message DC.B        'Finshed',CR,0
prompt1     DC.B        'Please input the starting address in hex:',0
prompt2     DC.B        'Please input the ending address in hex:',0
page_mss    DC.B        'Would you like to continue?',0
finished    DC.B        'Finished',CR,LF,0
not_found   DC.B        'No Opcodes were found',CR,LF,0
nop_message DC.B        'NOP ',0
neg_message DC.B        'NEG ',0
jsr_message DC.B        'JSR ',0
rts_message DC.B        'RTS ',0
bcc_message DC.B        'BCC ',0
bcs_message DC.B        'BCS ',0
bge_message DC.B        'BGE ',0
blt_message DC.B        'BLT ',0
bvc_message DC.B        'BVC ',0
bra_message DC.B        'BRA ',0
eor_message DC.B        'EOR ',0
cmp_message DC.B        'CMP ',0
asr_message DC.B        'ASR ',0
asl_message DC.B        'ASL ',0
lsr_message DC.B        'LSR ',0
lsl_message DC.B        'LSL ',0
rol_message DC.B        'ROL ',0
ror_message DC.B        'ROR ',0
lea_message DC.B        'LEA ',0
or_message DC.B         'OR ',0
bcl_message DC.B        'BCLR ',0
add_message DC.B        'ADD ',0
sub_message DC.B        'SUB ',0
mul_message DC.B        'MULS ',0
div_message DC.B        'DIVS ',0
bov_message DC.B        'MOVE ',0
wov_message DC.B        'MOVE ',0
lov_message DC.B        'MOVE ',0
awo_message DC.B        'MOVEA.W ',0
alo_message DC.B        'MOVEA.L ',0
mmo_message DC.B        'MOVEM (Memory to Register) ',0
rmo_message DC.B        'MOVEM (Register to Memory) ',0
qsu_message DC.B        'SUBQ ',0
ori_message DC.B        'ORI ',0
icm_message DC.B        'CMPI ',0
data        DC.B        'DATA ',0 
empty_lin   DC.B        '',CR,LF,0   


            END         START








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
