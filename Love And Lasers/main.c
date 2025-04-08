#include "lib/neslib.h"
#include "lib/nesdoug.h"

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
#define PRESS_A_LEN 14 // MIGHT BE HOLDOVER FROM OLD CODE

#define MAX_BULLETS 3
#define MAX_SPECIAL_BULLETS 5
#define BULLET_RIGHT_LIMIT 252
#define MAX_ENEMIES 6
#define ENEMY_LEFT_LIMIT 8
#define MAX_HEALTH 3

#define ZARNELLA_COOLDOWN 300   // 5 sec
#define LUMA6_COOLDOWN 600   // 10 sec
#define BUBBLES_COOLDOWN 1200   // 20 sec

#define PLAYFIELD_TOP 48
#define PLAYFIELD_BOTTOM 192

#define WRITE(text, x, y) multi_vram_buffer_horz(text, sizeof(text)-1, NTADR_A(x, y))
#define BLINK_MSG(msg, x, y) display_blinking_message(msg, sizeof(msg)-1, x, y)

#pragma bss-name(push, "ZEROPAGE")

struct Box {
	unsigned char x;
	unsigned char y;
	unsigned char width;
	unsigned char height;
};

struct Bullet {
	unsigned char x;
	unsigned char y;
	signed char dx;
	signed char dy;
	unsigned char active;
};

const unsigned char palette[] = {
	0x0f, 0x01, 0x21, 0x31,  // Background (blues)
	0x0f, 0x17, 0x27, 0x37,  // Sprite palette 0 (default red)
	0x0f, 0x11, 0x21, 0x31,  // Sprite palette 1 (Luma-6 invincibility - cool blues)
	0, 0, 0, 0
};

enum GameState {
  STATE_TITLE,
  STATE_BRIEFING,
  STATE_SELECT_CREWMATE,
  STATE_CREWMATE_CONFIRM,
  STATE_SHMUP,
  STATE_DIALOGUE,
  STATE_ENDING
};

unsigned char game_state = STATE_TITLE;
unsigned char i = 0;
unsigned char j = 0;
char hp_string[] = "HP: 3";

unsigned char selected_crewmate = 0;
unsigned char shmup_screen_drawn = 0;
unsigned char shmup_started = 0;
unsigned char dialogue_shown = 0;
unsigned char ending_shown = 0;
unsigned char ability_ready = 1;

unsigned char frame_count = 0;
unsigned int ability_cooldown_timer = 0;

unsigned char player_invincible = 0;
unsigned char invincibility_timer = 0;

unsigned char pad1, pad1_old;

unsigned char player_x = 32;
unsigned char player_y = 120;
unsigned char player_health = MAX_HEALTH;

unsigned char bullet_x[MAX_BULLETS];
unsigned char bullet_y[MAX_BULLETS];
unsigned char bullet_active[MAX_BULLETS];

unsigned char enemy_x[MAX_ENEMIES];
unsigned char enemy_y[MAX_ENEMIES];
unsigned char enemy_active[MAX_ENEMIES];
unsigned char enemy_frozen[MAX_ENEMIES];
unsigned int freeze_timer = 0;

unsigned int player_score = 0;
char score_string[] = "SCORE: 00000";

unsigned int shmup_timer = 5400; // 90 seconds × 60 frames
char timer_string[] = "TIMER: 90";

struct Box bullet_box;
struct Box enemy_box;
struct Bullet bullets[MAX_BULLETS];
struct Bullet special_bullets[MAX_SPECIAL_BULLETS];

const unsigned char player_sprite[] = {
	0, 0, 0x41, 0,  // Tile 0x41 ('A' in standard ASCII CHR)
	128
};

const unsigned char bullet_sprite[] = {
	0, 0, 0x42, 0,  // Tile 0x42 ('B')
	128
};

const unsigned char enemy_sprite[] = {
    0, 0, 0x43, 0,  // Tile 0x43 ('C')
    128
};

const unsigned char special_bullet_sprite[] = {
	0, 0, 0x66, 0,  // Tile 0x66 ('f')
	128
};

void update_arrow(void);
void clear_screen(void);
void draw_crewmate_menu(void);
void display_blinking_message(const char* message, unsigned char len, unsigned char x, unsigned char y);
void clear_line(unsigned char y);
void clear_all_bullets(void);
void clear_all_enemies(void);
void spawn_enemies(void);
void update_enemies(void);
void handle_shmup_input(void);
void mission_begin_text(void);
void crewmate_confirm_text(void);
void handle_selection_arrow(void);
void spawn_bullets(void);
void update_regular_bullets(void);
void update_special_bullets(void);
void draw_player(void);
void enemy_killed_check(void);
void check_player_hit(void);
void draw_hud(void);
void fire_zarnella_spread(void);
void update_ability_cooldown(void);
void start_ability_cooldown(void);
unsigned int get_current_cooldown_max(void);
void draw_ability_cooldown_bar(void);
void reset_companion_ability_state(void);
void update_score_string(void);
void update_timer_string(void);

