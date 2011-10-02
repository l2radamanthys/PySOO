UNIT Estr_Dat;
{ Unidad que contiene objetos que manejan ciertas estructuras de datos.      }
{ Las que actualmente se encuentran en esta unidad son las siguientes:       }
{      - Objeto HEAP.                                                        }
{      - Objeto COLA                                                         }
{      - Objeto FIFO.                                                        }
{      - Objeto CONJUNTO.                                                    }
{                                                                            }
{ REFERENCIAS: consultar la secci¢n XII del "Manual del PSOO" para mayores   }
{ detalles.                                                                  }
{ NOTA: Las estructuras puestas con þ no figuran en la mencionada referencia }

INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }

const
  MedidaHeap  =1000; { m xima cantidad de elementos que puede manejar el heap }

type

  PtrColaFifo    =^ObjFifo;         { punt. cola FIFO.    }
  PtrColaLifo    =^ObjLifo;         { punt. cola LIFO.    }

  TipoNodoHeap=record               { formato del reg.    }
                 obj:pointer;       { del nodo del HEAP   }
                 tiempo:real;
               end;

  ObjLifo=object              { Clase dotada para el manejo de una pila de   }
                              { objetos (pila de punteros).                  }
    V,                        { Puntero al vector din mico de punteros       }
    ultimo:pointer;           { puntero a la pr¢xima entrada libre para in-  }
                              { gresar un nuevo elemento a la cola.          }
    CantElem:word;            { cantidad de elementos actual en el vector.   }
    FacAmpl :real;            { factor de ampliaci¢n del vector din mico.    }

    constructor iniciar(TamMinCola:word;FactorAmpl:real);
    constructor inic;
    procedure   poner(Obj:pointer);
    function    sacar:pointer;
    function    primero:pointer;
    function    vacia  :boolean;
    destructor  borrar;
    private
    procedure   ErrorLlena;                virtual;
    procedure   ErrorVacia;                virtual;
    procedure   ErrorTamMin(TamMin:word);  virtual;
    procedure   ErrorFacAmpl(Factor:real); virtual;
  end;

  ObjFifo=object(ObjLifo)     { Subclase de cola (cola LIFO). Contiene la    }
                              { estructura y los mensajes necesarios para el }
                              { manejo de una cola FIFO.                     }

    primer:pointer;           { direcci¢n al primer elemento de la cola }

    constructor iniciar(TamMinCola:word;FactorAmpl:real);
    constructor inic;
    function    sacar:pointer;
    function    primero:pointer;
    private
    procedure   ErrorLlena;                virtual;
    procedure   ErrorVacia;                virtual;
    procedure   ErrorTamMin(TamMin:word);  virtual;
    procedure   ErrorFacAmpl(Factor:real); virtual;
    end;

  ObjConj=object(ObjLifo)  { Objeto CONJUNTO que coloca elementos en una    }
                           { cola LIFO heredada.                            }

    procedure   sacar(obj:pointer);
    function    SacarUltimo:pointer;
    function    pertenece(obj:pointer):boolean;
    function    vacio  :boolean;
    private
    procedure   ErrorLlena;                virtual;
    procedure   ErrorVacia;                virtual;
    procedure   ErrorNoEncontrado;         virtual;
    procedure   ErrorTamMin(TamMin:word);  virtual;
    procedure   ErrorFacAmpl(Factor:real); virtual;
  end;

  ObjHeap=object  { Objeto HEAP contiene los mensajes y estructuras necesa-  }
                  { rias para el manejo de un heap.                          }
                  { Tiene incorporado adem s un mensaje de visualizaci¢n que }
                  { permite presentar por pantalla el  rbol del heap.        }

    ultimo:integer;     { indica la cantidad de elementos que tiene el heap. }
    heap:array[0..MedidaHeap] of TipoNodoHeap; { lugar donde se almacena el  }
                                               { el heap.                    }

    constructor Iniciar;
    procedure poner(r:real;datos:pointer);
    procedure sacar(var r:real;var datos:pointer);
    function  vacio:Boolean;
    function  AlturaHeap(raiz:integer):integer;
    procedure ImpArbol(raiz,x,y:integer);
  end;

