#include <string.h>
#include <libgrpc-go.h>

GoString cgo_str(char *s) {
  GoString id = {s, strlen(s)};
  return id;
}

GoString request;
GoString response;

void connect_and_register() {
  goConnect(cgo_str(":8888"));
  request = cgo_str("request");
  response = cgo_str("response");
  GoString ids[] = {request, response};
  char n = sizeof(ids)/sizeof(ids[0]);
  GoSlice l = {ids, n, n};
  goRegister(l);
}
