
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

void spawn_boss(void) {
    boss_active = 1;
    boss_health = 20;
    boss_x = 216;
    boss_y = 100;

    for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
        boss_bullet_active[i] = 0;
    }
}

void update_boss(void) {
	static char boss_direction = 1;

    if (!boss_active) return;

    // Draw the boss
    oam_meta_spr(boss_x, boss_y, boss_sprite);

	if (frame_count % 120 == 0) {
    	boss_attack_mode = (boss_attack_mode + 1) % 3;  // Cycle between 0, 1, 2
	}

	// Then in your shooting logic:
	if (boss_fire_timer > 0) {
    	boss_fire_timer--;
	} else {
    	// Time to fire!
	    if (boss_attack_mode == 0) {
    	    spawn_boss_bullet(boss_y + 16);
	    } else if (boss_attack_mode == 1) {
	        spawn_boss_bullet(boss_y + 8);
	        spawn_boss_bullet(boss_y + 32);
	    } else if (boss_attack_mode == 2) {
	        spawn_boss_bullet(boss_y);
	        spawn_boss_bullet(boss_y + 16);
        	spawn_boss_bullet(boss_y + 32);
    	}

    boss_fire_timer = 60;
	}

    // Move boss bullets
    for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
        if (boss_bullet_active[i]) {
            boss_bullet_x[i] -= 2;
            if (boss_bullet_x[i] <= 8) {
                boss_bullet_active[i] = 0;
            } else {
                oam_meta_spr(boss_bullet_x[i], boss_bullet_y[i], boss_bullet_sprite);
            }
        }
    }

	if (frame_count % 4 == 0) {  // Slow down movement speed
	    boss_y += boss_direction;
	    if (boss_y <= PLAYFIELD_TOP || boss_y >= PLAYFIELD_BOTTOM - 32) {  // Adjust based on boss height
	        boss_direction = -boss_direction;
	    }
	}
}

void spawn_boss_bullet(unsigned char y_position) {
    for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
        if (!boss_bullet_active[i]) {
            boss_bullet_active[i] = 1;
            boss_bullet_x[i] = boss_x;
            boss_bullet_y[i] = y_position;
            break;  // Only spawn one bullet at a time
        }
    }
}

