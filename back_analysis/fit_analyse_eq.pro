
FUNCTION f, a, top
  RETURN, (-((top*1e3)*160/6.+50)^(-a)+((2.5)*160/6.+50)^(-a))/a
END

spawn,'wc -l fit_res_man.txt', l
data = fltarr(4, l)

openr, 1, 'fit_res_man.txt'
readf, 1, data
close, 1

xuld = [[85.10, 79.38, 74.58, 72.03, 73.52, 77.92, $
        83.43, 93.39, 118.37, 129.24, 96.90, 88.30],$
        [91.28, 99.34, 106.65, 105.87, 102.32, 92.94, $
         86.93, 84.57, 82.83, 10.00, 10.00, 10.00]]

rate = [[41.17, 48.84, 57.50, 55.31, 52.69, 49.99, $
        45.51, 41.01, 36.45, 35.21, 39.37, 40.53],$
        [39.00, 37.95, 38.34, 38.04, 39.64, 43.38, $
         47.28, 49.18, 48.26, 10.00, 10.00, 10.00]]

a = data[1,0]

lon = indgen(12)*30
ndx = ['-1','-2']
exc = ['360-330-2','330-300-2','300-270-2']

FOR i=0, n_elements(ndx)-1 DO BEGIN
   FOR j=0, n_elements(lon)-1 DO BEGIN
      strlon = strtrim(lon[j]+30,1)+'-'+strtrim(lon[j],1)+ndx[i]
      IF strlon NE exc[0] AND $
         strlon NE exc[1] AND $
         strlon NE exc[2] THEN BEGIN
          intxuld=data[2,12*i+j]*f(a-1,data[3,12*i+j])*4e2/$
              (xuld[12*i+j]-data[0,12*i+j]/rate[12*i+j])/rate[12*i+j]
          print,strlon
          print, data[0,12*i+j]/rate[12*i+j],intxuld, $
                data[0,12*i+j]/rate[12*i+j]+intxuld,xuld[12*i+j],$
                (data[0,12*i+j]/rate[12*i+j]+intxuld)/xuld[12*i+j]
      ENDIF
   ENDFOR
ENDFOR

END
