
#include "companions.h"
#include "globals.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "enemies.h"
#include "hud.h"

void update_arrow(void) {
	int arrow_addr = NTADR_A(8, 11 + selected_crewmate * 4);
	one_vram_buffer('>', arrow_addr);
}

void draw_crewmate_menu(void) {
	WRITE("ZARNELLA", 10, 11);
	WRITE("LUMA-6", 10, 15);
	WRITE("MR BUBBLES", 10, 19);
}

void crewmate_confirm_text(void) {
    if (selected_crewmate == 0) {
		WRITE("ZARNELLA: DON'T SLOW ME", 2, 12);
		WRITE("          DOWN, MEATBAG.", 2, 14);
    }
	else if (selected_crewmate == 1) {
		WRITE("LUMA-6: UPLOADING MISSION", 2, 12);
		WRITE("        PROTOCOLS.", 2, 14);
	}
    else {
		WRITE("MR BUBBLES: WUBBLE WUBBLE", 2, 12);
		WRITE("            WUBBLE WUBBLE!", 2, 14);
	}
}

void handle_selection_arrow(void) {
	// Move selection down
	if ((pad1 & PAD_DOWN) && !(pad1_old & PAD_DOWN)) {
		selected_crewmate++;
		if (selected_crewmate > 2) selected_crewmate = 0;
	}
	// Move selection up
	if ((pad1 & PAD_UP) && !(pad1_old & PAD_UP)) {
		if (selected_crewmate == 0) selected_crewmate = 2;
		else selected_crewmate--;
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