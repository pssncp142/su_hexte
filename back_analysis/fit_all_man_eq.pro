
FUNCTION model, A, B, f
  RETURN, A*sin(!pi*B*f)^2/(!pi*f)^2
END

FUNCTION all, f, P
  RETURN, 2*P[0]+model(P[1],P[2],f)+intmodel(f,P[3],P[4],P[5],P[6])
END

FUNCTION fit, f, psd, err, a
  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},7)
  pi[0].fixed=1
  pi[1].limited[1] = 1
  pi[1].limits = 2000D0
  pi[2].fixed = 1
  pi[3].fixed = 1
  pi[6].limited = [1,1]
  pi[6].limits = [10e-3,100e-3]

  start = [1D, 350D, 2.5e-3, a, 50D, 10D, 30e-3]
  fit = mpfitfun('all',f,psd[*,0],err[*,0],start,parinfo=pi,relstep=1e-8)

  RETURN, fit
END

;-------------------------------------------------------------------------------

lon = ['30-0','60-30','90-60','120-90','150-120','180-150',$
     '210-180','240-210','270-240','300-270','330-300','360-330']

ndx = ['-1','-2']
exc = ['330-300-2']
 
xuld = [86.65, 86.62, 87.20, 87.22, 85.72, 84.33, 85.09, 88.68, $
       103.92, 128.67, 96.89, 88.29]

rate = [40.59, 44.61, 50.02, 46.96, 46.63, 46.89, 46.44, 45.57, $
       40.90, 35.33, 39.37, 40.50]

a = [2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9]
a = [1.7]

f_path = '/light/fourier/high/onelength/'
fit_r = fltarr(2, n_elements(lon), n_elements(a), 7)

FOR k=0, n_elements(ndx)-1 DO BEGIN
   FOR i=0, n_elements(lon)-1 DO BEGIN
      FOR j=0, n_elements(a)-1 DO BEGIN
         IF lon[i]+ndx[k] NE exc[0] THEN BEGIN
            xdrfu_r1, lon[i]+ndx[k]+f_path+$
                      '0014336_manbin_signormpsd.xdrfu.gz', f, psd
            xdrfu_r1, lon[i]+ndx[k]+f_path+$
                      '0014336_manbin_errnormpsd.xdrfu.gz', f, err 
            fit_r[k, i, j, *] = fit(f, psd, err, a[j])
            device,decomposed=0
            loadct,1
            tt = findgen(256)
            plot,tt,all(tt,fit_r[k,i,j,*]),/xlog,xr=[1,1e3],yr=[1.95,2.15],$
                 back=255,color=0,thick=2
            oploterror,f,psd,err,psym=3,/nohat,errthick=2,$
                       color=100,backcolor=255,linecolor=100,errcolor=100
            print,lon[i]+ndx[k]
            stop      
         ENDIF
      ENDFOR
   ENDFOR
ENDFOR

openw, 1, 'fit_res_man.txt'
FOR j=0, n_elements(a)-1 DO BEGIN
   FOR k=0, n_elements(ndx)-1 DO BEGIN
      FOR i=0, n_elements(lon)-1 DO BEGIN
         IF lon[i]+ndx[k] NE exc[0] THEN BEGIN
            printf, 1, fit_r[k, i, j, 1], fit_r[k, i, j, 3], fit_r[k,i, j, 5], $
                    fit_r[k, i, j, 6]
         ENDIF
      ENDFOR
   ENDFOR
ENDFOR

close, 1

END
