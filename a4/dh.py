#! /usr/bin/env python
import sys
import math

user1=sys.argv[1]
user2=sys.argv[2]

g=104723
p=104729  

f15s={}


f15s['cs772']=104347 
f15s['wahab']=104327 
f15s['aalmutai']=104369
f15s['ayanamad']=104381
f15s['balkh']=104383
f15s['cchun008']=104393
f15s['halfuray']=104399
f15s['mabdelaa']=104417
f15s['mabdulka']=104459
f15s['mkompal']=104527
f15s['mkompall']=104537
f15s['ntippart']=104543
f15s['pvargas']=104471
f15s['smelton']=104473
f15s['smilanko']=104479
f15s['spopuri']=104491
f15s['zli']=104513


def get1s(name):
	return(f15s[name])

def compute1T (p, g, s):
	T=pow(g,s,p)
	return (T)
	
def compute1S (p,s,t):
	S=pow(t,s,p)
	return(S)

def getsecret(alice, bob):
	a=get1s(alice)
	b=get1s(bob)
	#print('personal secrets:')
	#print(a,b)
	bt=compute1T(p,g,b)
	X=compute1S(p,a,bt)
	#print('X shared secret:')
	#print(X)

	at=compute1T(p,g,a)
	Y=compute1S(p,b,at)
	#print('Y shared secret:')
	print(Y)

getsecret(user1, user2)
