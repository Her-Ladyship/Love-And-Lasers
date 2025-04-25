
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

#define ENEMY_TYPE_BASIC 0
#define ENEMY_TYPE_FAST  1
#define ENEMY_TYPE_TOUGH 2

#define WRITE(text, x, y) multi_vram_buffer_horz(text, sizeof(text)-1, NTADR_A(x, y))
#define BLINK_MSG(msg, x, y) display_blinking_message(msg, sizeof(msg)-1, x, y)

#define MAX_BOSS_BULLETS 10

// === ENUMS ===
enum GameState {
  STATE_TITLE,
  STATE_BRIEFING,
  STATE_SELECT_CREWMATE,
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
extern unsigned char briefing_started;
extern unsigned char selected_crewmate;
extern unsigned char previous_crewmate;
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

extern unsigned char boss_active;
extern unsigned char boss_health;
extern unsigned char boss_x;
extern unsigned char boss_y;
extern unsigned char boss_attack_mode;
extern unsigned char boss_fire_timer;

extern unsigned char boss_bullet_x[MAX_BOSS_BULLETS];
extern unsigned char boss_bullet_y[MAX_BOSS_BULLETS];
extern unsigned char boss_bullet_active[MAX_BOSS_BULLETS];

extern unsigned int freeze_timer;

extern unsigned int player_score;
extern char score_string[13];

extern unsigned int shmup_timer;
extern char timer_string[10];

extern unsigned char typewriter_step;
extern unsigned char typewriter_line;
extern unsigned char typewriter_ended;

extern unsigned char zarnella_picks;
extern unsigned char luma_picks;
extern unsigned char bubbles_picks;

extern unsigned int total_romance_score;

extern struct Box bullet_box;
extern struct Box enemy_box;

extern unsigned char enemy_type[MAX_ENEMIES];
extern unsigned char enemy_health[MAX_ENEMIES];

extern unsigned char tens;
extern unsigned char ones;

// === SPRITES ===
extern const unsigned char player_sprite[];
extern const unsigned char bullet_sprite[];
extern const unsigned char enemy_sprite[];
extern const unsigned char special_bullet_sprite[];

extern const unsigned char enemy_sprite_basic[];
extern const unsigned char enemy_sprite_fast[];
extern const unsigned char enemy_sprite_tough[];
extern const unsigned char* enemy_sprites[3];

extern const unsigned char boss_bullet_sprite[];
extern const unsigned char boss_sprite[];

extern const unsigned char palette[];

extern const unsigned char tough_debris_1[];
extern const unsigned char tough_debris_2[];
extern const unsigned char tough_debris_3[];
extern const unsigned char tough_debris_4[];
extern const unsigned char tough_debris_5[];
extern const unsigned char tough_debris_6[];
extern const unsigned char tough_debris_7[];
extern const unsigned char tough_debris_8[];
extern const unsigned char tough_debris_9[];

extern const unsigned char* tough_debris_variants[9];

#endif
