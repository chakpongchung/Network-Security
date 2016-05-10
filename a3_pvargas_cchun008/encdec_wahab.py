import random
import math
import base64

def base64fileEncode(file, efile):
	fstr = file2str(file)
	data = base64.encodestring(fstr).strip()
	str2file(data, efile)

def base64fileDecode(file, dfile):
	fstr = file2str(file)
	data = base64.decodestring(fstr)
	str2file(data, dfile)

def file2str(file):
        f = open(file)
        fstr = f.read()
        return fstr

def str2file(str, ofile):
	of=open(ofile, 'w')
	of.write(str)
	of.close()

def railFenceEncrypt(plain,numRails):

	if numRails == 1:
		return plain
	rail=[]
	for row in range(numRails):
		rail.append('')
	row=0
	dir=1
	for ch in plain:
		rail[row]=rail[row]+ch
		row=row+dir
		if row == numRails:
			dir=-1
			row=row-2
		if row == -1:
			dir=1
			row=row+2		
	cipher=''
	for row in range(numRails):
		cipher=cipher+rail[row]
	return cipher
		
def frailFenceEncrypt(pfile, numRails, cfile):
	plain = file2str(pfile)
	cipher=railFenceEncrypt(plain, numRails)
	str2file(cipher,cfile)

def railFenceDecrypt(cipher,numRails):
	
	if numRails == 1:
		return cipher
	
	crail=[]
	for row in range(numRails):
		crail.append('')
	row=0
	dir=1
	for ch in cipher:
		crail[row]=crail[row]+ch
		row=row+dir
		if row == numRails:
			dir=-1
			row=row-2
		if row == -1:
			dir=1
			row=row+2		
	
	countRail=[]
	for row in range(numRails):
		countRail.append(0)
		
	
	for row in range(numRails):
		countRail[row]=len(crail[row])
		
	
	rail=[]	
	for row in range(numRails):
		rail.append([])
		
				
	begin=0
	for row in range(0,numRails):
		end=begin+countRail[row]
		rail[row]=list(cipher[begin:end])
		begin=end
	
	row=0
	plain=''
	dir=1
	for i in range (len(cipher)):
		plain=plain+rail[row].pop(0)
		row=row+dir
		if row == numRails:
			dir=-1
			row=row-2
		if row==-1:
			dir=1
			row=row+2

	return plain


def frailFenceDecrypt(cfile,numRails, pfile):
	
	cipher = file2str(cfile)
	plain=railFenceDecrypt(cipher,numRails)
	str2file(plain,pfile)
	
def genKeyLong():
	alpha="abcdefghijklmnopqrstuvwxyz "
	key=""
	for i in range(len(alpha)):
		ch=random.randint(0,26-i)
		key=key+alpha[ch]
		alpha=rmChar(alpha,ch)
	return key
	
def rmChar(st,idx):
	return st[:idx]+st[idx+1:]

def subEncrypt(plain, key):

	alpha="abcdefghijklmnopqrstuvwxyz "
	cipher=""
	for ch in plain:
		idx=alpha.find(ch)
		if idx == -1:
			cipher=cipher+ch
		else:
			cipher=cipher+key[idx]
	return cipher

def fsubEncrypt(pfile, key, cfile):
	plain = file2str(pfile)
	cipher=subEncrypt(plain,key)
	str2file(cipher,cfile)
	
def subDecrypt(cipher, key):

	alpha="abcdefghijklmnopqrstuvwxyz "
	plain=""
	for ch in cipher:
		idx=key.find(ch)
		if idx == -1:
			plain=plain+ch
		else:
			plain=plain+alpha[idx]
	return plain

def fsubDecrypt(cfile, key, pfile):

	cipher = file2str(cfile)
	plain= subDecrypt(cipher,key)
	str2file(plain,pfile)

def genKeyPasswd(passwd):
	key="abcdefghijklmnopqrstuvwxyz "
	passwd=rmDup(passwd)
	lastch=passwd[-1]
	lastIdx=key.find(lastch)
	afterSt=rmMatch(key[lastIdx+1:], passwd)
	beforeSt=rmMatch(key[:lastIdx], passwd)
	key=passwd+afterSt+beforeSt
	return key
	
