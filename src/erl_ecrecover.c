// -*- C -*-
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

#include "ecrecover.h"
#include "erl_comm.h"
#include "base64.h"

#define OUTPUT_LENGTH 32

int main(int arc, char **argv)
{
  int fn, arg, len;
  byte buf[ECRECOVER_BUFFER_MAX];

  while ((len = read_cmd(buf)) > 0) {
    DEBUG_PRINTF("len %d\n", len);
    fn = buf[0];
    DEBUG_PRINTF("Function %d len %d\n", fn, len);
    buf[len] = '\0';
    if (fn == 1) {
      int result;
      byte *input = hex2bin(buf+1);
      byte *output = malloc(ECRECOVER_BUFFER_MAX);
      result = ecrecover(input, output);
      free(input);
      DEBUG_PRINTF("Return value is %d", result);
      if(result) {
	byte *hex_result = bin2hex(output, OUTPUT_LENGTH);
	strcpy(buf, hex_result);
	free(hex_result);
	DEBUG_PRINTF("result is %s len %ld\n", buf, strlen(buf));
      } else {
	strcpy("failed", buf);
      }
      free(output);
   } else {
      strcpy("function not found", buf);
    }
    DEBUG_PRINTF("Returning %s\n", buf);
    write_cmd(buf, strlen(buf));
  }
}
