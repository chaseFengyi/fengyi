DATA SEGMENT
    MSG1 DB 0DH,0AH,'KEY1-8 TO SING,ESC TO EXIT!'    
    MSG2 DB 0DH,0AH,' key in 1 and 8',0DH,0AH,'$'
   	INITAB DW 241,293,329,349,392,440,493,0
   	STORE   DB 100;数据区长度
   	        DB 0;填入实际输入的字符个数
   	        DW 100 DUP(0);定义100个字节的存储空间
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
    CURSOR 23,6
    LEA DX,MSG1
 	MOV AH,09H
 	INT 21H
        
    LEA DI,STORE
    INC DI
    MOV CX,[DI]
    INC DI
    PUSH CX     
LP1:MOV AH,08H  
    INT 21H   
    CMP AL,1BH  
    JZ DONE 
    CMP AL,'0'
    JZ REPLAY
    CMP AL,'0'
    JB ERROR
    CMP AL,'8'
    JA ERROR  
    AND AL,0FH  
    DEC AL    
    SHL AL,1
    XOR AH,AH
    LEA SI,INITAB
    ADD SI,AX
    MOV BX,[SI]  
    MOV [DI],BL
    INC DI
    MOV [DI],BH
    INC DI
    POP CX 
    INC CX
    PUSH CX
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
DONE:    
        POP DS
        POP DX
        POP CX
        POP BX
        POP AX
    MOV AH,4CH
    INT 21H        
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
REPLAY: 
     POP CX  
     PUSH DI 
     PUSH BX
     PUSH AX
     PUSH CX
 PTN:     
     POP CX
     ADD CX,30H 
     MOV DL,CL
     MOV AH,2
     INT 21H
     ;INC CX
     MOV DI,OFFSET STORE
     ADD DI,2
  PLAY: 
    MOV BL,[DI]
    INC DI
    MOV AH,[DI]
    MOV AL,01H
    OUT 61H,AL
    MOV AL,0B6H
    OUT 43H,AL
    MOV AL,BL
    OUT 42H,AL
    MOV AL,BH
    OUT 42H,AL
    IN AL,61H
    OR AL,3
    OUT 61H,AL
    CALL DELAY
    IN AL,61H
    AND AL,0FCH
    OUT 61H,AL 
    INC DI
    LOOP PLAY
    LEA DX,MSG1
 	MOV AH,09H
 	INT 21H 
    IN AL,61H
    AND AL,0FCH
    OUT 61H,AL
    JMP START             
    POP AX
    POP BX
    POP DI
CODE ENDS
    END  START