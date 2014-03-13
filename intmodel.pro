FUNCTION func, t, a, b, c, f

  RETURN, -1e5*c*(t*1e3+b)^(-a)*sin(!pi*t*f)^2/(!pi*f)^2

END

FUNCTION intmodel, f, a, b, c, t_max

t_t = 1000
t_min = 2.5e-3

t = (dindgen(t_t)+1)/t_t*(t_max-t_min)+t_min

len = size(f)
psd = dblarr(len[1])

FOR i=0,len[1]-1 DO BEGIN
   psd[i] = integral(t,func(t,a,b,c,f[i]))
ENDFOR

;plot,f,2+psd,/xlog,yr=[1.9,2.4]

RETURN,psd

END
