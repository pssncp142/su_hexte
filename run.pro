PRO run,freq,psd,nsig

back_r=100.
xuld_r=100.
dur=2.^5
dt=8
f_dt=0.5^9
times=200
ndet=1
;pure=1
dead=2.5

;pow=-1.8
;min_d=2.5
;max_d=6.5
;step=1.2

sim, back_r, xuld_r, dur, dt, f_dt, times, freq, psd, nsig, $
         pure=pure,$
         dead=dead,$
         pow=pow,min_d=min_d,max_d=max_d,step=step,$
         ndet=ndet,$
         logf=logf, high=high,$
         chatty=chatty 

END
