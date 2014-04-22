PRO manbin, lon

fbin=[0,3,10,20,30,40,50,60,70,80,90,100,$
      110,120,130,140,160,180,200,220,250]

path=lon+'/light/fourier/high/onelength/'

xdrfu_r1,path+'0014336_signormpsd.xdrfu',f,psd
xdrfu_r1,path+'0014336_errnormpsd.xdrfu',f,err

nofbin=n_elements(fbin)-1
errbin=fltarr(nofbin)
psdbin=fltarr(nofbin)
count=lonarr(nofbin)


FOR i=0, nofbin-1 DO BEGIN
   FOR j=0, n_elements(f)-1 DO BEGIN
      IF f[j] GT fbin[i] AND f[j] LT fbin[i+1] THEN BEGIN
         psdbin[i] += psd[j,0]
         errbin[i] += err[j,0]
         count[i] += 1
      ENDIF
   ENDFOR
ENDFOR

psd = fltarr(nofbin,2)
err = fltarr(nofbin,2)
psd[*,0] = psdbin/count
psd[*,1] = psdbin/count
err[*,0] = errbin/(count*sqrt(count))
err[*,1] = errbin/(count*sqrt(count))

xdrfu_w1,path+'0014336_manbin_signormpsd.xdrfu',fbin[1:-1],psd
xdrfu_w1,path+'0014336_manbin_errnormpsd.xdrfu',fbin[1:-1],err


END

lon = [0,30,60,90,120,150,180,210,240,270,300,330]
ndx = ['-1','-2']
exc = ['330-300-2']

FOR j=0, n_elements(ndx)-1 DO BEGIN
   FOR i=0, n_elements(lon)-1 DO BEGIN
      strlon = strtrim(lon[i]+30,1)+'-'+strtrim(lon[i],1)+ndx[j]
      IF strlon NE exc[0] THEN BEGIN 
         print,strlon
         ;spawn,'ls '+strlon+'/light/fourier/high/onelength/'
         manbin,strlon
      ENDIF
   ENDFOR
ENDFOR

END
