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
	.export		_spawn_bullets
	.export		_update_regular_bullets
	.export		_clear_all_bullets
	.export		_enemy_killed_check
	.export		_check_boss_hit
	.export		_check_boss_bullet_hit
	.import		_ppu_off
	.import		_ppu_on_all
	.import		_oam_meta_spr
	.import		_current_level
	.import		_i
	.import		_j
	.import		_shmup_screen_drawn
	.import		_shmup_started
	.import		_frame_count
	.import		_pad1
	.import		_pad1_old
	.import		_player_invincible
	.import		_player_x
	.import		_player_y
	.import		_player_health
	.import		_bullets
	.import		_boss_active
	.import		_boss_health
	.import		_boss_x
	.import		_boss_y
	.import		_boss_bullet_x
	.import		_boss_bullet_y
	.import		_boss_bullet_active
	.import		_player_score
	.import		_enemy_type
	.import		_enemy_health
	.import		_bullet_sprite
	.import		_enemy_x
	.import		_enemy_y
	.import		_enemy_active
	.import		_init_level
	.import		_on_level_complete
	.import		_on_player_death

; ---------------------------------------------------------------
; void __near__ spawn_bullets (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_spawn_bullets: near

.segment	"CODE"

;
; if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
;
	lda     _pad1
	and     #$80
	beq     L000D
	lda     _pad1_old
	and     #$80
	beq     L0010
L000D:	rts
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L0010:	sta     _i
L000F:	lda     _i
	cmp     #$03
	bcc     L0011
;
; }
;
	rts
