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

nreps = 250
num.to.plot = 20
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
        print(c("v=", v))
        mean.v = mean.v + v
        if (j <= num.to.plot) {
            min.v = min(min.v, v);
            max.v = max(max.v, v);
        }
    }
    mean.list[[i]] = mean.v/nreps
    min.list[[i]] = min.v
    max.list[[i]] = max.v
}

print(c("mean.list=", mean.list))
print(c("min.list=", min(min.list)))
print(c("max.list=", max(max.list)))


c.max.v = -11e300;
c.min.v = 0;
centered = c()
for (j in seq(1, nreps)) {
    row.list = c()
    for (i in seq(1, ntrees)) {
        v = bs[[j]][[i]] - mean.list[[i]];
        row.list[[i]] = v;
        if (j <= num.to.plot) {
            c.max.v = max(c.max.v, v);
            c.min.v = min(c.min.v, v);
        }
    }
    centered[[j]] = row.list;
}

u.real.width = max.v - min.v
c.real.width = c.max.v - c.min.v

denom = 1 + num.to.plot
uoffset = 0.1
uwidth = 1.1

colors = c( "#00CC00", # dark green
            "#0000FF", # bright blue
            "#FF0000"  # bright red
          , "#BBDD00" # yellow
          , "#DD00FF" # purple
          , "#DDBB00" # orange
          , "#00FFFF" #  cyan
          , "#9999FF" # cornflower blue
          , "#FF8888" # pink
          , "#99FF99" #light green
          , "#333399" # dark blue
          , "#BB4444" # salmon
          , "#666600" # brown
          , "#000000" # black
          , "#999999" # grey
          )

pdf("sh_test_uncentered_plots.pdf")
plot(x=c(uoffset, uoffset + uwidth), y=c(1/denom, 1/denom), type='l', lty=2, 
     xlim=c(0, uwidth + 2*uoffset), 
     ylim=c(0, 1.1), axes=FALSE, ylab="", xlab="", main="")
for (i in seq(num.to.plot)) {
    text(0.02, 1 - i/denom, paste('boot', as.character(i), sep=' ') , col=colors[i])
    lines(c(uoffset, uoffset + uwidth), c(i/denom, i/denom), lty=2)
}
text(uoffset, 0, as.character(round(min.v, 1)))
text(uoffset + uwidth, 0, as.character(round(max.v, 1)))
for (j in seq(ntrees)) {
    abline(v=uoffset + uwidth*(mean.list[[j]] - min.v)/u.real.width, col=colors[j], cex=0.5)
}
for (i in seq(num.to.plot)) {
    y = 1 - i/denom
    for (j in seq(ntrees)) {
        points(uoffset + uwidth*(bs[[i]][[j]] - min.v)/u.real.width, y, col=colors[j], pch=4)
    }
}
dev.off()


coffset = 0.1
cwidth = 1.1

pdf("sh_test_centered_plots.pdf")

plot(x=c(uoffset, uoffset + uwidth), y=c(1/denom, 1/denom), type='l', lty=2, 
     xlim=c(0, 2*coffset + cwidth), 
     ylim=c(0,1.1), axes=FALSE, ylab="", xlab="", main="")
for (i in seq(num.to.plot)) {
    text(0.02, 1 - i/denom, paste('boot', as.character(i), sep=' '))
    lines(c(coffset, coffset + cwidth), c(i/denom,  i/denom), lty=2)
}
abline(v=coffset + cwidth/2)
text(coffset, 0, as.character(round(c.min.v, 1)))
text(0.02 + coffset + cwidth/2, 0.0, "0")
text(coffset + cwidth, 0.0, as.character(round(c.max.v, 1)))

for (i in seq(num.to.plot)) {
    y = 1 - i/denom
    for (j in seq(ntrees)) {
        points(coffset + cwidth*(centered[[i]][[j]] - c.min.v)/c.real.width, y, col=colors[j], pch=4)
    }
}

dev.off()



coffset = uoffset
cwidth = uwidth
toffset = 0.1
twidth = cwidth

t.max.v = 0.0
t.min.v = 0.0
boot.ts = c()
for (j in seq(1, nreps)) {
    t.row.list = c()
    for (i in seq(1, ntrees)) {
        c.max.row = max(centered[[j]]) ;
        t.row.list = centered[[j]] - c.max.row  ;
        if (j <= num.to.plot) {
            t.min.v = min(t.min.v, min(t.row.list));
        }
    }
    boot.ts[[j]] = t.row.list;
}
t.real.width = -t.min.v;
pdf("sh_test_stat_plots.pdf")

plot(x=c(coffset, coffset + cwidth), y=c(1/denom, 1/denom), type='l', lty=2, 
     xlim=c(0,toffset + twidth + coffset), 
     ylim=c(0,1.1), axes=FALSE, ylab="", xlab="", main="")
for (i in seq(num.to.plot)) {
    text(0.02, 1 - i/denom, paste('boot', as.character(i), sep=' '))
    lines(c(toffset, toffset + twidth), c(i/denom, i/denom), lty=2)
    lines(c(coffset, coffset + cwidth), c(i/denom,  i/denom), lty=2)
}
text(toffset - 0.01 , 0, "0")
mts = min(obs.ts)
text(toffset - twidth*mts/t.real.width + 0.03, 0.0, as.character(round(2*mts, 1)))

for (i in seq(num.to.plot)) {
    y = 1 - i/denom
    for (j in seq(ntrees)) {
        vts = boot.ts[[i]][[j]]
        print(c("testing ", vts, "<=", obs.ts[[j]]))
        if (vts <= obs.ts[[j]]) {
            point.type = 4
        }
        else {
            point.type = 3
        }
        points(toffset - twidth*vts/t.real.width, y, col=colors[j], pch=point.type)
    }
}

for (j in seq(ntrees)) {
    abline(v=toffset + - twidth*obs.ts[[j]]/t.real.width, col=colors[j], cex=0.5)
}


print(c("obs.ts = ", obs.ts))
dev.off()












