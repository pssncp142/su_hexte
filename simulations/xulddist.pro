PRO xulddist, pow, min_d, max_d, step, dist

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          24.11.2013
; 
; Returns deadtime distribution function of cosmic background
; events. Dead time is distributed in logarithmic.
;
; PURPOSE
;   - Use the distribution function on the decision of the dead time
;     for cosmic background events 
;
; INPUT 
;   - pow       Power of the distribution
;   - min_d     Minimum deadtime
;   - max_d     Maximum deadtime
;   - step      Step size for deadtime   
;               
; OUTPUT
;   - dist      Distribution function  
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

steps=floor((max_d-min_d)/step)

dist=fltarr(2,steps)

dist[0,*]=findgen(steps)*step+min_d+step

;dist[1,*]=((dist[0,*])^(pow+1)-min_d^(pow+1))$
;     /(max_d^(pow+1)-min_d^(pow+1))

A = 150/6.
B = 50

dist[1,*]=((A*dist[0,*]+B)^(pow+1)-(A*min_d+B)^(pow+1))$
     /((A*max_d+B)^(pow+1)-(A*min_d+B)^(pow+1))


END
