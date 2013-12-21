PRO sync_back,path,t_new,r_new

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Yigit Dallilar          20.12.2013
; 
; Correct the segment time of the light curve for background and
; writes into same file
;
; PURPOSE
;   Rocking causes an interval of 32 s of data collection for the source
;   and 28 s of data collection for the background. For a correct
;   analysis, first and last two seconds of the light curves provided
;   from rxte_syncseg.pro should be extracted.
;
; INPUT 
;   - file      file that contains the light curve resulted from 
;               rxte_syncseg.pro
;
; OUTPUT
;   - NONE
;
; NOTES
;   - There is no output. Program just reads and rewrite the file.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

file=path+'/light/processed/'+string(512L*32L,format='(I07)')+$
     '_seg_bkg.xdrlc'

xdrlc_r,file,t,r

len=size(r)

n_lc=floor(len[1]/(32.*512.))
len_lc=32L*512L
lenb_lc=28L*512L
two_sec=2L*512L

r_new=fltarr(n_lc*lenb_lc,len[2])
t_new=dblarr(n_lc*lenb_lc)

FOR j=0L,n_lc-1 DO BEGIN

   t_new[j*lenb_lc:(j+1)*lenb_lc-1]=$
      t[j*len_lc+two_sec:j*len_lc+two_sec+lenb_lc-1]


   FOR i=0L,len[2]-1 DO BEGIN
      
      r_new[j*lenb_lc:(j+1)*lenb_lc-1,i]=$
         r[j*len_lc+two_sec:j*len_lc+two_sec+lenb_lc-1,i]

   ENDFOR

ENDFOR

n_file=path+'/light/processed/'+string(512L*28L,format='(I07)')+$
     '_seg_bkg.xdrlc'

xdrlc_w,n_file,t_new,r_new,dseg=len[2]

END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
