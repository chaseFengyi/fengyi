DATA    SEGMENT
        HENGX   DB 100 DUP('*')	
                FINISH db 0ah,0dh," Thanks  for  use  our  program--FY LH ZCY      ",0ah,0dh,"$"
;第一个子程序数据段*******************************	
;第二个子程序数据段**********************************
;第三个子程序数据段**********************************
;第四个子程序数据段**********************************


DATA    ENDS
CODE    SEGMENT
        ASSUME CS:CODE,DS:DATA
START:  MOV     AX,DATA
        MOV     DS,AX
;屏幕显示方式设置宏指令SETCRT
SETCRT  MACRO
        MOV     AH,0
        MOV     AL,2
        INT     10H
        ENDM
;清屏宏指令CLEAR
CLEAR   MACRO
        MOV     AH,06H
        MOV     AL,0
        INT     10H
        ENDM
;设置光标宏指令CURSOR
CURSOR  MACRO   ROW,CLM
        MOV     AH,02H
        MOV     BH,00H
        MOV     DH,ROW
        MOV     DL,CLM
        INT     10H
        ENDM
;设置信息显示宏指令DSTRING
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
        CURSOR  0,0		;设置第一条横线光标位置
        DSTRING	HENGX		;输出第一条横线
	CURSOR	11,0		;设置第二条横线光标位置
	DSTRING	HENGX		;输出第二条横线
	CURSOR	23,0		;设置第三条横线光标位置
	DSTRING	HENGX		;输出第三条横线
	MOV	CX,0
	
SHUX1:	CURSOR	CL,0		;输出第一条竖线
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX1

	MOV	CX,0
SHUX2:	CURSOR	CL,40		;输出第二条竖线
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX2

	MOV	CX,0
SHUX3:	CURSOR	CL,79		;输出第三条竖线
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX3

	CALL	FIRST
        MOV     AH,4CH
        INT     21H
;第一个屏幕上的子程序，用来显示时期和时间***************************************	
FIRST	PROC	NEAR	
LOOP1:	CURSOR 2,2
		MOV AH,09H
		MOV AL,'A'
		INT 10H
		MOV 	AH,07H		;检测是否有键按下
    	INT   	21h
      	CMP   	AL, 2		
        JNZ    	EXITT1		;有键按下则跳转EXITT
		JMP		LOOP1
EXITT1:	
	CALL	SECONDS
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
FIRST	ENDP		
;第一个子程序结束处**********************************************************
SECONDS	PROC	NEAR
LOOP2:	CURSOR 2,42
		MOV AH,09H
		MOV AL,'B'
		INT 10H
	    MOV 	AH,07H		;检测是否有键按下
    	INT   	21h
      	CMP   	AL, 2		
        JNZ    	EXITT2		;有键按下则跳转EXITT
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
	    MOV 	AH,07H		;检测是否有键按下
    	INT   	21h
      	CMP   	AL, 3		
        JNZ    	EXITT3		;有键按下则跳转EXITT
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
	    MOV 	AH,07H		;检测是否有键按下
    	INT   	21h
      	CMP   	AL, 4		
        JNZ    	EXITT4		;有键按下则跳转EXITT
		JMP		LOOP4	;有键按下则跳转EXITT
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
