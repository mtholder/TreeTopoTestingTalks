import sys, random
competitors = range(int(sys.argv[1]))
num_reps = int(sys.argv[3])
flips = range(int(sys.argv[2]))
reps = range(num_reps)


diff_first_two = []
diff_first_best = []
for r in reps:
    ph = []
    for c in competitors:
        s = sum([(random.random() < 0.5 and 1 or 0) for f in flips])
        ph.append(s)
    diff_first_two.append(ph[0] - ph[1])
    diff_first_best.append(max(ph) - ph[0])

sys.stdout.write('n\tp\tb\n')

for n, p in enumerate(diff_first_two):
    b = diff_first_best[n]
    sys.stdout.write('%d\t%d\t%d\n' % (n, p, b))

diff_first_two = [abs(i) for i in diff_first_two]
diff_first_two.sort()
diff_first_best.sort()
cutoff = int(19*num_reps/20)
sys.stderr.write('5%% critical value for comparing 2 a priori individuals: %f\n' % (diff_first_two[cutoff]))
sys.stderr.write('5%% critical value for comparing one individuals vs the best: %f\n' % (diff_first_best[cutoff]))
sys.stderr.write('max from comparing 2 a priori individuals: %f\n' % (diff_first_two[-1]))
sys.stderr.write('max comparing one individuals vs the best: %f\n' % (diff_first_best[-1]))
