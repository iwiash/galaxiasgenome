Alaska <- read.table("Alaska.final.summary",header=T)
Eastern <- read.table("Eastern.final.summary",header=T)
Northwest <- read.table("Northwest.final.summary",header=T)
Rockies <- read.table("Rockies.final.summary",header=T)

pdf("PP-stairway2.plot.pdf",height = 6.25,width = 10)

plot(Alaska$year/1000,Alaska$Ne_median/1000, log=c("xy"), type="n", xlab="Time (1k years ago)", ylab="Effective Population Size (1k individuals)",xlim=c(4,1000),ylim=c(20,30000))

lines(Alaska$year/1000,Alaska$Ne_median/1000,type="s",col="#882255",lwd = 5)
lines(Alaska$year/1000,Alaska$Ne_2.5./1000,type="s",col="#882255",lty=3)
lines(Alaska$year/1000,Alaska$Ne_97.5./1000,type="s",col="#882255",lty=3)

lines(Eastern$year/1000,Eastern$Ne_median/1000,type="s",col="#332288",lwd = 5)
lines(Eastern$year/1000,Eastern$Ne_2.5./1000,type="s",col="#332288",lty=3)
lines(Eastern$year/1000,Eastern$Ne_97.5./1000,type="s",col="#332288",lty=3)

lines(Northwest$year/1000,Northwest$Ne_median/1000,type="s",col="#117733",lwd = 5)
lines(Northwest$year/1000,Northwest$Ne_2.5./1000,type="s",col="#117733",lty=3)
lines(Northwest$year/1000,Northwest$Ne_97.5./1000,type="s",col="#117733",lty=3)

lines(Rockies$year/1000,Rockies$Ne_median/1000,type="s",col="#88CCEE",lwd = 5)
lines(Rockies$year/1000,Rockies$Ne_2.5./1000,type="s",col="#88CCEE",lty=3)
lines(Rockies$year/1000,Rockies$Ne_97.5./1000,type="s",col="#88CCEE",lty=3)

legend(400,28000,legend = c("Alaska","Eastern","Northwest","Rockies","95% CI"),col=c("#882255","#332288","#117733","#88CCEE","black"),lty=c(1,1,1,1,3),lwd=c(5,5,5,5,1),cex=0.8)

dev.off()

############################################################################################################################################################################

aucklandIslands = read.table("auckland_island.final.summary",header=T)

chathamIsland = read.table("chatham_island.final.summary",header=T)

diadromous = read.table("diadromous_max.final.summary",header=T)

greenLake = read.table("green_lake.final.summary",header=T)

lagoonSaddle = read.table("lagoon_saddle_tarn.final.summary",header=T)

chalice = read.table("lake_chalice.final.summary",header=T)

marian = read.table("lake_marian.final.summary",header=T)

paringa = read.table("lake_paringa.final.summary",header=T)

sylvester = read.table("lake_sylvester.final.summary",header=T)

rotoroa = read.table("rotoroa_max_test.final.summary",header=T)

twelveMile = read.table("twelve_mile_ck.final.summary",header=T)



plot(rotoroa$year/1000,rotoroa$Ne_median/1000, log=c("xy"), type="n", xlab="Time (1k years ago)", 
     ylab="Effective Population Size (1k individuals)",xlim=c(5,10000),ylim=c(50,20000))

lines(greenLake$year/1000,greenLake$Ne_median/1000,type="s",col="#332288",lwd = 3)
lines(greenLake$year/1000,greenLake$Ne_2.5./1000,type="s",col="#332288",lty=3)
lines(greenLake$year/1000,greenLake$Ne_97.5./1000,type="s",col="#332288",lty=3)

lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_median/1000,type="s",col="#117733",lwd = 3)
lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_2.5./1000,type="s",col="#117733",lty=3)
lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_97.5./1000,type="s",col="#117733",lty=3)

lines(chalice$year/1000,chalice$Ne_median/1000,type="s",col="#88CCEE",lwd = 3)
lines(chalice$year/1000,chalice$Ne_2.5./1000,type="s",col="#88CCEE",lty=3)
lines(chalice$year/1000,chalice$Ne_97.5./1000,type="s",col="#88CCEE",lty=3)

lines(marian$year/1000,marian$Ne_median/1000,type="s",col="#DDCC77",lwd = 3)
lines(marian$year/1000,marian$Ne_2.5./1000,type="s",col="#DDCC77",lty=3)
lines(marian$year/1000,marian$Ne_97.5./1000,type="s",col="#DDCC77",lty=3)

lines(paringa$year/1000,paringa$Ne_median/1000,type="s",col="#CC6677",lwd = 3)
lines(paringa$year/1000,paringa$Ne_2.5./1000,type="s",col="#CC6677",lty=3)
lines(paringa$year/1000,paringa$Ne_97.5./1000,type="s",col="#CC6677",lty=3)

