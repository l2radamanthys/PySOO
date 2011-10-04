program rotiseria;
(*programa que calcula tiempos promedios en base a tirar una moneda y simular en intervalos fijos de tiempo *)

uses crt;

type
	tipo_estado = record
		hora: real;
		cola: longint;
		proxima_llegada: real;
		proxima_salida: real;
		end;
		
var
	cola, clientes, t_simulacion, tiempo_simulacion : longint;
	t_total, t_ocioso, t_espera, tiempo_observacion : real;
	i:byte;
	moneda, alpha, alpha_minuto, mu, mu_minuto, hora :real;
	
procedure avanzar(var estado:tipo_estado);
begin
	if estado.proxima_llegada < estado.proxima_salida then
		begin
		inc(estado.cola);
		estado.hora := estado.proxima_llegada;
		estado.proxima_llegada := estado.hora + 12;
		end
	else
		begin
		dec(estado.cola);
		if estado.cola = 0 then
			begin
			estado.hora := estado.proxima_salida;
			estado.proxima_salida := estado.proxima_llegada + 12;
			end
		else estado.proxima_salida := estado.hora + 12;
		end
		
end;

Begin


End.
