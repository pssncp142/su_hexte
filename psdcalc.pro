PRO psdcalc, lc, dt, psd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          15.11.2013
; 
; Calculates PSD function from the light curve
;
; PURPOSE
;
; INPUT 
;   - lc        light curve
;   - dt        0.5^dt time resolution of the curve
;               (necessary to adjust photon count)
;
; OUTPUT
;   - psd       PSD function  
;
; NOTES
;   - PSD contains all freguencies it can be adjusted later in psdrebin.pro. 
;   - Leahy normalization is applied.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
     R=mean(lc)
     psdt=fft(lc,/double)
     psd=abs(psdt)^2*(2./R*dt)

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
