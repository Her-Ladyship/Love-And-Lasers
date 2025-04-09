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
	.export		_clear_screen
	.export		_clear_line
	.export		_display_blinking_message
	.export		_mission_begin_text
	.import		_oam_clear
	.import		_vram_adr
	.import		_vram_fill
	.import		_one_vram_buffer
	.import		_multi_vram_buffer_horz
	.import		_i
	.import		_selected_crewmate
	.import		_frame_count

.segment	"RODATA"

S0001:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte	$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
	.byte	$00
S0006:
	.byte	$49,$27,$4C,$4C,$20,$48,$41,$55,$4E,$54,$20,$59,$4F,$55,$20,$50
	.byte	$45,$52,$53,$4F,$4E,$41,$4C,$4C,$59,$00
S000C:
	.byte	$4C,$45,$54,$27,$53,$20,$4D,$41,$4B,$45,$20,$54,$48,$49,$53,$20
	.byte	$45,$46,$46,$49,$43,$49,$45,$4E,$54,$00
S000A:
	.byte	$54,$41,$43,$54,$49,$43,$41,$4C,$20,$53,$59,$53,$54,$45,$4D,$53
	.byte	$20,$47,$52,$45,$45,$4E,$20,$2D,$00
S0004:
	.byte	$49,$46,$20,$59,$4F,$55,$20,$47,$45,$54,$20,$4D,$45,$20,$4B,$49
	.byte	$4C,$4C,$45,$44,$2C,$00
S0010:
	.byte	$42,$55,$42,$42,$4C,$45,$20,$4D,$4F,$44,$45,$20,$45,$4E,$47,$41
	.byte	$47,$45,$44,$21,$00
S000E:
	.byte	$4D,$52,$20,$42,$55,$42,$42,$4C,$45,$53,$3A,$00
S0002:
	.byte	$5A,$41,$52,$4E,$45,$4C,$4C,$41,$3A,$00
S0008:
	.byte	$4C,$55,$4D,$41,$2D,$36,$3A,$00

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
	jsr     _vram_fill
;
; oam_clear();
;
	jmp     _oam_clear

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
	lda     #<(S0001)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0001)
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
; void __near__ mission_begin_text (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_mission_begin_text: near

.segment	"CODE"

;
; if (selected_crewmate == 0) {
;
	lda     _selected_crewmate
	bne     L0007
;
; WRITE("ZARNELLA:", 11, 10);
;
	jsr     decsp3
	lda     #<(S0002)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0002)
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
	lda     #<(S0004)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0004)
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
	lda     #<(S0006)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0006)
	sta     (sp),y
	lda     #$19
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$E3
;
; else if (selected_crewmate == 1) {
;
	jmp     _multi_vram_buffer_horz
L0007:	lda     _selected_crewmate
	cmp     #$01
	bne     L0004
;
; WRITE("LUMA-6:", 12, 10);
;
	jsr     decsp3
	lda     #<(S0008)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0008)
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
	lda     #<(S000A)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000A)
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
	lda     #<(S000C)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000C)
	sta     (sp),y
	lda     #$19
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$E3
;
; else {
;
	jmp     _multi_vram_buffer_horz
;
; WRITE("MR BUBBLES:", 11, 10);
;
L0004:	jsr     decsp3
	lda     #<(S000E)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000E)
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
	lda     #<(S0010)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0010)
	sta     (sp),y
	lda     #$14
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$A6
	jmp     _multi_vram_buffer_horz

.endproc

