
require(bio.survey)
require(bio.groundfish)
require(bio.utilities)
load_all('~/git/bio.groundfish')
load_all('~/git/bio.survey')

fp = file.path(project.datadirectory('bio.groundfish'),"analysis")

p=list()
  p$strat=c(456,458:495)  #unit III - subtract 457 for unit 3
      p$series =c('summer')# p$series =c('4vswcod');p$series =c('georges')
      p$years.to.estimate = c(1970:2016)
      p$species = 23
      p$vessel.correction = T
      p$vessel.correction.fixed = 1.2
       p$functional.groups = F
      p$strata.efficiencies = F   


p$vessel.correction = T
p$vessel.correction.fixed = 1.2
p$length.based = F
p$by.sex = F
p$sex = 1# male female berried c(1,2,3)
p$strata.efficiencies=F
#out = groundfish.db(DS='gsdet.spec.redo',p=p)
p$alpha = 0.05

#out = groundfish.analysis(DS='ab.redo',p=p)
#MPA functional groups
p$functional.groups = F
p$bootstrapped.ci = F
#
p$clusters = c( rep( "localhost", 7) )

p = make.list(list(v=p$species, yrs=p$years.to.estimate),Y=p)
p$runs = p$runs[order(p$runs$v),]
p$strata.files.return=F
#parallel.run(groundfish.analysis,DS='stratified.estimates.redo',p=p,specific.allocation.to.clusters=T) #silly error arisingexit

#not finished
#all sizes
aout= groundfish.analysis(DS='stratified.estimates.redo',p=p,out.dir='redfish')
 write.table(aout, pipe("xclip -i", "w"))  
gc()
#recruitment
p$length.based =T
p$size.class = c(10,21)

aout= groundfish.analysis(DS='stratified.estimates.redo',p=p,out.dir='redfish')
 write.table(aout, pipe("xclip -i", "w"))  
gc()

#commercial
p$length.based =T
p$size.class = c(22,100)

aout= groundfish.analysis(DS='stratified.estimates.redo',p=p,out.dir='redfish')
 write.table(aout, pipe("xclip -i", "w"))  
gc()

#weight at length

if(redo.mean.wt.at.length) {
    sc = c(18,21,25)
    o = NULL
    for(i in 1:length(sc)) {
      p$size.class = c(sc[i],sc[i])
      a = groundfish.analysis(DS='mean.wt.at.length',p=p,out.dir= 'redfish')
      a$length = sc[i]
      o = rbind(o,a)
      }
    save(o,file= file.path(project.datadirectory('redfish'),'analysis','mean.wt.at.length.r'))


    plot(1,1,xlab='Year',xlim=c(min(o$yr,na.rm=T),max(o$yr,na.rm=T)),ylim=c(min(o$meanWt,na.rm=T),350),ylab='Mean Weight at Length (g)',type='n')
    
    with(o[which(o$length==sc[1]),],lines(yr,meanWt,col='red',lty=2,pch=16,type='b'))
    a =with(o[which(o$length==sc[1]),],summary(lm(meanWt~yr)))
    abline(a=coef(a)[1],b=coef(a)[2],col='red',lwd=2)
    
    with(o[which(o$length==sc[2]),],lines(yr,meanWt,col='blue',lty=2,pch=16,type='b'))
    a1 =with(o[which(o$length==sc[2]),],summary(lm(meanWt~yr)))
    abline(a=coef(a1)[1],b=coef(a1)[2],col='blue',lwd=2)
    
    with(o[which(o$length==sc[3]),],lines(yr,meanWt,col='black',lty=2,pch=16,type='b'))
    a2 =with(o[which(o$length==sc[3]),],summary(lm(meanWt~yr)))
    abline(a=coef(a2)[1],b=coef(a2)[2],col='black',lwd=2)
    
    legend('top',c('20 cm', '23 cm','26 cm'),lty=c(2,2,2),pch=16,col=c('red','blue','black'),bty='n',ncol=3)            
savePlot(file.path(project.datadirectory('redfish'),'figures','weight.at.length.png'),type='png')
}










p = bio.groundfish::load.groundfish.environment("BIOsurvey")

fp = file.path(project.datadirectory('bio.groundfish'),"analysis")
  p$strat=c(456,458:495)  #unit III - subtract 457 for unit 3
      p$series =c('summer')# p$series =c('4vswcod');p$series =c('georges')
      p$years.to.estimate = c(1970:2016)
      p$species = 23
      p$vessel.correction = T
      p$vessel.correction.fixed = 1.2
       p$functional.groups = F
      p$strata.efficiencies = F   
