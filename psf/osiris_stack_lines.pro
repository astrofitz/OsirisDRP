pro osiris_stack_lines,outmedstack=outmedstack,outrebin=outrebin,interpcubic=interpcubic

; sky
;refx=[907]
;insky='/Users/kel/Documents/Projects/Antennae/OSIRIS_1505/150505/SPEC/raw/s150505_a015001.fits'
; dark-subtracted sky
; [749,803,907,999,1346,1442,1527]
;refx=[907]
;insky='/Users/kel/Documents/Projects/Antennae/OSIRIS_1505/150505/SPEC/FRP/sky2d_darksub/s150505_a015001_Kbb_050.fits'
; arc
; 2015 Kbb/050 data
;refx=[765]
;insky='/Users/kel/Documents/Projects/OSIRIS_pipeline_testing/osiris_arcs_oct2015/s151028_a001014_el45.fits'
;inrecmat='/Users/kel/Documents/Projects/Antennae/OSIRIS_1505/150509/SPEC/FRP/s150508_c002___infl_Kbb_050.fits'
; 2016 Jbb/050 arc data
;refx=[1105]
;refx=[497]
;insky='/Users/kel/Documents/Projects/OSIRIS_pipeline_testing/osiris_arcs_mar2016/s160318_c012004.fits.gz'
; 2016  sky data
;inrecmat='/Users/kel/Documents/Library/Python/OSIRIS-dev/OsirisDRP/calib/s160318_c013___infl_Jbb_050_origweightlimit.fits.gz'
;refx=[1475]
;refx=[942]
;insky='/Users/kel/Documents/Projects/OSIRIS_pipeline_testing/osiris_skies_jul2016/s160711_a013002.fits'

  ;; 2017 Kbb/035 arc
  refx = [765]
  insky = '/Users/fitz/work/data/Arcs2017/s170509_c013001.fits.gz'
  inrecmat = '/Users/fitz/Google Drive/work/OSIRIS Pipeline Working Group/Test Data/Trace/s170509_c014___infl_Kbb_035.fits'


sci = readfits(insky)

;osiris_specsci_psfcomp,insci=insky,/noplot,refx=refx,outpos=outpos
osiris_find_lines_bb,insci=insky,inrecmat=inrecmat,refx=refx,outpos=outpos

good=where(outpos[*,0] ne -1,nclips)
goodpos=outpos[good,*]

rad=5.
; create the output array a bit larger than the size of an individual
; clip, then supersample by a factor of 100
stackall=fltarr((rad*2+2)*100,(rad*2+2)*100,nclips)
stackall1=fltarr((rad*2+2)*100,(rad*2+2)*100,nclips)
; find the center
cent=((rad*2+2)*100)/2

for i=0,nclips-1 do begin
   ; clip the emission line
   tmpclip = sci[goodpos[i,0]-rad:goodpos[i,0]+rad,goodpos[i,1]-rad:goodpos[i,1]+rad]
   ; this resamples using a nearest neighbor method
   ;; rebin in prep for supersampling
   if ~keyword_set(interpcubic) then $
      tmpsuper =rebin(tmpclip,(size(tmpclip))[1]*100,(size(tmpclip))[2]*100) $
   ; 20160510 - tested a bilinear interpolation method -
                                ; v. similar to nearest neighbor
   ;tmpsuper = congrid(tmpclip,(size(tmpclip))[1]*100,(size(tmpclip))[2]*100,/interp)
   ; 20160510 - cubic interpolation is what I was looking for -
                                ; delivers proper smoothing
   else $
      tmpsuper = congrid(tmpclip,(size(tmpclip))[1]*100,(size(tmpclip))[2]*100,cubic=-0.5)
   ; find the centroid, convert to supersampled coordinates
   tmpcentx = ((goodpos[i,0]-fix(goodpos[i,0]))*100)+(rad*100)
   tmpcenty = ((goodpos[i,1]-fix(goodpos[i,1]))*100)+(rad*100)
   ; drop into the stack
   stackall[fix(cent-tmpcentx):fix(cent-tmpcentx)+(size(tmpsuper))[1]-1,fix(cent-tmpcenty):fix(cent-tmpcenty)+(size(tmpsuper))[1]-1,i]=tmpsuper
   ;stop
endfor

medstack=median(stackall,dimension=3)
;totstack=total(stackall,3)

; when rebinning, clip off the raggedy edges with little data
medrebin=rebin(medstack[100:(size(tmpsuper))[1]-101,100:(size(tmpsuper))[1]-101],(rad*2)-1,(rad*2)-1)
medrelog=alog10(medrebin)

;totrebin=rebin(totstack[100:(size(tmpsuper))[1]-101,100:(size(tmpsuper))[1]-101],(rad*2)-1,(rad*2)-1)
;totrelog=alog10(totrebin)

outmedstack=medstack
outrebin=medrebin

;stop

end