;
; if (!bullets[i].active) {
;
L0011:	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$04
	lda     (ptr1),y
	bne     L0008
;
; bullets[i].active = 1;
;
	tax
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     #$01
	sta     (ptr1),y
;
; bullets[i].x = player_x + 8;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     _player_x
	clc
	adc     #$08
	ldy     #$00
	sta     (ptr1),y
;
; bullets[i].y = player_y;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     _player_y
	iny
	sta     (ptr1),y
;
; bullets[i].dx = 2;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     #$02
	iny
	sta     (ptr1),y
;
; bullets[i].dy = 0;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     #$00
	iny
	sta     (ptr1),y
;
; break;
;
	rts
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L0008:	inc     _i
	jmp     L000F

.endproc

; ---------------------------------------------------------------
; void __near__ update_regular_bullets (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_update_regular_bullets: near

.segment	"CODE"

;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
	lda     #$00
	sta     _i
L000D:	lda     _i
	cmp     #$03
	bcc     L0010
;
; }
;
	rts
;
; if (bullets[i].active) {
;
L0010:	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$04
	lda     (ptr1),y
	jeq     L000F
;
; bullets[i].x += bullets[i].dx;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	tay
	txa
	adc     #>(_bullets)
	tax
	tya
	sta     ptr2
	stx     ptr2+1
	sta     ptr1
	stx     ptr1+1
	ldy     #$00
	lda     (ptr1),y
	sta     sreg
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	tay
	txa
	adc     #>(_bullets)
	tax
	tya
	ldy     #$02
	jsr     ldaidx
	clc
	adc     sreg
	ldy     #$00
	sta     (ptr2),y
;
; bullets[i].y += bullets[i].dy;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	tay
	txa
	adc     #>(_bullets)
	tax
	tya
	sta     ptr2
	stx     ptr2+1
	sta     ptr1
	stx     ptr1+1
	ldy     #$01
	lda     (ptr1),y
	sta     sreg
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	tay
	txa
	adc     #>(_bullets)
	tax
	tya
	ldy     #$03
	jsr     ldaidx
	clc
	adc     sreg
	ldy     #$01
	sta     (ptr2),y
;
; if (bullets[i].x > BULLET_RIGHT_LIMIT || bullets[i].y > 240) {
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	sta     ptr1
	txa
	clc
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #<(_bullets)
	lda     (ptr1),y
	cmp     #$FD
	bcs     L000E
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$01
	lda     (ptr1),y
	cmp     #$F1
	bcc     L0007
;
; bullets[i].active = 0;
;
L000E:	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     #$00
	ldy     #$04
	sta     (ptr1),y
;
; } else {
;
	jmp     L000F
;
; oam_meta_spr(bullets[i].x, bullets[i].y, bullet_sprite);
;
L0007:	jsr     decsp2
	ldx     #$00
	lda     _i
	jsr     mulax5
	sta     ptr1
	txa
	clc
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #<(_bullets)
	lda     (ptr1),y
	ldy     #$01
	sta     (sp),y
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     (ptr1),y
	dey
	sta     (sp),y
	lda     #<(_bullet_sprite)
	ldx     #>(_bullet_sprite)
	jsr     _oam_meta_spr
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L000F:	inc     _i
	jmp     L000D

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
L0006:	lda     _i
	cmp     #$03
	bcs     L0003
;
; bullets[i].active = 0;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     #$00
	ldy     #$04
	sta     (ptr1),y
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
	inc     _i
	jmp     L0006
;
; }
;
L0003:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ enemy_killed_check (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_enemy_killed_check: near

.segment	"CODE"

;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
	lda     #$00
	sta     _i
L002F:	lda     _i
	cmp     #$03
	bcc     L003D
;
; }
;
	rts
;
; if (i % 2 != (frame_count % 2)) continue;
;
L003D:	and     #$01
	sta     ptr1
	lda     _frame_count
	and     #$01
	cmp     ptr1
	jne     L003C
;
; if (bullets[i].active) {
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$04
	lda     (ptr1),y
	jeq     L003C
;
; for (j = 0; j < MAX_ENEMIES; ++j) {
;
	lda     #$00
	sta     _j
L0030:	lda     _j
	cmp     #$06
	jcs     L003C
;
; if (enemy_active[j] && enemy_x[j] <= 240) {
;
	ldy     _j
	lda     _enemy_active,y
	jeq     L003B
	ldy     _j
	lda     _enemy_x,y
	cmp     #$F1
	jcs     L003B
;
; unsigned char target_y = enemy_y[j];
;
	ldy     _j
	lda     _enemy_y,y
	jsr     pusha
;
; if (enemy_type[j] == ENEMY_TYPE_TOUGH) {
;
	ldy     _j
	ldx     #$00
	lda     _enemy_type,y
	cmp     #$02
	bne     L0034
;
; target_y += 8;  // Aim for the middle tile!
;
	ldy     #$00
	clc
	lda     #$08
	adc     (sp),y
	sta     (sp),y
;
; if ((bullets[i].x > enemy_x[j] ? bullets[i].x - enemy_x[j] : enemy_x[j] - bullets[i].x) < 6 &&
;
L0034:	lda     _i
	jsr     mulax5
	sta     ptr1
	txa
	clc
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #<(_bullets)
	lda     (ptr1),y
	ldy     _j
	cmp     _enemy_x,y
	bcc     L0017
	beq     L0017
	ldx     #$00
	lda     _i
	jsr     mulax5
	sta     ptr1
	txa
	clc
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #<(_bullets)
	lda     (ptr1),y
	sec
	ldy     _j
	sbc     _enemy_x,y
	ldx     #$00
	bcs     L0019
	dex
	jmp     L0019
L0017:	ldy     _j
	lda     _enemy_x,y
	jsr     pusha0
	lda     _i
	jsr     mulax5
	sta     ptr1
	txa
	clc
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #<(_bullets)
	lda     (ptr1),y
	jsr     tossuba0
L0019:	cmp     #$06
	txa
	sbc     #$00
	bvc     L001B
	eor     #$80
L001B:	jpl     L0015
;
; (bullets[i].y > target_y ? bullets[i].y - target_y : target_y - bullets[i].y) < 6) {
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$01
	ldx     #$00
	lda     (ptr1),y
	dey
	cmp     (sp),y
	bcc     L0036
	beq     L0036
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	iny
	lda     (ptr1),y
	sec
	dey
	sbc     (sp),y
	ldx     #$00
	bcs     L001E
	dex
	jmp     L001E
L0036:	lda     (sp),y
	jsr     pusha0
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$01
	lda     (ptr1),y
	jsr     tossuba0
L001E:	cmp     #$06
	txa
	sbc     #$00
	bvc     L001F
	eor     #$80
L001F:	jpl     L0015
;
; bullets[i].active = 0;
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     #$00
	ldy     #$04
	sta     (ptr1),y
;
; if (enemy_health[j] > 1) {
;
	ldy     _j
	lda     _enemy_health,y
	cmp     #$02
	bcc     L0022
;
; enemy_health[j]--;
;
	lda     #<(_enemy_health)
	ldx     #>(_enemy_health)
	clc
	adc     _j
	bcc     L0024
	inx
L0024:	sta     sreg
	stx     sreg+1
	sta     ptr1
	stx     ptr1+1
	ldy     #$00
	lda     (ptr1),y
	sec
	sbc     #$01
	sta     (sreg),y
;
; } else {
;
	jmp     L0025
;
; enemy_active[j] = 0;
;
L0022:	ldy     _j
	lda     #$00
	sta     _enemy_active,y
;
; player_score += (enemy_type[j] == ENEMY_TYPE_TOUGH) ? 50 :
;
	ldy     _j
	lda     _enemy_type,y
	cmp     #$02
	bne     L0028
	lda     #$32
	jmp     L002C
;
; (enemy_type[j] == ENEMY_TYPE_FAST) ? 20 : 10;
;
L0028:	ldy     _j
	lda     _enemy_type,y
	cmp     #$01
	bne     L003A
	lda     #$14
	jmp     L002C
L003A:	lda     #$0A
L002C:	clc
	adc     _player_score
	sta     _player_score
	lda     #$00
	adc     _player_score+1
	sta     _player_score+1
;
; break;
;
L0025:	jsr     incsp1
	jmp     L003C
;
; }
;
L0015:	jsr     incsp1
;
; for (j = 0; j < MAX_ENEMIES; ++j) {
;
L003B:	inc     _j
	jmp     L0030
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L003C:	inc     _i
	jmp     L002F

.endproc

; ---------------------------------------------------------------
; void __near__ check_boss_hit (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_check_boss_hit: near

.segment	"CODE"

;
; if (!boss_active) return;
;
	lda     _boss_active
	bne     L0015
;
; }
;
	rts
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L0015:	lda     #$00
	sta     _i
L0012:	lda     _i
	cmp     #$03
	bcc     L0016
;
; }
;
	rts
;
; if (bullets[i].active) {
;
L0016:	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$04
	lda     (ptr1),y
	jeq     L0014
;
; if ((bullets[i].x >= boss_x) && (bullets[i].x <= boss_x + 6) &&
;
	ldx     #$00
	lda     _i
	jsr     mulax5
	sta     ptr1
	txa
	clc
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #<(_bullets)
	lda     (ptr1),y
	cmp     _boss_x
	jcc     L0014
	ldx     #$00
	lda     _i
	jsr     mulax5
	sta     ptr1
	txa
	clc
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #<(_bullets)
	lda     (ptr1),y
	jsr     pusha0
	lda     _boss_x
	clc
	adc     #$06
	bcc     L000A
	ldx     #$01
L000A:	jsr     tosicmp
	beq     L0011
	jpl     L0014
;
; (bullets[i].y >= boss_y) && (bullets[i].y <= boss_y + 40)) {
;
L0011:	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	ldy     #$01
	lda     (ptr1),y
	cmp     _boss_y
	bcc     L0014
	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     (ptr1),y
	jsr     pusha0
	lda     _boss_y
	clc
	adc     #$28
	bcc     L000B
	ldx     #$01
L000B:	jsr     tosicmp
	bmi     L000C
	bne     L0014
;
; bullets[i].active = 0;
;
L000C:	ldx     #$00
	lda     _i
	jsr     mulax5
	clc
	adc     #<(_bullets)
	sta     ptr1
	txa
	adc     #>(_bullets)
	sta     ptr1+1
	lda     #$00
	ldy     #$04
	sta     (ptr1),y
;
; if (boss_health > 1) {
;
	lda     _boss_health
	cmp     #$02
	bcc     L000E
;
; boss_health--;
;
	dec     _boss_health
;
; } else {
;
	rts
;
; ppu_off();
;
L000E:	jsr     _ppu_off
;
; boss_active = 0;
;
	lda     #$00
	sta     _boss_active
;
; player_score += 500;
;
	lda     #$F4
	clc
	adc     _player_score
	sta     _player_score
	lda     #$01
	adc     _player_score+1
	sta     _player_score+1
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
; ppu_on_all();
;
	jmp     _ppu_on_all
;
; for (i = 0; i < MAX_BULLETS; ++i) {
;
L0014:	inc     _i
	jmp     L0012

.endproc

; ---------------------------------------------------------------
; void __near__ check_boss_bullet_hit (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_check_boss_bullet_hit: near

.segment	"CODE"

;
; if (!boss_active) return;
;
	lda     _boss_active
	bne     L002B
;
; }
;
	rts
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
L002B:	lda     #$00
	sta     _i
L0021:	lda     _i
	cmp     #$0A
	bcc     L002C
;
; }
;
	rts
;
; if (boss_bullet_active[i]) {
;
L002C:	ldy     _i
	lda     _boss_bullet_active,y
	jeq     L0026
;
; if ((player_x > boss_bullet_x[i] ? player_x - boss_bullet_x[i] : boss_bullet_x[i] - player_x) < 6 &&
;
	lda     _player_x
	ldy     _i
	cmp     _boss_bullet_x,y
	bcc     L000B
	beq     L000B
	lda     _player_x
	sec
	ldy     _i
	sbc     _boss_bullet_x,y
	jmp     L0029
L000B:	ldy     _i
	lda     _boss_bullet_x,y
	sec
	sbc     _player_x
L0029:	ldx     #$00
	bcs     L000D
	dex
L000D:	cmp     #$06
	txa
	sbc     #$00
	bvc     L000F
	eor     #$80
L000F:	bpl     L0026
;
; (player_y > boss_bullet_y[i] ? player_y - boss_bullet_y[i] : boss_bullet_y[i] - player_y) < 6) {
;
	lda     _player_y
	ldy     _i
	cmp     _boss_bullet_y,y
	bcc     L0012
	beq     L0012
	lda     _player_y
	sec
	ldy     _i
	sbc     _boss_bullet_y,y
	jmp     L002A
L0012:	ldy     _i
	lda     _boss_bullet_y,y
	sec
	sbc     _player_y
L002A:	ldx     #$00
	bcs     L0014
	dex
L0014:	cmp     #$06
	txa
	sbc     #$00
	bvc     L0016
	eor     #$80
L0016:	bpl     L0026
;
; boss_bullet_active[i] = 0;
;
	ldy     _i
	lda     #$00
	sta     _boss_bullet_active,y
;
; if (!player_invincible) {
;
	lda     _player_invincible
	bne     L0025
;
; if (player_health > 0) {
;
	lda     _player_health
	beq     L0025
;
; player_health--;
;
	dec     _player_health
;
; if (player_health == 0) {
;
L0025:	lda     _player_health
	bne     L0004
;
; on_player_death();
;
	jmp     _on_player_death
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
L0026:	inc     _i
	jmp     L0021
;
; }
;
L0004:	rts

.endproc

