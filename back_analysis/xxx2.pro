
lon=[0,30,60,90,120,150,180,210,240,270,300,330]

FOR i=0,n_elements(lon)-1 DO BEGIN
   file=strtrim(lon[i]+30,1)+'-'+strtrim(lon[i],1)+$
        '/light/processed/0014336_seg_bkg.xdrlc.gz'
   print,file
   xdrlc_r,file,t,r
   help,r
   print,mean(r[*,0])
END

END
