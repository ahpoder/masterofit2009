/*

Gate-level System-C Netlist      
Generated by
  craft System-C Compiler
  Version 3.0.0.4

*/

#include "systemc.h"
#include "craft_gatelibrary.h"

namespace craft_craft {

class SynFir : public sc_module
{
public:
   SC_HAS_PROCESS(SynFir);
   SynFir(sc_module_name name);
   sc_in<bool > clock;
   sc_in<bool > reset;
   sc_in<bool > sample_clock;
   sc_in<sc_bv<18> > in_data;
   sc_out<sc_bv<18> > out_data;
   sc_in<sc_bv<32> > in_coef0;
   sc_in<sc_bv<32> > in_coef1;
   sc_in<sc_bv<32> > in_coef2;
   sc_in<sc_bv<32> > in_coef3;
   sc_in<sc_bv<32> > in_coef4;
   sc_in<sc_bv<32> > in_coef5;
   sc_in<sc_bv<32> > in_coef6;
   sc_in<sc_bv<32> > in_coef7;
   sc_in<sc_bv<32> > in_coef8;
   sc_in<sc_bv<32> > in_coef9;
   sc_in<sc_bv<32> > in_coef10;
   sc_in<sc_bv<32> > in_coef11;
   sc_in<sc_bv<32> > in_coef12;
   sc_in<sc_bv<32> > in_coef13;
   sc_in<sc_bv<32> > in_coef14;
   sc_in<sc_bv<32> > in_coef15;
   sc_in<sc_bv<32> > in_coef16;
   sc_in<sc_bv<32> > in_coef17;
   sc_in<sc_bv<32> > in_coef18;
   sc_in<sc_bv<32> > in_coef19;
   sc_in<sc_bv<32> > in_coef20;
   sc_in<sc_bv<32> > in_coef21;
   sc_in<sc_bv<32> > in_coef22;

   sc_signal<bool > s259;
   sc_signal<bool > s260;
   sc_signal<sc_bv<18> > s264;
   sc_signal<sc_bv<18> > s290[23];
   sc_signal<sc_bv<18> > s291[23];
   sc_signal<sc_bv<32> > s293[23];
   sc_signal<sc_bv<32> > s294[23];
   sc_signal<bool > s296;
   sc_signal<bool > s297;
   sc_signal<bool > s298;
   sc_signal<bool > s299;
   sc_signal<bool > s300;
}; // end of class SynFir



} //end namespace craft_craft 

namespace craft_craft {

class SynFir_DoCalculate : public sc_module
{
public:
   SC_HAS_PROCESS(SynFir_DoCalculate);
   SynFir_DoCalculate(sc_module_name name);
   sc_in<bool > clockin_craft;
   sc_in<bool > syncreset_craft;
   sc_in<bool > asyncreset_craft;
   sc_in<bool > start_craft;
   sc_out<bool > finish_craft;
   sc_in<bool > clock;
   sc_in<bool > reset;
   sc_in<bool > sample_clock;
   sc_in<sc_bv<18> > in_data;
   sc_out<sc_bv<18> > out_data_out;
   sc_in<sc_bv<18> > out_data_prev;
   sc_in<sc_bv<18> > out_data_new;
   sc_in<sc_bv<32> > in_coef0;
   sc_in<sc_bv<32> > in_coef1;
   sc_in<sc_bv<32> > in_coef2;
   sc_in<sc_bv<32> > in_coef3;
   sc_in<sc_bv<32> > in_coef4;
   sc_in<sc_bv<32> > in_coef5;
   sc_in<sc_bv<32> > in_coef6;
   sc_in<sc_bv<32> > in_coef7;
   sc_in<sc_bv<32> > in_coef8;
   sc_in<sc_bv<32> > in_coef9;
   sc_in<sc_bv<32> > in_coef10;
   sc_in<sc_bv<32> > in_coef11;
   sc_in<sc_bv<32> > in_coef12;
   sc_in<sc_bv<32> > in_coef13;
   sc_in<sc_bv<32> > in_coef14;
   sc_in<sc_bv<32> > in_coef15;
   sc_in<sc_bv<32> > in_coef16;
   sc_in<sc_bv<32> > in_coef17;
   sc_in<sc_bv<32> > in_coef18;
   sc_in<sc_bv<32> > in_coef19;
   sc_in<sc_bv<32> > in_coef20;
   sc_in<sc_bv<32> > in_coef21;
   sc_in<sc_bv<32> > in_coef22;
   sc_out<sc_bv<18> > m_delay_line_out[23];
   sc_in<sc_bv<18> > m_delay_line_prev[23];
   sc_in<sc_bv<18> > m_delay_line_new[23];
   sc_out<sc_bv<32> > m_coeffs_out[23];
   sc_in<sc_bv<32> > m_coeffs_prev[23];
   sc_in<sc_bv<32> > m_coeffs_new[23];

