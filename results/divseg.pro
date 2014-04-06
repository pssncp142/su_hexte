PRO divseg, lc, dseg, seglc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          15.11.2013
; 
; Divides the light curve into segments
; 
; PURPOSE  
;   - Prepare light curve for PSD calculation
;
; INPUT 
;   - lc        light curve array
;   - dseg      number of data points for each segmented light curves
;
; OUTPUT
;   - seglc     segmented light curves in the form [nof,dseg] 
;
; NOTES
;   - There is a range for array index should be corrected
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  n_lc = floor(n_elements(lc)/dseg) 
  seglc=fltarr(n_lc,dseg)
  FOR i=0,n_lc-1 DO BEGIN
     seglc[i,*]=lc[(dseg*i):(i+1)*dseg-1]
  ENDFOR

  print, '----------------------------------'
  print, 'Light curve is segmented...'
  print, '# of lc     :',n_lc
  print, '# of points :',dseg
END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
