PRO divseg, lc, dseg, seglc

  n_lc = floor(n_elements(lc)/dseg) 
  print,n_lc
  seglc=fltarr(n_lc,dseg)
  help,seglc
  FOR i=0,n_lc-1 DO BEGIN
     seglc[i,*]=lc[(dseg*i):(i+1)*dseg-1]
  ENDFOR

END