   sc_signal<bool > s7;
   sc_signal<bool > s8;
   sc_signal<bool > s9;
   sc_signal<bool > s11;
   sc_signal<bool > s12;
   sc_signal<bool > s13;
   sc_signal<bool > s14;
   sc_signal<sc_bv<32> > s15;
   sc_signal<sc_bv<32> > s16;
   sc_signal<sc_bv<32> > s17;
   sc_signal<bool > s41;
   sc_signal<sc_bv<32> > s19;
   sc_signal<sc_bv<32> > s20;
   sc_signal<sc_bv<32> > s21;
   sc_signal<bool > s22;
   sc_signal<sc_bv<32> > s23;
   sc_signal<bool > s24;
   sc_signal<bool > s25;
   sc_signal<sc_bv<18> > s26;
   sc_signal<sc_bv<5> > s27;
   sc_signal<sc_bv<18> > s28;
   sc_signal<sc_bv<18> > s29;
   sc_signal<sc_bv<18> > s30[23];
   sc_signal<sc_bv<32> > s31;
   sc_signal<sc_bv<5> > s32;
   sc_signal<sc_bv<32> > s33;
   sc_signal<sc_bv<32> > s34;
   sc_signal<sc_bv<32> > s35[23];
   sc_signal<bool > s36;
   sc_signal<bool > s39;
   sc_signal<bool > s40;
   sc_signal<bool > s42;
   sc_signal<bool > s43;
   sc_signal<bool > s44;
   sc_signal<bool > s45;
   sc_signal<bool > s47;
   sc_signal<bool > s48;
   sc_signal<bool > s49;
   sc_signal<bool > s50;
   sc_signal<bool > s51;
   sc_signal<bool > s52;
   sc_signal<bool > s53;
   sc_signal<bool > s54;
   sc_signal<sc_bv<32> > s55;
   sc_signal<sc_bv<32> > s56;
   sc_signal<sc_bv<32> > s57;
   sc_signal<sc_bv<33> > s59;
   sc_signal<sc_bv<33> > s60;
   sc_signal<sc_bv<33> > s61;
   sc_signal<sc_bv<32> > s62;
   sc_signal<sc_bv<32> > s63;
   sc_signal<bool > s64;
   sc_signal<sc_bv<32> > s65;
   sc_signal<bool > s66;
   sc_signal<bool > s67;
   sc_signal<sc_bv<33> > s68;
   sc_signal<sc_bv<33> > s69;
   sc_signal<sc_bv<33> > s70;
   sc_signal<sc_bv<5> > s71;
   sc_signal<sc_bv<5> > s72;
   sc_signal<sc_bv<18> > s73;
   sc_signal<sc_bv<5> > s74;
   sc_signal<sc_bv<5> > s75;
   sc_signal<sc_bv<18> > s76;
   sc_signal<sc_bv<18> > s77;
   sc_signal<sc_bv<18> > s78[23];
   sc_signal<bool > s79;
   sc_signal<bool > s82;
   sc_signal<bool > s83;
   sc_signal<sc_bv<5> > s85;
   sc_signal<sc_bv<18> > s86;
   sc_signal<sc_bv<18> > s87;
   sc_signal<sc_bv<36> > s89;
   sc_signal<sc_bv<36> > s90;
   sc_signal<sc_bv<36> > s91;
   sc_signal<sc_bv<32> > s92;
   sc_signal<sc_bv<32> > s93;
   sc_signal<sc_bv<32> > s94;
   sc_signal<sc_bv<32> > s96;
   sc_signal<sc_bv<32> > s97;
   sc_signal<sc_bv<32> > s98;
   sc_signal<bool > s99;
   sc_signal<sc_bv<32> > s100;
   sc_signal<bool > s101;
   sc_signal<bool > s102;
   sc_signal<sc_bv<65> > s103;
   sc_signal<sc_bv<5> > s104;
   sc_signal<sc_bv<5> > s105;
   sc_signal<sc_bv<18> > s106;
   sc_signal<sc_bv<64> > s107;
   sc_signal<sc_bv<5> > s108;
   sc_signal<sc_bv<5> > s109;
   sc_signal<sc_bv<32> > s110;
   sc_signal<sc_bv<64> > s111;
   sc_signal<sc_bv<64> > s112;
   sc_signal<sc_bv<65> > s113;
   sc_signal<sc_bv<65> > s114;
   sc_signal<sc_bv<36> > s115;
   sc_signal<sc_bv<36> > s116;
   sc_signal<bool > s117;
   sc_signal<bool > s120;
   sc_signal<bool > s121;
   sc_signal<sc_bv<5> > s122;
   sc_signal<sc_bv<36> > s123;
   sc_signal<sc_bv<36> > s124;
   sc_signal<sc_bv<18> > s125;
   sc_signal<bool > s127;
   sc_signal<bool > s128;
   sc_signal<bool > s129;
   sc_signal<bool > s130;
   sc_signal<bool > s131;
   sc_signal<bool > s132;
   sc_signal<bool > s133;
   sc_signal<sc_bv<5> > s135;
   sc_signal<sc_bv<32> > s136;
   sc_signal<sc_bv<32> > s137;
   sc_signal<sc_bv<32> > s138[23];
   sc_signal<sc_bv<5> > s140;
   sc_signal<sc_bv<32> > s141;
   sc_signal<sc_bv<32> > s142;
   sc_signal<sc_bv<32> > s143[23];
   sc_signal<sc_bv<5> > s145;
   sc_signal<sc_bv<32> > s146;
   sc_signal<sc_bv<32> > s147;
   sc_signal<sc_bv<32> > s148[23];
   sc_signal<sc_bv<5> > s150;
   sc_signal<sc_bv<32> > s151;
   sc_signal<sc_bv<32> > s152;
   sc_signal<sc_bv<32> > s153[23];
   sc_signal<sc_bv<5> > s155;
   sc_signal<sc_bv<32> > s156;
   sc_signal<sc_bv<32> > s157;
   sc_signal<sc_bv<32> > s158[23];
   sc_signal<sc_bv<5> > s160;
   sc_signal<sc_bv<32> > s161;
   sc_signal<sc_bv<32> > s162;
   sc_signal<sc_bv<32> > s163[23];
   sc_signal<sc_bv<5> > s165;
   sc_signal<sc_bv<32> > s166;
   sc_signal<sc_bv<32> > s167;
   sc_signal<sc_bv<32> > s168[23];
   sc_signal<sc_bv<5> > s170;
   sc_signal<sc_bv<32> > s171;
   sc_signal<sc_bv<32> > s172;
   sc_signal<sc_bv<32> > s173[23];
   sc_signal<sc_bv<5> > s175;
   sc_signal<sc_bv<32> > s176;
   sc_signal<sc_bv<32> > s177;
   sc_signal<sc_bv<32> > s178[23];
   sc_signal<sc_bv<5> > s180;
   sc_signal<sc_bv<32> > s181;
   sc_signal<sc_bv<32> > s182;
   sc_signal<sc_bv<32> > s183[23];
   sc_signal<sc_bv<5> > s185;
   sc_signal<sc_bv<32> > s186;
   sc_signal<sc_bv<32> > s187;
   sc_signal<sc_bv<32> > s188[23];
   sc_signal<sc_bv<5> > s190;
   sc_signal<sc_bv<32> > s191;
   sc_signal<sc_bv<32> > s192;
   sc_signal<sc_bv<32> > s193[23];
   sc_signal<sc_bv<5> > s195;
   sc_signal<sc_bv<32> > s196;
   sc_signal<sc_bv<32> > s197;
   sc_signal<sc_bv<32> > s198[23];
   sc_signal<sc_bv<5> > s200;
   sc_signal<sc_bv<32> > s201;
   sc_signal<sc_bv<32> > s202;
   sc_signal<sc_bv<32> > s203[23];
   sc_signal<sc_bv<5> > s205;
   sc_signal<sc_bv<32> > s206;
   sc_signal<sc_bv<32> > s207;
   sc_signal<sc_bv<32> > s208[23];
   sc_signal<sc_bv<5> > s210;
   sc_signal<sc_bv<32> > s211;
   sc_signal<sc_bv<32> > s212;
   sc_signal<sc_bv<32> > s213[23];
   sc_signal<sc_bv<5> > s215;
   sc_signal<sc_bv<32> > s216;
   sc_signal<sc_bv<32> > s217;
   sc_signal<sc_bv<32> > s218[23];
   sc_signal<sc_bv<5> > s220;
   sc_signal<sc_bv<32> > s221;
   sc_signal<sc_bv<32> > s222;
   sc_signal<sc_bv<32> > s223[23];
   sc_signal<sc_bv<5> > s225;
   sc_signal<sc_bv<32> > s226;
   sc_signal<sc_bv<32> > s227;
   sc_signal<sc_bv<32> > s228[23];
   sc_signal<sc_bv<5> > s230;
   sc_signal<sc_bv<32> > s231;
   sc_signal<sc_bv<32> > s232;
   sc_signal<sc_bv<32> > s233[23];
   sc_signal<sc_bv<5> > s235;
   sc_signal<sc_bv<32> > s236;
   sc_signal<sc_bv<32> > s237;
   sc_signal<sc_bv<32> > s238[23];
   sc_signal<sc_bv<5> > s240;
   sc_signal<sc_bv<32> > s241;
   sc_signal<sc_bv<32> > s242;
   sc_signal<sc_bv<32> > s243[23];
   sc_signal<sc_bv<5> > s245;
   sc_signal<sc_bv<32> > s246;
   sc_signal<sc_bv<32> > s247;
   sc_signal<bool > s249;
   sc_signal<bool > s250;
   sc_signal<bool > s251;
   sc_signal<bool > s252;
   sc_signal<bool > s253;
   sc_signal<bool > s256;
   sc_signal<bool > s302;
   sc_signal<bool > s303;
   sc_signal<bool > s304;
   sc_signal<bool > s305;
   sc_signal<sc_bv<5> > s306;
   sc_signal<bool > s309;
   sc_signal<bool > s310;
   sc_signal<bool > s311;
   sc_signal<bool > s312;
   sc_signal<sc_bv<5> > s313;
   sc_signal<sc_bv<29> > s316;
   sc_signal<sc_bv<29> > s317;
   sc_signal<sc_bv<29> > s318;
   sc_signal<bool > s319;
   sc_signal<sc_bv<6> > s320;
   sc_signal<sc_bv<46> > s323;
   sc_signal<sc_bv<46> > s324;
   sc_signal<sc_bv<46> > s325;
   sc_signal<bool > s326;
   sc_signal<sc_bv<5> > s327;
   sc_signal<sc_bv<32> > s330;
   sc_signal<sc_bv<32> > s331;
   sc_signal<sc_bv<32> > s332;
   sc_signal<bool > s333;
   sc_signal<sc_bv<5> > s334;
   sc_signal<bool > s337;
   sc_signal<bool > s338;
   sc_signal<bool > s339;
   sc_signal<bool > s340;
   sc_signal<sc_bv<6> > s341;
}; // end of class SynFir_DoCalculate



} //end namespace craft_craft 



