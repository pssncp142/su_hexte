PRO modelfit,f,psd,sig,dead,res

  n=size(dead)
  n=n[1]+1
  A=dblarr(n,n)
  B=dblarr(n)
  size=size(f)
  psd_f=dblarr(n,size[1])

  psd_f[0,*]=2D0
  FOR i=1,n-1 DO BEGIN
     psd_f[i,*]=modelf(1,dead[i-1],f)
  ENDFOR

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

  gaussjordan,A,B,res
  gaussj,A,B,solution=sol
  print,Cramer(A,B,/double)
  print,''
  print,sol

END
