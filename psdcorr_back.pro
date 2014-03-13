FUNCTION model, A, B, f
  RETURN, A*sin(!pi*B*f)^2/(!pi*f)^2
END

FUNCTION all, f, P
  RETURN, 2*P[0]+model(P[1],P[2],f)+model(P[3],P[4],f)+model(P[5],P[6],f)+$
          model(P[7],P[8],f)+model(P[9],P[10],f)
END

FUNCTION all2, f, P
  RETURN, 2*P[0]+model(P[1],P[2],f)+P[8]* $
          (model(P[3],(P[3]*1e3)^(-P[7]),f)+model(P[4],(P[4]*1e3)^(-P[7]),f)+$
           model(P[5],(P[5]*1e3)^(-P[7]),f)+model(P[6],(P[6]*1e3)^(-P[7]),f)+$
           model(P[9],(P[9]*1e3)^(-P[7]),f))
                                         
END

FUNCTION all3, f, P
  RETURN, 2*P[0]+model(P[1],P[2],f)+intmodel(f,P[3],P[4],P[5],P[6])
END

PRO psdcorr_back, inplength,inpdseg, $
                  freq,noipsd, $
                  clusterrate=clusterrate,xuld=xuld, $
                  cluster_a=cluster_a,cluster_b=cluster_b, $
                  back_f = f_b, back_psd=psd_b, back_err=err_b, $
                  miyamoto=miyamoto, $
                  avgrate=avgrate,avgback=avgback, $
                  chatty=chatty

;; lightcurve parameters
dseg     = long(inpdseg)
length   = double(inplength)
bt       = double(length/dseg)
time     = double(bt*findgen(dseg))

;; Fourier frequency array
fourierfreq,time,freq

hpsd = (all3(freq,f_b)-2.)*avgrate/avgback[0]+2.
print,'oooooooooooooooooooooooooooooooooooooooooooo'
print,string(avgrate)+' '+string(avgback)

noipsd=(hpsd*dseg*dseg*avgrate)/(2.*length)
psdnorm,avgrate,length,dseg,noipsd, $
        miyamoto=1, $
        avgback=avgback[1],chatty=chatty

END
