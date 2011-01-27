#ifndef __MEM_H
#define __MEM_H

extern unsigned char* memcpy(unsigned char* dest, const unsigned char* src, int count);
extern unsigned char* memset(unsigned char* dest, unsigned char val, int count);
extern unsigned short* memsetw(unsigned short* dest, unsigned short val, int count);
extern unsigned int strlen(unsigned char* str);

#endif
