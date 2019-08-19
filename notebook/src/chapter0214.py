#!/usr/bin/env python3

import sys


def head(fpath, n):
    h = ""
    with open(fpath) as f:
        for i in range(n):
            h += next(f)
    return h


if __name__ == '__main__':
    fpath = sys.argv[1]
    n = int(sys.argv[2])

    print(head(fpath, n))
