#ifndef SIMPLE_PROCESS_EX_H
#define SIMPLE_PROCESS_EX_H
#include <systemc.h>
SC_MODULE(simple_process_ex) {
  simple_process_ex(sc_module_name instname);
  void my_thread_process(void);
  void my_other_thread_process(void);
};
#endif

