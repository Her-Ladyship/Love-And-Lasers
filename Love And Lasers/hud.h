
#ifndef HUD_H
#define HUD_H

void draw_hud(void);
void update_score_string(void);
void update_timer_string(void);
void draw_ability_cooldown_bar(void);
unsigned int get_current_cooldown_max(void);

#endif
