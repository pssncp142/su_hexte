PRO poissoncdf, var, range, cdf

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
