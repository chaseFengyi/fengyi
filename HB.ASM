DATA    SEGMENT
        HENGX   DB 100 DUP('*')	
		FINISH DB 0ah,0dh,"         Thanks  for  use  our  program--FY LH ZCY      ",0ah,0dh,"$"
;��һ���ӳ������ݶ�*******************************	
		;SPACE DB 1000 DUP(' ')
		PATN1 	DB 5 DUP(' '),28 DUP(07EH),4 DUP(' ')
		PATN2	DB 5 DUP(' '),07CH,26 DUP(' '),07CH,4 DUP(' ')
		PATN3	DB 5 DUP(' '),28 DUP(07EH),4 DUP(' ')
		DBUFFER DB 8 DUP('-'),12 DUP(' ')
		DBUFFE	DB 8 DUP(':'),12 DUP(' ')
		STR 	DB 'PLEASE INPUT DATE(D) OR TIME(T): $'
		OVER	DB 'CLOCK IS OVER!$'
;�ڶ����ӳ������ݶ�**********************************
;�������ӳ������ݶ�**********************************
INFOR1 DB 0AH,0DH,"Please Input the First Data(<65535):$"
        INFOR2 DB 0AH,0DH,"Please Input the Second Data(<65535):$"
        INFOR3 DB "The Result is:$"
        INFOR4 DB "The Result is: -$"
        INFOR5 DB 0AH,0DH,"The second number should not be zero $" 
        INFOR6 DB 0AH,0DH,"Please input a number $"  
        INFOR7 DB 0AH,0DH,"The number that you input is out of range $"    
        CHOOSE DB 0AH,0DH,"Please choose ([+][-][*][/]) :$"    
        INF0    DB 0AH,0DH,"-----MY CALCULATOR-----$"
        INF1    DB 0AH,0DH,"+ -----------------ADD$"
        INF2    DB 0AH,0DH,"- -----------------SUB$"
        INF3    DB 0AH,0DH,"* -----------------MUL$"
        INF4    DB 0AH,0DH,"/ -----------------DIV$"       
        INF5    DB 0AH,0DH,"Q(q) --------------EXIT$"
        INF6    DB 0AH,0DH,"C(c) --------------CONTINUE$"          
        INF7    DB 0AH,0DH,"Choose([Q(q)]=>EXIT,[C(c)=>CONTINUE]):$"
        INF8    DB 0AH,0DH,0AH,0DH,"Input a right word:$"
        IBUF1 DB 7,0,6 DUP(0)
        IBUF2 DB 7,0,6 DUP(0)
        OBUF DB 6 DUP(0)


;���ĸ��ӳ������ݶ�**********************************
SPORT	DB	16
	;DB	4FH,71,0,3
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
			
DATA    ENDS
CODE    SEGMENT
        ASSUME CS:CODE,DS:DATA
START:  MOV     AX,DATA
        MOV     DS,AX
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
;��ʾ�ַ���
DISP MACRO 	STRING,DX1,CX1,BL1,AX1
		MOV BP,OFFSET STRING
		MOV DX,DX1		
		MOV CX,CX1
		MOV BL,BL1		;�ַ���ɫ���ԣ���ɫΪ��ɫ���ַ���ɫΪ��ɫ��
		MOV AX,AX1		;��ʾ�ַ�����д��ʽ��AL=0��
		INT 10H
		ENDM
;��ʾ�����������ָ��MENU
MENU MACRO INF
        LEA DX,INF
        MOV AH,09H
        INT 21H
ENDM


 LINE PROC NEAR
    MOV     BX,OFFSET HENGX+80
    MOV     BYTE PTR[BX],'$'
    SETCRT
    CLEAR
    CURSOR  0,0		;���õ�һ�����߹��λ��
    DSTRING	HENGX		;�����һ������
	CURSOR	11,0		;���õڶ������߹��λ��
	DSTRING	HENGX		;����ڶ�������
	CURSOR	23,0		;���õ��������߹��λ��
	DSTRING	HENGX		;�������������
	MOV	CX,0
	
SHUX1:	CURSOR	CL,0		;�����һ������
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,23
	JNZ	SHUX1

	MOV	CX,0
SHUX2:	CURSOR	CL,40		;����ڶ�������
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,23
	JNZ	SHUX2

	MOV	CX,0
SHUX3:	CURSOR	CL,79		;�������������
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,23
	JNZ	SHUX3

	CALL	FIRST
    MOV     AH,4CH
    INT     21H
    
