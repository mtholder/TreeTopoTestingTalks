border_x = 110
gen_x = border_x + 5
gen_y = 100.0
sd_x = 30
sd_y = 30
n_points = 40

plot_buffer = 8

# draw a point and make sure that it has a mean x > border_x
est_x = 0
while ((est_x < border_x + 5) | (est_x > (border_x + 10))) {
    obs_x = rnorm(n_points, mean=gen_x, sd=sd_x)
    obs_y = rnorm(n_points, mean=gen_y, sd=sd_y)
    est_y = mean(obs_y)
    obs_y = gen_y + obs_y - est_y
    y_min_lim = min(obs_y)
    y_max_lim = max(obs_y) 
    x_min_lim = min(obs_x)
    x_max_lim = max(obs_x) 
    est_x = mean(obs_x)
    est_y = mean(obs_y)
}


pdf('field.pdf')
plot(obs_x, obs_y, xlim=c(x_min_lim, x_max_lim), ylim=c(y_min_lim, y_max_lim), xlab="x", ylab="y")
polygon(c(0, border_x, border_x, 0),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#54FF9F')
points(obs_x, obs_y)
points(est_x, est_y, pch=16)
text(border_x - 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 - 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("0"), cex=1.5)
text(border_x + 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 + 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("1"), cex=1.5)
dev.off()



pdf('field-just-mean.pdf')
plot(obs_x, obs_y, type='n', xlim=c(x_min_lim, x_max_lim), ylim=c(y_min_lim, y_max_lim), xlab="x", ylab="y")
polygon(c(0, border_x, border_x, 0),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#54FF9F')
points(est_x, est_y, pch=16)
text(border_x - 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 - 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("0"), cex=1.5)
text(border_x + 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 + 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("1"), cex=1.5)
dev.off()




pdf('field-mean-rej.pdf')
plot(obs_x, obs_y, type='n', xlim=c(x_min_lim, x_max_lim), ylim=c(y_min_lim, y_max_lim), xlab="x", ylab="y")
polygon(c(0, border_x, border_x, 0),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#54FF9F')
polygon(c(est_x, x_max_lim + plot_buffer, x_max_lim + plot_buffer, est_x),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#FF8C69')
points(est_x, est_y, pch=16)
text(border_x - 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 - 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("0"), cex=1.5)
text(border_x + 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 + 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("1"), cex=1.5)
dev.off()

lfc_x = border_x
lfc_y = est_y
pdf('field-mean-rej-lfc.pdf')
plot(obs_x, obs_y, type='n', xlim=c(x_min_lim, x_max_lim), ylim=c(y_min_lim, y_max_lim), xlab="x", ylab="y")
polygon(c(0, border_x, border_x, 0),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#54FF9F')
polygon(c(est_x, x_max_lim + plot_buffer, x_max_lim + plot_buffer, est_x),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#FF8C69')
points(est_x, est_y, pch=16)
points(lfc_x, lfc_y, pch=15)
text(border_x - 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 - 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("0"), cex=1.5)
text(border_x + 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 + 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("1"), cex=1.5)
dev.off()

est_sd_y = sd(obs_y)
print(c("est_sd_y", est_sd_y))
est_sd_x = sd(obs_x)
print(c("est_sd_x", est_sd_x))

n_sims=1000

sim_mean_x = replicate(n_sims, mean(rnorm(n_points, mean=lfc_x, sd=est_sd_x)))
sim_mean_y = replicate(n_sims, mean(rnorm(n_points, mean=lfc_y, sd=est_sd_y)))
gt_obs = sim_mean_x >= est_x
p_val_from_markov = sum(gt_obs)/n_sims
pdf('field-mean-p-val-markov.pdf')
plot(obs_x, obs_y, type='n', xlim=c(x_min_lim, x_max_lim), ylim=c(y_min_lim, y_max_lim), xlab="x", ylab="y")
polygon(c(0, border_x, border_x, 0),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#54FF9F')
polygon(c(est_x, x_max_lim + plot_buffer, x_max_lim + plot_buffer, est_x),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#FF8C69')
points(est_x, est_y, pch=16)
points(lfc_x, lfc_y, pch=15)
points(sim_mean_x[gt_obs], sim_mean_y[gt_obs], cex=.6, pch=16,col='#27408B')
points(sim_mean_x[!gt_obs], sim_mean_y[!gt_obs], cex=0.5, pch=16)
text(border_x - 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 - 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("0"), cex=1.5)
text(border_x + 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 + 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("1"), cex=1.5)
text(border_x + 4*plot_buffer, y_max_lim  - plot_buffer, paste("P=", sum(gt_obs), "/", n_sims), cex=2)
text(border_x + 1 + 4*plot_buffer, y_max_lim  - 2*plot_buffer, paste("=", p_val_from_markov), cex=2)
dev.off()


boot_mean_x = replicate(n_sims, mean(sample(obs_x, replace=TRUE)))
boot_mean_y = replicate(n_sims, mean(sample(obs_y, replace=TRUE)))
in_null = boot_mean_x <= border_x
p_val_from_boot = sum(in_null)/n_sims
pdf('field-mean-p-val-boot.pdf')
plot(obs_x, obs_y, type='n', xlim=c(x_min_lim, x_max_lim), ylim=c(y_min_lim, y_max_lim), xlab="x", ylab="y")
polygon(c(0, border_x, border_x, 0),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#54FF9F')
polygon(c(est_x, x_max_lim + plot_buffer, x_max_lim + plot_buffer, est_x),
        c(y_min_lim - plot_buffer, y_min_lim - plot_buffer, y_max_lim + plot_buffer, y_max_lim + plot_buffer),
        col='#FF8C69')
points(est_x, est_y, pch=16)
points(lfc_x, lfc_y, pch=15)
points(boot_mean_x[in_null], boot_mean_y[in_null], cex=.6, pch=16,col='#27408B')
points(boot_mean_x[!in_null], boot_mean_y[!in_null], cex=0.5, pch=16)
text(border_x - 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 - 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("0"), cex=1.5)
text(border_x + 4*plot_buffer, gen_y - 3*plot_buffer, c("H"), cex=2)
text(border_x + 7 + 4*plot_buffer, gen_y - 6 - 3*plot_buffer, c("1"), cex=1.5)
text(border_x + 4*plot_buffer, y_max_lim - plot_buffer, paste("1-BP=", sum(in_null), "/", n_sims), cex=2)
text(border_x + 1 + 4*plot_buffer, y_max_lim - 2*plot_buffer, paste("=", p_val_from_boot), cex=2)
dev.off()

print(c("p_ests =" , p_val_from_markov, p_val_from_boot))

obs_diff = est_x - border_x
radius = 10
center_x = border_x - radius
center_y = est_y

for (r in seq(0.5, 2.0, 0.1)) {
    boot_mean_x = replicate(n_sims, mean(sample(obs_x, size=r*n_points, replace=TRUE)))
    boot_mean_y = replicate(n_sims, mean(sample(obs_y, size=r*n_points, replace=TRUE)))
    diff_center_x = boot_mean_x -center_x 
    diff_center_y = boot_mean_y - center_y
    diff_center_x_sq = diff_center_x*diff_center_x
    diff_center_y_sq = diff_center_y*diff_center_y
    diff_center_sq = diff_center_x_sq + diff_center_y_sq
    dist_center = diff_center_sq**0.5
    lin_bound = sum(boot_mean_x < border_x)
    lin_bound_p = 1 - lin_bound/n_sims
    circ_bound = sum(dist_center < radius)
    circ_bound_p = 1 - circ_bound/n_sims
    print(paste("r", r, lin_bound_p, circ_bound_p))
}
