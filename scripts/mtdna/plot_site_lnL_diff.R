t = read.table('sitelnL3000.csv', sep='\t', header=TRUE)

d1.2 = t$tree1 - t$tree2
d1.3 = t$tree1 - t$tree3
d1.12 = t$tree1 - t$tree12

nsites = length(d1.2)




biggest1.2=max(ceiling(max(d1.2)*10),ceiling(-min(d1.2)*10))/10
biggest1.3=max(ceiling(max(d1.3)*10),ceiling(-min(d1.3)*10))/10
biggest1.12=max(ceiling(max(d1.12)*10),ceiling(-min(d1.12)*10))/10
biggest = max(biggest1.2, biggest1.3, biggest1.12)

rellfunc = function(diffs) {
    centering = sum(diffs)
    obs = abs(centering)
    rellMoreExtreme = 0;
    nrellreps = 10000;
    for (i in c(1:nrellreps)) {
        r = sample(diffs, replace=TRUE)
        rs = abs(sum(r) - centering)
        if (rs >= obs) {
            rellMoreExtreme = rellMoreExtreme + 1;
        }
    }
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


print(ztestkh(d1.2))
print(rellfunc(d1.2))
    
x = seq(-biggest, biggest, 0.01)
breaks=seq(-biggest, biggest, 0.1)
print(breaks)
pdf('d1-2hist.pdf')
hist(d1.2, breaks=breaks, axes=TRUE, ylim=c(0,50))
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.2)))
dev.off()


print(ztestkh(d1.3))
print(rellfunc(d1.3))

x = seq(-biggest, biggest, 0.01)
breaks=seq(-biggest, biggest, 0.1)
print(breaks)
pdf('d1-3hist.pdf')
hist(d1.3, breaks=breaks, axes=TRUE, ylim=c(0,50))
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.3)))
dev.off()



print(ztestkh(d1.12))
print(rellfunc(d1.12))


x = seq(-biggest, biggest, 0.01)
breaks=seq(-biggest, biggest, 0.1)
print(breaks)
pdf('d1-12hist.pdf')
hist(d1.12, breaks=breaks, axes=TRUE, ylim=c(0,50))
#lines(x, 5*dnorm(x, mean=0, sd=sd(d1.12)))
dev.off()



