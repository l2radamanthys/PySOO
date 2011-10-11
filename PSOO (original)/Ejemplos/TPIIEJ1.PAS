program tp2_pII_ej1;

uses simulacion,estr_dat,distribuciones;

type
    obj_cliente = object(ObjSim)

        h_llegada, h_servicio: real;

        constructor iniciar;
        procedure CicloDeVida; virtual;
        destructor  borrar;    virtual;

    end;

    p_cliente = ^obj_cliente;

    obj_director = object(ObjSim)

        constructor iniciar;
        procedure CicloDeVida; virtual;
        destructor  borrar;    virtual;

    end;

    p_director = ^obj_director;

var
    cliente, cliente_new : p_cliente;
    lambda, mu : real;
    cola : ObjFifo;
    t_servicio, t_espera, t_sistema, t_simulacion : real;
    clientes : longint;
    director : p_director;

constructor obj_cliente.iniciar;
begin 
h_llegada := 0;
h_servicio := 0;
end;

procedure obj_cliente.CicloDeVida;

begin
esperar(dExp(lambda));
nuevo(new(p_cliente,iniciar));
h_llegada := Hora;
if cola.vacia then cola.poner(yo)
else
    begin
    cola.poner(yo);
    suspenderse;
    end;

h_servicio := Hora;
esperar(dExp(mu));
t_servicio := t_servicio + (hora - h_servicio);
t_espera := t_espera + (h_servicio - h_llegada);
t_sistema := t_sistema + (hora-h_llegada);
inc(clientes);
cola.sacar;
if not cola.vacia then activar(cola.primero);
borrarse;
end;

destructor obj_cliente.borrar;
begin end;

constructor obj_director.iniciar;
begin end;

procedure obj_director.Ciclodevida;
begin
writeln('director inicia');
nuevo(new(p_cliente,iniciar));
esperar(t_simulacion);
write('T servicio = ',t_servicio/clientes:7:3);
writeln(' Tiempo de sistema = ',t_sistema/clientes:7:3);
end;

destructor obj_director.borrar;
begin end;

Begin
randomize;
writeln('Inicio Simulacion');
t_servicio := 0;
t_sistema := 0;
t_espera := 0;
clientes := 0;
cola.inic;
t_simulacion := 10000;
lambda := 10;
mu := 11.5;
IniciarSim(new(p_director,iniciar));
readln;
End.
