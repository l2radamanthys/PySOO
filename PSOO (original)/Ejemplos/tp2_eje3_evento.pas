program rotiseria;
(*programa que calcula tiempos promedios en base a tirar una moneda y simular en intervalos fijos de tiempo *)

uses crt, DISTRIBUCIONES;

type
	tipo_estado = record
		hora: real;
		cola: longint;
		proxima_llegada: real;
		proxima_salida: real;
		end;
		
var
	cola_previa, clientes, t_simulacion, tiempo_simulacion : longint;
	t_total, t_ocioso, t_espera : real;
	i:byte;
	delta_tiempo, lambda, mu, hora_previa : real;
	estado : tipo_estado;
	
procedure avanzar(var estado:tipo_estado);
begin
	{if estado.cola = 0 then
		begin
		estado.hora := estado.proxima_llegada;
		estado.cola := 1;
		estado.proxima_llegada := estado.hora + dExp(lambda);
		estado.proxima_salida := estado.hora + dExp(mu);
		end
	else
		begin}
		if estado.proxima_llegada < estado.proxima_salida then
			begin
			inc(estado.cola);
			estado.hora := estado.proxima_llegada;
			estado.proxima_llegada := estado.hora + dExp(lambda);
			end
		else
			begin
			dec(estado.cola);
			estado.hora := estado.proxima_salida;
			if estado.cola < 0 then writeln('cola negativa');
			if estado.cola = 0 then
				begin
				estado.proxima_llegada := estado.hora + dExp(lambda);
				estado.proxima_salida := estado.proxima_llegada + dExp(mu);
				
				end
			else 
				begin
				estado.proxima_salida := estado.hora + dExp(mu);
				end
			end
		{end;}
end;

Begin
randomize;
tiempo_simulacion := 100000;
lambda := 5;
mu := 9;
writeln('Tiempo en sistema teorico = ',1/(mu-lambda):7:4 );
for i:=1 to 10 do
	begin
	clientes := 0;
	estado.hora := 0;
	estado.proxima_llegada := dExp(lambda);
	estado.proxima_salida := estado.proxima_llegada + dExp(mu);
	estado.cola := 0;
	t_total :=0;
	while estado.hora < tiempo_simulacion do
		begin
		cola_previa := estado.cola;
		hora_previa := estado.hora;
		avanzar(estado);
		if estado.cola > cola_previa then clientes := clientes +1;
		delta_tiempo := estado.hora - hora_previa;
		t_total := t_total + cola_previa * delta_tiempo;
		end;
	writeln('t_sistema = ',t_total/clientes:7:4,' cola_prom. ', t_total/tiempo_simulacion:7:4);
	end;
End.
