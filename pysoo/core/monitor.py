#!/usr/bin/env python
# -*- coding: utf-8 -*-

import math
#Creo que podriamos cambiar la forma en que se muestran los datos, por
#ahora lo dejo asi.
class Promedio:
	"""
		Observa un evento y calcula a partir de los datos que se le 
		suministra, el promedio de los mismos.
	"""
	#procedure inic; "constructor" para pascal :P
	def __init__(self, mensaje_promedio = 'El promedio'):
		self.__acumulador = 0.0 #Acumulador de datos en general reales
		self.__contador = 0 #Cantidad de datos acumulados
		self.__mensaje_promedio = mensaje_promedio #Mensaje que se mostrara para aclarar de que se tomo el promedio 
		
	#extraños nombres los que elegia este pibe, nunca un setMensaje
	#una duda seria set_mensaje o setMensaje, error era otro constructor :P
	#procedure iniciar(titulo:letrero); mantenido por compatibilidad
	def iniciar(self, mensaje):
		"""
			Setea el mensaje que se mostrara el 
		"""
		self.__mensaje = mensaje
		
	#procedure acumular(dato:real);
	def acumular(self, dato):
		self.__acumulador += dato
		self.__contador += 1
		
	#procedure MostrarEstd;
	def mostrarEstd(self):
		"""
			Imprime el promedio por pantalla
		"""
		print self.__mensaje, ' ', self.resul()
	
	#function  resul:real;
	def resul(self):
		"""
			Devuelve el promedio sobre los datos acumulados
		"""
		return self.__acumulador/self.__contador
		
	def get_contador(self):
		"""
			Devuelve la cantidad de datos acumulados/observados
		"""
		return self.__contador

 
class Desvios(Promedio):
	"""
		Observa un evento y calcula a partir de los datos que se le 
		suministra, el desv¡o y la varianza de los mismos. Hereda de
		Promedio
	"""
	def __init__(self, msj_desvio = 'El desvio', msj_varianza = 'La varianza'):
		Promedio.__init__(self, 'El promedio')
		self.__muestra = [] #datos sobre los cuales se calcula el desvio y la varianza
		self.__mensaje_desvio = msj_desvio   #menasaje para el desvio
		self.__mensaje_varianza = msj_varianza #mensaje para la varianza
	

	#procedure iniciar(titulo1,titulo2:letrero);
	#se mantiene por compatibilidad
	def iniciar(self, mensaje_desvio, mensaje_varianza):
		self.__mensaje_desvio = mensaje_desvio  
		self.__mensaje_varianza = mensaje_varianza 
	
	
	#procedure acumular(dato:real);
	def acumular(self, dato):
		Promedio.acumular(self, dato)
		self.__muestra.append(dato)
	
	#si no hay datas deveria saltar error, pero en ves de eso estoy splo
	#tirando un mensaje, lei uno de tus comentarios que decia que no 
	#implementabamos errores todabia, o sera suficiente con un mensajillo creo que no
	#IMPORTANTE si hay error devuelve 0 lo que puede confundir pues la varianza puede ser 0	
	def varianza(self):
		"""
			Calcula la varianza sobre los datos que se fueron acumulando en
			el mismo objeto, si no hay datos devuelve error
		"""
		if (self.get_contador() == 0):
			print "Error, no hay datos para calcular la varianza"
			return 0 #me molesta que por aca devuelva 0, la varianza puede ser 0
		media = self.resul()
		varianza = 0
		for valor in self.__muestra:
			varianza += math.pow(valor - media, 2)
		varianza = varianza/( self.get_contador() - 1 )
		return varianza
	
	
	# lo mismo que para varianza
	def desvio(self):
		"""
			Calcula el devio sobre los datos que se fueron acumulando en
			el objeto, si no hay datos devuelve error
		"""
		if (self.get_contador() == 0):
			print "Error, no hay datos para calcular el desvio"
			return 0
		varianza = self.varianza()
		return math.sqrt(varianza)
		
	#procedure MostrarEstd;
	def mostrarEstd(self):
		"""
			Muestra el desvio y la varianza acompañados de sus correspondientes
			mensajes
		"""
		print self.__mensaje_desvio, ' ', self.desvio()
		print self.__mensaje_varianza, ' ', self.varianza() 
	
#Esta clase es lo mismo que Desvios (medio rebuscado eh) solo que esta 
#muestra encima el promedio, eso lo podria hacer tranquilamente Desvios,
#pero buehhh, herede de promedio para sacar el promedio "al vuelo" y no 
#calcularlo despues de tener todos los datos supongo que sera un pelin 
#mas rapido, mas con grandes cantidades de datos		
class Datos(Desvios):
	"""
		observa un evento y calcula a partir de los datos que se le 
		suministra, el promedio, desv¡o y varianza de los mismos.
	"""
	def __init__(self, msj_promedio = 'El promedio', msj_desvio = 'El desvio', msj_varianza = 'La varianza'):
		Desvios.__init__(self, msj_desvio, msj_varianza)
		self.__mensaje_promedio = msj_promedio #mensaje para el promedio
		
	
	#procedure iniciar(titulo1,titulo2,titulo3:letrero);
	def iniciar(self, mensaje_desvio, mensaje_varianza, mensaje_promedio):
		Desvios.iniciar(self, mensaje_desvio, mensaje_varianza)
		self.__mensaje_promedio = mensaje_promedio 
		
	#procedure acumular(dato:real);
	def acumular(self, dato):
		Desvios.acumular(self, dato) 
		
	#procedure MostrarEstd;
	def mostrarEstd(self):
		print self.__mensaje_promedio, ' ', self.resul()
		Desvios.mostrarEstd(self)
		
