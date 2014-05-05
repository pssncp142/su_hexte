
lon = [0,30,60,90,120,150,180,210,240,270,300,330]
ndx = ['-1','-2'] 
exc = ['330-300-2']

FOR j=0,n_elements(ndx)-1 DO BEGIN
   FOR i=0,n_elements(lon)-1 DO BEGIN
      strlon = strtrim(lon[i]+30,1)+'-'+strtrim(lon[i],1)+ndx[j]
      print,strlon
      IF strlon NE exc[0] THEN BEGIN
         file=strlon+$
              '/light/processed/0014336_seg_bkg.xdrlc.gz'
         print,file
         xdrlc_r,file,t,r
         help,r
         print,mean(r[*,0])
      ENDIF
   ENDFOR
ENDFOR

END
