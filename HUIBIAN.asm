DATA    SEGMENT
        HENGX   DB 100 DUP('*')	
        HX  DB '\','$'
		FINISH db 0ah,0dh,"         Thanks  for  use  our  program--FY LH ZCY      ",0ah,0dh,"$"
;��һ���ӳ������ݶ�*******************************	
        PATN1 	DB 5 DUP(' '),28 DUP(07EH),4 DUP(' ')
		PATN2	DB 5 DUP(' '),07CH,26 DUP(' '),07CH,4 DUP(' ')
		PATN3	DB 5 DUP(' '),28 DUP(07EH),4 DUP(' ')
		DBUFFER DB 8 DUP('-'),12 DUP(' ')
		DBUFFE	DB 8 DUP(':'),12 DUP(' ')
		STR 	DB 'PLEASE INPUT DATE(D) OR TIME(T): $'
		CLCOVER	DB 'CLOCK IS OVER!$'
;�ڶ����ӳ������ݶ�**********************************
        STR0  DB        "         M E N U        $"
        STR1  DB        "         CHOOSE ONE     $"
        STR2  DB        "1.Mary Had a Little Lamb$"
        STR3  DB        "2.Happy Birthday To You!$" 
        STR4  DB        "3.      Return          $"
        STR5  DB        "~~~~~~~~~~~~~~~~~~~~~~~~$"
        YF1  DW        330,294,262,294,330,330,330,294,294,294,330,392,392,330,294,262,294,330,330,330,330,292,292,330,294,262,0
        TM1  DB        4,4,4,4,4,4,8,4,4,8,4,4,8,4,4,4,4,4,4,4,4,4,4,4,4,16
        YF2  DW        262,262,294,262,349,330,262,262,294,262,392,349,262,262,523,440,349,330,294,466,466,440,349,392,349,0
        TM2  DB        2,2,4,4,4,8,2,2,4,4,4,8,2,2,4,4,4,4,6,2,2,4,4,4,8
        ATM1  EQU       1000
        ATM2  EQU       145
        YF  DW        ?
        TM  DW        ?
;�������ӳ������ݶ�**********************************
        INFOR1 DB "Input the First Data(<65535):$"
        INFOR2 DB "Input the Second Data(<65535):$"
        INFOR3 DB "The Result is:$"
        INFOR4 DB "The Result is: -$"
        INFOR5 DB "The second number should not be zero $" 
        INFOR6 DB "Please input a number $"  
        INFOR7 DB "The number that you input is out of range $"    
        CHOOSE DB "Please choose ([+][-][*][/]) :$"    
        INF0    DB "-----MY CALCULATOR----     $"
        INF1    DB "+ -----------------ADD     $"
        INF2    DB "- -----------------SUB     $"
        INF3    DB "* -----------------MUL     $"
        INF4    DB "/ -----------------DIV     $"       
        INF5    DB "Q(q) --------------EXIT    $"
        INF6    DB "C(c) --------------CONTINUE$"          
        INF7    DB "Choose([Q(q)]=>EXIT,[C(c)=>CONTINUE]):$"
        INF8    DB "Input a right word:$"
        IBUF1 DB 7,0,6 DUP(0)
        IBUF2 DB 7,0,6 DUP(0)
        OBUF DB 6 DUP(0)
        CALRESET1 DB " $"
        CALRESET2 DB "      $"
        CALRESET3 DB "                                 $"
;���ĸ��ӳ������ݶ�**********************************
SPORT	DB	16	
	    DB	2,63,2,22			;Ц����ASCII�루4����ɫ��		
	    DB	53H,79H,1,-2		;S
	    DB	50H,79H,0,1		;P
	    DB	4FH,79H,0,1		;O
	    DB	52H,79H,0,1		;R
	    DB	54H,79H,0,1		;T
	    DB	3FH,7,1,-2		;?��ASCII��
	    DB	4FH,6,0,-2		;O(6��ʾ�޵�ɫ��ɫ)
	    DB	4FH,6,0,4		;O��ASCII��                     
	    DB	3FH,7,1,-3		;?��ASCII��
	    DB	3FH,7,0,1
	    DB	3FH,7,0,1
	    DB	23H,7,1,-3		;#��ASCII��
	    DB	23H,7,0,4
	    DB	4FH,3,1,-5		;��3��ʾ�޵�ɫ��ɫ��
	    DB	4FH,3,0,6
