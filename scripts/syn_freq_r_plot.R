require(scatterplot3d)
require(rgl)



t = read.table('pu.csv', sep=',', header=TRUE)
# setup rgl environment:
zscale <- 1
 
# clear scene:
clear3d("all")
 
# setup env:
bg3d(color="white")
light3d()


# draw shperes in an rgl window
spheres3d(t$ab, t$ac, t$ad, radius=0.025, color=rgb(1,0,0))
