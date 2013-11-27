PRO sim,freq1,tt
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar            27.11.2013
;
; Peforms the same observation n times considering options given. For
; each light curve, PSD function is calculated separately. Then mean value
; of the psd function in each discrete frequency is rebinned.  
;
; PURPOSE
;   - Modelling HEXTE ligth curves with dead time events.
;
; INPUT
;   - back_r    background count rate (real)
;   - xuld_r    XULD count rate
;   - dur       Duration of the observation time in seconds
;   - dt        time resolution of the curve in us
;   - f_dt      rebin interval of the light curve in seconds
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  FOR i=0,20 DO BEGIN
     ;observe1,100.,100.,32.,8.,0.5^9,olc,psd,pow=-1.8,$
     ;         min_d=2.5,max_d=6.5,step=0.008,chatty=0 
     ;observe1,100.,100.,32.,8.,0.5^9,olc,psd,dead=2.5,chatty=0
     observe1,100.,100.,32.,8.,0.5^9,olc,psd,pure=1,chatty=0
     print,i
     IF i EQ 0 THEN BEGIN
        psd_t=psd
     ENDIF ELSE BEGIN
        psd_t=(psd_t*i+psd)/(i+1)
        ;print,floor(n_elements(psd)*0.5)
     ENDELSE

  ENDFOR

  ;plot,psd_t[1:floor(n_elements(psd)*0.5)+1],psym=3,yrange=[0,4]

  psd_t=psd_t[1:floor(n_elements(psd)*0.5)+1]
  length=floor(n_elements(psd)*0.5)
  freq=(findgen(length)+1)/2.^6

  freqrebin,freq,psd_t,freq1,tt,nsig,osig,logf=0.2,high=128D0
  stop

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
