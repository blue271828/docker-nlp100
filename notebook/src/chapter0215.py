#!/usr/bin/env python3

import sys


def tail(fpath, n):
    with open(fpath) as f:
        return ''.join(f.readlines()[-n:])


if __name__ == '__main__':
    fpath = sys.argv[1]
    n = int(sys.argv[2])

    print(tail(fpath, n))
