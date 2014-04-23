
restore,'/data1/ydallilar/work/back_data/data.sav'

dlat = data.earthlat
dlon = data.earthlon[where(dlat lt 0)]
xuld = data.xuldd[where(dlat lt 0)]

;plot,dlat[where(dlat gt 0)]

print,hist1d(dlon,xuld,binsize=30,max=360,min=0,obin=l)/$
      hist1d(dlon,binsize=30,max=360,min=0)
print,hist1d(dlon,binsize=30,max=360,min=0)
print,l

END
