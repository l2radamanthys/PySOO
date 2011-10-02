===============
Guia de Trabajo
===============    

Tabla de estados
----------------

La migración se lleva a cabo fichero a fichero, en la siguiente tabla podemos
ver como se lleva a cabo:

============  ==============  ===============  ===============  =============
Original      Final           Dificultad       Asignado a       Estado avance 
============  ==============  ===============  ===============  =============
SIMULACI.PAS  simulacion.py   medio-avanzado   nerones (open)   inicial
                              manejo de hilos 
CORRUT.PAS    [1]             n/a              n/a              n/a
CRONO.PAS     crono.py        basico           nadie            avanzado
DISTRIBU.PAS  distrib.py      basico           nadie            avanzado
ESTR_DAT.PAS  extr_dat.py     medio            nadie            medio
GESTDIN.PAS   [1]             n/a              n/a              n/a
GRAFICOS.PAS  [1]             n/a              n/a              n/a
MONITOR.PAS   monitor.py      basico           nadie            inicial
SEMAFORO.PAS  semaforo.py     medio, manejo    nadie            inicial
                              de hilos
n/a           constantes.py   basico           nadie(global*)   inicial
============  ==============  ===============  ===============  =============

Leyendas:

[1]
    No es necesario implementar por el modo en el que se esta trabajando
    ahora.
n/a
    siginifica que no se puede especificar, por ej no existe o no se puede
    asignar.
global*
    quiere decir que no necesariamente se tiene que asignar a alguien, es
    una clase que agrupa constantes.

niveles de avance
    1. inicial
    2. medio
    3. avanzado
    4. terminado -> como para empezar a usarlo

niveles de dificultad
    1. basico
    2. medio
    3. medio-avanzado
    4. avanzado

Como hacer
----------
Si queres revisar uno de los ficheros marcate como asignado para esa clase
y se puede ir modificando el estado de avance.
