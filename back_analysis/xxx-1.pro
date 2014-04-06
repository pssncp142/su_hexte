
FUNCTION exist, id ,l
  spawn,'ls '+string(id)+'/'+strtrim(l+30,1)+'-'+strtrim(l,1)+$
        '-1.all/light/raw',a
  s=size(a)
  if s[0] eq 1 then return,1 else return,0
END

PRO do_sync, id, l
  cd,id
  catch,stats
  IF stats NE 0 THEN BEGIN
     catch,/cancel
     goto,error
  ENDIF
  path                = strtrim(l+30,1)+'-'+strtrim(l,1)+'-1.all'
  channels            = ['10-255','10-255']
  hexte               = 1
  bkg                 = 1
  orgbin              = [-9D0,-9D0,-9D0]
  newbin              = [1L,1L,1L]
  dseg                = 1L*512L*32L
  obsid               = '30191/'+path
  username            = 'Yigit Dallilar'
  date                = systime(0)
  chatty              = 1
  rxte_syncseg,path,channels, $
               hexte=hexte,bkg=bkg,back_p=back_p,back_m=back_m, $
               orgbin=orgbin,newbin=newbin,dseg=dseg, $
               obsid=id,username=username,date=date, $
               chatty=chatty,novle=novle
  error: print,'error',stats
  print,'AAA:',id,'  '+strtrim(l+30,1)+'-'+strtrim(l,1)
  cd,'..'
END

spawn,'cat ids.txt',ids

lon=[0,30,60,90,120,150,180,210,240,270,300,330]

FOREACH id, ids DO BEGIN
   print,id
   FOREACH l, lon DO BEGIN
      IF exist(id,l) eq 1 THEN do_sync,id,l ELSE $
         print,'Does not exist',id,l
   ENDFOREACH
ENDFOREACH

END
