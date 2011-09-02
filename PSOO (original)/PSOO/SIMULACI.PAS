UNIT simulacion;
{ Unidad que provee de los elementos necesarios para permitir la realizaci¢n }
{ de simulaciones en TP6:                                                    }
{     - Rutinas del DESPACHADOR                                              }
{          * INICIAR_SIM                                                     }
{          * NUEVO                                                           }
{          * ACTIVAR                                                         }
{          * ESPERAR                                                         }
{          * CANCELAR (ESPERA)
{          * SUSPENDERSE                                                     }
{          * REANUDAR                                                        }
{          * BORRARSE                                                        }
{          * TERMINAR                                                        }
{                                                                            }
{ REFERENCIAS: consultar la secci¢n *** del "Manual del PSOO" para mayores   }
{ detalles.                                                                  }

INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }

type

  TipEstados=(susp,act,esp,borr);

  PtrObjSim=^ObjSim;        { puntero a un objeto de simulaci¢n  }

  ObjSim=object             { Objeto de simulacion. Todos los objetos no /// }
                            { pasivos de la simulacion deben declararse como }
                            { una subclase de "ObjSim".                      }

    pMemoPila:pointer;      { puntero de la Informaci¢n de pila  }
    HoraDesp:real;          { hora planeada para despertar en caso de ESPERA }
    CantEsp:integer;        { cantidad de esperas a£n en el HEAP para desc.  }
    Estado:TipEstados;      { estados en los que puede encontrarse el objeto }

    constructor iniciar;
    procedure   CicloDeVida;                      virtual;
    destructor  borrar;                           virtual;
    private
    procedure   congelar(var pEstrPila:pointer);
    procedure   descongelar(var pEstrPila:pointer);

  end;

{--------------------  PROCEDIMIENTOS DEL "DESPACHADOR"  --------------------}

procedure IniciarSimulacion(direc:PtrObjSim); { inicializa la simulacion    }
procedure nuevo(NuevoObj:PtrObjSim);          { da el control a nuevo obj.  }
procedure activar(NuevoObjActivo:PtrObjSim);  { activa un objeto existente  }
function  esperar(tEsp:real):boolean;         { retardo de tEsp para seguir }
procedure suspenderse;                        { suspender acci¢n del obj.   }
procedure reanudar(pObj:PtrObjSim);           { reanuda un determinado obj. }
procedure borrarse;                           { salir de la simulacion      }
procedure terminar;                           { salir de la simulacion sin  }
                                              { borrar las estr. de datos   }

{--------------  VARIABLES COMPARTIDAS POR EL "DESPACHADOR"  ----------------}

var
  HoraAct:real;               {  hora actual en el sistema  }
  mismo:pointer;              { puntero al objeto corriente }

  yo:pointer absolute mismo;          { r‚plica de "mismo". }
  Hora:real        absolute HoraAct;  { r‚plica de HoraAct. }
  HoraActual:real  absolute HoraAct;  { r‚plica de HoraAct. }

  TamMinColaAct :word;      { tama¤o m¡nimo de la pila de obj. activos     }
  FacAmplColaAct:real;      { factor de ampliaci¢n de su vector din mico   }

  TamMinConjSusp:word;      { tama¤o m¡nimo del conj. de obj. suspendidos  }
  FacAmplConjSusp:real;     { factor de ampliaci¢n de su vector din mico   }

  TamMinBuffCorr:word;     { tama¤o m¡nimo del vector del gestor din mico }
                            { especializado.                               }
  FacAmplGestDin:real;      { factor de ampliaci¢n del vector del gestor   }
                            { din mico especializado.                      }

IMPLEMENTATION
{ Unidades, tipos, constantes y variables utilizadas por el despachador.     }
{ NO est n disponibles para ning£n programa que utilice esta unidad.         }

uses Corrut,GestDin,Estr_Dat;


type
  ClaseError=(futuro,activ,rean,cancel);

const
  MensajeError:array[ClaseError] of string[30]=
    (
      'No existen objetos para activar en el futuro' ,
      'No se puede activar objeto',
      'No se puede reanudar objeto',
      'No se puede cancelar objeto'
    );

var
  ObjEnCPU:PtrObjSim absolute mismo;  { r‚plica de "mismo", puntero }
                                      { al actual objeto en CPU.    }
  director   :PtrObjSim;     { puntero al obj director }
  pArranque  :pointer;       { direcci¢n del bloque de pila del arrancador }
  HeapObjFut :ObjHeap;       { cola de prioridades de objetos futuros }
  ConjObjSusp:ObjConj;       { conjunto de objetos suspendidos        }
  PilaObjActivos:ObjLifo;    { pila de objetos activos (pero sin CPU) }

  TopeMonton:pointer;        { Tope del mont¢n.Utilizado para restaurar el }
                             { HEAP de Pascal a su estado anterior a la    }
                             { llamada del despachador de objetos.         }

{----------------------------------------------------------------------------}
{------------   E L   O B J E T O   D E   S I M U L A C I O N   -------------}
{----------------------------------------------------------------------------}

{ Observaci¢n: los m‚todos de los objetos que pertenezcan a esta clase en    }
{ realidad nunca se ejecutar n ya que en el momento de la ejecuci¢n, se ///  }
{ llamaran los de las subclases que corresponda con el tipo de la variable de}
{ ese objeto.                                                                }
{  *** Los dos £ltimos mensajes quedan fuera de esta observaci¢n.            }
{ Debido a lo mencionado los m‚todos de este objeto son "rutinas fantasmas"  }



{---------I-N-I-C-I-A-L-I-Z-A-R---O-B-J-.---D-E---S-I-M-U-L-A-C-I-O-N--------}

constructor ObjSim.iniciar;
{ Inicializa las estructuras de datos que utilizara el objeto de simulacion  }

begin end;

{---C-I-C-L-O---D-E---V-I-D-A---D-E-L---O-B-J-.---D-E---S-I-M-U-L-A-C-I-O-N--}

procedure   ObjSim.CicloDeVida;
{ Ciclo de vida del objeto de simulacion donde se detallan las operaciones y }
{ acciones que el objeto debe realizar                                       }

begin end;

{-------------B-O-R-R-A-R---O-B-J-.---D-E---S-I-M-U-L-A-C-I-O-N--------------}

destructor  ObjSim.borrar;
{ Borra las estr. de datos utilizadas por el objeto de simulacion.           }

begin end;

{---------C-O-N-G-E-L-A-R---O-B-J-E-T-O---D-E---S-I-M-U-L-A-C-I-O-N----------}

procedure   ObjSim.congelar(var pEstrPila:pointer);
{ Guarda la direcci¢n del bloque que contiene inf. de la pila actual, inf.   }
{ que parte desde la base prefijada por la variable BasePila hasta la direc- }
{ ci¢n especificada por el valor actual del SP.                              }

begin
  pMemoPila:=pEstrPila;  { guarda direcci¢n en pMemoPila }
end;

{------D-E-S-C-O-N-G-E-L-A-R---O-B-J-E-T-O---D-E---S-I-M-U-L-A-C-I-O-N-------}

procedure   ObjSim.descongelar(var pEstrPila:pointer);
{ Retorna la direcci¢n del bloque de inf. de la pila del CPU.                }

begin
  pEstrPila:=pMemoPila;  { obtiene direcci¢n guardada por }
                         { "congelar" de pMemoPila        }
end;

{----------------------E-M-I-S-O-R---D-E---E-R-R-O-R-E-S---------------------}

procedure EmitirERROR(error:ClaseError);

begin
  writeln('*** ERROR:',MensajeError[error]);
  halt;
end;

{------------------A-R-R-A-N-C-A-D-O-R---D-E---O-B-J-E-T-O-S-----------------}

procedure arrancar;
{ Ejecuta el ciclo de vida del objeto indicado por la variable ObjEnCPU.     }

var
  i:integer;              { resultado de las funciones de corrutina }
  HoraFut:real;           { hora siguiente a la que debe avanzar la HoraAct  }
  pMemoPila,              { direcci¢n del bloque de inf. de pila }
  pAux:pointer;           { adaptador de tipos }

begin
  repeat i:=SetJmp(pArranque) until i=0;   { pArranque=inf. de la pila del   }
                                           { procedimiento "arrancar".       }
  ObjEnCPU^.CantEsp:=0;
  ObjEnCPU^.Estado:=act;
  ObjEnCPU^.CicloDeVida;                   { ejecuta ciclo de vida del obj.  }
                                           { en CPU.                         }
  if ObjEnCPU<>director then               { si el actual obj. en CPU no es  }
                                           { el obj. "director" ...          }
    if PilaObjActivos.vacia then           { ... miro si no hay obj. activos }
      begin
      while not HeapObjFut.vacio do        { ..y si el heap no esta vsac¡o...}
        begin
          HeapObjFut.sacar(HoraFut,pAux);   { sacar el primer obj. del heap}
          ObjEnCPU:=pAux;                   { y hacerlo obj. corriente ,   }
          HoraAct:=HoraFut;                 { actualizar la hora actual,   }
          if HoraAct=ObjEnCPU^.HoraDesp then  { ¨es evento NO cancelado..? }
            begin
              ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,}
              ObjEnCPU^.Estado:=act;
              i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU.}
            end;
          dec(ObjEnCPU^.CantEsp);
          if (ObjEnCPU^.CantEsp = 0) and (ObjEnCPU^.Estado=Borr) then
            begin
              ConjObjSusp.sacar(pointer(ObjEnCPU));
              ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,}
              ObjEnCPU^.Estado:=borr;
              i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU.}
            end;
        end;
      EmitirERROR(futuro)                     { ... entonces emitir error.   }
      end
    else                                   { ... si hay obj. activos ...     }
      begin
        pAux:=PilaObjActivos.sacar;        { ... saco de la pila de objetos  }
                                           { activos el primero de ellos,... }
        ObjEnCPU:=pAux;                    { ... que se trans. en el nuevo   }
                                           { objeto en CPU,                  }
        ObjEnCPU^.descongelar(pMemoPila);  { obtengo informaci¢n de la pila  }
                                           { de dicho objeto y ....          }
        i:=LongJmp(pMemoPila,1);           { ... reanudo sus tareas.         }
      end;