STRING	DB 'PRESS A KEY:QUIT(Q),TAB!$'
DATA    ENDS
;��Ļ��ʾ��ʽ���ú�ָ��SETCRT
SETCRT  MACRO
        MOV     AH,0
        MOV     AL,2
        INT     10H
        ENDM
;������ָ��CLEAR
CLEAR   MACRO
        MOV     AH,06H
        MOV     AL,0
        INT     10H
        ENDM
;���ù���ָ��CURSOR
CURSOR  MACRO   ROW,CLM
        MOV     AH,02H
        MOV     BH,00H
        MOV     DH,ROW
        MOV     DL,CLM
        INT     10H
        ENDM
;������Ϣ��ʾ��ָ��DSTRING
DSTRING	MACRO	STRING
	PUSH	DX
	PUSH	AX
	MOV	DX,OFFSET STRING
	MOV	AH,09H
	INT	21H
	POP	AX
	POP	DX
ENDM
LINE MACRO
    MOV AH,09H
    MOV AL,HX
    MOV BL,0DH
    MOV CX,80
    INT 10H
    ENDM
;��ʾ�ַ���
CLCDISP MACRO 	STRING,DX1,CX1,BL1
		MOV BP,OFFSET STRING
		MOV DX,DX1		
		MOV CX,CX1
		MOV BL,BL1		;�ַ���ɫ���ԣ���ɫΪ��ɫ���ַ���ɫΪ��ɫ��
		MOV AX,1301H		;��ʾ�ַ�����д��ʽ��AL=0��
		INT 10H
ENDM
;��ʾ�����������ָ��MENU
MENU MACRO INF
        LEA DX,INF
        MOV AH,09H
        INT 21H
ENDM
;���ֲ������˵���ʾ     
DISP  MACRO COLOR
              MOV       AH,00H 
              MOV       AL,COLOR
              INT       10H
ENDM
CODE    SEGMENT
        ASSUME CS:CODE,DS:DATA
START:  MOV     AX,DATA
        MOV     DS,AX 
HUIBIAN:          
        MOV     BX,OFFSET HENGX+80
        MOV     BYTE PTR[BX],'$'
        SETCRT
        ;CLEAR
        CURSOR  0,0		;���õ�һ�����߹��λ�� 
        LINE 
        CURSOR 10,0
        LINE 
        CURSOR 23,0
        LINE
	MOV	CX,0
SHUX1:	CURSOR	CL,0		;�����һ������
    PUSH CX
    MOV AH,9
    MOV AL,2FH
    MOV BL,8EH
    MOV CX,1
    INT 10H
    POP CX
	INC	CX
	CMP	CX,24
	JNZ	SHUX1
	MOV	CX,0                      
SHUX2:	CURSOR	CL,40		;����ڶ�������
	PUSH CX
    MOV AH,9
    MOV AL,2FH
    MOV BL,8EH
    MOV CX,1
    INT 10H
    POP CX
	INC	CX
	CMP	CX,24
	JNZ	SHUX2
	MOV	CX,0
SHUX3:	CURSOR	CL,79		;�������������
	PUSH CX
    MOV AH,9
    MOV AL,2FH
    MOV BL,8EH
    MOV CX,1
    INT 10H
    POP CX
	INC	CX
	CMP	CX,24
	JNZ	SHUX3
	CALL	FIRST
        MOV     AH,4CH
        INT     21H
;��һ����Ļ�ϵ��ӳ���������ʾʱ�ں�ʱ��***************************************	
FIRST	PROC	NEAR	
LOOP1:	CURSOR 2,2
		CALL    CLOCK
		MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 09H		
        JE    	EXITT1		;�м���������תEXITT
		JMP		LOOP1
EXITT1:	
	CALL	SECONDS
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
FIRST	ENDP		
;��һ���ӳ��������**********************************************************
SECONDS	PROC	NEAR
LOOP2:	CURSOR 2,42
		CALL MUSIC
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 09H		
        ;JNZ    	EXITT2		;�м���������תEXITT	
        JE    	EXITT2
		JMP		LOOP2
