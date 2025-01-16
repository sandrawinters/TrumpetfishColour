#generates cone spectral sensitivity curves for the barrier reef anemonefish (Amphiprion akindynos)
#visual system data from Stieb et al. 2019 Sci Rep doi.org/10.1038/s41598-019-52297-0

#Sandra Winters <sandra.winters@helsinki.fi>
#updated 3 Mar 2023

library(pavo)

# lens transmission data ----------
trans = read.csv('anemonefish_lens_transmission.csv')
colnames(trans) = c('wl','lens')
trans = as.rspec(trans,whichwl=1,lim=c(300,700))
plot(trans$lens~trans$wl,type='l',ylim=c(0,100))

# data from Stieb et al. 2019 Sci Rep doi.org/10.1038/s41598-019-52297-0
# fig 1b digitized using https://apps.automeris.io/wpd/

# generate spectral sensitivity curves - L,M,S,VS,DBL (300-700) ----------
vis = sensmodel(peaksens=c(541,520,498,400), 
                om=trans$lens,
                sensnames=c('lw','mw','sw','uv'),
                integrate=F) #setting integrate to false because it's applied before accounting for OMT; adding it below

#normalize to sum to 1
vis$lw = vis$lw/sum(vis$lw)
vis$mw = vis$mw/sum(vis$mw)
vis$sw = vis$sw/sum(vis$sw)
vis$uv = vis$uv/sum(vis$uv)
# vis$lum = (vis$lw+vis$mw)/2 # https://doi.org/10.3389/fncir.2014.00118 ; https://doi.org/10.1242/jeb.232090

#plot
plot(vis$wl,vis$lw,type='l',col='red',main='Anemonefish cone sensitivities',ylim=c(0,0.015),xlab='Wavelength',ylab='Reflectance')
lines(vis$wl,vis$mw,col='green')
lines(vis$wl,vis$sw,col='blue')
lines(vis$wl,vis$uv,col='gray')
# lines(vis$wl,vis$lum,lty=2)
legend('topright',title='Cone type:',legend=c('L','M','S','UV'),col=c('red','green','blue','gray'))

# output ----------
write.csv(vis,'anemonefish_cone_sensitivities.csv',row.names=F)

write.table(t(vis),'Anemonefish 300-700.csv',col.names=F,row.names=T,sep=',',quote=F) #long format for MICA
write.table(t(vis[vis$wl>=400,c('wl','lw','mw','sw')]),'Anemonefish 400-700.csv',col.names=F,row.names=T,sep=',',quote=F) #visible light; long format for MICA

