LOADGFX:
	MOVEM	D0-D4/A0,-(A7)
	lea @asciiGfx(pc), a0
	vdp_wrvram $0, ctrl_port
@loadGfx0
	move.l 	#$Aff,d0
	moveq #1,d4
@loadGfx1
	move.b 	(A0)+,D2
	clr.l	d3
	moveq	#7,d1
@loadGfx2
	ROR.L	#4,D4
	BTST	D1,D2
	BEQ		@loadGfx3
	OR.L	D4,D3
@loadGfx3
	DBRA	D1,@loadGfx2
	MOVE.L	D3,$C00000
	DBRA	D0,@loadGfx1
	MOVEM	(A7)+,D0-D4/A0
	RTS

@asciiGfx
	INCBIN	textcode\ASC2.BIN
	INCBIN	textcode\FISH.BIN
