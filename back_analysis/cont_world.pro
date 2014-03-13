
restore,'data.sav'

device,decomposed=0
loadct,2

lat = REPLICATE(10., 36) # FINDGEN(15)*2./5. - 28.
lon = FINDGEN(36) # REPLICATE(10, 15) + 5.0  

print,lon,lat

dlat = data.earthlat
dlon = data.earthlon
xuld = data.mcilwain

bin2d, 36, 15, 0, 360, -31, 31, dlon, dlat, xuld, $
       map, num, 1

WINDOW, 0, color=255

plot,[1,2],[3,4],color=255,back=255

MAP_SET, /mollweide, 0, 0, /ISOTROPIC, $
         /HORIZON,$
         /GRID, /CONTINENTS,xmargin=[2,15],ymargin=[0,2], $
         TITLE='McIlwain L',/noerase,color=0

contour,map[*,0:-1],lon[*,0:-1],lat[*,0:-1],/overplot,/fill,nlev=10

MAP_GRID, latdel=30, londel=30, /LABEL, /HORIZON,color=0
;Draw continent outlines:
MAP_CONTINENTS, /coasts, mlinethick=1,color=0


imd=0

colorbar2,ncolors=230,divisions=10,/vertical,/right,bottom=0,$
          position=[0.91, 0.07, 0.95, 0.88],$
          min=min(xuld)*0,max=max(xuld),$
          format='(F6.2)',title='Mcilwain L'


END
