#!/usr/bin/env python
# -*- coding: utf-8 -*-

from extr_datos import *
from random import *
import unittest

class TestEstrDatos(unittest.TestCase):
    #necesita tests mas extensos
    def setUp(self):
        self.elements = range(100000)
        self.heap = Heap()
        
    def test_sacar_heap(self):
        shuffle(self.elements)
        result = []
        for element in self.elements:
            self.heap.poner(element,None)
        for i in range(len(self.elements)):
            node = self.heap.sacar()
            result.append(node.value)
        self.assertEqual(result, range(len(self.elements)))
    
    def test_sacar_fifo(self):
        fifo = ColaFIFO()
        for element in self.elements:
            fifo.poner(element)
        result = []
        for element in self.elements:
            result.append(fifo.sacar())
        self.assertEqual(result, self.elements)


if __name__ == '__main__':
    unittest.main()

