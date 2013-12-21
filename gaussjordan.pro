PRO gaussjordan,A,B,C

  lim0=1e-20
  sizeA=size(A)
  print,sizeA
  IF sizeA[1] NE sizeA[2] THEN print,'Needs square matrix...'
  n=size(B)
  n=n[1]
  IF sizeA[1] NE n THEN print,'Dimensions do not match...'
  
  n_A=dblarr(n,n)
  n_B=dblarr(n)

  n_A[*,*]=A
  n_B[*]=B

  FOR j=0,n-1 DO BEGIN

     cnt=0
     FOR i=j,n-1 DO BEGIN  
        IF abs(A[i,j]) GT lim0 THEN BEGIN
           val=n_A[i,j]
           n_A[i,j:n-1]=n_A[i,j:n-1]/val
           n_B[i]=n_B[i]/val
           tmpA=n_A[i,j:n-1]
           tmpB=n_B[i]
           IF i NE j THEN BEGIN
              n_A[j+1:i,j:n-1]=n_A[j:i-1,j:n-1]
              n_A[j,j:n-1]=tmpA
              n_B[j+1:i]=n_B[j:i-1]
              n_B[j]=tmpB
           ENDIF
           cnt=cnt+1
        ENDIF        
     ENDFOR

     IF cnt EQ 0 THEN BEGIN 
        print,'Singular Matrix...' 
     ENDIF ELSE IF cnt EQ 1 THEN BEGIN
        FOR i=0,j-1 DO BEGIN
           val=n_A[i,j]
           n_A[i,j:n-1]=n_A[i,j:n-1]-n_A[j,j:n-1]*val
           n_B[i]=n_B[i]-n_B[j]*val
        ENDFOR
     ENDIF ELSE BEGIN
        FOR i=j+1,cnt+j-1 DO BEGIN
           n_A[i,j:n-1]=n_A[i,j:n-1]-n_A[j,j:n-1]
           n_B[i]=n_B[i]-n_B[j]
        ENDFOR
        FOR i=0,j-1 DO BEGIN
           val=n_A[i,j]
           n_A[i,j:n-1]=n_A[i,j:n-1]-n_A[j,j:n-1]*val
           n_B[i]=n_B[i]-n_B[j]*val
        ENDFOR
     ENDELSE
  ENDFOR

  C=n_B

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
