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
    lambda, mu, alpha : real;
    cola : ObjFifo;
    t_servicio, t_espera, t_sistema, t_simulacion, t_sistema_total : real;
    i, clientes, clientes_abandona : longint;
    director : p_director;
    se_fue : boolean;

constructor obj_cliente.iniciar;
begin
h_llegada := 0;
h_servicio := 0;
end;

destructor obj_cliente.borrar;
begin end;

procedure obj_cliente.CicloDeVida;

begin
esperar(dExp(lambda));
nuevo(new(p_cliente,iniciar));
h_llegada := Hora;
if cola.vacia then cola.poner(yo)
else
    begin
    cola.poner(yo);
    if esperar(dExp(alpha)) then
		begin
		inc(clientes_abandona);
		se_fue := true;
		t_sistema_total := t_sistema_total + (hora - h_llegada);
		end;
    suspenderse;
    end;
if not se_fue then
	begin
	esperar(dExp(mu));
	{Solo voy a considerara para tiempo en el sistema el t de los}
	{clientes atendidos}
	t_sistema := t_sistema + (hora - h_llegada);
	t_sistema_total := t_sistema_total + (hora - h_llegada);
	inc(clientes);
	end;


{h_servicio := Hora;
esperar(dExp(mu));
t_servicio := t_servicio + (hora - h_servicio);
t_espera := t_espera + (h_servicio - h_llegada);
t_sistema := t_sistema + (hora-h_llegada);}
cola.sacar;
if not cola.vacia then activar(cola.primero);
cliente_new := yo;
dispose(cliente_new,borrar);
end;

constructor obj_director.iniciar;
begin end;

procedure obj_director.Ciclodevida;
begin
nuevo(new(p_cliente,iniciar));
esperar(t_simulacion);
write('Tsistema',t_sistema/(clientes):7:3, ' ');
write('Tsistema de todos',t_sistema_total/(clientes+clientes_abandona):7:3, ' ');
writeln('Popque abandonan', clientes_abandona/(clientes+clientes_abandona):7:3);
end;

destructor obj_director.borrar;
begin end;

Begin
randomize;
tammincolaact := 100;
tamminbuffcorr := 10000;
writeln('Inicio Simulacion');
t_servicio := 0;
t_sistema := 0;
t_espera := 0;
clientes := 0;
cola.inic;
t_simulacion := 10000;
lambda := 3;
mu := 3.2;
alpha := 1;
IniciarSim(new(p_director,iniciar));
borrarse;
readln;
End.
