#!/usr/bin/env python
# -*- coding: utf-8 -*-


from threading import *


class Semaforo(Semaphore):
    """
        Solo es un Wraper osea una cobertura, para tener coincidencia con
        los nombres de metodos
    """
    def __init__(self, band=0):
        Semaphore.__init__(self, band)

    esperar = adquire

    continuar = release










    


        
