#!/usr/bin/env python3

import sys


def split(fpath, n, k):
    with open(fpath, 'r') as f:
        ln = sum(1 for l in f)
        un = -(-ln // n)

        f.seek(0)
        s = ""
        for i, l in enumerate(f):
            if i >= un * (k - 1) and i < un * k:
                s += l

    return s.strip()


if __name__ == '__main__':
    fpath = sys.argv[1]
    n = int(sys.argv[2])
    k = int(sys.argv[3])

    print(split(fpath, n, k))
