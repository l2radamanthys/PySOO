==========
Simulación
==========

Objetivo
========
Lo que se debe hacer es controlar como se ejecutan los hilos que se van creando, solo uno de los hilos se debe ejecutar a la vez en ese sentido se pierde la gracio de los hilos con la multitarea, pero se precisa de hilos puesto que necesitamos hacer que la ejecución de el hilo sea interrumpida (como poner un GOTO) para darle paso a la ejecucion a otro hilo pero siempre bajo la supervicion de una clase(?) conductora. Lo primero que se viene a la mente es utilizar un 


Propuestas
==========

1. La primera posible solución es que cada objeto posea un cerrojo (mutex, o Lock) que sera controlado por la clase directora, pero el problema en este caso es que se logra exclusion entre el director y el activo, pero no se logra excluion entre los activos, debido a esto no sirve la solución. 