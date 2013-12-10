PRO progressbar,ndx,tot_ndx,start,points

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar  10.12.2013
;
; Progress bar program for command line
;
; INPUT
;  - ndx          index for the current event
;  - tot_ndx      # of event to perform
;  - start        starting time for the progress
;  - points       controls number of points in the progress bar 100/points
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  p=100.*ndx/tot_ndx
  print,string(10B)+string(27B)+'[1A',format='(A, $)'
  x='['
  for j=0,floor(p)/points DO x=x+'*'
  for j=1,50-floor(p)/points DO x=x+' '
  print,x,format='(A,":",$)'
  print,p,format='(I5,"%]  EL :",$)'
  IF ndx NE 0 THEN BEGIN 
     print,(systime(1)-start)*(100.-p)/p,format='(I5,"/ TOT :",$)'
     print,(systime(1)-start)*100./p,format='(I5,$)'
  ENDIF

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
