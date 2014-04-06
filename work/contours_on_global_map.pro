; docformat = 'rst'
;+
; This is an example program to demontrate how to create a filled contour plot
; on a global map projection with Coyote Graphics routines.
;
; :Categories:
;    Graphics
;    
; :Examples:
;    Save the program as "filled_contours_on_global_map.pro" and run it like this::
;       IDL> .RUN filled_contours_on_global_map
;       
; :Author:
;    FANNING SOFTWARE CONSULTING::
;       David W. Fanning 
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: david@idlcoyote.com
;       Coyote's Guide to IDL Programming: http://www.idlcoyote.com
;
; :History:
;     Change History::
;        Written, 23 January 2013 by David W. Fanning.
;
; :Copyright:
;     Copyright (c) 2013, Fanning Software Consulting, Inc.
;-
PRO Contours_On_Global_Map

  ; Restore the NCEP temperature data.
  Restore, 'contours_on_global_map.sav' ; lat, lon, data
  
  ; House keeping tasks. Set up variables. Many of these would normally
  ; be passed in as positional and keyword parameters.
  xrange = [Min(lon), Max(lon)]
  yrange = [Min(lat), Max(lat)]
  center_lon = (xrange[1]-xrange[0])/2.0 + xrange[0]
  nlevels = 12
  levels = cgConLevels(Float(data), NLevels=nlevels+1, $
       MinValue=Floor(Min(data)), STEP=step, Factor=1)
       
  ; Set up the colors to be used in the plot.
  cgLoadCT, 0
  cgLoadCT, 2, /Reverse, /Brewer, NColors=nlevels-1, Bottom=1
  TVLCT, cgColor('white', /Triple), nlevels
  
  ; Set up the Coyote Graphics graphics display window.
  cgDisplay, Title='Contour on Map Plot'
  
  ; Set up the map projection.
  map = Obj_New('cgMap', 'Equirectangular', Ellipsoid=19, $
     XRange=xrange, YRange=yrange, /LatLon_Ranges, CENTER_LON=center_lon, $
     Position=[0.1, 0.1, 0.9, 0.8], Limit=[Min(lat), Min(lon), Max(lat), Max(lon)])
  map -> Draw
  
  ; Draw the contour plot.
  cgContour, data, lon, lat, /Cell_Fill, /Overplot, /Outline, $
     C_Colors=Indgen(nlevels)+1, Levels=levels, Map=map, OutColor='White'
   
  ; Add map annotations.
  cgMap_Grid, Map=map, /Box
  cgMap_Continents, Map=map, Color='tomato'
  cgColorbar, Range=[Min(levels), Max(levels)-step], OOB_High=nlevels, $
     NColors=nlevels-1, Bottom=1, /Discrete, $
     Title='Temperature ' + cgSymbol('deg') + 'K', $
     Position=[0.1, 0.91, 0.9, 0.95]  
  
END ;*****************************************************************

; This main program shows how to call the program and produce
; various types of output.

  ; Display the contour plot in a graphics window.
  Contours_On_Global_Map
  
  ; Display the contour plot in a resizeable graphics window.
  cgWindow, 'Contours_On_Global_Map', WBackground='white', $
      WTitle='Contours On Global Map in Resizeable Graphics Window'
  
  ; Create a PostScript file.
  cgPS_Open, 'contours_on_global_map.ps'
  Contours_On_Global_Map
  cgPS_Close
  
  ; Create a PNG file with a width of 600 pixels.
  cgPS2Raster, 'contours_on_global_map.ps', /PNG, Width=600

END