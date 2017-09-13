pro osiris_find_lines_bb,insci=insci,inrecmat=inrecmat,refx=refx,outpos=outpos

; code to find the x,y position of emission lines on a raw science frame via
; centroiding.
; the x shifts are derived for 2013-2015 data only for now! no guarantee that
; new data will work!

; insci: filename of the input raw 2D frame
; inrecmat: filename of the corresponding rectification matrix, used to
;    pull the input y position of the emission lines
; refx: x position of the emission line in the topmost spectrum on the 2D
;    frame, used to pull the input x position of the emission lines
; outpos: output [x,y] from the centroiding; if 

rm0 = mrdfits(inrecmat,0,/silent)
;sci = mrdfits(insci,0,/silent)
sci = readfits(insci,0,/silent)

szrm = size(rm0)
nspec = szrm[2]

xoutall=fltarr(nspec)
youtall=fltarr(nspec)

for i=0,nspec-1 do begin
    ; get spectral position in [x,y]
   tmppos=rm0[*,i]
   ; each spectrum covers 16 pixels in y on the CCD, with the
   ; "spectral position" x,y corresponding to the top
   ; get the appropriate range in y
   tmpyrg=[tmppos[1]-15,tmppos[1]]
   ; the center of the PSF centroid is actually 5ish pixels below the top
   ; we'll get the actual value via a centroid later
   yin=tmppos[1]-5
   xorg=refx 
   ; shifts ~1.92 pixels to the left with each new column, and ~29.2129
   ; pixels to the right with each new row within a column
   ; spec = (col-1)*specpercol + row
   ; calculate the input x position
   case 1 of
      (i ge 0) AND (i le 63): begin
         xin=xorg+i*(-1.92)
      end 
      (i ge 64) AND (i lt 64*2): begin
         xin=xorg+29.2129-((i-64.)*1.92)
      end
      (i ge 64*2) AND (i lt 64*3): begin
         xin=xorg+(2.*29.2129)-((i-2.*64.)*1.92)
      end 
      (i ge 64*3) AND (i lt 64*4): begin 
         xin=xorg+(3.*29.2129)-((i-3.*64.)*1.92)
      end 
      (i ge 64*4) AND (i lt 64*5): begin
         xin=xorg+(4.*29.2129)-((i-4.*64.)*1.92)
      end 
      (i ge 64*5) AND (i lt 64*6): begin
         xin=xorg+(5.*29.2129)-((i-5.*64.)*1.92)
      end 
      (i ge 64*6) AND (i lt 64*7): begin
         xin=xorg+(6.*29.2129)-((i-6.*64.)*1.92)
      end 
      (i ge 64*7) AND (i lt 64*8): begin
         xin=xorg+(7.*29.2129)-((i-7.*64.)*1.92)
      end 
      (i ge 64*8) AND (i lt 64*9): begin
         xin=xorg+(8.*29.2129)-((i-8.*64.)*1.92)
      end 
      (i ge 64*9) AND (i lt 64*10): begin
         xin=xorg+(9.*29.2129)-((i-9.*64.)*1.92)
      end 
      (i ge 64*10) AND (i lt 64*11): begin
         xin=xorg+(10.*29.2129)-((i-10.*64.)*1.92)
      end 
      (i ge 64*11) AND (i lt 64*12): begin
         xin=xorg+(11.*29.2129)-((i-11.*64.)*1.92)
      end 
      (i ge 64*12) AND (i lt 64*13): begin
         xin=xorg+(12.*29.2129)-((i-12.*64.)*1.92)
      end 
      (i ge 64*13) AND (i lt 64*14): begin
         xin=xorg+(13.*29.2129)-((i-13.*64.)*1.92)
      end 
      (i ge 64*14) AND (i lt 64*15): begin
         xin=xorg+(14.*29.2129)-((i-14.*64.)*1.92)
      end 
      (i ge 64*15) AND (i lt 64*16): begin
         xin=xorg+(15.*29.2129)-((i-15.*64.)*1.92)
      end 
      (i ge 64*16) AND (i lt 64*17): begin
         xin=xorg+(16.*29.2129)-((i-16.*64.)*1.92)
      end 
      (i ge 64*17) AND (i lt 64*18): begin
         xin=xorg+(17.*29.2129)-((i-17.*64.)*1.92)
      end 
      (i ge 64*18): begin
         xin=xorg+(18.*29.2129)-((i-18.*64.)*1.92)
      end 
   endcase
   
; but not all columns have all rows, so setting the PSF of these to 0
; to start with
   if (i ge 16 AND i le 63) $
      OR (i ge 96 AND i le 127) $
      OR (i ge 176 AND i le 191) $
      OR (i ge 1024 AND i le 1039) $
      OR (i ge 1088 AND i le 1119) $
      OR (i ge 1152 AND i le 1199) $
   then begin
      xoutall[i]=-1
      youtall[i]=-1
   endif else begin 
; get the actual center of the line via centroiding, FWHM from
; previous estimates
      cntrd,sci,xin,yin,xout,yout,2.,extend=2.
      xoutall[i]=xout
      youtall[i]=yout 
   endelse
endfor

outpos=[[xoutall],[youtall]]

end
