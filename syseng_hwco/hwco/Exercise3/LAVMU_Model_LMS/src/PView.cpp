//----------------------------------------------------------------------------------------------
// PView.cpp (systemc)
//
//	Author: KBE / 2010.09.12
//----------------------------------------------------------------------------------------------
#include <systemc.h>
#include "PView.h"
 
void PView::SetConvergenceFactor(void)
{
	// Set coefficients in algo
	set_converg.write(131);
}

PView::PView(sc_module_name nm) :
	sc_module(nm)
{
	SetConvergenceFactor();
}
