;+
; Yigit Dallilar  20.02.2014
; 
; Performs background fitting to calculate correction for
; the orignal PSD
;
; Options may be applied sooner...
;
; INPUT
;   - path      name of the observation directory, e.g. '01.00ha.all'
;
; OUTPUT
;   - fit       fit values obtained from the procedure
; 
; Some function definitions before starting
FUNCTION model, A, B, f
  RETURN, A*sin(!pi*B*f)^2/(!pi*f)^2
END

FUNCTION all, f, P
  RETURN, 2*P[0]+model(P[1],P[2],f)+model(P[3],P[4],f)+model(P[5],P[6],f)+$
          model(P[7],P[8],f)+model(P[9],P[10],f)
END

FUNCTION all2, f, P
  RETURN, 2*P[0]+model(P[1],P[2],f)+P[8]* $
          (model(P[3],(P[3]*1e3)^(-P[7]),f)+model(P[4],(P[4]*1e3)^(-P[7]),f)+$
           model(P[5],(P[5]*1e3)^(-P[7]),f)+model(P[6],(P[6]*1e3)^(-P[7]),f)+$
           model(P[9],(P[9]*1e3)^(-P[7]),f))
                                         
END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO back_fit, path, fit

  f_path = path + '/light/fourier/high/onelength/'
  xdrfu_r1, f_path+'0014336_rebin_signormpsd.xdrfu.gz', f, psd
  xdrfu_r1, f_path+'0014336_rebin_errnormpsd.xdrfu.gz', f, err
  
  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},10)
  pi[0].fixed=1
  pi[2].fixed=1
  pi[3].limited=[1,1]
  pi[3].limits=[5e-3,10e-3]
  pi[4].limited=[1,1]
  pi[4].limits=[15e-3,25e-3]
  pi[5].limited=[1,1]
  pi[5].limits=[25e-3,36e-3]
  pi[6].limited=[1,1]
  pi[6].limits=[36e-3,50e-3]
  pi[9].limited=[1,1]
  pi[9].limits=[10e-3,15e-3]
  pi[7].limited=[1,1]
  pi[7].limits=[1.7,1.8]
  pi[8].limited[0] = 1
  pi[8].limits[0]=0
  start = [1D,200D,2.5e-3,10e-3,20e-3,30e-3,40e-3,1.75D,2D,12e-3]
  fit = mpfitfun('all2',f,psd[*,0],err[*,0],start,parinfo=pi)

  ;plot,[1,2],[2,3]
  ;ploterror,f,psd[*,0],err[*,0],/xlog,yr=[1.9,2.5],psym=1,/nohat
  ;oplot,f,all2(f,fit)

  ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},11)
  ;pi[0].fixed = 1
  ;pi[2].fixed = 1
  ;pi[4].limited = [1,1]
  ;pi[4].limits = [7e-3,15e-3]
  ;pi[6].limited = [1,1]
  ;pi[6].limits = [15e-3,25e-3]
  ;pi[8].limited = [1,1]
  ;pi[8].limits = [25e-3,37e-3]
  ;pi[10].limited = [1,1]
  ;pi[10].limits = [37e-3,70e-3]
  ;pi[1].limited[0] = 1
  ;pi[1].limits[0] = 0
  ;pi[3].limited[0] = 1
  ;pi[3].limits[0] = 0
  ;pi[5].limited[0] = 1
  ;pi[5].limits[0] = 0
  ;pi[7].limited[0] = 1
  ;pi[7].limits[0] = 0
  ;pi[9].limited[0] = 1
  ;pi[9].limits[0] = 0
  
  ;start = [1D, 2000D, 2.5e-3, 1000D, 1e-2, 500D, $
  ;         2e-2, 200D, 3e-2, 50D, 4e-2]
  
  ;fit = mpfitfun('all', f, psd[*,0], err[*,0], start, parinfo=pi)

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EOF;;;
