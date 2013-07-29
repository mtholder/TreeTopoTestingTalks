#!/usr/bin/env python
import sys
f = None
for line in sys.stdin:
    ls = line.strip()
    try:
        x = int(ls)
    except:
        x = float(ls)
    if f is None:
        f = x
    else:
        print x - f
        f = None
