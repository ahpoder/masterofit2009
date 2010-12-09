#include "simple_process_ex.h"
int sc_main(int argc, char* argv[]) {
  simple_process_ex my_instance("my_instance");
  cout << "Elaboration done, beginning simulation" << std::endl;
  sc_start();
  return 0;
}
