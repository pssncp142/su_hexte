PRO run,freq,psd,nsig,vstat

back_r=65D0
xuld_r=85D0
dur=2.^5D0
dt=0.5^13D0*1e6
f_dt=0.5^9D0
times=1000
ndet=1
;pure=1
;dead=20

;vstat=0
ratio=0.6
pow=-1.7
min_d=2.5
max_d=15.5
step=0.1

sim, back_r, xuld_r, dur, dt, f_dt, times, freq, psd, nsig, $
         pure=pure,$
         dead=dead,$.
         pow=pow,ratio=ratio,min_d=min_d,max_d=max_d,step=step,$
         ndet=ndet,$
         logf=logf, high=high,$
         stat=vstat, $
         chatty=chatty 

END
