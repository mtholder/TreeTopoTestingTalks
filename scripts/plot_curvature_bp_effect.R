d = read.table('curves.csv', sep='\t', header=TRUE)
pdf("curvature_bp_effect.pdf")
plot(d$r, d$linbp, 
    xlim=c(.5,1.5), ylim=c(0,1),
    xlab="r", ylab="\"BP\"",
    main="Effect of boundary curvature on the plot of BP versus r", 
    type='l')
points(d$r, d$linbp, pty=1)
lines(d$r, d$curvbp, lty=2)
points(d$r, d$curvbp, pty=2)
dev.off()

