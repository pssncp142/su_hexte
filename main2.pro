PRO main2,res 

back_r=100.
xuld_r=60.
dur=32.
dt=128.
dead=2.5
times=1000
times2=21
step=5.

tres=fltarr(times)
res=fltarr(times2,2)

FOR j=0,times2-1 DO BEGIN
   FOR i=0,times-1 DO BEGIN
      observe1,back_r, xuld_r+j*step, dur, dt, dead, olc, perc 
      tres[i]=perc
   ENDFOR 
   res[j,0]=mean(tres)
   res[j,1]=mean(tres)/sqrt(times)
   print,j,xuld_r+j*step,res[j,0],res[j,1]
ENDFOR

END
