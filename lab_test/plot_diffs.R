d = read.table('step20.diffs.txt', sep='\t', header=TRUE)
obs = as.integer(commandArgs(trailingOnly = TRUE))
print(c("obs = ", obs))
md = max(d$diff)
m = max(md, obs)
pdf('null_distribution_pscore_diffs.pdf')
hist(d$diff,
    main='Null distribution approximated by parametric bootstrapping',
    xlab='difference in tree length')
abline(v=obs)
pvalue = sum(d$diff >= obs)/length(d$diff)
text(0, -   15, paste('P value approx =', as.character(pvalue)), pos=4)
dev.off()
print(c("Approx P-value = ", as.character(pvalue)))
