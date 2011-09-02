#!/usr/bin/env python
# -*- coding: utf-8 -*-


#sin implementar Heap

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


    def __len__(self):
        return len(self.__elementos)


    tamanio = __len__


    def pertenece(elemento):
        return elemento in self.__elementos



class ColaLIFO(ColaFIFO):
    """
        Clase q simula una cola de tipo LIFO
    """
    def sacar(self):
        return self.elemento.pop()


class Conjunto(ColaLIFO):
    def __init__(self):
        ColaFIFO.__init__(self)


    def sacar(self, obj):
        pass


    def sacar_ultimo(self):
        pass


    def pertenece(self, obj):
        pass


    def vacio(self):
        pass


    #toy pensando si implementar o no los siguientes metodos :S
    #ya q no se si valen la pena
    #error_llena()
    #error_vacia()
    #error_no_encontrado()
    #error_tamanio_minimo()
    #error_factor_ampliacion(factor)


class NodoHeap:
    """
        formato de registro de los Nodos Pertenecientes a la pila o Heap
    """
    def __init__(self, obj=None, t=0.0):
        self.objecto = obj  #apuntador a un objecto
        self.tiempo = t


#por el momento no aseguro que esta clase funcione correrctamento
#me esta costando entender la idea de esta clase :(
class Heap:
    def __init__(self):
        self.__heap = [NodoHeap(t=-1e37)]


    def poner(self, r, datos):
        nodo = NodoHeap(datos, r)
        expl = len(self.__heap) - 1


    def sacar(self, r):
        pass


    def vacio(self):
        """
            devuelve el estado
        """
        return not(self.__len__())


    def altura(self):
        pass


    def imprime_arbol(self):
        #todavia no le entiendo la gracia a este metodo para mostrar el
        #arbol
        pass


    def __len__(self):
        """
            sobrecarga del operador longitud, que permitira conocer
            externamente la cantidad de elementos de la Heap (Pila)
        """
        return len(self.__heap)