EXITT2:	
	CALL	THIRD
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
SECONDS	ENDP
THIRD PROC NEAR
 LOOP3:CURSOR 12,2
		CALL CALCULATE
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h       	
      	CMP   	AL, 09H		
        JE    	EXITT3		;�м���������תEXITT
		JMP		LOOP3
EXITT3:	
	CALL	FOURTH
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
THIRD ENDP
FOURTH PROC NEAR
LOOP4:	CURSOR 12,42 
		CALL PERSON
		
      	MOV AH,01H
      	INT 21H 
      	;POP AX
      	CMP AL,09H		
        JE    	EXITT4		;�м���������תEXITT
        ;CMP AL,09H
        ;JE  HUIBIAN
		;JMP		LOOP4	;�м���������תEXITT
EXITT4:
    	
	;POP	DX
	;POP	CX
	;POP	BX
	;POP	AX
    CALL FIRST 
    POP	DX
	POP	CX
	POP	BX
	POP	AX
		;MOV AX,0003H
        ;INT     10H
		;mov dx,offset FINISH
        ;mov ah,09h
        ;int 21h
		;mov ah,4ch
		;int 21h
		RET 
FOURTH ENDP                      
;��һ���ӳ��򡪡���������ʱ�ӳ���
CLOCK PROC NEAR
START1:	;MOV AX,0001H		;������ʾ��ʽΪ40*25H��ɫ�ı���ʽ
		;INT 10H
		MOV AX,DATA
		MOV DS,AX
		MOV ES,AX
		CLCDISP PATN1,0101H,37,0EH   ;������ο�
		CLCDISP PATN2,0201H,37,0EH
		CLCDISP PATN3,0301H,37,0EH
				
		CLCDISP STR,0404H,32,03H  ;��ʾ��ʾ��Ϣ
		
		MOV AH,1			;�Ӽ������뵥���ַ�
		INT 21H
		CMP AL,44H			;AL='D'?
		JNE	A
		CALL DATE			;��ʾϵͳ����
A:		CMP AL,54H			;AL='T'?
		JNE	B 
		CALL TIME			;��ʾϵͳʱ��
B:
		;CMP AL,51H			;AL='Q'?
		;JNE START1
		CLCDISP CLCOVER,0504H,14,03H
		
		RET
CLOCK ENDP
DATE PROC NEAR				;��ʾ�����ӳ���
DISPL:
		MOV AH,2AH			;ȡϵͳ����
		INT 21H				;CX=�꣬DH=�£�DL=��
		MOV SI,0
		MOV AX,CX
		MOV BX,100
		DIV BL			;��->AL  ����->AH�������4λ��Ҫת��2��
		MOV BL,AH
		CALL BCDASC1	;����ת�� ��AL=20����ݣ�20��
		MOV AL,BL
		CALL BCDASC1	;����ת�� ����AL=14����ݣ�14��
		INC SI			;�������":"
		MOV AL,DH
		CALL BCDASC1	;�����·ݣ�11�£�
		INC SI
		MOV AL,DL
		CALL BCDASC1	;��������
		MOV BP,OFFSET DBUFFER	;�ַ�����ַ
		MOV DX,020DH	;��ʼ����
		MOV CX,20		;�ַ�������
		MOV BX,0004H	;��ʾ��ɫ
		MOV AX,1301H	;13�Ź��ܣ���ʾ�ַ�����д��ʽ��AL=01��
		INT 10H
		MOV AH,02H		;�ù��λ��
		MOV DX,0500H	;��/��
		MOV BH,0		;��ʾҳ
		INT 10H
		MOV BX,0010H
REPEA:
		MOV CX,0FH		;��ʱ
REPEAT:
		LOOP REPEAT
		DEC BX
		JNZ	REPEA
		RET
DATE ENDP

TIME PROC NEAR
DISPLAY1:
		MOV SI,0
		MOV BX,100
		DIV BL
		MOV AH,2CH		;ȡϵͳʱ��  CH=ʱ��0~23����CL=�֣�
		INT 21H			;DH=�룬DL=�ٷ���
		MOV AL,CH		
		CALL BCDASC		;����ת��	ʱ
		INC SI			
		MOV AL,CL		
		CALL BCDASC		;����ת��   ��
		INC SI
		MOV AL,DH
		CALL BCDASC		;����ת��   ��
		MOV BP,OFFSET DBUFFE
		MOV DX,020DH
		MOV CX,20
		MOV BX,0004H
		MOV AX,1301H	;��ʾ�ַ���
		INT 10H
		MOV AH,02H
		MOV DX,0501H
		MOV BH,0
		INT 10H			;�ù��λ��
		MOV BX,0018H
