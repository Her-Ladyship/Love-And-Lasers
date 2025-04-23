
#include "player.h"
#include "globals.h"
#include "enemies.h"
#include "bullets.h"
#include "screens.h"
#include "levels.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"

void draw_player(void) {
	const unsigned char* sprite = player_sprite;
	static unsigned char temp_sprite[5];

	for (i = 0; i < 5; ++i) {
		temp_sprite[i] = player_sprite[i];
	}

	temp_sprite[3] = player_invincible ? 1 : 0;
	oam_meta_spr(player_x, player_y, temp_sprite);
}

void handle_shmup_input(void) {
	if (pad1 & PAD_LEFT && player_x > 8) player_x--;
	if (pad1 & PAD_RIGHT && player_x < 40) player_x++;
	if (pad1 & PAD_UP && player_y > PLAYFIELD_TOP) player_y--;
	if (pad1 & PAD_DOWN && player_y < PLAYFIELD_BOTTOM) player_y++;
}

void check_player_hit(void) {
	for (i = 0; i < MAX_ENEMIES; ++i) {
		if (enemy_active[i] && enemy_x[i] < 44) {
		    unsigned char hitbox_top = enemy_y[i];
    		unsigned char hitbox_bottom = enemy_y[i] + ((enemy_type[i] == ENEMY_TYPE_TOUGH) ? 24 : 8);

			if ((player_x > enemy_x[i] ? player_x - enemy_x[i] : enemy_x[i] - player_x) < 6 &&
			    (player_y >= hitbox_top && player_y <= hitbox_bottom)) {

			    enemy_active[i] = 0;
			    player_score += (enemy_type[i] == ENEMY_TYPE_TOUGH) ? 50 : (enemy_type[i] == ENEMY_TYPE_FAST) ? 20 : 10;

				if (!player_invincible) {
					if (player_health > 0) {
						player_health--;
					}
				}

				if (player_health == 0) {
					on_player_death();
				}
				break;
			}
		}
	}
}