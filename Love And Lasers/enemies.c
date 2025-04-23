
#include "enemies.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "globals.h"

unsigned char enemy_x[MAX_ENEMIES];
unsigned char enemy_y[MAX_ENEMIES];
unsigned char enemy_active[MAX_ENEMIES];
unsigned char enemy_frozen[MAX_ENEMIES];

void spawn_basic(void) {
	if ((frame_count % 60) == 0) {
		for (i = 0; i < MAX_ENEMIES; ++i) {
			if (!enemy_active[i]) {
				enemy_active[i] = 1;
				enemy_type[i] = ENEMY_TYPE_BASIC;
				enemy_health[i] = 1;
				enemy_x[i] = 240;
				enemy_y[i] = PLAYFIELD_TOP + (rand8() % (PLAYFIELD_BOTTOM - PLAYFIELD_TOP));
				break;
			}
		}
	}
}

void spawn_fast(void) {
	if ((frame_count % 60) == 0) {
		for (i = 0; i < MAX_ENEMIES; ++i) {
			if (!enemy_active[i]) {
				enemy_active[i] = 1;
				enemy_type[i] = ENEMY_TYPE_FAST;
				enemy_health[i] = 1;
				enemy_x[i] = 240;
				enemy_y[i] = PLAYFIELD_TOP + (rand8() % (PLAYFIELD_BOTTOM - PLAYFIELD_TOP));
				break;
			}
		}
	}
}

void spawn_tough(void) {
	if ((frame_count % 60) == 0) {
		for (i = 0; i < MAX_ENEMIES; ++i) {
			if (!enemy_active[i]) {
				enemy_active[i] = 1;
				enemy_type[i] = ENEMY_TYPE_TOUGH;
				enemy_health[i] = 4;
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
					if (enemy_type[i] == ENEMY_TYPE_BASIC) {
					    enemy_x[i] -= 1;
					} else if (enemy_type[i] == ENEMY_TYPE_FAST) {
					    enemy_x[i] -= 2; // faster!
					} else if (enemy_type[i] == ENEMY_TYPE_TOUGH) {
					    enemy_x[i] -= 1; // tough but slow
					}
				}
			}
		}
	}

	// === Drawing (every frame) ===
	for (i = 0; i < MAX_ENEMIES; ++i) {
		if (enemy_active[i]) {
			if (enemy_type[i] == ENEMY_TYPE_BASIC) {					    
				oam_meta_spr(enemy_x[i], enemy_y[i], enemy_sprite_basic);
			} else if (enemy_type[i] == ENEMY_TYPE_FAST) {
			    oam_meta_spr(enemy_x[i], enemy_y[i], enemy_sprite_fast);
			} else if (enemy_type[i] == ENEMY_TYPE_TOUGH) {
			    oam_meta_spr(enemy_x[i], enemy_y[i], enemy_sprite_tough);
			}
		}
	}
}

void clear_all_enemies(void) {
	for (i = 0; i < MAX_ENEMIES; ++i) {
		enemy_active[i] = 0;
		enemy_frozen[i] = 0;
	}
}
