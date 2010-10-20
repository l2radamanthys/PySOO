#!/usr/bin/env python
# -*- coding: utf-8 -*-

#Esta clase simula semáforos usando los métodos de simulación, hay algo 
#que me esta molestando, no estoy seguro de como implementar si uso
#Lock deberíamos estar usando hilos para la simulación, voy a tener que
#echarle un buen vistazo a Simulación para implementar esto. Creo que tenemos
#que terminar primero Simulación 
class Semaforo:
    """
        clase que ofrece los mecanismos de un semáforo de prioridad FIFO.
    """
    def __init__(self):
        self.__rojo = false #si verdad indica que el semáforo está ocupado
        self.__cola_espera = ColaFIFO()  #colección de objetos en espera de la señal "verde"

    #procedure iniciar(TamMinColaEsp:word; FactorAmpl:real);
    #creo que no hace falta implementar, ColaFIFO es completamente dinámico
    def iniciar(self, tamanio_minimo_cola, factor_amp):
        pass 
    
    #procedure inic; es init
    
    #function  esperar(Obj:pointer):boolean;
    def esperar(self, objeto):
        pass
    
    #procedure continuar;
    def continuar(self):
        pass 
    
    #procedure borrar;
    def borrar(self):
        pass 
        
#SemaforoN debería heredar de Semáforo
class SemaforoN:
    """
        clase que ofrece los mecanismos de un semáforo de prioridad
        FIFO de capacidad N
    """
    """
    elemLibres:longint;    { cant. de elementos libres }
    ColaEspera:ObjFIFO;  { colecci¢n de objetos en espera de la se¤al "verde"}

    procedure iniciar(n:longint; TamMinColaEsp:word; FactorAmpl:real);
    procedure inic(n:longint);
    function  esperar(Obj:pointer):boolean;
    procedure continuar;
    procedure borrar;
    """
