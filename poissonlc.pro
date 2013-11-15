PRO poissonlc, var, dur, dt, lc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          15.11.2013
; 
; Poisson sampling of the light curve
; 
; PURPOSE  
;   - Sampling poisson light curves for background simulation
;
; INPUT 
;   - var       variance of poisson distribution
;   - dur       duration of the observation time in seconds
;   - dt        0.5^dt time resolution of the curve
;
; OUTPUT
;   - lc        light curve array with range of dur*2^dt 
;
; NOTES
;   - range+1 value is given as 1 
;   - range should be given carefully according to variance
;
; PROCEDURES
;   - poissoncdf.pro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  dtt=0.5^dt
  steps=floor(dur/dtt)
  var=var*dtt
  poissoncdf, var, 200, cdf
  limit=n_elements(cdf)-1
  n_rand=randomu(systime(1),steps)
  lc=fltarr(steps)
  
  FOR i=0,steps-1 DO BEGIN
     FOR j=0, limit DO BEGIN
        IF n_rand[i] LT cdf[j] THEN BEGIN
           lc[i]=j/dtt
           BREAK
        ENDIF
     ENDFOR
  ENDFOR
 
  plot,lc

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;