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
  freq=(findgen(length)+2)/(dseg*0.5^dt)

  fmin10=alog10(freq[0])
  fmax10=alog10(freq[-1])

  fmin10=floor(fmin10/lint)*lint
  fmax10=floor(fmax10/lint+1)*lint
  steps=floor((fmax10-fmin10)/lint)
  fbin=10^(findgen(steps)*lint+fmin10+lint/2)
  rbpsd=dblarr(steps)

  FOR j=0,steps-1 DO BEGIN
     rbpsd[j]=mean(psd[ $
                       where(freq GT fbin[j]*10^(-lint/2) $ 
                            AND freq LT fbin[j]*10^(lint/2))])
  ENDFOR

  window,0
  plot,fbin,rbpsd,psym=1,/xlog,yrange=[1.4,2.6]
  print, '----------------------------------'
  print, 'PSD function is rebinned...'
  print, 'Log int      :', 0.1
  print, 'Min freq     :', freq[0], ' Hz'
  print, 'Nyquist freq :', float(freq[-1]), ' Hz'
  print, 'Average PSD  :', float(mean(rbpsd)), ' rms^2/Hz'
  print, 'Sigma        :', float(stddev(rbpsd)), ' rms^2/Hz'
END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
