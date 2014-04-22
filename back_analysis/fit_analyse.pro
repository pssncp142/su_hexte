
FUNCTION f, a, top
  RETURN, (-((top*1e3)*160/6.+50)^(-a)+((2.5)*160/6.+50)^(-a))/a
END

spawn,'wc -l fit_res.txt', l
data = fltarr(4, l)

openr, 1, 'fit_res.txt'
readf, 1, data
close, 1

xuld = [86.65, 86.62, 87.20, 87.22, 85.72, 84.33, 85.09, 88.68, $
       103.92, 128.67, 96.89, 88.29]

rate = [40.59, 44.61, 50.02, 46.96, 46.63, 46.89, 46.44, 45.57, $
       40.90, 35.33, 39.37, 40.50]

a = fltarr(l/12)
FOR i=0, n_elements(a)-1 DO a[i] = data[1, 12*i]

FOR i=0, n_elements(a)-1 DO BEGIN
   FOR j=0, 11 DO BEGIN
      print, a[i], data[0,12*i+j]/rate[j], data[2,12*i+j]/rate[j],$
             data[2,12*i+j]*f(a[i]-1,data[3,12*i+j])*8e2/$
             (xuld[j]-data[0,12*i+j]/rate[j])/rate[j]-100,$
             data[3,12*i+j]
   ENDFOR
ENDFOR

END
