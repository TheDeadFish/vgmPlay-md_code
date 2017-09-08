DISPLAY_GD3 macro address, row
	pea (\address)
	jsr SHOW_GD3
	addq.w #4, a7
	endm

GD3_SPACE_SRC 	equr d2
GD3_SPACE_DST	equr d3
GD3_CURSOR		equr d4

PRINT_GD3:; a0 = header, a1 = GD3 string, d0/d1/a1/a2/a3 wacked
	link a3,#-256
	PrintStr2 a0
	moveq #0,GD3_SPACE_SRC	
	moveq #7,GD3_CURSOR
	move.l a7,a2
	move.w #250,d0

PRINT_GD3L:
	move.b (a1)+,d1
	tst.b (a1)+
	beq.s @chok
	moveq #63, d1
@chok:
	tst.b d1
	beq.s PRINT_GD3E		; leave when null
	tst.w d0
	beq.s PRINT_GD3L		; continue when string to long
	subq.w #1,d0 
	addq.w #1,GD3_CURSOR
	; check for new line
	cmp.b #$0D,d1
	bne.s PRINT_GD3NCR
	move.b (a1)+,d1
	move.b (a1)+,d1
	bra.s PRINT_GD3ICR

PRINT_GD3NCR:
	cmp.w #40,GD3_CURSOR	
	beq.s PRINT_GD3CR		; end of line goto CR processing
	move.b d1,(a2)+
	cmp.b #32,d1
	bne.s PRINT_GD3L		; skip when not continue
	move.l a1,GD3_SPACE_SRC
	move.l a2,GD3_SPACE_DST	
	bra PRINT_GD3L

PRINT_GD3CR: ; end of line processing
	cmp.b #32,d1
	beq.s PRINT_GD3ICR
	tst.l GD3_SPACE_SRC
	beq.s PRINT_GD3CR1
	move.l GD3_SPACE_SRC,a1
	move.l GD3_SPACE_DST,a2
PRINT_GD3ICR:
	move.b #$c,(a2)+
	move.b #32,(a2)+
	moveq #0,GD3_SPACE_SRC
	moveq #1,GD3_CURSOR
	bra PRINT_GD3L

PRINT_GD3CR1:
	move.b #$c,(a2)+
	move.b #32,(a2)+
	move.b d1,(a2)+
	moveq #0,GD3_SPACE_SRC
	moveq #2,GD3_CURSOR
	bra PRINT_GD3L

PRINT_GD3E:
	move.b #$c,(a2)+
	move.b d1,(a2)+
	move.l a7,a2
	PrintStr a2
	unlk a3
	rts

SKIP_GD3:
	move.b (a1)+,d1
	or.b (a1)+,d1
	bne.s SKIP_GD3
	tst.b -1(a0)
	beq.s @1f
@1b:
	tst.b (a0)+
	bne.s @1b
@1f:
	rts

SHOW_GD3:
	; draw header
	movem.l a0-a3/d0-d4,-(a7)
	Locate #0, Gd3Start
	move.l 40(a7), a1
	ReadBig32 a1, d0
	cmp.l #$47643320,d0
	bne.s @badgd3
	tst.b cfg_minui
	bpl.s @minui
	PrintCR $A, $A, " GD3 INFO", $A
@minui:
	
	; draw gd3 info
	lea GD3_TEXT(pc),a0
	adda.w #8,a1
@loop1:
	move.b (a0)+, d0
	bmi.s @loope
	and.b cfg_minui, d0
	pea @loop1(pc)
	beq SKIP_GD3
	bra PRINT_GD3
@loope:
	add.w #1,CurRow
@badgd3:
	bsr ClearToEnd
	movem.l (a7)+, a0-a3/d0-d4
	rts

GD3_TEXT:
	dc.b 1, " Track:", 0, 0
	dc.b 2, " Game :", 0, 0, 0, 0
	dc.b 4, " Auth.:", 0, 0
	dc.b 8, " Date :", 0
	dc.b 16, " VgmBy:", 0
	dc.b 32, " Notes:", 0, -1
	align 2
