PRO observe1, back_r, xuld_r, dur, dt, f_dt, rand, rblc, psd, $
              pure=pure,$
              dead=vdead,$
              pow=vpow,ratio=vratio,min_d=vmin_d,max_d=vmax_d,step=vstep,$
              ndet=vndet,$
              stat=vstat,$
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
;     :  ratio     * ratio*xuld_r for log distributed background
;                  * (1-ratio)*xuld_r for 2.5 ms constant deadtime
;     :  min_d     minimum deadtime
;     :  max_d     maximum deadtime
;     :  step      step size to calculate distribution
;     
; OUTPUT
;   - olc       light curve array with range of dur/(dt*1e-6) 
;   - perc      percentage between observed light curve 
;               and pure poisson light curve
;
; OPTIONAL OUTPUT
;   - (v)stat   two dimensional array notes the dead time of xuld particles     
;               * first array for all created particles
;               * second array excludes the particles which are
;               already created in the paralyzed time
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
IF chatty EQ 1 THEN $
   print, 'Simulation will be performed for', uint(ndet+1),' detectors.'
ENDIF ELSE BEGIN
ndet=0
IF chatty EQ 1 THEN $
   print, 'Simulation will be performed for a single detector.' 
ENDELSE

IF keyword_set(pure) THEN BEGIN
   p_pure=1
   stat=1
   IF chatty EQ 1 THEN print,'Pure poisson light curve.'
ENDIF ELSE IF keyword_set(vdead) THEN BEGIN 
   p_pure=0
   opt=1
   stat=lonarr(2)
   dead=vdead 
   IF chatty EQ 1 THEN print,'Constant deadtime option with',$
                             float(dead),' milisec'
ENDIF ELSE IF keyword_set(vpow) AND keyword_set(vmin_d) AND $
   keyword_set(vmax_d) AND keyword_set(vstep) AND $
   keyword_set(vratio) THEN BEGIN
   p_pure=0
   opt=2
   pow=vpow
   ratio=vratio
   min_d=vmin_d
   max_d=vmax_d
   step=vstep
   stat=lonarr(2,floor((max_d-min_d)/step))
   IF chatty EQ 1 THEN BEGIN
      print,'Power law deadtime distribution option with'
      print,'- 2.5 ms const. :',float((1-ratio)*xuld_r),' cts/s'
      print,'- Dist. count   :',float(ratio*xuld_r),' cts/s'
      print,'- Power         :',float(pow)
      print,'- Min deadtime  :',float(min_d),' milisec'
      print,'- Max deadtime  :',float(max_d),' milisec'
      print,'- Step size     :',float(step),' milisec'
   ENDIF
ENDIF ELSE BEGIN
   message,'Choose whether constant or power law deadtime'
ENDELSE

FOR k=0,ndet DO BEGIN
   
   IF p_pure EQ 1 THEN BEGIN
      poissonlc,back_r,dur,dt,rand,back_lc,chatty=chatty
      olc=back_lc
   ENDIF ELSE BEGIN
      ;create back_lc and xuld_lc
      poissonlc,back_r,dur,dt,rand,back_lc,chatty=chatty
      poissonlc,xuld_r,dur,dt,rand,xuld_lc,chatty=chatty
      olc=back_lc
   
      tot_step=floor(dur/(dt*1e-6))
   
      ;constant deadtime
      IF opt EQ 1 THEN BEGIN

         dead_step=floor(dead*1e3/dt)
         
         FOR i=0,tot_step-1 DO BEGIN
            IF xuld_lc[i] GT 0 THEN stat[0]=stat[0]+1L
         ENDFOR

         FOR i=0,tot_step-1 DO BEGIN
            IF xuld_lc[i] GT 0 THEN BEGIN
               stat[1]=stat[1]+1L
               IF dead_step LT tot_step-i THEN BEGIN
                  olc[i+1:i+dead_step]=0
                  ;paralyzed case ignore the ones already inside the deadtime
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
         n_rand=rand->GetRandomNumbers(tot_step,/double)
         rat_rand=rand->GetRandomNumbers(tot_step,/double)
         cnt=0
         
         ;;;;;;;;;;;;;;;;;;;;;;;;;;
         FOR i=0,tot_step-1 DO BEGIN
            IF xuld_lc[i] GT 0 THEN BEGIN
               IF rat_rand[i] GT ratio THEN BEGIN
                  stat[0,0]=stat[0,0]+1L
               ENDIF ELSE BEGIN
                  FOR j=0,steps-1 DO BEGIN
                     IF dist[1,j] GT n_rand[i] THEN BEGIN
                        stat[0,j]=stat[0,j]+1L
                        BREAK
                     ENDIF
                  ENDFOR
               ENDELSE
            ENDIF
         ENDFOR
         ;;;;;;;;;;;;;;;;;;;;;;;;;;

         FOR i=0,tot_step-1 DO BEGIN
            
            IF xuld_lc[i] GT 0 THEN BEGIN
               
            ;calculate dead time for each xuld photon
               cnt=cnt+1
               dead_step=0

               IF rat_rand[i] GT ratio THEN BEGIN
                  dead_step=floor(2.5*1e3/dt)
                  stat[1,0]=stat[1,0]+1L
               ENDIF ELSE BEGIN
                  FOR j=0,steps-1 DO BEGIN
                     IF dist[1,j] GT n_rand[cnt] THEN BEGIN
                        dead_step=floor(dist[0,j]*1e3/dt)
                        stat[1,j]=stat[1,j]+1L
                        BREAK
                     ENDIF
                     ;IF j EQ steps-1 THEN BEGIN
                     ;   dead_step=floor(dist[0,steps-1]*1e3/dt)
                     ;   stat[1,j]=stat[1,j]+1L
                     ;ENDIF
                  ENDFOR
               ENDELSE

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

IF p_pure NE 1 THEN vstat=stat
rebinlc, olc1, dur, dt, f_dt, rblc
psdcalc, rblc, dur, psd

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
