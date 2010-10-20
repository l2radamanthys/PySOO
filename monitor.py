#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Promedio:
	"""
	 Observa un evento y calcula a partir de los datos que se le 
	 suministra, el promedio de los mismos.
	"""
	#procedure inic; constructor para pascal :P
	def __init__(self, mensaje_promedio):
		self.__acumulador = 0.0 #Acumulador de datos en general reales
		self.__contador = 0 #Cantidad de datos acumulados
		self.__mensaje_promedio = mensaje_promedio #Mensaje que se mostrara para aclarar de que se tomo el promedio 
		
	#extraños nombres los que elegia este pibe, nunca un setMensaje
	#una duda seria set_mensaje o setMensaje, error era otro constructor :P
	#procedure iniciar(titulo:letrero);
	def iniciar(self, mensaje):
		"""Setea el mensaje que se mostrara el """
		self.__mensaje = mensaje
		
	#procedure acumular(dato:real);
	def acumular(self, dato):
		self.__acumulador += dato
		self.__contador += 1
		
	#procedure MostrarEstd;
	def mostrarEstd(self):
		print self.__mensaje, ' ', self.resul()
	
	#function  resul:real;
	def resul(self):
		return self.__acumulador/self.__contador

 #hay algo mal aca la descripcion de la clase esta mal, o mas bien la
 #implementacion esta mal, en vez de calcular varianza y desvio calcula
 #varianza y promedio, corrigiendo!!!  
class Desvios:
	"""
	Observa un evento y calcula a partir de los datos que se le 
	suministra, el desv¡o y la varianza de los mismos.
	"""
	def __init__(self, msj_desvio, msj_varianza):
		self.__muestra = [] #datos sobre los cuales se calcula el desvio y la varianza
		self.__contador = 0 #cuanta la cantidad de datos de muestra, quiza al pedo
		self.__mensaje_desvio = msj_desvio   #menasaje para el desvio
		self.__mensaje_varianza = msj_varianza #mensaje para la varianza
	

	#procedure iniciar(titulo1,titulo2:letrero);
    #se mantiene por compatibilidad
	def iniciar(self, mensaje_desvio, mensaje_varianza):
        self.__mensaje_desvio = mensaje_desvio  
		self.__mensaje_varianza = mensaje_varianza 
		
	#procedure acumular(dato:real);
	def acumular(self, dato):
        self.__muestra.append(dato)
        self.__contador +=1
        
		 
		
	#procedure MostrarEstd;
	def mostrarEstd(self):
		pass 
	
		
class Datos:
	"""
	observa un evento y calcula a partir de los datos que se le 
	suministra, el promedio, desv¡o y varianza de los mismos.
	"""
	def __init__(self):
		self.__muestra = [] #datos sobre los cuales se calcula el desvio y la varianza
		self.__contador = 0 #cuanta la cantidad de datos de muestra, quiza al pedo
		self.__mensaje_desvio = ''   #menasaje para el desvio
		self.__mensaje_varianza = '' #mensaje para la varianza
		self.__mensaje_promedio = '' #para el promedio
		
	
	#procedure iniciar(titulo1,titulo2,titulo3:letrero);
	def iniciar(self, mensaje_desvio, mensaje_varianza, mensaje_promedio):
		pass 
		
	#procedure acumular(dato:real);
	def acumular(self, dato):
		pass 
		
	#procedure MostrarEstd;
	def mostrarEstd(self):
		pass 