end;

{----------------------------------------------------------------------------}
{---------------------   E L   D E S P A C H A D O R   ----------------------}
{----------------------------------------------------------------------------}

procedure IniciarSimulacion(direc:PtrObjSim);
{ Inicia las estructuras internas del simulador:                             }
{    - Base de la pila,                                                      }
{    - Hora actual en el sistema,                                            }
{    - Heap de objetos futuros,                                              }
{    - Conjunto de objetos suspendidos,                                      }
{    - Pila de objetos activos,                                              }
{    - ObjEnCPU= Obj. director (direc),                                      }
{    - director= Obj. director (direc), ....                                 }
{ ... y arranca las tareas del objeto director de la simulacion              }

var
  i:word;
  hora:real;
  obj:PtrObjSim;
  p:pointer;
begin
  HeapError:=@ErrorMemoLlena;   { tomar el control de errores de des-  }
                                { bordamiento del HEAP de TP6.         }

  IniciarCorrutinas(Sptr-1,TamMinBuffCorr,FacAmplGestDin);{ iniciar el }
     { gestor de corrutinas poniendo la base de la pila desde la rutina}
     { "arrancar" y especificando un cierto tama¤o m¡nimo para el ///  }
     { buffer del manejador de corrutinas.                             }

  HoraAct:=0;            { hora actual en el sistema igual a cero.     }

  HeapObjFut.Iniciar;    { inicializo el heap de objetos activos.      }

  ConjObjSusp.iniciar(TamMinConjSusp,FacAmplConjSusp); { inicializo el }
                                           { conjunto de objetos sus-  }
                                           { pendidos.                 }

  PilaObjActivos.Iniciar(TamMinColaAct,FacAmplColaAct);   { inicializo }
                                           { la pila de objetos activos}

  ObjEnCPU:=direc;       { el objeto en CPU  es el "director"                }
  director:=direc;       { director = puntero al objeto "director".          }
  arrancar;              { arranca el objeto en CPU (en este caso el direc.) }

  HeapError:=nil;        { restaura el gestor de errores de desbordamiento   }
                         { del HEAP de Trbo Pascal V6.0.                     }
end;

{---------------------------------N-U-E-V-O----------------------------------}

procedure nuevo(NuevoObj:PtrObjSim);
{ NUEVO= cede el control al "NuevoObj" dejando en estado de activo al objeto }
{ llamador de este mensaje.                                                  }

var
  i:integer;              { resultado de las funciones de corrutina }
  HoraFut:real;           { hora siguiente a la que debe avanzar la HoraAct  }
  pMemoPila,              { direcci¢n del bloque de inf. de pila }
  pAux:pointer;           { adaptador de tipos }

begin
  i:=SetJmp(pMemoPila);                { memorizo la situaci¢n de la pila  }
  if i=0 then                          { si acabo de memorizar la pila ... }
    begin
      ObjEnCPU^.congelar(pMemoPila);   { congelo el obj. llamador      }
      PilaObjActivos.poner(ObjEnCPU);  { pongo ACTIVO al obj. llamador }
      ObjEnCPU:=NuevoObj;              { el NuevoObj es el obj. corriente }

      i:=LongJmp(pArranque,1);         { llamo al arrancador de obj.      }
    end;
end;

{--------------------------------A-C-T-I-V-A-R-------------------------------}

procedure activar(NuevoObjActivo:PtrObjSim);
{ ACTIVAR= pone en estado de ACTIVO al "NuevoObjActivo". Esto solo se puede  }
{ llevar a cabo si dicho objeto estaba previamente SUSPENDIDO.               }
{    De no cumplirse esto se emite el correspondiente mensaje de error y la  }
{ simulacion se detiene.                                                     }

begin
  if NuevoObjActivo^.Estado=susp then           { si el Obj estaba susp....  }
    begin
      ConjObjSusp.sacar(pointer(NuevoObjActivo));         { ... lo saco del conjunto, }
      NuevoObjActivo^.Estado:=act;
      PilaObjActivos.poner(NuevoObjActivo);      { y lo pongo en la pila de  }
    end                                          { objetos activos.          }
  else
  if NuevoObjActivo^.Estado=esp then        { si cancelaci¢n v lida...  }
    begin
      inc(NuevoObjActivo^.CantEsp);
      NuevoObjActivo^.HoraDesp:=0;         { marcar espera cancelada ...   }
      NuevoObjActivo^.Estado:=act;
      PilaObjActivos.poner(NuevoObjActivo);{ ... y lo pongo en la pila de  }
    end                                   { objetos activos.              }
  else
    EmitirERROR(activ)                        { ...entonces emitir error.. }

end;

{--------------------------------E-S-P-E-R-A-R-------------------------------}

function esperar(tEsp:real):boolean;
{ ESPERAR= el objeto llamador se "duerme" durante el tiempo "tEsp". Durante  }
{ esos momentos se encuentra en el heap de objetos futuros y se apodera de la}
{ CPU cuando llegue el momento adecuado seg£n el tiempo de demora estipulado }

var
  i:integer;              { resultado de las funciones de corrutina }
  HoraFut:real;           { hora siguiente a la que debe avanzar la HoraAct  }
  pMemoPila,              { direcci¢n del bloque de inf. de pila }
  pAux:pointer;           { adaptador de tipos }

begin
  ObjEnCPU^.Estado:=esp;
  i:=SetJmp(pMemoPila);              { memorizo la situaci¢n de la pila  }
  if i=0 then                        { si acabo de memorizar la pila ... }
    begin
      ObjEnCPU^.congelar(pMemoPila);      { ... congelo el objeto corriente, }
      ObjEnCPU^.HoraDesp:=HoraAct+tEsp;         { registro hora de despertar }
      HeapObjFut.poner(ObjEnCPU^.HoraDesp,ObjEnCPU);  { lo pongo en el heap, }
      if PilaObjActivos.vacia then              { si no hay obj. activos ... }
        begin
        while not HeapObjFut.vacio do         { y si el heap no esta vacio.. }
          begin
            HeapObjFut.sacar(HoraFut,pAux);   { sacar el primer obj. del heap}
            ObjEnCPU:=pAux;                   { y hacerlo obj. corriente ,   }
            HoraAct:=HoraFut;                 { actualizar la hora actual,   }
            if HoraAct=ObjEnCPU^.HoraDesp then  { ¨es evento NO cancelado..? }
              begin
                ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,  }
                ObjEnCPU^.Estado:=act;
                i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU }
              end;
            dec(ObjEnCPU^.CantEsp);
            if (ObjEnCPU^.CantEsp = 0) and (ObjEnCPU^.Estado=borr) then
              begin
                ConjObjSusp.sacar(pointer(ObjEnCPU));
                ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,}
                ObjEnCPU^.Estado:=borr;
                i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU.}
              end;
          end;
        EmitirERROR(futuro)                 { ... entonces emitir error.   }
        end
      else                                      { si hay obj. activos ...    }
        begin
          pAux:=PilaObjActivos.sacar;         { ... sacar obj de la pila de  }
                                              { objetos activos,             }
          ObjEnCPU:=pAux;                     { hacerlo obj corriente,       }
          ObjEnCPU^.descongelar(pMemoPila);   { descongelarlo,               }
          i:=LongJmp(pMemoPila,1);          { y cederle el control de la CPU.}
        end;
    end;
  esperar:=ObjEnCPU^.HoraDesp=HoraAct;
