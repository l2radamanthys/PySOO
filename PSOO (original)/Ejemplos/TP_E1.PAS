program tp2_pII_ej1;

uses crt,simulacion,estr_dat,distribuciones;

type
    obj_cliente = object(ObjSim)

        h_llegada, h_servicio: real;
        procedure CicloDeVida; virtual;

    end;

    p_cliente = ^obj_cliente;

    obj_director = object(ObjSim)

        procedure CicloDeVida; virtual;

    end;

    p_director = ^obj_director;

var
    cliente, cliente_new : p_cliente;
    lambda, mu : real;
    cola : ObjFifo;
    t_servicio, t_espera, t_sistema, t_simulacion : real;
    clientes : integer;
    director : p_director;

procedure obj_cliente.CicloDeVida;
var
   cliente1 : p_cliente;
begin
esperar(dExp(lambda));
h_llegada := HoraAct;
new(cliente1);
nuevo(cliente1);
if cola.vacia then cola.poner(yo)
else
    begin
    cola.poner(yo);
    suspenderse;
    end;

h_servicio := Hora;
esperar(dExp(mu));
t_servicio := t_servicio + (hora - h_servicio);
t_espera := t_espera + (h_llegada - h_servicio);
t_sistema := t_sistema + t_servicio + t_espera;
cola.sacar;
if not cola.vacia then activar(cola.primero);
borrarse;
end;

procedure obj_director.Ciclodevida;
begin
t_servicio := 0;
t_sistema := 0;
t_espera := 0;
clientes := 0;
cola.iniciar(500,2);
new(cliente);
nuevo(cliente);
esperar(t_simulacion);
writeln('Tiempo de sistema',t_sistema/clientes:7:3);
end;

Begin
writeln('ratas');
t_simulacion := 1000000;
new(director);
IniciarS(director);

End.