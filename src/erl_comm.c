// -*- C -*-

#include "erl_comm.h"

#include <unistd.h>

int read_cmd(byte *buf)
{
  int len;

  if (read_exact(buf, 2) != 2)
    return(-1);
  len = (buf[0] << 8) | buf[1];
  DEBUG_PRINTF("Len is %d\n", len);
  if(len > ECRECOVER_BUFFER_MAX - 1) {
    DEBUG_PRINTF("Avoiding overflow\n");
    return 0; // let's not overflow.
  }
  int read = read_exact(buf, len);
  DEBUG_PRINTF("read_cmd returning %d\n", read);
  return read;
}

int write_cmd(byte *buf, int len)
{
  byte li;

  li = (len >> 8) & 0xff;
  write_exact(&li, 1);

  li = len & 0xff;
  write_exact(&li, 1);

  return write_exact(buf, len);
}

int read_exact(byte *buf, int len)
{
  int i, got=0;
  DEBUG_PRINTF("Read exact\n");
  do {
    if ((i = read(0, buf+got, len-got)) <= 0) {
      DEBUG_PRINTF("got=%d len=%d i=%d\n", got, len, i);
      return(i);
    }
    got += i;
  } while (got<len);
  DEBUG_PRINTF("Read %d returning %d\n", got, len);
  return(len);
}

int write_exact(byte *buf, int len)
{
  int i, wrote = 0;

  do {
    if ((i = write(1, buf+wrote, len-wrote)) <= 0)
      return (i);
    wrote += i;
  } while (wrote<len);

  return (len);
}
