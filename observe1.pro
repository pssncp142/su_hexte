PRO observe1, back_r, xuld_r, dur, dt, f_dt, rblc, psd, $
              pure=pure,$
              dead=vdead,$
              pow=vpow,min_d=vmin_d,max_d=vmax_d,step=vstep,$
              ndet=vndet,$
              chatty=chatty 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          18.11.2013
; 
;  Returns observed light curve
;
; PURPOSE  
;   - Modelling of HEXTE light curves with dead time events.
;
; INPUT 
;   - back_r    background count rate (real)
;   - xuld_r    XULD count rate
;   - dur       Duration of the observation time in seconds
;   - dt        time resolution of the curve in us
;   - f_dt      rebin interval of the light curve in seconds
;
; OPTIONAL INPUTS
;   - ndet      # of detectors included into observation
;
;   - For pure poisson light curve
;   1 :  pure      KEYWORD
;         
;   - For constant deadtime simulation
;   2 :  dead      constant deadtime
;
;   - For power law distributed cosmic background
;   3 :  pow       power of the power law distribution
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
;   - NOT SURE IF POWER LAW WORKS??
;
; PROCEDURES
;   - poissonlc.pro
;   - xulddist.pro
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on_error,2

IF keyword_set(chatty) THEN chatty=1 ELSE chatty=0

IF keyword_set(vndet) THEN BEGIN
ndet=vndet-1
print, 'Simulation will be performed for', uint(ndet+1),' detectors.'
ENDIF ELSE BEGIN
ndet=0
print, 'Simulation will be performed for a single detector' 
ENDELSE

IF keyword_set(pure) THEN BEGIN
   p_pure=1
   IF chatty EQ 1 THEN print,'Pure poisson light curve'
ENDIF ELSE IF keyword_set(vdead) THEN BEGIN 
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

FOR k=0,0 DO BEGIN
   
   IF p_pure EQ 1 THEN BEGIN
      poissonlc,back_r,dur,dt,back_lc,chatty=chatty
      olc=back_lc
   ENDIF ELSE BEGIN
      ;create back_lc and xuld_lc
      poissonlc,back_r,dur,dt,back_lc,chatty=chatty
      poissonlc,xuld_r,dur,dt,xuld_lc,chatty=chatty
      olc=back_lc
   
      tot_step=floor(dur/(dt*1e-6))
   
      ;constant deadtime
      IF opt EQ 1 THEN BEGIN

         dead_step=floor(dead*1e3/dt)
         FOR i=0,tot_step-1 DO BEGIN
         
            IF xuld_lc[i] GT 0 THEN BEGIN
               IF dead_step LT tot_step-i THEN BEGIN
                  olc[i+1:i+dead_step]=0
                  ;unparalyzed case ignore the ones already inside the deadtime
                  i=i+dead_step
                  ;if deadtime is lower than the rest of the ligth curve
                  ;make the rest 0 then break
               ENDIF ELSE IF i EQ tot_step-1 THEN BEGIN
                  olc[i]=0
                  BREAK
               ENDIF ELSE BEGIN
                  olc[i+1:tot_step-1]=0
                  BREAK
               ENDELSE
            ENDIF

         ENDFOR
      
       ;deadtime with power distribution 
      ENDIF ELSE BEGIN

         xulddist, pow, min_d, max_d, step, dist
         steps=size(dist)
         steps=steps[2]
         n_rand=randomu(systime(1),tot_step)
         cnt=0
         
         FOR i=0,tot_step-1 DO BEGIN
            
            IF xuld_lc[i] GT 0 THEN BEGIN
               
            ;calculate dead time for each xuld photon
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
                  cnt=cnt+total(xuld_lc[i:i+dead_step])-1
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

   ENDELSE

   IF k EQ 0 THEN BEGIN
      olc1=olc
   ENDIF ELSE BEGIN
      olc1=olc1+olc
   ENDELSE

ENDFOR

perc=mean(olc)/mean(back_lc)*100.

IF chatty EQ 1 THEN print,'Percentage left from original light curve :',$
                          float(mean(olc)/mean(back_lc))*100,'%'

rebinlc, olc, dur, dt, f_dt, rblc
psdcalc, rblc, f_dt, psd

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
