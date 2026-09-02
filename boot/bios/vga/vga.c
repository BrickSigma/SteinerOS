/**
 * VGA driver source code for BIOS text mode
 */
#include "vga.h"

#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>

static const int SCREEN_WIDTH = 80;
static const int SCREEN_HEIGHT = 25;

// Const pointer to VGA framebuffer memory in RAM.
// This is specific to VGA text mode 02h.
static void *const VGA_FRAMEBUFFER = (void *)0xb8000;

// Pointer to BIOS cursor's position
static VGA_Cursor *_cursor = (void *)0x500;

// Current text mode color attribute used when printing to the screen
static uint8_t VGA_COLOR_ATTRIBUTE = 0x07;


void VGA_SetCursor(VGA_Cursor cursor)
{
    *_cursor = cursor;
}


VGA_Cursor VGA_GetCursor(void)
{
    return *_cursor;
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

    *_cursor = (VGA_Cursor){0, 0};
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
    _cursor->row--;
    // In case the cursor goes outside of the screen, move it back to (0, 0)
    if (_cursor->row < 0)
    {
        _cursor->row = 0;
        _cursor->col = 0;
    }
}


void VGA_PutChar(const char c)
{
    // Move the cursor to the next line if a newline is read
    if (c == '\n')
    {
        _cursor->row++;
        _cursor->col = 0;
        if (_cursor->row >= SCREEN_HEIGHT)
        {
            VGA_ScrollScreen();
        }
        return;
    }

    uint16_t text_attr = ((uint16_t)VGA_COLOR_ATTRIBUTE << 8) | (uint16_t)c;
    ((uint16_t *)VGA_FRAMEBUFFER)[_cursor->row * SCREEN_WIDTH + _cursor->col] = text_attr;

    // Update the cursor
    _cursor->col++;
    if (_cursor->col >= SCREEN_WIDTH)
    {
        _cursor->col = 0;
        _cursor->row++;
        if (_cursor->row >= SCREEN_HEIGHT)
        {
            VGA_ScrollScreen();
        }
    }
}


void VGA_Print(const char * s)
{
    size_t i = 0;
    while (s[i])
    {
        VGA_PutChar(s[i]);
        i++;
    }
}


void VGA_PrintInt(int value)
{
    if (value == 0)
    {
        VGA_PutChar('0');
        return;
    }

    if (value < 0)
    {
        VGA_PutChar('-');
        return;
    }

    // Buffer to store each character to print, designed for 32-bit integers
    char buffer[10];

    int buffer_len = 0;
    while (value != 0 && buffer_len < 10)
    {
        int digit = value % 10;
        value /= 10;
        buffer[buffer_len] = digit + '0';
        buffer_len++;
    }

    // Print each digit from the buffer in reverse order
    for (int i = buffer_len - 1; i >= 0; i--)
    {
        VGA_PutChar(buffer[i]);
    }
}

static const char HEX_CHARS[] = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
};

void VGA_PrintPointer(void *ptr)
{
    VGA_Print("0x");
    for (int8_t i = 7; i >= 0; i--)
    {
        uint32_t value = (uint32_t)ptr;
        value >>= i*4;
        value &= 0xf;
        VGA_PutChar(HEX_CHARS[value]);
    }
}

void VGA_Printf(const char *restrict fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);

    size_t i = 0;
    while (fmt[i])
    {
        switch (fmt[i])
        {
            case '%':
                i++;
                switch (fmt[i])
                {
                    case 'c':
                        char char_arg = (char)va_arg(ap, int);
                        VGA_PutChar(char_arg);
                        break;
                    case 'd':
                        int int_arg = va_arg(ap, int);
                        VGA_PrintInt(int_arg);
                        break;
                    case 'p':
                        void *ptr_arg = va_arg(ap, void *);
                        VGA_PrintPointer(ptr_arg);
                        break;
                    case 's':
                        char *string_arg = va_arg(ap, char *);
                        VGA_Print(string_arg);
                        break;
                }
                break;

            default:
                VGA_PutChar(fmt[i]);
                break;
        }
        i++;
    }

    va_end(ap);
}