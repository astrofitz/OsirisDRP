pro osiris_stack_lines_plot

osiris_stack_lines,outmedstack=outmedstack,outrebin=outrebin,/interpcubic

; centroids are lined up on the center of the plot, which is square
szsup = size(outmedstack)
szreb = size(outrebin)

centsup = szsup[1]/2.
centreb = szreb[1]/2.

cgloadct,15
mednorm=outmedstack/max(outmedstack)
cgimage,mednorm[100:999,100:999],/keep,/scale,/save
sztmp=size(mednorm[100:999,100:999])
centtmp=sztmp[1]/2.
; overplotting lines to show where the binned pixel edges will be
nlines=fix(sztmp[1]/100)
for i=0,nlines do begin
   cgplot,[i*100,i*100],[0,szsup[2]],/over,thick=1,color=cgcolor('dark gray')
   cgplot,[0,szsup[1]],[i*100,i*100],/over,thick=1,color=cgcolor('dark gray')
endfor
;cgplot,[centtmp,centtmp],[0,sztmp[2]],/over,thick=2,color=cgcolor('green')
;cgplot,[centtmp-200,centtmp-200],[0,sztmp[2]],/over,thick=2,color=cgcolor('red'),linestyle=2
;cgplot,[centtmp-100,centtmp-100],[0,sztmp[2]],/over,thick=2,color=cgcolor('orange'),linestyle=2
;cgplot,[centtmp+100,centtmp+100],[0,sztmp[2]],/over,thick=2,color=cgcolor('cyan'),linestyle=2
;cgplot,[centtmp+200,centtmp+200],[0,sztmp[2]],/over,thick=2,color=cgcolor('purple'),linestyle=2
cgloadct,15
colorbar,range=[min(mednorm),max(mednorm)],title='Normalized flux',format='(f4.2)',position=[0.20, 0.88, 0.80, 0.95],color=cgcolor('white')

stop
cgloadct,0
cgimage,outmedstack,/keep,/scale,/save
stop
; colors match those from osiris_empfwhm_comp
; each raw frame regular pixel = 100 supersampled pixels
cgplot,[centsup,centsup],[0,szsup[2]],/over,thick=2,color=cgcolor('green')
cgplot,[centsup-200,centsup-200],[0,szsup[2]],/over,thick=2,color=cgcolor('red'),linestyle=2
cgplot,[centsup-100,centsup-100],[0,szsup[2]],/over,thick=2,color=cgcolor('orange'),linestyle=2
cgplot,[centsup+100,centsup+100],[0,szsup[2]],/over,thick=2,color=cgcolor('cyan'),linestyle=2
cgplot,[centsup+200,centsup+200],[0,szsup[2]],/over,thick=2,color=cgcolor('purple'),linestyle=2

stop
cgloadct,0
cgimage,outrebin,/keep,/scale,/save
; colors match those from osiris_empfwhm_comp
cgplot,[centreb,centreb],[0,szreb[2]],/over,thick=2,color=cgcolor('green')
cgplot,[centreb-2,centreb-2],[0,szreb[2]],/over,thick=2,color=cgcolor('red'),linestyle=2
cgplot,[centreb-1,centreb-1],[0,szreb[2]],/over,thick=2,color=cgcolor('orange'),linestyle=2
cgplot,[centreb+1,centreb+1],[0,szreb[2]],/over,thick=2,color=cgcolor('cyan'),linestyle=2
cgplot,[centreb+2,centreb+2],[0,szreb[2]],/over,thick=2,color=cgcolor('purple'),linestyle=2

stop

end
