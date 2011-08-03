d = read.table(commandArgs(trailingOnly=TRUE), sep=' ', header=TRUE)
height = 1.0
angle.in.radians = pi/3
cos.angle = cos(angle.in.radians)
sin.angle = sin(angle.in.radians)
tan.angle = tan(angle.in.radians)
half.width = height/tan(angle.in.radians)
width = 2*half.width
print(c(height, width));

to_bary_x = function(p1, p2) {
    o2t = sin.angle*(p2);
    a2t = cos.angle*(p2);
    y = p1;
    o2b = a2t + y;
    a2b = o2b/tan.angle;
    x = a2b + o2t;
    x
}

y = d$p1
x = to_bary_x(d$p1, d$p2)

mp1p3 = mean((d$p1 - d$p2))/2
y2 = d$p1 - mp1p3
x2 = to_bary_x(y2, d$p2 + mp1p3)
print(c("mp1p3", mp1p3))
print(c("y2", mean(y2)))
print(c("d$p2 + mp1p3", mean(d$p2 + mp1p3)))

do.background2 = function() {
    plot(c(0, width, half.width, 0), c(0, 0, height, 0), type="l", axes=FALSE, ylab="", xlab="")
    #p1 = c(0, 0,   1/3, 0.5, 0)
    #p2 = c(0, 0.5, 1/3, 0,   0)
    #polygon(to_bary_x(p1, p2), p1, col="#FFAAAA")
    p1 = c(1, 0.5, 1/3, 0, 1)
    p2 = c(0, 0.5, 1/3, 0,   0)
    polygon(to_bary_x(p1, p2), p1, col="#AAFFAA")
    p1 = c(1, 0.6, 1/3, 0.6, 1)
    p2 = c(0, 0.25, 1/3, 0.15,   0)
    polygon(to_bary_x(p1, p2), p1, col="#00AA00")
    p1 = c(0, 0.5, 1/3, 0, 0)
    p2 = c(1, 0.5, 1/3, 0, 1)
    polygon(to_bary_x(p1, p2), p1, col="#AAAAFF")
    p1 = c(0, 0.25, 1/3, 0.15, 0)
    p2 = c(1, 0.6, 1/3, 0.6, 1)
    polygon(to_bary_x(p1, p2), p1, col="#4444BB")
    lines(c(0, width, half.width, 0), c(0, 0, height, 0))
}
pdf("kh_points_before.pdf")
do.background2()
points(x, y, pch=".",cex=3)
p1=15/40
p2=11/40
points(to_bary_x(p1, p2), p1, pch=3, col="black")
dev.off()

pdf("kh_points_arrows.pdf")
do.background2()
points(x, y, pch=".",cex=3)
arrows(x, y, x1 = x2, y1 = y2, length = 0.1)
points(x2, y2, pch=".",cex=3)
dev.off()

pdf("kh_points_after.pdf")
do.background2()
points(x2, y2, pch=".",cex=3)
points(to_bary_x(p1, p2), p1, pch=3, col="black")
dev.off()


