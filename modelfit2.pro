PRO modelfit2,f,psd,sig,dead,res
  
  n=3

  A=dblarr(n,n)
  B=dblarr(n)
  size=size(f)
  psd_f=dblarr(n,size[1])

  psd_f[0,*]=2D0
  psd_f[1,*]=modelf(1,dead[0],f)
  psd_f[2,*]=sin(3.*!pi*dead[0]*f)/(!pi*f)


  FOR i=0,n-1 DO BEGIN
     FOR k=0,size[1]-1 DO BEGIN
        B[i]=B[i]+psd_f[i,k]*psd[k]/sig[k]^2
     ENDFOR
     FOR j=0,n-1 DO BEGIN
        FOR k=0,size[1]-1 DO BEGIN
           A[i,j]=A[i,j]+psd_f[i,k]*psd_f[j,k]/sig[k]^2
        ENDFOR
     ENDFOR
  ENDFOR

  print,A
  print,B
  gaussj,A,B,solution=res

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
