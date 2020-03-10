#include <iostream>
#include <dlfcn.h>

int main() {
  using std::cout;
  using std::cerr;

  void* hndl = dlopen("./core", RTLD_LAZY);
  if (!hndl) {
    cerr << "Cannot open library: " << dlerror() << '\n';
    return 1;
  }

  typedef int (*main_t)(int, char**);

  dlerror(); // reset errors
  main_t ghdl_main = (main_t) dlsym(hndl, "main");
  const char *dlsym_error = dlerror();
  if (dlsym_error) {
      cerr << "Cannot load symbol 'ghdl_main': " << dlsym_error << '\n';
      dlclose(hndl);
      return 2;
  }

  // use it to do the calculation
  cout << "Calling ghdl_main...\n";
  char* args[] = {(char*)"client"};
  ghdl_main(1, args);

  dlclose(hndl);
}