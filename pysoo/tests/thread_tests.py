#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#       sin título.py
#       
#       Copyright 2011 Nelson Efrain A. Cruz <neac03@gmail.com>
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

from threading import Thread
import time
from random import random
import threading

global_lock = threading.Lock()

class Hilo(Thread):
	
	def __init__(self, num):
		Thread.__init__(self)
		self.num = num
		self.cond = threading.Condition(global_lock)
	
	def run(self):
		#print 'inicie', self.num
		time.sleep(random())
		print 'desperte', self.num
		self.cond.acquire()
		print self.num
		self.cond.notify()
		self.cond.release()
		
class Hilo2(Thread):
	
	def __init__(self, num):
		Thread.__init__(self)
		self.num = num
		self.cond = threading.Condition(global_lock)
	
	def run(self):
		#print 'inicie', self.num
		time.sleep(random())
		print 'desperte', self.num
		self.cond.acquire()
		print self.num
		self.cond.notify()
		self.cond.wait()
		print 'extra job completed'
		self.cond.release()
	

def main():
	numeros = range(0,15)
	hilos = []
	for n in numeros:
		if n == 2: hilos.append(Hilo2(n))
		else: hilos.append(Hilo(n))
	for n in numeros:
		hilos[n].cond.acquire()
		hilos[n].start()
		hilos[n].cond.wait()
		print 'init ',n
		hilos[n].cond.release()
	hilos[2].cond.acquire()
	hilos[2].cond.notify()
	hilos[2].cond.release()
	print 'fin principal'
	return 0

if __name__ == '__main__':
	main()

