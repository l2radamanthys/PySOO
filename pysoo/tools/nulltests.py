#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#       nulltests.py
#       
#       Copyright 2011 Nelson Efrain Cruz <nelson@Zoidberg>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.
#       
#       
from random_variables import *
from math import fabs

def ks(samples, variable):
	cumulative = variable.cumulative
	i = 1.0
	n = len(samples)
	maxim = 0.0
	for sample in samples:
		value = cumulative(sample)
		a = fabs(value - ((i-1)/n))
		b = fabs(value - (i/n))
		if a > maxim:
			maxim = a
		if b > maxim:
			maxim = b
		i += 1.0
	return maxim
	
def chi_basic(n, observations = [], prob = []):
	if len(observations) != len(prob):
		raise Exception('no coinciden los intervalos observados con las probabilidades por intervalo')
	estimator = 0.0
	for i in range(0,len(prob)):
		print i
		p = prob[i]
		expected_value = p*n
		estimator += pow(observations[i] - expected_value, 2)/expected_value
	return estimator

def main():
	l = [0.09,0.32,0.36]
	va = Exponential(2)
	print ks(l,va)
	print 'end'
	o = [6,3,7,5,4,6]
	p = [0.16666666]*6
	n = 31
	print chi_basic(n,o,p)

if __name__ == '__main__':
	main()

