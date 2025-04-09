
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
			if ((player_x > enemy_x[i] ? player_x - enemy_x[i] : enemy_x[i] - player_x) < 6 &&
			    (player_y > enemy_y[i] ? player_y - enemy_y[i] : enemy_y[i] - player_y) < 6) {

				enemy_active[i] = 0; // enemy dies on impact

				if (!player_invincible) {
					if (player_health > 0) {
						player_health--;
					}
				}

				if (player_health == 0) {
					on_player_death();
				}
				break; // Only take 1 hit per frame

			}
		}
	}
}