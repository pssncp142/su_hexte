; docformat = 'rst'
;+
; This is an example program to demonstrate how to create a contour plot on a global
; map with IDL function graphics routines.
;
; :Categories:
;    Graphics
;
; :Examples:
;    Save the program as "contours_on_global_map_fg.pro" and run it like this::
;       IDL>contours_on_global_map_fg_fullsize
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
;        Written, 27 February 2014 David W. Fanning.
;
; :Copyright:
;     Copyright (c) 2014, Fanning Software Consulting, Inc.
;-
PRO Contours_on_Global_Map_FG

    ; Don't forget compile options in IDL 8 programs or there can be problems
    Compile_Opt idl2

    ; Restore the NCEP temperature data.
    Restore, 'contours_on_global_map.sav' ; lat, lon, data
  
    ; Housekeeping chores. The same for all graphics plots.
    nlevels = 12
    xrange = [Min(lon), Max(lon)]
    yrange = [Min(lat), Max(lat)]
    center_lon = (xrange[1]-xrange[0])/2.0 + xrange[0]
    nlevels = 12
    levels = cgConLevels(Float(data), NLevels=nlevels+1, $
        MinValue=Floor(Min(data)), STEP=step, Factor=1)
    mylat = 40.6  ; Latitude of Fort Collins, Colorado.
    mylon = 254.9 ; Longitude of Fort Collins, Colorado.
    
    ; Load the colors for the plots.
    cgLoadCT, 2, /Reverse, /Brewer, NColors=nlevels, RGB_Table=rgb
    rgb[11,*] = [255, 255, 255]
    
    win = WINDOW(WINDOW_TITLE = 'Contours on a Global Map', $
        dimensions = [700, 600])
        
    ; Disable updates until finished.
    win.Refresh, /Disable
    
    ; The map projection we are using. Note the latitude limits
    ; in the LIMIT keyword. This is required to avoid have extra
    ; labels on the box axes.
    mp1 = map('Equirectangular', CENTER_LONGITUDE=180, $
        POSITION=[0.1,0.1,0.90,0.75], $
        LABEL_POSITION = 0, BOX_AXES=1, $
        GRID_LATITUDE = 30, GRID_LONGITUDE = 45, $
        /CURRENT, ASPECT_RATIO=0, LIMIT=[-89.99, 0, 89.99, 360])
    mp1['Latitudes'].label_angle=90
    mp1['Longitudes'].label_angle=0
    
    ; Create a grid object to label top and right axes.
    charcoal = cgColor('charcoal', /Triple, /Row)
    grid = MapGrid( $
        LONGITUDE_MIN=0, LONGITUDE_MAX=360, $
        LATITUDE_MIN=-90, LATITUDE_MAX=90, $
        GRID_LONGITUDE=45, GRID_LATITUDE=30, $
        LABEL_POSITION=1, COLOR=charcoal)
    FOREACH g,grid.latitudes DO g.label_angle=270
    FOREACH g,grid.longitudes DO g.label_angle=0
    
    ; Filled contour plot.
    cn = contour(data, lon, lat, /OVERPLOT, $
        GRID_UNITS=2, MAP_PROJECTION='Equirectangular', $
        RGB_TABLE=rgb, /CURRENT, RGB_INDICES=Indgen(nlevels), $
        C_VALUE=levels, /FILL)
        
    ; Overplot contour lines.
    cn1 = contour(data, lon, lat, /OVERPLOT, $
        GRID_UNITS=2, MAP_PROJECTION='Equirectangular', $
        RGB_TABLE=rgb, /CURRENT, $
        C_VALUE=levels, C_COLOR=!Color.White)
        
    ; Draw continents.
    c = MapContinents(Color=cgColor('tomato', /Triple, /Row))
    
    ; Draw colorbar.
    cb = Colorbar(Tickname=levels, RGB_TABLE=rgb, Range=[Min(levels), $
        Max(levels)], Major=11, /Border_On, Title='Temperature $\deg$K', $
        Position=[0.1, 0.90, 0.9, 0.95], Minor=0, TAPER=3)
        
    ; Add symbol at Fort Collins location.
    s = Symbol(mylon, mylat, /Data, /Current, 'Star', $
        /Sym_Filled, Sym_Color='red')
        
    ; Refresh and draw the graphic in the window.
    win.Refresh
    
    ; Create a PostScript file. Linestyles are not preserved in IDL 8.2.3 due
    ; to a bug. Only encapsulated PostScript files can be created.
    win.save, 'contours_on_global_map_fg.eps'
    
    ; Create a PNG file with a width of 600 pixels. Resolution of this
    ; PNG file is not very good.
    ;win.save, 'image_with_contours_overlayed_fg.png', WIDTH=600
    
    ; For better resolution PNG files, make the PNG full-size, then resize it
    ; with ImageMagick. Requires ImageMagick to be installed.
    win.save, 'contours_on_global_map_fg_fullsize.png'
    Spawn, 'convert contours_on_global_map_fg_fullsize.png -resize 600 contours_on_global_map_fg.png'
    
END