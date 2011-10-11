program rotiseria;
(*(M/M/1) FIFO *)
uses crt;
var
	cola, clientes, t_simulacion, tiempo_simulacion : longint;
	t_total, t_ocioso, t_espera, tiempo_observacion : real;
	i:byte;
	moneda, alpha, alpha_minuto, mu, mu_minuto, hora :real;
Begin
clrscr;
randomize;
alpha_minuto := 0.1;
mu_minuto := 0.125;
tiempo_observacion := 1; {en minutos}
alpha := alpha_minuto * tiempo_observacion;
mu := mu_minuto * tiempo_observacion;
tiempo_simulacion := 100000; {en minutos}
t_simulacion := tiempo_simulacion;
{tiempo de simulación}
writeln('   Ts    Proporción tpo. Ocioso    Cola prom.    Proporción cli. x min');
for i:=1 to 20 do
	{ciclo para obtener 20 corridas de la simulación}
	begin
	cola:=0;
	t_ocioso:=0;
	t_total:=0;
	t_espera:=0;
	clientes:=0;
	hora := 0;
	while (hora < t_simulacion) or (cola>0) do {la simulación termina cuando se consume T o cuando se atiende
	hasta el último cliente en el sistema}
		begin
		hora := hora + tiempo_observacion;
		if cola > 0 then
			begin
			moneda:=random;
			{simula la salida}
			if moneda < mu then dec(cola);
			end;
		moneda:=random;
		{simula la llegada}
		if moneda < alpha then
			begin
			inc(cola);
			inc(clientes);
			end;
		t_total := t_total + (cola*tiempo_observacion);
		if cola = 0 then t_ocioso := t_ocioso + tiempo_observacion
		else t_espera := t_espera + ((cola-1)*tiempo_observacion);
		end;
	writeln(t_total/clientes:7:2, '', t_ocioso/t_simulacion:7:2, '', t_total/t_simulacion:7:2, '', clientes/t_simulacion:7:2);
	end;
readln;
End.

