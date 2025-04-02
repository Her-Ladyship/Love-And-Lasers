#include "LIB/neslib.h"
#include "LIB/nesdoug.h" 

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
// black must be 0x0f, white must be 0x30
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
unsigned char selected_crewmate = 0;  // 0 = Zarnella, 1 = Luma-6, 2 = Mr Bubbles

void display_press_start(void);
void display_press_A(void);

void main(void) {
	unsigned char pad1;

	ppu_off();
	pal_bg(palette);
	vram_adr(NTADR_A(10, 12));
	vram_write("LOVE & LASERS", 13);
	ppu_on_all();

	while (1){
		ppu_wait_nmi();
		pad1 = pad_poll(0);

		if (game_state == STATE_TITLE) {
			vram_adr(NTADR_A(11,15));
			display_press_start();

			if (pad1 & PAD_START) {
				ppu_off();
				vram_adr(NTADR_A(0, 0));
				vram_fill(0, 32*30);

				vram_adr(NTADR_A(7, 12));
				vram_write("BRIEFING GOES HERE", 18);

				game_state = STATE_BRIEFING;
				vram_adr(NTADR_A(0, 0));

				ppu_on_all();
			}
		}
		else if (game_state == STATE_BRIEFING) {
			vram_adr(NTADR_A(9,15));
			display_press_A();		

			if (pad1 & PAD_A) {
				ppu_off();
				vram_adr(NTADR_A(0, 0));
				vram_fill(0, 32*30);

				vram_adr(NTADR_A(8, 12));
				vram_write("SELECT YOUR CREW", 16);

				game_state = STATE_SELECT_CREWMATE;
				ppu_on_all();
			}
		}
		else if (game_state == STATE_SELECT_CREWMATE) {

		}
	}
}

void display_press_start(void) {
	frame_count++;	
	if ((frame_count & 0x20) == 0) {
		vram_write("PRESS START", 11);
	} else {
		vram_fill(' ', 11);
	}
	vram_adr(NTADR_A(0,0));
}

void display_press_A(void) {
	frame_count++;	
	if ((frame_count & 0x20) == 0) {
		vram_write("PRESS A BUTTON", 14);
	} else {
		vram_fill(' ', 14);
	}
	vram_adr(NTADR_A(0,0));
}

