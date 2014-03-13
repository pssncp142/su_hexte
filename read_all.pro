PRO read_all,data

;spawn,'cat '+id_file,ids
spawn,'ls -d *-*-*',ids
spawn,'pwd',path

cnt=size(ids)
print,cnt
cnt=cnt[1]
print,cnt

FOR i=0,cnt-1 DO BEGIN
   read_status,path,strtrim(ids[i]),t_data
   print,ids[i]
   IF i EQ 0 THEN BEGIN

      time=t_data.time
      earthlat=t_data.earthlat
      earthlon=t_data.earthlon
      altit=t_data.altit
      mcilwain=t_data.mcilwain
      xuldd=t_data.xuldd
      uldd=t_data.uldd

   ENDIF ELSE BEGIN

      help,time
      time=[time,t_data.time]
      earthlat=[earthlat,t_data.earthlat]
      earthlon=[earthlon,t_data.earthlon]
      altit=[altit,t_data.altit]
      mcilwain=[mcilwain,t_data.mcilwain]
      xuldd=[xuldd,t_data.xuldd]
      uldd=[uldd,t_data.uldd]

   ENDELSE

ENDFOR

data={time:time,earthlat:earthlat,earthlon:earthlon,$
     altit:altit,mcilwain:mcilwain,xuldd:xuldd,uldd:uldd}

END
