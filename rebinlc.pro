PRO rebinlc, lc, dur, dt, f_dt, rblc

  nofbin=floor(dur/f_dt)
  print,nofbin*f_dt/dt*1e6,size(lc)
  rblc=fltarr(2,nofbin)
  lc_size=size(lc)
  step=0

  FOR i=0,nofbin-1 DO BEGIN

     lst_step=step+f_dt/dt*1e6
     IF lst_step GT lc_size[1] THEN BEGIN
        rblc[0,i]=total(lc[floor(step):lc_size[1]-1])/f_dt
        BREAK
     ENDIF ELSE BEGIN
        rblc[0,i]=total(lc[floor(step):floor(lst_step)])/f_dt
     ENDELSE
     rblc[1,i]=rblc[0,i]; find error !!!!
     step=lst_step

  ENDFOR

  print,mean(rblc[0,*])

END
