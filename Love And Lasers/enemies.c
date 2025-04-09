
#include "enemies.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "globals.h"

unsigned char enemy_x[MAX_ENEMIES];
unsigned char enemy_y[MAX_ENEMIES];
unsigned char enemy_active[MAX_ENEMIES];
unsigned char enemy_frozen[MAX_ENEMIES];

void spawn_enemies(void) {
	if ((frame_count % 60) == 0) {
		for (i = 0; i < MAX_ENEMIES; ++i) {
			if (!enemy_active[i]) {
				enemy_active[i] = 1;
				enemy_x[i] = 240;
				enemy_y[i] = PLAYFIELD_TOP + (rand8() % (PLAYFIELD_BOTTOM - PLAYFIELD_TOP));
				break;
			}
		}
	}
}

void update_enemies(void) {
	// === Movement ===
	if (frame_count % 2 == 0) {
		for (i = 0; i < MAX_ENEMIES; ++i) {
			if (enemy_active[i] && !enemy_frozen[i]) {
				if (enemy_x[i] <= ENEMY_LEFT_LIMIT) {
					enemy_active[i] = 0;
				} else {
					enemy_x[i] -= 1;
				}
			}
		}
	}

	// === Drawing (every frame) ===
	for (i = 0; i < MAX_ENEMIES; ++i) {
		if (enemy_active[i]) {
			oam_meta_spr(enemy_x[i], enemy_y[i], enemy_sprite);
		}
	}
}

void clear_all_enemies(void) {
	for (i = 0; i < MAX_ENEMIES; ++i) {
		enemy_active[i] = 0;
		enemy_frozen[i] = 0;
	}
}