def rmDup(st):
	nst=""
	for ch in st:
		if ch not in nst:
			nst=nst+ch
	return nst
	
def rmMatch(st, rst):
	nst=""
	for ch in st:
		if ch not in rst:
			nst=nst+ch
	return nst

def letterToIndex(ch):
	alpha="abcdefghijklmnopqrstuvwxyz "
	idx=alpha.find(ch)
	return idx

def indexToLetter(idx):
	alpha="abcdefghijklmnopqrstuvwxyz "
	if idx >26 or idx <0:
		print('error: ', idx)
		letter=''
	else:
		letter=alpha[idx]
	return letter
	
def vignereIndex(keyLet, plainLet):
	keyIndex=letterToIndex(keyLet)
	plainIndex=letterToIndex(plainLet)
	if plainIndex == -1:
		return plainLet
	else:
		newIndex=(plainIndex+keyIndex)%27
		return indexToLetter(newIndex)

def vignereRevIndex(keyLet, cipherLet):
	keyIndex=letterToIndex(keyLet)
	cipherIndex=letterToIndex(cipherLet)
	if cipherIndex == -1:
		return cipherLet
	else:
		newIndex=(cipherIndex-keyIndex)%27
		return indexToLetter(newIndex)
	
def viEncrypt(passwd, plain):

	key=genKeyPasswd(passwd)
	cipher=""
	keyLen=len(key)
	for i in range(len(plain)):
		ch = plain[i]
		cipher=cipher+vignereIndex(key[i%keyLen], ch)
	return cipher

def fviEncrypt(passwd, pfile, cfile):

	plain = file2str(pfile)
	cipher=viEncrypt(passwd, plain)
	str2file(cipher,cfile)
	
def viDecrypt(passwd, cipher):

	key=genKeyPasswd(passwd)
	plain=""
	keyLen=len(key)
	for i in range(len(cipher)):
		ch = cipher[i]
		plain=plain+vignereRevIndex(key[i%keyLen], ch)
	return plain

def fviDecrypt(passwd, cfile, pfile):
	cipher = file2str(cfile)
	plain = viDecrypt(passwd, cipher)
	str2file(plain,pfile)
	
	
def xorEncryptDecrypt(passwd, inputString):
	outString=""
	key=genKeyPasswd(passwd)
	keyLen=len(key)
	for i in range(len(inputString)):
		ch = inputString[i]
		outString=outString+ chr( ord(key[i%keyLen]) ^ ord(ch) )
	return outString

def xorEncryptDecrypt_wahab(passwd, inputString):
	outString=""
	key=file2str(passwd)
	keyLen=len(key)
	for i in range(len(inputString)):
		ch = inputString[i]
		outString=outString+ chr( ord(key[i]) ^ ord(ch) )
	return outString

def fxorEncryptBase64(passwd, inputfile, outputfile):

	inputString = file2str(inputfile)
	outString = xorEncryptDecrypt(passwd, inputString)
	data = base64.encodestring(outString).strip()
	str2file(data,outputfile)


def fxorDecryptBase64(passwd, inputfile, outputfile):

	data = file2str(inputfile)
	inputString = base64.decodestring(data)
	outString = xorEncryptDecrypt(passwd, inputString)
	str2file(outString,outputfile)

def fxorEncryptBase64_wahab(passwd, inputfile, outputfile):

	inputString = file2str(inputfile)
	outString = xorEncryptDecrypt_wahab(passwd, inputString)
	data = base64.encodestring(outString).strip()
	str2file(data,outputfile)


def fxorDecryptBase64_wahab(passwd, inputfile, outputfile):

	data = file2str(inputfile)
	inputString = base64.decodestring(data)
	outString = xorEncryptDecrypt_wahab(passwd, inputString)
	str2file(outString,outputfile)	

def fxorEncryptDecrypt(passwd, inputfile, outputfile):
	inputString = file2str(inputfile)
	outString=xorEncryptDecrypt(passwd,inputString)
	str2file(outString,outputfile)

