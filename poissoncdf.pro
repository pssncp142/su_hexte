PRO poissoncdf, var, range, cdf
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          15.11.2013
; 
; Poisson CDF calculation
; 
; PURPOSE  
;   - Sampling poisson light curves for background simulation
;
; INPUT 
;   - var       variance of poisson distribution
;   - range     last k point to calculate cdf
;
; OUTPUT
;   - cdf       array of cdf function with array of length range+1
;
; NOTES
;   - range+1 value is given as 1 
;   - range should be given carefully according to variance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,;;;

  var=double(var)
  coef=exp(-var)
  k=double(findgen(range)+1)
  cdf=dblarr(range+1)

  FOR i=0,range-1 DO BEGIN
     IF i EQ 0 THEN BEGIN
        cdf[0]=coef
     ENDIF ELSE BEGIN
        cdf[i]=cdf[i-1]+coef*var^i/factorial(i)
     ENDELSE
  ENDFOR

  cdf[range]=1

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
