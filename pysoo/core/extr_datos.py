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
        return self.__elementos.pop(0)


    def cabeza(self):
        return self.__elementos[0]
    
    primero = cabeza

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
        index = self.__elementos.index(obj)
        element = self.__elementos.pop(index)
        return element


    def sacar_ultimo(self):
        return sacar()

    def vacio(self):
        return len(self) == 0


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
        self.data = obj  #apuntador a un objeto
        #el peso de los nodos se define por la variable tiempo
        #si esta mal corregirlo :D
        self.value = t

        #ramas
        self.rama_izq = None
        self.rama_der = None
    

    #sobrecarga de operadores
    def __eq__(self, nodo):
        return (self.value == nodo.value)
            

    def __neq__(self, nodo):
        return (self.value != nodo.value)
        
    def __lt__(self, node):
        return (self.value < node.value)
        

class Heap:
    """
        Es un min-heap (la raiz es el nodo de menor valor) que es por lo general
        un arbol binario completo, se implemente con un array que es teoricamente
        la forma mas simple de implementar un heap. 

            (A)
           /   \ 
         (B)   (C)
        /   \     \

    """
    def __init__(self):
        self.__heap = []
        #NodoHeap(t=-1e37) #nodo raiz
        self.pointer = self.__heap #apuntador generico
        self.last = -1

    def poner(self, r=0, datos=None):
        """
            A partir de los datos pasados crea un Nodo y lo inserta
            en el ABB
        """
        root_node = 0
        node = NodoHeap(datos, r)
        self.pointer = self.__heap
        if self.vacio():
            self.__heap.append(node)
            self.last += 1
        else:
            self.last += 1
            self.__heap.append(NodoHeap()) #agrego un elemento temporal
            expl_node = self.last #posicion del elemento temporal
            root_node = (expl_node - 1) // 2 #posicion padre de temporal
            while (node.value < self.__heap[root_node].value) and (root_node > -1):
                self.__heap[expl_node] = self.__heap[root_node]
                expl_node = root_node
                root_node = (root_node - 1) // 2
            self.__heap[expl_node] = node
            
        #self._poner(nodo)
    
    
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
        

    def sacar(self):
        """
            Saca la raiz del heap y lo devuelve 
        """
        #necesita una mejor implementación
        if self.vacio(): raise Exception('El Heap esta vacio, no se puede sacar')
        if self.last == 0:
            self.last -= 1
            return self.__heap.pop()
        if self.last == 1:
            self.last -= 1
            return self.__heap.pop(0)
        return_node = self.__heap[0]
        self.__heap[0] = self.__heap[self.last]
        self.__heap.pop()
        self.last -=1
        if self.last == 1:
            if self.__heap[0] > self.__heap[1]:
                aux = self.__heap[0]
                self.__heap[0] = self.__heap[1]
                self.__heap[1] = aux
            return return_node
        expl_node = 0
        left_node = (expl_node * 2) + 1 #right_node = left_node + 1
        aux = -2
        while left_node < self.last:
            if self.__heap[left_node].value < self.__heap[left_node+1].value:
                if self.__heap[left_node].value < self.__heap[expl_node].value:
                    aux = self.__heap[expl_node]
                    self.__heap[expl_node] = self.__heap[left_node]
                    self.__heap[left_node] = aux
                    expl_node = left_node
                else: return return_node
            else:
                if self.__heap[left_node+1].value < self.__heap[expl_node].value:
                    aux = self.__heap[expl_node]
                    self.__heap[expl_node] = self.__heap[left_node+1]
                    self.__heap[left_node+1] = aux
                    expl_node = left_node + 1
                else: return return_node
            left_node = (expl_node * 2) + 1
        #if expl_node == 0: return return_node
        parent_node = (self.last-1) // 2
        if self.__heap[self.last] < self.__heap[parent_node]:
            aux = self.__heap[self.last]
            self.__heap[self.last] = self.__heap[parent_node]
            self.__heap[parent_node] = aux
        return return_node 


    def vacio(self):
        """
            devuelve el estado
        """
        return self.last == -1


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
        return last
        pass




