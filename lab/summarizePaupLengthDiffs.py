#!/usr/bin/env python
import sys
import re
import itertools
try:
    fn = sys.argv[1]
except:
    sys.exit('Expecting a filename of a PAUP log as an argument\n')
try:
    f = open(fn, 'rU')
except:
    sys.exit('Could not open "' + fn + '"\n')

p_score_pattern = re.compile('^Length\s+(\d+)')
best_score_list = []
null_score_list = []
add_to_best = True
for line in f:
    m = p_score_pattern.match(line)
    if m:
        pscore = int(m.group(1))
        if add_to_best:
            best_score_list.append(pscore)
        else:
            null_score_list.append(pscore)
        add_to_best = not add_to_best

diff_list = []
print 'rep\tbest\tnull\tdiff'
n = 0
for b_sc, n_sc in itertools.izip(best_score_list, null_score_list):
    n += 1
    d = n_sc - b_sc
    diff_list.append(d)
    print '%d\t%d\t%d\t%d' % (n, b_sc, n_sc, d)

diff_list.sort()
sys.stderr.write('Approximate critical values for different significance levels\n')

num_sim_reps = len(diff_list)
for s in range(10,20):
    one_minus_alpha = s/20.0
    alpha = 1 - one_minus_alpha
    cutoff = int(num_sim_reps*one_minus_alpha)
    cv = diff_list[cutoff]
    sys.stderr.write('Significance level of %f attained if test statistic is greater than %d\n' % (alpha,  cv))

denom = 100
while denom <= num_sim_reps:
    alpha = 1.0/denom
    one_minus_alpha = 1 - alpha
    cutoff = int(num_sim_reps*one_minus_alpha)
    cv = diff_list[cutoff]
    sys.stderr.write('Significance level of %f attained if test statistic is greater than %d\n' % (alpha,  cv))
    denom *= 10
    
    


        
