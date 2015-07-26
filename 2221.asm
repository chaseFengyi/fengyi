��������ORG 0000H
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
       SETB ET0                        ;������0
       SETB ET1                        ;������1
       MOV TMOD,#21H
       MOV TH0,#09CH
       MOV TL0,#09CH                   ;��ʱ����ֲ
       MOV TH1,#0D8H
       MOV TL1,#0EFH
       CLR TR0                         ;��ʱ��������
       CLR TR1                        
SCAN:                                  ;����ɨ��
       MOV A,P1                        ;�жϼ��̰��£�����SCAN_1����δ��������ɨ��
       CJNE A,#0F0H,SCAN_1
       NOP
       LJMP SCAN
SCAN_1:ACALL DELAY                       ;�ǲ������Ҫ���£�����ǣ�����תSU_KEY��ѯ���ĸ����£�
       MOV A,P1
       CJNE A,#0F0H,SU_KEY
       NOP
       LJMP SCAN
SU_KEY:JNB P1.0,MU_0                     ;�ж����ĸ������£�
       JNB P1.1,MU_1
       JNB P1.2,MU_2
       JNB P1.3,MU_3
       JNB P1.4,MU_4
       JNB P1.5,MU_5
       JNB P1.6,MU_6
       JNB P1.7,MU_7
       LJMP SCAN
                                       
MU_0: CPL P0.0                        ;���ǵ�һ���������£�������һ��LED
       LCALL DELAY
       SETB P0.0                       ;��ʱ֮��Ϣ���LED
       MOV R1,#19                      ;R1�ź�����
       LJMP NEXT
MU_1:  CPL P0.1                        ;���ǵڶ����������£������ڶ���LED
       LCALL DELAY
       SETB P0.1                       ;��ʱ֮��Ϣ���LED
       MOV R1,#17             
       LJMP NEXT
MU_2: CPL P0.2                        ;���ǵ������������£�����������LED
       LCALL DELAY
       SETB P0.2                       ;��ʱ֮��Ϣ���LED
       MOV R1,#15
       LJMP NEXT
MU_3: CPL P0.3                        ;���ǵ��ĸ��������£��������ĸ�LED
       LCALL DELAY
       SETB P0.3                       ;��ʱ֮��Ϣ���LED
       MOV R1,#14
       LJMP NEXT
MU_4: CPL P0.4                        ;���ǵ�����������£����������LED
       LCALL DELAY
       SETB P0.4                       ;��ʱ֮��Ϣ���LED
       MOV R1,#13
       LJMP NEXT
MU_5: CPL P0.5                        ;���ǵ������������£�����������LED
       LCALL DELAY
       SETB P0.5                       ;��ʱ֮��Ϣ���LED
       MOV R1,#11
       LJMP NEXT
MU_6: CPL P0.6                        ;���ǵ��߸��������£��������߸�LED
       LCALL DELAY
       SETB P0.6                       ;��ʱ֮��Ϣ���LED
       MOV R1,#10
       LJMP NEXT
MU_7: CPL P0.7                        ;���ǵڰ˸��������£������ڰ˸�LED
       LJMP NEXT_2
NEXT: MOV A,R1                
       MOV R0,A
       SETB TR1                        ;������ʱ��0                                                   
NEXT_1:MOV A,P1                         ;û�����¼���ִ�У��м����£����ض�����
       CJNE A,#0FFH,NEXT_1
       ACALL DELAY
       MOV A,P1                       ;���û�����£�
       CJNE A,#0FFH,NEXT_1
       CLR TR1                        ;����
       AJMP SCAN                     ;ɨ�����ȥ
INT_0:                                 ;�жϳ���
       DJNZ R0,RE                     ;R0������0ʱ������
       CPL P2.0
       MOV A,R1
       MOV R0,A
  RE: RETI
NEXT_2: NOP                          ;�Ÿ����
MUSIC0:MOV SP,#50H
       NOP
       MOV DPTR,#DAT                 ;��ͷ��ַ��DPTR
       MOV 20H,#00H                  ;�жϼ�������0
       MOV B,#00H                     ;�������0
MUSIC1:NOP
       CLR A
       MOVC A,@A+DPTR                  ;���ȡ����
       JZ END0                         ;��00H,�����
       CJNE A,#0FFH,MUSIC5
       LJMP MUSIC3
MUSIC5:NOP
       MOV R6,A
       INC DPTR
       MOV A,B
       MOVC A,@A+DPTR                 ;ȡ���Ĵ�����R7
       MOV R7,A
       SETB TR0                        ;��������
MUSIC2:NOP
       CPL P2.0
       MOV A,R6
       MOV R3,A
       LCALL DEL
       MOV A,R7
       CJNE A,20H,MUSIC2                ;�жϼ�����(20H)=R7��?;����,�����ѭ�� 
       MOV 20H,#00H                     ;����,��ȡ��һ����
       INC DPTR
       ;INC B
       LJMP MUSIC1
MUSIC3:NOP
       CLR TR0                          ;��ֹ100����
       MOV R2,#0DH
MUSIC4:NOP
       MOV R3,#0FFH
       LCALL DEL
       DJNZ R2,MUSIC4
       INC DPTR
       LJMP MUSIC1
END0:  NOP
       MOV R2,#64H                       ;��������,��ʱ1������
MUSIC6:MOV R3,#00H
       LCALL DEL
       DJNZ R2,MUSIC6
       LJMP MUSIC0
DELAY:MOV 30H,#100                       ;�ӳ�ʱ��ȴ�����������
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
