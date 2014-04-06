
spawn,'cat nogti.txt',nogti

FOREACH gti, nogti DO BEGIN
   print,strsplit(gti,/extract)
ENDFOREACH


END