lines(sylvester$year/1000,sylvester$Ne_median/1000,type="s",col="#AA4499",lwd = 3)
lines(sylvester$year/1000,sylvester$Ne_2.5./1000,type="s",col="#AA4499",lty=3)
lines(sylvester$year/1000,sylvester$Ne_97.5./1000,type="s",col="#AA4499",lty=3)

lines(rotoroa$year/1000,rotoroa$Ne_median/1000,type="s",col="#882255",lwd = 3)
lines(rotoroa$year/1000,rotoroa$Ne_2.5./1000,type="s",col="#882255",lty=3)
lines(rotoroa$year/1000,rotoroa$Ne_97.5./1000,type="s",col="#882255",lty=3)

lines(twelveMile$year/1000,twelveMile$Ne_median/1000,type="s",col="#E65B26",lwd = 3)
lines(twelveMile$year/1000,twelveMile$Ne_2.5./1000,type="s",col="#E65B26",lty=3)
lines(twelveMile$year/1000,twelveMile$Ne_97.5./1000,type="s",col="#E65B26",lty=3)

legend(3000,500,legend = c("Green","Lagoon","Chalice","Marian","Paringa","Sylvester", "Rotoroa", "TwelveMile","95% CI"),
       col=c("#332288","#117733","#88CCEE", "#DDCC77", "#CC6677", "#AA4499", "#882255", "#E65B26", "black"),
       lty=c(1,1,1,1,1,1,1,1,3),lwd=c(5,5,5,5,5,5,5,5,1),cex=1.2)


############################################################################################################################################################################

plot(rotoroa$year/1000,rotoroa$Ne_median/1000, log=c("xy"), type="n", xlab="Time (1k years ago)", 
     ylab="Effective Population Size (1k individuals)",xlim=c(5,10000),ylim=c(50,20000))

lines(greenLake$year/1000,greenLake$Ne_median/1000,type="s",col="#332288",lwd = 3)
#lines(greenLake$year/1000,greenLake$Ne_2.5./1000,type="s",col="#332288",lty=3)
#lines(greenLake$year/1000,greenLake$Ne_97.5./1000,type="s",col="#332288",lty=3)

lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_median/1000,type="s",col="#117733",lwd = 3)
#lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_2.5./1000,type="s",col="#117733",lty=3)
#lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_97.5./1000,type="s",col="#117733",lty=3)

lines(chalice$year/1000,chalice$Ne_median/1000,type="s",col="#88CCEE",lwd = 3)
#lines(chalice$year/1000,chalice$Ne_2.5./1000,type="s",col="#88CCEE",lty=3)
#lines(chalice$year/1000,chalice$Ne_97.5./1000,type="s",col="#88CCEE",lty=3)

lines(marian$year/1000,marian$Ne_median/1000,type="s",col="#DDCC77",lwd = 3)
#lines(marian$year/1000,marian$Ne_2.5./1000,type="s",col="#DDCC77",lty=3)
#lines(marian$year/1000,marian$Ne_97.5./1000,type="s",col="#DDCC77",lty=3)

lines(paringa$year/1000,paringa$Ne_median/1000,type="s",col="#CC6677",lwd = 3)
#lines(paringa$year/1000,paringa$Ne_2.5./1000,type="s",col="#CC6677",lty=3)
#lines(paringa$year/1000,paringa$Ne_97.5./1000,type="s",col="#CC6677",lty=3)

lines(sylvester$year/1000,sylvester$Ne_median/1000,type="s",col="#AA4499",lwd = 3)
#lines(sylvester$year/1000,sylvester$Ne_2.5./1000,type="s",col="#AA4499",lty=3)
#lines(sylvester$year/1000,sylvester$Ne_97.5./1000,type="s",col="#AA4499",lty=3)

lines(rotoroa$year/1000,rotoroa$Ne_median/1000,type="s",col="#882255",lwd = 3)
#lines(rotoroa$year/1000,rotoroa$Ne_2.5./1000,type="s",col="#882255",lty=3)
#lines(rotoroa$year/1000,rotoroa$Ne_97.5./1000,type="s",col="#882255",lty=3)

lines(twelveMile$year/1000,twelveMile$Ne_median/1000,type="s",col="#E65B26",lwd = 3)
#lines(twelveMile$year/1000,twelveMile$Ne_2.5./1000,type="s",col="#E65B26",lty=3)
#lines(twelveMile$year/1000,twelveMile$Ne_97.5./1000,type="s",col="#E65B26",lty=3)

legend(3000,500,legend = c("Green","Lagoon","Chalice","Marian","Paringa","Sylvester", "Rotoroa", "TwelveMile"),
       col=c("#332288","#117733","#88CCEE", "#DDCC77", "#CC6677", "#AA4499", "#882255", "#E65B26"),
       lty=c(1,1,1,1,1,1,1,1),lwd=c(5,5,5,5,5,5,5,5),cex=1.2)

