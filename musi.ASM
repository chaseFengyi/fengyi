DATA SEGMENT
    MSG1 DB 0DH,0AH,'KEY1-8 TO SING,ESC TO EXIT!'    
    MSG2 DB 0DH,0AH,' key in 1 and 8',0DH,0AH,'$'
   	INITAB DW 241,293,329,349,392,440,493,0
   	INITTM DW 4,4,2,4,4,4,2,0
DATA ENDS
;设置光标宏指令CURSOR
CURSOR  MACRO   ROW,CLM
        MOV     AH,02H
        MOV     BH,00H
        MOV     DH,ROW
        MOV     DL,CLM
        INT     10H
ENDM 

CODE SEGMENT
    ASSUME  DS:DATA,CS:CODE
START:
    MOV DX,DATA
    MOV DS,AX  
    
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH DS
        MOV AX,DATA
        MOV DS,AX
        CURSOR 23,6
        MOV AX,DS
        MOV DS,AX
 	LEA DX,MSG1
 	MOV AH,09H
 	INT 21H

LP1:MOV AH,08H  
    INT 21H
   
    CMP AL,1BH  
    JZ DONE
    CMP AL,'1'
    JB ERROR
    CMP AL,'8'
    JA ERROR 
     
    AND AL,0FH  
    DEC AL    
    SHL AL,1
    XOR AH,AH
    LEA SI,INITAB
   LEA DI,INITTM
    ADD SI,AX
    ADD DI,AX
    MOV BX,[SI]
    MOV AL,01H
    OUT 61H,AL
    MOV AL,10110110B
    OUT 43H,AL
    MOV AL,BL
    OUT 42H,AL
    MOV AL,BH
    OUT 42H,AL
    IN AL,61H
    OR AL,3
    OUT 61H,AL
    CALL DELAY
    AND AL,0FCH
    OUT 61H,AL
    
    JMP LP1

ERROR:LEA DX,MSG2
      MOV AH,09H
      INT 21H
      JMP LP1

DELAY PROC NEAR
      MOV CX,0
DL2:  MOV AX,20
DL1:  SUB AX,1
      JNZ DL1
      LOOP DL2
      RET
DELAY ENDP
DONE:  
        POP DS
        POP DX
        POP CX
        POP BX
        POP AX
        
CODE ENDS
    END  START