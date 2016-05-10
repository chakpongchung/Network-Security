#! /usr/bin/env python
import sys
import math

p=int(sys.argv[1])
g=int(sys.argv[2])
s=int(sys.argv[3])

T=(g**s)%p
print(T)


