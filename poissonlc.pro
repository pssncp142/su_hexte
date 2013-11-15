PRO poissonlc, var, dur, dt, lc
  
  dtt=0.5^dt
  steps=floor(dur/dtt)
  var=var*dtt
  poissoncdf, var, 20, cdf
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
