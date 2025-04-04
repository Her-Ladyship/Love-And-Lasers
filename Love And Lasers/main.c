#include "lib/neslib.h"
#include "lib/nesdoug.h"

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
#define PRESS_A_LEN 14 // MIGHT BE HOLDOVER FROM OLD CODE
#define WRITE(text, x, y) multi_vram_buffer_horz(text, sizeof(text)-1, NTADR_A(x, y))
#define BLINK_MSG(msg, x, y) display_blinking_message(msg, sizeof(msg)-1, x, y)

#pragma bss-name(push, "ZEROPAGE")

const unsigned char palette[] = {
	BLACK, DK_GY, LT_GY, WHITE,
	0,0,0,0,
	0,0,0,0,
	0,0,0,0
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
unsigned char dialogue_shown = 0;
unsigned char ending_shown = 0;
unsigned char i = 0;

unsigned char pad1, pad1_old;

void display_press_start(void);
void display_press_A(void);
void update_arrow(void);
void clear_screen(void);
void draw_crewmate_menu(void);
void display_blinking_message(const char* message, unsigned char len, unsigned char x, unsigned char y);

void main(void) {
	ppu_off();
	pal_bg(palette);
	set_vram_buffer();
	ppu_on_all();

	while (1){
		ppu_wait_nmi();
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
				WRITE("                                ", 0, 15);
				selected_crewmate = 0;
				draw_crewmate_menu();
				ppu_on_all();

				game_state = STATE_SELECT_CREWMATE;
			}
		}
		else if (game_state == STATE_SELECT_CREWMATE) {
			unsigned char old_crewmate = selected_crewmate;

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
		    // Wait for input to continue
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
				ppu_on_all();

				WRITE("SHMUP GOES HERE", 8, 10);
				if (selected_crewmate == 0) {
					WRITE("CREWMATE: ZARNELLA", 6, 14);
				}
				else if (selected_crewmate == 1) {
					WRITE("CREWMATE: LUMA-6", 7, 14);
				}
				else {
					WRITE("CREWMATE: MR BUBBLES", 5, 14);
				}
				shmup_screen_drawn = 1;
			}
			// Restart option
			if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
				ppu_off();
				clear_screen();
				shmup_screen_drawn = 0;
				game_state = STATE_DIALOGUE;
				ppu_on_all();
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
	frame_count++;
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
