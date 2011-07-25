d = read.table('cfc.csv', sep='\t', header=TRUE)
pdf("cfc_diff_a_priori.pdf")
breaks=seq(min(d$p)-.5, max(d$b)+.5, 1)
hist(d$p, breaks, xlab=c("Diff # heads"), main="Null dist.: difference in # heads any two competitors");
abline(v=14.5)
abline(v=-14.5)
dev.off()
pdf("cfc_diff_best_v_one.pdf")
hist(d$b, breaks, xlab=c("Diff # heads"), main="Null dist.: difference highest - random competitor");
abline(v=21.5)
dev.off()
