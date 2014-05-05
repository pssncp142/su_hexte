pro plottau2

f=[0.1,1.,10.]
a=1.7
b=0.
c=10000.

tm=(dindgen(30)+10.)*1D-3

k=dblarr(3,30)
fac=dblarr(30)
for i=0,29 do begin
  k[*,i]=intmodel(f,a,b,c,tm[i])
  fac[i]=((tm[i]*1e3)*160/6.+50)^(-a)
endfor
plot,tm,k[0,*]
oplot,tm,fac*1000.,line=2
end


