SHOW_IMG:	; d0 = start tile, d1 = xpos, d2 = ypos, d3 = ysize, d4 = xsize
		move.l #$c00000,a1
		lsl.w #1,d1
		lsl.w #7,d2
		add.w d2,d1
		or.w #$4000,d1
		swap d1
		move.w #3,d1

Y_LOOP:	move.l d1,4(a1)
		swap d1
		add.w #128,d1
		swap d1
		move.w d4,d2

X_LOOP:	move.w d0,(a1)
		addq.w #1,d0
		subq.w #1,d2
		bne.s X_LOOP
		subq.w #1,d3
		bne.s Y_LOOP
		rts
			
	