end;


{----------------------------S-U-S-P-E-N-D-E-R-S-E---------------------------}

procedure suspenderse;
{ SUSPENDERSE= el objeto que utiliza este mensaje pasa al estado SUSPENDIDO. }

var
  i:integer;              { resultado de las funciones de corrutina }
  HoraFut:real;           { hora siguiente a la que debe avanzar la HoraAct  }
  pMemoPila,              { direcci¢n del bloque de inf. de pila }
  pAux:pointer;           { adaptador de tipos }

begin
  ObjEnCPU^.Estado:=susp;
  i:=SetJmp(pMemoPila);              { memorizo la situaci¢n de la pila  }
  if i=0 then                        { si acabo de memorizar la pila ... }
    begin
      ObjEnCPU^.congelar(pMemoPila); { ... congelo el objeto corriente,  }
      ConjObjSusp.poner(ObjenCPU);   { lo pongo en el conj. de susp. ,   }
      if PilaObjActivos.vacia then              { si no hay obj. activos ... }
        begin
        while not HeapObjFut.vacio do         { y si el heap no esta vacio.. }
          begin
            HeapObjFut.sacar(HoraFut,pAux);   { sacar el primer obj. del heap}
            ObjEnCPU:=pAux;                   { y hacerlo obj. corriente ,   }
            HoraAct:=HoraFut;                 { actualizar la hora actual,   }
            if HoraAct=ObjEnCPU^.HoraDesp then  { ¨es evento NO cancelado..? }
              begin
                ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,}
                ObjEnCPU^.Estado:=act;
                i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU.}
              end;
            dec(ObjEnCPU^.CantEsp);
            if (ObjEnCPU^.CantEsp = 0) and (ObjEnCPU^.Estado=borr) then
              begin
                ConjObjSusp.sacar(pointer(ObjEnCPU));
                ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,}
                ObjEnCPU^.Estado:=borr;
                i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU.}
              end;
          end;
        EmitirERROR(futuro)                 { ... entonces emitir error.   }
        end
      else                                      { si hay obj. activos ...    }
        begin
          pAux:=PilaObjActivos.sacar;         { ... sacar obj de la pila de  }
                                              { objetos activos,             }
          ObjEnCPU:=pAux;                     { hacerlo obj corriente,       }
          ObjEnCPU^.descongelar(pMemoPila);   { descongelarlo,               }
          i:=LongJmp(pMemoPila,1);          { y cederle el control de la CPU.}
        end;
    end;
