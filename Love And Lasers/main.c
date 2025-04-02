#include "LIB/neslib.h"
#include "LIB/nesdoug.h" 

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
// black must be 0x0f, white must be 0x30

#pragma bss-name(push, "ZEROPAGE")

const unsigned char palette[] = {
	BLACK, DK_GY, LT_GY, WHITE,
	0,0,0,0,
	0,0,0,0,
	0,0,0,0
}; 

enum GameState { STATE_TITLE, STATE_GAME };
unsigned char game_state = STATE_TITLE;

unsigned char frame_count = 0;

void update_title_screen(void); // function declaration

void main(void) {
	unsigned char pad1; // must be declared at the start of a block

	ppu_off(); // screen off

	pal_bg(palette); //	load the BG palette
		
	// set a starting point on the screen
	vram_adr(NTADR_A(9,14)); // screen is 32 x 30 tiles

	vram_write("LOVE & LASERS!", 14);
	
	ppu_on_all(); //	turn on screen	

	while (1){
		ppu_wait_nmi(); // sync with the screen refresh

		pad1 = pad_poll(0);

		if (game_state == STATE_TITLE) {
			update_title_screen();

			if (pad1 & PAD_START) {
				ppu_off();
				// scroll(0, 0);
				// vram_adr(NTADR_A(10,15));
				vram_fill(0, 32*30);

				vram_adr(NTADR_A(10, 15));  // This should be dead-centre
				vram_write("GAME STARTED", 12);

				game_state = STATE_GAME;
				ppu_on_all();
			}

		}
		else if (game_state == STATE_GAME) {

		}

	}
}

// Function definition *after* main
void update_title_screen(void) {
	frame_count++;

	vram_adr(NTADR_A(10,17));

	if ((frame_count & 0x20) == 0) {
		// Show "PRESS START"
		vram_write("PRESS START", 11);
	} else {
		// Hide it by writing spaces
		vram_fill(' ', 11);
	}

	vram_adr(NTADR_A(0,0));
}
