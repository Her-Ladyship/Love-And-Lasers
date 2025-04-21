
#include "dialogue.h"
#include "globals.h"
#include "lib/neslib.h"
#include "lib/nesdoug.h"
#include "screens.h"

// === TYPEWRITER ===

const DialogueLine briefing_lines[] = {
 	{"GALACTIC COMMAND BOOTING UP..", 2, 2},
 	{"CAPTAIN, WE NEED A HERO,", 4, 5},
 	{"OR AT LEAST SOMEONE SHOOTY.", 3, 7},
 	{"OUTPOST DELTA-ZULU-7 WENT DARK.", 1, 10},
 	{"POSSIBLE AI GONE ROGUE. AGAIN.", 1, 12},
 	{"GO IN HARD AND FIND THE TRUTH.", 1, 15},
 	{"EXPLOSIONS OPTIONAL BUT LIKELY", 1, 17},
 	{"YOU'RE OUR ONLY HOPE. SORT OF.", 1, 22}
 };

 const DialogueLine zarnella_lv1_start[] = {
	{"DON'T SLOW ME DOWN, MEATBAG.", 2, 11},
	{"IF YOU GET ME KILLED", 6, 15},
	{"I'LL HAUNT YOU PERSONALLY.", 3, 17}
 };

 const DialogueLine luma_lv1_start[] = {
	{"UPLOADING MISSION PROTOCOLS", 2, 11},
	{"TACTICAL SYSTEMS GREEN -", 4, 15},
	{"LET'S MAKE THIS EFFICIENT", 3, 17}
 };

 const DialogueLine bubbles_lv1_start[] = {
	{"WUBBLE WUBBLE WUBBLE WUBBLE!", 2, 11},
	{"BUBBLE MODE ENGAGED!", 6, 15}
 };

 const DialogueLine zarnella_lv1_end[] = {
	{"WELL, THAT WASN'T *TERRIBLE*.", 2, 11},
	{"DON'T EXPECT ME TO CLAP", 5, 15}
};

const DialogueLine luma_lv1_end[] = {
	{"MISSION PARAMETERS COMPLETE", 3, 11},
	{"NICE SHOOTING, I GUESS.", 5, 15}
};

const DialogueLine bubbles_lv1_end[] = {
	{"BUBBLE MISSION SUCCESSFUL", 4, 11},
	{"WHEEEEEEEE!", 11, 15}
};

unsigned char typewriter_char = 0;
unsigned char typewriter_delay = 0;

void show_typewriter(const DialogueLine* lines, unsigned char line_count) {
	const char* current = lines[typewriter_line].text;
	unsigned char x = lines[typewriter_line].x;
	unsigned char y = lines[typewriter_line].y;

	if (typewriter_line >= line_count) {
		typewriter_ended = 1;
		return;
	}

	if (++typewriter_delay < 2) return; // Lower = faster typing
	typewriter_delay = 0;

	if (current[typewriter_char] != '\0') {
		one_vram_buffer(current[typewriter_char], NTADR_A(x + typewriter_char, y));
		typewriter_char++;
	} else {
		typewriter_line++;
		typewriter_char = 0;
	}
}

void typewriter_reset(void) {
	typewriter_ended = 0;
	typewriter_line = 0;
	typewriter_char = 0;
	typewriter_step = 0;
}

// === CREWMATE COMMENTARY ===

void mission_begin_text(unsigned char level_num) {
	if (level_num == 1) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_lv1_start, 3);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv1_start, 3);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv1_start, 2);
		}
	}
}

void mission_end_text(unsigned char level_num) {
	if (level_num == 1) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_lv1_end, 2);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv1_end, 2);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv1_end, 2);
		}
	}
}
