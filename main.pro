PRO main

  rate=1050.
  dur=2.^14
  dseg=2.^12
  dt=9.

  poissonlc,rate, dur, dt, lc
  divseg, lc, dseg, seglc
  psdcalc, seglc, dt, psd
  print,'asd',dur,2^dt,dseg,dur*2^dt/dseg
  psdrebin, psd, dseg, dt
  print,dur*0.5^dt/dseg

END
