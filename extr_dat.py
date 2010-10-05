#!/usr/bin/env python
# -*- coding: utf-8 -*-


class ColaFIFO:
    """
        Clase q simula una cola FIFO
    """
    def __init__(self):
        self.__elementos = []


    def poner(self, elemento):
        self.__elementos.append(elemento)
        return elemento


    def sacar(self):
        return self.elemento.pop(0)


    def cabeza(self):
        return self.__elementos[0]


    def cola(self):
        return self.__elementos[-1]


    def tamanio(self):
        return len(self.__elementos)


    def pertenece(elemento):
        return elemento in self.__elementos


class ColaLIFO(ColaFIFO):
    """
        Clase q simula una cola de tipo LIFO
    """
    def sacar(self):
        return self.elemento.pop()

