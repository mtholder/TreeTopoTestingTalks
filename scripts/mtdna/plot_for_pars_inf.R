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
mult=7
breaks=seq(-biggest, biggest, 0.1)
sbreaks=seq(-biggest*mult, biggest*mult, 0.1*mult)

pdf('diff1-2hist.pdf')
hist( 2*(t2$tree1 - t2$tree2), breaks=breaks, axes=FALSE, ylim=c(0,50), main=c(""), xlab="", col="red", ylab="")
dev.off()
print(c("diffs:", length(2*(t2$tree1 - t2$tree2)), 2*(t2$tree1 - t2$tree2)))

