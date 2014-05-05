
FUNCTION model, A, B, f
  RETURN, A*sin(!pi*B*f)^2/(!pi*f)^2
END

FUNCTION coef, t_max, a
  C = 1e3*150D/6D
  B = 50D
  t_min = 2.5e-3
  RETURN, (C*t_max+B)^(-a+1)/(C*(-a+1))-(C*t_min+B)^(-a+1)/(C*(-a+1))
END

; P[0] constant 1
; P[1] back rate
; P[2] xuld rate
; P[3] 2.5/int E (0,1)
; P[4] 2.5e-3
; P[5] 1.7
; P[6] a magic number
; P[7] max dead time

FUNCTION all, f, P
  RETURN, 2*P[0]+2*model(P[1]*P[2]*P[3],P[4],f)+$
          2*intmodel2(f,P[5],P[1]*p[2]*(1-P[3])*P[6],P[7])/coef(P[7],P[5])
END

FUNCTION fit, f, psd, err, rate, xuld
  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},8)
  pi[0].fixed = 1
  pi[1].fixed = 1
  pi[2].fixed = 1
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;pi[1].limited = [1,1]
  ;pi[1].limits = [rate*0.9,rate*1.1]
  ;pi[2].limited = [1,1]
  ;pi[2].limits = [xuld*0.9,xuld*1.1]
  
  pi[3].limited = [1,1]
  pi[3].limits = [0,1]
  ;pi[3].fixed = 1
  pi[4].fixed = 1
  pi[5].fixed = 1
  ;pi[6].fixed = 1
  pi[7].limited = [1,1]
  pi[7].limits = [10e-3,50e-3]

  start=[1D, rate, xuld, 0.5D, 2.5e-3, 1.7D, 0.2D, 30e-3]
  fit = mpfitfun('all',f,psd[*,0],err[*,0],start,parinfo=pi,relstep=1e-8)

  RETURN, fit
END

;-------------------------------------------------------------------------------

lon = ['30-0','60-30','90-60','120-90','150-120','180-150',$
     '210-180','240-210','270-240','300-270','330-300','360-330']
 
xuld = [86.65, 86.62, 87.20, 87.22, 85.72, 84.33, 85.09, 88.68, $
       103.92, 128.67, 96.89, 88.29]

rate = [40.59, 44.61, 50.02, 46.96, 46.63, 46.89, 46.44, 45.57, $
       40.90, 35.33, 39.37, 40.50]

a = [2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9]
a = [1.7]

f_path = '/light/fourier/high/onelength/'
fit_r = fltarr(n_elements(lon), n_elements(a), 8)

FOR i=0, n_elements(lon)-1 DO BEGIN
   FOR j=0, n_elements(a)-1 DO BEGIN
       xdrfu_r1, lon[i]+f_path+'0014336_manbin_signormpsd.xdrfu.gz', f, psd
       xdrfu_r1, lon[i]+f_path+'0014336_manbin_errnormpsd.xdrfu.gz', f, err
       fit_r[i, j, *] = fit(f, psd, err, rate[i], xuld[i])
       device,decomposed=0
       loadct,1
       tt = findgen(256)
       plot,tt,all(tt,fit_r[i,j,*]),/xlog,xr=[1,1e3],yr=[1.95,2.15],$
            back=255,color=0,thick=2
       oploterror,f,psd,err,psym=3,/nohat,errthick=2,$
                 color=100,backcolor=255,linecolor=100,errcolor=100       
       print,lon[i]
       print, rate[i]/fit_r[i, j, 1], xuld[i]
       stop
   ENDFOR
ENDFOR

;openw, 1, 'fit_res_man1.txt'
;FOR j=0, n_elements(a)-1 DO BEGIN
;   FOR i=0, n_elements(lon)-1 DO BEGIN
;      printf, 1, fit_r[i, j, 1], fit_r[i, j, 3], fit_r[i, j, 5], $
;              fit_r[i, j, 6]
;   ENDFOR
;ENDFOR

;close, 1

END