IMPLEMENTATION
{ Descripci¢n de los mensajes de los distintos objetos que componen esta     }
{ unidad.                                                                    }

uses crt;

{----------------------------------------------------------------------------}
{----------------------------- EL OBJETO HEAP -------------------------------}
{----------------------------------------------------------------------------}

{----------------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---H-E-A-P-----------------}

constructor ObjHeap.Iniciar;
{ INICIAR arranca el objeto HEAP con las estructuras vacias. }

begin
  heap[0].tiempo:=-1e37; { se asigna un -ì a la posici¢n 0 del heap. }
  ultimo:=0;             { no hay elementos en el heap.              }
end;

{-----------P-O-N-E-R---U-N---E-L-E-M-E-N-T-O---E-N---E-L---H-E-A-P----------}

procedure ObjHeap.poner;
{ PONE un elemento en el HEAP siempre y cuando no se haya desbordado su /// }
{ capacidad.                                                                }

var
  padre,         { ubicaci¢n del padre de un elemento. }
  expl:integer;  { explorador del array "heap".        }{ oficia de hijo }

begin
  if ultimo>MedidaHeap then exit; { si la capacidad se supera me voy }
  inc(ultimo);                    { un elemento mas }
  expl:=ultimo;
  padre:=expl div 2;              { padre de "expl" }
  while r < heap[padre].tiempo do         { busco el padre de "r".   }
    begin
      heap[expl]:=heap[padre];            { desplazo los contenidos. }
      expl:=padre;                        { avanzo a un nivel ...    }
      padre:=padre div 2;                 { ... superior.            }
    end;
  heap[expl].tiempo:=r;                   { pongo "r" como hijo de   }
  heap[expl].obj   :=datos;               { la variable "padre".     }
end;

{-----E-L-I-M-I-N-A-R---E-L---E-L-E-M-E-N-T-O---R-A-I-Z---D-E-L---H-E-A-P----}

procedure  ObjHeap.Sacar;
{ SACAR el elemento raiz del  rbol del heap ( que en realidad es un array ). }

var
  expl,      { explorador del array "heap".        }{ oficia de padre. }
  HijoIzq,   { hijo izquierdo de un elemento dado. }
  u:integer; { auxiliar que resguarda por un momento la cant. de elementos. }

begin
  r  :=heap[1].tiempo;  { cargo el registro ra¡z en "r". }
  datos:=heap[1].obj;   { Pero ahora se debe producir un }
                        { levantamiento de los otros reg.}
                        { para cubrir el "hueco" dejado  }
                        { por el nodo ra¡z.              }

  expl:=1;HijoIzq:=2*expl;
  while HijoIzq<ultimo do { levanto los elementos. }
    begin
      if (heap[HijoIzq].tiempo<heap[HijoIzq+1].tiempo) then
        begin
          heap[expl]:=heap[HijoIzq];
          expl:=HijoIzq;
        end
      else
        begin
          heap[expl]:=heap[HijoIzq+1];
          expl:=HijoIzq+1;
        end;
      HijoIzq:=2*expl;
    end;
  dec(expl);
  if ultimo=0 then exit;
  u:=ultimo;
  ultimo:=expl;
  poner(heap[u].tiempo,heap[u].obj);
  ultimo:=u;
  dec(ultimo);
end;

{--------------------¨-E-L---H-E-A-P---E-S-T-A---V-A-C-I-O-?-----------------}

function ObjHeap.vacio:boolean;
{ VACIO contesta al programa llamador si el heap no contiene elementos. }

begin
  vacio:=ultimo=0; { verdadero si no hay elementos en el heap. }
end;

{--------------A-L-T-U-R-A---D-E-L---A-R-B-O-L---D-E-L---H-E-A-P-------------}

function ObjHeap.AlturaHeap;
{ ALTURAHEAP entrega la altura que alcanza un sub-arbol del HEAP desde un // }
{ nodo "ra¡z" en particular.                                                 }
{ NOTA: el c lculo de altura en realidad regresa de este mensaje incrementa- }
{ do en 1 (uno). si el  rbol est  vac¡o regresa altura 1.                    }

begin
  if raiz>ultimo then AlturaHeap:=1
                 else AlturaHeap:=AlturaHeap(raiz*2)+1;

end;

{--------------I-M-P-R-E-S-O-R---G-R-A-F-I-C-O---D-E-L---H-E-A-P-------------}

procedure ObjHeap.ImpArbol(raiz,x,y:integer);
{ IMPARBOL imprime un sub-arbol del HEAP desde un elemento "ra¡z" a partir de }
{ la posici¢n (X,Y) en la pantalla de video.                                  }

var
  HijoIzq,dif:integer;

procedure ConectaNodos(x,y,Yh:integer);  {---UNE-CON-DOBLE-LINEA-DOS-NODOS---}
var                                      {  (X,Y): posici¢n en pantalla del  }
  i:integer;                             {         del nodo padre....        }
                                         {    Yh : columna del nodo hijo...  }
begin
  highvideo;
  x:=x+1;
  gotoxy(y,x);
  if Yh<y then
    begin
      write('¼');
      gotoxy(Yh,x);write('É');
      for i:=Yh+1 to y-1 do write('Í');
    end
  else
    begin
      write('Ê');
      gotoxy(Yh,x);write('»');
      gotoxy(y+1,x);
      for i:=Y+1 to Yh-1 do write('Í');
    end;
  lowvideo;
end;


begin
  if raiz>ultimo then exit;
  dif:=trunc(exp(ln(2)*(AlturaHeap(raiz)-2)));

  gotoxy(y-1,x);
  highvideo;
  textcolor(black);
  textbackground(white);
  write(heap[raiz].tiempo:3:0);
  textcolor(white);
  textbackground(black);
  lowvideo;

  HijoIzq:=2*raiz;
  if HijoIzq  <=ultimo then
    begin
      ImpArbol(HijoIzq  ,x+2,y-dif);
      ConectaNodos(x,y,y-dif);
    end;
  if HijoIzq+1<=ultimo then
    begin
      ImpArbol(HijoIzq+1,x+2,y+dif);
      ConectaNodos(x,y,y+dif);
    end;
end;


{----------------------------------------------------------------------------}
{---------------------------- EL OBJETO COLA-LIFO ---------------------------}
{----------------------------------------------------------------------------}

{----------------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---C-O-L-A-----------------}

constructor ObjLifo.iniciar(TamMinCola:word;FactorAmpl:real);
{ INICIAR crea la estructura de cola poni‚ndola vac¡a. }

begin
  if (TamMinCola>16382) or (TamMinCola<1) then ErrorTamMin(TamMinCola);
                                 { testear tama¤o m¡nimo del vector din mico }
  if (FactorAmpl<1) or (FactorAmpl>100) then ErrorFacAmpl(FactorAmpl);
                                 { testear factor de aumento del vec. din.   }

  FacAmpl:=FactorAmpl;

  getmem(v,(TamMinCola+1)*4);     { pedir bloque para el vector din mico }
  asm
    push ds
    lds si,[self]

    mov word ptr ds:[si+CantElem],0
    mov cx,TamMinCola

    les di,ds:[si + v]      { es:di= primer elemento del vector din mico }
    mov word ptr ds:[si+ultimo],di
    mov word ptr ds:[si+ultimo+2],es
    mov ax,0fffeh

@1:   inc di
      inc di
      mov es:[di],ax
      inc di
      inc di
    loop @1

    inc ax
    mov es:[di+2],ax

    pop ds
  end;
end;

{--------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---C-O-L-A---(-R-A-P-I-D-O-)-------}

constructor ObjLifo.inic;
{ INICIAR crea la estructura de cola poni‚ndola vac¡a. La diferencia con el  }
{ anterior m‚todo recide en que asigna valores por defecto al tama¤o del //  }
{ vector din mico y a su factor de ampliaci¢n.                               }

begin
  ObjLifo.iniciar(5,1.50);
end;

{-----------P-O-N-E-R---U-N---E-L-E-M-E-N-T-O---E-N---L-A---C-O-L-A----------}

procedure ObjLifo.poner(obj:pointer);
{ PONER ubica el "obj" en el tope de la cola. }

label sigo;

begin
  asm
    push ds
    lds si,[self]

    les di,ds:[si+ultimo]
    mov ax,es:[di+2]
    cmp ax,0ffffh      { comparo si es fin del buffer del vector }
    jnz @1             {   si no es el fin, sigo tranquilo ....  }
      les di,ds:[si+v] { ds:si= primer elemento del vector din mico }
      mov ax,es:[di+2]

@1: cmp ax,0fffeh      { comparo si no hay lugar en el vector    }
    jz sigo            {   si hay lugar, pongo el objeto ....    }

      pop ds
      end;
      ErrorLLena;
      asm
      push ds
      lds si,[self]
      les di,ds:[si+ultimo]
      end;
sigo: asm

    lds si,obj  { ds:si= puntero al OBJ }
    mov es:[di],si
    inc di
    inc di
    mov es:[di],ds
    inc di
    inc di

    lds si,[self]
    mov word ptr ds:[si+ultimo],di
    inc word ptr ds:[si+CantElem]

    pop ds

  end;
end;

{-E-L-I-M-I-N-A-R---E-L---U-L-T-I-M-O---E-L-E-M-E-N-T-O---D-E---L-A---C-O-L-A-}

function ObjLifo.sacar:pointer;
{ SACAR debuelve el puntero al £ltimo elemento que se a¤adi¢ a la cola.      }
{ Luego lo extrae de la misma.                                               }

label sigo;

begin
  asm
    push ds
    lds si,[self]

    cmp word ptr ds:[si+CantElem],0
    jnz sigo
      pop ds
      end;
      ErrorVacia;
sigo: asm
    les di,ds:[si+ultimo]    { es:di= siguiente posici¢n al £ltimo ele- }
                             { mento del vector din mico.               }
    dec di
    dec di
    mov dx,es:[di]
    mov ax,0fffeh
    mov es:[di],ax
    dec di
    dec di
    mov ax,es:[di]

    mov word ptr ds:[si+ultimo],di
    dec word ptr ds:[si+CantElem]

    pop ds
    mov word ptr @result,ax
    mov word ptr @result+2,dx

  end;
end;

{--O-B-T-E-N-E-R---E-L---U-L-T-I-M-O---E-L-E-M-E-N-T-O---D-E---L-A---C-O-L-A-}

function ObjLifo.primero;
{ PRIMERO debuelve el puntero al £ltimo elemento que se a¤adi¢ a la cola.    }

label sigo;

begin
  asm
    push ds
    lds si,[self]

    cmp word ptr ds:[si+CantElem],0
    jnz sigo
      pop ds
      end;
      ErrorVacia;
sigo: asm
    les di,ds:[si+ultimo]    { es:di= siguiente posici¢n al £ltimo ele- }
                             { mento del vector din mico                }
    mov dx,es:[di-2]
    mov ax,es:[di-4]

    pop ds
    mov word ptr @result,ax
    mov word ptr @result+2,dx

  end;

end;

{--------------------¨-L-A---C-O-L-A---E-S-T-A---V-A-C-I-A-?-----------------}

function ObjLifo.vacia:boolean;
{ VACIA debuelve verdad si la cola est  vac¡a. }

begin
  vacia:=CantElem=0;
end;

                   {---------------------------------------}
procedure  ObjLifo.ErrorLlena;
var
  aux:pointer;     { puntero auxiliar de prop¢sitos generales }
  NuevoTam:word;   { nuevo tama¤o del vector din mico         }
begin

  NuevoTam:=trunc(CantElem*FacAmpl)+2;       {   nuevo tama¤o    }
  if  NuevoTam>16382 then
    begin
      writeln('*** ERROR: la cola LIFO se ha desbordado... ');
      halt;
    end;

  GetMem(aux, NuevoTam*4);                   { pido nuevo vector }
  asm
    push ds
    lds si,[self]

    mov cx,ds:[si+CantElem]  {}
    mov dx,cx                {}{ cx= cantidad de elementos del vector viejo }
    shl cx,1                 {}

    les si,ds:[si+v]         { es:si= puntero al inicio del vector viejo }
    lds di,aux               { es:di= puntero al inicio del vector nuevo }

@CopioOtro:                  {}
      mov ax,es:[si]         {}
      mov ds:[di],ax         {}
      inc si                 {}{ copiar vector viejo en el nuevo }
      inc si                 {}
      inc di                 {}
      inc di                 {}
    loop @CopioOtro          {}

    mov ax,0fffeh
    mov cx,NuevoTam          {}
    sub cx,dx                {}{cx= exedente del TamNuevo - TamViejo }

@LlenarOtro:                 {}
      inc di                 {}
      inc di                 {}
      mov ds:[di],ax         {}{ marca exedente del vector nuevo como vac¡o }
      inc di                 {}
      inc di                 {}
    loop @LLenarOtro         {}

    inc ax                   {}
    mov ds:[di-2],ax         {}{ marca el final del vector nuevo }
                             {}
    pop ds
  end;

  FreeMem(v,(CantElem+1)*4);          { liberar memoria del vector viejo }
  v:=aux;                                       { actualiza los punteros }
  ultimo:=Ptr(seg(v^),ofs(v^) + CantElem*4);    {   al vector din mico   }

end;

                   {---------------------------------------}
procedure  ObjLifo.ErrorVacia;
begin
  writeln('*** ERROR: la cola LIFO est  vac¡a...');
  halt;
end;

                   {---------------------------------------}
destructor ObjLifo.borrar;
{ BORRAR elimina las estructuras internas de la cola. }

var
  TamCola:word;

begin
  asm
    push ds
    lds si,[self]

    les di,ds:[si+v] { es:di= direcci¢n del primer lugar del buffer din mico }
    mov ax,0ffffh
    mov cx,1

@1: inc di
    inc di
    cmp ax,es:[di]
    jz @2
    inc cx
    inc di
    inc di
    jmp @1

@2: mov word ptr TamCola,cx

    pop ds
  end;
  FreeMem(v,TamCola*4);
end;

                   {---------------------------------------}

procedure   ObjLifo.ErrorTamMin(TamMin:word);
begin
  writeln('*** ERROR: el tama¤o m¡nimo especificado para la cola LIFO es');
  writeln('           incorrecto: ',TamMin,' (1..16382)');
  halt;
end;

                   {---------------------------------------}

procedure   ObjLifo.ErrorFacAmpl(Factor:real);
begin
  writeln('*** ERROR: el factor de amplificaci¢n especificado para ');
  writeln('           el vector din mico de la cola LIFO es incorrecto:');
  writeln('           ',Factor:5:2,' (1..100 veces)');
  halt;
end;

{----------------------------------------------------------------------------}
{---------------------------- EL OBJETO COLA-FIFO ---------------------------}
{----------------------------------------------------------------------------}

{----------------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---C-O-L-A-----------------}

constructor ObjFifo.Iniciar(TamMinCola:word;FactorAmpl:real);
{ INICIAR arranca el objeto COLAFIFO con las estructuras vac¡as. }

begin
  ObjLifo.iniciar(TamMinCola,FactorAmpl);
  primer:=ultimo;
end;

{--------I-N-I-C-I-A-R---E-L---O-B-J-E-T-O---C-O-L-A---(-R-A-P-I-D-O-)-------}

constructor ObjFifo.inic;
{ INICIAR crea la estructura de cola poni‚ndola vac¡a. La diferencia con el  }
{ anterior m‚todo recide en que asigna valores por defecto al tama¤o del //  }
{ vector din mico y a su factor de ampliaci¢n.                               }

begin
  ObjFifo.iniciar(5,1.50);
end;

{-E-L-I-M-I-N-A-R---E-L---P-R-I-M-E-R---E-L-E-M-E-N-T-O---D-E---L-A---C-O-L-A-}

function ObjFifo.sacar:pointer;
{ SACAR debuelve el primer elemento que lleg¢ a la cola, extrall‚ndolo. }

label sigo;

begin
  asm
    push ds
    lds si,[self]

    cmp word ptr ds:[si+CantElem],0
    jnz sigo
      pop ds
      end;
      ErrorVacia;
sigo: asm
    les di, ds:[si+primer]     { es:di= primera posici¢n del vector din mica }
    mov dx,es:[di+2]
    cmp dx,0ffffh
    jnz @2
      les di,ds:[si+v]
      mov dx,es:[di+2]
@2: mov ax,es:[di]
    inc di
    inc di
    mov bx,0fffeh
    mov es:[di],bx
    inc di
    inc di
    mov word ptr ds:[si+primer],di
    dec word ptr ds:[si+CantElem]

    pop ds
    mov word ptr @result,ax
    mov word ptr @result+2,dx

  end;
end;

{--O-B-T-E-N-E-R---E-L---P-R-I-M-E-R---E-L-E-M-E-N-T-O---D-E---L-A---C-O-L-A-}

function ObjFifo.primero;
{ PRIMERO retorna el puntero al primer elemento de la cola. }

label sigo;

begin
  asm
    push ds
    lds si,[self]

    cmp word ptr ds:[si+CantElem],0
    jnz sigo
      pop ds
      end;
      ErrorVacia;
sigo: asm
    les di,ds:[si+primer]      { es:di= primera posici¢n del vector din mico }
    mov dx,es:[di+2]
    cmp dx,0ffffh
    jnz @1
      les di,ds:[si+v]
      mov dx,es:[di+2]
@1: mov ax,es:[di]

    pop ds
    mov word ptr @result,ax
    mov word ptr @result+2,dx
  end;
end;

                   {---------------------------------------}
procedure  ObjFifo.ErrorLlena;
var
  aux,             { punteros auxiliares de prop¢sitos }
  aux2:pointer;    { generales.                        }
  TamBlq1,         { tama¤o del bloque auxiliar 1 }
  TamBlq2:word;    { tama¤o del bloque auxiliar 2 }
  NuevoTam:word;   { nuevo tama¤o del vector din mico  }

begin
  NuevoTam:=trunc(CantElem*FacAmpl)+2;       {   nuevo tama¤o    }
  if NuevoTam>16382 then
    begin
      writeln('*** ERROR: la cola FIFO se ha desbordado... ');
      halt;
    end;

  GetMem(aux, NuevoTam*4);                   { pido nuevo vector }

  if primer=v then             { determino tama¤o y localizaci¢n }
    begin                      { de los bloques del vector din - }
      TamBlq1:=cantElem*4;     { mico seg£n la ubicaci¢n de los  }
      TamBlq2:=0;              { punteros "primer" y "£ltimo".   }
      aux2:=nil;
    end
  else
    begin
      TamBlq1:=cantElem*4-ofs(primer^)+ofs(v^);
      TamBlq2:=ofs(ultimo^)-ofs(v^);
      aux2:=ptr(seg(aux^),ofs(aux^)+TamBlq1);
    end;

  asm
{-- BLQ 1 --}

    push ds
    lds si,[self]

    mov cx,TamBlq1           { cx=cantidad de words del bloque 1 }
    shr cx,1
    mov dx,cx                { guardo en dx la cantidad de elementos }
    shr dx,1

    cmp cx,0                 { si bloque 1 no tiene elementos ...    }
    jz @Blq2

      les si,ds:[si+primer]    { es:si= puntero al inicio del bloque 1 }
      lds di,aux               { es:di= puntero al inicio del vector nuevo }

@CopioOtro:                    {}
        mov ax,es:[si]         {}
        mov ds:[di],ax         {}
        inc si                 {}{ copiar bloque 1 viejo en el nuevo vector }
        inc si                 {}
        inc di                 {}
        inc di                 {}
      loop @CopioOtro          {}

{-- BLQ 2 --}
@Blq2:
    mov cx,TamBlq2           { cx=cantidad de words del bloque 2 }
    shr cx,1
    mov bx,cx              {}
    shr bx,1               {}{ guardo en dx la cantidad de elementos totales }
    add dx,bx              {}

    cmp cx,0                 { si bloque 2 no tiene elementos ...    }
    jz @NoCopioBlq2

      lds si,[self]

      les si,ds:[si+v]         { es:si= puntero al inicio del bloque 2 }
      lds di,aux2              { es:di= puntero al inicio del vector nuevo }

@CopioOtro2:                   {}
        mov ax,es:[si]         {}
        mov ds:[di],ax         {}
        inc si                 {}{ copiar bloque 2 viejo en el nuevo vector }
        inc si                 {}
        inc di                 {}
        inc di                 {}
      loop @CopioOtro2         {}

@NoCopioBlq2:                { ... saltear copia del bloque 2 y ... }
                             { ... marcar como disponibles las entradas }
                             { restantes del nuevo vector din mico. }
    mov ax,0fffeh
    mov cx,NuevoTam          {}
    sub cx,dx                {}{cx= exedente del TamNuevo - TamViejo }

@LlenarOtro:                 {}
      inc di                 {}
      inc di                 {}
      mov ds:[di],ax         {}{ marca exedente del vector nuevo como vac¡o }
      inc di                 {}
      inc di                 {}
    loop @LLenarOtro         {}

    inc ax                   {}
    mov ds:[di-2],ax         {}{ marca el final del vector nuevo }
                             {}
    pop ds
  end;

  FreeMem(v,(CantElem+1)*4);          { liberar memoria del vector viejo }
  v:=aux; primer:=v;                            { actualiza los punteros }
  ultimo:=Ptr(seg(v^),ofs(v^) + CantElem*4);    {   al vector din mico   }

end;

                   {---------------------------------------}
procedure ObjFifo.ErrorVacia;
begin
  writeln('*** ERROR: la cola FIFO est  vac¡a... ');
  halt;
end;

                   {---------------------------------------}

procedure   ObjFifo.ErrorTamMin(TamMin:word);
begin
  writeln('*** ERROR: el tama¤o m¡nimo especificado para la cola FIFO es');
  writeln('           incorrecto: ',TamMin,' (1..16382)');
  halt;
end;

                   {---------------------------------------}

procedure   ObjFifo.ErrorFacAmpl(Factor:real);
begin
  writeln('*** ERROR: el factor de amplificaci¢n especificado para ');
  writeln('           el vector din mico de la cola FIFO es incorrecto:');
  writeln('           ',Factor:5:2,' (1..100 veces)');
  halt;
end;

{----------------------------------------------------------------------------}
{---------------------------- EL OBJETO CONJUNTO ----------------------------}
{----------------------------------------------------------------------------}

{--S-A-C-A-R---U-N---C-I-E-R-T-O---E-L-E-M-E-N-T-O---D-E-L---C-O-N-J-U-N-T-O-}

procedure ObjConj.sacar;
{ SACAR un cierto "obj" que pertenece al conjunto. }

label sigo,sigo2;

begin
  asm
    push ds
    lds si,obj               {}
    mov bx,si                { dx:bx puntero al OBJ }
    mov dx,ds                {}

    lds si,[self]

    mov cx,ds:[si+CantElem]
    cmp cx,0
    jnz sigo
      pop ds
      end;
      ErrorVacia;
sigo: asm
    les di,ds:[si+V]         { es:di= primer elemento del vector din mico }

@3:   mov ax,es:[di]
      inc di
      inc di
      cmp ax,bx              { comparo parte baja del puntero }
      jnz @2                 {   si no son iguales, siguiente elemento }
      mov ax,es:[di]
      cmp ax,dx              { comparo parte alta del puntero }
      jz sigo2               {   si coinciden, saco elemento .... }
@2:   inc di
      inc di
    loop @3
    pop ds
    end;
    ErrorNoEncontrado;
sigo2:asm

    inc di
    inc di
@5: dec cx
    cmp cx,0                 { comparo si hay elementos todav¡a   }
    jz @6                    {   si no hay elementos, termino ... }
      mov ax,es:[di]
      mov es:[di-4],ax
      inc di
      inc di
      mov ax,es:[di]
      mov es:[di-4],ax
      inc di
      inc di
    jmp @5

@6: dec di
    dec di
    mov ax,0fffeh
    mov es:[di],ax
    dec di
    dec di
    mov word ptr ds:[si+ultimo],di
    dec word ptr ds:[si+CantElem]

    pop ds
  end;
end;

{------S-A-C-A-R---U-T-I-M-O---E-L-E-M-E-N-T-O---D-E-L---C-O-N-J-U-N-T-O-----}

function  ObjConj.SacarUltimo:pointer;
{ SACARULTIMO retorna el puntero al £ltimo elemento que se agreg¢ al conj.   }
{ Adem s lo elimina del mismo.                                               }

begin
  SacarUltimo:=ObjLifo.sacar;
end;

{----------¨-P-E-R-T-E-N-E-C-E---"O-B-J"---A-L---C-O-N-J-U-N-T-O-?-----------}

function   ObjConj.pertenece;
{ PERTENECE informa al programa que lo llam¢ si un cierto objeto î CONJ. }

label sigo,exit;

begin
  asm
    push ds
    lds si,obj
    mov bx,si
    mov dx,ds

    lds si,[self]

    mov cx,ds:[si+CantElem]
    cmp cx,0
    jnz sigo
      pop ds
      end;
      ErrorVacia;
sigo: asm
    les di,ds:[si+v]         { es:di= primer elemento del vector din mico }

@3:   mov ax,es:[di]
      inc di
      inc di
      cmp ax,bx              { comparo parte baja del puntero }
      jnz @2                 {   si no son iguales, siguiente elemento }
      mov ax,es:[di]
      cmp ax,dx              { comparo parte alta del puntero }
      jz @4                  {   si coinciden, saco elemento .... }
@2:   inc di
      inc di
    loop @3

    pop ds
    mov @result,false
    jmp exit
@4: pop ds
    mov @result,true
  end;
exit:
end;

{---------------¨-E-L----C-O-N-J-U-N-T-O---E-S-T-A---V-A-C-I-O-?-------------}

function ObjConj.vacio;
{ VACIO debuelve verdad si el conjunto est  vac¡o. }

begin
  vacio:=CantElem=0;
end;

                   {---------------------------------------}
procedure  ObjConj.ErrorLlena;
var
  aux:pointer;     { puntero auxiliar de prop¢sitos generales }
  NuevoTam:word;   { nuevo tama¤o del vector din mico         }
begin

  NuevoTam:=trunc(CantElem*FacAmpl)+2;       {   nuevo tama¤o    }
  if  NuevoTam>16382 then
    begin
      writeln('*** ERROR: un conjunto se ha desbordado... ');
      halt;
    end;

  GetMem(aux, NuevoTam*4);                   { pido nuevo vector }
  asm
    push ds
    lds si,[self]

    mov cx,ds:[si+CantElem]  {}
    mov dx,cx                {}{ cx= cantidad de elementos del vector viejo }
    shl cx,1                 {}

    les si,ds:[si+v]         { es:si= puntero al inicio del vector viejo }
    lds di,aux               { es:di= puntero al inicio del vector nuevo }

@CopioOtro:                  {}
      mov ax,es:[si]         {}
      mov ds:[di],ax         {}
      inc si                 {}{ copiar vector viejo en el nuevo }
      inc si                 {}
      inc di                 {}
      inc di                 {}
    loop @CopioOtro          {}

    mov ax,0fffeh
    mov cx,NuevoTam          {}
    sub cx,dx                {}{cx= exedente del TamNuevo - TamViejo }

@LlenarOtro:                 {}
      inc di                 {}
      inc di                 {}
      mov ds:[di],ax         {}{ marca exedente del vector nuevo como vac¡o }
      inc di                 {}
      inc di                 {}
    loop @LLenarOtro         {}

    inc ax                   {}
    mov ds:[di-2],ax         {}{ marca el final del vector nuevo }
                             {}
    pop ds
  end;

  FreeMem(v,(CantElem+1)*4);          { liberar memoria del vector viejo }
  v:=aux;                                       { actualiza los punteros }
  ultimo:=Ptr(seg(v^),ofs(v^) + CantElem*4);    {   al vector din mico   }

end;

                   {---------------------------------------}
procedure ObjConj.ErrorVacia;
begin
  writeln('*** ERROR: el conjunto esta vac¡o... ');
  halt;
end;

                   {---------------------------------------}
procedure ObjConj.ErrorNoEncontrado;
begin
  writeln('*** ERROR: el elemento que se intenta sacar del conj. no existe... '
         );
  halt;
end;

                   {---------------------------------------}

procedure   ObjConj.ErrorTamMin(TamMin:word);
begin
  writeln('*** ERROR: el tama¤o m¡nimo especificado para el CONJUNTO es');
  writeln('           incorrecto: ',TamMin,' (1..16382)');
  halt;
end;

                   {---------------------------------------}

procedure   ObjConj.ErrorFacAmpl(Factor:real);
begin
  writeln('*** ERROR: el factor de amplificaci¢n especificado para ');
  writeln('           el vector din mico del CONJUNTO es incorrecto:');
  writeln('           ',Factor:5:2,' (1..100 veces)');
  halt;
end;

END.