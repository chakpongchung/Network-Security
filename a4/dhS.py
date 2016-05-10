#! /usr/bin/env python
import sys
import math

p=int(sys.argv[1])
s=int(sys.argv[2])
t=int(sys.argv[3])


S=(t**s)%p
print(S)


