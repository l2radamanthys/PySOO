UNIT Distribuciones;
{ Unidad que contiene fuentes de valores aleatorios que responden a diferen- }
{ tes distribuciones de probabilidad. A continuaci¢n las siguientes:         }
{      - distribuci¢n exponencial.                                           }
{      - distribuci¢n normal.                                                }
{      - distribuci¢n uniforme.                                              }
{      - generador de valores enteros aleatorios.                            }
{                                                                            }
{ REFERENCIAS: consultar la secci¢n *** del "Manual del PSOO" para mayores   }
{ detalles.                                                                  }

INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }

  function dExp(tasa:real):real;
  function dNorm(media,desvio:real):real;
  function dUnif(a,b:real):real;
  function dEntera(a,b:integer):integer;

IMPLEMENTATION
{ Descripci¢n de los procedimientos de las distintos generadores.            }

{--------------------F-U-E-N-T-E---E-X-P-O-N-E-N-C-I-A-L---------------------}

function dExp(tasa:real):real;
{ Retorna valores que responden a una distribuci¢n exponencial con tasa ///  }
{ "tasa"                                                                     }

begin
  dExp:=-ln(random)/tasa;
end;

{-------------------------F-U-E-N-T-E---N-O-R-M-A-L--------------------------}

function dNorm(media,desvio:real):real;
{ Retorna valores que responden a una distribuci¢n normal con una sierta /// }
{ "media" y "desvio.                                                         }

begin
  dNorm:=(random + random + random + random + random + random +
         random + random + random + random + random + random - 6)*desvio +
         media ;
end;

{-----------------------F-U-E-N-T-E---U-N-I-F-O-R-M-E------------------------}

function dUnif(a,b:real):real;
{ Retorna valores que responden a una distribuci¢n uniforme donde "a", y "b" }
{ son los l¡mites inferior y superior respectivamente.                       }

begin
  dUnif:=random*(b-a)+a;
end;

{----------G-E-N-E-R-A-R----A-L-E-A-T-O-R-I-O---D-E---E-N-T-E-R-O-S----------}

function dEntera(a,b:integer):integer;
{ Retorna valores enteros aleatorios comprendidos entre "a" y "b".           }

begin
  dEntera:=a + trunc(random*(b-a+1));
end;

END.