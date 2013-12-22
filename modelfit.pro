PRO modelfit,f,psd,sig,dead,res
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar   22.12.2013
;
; Give the fit values for different dead time values and a constant
; poisson noise.
;
; PURPOSE 
;  - Modelling of the power spectrum
;
; INPUT
;  - f          discrete frequencies
;  - psd        discrete PSD function
;  - sig        error of the psd function
;  - dead       dead time array to be fit with the PSD
;  
; OUTPUT
;  - res        fit values for dead times
;
; NOTES
;  - fit function is Ai*sin(!pi*dead*f)^2/(!pi*f)^2
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

  gaussj,A,B,solution=res

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
