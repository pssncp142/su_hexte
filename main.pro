PRO main,reb

  back_r=1000
  xuld_r=100
  dur=2.^15
  dseg=2.^14
  dt=9.

  print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
  ;poissonlc,rate, dur, dt, lc
  observe, back_r, xuld_r, dur, dt, lc
  divseg, lc, dseg, seglc
  psdcalc, seglc, dt, psd
  psdrebin, psd, dseg, dt, reb
  print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

END
