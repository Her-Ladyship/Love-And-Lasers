#include "lib/neslib.h"
#include "lib/nesdoug.h"

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
#define PRESS_A_LEN 14 // MIGHT BE HOLDOVER FROM OLD CODE

#define MAX_BULLETS 3
#define BULLET_RIGHT_LIMIT 252
#define MAX_ENEMIES 6
#define ENEMY_LEFT_LIMIT 8
#define MAX_HEALTH 3

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

const unsigned char palette[] = {
	0x0f, 0x01, 0x21, 0x31,  // Background (blues)
	0x0f, 0x17, 0x27, 0x37,  // Sprite palette 0 (red tones)
	0, 0, 0, 0,              // unused
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
unsigned char frame_count = 0;
unsigned char selected_crewmate = 0;
unsigned char shmup_screen_drawn = 0;
unsigned char shmup_started = 0;
unsigned char dialogue_shown = 0;
unsigned char ending_shown = 0;
unsigned char i = 0;
unsigned char j = 0;
char hp_string[] = "HP: 3";

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

struct Box bullet_box;
struct Box enemy_box;

const unsigned char player_sprite[] = {
	0, 0, 0x41, 0,  // Tile 0x41 ('A' in standard ASCII CHR)
	128
};

const unsigned char bullet_sprite[] = {
	0, 0, 0x42, 0,  // Use tile 0x42 ('B')
	128
};

const unsigned char enemy_sprite[] = {
    0, 0, 0x43, 0,  // Tile 0x43 ('C')
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
void update_bullets(void);
void draw_player(void);
void enemy_killed_check(void);
void check_player_hit(void);
void draw_hud(void);

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
				draw_player();
				draw_hud();

				spawn_bullets();
				update_bullets();

				spawn_enemies();
				update_enemies();

				enemy_killed_check();
				check_player_hit();

				// TEMP: transition to dialogue
				if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
					ppu_off();
					clear_screen();
					clear_all_bullets();
					clear_all_enemies();
					oam_clear();
					shmup_screen_drawn = 0;
					shmup_started = 0;
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
}

void clear_line(unsigned char y) {
	multi_vram_buffer_horz("                                ", 32, NTADR_A(0, y));
}

void clear_all_bullets(void) {
	for (i = 0; i < MAX_BULLETS; ++i) {
		bullet_active[i] = 0;
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
			if (frame_count % 2 == 0) { // Only move every other frame
				if (enemy_x[i] <= ENEMY_LEFT_LIMIT) {
					enemy_active[i] = 0;
				} else {
					enemy_x[i] -= 1;
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
			if (!bullet_active[i]) {
				bullet_active[i] = 1;
				bullet_x[i] = player_x + 8;
				bullet_y[i] = player_y;
				break;
			}
		}
	}
}

void update_bullets(void) {
	for (i = 0; i < MAX_BULLETS; ++i) {
		if (bullet_active[i]) {
			bullet_x[i] += 2;
			if (bullet_x[i] > BULLET_RIGHT_LIMIT) {
				bullet_active[i] = 0;
			} else {
				oam_meta_spr(bullet_x[i], bullet_y[i], bullet_sprite);
			}
		}
	}
}

void draw_player(void) {
	oam_clear();
	oam_meta_spr(player_x, player_y, player_sprite);
}

void enemy_killed_check(void) {
	for (i = 0; i < MAX_BULLETS; ++i) {
		if (bullet_active[i]) {
			// Build bullet hitbox
			bullet_box.x = bullet_x[i];
			bullet_box.y = bullet_y[i];
			bullet_box.width = 8;
			bullet_box.height = 8;

			for (j = 0; j < MAX_ENEMIES; ++j) {
				if (enemy_active[j]) {
					// Build enemy hitbox
					enemy_box.x = enemy_x[j];
					enemy_box.y = enemy_y[j];
					enemy_box.width = 8;
					enemy_box.height = 8;

					if (check_collision(&bullet_box, &enemy_box)) {
						// Boom!
						bullet_active[i] = 0;
						enemy_active[j] = 0;
						break; // Stop checking this bullet
					}
				}
			}
		}
	}
}

void check_player_hit(void) {
	struct Box player_box;
	player_box.x = player_x;
	player_box.y = player_y;
	player_box.width = 8;
	player_box.height = 8;

	for (i = 0; i < MAX_ENEMIES; ++i) {
		if (enemy_active[i]) {
			enemy_box.x = enemy_x[i];
			enemy_box.y = enemy_y[i];
			enemy_box.width = 8;
			enemy_box.height = 8;

			if (check_collision(&player_box, &enemy_box)) {
				enemy_active[i] = 0; // enemy dies on impact
				if (player_health > 0) player_health--;

				if (player_health == 0) {
					// PLAYER DEAD — maybe trigger game over
					ppu_off();
					clear_screen();
					clear_all_bullets();
					clear_all_enemies();
					oam_clear();
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
	WRITE(hp_string, 2, 1); // Draw near top-left corner
}