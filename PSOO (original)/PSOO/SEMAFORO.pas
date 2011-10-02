UNIT semaforos;
{ Esta unidad provee la definici¢n de una clase que permite el uso de "sem - }
{ foros" en la simulaci¢n.                                                   }
{ * Sem foro estandar con disciplina FIFO:                                   }
{   Mensajes:                                                                }
{     - iniciar(TamMinColaEsp) ÄÄÄ inicia la cola interna del sem foro con  }
{                                   un sierto tama¤o m¡nimo.                 }
{     - esperar(obj) ÄÄÄ pone en suspenso al obj. hasta que el sem foro se  }
{                         ponga "verde".                                     }
{     - continuar ÄÄÄ activa al objeto que est  esperando sac ndolo de la   }
{                      cola de objetos en espera.                            }
{     - borrar ÄÄÄ destrulle la cola de espera y con ella a los punteros de }
{                   los objetos que estaban esperando.                       }
{                                                                            }
{ * Sem foro de disciplina FIFO, tama¤o "n":                                 }
{   Mensajes:                                                                }
{     - iniciar(n) ÄÄÄ inicia el sem foro con un tama¤o "n".                }
{     - esperar(obj) ÄÄÄ pone en suspenso al obj. cuando "n" se ha agotado, }
{                         sino sigue la ejecuci¢n y "n" merma en uno.        }
{     - continuar ÄÄÄ activa al objeto que est  esperando sac ndolo de la   }
{                      cola de objetos en espera. "n" crece en uno.          }
{     - borrar ÄÄÄ destrulle la cola de espera y con ella a los punteros de }
{                   los objetos que estaban esperando.                       }
{                                                                            }
{ REFERENCIAS: consultar la secci¢n *** del "Manual del PSOO" para mayores   }
{ detalles sobre el primer tipo de sem foro. Para el segundo, vea la teor¡a  }
{ de la C tedra Modelos y Simulaci¢n.                                        }
{                                                                            }


INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }

uses Estr_dat;

type
  ObjSmf=object          { clase que ofrece los mecanismos de un sem foro de }
                         { prioridad FIFO.                                   }

    rojo:boolean;        { si verdad indica que el sem foro est  ocupado     }
    ColaEspera:ObjFIFO;  { colecci¢n de objetos en espera de la se¤al "verde"}

    procedure iniciar(TamMinColaEsp:word; FactorAmpl:real);
    procedure inic;
    function  esperar(Obj:pointer):boolean;
    procedure continuar;
    procedure borrar;
  end;

  ObjSmf_N=object          { clase que ofrece los mecanismos de un sem foro de }
                           { prioridad FIFO de capacidad N                     }

    elemLibres:longint;    { cant. de elementos libres }
    ColaEspera:ObjFIFO;  { colecci¢n de objetos en espera de la se¤al "verde"}

    procedure iniciar(n:longint; TamMinColaEsp:word; FactorAmpl:real);
    procedure inic(n:longint);
    function  esperar(Obj:pointer):boolean;
    procedure continuar;
    procedure borrar;
  end;

IMPLEMENTATION
{ Unidades, tipos, constantes y variables utilizadas por el despachador.     }
{ NO est n disponibles para ning£n programa que utilice esta unidad.         }

uses simulacion;

{----------------------------------------------------------------------------}
{-----------   L A   C L A S E   S E M A F O R O   " F I F O "---------------}
{----------------------------------------------------------------------------}

{-------------I-N-I-C-I-A-R---L-A---C-L-A-S-E---S-E-M-A-F-O-R-O--------------}

procedure ObjSmf.iniciar(TamMinColaEsp:word; FactorAmpl:real);
{ Inicia las estructuras internas del sem foro.                              }

begin
  rojo:=false;
  ColaEspera.iniciar(TamMinColaEsp,FactorAmpl);
end;

procedure ObjSmf.inic;
{ Inicia las estructuras internas del sem foro con valores por defecto.      }

begin
  iniciar(10,1.4);
end;


{---------------E-S-P-E-R-A-R---L-A---S-E-¥-A-L---"-V-E-R-D-E-"--------------}

function  ObjSmf.esperar(obj:pointer):boolean;
{ El objeto que env¡a este mensaje espera en al cola del sem foro hasta que  }
{ se ponga en "verde".(Verdad -> si tubo que esperar.)                       }

begin
  if rojo then
    begin
      ColaEspera.poner(obj);
      suspenderse;
      esperar:=true;
    end
  else
    begin 
      rojo:=true;
      esperar:=false;
    end;
end;

{-------A-C-T-I-V-A-R---A-L---P-R-O-X-I-M-O---O-B-J---E-N---E-S-P-E-R-A------}

procedure ObjSmf.continuar;
{ El sem foro busca en su cola de espera al siguiente objeto para activarlo. }
{ Si encuentra a  lguien se mantiene "rojo" sino se pone "verde".            }

var
  obj:PtrObjSim;
begin
  if ColaEspera.vacia then rojo:=false
  else
    begin
      obj:=ColaEspera.sacar;
      activar(obj);
    end;
end;

{-------B-O-R-R-A-R---E-S-T-R-U-C-T-U-R-A-S---D-E-L---S-E-M-A-F-O-R-O--------}

procedure ObjSmf.borrar;
{ Destrulle la cola de espera del sem foro devolviendo el bloque de memoria  }
{ al manejador din mico del pascal.                                          }

begin
  ColaEspera.borrar;
end;


{----------------------------------------------------------------------------}
{---- C L A S E   S E M A F O R O   " F I F O "   C A P A C I D A D   N -----}
{----------------------------------------------------------------------------}

{-------------I-N-I-C-I-A-R---L-A---C-L-A-S-E---S-E-M-A-F-O-R-O--------------}

procedure ObjSmf_N.iniciar(n:longint; TamMinColaEsp:word; FactorAmpl:real);
{ Inicia las estructuras internas del sem foro.                              }

begin
  ElemLibres:=n;
  ColaEspera.iniciar(10,1.4);
end;

procedure ObjSmf_N.inic(n:longint);
{ Inicia las estructuras internas del sem foro con valores por defecto.      }

begin
  iniciar(n,10,1.4);
end;

{---------------E-S-P-E-R-A-R---L-A---S-E-¥-A-L---"-V-E-R-D-E-"--------------}

function  ObjSmf_N.esperar(obj:pointer):boolean;
{ El objeto que env¡a este mensaje espera en al cola del sem foro hasta que  }
{ se ponga en "verde".(Verdad -> si tubo que esperar.)                       }

begin
  if ElemLibres=0 then
    begin
      ColaEspera.poner(obj);
      suspenderse;
      esperar:=true;
    end
  else
    begin 
      elemLibres:=elemLibres - 1;
      esperar:=false;
    end;
end;

{-------A-C-T-I-V-A-R---A-L---P-R-O-X-I-M-O---O-B-J---E-N---E-S-P-E-R-A------}

procedure ObjSmf_N.continuar;
{ El sem foro busca en su cola de espera al siguiente objeto para activarlo. }
{ Si encuentra a  lguien se mantiene "rojo" sino se pone "verde".            }

var
  obj:PtrObjSim;
begin
  if ColaEspera.vacia then elemLibres:=elemLibres + 1
  else
    begin
      obj:=ColaEspera.sacar;
      activar(obj);
    end;
end;

{-------B-O-R-R-A-R---E-S-T-R-U-C-T-U-R-A-S---D-E-L---S-E-M-A-F-O-R-O--------}

procedure ObjSmf_N.borrar;
{ Destrulle la cola de espera del sem foro devolviendo el bloque de memoria  }
{ al manejador din mico del pascal.                                          }

begin
  ColaEspera.borrar;
end;

END.

