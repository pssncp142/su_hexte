


file='all/light/processed/0014336_seg_bkg.xdrlc.gz'
print,file
xdrlc_r,file,t,r
help,r
print,mean(r[*,0])

END
