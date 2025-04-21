
#ifndef DIALOGUE_H
#define DIALOGUE_H

typedef struct {
	char* text;
	unsigned char x;
	unsigned char y;
} DialogueLine;

extern unsigned char typewriter_char;

extern const DialogueLine briefing_lines[];

extern const DialogueLine zarnella_lv1_start[];
extern const DialogueLine luma_lv1_start[];
extern const DialogueLine bubbles_lv1_start[];

extern const DialogueLine zarnella_lv1_end[];
extern const DialogueLine luma_lv1_end[];
extern const DialogueLine bubbles_lv1_end[];

extern const DialogueLine zarnella_lv2_start[];
extern const DialogueLine luma_lv2_start[];
extern const DialogueLine bubbles_lv2_start[];

extern const DialogueLine zarnella_lv2_end[];
extern const DialogueLine luma_lv2_end[];
extern const DialogueLine bubbles_lv2_end[];

extern const DialogueLine zarnella_lv3_start[];
extern const DialogueLine luma_lv3_start[];
extern const DialogueLine bubbles_lv3_start[];

extern const DialogueLine zarnella_lv3_end[];
extern const DialogueLine luma_lv3_end[];
extern const DialogueLine bubbles_lv3_end[];

extern const DialogueLine zarnella_boss_start[];
extern const DialogueLine luma_boss_start[];
extern const DialogueLine bubbles_boss_start[];

extern const DialogueLine zarnella_boss_end[];
extern const DialogueLine luma_boss_end[];
extern const DialogueLine bubbles_boss_end[];

void show_typewriter(const DialogueLine* lines, unsigned char line_count);
void typewriter_reset(void);

void mission_begin_text(unsigned char level_num);
void mission_end_text(unsigned char level_num);

#endif
