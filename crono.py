#!/usr/bin/env python
# -*- coding: utf-8 -*-


import time


class Cronometro:
	"""
		Clase que encapsula el cronometro del paquete de simulacion
		PSOO para medir el tiempo transcurrido entre 2 eventos
		
		Ejemplo de Uso:
			crono =  Cronometro()
			crono.iniciar()
			#...evento
			crono.detener() # o crono.parar()
			#obtener datos
			ini,fin,tot = crono.obtener_datos()
			...
	"""
	def __init__(self):
		self.__inicio = 0.0
		self.__parada = 0.0
		self.__estado = False
	
	
	def resetear(self):
		"""
			pone a 0 el cronometro
		"""
		self.__inicio = 0.0
		self.__parada = 0.0
		self.__estado = False
	
	
	def reiniciar(self):
		"""
			reinicia el cronometro
		"""
		self.resetear()
		self.iniciar()
		
		
	def iniciar(self):
		"""
			inicia el cronometro
		"""
		if not(self.__estado):
			self.__estado = True
			self.__inicio = time.time()
		else:
			print "Error - el cronometro ya fue iniciado"
			
		
	def detener(self):
		"""
			detiene el cronometro, a diferencia de la version original
			este metodo no muestra los datos por pantalla, para obtener
			los datos usar el metodo obtener_datos()
		"""
		if not(self.__estado):
			self.__estado = False
			self.__parada = time.time()
		else:
			print "Error - el cronometro esta detenido o no fue iniciado"
		
	
	#para mantener compatibilidad con el archivo original
	parar = detener


	def obtener_datos(self):
		"""
			devuelve una tupla con los siguientes valores
				- inicio
				- parada
				- duracion
				
			
		""" 
		return self.__inicio, self.__parada, (self.__parada - self.__inicio)
	
