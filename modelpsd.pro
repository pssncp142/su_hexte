PRO modelpsd,cnt,dead,low,high,f,psd,points=vpoints

  IF keyword_set(vpoints) THEN p=vpoints ELSE p=20

  ll10=alog10(low)
  hl10=alog10(high)

  f=10^(findgen(p)*(hl10-ll10)/(p-1)+ll10)

  psd=2+cnt*sin(!pi*dead*f)^2/(!pi*f)^2

END
