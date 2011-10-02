UNIT monitor;
{ Esta unidad contiene definiciones de clases que resultan £tiles para la // }
{ toma de estad¡sticas cuandose utiliza el PSOO.                             }
{                                                                            }
{ La id‚a que maneja es la de "objetos m£ltiples" cobceptos que fueron ///// }
{ explicados en el manual de este soft.                                      }
{                                                                            }
{ A continuaci¢n se enumera las clases que componen esta unidad:             }
{     - ObsPromedio: observa un evento y calcula a partir de los datos que   }
{                    se le suministra, el promedio de los mismos.            }
{     - ObsDesv¡os : observa un evento y calcula a partir de los datos que   }
{                    se le suministra, el desv¡o y la varianza de los mismos.}
{     - ObsDatos   : observa un evento y calcula a partir de los datos que   }
{                    se le suministra, el promedio, desv¡o y varianza de los }
{                    mismos.                                                 }
{                                                                            }
INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }

type
  letrero=string[60];

  ObsPromedio=object
    acum:real;         { acumulador de datos (valores reales) }
    cont:longint;      { contador de datos                    }
    mensaje:letrero;   { mensaje que aparece al lado del promedio }
                       { (denota su naturaleza)                   }

    procedure inic;
    procedure iniciar(titulo:letrero);
    procedure acumular(dato:real);
    procedure MostrarEstd;
    function  resul:real;
  end;

  ObsDesvio=object
    muestra:array[1..100] of real;  { datos sobre los cuales  }
                                    { se calcular  el desv¡o  }
                                    { y la varianza           }

    cont:word;         { contador de datos                    }
    mensaje1,          { mensaje que aparece al lado del desv¡o  }
    mensaje2:letrero;  { y de la varianza                        }

    procedure iniciar(titulo1,titulo2:letrero);
    procedure acumular(dato:real);
    procedure MostrarEstd;
  end;

  ObsDatos=object
    muestra:array[1..100] of real;  { datos sobre los cuales  }
                                    { se calcular  el desv¡o  }
                                    { la varianza y la media  }

    cont:word;         { contador de datos                    }
    mensaje1,          { mensaje que aparece al lado del desv¡o  }
    mensaje2,          { de la varianza y ...                    }
    mensaje3:letrero;  { del promedio.                           }

    procedure iniciar(titulo1,titulo2,titulo3:letrero);
    procedure acumular(dato:real);
    procedure MostrarEstd;
  end;


IMPLEMENTATION

{----------------------------------------------------------------------------}
{--------------   L A   C L A S E   O B S.  P R O M E D I O   ---------------}
{----------------------------------------------------------------------------}

{------------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---P-R-O-M-E-D-I-O-------------}
procedure ObsPromedio.inic;
{ Inicia las estructuras de la clase ObdPromedio, colocando el acumulador y  }
{ contador a cero.                                                           }
begin
  acum:=0; cont:=0;
end;
{----------------------------------------------------------------------------}
procedure ObsPromedio.iniciar(titulo:letrero);
{ Inicia las estructuras de la clase ObdPromedio, colocando el acumulador y  }
{ contador a cero. Tambi‚n almacena el mensaje que debe emitir el m‚todo /// }
{ "MostrEstd"  cuando muestre el promedio.                                   }

begin
  mensaje:=titulo;
  acum:=0; cont:=0;
end;

{--------------------A-C-U-M-U-L-A-R---L-O-S---D-A-T-O-S---------------------}

procedure ObsPromedio.acumular(dato:real);
{ Acumula el "dato" en el acumulador interno de la clase y adem s cuenta la  }
{ recolecci¢n de un elemento m s para el c lculo del promedio.               }

begin
  acum:=acum + dato;
  inc(cont);
end;

{-------------------M-O-S-T-R-A-R---E-L---P-R-O-M-E-D-I-O--------------------}
function ObsPromedio.Resul:real;
begin
  resul:=acum/cont;
end;
{----------------------------------------------------------------------------}
procedure ObsPromedio.MostrarEstd;
{ Muestra el promedio de los datos que se coleccionaron a trav‚s del mensaje }
{ "acumular" visto anteriormente.                                            }

begin
  writeln(mensaje,' ',(acum/cont):5:2);
end;



{----------------------------------------------------------------------------}
{----------------   L A   C L A S E   O B S.   D E S V I O   ----------------}
{----------------------------------------------------------------------------}

{--------------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---D-E-S-V-I-O---------------}

procedure ObsDesvio.iniciar(titulo1,titulo2:letrero);
{ Inicia las estructuras de la clase ObdDesvio, colocando el contador en cero}
{ Tambi‚n almacena los mensajes que deber  emitir el m‚todo"MostrEstd" cuando}
{ muestre el desv¡o y la varianza.                        }

begin
  mensaje1:=titulo1;
  mensaje2:=titulo2;
  cont:=0;
end;

{--------------------A-C-U-M-U-L-A-R---L-O-S---D-A-T-O-S---------------------}

procedure ObsDesvio.acumular(dato:real);
{ Incorpora el "dato" en el vector "muestra" de la clase y adem s cuenta la  }
{ recolecci¢n de un elemento m s para el c lculo del desv¡o y la varianza.   }

begin
  inc(cont);
  muestra[cont]:=dato;
end;

{-------M-O-S-T-R-A-R---E-L---D-E-S-V-I-O---Y----L-A---V-A-R-I-A-N-Z-A-------}

procedure ObsDesvio.MostrarEstd;
{ Muestra el desvio y la varianza de los datos que se coleccionaron a trav‚s }
{ del mensaje "acumular" visto anteriormente.                                }

var
  i:word;         { ¡ndice de prop¢sitos generales            }
  media:real;     { media de los datos del vector "muestra"   }
  varianza:real;  { varianza de los datos del vector "muetra" }

begin
  media:=0;
  for i:=1 to cont do media:=media + muestra[i];
  media:=media/cont;

  varianza:=0;
  for i:=1 to cont do varianza:=varianza +
                                (muestra[i] - media) * (muestra[i] - media);
  varianza:=varianza/(cont-1);

  writeln(mensaje1,' ',sqrt(varianza):5:2);
  writeln(mensaje2,' ',     varianza :5:2);
end;

{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}

{---------------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---D-A-T-O-S----------------}

procedure ObsDatos.iniciar(titulo1,titulo2,titulo3:letrero);
{ Inicia las estructuras de la clase ObdDatos, colocando al contador en cero }
{ Tambi‚n almacena los mensajes que deber  emitir el m‚todo"MostrEstd" cuando}
{ muestre el desv¡o, varianza y promedio.                                    }

begin
  mensaje1:=titulo1;
  mensaje2:=titulo2;
  mensaje3:=titulo3;
  cont:=0;
end;

{--------------------A-C-U-M-U-L-A-R---L-O-S---D-A-T-O-S---------------------}

procedure ObsDatos.acumular(dato:real);
{ Incorpora el "dato" en el vector "muestra" de la clase y adem s cuenta la  }
{ recolecci¢n de un elemento m s para el c lculo del desv¡o, varianza y media}

begin
  inc(cont);
  muestra[cont]:=dato;
end;

{----M-O-S-T-R-A-R---E-L---D-E-S-V-I-O,---V-A-R-I-A-N-Z-A---Y--M-E-D-I-A-----}

procedure ObsDatos.MostrarEstd;
{ Muestra el desvio, varianza y media de los datos que se coleccionaron a // }
{ trav‚s del mensaje "acumular" visto anteriormente.                         }

var
  i:word;      { ¡ndice de prop¢sitos generales          }
  media:real;  { media de los datos del vector "muestra" }
  varianza:real;  { varianza de los datos del vector "muetra" }

begin
  media:=0;
  for i:=1 to cont do media:=media + muestra[i];
  media:=media/cont;

  varianza:=0;
  for i:=1 to cont do varianza:=varianza +
                                (muestra[i] - media) * (muestra[i] - media);
  varianza:=varianza/(cont-1);

  writeln(mensaje1,' ',sqrt(varianza):5:2);
  writeln(mensaje2,' ',     varianza :5:2);
  writeln(mensaje3,' ',media:5:2);
end;

END.

