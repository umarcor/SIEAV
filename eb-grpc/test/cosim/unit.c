#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include "dbhi-grpc.h"

extern int ghdl_main(int argc, void** argv);

char hdl_request(int32_t* req) {
  struct goRead_return read = goRead(request);
  req[0] = read.r0;
  req[1] = read.r1;
  GoString err = read.r2;
  // Go strings are not null-terminated, hence, we need to append '\0' to use strcmp.
  char errstr[err.n+1];
  memcpy(errstr, err.p, err.n);
  errstr[err.n] = '\0';
  return !strcmp(errstr, "EMPTY");
}

void hdl_response(int32_t adr, int32_t dat) {
  goWriteBlocking(response, adr, dat, 2);
}

int main(int argc, void** argv) {
  printf("> Unit\n");
  connect_and_register();
  return ghdl_main(argc, argv);
}
