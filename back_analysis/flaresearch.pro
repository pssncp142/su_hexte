
PRO ndxflare2, r, ndx

  len = 512L*28L
  ndx = []

  FOR i=0, n_elements(r)/len-1 DO BEGIN
     m_lc = mean(r[i*len:(i+1)*len-1])
     rebin, r[i*len:(i+1)*len-1], n_r
     FOR j=0, 27 DO BEGIN
        IF n_r[j] GT m_lc*1.4 THEN BEGIN
          ndx = [ndx,i] 
          ;print,'in', i
          ;plot, n_r, yr=[0,100]
          ;stop
          BREAK
        ENDIF
     ENDFOR
     ;print, 'out', i
     ;plot, n_r, yr=[0,100]
     ;stop
  ENDFOR

END

PRO ndxflare, t, r, ndx

  m_lc = mean(r)
  len = 512L*28L
  ndx = []

  FOR i=0, n_elements(r)/len-1 DO BEGIN
     rebin, r[i*len:(i+1)*len-1], n_r
     FOR j=0, 6 DO BEGIN
        IF n_r[j] GT m_lc*1.3 THEN BEGIN
          ndx = [ndx,i] 
          BREAK
        ENDIF
     ENDFOR
  ENDFOR

  ;print,ndx
  ;print,n_elements(r)/len,n_elements(ndx)
  
END

PRO removeflare, r, ndx, n_t, n_r

  n_t = []
  n_r = []
  len = 512L*28L
  t = dindgen(len)/512

  FOR i=0, n_elements(r)/len-1 DO BEGIN
     check = 0 ;no flare
     FOR j=0, n_elements(ndx)-1 DO BEGIN
        IF ndx[j] EQ i THEN BEGIN
           check = 1;there is flare
           BREAK
        ENDIF
     ENDFOR
     IF check EQ 0 THEN BEGIN
        n_r = [n_r, r[i*len:(i+1)*len-1]]
     ENDIF
  ENDFOR

  FOR i=0, n_elements(n_r)/len-1 DO BEGIN
     IF i EQ 0 THEN n_t=t ELSE BEGIN
        n_t = [n_t,i*2L*28L+t]
     ENDELSE
  ENDFOR
  
END

PRO rebin, r, n_r
  
  n_r=[]

  sec = 1L

  FOR i=0L, n_elements(r)/(512*sec)-1 DO BEGIN
     n_r = [n_r,mean(r[i*512L*sec:(i+1)*512L*sec-1])]
  ENDFOR

END

PRO rebint, r, n_t, n_r
  
  n_r=[]
  n_t=[]
  t = dindgen(7)*4
  sec = 4L

  FOR i=0L, n_elements(r)/(512*sec)-1 DO BEGIN
     n_r = [n_r,mean(r[i*512L*sec:(i+1)*512L*sec-1])]
  ENDFOR

  FOR i=0, n_elements(n_r)/(28/sec)-1 DO BEGIN
     IF i EQ 0 THEN n_t=t ELSE BEGIN
        n_t = [n_t,i*2L*28L+t]
     ENDELSE
  ENDFOR

  help,n_t,n_r

END

;xdrlc_r,'120-90/light/processed/0014336_seg_bkg.xdrlc.gz',t,r
;ndxflare2, r[*,0], ndx
;print, n_elements(ndx)

l = indgen(12)*30

FOR i=0, n_elements(l)-1 DO BEGIN
   strlon = strtrim(l[i]+30,1)+'-'+strtrim(l[i],1)
   print,strlon
   xdrlc_r,strlon+'/light/processed/0014336_seg_bkg.xdrlc.gz',t,r
   ndxflare2, r[*,0], ndx
   removeflare, r[*,0], ndx, n_t, n_r 
   rr = fltarr(n_elements(n_r),2)
   rr[*,0] = n_r
   rr[*,1] = n_r
   xdrlc_w,'../arch2/'+strlon+'/light/processed/0014336_seg_bkg.xdrlc',n_t,rr
ENDFOR


;rebin, t, r[*,0], n_t, n_r
;help, n_t, n_r
;print, mean(n_r)
;rebint, n_r, n_t, a_r
;rebint, r[*,0], n_t, a_r
;plot, n_t, a_r,psym=3,yr=[0,100]
;stop

END