LINE    ENDP
;��һ����Ļ�ϵ��ӳ���������ʾʱ�ں�ʱ��***************************************	
FIRST	PROC	NEAR	
LOOP1:	CURSOR 2,2
		
		;MOV AH,09H
		;MOV AL,'A'
		;INT 10H
		
		CALL CLOCK
		
		MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 09H		
      	;CURSOR 2,2
		;lDSTRING SPACE
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
LOOP2:	
		
		CURSOR 2,42
		;CALL LINE
		MOV AH,09H
		MOV AL,'B'
		MOV CX,10
		INT 10H 
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 09H		

        JE    	EXITT2		;�м���������תEXITT
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
		MOV AH,09H
		MOV AL,'C'
		MOV CX,10
		INT 10H
		;CALCULATE
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21H
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
;���ĸ���Ļ�ϵ��ӳ���������ʾ�˶�Ա***************************************
FOURTH PROC NEAR
LOOP4:	CURSOR 12,42
		;MOV AH,09H
		;MOV AL,'D'
		;INT 10H
		CALL MAIN
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 09H		;09H��Tab��	
        JE    	EXITT4		;�м���������תEXITT
		JMP		LOOP4	;�м���������תEXITT
EXITT4:
  	 CALL FIRST	
	POP	DX
	POP	CX
	POP	BX
	POP	AX
		;MOV AX,0003H
        ;INT     10H
		MOV DX,OFFSET FINISH
        MOV AH,09h
        INT 21h
		MOV AH,4ch
		INT 21h 
FOURTH ENDP

;��һ���ӹ���   ʱ�ӳ���
CLOCK PROC NEAR
START1:	;MOV AX,0001H		;������ʾ��ʽΪ40*25H��ɫ�ı���ʽ
		;INT 10H
		MOV AX,DATA
		MOV DS,AX
		MOV ES,AX
		;MOV BP,OFFSET SPACE	;BP�ַ�����ַ
		;MOV DX,0000H		;��ʼ����
		;MOV CX,200			;�ַ�������
		;MOV BX,0040H		;��ʾ����
		;MOV AX,1300H		;���ܺ�Ϊ13����ʾ�ַ�����ALΪд��ʽ��
		;INT 10H
		;MOV BP,OFFSET PATTERN
		;MOV DX,0101H		
		;MOV CX,110
		;MOV BX,0007H		;�ַ���ɫ���ԣ���ɫΪ��ɫ���ַ���ɫΪ��ɫ��
		;MOV AX,1301H		;��ʾ�ַ�����д��ʽ��AL=0��
		;INT 10H
		
		DISP PATN1,0101H,37,07H,1301H
		DISP PATN2,0201H,37,07H,1301H
		DISP PATN3,0301H,37,07H,1301H
		
		;LEA DX,STR
		;MOV AH,9			;��ʾ��ʾ��Ϣ
		;INT 21H
		
		;MOV BP,OFFSET STR
		;MOV DX,0402H		
		;MOV CX,32
		;MOV BX,0007H		;�ַ���ɫ���ԣ���ɫΪ��ɫ���ַ���ɫΪ��ɫ��
		;MOV AX,1301H		;��ʾ�ַ�����д��ʽ��AL=0��
		;INT 10H
		DISP STR,0404H,32,07H,1301H
		
		
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
		DISP OVER,0504H,14,07H,1301H
		
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
		MOV DX,020AH	;��ʼ����
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
		;MOV AH,01H		;�����̻������ַ���AL�Ĵ�����
		;INT 16H
		;;JE DISPL
		;JMP START1
		;MOV AX,4C00H
		;INT 21H
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
		MOV DX,020AH
		MOV CX,20
		MOV BX,0004H
		MOV AX,1301H	;��ʾ�ַ���
		INT 10H
		MOV AH,02H
		MOV DX,0300H
		MOV BH,0
		INT 10H			;�ù��λ��
		MOV BX,0018H
RE:
		MOV CX,0FH		;��ʱ
REA:
		LOOP REA
		DEC BX
		JNZ	RE
		MOV AH,01H		;�����̻������ַ���Al�Ĵ�����
		INT 16H
		;JE DISPLAY1
		JMP START1
		MOV AX,4C00H
		INT 21H
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

;���ĸ��ӹ���С�˳���
MAIN	PROC	NEAR
	PUSH	DS
	SUB		AX,AX
	PUSH	AX
	MOV		AX,DATA
	MOV		DS,AX
	;CALL	CLEAR
	LEA		SI,SPORT
	MOV		DH,12
	MOV		DL,36
	CALL	SPORTDIS
	RET
MAIN	ENDP
SPORTDIS	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	MOV		AH,0FH		;��ȡ��ǰ��ʾ״̬
	INT 	10H
	SUB		CH,CH		;��0
	MOV		CL,[SI]
	INC		SI
NEXT:	ADD	DH,[SI+2]	;�����
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
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
SPORTDIS	ENDP


CODE    ENDS

        END     START