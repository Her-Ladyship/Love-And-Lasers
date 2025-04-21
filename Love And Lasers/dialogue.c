
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
	{"I'LL HAUNT YOU PERSONALLY.", 3, 17},
	{"                             ", 0, 19}
 };

 const DialogueLine luma_lv1_start[] = {
	{"UPLOADING MISSION PROTOCOLS", 2, 11},
	{"TACTICAL SYSTEMS GREEN -", 4, 15},
	{"LET'S MAKE THIS EFFICIENT", 3, 17},
	{"                             ", 0, 19}
 };

 const DialogueLine bubbles_lv1_start[] = {
	{"WUBBLE WUBBLE WUBBLE WUBBLE!", 2, 11},
	{"BUBBLE MODE ENGAGED!", 6, 15},
	{"                             ", 0, 17}
 };

 const DialogueLine zarnella_lv1_end[] = {
	{"WELL, THAT WASN'T *TERRIBLE*.", 2, 11},
	{"DON'T EXPECT ME TO CLAP", 5, 15},
	{"                             ", 0, 17}
};

const DialogueLine luma_lv1_end[] = {
	{"MISSION PARAMETERS COMPLETE", 3, 11},
	{"NICE SHOOTING, I GUESS.", 5, 15},
	{"                             ", 0, 17}
};

const DialogueLine bubbles_lv1_end[] = {
	{"BUBBLE MISSION SUCCESSFUL", 4, 11},
	{"WHEEEEEEEE!", 11, 15},
	{"                             ", 0, 17}
};

const DialogueLine zarnella_lv2_start[] = {
	{"THEY SENT ME *BACK* WITH YOU?", 1, 11},
	{"EITHER I'M BEING PUNISHED...", 2, 13},
	{"                             ", 0, 15},
	{"OR THEY THINK", 10, 17},
	{"YOU'LL DIE THIS TIME", 6, 19},
	{"                             ", 0, 15}
};

const DialogueLine luma_lv2_start[] = {
	{"LAST TEAM-UP: EFFICIENCY LOSS", 1, 11},
	{"MITIGATING HUMAN VARIABLES...", 1, 13},
	{"                             ", 0, 15},
	{"PLEASE REMAIN", 9, 17},
	{"*LESS* STUPID THIS TIME.", 4, 19},
	{"                             ", 0, 15}
};

const DialogueLine bubbles_lv2_start[] = {
	{"LAST NIGHT I DREAMT OF YOU.", 2, 11},
	{"THERE WAS SLIME EVERYWHERE.", 2, 13},
	{"SO MUCH SLIME.", 9, 15},
	{"                             ", 0, 17},
	{"LET'S MAKE THE DREAM *REAL*.", 2, 19},
	{"                             ", 0, 17}
};

const DialogueLine zarnella_lv2_end[] = {
	{"I'M STILL IN ONE PIECE.", 5, 11},
	{"EVEN IF I CAN'T SAY", 7, 13},
	{"THE SAME FOR THE ENEMY.", 5, 15},
	{"                             ", 0, 17},
	{"OR MY FAITH IN YOU.", 7, 19},
	{"                             ", 0, 17}
};

const DialogueLine luma_lv2_end[] = {
	{"MISSION COMPLETE", 8, 10},
	{"DESPITE MULTIPLE", 8, 12},
	{"OPERATOR ERRORS.", 8, 14},
	{"                             ", 0, 16},
	{"I'VE LOGGED THEM ALL", 6, 18},
	{"                             ", 0, 16},
	{"FOR LATER.", 11, 20},
	{"                             ", 0, 16}
};

const DialogueLine bubbles_lv2_end[] = {
	{"SO MANY SPLATTERS!", 7, 11},
	{"THE FLOOR IS", 10, 13},
	{"*SLIPPERY* WITH JOY!", 6, 15},
	{"                             ", 0, 17},
	{"I'M GONNA POP FROM EXCITEMENT!", 1, 19},
	{"                             ", 0, 17}
};

const DialogueLine zarnella_lv3_start[] = {
	{"ONE MORE MISSION.", 8, 11},
	{"ONE MORE CHANCE", 9, 13},
	{"TO DIE WITH HONOUR.", 7, 15},
	{"                             ", 0, 17},
	{"OR TO SHOOT FIRST.", 2, 19},
	{"                             ", 0, 17},
	{"YOUR CALL.", 21, 19},
	{"                             ", 0, 17}
};

const DialogueLine luma_lv3_start[] = {
	{"SYSTEM STABILITY: CRITICAL.", 3, 11},
	{"MORALE: LAUGHABLY LOW.", 6, 13},
	{"LET'S FINISH THIS BEFORE YOU", 2, 15},
	{"BREAK ANYTHING ELSE", 7, 17},
	{"                             ", 0, 19}
};

const DialogueLine bubbles_lv3_start[] = {
	{"THE BUBBLES HAVE SPOKEN.", 4, 11},
	{"THEY SAY 'POP POP POP'.", 5, 13},
	{"                             ", 0, 15},
	{"AND THEY DEMAND SACRIFICE.", 3, 17},
	{"                             ", 0, 15}
};

const DialogueLine zarnella_lv3_end[] = {
	{"THIS FIGHT WAS ALMOST WORTH IT", 1, 10},
	{"                             ", 0, 16},
	{"BLOOD.", 9, 12},
	{"             ", 0, 16},
	{"FLAMES.", 16, 12},
	{"             ", 0, 16},
	{"THE SMELL OF VICTORY.", 5, 14},
	{"                             ", 0, 16},
	{"IF THE FINAL BATTLE", 6, 18},
	{"DISAPPOINTS ME...", 8, 20},
	{"                             ", 0, 16}
};

