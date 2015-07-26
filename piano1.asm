DATA SEGMENT
       DO_YF DW 241
       DO_TM DW 4
       RE_YF DW 293
       RE_TM DW 4
       MI_YF DW 329
       MI_TM DW 2
       FA_YF DW 349
       FA_TM DW 4
       SOL_YF DW 392
       SOL_TM DW 4
       LA_YF DW 440
       LA_TM DW 4
       SI_YF DW 493
       SI_TM DW 2 
DATA ENDS      

; 跳转到相应频率对应的8253的初始化，并给8253赋上频率对应的初始值
VALUE MACRO TM
    MOV AL,0B6H
    OUT 43H,AL
    MOV AX,TM
    OUT 42H,AL
    MOV AL,AH
    OUT 42H,AL
ENDM

DELAY MACRO YF
    MOV CX,0
DL2:  
    MOV AX,20
DL1:  
    SUB AX,1
    JNZ DL1
    LOOP DL2
ENDM 

CODE SEGMENT
    ASSUME  DS:DATA,CS:CODE
START:
    MOV DX,DATA
    MOV DS,AX
    
    ;从标准设备输入单字符置入AL寄存器中
INPUT:
    MOV AH,01H
    INT 21H  ;调用16号DOS命令，使返回DOS系统
    
    CMP AL,'1'
    JZ  VOICE1
    ;CMP AL,'2'
    ;JZ VOICE2
    ;CMP AL,'3'
    ;JZ VOICE3 
    ;CMP AL,'4'
    ;JZ VOICE4 
    ;CMP AL,'5'
    ;JZ VOICE5
    ;CMP AL,'6'
    ;JZ VOICE6 
    ;CMP AL,'7'
    ;JZ VOICE7
    CMP AL,1BH    ;是ESC键吗？
    JE  OVER
    JMP INPUT 
    
;返回DOS;
OVER:
    MOV AH,4CH
    INT 21H
        
VOICE1:
    MOV AL,01H
    OUT 61H,AL 
    MOV AL,0B6H
    OUT 43H,AL
    ;MOV AX,DO_YF
    MOV BX,DO_YF
    MOV AL,BL
    OUT 42H,AL
    MOV AL,BH
    OUT 42H,AL
    IN AL,61H 
    MOV AH,AL
    OR AL,03H
    OUT 61H,AL 
    
    MOV CX,0
DL2:  
    MOV AX,20
DL1:  
    SUB AX,1
    JNZ DL1
    LOOP DL2 
          
    ;CALL OPEN 
    ;DELAY DO_TM
    CALL CLOSE
    
    ;PB0、PB1置1，打开8253的GATE和与门
OPEN PROC
    IN AL,61H 
    MOV AH,AL
    OR AL,03H
    OUT 61H,AL
    RET
OPEN ENDP 
    
    ;将8255A的PB0、PB1置0，关闭扬声器
CLOSE PROC
    IN AL,61H
    AND AL,0FCH
    OUT 61H,AL
    RET
CLOSE ENDP   

        
CODE ENDS
    END  START