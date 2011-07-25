#!/usr/bin/env python
#
#  A           C
#   \         /
#   left====right
#   /         \
#  B           D
TOL = 1e-6
max_v = 30
step = 2
mult = .5/max_v
int_st_p = []
mab = 0.0
mac = 0.0
mad = 0.0
for a in range(0, max_v,step):
    pa = a*mult
    ompa = 1 - pa
    for e in range(0, max_v,step):
        pe = e*mult
        ompe = 1 - pe
        lr00 = ompa*ompe
        lr01 = ompa*pe
        lr10 = pa*pe
        lr11 = pa*ompe
        for b in range(a, max_v,step):
            pb = b*mult
            ompb = 1 - pb
            # s and d are for same and diff
            left_s_r0 = lr00*ompb + lr10*pb
            left_d_r0 = lr00*pb + lr10*ompb
            left_s_r1 = lr01*ompb + lr11*pb
            left_d_r1 = lr01*pb + lr11*ompb
            for c in range(0, max_v,step):
                pc = c*mult
                ompc = 1 - pc
                for d in range(c, max_v,step):
                    pd = d*mult
                    ompd = 1 - pd
                    const  = left_s_r0*ompc*ompd + left_s_r1*pc*pd
                    d_diff = left_s_r0*ompc*pd + left_s_r1*pc*ompd
                    c_diff = left_s_r0*pc*ompd + left_s_r1*ompc*pd
                    ab_syn = left_s_r0*pc*pd + left_s_r1*ompc*ompd
                    b_diff = left_d_r0*ompc*ompd + left_d_r1*pc*pd
                    a_diff = left_d_r0*pc*pd + left_d_r1*ompc*ompd
                    ac_syn = left_d_r0*ompc*pd + left_d_r1*pc*ompd
                    ad_syn = left_d_r0*pc*ompd + left_d_r1*ompc*pd
                    mab = max(mab, ab_syn)
                    mac = max(mac, ac_syn)
                    mad = max(mad, ad_syn)
                    assert(abs(1 - const - d_diff - c_diff - ab_syn - b_diff - a_diff - ac_syn - ad_syn) < TOL)
                    print "%f,%f,%f" % (ab_syn, ac_syn, ad_syn)
                    print "%f,%f,%f" % (ab_syn, ad_syn, ac_syn)

import sys
sys.stderr.write('mab = %f\n' % mab)
sys.stderr.write('mac = %f\n' % mac)
sys.stderr.write('mad = %f\n' % mad)
