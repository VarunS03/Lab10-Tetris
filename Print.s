; Print.s
; Student names: change this to your names or look very silly
; Last modification date: change this to the last modification date or look very silly
; Runs on TM4C123
; EE319K lab 7 device driver for any LCD
;
; As part of Lab 7, students need to implement these LCD_OutDec and LCD_OutFix
; This driver assumes two low-level LCD functions
; ST7735_OutChar   outputs a single 8-bit ASCII character
; ST7735_OutString outputs a null-terminated string 

    IMPORT   ST7735_OutChar
    IMPORT   ST7735_OutString
    EXPORT   LCD_OutDec
    EXPORT   LCD_OutFix
		
	preserve8  
FP RN 11
Count EQU 0
Num EQU 4


    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB
	
  

;-----------------------LCD_OutDec-----------------------
; Output a 32-bit number in unsigned decimal format
; Input: R0 (call by value) 32-bit unsigned number
; Output: none
; Invariables: This function must not permanently modify registers R4 to R11
; R0=0,    then output "0"
; R0=3,    then output "3"
; R0=89,   then output "89"
; R0=123,  then output "123"
; R0=9999, then output "9999"
; R0=4294967295, then output "4294967295"
LCD_OutDec
	PUSH {R4-R9, R11, LR}
	SUB SP, #8
	MOV FP, SP ; copy stack pointer into frame pointer
	MOV R4, #0 
	STR R4, [FP, #Count] ; set count to 0 
	STR R0, [FP, #Num] ; store input in num
	MOV R5, #10 ; use as register for the division
	CMP R0, #0
	BNE lopp
	MOV R0, #0x30
	BL ST7735_OutChar
	B done
	
lopp
	LDR R4, [FP, #Num] ; load number into r4
	CMP R4, #0
	BEQ Next
	UDIV R6, R4, R5 ; isolate the first bit of input number
	MUL R7, R6, R5 ;  multipy back and put in r7
	SUB R8, R4, R7 ; r8 has the remainder which will be pushed on stack
	PUSH {R8} ; push least significant bit on stack
	STR R6, [FP, #Num] ; store the new number back into Num
	LDR R6, [FP, #Count] ; load count into r6
	ADD R6, #1 ; add count by 1
	STR R6, [FP, #Count] ; store count back into fp
	B lopp
	
Next 
	LDR R4, [FP, #Count] ; load r4 with the count
	CMP R4, #0 ; if count is 0 finish 
	BEQ done
	POP {R0} ; pop first digit 
	ADD R0, #0x30 ; make it a chracter by adding 48
	BL ST7735_OutChar ; bring to make character
	SUB R4, #1 ; subtract count by 1
	STR R4, [FP, #Count] ;store back into count
	B Next
	
done
	ADD SP, #8 ; deallocate
	POP {R4-R9, R11, LR}


      BX  LR
;* * * * * * * * End of LCD_OutDec * * * * * * * *

; -----------------------LCD _OutFix----------------------
; Output characters to LCD display in fixed-point format
; unsigned decimal, resolution 0.001, range 0.000 to 9.999
; Inputs:  R0 is an unsigned 32-bit number
; Outputs: none
; E.g., R0=0,    then output "0.000"
;       R0=3,    then output "0.003"
;       R0=89,   then output "0.089"
;       R0=123,  then output "0.123"
;       R0=9999, then output "9.999"
;       R0>9999, then output "*.***"
; Invariables: This function must not permanently modify registers R4 to R11
FPF RN 9
Numfix EQU 0

LCD_OutFix
	PUSH {R4-R9, R11, LR}
	SUB SP, #4
	MOV FPF, SP
	MOV R4, #0
	STR R0, [FPF, #Numfix]
	MOV R5, #10 ; use to divide
	MOV R11, #3 ; counter
	MOV R6, #9999
	

	CMP R0, R6
	BHI astricks
loopz
	CMP R11, #0
	BEQ addperiod
	LDR R4, [FPF, #Numfix] ; load number into r4
	MOV R6, #0 ; clear r6
	UDIV R6, R4, R5 ; isolate the first bit of input number
	MUL R7, R6, R5 ;  multipy back and put in r7
	SUB R8, R4, R7 ; r8 has the remainder which will be pushed on stack
	PUSH {R8} ; push least significant bit on stack
	STR R6, [FPF, #Numfix] ; store the new number back into Num
	SUB R11, #1 ; decrement counter 
	B loopz
	
addperiod 
	MOV R8, #-2 ; push period
	PUSH {R8}
	LDR R4, [FPF, #Numfix]
	UDIV R6, R4, R5 ; isolate the first bit of input number
	MUL R7, R6, R5 ;  multipy back and put in r7
	SUB R8, R4, R7 ; r8 has the remainder which will be pushed on stack
	PUSH {R8} ; push least significant bit on stack
	STR R6, [FPF, #Numfix] ; store the new number back into Num
	MOV R11, #5 ; use as counter for nextz
	B Nextz
	
Nextz
	CMP R11, #0
	BEQ donzo
	POP {R0} ; pop first digit 
	ADD R0, #0x30 ; make it a chracter by adding 48
	BL ST7735_OutChar ; bring to make character
	SUB R11, #1 ; subtract count by 1
	STR R4, [FPF, #Count] ;store back into count
	
	B Nextz

	
astricks 
;	MOV R8, #0x2A; ascii value for astrick
;	PUSH {R8}
;	PUSH {R8}
;	PUSH {R8}
;	MOV R8, #0x2E; ascii value for period
;	PUSH {R8}
;	MOV R8, #0x2A
;	PUSH {R8} 
;	MOV R11, #5 ; use as counter for nextz
;	B Nextz
	
	MOV R0, #0x2A
	BL ST7735_OutChar
	MOV R0, #0x2E
	BL ST7735_OutChar
	MOV R0, #0x2A
	BL ST7735_OutChar
	MOV R0, #0x2A
	BL ST7735_OutChar
	MOV R0, #0x2A
	BL ST7735_OutChar
	B donzo
	
donzo
	ADD SP, #4 ; deallocate
	POP {R4-R9, R11, LR}
	BX LR
	

 
     ALIGN
;* * * * * * * * End of LCD_OutFix * * * * * * * *

     ALIGN                           ; make sure the end of this section is aligned
     END                             ; end of file
