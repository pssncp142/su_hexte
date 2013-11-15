PRO psdcalc, lc, dt, psd
  
  shape=size(lc)
  print,shape
  dtt=0.5^dt
  FOR i=0,shape[1]-1 DO BEGIN
     R=mean(lc[i,*])/dtt
     IF i EQ 0 THEN BEGIN
        psdt=fft(lc[i,*])
        psd=abs(psdt[1:-1])^2*shape[2]*(2./R)/shape[1]
     ENDIF ELSE BEGIN
        psdt=fft(lc[i,*])
        psdt[1:-1]=abs(psdt[1:-1])^2*shape[2]*(2./R)/shape[1]
        psd=psd+float(psdt[1:-1])
     ENDELSE
  ENDFOR
  
  print,mean(psd)

END
