A8255	EQU 0DC00H		;8255�˿�A�ĵ�ַ
C8255	EQU 0DC08H		;8255�˿�C�ĵ�ַ
K8255	EQU 0DC0CH		;8255���ƼĴ�����ַ
DATA SEGMENT
    MSG1 DB 0DH,0AH,'KEY1-8 TO SING,ESC TO EXIT!'    
    MSG2 DB 0DH,0AH,' key in 1 and 8',0DH,0AH,'$'
   	INITAB DW 241,293,329,349,392,440,493,0
   	STORE   DB 100;����������
   	        DB 0;����ʵ��������ַ�����
   	        DW 100 DUP(0);����100���ֽڵĴ洢�ռ�
   	;WCODE DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH	;�߶�����ܵ����д����
   	WCODE DB 30H,5BH,79H,74H,6DH,6FH,38H	;�߶�����ܵ����д����
DATA ENDS
;���ù���ָ��CURSOR
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
     
    ;����
    ;MOV DX,K8255
    ;MOV AL,10010000B    ;��8255��Ϊ�˿�A���룬C�����B���
    ;OUT DX,AL
    
    ;MOV DX,A8255
    ;IN AL,DX
    ;CMP AL,11111101B
    ;JZ  GO 
    ;CMP AL,11111101B
    ;JNZ OVER
    ;CMP AL,11111110B
    ;JZ REPLAY1
;OVER:
    ;MOV AH,4CH
    ;INT 21H
GO:
    CALL MUSIC
REPLAY1:
	CALL REPLAY
REPLAY PROC NEAR    
     POP CX
     PUSH DI 
     PUSH BX
     PUSH AX
     ;ADD CX,30H 
     ;MOV DL,CL
     ;MOV AH,2
     ;INT 21H
     MOV DI,OFFSET STORE
     ADD DI,2
  PLAY:
    MOV       AL,10110110B   ;��ʼ����ʱ��
    OUT       43H,AL     ;���Ϳ����ֽڵ����ƼĴ���
    IN        AL,61H        ;��ö˿�B�ĵ�ǰ����
    OR        AL,00000011B   ;ʹPB0=1��PB1=1
    OUT       61H,AL         ;��������  
    PIN: MOV SI,DI
    ACT:  
        MOV       DX,12H
        MOV       AX, 34DEH
        DIV       WORD PTR[SI]
        OUT       42H,AL
        MOV       AL,AH
        OUT       42H,AL
        CALL      DELAY

        ADD       SI,2
        CMP       WORD PTR[SI],0
        JZ        PIN
        MOV       AH,1
        INT       16H
        JZ        ACT
        IN        AL,61H
        AND       AL,11111100B
        OUT       61H,AL
     
    JMP START             
    POP AX
    POP BX
    POP DI
    PUSH CX 
    RET
REPLAY ENDP   
MUSIC PROC NEAR
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
    JZ REPLAY1
    CMP AL,'1'
    JB ERROR
    CMP AL,'7'
    JA ERROR         
    PUSH SI
    PUSH AX  
    DEC AL
    SUB AL,30H				;�õ������ַ����������ֵ 
	MOV SI,OFFSET WCODE		;SIָ��0�����δ���
	SUB AH,AH	
	ADD SI,AX				;
	MOV	AL,[SI]				;�����Ӧ�Ķ���	
	MOV DX,A8255
	OUT DX,AL 
	POP AX 
	POP SI
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

    RET
MUSIC ENDP
CODE ENDS
    END  START