end;

{------------------------------R-E-A-N-U-D-A-R-------------------------------}

procedure reanudar(pObj:PtrObjSim);
{ REANUDAR= el obj. llamador pasa al estado de SUSPENDIDO y el obj. a reanu- }
{ dar sera el nuevo objeto corriente. Solo se puede reanudar objetos que es- }
{ taban en estado de SUSPENDIDOS; de no ser as¡ se emitir  el correspondiente}
{ mensaje de error.                                                          }

var
  i:integer;              { resultado de las funciones de corrutina }
  pMemoPila:pointer;      { direcci¢n del bloque de inf. de pila }

begin
  ObjEnCPU^.Estado:=susp;
  i:=SetJmp(pMemoPila);                  { memorizo la situaci¢n de la pila  }
  if i=0 then                            { si acabo de memorizar la pila ... }
    begin
      ObjEnCPU^.congelar(pMemoPila);     { ... congelo el objeto corriente,  }
      ConjObjSusp.poner(ObjEnCPU);       { lo pongo en el conj. de susp. ,   }
      if pObj^.Estado=susp  then              { si el obj. estaba susp. .... }
        begin
          ConjObjSusp.sacar(pointer(pObj));      { ... lo saco del conjunto, }
          ObjEnCPU:=pObj;                  { lo nombro nuevo obj. corriente, }
          ObjEnCPU^.descongelar(pMemoPila);   { descongelar el obj corriente,}
          ObjEnCPU^.Estado:=act;
          i:=LongJmp(pMemoPila,1);         {  y cederle el control de la CPU.}
        end
      else                                 { si no lo estaba (susp.) ...  }
      if pObj^.Estado=esp then
        begin
          ObjEnCPU:=pObj;
          inc(ObjEnCPU^.CantEsp);
          ObjEnCPU^.HoraDesp:=0;              { marcar espera cancelada ...  }
          ObjEnCPU^.descongelar(pMemoPila);   { descongelar el obj corriente,}
          ObjEnCPU^.Estado:=act;
          i:=LongJmp(pMemoPila,1);         {  y cederle el control de la CPU.}
        end
      else EmitirERROR(rean);             { ... emitir mensaje de error. }
    end;
