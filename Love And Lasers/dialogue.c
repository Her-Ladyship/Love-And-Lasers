
#include "dialogue.h"
#include "globals.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "screens.h"

// === TYPEWRITER BRIEFING ===

struct DialogueLine {
	const char* text;
	unsigned char x;
	unsigned char y;
};

const struct DialogueLine briefing_lines[] = {
	{"GALACTIC COMMAND BOOTING UP..", 2, 2},
	{"CAPTAIN, WE NEED A HERO,", 4, 5},
	{"OR AT LEAST SOMEONE SHOOTY.", 3, 7},
	{"OUTPOST DELTA-ZULU-7 WENT DARK.", 1, 10},
	{"POSSIBLE AI GONE ROGUE. AGAIN.", 1, 12},
	{"GO IN HARD AND FIND THE TRUTH.", 1, 15},
	{"EXPLOSIONS OPTIONAL BUT LIKELY", 1, 17},
	{"YOU'RE OUR ONLY HOPE. SORT OF.", 1, 22},
	{"PRESS A BUTTON", 9, 26}
};

#define NUM_BRIEFING_LINES (sizeof(briefing_lines) / sizeof(briefing_lines[0]))

unsigned char briefing_char = 0;
unsigned char briefing_delay = 0;

void show_briefing_typewriter(void) {
	const char* current = briefing_lines[briefing_line].text;
	unsigned char x = briefing_lines[briefing_line].x;
	unsigned char y = briefing_lines[briefing_line].y;

	if (briefing_line >= NUM_BRIEFING_LINES) return;

	if (++briefing_delay < 2) return; // Lower = faster typing
	briefing_delay = 0;

	if (current[briefing_char] != '\0') {
		one_vram_buffer(current[briefing_char], NTADR_A(x + briefing_char, y));
		briefing_char++;
	} else {
		briefing_line++;
		briefing_char = 0;
	}
}

unsigned char is_briefing_done(void) {
	return (briefing_line >= NUM_BRIEFING_LINES);
}

// === CREWMATE START COMMENTARY ===

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