#out = groundfish.db(DS='gsdet.spec.redo',p=p)
p$alpha = 0.05

#out = groundfish.analysis(DS='ab.redo',p=p)
#MPA functional groups
p$functional.groups = F
p$bootstrapped.ci=T
p = make.list(list(v=p$species, yrs=p$years.to.estimate),Y=p)
p$runs = p$runs[order(p$runs$v),]
#parallel.run(groundfish.analysis,DS='stratified.estimates.redo',p=p,specific.allocation.to.clusters=T) #silly error arisingexit

#not finished

aout= groundfish.analysis(DS='stratified.estimates.redo',p=p)

aout= groundfish.analysis(DS='stratified.estimates',p=p,out.dir= 'redfish') #returns all the redfish stratified data

#survey numbers at length by cm
if(redo.numbers.at.length) {
        len = 1:50
        oo = NULL
        p$length.based=T
        p$bootstrapped.ci = F
        for(l in len) {
          p$size.class = c(l,l)
          aout= groundfish.analysis(DS='stratified.estimates.redo',p=p,out.dir= 'redfish')
          aout$len.group = l
          oo = rbind(oo,aout)
           }
           save(oo,file = file.path(project.datadirectory('redfish'),'analysis','stratified.at.length.redfish.rdata'))
}
  if(redo.survey.bubbles) {
        load(file.path(project.datadirectory('redfish'),'analysis','stratified.at.length.redfish.rdata')) #This matches PComeau's #s
        out = reshape(oo[,c('yr','len.group','n.yst')], timevar= 'len.group',idvar='yr',direction='wide')
        pdf(file.path(project.datadirectory('redfish'),'figures','UnitIIIsurveybubbles.pdf'))
        matrixBubbles(t(out[,2:51]),xr=1:47,yr=1:50,maxinch=0.15,xlab='Year',ylab='Length',yc.colors=T,ttl='Unit III Redfish')
        lines(1:10,ht[7:16],lwd=3,col='red')
        lines(28:37,ht[7:16],lwd=3,col='red')
        lines(1:10,htMohn[7:16],lwd=3,col='blue')
        lines(28:37,htMohn[7:16],lwd=3,col='blue')
        
          dev.off()
    
      }

if(redo.mean.wt.at.length) {
    sc = c(20,23,26)
    o = NULL
    for(i in 1:length(sc)) {
      p$size.class = c(sc[i],sc[i])
      a = groundfish.analysis(DS='mean.wt.at.length',p=p,out.dir= 'redfish')
      a$length = sc[i]
      o = rbind(o,a)
      }
    save(o,file= file.path(project.datadirectory('redfish'),'analysis','mean.wt.at.length.r'))


    plot(1,1,xlab='Year',xlim=c(min(o$yr,na.rm=T),max(o$yr,na.rm=T)),ylim=c(min(o$meanWt,na.rm=T),350),ylab='Mean Weight at Length (g)',type='n')
    
    with(o[which(o$length==sc[1]),],lines(yr,meanWt,col='red',lty=2,pch=16,type='b'))
    a =with(o[which(o$length==sc[1]),],summary(lm(meanWt~yr)))
    abline(a=coef(a)[1],b=coef(a)[2],col='red',lwd=2)
    
    with(o[which(o$length==sc[2]),],lines(yr,meanWt,col='blue',lty=2,pch=16,type='b'))
    a1 =with(o[which(o$length==sc[2]),],summary(lm(meanWt~yr)))
    abline(a=coef(a1)[1],b=coef(a1)[2],col='blue',lwd=2)
    
    with(o[which(o$length==sc[3]),],lines(yr,meanWt,col='black',lty=2,pch=16,type='b'))
    a2 =with(o[which(o$length==sc[3]),],summary(lm(meanWt~yr)))
    abline(a=coef(a2)[1],b=coef(a2)[2],col='black',lwd=2)
    
    legend('top',c('20 cm', '23 cm','26 cm'),lty=c(2,2,2),pch=16,col=c('red','blue','black'),bty='n',ncol=3)            
savePlot(file.path(project.datadirectory('redfish'),'figures','weight.at.length.png'),type='png')
}


###Standardarding catch rate data


