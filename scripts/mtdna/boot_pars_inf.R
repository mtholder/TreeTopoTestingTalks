#!/usr/bin/env R
n = 3000
t1 = 15
t2 = 11
t3 = 14
parsinf = t1 + t2 + t3
ppi = parsinf/n
p1gpi = t1/parsinf
p2g2or3 = t2/(t2 + t3)
nr = 500
for (i in seq(1, nr)) {
    ppr = rbinom(1, n, ppi)
    n1 = rbinom(1, ppr, p1gpi)
    n2or3 = ppr - n1
    n2 = rbinom(1, n2or3, p2g2or3)
    n3 = n2or3 - n2 
    if (ppr == 0)
        print(paste(c(1/3, 1/3, 1/3)))
        
    else {
        print(paste(n1/ppr, n2/ppr, n3/ppr))
    }
}
