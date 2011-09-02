UNIT crono;
{ Mide el tiempo transcurrido entre dos eventos.                            }
{ Utilizaci¢n:                                                              }
{        ActivarReloj;                                                      }
{          un evento en particular;                                         }
{        PararReloj;    ----->  Imprimira la velocidad del evento.          }

INTERFACE
uses dos;

procedure ActivarReloj;
procedure PararReloj(str:string);

IMPLEMENTATION
var
  h,m,s,s100:word;
  arranque,parada:real;

procedure ActivarReloj;
begin
  GetTime(h,m,s,s100);
  arranque:=(h*3600)+(m*60)+s+(s100/100);
end;

procedure PararReloj(str:string);
begin
  GetTime(h,m,s,s100);
  parada:=(h*3600)+(m*60)+s+(s100/100);
  writeln(str,(parada-arranque):0:2,' segundos...');
end;

END.
