#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "dbhi-grpc.h"

extern int ghdl_main(int argc, void** argv);

int32_t hdl_request(int32_t adr, int32_t dat) {
  goWriteBlocking(request, adr, dat, 2);
  struct goReadBlocking_return msg = goReadBlocking(response, 1);
  assert(adr==msg.r0);
  return msg.r1;
}

int main(int argc, void** argv) {
  printf("> Manager\n");
  connect_and_register();
  return ghdl_main(argc, argv);
}
