#include "simple_process_ex.h"

SC_HAS_PROCESS(simple_process_ex);
simple_process_ex::simple_process_ex(sc_module_name instname)
  : sc_module(instname)
{
    SC_THREAD(my_thread_process);
    SC_THREAD(my_other_thread_process);
}

void simple_process_ex::my_thread_process(void) {
  std::cout << "my_thread_process executed within "
            << name()
            << std::endl;
}

void simple_process_ex::my_other_thread_process(void) {
  std::cout << "my_other_thread_process executed within "
            << name()
            << std::endl;
}
