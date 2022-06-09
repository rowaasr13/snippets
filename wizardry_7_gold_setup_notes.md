# Wizardry 7 Gold setup tips

## Common sense
* When advised to remove, replace or edit files, you will probably want to keep a copy of original. I.e. instead of completely deleting it, move it to sub-directory named "backup" or something like that.
* Any search and replace should be done with editor capable of reading and saving files in binary mode to preserve any unchanged non-text characters intact. After editing resulting file must have exactly same length in bytes as before.

## Speeding up slow command animations
Search, open cast, etc. animation of 5 command icons below game world screen can be speed up by removing all frame except first. Go to `RES\BITS\ANIMS` and remove all files from respective sub-directory (`BOOK`, `EYE`, `FIRE`, `HAND`, `KEY`) except `0.bmp`.

## Speeding up slow game intro/logo
* Sir-Tech/MIS logos: Go to `RES\MEDIA\VIDEO` and remove `DRAGON.AVI` and `MISLOGO.AVI` or replace them with with blank AVI files. Removing files completely or replacing them with invalid .avi will cause error messages on game start that can be quickly dismissed with `Enter`.
* Book opening: Go to `RES\BITS\BOOKBITS` and remove everything except `BOOK000.BMP`.

## Speeding up slow/long encounter intro sound
Replace `RES\MEDIA\SFX\WIZ_NPC.WAV` with shorter sound. There are several short `.wav` sounds available in `C:\Windows\Media`.

## Text and dialogues scroll instantly
Most can be fixed by editing `MSG.GLD` searching and replacing:
* find: `&%]`, replace with: `&@]`
* find: `&%%]`, replace with: `&%@]`.
