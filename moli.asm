code segment
assume cs:code 
;;;;;;;;;;;;;;;;;;;音乐文件;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
freq dw 659,587,659,784,880,1046,880,784,659,784,880
dw 1046,1175,1318,1174,1046,880,1046,784
dw 784,659,784,880,1046,1175,1318,1046,880,784
dw 784,587,659,784,659,587,523,440,523
dw 659,587,523,587,659,784,880,1046,880,783
dw 784,587,659,784,659,587,523,587,440,523
dw 587,659,523,587,523,440,523,440,392
dw 1,523,587,659
dw 784,880,784,659,659,587,659,587,523
dw 659,784,659,784
dw 880,1046,1046,880,784,880,784,880,784
dw 659,784,659,784
dw 880,1175,1318,1175,1046,1046,880,784
dw 784,659,784,880,1046,1175,1318,1046,880,784，0
time dw 10 dup(5000),20000,10000,10000,6 dup(5000),40000,5000,5000,20000,10000,10000
dw 4 dup(20000),50000,10000,10000,10000
dw 6 dup(30000),7500,5000,5000,10000,15000,5000,10000,5000,5000,10000,10000
dw 10000,10000,6 dup(5000),20000,10000,15000,7 dup(5000),30000,20000,20000,4 dup(10000),15000,5000,5000,10000,10000,4 dup(5000),10000,6 dup(5000),30000
dw 30000,10000,30000,10000,15000,5 dup(5000),30000,5000,5000,30000,10000,30000,10000,10000,6 dup(5000),40000,5000,5000,20000,10000,10000,4 dup(5000),10000,10000
reg    dw  3
;;;;;;;;;;;;;;;;;;;;;;计数器3遍;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start1:   
;mov  ch,2

jmp start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start: 
     dec reg        ;减一计数
	 cmp reg,0
	  je endd         ;循环三次结束
      lea si,freq
      lea bp,time
      lea sp,reg 
      mov di,cs:[si];频率
      mov bx,[bp]
      jmp music 
music:    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov dx,0F6h
mov al,10010110B
out dx,al

;;;;;;;;;;;;;;;;;
mov dx,00h		   ;设置被除数
mov ax,5000
div di
mov dx,0F4h
out dx,al
;;;;;;;;;;;;;;;;;;;;;;


;mov ax,1                     ;频率
;out dx,ax
;mov bx,20000                 ; 时间
wait1:	mov cx,6	       ;设循环次数6
delay1:	loop delay1
	dec bx  ;循环持续bx次，即传进来的节拍时间
	jnz wait1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	dec bx
;	jnz wait1
	 add si,2		 
	 add bp,2
	  
	 
	 mov di,cs:[si]
	 cmp di,0
     je start
     
     mov bx,[bp] 
     
	jmp music 
	
endd:
     mov dx,0F6h
mov al,10010110B
out dx,al
code ends
end start