end;

{------------------------------B-O-R-R-A-R-S-E-------------------------------}

procedure borrarse;
{ BORRARSE= el objeto llamador desaparece por completo de la simulacion.     }
{ Esto se logra gracias a la llamada del mensaje BORRAR que todo objeto debe }
{ poseer.                                                                    }
var
  i:integer;              { resultado de las funciones de corrutina }
  HoraFut:real;           { hora siguiente a la que debe avanzar la HoraAct  }
  pMemoPila,              { direcci¢n del bloque de inf. de pila }
  pAux:pointer;           { adaptador de tipos }

begin
  ObjEnCPU^.HoraDesp:=0;             { marcar espera cancelada ...   }
  ObjEnCPU^.Estado:=borr;
  if ObjEnCPU^.CantEsp=0 then
    begin
      dispose(ObjEnCPU,borrar);
      exit;
    end;
  i:=SetJmp(pMemoPila);              { memorizo la situaci¢n de la pila  }
  if i=0 then                        { si acabo de memorizar la pila ... }
    begin
      ObjEnCPU^.congelar(pMemoPila); { ... congelo el objeto corriente,  }
      ConjObjSusp.poner(ObjenCPU);   { lo pongo en el conj. de susp. ,   }
      if PilaObjActivos.vacia then              { si no hay obj. activos ... }
        begin
        while not HeapObjFut.vacio do         { y si el heap no esta vacio.. }
          begin
            HeapObjFut.sacar(HoraFut,pAux);   { sacar el primer obj. del heap}
            ObjEnCPU:=pAux;                   { y hacerlo obj. corriente ,   }
            HoraAct:=HoraFut;                 { actualizar la hora actual,   }
            if HoraAct=ObjEnCPU^.HoraDesp then  { ¨es evento NO cancelado..? }
              begin
                ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,}
                ObjEnCPU^.Estado:=act;
                i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU.}
              end;
            dec(ObjEnCPU^.CantEsp);
            if (ObjEnCPU^.CantEsp = 0) and (ObjEnCPU^.Estado=borr) then
              begin
                ConjObjSusp.sacar(pointer(ObjEnCPU));
                ObjEnCPU^.descongelar(pMemoPila);  { descongelar el obj corriente,}
                ObjEnCPU^.Estado:=borr;
                i:=LongJmp(pMemoPila,1);           { y cederle el control de la CPU.}
              end;
          end;
        EmitirERROR(futuro)                 { ... entonces emitir error.   }
        end
      else                                      { si hay obj. activos ...    }
        begin
          pAux:=PilaObjActivos.sacar;         { ... sacar obj de la pila de  }
                                              { objetos activos,             }
          ObjEnCPU:=pAux;                     { hacerlo obj corriente,       }
          ObjEnCPU^.descongelar(pMemoPila);   { descongelarlo,               }
          i:=LongJmp(pMemoPila,1);          { y cederle el control de la CPU.}
        end;
    end;

  dispose(ObjEnCPU,borrar);
end;

{------------------------------T-E-R-M-I-N-A-R-------------------------------}

procedure terminar;
{ TERMINAR= el objeto llamador culmina su ciclo de vida pero sus estructuras }
{ de datos no desaparecen de la simulacion y est n disponibles para el resto }
{ de los objetos a trav‚s de los mensajes con que cuenta para su tratamiento.}
{ El mismo efecto se puede lograr si se culmina el ciclo de vida del obj. sin}
{ utilizar ninguna rutina del DESPACHADOR. El uso o no de TERMINAR queda a la}
{ libre elecci¢n del programador.                                            }

begin
end;

BEGIN
  TamMinColaAct :=10;  { valor por defecto del tama¤o de la cola de activos  }
  FacAmplColaAct:=1.2; { valor por defecto de su factor de ampliaci¢n.       }

  TamMinConjSusp:=300; { valor por defecto del tama¤o del conj. de obj. susp.}
  FacAmplConjSusp:=1.3;{ valor por defecto de su factor de ampliaci¢n.       }

  TamMinBuffCorr:=100; { valor por defecto del tama¤o del vector del gestor  }
                       { din mico especializado para las corrutinas.         }
  FacAmplGestDin:=1.5; { valor por defecto de su factor de ampliaci¢n.       }
END.