void main(void) {
	ppu_off();
	pal_bg(palette);     	// for background
	pal_spr(&palette[4]); 	// for sprite colours
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
				WRITE("BRIEFING GOES HERE", 7, 12);
				ppu_on_all();
				game_state = STATE_BRIEFING;
			}
		}
		else if (game_state == STATE_BRIEFING) {
			BLINK_MSG("PRESS A BUTTON", 9, 15);
			if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
				ppu_off();
				clear_screen();
				WRITE("SELECT YOUR CREWMATE", 6, 4);
				clear_line(15);
				selected_crewmate = 0;
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
						clear_screen();
						clear_all_bullets();
						clear_all_enemies();
						oam_clear();
						shmup_screen_drawn = 0;
						shmup_started = 0;
						player_health = MAX_HEALTH;
						shmup_timer = 5400;
						game_state = STATE_DIALOGUE;
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
				draw_player();
				draw_hud();

				spawn_bullets();
				update_regular_bullets();
				update_special_bullets();

				spawn_enemies();
				update_enemies();

				enemy_killed_check();
				check_player_hit();

				if ((pad1 & PAD_B) && !(pad1_old & PAD_B)) {
					if (selected_crewmate == 0 && ability_ready) { // Zarnella
						fire_zarnella_spread();
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
					clear_screen();
					clear_all_bullets();
					clear_all_enemies();
					oam_clear();
					shmup_screen_drawn = 0;
					shmup_started = 0;
					player_health = MAX_HEALTH;
					shmup_timer = 5400;
					game_state = STATE_DIALOGUE;
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
	}
}

void display_blinking_message(const char* message, unsigned char len, unsigned char x, unsigned char y) {
	if ((frame_count & 0x20) == 0) {
		multi_vram_buffer_horz(message, len, NTADR_A(x, y));
	} else {
		for (i = 0; i < len; ++i) {
			one_vram_buffer(' ', NTADR_A(x + i, y));
		}
	}
}

void update_arrow(void) {
	int arrow_addr = NTADR_A(8, 11 + selected_crewmate * 4);
	one_vram_buffer('>', arrow_addr);
}

void draw_crewmate_menu(void) {
	WRITE("ZARNELLA", 10, 11);
	WRITE("LUMA-6", 10, 15);
	WRITE("MR BUBBLES", 10, 19);
}

void clear_screen(void) {
	vram_adr(NTADR_A(0, 0));
	vram_fill(' ', 32 * 30);
	oam_clear();
}

void clear_line(unsigned char y) {
	multi_vram_buffer_horz("                                ", 32, NTADR_A(0, y));
}

void clear_all_bullets(void) {
	for (i = 0; i < MAX_BULLETS; ++i) {
		bullets[i].active = 0;
	}
}

void clear_all_enemies(void) {
    for (i = 0; i < MAX_ENEMIES; ++i) {
        enemy_active[i] = 0;
    }
}

void spawn_enemies(void) {
	if ((frame_count % 60) == 0) { // roughly once per second
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
	for (i = 0; i < MAX_ENEMIES; ++i) {
		if (enemy_active[i]) {
			if (frame_count % 2 == 0) {
				if (!enemy_frozen[i]) {
					if (enemy_x[i] <= ENEMY_LEFT_LIMIT) {
						enemy_active[i] = 0;
					} else {
						enemy_x[i] -= 1;
					}
				}
			}
			oam_meta_spr(enemy_x[i], enemy_y[i], enemy_sprite);
		}
	}
}

void handle_shmup_input(void) {
	if (pad1 & PAD_LEFT && player_x > 8) player_x--;
	if (pad1 & PAD_RIGHT && player_x < 40) player_x++;
	if (pad1 & PAD_UP && player_y > PLAYFIELD_TOP) player_y--;
	if (pad1 & PAD_DOWN && player_y < PLAYFIELD_BOTTOM) player_y++;
}

void mission_begin_text(void) {
	if (selected_crewmate == 0) {
		WRITE("ZARNELLA:", 11, 10);
		WRITE("IF YOU GET ME KILLED,", 5, 13);
		WRITE("I'LL HAUNT YOU PERSONALLY", 3, 15);
	}
	else if (selected_crewmate == 1) {
		WRITE("LUMA-6:", 12, 10);
		WRITE("TACTICAL SYSTEMS GREEN -", 4, 13);
		WRITE("LET'S MAKE THIS EFFICIENT", 3, 15);
	}
	else {
		WRITE("MR BUBBLES:", 11, 10);
		WRITE("BUBBLE MODE ENGAGED!", 6, 13);
	}
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

void update_special_bullets(void) {
	for (i = 0; i < MAX_SPECIAL_BULLETS; ++i) {
		if (special_bullets[i].active) {
			special_bullets[i].x += special_bullets[i].dx;
			special_bullets[i].y += special_bullets[i].dy;

		 if (special_bullets[i].x > BULLET_RIGHT_LIMIT || special_bullets[i].y > 240) {
				special_bullets[i].active = 0;
			} else {
				oam_meta_spr(special_bullets[i].x, special_bullets[i].y, special_bullet_sprite);
			}
		}
	}
}

void draw_player(void) {
	const unsigned char* sprite = player_sprite;
	static unsigned char temp_sprite[5];

	for (i = 0; i < 5; ++i) {
		temp_sprite[i] = player_sprite[i];
	}

	// Use palette 1 while invincible (or make it flicker)
	temp_sprite[3] = player_invincible ? 1 : 0;

	oam_meta_spr(player_x, player_y, temp_sprite);
}

void enemy_killed_check(void) {
	// === Check regular bullets (staggered) ===
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

	// === Check Zarnella's spread bullets (staggered) ===
	for (i = 0; i < MAX_SPECIAL_BULLETS; ++i) {
		if (i % 2 != (frame_count % 2)) continue; // stagger special bullets

		if (special_bullets[i].active) {
			for (j = 0; j < MAX_ENEMIES; ++j) {
				if (enemy_active[j] && enemy_x[j] <= 240) {
					if ((special_bullets[i].x > enemy_x[j] ? special_bullets[i].x - enemy_x[j] : enemy_x[j] - special_bullets[i].x) < 6 &&
    					(special_bullets[i].y > enemy_y[j] ? special_bullets[i].y - enemy_y[j] : enemy_y[j] - special_bullets[i].y) < 6) {
						special_bullets[i].active = 0;
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
					// PLAYER DEAD — maybe trigger game over
					ppu_off();
					clear_screen();
					clear_all_bullets();
					clear_all_enemies();
					oam_clear();
					player_health = MAX_HEALTH;
					game_state = STATE_DIALOGUE; // FOR NOW
					ppu_on_all();
				}

				break; // Only take 1 hit per frame
			}
		}
	}
}

void draw_hud(void) {
	hp_string[4] = '0' + player_health;
	WRITE(hp_string, 2, 1);
	update_score_string();
	WRITE(score_string, 10, 1);
	update_timer_string();
	WRITE(timer_string, 2, 27);
}

void fire_zarnella_spread(void) {
	const signed char spread_dx[5] = {1, 2, 2, 2, 1};
	const signed char spread_dy[5] = {-1, -1, 0, 1, 1};

	for (i = 0; i < 5; i++) {
		for (j = 0; j < MAX_SPECIAL_BULLETS; j++) {
			if (!special_bullets[j].active) {
				special_bullets[j].active = 1;
				special_bullets[j].x = player_x + 8;
				special_bullets[j].y = player_y;
				special_bullets[j].dx = spread_dx[i];
				special_bullets[j].dy = spread_dy[i];
				break;
			}
		}
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

unsigned int get_current_cooldown_max(void) {
	if (selected_crewmate == 0) return ZARNELLA_COOLDOWN;
	if (selected_crewmate == 1) return LUMA6_COOLDOWN;
	return BUBBLES_COOLDOWN;
}

void draw_ability_cooldown_bar(void) {
	unsigned char segments = 4;
	unsigned char fill = 0;
	unsigned int max = get_current_cooldown_max();
	char bar_string[] = "[    \\";

	if (ability_ready) {
		fill = segments;
	} else {
		fill = (segments * (max - ability_cooldown_timer)) / max;
	}

	for (i = 0; i < segments; ++i) {
		bar_string[1 + i] = (i < fill) ? '=' : ' ';
	}

	WRITE(bar_string, 25, 1);
}

void reset_companion_ability_state(void) {
	ability_ready = 1;
	ability_cooldown_timer = 0;
	player_invincible = 0;
	invincibility_timer = 0;
}

void update_score_string(void) {
	unsigned int temp_score = player_score;
	score_string[7] = '0' + (temp_score / 10000) % 10;
	score_string[8] = '0' + (temp_score / 1000) % 10;
	score_string[9] = '0' + (temp_score / 100) % 10;
	score_string[10] = '0' + (temp_score / 10) % 10;
	score_string[11] = '0' + temp_score % 10;
}

void update_timer_string(void) {
	unsigned int seconds = shmup_timer / 60;
	timer_string[7] = '0' + (seconds / 10) % 10;
	timer_string[8] = '0' + (seconds % 10);
}
