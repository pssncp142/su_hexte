PRO observe1, back_r, xuld_r, dur, dt, olc, perc, $
              dead=vdead,$
              pow=vpow,min_d=vmin_d,max_d=vmax_d,step=vstep,$
              chatty=chatty 

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
;
; OPTIONAL INPUTS
;   1 :  dead      constant deadtime
;
;   2 :  pow       power of the power law distribution
;     :  min_d     minimum deadtime
;     :  max_d     maximum deadtime
;     :  step      step size to calculate distribution
;     
; OUTPUT
;   - olc       light curve array with range of dur/(dt*1e-6) 
;   - perc      percentage between observed light curve 
;               and pure poisson light curve
;
; NOTES
;   - NOT SURE IF POWER LAW WORKS
;
; PROCEDURES
;   - poissonlc.pro
;   - xulddist.pro
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on_error,2

IF keyword_set(chatty) THEN chatty=1 ELSE chatty=0
IF keyword_set(vdead) THEN BEGIN 
   opt=1
   dead=vdead 
   IF chatty EQ 1 THEN print,'Constant deadtime option with',$
                             float(dead),' milisec'
ENDIF ELSE IF keyword_set(vpow) AND keyword_set(vmin_d) AND $
   keyword_set(vmax_d) AND keyword_set(vstep) THEN BEGIN
   opt=2
   pow=vpow
   min_d=vmin_d
   max_d=vmax_d
   step=vstep
   IF chatty EQ 1 THEN BEGIN
      print,'Power law deadtime distribution option with'
      print,'- Power        :',float(pow)
      print,'- Min deadtime :',float(min_d),' milisec'
      print,'- Max deadtime :',float(max_d),' milisec'
      print,'- Step size    :',float(step),' milisec'
   ENDIF
ENDIF ELSE BEGIN
   message,'Choose whether constant or power law deadtime'
ENDELSE

poissonlc,back_r,dur,dt,back_lc,chatty=chatty
poissonlc,xuld_r,dur,dt,xuld_lc,chatty=chatty

olc=back_lc

tot_step=floor(dur/(dt*1e-6))

IF opt EQ 1 THEN BEGIN

   dead_step=floor(dead*1e3/dt)
   FOR i=0,tot_step-1 DO BEGIN

      IF xuld_lc[i] GT 0 THEN BEGIN
         IF dead_step LT tot_step-i THEN BEGIN
            olc[i+1:i+dead_step]=0
            i=i+dead_step
         ENDIF ELSE IF i EQ tot_step-1 THEN BEGIN
            olc[i]=0
            BREAK
         ENDIF ELSE BEGIN
            olc[i+1:tot_step-1]=0
            BREAK
         ENDELSE
      ENDIF

   ENDFOR

ENDIF ELSE BEGIN

   xulddist, pow, min_d, max_d, step, dist
   steps=size(dist)
   steps=steps[2]
   n_rand=randomu(systime(1),tot_step)
   cnt=0

   FOR i=0,tot_step-1 DO BEGIN

      IF xuld_lc[i] GT 0 THEN BEGIN

         cnt=cnt+1
         dead_step=0
         FOR j=0,steps-1 DO BEGIN
            IF dist[1,j] GT n_rand[cnt] THEN BEGIN
               dead_step=floor(dist[0,j]*1e3/dt)
               BREAK
            ENDIF
            IF j EQ steps-1 THEN BEGIN
               dead_step=floor(dist[0,steps-1]*1e3/dt)
            ENDIF
         ENDFOR

         IF dead_step LT tot_step-i THEN BEGIN
            olc[i+1:i+dead_step]=0
            i=i+dead_step
         ENDIF ELSE IF i EQ tot_step-1 THEN BEGIN
            olc[i]=0
            BREAK
         ENDIF ELSE BEGIN
            olc[i+1:tot_step-1]=0
            BREAK
         ENDELSE
      ENDIF

   ENDFOR   

ENDELSE

perc=mean(olc)/mean(back_lc)*100.

IF chatty EQ 1 THEN print,'Percentage left from original light curve :',$
                          float(mean(olc)/mean(back_lc))*100,'%'

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
