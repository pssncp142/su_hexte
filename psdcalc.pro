PRO psdcalc, seglc, dt, psd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          15.11.2013
; 
; Calculates PSD function from the segmented light curve
;
; PURPOSE
;
; INPUT 
;   - seglc     Segmented light curve from divseg.pro
;   - dt        0.5^dt time resolution of the curve
;               (necessary to adjust photon count)
;
; OUTPUT
;   - psd       PSD function  
;
; NOTES
;   - PSD contains all freguencies it can be adjested later in psdrebin.pro. 
;   - Leahy normalization is applied.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  shape=size(seglc)
  dtt=0.5^dt
  FOR i=0,shape[1]-2 DO BEGIN
     R=mean(seglc[i,*])
     print,R,total(seglc[i,*])
     print,dtt,R,shape[1],shape[2]
     IF i EQ 0 THEN BEGIN
        psdt=fft(seglc[i,*])
        psd=abs(psdt[0:-1])^2*(2./R*2^5.)
     ENDIF ELSE BEGIN
        psdt=fft(seglc[i,*])
        psdt[1:-1]=abs(psdt[1:-1])^2*shape[2]*(2./R)/shape[1]
        psd=psd+float(psdt[1:-1])
     ENDELSE
  ENDFOR

  print, '----------------------------------'  
  print, 'Leahy normalized PSD function...'

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
