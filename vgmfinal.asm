ProgName equs "VGM PLAYER V3.31"
ProgDate equs "(C)DFSW 2015-SEP"
	include "libs\genesis.68k"
	include "libs\initvdp.68k"
	include "config.68k"
	include "message.asm"
	include "vgmPlay\interact.68k"

START:
	bsr InitVdp
	ram_clear
	bsr Print_Message
	z80_busreq
	pad1_init
	bra PLAY_BEGIN
VGM_LIST:	

**********************************************
*
*	Ram Locations
*
**********************************************

	var_hi_2 Gd3Start, 2
	var_hi_2 PrintRam, 4
	var_hi_2 VGM_RAM, 4
