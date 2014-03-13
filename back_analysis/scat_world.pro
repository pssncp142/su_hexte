
restore,'data.sav'

device,decomposed=0

; Make a 10 degree latitude/longitude grid covering the Earth:
lat = REPLICATE(10., 73) # FINDGEN(37)/2. - 90.
lon = FINDGEN(73)/2. # REPLICATE(10, 37)

loadct,2

; Create a plotting window
WINDOW, 0, color=255

plot,[1,2],[3,4],color=255,back=255

MAP_SET, /mollweide, 0, 0, /ISOTROPIC, $
         /HORIZON,$
         /GRID, /CONTINENTS,xmargin=[2,15],ymargin=[0,2], $
         TITLE='Mcilwain L',/noerase,color=0
n=-1

xuld=data.mcilwain[0:n]-min(data.mcilwain[0:n])
plots,data.earthlon[0:n],data.earthlat[0:n],$
      color=xuld*190/max(xuld)+20,psym=3

MAP_GRID, latdel=30, londel=30, /LABEL, /HORIZON,color=0
;Draw continent outlines:
MAP_CONTINENTS, /coasts, mlinethick=1,color=0

colorbar2,ncolors=190,divisions=7,/vertical,/right,bottom=20,$
          position=[0.91, 0.07, 0.95, 0.88],$
          min=min(data.mcilwain[0:n]),max=max(data.mcilwain[0:n]),$
          format='(F6.2)',title='Mcilwain L'

END
