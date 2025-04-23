
#ifndef COMPANIONS_H
#define COMPANIONS_H

void update_arrow(void);
void draw_crewmate_menu(void);
void resting_companion_text(void);
void handle_selection_arrow(unsigned char allow_all);

void update_ability_cooldown(void);
void start_ability_cooldown(void);
void reset_companion_ability_state(void);

void fire_zarnella_lasers(void);
void draw_zarnella_lasers(void);

unsigned char get_romance_winner(void);
unsigned int affection_bonus(void);
unsigned int get_picks_for_winner(void);

#endif
