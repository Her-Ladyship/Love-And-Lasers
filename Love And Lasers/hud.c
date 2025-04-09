
#include "hud.h"
#include "globals.h"
#include "lib/neslib.h"

void draw_hud(void) {
	hp_string[4] = '0' + player_health;
	WRITE(hp_string, 2, 1);
	update_score_string();
	WRITE(score_string, 10, 1);
	update_timer_string();
	WRITE(timer_string, 2, 27);
}

void update_score_string(void) {
	unsigned int temp_score = player_score;
	score_string[7] = '0' + (temp_score / 10000) % 10;
	score_string[8] = '0' + (temp_score / 1000) % 10;
	score_string[9] = '0' + (temp_score / 100) % 10;
	score_string[10] = '0' + (temp_score / 10) % 10;
	score_string[11] = '0' + temp_score % 10;
}

void update_timer_string(void) {
	unsigned int seconds = shmup_timer / 60;
	timer_string[7] = '0' + (seconds / 10) % 10;
	timer_string[8] = '0' + (seconds % 10);
}

void draw_ability_cooldown_bar(void) {
	unsigned char segments = 4;
	unsigned char fill = 0;
	unsigned int max = get_current_cooldown_max();
	char bar_string[] = "[    \\";

	if (ability_ready) {
		fill = segments;
	} else {
		fill = (segments * (max - ability_cooldown_timer)) / max;
	}

	for (i = 0; i < segments; ++i) {
		bar_string[1 + i] = (i < fill) ? '=' : ' ';
	}

	WRITE(bar_string, 25, 1);
}

unsigned int get_current_cooldown_max(void) {
	if (selected_crewmate == 0) return ZARNELLA_COOLDOWN;
	if (selected_crewmate == 1) return LUMA6_COOLDOWN;
	return BUBBLES_COOLDOWN;
}