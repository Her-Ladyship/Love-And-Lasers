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
	.import		_spawn_basic
	.import		_spawn_fast
	.import		_spawn_tough
	.import		_update_enemies
	.import		_spawn_boss
	.import		_update_boss
	.import		_game_state
	.import		_current_level
	.import		_i
	.import		_briefing_started
	.import		_selected_crewmate
	.import		_previous_crewmate
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
	.import		_boss_active
	.import		_freeze_timer
	.import		_player_score
	.import		_shmup_timer
	.import		_typewriter_ended
	.import		_zarnella_picks
	.import		_luma_picks
	.import		_bubbles_picks
	.import		_total_romance_score
	.import		_palette
	.import		_spawn_bullets
	.import		_update_regular_bullets
	.import		_enemy_killed_check
	.import		_check_boss_hit
	.import		_check_boss_bullet_hit
	.import		_draw_hud
	.import		_draw_ability_cooldown_bar
	.import		_draw_player
	.import		_handle_shmup_input
	.import		_check_player_hit
	.import		_clear_screen
	.import		_clear_line
	.import		_display_blinking_message
	.import		_update_arrow
	.import		_draw_crewmate_menu
	.import		_resting_companion_text
	.import		_handle_selection_arrow
	.import		_update_ability_cooldown
	.import		_start_ability_cooldown
	.import		_reset_companion_ability_state
	.import		_fire_zarnella_lasers
	.import		_draw_zarnella_lasers
	.import		_affection_bonus
	.import		_get_picks_for_winner
	.import		_init_level
	.import		_on_level_complete
	.import		_briefing_lines
	.import		_show_typewriter
	.import		_typewriter_reset
	.import		_mission_begin_text
	.import		_mission_end_text
	.import		_show_romance_ending
	.import		_show_game_over_screen
	.export		_main

.segment	"RODATA"

S0009:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$54,$4F,$20,$53,$54,$41,$52,$54
	.byte	$20,$4D,$49,$53,$53,$49,$4F,$4E,$00
S0011:
	.byte	$59,$4F,$55,$20,$57,$49,$4E,$21,$20,$2D,$20,$50,$52,$45,$53,$53
	.byte	$20,$53,$54,$41,$52,$54,$00
S0015:
	.byte	$59,$4F,$55,$20,$4C,$4F,$53,$45,$20,$2D,$20,$50,$52,$45,$53,$53
	.byte	$20,$53,$54,$41,$52,$54,$00
S0013:
	.byte	$59,$4F,$55,$20,$57,$49,$4E,$3F,$20,$2D,$20,$50,$52,$45,$53,$53
	.byte	$20,$53,$54,$41,$52,$54,$00
S000F:
	.byte	$46,$4F,$52,$20,$54,$48,$45,$20,$46,$49,$4E,$41,$4C,$20,$42,$41
	.byte	$54,$54,$4C,$45,$00
S000D:
	.byte	$53,$45,$4C,$45,$43,$54,$20,$59,$4F,$55,$52,$20,$43,$52,$45,$57
	.byte	$4D,$41,$54,$45,$00
S0007	:=	S000D+0
S000B:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$54,$4F,$20,$43,$4F,$4E,$54,$49
	.byte	$4E,$55,$45,$00
S0005:
	.byte	$50,$52,$45,$53,$53,$20,$41,$20,$42,$55,$54,$54,$4F,$4E,$00
S0001:
	.byte	$4C,$4F,$56,$45,$20,$26,$20,$4C,$41,$53,$45,$52,$53,$00
S0003	:=	S0011+11

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
; pal_spr(palette);
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_spr
;
; set_vram_buffer();
;
	jsr     _set_vram_buffer
;
; ppu_on_all();
;
L00CE:	jsr     _ppu_on_all
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
	bne     L008D
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
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; typewriter_reset();
;
	jsr     _typewriter_reset
;
; game_state = STATE_BRIEFING;
;
	lda     #$01
	sta     _game_state
