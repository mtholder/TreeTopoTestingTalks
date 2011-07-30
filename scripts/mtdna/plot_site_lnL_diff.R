t = read.table('sitelnL3000.csv', sep='\t', header=TRUE)
t2 = read.table('pdiff.csv', sep='\t', header=TRUE)

d1.2 = 2*(t$tree1 - t$tree2)
d1.3 = 2*(t$tree1 - t$tree3)
d1.12 = 2*(t$tree1 - t$tree12)

nsites = length(d1.2)


nrellreps = 10000;
    

biggest1.2=max(ceiling(max(d1.2)*10),ceiling(-min(d1.2)*10))/10
biggest1.3=max(ceiling(max(d1.3)*10),ceiling(-min(d1.3)*10))/10
biggest1.12=max(ceiling(max(d1.12)*10),ceiling(-min(d1.12)*10))/10
biggest = max(biggest1.2, biggest1.3, biggest1.12)

rellfunc = function(diffs) {
    obs = sum(diffs)
    ss = replicate(nrellreps, sum(sample(diffs, replace=TRUE)))
    centering = mean(ss)
    print(c("centering", centering))
    c = ss - centering
    rellMoreExtreme = sum(abs(c) > abs(obs))
    print(c("rellMoreExtreme", rellMoreExtreme))
    rellMoreExtreme/nrellreps;
}

ztestkh = function(diffs) {
    print(c('max',  max(diffs)))
    print(c('min', min(diffs)))
    print(c('mean', mean(diffs)))
    print(c('sd', sd(diffs)))
    nsites = length(diffs)
    Delta = sum(diffs)
    print(c('Delta', Delta))
    VarSum = nsites*var(diffs)
    print(c('VarSum', VarSum))
    Z = -abs(Delta/(sqrt(VarSum)))
    print(c('Z', Z))
    halfp = pnorm(Z)
    p = 2.0 * halfp 
    print(c('p', p))
    p
}


ztestkh(d1.2)
r1.2 = rellfunc(d1.2)
mult=7
x = seq(-biggest, biggest, 0.01)
breaks=seq(-biggest, biggest, 0.1)
sbreaks=seq(-biggest*mult, biggest*mult, 0.1*mult)
print(breaks)
pdf('d1-2hist.pdf')
hist(d1.2, breaks=breaks, axes=TRUE, ylim=c(0,50), main=c(""), xlab="")
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.2)))
dev.off()


u1.2 = replicate(nrellreps, sum(sample(d1.2, replace=TRUE)))
mu1.2 = mean(u1.2)
obs1.2 = sum(d1.2)
r1.2 = sum(abs(u1.2 - mu1.2) > abs(obs1.2))

print(mu1.2)
print(sd(u1.2))
print(var(u1.2))
pdf('uncentered1-2hist.pdf')
hist(u1.2, breaks=sbreaks, axes=TRUE, main=c(""), xlab="")
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.2)))
abline(v=mu1.2)
dev.off()
pdf('centered1-2hist.pdf')
c1.2 = u1.2 - mu1.2
hist(c1.2, breaks=sbreaks-mu1.2, axes=TRUE, main=c(""), xlab="")
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.2)))
dev.off()
pdf('centered1-2hist-p.pdf')
c1.2 = u1.2 - mu1.2
hist(c1.2, breaks=sbreaks-mu1.2, axes=TRUE, main=c(""), xlab="", ylim=c(0,.08*nrellreps))
abline(v=-abs(obs1.2))
text(20, 200, paste('P-value =', as.character(round(r1.2/nrellreps, 2)), sep=' '))
abline(v=abs(sum(d1.2)))
dev.off()
pdf('centered1-2hist-tails.pdf')
in_tails1.2 = abs(c1.2) >= abs(obs1.2)
print(in_tails1.2)
inv = c1.2[in_tails1.2]
print(inv)
hist(inv, breaks=sbreaks-mu1.2, axes=FALSE, main=c(""), xlab="", ylab="", col="red", , ylim=c(0,.08*nrellreps))
dev.off()



ztestkh(d1.3)
rellfunc(d1.3)

x = seq(-biggest, biggest, 0.01)
breaks=seq(-biggest, biggest, 0.1)
print(breaks)
pdf('d1-3hist.pdf')
hist(d1.3, breaks=breaks, axes=TRUE, ylim=c(0,50), main=c(""), xlab="")
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.3)))
dev.off()



ztestkh(d1.12)
rellfunc(d1.12)


x = seq(-biggest, biggest, 0.01)
breaks=seq(-biggest, biggest, 0.1)
print(breaks)
pdf('d1-12hist.pdf')
hist(d1.12, breaks=breaks, axes=TRUE, ylim=c(0,50), main=c(""), xlab="")
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.12)))
dev.off()



