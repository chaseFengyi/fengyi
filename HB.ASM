DATA    SEGMENT
        HENGX   DB 100 DUP('*')	
		FINISH DB 0ah,0dh,"         Thanks  for  use  our  program--FY LH ZCY      ",0ah,0dh,"$"
;第一个子程序数据段*******************************	
		;SPACE DB 1000 DUP(' ')
		PATN1 	DB 5 DUP(' '),28 DUP(07EH),4 DUP(' ')
		PATN2	DB 5 DUP(' '),07CH,26 DUP(' '),07CH,4 DUP(' ')
		PATN3	DB 5 DUP(' '),28 DUP(07EH),4 DUP(' ')
		DBUFFER DB 8 DUP('-'),12 DUP(' ')
		DBUFFE	DB 8 DUP(':'),12 DUP(' ')
		STR 	DB 'PLEASE INPUT DATE(D) OR TIME(T): $'
		OVER	DB 'CLOCK IS OVER!$'
;第二个子程序数据段**********************************
;第三个子程序数据段**********************************
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


;第四个子程序数据段**********************************
SPORT	DB	16
	;DB	4FH,71,0,3
	DB	2,63,2,22			;笑脸的ASCII码（4：红色）		
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
;显示字符串
DISP MACRO 	STRING,DX1,CX1,BL1,AX1
		MOV BP,OFFSET STRING
		MOV DX,DX1		
		MOV CX,CX1
		MOV BL,BL1		;字符颜色属性（底色为红色，字符颜色为白色）
		MOV AX,AX1		;显示字符串（写方式：AL=0）
		INT 10H
		ENDM
;显示计算器界面宏指令MENU
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
	CMP	CX,23
	JNZ	SHUX1

	MOV	CX,0
SHUX2:	CURSOR	CL,40		;输出第二条竖线
	MOV	DL,'*'
	MOV	AH,2
	INT	21H
	INC	CX
	CMP	CX,23
	JNZ	SHUX2

	MOV	CX,0
SHUX3:	CURSOR	CL,79		;输出第三条竖线
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
;第一个屏幕上的子程序，用来显示时期和时间***************************************	
FIRST	PROC	NEAR	
LOOP1:	CURSOR 2,2
		
		;MOV AH,09H
		;MOV AL,'A'
		;INT 10H
		
		CALL CLOCK
		
		MOV 	AH,07H		;检测是否有键按下
    	INT   	21h
      	CMP   	AL, 09H		
      	;CURSOR 2,2
		;lDSTRING SPACE
        JE    	EXITT1		;有键按下则跳转EXITT
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
LOOP2:	
		
		CURSOR 2,42
		;CALL LINE
		MOV AH,09H
		MOV AL,'B'
		MOV CX,10
		INT 10H 
	    MOV 	AH,07H		;检测是否有键按下
    	INT   	21h
      	CMP   	AL, 09H		

        JE    	EXITT2		;有键按下则跳转EXITT
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
	    MOV 	AH,07H		;检测是否有键按下
    	INT   	21H
      	CMP   	AL, 09H		
        JE    	EXITT3		;有键按下则跳转EXITT
		JMP		LOOP3
EXITT3:	
	CALL	FOURTH
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
THIRD ENDP
;第四个屏幕上的子程序，用来显示运动员***************************************
FOURTH PROC NEAR
LOOP4:	CURSOR 12,42
		;MOV AH,09H
		;MOV AL,'D'
		;INT 10H
		CALL MAIN
	    MOV 	AH,07H		;检测是否有键按下
    	INT   	21h
      	CMP   	AL, 09H		;09H是Tab键	
        JE    	EXITT4		;有键按下则跳转EXITT
		JMP		LOOP4	;有键按下则跳转EXITT
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

