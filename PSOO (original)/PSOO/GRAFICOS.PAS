UNIT graficos;
{ TEMA: Biblioteca de PSOO (para la Catedra Modelos y Simulaci¢n).           }
{ SUBTEMA: Herramientas de graficaci¢n para ejes reales.                     }
{ AUTOR: Pablo Esteban Lorenzo                                               }
{ ULTIMA ACTUALIZACION: 11/8/97                                              }
{ DESCRIPCION:                                                               }
{             Colecci¢n de clases que permite manipular la pantalla gr fica  }
{ seg£n coordenadas cartesianas.                                             }
{                                                                            }
{             Actualmente solamente una clase est  disponible:               }
{               - ClsPantReal -> Pantalla Real                               }
{                                                                            }
{             Remitirse a la documentaci¢n para obtener una descripci¢n de   }
{ la clase.                                                                  }
{                                                                            }
{ ADVERTENCIA: no se garantiza el correcto funcionamiento de las clases defi-}
{              nidas en esta unidad. Este m¢dulo est  en construcci¢n y a£n  }
{              NO no se le han efectuado los test suficientes.               }
{                                                                            }
{ NOTA: el usuario est  autorizado a modificar este fuente si descubre erro- }
{       res. De ser posible hacer llegar esas observaciones (y sugerencias)  }
{       a Pablo E. Lorenzo, C tedra Modelos y Simulaci¢n  (UNSA).            }
{                                                                            }
{                                                                            }

INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }
uses graph;

TYPE
  ClsPantReal=object
    Xmin, Xmax, Ymin, Ymax, porX, porY:real;

    procedure inic(minX,maxX,minY,maxY:real);
    procedure punto(x,y:real; color:integer);
    procedure circulo(x,y,r:real; color:integer);
    function pixelX(x:real):integer;          { columna del argumento }
    function pixelY(y:real):integer;          { fila del argumento    }
  end;

procedure InicGraf;
procedure FinGraf;

{----------------------------------------------------------------------------}
IMPLEMENTATION

procedure ClsPantReal.Inic;
begin
   Xmin := minx; Xmax := maxx; Ymin := miny; Ymax := maxy;

   porX := (getmaxX + 1)/(Xmax - Xmin);
   porY := (getmaxY + 1)/(Ymax - Ymin);
end;
   
procedure ClsPantReal.punto;
begin
  putpixel(trunc((x - xmin)*porX), trunc((ymax - y)*porY), color);
end;

procedure ClsPantReal.circulo(x,y,r:real; color:integer);
begin
  setcolor(color);
  circle(trunc((x - xmin)*porX), trunc((ymax - y)*porY), trunc((r)*porY));
end;


function ClsPantReal.pixelX(x:real):integer;
begin
   pixelX:=trunc((x - xmin)*porX);
end;

function ClsPantReal.pixelY(y:real):integer;
begin
  pixelY:=trunc((ymax - y)*porY);
end;

{---------------------------------------------------------------------------}
procedure InicGraf;
var
  grDriver : Integer;
  grMode   : Integer;
  ErrCode  : Integer;
begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\tp6\bgi');
  ErrCode := GraphResult;
  if ErrCode <> grOk then
    begin
      WriteLn('Graphics error:',
               GraphErrorMsg(ErrCode));
      halt(1);
    end;
end;

procedure FinGraf;
begin
  CloseGraph;
end;

END.