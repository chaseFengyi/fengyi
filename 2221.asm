　　　　ORG 0000H
       JMP START
       ORG 001BH
       LJMP INT_0
       ORG 000BH
       INC 20H
       MOV TH0,#0D8H
       MOV TL0,#0EFH
       RETI
       ORG 0200H
START: MOV P2,#00H
       SETB EA
       SETB ET0                        ;计数器0
       SETB ET1                        ;计数器1
       MOV TMOD,#21H
       MOV TH0,#09CH
       MOV TL0,#09CH                   ;定时器初植
       MOV TH1,#0D8H
       MOV TL1,#0EFH
       CLR TR0                         ;定时器不允许
       CLR TR1                        
SCAN:                                  ;键盘扫描
       MOV A,P1                        ;判断键盘按下，跳到SCAN_1，若未按，继续扫描
       CJNE A,#0F0H,SCAN_1
       NOP
       LJMP SCAN
SCAN_1:ACALL DELAY                       ;是不是真的要按下？如果是，则跳转SU_KEY查询是哪个按下？
       MOV A,P1
       CJNE A,#0F0H,SU_KEY
       NOP
       LJMP SCAN
SU_KEY:JNB P1.0,MU_0                     ;判断是哪个键按下？
       JNB P1.1,MU_1
       JNB P1.2,MU_2
       JNB P1.3,MU_3
       JNB P1.4,MU_4
       JNB P1.5,MU_5
       JNB P1.6,MU_6
       JNB P1.7,MU_7
       LJMP SCAN
                                       
MU_0: CPL P0.0                        ;若是第一个按键按下，点亮第一个LED
       LCALL DELAY
       SETB P0.0                       ;延时之后息灭该LED
       MOV R1,#19                      ;R1信号周期
       LJMP NEXT
MU_1:  CPL P0.1                        ;若是第二个按键按下，点亮第二个LED
       LCALL DELAY
       SETB P0.1                       ;延时之后息灭该LED
       MOV R1,#17             
       LJMP NEXT
MU_2: CPL P0.2                        ;若是第三个按键按下，点亮第三个LED
       LCALL DELAY
       SETB P0.2                       ;延时之后息灭该LED
       MOV R1,#15
       LJMP NEXT
MU_3: CPL P0.3                        ;若是第四个按键按下，点亮第四个LED
       LCALL DELAY
       SETB P0.3                       ;延时之后息灭该LED
       MOV R1,#14
       LJMP NEXT
MU_4: CPL P0.4                        ;若是第五个按键按下，点亮第五个LED
       LCALL DELAY
       SETB P0.4                       ;延时之后息灭该LED
       MOV R1,#13
       LJMP NEXT
MU_5: CPL P0.5                        ;若是第六个按键按下，点亮第六个LED
       LCALL DELAY
       SETB P0.5                       ;延时之后息灭该LED
       MOV R1,#11
       LJMP NEXT
MU_6: CPL P0.6                        ;若是第七个按键按下，点亮第七个LED
       LCALL DELAY
       SETB P0.6                       ;延时之后息灭该LED
       MOV R1,#10
       LJMP NEXT
MU_7: CPL P0.7                        ;若是第八个按键按下，点亮第八个LED
       LJMP NEXT_2
NEXT: MOV A,R1                
       MOV R0,A
       SETB TR1                        ;启动定时器0                                                   
NEXT_1:MOV A,P1                         ;没键按下继续执行，有键按下，返回读引脚
       CJNE A,#0FFH,NEXT_1
       ACALL DELAY
       MOV A,P1                       ;真的没键按下？
       CJNE A,#0FFH,NEXT_1
       CLR TR1                        ;不响
       AJMP SCAN                     ;扫描键盘去
INT_0:                                 ;中断程序
       DJNZ R0,RE                     ;R0不等于0时，返回
       CPL P2.0
       MOV A,R1
       MOV R0,A
  RE: RETI
NEXT_2: NOP                          ;放歌程序
MUSIC0:MOV SP,#50H
       NOP
       MOV DPTR,#DAT                 ;表头地址送DPTR
       MOV 20H,#00H                  ;中断计数器清0
       MOV B,#00H                     ;表序号清0
MUSIC1:NOP
       CLR A
       MOVC A,@A+DPTR                  ;查表取代码
       JZ END0                         ;是00H,则结束
       CJNE A,#0FFH,MUSIC5
       LJMP MUSIC3
MUSIC5:NOP
       MOV R6,A
       INC DPTR
       MOV A,B
       MOVC A,@A+DPTR                 ;取节拍代码送R7
       MOV R7,A
       SETB TR0                        ;启动计数
MUSIC2:NOP
       CPL P2.0
       MOV A,R6
       MOV R3,A
       LCALL DEL
       MOV A,R7
       CJNE A,20H,MUSIC2                ;中断计数器(20H)=R7否?;不等,则继续循环 
       MOV 20H,#00H                     ;等于,则取下一代码
       INC DPTR
       ;INC B
       LJMP MUSIC1
MUSIC3:NOP
       CLR TR0                          ;休止100毫秒
       MOV R2,#0DH
MUSIC4:NOP
       MOV R3,#0FFH
       LCALL DEL
       DJNZ R2,MUSIC4
       INC DPTR
       LJMP MUSIC1
END0:  NOP
       MOV R2,#64H                       ;歌曲结束,延时1秒后继续
MUSIC6:MOV R3,#00H
       LCALL DEL
       DJNZ R2,MUSIC6
       LJMP MUSIC0
DELAY:MOV 30H,#100                       ;延长时间等待，键盘消抖
   D1:MOV R5,#200
   D2:DJNZ R5,D2
      DJNZ 30H,D1
      RET
      
  DEL:NOP    
 DEL3:MOV R4,#02H
 DEL4:NOP
      DJNZ R4,DEL4
      NOP
      DJNZ R3,DEL3
      RET
