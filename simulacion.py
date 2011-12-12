#!/usr/bin/env python
# -*- coding: utf-8 -*-


import sys
from threading import Thread

#Version con hilos

class ObjetoSimulacion(Thread):
    """
        plantilla para crear sus propios obectos para la Simulacion
    """
    def __init__(self):
        self.p_memo_pila = None #puntero a la informacion de pila
        self.hora_desp = 0.0 #hora en que tiene que despertarse en caso de encontrarse en ESPERA
        self.cant_esp = 0
        self.estado = None      
    
    #def __eq__(obj_simulacion)
        
    def run(self):
        pass
        
        
    ciclo_de_vida = run
    
    #creo que no es necesario
    def congelar(self):
        return self
        
    #creo que no es necesario   
    def descongelar(self):
        return self
        

#despachador
class Simulacion:
    """
    En PSOO existen basicamente tres "colas" con las que se lleva el control
    de todo:
        - cola de objetos activos [PilaObjActivos]: es una cola LIFO , en 
        realidad una pila, de objetos (objetos que son hilos en nuestro caso)
        que estan listos para usar el cpu, estan esperando que les pase a
        la cola de objetos dormidos con esperar
        
        - cola de objetos suspendido [ConjObjSusp]: es una cola, un conjunto
        en realidad por lo que no hay un orden, donde se
        almacenan los hilos (en nuestro caso) que no podran usar el cpu
        hasta que se los ponga en estado activo. cuando esten en estado
        activo los hilos se sacan de esta cola y se pasa a las de objetos
        activos.
        
        - cola (heap) de objetos dormidos con esperar [HeapObjFut]: es un arbol ordenado
        se me hace que mantiene en orden los objetos que fueron dormidos
        con esperar(tiempo) y estan esperando que se acabe el tiempo para
        tomar el control del cpu, una vez que toman el control si no me
        equivoco salen del heap.   
    Hay que ver que colas implementar
    
    todo : COMPLETAR!
    """
    def __init__(self, objeto_director):
        """
        Despues de instanciar Simulacion la simulacion empezara a 
        ejecutarse.
        """
        #Falta revisar si los datos son dinamicos o no y crear el manejo de errores
        self.hora_actual = 0.0  #hora actual en el sistema
        self.mismo = None   #puntero al objecto que actualmente se encuetra corriendo
        #self.yo = None #replica de mismo
        #self.hora = 0.0    #replica de hora_act        
        #self.hora_actual = 0.0 #replica de hora_act
        """
        todas estas variables son necesarias si es que las estructuras de datos no son
        dinamicas, si son dinamicas no son necesarias.
        self.tam_min_cola_act = 0   #tamanio minimo de la pila de obj activos
        self.fac_amp_cola_act = 0.0 #factor de ampliacion de su vector dinamico
        
        self.tam_min_cola_susp = 0  #tamanio minimo de la pila de obj suspendidos
        self.fac_amp_cola_susp = 0.0    #factor de ampliacion de su vector dinamico
        
        self.tam_min_buff_corr = 0  #tamanio del vector de gestion dinamico expecializado
        self.fact_amp_gest_din = 0.0 #factor de ampliacion del del vector de gestion dinamico expecializado
        """
        #esta parte esta incompleta
        self.__obj_en_cpu = objeto_director #replica de mismo
        self.__director = objeto_director #puntero al objeto director
        self.__heap_obj_fut = extr_dat.Heap()   #cola deprioridades de objetos a futuro
        self.__conj_obj_susp = extr_dat.Conjunto()  #conjunto de objectos suspendidos
        self.__pila_obj_act = extr_dat.ColaLIFO()   #pila de obj activos que no estan en la CPU
        self._arrancar();
        self.__tope_monton = None 
        
    def _arrancar(self):
        """Ejecuta el ciclo de vida del objeto indicado por la variable ObjEnCPU
        que en nuestro caso es el hilo que esta siendo ejecutado y despues de 
        terminada la ejecucion busca el siguiente objeto a ser ejecutado.
        """
        self.__obj_en_cpu.cant_esp = 0
        self.__obj_en_cpu.estado = ACTIVO
        self.__obj_en_cpu.run()
        
        #quiero comparar si son los mismos punteros
        if ( self.__obj_en_cpu != self.__director ):
            #miro si no hay objetos activos
            if ( self.__pila_obj_act.tamanio() ):
                #y si el heap no esta vacio
                while not ( self.__heap_obj_fut.vacio() ):
                    self.__heap_obj_fut.sacar(nodo_futuro)
                    self.__obj_en_cpu = nodo_futuro.objeto
                    self.hora_actual = nodo_futuro.tiempo
                    #es evento no cancelado? wtf es cancelado si hora_desp == 0
                    if (self.hora_actual == self.__obj_en_cpu.hora_desp):
                        self.__obj_en_cpu.estado = ACTIVO
                        #aca debo hacer que __obj_en_cpu se pase a ejecutar saliendo de esta funcion
                        
                    self.__obj_en_cpu.cant_esp-=1
                    if (self.__obj_en_cpu == 0) and (self.__obj_en_cpu.estado == BORRADO):
                        self.__conj_obj_susp.sacar(self.__obj_en_cpu)
                        self.__obj_en_cpu.estado = BORRADO
                        #aca debo hacer que __obj_en_cpu se pase a ejecutar saliendo de esta funcion
                        
                raise Exception(E_FUTURO)
        else:
            self.__obj_en_cpu = self.__pila_obj_act.sacar
            #aca debo hacer que __obj_en_cpu se pase a ejecutar saliendo de esta funcion
                    
                
    
    
    def nuevo(self, obj_simulacion):
        """
        Cede el control al obj_sim dejando en estado de activo al objeto
        llamador de este mensaje. Lo que haces es que obj_sim pase a ejecutarse
        poniendo al objeto que llamo a esta funcion a esperar por el uso del cpu
        por lo que ObjetoSimulacion deberia ser un hilo.
         
        obj_sim debe ser del tipo ObjetoSimulacion
        """
        self.__pila_obj_act.poner = self.__obj_en_cpu
        self.__obj_en_cpu = obj_simulacion
        #no se si arrancar trabajara adecuadamente cuando sea llamado desde aca
        self._arrancar()
        
    
    def activar(self, obj_sim_act):
        """
        activar pone en estado de ACTIVO a obj_sim_act. Esto solo se puede 
        llevar a cabo si dicho objeto estaba previamente SUSPENDIDO. De 
        no cumplirse esto se emite el correspondiente mensaje de error y la
        simulacion se detiene. Que un objeto este activo significa que esta
        esperando por su turno para el uso del cpu, en definitiva este metodo
        no afecta al hilo que lo llama solo pone en estado activo al hilo
        representado por obj_sim_act.
        """
        pass 
        
        
    def esperar(self, tiempo):
        """
        el objeto (que es un hilo) llamador se "duerme" durante el tiempo "tiempo". Durante 
        esos momentos se encuentra desahabilitado para el uso de cpu y se deberia contar con
        una cola en la que se pongan estos objetos (el heap de objetos futuros en PSOO) a fin
        de controlar el paso del tiempo para que consumido el "tiempo" el hilo se despierte 
        y tome el control del cpu, 
        """
        
        pass
        
        
    def suspenderse(self):
        pass 
        
        
    def reanudar(self, obj_sim):
        pass 
        
        
    def borrarse(self):
        pass 
        
        
    def terminar(self):
        pass 
