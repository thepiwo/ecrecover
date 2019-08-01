// -*- C -*-
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

#include "../include/ecrecover.h"

char *bin2hex(unsigned char*, int);
unsigned char *hex2bin(const char*);

#define OUTPUT_LENGTH 32

int main(int arc, char **argv)
{
  // copied from Ethereum tests
  unsigned char *input = hex2bin("47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad000000000000000000000000000000000000000000000000000000000000001b650acf9d3f5f0a2c799776a1254355d5f4061762a237396a99a0e0e3fc2bcd6729514a0dacb2e623ac4abd157cb18163ff942280db4d5caad66ddf941ba12e03");
  unsigned char *expected = "000000000000000000000000c08b5542d177ac6686946920409741463a15dddb";
  unsigned char *output = malloc(OUTPUT_LENGTH * sizeof(unsigned char));
  ecrecover(input, output);
  assert(strcmp(bin2hex(output, OUTPUT_LENGTH), expected) == 0);
  printf("Test passed\n");
}

char *bin2hex(unsigned char *p, int len)
{
    char *hex = malloc(((2*len) + 1));
    char *r = hex;

    while(len && p)
    {
        (*r) = ((*p) & 0xF0) >> 4;
        (*r) = ((*r) <= 9 ? '0' + (*r) : 'a' - 10 + (*r));
        r++;
        (*r) = ((*p) & 0x0F);
        (*r) = ((*r) <= 9 ? '0' + (*r) : 'a' - 10 + (*r));
        r++;
        p++;
        len--;
    }
    *r = '\0';

    return hex;
}

unsigned char *hex2bin(const char *str)
{
    int len, h;
    unsigned char *result, *err, *p, c;

    err = malloc(1);
    *err = 0;

    if (!str)
        return err;

    if (!*str)
        return err;

    len = 0;
    p = (unsigned char*) str;
    while (*p++)
        len++;

    result = malloc((len/2)+1);
    h = !(len%2) * 4;
    p = result;
    *p = 0;

    c = *str;
    while(c)
    {
        if(('0' <= c) && (c <= '9'))
            *p += (c - '0') << h;
        else if(('A' <= c) && (c <= 'F'))
            *p += (c - 'A' + 10) << h;
        else if(('a' <= c) && (c <= 'f'))
            *p += (c - 'a' + 10) << h;
        else
            return err;

        str++;
        c = *str;

        if (h)
            h = 0;
        else
        {
            h = 4;
            p++;
            *p = 0;
        }
    }

    return result;
}