;第一个子过程   时钟程序
CLOCK PROC NEAR
START1:	;MOV AX,0001H		;设置显示方式为40*25H彩色文本方式
		;INT 10H
		MOV AX,DATA
		MOV DS,AX
		MOV ES,AX
		;MOV BP,OFFSET SPACE	;BP字符串地址
		;MOV DX,0000H		;起始行列
		;MOV CX,200			;字符串长度
		;MOV BX,0040H		;显示属性
		;MOV AX,1300H		;功能号为13，显示字符串（AL为写方式）
		;INT 10H
		;MOV BP,OFFSET PATTERN
		;MOV DX,0101H		
		;MOV CX,110
		;MOV BX,0007H		;字符颜色属性（底色为红色，字符颜色为白色）
		;MOV AX,1301H		;显示字符串（写方式：AL=0）
		;INT 10H
		
		DISP PATN1,0101H,37,07H,1301H
		DISP PATN2,0201H,37,07H,1301H
		DISP PATN3,0301H,37,07H,1301H
		
		;LEA DX,STR
		;MOV AH,9			;显示提示信息
		;INT 21H
		
		;MOV BP,OFFSET STR
		;MOV DX,0402H		
		;MOV CX,32
		;MOV BX,0007H		;字符颜色属性（底色为红色，字符颜色为白色）
		;MOV AX,1301H		;显示字符串（写方式：AL=0）
		;INT 10H
		DISP STR,0404H,32,07H,1301H
		
		
		MOV AH,1			;从键盘输入单个字符
		INT 21H
		CMP AL,44H			;AL='D'?
		JNE	A
		CALL DATE			;显示系统日期
A:		CMP AL,54H			;AL='T'?
		JNE	B
		CALL TIME			;显示系统时间
B:
		;CMP AL,51H			;AL='Q'?
		;JNE START1
		DISP OVER,0504H,14,07H,1301H
		
		RET
CLOCK ENDP
DATE PROC NEAR				;显示日期子程序
DISPL:
		MOV AH,2AH			;取系统日期
		INT 21H				;CX=年，DH=月，DL=日
		MOV SI,0
		MOV AX,CX
		MOV BX,100
		DIV BL			;商->AL  余数->AH。年份有4位，要转换2次
		MOV BL,AH
		CALL BCDASC1	;处理转换 商AL=20；年份（20）
		MOV AL,BL
		CALL BCDASC1	;处理转换 余数AL=14；年份（14）
		INC SI			;可以输出":"
		MOV AL,DH
		CALL BCDASC1	;处理月份（11月）
		INC SI
		MOV AL,DL
		CALL BCDASC1	;处理日期
		MOV BP,OFFSET DBUFFER	;字符串地址
		MOV DX,020AH	;起始行列
		MOV CX,20		;字符串长度
		MOV BX,0004H	;显示颜色
		MOV AX,1301H	;13号功能：显示字符串（写方式：AL=01）
		INT 10H
		MOV AH,02H		;置光标位置
		MOV DX,0500H	;行/列
		MOV BH,0		;显示页
		INT 10H
		MOV BX,0010H
REPEA:
		MOV CX,0FH		;延时
REPEAT:
		LOOP REPEAT
		DEC BX
		JNZ	REPEA
		;MOV AH,01H		;读键盘缓冲区字符到AL寄存器中
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
		MOV AH,2CH		;取系统时间  CH=时（0~23），CL=分，
		INT 21H			;DH=秒，DL=百分秒
		MOV AL,CH		
		CALL BCDASC		;处理转换	时
		INC SI			
		MOV AL,CL		
		CALL BCDASC		;处理转换   分
		INC SI
		MOV AL,DH
		CALL BCDASC		;处理转换   秒
		MOV BP,OFFSET DBUFFE
		MOV DX,020AH
		MOV CX,20
		MOV BX,0004H
		MOV AX,1301H	;显示字符串
		INT 10H
		MOV AH,02H
		MOV DX,0300H
		MOV BH,0
		INT 10H			;置光标位置
		MOV BX,0018H
RE:
		MOV CX,0FH		;延时
REA:
		LOOP REA
		DEC BX
		JNZ	RE
		MOV AH,01H		;读键盘缓冲区字符到Al寄存器中
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

;第四个子过程小人程序
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
	MOV		AH,0FH		;读取当前显示状态
	INT 	10H
	SUB		CH,CH		;清0
	MOV		CL,[SI]
	INC		SI
NEXT:	ADD	DH,[SI+2]	;光标行
	ADD	DL,[SI+3]		;光标列
	MOV	AH,2			;设置光标位置
	INT 	10H
	MOV	AL,[SI]			;要写字符的ASCII码
	MOV	BL,[SI+1]		;字符的显示属性
	PUSH	CX
	MOV	CX,1			;重复次数
	MOV	AH,9			;9号功能在当前光标位置写字符和属性（用cx）
	INT	10H				;显示器服务程序
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
