
PRO four, path

  type                = 'high'
  maxdim              = 512L*28L
  dim                 = 512L*28L
  normindiv           = 0
  leahy               = 1
  back_leahy          = 1
;hexte_bkg           = 0
  nof                 = 1
  logf                = 0.05
  hexte_dt            = 0
;ninstr              = numpcu
;deadtime            = 1D-5
;nonparalyzable      = 0
  fcut                = 256D0
  xmin                = [0.02,0.02,0.02]       &  xmax        = [256.,256.,256.]
  ymin                = [1.9,1.8,1.8]        &  ymax        = [2.2,9.4,9.4]
  xtenlog             = [1,1,1]                &  ytenlog     = [0,0,0]
  sym                 = [3,-3]
  ebounds             = [[15,30],[30,80]]
  obsid               = 'obs'
  username            = 'Yigit Dallilar'
  date                = systime(0)
  color               = [50,50,50]
  postscript          = 1
  chatty              = 1


  rxte_fourier2,path,type=type, $
                maxdim=maxdim,dim=dim,normindiv=normindiv, $
                schlittgen=schlittgen,leahy=leahy,miyamoto=miyamoto, $
                hexte_bkg=hexte_bkg,back_leahy=back_leahy,pca_bkg=pca_bkg, $
                linf=linf,logf=logf,nof=nof, $
                zhang_dt=zhang_dt,   ninstr=ninstr,deadtime=deadtime, $
                nonparalyzable=nonparalyzable, $
                pca_dt=pca_dt, $
                hexte_dt=hexte_dt, back_corr=back_corr, $
                cluster_a=cluster_a,cluster_b=cluster_b, $
                fmin=fmin,fmax=fmax,fcut=fcut, $
                xmin=xmin,xmax=xmax, $
                ymin=ymin,ymax=ymax, $
                xtenlog=xtenlog,ytenlog=ytenlog,sym=sym, $
                ebounds=ebounds,obsid=obsid,username=username,date=date, $
                color=color,postscript=postscript,chatty=chatty

END

   four,'arch1/all'

END