;
; else if (game_state == STATE_BRIEFING) {
;
	jmp     L0002
L008D:	lda     _game_state
	cmp     #$01
	jne     L0092
;
; if (!briefing_started) {
;
	lda     _briefing_started
	bne     L000C
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; briefing_started = 1;
;
	lda     #$01
	sta     _briefing_started
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; show_typewriter(briefing_lines, 8);
;
L000C:	lda     #<(_briefing_lines)
	ldx     #>(_briefing_lines)
	jsr     pushax
	lda     #$08
	jsr     _show_typewriter
;
; if (typewriter_ended) {
;
	lda     _typewriter_ended
	beq     L000D
;
; BLINK_MSG("PRESS A BUTTON", 9, 26);
;
	jsr     decsp4
	lda     #<(S0005)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0005)
	sta     (sp),y
	lda     #$0E
	ldy     #$01
	sta     (sp),y
	lda     #$09
	dey
	sta     (sp),y
	lda     #$1A
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A) && typewriter_ended == 1) {
;
L000D:	lda     _pad1
	and     #$80
	jeq     L0002
	lda     _pad1_old
	and     #$80
	jne     L0002
	lda     _typewriter_ended
	cmp     #$01
	jne     L0002
;
; typewriter_reset();
;
	jsr     _typewriter_reset
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; clear_line(26);
;
	lda     #$1A
	jsr     _clear_line
;
; WRITE("SELECT YOUR CREWMATE", 6, 4);
;
	jsr     decsp3
	lda     #<(S0007)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S0007)
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
; briefing_started = 0;
;
	sta     _briefing_started
;
; draw_crewmate_menu();
;
	jsr     _draw_crewmate_menu
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; previous_crewmate = 4;
;
	lda     #$04
	sta     _previous_crewmate
;
; game_state = STATE_SELECT_CREWMATE;
;
	lda     #$02
	sta     _game_state
;
; else if (game_state == STATE_SELECT_CREWMATE) {
;
	jmp     L0002
L0092:	lda     _game_state
	cmp     #$02
	jne     L009C
;
; unsigned char old_crewmate = selected_crewmate;
;
	lda     _selected_crewmate
	jsr     pusha
;
; if (current_level < 4) {
;
	lda     _current_level
	cmp     #$04
	bcs     L0093
;
; resting_companion_text();
;
	jsr     _resting_companion_text
;
; handle_selection_arrow(current_level >= 4);  // still need arrows!
;
L0093:	lda     _current_level
	cmp     #$04
	lda     #$00
	rol     a
	jsr     _handle_selection_arrow
;
; one_vram_buffer(' ', NTADR_A(6, 10 + old_crewmate * 6));
;
	lda     #$20
	jsr     pusha
	ldy     #$01
	ldx     #$00
	lda     (sp),y
	jsr     mulax6
	clc
	adc     #$0A
	bcc     L0016
	inx
L0016:	jsr     aslax4
	stx     tmp1
	asl     a
	rol     tmp1
	ora     #$06
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
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A) && (current_level >= 4 || selected_crewmate != previous_crewmate)) {
;
	lda     _pad1
	and     #$80
	beq     L0017
	lda     _pad1_old
	and     #$80
	bne     L0017
	lda     _current_level
	cmp     #$04
	bcs     L0098
	lda     _selected_crewmate
	cmp     _previous_crewmate
	beq     L0017
;
; ppu_off();
;
L0098:	jsr     _ppu_off
;
; one_vram_buffer(' ', NTADR_A(8, 11 + old_crewmate * 6));
;
	lda     #$20
	jsr     pusha
	ldy     #$01
	ldx     #$00
	lda     (sp),y
	jsr     mulax6
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
; clear_screen();
;
	jsr     _clear_screen
;
; if (selected_crewmate == 0) zarnella_picks++;
;
	lda     _selected_crewmate
	bne     L0099
	inc     _zarnella_picks
;
; else if (selected_crewmate == 1) luma_picks++;
;
	jmp     L009B
L0099:	lda     _selected_crewmate
	cmp     #$01
	bne     L009A
	inc     _luma_picks
;
; else if (selected_crewmate == 2) bubbles_picks++;
;
	jmp     L009B
L009A:	lda     _selected_crewmate
	cmp     #$02
	bne     L009B
	inc     _bubbles_picks
;
; previous_crewmate = selected_crewmate;
;
L009B:	lda     _selected_crewmate
	sta     _previous_crewmate
;
; game_state = STATE_SHMUP;
;
	lda     #$03
	sta     _game_state
;
; reset_companion_ability_state();
;
	jsr     _reset_companion_ability_state
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; }
;
L0017:	jsr     incsp1
;
; else if (game_state == STATE_SHMUP) {
;
	jmp     L0002
L009C:	lda     _game_state
	cmp     #$03
	jne     L00BB
;
; if (!shmup_screen_drawn) {
;
	lda     _shmup_screen_drawn
	bne     L009D
;
; typewriter_reset();
;
	jsr     _typewriter_reset
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
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
L009D:	lda     _shmup_started
	bne     L0026
;
; mission_begin_text(current_level);
;
	lda     _current_level
	jsr     _mission_begin_text
;
; if (typewriter_ended) {
;
	lda     _typewriter_ended
	beq     L0027
;
; BLINK_MSG("PRESS A TO START MISSION", 4, 24);
;
	jsr     decsp4
	lda     #<(S0009)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0009)
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
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A) && typewriter_ended == 1) {
;
L0027:	lda     _pad1
	and     #$80
	jeq     L0002
	lda     _pad1_old
	and     #$80
	jne     L0002
	lda     _typewriter_ended
	cmp     #$01
	jne     L0002
;
; typewriter_reset();
;
	jsr     _typewriter_reset
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; clear_line(6);
;
	lda     #$06
	jsr     _clear_line
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
	jmp     L00CE
;
; handle_shmup_input();
;
L0026:	jsr     _handle_shmup_input
;
; if (shmup_timer > 0) {
;
	lda     _shmup_timer
	ora     _shmup_timer+1
	beq     L0030
;
; shmup_timer--;
;
	lda     _shmup_timer
	bne     L002F
	dec     _shmup_timer+1
L002F:	dec     _shmup_timer
;
; if (shmup_timer == 0) {
;
	lda     _shmup_timer
	ora     _shmup_timer+1
	bne     L0030
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
L0030:	lda     _player_invincible
	beq     L0035
;
; if (invincibility_timer > 0) {
;
	lda     _invincibility_timer
	beq     L00A3
;
; invincibility_timer--;
;
	dec     _invincibility_timer
;
; } else {
;
	jmp     L0035
;
; player_invincible = 0;
;
L00A3:	sta     _player_invincible
;
; if (freeze_timer > 0) {
;
L0035:	lda     _freeze_timer
	ora     _freeze_timer+1
	beq     L003C
;
; freeze_timer--;
;
	lda     _freeze_timer
	bne     L0038
	dec     _freeze_timer+1
L0038:	dec     _freeze_timer
;
; if (freeze_timer == 0) {
;
	lda     _freeze_timer
	ora     _freeze_timer+1
	bne     L003C
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	sta     _i
L00A4:	lda     _i
	cmp     #$06
	bcs     L003C
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
	jmp     L00A4
;
; update_ability_cooldown();
;
L003C:	jsr     _update_ability_cooldown
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
	beq     L0040
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
L0040:	jsr     _draw_player
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
; if (current_level == 1) {
;
	lda     _current_level
	cmp     #$01
	bne     L00A5
;
; spawn_basic();
;
	jsr     _spawn_basic
;
; else if (current_level == 2) {
;
	jmp     L0047
L00A5:	lda     _current_level
	cmp     #$02
	bne     L00A6
;
; spawn_fast();
;
	jsr     _spawn_fast
;
; else if (current_level == 3) {
;
	jmp     L0047
L00A6:	lda     _current_level
	cmp     #$03
	bne     L00A7
;
; spawn_tough();
;
	jsr     _spawn_tough
;
; else if (current_level == 4 && !boss_active) {
;
	jmp     L0047
L00A7:	lda     _current_level
	cmp     #$04
	bne     L0047
	lda     _boss_active
	bne     L0047
;
; spawn_boss();
;
	jsr     _spawn_boss
;
; update_enemies();
;
L0047:	jsr     _update_enemies
;
; update_boss();
;
	jsr     _update_boss
;
; enemy_killed_check();
;
	jsr     _enemy_killed_check
;
; check_boss_hit();
;
	jsr     _check_boss_hit
;
; check_boss_bullet_hit();
;
	jsr     _check_boss_bullet_hit
;
; check_player_hit();
;
	jsr     _check_player_hit
;
; if ((pad1 & PAD_B) && !(pad1_old & PAD_B)) {
;
	lda     _pad1
	and     #$40
	beq     L00B7
	lda     _pad1_old
	and     #$40
	bne     L00B7
;
; if (selected_crewmate == 0 && ability_ready) { // Zarnella
;
	lda     _selected_crewmate
	bne     L00AF
	lda     _ability_ready
	beq     L00AF
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
L00AF:	lda     _selected_crewmate
	cmp     #$01
	bne     L00B2
	lda     _ability_ready
	beq     L00B2
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
L00B2:	lda     _selected_crewmate
	cmp     #$02
	bne     L00B7
	lda     _ability_ready
	beq     L00B7
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	lda     #$00
	sta     _i
L00B5:	lda     _i
	cmp     #$06
	bcs     L005C
;
; if (enemy_active[i]) {
;
	ldy     _i
	lda     _enemy_active,y
	beq     L00B6
;
; enemy_frozen[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _enemy_frozen,y
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L00B6:	inc     _i
	jmp     L00B5
;
; freeze_timer = 300;
;
L005C:	ldx     #$01
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
L00B7:	lda     _pad1
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
	jmp     L00CE
L00BB:	lda     _game_state
	cmp     #$04
	jne     L00C3
;
; if (!dialogue_shown) {
;
	lda     _dialogue_shown
	bne     L00BC
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
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
; mission_end_text(current_level - 1);
;
L00BC:	lda     _current_level
	sec
	sbc     #$01
	jsr     _mission_end_text
;
; if (typewriter_ended) {
;
	lda     _typewriter_ended
	beq     L006B
;
; BLINK_MSG("PRESS A TO CONTINUE", 7, 24);
;
	jsr     decsp4
	lda     #<(S000B)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S000B)
	sta     (sp),y
	lda     #$13
	ldy     #$01
	sta     (sp),y
	lda     #$07
	dey
	sta     (sp),y
	lda     #$18
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A) && typewriter_ended) {
;
L006B:	lda     _pad1
	and     #$80
	jeq     L0002
	lda     _pad1_old
	and     #$80
	jne     L0002
	lda     _typewriter_ended
	jeq     L0002
;
; ppu_off();
;
	jsr     _ppu_off
;
; clear_screen();
;
	jsr     _clear_screen
;
; clear_line(6);
;
	lda     #$06
	jsr     _clear_line
;
; clear_line(24);
;
	lda     #$18
	jsr     _clear_line
;
; selected_crewmate = (previous_crewmate == 0) ? 1 : 0;
;
	lda     _previous_crewmate
	bne     L00C0
	lda     #$01
	jmp     L00C1
L00C0:	lda     #$00
L00C1:	sta     _selected_crewmate
;
; if (selected_crewmate == previous_crewmate) selected_crewmate = 2;
;
	cmp     _previous_crewmate
	bne     L00C2
	lda     #$02
	sta     _selected_crewmate
;
; briefing_started = 0;
;
L00C2:	lda     #$00
	sta     _briefing_started
;
; dialogue_shown = 0;
;
	sta     _dialogue_shown
;
; typewriter_reset();
;
	jsr     _typewriter_reset
;
; if (current_level >= 5) {
;
	lda     _current_level
	cmp     #$05
	bcc     L0073
;
; previous_crewmate = selected_crewmate;
;
	lda     _selected_crewmate
	sta     _previous_crewmate
;
; game_state = STATE_ENDING;
;
	lda     #$05
;
; else {
;
	jmp     L0088
;
; WRITE("SELECT YOUR CREWMATE", 6, 4);
;
L0073:	jsr     decsp3
	lda     #<(S000D)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000D)
	sta     (sp),y
	lda     #$14
	ldy     #$00
	sta     (sp),y
	ldx     #$20
	lda     #$86
	jsr     _multi_vram_buffer_horz
;
; if (current_level == 4) {
;
	lda     _current_level
	cmp     #$04
	bne     L0075
;
; WRITE("FOR THE FINAL BATTLE", 6, 6);
;
	jsr     decsp3
	lda     #<(S000F)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(S000F)
	sta     (sp),y
	lda     #$14
	ldy     #$00
	sta     (sp),y
	ldx     #$20
	lda     #$C6
	jsr     _multi_vram_buffer_horz
;
; draw_crewmate_menu();
;
L0075:	jsr     _draw_crewmate_menu
;
; game_state = STATE_SELECT_CREWMATE;
;
	lda     #$02
L0088:	sta     _game_state
;
; else if (game_state == STATE_ENDING) {
;
	jmp     L00CE
L00C3:	lda     _game_state
	cmp     #$05
	jne     L00C7
;
; if (!ending_shown) {
;
	lda     _ending_shown
	bne     L0078
;
; total_romance_score = player_score + (get_picks_for_winner() * 50) + affection_bonus();
;
	lda     _player_score
	ldx     _player_score+1
	jsr     pushax
	jsr     _get_picks_for_winner
	jsr     pushax
	lda     #$32
	jsr     tosumula0
	jsr     tosaddax
	jsr     pushax
	jsr     _affection_bonus
	jsr     tosaddax
	sta     _total_romance_score
	stx     _total_romance_score+1
;
; ending_shown = 1;
;
	lda     #$01
	sta     _ending_shown
;
; boss_active = 0;
;
	lda     #$00
	sta     _boss_active
;
; show_romance_ending();
;
L0078:	jsr     _show_romance_ending
;
; if (typewriter_ended) {
;
	lda     _typewriter_ended
	beq     L007B
;
; if (total_romance_score > 3000) {
;
	lda     _total_romance_score
	cmp     #$B9
	lda     _total_romance_score+1
	sbc     #$0B
	bcc     L007A
;
; BLINK_MSG("YOU WIN! - PRESS START", 5, 26);
;
	jsr     decsp4
	lda     #<(S0011)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0011)
;
; else {
;
	jmp     L00D6
;
; BLINK_MSG("YOU WIN? - PRESS START", 5, 26);
;
L007A:	jsr     decsp4
	lda     #<(S0013)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0013)
L00D6:	sta     (sp),y
	lda     #$16
	ldy     #$01
	sta     (sp),y
	lda     #$05
	dey
	sta     (sp),y
	lda     #$1A
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
;
L007B:	lda     _pad1
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
; clear_line(6);
;
	lda     #$06
	jsr     _clear_line
;
; clear_line(24);
;
	lda     #$18
	jsr     _clear_line
;
; clear_line(26);
;
	lda     #$1A
	jsr     _clear_line
;
; typewriter_reset();
;
	jsr     _typewriter_reset
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
; ending_shown = 0;
;
	sta     _ending_shown
;
; else if (game_state == STATE_GAME_OVER) {
;
	jmp     L00CE
L00C7:	lda     _game_state
	cmp     #$06
	jne     L0002
;
; show_game_over_screen();
;
	jsr     _show_game_over_screen
;
; if (typewriter_ended) {
;
	lda     _typewriter_ended
	beq     L0082
;
; BLINK_MSG("YOU LOSE - PRESS START", 5, 26);
;
	jsr     decsp4
	lda     #<(S0015)
	ldy     #$02
	sta     (sp),y
	iny
	lda     #>(S0015)
	sta     (sp),y
	lda     #$16
	ldy     #$01
	sta     (sp),y
	lda     #$05
	dey
	sta     (sp),y
	lda     #$1A
	jsr     _display_blinking_message
;
; if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
;
L0082:	lda     _pad1
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
; clear_line(26);
;
	lda     #$1A
	jsr     _clear_line
;
; oam_clear();
;
	jsr     _oam_clear
;
; typewriter_reset();
;
	jsr     _typewriter_reset
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
; boss_active = 0;
;
	lda     #$00
	sta     _boss_active
;
; game_state = STATE_TITLE;
;
	sta     _game_state
;
; while (1){
;
	jmp     L00CE

.endproc