const DialogueLine luma_lv3_end[] = {
	{"ANALYSIS:", 1, 11},
	{"               ", 0, 15},
	{"IMPROVEMENT DETECTED", 11, 11},
	{"                             ", 0, 15},
	{"DID YOU...", 2, 13},
	{"             ", 0, 15},
	{"LEARN SOMETHING?", 13, 13},
	{"                             ", 0, 15},
	{"UNEXPECTED.", 1, 17},
	{"                             ", 0, 15},
	{"POSSIBLY A GLITCH.", 13, 17},
	{"                             ", 0, 15}
};

const DialogueLine bubbles_lv3_end[] = {
	{"DID YOU FEEL THAT?", 1, 11},
	{"                             ", 0, 15},
	{"THAT *POP*?", 20, 11},
	{"                             ", 0, 15},
	{"EVERY BLAST MADE ME QUIVER!", 2, 13},
	{"                             ", 0, 15},
	{"DON'T CLEAN THE COCKPIT.", 4, 17},
	{"                             ", 0, 15},
	{"I'LL LICK IT.", 10, 19},
	{"                             ", 0, 15}
};

const DialogueLine zarnella_boss_start[] = {
	{"THIS IS IT", 11, 9},
	{"               ", 0, 13},
	{"THE FINAL SLAUGHTER", 6, 11},
	{"                             ", 0, 13},
	{"I'LL CARVE MY NAME", 7, 15},
	{"INTO THEIR CORPSES", 7, 17},
	{"                             ", 0, 13},
	{"JUST TRY TO KEEP UP, CAPTAIN.", 2, 20},
	{"                             ", 0, 13}
};

const DialogueLine luma_boss_start[] = {
	{"ALL PATHS LEAD TO THIS POINT", 2, 11},
	{"                             ", 0, 15},
	{"STATISTICAL SURVIVAL:", 1, 13},
	{"              ", 0, 15},
	{"UNLIKELY", 23, 13},
	{"                             ", 0, 15},
	{"BUT IF WE DIE, I'M TAKING", 4, 17},
	{"THE MAINFRAME WITH ME.", 5, 19},
	{"                             ", 0, 15}
};

const DialogueLine bubbles_boss_start[] = {
	{"OOH, I'M *TREMBLING*", 6, 9},
	{"WITH EXCITEMENT!", 8, 11},
	{"                             ", 0, 13},
	{"THAT SHIP...", 6, 15},
	{"                             ", 0, 13},
	{"SO BIG.", 19, 15},
	{"                             ", 0, 13},
	{"SO FULL OF JUICE.", 8, 17},
	{"                             ", 0, 13},
	{"LET'S GO BURST IT, CAPTAIN!", 3, 21},
	{"                             ", 0, 13}
};

const DialogueLine zarnella_boss_end[] = {
	{"HAH! NOW *THAT* WAS A FIGHT.", 2, 11},
	{"            ", 0, 15},
	{"MY BLOOD'S STILL HUMMING.", 3, 13},
	{"                             ", 0, 15},
	{"COME ON, LET'S FIND", 7, 17},
	{"SOMETHING ELSE TO KILL.", 5, 19},
	{"                             ", 0, 15},
};

const DialogueLine luma_boss_end[] = {
	{"THAT...", 4, 11},
	{"              ", 0, 15},
	{"WAS UNEXPECTEDLY", 11, 11},
	{"EFFECTIVE.", 11, 13},
	{"                             ", 0, 15},
	{"DID YOU...", 5, 17},
	{"              ", 0, 15},
	{"PERFORM WELL?", 16, 17},
	{"                             ", 0, 15},
	{"NO.", 2, 19},
	{"              ", 0, 15},
	{"DON'T GET USED TO PRAISE.", 6, 19},
	{"                             ", 0, 15}
};

const DialogueLine bubbles_boss_end[] = {
	{"I'M *QUIVERING* IN PLACES", 3, 9},
	{"I DIDN'T KNOW I HAD!", 6, 11},
	{"                             ", 0, 13},
	{"THAT WAS THE JUICIEST", 5, 15},
	{"EXPLOSION YET!", 9, 17},
	{"                             ", 0, 13},
	{"I'VE MADE A MESS", 8, 21},
	{"                             ", 0, 13}
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
			show_typewriter(zarnella_lv1_start, 4);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv1_start, 4);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv1_start, 3);
		}
	}
	if (level_num == 2) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_lv2_start, 6);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv2_start, 6);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv2_start, 6);
		}
	}
	if (level_num == 3) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_lv3_start, 8);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv3_start, 5);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv3_start, 5);
		}
	}
	if (level_num == 4) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_boss_start, 9);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_boss_start, 9);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_boss_start, 11);
		}
	}
}

void mission_end_text(unsigned char level_num) {
	if (level_num == 1) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_lv1_end, 3);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv1_end, 3);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv1_end, 3);
		}
	}
	if (level_num == 2) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_lv2_end, 6);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv2_end, 8);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv2_end, 6);
		}
	}
	if (level_num == 3) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_lv3_end, 11);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_lv3_end, 12);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_lv3_end, 10);
		}
	}
	if (level_num == 4) {
		if (selected_crewmate == 0) {
			WRITE("ZARNELLA:", 12, 6);
			show_typewriter(zarnella_boss_end, 7);
		}
		else if (selected_crewmate == 1) {
			WRITE("LUMA-6:", 12, 6);
			show_typewriter(luma_boss_end, 13);
		}
		else {
			WRITE("MR. BUBBLES:", 10, 6);
			show_typewriter(bubbles_boss_end, 8);
		}
	}
}
