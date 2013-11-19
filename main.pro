PRO main,freq, rbpsd

  back_r=1000.
  xuld_r=100.
  eff=[0.,0.6,0.8,0.95]
  dur=2.^15
  dseg=2.^14
  dt=9.

  print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
  ;poissonlc,rate, dur, dt, lc
  observe, back_r, xuld_r, dur, dt, eff, lc
  divseg, lc, dseg, seglc
  psdcalc, seglc, dt, psd
  psdrebin, psd, dseg, dt, freq, rbpsd
  print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

END
