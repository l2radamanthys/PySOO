#!/usr/bin/env python
# -*- coding: utf-8 -*-


import sys


class ObjectoSimulacion:
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
		
		
	def iniciar(self, obj_direc):
		pass
	
	
	def nuevo(self, obj_sim):
		"""
		"""
		pass
		
	
	def activar(self, obj_sim_act):
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
