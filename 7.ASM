DATA    SEGMENT
        HENGX   DB 100 DUP('*')	
                FINISH db 0ah,0dh," Thanks  for  use  our  program--FY LH ZCY      ",0ah,0dh,"$"
;��һ���ӳ������ݶ�*******************************	
;�ڶ����ӳ������ݶ�**********************************
;�������ӳ������ݶ�**********************************
;���ĸ��ӳ������ݶ�**********************************


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
	CMP	CX,22
	JNZ	SHUX1

	MOV	CX,0
SHUX2:	CURSOR	CL,40		;����ڶ�������
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX2

	MOV	CX,0
SHUX3:	CURSOR	CL,79		;�������������
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX3

	CALL	FIRST
        MOV     AH,4CH
        INT     21H
;��һ����Ļ�ϵ��ӳ���������ʾʱ�ں�ʱ��***************************************	
FIRST	PROC	NEAR	
LOOP1:	CURSOR 2,2
		MOV AH,09H
		MOV AL,'A'
		INT 10H
		MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 2		
        JNZ    	EXITT1		;�м���������תEXITT
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
		MOV AH,09H
		MOV AL,'B'
		INT 10H
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 2		
        JNZ    	EXITT2		;�м���������תEXITT
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
		INT 10H
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 3		
        JNZ    	EXITT3		;�м���������תEXITT
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
		MOV AH,09H
		MOV AL,'D'
		INT 10H
	    MOV 	AH,07H		;����Ƿ��м�����
    	INT   	21h
      	CMP   	AL, 4		
        JNZ    	EXITT4		;�м���������תEXITT
		JMP		LOOP4	;�м���������תEXITT
EXITT4:	
	POP	DX
	POP	CX
	POP	BX
	POP	AX
		MOV AX,0003H
        INT     10H
		mov dx,offset FINISH
        mov ah,09h
        int 21h
		mov ah,4ch
		int 21h 
FOURTH ENDP
CODE    ENDS
        END     START