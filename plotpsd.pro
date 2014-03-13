
main='30188-06-11-00/11.00ha.all'
f_path='/light/fourier/high/onelength/'
;psd_f='0016384_rebin_signormpsd_corr.xdrfu.gz'
;err_f='0016384_rebin_errnormpsd_corr.xdrfu.gz'
psd_f='0016384_rebin_lag.xdrfu.gz'
err_f='0016384_rebin_errlag.xdrfu.gz'

f_path=main+f_path

xdrfu_r2,f_path+psd_f,freq,psd
xdrfu_r2,f_path+err_f,freq,err

help,psd,err,freq

device,decomposed=0
loadct,2

!p.multi=[1,3]
plot,[1,2],[2,3],back=255
ploterror,freq,psd[*,1,3],err[*,1,3],/xlog,/ylog,yr=[1e-4,1e3],$
          xr=[0.01,100],/nohat,psym=1, back=255,col=0,errcol=120
ploterror,freq,psd[*,1,2],err[*,1,2],/xlog,/ylog,yr=[1e-4,1e3],$
          xr=[0.01,100],/nohat,psym=1,back=255,col=0,errcol=120
ploterror,freq,psd[*,1,1],err[*,1,1],/xlog,/ylog,yr=[1e-4,1e3],$
          xr=[0.01,100],/nohat,psym=1,back=255,col=0,errcol=120

print,5

END
