; Prints null terminated string with cursor update
;





; print string control codes
; $0 string end
; $d $a new line
; $c new line with cls









TxtBase equ 0

Locate macro Column, Row
	move.w \Column,CurCol
	move.w \Row,CurRow
	endm
	
PrintStr macro
	pea (\1)
	jsr PrintString
	addq #4, a7
	endm
	
PrintStr2 macro
	pea (\1)
	jsr PrintString
	move.l (a7)+, \1
	endm

PrintCR macro
	Print \_, $A
	endm
Print macro
	jsr PrintStringS
	dc.b \_, 0
	align 2
	endm
	
	
PrintStringS:
	bsr PrintString
	addq.l #1, (sp)
	bclr #0, 3(sp)
	rts 

PrintString:
	movem.l a0-a1/d0-d2,-(a7)
	move.l 24(a7), a0
	move.l #data_port,a1
	move.w CurCol,d0
	move.w CurRow,d1
	vdp_planeB_xy d1, d0, 4(a1)
@loop:
	moveq #0,d2
	move.b (a0)+, d2
	beq.s @endloop
	cmp.b #$0C,d2
	beq.s @crlfcls
	cmp.b #$0A,d2
	beq.s @nextLine1
	addq.w #1,d0
	cmp.w #40,d0
	bcc.s @nextLine
	add.w #TxtBase, d2
	move.w d2,(a1)
	bra @loop
@nextLine:
	suba.w #1,a0
	bra.s @nextLine1	
@crlfcls:
	move.w #0,(a1)
	addq.w #1,d0	
	cmp.w #40,d0
	bcs.s @crlfcls
@nextLine1:
	addq.w #1,CurRow
	moveq #0,d0
	vdp_plane_next d1, 4(a1)
	bra @loop
@endloop:
	move.w d0,CurCol
	move.l a0, 24(a7)
	movem.l (a7)+,a0-a1/d0-d2
	rts

ClearToEnd:
	movem.l a1/d0-d4,-(a7)
	move.l #$c00000,a1
	move.w CurCol,d0
	move.w CurRow,d1
	vdp_planeB_xy d1, d0
@loop0
	move.l d1, 4(a1)
@loop1
	move.w #0,(a1)
	addq.w #1,d0
	cmp.b #40,d0
	bcs.s @loop1
	vdp_plane_next d1, #planeB_last, @endloop
	moveq #0,d0
	bra.s @loop0
@endloop
	movem.l (a7)+,a0/d0-d4
	rts
	
CurCol equ PrintRam+0
CurRow equ PrintRam+2

PrintHex32:
	link.w a6,#-12
	move.l 8(a6),d1
	lea -9(a6),a1
	move.l a1,d0
	lea -1(a6),a0
	clr.b (a0)
@L3
	subq.l #1,a0
	move.b d1,d0
	and.b #15,d0
	cmp.b #10,d0
	ble @L2
	addq.b #8,d0
@L2
	add.b #48,d0
	move.b d0,(a0)
	ror.l #4,d1
	cmp.l a0,a1
	bcs @L3
	PrintStr a0
	unlk a6
	rts

PrintHex32 macro
	pea (\1)
	jsr PrintHex32
	addq #4, a7
	endm