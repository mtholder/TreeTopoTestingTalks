#library(heR)
n=100
h=60
pdf("binomdist.pdf")
breaks=seq(0.0, 1.0, 1/n)
v=seq(0, n, 1)
p = dbinom(v, n, 0.5)
print(pbinom(h, n, 0.5))
print(pbinom(n-h, n, 0.5))
#hist(p, seq(0,100, 1), xlab=c("# heads"), main="Null distribution of the # heads", probability=FALSE);
plot(breaks, p, type='s', xlab=c("Pr(heads)"), ylab=c("frequency"))
#areaplot(v, p, col = "gray") #, new = FALSE, base=0, density=NULL, angle=NULL)
#barplot(p)
abline(v=h/n, col=2)
abline(v=(1 - (h-1)/n) , col=2)
dev.off()
