PRO read_status,path,id,data

;+
;
; Yigit Dallilar    04.01.2014 
; Sabanci University
;
; Reads housekeeping, git and filter files and returns desired data
;
; PURPOSE
;  - Cosmic background analysis depending on the spacecraft orbit 
;
; INPUT
;  - path       Path of the observation
;  - id         Observation id (ex. 70110-01-70-00)
;
; OUTPUT
;  - data       Struct of the obtained data
;
; NOTES
;  - Observation data should be located inside the directory
;    ex. 70110-01-70-00/70.00ha.all
;  - "xtescript" provides the directory formation for this code
;    filter file also added ./house directory in the same format as 
;    housekeeping and filter files
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

id_spl=strsplit(id,'-',/extract)

f_path=path+'/'+id+'/'+id_spl[2]+'.00ha.all/house/'

filt_f=f_path+id_spl[2]+'.00ha_filter.xfl'
gti_f=f_path+id_spl[2]+'.00ha_good_hexte.gti'
hk_f=f_path+id_spl[2]+'.00ha_FH53_a.gz'

d_time=loadcoll(filt_f,'TIME')
d_time_saa=loadcoll(filt_f,'TIME_SINCE_SAA')
d_earthlat=loadcoll(filt_f,'ACSEARTHLAT')
d_earthlon=loadcoll(filt_f,'ACSEARTHLON')
d_altit=loadcoll(filt_f,'ACSALTITUDE')
d_mcilwain=loadcoll(filt_f,'MCILWAIN_L')
d_time2=loadcoll(hk_f,'TIME')
d_uldd=loadcoll(hk_f,'ctUldD0')+loadcoll(hk_f,'ctUldD1')+$
      loadcoll(hk_f,'ctUldD2')+loadcoll(hk_f,'ctUldD3')
d_uldd=d_uldd*0.25
d_xuldd=loadcoll(hk_f,'ctXuldD0')+loadcoll(hk_f,'ctXuldD1')+$
       loadcoll(hk_f,'ctXuldD2')+loadcoll(hk_f,'ctXuldD3')
d_xuldd=d_xuldd*0.25

start=loadcoll(gti_f,'START')
stop=loadcoll(gti_f,'STOP')

size=size(start)
IF size[0] EQ 0 THEN cnt=1 ELSE cnt=size[1]
ndx=dblarr(cnt,2)
ndx_cnt=0

d_time_saa=interpol(d_time_saa,d_time,d_time2)
d_earthlat=interpol(d_earthlat,d_time,d_time2)
d_earthlon=interpol(d_earthlon,d_time,d_time2)
d_altit=interpol(d_altit,d_time,d_time2)

ndx_m=where(d_mcilwain GT -100 AND d_mcilwain LT 100)
d_mcilwain=interpol(d_mcilwain[ndx_m],d_time[ndx_m],d_time2)

FOR i=0,cnt-1 DO BEGIN
   tmp=where(d_time2 GT start[i] AND d_time2 LT stop[i])
   IF tmp[0] EQ -1 THEN stop
   ndx[i,0]=min(tmp)
   ndx[i,1]=max(tmp)
   ndx_cnt=ndx_cnt+ndx[i,1]-ndx[i,0]+1
ENDFOR

time=dblarr(ndx_cnt)
earthlat=fltarr(ndx_cnt)
earthlon=fltarr(ndx_cnt)
altit=fltarr(ndx_cnt)
mcilwain=fltarr(ndx_cnt)
xuldd=fltarr(ndx_cnt)
uldd=fltarr(ndx_cnt)

last=0
FOR i=0,cnt-1 DO BEGIN
   time[last:ndx[i,1]-ndx[i,0]+last]=d_time2[ndx[i,0]:ndx[i,1]]
   earthlat[last:ndx[i,1]-ndx[i,0]+last]=d_earthlat[ndx[i,0]:ndx[i,1]]
   earthlon[last:ndx[i,1]-ndx[i,0]+last]=d_earthlon[ndx[i,0]:ndx[i,1]]
   altit[last:ndx[i,1]-ndx[i,0]+last]=d_altit[ndx[i,0]:ndx[i,1]]
   mcilwain[last:ndx[i,1]-ndx[i,0]+last]=d_mcilwain[ndx[i,0]:ndx[i,1]]
   xuldd[last:ndx[i,1]-ndx[i,0]+last]=d_xuldd[ndx[i,0]:ndx[i,1]]
   uldd[last:ndx[i,1]-ndx[i,0]+last]=d_uldd[ndx[i,0]:ndx[i,1]]
   last=last+ndx[i,1]-ndx[i,0]+1
ENDFOR

data={time:time,earthlat:earthlat,earthlon:earthlon,altit:altit,$
     mcilwain:mcilwain,xuldd:xuldd,uldd:uldd}

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;bkgd_theta=loadcol(filt_f,'BKGD_THETA')
;bkgd_phi=loadcol(filt_f,'BKGD_PHI')
;time2=loadcol(filt_f,'TIME')
;uldD0=loadcol(hk_f,'ctUldD0')
;xuldD0=loadcol(hk_f,'ctXuldD0')
;usdD0=loadcol(hk_f,'ctUsdD0')
;hwvetoD0=loadcol(hk_f,'ctHwVetoD0')
;coinD0=loadcol(hk_f,'ctCoinGcD0')
;amrD0=loadcol(hk_f,'ctArmD0')
;trigD0=loadcol(hk_f,'ctTrigD0')
;uldD1=loadcol(hk_f,'ctUldD0')
;xuldD1=loadcol(hk_f,'ctXuldD0')
;usdD1=loadcol(hk_f,'ctUsdD0')
;hwvetoD1=loadcol(hk_f,'ctHwVetoD0')
;coinD1=loadcol(hk_f,'ctCoinGcD0')
;amrD1=loadcol(hk_f,'ctArmD0')
;trigD1=loadcol(hk_f,'ctTrigD0')
;uldD2=loadcol(hk_f,'ctUldD0')
;xuldD2=loadcol(hk_f,'ctXuldD0')
;usdD2=loadcol(hk_f,'ctUsdD0')
;hwvetoD2=loadcol(hk_f,'ctHwVetoD0')
;coinD2=loadcol(hk_f,'ctCoinGcD0')
;amrD2=loadcol(hk_f,'ctArmD0')
;trigD2=loadcol(hk_f,'ctTrigD0')
;uldD3=loadcol(hk_f,'ctUldD0')
;xuldD3=loadcol(hk_f,'ctXuldD0')
;usdD3=loadcol(hk_f,'ctUsdD0')
;hwvetoD3=loadcol(hk_f,'ctHwVetoD0')
;coinD3=loadcol(hk_f,'ctCoinGcD0')
;amrD3=loadcol(hk_f,'ctArmD0')
;trigD3=loadcol(hk_f,'ctTrigD0')
;sh_dead=loadcol(hk_f,'ctDeadSelShd')
;lldpm=loadcol(hk_f,'ctLldPm')
