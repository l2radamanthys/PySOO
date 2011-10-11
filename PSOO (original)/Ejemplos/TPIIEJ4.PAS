program tp2_pII_ej4;

uses simulacion,estr_dat,distribuciones;

type
    obj_cliente = object(ObjSim)

        h_llegada, h_servicio, t_d_servicio: real;
        interrumpido : boolean;

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
    cliente : p_cliente;
    lambda, mu : real;
    cola : Objfifo;
    conjunto_en_serv : ObjConj;
    t_servicio, t_espera, t_sistema, t_simulacion : real;
    clientes, cant_servidores, servidores_ocup : longint;
    director : p_director;

constructor obj_cliente.iniciar;
begin
t_d_servicio := dexp(mu);
h_llegada := 0;
h_servicio := 0;
end;

procedure obj_cliente.CicloDeVida;

begin
esperar(dExp(lambda));
nuevo(new(p_cliente,iniciar));
h_llegada := Hora;
if conjunto_en_serv.vacia or (conjunto_en_serv.cantelem < cant_servidores) then
	begin
	conjunto_en_serv.poner(yo);
	end
else
    begin
    cola.poner(yo);
	suspenderse;
	cola.sacar;
	conjunto_en_serv.poner(yo);
	if conjunto_en_serv.cantelem > cant_servidores then writeln('SERV', conjunto_en_serv.cantelem);
	end;
h_servicio := Hora;
{writeln('tam ser ',conjunto_en_serv.cantelem);}
esperar(t_d_servicio);
conjunto_en_serv.sacar(yo);
if conjunto_en_serv.cantelem > cant_servidores then writeln('SERV', conjunto_en_serv.cantelem);
inc(clientes);
t_servicio := t_servicio + (hora - h_servicio);
t_espera := t_espera + (h_servicio - h_llegada);
t_sistema := t_sistema + (hora-h_llegada);
{writeln('tam cola', cola.cantelem);}
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
write('Tserv = ', t_servicio/clientes:7:3, ' ');
write(' Tesp = ', t_espera/clientes:7:3, ' ');
write(' cola_prom = ', t_sistema/t_simulacion:7:3, ' ');
writeln(' T_sistema = ',t_sistema/clientes:7:2);

end;

destructor obj_director.borrar;
begin end;

Begin
randomize;
writeln('Inicio Simulacion');
cant_servidores := 4;
servidores_ocup := 0;
t_servicio := 0;
t_sistema := 0;
t_espera := 0;
clientes := 0;
cola.inic;
conjunto_en_serv.inic;
t_simulacion := 10000;
lambda := 3.2;
mu := 1.25;
IniciarSim(new(p_director,iniciar));
readln;
End.
