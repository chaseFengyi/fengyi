STACK	SEGMENT	STACK
	DW	64	DUP(?)
STACK	ENDS
DATA    SEGMENT
        HENGX   DB 100 DUP('*')	
;第一个子程序数据段*******************************	
	SPORT	DB	16
	;DB	4FH,71,0,3
	DB	2,63,0,0			;笑脸的ASCII码（4：红色）
	;DB	4FH,70,0,-2
	;DB	4FH,7,0,0		
	DB	53H,79H,1,-2		;S
	DB	50H,79H,0,1		;P
	DB	4FH,79H,0,1		;O
	DB	52H,79H,0,1		;R
	DB	54H,79H,0,1		;T
	DB	3FH,7,1,-2		;?的ASCII码
	DB	4FH,6,0,-2		;O(6表示无底色黄色)
	DB	4FH,6,0,4		;O的ASCII码
	DB	3FH,7,1,-3		;?的ASCII码
	DB	3FH,7,0,1
	DB	3FH,7,0,1
	DB	23H,7,1,-3		;#的ASCII码
	DB	23H,7,0,4
	DB	4FH,3,1,-5		;（3表示无底色蓝色）
	DB	4FH,3,0,6
;第二个子程序数据段**********************************
	 INFOR1 DB 0AH,0DH,"Please Input the First Data(<10):$"
        INFOR2 DB 0AH,0DH,"Please Input the Second Data(<10):$"
        INFOR3 DB 0AH,0DH,"The Result is:$"
        INFOR4 DB 0AH,0DH,"The second number should not be zero $" 
        CHOOSE DB 0AH,0DH,"Please input  +,-,* or / :$"
        IBUF1 DB 7,0,6 DUP(0)
        IBUF2 DB 7,0,6 DUP(0) 
        OBUF DB 6 DUP(0)  
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
	CURSOR	22,0		;设置第三条横线光标位置
	DSTRING	HENGX		;输出第三条横线
	MOV	CX,0
	
SHUX1:	CURSOR	CX,0		;输出第一条竖线
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX1

	MOV	CX,0
SHUX2:	CURSOR	CX,40		;输出第二条竖线
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX2

	MOV	CX,0
SHUX3:	CURSOR	CX,79		;输出第三条竖线
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,22
	JNZ	SHUX3
	CALL	FIRST
        MOV     AH,4CH
        INT     21H
;第一个屏幕上的子程序，用来显示运动员***************************************	
	FIRST	PROC	NEAR
	PUSH	DS
	SUB		AX,AX
	PUSH	AX
	MOV		AX,DATA
	MOV		DS,AX
	LEA		SI,SPORT
	MOV		DH,12
	MOV		DL,36
	CALL	SPORTDIS
	RET
FIRST	ENDP
SPORTDIS	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	MOV		AH,0FH		;读取当前显示状态
	INT 	10H
	SUB		CH,CH		;清0
	MOV		CL,[SI]
	INC		SI
NEXT:	
	ADD	DH,	;光标行
	ADD	DL, 
	MOV	AH,2			;设置光标位置
	INT 10H
	MOV	AL,[SI]			;要写字符的ASCII码
	MOV	BL,[SI+1]		;字符的显示属性
	PUSH	CX
	MOV	CX,1			;重复次数
	MOV	AH,9			;9号功能在当前光标位置写字符和属性（用cx）
	INT	10H				;显示器服务程序
	POP	CX
	ADD	SI,4
	LOOP	NEXT
	MOV 	AH,0BH		;检测是否有键按下
    INT   	21h
    CMP   	AL, 00H		
    JNZ    	EXITT		;有键按下则跳转EXITT	
EXITT:	
	CALL	SECONDS
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
SPORTDIS	ENDP		
;第一个子程序结束处**********************************************************
SECONDS	PROC	NEAR
	CHOOSE1:  
	  CURSOR	3,42
      MOV DX,OFFSET INFOR1
      MOV AH,09H
      INT 21H 
      
      ;输入第一个数字 将其存在AX中
      MOV AH,01H
      INT 21H  
      CMP AL,071H;如果按‘q’退出dos
      JE STOP
      CMP AL,051H
      JE STOP ;如果按‘Q’退出dos
      MOV BL,AL
      SUB BL,30H
      PUSH BX
      
      ;输入运算符号           
      MOV DX,OFFSET CHOOSE
      MOV AH,09H
      INT 21H
       
      MOV AH,01H
      INT 21H
      MOV CL,AL
      XOR CH,CH
      PUSH CX
    
      
      MOV DX,OFFSET INFOR2
      MOV AH,09H
      INT 21H
      ;输入第二个数字  将其存在bx中
      MOV AH,01H
      INT 21H
      SUB AL,30H
      XOR AH,AH
      PUSH AX

      MOV DX,OFFSET INFOR3
      MOV AH,09H
      INT 21H
      
      POP AX
      POP CX
      PUSH AX
      CMP CL,02BH
      JE PLUS
      CMP CL,02DH
      JE SUBTRACTION    
      CMP CL,02AH
      JE MULTIPLICATION 
      CMP CL,02FH
      JE DIVISION
      JNE AGAIN             
      JMP CHOOSE1
STOP:     
    MOV AH,4CH
    INT 21H
AGAIN:
    MOV DX,OFFSET CHOOSE
    MOV AH,09H
    INT 21H
    JMP CHOOSE1

PLUS: 
    POP AX
    POP BX    
    ADD AL,BL
    AAA
    PUSH AX
    MOV DL,AH
    ADD DL,30H
    MOV AH,02H
    INT 21H
    POP AX
    MOV DL,AL
    ADD DL,30H
    MOV AH,02H
    INT 21H
    JMP CHOOSE1

SUBTRACTION:
    POP AX
    POP BX 
    MOV DX,AX
    MOV AX,BX
    MOV BX,DX
    SUB AL,BL
    AAS
    PUSH AX
    MOV DL,AH
    ADD DL,30H
    MOV AH,02H
    INT 21H
    POP AX
    MOV DL,AL
    ADD DL,30H
    MOV AH,02H
    INT 21H 
    JMP CHOOSE1 

MULTIPLICATION:
    POP AX
    POP BX
    MUL BL 
    AAM
    PUSH AX
    MOV DL,AH
    ADD DL,30H
    MOV AH,02H
    INT 21H
    POP AX
    MOV DL,AL
    ADD DL,30H
    MOV AH,02H
    INT 21H 
    JMP CHOOSE1

DIVISION:
    POP AX
    POP BX
    MOV DX,AX
    MOV AX,BX
    MOV BX,DX 
    CMP BX,0
    JE PRINTF
    DIV BL 
    AAD
    PUSH AX
    MOV DL,AH
    ADD DL,30H
    MOV AH,02H
    INT 21H
    POP AX
    MOV DL,AL
    ADD DL,30H
    MOV AH,02H
    INT 21H
    JMP CHOOSE1
            
PRINTF:
    MOV DX,OFFSET INFOR4
    MOV AH,09H
    INT 21H            
SECONDS	ENDP
CODE    ENDS
        END     START
