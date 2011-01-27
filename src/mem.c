#include "mem.h"

// these functions are inherently vulnerable to buffer overflow, of course

unsigned char* memcpy(unsigned char* dest, const unsigned char* src, int count)
{
  unsigned int offset;

  while (count > 0) {
    dest[offset] = src[offset];
    offset++;
    count--;
  }
  return dest;
}

unsigned char* memset(unsigned char* dest, unsigned char val, int count)
{
  unsigned int offset;
  
  while (count > 0) {
    dest[offset] = val;
    offset++, count--;
  }
  return dest;
}

unsigned short* memsetw(unsigned short* dest, unsigned short val, int count)
{
  unsigned int offset;
  
  while (count > 0) {
    dest[offset] = val;
    offset++, count--;
  }
  return dest;
}

unsigned int strlen(unsigned char* str)
{
  unsigned int l = 0;
  while (str[l] != '\0') l++;
  return l;
}

unsigned char * strcpy(unsigned char* dest, const unsigned char* src)
{
    unsigned int offset;
    while (src[offset] != '\0') {
	dest[offset] = src[offset];
	offset++;
    }
    return dest;
}