############################################################################################################################################################################


############################################################################################################################################################################


plot(rotoroa$year/1000,rotoroa$Ne_median/1000, log=c("xy"), type="n", xlab="Time (1k years ago)", 
     ylab="Effective Population Size (1k individuals)",xlim=c(5,10000),ylim=c(50,20000))

lines(greenLake$year/1000,greenLake$Ne_median/1000,type="s",col="#332288",lwd = 3)
lines(greenLake$year/1000,greenLake$Ne_2.5./1000,type="s",col="#332288",lty=3)
lines(greenLake$year/1000,greenLake$Ne_97.5./1000,type="s",col="#332288",lty=3)

lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_median/1000,type="s",col="#117733",lwd = 3)
lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_2.5./1000,type="s",col="#117733",lty=3)
lines(lagoonSaddle$year/1000,lagoonSaddle$Ne_97.5./1000,type="s",col="#117733",lty=3)

lines(chalice$year/1000,chalice$Ne_median/1000,type="s",col="#88CCEE",lwd = 3)
lines(chalice$year/1000,chalice$Ne_2.5./1000,type="s",col="#88CCEE",lty=3)
lines(chalice$year/1000,chalice$Ne_97.5./1000,type="s",col="#88CCEE",lty=3)

lines(marian$year/1000,marian$Ne_median/1000,type="s",col="#DDCC77",lwd = 3)
lines(marian$year/1000,marian$Ne_2.5./1000,type="s",col="#DDCC77",lty=3)
lines(marian$year/1000,marian$Ne_97.5./1000,type="s",col="#DDCC77",lty=3)

lines(paringa$year/1000,paringa$Ne_median/1000,type="s",col="#CC6677",lwd = 3)
lines(paringa$year/1000,paringa$Ne_2.5./1000,type="s",col="#CC6677",lty=3)
lines(paringa$year/1000,paringa$Ne_97.5./1000,type="s",col="#CC6677",lty=3)

lines(sylvester$year/1000,sylvester$Ne_median/1000,type="s",col="#AA4499",lwd = 3)
lines(sylvester$year/1000,sylvester$Ne_2.5./1000,type="s",col="#AA4499",lty=3)
lines(sylvester$year/1000,sylvester$Ne_97.5./1000,type="s",col="#AA4499",lty=3)

lines(rotoroa$year/1000,rotoroa$Ne_median/1000,type="s",col="#882255",lwd = 3)
lines(rotoroa$year/1000,rotoroa$Ne_2.5./1000,type="s",col="#882255",lty=3)
lines(rotoroa$year/1000,rotoroa$Ne_97.5./1000,type="s",col="#882255",lty=3)

lines(twelveMile$year/1000,twelveMile$Ne_median/1000,type="s",col="#E65B26",lwd = 3)
lines(twelveMile$year/1000,twelveMile$Ne_2.5./1000,type="s",col="#E65B26",lty=3)
lines(twelveMile$year/1000,twelveMile$Ne_97.5./1000,type="s",col="#E65B26",lty=3)

lines(aucklandIslands$year/1000,aucklandIslands$Ne_median/1000,type="s",col="blue",lwd = 3)
lines(aucklandIslands$year/1000,aucklandIslands$Ne_2.5./1000,type="s",col="blue",lty=3)
lines(aucklandIslands$year/1000,aucklandIslands$Ne_97.5./1000,type="s",col="blue",lty=3)

lines(chathamIsland$year/1000,chathamIsland$Ne_median/1000,type="s",col="green",lwd = 3)
lines(chathamIsland$year/1000,chathamIsland$Ne_2.5./1000,type="s",col="green",lty=3)
lines(chathamIsland$year/1000,chathamIsland$Ne_97.5./1000,type="s",col="green",lty=3)

legend(3000,500,legend = c("Green","Lagoon","Chalice","Marian","Paringa","Sylvester", "Rotoroa", "TwelveMile","95% CI"),
       col=c("#332288","#117733","#88CCEE", "#DDCC77", "#CC6677", "#AA4499", "#882255", "#E65B26", "black"),
       lty=c(1,1,1,1,1,1,1,1,3),lwd=c(5,5,5,5,5,5,5,5,1),cex=1.2)

#################

plot(diadromous$year/1000,diadromous$Ne_median/1000, log=c("xy"), type="n", xlab="Time (1k years ago)", 
     ylab="Effective Population Size (1k individuals)",xlim=c(5,10000),ylim=c(50,20000))

lines(diadromous$year/1000,diadromous$Ne_median/1000,type="s",col="#332288",lwd = 3)
lines(diadromous$year/1000,diadromous$Ne_2.5./1000,type="s",col="#332288",lty=3)
lines(diadromous$year/1000,diadromous$Ne_97.5./1000,type="s",col="#332288",lty=3)
