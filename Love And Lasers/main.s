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
	.import		_pad_poll
	.import		_set_vram_buffer
	.import		_one_vram_buffer
	.import		_multi_vram_buffer_horz
	.import		_enemy_active
	.import		_enemy_frozen
	.import		_spawn_enemies
	.import		_update_enemies
	.import		_game_state
	.import		_current_level
	.import		_i
	.import		_selected_crewmate
	.import		_shmup_screen_drawn
	.import		_shmup_started
	.import		_dialogue_shown
	.import		_ending_shown
	.import		_ability_ready
	.import		_frame_count
	.import		_pad1
	.import		_pad1_old
	.import		_player_invincible
	.import		_invincibility_timer
	.import		_zarnella_laser_timer
	.import		_freeze_timer
	.import		_shmup_timer
	.import		_palette
	.import		_spawn_bullets
	.import		_update_regular_bullets
	.import		_enemy_killed_check
	.import		_draw_hud
	.import		_draw_ability_cooldown_bar
	.import		_draw_player
	.import		_handle_shmup_input
	.import		_check_player_hit
	.import		_clear_screen
	.import		_clear_line
	.import		_display_blinking_message
	.import		_mission_begin_text
	.import		_update_arrow
	.import		_draw_crewmate_menu
	.import		_crewmate_confirm_text
	.import		_handle_selection_arrow
	.import		_update_ability_cooldown
	.import		_start_ability_cooldown
	.import		_reset_companion_ability_state
	.import		_fire_zarnella_lasers
	.import		_draw_zarnella_lasers
	.import		_init_level
	.import		_on_level_complete
	.export		_main

.segment	"RODATA"

S000B:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$54,$4F,$20,$53,$54,$41,$52,$54
	.byte	$20,$4D,$49,$53,$53,$49,$4F,$4E,$00
S0017:
	.byte	$50,$52,$45,$53,$53,$20,$53,$54,$41,$52,$54,$20,$54,$4F,$20,$52
	.byte	$45,$53,$54,$41,$52,$54,$00
S0009:
	.byte	$53,$45,$4C,$45,$43,$54,$20,$59,$4F,$55,$52,$20,$43,$52,$45,$57
	.byte	$4D,$41,$54,$45,$00
S0011:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$54,$4F,$20,$43,$4F,$4E,$54,$49
	.byte	$4E,$55,$45,$00
S0005:
	.byte	$42,$52,$49,$45,$46,$49,$4E,$47,$20,$47,$4F,$45,$53,$20,$48,$45
	.byte	$52,$45,$00
S0015:
	.byte	$54,$48,$41,$4E,$4B,$53,$20,$46,$4F,$52,$20,$50,$4C,$41,$59,$49
	.byte	$4E,$47,$00
S000F:
	.byte	$47,$4F,$4F,$44,$20,$4A,$4F,$42,$2C,$20,$43,$41,$50,$54,$41,$49
	.byte	$4E,$00
S000D:
	.byte	$4D,$49,$53,$53,$49,$4F,$4E,$20,$43,$4F,$4D,$50,$4C,$45,$54,$45
	.byte	$21,$00
S0013:
	.byte	$45,$4E,$44,$49,$4E,$47,$20,$47,$4F,$45,$53,$20,$48,$45,$52,$45
	.byte	$00
S0007:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$42,$55,$54,$54,$4F,$4E,$00
S0001:
	.byte	$4C,$4F,$56,$45,$20,$26,$20,$4C,$41,$53,$45,$52,$53,$00
S0003:
	.byte	$50,$52,$45,$53,$53,$20,$53,$54,$41,$52,$54,$00
S0019:
	.byte	$47,$41,$4D,$45,$20,$4F,$56,$45,$52,$00

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
; pal_bg(palette);
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_bg
;
; pal_spr(&palette[4]);
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
L00A1:	jsr     _ppu_on_all
;
; ppu_wait_nmi();
;
L0002:	jsr     _ppu_wait_nmi
;
; frame_count++;
;
	inc     _frame_count
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
	bne     L006E
;
; WRITE("LOVE & LASERS", 10, 12);
;
	jsr     decsp3
	lda     #<(S0001)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0001)
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
	lda     #<(S0003)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0003)
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
	lda     #<(S0005)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0005)
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
L006E:	lda     _game_state
	cmp     #$01
	bne     L0072
