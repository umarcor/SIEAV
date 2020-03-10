#include <dlfcn.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv) {
  unsigned i;
  for ( i=0; i<argc; i++) {
      printf("> args %d: %s\n", i, argv[i]);
  }

  void* hndl = dlopen("./core",  RTLD_LAZY);
  if (!hndl){
      fprintf(stderr, "%s\n", dlerror());
      return 1;
  }

  typedef int (*main_t)(int, char**);

  dlerror(); // reset errors
  main_t ghdl_main = (main_t) dlsym(hndl, "main");
  const char *dlsym_error = dlerror();
  if (dlsym_error != NULL){
      fprintf(stderr, "Cannot load symbol 'ghdl_main': %s\n", dlsym_error);
      dlclose(hndl);
      return 2;
  }

  printf("Calling ghdl_main...\n");
  ghdl_main(1, (char*[]){"client", 0});

  dlclose(hndl);

  return 0;
}
