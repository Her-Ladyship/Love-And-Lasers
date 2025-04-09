
#include "globals.h"

// === GLOBAL VARIABLES ===

unsigned char game_state = STATE_TITLE;
unsigned char current_level = 1;
unsigned char i = 0;
unsigned char j = 0;
unsigned char briefing_step = 0;
unsigned char selected_crewmate = 0;
unsigned char shmup_screen_drawn = 0;
unsigned char shmup_started = 0;
unsigned char dialogue_shown = 0;
unsigned char ending_shown = 0;
unsigned char ability_ready = 1;
char hp_string[6] = "HP: 3";

unsigned char frame_count = 0;
unsigned int ability_cooldown_timer = 0;

unsigned char pad1, pad1_old;

unsigned char player_invincible = 0;
unsigned char invincibility_timer = 0;
unsigned char zarnella_laser_timer = 0;

unsigned char player_x = 32;
unsigned char player_y = 120;
unsigned char player_health = MAX_HEALTH;

unsigned char bullet_x[MAX_BULLETS];
unsigned char bullet_y[MAX_BULLETS];
unsigned char bullet_active[MAX_BULLETS];
struct Bullet bullets[MAX_BULLETS];

unsigned int freeze_timer = 0;

unsigned int player_score = 0;
char score_string[13] = "SCORE: 00000";

unsigned int shmup_timer = 5400;
char timer_string[10] = "TIMER: 90";
unsigned char briefing_line = 0;
unsigned char briefing_started = 0;

struct Box bullet_box;
struct Box enemy_box;

const unsigned char player_sprite[] = {
	0, 0, 0x41, 0,
	128
};

const unsigned char bullet_sprite[] = {
	0, 0, 0x42, 0,
	128
};

const unsigned char enemy_sprite[] = {
    0, 0, 0x43, 0,
    128
};

const unsigned char special_bullet_sprite[] = {
	0, 0, 0x66, 0,
	128
};

const unsigned char palette[] = {
	0x0f, 0x01, 0x21, 0x31,
	0x0f, 0x17, 0x27, 0x37,
	0x0f, 0x11, 0x21, 0x31,
	0, 0, 0, 0
};
