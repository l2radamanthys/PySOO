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
        Nodo, elementos del ABB
    """
    def __init__(self, obj=None, t=0.0):
        self.objeto = obj  #apuntador a un objeto
        #el peso de los nodos se define por la variable tiempo
        #si esta mal corregirlo :D
        self.tiempo = t

        #ramas
        self.rama_izq = None
        self.rama_der = None


    #sobrecarga de operadores
    def __eq__(self, nodo):
        return (self.tiempo == nodo.tiempo)
            

    def __neq__(self, nodo):
        return (self.tiempo != nodo.tiempo)
        

class Heap:
    """
        Es un ABB, nu es balanceadp

            (A)
           /   \ 
         (B)   (C)
        /   \     \

    """
    def __init__(self):
        self.__heap = NodoHeap(t=-1e37) #nodo raiz
        self.pointer = self.__heap #apuntador generico

    def poner(self, r=0, datos=None):
        """
            A partir de los datos pasados crea un Nodo y lo inserta
            en el ABB
        """
        nodo = NodoHeap(datos, r)
        self.pointer = self.__heap
        self._pone(nodo)
    
    
    def _poner(self, nodo): #no testeado
        """
            inserta un nodo en el ABB
        """
        if self.pointer.tiempo < nodo.tiempo:
            if self.pointer.rama_der == None:
                self.pointer.rama_der = nodo
                self.pointer = self.__heap
            else:
                self.pointer.rama_der = self.pointer
                self._poner(nodo)
        else:
            if self.pointer.rama_izq == None:
                self.pointer.rama_izq = nodo
                self.pointer = self.__heap
            else:
                self.pointer.rama_izq = self.pointer
                self._poner(nodo)
        

    def sacar(self, r):
        """
        """
        pass


    def vacio(self):
        """
            devuelve el estado
        """
        return not(self.__len__())


    def altura(self):
        """
            calcula la altura de del arbol
        """
        pass


    def imprime_arbol(self):
        """
            Pensando como implementar... pensando
        """
        pass


    def __len__(self):
        """
            sobrecarga del operador longitud, que permitira conocer
            externamente la cantidad de elementos de la Heap (Pila)
        """
        #return len(self.__heap)
        pass




