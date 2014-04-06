PRO lala
; Create a simple image to be warped:
loadct,1
window,0,color=255
image = BYTSCL(SIN(DIST(400)/10))
help,image
; Display the image so we can see what it looks like before
; warping:
;TV, image
latmin = -85
latmax = 85
; Left edge is 160 East:
lonmin = 0 
; Right edge is 70 West = +360:
lonmax = 360
;MAP_SET, 0, 0, /cylindrical, /ISOTROPIC,/continents,/grid,$
;   LIMIT=[latmin, lonmin, latmax, lonmax],color=255
;result = MAP_IMAGE(image,Startx,Starty, COMPRESS=1, $
;   LATMIN=latmin, LONMIN=lonmin, $
;   LATMAX=latmax, LONMAX=lonmax)
; Display the warped image on the map at the proper position:
;TV, result, Startx, Starty
; Draw gridlines over the map and image:
;MAP_GRID, latdel=30, londel=30, /LABEL, /HORIZON
; Draw continent outlines:
;loadct,2
;MAP_CONTINENTS, /coasts, /fill, mlinethick=1.5,color=150
END

device,decomposed=0

; Make a 10 degree latitude/longitude grid covering the Earth:
lat = REPLICATE(10., 73) # FINDGEN(37)/2. - 90.
lon = FINDGEN(73)/2. # REPLICATE(10, 37)

help,lat,lon

loadct,10

; Convert lat and lon to Cartesian coordinates:
X = COS(!DTOR * lon) * COS(!DTOR * lat)
Y = SIN(!DTOR * lon) * COS(!DTOR * lat)
Z = SIN(!DTOR * lat)
; Create the function to be plotted, set it equal
; to the distance squared from (1,1,1):
;F = (X-1.)^2 + (Y-1.)^2 + (Z-1.)^2
F = lat*0
F[10,10] = 100
F[40,30] = 100
; Create a plotting window
WINDOW, 0, TITLE='Mollweide Contour',color=255

plot,[1,2],[3,4],color=255,back=255
;plot,[1,2],[3,4],color=255,back=255

MAP_SET, /mollweide, 0, 0, /ISOTROPIC, $
   /HORIZON, /GRID, /CONTINENTS, $
   TITLE='Mollweide asContour',/noerase,color=0
CONTOUR, F, lon, lat, NLEVELS=60, $
   /OVERPLOT, /DOWNHILL, /FOLLOW, /fill, title='fuck'
MAP_GRID, latdel=30, londel=30, /LABEL, /HORIZON,color=0
;Draw continent outlines:
loadct,1
MAP_CONTINENTS, /coasts, mlinethick=1.5,color=1


END
