
#include "bullets.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "globals.h"
#include "enemies.h"

void spawn_bullets(void) {
	if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
		for (i = 0; i < MAX_BULLETS; ++i) {
			if (!bullets[i].active) {
				bullets[i].active = 1;
				bullets[i].x = player_x + 8;
				bullets[i].y = player_y;
				bullets[i].dx = 2;
				bullets[i].dy = 0;
				break;
			}
		}
	}
}

void update_regular_bullets(void) {
	for (i = 0; i < MAX_BULLETS; ++i) {
		if (bullets[i].active) {
			bullets[i].x += bullets[i].dx;
			bullets[i].y += bullets[i].dy;

			if (bullets[i].x > BULLET_RIGHT_LIMIT || bullets[i].y > 240) {
				bullets[i].active = 0;
			} else {
				oam_meta_spr(bullets[i].x, bullets[i].y, bullet_sprite);
			}
		}
	}
}

void clear_all_bullets(void) {
	for (i = 0; i < MAX_BULLETS; ++i) {
		bullets[i].active = 0;
	}
}

void enemy_killed_check(void) {
	// === Check bullets (staggered) ===
	for (i = 0; i < MAX_BULLETS; ++i) {
		if (i % 2 != (frame_count % 2)) continue; // skip this bullet this frame

		if (bullets[i].active) {
			for (j = 0; j < MAX_ENEMIES; ++j) {
				if (enemy_active[j] && enemy_x[j] <= 240) {
					if ((bullets[i].x > enemy_x[j] ? bullets[i].x - enemy_x[j] : enemy_x[j] - bullets[i].x) < 6 &&
						(bullets[i].y > enemy_y[j] ? bullets[i].y - enemy_y[j] : enemy_y[j] - bullets[i].y) < 6) {
						bullets[i].active = 0;
						enemy_active[j] = 0;
						enemy_frozen[j] = 0;
						player_score += 10;
						break;
					}
				}
			}
		}
	}
}