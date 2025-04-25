
#include "bullets.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "globals.h"
#include "enemies.h"
#include "levels.h"

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
	for (i = 0; i < MAX_BULLETS; ++i) {
		if (i % 2 != (frame_count % 2)) continue;

		if (bullets[i].active) {
			for (j = 0; j < MAX_ENEMIES; ++j) {
				if (enemy_active[j] && enemy_x[j] <= 240) {
					unsigned char target_y = enemy_y[j];
					if (enemy_type[j] == ENEMY_TYPE_TOUGH) {
					    target_y += 8;  // Aim for the middle tile!
					}
					if ((bullets[i].x > enemy_x[j] ? bullets[i].x - enemy_x[j] : enemy_x[j] - bullets[i].x) < 6 &&
						(bullets[i].y > target_y ? bullets[i].y - target_y : target_y - bullets[i].y) < 6) {
						bullets[i].active = 0;
						if (enemy_health[j] > 1) {
						    enemy_health[j]--;
						} else {
					    enemy_active[j] = 0;
					    player_score += (enemy_type[j] == ENEMY_TYPE_TOUGH) ? 50 :
					                    (enemy_type[j] == ENEMY_TYPE_FAST) ? 20 : 10;
						}
						break;
					}
				}
			}
		}
	}
}

void check_boss_hit(void) {
    if (!boss_active) return;

    for (i = 0; i < MAX_BULLETS; ++i) {
        if (bullets[i].active) {
			if ((bullets[i].x >= boss_x) && (bullets[i].x <= boss_x + 6) &&
			    (bullets[i].y >= boss_y) && (bullets[i].y <= boss_y + 40)) {
                bullets[i].active = 0;
                if (boss_health > 1) {
                    boss_health--;
                } else {
                    ppu_off();
                    boss_active = 0;
                    player_score += 500;
					shmup_screen_drawn = 0;
					shmup_started = 0;
					init_level(current_level + 1);
					on_level_complete();
					ppu_on_all();
                }
                break;
            }
        }
    }
}

void check_boss_bullet_hit(void) {
    if (!boss_active) return;

    for (i = 0; i < MAX_BOSS_BULLETS; ++i) {
        if (boss_bullet_active[i]) {
            if ((player_x > boss_bullet_x[i] ? player_x - boss_bullet_x[i] : boss_bullet_x[i] - player_x) < 6 &&
                (player_y > boss_bullet_y[i] ? player_y - boss_bullet_y[i] : boss_bullet_y[i] - player_y) < 6) {

                boss_bullet_active[i] = 0;

                if (!player_invincible) {
                    if (player_health > 0) {
                        player_health--;
                    }
                }

                if (player_health == 0) {
                    on_player_death();
                }
                break;  // Only one bullet hit per frame
            }
        }
    }
}

