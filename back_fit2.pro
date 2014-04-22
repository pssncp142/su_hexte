
FUNCTION model, A, B, f
  RETURN, A*sin(!pi*B*f)^2/(!pi*f)^2
END

FUNCTION all, f, P
  RETURN, 2*P[0]+model(P[1],P[2],f)+intmodel(f,P[3],P[4],P[5],P[6])
END

PRO back_fit2, path, fit, plot=plot

  f_path = path + '/light/fourier/high/onelength/'
  xdrfu_r1, f_path+'0014336_rebin_signormpsd.xdrfu.gz', f, psd
  xdrfu_r1, f_path+'0014336_rebin_errnormpsd.xdrfu.gz', f, err

  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},7)
  pi[0].fixed=1
  pi[1].limited[1] = 1
  pi[1].limits = 2000D0
  pi[2].fixed = 1
  pi[3].fixed = 1
  ;pi[3].limits = [1.6D,2.4D]
  ;pi[4].fixed = 1
  ;pi[6].fixed = 1
  ;pi[6].fixed = 1
  pi[6].limited = [1,1]
  pi[6].limits = [10e-3,100e-3]

  start = [1D,350D,2.5e-3,2.8D,50D,10D,30e-3]
  fit = mpfitfun('all',f,psd[*,0],err[*,0],start,parinfo=pi,relstep=1e-8)
  
  IF keyword_set(plot) THEN BEGIN
     device,decomposed=0
     loadct,1
     plot,[1e-2,1e3],[2,2],back=255,color=1,/xlog,yr=[1.9,2.2]
     oploterror,f,psd[*,0],err[*,0],psym=3,/nohat,$
               color=1,errc=1
     oplot, f, all(f,fit), color=1 
  ENDIF


END