RE:
		MOV CX,0FH		;��ʱ
REA:
		LOOP REA
		DEC BX
		JNZ	RE
		MOV AH,01H		;�����̼�����ַ�
		INT 21H
		;JE DISPLAY1
		;JMP START1
		;MOV AX,4C00H
		;INT 21H
		RET
TIME ENDP

BCDASC	PROC NEAR
		PUSH BX
		CBW
		MOV BL,10
		DIV BL
		ADD AL,'0'
		MOV DBUFFE[SI],AL
		INC SI
		ADD AH,'0'
		MOV DBUFFE[SI],AH
		INC SI
		POP BX
		RET
BCDASC ENDP

BCDASC1	PROC NEAR
		PUSH BX
		CBW
		MOV BL,10
		DIV BL
		ADD AL,'0'
		MOV DBUFFER[SI],AL
		INC SI
		ADD AH,'0'
		MOV DBUFFER[SI],AH
		INC SI
		POP BX
		RET 
BCDASC1	ENDP
;�ڶ����ӳ��򡪡������������ֳ���
MUSIC PROC NEAR 
    SHOW:    
              CURSOR 1,43
              ;MENU STR0
              CLCDISP STR0,012BH,24,04H  
              CURSOR 2,43
              ;MENU STR1
              CLCDISP STR1,022BH,24,03H  
              CURSOR 3,43
              ;MENU STR2
              CLCDISP STR2,032BH,24,03H  
              CURSOR 4,43
              ;MENU STR3  
              CLCDISP STR3,042BH,24,03H
              CURSOR 5,43
              ;MENU STR4  
              CLCDISP STR4,052BH,24,03H
              CURSOR 6,43
              CLCDISP STR5,062BH,24,0EH
              ;MENU STR5                 
              MOV       AH,02H   ;��ʾ�ַ�  
              MOV       BH,0
              MOV       DH,8       ;���ĸ߶�
              MOV       DL,58       ;����x����
              INT       10H         ;���ù��λ��
     MUSICCHOOSE:  MOV       AH,08H ;�Ӽ��̶�һ�ַ���������
              INT       21H
              CMP       AL,'1'
              JZ        M1
              CMP       AL,'2'
              JZ        M2
              CMP       AL,'3'
              JZ        OVER
              JMP       MUSICCHOOSE

         M1:  LEA       SI,YF1
              MOV       YF,SI
              LEA       SI,TM1
              MOV       TM,SI
              JMP       BEG

         M2:  LEA       SI,YF2
              MOV       YF,SI
              LEA       SI,TM2
              MOV       TM,SI

        BEG:  MOV       AL,10110110B   ;��ʼ����ʱ��
              OUT       43H,AL     ;���Ϳ����ֽڵ����ƼĴ���
              CALL      OPEN

        RTN:  MOV       SI,YF
              MOV       DI,TM

        ACT:  MOV       DX,12H
              MOV       AX, 34DEH
              DIV       WORD PTR[SI]
              OUT       42H,AL
              MOV       AL,AH
              OUT       42H,AL
              CALL      DELAY

              ADD       SI,2
              CMP       WORD PTR[SI],0
              JZ        RTN
              INC       DI
              MOV       AH,1
              INT       16H
              JZ        ACT
              CALL      CLOSE
              JMP       SHOW
       OVER:  RET
       RET
MUSIC ENDP
OPEN  PROC
              IN        AL,61H        ;��ö˿�B�ĵ�ǰ����
              OR        AL,00000011B   ;ʹPB0=1��PB1=1
              OUT       61H,AL         ;��������
              RET
        OPEN  ENDP
       CLOSE  PROC
              IN        AL,61H
              AND       AL,11111100B
              OUT       61H,AL
              RET
       CLOSE  ENDP

       DELAY  PROC
              MOV       AX,ATM1
              MOV       DH,0
              MOV       DL,[DI]
              MUL       DX
              MOV       DX,ATM2
              MUL       DX
              MOV       CX,DX
              MOV       DX,AX
              MOV       AH,86H
              INT       15H
              RET
       DELAY  ENDP        
