PRO observe1, back_r, xuld_r, dur, dt, dead, olc 

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
;   - lc        light curve array with range of dur/(dt*1e-6) 
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
;help,dead_step,tot_step

FOR i=0,tot_step-1 DO BEGIN
   IF xuld_lc[i] GT 0 THEN BEGIN
      IF dead_step LT tot_step-i THEN BEGIN
         olc[i+1:i+dead_step]=0
         i=i+dead_step
      ENDIF ELSE BEGIN
         olc[i+1:tot_step-1]=0
         BREAK
      ENDELSE
   ENDIF
ENDFOR

print,float(mean(olc)/mean(back_lc))*100,'%'

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
