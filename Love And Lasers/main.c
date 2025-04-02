
#include "LIB/neslib.h"
#include "LIB/nesdoug.h" 

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
// black must be 0x0f, white must be 0x30
 
#pragma bss-name(push, "ZEROPAGE")

unsigned char i;
const unsigned char text[]="LOVE & LASERS!";
const unsigned char palette[]={
BLACK, DK_GY, LT_GY, WHITE,
0,0,0,0,
0,0,0,0,
0,0,0,0
}; 	

void main (void) {
	
	ppu_off(); // screen off

	pal_bg(palette); //	load the BG palette
		
	// set a starting point on the screen
	vram_adr(NTADR_A(9,12)); // screen is 32 x 30 tiles

	i = 0;
	while(text[i]){
		vram_put(text[i]); // this pushes 1 char to the screen
		++i;
	}	
	
	ppu_on_all(); //	turn on screen	
	
	while (1){
		// infinite loop
		// game code can go here later.
		
	}
}
	
	