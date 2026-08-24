/**
 * VGA driver source code for BIOS text mode
 */
#include "vga.h"

#include <stdint.h>
#include <stddef.h>

static const int SCREEN_WIDTH = 80;
static const int SCREEN_HEIGHT = 25;

// Const pointer to VGA framebuffer memory in RAM.
// This is specific to VGA text mode 02h.
static void *const VGA_FRAMEBUFFER = (void *)0xb8000;

// Current cursor position
static VGA_Cursor _cursor = {0, 0};

// Current text mode color attribute used when printing to the screen
static uint8_t VGA_COLOR_ATTRIBUTE = 0x07;

void VGA_SetCursor(VGA_Cursor cursor)
{
    _cursor = cursor;
}

VGA_Cursor VGA_GetCursor(void)
{
    return _cursor;
}

void VGA_SetColorAttributes(VGA_Attribute fg, VGA_Attribute bg)
{
    VGA_COLOR_ATTRIBUTE = (((uint8_t)bg) << 4) | (uint8_t)fg;
}

uint8_t VGA_GetColorAttributes(void)
{
    return VGA_COLOR_ATTRIBUTE;
}

void VGA_ClearScreen(void)
{
    // Text-attribute pair representing a space character
    uint16_t text_attr = ((uint16_t)VGA_COLOR_ATTRIBUTE << 8) | (uint16_t)' ';

    for (int i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++)
    {
        ((uint16_t *)VGA_FRAMEBUFFER)[i] = text_attr;
    }

    _cursor = (VGA_Cursor){0, 0};
}

void VGA_ScrollScreen(void)
{
    // It's probably better to use some form of a memcpy here (maybe with SSE support to speed it up)
    // but a simple loop can work as well.
    for (int i = SCREEN_WIDTH; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++)
    {
        ((uint16_t *)VGA_FRAMEBUFFER)[i - SCREEN_WIDTH] = ((uint16_t *)VGA_FRAMEBUFFER)[i];
    }

    // Also move the cursor up one row
    _cursor.row--;
    // In case the cursor goes outside of the screen, move it back to (0, 0)
    if (_cursor.row < 0)
    {
        _cursor.row = 0;
        _cursor.col = 0;
    }
}

void VGA_PutChar(const char c)
{
    // Move the cursor to the next line if a newline is read
    if (c == '\n')
    {
        _cursor.row++;
        _cursor.col = 0;
        if (_cursor.row >= SCREEN_HEIGHT)
        {
            VGA_ScrollScreen();
        }
        return;
    }

    uint16_t text_attr = ((uint16_t)VGA_COLOR_ATTRIBUTE << 8) | (uint16_t)c;
    ((uint16_t *)VGA_FRAMEBUFFER)[_cursor.row * SCREEN_WIDTH + _cursor.col] = text_attr;

    // Update the cursor
    _cursor.col++;
    if (_cursor.col >= SCREEN_WIDTH)
    {
        _cursor.col = 0;
        _cursor.row++;
        if (_cursor.row >= SCREEN_HEIGHT)
        {
            VGA_ScrollScreen();
        }
    }
}

void VGA_Print(const char *restrict s)
{
    size_t i = 0;
    while (s[i])
    {
        VGA_PutChar(s[i]);
        i++;
    }
}