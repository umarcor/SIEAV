// https://octave.org/doc/v5.1.0/Oct_002dFiles.html#Oct_002dFiles

#include <octave/oct.h>
#include <fstream>
#include <dlfcn.h>

DEFUN_DLD (axis_stage, args, nargout,
           "axis_stage('../py/args.txt', idata) where idata is an array")
{
  using std::string;
  int nargin = args.length();
  //octave_value_list retval;

  if (nargin < 2 ) {
    print_usage ();
    return octave_value(1);
  }

  string cRed      = "\033[0;31m";
  string cGreen    = "\033[0;32m";
  string cYellow   = "\033[0;33m";
  string cBlue     = "\033[0;34m";
  string cMagenta  = "\033[0;35m";
  string cCyan     = "\033[0;36m";
  string cGray     = "\033[0;37m";
  string cLRed     = "\033[0;91m";
  string cLGreen   = "\033[0;92m";
  string cLYellow  = "\033[0;93m";
  string cLBlue    = "\033[0;94m";
  string cLMagenta = "\033[0;95m";
  string cLCyan    = "\033[0;96m";
  string cLGray    = "\033[0;97m";
  string cRst      = "\033[0m";

  octave_stdout << cLBlue + "'axis_stage' has " << nargin << " input arguments." << cRst << "\n";

//>> Get location of args.txt as first arg to the octave function
// https://octave.org/doc/v4.4.1/Character-Strings-in-Oct_002dFiles.html
  string argstxt = args(0).char_matrix_value().row_as_string(0);

  if (error_state)
    return octave_value(2);
//<<

//>> Read CLI arguments for ghdl_main from txt file
  octave_stdout << cMagenta << "Reading CLI arguments from txt file..." << cRst << "\n";

  using std::ifstream;
  using std::list;

  // Read txt file
  list<string> lines;
  lines.clear();
  ifstream file(argstxt);
  string s;
  while (getline(file, s))
    lines.push_front(s);

  // Allocate gargs
  int ngargin = lines.size();
  char* gargs[ngargin];

  octave_stdout << cLBlue << "ngargin: " << ngargin << cRst << "\n";

  // Convert 'lines' (list of strings) to 'gargs' (array of char*)
  int i = 0;
  for (auto it=lines.rbegin(); it!=lines.rend(); ++it, ++i) {
    gargs[i] = new char[it->size()];
    strcpy(gargs[i], it->c_str());

    octave_stdout << cLBlue << "  " << i << ": " << cRst << gargs[i] << '\n';
  }
  octave_stdout << '\n';
//<<

//>> Prepare shared buffers (params, idata and odata)
  // https://octave.org/doc/v4.4.1/Matrices-and-Arrays-in-Oct_002dFiles.html
  int32NDArray a = args(1).int32_array_value ();
  unsigned nidat = a.numel();
  int32_t* idata = new int32_t[nidat];
  for ( i = 0 ; i < nidat ; i++ )
    idata[i] = a(i);
  /*
  for ( i = 0 ; i < nidat ; i++ ) {
    octave_stdout << idata[i] << '\n';
  }
  */

  // Initialize 'params' array
  int32_t params[5];
  params[0] = INT32_MIN+10;
  params[1] = INT32_MIN;
  params[2] = 3;          // clk_step
  params[3] = 0;          // update
  params[4] = nidat;      // block_length

  // Allocate buffer for output data
  int32_t odata[nidat] = {0};
//<<

//>> Dynamically load ghdl design binary and execute 'octave'
  using std::cerr;

  void* hndl = dlopen(gargs[0], RTLD_LAZY);
  if (!hndl) {
    cerr << cRed << "Cannot open library: " << dlerror() << cRst << '\n';
    return octave_value(3);
  }

  const char *dlsym_error;

  typedef int (*main_t)(int, char**);
  dlerror(); // reset errors
  main_t oct_main = (main_t) dlsym(hndl, "oct_main");
  dlsym_error = dlerror();
  if (dlsym_error) {
    cerr << cRed << "Cannot load symbol 'oct_main': " << dlsym_error << cRst << '\n';
    dlclose(hndl);
    return octave_value(4);
  }

  typedef void (*set_string_ptr_t)(uint8_t id, uintptr_t p);
  dlerror(); // reset errors
  set_string_ptr_t set_string_ptr = (set_string_ptr_t) dlsym(hndl, "set_string_ptr");
  dlsym_error = dlerror();
  if (dlsym_error) {
    cerr << cRed << "Cannot load symbol 'set_string_ptr': " << dlsym_error << cRst << '\n';
    dlclose(hndl);
    return octave_value(4);
  }

  set_string_ptr(0, (uintptr_t)params);
  set_string_ptr(1, (uintptr_t)idata);
  set_string_ptr(2, (uintptr_t)odata);

  octave_stdout << cMagenta << "Executing main..." << cRst << "\n";
  oct_main(ngargin, gargs);

  dlclose(hndl);
//<<

  octave_stdout << cLBlue << "'axis_stage' has " << nargout << " output arguments." << cRst << "\n";

  return octave_value(0);
}
