
restore,'data.sav'

dlat = data.earthlat
dlon = data.earthlon
xuld = data.uldd

print,total(xuld)
print,hist1d(dlon,xuld,binsize=30,max=360,min=0,obin=l)/$
      hist1d(dlon,binsize=30,max=360,min=0)
print,hist1d(dlon,binsize=30,max=360,min=0)
print,l

END
