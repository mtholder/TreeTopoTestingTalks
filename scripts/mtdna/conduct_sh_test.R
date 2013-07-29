#!/usr/bin/env R
t = read.table('sitelnL3000.csv', sep='\t', header=TRUE)

d1.2 = 2*(t$tree1 - t$tree2)
d1.3 = 2*(t$tree1 - t$tree3)

nsites = length(d1.2)


    
t$tree1 = -t$tree1
t$tree2 = -t$tree2
t$tree3 = -t$tree3
t$tree4 = -t$tree4
t$tree5 = -t$tree5
t$tree6 = -t$tree6
t$tree7 = -t$tree7
t$tree8 = -t$tree8
t$tree9 = -t$tree9
t$tree10 = -t$tree10
t$tree11 = -t$tree11
t$tree12 = -t$tree12
t$tree13 = -t$tree13
t$tree14 = -t$tree14
t$tree15 = -t$tree15
lnL1 = -sum(t$tree1)
lnL2 = -sum(t$tree2)
lnL3 = -sum(t$tree3)


bootstrap = function(lnLList, nreps) {
    ntrees = length(lnLList);
    nsites = length(lnLList[[1]]);
    inds = seq(1, nsites);
    b = c();
    for (r in seq(1, nreps)) {
        rinds = sample(inds, replace=TRUE);
        s = c();
        for (j in seq(1, ntrees)) {
            resam = lnLList[[j]][rinds]
            s[[j]] = sum(resam)
        }
        b[[r]] = s
    }
    b
}

d = list(t$tree1, t$tree2, t$tree3
    , t$tree4, t$tree5, t$tree6, t$tree7, t$tree8, t$tree9, t$tree10 , t$tree11 , t$tree12 , t$tree13 , t$tree14 , t$tree15
       )

ntrees = length(d);
scores = c()
for (i in seq(ntrees)) {
    scores[i] = sum(d[[i]])
}
mle.score = max(scores)
obs.ts =  scores - mle.score

nreps = 10000
bs = bootstrap(d, nreps)
print(c("bs=", bs))
nsites = length(d[[1]]);
mean.list = rep(0, ntrees)
min.list = rep(0, ntrees)
max.list = rep(0, ntrees)
for (i in seq(1, ntrees)) {
    mean.v = 0;
    max.v = -11e300;
    min.v = 0;
    for (j in seq(1, nreps)) {
        v = bs[[j]][[i]];
        mean.v = mean.v + v
    }
    mean.list[[i]] = mean.v/nreps
}

print(c("mean.list=", mean.list))

centered = c()
for (j in seq(1, nreps)) {
    row.list = c()
    for (i in seq(1, ntrees)) {
        v = bs[[j]][[i]] - mean.list[[i]];
        row.list[[i]] = v;
    }
    centered[[j]] = row.list;
}
boot.ts = c()
for (j in seq(1, nreps)) {
    t.row.list = c()
    for (i in seq(1, ntrees)) {
        c.max.row = max(centered[[j]]) ;
        t.row.list = centered[[j]] - c.max.row  ;
    }
    boot.ts[[j]] = t.row.list;
}

more.extreme = rep(0, ntrees)
for (i in seq(nreps)) {
    for (j in seq(ntrees)) {
        vts = boot.ts[[i]][[j]]
        if (vts <= obs.ts[[j]]) {
            more.extreme[[j]] = 1 + more.extreme[[j]]
        }
    }
}
print("approx P = ")
print(more.extreme/nreps)












