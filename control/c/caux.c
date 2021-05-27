#include <stdlib.h>
#include <stdint.h>

double params[4] = {
  0.0,  // Ref
  2.0,  // Kp
  1.5,  // Ki
  0.001 // Kd
};

double trajectory[] = {0.15, 0.5, 1.5, 0.75, 1, 0.25};
uint8_t idx = 0;

void handleInterrupt(void) {
  params[0] = trajectory[idx++];
}

// Utility, for binding an VHDL access to the C pointer
uintptr_t getParamsPtr(void) {
  return (uintptr_t)params;
}
