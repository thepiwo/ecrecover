// -*-C-*-
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
