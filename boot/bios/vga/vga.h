/**
 * VGA driver header for BIOS text mode.
 */

#ifndef __VGA_H
#define __VGA_H

#include <stdint.h>

/**
 * Struct representing the VGA cursor's position
 */
typedef struct VGA_Cursor
{
    int row;
    int col;
} VGA_Cursor;

/**
 * VGA text mode color attributes
 */
typedef enum VGA_Attribute
{
    BLACK,
    BLUE,
    GREEN,
    CYAN,
    RED,
    MAGENTA,
    BROWN,
    WHITE,
    GRAY,
    BRIGHT_BLUE,
    BRIGHT_GREEN,
    BRIGHT_CYAN,
    BRIGHT_RED,
    BRIGHT_MAGENTA,
    YELLOW,
    BRIGHT_WHITE,
} VGA_Attribute;

// Set the cursor position
void VGA_SetCursor(VGA_Cursor cursor);

// Get the current cursor position
VGA_Cursor VGA_GetCursor(void);

// Set the foreground and background color attributes
void VGA_SetColorAttributes(VGA_Attribute fg, VGA_Attribute bg);

// Get the color attribute byte used for VGA output
uint8_t VGA_GetColorAttributes(void);

// Clear the screen and set the cursor to (0, 0)
void VGA_ClearScreen(void);

// Scroll the screen up by 1 row
void VGA_ScrollScreen(void);

// Print a single character to the screen and advance the cursor
void VGA_PutChar(const char c);

// Print a string to the screen and advance the cursor
void VGA_Print(const char * s);

// Print a 32-bit integer to the screen
void VGA_PrintInt(int value);

// Print a 32-bit pointer to the screen in hexadecimal notation
void VGA_PrintPointer(void *ptr);

// Printf implementation for VGA output
void VGA_Printf(const char *restrict fmt, ...);

#endif // __VGA_H