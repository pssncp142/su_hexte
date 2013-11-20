PRO observe1, back_r, xuld_r, dur, dt, dead, olc, perc 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          18.11.2013
; 
;  Returns observed light curve.
;
; PURPOSE  
;   - Modelling of light curve observation
;
; INPUT 
;   - back_r    background count rate (real)
;   - xuld_r    XULD count rate
;   - dur       Duration of the observation time in seconds
;   - dt        time resolution of the curve in us
;   - dead      deadtime in miliseconds
;
; OUTPUT
;   - olc       light curve array with range of dur/(dt*1e-6) 
;   - perc      percentage between observed light curve 
;               and pure poisson light curve
;
; NOTES
;
; PROCEDURES
;   - poissonlc.pro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


poissonlc,back_r,dur,dt,back_lc
poissonlc,xuld_r,dur,dt,xuld_lc


olc=back_lc

tot_step=floor(dur/(dt*1e-6))
dead_step=floor(dead*1e3/dt)

FOR i=0,tot_step-1 DO BEGIN
   IF xuld_lc[i] GT 0 THEN BEGIN
      IF dead_step LT tot_step-i THEN BEGIN
         olc[i+1:i+dead_step]=0
         i=i+dead_step
      ENDIF ELSE IF i EQ tot_step-1 THEN BEGIN
         BREAK
      ENDIF ELSE BEGIN
         olc[i+1:tot_step-1]=0
         BREAK
      ENDELSE
   ENDIF
ENDFOR

perc=mean(olc)/mean(back_lc)*100.

;print,float(mean(olc)/mean(back_lc))*100,'%'

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
