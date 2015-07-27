import sys
inp = open(sys.argv[1])
inp.next()
offset = 0
tree2_sitelnL = {}
tree_names = []
for row in inp:
    rs = row.strip()
    if not rs:
        continue
    s = row.split('\t')
    #print s
    if s[0]:
        if len(tree_names) > 1:
            assert len(row_lnL) == num_sites
        elif len(tree_names) == 1:
            num_sites = len(row_lnL)
        row_lnL = []
        tree_name = 'tree{}'.format(1 + len(tree_names))
        tree_names.append(tree_name)
        tree2_sitelnL[tree_name] = row_lnL
    else:
        last_word = s[-1].strip()
        row_lnL.append('-' + last_word)

sys.stdout.write('Site\t{}\n'.format('\t'.join(tree_names)))
site_number = 1
for site_number in range(1, num_sites + 1):
    sys.stdout.write('{}'.format(site_number))
    for tn in tree_names:
        siteLnL = tree2_sitelnL[tn][site_number - 1]
        sys.stdout.write('\t{}'.format(siteLnL))
    sys.stdout.write('\n')
