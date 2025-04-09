
#ifndef GLOBALS_H
#define GLOBALS_H

// === LIBRARIES ===
#include "lib/neslib.h"
#include "lib/nesdoug.h"

// === SHARED CONSTANTS ===
#define MAX_BULLETS 3
#define BULLET_RIGHT_LIMIT 252
#define MAX_ENEMIES 6
#define ENEMY_LEFT_LIMIT 8
#define MAX_HEALTH 3

#define ZARNELLA_COOLDOWN 300
#define LUMA6_COOLDOWN 600
#define BUBBLES_COOLDOWN 1200

#define PLAYFIELD_TOP 48
#define PLAYFIELD_BOTTOM 192

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30

#define WRITE(text, x, y) multi_vram_buffer_horz(text, sizeof(text)-1, NTADR_A(x, y))
#define BLINK_MSG(msg, x, y) display_blinking_message(msg, sizeof(msg)-1, x, y)

// === ENUMS ===
enum GameState {
  STATE_TITLE,
  STATE_BRIEFING,
  STATE_SELECT_CREWMATE,
  STATE_CREWMATE_CONFIRM,
  STATE_SHMUP,
  STATE_DIALOGUE,
  STATE_ENDING,
  STATE_GAME_OVER
};

// === STRUCTS ===
struct Box {
	unsigned char x;
	unsigned char y;
	unsigned char width;
	unsigned char height;
};

struct Bullet {
	unsigned char x;
	unsigned char y;
	signed char dx;
	signed char dy;
	unsigned char active;
};

// === GLOBAL VARIABLES (extern) ===
extern unsigned char game_state;
extern unsigned char current_level;
extern unsigned char i, j;
extern unsigned char briefing_step;
extern unsigned char selected_crewmate;
extern unsigned char shmup_screen_drawn, shmup_started;
extern unsigned char dialogue_shown, ending_shown;
extern unsigned char ability_ready;
extern char hp_string[6];

extern unsigned char frame_count;
extern unsigned int ability_cooldown_timer;

extern unsigned char pad1, pad1_old;

extern unsigned char player_invincible;
extern unsigned char invincibility_timer;
extern unsigned char zarnella_laser_timer;

extern unsigned char player_x, player_y;
extern unsigned char player_health;

extern unsigned char bullet_x[MAX_BULLETS];
extern unsigned char bullet_y[MAX_BULLETS];
extern unsigned char bullet_active[MAX_BULLETS];
extern struct Bullet bullets[MAX_BULLETS];

extern unsigned int freeze_timer;

extern unsigned int player_score;
extern char score_string[13];

extern unsigned int shmup_timer;
extern char timer_string[10];
extern unsigned char briefing_line;
extern unsigned char briefing_started;

extern struct Box bullet_box;
extern struct Box enemy_box;

// === SPRITES ===
extern const unsigned char player_sprite[];
extern const unsigned char bullet_sprite[];
extern const unsigned char enemy_sprite[];
extern const unsigned char special_bullet_sprite[];

extern const unsigned char palette[];

#endif
