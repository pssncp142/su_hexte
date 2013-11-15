PRO main

  rate=250.
  dur=2.^15
  dseg=2.^14
  dt=9.

  poissonlc,rate, dur, dt, lc
  divseg, lc, dseg, seglc
  psdcalc, seglc, dt, psd
  print,'asd',dur,2^dt,dseg,dur*2^dt/dseg
  psdrebin, psd, dseg, dt
  print,dur*0.5^dt/dseg

END
