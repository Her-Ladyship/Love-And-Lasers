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
	.export		_game_state
	.export		_current_level
	.export		_i
	.export		_j
	.export		_briefing_step
	.export		_selected_crewmate
	.export		_shmup_screen_drawn
	.export		_shmup_started
	.export		_dialogue_shown
	.export		_ending_shown
	.export		_ability_ready
	.export		_hp_string
	.export		_frame_count
	.export		_ability_cooldown_timer
	.export		_pad1
	.export		_pad1_old
	.export		_player_invincible
	.export		_invincibility_timer
	.export		_zarnella_laser_timer
	.export		_player_x
	.export		_player_y
	.export		_player_health
	.export		_bullet_x
	.export		_bullet_y
	.export		_bullet_active
	.export		_bullets
	.export		_freeze_timer
	.export		_player_score
	.export		_score_string
	.export		_shmup_timer
	.export		_timer_string
	.export		_briefing_line
	.export		_briefing_started
	.export		_bullet_box
	.export		_enemy_box
	.export		_player_sprite
	.export		_bullet_sprite
	.export		_enemy_sprite
	.export		_special_bullet_sprite
	.export		_palette

.segment	"DATA"

_game_state:
	.byte	$00
_current_level:
	.byte	$01
_i:
	.byte	$00
_j:
	.byte	$00
_briefing_step:
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
_ability_ready:
	.byte	$01
_hp_string:
	.byte	$48,$50,$3A,$20,$33,$00
_frame_count:
	.byte	$00
_ability_cooldown_timer:
	.word	$0000
_player_invincible:
	.byte	$00
_invincibility_timer:
	.byte	$00
_zarnella_laser_timer:
	.byte	$00
_player_x:
	.byte	$20
_player_y:
	.byte	$78
_player_health:
	.byte	$03
_freeze_timer:
	.word	$0000
_player_score:
	.word	$0000
_score_string:
	.byte	$53,$43,$4F,$52,$45,$3A,$20,$30,$30,$30,$30,$30,$00
_shmup_timer:
	.word	$1518
_timer_string:
	.byte	$54,$49,$4D,$45,$52,$3A,$20,$39,$30,$00
_briefing_line:
	.byte	$00
_briefing_started:
	.byte	$00

.segment	"RODATA"

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
_enemy_sprite:
	.byte	$00
	.byte	$00
	.byte	$43
	.byte	$00
	.byte	$80
_special_bullet_sprite:
	.byte	$00
	.byte	$00
	.byte	$66
	.byte	$00
	.byte	$80
_palette:
	.byte	$0F
	.byte	$01
	.byte	$21
	.byte	$31
	.byte	$0F
	.byte	$17
	.byte	$27
	.byte	$37
	.byte	$0F
	.byte	$11
	.byte	$21
	.byte	$31
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00

.segment	"BSS"

_pad1:
	.res	1,$00
_pad1_old:
	.res	1,$00
_bullet_x:
	.res	3,$00
_bullet_y:
	.res	3,$00
_bullet_active:
	.res	3,$00
_bullets:
	.res	15,$00
_bullet_box:
	.res	4,$00
_enemy_box:
	.res	4,$00

