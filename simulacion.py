#!/usr/bin/env python
# -*- coding: utf-8 -*-


import sys

#Version con hilos

class ObjetoSimulacion:
	"""
		plantilla para crear sus propios objectos para la Simulacion
	"""
	def __init__(self):
		self.p_memo_pila = None #puntero a la informacion de pila
		self.hora_desp = 0.0 #hora en que tiene que despertarse
		self.cant_esp = 0
		self.estado = None		
	
	
	def run(self):
		pass
		
		
	ciclo_de_vida = run
	
	
	def congelar(self):
		return self
		
		
	def descongelar(self):
		return self
		

#despachador
class Simulacion:
	def __init__(self):
		self.hora_act = 0.0	#hora actual en el sistema
		self.mismo = None	#puntero al objecto que actualmente se encuetra corriendo
		#self.yo = None	#replica de mismo
		#self.hora = 0.0	#replica de hora_act		
		#self.hora_actual = 0.0	#replica de hora_act
		
		self.tam_min_cola_act = 0	#tamanio minimo de la pila de obj activos
		self.fac_amp_cola_act = 0.0	#factor de ampliacion de su vector dinamico
		
		self.tam_min_cola_susp = 0	#tamanio minimo de la pila de obj suspendidos
		self.fac_amp_cola_susp = 0.0	#factor de ampliacion de su vector dinamico
		
		self.tam_min_buff_corr = 0	#tamanio del vector de gestion dinamico expecializado
		self.fact_amp_gest_din = 0.0 #factor de ampliacion del del vector de gestion dinamico expecializado
		
		#esta parte esta incompleta
		self.__obj_en_cpu = None #replica de mismo
		self.__director = None #objecto director
		self.__heap_obj_fut = extr_dat.Heap()	#cola de objectos a futuro
		self.__conj_obj_susp = extr_dat.Conjunto()	#conjunto de objectos suspendidos
		self.__pila_obj_act = extr_dat.ColaLIFO()	#pila de obj activos que no estan en la CPU
		
		self.__tope_monton = None
		
		
	def iniciar(self, obj_director):
		"""
		ESTO DEBE SER BORRADO
		var
  i:word;
  hora:real;
  obj:PtrObjSim;
  p:pointer;
  begin
  HeapError:=@ErrorMemoLlena;   { tomar el control de errores de des-  }
								{ bordamiento del HEAP de TP6.		 }

  IniciarCorrutinas(Sptr-1,TamMinBuffCorr,FacAmplGestDin);{ iniciar el }
	 { gestor de corrutinas poniendo la base de la pila desde la rutina}
	 { "arrancar" y especificando un cierto tama¤o m¡nimo para el ///  }
	 { buffer del manejador de corrutinas.							 }

  HoraAct:=0;			{ hora actual en el sistema igual a cero.	 }

  HeapObjFut.Iniciar;	{ inicializo el heap de objetos activos.	  }

  ConjObjSusp.iniciar(TamMinConjSusp,FacAmplConjSusp); { inicializo el }
										   { conjunto de objetos sus-  }
										   { pendidos.				 }

  PilaObjActivos.Iniciar(TamMinColaAct,FacAmplColaAct);   { inicializo }
										   { la pila de objetos activos}

  ObjEnCPU:=direc;	   { el objeto en CPU  es el "director"				}
  director:=direc;	   { director = puntero al objeto "director".		  }
  arrancar;			  { arranca el objeto en CPU (en este caso el direc.) }
#heap error creo que no debe ser tenido en cuenta puesto que no creo que tengamos
que lidiar con errores de desbordamiento
  HeapError:=nil;		{ restaura el gestor de errores de desbordamiento   }
						 { del HEAP de Trbo Pascal V6.0.					 }
end;
		"""
		"""
		Inicializa la simulación
		
		Incompleto
		"""
		self.hora_act = 0.0 #creo que no es necesario hacerlo de nuevo
		self.__dirctor = obj_director # es el director el que inicia las simulaciones
									  # ademas debe ser el primero en ejecutarse
		self.arrancar()
		
		pass
	
	
	def nuevo(self, obj_sim):
		"""
		Cede el control al obj_sim dejando en estado de activo al objeto
		llamador de este mensaje. Lo que haces es que obj_sim pase a ejecutarse
		poniendo al objeto que llamo a esta funcion a esperar por el uso del cpu
		por lo que ObjetoSimulacion deberia ser un hilo.
		 
		obj_sim debe ser del tipo ObjetoSimulacion
		"""
		pass
		
	
	def activar(self, obj_sim_act):
		"""
		activar pone en estado de ACTIVO a obj_sim_act. Esto solo se puede 
        llevar a cabo si dicho objeto estaba previamente SUSPENDIDO. De 
        no cumplirse esto se emite el correspondiente mensaje de error y la
        simulacion se detiene.
		"""
		pass 
		
		
	def esperar(self, tiempo):
		pass
		
		
	def suspenderse(self):
		pass 
		
		
	def reanudar(self, obj_sim):
		pass 
		
		
	def borrarse(self):
		pass 
		
		
	def terminar(self):
		pass 