class SynFir : public sc_module
{
public:
   sc_in<bool > clock;
   sc_in<bool > reset;
   sc_in<bool > sample_clock;
   sc_in<sc_int<18> > in_data;
   sc_out<sc_int<18> > out_data;
   sc_in<sc_int<32> > in_coef0;
   sc_in<sc_int<32> > in_coef1;
   sc_in<sc_int<32> > in_coef2;
   sc_in<sc_int<32> > in_coef3;
   sc_in<sc_int<32> > in_coef4;
   sc_in<sc_int<32> > in_coef5;
   sc_in<sc_int<32> > in_coef6;
   sc_in<sc_int<32> > in_coef7;
   sc_in<sc_int<32> > in_coef8;
   sc_in<sc_int<32> > in_coef9;
   sc_in<sc_int<32> > in_coef10;
   sc_in<sc_int<32> > in_coef11;
   sc_in<sc_int<32> > in_coef12;
   sc_in<sc_int<32> > in_coef13;
   sc_in<sc_int<32> > in_coef14;
   sc_in<sc_int<32> > in_coef15;
   sc_in<sc_int<32> > in_coef16;
   sc_in<sc_int<32> > in_coef17;
   sc_in<sc_int<32> > in_coef18;
   sc_in<sc_int<32> > in_coef19;
   sc_in<sc_int<32> > in_coef20;
   sc_in<sc_int<32> > in_coef21;
   sc_in<sc_int<32> > in_coef22;

   sc_signal<sc_bv<18> > s_in_data_bv_craft;
   sc_signal<sc_bv<18> > s_out_data_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef0_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef1_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef2_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef3_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef4_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef5_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef6_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef7_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef8_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef9_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef10_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef11_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef12_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef13_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef14_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef15_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef16_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef17_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef18_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef19_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef20_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef21_bv_craft;
   sc_signal<sc_bv<32> > s_in_coef22_bv_craft;

   SC_HAS_PROCESS(SynFir);
   SynFir(sc_module_name name);
};

