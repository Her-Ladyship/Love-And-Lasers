
#include "globals.h"

// === GLOBAL VARIABLES ===

unsigned char game_state = STATE_TITLE;
unsigned char current_level = 1;
unsigned char i = 0;
unsigned char j = 0;
unsigned char briefing_started = 0;
unsigned char selected_crewmate = 0;
unsigned char previous_crewmate = 0;
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

unsigned char boss_active = 0;
unsigned char boss_health = 20;
unsigned char boss_x = 216;
unsigned char boss_y = 100;
unsigned char boss_attack_mode = 0;
unsigned char boss_fire_timer = 0;

unsigned char boss_bullet_x[MAX_BOSS_BULLETS];
unsigned char boss_bullet_y[MAX_BOSS_BULLETS];
unsigned char boss_bullet_active[MAX_BOSS_BULLETS];

unsigned int freeze_timer = 0;

unsigned int player_score = 0;
char score_string[13] = "SCORE: 00000";

unsigned int shmup_timer = 5400;
char timer_string[10] = "TIMER: 90";

unsigned char typewriter_step = 0;
unsigned char typewriter_line = 0;
unsigned char typewriter_ended = 0;

unsigned char zarnella_picks = 0;
unsigned char luma_picks = 0;
unsigned char bubbles_picks = 0;

unsigned int total_romance_score = 0;

struct Box bullet_box;
struct Box enemy_box;

unsigned char enemy_type[MAX_ENEMIES];
unsigned char enemy_health[MAX_ENEMIES];

unsigned char tens = 0;
unsigned char ones = 0;

// === SPRITES ===
const unsigned char player_sprite[] = {
	0, 0, 0x96, 1,
	128
};

const unsigned char bullet_sprite[] = {
	0, 0, 0x2d, 0,
	128
};

const unsigned char special_bullet_sprite[] = {
	0, 0, 0x3e, 0,
	128
};

const unsigned char enemy_sprite_basic[] = {
    0, 0, 0xb7, 3,
    128
};

const unsigned char enemy_sprite_fast[] = {
    0, 0, 0x98, 2,
    128
};

const unsigned char enemy_sprite_tough[] = {
    0, 0, 0x5b, 0,  // Top left
    8, 0, 0x5c, 0,  // Top right
    0, 8, 0x5b, 0,  // Middle left
    8, 8, 0x5c, 0,  // Middle right
    0, 16, 0x5b, 0,  // Bottom left
    8, 16, 0x5c, 0,  // Bottom right
    128
};

// Link them together:
const unsigned char* enemy_sprites[3] = {
    enemy_sprite_basic,
    enemy_sprite_fast,
    enemy_sprite_tough
};

const unsigned char boss_bullet_sprite[] = {
	0, 0, 0x7e, 0,
	128
};

const unsigned char boss_sprite[] = {
    // Row 1
    0,    0, 0x42, 0,  // B
    8,    0, 0x4f, 0,  // O
    16,   0, 0x53, 0,  // S
    24,   0, 0x53, 0,  // S
    // Row 2
    0,    8, 0x42, 0,
    8,    8, 0x4f, 0,
    16,   8, 0x53, 0,
    24,   8, 0x53, 0,
    // Row 3
    0,    16, 0x42, 0,
    8,    16, 0x4f, 0,
    16,   16, 0x53, 0,
    24,   16, 0x53, 0,
    // Row 4
    0,    24, 0x42, 0,
    8,    24, 0x4f, 0,
    16,   24, 0x53, 0,
    24,   24, 0x53, 0,
    // Row 5
    0,    32, 0x42, 0,
    8,    32, 0x4f, 0,
    16,   32, 0x53, 0,
    24,   32, 0x53, 0,

    128  // End of metasprite
};

const unsigned char palette[] = {
	0x0f, 0x00, 0x10, 0x30,
	0x0f, 0x11, 0x21, 0x38,
	0x0f, 0x05, 0x15, 0x25,
	0x0f, 0x27, 0x1a, 0x29
};

const unsigned char tough_debris_1[] = {
    0, 0, 0x92, 1,   8, 0, 0xa3, 1,
    0, 8, 0xb4, 1,   8, 8, 0x94, 1,
    0, 16, 0xa2, 1,  8, 16, 0xb2, 1,
    128
};

const unsigned char tough_debris_2[] = {
    0, 0, 0xa3, 1,   8, 0, 0x93, 1,
    0, 8, 0xb3, 1,   8, 8, 0x92, 1,
    0, 16, 0xa4, 1,  8, 16, 0xb4, 1,
    128
};

const unsigned char tough_debris_3[] = {
    0, 0, 0xb2, 1,   8, 0, 0xa2, 1,
    0, 8, 0x92, 1,   8, 8, 0x94, 1,
    0, 16, 0xb4, 1,  8, 16, 0xa3, 1,
    128
};

const unsigned char tough_debris_4[] = {
    0, 0, 0x94, 2,   8, 0, 0xb3, 2,
    0, 8, 0xa2, 2,   8, 8, 0xb2, 2,
    0, 16, 0x93, 2,  8, 16, 0xa4, 2,
    128
};

const unsigned char tough_debris_5[] = {
    0, 0, 0xb4, 2,   8, 0, 0xa3, 2,
    0, 8, 0x92, 2,   8, 8, 0x93, 2,
    0, 16, 0xa2, 2,  8, 16, 0xb2, 2,
    128
};

const unsigned char tough_debris_6[] = {
    0, 0, 0x92, 2,   8, 0, 0xa2, 2,
    0, 8, 0xb3, 2,   8, 8, 0xa4, 2,
    0, 16, 0x93, 2,  8, 16, 0xb4, 2,
    128
};

const unsigned char tough_debris_7[] = {
    0, 0, 0xa3, 3,   8, 0, 0xb4, 3,
    0, 8, 0xa2, 3,   8, 8, 0x94, 3,
    0, 16, 0x93, 3,  8, 16, 0xb2, 3,
    128
};

const unsigned char tough_debris_8[] = {
    0, 0, 0xb2, 3,   8, 0, 0x94, 3,
    0, 8, 0xa4, 3,   8, 8, 0xb3, 3,
    0, 16, 0x92, 3,  8, 16, 0xa3, 3,
    128
};

const unsigned char tough_debris_9[] = {
    0, 0, 0xa4, 3,   8, 0, 0x92, 3,
    0, 8, 0x93, 3,   8, 8, 0xb4, 3,
    0, 16, 0xa2, 3,  8, 16, 0xb3, 3,
    128
};

const unsigned char* tough_debris_variants[9] = {
    tough_debris_1, tough_debris_2, tough_debris_3,
    tough_debris_4, tough_debris_5, tough_debris_6,
    tough_debris_7, tough_debris_8, tough_debris_9
};

unsigned char enemy_variant[MAX_ENEMIES];