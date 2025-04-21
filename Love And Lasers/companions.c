
#include "companions.h"
#include "globals.h"
#include "screens.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "enemies.h"
#include "hud.h"

void update_arrow(void) {
	int arrow_addr = NTADR_A(6, 10 + selected_crewmate * 6);
	one_vram_buffer('>', arrow_addr);
}

void draw_crewmate_menu(void) {
	WRITE("ZARNELLA", 11, 10);
	WRITE("LUMA-6", 12, 16);
	WRITE("MR. BUBBLES", 10, 22);
}

void resting_companion_text(void) {
	if (previous_crewmate == 0) {
		BLINK_MSG("OUT HUNTING SPACE WITCHES", 3, 12);
	}
		if (previous_crewmate == 1) {
		BLINK_MSG("RECHARGING TACTICAL CORE", 4, 18);
	}
		if (previous_crewmate == 2) {
		BLINK_MSG("BUBBLING IN THE DARK", 6, 24);
	}
}

void handle_selection_arrow(void) {
	// DOWN
	if ((pad1 & PAD_DOWN) && !(pad1_old & PAD_DOWN)) {
		do {
			selected_crewmate = (selected_crewmate + 1) % 3;
		} while (selected_crewmate == previous_crewmate && previous_crewmate != 255);
	}

	// UP
	if ((pad1 & PAD_UP) && !(pad1_old & PAD_UP)) {
		do {
			selected_crewmate = (selected_crewmate == 0) ? 2 : selected_crewmate - 1;
		} while (selected_crewmate == previous_crewmate && previous_crewmate != 255);
	}

}

void update_ability_cooldown(void) {
	if (!ability_ready) {
		if (ability_cooldown_timer > 0) {
			ability_cooldown_timer--;
		} else {
			ability_ready = 1;
		}
	}
}

void start_ability_cooldown(void) {
	ability_ready = 0;
	ability_cooldown_timer = get_current_cooldown_max();
}

void reset_companion_ability_state(void) {
	ability_ready = 1;
	ability_cooldown_timer = 0;
	player_invincible = 0;
	invincibility_timer = 0;
}

void fire_zarnella_lasers(void) {
	const signed char laser_dx[5] = {1, 2, 2, 2, 1};
	const signed char laser_dy[5] = {-1, -1, 0, 1, 1};

	for (i = 0; i < 5; ++i) {
		for (j = 0; j < MAX_ENEMIES; ++j) {
			if (enemy_active[j]) {
				signed char dx = enemy_x[j] - player_x;
				signed char dy = enemy_y[j] - player_y;

				if ((dx * laser_dy[i] - dy * laser_dx[i]) >= -4 &&
				    (dx * laser_dy[i] - dy * laser_dx[i]) <= 4 &&
				    dx >= 0 &&
				    enemy_y[j] >= PLAYFIELD_TOP && enemy_y[j] <= PLAYFIELD_BOTTOM) {

					enemy_active[j] = 0;
					enemy_frozen[j] = 0;
					player_score += 10;
				}
			}
		}
	}

	zarnella_laser_timer = 3; // show laser visuals for 3 frames
}

void draw_zarnella_lasers(void) {
	const signed char laser_dx[5] = {1, 2, 2, 2, 1};
	const signed char laser_dy[5] = {-1, -1, 0, 1, 1};

	unsigned char lx, ly;

	for (i = 0; i < 5; ++i) {
		for (j = 1; j < 32; ++j) { // extend far enough to hit edges
			lx = player_x + laser_dx[i] * j * 8;
			ly = player_y + laser_dy[i] * j * 8;

			// Stop drawing if we leave the screen/playfield
			if (lx >= 248 || ly < PLAYFIELD_TOP || ly > PLAYFIELD_BOTTOM) break;

			oam_meta_spr(lx, ly, special_bullet_sprite); // can be replaced with laser-specific sprite later
		}
	}
}