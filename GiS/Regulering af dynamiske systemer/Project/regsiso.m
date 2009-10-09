clear
s=tf('s');
G=-0.06068/((s+1.1)*s);
C=-(s+0.11)/s;
sisotool('bode',G,C)