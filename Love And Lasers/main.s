;
; File generated by cc65 v 2.19 - Git 065b0d7
;
	.fopt		compiler,"cc65 v 2.19 - Git 065b0d7"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_pal_bg
	.import		_pal_spr
	.import		_ppu_wait_nmi
	.import		_ppu_off
	.import		_ppu_on_all
	.import		_oam_clear
	.import		_oam_meta_spr
	.import		_pad_poll
	.import		_vram_adr
	.import		_vram_fill
	.import		_set_vram_buffer
	.import		_one_vram_buffer
	.import		_multi_vram_buffer_horz
	.export		_palette
	.export		_game_state
	.export		_frame_count
	.export		_selected_crewmate
	.export		_shmup_screen_drawn
	.export		_shmup_started
	.export		_dialogue_shown
	.export		_ending_shown
	.export		_i
	.export		_pad1
	.export		_pad1_old
	.export		_player_x
	.export		_player_y
	.export		_bullet_x
	.export		_bullet_y
	.export		_bullet_active
	.export		_player_sprite
	.export		_bullet_sprite
	.export		_update_arrow
	.export		_clear_screen
	.export		_draw_crewmate_menu
	.export		_display_blinking_message
	.export		_clear_line
	.export		_clear_all_bullets
	.export		_main

.segment	"DATA"

_game_state:
	.byte	$04
_frame_count:
	.byte	$00
_selected_crewmate:
	.byte	$00
_shmup_screen_drawn:
	.byte	$00
_shmup_started:
	.byte	$00
_dialogue_shown:
	.byte	$00
_ending_shown:
	.byte	$00
_i:
	.byte	$00
_player_x:
	.byte	$20
_player_y:
	.byte	$78

.segment	"RODATA"

_palette:
	.byte	$0F
	.byte	$01
	.byte	$21
	.byte	$31
	.byte	$0F
	.byte	$17
	.byte	$27
	.byte	$37
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
_player_sprite:
	.byte	$00
	.byte	$00
	.byte	$41
	.byte	$00
	.byte	$80
_bullet_sprite:
	.byte	$00
	.byte	$00
	.byte	$42
	.byte	$00
	.byte	$80
S003C:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte	$00
S0016:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$57,$55,$42,$42
	.byte	$4C,$45,$20,$57,$55,$42,$42,$4C,$45,$21,$00
S001C:
	.byte	$49,$27,$4C,$4C,$20,$48,$41,$55,$4E,$54,$20,$59,$4F,$55,$20,$50
	.byte	$45,$52,$53,$4F,$4E,$41,$4C,$4C,$59,$00
S0022:
	.byte	$4C,$45,$54,$27,$53,$20,$4D,$41,$4B,$45,$20,$54,$48,$49,$53,$20
	.byte	$45,$46,$46,$49,$43,$49,$45,$4E,$54,$00
S0014:
	.byte	$4D,$52,$20,$42,$55,$42,$42,$4C,$45,$53,$3A,$20,$57,$55,$42,$42
	.byte	$4C,$45,$20,$57,$55,$42,$42,$4C,$45,$00
S0010:
	.byte	$4C,$55,$4D,$41,$2D,$36,$3A,$20,$55,$50,$4C,$4F,$41,$44,$49,$4E
	.byte	$47,$20,$4D,$49,$53,$53,$49,$4F,$4E,$00
S0028:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$54,$4F,$20,$53,$54,$41,$52,$54
	.byte	$20,$4D,$49,$53,$53,$49,$4F,$4E,$00
S000E:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$44,$4F,$57,$4E,$2C,$20
	.byte	$4D,$45,$41,$54,$42,$41,$47,$2E,$00
S0020:
	.byte	$54,$41,$43,$54,$49,$43,$41,$4C,$20,$53,$59,$53,$54,$45,$4D,$53
	.byte	$20,$47,$52,$45,$45,$4E,$20,$2D,$00
S000C:
	.byte	$5A,$41,$52,$4E,$45,$4C,$4C,$41,$3A,$20,$44,$4F,$4E,$27,$54,$20
	.byte	$53,$4C,$4F,$57,$20,$4D,$45,$00
