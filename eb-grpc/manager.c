#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "dbhi-grpc.h"

int32_t hdl_request(int32_t adr, int32_t dat) {
  goWriteBlocking(request, adr, dat, 2);
  struct goReadBlocking_return msg = goReadBlocking(response, 1);
  assert(adr==msg.r0);
  return msg.r1;
}

int hdl_main() {
  GoInt32 config[] = {10, 20, 30, 40, 50};
  char k = sizeof(config)/sizeof(config[0]);

  for (int x=0; x<k ; x++) {
    int32_t adr = config[x];
    int32_t dat = (x+1)*11;
    assert(dat == hdl_request(adr, dat));
  }

  return 0;
}

int main() {
  printf("> Manager\n");
  connect_and_register();
  return hdl_main();
}
