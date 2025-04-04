#include "lib/neslib.h"
#include "lib/nesdoug.h"

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
#define PRESS_A_LEN 14

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
  STATE_SHMUP,
  STATE_DIALOGUE,
  STATE_ENDING
};

unsigned char game_state = STATE_TITLE;
unsigned char frame_count = 0;
unsigned char selected_crewmate = 0;

unsigned char pad1, pad1_old;

void display_press_start(void);
void display_press_A(void);
void update_arrow(void);
void clear_screen(void);
void draw_crewmate_menu(void);

void main(void) {
	ppu_off();
	pal_bg(palette);
	set_vram_buffer();
	multi_vram_buffer_horz("LOVE & LASERS", 13, NTADR_A(10,12));
	ppu_on_all();

	while (1){
		ppu_wait_nmi();
		pad1_old = pad1;
		pad1 = pad_poll(0);

		if (game_state == STATE_TITLE) {
			display_press_start();

			if ((pad1 & PAD_START) && !(pad1_old & PAD_START)) {
				ppu_off();
				clear_screen();
				multi_vram_buffer_horz("BRIEFING GOES HERE", 18, NTADR_A(7,12));
				ppu_on_all();

				game_state = STATE_BRIEFING;
			}
		}
		else if (game_state == STATE_BRIEFING) {
			display_press_A();

			if ((pad1 & PAD_A) && !(pad1_old & PAD_A)) {
				ppu_off();
				clear_screen();
				multi_vram_buffer_horz("SELECT YOUR CREWMATE", 20, NTADR_A(6,4));
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
		}
	}
}

void display_press_start(void) {
	frame_count++;
	if ((frame_count & 0x20) == 0) {
		multi_vram_buffer_horz("PRESS START", 11, NTADR_A(11,15));
	} else {
		multi_vram_buffer_horz("           ", 11, NTADR_A(11,15));
	}
}

void display_press_A(void) {
	frame_count++;
	if ((frame_count & 0x20) == 0) {
		multi_vram_buffer_horz("PRESS A BUTTON", 14, NTADR_A(9,15));
	} else {
		multi_vram_buffer_horz("              ", 14, NTADR_A(9,15));
	}
}

void update_arrow(void) {
	int arrow_addr = NTADR_A(8, 11 + selected_crewmate * 4);
	one_vram_buffer('>', arrow_addr);
}

void draw_crewmate_menu(void) {
	multi_vram_buffer_horz("ZARNELLA", 8, NTADR_A(10, 11));
	multi_vram_buffer_horz("LUMA-6", 6, NTADR_A(10, 15));
	multi_vram_buffer_horz("MR BUBBLES", 10, NTADR_A(10, 19));
}

void clear_screen(void) {
	ppu_off();
	vram_adr(NTADR_A(0, 0));
	vram_fill(' ', 32 * 30);
	ppu_on_all();
}
