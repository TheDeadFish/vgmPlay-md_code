	include textcode\loadgfx.asm
	include textcode\show_img.asm
	include textcode\print.asm

Init_Screen:
	move.l #$c0000000,$c00004
	move.w #$0000,$c00000
	move.w #$0eee,$c00000
	bsr LOADGFX
	rts
