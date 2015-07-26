A8255	EQU 288H		;8255�˿�A�ĵ�ַ
C8255	EQU 28AH		;8255�˿�C�ĵ�ַ
K8255	EQU 28BH		;8255���ƼĴ�����ַ
; multi-segment executable file template.
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

code SEGMENT
    ASSUME  DS:DATA,CS:CODE
START:
; set segment registers:
    MOV AX, data
    MOV DS, AX
    MOV ES, AX
 
    LEA DX,MSG1
 	MOV AH,09H
 	INT 21H        
    LEA DI,STORE
    INC DI
    MOV CX,[DI]
    INC DI
    PUSH CX 
	
INPUT:
	MOV AH,08H
	INT 21H	  
    CMP AL,1BH  
    JZ DONE   				;�Ӽ��̽����ַ�
	
	CMP AL,'0'
	JB  INPUT				;�����ַ��͵ȴ�������һ���ַ�
	CMP AL,'7'
	JA	INPUT   
	CMP AL,'0'
	JZ REPLAY      
    PUSH SI
    PUSH AX  
	DEC AL
	SUB AL,30H				;�õ������ַ����������ֵ 
	MOV SI,OFFSET WCODE		;SIָ��0�����δ���
	SUB AH,AH
	
	ADD SI,AX				;
	MOV	AL,[SI]				;�����Ӧ�Ķ���   
	 
	MOV DL,AL
	MOV AH,2
	INT 21H
	
	MOV DX,C8255
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
    JMP INPUT
DONE:    
        POP DS
        POP DX
        POP CX
        POP BX
        POP AX
    MOV AH,4CH
    INT 21H  
          
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
       
       
CODE ENDS
	END START ; set entry point and stop the assembler.
