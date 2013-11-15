PRO psdrebin, psd, dseg, dt, rbpsd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          15.11.2013
; 
; Returns rebinned PSD function
;
; PURPOSE
;   - Adjust the PSD function by rebinning process
;
; INPUT 
;   - psd       Segmented light curve from divseg.pro
;   - dseg      Length of the segmented light curve
;   - dt        2^dt time resolution   
;               
; OUTPUT
;   - rbpsd     rbpsd function  
;
; NOTES
;   - Logarithmic binning is applied for now with 0.1 interval
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  lint=0.1

  length=floor(n_elements(psd)/4)
  freq=(findgen(length)+1)/(dseg*0.5^dt)
  print,freq[-5:-1]

  print,psd[0]
  fmin10=alog10(freq[0])
  print,psd[0]
  fmax10=alog10(freq[-1])
  print,psd[0]
  print,fmin10,fmax10

  print,psd[0]
  fmin10=floor(fmin10/lint)*lint
  fmax10=floor(fmax10/lint+1)*lint
  steps=floor((fmax10-fmin10)/lint)
  fbin=10^(findgen(steps)*lint+fmin10+lint/2)
  print,psd[0]
  rbpsd=dblarr(steps)
  print,psd[0]

  FOR j=0,steps-1 DO BEGIN
     rbpsd[j]=mean(psd[ $
                       where(freq GT fbin[j]*10^(-lint/2) $ 
                            AND freq LT fbin[j]*10^(lint/2))])
  ENDFOR

  print,rbpsd[0]
  plot,fbin,rbpsd,psym=1,/xlog

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
