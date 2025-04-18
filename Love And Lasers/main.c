#include "lib/neslib.h"
#include "lib/nesdoug.h"

#include "enemies.h"
#include "globals.h"
#include "bullets.h"
#include "hud.h"
#include "player.h"
#include "screens.h"
#include "companions.h"
#include "levels.h"
#include "dialogue.h"

void main(void) {
	ppu_off();
	pal_bg(palette);
	pal_spr(&palette[4]);
	set_vram_buffer();
	ppu_on_all();

	while (1){
		ppu_wait_nmi();
		frame_count++;
		pad1_old = pad1;
		pad1 = pad_poll(0);

		if (game_state == STATE_TITLE) {
			WRITE("LOVE & LASERS", 10, 12);
			BLINK_MSG("PRESS START", 11, 15);
			if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
				ppu_off();
				clear_screen();
				ppu_on_all();
				game_state = STATE_BRIEFING;
			}
		}
		else if (game_state == STATE_BRIEFING) {
			if (!briefing_started) {
				ppu_off();
				clear_screen();
				briefing_started = 1;
				ppu_on_all();
			}

			show_briefing_typewriter();

			if ((pad1 & PAD_A) && !(pad1_old & PAD_A) && is_briefing_done()) {
				ppu_off();
				clear_screen();
				WRITE("SELECT YOUR CREWMATE", 6, 4);
				clear_line(15);
				selected_crewmate = 0;
				briefing_step = 0;
				briefing_line = 0; // Reset if replayed later
				briefing_started = 0;
				draw_crewmate_menu();
				ppu_on_all();
				game_state = STATE_SELECT_CREWMATE;
			}
		}
		else if (game_state == STATE_SELECT_CREWMATE) {
			unsigned char old_crewmate = selected_crewmate;
			handle_selection_arrow();
			one_vram_buffer(' ', NTADR_A(8, 11 + old_crewmate * 4));
			update_arrow();
			if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
				ppu_off();
				one_vram_buffer(' ', NTADR_A(8, 11 + old_crewmate * 4));
				clear_screen();
				game_state = STATE_CREWMATE_CONFIRM;
				ppu_on_all();
			}
		}
		else if (game_state == STATE_CREWMATE_CONFIRM) {
			crewmate_confirm_text();
	    	if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
				ppu_off();
        		clear_screen();
				game_state = STATE_SHMUP;
				reset_companion_ability_state();
				ppu_on_all();
	    	}
		}
		else if (game_state == STATE_SHMUP) {
			if (!shmup_screen_drawn) {
				ppu_off();
				clear_screen();
				mission_begin_text();
				shmup_screen_drawn = 1;
				ppu_on_all();
			}
			// Pre-mission phase
			if (shmup_started == 0) {
				BLINK_MSG("PRESS A TO START MISSION", 4, 24);
				if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
					ppu_off();
					clear_screen();
					clear_line(24);
					shmup_started = 1;
					ppu_on_all();
				}
			}
			else {
				handle_shmup_input();

				if (shmup_timer > 0) {
					shmup_timer--;
					if (shmup_timer == 0) {
						ppu_off();
						shmup_screen_drawn = 0;
						shmup_started = 0;
						init_level(current_level + 1); // increase level
						on_level_complete(); // move to next game state
						ppu_on_all();
					}
				}

				if (player_invincible) {
					if (invincibility_timer > 0) {
						invincibility_timer--;
					} else {
						player_invincible = 0;
					}
				}

				if (freeze_timer > 0) {
					freeze_timer--;
					if (freeze_timer == 0) {
						for (i = 0; i < MAX_ENEMIES; ++i) {
							enemy_frozen[i] = 0; // unfreeze everyone
						}
					}
				}
				
				update_ability_cooldown();
				draw_ability_cooldown_bar();

				oam_clear();
				if (zarnella_laser_timer > 0) {
					draw_zarnella_lasers();
					zarnella_laser_timer--;
				}
				draw_player();
				draw_hud();

				spawn_bullets();
				update_regular_bullets();

				spawn_enemies();
				update_enemies();

				enemy_killed_check();
				check_player_hit();

				if ((pad1 & PAD_B) && !(pad1_old & PAD_B)) {
					if (selected_crewmate == 0 && ability_ready) { // Zarnella
						fire_zarnella_lasers();
						start_ability_cooldown();
					}
					if (selected_crewmate == 1 && ability_ready) { // Luma-6
						player_invincible = 1;
						invincibility_timer = 180;
						start_ability_cooldown();
					}
					if (selected_crewmate == 2 && ability_ready) { // Mr Bubbles
						for (i = 0; i < MAX_ENEMIES; ++i) {
							if (enemy_active[i]) {
								enemy_frozen[i] = 1;
							}
						}
						freeze_timer = 300;
						start_ability_cooldown();
					}
				}

				// TEMP: transition to dialogue
				if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
					ppu_off();
					shmup_screen_drawn = 0;
					shmup_started = 0;
					init_level(current_level + 1);
					on_level_complete();
					ppu_on_all();
				}
			}
		}
		else if (game_state == STATE_DIALOGUE) {
			if (!dialogue_shown) {
				ppu_off();
				clear_screen();
				WRITE("MISSION COMPLETE!", 7, 10);
				WRITE("GOOD JOB, CAPTAIN", 7, 12);
				WRITE("PRESS A TO CONTINUE", 6, 24);
				dialogue_shown = 1;
				ppu_on_all();
			}
			if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
				ppu_off();
				clear_screen();
				dialogue_shown = 0;
				game_state = STATE_ENDING;
				ppu_on_all();
			}
		}
		else if (game_state == STATE_ENDING) {
			if (!ending_shown) {
				ppu_off();
				clear_screen();
				WRITE("ENDING GOES HERE", 8, 10);
				WRITE("THANKS FOR PLAYING", 7, 12);
				WRITE("PRESS START TO RESTART", 5, 24);
				ending_shown = 1;
				ppu_on_all();
			}
			if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
				ppu_off();
				clear_screen();
				game_state = STATE_TITLE;
				ending_shown = 0;
				ppu_on_all();
			}
		}
		else if (game_state == STATE_GAME_OVER) {
			BLINK_MSG("GAME OVER", 12, 14);

			if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
				ppu_off();
				clear_screen();
				oam_clear();

				// Reset everything for a new game
				current_level = 1;
				init_level(1);

				game_state = STATE_TITLE;
				ppu_on_all();
			}
		}
	}
}