CALMENU PROC NEAR
      CURSOR 11,8
      ;MENU INF0
      CLCDISP INF0,0B08H,27,03H
      CURSOR 12,8
      ;MENU INF1 
      CLCDISP INF1,0C08H,27,03H
      CURSOR 13,8
      ;MENU INF2
      CLCDISP INF2,0D08H,27,03H
      CURSOR 14,8
      ;MENU INF3
      CLCDISP INF3,0E08H,27,03H 
      CURSOR 15,8
      ;MENU INF4
      CLCDISP INF4,0F08H,27,03H
      CURSOR 16,8
      ;MENU INF5
      CLCDISP INF5,1008H,27,03H
      CURSOR 17,6                  
      ;MENU INF6
      CLCDISP INF6,1106H,27,03H
    RET
CALMENU ENDP 
;�������ӳ��򡪡���������������������ʵ��CALCULATE 
CALCLEAR PROC NEAR 
    CURSOR 18,39
    MENU CALRESET1  
    CURSOR 19,1
    MENU CALRESET3 
    CURSOR 20,1
    MENU CALRESET3 
    CURSOR 21,1
    MENU CALRESET3 
    CURSOR 22,1
    MENU CALRESET3
    RET
    CALCLEAR ENDP
CALCULATE PROC NEAR       
CLS:    
      CALL CALMENU  
CHOOSE1:
      CURSOR 18,1  
      ;MENU INF7
      CLCDISP INF7,1201H,38,0EH    
      MOV AH,01H
      INT 21H
      CMP AL,071H    ;q
      JE STOP
      CMP AL,051H      ;Q
      JE STOP 
      CMP AL,043H
      JE CHOOSE2
      CMP AL,063H
      JE CHOOSE2
      JNE NOTICE
OUTPUT:
    CURSOR 22,1
    ;MENU INFOR3
    CLCDISP INFOR3,1601H,14,03H  
    POP BX 
    MOV DX,BX
    MOV AH,09H
    INT 21H
    MOV AH,01H
    INT 21H
    PUSH AX      
    CALL CALCLEAR
    POP AX   
    CMP AL,0DH
    JE CLS
RUN:
    CALL FOURTH
STOP: 
    CURSOR 21,21
    MOV AH,08H
    INT 21H
    CMP AL,09H
    JE RUN
NOTICE:
    CURSOR 19,1
    MENU INF8
    CALL THIRD
CHOOSE2: 
      CURSOR 19,1
      ;MENU INFOR1
      CLCDISP INFOR1,1301H,29,03H        
      MOV DX,OFFSET IBUF1
      MOV AH,0AH
      INT 21H
      MOV BL,AL
      SUB BL,30H
      MOV CL,IBUF1+1
      MOV CH,0
      MOV SI,OFFSET IBUF1+2
      MOV AX,0 
AGAIN1: 
      MOV DX,10
      MUL DX
      AND BYTE PTR [SI],0FH
      ADD AL,[SI]
      ADC AH,0
      INC SI
      LOOP AGAIN1       
      PUSH AX 
      CURSOR 20,1
      ;MENU CHOOSE
      CLCDISP INFOR2,1401H,30,03H
      MOV AH,01H
      INT 21H 
      MOV CL,AL
      XOR CH,CH
      PUSH CX          
SECOND:  
      CURSOR 21,1        
      ;MENU INFOR2
      CLCDISP INFOR2,1501H,30,03H
      MOV DX,OFFSET IBUF2
      MOV AH,0AH
      INT 21H
      MOV AH,02H
      MOV DL,0AH
      INT 21H
      MOV CL,IBUF2+1
      MOV CH,0
      MOV SI,OFFSET IBUF2+2
      MOV AX,0 
AGAIN2: 
      MOV DX,10
      MUL DX
      AND BYTE PTR [SI],0FH
      ADD AL,[SI]
      ADC AH,0
      INC SI
      LOOP AGAIN2   
      MOV BX,AX
      PUSH BX 
      POP BX
      POP CX
      PUSH BX
      PUSH CX
      CMP CL,02BH
      JE PLUS
      CMP CL,02DH
      JE SUBTRACTION    
      CMP CL,02AH
      JE MULTIPLICATION 
      CMP CL,02FH
      JE DIVISION
      JMP SUBTRACTION
      JMP CLS         
