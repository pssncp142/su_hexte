PRO run,freq,psd,nsig

back_r=100D0
xuld_r=80D0
dur=2.^5D0
dt=0.5^13D0*1e6
f_dt=0.5^9D0
times=5000
ndet=1
;pure=1
;dead=2.5

ratio=0.1
pow=-1.72
min_d=2.5
max_d=50.5
step=0.2

sim, back_r, xuld_r, dur, dt, f_dt, times, freq, psd, nsig, $
         pure=pure,$
         dead=dead,$
         pow=pow,ratio=ratio,min_d=min_d,max_d=max_d,step=step,$
         ndet=ndet,$
         logf=logf, high=high,$
         chatty=chatty 

END
