#! /usr/bin/env python
import sys
import math

m=int(sys.argv[1])
p=int(sys.argv[2])
q=int(sys.argv[3])
n=p*q
e=65537

v=pow(m,e,n)
print(v)


