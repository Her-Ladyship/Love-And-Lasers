
#ifndef SCREENS_H
#define SCREENS_H

void clear_screen(void);
void clear_line(unsigned char row);
void display_blinking_message(const char *msg, unsigned char len, unsigned char x, unsigned char y);

#endif