;
; BLINK_MSG("PRESS A BUTTON", 9, 15);
;
	jsr     decsp4
	lda     #<(S0007)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0007)
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
	lda     #<(S0009)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0009)
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
L0072:	lda     _game_state
	cmp     #$02
	jne     L0076
;
; unsigned char old_crewmate = selected_crewmate;
;
	lda     _selected_crewmate
	jsr     pusha
;
; handle_selection_arrow();
;
	jsr     _handle_selection_arrow
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
	bcc     L0012
	inx
L0012:	jsr     aslax4
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
	beq     L0013
	lda     _pad1_old
	and     #$80
	bne     L0013
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
	bcc     L0017
	inx
L0017:	jsr     aslax4
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
L0013:	jsr     incsp1
;
; else if (game_state == STATE_CREWMATE_CONFIRM) {
;
	jmp     L0002
L0076:	lda     _game_state
	cmp     #$03
	bne     L007A
;
; crewmate_confirm_text();
;
	jsr     _crewmate_confirm_text
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
; reset_companion_ability_state();
;
	jsr     _reset_companion_ability_state
;
; else if (game_state == STATE_SHMUP) {
;
	jmp     L00A1
L007A:	lda     _game_state
	cmp     #$04
	jne     L0093
;
; if (!shmup_screen_drawn) {
;
	lda     _shmup_screen_drawn
	bne     L007B
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; mission_begin_text();
;
	jsr     _mission_begin_text
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
L007B:	lda     _shmup_started
	bne     L0021
;
; BLINK_MSG("PRESS A TO START MISSION", 4, 24);
;
	jsr     decsp4
	lda     #<(S000B)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S000B)
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
	jmp     L00A1
;
; handle_shmup_input();
;
L0021:	jsr     _handle_shmup_input
;
; if (shmup_timer > 0) {
;
	lda     _shmup_timer
	ora     _shmup_timer+1
	beq     L002A
;
; shmup_timer--;
;
	lda     _shmup_timer
	bne     L0029
	dec     _shmup_timer+1
L0029:	dec     _shmup_timer
;
; if (shmup_timer == 0) {
;
	lda     _shmup_timer
	ora     _shmup_timer+1
	bne     L002A
;
; ppu_off();
;
	jsr     _ppu_off
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
; init_level(current_level + 1); // increase level
;
	lda     _current_level
	clc
	adc     #$01
	jsr     _init_level
;
; on_level_complete(); // move to next game state
;
	jsr     _on_level_complete
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; if (player_invincible) {
;
L002A:	lda     _player_invincible
	beq     L002F
;
; if (invincibility_timer > 0) {
;
	lda     _invincibility_timer
	beq     L0080
;
; invincibility_timer--;
;
	dec     _invincibility_timer
;
; } else {
;
	jmp     L002F
;
; player_invincible = 0;
;
L0080:	sta     _player_invincible
;
; if (freeze_timer > 0) {
;
L002F:	lda     _freeze_timer
	ora     _freeze_timer+1
	beq     L0036
;
; freeze_timer--;
;
	lda     _freeze_timer
	bne     L0032
	dec     _freeze_timer+1
L0032:	dec     _freeze_timer
;
; if (freeze_timer == 0) {
;
	lda     _freeze_timer
	ora     _freeze_timer+1
	bne     L0036
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	sta     _i
L0081:	lda     _i
	cmp     #$06
	bcs     L0036
;
; enemy_frozen[i] = 0; // unfreeze everyone
;
	ldy     _i
	lda     #$00
	sta     _enemy_frozen,y
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	inc     _i
	jmp     L0081
;
; update_ability_cooldown();
;
L0036:	jsr     _update_ability_cooldown
;
; draw_ability_cooldown_bar();
;
	jsr     _draw_ability_cooldown_bar
;
; oam_clear();
;
	jsr     _oam_clear
;
; if (zarnella_laser_timer > 0) {
;
	lda     _zarnella_laser_timer
	beq     L003A
;
; draw_zarnella_lasers();
;
	jsr     _draw_zarnella_lasers
;
; zarnella_laser_timer--;
;
	dec     _zarnella_laser_timer
;
; draw_player();
;
L003A:	jsr     _draw_player
;
; draw_hud();
;
	jsr     _draw_hud
;
; spawn_bullets();
;
	jsr     _spawn_bullets
;
; update_regular_bullets();
;
	jsr     _update_regular_bullets
;
; spawn_enemies();
;
	jsr     _spawn_enemies
;
; update_enemies();
;
	jsr     _update_enemies
;
; enemy_killed_check();
;
	jsr     _enemy_killed_check
;
; check_player_hit();
;
	jsr     _check_player_hit
;
; if ((pad1 & PAD_B) && !(pad1_old & PAD_B)) {
;
	lda     _pad1
	and     #$40
	beq     L008F
	lda     _pad1_old
	and     #$40
	bne     L008F
;
; if (selected_crewmate == 0 && ability_ready) { // Zarnella
;
	lda     _selected_crewmate
	bne     L0087
	lda     _ability_ready
	beq     L0087
;
; fire_zarnella_lasers();
;
	jsr     _fire_zarnella_lasers
;
; start_ability_cooldown();
;
	jsr     _start_ability_cooldown
;
; if (selected_crewmate == 1 && ability_ready) { // Luma-6
;
L0087:	lda     _selected_crewmate
	cmp     #$01
	bne     L008A
	lda     _ability_ready
	beq     L008A
;
; player_invincible = 1;
;
	lda     #$01
	sta     _player_invincible
;
; invincibility_timer = 180;
;
	lda     #$B4
	sta     _invincibility_timer
;
; start_ability_cooldown();
;
	jsr     _start_ability_cooldown
;
; if (selected_crewmate == 2 && ability_ready) { // Mr Bubbles
;
L008A:	lda     _selected_crewmate
	cmp     #$02
	bne     L008F
	lda     _ability_ready
	beq     L008F
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	lda     #$00
	sta     _i
L008D:	lda     _i
	cmp     #$06
	bcs     L004C
;
; if (enemy_active[i]) {
;
	ldy     _i
	lda     _enemy_active,y
	beq     L008E
;
; enemy_frozen[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _enemy_frozen,y
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L008E:	inc     _i
	jmp     L008D
;
; freeze_timer = 300;
;
L004C:	ldx     #$01
	lda     #$2C
	sta     _freeze_timer
	stx     _freeze_timer+1
;
; start_ability_cooldown();
;
	jsr     _start_ability_cooldown
;
; if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
;
L008F:	lda     _pad1
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
; shmup_screen_drawn = 0;
;
	lda     #$00
	sta     _shmup_screen_drawn
;
; shmup_started = 0;
;
	sta     _shmup_started
;
; init_level(current_level + 1);
;
	lda     _current_level
	clc
	adc     #$01
	jsr     _init_level
;
; on_level_complete();
;
	jsr     _on_level_complete
;
; else if (game_state == STATE_DIALOGUE) {
;
	jmp     L00A1
L0093:	lda     _game_state
	cmp     #$05
	jne     L0098
;
; if (!dialogue_shown) {
;
	lda     _dialogue_shown
	bne     L0094
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
	lda     #<(S000D)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000D)
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
	lda     #<(S000F)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000F)
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
	lda     #<(S0011)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0011)
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
L0094:	lda     _pad1
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
	jmp     L00A1
L0098:	lda     _game_state
	cmp     #$06
	jne     L009D
;
; if (!ending_shown) {
;
	lda     _ending_shown
	bne     L0099
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
	lda     #<(S0013)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0013)
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
	lda     #<(S0015)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0015)
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
	lda     #<(S0017)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0017)
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
L0099:	lda     _pad1
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
; else if (game_state == STATE_GAME_OVER) {
;
	jmp     L00A1
L009D:	lda     _game_state
	cmp     #$07
	jne     L0002
;
; BLINK_MSG("GAME OVER", 12, 14);
;
	jsr     decsp4
	lda     #<(S0019)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0019)
	sta     (sp),y
	lda     #$09
	ldy     #$01
	sta     (sp),y
	lda     #$0C
	dey
	sta     (sp),y
	lda     #$0E
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
;
	lda     _pad1
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
; oam_clear();
;
	jsr     _oam_clear
;
; current_level = 1;
;
	lda     #$01
	sta     _current_level
;
; init_level(1);
;
	jsr     _init_level
;
; game_state = STATE_TITLE;
;
	lda     #$00
	sta     _game_state
;
; while (1){
;
	jmp     L00A1

.endproc

