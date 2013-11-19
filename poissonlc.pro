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
;   - var       variance of poisson distribution for one second
;   - dur       duration of the observation time in seconds
;   - dt        time resolution of the curve in us
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
  
  dtt=dt*1e-6
  steps=floor(dur/dtt)
  vart=var*(dtt)
  poissoncdf, vart, 200, cdf
  limit=n_elements(cdf)-1
  n_rand=randomu(systime(1),steps)
  lc=fltarr(steps)
  ;print,steps

  FOR i=0,steps-1 DO BEGIN
     FOR j=0, limit DO BEGIN
        IF n_rand[i] LT cdf[j] THEN BEGIN
           lc[i]=j/dtt
           BREAK
        ENDIF
     ENDFOR
  ENDFOR
 
  ;print, '----------------------------------'
  ;print, 'Poisson light curve is created...'
  ;print, 'Variance :', float(var)
  ;print, 'Duration :', float(dur), ' sec'
  ;print, 'Time Res :', float(dt), ' usec'
  ;print, 'Rate     :', float(mean(lc)), ' cnt/sec'

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