S0034:
	.byte	$50,$52,$45,$53,$53,$20,$53,$54,$41,$52,$54,$20,$54,$4F,$20,$52
	.byte	$45,$53,$54,$41,$52,$54,$00
S001A:
	.byte	$49,$46,$20,$59,$4F,$55,$20,$47,$45,$54,$20,$4D,$45,$20,$4B,$49
	.byte	$4C,$4C,$45,$44,$2C,$00
S0026:
	.byte	$42,$55,$42,$42,$4C,$45,$20,$4D,$4F,$44,$45,$20,$45,$4E,$47,$41
	.byte	$47,$45,$44,$21,$00
S000A:
	.byte	$53,$45,$4C,$45,$43,$54,$20,$59,$4F,$55,$52,$20,$43,$52,$45,$57
	.byte	$4D,$41,$54,$45,$00
S002E:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$54,$4F,$20,$43,$4F,$4E,$54,$49
	.byte	$4E,$55,$45,$00
S0006:
	.byte	$42,$52,$49,$45,$46,$49,$4E,$47,$20,$47,$4F,$45,$53,$20,$48,$45
	.byte	$52,$45,$00
S0012:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$50,$52,$4F,$54,$4F,$43,$4F,$4C
	.byte	$53,$2E,$00
S0032:
	.byte	$54,$48,$41,$4E,$4B,$53,$20,$46,$4F,$52,$20,$50,$4C,$41,$59,$49
	.byte	$4E,$47,$00
S002A:
	.byte	$4D,$49,$53,$53,$49,$4F,$4E,$20,$43,$4F,$4D,$50,$4C,$45,$54,$45
	.byte	$21,$00
S002C:
	.byte	$47,$4F,$4F,$44,$20,$4A,$4F,$42,$2C,$20,$43,$41,$50,$54,$41,$49
	.byte	$4E,$00
S0030:
	.byte	$45,$4E,$44,$49,$4E,$47,$20,$47,$4F,$45,$53,$20,$48,$45,$52,$45
	.byte	$00
S0008:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$42,$55,$54,$54,$4F,$4E,$00
S0002:
	.byte	$4C,$4F,$56,$45,$20,$26,$20,$4C,$41,$53,$45,$52,$53,$00
S0004:
	.byte	$50,$52,$45,$53,$53,$20,$53,$54,$41,$52,$54,$00
S0024:
	.byte	$4D,$52,$20,$42,$55,$42,$42,$4C,$45,$53,$3A,$00
S003A:
	.byte	$4D,$52,$20,$42,$55,$42,$42,$4C,$45,$53,$00
S0018:
	.byte	$5A,$41,$52,$4E,$45,$4C,$4C,$41,$3A,$00
S0036:
	.byte	$5A,$41,$52,$4E,$45,$4C,$4C,$41,$00
S001E:
	.byte	$4C,$55,$4D,$41,$2D,$36,$3A,$00
S0038:
	.byte	$4C,$55,$4D,$41,$2D,$36,$00

.segment	"BSS"

.segment	"ZEROPAGE"
_pad1:
	.res	1,$00
_pad1_old:
	.res	1,$00
_bullet_x:
	.res	4,$00
_bullet_y:
	.res	4,$00
_bullet_active:
	.res	4,$00

; ---------------------------------------------------------------
; void __near__ update_arrow (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_update_arrow: near

.segment	"CODE"

;
; int arrow_addr = NTADR_A(8, 11 + selected_crewmate * 4);
;
	ldx     #$00
	lda     _selected_crewmate
	jsr     shlax2
	clc
	adc     #$0B
	bcc     L0002
	inx
L0002:	jsr     aslax4
	stx     tmp1
	asl     a
	rol     tmp1
	ora     #$08
	pha
	lda     tmp1
	ora     #$20
	tax
	pla
	jsr     pushax
;
; one_vram_buffer('>', arrow_addr);
;
	lda     #$3E
	jsr     pusha
	ldy     #$02
	lda     (sp),y
	tax
	dey
	lda     (sp),y
	jsr     _one_vram_buffer
;
; }
;
	jmp     incsp2