PLUS: 
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    ADD AX,BX
    PUSH AX
    JMP BINARYTODECIMAL
SUBTRACTION:
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    CMP AX,BX
    JB SUB1
    SUB AX,BX
    PUSH AX
    JMP BINARYTODECIMAL
MULTIPLICATION:
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    MUL BX    
    PUSH AX
    JMP BINARYTODECIMAL
NOTICE1:
    MENU INFOR5
    JMP SECOND     
DIVISION:
    POP CX
    POP BX
    POP AX
    PUSH AX 
    PUSH CX
    CMP BX,0  
    JE NOTICE1
    DIV BX    
    PUSH AX
    JMP BINARYTODECIMAL
SUB1:
    MOV DX,AX
    MOV AX,BX
    MOV BX,DX
    SUB AX,BX
    PUSH AX
    POP AX 
    MOV BX,OFFSET OBUF+5
    MOV BYTE PTR[BX],'$'
    MOV CX,10   
CALLOOP2:
    MOV DX,0
    DIV CX
    ADD DL,30H
    DEC BX
    MOV [BX],DL
    OR AX,AX
    JNZ CALLOOP2
    PUSH BX 
    CURSOR 22,1  
    ;MENU INFOR4
    CLCDISP INFOR4,1601H,16,03H
    POP BX 
    MOV DX,BX
    MOV AH,09H
    INT 21H
    MOV AH,01H
    INT 21H
    CMP AL,0DH 
    JMP CLS
BINARYTODECIMAL:
    POP AX 
    MOV BX,OFFSET OBUF+5
    MOV BYTE PTR[BX],'$'
    MOV CX,10   
CALLOOP1:
    MOV DX,0
    DIV CX
    ADD DL,30H
    DEC BX
    MOV [BX],DL
    OR AX,AX
    JNZ CALLOOP1
    PUSH BX  
    JMP OUTPUT
    RET      
CALCULATE ENDP
                
;���ĸ��ӳ��򡪡������˶�С�˵���ʾ       
PERSON	PROC	NEAR
	PUSH	DS
	SUB		AX,AX
	PUSH	AX
	MOV		AX,DATA
	MOV		DS,AX
	;DSTRING STRING
	CLCDISP STRING,0C30H,24,03H
	LEA		SI,SPORT
	MOV		DH,12		;��ʼ��
	MOV		DL,36		;��ʼ��
	CALL	SPORTDIS
	RET
PERSON	ENDP
SPORTDIS	PROC	NEAR
	;PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	MOV		AH,0FH		;��ȡ��ǰ��ʾ״̬
	INT 	10H
	SUB		CH,CH		;��0
	MOV		CL,[SI]
	INC		SI
NEXT:	
	ADD	DH,[SI+2]		;�����
	ADD	DL,[SI+3]		;�����
	MOV	AH,2			;���ù��λ��
	INT 	10H
	MOV	AL,[SI]			;Ҫд�ַ���ASCII��
	MOV	BL,[SI+1]		;�ַ�����ʾ����
	PUSH	CX
	MOV	CX,1			;�ظ�����
	MOV	AH,9			;9�Ź����ڵ�ǰ���λ��д�ַ������ԣ���cx��
	INT	10H				;��ʾ���������
	POP	CX
	ADD	SI,4
	LOOP	NEXT
	;CURSOR 21,53
	MOV BX,0010H
REPEA1:
		MOV CX,000FH		;��ʱ
REPEAT1:
	LOOP REPEAT1
	DEC BX
	JNZ	REPEA1
	
	CURSOR 21,53		;��λ���
	MOV 	AH,08H		;����Ƿ��м�����
    INT   	21h
	CMP 	AL,51H	;Q	
    JE		PERSTOP	;q
   	CMP 	AL,71H
    JE 		PERSTOP	
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	RET		
SPORTDIS	ENDP 
PERSTOP PROC NEAR
	MOV AH,4CH
	INT 21H         
	PERSTOP ENDP
CODE    ENDS
        END     START
