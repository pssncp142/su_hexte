
FUNCTION exist, id ,l
  spawn,'ls '+string(id)+'/'+strtrim(l+30,1)+'-'+strtrim(l,1)+'-1.all'+ $
        '/light/processed/'+string(512L*32L,format='(I07)')+$
        '_seg_bkg.xdrlc.gz',a
  s=size(a)
  if s[0] eq 1 then return, 1 else return, 0
END

FUNCTION err_exist, id, l, err
  ndx = where(err[*,0] eq id and $
              err[*,1] eq strtrim(l+30,1)+'-'+strtrim(l,1)+'-1')
  RETURN, ndx
END

PRO find_error, err

  spawn,'cat nogti.txt',err

  errid=[]
  errln=[]

  FOREACH x, err DO BEGIN
     tmp = strsplit(x,/extract)
     errid = [errid, tmp[0]]
     errln = [errln, tmp[1]]
  ENDFOREACH 

  err = make_array(n_elements(errid), 2, /string)
  err[*,0] = errid
  err[*,1] = errln

END

PRO sync_28, path, t_new, r_new

  file=path+'/light/processed/'+string(512L*32L,format='(I07)')+$
     '_seg_bkg.xdrlc'

  xdrlc_r,file,t,r

  len=size(r)

  n_lc=floor(len[1]/(32.*512.))
  len_lc=32L*512L
  lenb_lc=28L*512L
  two_sec=2L*512L
  
  r_new=fltarr(n_lc*lenb_lc)
  t_new=fltarr(n_lc*lenb_lc)
  t_arr=(dindgen(lenb_lc)+1)/2.^9

  FOR j=0L,n_lc-1 DO BEGIN
     t_new[j*lenb_lc:(j+1)*lenb_lc-1] = 28D*2D*j + t_arr      
     r_new[j*lenb_lc:(j+1)*lenb_lc-1,0]=$
        r[j*len_lc+two_sec:j*len_lc+two_sec+lenb_lc-1,0]
  ENDFOR

END

spawn,'cat ids.txt',ids
find_error, err

;ids = ids[0:10]
lon = indgen(12)*30

FOREACH l, lon DO BEGIN
   r = []
   t = []

   FOREACH id, ids DO BEGIN
      ;print, id, err_exist(id, l, err)
      IF exist(id, l) EQ 1 AND err_exist(id, l, err) EQ -1 THEN BEGIN
         print, id, l
         sync_28,string(id)+'/'+strtrim(l+30,1)+'-'+strtrim(l,1)+'-1.all', $
                 t_t, r_t
         r = [r, r_t]
         help,r
         IF n_elements(t) EQ 0 THEN t = t_t ELSE t = [t, t_t + t[-1] + 28D]
      ENDIF
   ENDFOREACH

   rr = fltarr(n_elements(r),2)
   rr[*,0] = r
   rr[*,1] = r

   xdrlc_w,'arch/'+strtrim(l+30,1)+'-'+strtrim(l,1)+'-1/light/processed/'+$
           string(512L*28L,format='(I07)')+'_seg_bkg.xdrlc',t,rr
ENDFOREACH

END
