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

time=loadcol(filt_f,'TIME')
time_saa=loadcol(filt_f,'TIME_SINCE_SAA')
earthlat=loadcol(filt_f,'ACSEARTHLAT')
earthlon=loadcol(filt_f,'ACSEARTHLON')
altitude=loadcol(filt_f,'ACSALTITUDE')
mcilwain=loadcol(filt_f,'MCILWAIN_L')
bkgd_theta=loadcol(filt_f,'BKGD_THETA')
bkgd_phi=loadcol(filt_f,'BKGD_PHI')

start=loadcol(gti_f,'START')
stop=loadcol(gti_f,'STOP')

data={time:loadcol(filt_f,'TIME'),$
      time_saa:loadcol(filt_f,'TIME_SINCE_SAA'),$
      earthlat:loadcol(filt_f,'ACSEARTHLAT'),$
      earthlon:loadcol(filt_f,'ACSEARTHLON'),$
      altitude:loadcol(filt_f,'ACSALTITUDE'),$
      mcilwain:loadcol(filt_f,'MCILWAIN_L'),$
      bkgd_theta:loadcol(filt_f,'BKGD_THETA'),$
      bkgd_phi:loadcol(filt_f,'BKGD_PHI'),$
      start:loadcol(gti_f,'START'),$
      stop:loadcol(gti_f,'STOP'),$
      uldd0:loadcol(hk_f,'ctUldD0'),$
      xuldd0:loadcol(hk_f,'ctXuldD0'),$
      uldd1:loadcol(hk_f,'ctUldD1'),$
      xuldd1:loadcol(hk_f,'ctXuldD1'),$
      uldd2:loadcol(hk_f,'ctUldD2'),$
      xuldd2:loadcol(hk_f,'ctXuldD2'),$
      uldd3:loadcol(hk_f,'ctUldD3'),$
      xuldd3:loadcol(hk_f,'ctXuldD3')}


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

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
