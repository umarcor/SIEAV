#include <stdio.h>
#include "sim.c"

void main(){
  float rk[] = {0.75, 0.5, 1};
  float vk = 0.0;
  float uk = 0.0;

  int x, z;
  int y = 0;

  for ( z=0 ; z<3 ; z++ ) {
    for ( x=0 ; x<250 ; x++ ) {
      if ( y == 0 ) {
        uk = Controller(rk[z] - vk);
      }
      vk = Motor(uk);
      printf("%f %f %f\n", rk[z], uk, vk);
      y = y>8 ? 0 : ++y;
    }
  }
}
