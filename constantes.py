#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
	Este modulo no pertenece a la libreria original pero sera usado
	para agrupar todas las posibles constantes q sean necesarias
"""


__version__ =  "Alpha"
__desarrolladores__ = """ 
Ricardo Daniel Quiroga - L2Radamanthys - l2radamanthys@gmail.com
Nelson E. Cruz - @gmail.com
"""
__web__ = "http://"


#estados
SUSPENDIDO = 0
ACTIVO = 1
ESPERANDO = 2
BORRADO = 3


#constantes q definen los diferentes mensajes de error por el momento
#no se implementara ninguna clase directa para el manejo de excepciones
E_FUTURO = "Error - No existen objectos para activar en el Futuro"
E_ACTIVAR = "Error - No se puede ACTIVAR el Objecto"
E_REANUDAR = "Error - No se puede REANUDAR el Objecto"
E_CANCELAR = "Error - No se puede CANCELAR el Objecto"
