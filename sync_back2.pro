PRO sync_back2,path,t_new,r_new

  file=path+'/light/processed/'+string(512L*32L,format='(I07)')+$
     '_seg_bkg.xdrlc'

  xdrlc_r,file,t,r
  lenlc = size(r)

  len_lc=32L*512L
  lenb_lc=28L*512L
  two_sec=2L*512L

  ndx = where(r[*,0] gt 0)
  size = size(ndx)
  len = size[1]
  sgn = bytarr(len)

  ndx_s = 0L
  FOR i=0L,len-1 DO BEGIN

     IF ndx_s LT ndx[i] THEN BEGIN
        sgn[i] = 1
        print,ndx_s,ndx_s+lenb_lc,ndx[i]
        ndx_s = ndx[i] + lenb_lc
     ENDIF

  ENDFOR   

  t_new = dindgen(lenb_lc*2L*total(sgn))*0.5D^9+t[0]
  r_new = fltarr(lenb_lc*2L*total(sgn),2)
  help,r,r_new

  ndx_s = where(sgn EQ 1)
  FOR i=0L,total(sgn)-1 DO BEGIN

     ;print,2*i*lenb_lc,(2*i+1)*lenb_lc-1,lenb_lc
     r_new[2*i*lenb_lc:(2*i+1)*lenb_lc-1,*] = $
        r[ndx[ndx_s[i]]:ndx[ndx_s[i]]+lenb_lc-1,*]

  ENDFOR

  file=path+'/light/processed/'+string(512L*28L,format='(I07)')+$
     '_seg_bkg.xdrlc'

  xdrlc_w,file,t_new,r_new

END
