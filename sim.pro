PRO sim, back_r, xuld_r, dur, dt, f_dt, times, freq, psd, $
         nsig, $
         pure=vpure,$
         dead=vdead,$
         pow=vpow,min_d=vmin_d,max_d=vmax_d,step=vstep,$
         ndet=vndet,$
         logf=vlogf, high=vhigh,$
         chatty=chatty 
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar            27.11.2013
;
; Peforms the same observation n times considering options given. For
; each light curve, PSD function is calculated separately. Then mean value
; of the psd function in each discrete frequency is rebinned.  
;
; PURPOSE
;   - Modelling HEXTE ligth curves with dead time events.
;
; INPUT
;   - back_r    Background count rate (real)
;   - xuld_r    XULD count rate
;   - dur       Duration of the observation time in seconds
;   - dt        Time resolution of the curve in us
;   - f_dt      Rebin interval of the light curve in seconds
;   - times     # of observation in PSD 
;
; OPTIONAL INPUTS
;   - ndet      # of detectors included into observation
;
;   - For pure poisson light curve
;   1 :  pure      KEYWORD
;         
;   - For constant deadtime simulation
;   2 :  dead      Constant deadtime
;
;   - For power law distributed cosmic background
;   3 :  pow       Power of the power law distribution
;     :  min_d     Minimum deadtime
;     :  max_d     Maximum deadtime
;     :  step      Step size to calculate distribution
;
;   - Frequency binning options
;     : linf       Linear binning interval (default=0.12)
;     : high       High frequency limit (default=128D0)
;
; OUTPUT
;   - freq     Frequence array
;   - psd      Binned PSD function
;
; PROCEDURES
;   - observe1.pro
;   - freqrebin.pro (exclusive)
;   - randomnumbergenerator_define.pro (exclusive)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  DefSysV, '!RNG', Obj_New('RandomNumberGenerator')

  IF keyword_set(vpure) THEN pure=vpure ELSE pure=0
  IF keyword_set(vdead) THEN dead=vdead ELSE dead=0
  IF keyword_set(vpow) THEN pow=vpow ELSE pow=0
  IF keyword_set(vmin_d) THEN min_d=vmin_d ELSE min_d=0
  IF keyword_set(vmax_d) THEN max_d=vmax_d ELSE max_d=0
  IF keyword_set(vstep) THEN step=vstep ELSE step=0
  IF keyword_set(vndet) THEN ndet=vndet ELSE ndet=0

  start=systime(1)

  FOR i=0,times DO BEGIN
     observe1, back_r, xuld_r, dur, dt, f_dt, !RNG, rblc, psd, $
               pure=pure,$
               dead=dead,$
               pow=pow,min_d=min_d,max_d=max_d,step=step,$
               ndet=ndet,$
               chatty=0
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     p=floor(100.*i/times)
     print,string(10B)+string(27B)+'[1A',format='(A, $)'
     x='['
     for j=0,p/2 DO x=x+'*'
     for j=1,50-p/2 DO x=x+' '
     print,x,format='(A,":",$)'
     print,p,format='(I5,"%]  EL :",$)'
     IF i NE 0 THEN BEGIN 
        print,(systime(1)-start)*(100.-p)/p,format='(I4,"/ TOT :",$)'
        print,(systime(1)-start)*100./p,format='(I4,$)'
     ENDIF
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     IF i EQ 0 THEN BEGIN
        psd_t=psd
     ENDIF ELSE BEGIN
        psd_t=(psd_t*i+psd)/(i+1)
     ENDELSE

  ENDFOR

  psd_t=psd_t[1:floor(n_elements(psd)*0.5)+1]
  length=floor(n_elements(psd)*0.5)
  f=(findgen(length)+1)/dur

  freqrebin,f,psd_t,freq,psd,nsig,osig,logf=0.12,high=128D0

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
