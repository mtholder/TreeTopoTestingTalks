#!/usr/bin/env python
import re
import sys
fn = sys.argv[1]
log_file = open(fn, 'rU')
looking_for = 'Tree'
for line in log_file:
    if line.startswith(looking_for):
        if looking_for == '-------':
            break
        else:
            looking_for = '-------'
    elif looking_for == '-------':
        looking_for = 'Tree'
try:
    line = log_file.next()
    assert(line.startswith('-ln L'))
except:
    sys.exit("No LScore parameter output found!\n") 
line = log_file.next()
if line.startswith('Base frequencies:'):
    base_freqs = [log_file.next().strip().split()[1] for i in range(4)]
    line = log_file.next()
else:
    base_freqs = ['0.25' for i in range(4)]
if line.startswith('Rate matrix R:'):
    rmat = [log_file.next().strip().split()[1] for i in range(6)]
    line = log_file.next()
else:
    rmat = ['1.0' for i in range(6)]
if line.startswith('P_inv'):
    pinv = line.strip().split()[1]
    line = log_file.next()
else:
    pinv = '0.0'
if line.startswith('Shape'):
    shape = line.strip().split()[1]
    line = log_file.next()
else:
    shape = 'inf'
param_list = [shape, pinv] + rmat + base_freqs
print 'seq-gen -mGTR -a%s -i%s -r %s %s %s %s %s %s -f %s %s %s %s' % tuple(param_list)
