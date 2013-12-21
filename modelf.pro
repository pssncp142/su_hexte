FUNCTION modelf,A,B,f

  size=size(B)
  size_A=size(A)

  IF size[0] EQ 0 AND size_A[0] EQ 0 THEN BEGIN 
     RETURN, A*sin(!pi*B*f)^2/(!pi*f)^2
  ENDIF ELSE IF size[0] EQ 1 AND size_A[0] EQ 1 THEN BEGIN
     res=0
     FOR i=0,size[1]-1 DO BEGIN
        res=res+A[i]*sin(!pi*B[i]*f)^2/(!pi*f)^2
     ENDFOR
     RETURN, res
  ENDIF ELSE BEGIN
     print,'Check the dimensions...'
     RETURN, -1
  ENDELSE

END
