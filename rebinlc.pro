PRO rebinlc, lc, dur, dt, f_dt, rblc
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar           27.11.2013
;
; Rebins the light curve into discrete intervals with f_dt
;
; PURPOSE
;  - Prepare the ligth curve for PSD calculation
;
; INPUT
;  - lc      original light curve array
;  - dur     duration of the ligth curve in seconds
;  - dt      original discrete time interval in us
;  - f_dt    discrete time interval using to rebin the light curve
;
; OUTPUT
;  - rblc    rebinned light curve
;
; NOTES
;  - Error of the light curve
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  nofbin=floor(dur/f_dt)
  rblc=dblarr(nofbin)
  lc_size=size(lc)
  step=0

  FOR i=0,nofbin-1 DO BEGIN

     lst_step=step+f_dt/dt*1e6
     IF lst_step GT lc_size[1] THEN BEGIN
        rblc[i]=total(lc[floor(step):lc_size[1]-1])/f_dt
        BREAK
     ENDIF ELSE BEGIN
        rblc[i]=total(lc[floor(step):floor(lst_step)-1])/f_dt
     ENDELSE
     step=lst_step

  ENDFOR

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
