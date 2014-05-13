
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
  pi[6].fixed = 1
  ;pi[7].fixed = 1
  pi[7].limited = [1,1]
  pi[7].limits = [11e-3,50e-3]

  start=[1D, rate, xuld, 0.3D, 2.5e-3, 1.7D, 1D, 13e-3]
  fit = mpfitfun('all',f,psd[*,0],err[*,0],start,parinfo=pi,relstep=1e-8)

  RETURN, fit
END

;-------------------------------------------------------------------------------

PRO fit_sim, f, psd, err

xuld = 85
rate = 45

fit_r = fit(f, psd, err, rate, xuld)
device,decomposed=0
loadct,1
tt = findgen(256)
plot,tt,all(tt,fit_r),/xlog,xr=[1,1e3],yr=[1.95,2.4],$
     back=255,color=0,thick=2
oploterror,f,psd,err,psym=3,/nohat,errthick=2,$
           color=100,backcolor=255,linecolor=100,errcolor=100       

END
