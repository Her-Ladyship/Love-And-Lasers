
#include "screens.h"
#include "globals.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"

void clear_screen(void) {
	vram_adr(NTADR_A(0, 0));
	vram_fill(' ', 32 * 30);
	oam_clear();
}

void clear_line(unsigned char y) {
	multi_vram_buffer_horz("                                ", 32, NTADR_A(0, y));
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