.endproc

; ---------------------------------------------------------------
; void __near__ clear_screen (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_clear_screen: near

.segment	"CODE"

;
; vram_adr(NTADR_A(0, 0));
;
	ldx     #$20
	lda     #$00
	jsr     _vram_adr
;
; vram_fill(' ', 32 * 30);
;
	lda     #$20
	jsr     pusha
	ldx     #$03
	lda     #$C0
	jmp     _vram_fill

.endproc

; ---------------------------------------------------------------
; void __near__ draw_crewmate_menu (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_draw_crewmate_menu: near

.segment	"CODE"

;
; WRITE("ZARNELLA", 10, 11);
;
	jsr     decsp3
	lda     #<(S0036)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0036)
	sta     (sp),y
	lda     #$08
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$6A
	jsr     _multi_vram_buffer_horz
;
; WRITE("LUMA-6", 10, 15);
;
	jsr     decsp3
	lda     #<(S0038)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0038)
	sta     (sp),y
	lda     #$06
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$EA
	jsr     _multi_vram_buffer_horz
;
; WRITE("MR BUBBLES", 10, 19);
;
	jsr     decsp3
	lda     #<(S003A)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S003A)
	sta     (sp),y
	lda     #$0A
	ldy     #$00
	sta     (sp),y
	ldx     #$22
	lda     #$6A
	jmp     _multi_vram_buffer_horz

.endproc

; ---------------------------------------------------------------
; void __near__ display_blinking_message (const char *message, unsigned char len, unsigned char x, unsigned char y)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_display_blinking_message: near

.segment	"CODE"

;
; void display_blinking_message(const char* message, unsigned char len, unsigned char x, unsigned char y) {
;
	jsr     pusha
;
; frame_count++;
;
	inc     _frame_count
;
; if ((frame_count & 0x20) == 0) {
;
	lda     _frame_count
	and     #$20
	bne     L000A
;
; multi_vram_buffer_horz(message, len, NTADR_A(x, y));
;
	jsr     decsp3
	ldy     #$07
	lda     (sp),y
	tax
	dey
	lda     (sp),y
	ldy     #$01
	sta     (sp),y
	iny
	txa
	sta     (sp),y
	ldy     #$05
	lda     (sp),y
	ldy     #$00
	sta     (sp),y
	ldy     #$03
	ldx     #$00
	lda     (sp),y
	jsr     aslax4
	stx     tmp1
	asl     a
	rol     tmp1
	sta     ptr1
	iny
	lda     (sp),y
	ora     ptr1
	pha
	lda     tmp1
	ora     #$20
	tax
	pla
	jsr     _multi_vram_buffer_horz
;
; } else {
;
	jmp     incsp5
;
; for (i = 0; i < len; ++i) {
;
L000A:	lda     #$00
	sta     _i
L000B:	lda     _i
	ldy     #$02
	cmp     (sp),y
	bcs     L0006
;
; one_vram_buffer(' ', NTADR_A(x + i, y));
;
	lda     #$20
	jsr     pusha
	ldy     #$01
	ldx     #$00
	lda     (sp),y
	jsr     aslax4
	stx     tmp1
	asl     a
	rol     tmp1
	sta     ptr1
	ldx     #$00
	iny
	lda     (sp),y
	clc
	adc     _i
	bcc     L0009
	inx
L0009:	ora     ptr1
	pha
	txa
	ora     tmp1
	tax
	pla
	pha
	txa
	ora     #$20
	tax
	pla
	jsr     _one_vram_buffer
;
; for (i = 0; i < len; ++i) {
;
	inc     _i
	jmp     L000B
;
; }
;
L0006:	jmp     incsp5

.endproc

; ---------------------------------------------------------------
; void __near__ clear_line (unsigned char y)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_clear_line: near

.segment	"CODE"

;
; void clear_line(unsigned char y) {
;
	jsr     pusha
;
; multi_vram_buffer_horz("                                ", 32, NTADR_A(0, y));
;
	jsr     decsp3
	lda     #<(S003C)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S003C)
	sta     (sp),y
	lda     #$20
	ldy     #$00
	sta     (sp),y
	ldy     #$03
	ldx     #$00
	lda     (sp),y
	jsr     aslax4
	stx     tmp1
	asl     a
	rol     tmp1
	pha
	lda     tmp1
	ora     #$20
	tax
	pla
	jsr     _multi_vram_buffer_horz
;
; }
;
	jmp     incsp1

.endproc

; ---------------------------------------------------------------
; void __near__ clear_all_bullets (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_clear_all_bullets: near

.segment	"CODE"

;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
	lda     #$00
	sta     _i
L0007:	lda     _i
	cmp     #$04
	bcs     L0003
;
; bullet_active[i] = 0;
;
	ldy     _i
	lda     #$00
	sta     _bullet_active,y
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
	inc     _i
	jmp     L0007
;
; }
;
L0003:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; ppu_off();
;
	jsr     _ppu_off
;
; pal_bg(palette);      // for background
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_bg
;
; pal_spr(&palette[4]);  // for sprite colours
;
	lda     #<(_palette+4)
	ldx     #>(_palette+4)
	jsr     _pal_spr
;
; set_vram_buffer();
;
	jsr     _set_vram_buffer
;
; ppu_on_all();
;
L00C1:	jsr     _ppu_on_all
;
; ppu_wait_nmi();
;
L0002:	jsr     _ppu_wait_nmi
;
; pad1_old = pad1;
;
	lda     _pad1
	sta     _pad1_old
;
; pad1 = pad_poll(0);
;
	lda     #$00
	jsr     _pad_poll
	sta     _pad1
;
; if (game_state == STATE_TITLE) {
;
	lda     _game_state
	bne     L007C
;
; WRITE("LOVE & LASERS", 10, 12);
;
	jsr     decsp3
	lda     #<(S0002)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0002)
	sta     (sp),y
	lda     #$0D
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$8A
	jsr     _multi_vram_buffer_horz
;
; BLINK_MSG("PRESS START", 11, 15);
;
	jsr     decsp4
	lda     #<(S0004)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0004)
	sta     (sp),y
	lda     #$0B
	ldy     #$01
	sta     (sp),y
	dey
	sta     (sp),y
	lda     #$0F
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
;
	lda     _pad1
	and     #$10
	beq     L0002
	lda     _pad1_old
	and     #$10
	bne     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; WRITE("BRIEFING GOES HERE", 7, 12);
;
	jsr     decsp3
	lda     #<(S0006)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0006)
	sta     (sp),y
	lda     #$12
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$87
	jsr     _multi_vram_buffer_horz
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; game_state = STATE_BRIEFING;
;
	lda     #$01
	sta     _game_state
;
; else if (game_state == STATE_BRIEFING) {
;
	jmp     L0002
L007C:	lda     _game_state
	cmp     #$01
	bne     L0080
;
; BLINK_MSG("PRESS A BUTTON", 9, 15);
;
	jsr     decsp4
	lda     #<(S0008)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0008)
	sta     (sp),y
	lda     #$0E
	ldy     #$01
	sta     (sp),y
	lda     #$09
	dey
	sta     (sp),y
	lda     #$0F
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
;
	lda     _pad1
	and     #$80
	jeq     L0002
	lda     _pad1_old
	and     #$80
	jne     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; WRITE("SELECT YOUR CREWMATE", 6, 4);
;
	jsr     decsp3
	lda     #<(S000A)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000A)
	sta     (sp),y
	lda     #$14
	ldy     #$00
	sta     (sp),y
	ldx     #$20
	lda     #$86
	jsr     _multi_vram_buffer_horz
;
; clear_line(15);
;
	lda     #$0F
	jsr     _clear_line
;
; selected_crewmate = 0;
;
	lda     #$00
	sta     _selected_crewmate
;
; draw_crewmate_menu();
;
	jsr     _draw_crewmate_menu
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; game_state = STATE_SELECT_CREWMATE;
;
	lda     #$02
	sta     _game_state
;
; else if (game_state == STATE_SELECT_CREWMATE) {
;
	jmp     L0002
L0080:	lda     _game_state
	cmp     #$02
	jne     L008D
;
; unsigned char old_crewmate = selected_crewmate;
;
	lda     _selected_crewmate
	jsr     pusha
;
; if ((pad1 & PAD_DOWN) && !(pad1_old & PAD_DOWN)) {
;
	lda     _pad1
	and     #$04
	beq     L0084
	lda     _pad1_old
	and     #$04
	bne     L0084
;
; selected_crewmate++;
;
	inc     _selected_crewmate
;
; if (selected_crewmate > 2) selected_crewmate = 0;
;
	lda     _selected_crewmate
	cmp     #$03
	bcc     L0084
	lda     #$00
	sta     _selected_crewmate
;
; if ((pad1 & PAD_UP) && !(pad1_old & PAD_UP)) {
;
L0084:	lda     _pad1
	and     #$08
	beq     L0089
	lda     _pad1_old
	and     #$08
	bne     L0089
;
; if (selected_crewmate == 0) selected_crewmate = 2;
;
	lda     _selected_crewmate
	bne     L0088
	lda     #$02
	sta     _selected_crewmate
;
; else selected_crewmate--;
;
	jmp     L0089
L0088:	dec     _selected_crewmate
;
; one_vram_buffer(' ', NTADR_A(8, 11 + old_crewmate * 4));
;
L0089:	lda     #$20
	jsr     pusha
	ldy     #$01
	ldx     #$00
	lda     (sp),y
	jsr     shlax2
	clc
	adc     #$0B
	bcc     L001D
	inx
L001D:	jsr     aslax4
	stx     tmp1
	asl     a
	rol     tmp1
	ora     #$08
	pha
	lda     tmp1
	ora     #$20
	tax
	pla
	jsr     _one_vram_buffer
;
; update_arrow();
;
	jsr     _update_arrow
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
;
	lda     _pad1
	and     #$80
	beq     L001E
	lda     _pad1_old
	and     #$80
	bne     L001E
;
; ppu_off();
;
	jsr     _ppu_off
;
; one_vram_buffer(' ', NTADR_A(8, 11 + old_crewmate * 4));
;
	lda     #$20
	jsr     pusha
	ldy     #$01
	ldx     #$00
	lda     (sp),y
	jsr     shlax2
	clc
	adc     #$0B
	bcc     L0022
	inx
L0022:	jsr     aslax4
	stx     tmp1
	asl     a
	rol     tmp1
	ora     #$08
	pha
	lda     tmp1
	ora     #$20
	tax
	pla
	jsr     _one_vram_buffer
;
; clear_screen();
;
	jsr     _clear_screen
;
; game_state = STATE_CREWMATE_CONFIRM;
;
	lda     #$03
	sta     _game_state
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; }
;
L001E:	jsr     incsp1
;
; else if (game_state == STATE_CREWMATE_CONFIRM) {
;
	jmp     L0002
L008D:	lda     _game_state
	cmp     #$03
	jne     L0092
;
; if (selected_crewmate == 0) {
;
	lda     _selected_crewmate
	bne     L008E
;
; WRITE("ZARNELLA: DON'T SLOW ME", 2, 12);
;
	jsr     decsp3
	lda     #<(S000C)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000C)
	sta     (sp),y
	lda     #$17
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$82
	jsr     _multi_vram_buffer_horz
;
; WRITE("          DOWN, MEATBAG.", 2, 14);
;
	jsr     decsp3
	lda     #<(S000E)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000E)
	sta     (sp),y
	lda     #$18
;
; else if (selected_crewmate == 1) {
;
	jmp     L00C3
L008E:	lda     _selected_crewmate
	cmp     #$01
	bne     L0027
;
; WRITE("LUMA-6: UPLOADING MISSION", 2, 12);
;
	jsr     decsp3
	lda     #<(S0010)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0010)
	sta     (sp),y
	lda     #$19
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$82
	jsr     _multi_vram_buffer_horz
;
; WRITE("        PROTOCOLS.", 2, 14);
;
	jsr     decsp3
	lda     #<(S0012)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0012)
	sta     (sp),y
	lda     #$12
;
; else {
;
	jmp     L00C3
;
; WRITE("MR BUBBLES: WUBBLE WUBBLE", 2, 12);
;
L0027:	jsr     decsp3
	lda     #<(S0014)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0014)
	sta     (sp),y
	lda     #$19
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$82
	jsr     _multi_vram_buffer_horz
;
; WRITE("            WUBBLE WUBBLE!", 2, 14);
;
	jsr     decsp3
	lda     #<(S0016)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0016)
	sta     (sp),y
	lda     #$1A
L00C3:	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$C2
	jsr     _multi_vram_buffer_horz
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
;
	lda     _pad1
	and     #$80
	jeq     L0002
	lda     _pad1_old
	and     #$80
	jne     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; game_state = STATE_SHMUP;
;
	lda     #$04
	sta     _game_state
;
; else if (game_state == STATE_SHMUP) {
;
	jmp     L00C1
L0092:	lda     _game_state
	cmp     #$04
	jne     L00B5
;
; if (!shmup_screen_drawn) {
;
	lda     _shmup_screen_drawn
	jne     L0094
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; if (selected_crewmate == 0) {
;
	lda     _selected_crewmate
	bne     L0093
;
; WRITE("ZARNELLA:", 11, 10);
;
	jsr     decsp3
	lda     #<(S0018)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0018)
	sta     (sp),y
	lda     #$09
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$4B
	jsr     _multi_vram_buffer_horz
;
; WRITE("IF YOU GET ME KILLED,", 5, 13);
;
	jsr     decsp3
	lda     #<(S001A)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S001A)
	sta     (sp),y
	lda     #$15
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$A5
	jsr     _multi_vram_buffer_horz
;
; WRITE("I'LL HAUNT YOU PERSONALLY", 3, 15);
;
	jsr     decsp3
	lda     #<(S001C)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S001C)
	sta     (sp),y
	lda     #$19
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$E3
;
; else if (selected_crewmate == 1) {
;
	jmp     L0078
L0093:	lda     _selected_crewmate
	cmp     #$01
	bne     L0032
;
; WRITE("LUMA-6:", 12, 10);
;
	jsr     decsp3
	lda     #<(S001E)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S001E)
	sta     (sp),y
	lda     #$07
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$4C
	jsr     _multi_vram_buffer_horz
;
; WRITE("TACTICAL SYSTEMS GREEN -", 4, 13);
;
	jsr     decsp3
	lda     #<(S0020)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0020)
	sta     (sp),y
	lda     #$18
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$A4
	jsr     _multi_vram_buffer_horz
;
; WRITE("LET'S MAKE THIS EFFICIENT", 3, 15);
;
	jsr     decsp3
	lda     #<(S0022)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0022)
	sta     (sp),y
	lda     #$19
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$E3
;
; else {
;
	jmp     L0078
;
; WRITE("MR BUBBLES:", 11, 10);
;
L0032:	jsr     decsp3
	lda     #<(S0024)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0024)
	sta     (sp),y
	lda     #$0B
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$4B
	jsr     _multi_vram_buffer_horz
;
; WRITE("BUBBLE MODE ENGAGED!", 6, 13);
;
	jsr     decsp3
	lda     #<(S0026)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0026)
	sta     (sp),y
	lda     #$14
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$A6
L0078:	jsr     _multi_vram_buffer_horz
;
; shmup_screen_drawn = 1;
;
	lda     #$01
	sta     _shmup_screen_drawn
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; if (shmup_started == 0) {
;
L0094:	lda     _shmup_started
	bne     L0098
;
; BLINK_MSG("PRESS A TO START MISSION", 4, 24);
;
	jsr     decsp4
	lda     #<(S0028)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0028)
	sta     (sp),y
	lda     #$18
	ldy     #$01
	sta     (sp),y
	lda     #$04
	dey
	sta     (sp),y
	lda     #$18
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
;
	lda     _pad1
	and     #$80
	jeq     L0002
	lda     _pad1_old
	and     #$80
	jne     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; clear_line(24);
;
	lda     #$18
	jsr     _clear_line
;
; shmup_started = 1;
;
	lda     #$01
	sta     _shmup_started
;
; else {
;
	jmp     L00C1
;
; if (pad1 & PAD_LEFT && player_x > 8) player_x--;
;
L0098:	lda     _pad1
	and     #$02
	beq     L009C
	lda     _player_x
	cmp     #$09
	bcc     L009C
	dec     _player_x
;
; if (pad1 & PAD_RIGHT && player_x < 40) player_x++;
;
L009C:	lda     _pad1
	and     #$01
	beq     L00A0
	lda     _player_x
	cmp     #$28
	bcs     L00A0
	inc     _player_x
;
; if (pad1 & PAD_UP && player_y > 0) player_y--;
;
L00A0:	lda     _pad1
	and     #$08
	beq     L00A4
	lda     _player_y
	beq     L00A4
	dec     _player_y
;
; if (pad1 & PAD_DOWN && player_y < 232) player_y++;
;
L00A4:	lda     _pad1
	and     #$04
	beq     L0046
	lda     _player_y
	cmp     #$E8
	bcs     L0046
	inc     _player_y
;
; oam_clear();
;
L0046:	jsr     _oam_clear
;
; oam_meta_spr(player_x, player_y, player_sprite);
;
	jsr     decsp2
	lda     _player_x
	ldy     #$01
	sta     (sp),y
	lda     _player_y
	dey
	sta     (sp),y
	lda     #<(_player_sprite)
	ldx     #>(_player_sprite)
	jsr     _oam_meta_spr
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
;
	lda     _pad1
	and     #$80
	beq     L00AE
	lda     _pad1_old
	and     #$80
	bne     L00AD
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
	sta     _i
L00AB:	lda     _i
	cmp     #$04
	bcs     L00AD
;
; if (!bullet_active[i]) {
;
	ldy     _i
	lda     _bullet_active,y
	bne     L00AC
;
; bullet_active[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _bullet_active,y
;
; bullet_x[i] = player_x + 8; // Start just ahead of player
;
	lda     #<(_bullet_x)
	ldx     #>(_bullet_x)
	clc
	adc     _i
	bcc     L0055
	inx
L0055:	sta     ptr1
	stx     ptr1+1
	lda     _player_x
	clc
	adc     #$08
	ldy     #$00
	sta     (ptr1),y
;
; bullet_y[i] = player_y;
;
	ldy     _i
	lda     _player_y
	sta     _bullet_y,y
;
; break;
;
	jmp     L00AD
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L00AC:	inc     _i
	jmp     L00AB
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L00AD:	lda     #$00
L00AE:	sta     _i
L00AF:	lda     _i
	cmp     #$04
	bcs     L00B1
;
; if (bullet_active[i]) {
;
	ldy     _i
	lda     _bullet_active,y
	beq     L00B0
;
; bullet_x[i] += 2;
;
	lda     #<(_bullet_x)
	ldx     #>(_bullet_x)
	clc
	adc     _i
	bcc     L005E
	inx
L005E:	sta     ptr1
	stx     ptr1+1
	ldy     #$00
	lda     (ptr1),y
	clc
	adc     #$02
	sta     (ptr1),y
;
; if (bullet_x[i] > BULLET_RIGHT_LIMIT) {
;
	ldy     _i
	lda     _bullet_x,y
	cmp     #$FD
	bcc     L005F
;
; bullet_active[i] = 0;
;
	ldy     _i
	lda     #$00
	sta     _bullet_active,y
;
; } else {
;
	jmp     L00B0
;
; oam_meta_spr(bullet_x[i], bullet_y[i], bullet_sprite);
;
L005F:	jsr     decsp2
	ldy     _i
	lda     _bullet_x,y
	ldy     #$01
	sta     (sp),y
	ldy     _i
	lda     _bullet_y,y
	ldy     #$00
	sta     (sp),y
	lda     #<(_bullet_sprite)
	ldx     #>(_bullet_sprite)
	jsr     _oam_meta_spr
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L00B0:	inc     _i
	jmp     L00AF
;
; if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
;
L00B1:	lda     _pad1
	and     #$10
	jeq     L0002
	lda     _pad1_old
	and     #$10
	jne     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; clear_all_bullets();
;
	jsr     _clear_all_bullets
;
; oam_clear();
;
	jsr     _oam_clear
;
; shmup_screen_drawn = 0;
;
	lda     #$00
	sta     _shmup_screen_drawn
;
; shmup_started = 0;
;
	sta     _shmup_started
;
; game_state = STATE_DIALOGUE;
;
	lda     #$05
	sta     _game_state
;
; else if (game_state == STATE_DIALOGUE) {
;
	jmp     L00C1
L00B5:	lda     _game_state
	cmp     #$05
	jne     L00BA
;
; if (!dialogue_shown) {
;
	lda     _dialogue_shown
	bne     L00B6
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; WRITE("MISSION COMPLETE!", 7, 10);
;
	jsr     decsp3
	lda     #<(S002A)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S002A)
	sta     (sp),y
	lda     #$11
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$47
	jsr     _multi_vram_buffer_horz
;
; WRITE("GOOD JOB, CAPTAIN", 7, 12);
;
	jsr     decsp3
	lda     #<(S002C)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S002C)
	sta     (sp),y
	lda     #$11
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$87
	jsr     _multi_vram_buffer_horz
;
; WRITE("PRESS A TO CONTINUE", 6, 24);
;
	jsr     decsp3
	lda     #<(S002E)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S002E)
	sta     (sp),y
	lda     #$13
	ldy     #$00
	sta     (sp),y
	ldx     #$23
	lda     #$06
	jsr     _multi_vram_buffer_horz
;
; dialogue_shown = 1;
;
	lda     #$01
	sta     _dialogue_shown
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
;
L00B6:	lda     _pad1
	and     #$80
	jeq     L0002
	lda     _pad1_old
	and     #$80
	jne     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; dialogue_shown = 0;
;
	lda     #$00
	sta     _dialogue_shown
;
; game_state = STATE_ENDING;
;
	lda     #$06
	sta     _game_state
;
; else if (game_state == STATE_ENDING) {
;
	jmp     L00C1
L00BA:	lda     _game_state
	cmp     #$06
	jne     L0002
;
; if (!ending_shown) {
;
	lda     _ending_shown
	bne     L00BB
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; WRITE("ENDING GOES HERE", 8, 10);
;
	jsr     decsp3
	lda     #<(S0030)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0030)
	sta     (sp),y
	lda     #$10
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$48
	jsr     _multi_vram_buffer_horz
;
; WRITE("THANKS FOR PLAYING", 7, 12);
;
	jsr     decsp3
	lda     #<(S0032)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0032)
	sta     (sp),y
	lda     #$12
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$87
	jsr     _multi_vram_buffer_horz
;
; WRITE("PRESS START TO RESTART", 5, 24);
;
	jsr     decsp3
	lda     #<(S0034)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0034)
	sta     (sp),y
	lda     #$16
	ldy     #$00
	sta     (sp),y
	ldx     #$23
	lda     #$05
	jsr     _multi_vram_buffer_horz
;
; ending_shown = 1;
;
	lda     #$01
	sta     _ending_shown
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
;
L00BB:	lda     _pad1
	and     #$10
	jeq     L0002
	lda     _pad1_old
	and     #$10
	jne     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; game_state = STATE_TITLE;
;
	lda     #$00
	sta     _game_state
;
; ending_shown = 0;
;
	sta     _ending_shown
;
; while (1){
;
	jmp     L00C1

.endproc

