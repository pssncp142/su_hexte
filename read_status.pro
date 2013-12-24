PRO read_status,path,data

f_path=path+'/house/'

tmp_p=strsplit(path,'.',/extract)

filt_f=f_path+tmp_p[0]+'.'+tmp_p[1]+'_filter.xfl'
gti_f=f_path+tmp_p[0]+'.'+tmp_p[1]+'_good_hexte.gti'
hk_f=F_path+tmp_p[0]+'.'+tmp_p[1]+'_FH53_a.gz'

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

time2=loadcol(filt_f,'TIME')
uldD0=loadcol(hk_f,'ctUldD0')
xuldD0=loadcol(hk_f,'ctXuldD0')
;usdD0=loadcol(hk_f,'ctUsdD0')
;hwvetoD0=loadcol(hk_f,'ctHwVetoD0')
;coinD0=loadcol(hk_f,'ctCoinGcD0')
;amrD0=loadcol(hk_f,'ctArmD0')
;trigD0=loadcol(hk_f,'ctTrigD0')
uldD1=loadcol(hk_f,'ctUldD0')
xuldD1=loadcol(hk_f,'ctXuldD0')
;usdD1=loadcol(hk_f,'ctUsdD0')
;hwvetoD1=loadcol(hk_f,'ctHwVetoD0')
;coinD1=loadcol(hk_f,'ctCoinGcD0')
;amrD1=loadcol(hk_f,'ctArmD0')
;trigD1=loadcol(hk_f,'ctTrigD0')
uldD2=loadcol(hk_f,'ctUldD0')
xuldD2=loadcol(hk_f,'ctXuldD0')
usdD2=loadcol(hk_f,'ctUsdD0')
;hwvetoD2=loadcol(hk_f,'ctHwVetoD0')
;coinD2=loadcol(hk_f,'ctCoinGcD0')
;amrD2=loadcol(hk_f,'ctArmD0')
;trigD2=loadcol(hk_f,'ctTrigD0')
uldD3=loadcol(hk_f,'ctUldD0')
xuldD3=loadcol(hk_f,'ctXuldD0')
usdD3=loadcol(hk_f,'ctUsdD0')
;hwvetoD3=loadcol(hk_f,'ctHwVetoD0')
;coinD3=loadcol(hk_f,'ctCoinGcD0')
;amrD3=loadcol(hk_f,'ctArmD0')
;trigD3=loadcol(hk_f,'ctTrigD0')

;sh_dead=loadcol(hk_f,'ctDeadSelShd')
;lldpm=loadcol(hk_f,'ctLldPm')

data={time:time,time_saa:time_saa,earthlat:earthlat,earthlon:earthlon,$
      altitude:altitude,mcilwain:mcilwain,bkgd_theta:bkgd_theta,$
      bkgd_phi:bkgd_phi,start:start,stop:stop,$
      uldd0:uldd0,xuldd0:xuldd0,uldd1:uldd1,xuldd1:xuldd1,$
      uldd2:uldd2,xuldd2:xuldd2,uldd3:uldd3,xuldd3:xuldd3}

END
