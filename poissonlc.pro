PRO poissonlc, var, dur, dt, rand, lc, chatty=chatty

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
  
  IF keyword_set(chatty) THEN chatty=1 ELSE chatty=0

  dtt=dt*1e-6
  steps=floor(dur/dtt)
  vart=var*(dtt)
  poissoncdf, vart, 50, cdf
  limit=n_elements(cdf)
  ;DefSysV, '!RNG', Obj_New('RandomNumberGenerator')
  ;n_rand=fltarr(steps)
  n_rand=rand->GetRandomNumbers(steps)
  n_rand=randomu(systime(1),steps)
  lc=fltarr(steps)

  FOR i=0,steps-1 DO BEGIN
     FOR j=0, limit-1 DO BEGIN
        IF n_rand[i] LT cdf[j] THEN BEGIN
           lc[i]=j
           BREAK
        ENDIF
     ENDFOR
  ENDFOR
 
  IF chatty EQ 1 THEN BEGIN
     print, '----------------------------------'
     print, 'Poisson light curve is created...'
     print, 'Variance :', float(var)
     print, 'Duration :', float(dur), ' sec'
     print, 'Time Res :', float(dt), ' usec'
     print, 'Rate     :', float(mean(lc)/dtt), ' cnt/sec'
  ENDIF

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
