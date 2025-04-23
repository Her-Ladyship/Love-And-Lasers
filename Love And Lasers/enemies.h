
#ifndef ENEMIES_H
#define ENEMIES_H

#include "lib/neslib.h"

// === ENEMY CONSTANTS ===
#define MAX_ENEMIES 6
#define ENEMY_LEFT_LIMIT 8

// === ENEMY DATA ===
extern unsigned char enemy_x[MAX_ENEMIES];
extern unsigned char enemy_y[MAX_ENEMIES];
extern unsigned char enemy_active[MAX_ENEMIES];
extern unsigned char enemy_frozen[MAX_ENEMIES];

// === ENEMY FUNCTIONS ===
void spawn_basic(void);
void spawn_fast(void);
void spawn_tough(void);

void update_enemies(void);
void clear_all_enemies(void);

#endif
