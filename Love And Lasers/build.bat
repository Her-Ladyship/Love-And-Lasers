
@echo off

set name="main"

set CC65_HOME=..\cc65\

set path=%path%;%CC65_HOME%\bin\

cc65 -Oirs %name%.c --add-source
cc65 -Oirs enemies.c --add-source
cc65 -Oirs globals.c --add-source
cc65 -Oirs bullets.c --add-source
cc65 -Oirs hud.c --add-source
cc65 -Oirs player.c --add-source
cc65 -Oirs screens.c --add-source
cc65 -Oirs companions.c --add-source
cc65 -Oirs levels.c --add-source

ca65 crt0.s
ca65 %name%.s -g
ca65 enemies.s
ca65 globals.s
ca65 bullets.s
ca65 hud.s
ca65 player.s
ca65 screens.s
ca65 companions.s
ca65 levels.s

:: Link all .o files together
ld65 -C nrom_32k_vert.cfg -o %name%.nes crt0.o main.o enemies.o globals.o bullets.o hud.o player.o screens.o companions.o levels.o nes.lib -Ln %name%.labels --dbgfile %name%.dbg

del *.o

move /Y %name%.labels BUILD\
move /Y %name%.nes BUILD\
move /Y %name%.dbg BUILD\
