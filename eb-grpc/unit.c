#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include "dbhi-grpc.h"

char hdl_request(int32_t* adr, int32_t* dat) {
  struct goRead_return msg = goRead(request);
  *adr = msg.r0;
  *dat = msg.r1;
  GoString err = msg.r2;

  char errstr[err.n+1];
  memcpy(errstr, err.p, err.n);
  errstr[err.n] = '\0';

  return !strcmp(errstr, "EMPTY");
}

void hdl_response(int32_t adr, int32_t dat) {
  goWriteBlocking(response, adr, dat, 4);
}

int hdl_main() {
  while (1) {
    GoInt32 adr;
    GoInt32 dat;
    char empty = hdl_request(&adr, &dat);

    if (empty) {
      printf("[UNIT] Empty! Waiting...\n");
      sleep(1);
    } else {
      printf("[UNIT] READ %d %d\n", adr, dat);
      hdl_response(adr, dat);
    }
  }
}

int main() {
  printf("> Unit\n");
  connect_and_register();
  return hdl_main();
}
