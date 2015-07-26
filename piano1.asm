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

; ��ת����ӦƵ�ʶ�Ӧ��8253�ĳ�ʼ��������8253����Ƶ�ʶ�Ӧ�ĳ�ʼֵ
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
    
    ;�ӱ�׼�豸���뵥�ַ�����AL�Ĵ�����
INPUT:
    MOV AH,01H
    INT 21H  ;����16��DOS���ʹ����DOSϵͳ
    
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
    CMP AL,1BH    ;��ESC����
    JE  OVER
    JMP INPUT 
    
;����DOS;
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
    
    ;PB0��PB1��1����8253��GATE������
OPEN PROC
    IN AL,61H 
    MOV AH,AL
    OR AL,03H
    OUT 61H,AL
    RET
OPEN ENDP 
    
    ;��8255A��PB0��PB1��0���ر�������
CLOSE PROC
    IN AL,61H
    AND AL,0FCH
    OUT 61H,AL
    RET
CLOSE ENDP   

        
CODE ENDS
    END  START