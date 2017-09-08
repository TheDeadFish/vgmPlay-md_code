	include "textcode\textcode.asm"
	include "gd3.asm"

Print_Message:
	jsr Init_Screen
	Locate #1,#1
	tst.b cfg_minui
	bmi.s @fullui
@print_end:
	move.w CurRow, Gd3Start
	rts
	
	; full user interface
@fullui:
	PrintCR "MEGADRIVE VGM PLAYER V3.30", $A
	move.l VGM_LIST,d0
	cmp.w #1,d0
	beq.s @SkipSeek
	PrintCR " LEFT/UP  - Previous Track"
	PrintCR " RIGHT/DOWN - Next Track"
@SkipSeek:
	PrintCR " B - Stop Track"
	PrintCr " C - Restart Track"
	move.w #256,d0
	move.w #27,d1
	move.w #1,d2
	move.w #8,d3
	move.w #12,d4
	bsr SHOW_IMG
	bra @print_end
