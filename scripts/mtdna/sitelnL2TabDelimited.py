import sys
inp = open(sys.argv[1])
inp.next()
offset = 0
row_lnL = [['tree1']]
for row in inp:
    s = row.split('\t')
    if s[0]:
        offset += 1
        r_iter = iter(row_lnL)
        r = r_iter.next()
        r.append('tree%d' % (1 + offset))
    else:
        last_word = s[-1].strip()
        if offset == 0:
            row_lnL.append([last_word])
        else:
            r = r_iter.next()
            assert(len(r) == offset)
            r.append(last_word)

for n, r in enumerate(row_lnL):
    if n == 0:
        sys.stdout.write('Site\t')
    else:
        sys.stdout.write('%d\t' % (n))
    print '\t'.join(r)
sys.stderr.write(str(offset) + ' trees\n')
