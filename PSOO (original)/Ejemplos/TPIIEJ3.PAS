program tp2_pII_ej3;

uses simulacion,estr_dat,distribuciones;

type
    obj_cliente = object(ObjSim)

        h_llegada, h_servicio, h_interrupcion, t_d_servicio: real;
        interrumpido, termine_t_servicio : boolean;
        obj_c : integer;

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
    cliente, cliente_new, cliente_en_servicio : p_cliente;
    lambda, mu : real;
    cola : ObjLifo;
    t_servicio, t_espera, t_sistema, t_simulacion, t_espera_interrupcion : real;
    clientes, obj, clientes_interrumpidos : longint;
    director : p_director;

constructor obj_cliente.iniciar;
begin 
t_d_servicio := dexp(mu);
h_llegada := 0;
h_servicio := 0;
interrumpido := false;
termine_t_servicio := false;
inc(obj);
obj_c := obj;
end;

procedure obj_cliente.CicloDeVida;

begin
esperar(dExp(lambda));
nuevo(new(p_cliente,iniciar));
h_llegada := Hora;
if cola.vacia then cola.poner(yo)
else
    begin
    cliente_en_servicio := cola.primero;
    if t_d_servicio < cliente_en_servicio^.t_d_servicio then
		begin
{
		write(obj_c,' interrumpo a ',cliente_en_servicio^.obj_c, ' ');
}
		cliente_en_servicio^.t_d_servicio := cliente_en_servicio^.horadesp - horaact;
		cliente_en_servicio^.h_interrupcion := horaact;
		cliente_en_servicio^.interrumpido := true;
		inc(clientes_interrumpidos);
{
		if (cliente_en_servicio^.estado = esp) then write(' esper ', clientes, ' coa ',cola.cantelem)
                else write(' otro ', clientes, ' coa ',cola.cantelem);
}
		activar(cliente_en_servicio);
		
{
		writeln(' fin int');
}
		cola.poner(yo);
		end
	else 
		begin
{
		writeln(obj_c, ' no int');
}
		cola.sacar;
		cola.poner(yo);
		cola.poner(cliente_en_servicio);
		suspenderse;
		end
    end;
h_servicio := Hora;
while not termine_t_servicio do
	begin
{
	writeln(obj_c,' tomando serv cola = ', cola.cantelem, 'clientes ', clientes );
}
	termine_t_servicio := esperar(t_d_servicio);
	if not termine_t_servicio then suspenderse;
	if interrumpido then
		begin
		t_espera_interrupcion := t_espera_interrupcion + (horaact -h_interrupcion);
        interrumpido := false;
        end;
{
	writeln(obj_c, ' estado', termine_t_servicio);
}
	end;
inc(clientes);
t_servicio := t_servicio + t_d_servicio;
t_espera := t_espera + (h_servicio - h_llegada);
t_sistema := t_sistema + (hora-h_llegada);
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
write('Tservicio = ', t_servicio/clientes:7:3, ' ');
write(' Tinterrup = ', t_espera_interrupcion/clientes_interrumpidos:7:3, ' ');
writeln(' Tiempo__en_sistema = ',t_sistema/clientes:7:2);
end;

destructor obj_director.borrar;
begin end;

Begin
randomize;
writeln('Inicio Simulacion');
obj := 0;
t_servicio := 0;
t_sistema := 0;
t_espera := 0;
t_espera_interrupcion := 0;
clientes := 0;
clientes_interrumpidos := 0;
cola.inic;
t_simulacion := 50000;
lambda := 0.8;
mu := 1.3;
IniciarSim(new(p_director,iniciar));
readln;
End.
