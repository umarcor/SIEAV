/*
This source file is used for both string/byte_vector and integer_vector.
Accordingly, TYPE must be defined as uint8_t or int32_t during compilation.
Keep in mind that the buffer (D) is of type uint8_t*, independently of TYPE, i.e.
accesses are casted.
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <limits.h>
#include "vhpidirect_user.h"

uint32_t length = 5;

/*
 *
  Standalone
*
*/

//Check procedure, to be executed when ghdl_main in main exits.
static void exit_handler(void) {
  unsigned i, j, z, k;
  TYPE expected, got;
  k = 0;
  for (j=0; j<3; j++) {
    k += j;
    for(i=0; i<length; i++) {
      z = (length*j)+i;

      expected = (i+1)*11 + k;
      got = ((TYPE*)D[1])[z];
      if (expected != got) {
        printf("check error %d: %d %d\n", z, expected, got);
        exit(1);
      }
      printf("%d: %d\n", z, got);
    }
  }
  free(D[0]);
  free(D[1]);
}

// Main entrypoint of the application
int main(int argc, char **argv) {
  printf("argc: %d\n", argc);
  // Print cli args
  unsigned i;
  for ( i=0; i<argc; i++) {
    printf("  %d: %s\n", i, argv[i]);
  }

  // Allocate a buffer for 'params'
  D[0] = (uint8_t *) malloc(5*sizeof(int32_t));
  if ( D[0] == NULL ) {
    perror("execution of malloc() failed!\n");
    return -1;
  }

  // Initialize 'params' array
  int32_t *P = (int32_t*)D[0];
  P[0] = INT_MIN+10;
  P[1] = INT_MIN;
  P[2] = 3;          // clk_step
  P[3] = 0;          // update
  P[4] = length;     // block_length


  // Allocate a buffer which is twice times the number of values
  // that we want to copy/modify
  D[1] = (uint8_t *) malloc(2*length*sizeof(TYPE));
  if ( D[1] == NULL ) {
    perror("execution of malloc() failed!\n");
    return -1;
  }

  // The output buffer is an alias/cast of the second half of the input buffer
  D[2] = (uint8_t *) &(((TYPE*)D[1])[length]);

  // Initialize the first 1/2 of the buffer
  for(i=0; i<length; i++) {
    ((TYPE*)D[1])[i] = (i+1)*11;
  }

  // Print all the buffer
  printf("sizeof: %lu\n", sizeof(TYPE));
  for(i=0; i<length; i++) {
    printf("%d: %d %d\n", i, ((TYPE*)D[1])[i], ((TYPE*)D[2])[i]);
  }

  // Register a function to be called when GHDL exits
  atexit(exit_handler);

  // Start the simulation
  return ghdl_main(argc, argv);
}

/*
 *
  Octave
*
*/

//Check procedure, to be executed when ghdl_main in oct_main exits.
static void oct_exit_handler(void) {
  // Print buffers
  unsigned i;
  for(i=0; i<length; i++) {
    printf("%d: %d %d\n", i, ((TYPE*)D[1])[i], ((TYPE*)D[2])[i]);
  }
}

// Main entrypoint for the *.oct plugin
int oct_main(int argc, char **argv) {
  printf("argc: %d\n", argc);
  // Print cli args
  unsigned i;
  for ( i=0; i<argc; i++) {
    printf("  %d: %s\n", i, argv[i]);
  }

  // Print 'params' array
  int32_t *P = (int32_t*)D[0];
  printf("param 0: %d\n", P[0]);
  printf("param 1: %d\n", P[1]);
  printf("param 2 (clk_step): %d\n", P[2]);
  printf("param 3 (update): %d\n", P[3]);
  printf("param 4 (block_len): %d\n", P[4]);
  length = P[4];     // block_length

  // Print buffers
  printf("sizeof: %lu\n", sizeof(TYPE));
  for(i=0; i<length; i++) {
    printf("%d: %d %d\n", i, ((TYPE*)D[1])[i], ((TYPE*)D[2])[i]);
  }

  // Register a function to be called when ghdl exits
  atexit(oct_exit_handler);

  // Start the simulation
  return ghdl_main(argc, argv);
}