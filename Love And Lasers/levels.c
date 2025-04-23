
#include "levels.h"
#include "globals.h"
#include "enemies.h"
#include "bullets.h"
#include "screens.h"
#include "companions.h"

void init_level(unsigned char level) {
	current_level = level;

	clear_all_enemies();
	clear_all_bullets();
    clear_screen();

	shmup_timer = 5400; // 90 seconds (can change per level)
	player_health = MAX_HEALTH;
	if (current_level == 1) {
		player_score = 0;
		zarnella_picks = 0;
		luma_picks = 0;
		bubbles_picks = 0;
		total_romance_score = 0;
	}

	reset_companion_ability_state();
}

void update_level_logic(void) {
	// Later: switch on current_level to pick enemy patterns or behaviours
	// Right now: keep it simple, all handled in main's spawn/update
}

void on_level_complete(void) {
	game_state = STATE_DIALOGUE;
}

void on_player_death(void) {
	ppu_off();

	clear_all_bullets();
	clear_all_enemies();
	clear_line(1);  // HUD row (HP, SCORE, SPECIAL)
	clear_line(27); // TIMER row at the bottom
	clear_screen();

	shmup_screen_drawn = 0;
	shmup_started = 0;

    shmup_timer = 5400;
	player_health = MAX_HEALTH;
	player_score = 0;

	game_state = STATE_GAME_OVER;
	ppu_on_all();
}
