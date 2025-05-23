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
	.import		_oam_meta_spr
	.import		_rand8
	.export		_enemy_x
	.export		_enemy_y
	.export		_enemy_active
	.export		_enemy_frozen
	.export		_spawn_basic
	.export		_spawn_fast
	.export		_spawn_tough
	.export		_update_enemies
	.export		_clear_all_enemies
	.export		_spawn_boss
	.export		_update_boss
	.export		_spawn_boss_bullet
	.import		_i
	.import		_frame_count
	.import		_boss_active
	.import		_boss_health
	.import		_boss_x
	.import		_boss_y
	.import		_boss_attack_mode
	.import		_boss_fire_timer
	.import		_boss_bullet_x
	.import		_boss_bullet_y
	.import		_boss_bullet_active
	.import		_enemy_type
	.import		_enemy_health
	.import		_enemy_sprite_basic
	.import		_enemy_sprite_fast
	.import		_boss_bullet_sprite
	.import		_boss_sprite
	.import		_tough_debris_variants
	.import		_enemy_variant

.segment	"BSS"

_enemy_x:
	.res	6,$00
_enemy_y:
	.res	6,$00
_enemy_active:
	.res	6,$00
_enemy_frozen:
	.res	6,$00

; ---------------------------------------------------------------
; void __near__ spawn_basic (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_spawn_basic: near

.segment	"CODE"

;
; if ((frame_count % 60) == 0) {
;
	lda     _frame_count
	jsr     pusha0
	lda     #$3C
	jsr     tosumoda0
	cpx     #$00
	bne     L0005
	cmp     #$00
	bne     L0005
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	sta     _i
L0010:	lda     _i
	cmp     #$06
	bcs     L0005
;
; if (!enemy_active[i]) {
;
	ldy     _i
	lda     _enemy_active,y
	bne     L0011
;
; enemy_active[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _enemy_active,y
;
; enemy_type[i] = ENEMY_TYPE_BASIC;
;
	ldy     _i
	lda     #$00
	sta     _enemy_type,y
;
; enemy_health[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _enemy_health,y
;
; enemy_x[i] = 240;
;
	ldy     _i
	lda     #$F0
	sta     _enemy_x,y
;
; enemy_y[i] = PLAYFIELD_TOP + (rand8() % (PLAYFIELD_BOTTOM - PLAYFIELD_TOP));
;
	lda     #<(_enemy_y)
	ldx     #>(_enemy_y)
	clc
	adc     _i
	bcc     L000E
	inx
L000E:	jsr     pushax
	jsr     _rand8
	jsr     pushax
	lda     #$90
	jsr     tosumoda0
	clc
	adc     #$30
	ldy     #$00
	jmp     staspidx
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L0011:	inc     _i
	jmp     L0010
;
; }
;
L0005:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ spawn_fast (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_spawn_fast: near

.segment	"CODE"

;
; if ((frame_count % 60) == 0) {
;
	lda     _frame_count
	jsr     pusha0
	lda     #$3C
	jsr     tosumoda0
	cpx     #$00
	bne     L0005
	cmp     #$00
	bne     L0005
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	sta     _i
L0010:	lda     _i
	cmp     #$06
	bcs     L0005
;
; if (!enemy_active[i]) {
;
	ldy     _i
	lda     _enemy_active,y
	bne     L0011
;
; enemy_active[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _enemy_active,y
;
; enemy_type[i] = ENEMY_TYPE_FAST;
;
	ldy     _i
	sta     _enemy_type,y
;
; enemy_health[i] = 1;
;
	sta     _enemy_health,y
;
; enemy_x[i] = 240;
;
	ldy     _i
	lda     #$F0
	sta     _enemy_x,y
;
; enemy_y[i] = PLAYFIELD_TOP + (rand8() % (PLAYFIELD_BOTTOM - PLAYFIELD_TOP));
;
	lda     #<(_enemy_y)
	ldx     #>(_enemy_y)
	clc
	adc     _i
	bcc     L000E
	inx
L000E:	jsr     pushax
	jsr     _rand8
	jsr     pushax
	lda     #$90
	jsr     tosumoda0
	clc
	adc     #$30
	ldy     #$00
	jmp     staspidx
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L0011:	inc     _i
	jmp     L0010
;
; }
;
L0005:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ spawn_tough (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_spawn_tough: near

.segment	"CODE"

;
; if ((frame_count % 60) == 0) {
;
	lda     _frame_count
	jsr     pusha0
	lda     #$3C
	jsr     tosumoda0
	cpx     #$00
	bne     L0005
	cmp     #$00
	bne     L0005
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	sta     _i
L0011:	lda     _i
	cmp     #$06
	bcs     L0005
;
; if (!enemy_active[i]) {
;
	ldy     _i
	lda     _enemy_active,y
	bne     L0012
;
; enemy_active[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _enemy_active,y
;
; enemy_type[i] = ENEMY_TYPE_TOUGH;
;
	ldy     _i
	lda     #$02
	sta     _enemy_type,y
;
; enemy_health[i] = 4;
;
	ldy     _i
	lda     #$04
	sta     _enemy_health,y
;
; enemy_x[i] = 240;
;
	ldy     _i
	lda     #$F0
	sta     _enemy_x,y
;
; enemy_y[i] = PLAYFIELD_TOP + (rand8() % (PLAYFIELD_BOTTOM - PLAYFIELD_TOP));
;
	lda     #<(_enemy_y)
	ldx     #>(_enemy_y)
	clc
	adc     _i
	bcc     L000E
	inx
L000E:	jsr     pushax
	jsr     _rand8
	jsr     pushax
	lda     #$90
	jsr     tosumoda0
	clc
	adc     #$30
	ldy     #$00
	jsr     staspidx
;
; enemy_variant[i] = rand8() % 9;
;
	lda     #<(_enemy_variant)
	ldx     #>(_enemy_variant)
	clc
	adc     _i
	bcc     L0010
	inx
L0010:	jsr     pushax
	jsr     _rand8
	jsr     pushax
	lda     #$09
	jsr     tosumoda0
	ldy     #$00
	jmp     staspidx
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L0012:	inc     _i
	jmp     L0011
;
; }
;
L0005:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ update_enemies (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_update_enemies: near

.segment	"CODE"

;
; if (frame_count % 2 == 0) {
;
	lda     _frame_count
	and     #$01
	jne     L003B
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	sta     _i
L0036:	lda     _i
	cmp     #$06
	bcs     L003B
;
; if (enemy_active[i] && !enemy_frozen[i]) {
;
	ldy     _i
	lda     _enemy_active,y
	beq     L003A
	ldy     _i
	lda     _enemy_frozen,y
	bne     L003A
;
; if (enemy_x[i] <= ENEMY_LEFT_LIMIT) {
;
	ldy     _i
	lda     _enemy_x,y
	cmp     #$09
	bcs     L000E
;
; enemy_active[i] = 0;
;
	ldy     _i
	lda     #$00
	sta     _enemy_active,y
;
; } else {
;
	jmp     L003A
;
; if (enemy_type[i] == ENEMY_TYPE_BASIC) {
;
L000E:	ldy     _i
	lda     _enemy_type,y
;
; } else if (enemy_type[i] == ENEMY_TYPE_FAST) {
;
	beq     L0048
	ldy     _i
	lda     _enemy_type,y
	cmp     #$01
	bne     L0016
;
; enemy_x[i] -= 2; // faster!
;
	lda     #<(_enemy_x)
	ldx     #>(_enemy_x)
	clc
	adc     _i
	bcc     L0018
	inx
L0018:	sta     ptr1
	stx     ptr1+1
	ldy     #$00
	lda     (ptr1),y
	sec
	sbc     #$02
;
; } else if (enemy_type[i] == ENEMY_TYPE_TOUGH) {
;
	jmp     L0033
L0016:	ldy     _i
	lda     _enemy_type,y
	cmp     #$02
	bne     L003A
;
; enemy_x[i] -= 1; // tough but slow
;
L0048:	lda     #<(_enemy_x)
	ldx     #>(_enemy_x)
	clc
	adc     _i
	bcc     L001C
	inx
L001C:	sta     ptr1
	stx     ptr1+1
	ldy     #$00
	lda     (ptr1),y
	sec
	sbc     #$01
L0033:	sta     (ptr1),y
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L003A:	inc     _i
	jmp     L0036
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L003B:	lda     #$00
	sta     _i
L003C:	lda     _i
	cmp     #$06
	bcc     L0049
;
; }
;
	rts
;
; if (enemy_active[i]) {
;
L0049:	ldy     _i
	lda     _enemy_active,y
	jeq     L003D
;
; if (enemy_type[i] == ENEMY_TYPE_BASIC) {         
;
	ldy     _i
	lda     _enemy_type,y
	bne     L0023
;
; oam_meta_spr(enemy_x[i], enemy_y[i], enemy_sprite_basic);
;
	jsr     decsp2
	ldy     _i
	lda     _enemy_x,y
	ldy     #$01
	sta     (sp),y
	ldy     _i
	lda     _enemy_y,y
	ldy     #$00
	sta     (sp),y
	lda     #<(_enemy_sprite_basic)
	ldx     #>(_enemy_sprite_basic)
;
; } else if (enemy_type[i] == ENEMY_TYPE_FAST) {
;
	jmp     L0034
L0023:	ldy     _i
	lda     _enemy_type,y
	cmp     #$01
	bne     L0028
;
; oam_meta_spr(enemy_x[i], enemy_y[i], enemy_sprite_fast);
;
	jsr     decsp2
	ldy     _i
	lda     _enemy_x,y
	ldy     #$01
	sta     (sp),y
	ldy     _i
	lda     _enemy_y,y
	ldy     #$00
	sta     (sp),y
	lda     #<(_enemy_sprite_fast)
	ldx     #>(_enemy_sprite_fast)
;
; } else if (enemy_type[i] == ENEMY_TYPE_TOUGH) {
;
	jmp     L0034
L0028:	ldy     _i
	lda     _enemy_type,y
	cmp     #$02
	bne     L003D
;
; oam_meta_spr(enemy_x[i], enemy_y[i], tough_debris_variants[enemy_variant[i]]);
;
	jsr     decsp2
	ldy     _i
	lda     _enemy_x,y
	ldy     #$01
	sta     (sp),y
	ldy     _i
	lda     _enemy_y,y
	ldy     #$00
	sta     (sp),y
	ldy     _i
	ldx     #$00
	lda     _enemy_variant,y
	asl     a
	bcc     L0035
	inx
	clc
L0035:	adc     #<(_tough_debris_variants)
	sta     ptr1
	txa
	adc     #>(_tough_debris_variants)
	sta     ptr1+1
	ldy     #$01
	lda     (ptr1),y
	tax
	dey
	lda     (ptr1),y
L0034:	jsr     _oam_meta_spr
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
L003D:	inc     _i
	jmp     L003C

.endproc

; ---------------------------------------------------------------
; void __near__ clear_all_enemies (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_clear_all_enemies: near

.segment	"CODE"

;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	lda     #$00
	sta     _i
L0008:	lda     _i
	cmp     #$06
	bcs     L0003
;
; enemy_active[i] = 0;
;
	ldy     _i
	lda     #$00
	sta     _enemy_active,y
;
; enemy_frozen[i] = 0;
;
	ldy     _i
	sta     _enemy_frozen,y
;
; for (i = 0; i < MAX_ENEMIES; ++i) {
;
	inc     _i
	jmp     L0008
;
; }
;
L0003:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ spawn_boss (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_spawn_boss: near

.segment	"CODE"

;
; boss_active = 1;
;
	lda     #$01
	sta     _boss_active
;
; boss_health = 20;
;
	lda     #$14
	sta     _boss_health
;
; boss_x = 216;
;
	lda     #$D8
	sta     _boss_x
;
; boss_y = 100;
;
	lda     #$64
	sta     _boss_y
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
	lda     #$00
	sta     _i
L0007:	lda     _i
	cmp     #$0A
	bcs     L0003
;
; boss_bullet_active[i] = 0;
;
	ldy     _i
	lda     #$00
	sta     _boss_bullet_active,y
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
	inc     _i
	jmp     L0007
;
; }
;
L0003:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ update_boss (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_update_boss: near

.segment	"CODE"

;
; if (!boss_active) return;
;
	lda     _boss_active
	bne     L0032
;
; }
;
	rts
;
; oam_meta_spr(boss_x, boss_y, boss_sprite);
;
L0032:	jsr     decsp2
	lda     _boss_x
	ldy     #$01
	sta     (sp),y
	lda     _boss_y
	dey
	sta     (sp),y
	lda     #<(_boss_sprite)
	ldx     #>(_boss_sprite)
	jsr     _oam_meta_spr
;
; if (frame_count % 120 == 0) {
;
	lda     _frame_count
	jsr     pusha0
	lda     #$78
	jsr     tosumoda0
	cpx     #$00
	bne     L0003
	cmp     #$00
	bne     L0003
;
; boss_attack_mode = (boss_attack_mode + 1) % 3;  // Cycle between 0, 1, 2
;
	lda     _boss_attack_mode
	clc
	adc     #$01
	bcc     L0005
	inx
L0005:	jsr     pushax
	ldx     #$00
	lda     #$03
	jsr     tosmoda0
	sta     _boss_attack_mode
;
; if (boss_fire_timer > 0) {
;
L0003:	lda     _boss_fire_timer
	beq     L0025
;
; boss_fire_timer--;
;
	dec     _boss_fire_timer
;
; } else {
;
	jmp     L0029
;
; if (boss_attack_mode == 0) {
;
L0025:	lda     _boss_attack_mode
	bne     L0026
;
; spawn_boss_bullet(boss_y + 16);
;
	lda     _boss_y
	clc
	adc     #$10
;
; } else if (boss_attack_mode == 1) {
;
	jmp     L0024
L0026:	lda     _boss_attack_mode
	cmp     #$01
	bne     L0027
;
; spawn_boss_bullet(boss_y + 8);
;
	lda     _boss_y
	clc
	adc     #$08
;
; } else if (boss_attack_mode == 2) {
;
	jmp     L0031
L0027:	lda     _boss_attack_mode
	cmp     #$02
	bne     L0028
;
; spawn_boss_bullet(boss_y);
;
	lda     _boss_y
	jsr     _spawn_boss_bullet
;
; spawn_boss_bullet(boss_y + 16);
;
	lda     _boss_y
	clc
	adc     #$10
L0031:	jsr     _spawn_boss_bullet
;
; spawn_boss_bullet(boss_y + 32);
;
	lda     _boss_y
	clc
	adc     #$20
L0024:	jsr     _spawn_boss_bullet
;
; boss_fire_timer = 60;
;
L0028:	lda     #$3C
	sta     _boss_fire_timer
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
L0029:	lda     #$00
	sta     _i
L002A:	lda     _i
	cmp     #$0A
	bcs     L002C
;
; if (boss_bullet_active[i]) {
;
	ldy     _i
	lda     _boss_bullet_active,y
	beq     L002B
;
; boss_bullet_x[i] -= 2;
;
	lda     #<(_boss_bullet_x)
	ldx     #>(_boss_bullet_x)
	clc
	adc     _i
	bcc     L0018
	inx
L0018:	sta     ptr1
	stx     ptr1+1
	ldy     #$00
	lda     (ptr1),y
	sec
	sbc     #$02
	sta     (ptr1),y
;
; if (boss_bullet_x[i] <= 8) {
;
	ldy     _i
	lda     _boss_bullet_x,y
	cmp     #$09
	bcs     L0019
;
; boss_bullet_active[i] = 0;
;
	ldy     _i
	lda     #$00
	sta     _boss_bullet_active,y
;
; } else {
;
	jmp     L002B
;
; oam_meta_spr(boss_bullet_x[i], boss_bullet_y[i], boss_bullet_sprite);
;
L0019:	jsr     decsp2
	ldy     _i
	lda     _boss_bullet_x,y
	ldy     #$01
	sta     (sp),y
	ldy     _i
	lda     _boss_bullet_y,y
	ldy     #$00
	sta     (sp),y
	lda     #<(_boss_bullet_sprite)
	ldx     #>(_boss_bullet_sprite)
	jsr     _oam_meta_spr
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
L002B:	inc     _i
	jmp     L002A
;
; if (frame_count % 4 == 0) {  // Slow down movement speed
;
L002C:	lda     _frame_count
	and     #$03
	bne     L0021
;
; boss_y += boss_direction;
;
	lda     M0001
	clc
	adc     _boss_y
	sta     _boss_y
;
; if (boss_y <= PLAYFIELD_TOP || boss_y >= PLAYFIELD_BOTTOM - 32) {  // Adjust based on boss height
;
	cmp     #$31
	bcc     L002D
	lda     _boss_y
	cmp     #$A0
	bcs     L002D
	rts
;
; boss_direction = -boss_direction;
;
L002D:	lda     M0001
	eor     #$FF
	clc
	adc     #$01
	sta     M0001
;
; }
;
L0021:	rts

.segment	"DATA"

M0001:
	.byte	$01

.endproc

; ---------------------------------------------------------------
; void __near__ spawn_boss_bullet (unsigned char y_position)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_spawn_boss_bullet: near

.segment	"CODE"

;
; void spawn_boss_bullet(unsigned char y_position) {
;
	jsr     pusha
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
	lda     #$00
	sta     _i
L000B:	lda     _i
	cmp     #$0A
	bcs     L0003
;
; if (!boss_bullet_active[i]) {
;
	ldy     _i
	lda     _boss_bullet_active,y
	bne     L000C
;
; boss_bullet_active[i] = 1;
;
	ldy     _i
	lda     #$01
	sta     _boss_bullet_active,y
;
; boss_bullet_x[i] = boss_x;
;
	ldy     _i
	lda     _boss_x
	sta     _boss_bullet_x,y
;
; boss_bullet_y[i] = y_position;
;
	ldy     #$00
	lda     (sp),y
	ldy     _i
	sta     _boss_bullet_y,y
;
; break;  // Only spawn one bullet at a time
;
	jmp     incsp1
;
; for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
;
L000C:	inc     _i
	jmp     L000B
;
; }
;
L0003:	jmp     incsp1

.endproc

