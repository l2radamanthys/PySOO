UNIT corrut;
{ Unidad que provee las funciones necesarias para la implementaci¢n de corru-}
{ tinas en TP6. Dichas funciones se inspiran de las que posee TC++ :         }
{ SetJmp y LongJmp.                                                          }
{                                                                            }
{ REFERENCIAS: consultar la secci¢n *** del "Manual del PSOO" para mayores   }
{ detalles.                                                                  }


INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }

var
  BasePila:word;    { base del stack a partir de la cual se almacena la pila }
  TamMinBuffDin:word;  { tama¤o del vector del gestor din mico especializado }

procedure IniciarCorrutinas(Pila,TamDin:word;FactorAumento:real); {  inicia  }
                                                      { gestor de corrutinas }
function SetJmp (var p:pointer):integer;    { guarda el contenido de la pila }
function LongJmp(var p:pointer; i:integer):integer;  { restaura su contenido }

IMPLEMENTATION
{ Las declaraciones que se realicen en este p rrafo no ser n accesibles al   }
{ programa que utilice esta unidad.                                          }

uses GestDin;

{----------------------------------------------------------------------------}
{-------------   E L   G E S T O R   D E   C O R R U T I N A S   ------------}
{----------------------------------------------------------------------------}

{----------------I-N-I-C-I-A-R---L-A-S---C-O-R-R-U-T-I-N-A-S-----------------}

procedure IniciarCorrutinas(Pila,TamDin:word;FactorAumento:real);
{ Inicia las estructuras que utiliza el gestor.                              }

begin
  BasePila:=Pila;
  TamMinBuffDin:=TamDin;
  IniciarGestorDinamico(TamMinBuffDin,FactorAumento);
end;

{------------------------------S-E-T---J-A-M-P-------------------------------}

function  SetJmp (var p:pointer):integer;
{ Almacena el contenido de la pila desde la base indicada hasta el procedi-  }
{ miento llamador de SetJmp en el heap del TP6, retorna la direcci¢n donde se}
{ encuentra dicha informaci¢n en "p". Retorna adem s el valor 0.             }

begin
  asm
    mov ax,BasePila
    sub ax,bp
    dec ax                { ax=tama¤o del resguardo de pila }
    push ax

    les di,p
    push ax
    push es
    push di

    call ObtenerMemoria   { pedir "ax" bytes de memoria  }

    mov es,dx             { es:di= direcci¢n del bloque de  }
    mov di,ax             { memoria pedido al heap del TP6  }
    pop ax                { ax=tama¤o del resguardo de pila }
    mov es:[di],ax        { almacenar en bloque el tama¤o   }
    inc di
    inc di

    push ss               { ds:si= direcci¢n de la cima de  }
    pop ds                { del stack del TP6.              }
    mov si,bp
    mov cx,6              { copiar BP y CS:IP de la rutina  }
                          { que llama a SetJmp en bloque    }
    cld
    rep movsb

    add si,4              { copiar el contenido de la pila  }
    mov cx,ax             { en el bloque del heap           }
    sub cx,8

    cld
    rep movsb

    mov ax,Seg @data      { restaurar el segmento de dato   }
    mov ds,ax             { del TP6.                        }
    mov ax,0              { retornar como resultado de Set- }
    mov @result,ax        { Jmp un cero (0)                 }
  end;
end;

{------------------------------L-O-N-G---J-A-M-P-----------------------------}

function LongJmp(var p:pointer;i:integer):integer;
{ Pone en el stack a partir de la base prefijada la informaci¢n contenida en }
{ el bloque de memoria apuntado por "p" que se encuentra en el heap del TP6. }
{ Regresa el control al programa que se estaba ejecutando cuando se realizo  }
{ el SetJmp correspondiente, regres ndole como valor "i" ( si i=0 regresa 1 )}

begin
  asm
    mov ax,i              { preparar retorno de "i" (<> 0)    }
    cmp ax,0
    jnz @1
    inc ax
@1:                       { comenzar tarea de restauraci¢n de }
                          { pila (stack) del TP6              }

    push ss               { es:di=direcci¢n de la base de la  }
    pop es                { pila de TP6                       }
    mov di,BasePila

    lds si,p              { ds:si=direcci¢n del bloque de inf.}
    lds si,[si]           { de pila en el heap del TP6        }
    mov bx,si             { dx:bx = ds:si                     }
    mov dx,ds
    mov cx,[si]           { obtener en "cx" el tama¤o del bloque }
    sub di,cx             { es:di=direcci¢n del tope de la pila  }
    inc di                { del TP6.                             }
    mov sp,di             { actualizar SP al nuevo tope de pila  }

    cld                   { copiar bloque en pila (restaurar la  }
    rep movsb             { pila al estado de la llamada SetJmp) }

    pop cx                { obtener en "cx" el tama¤o del bloque }
    push ax               { guardar resultado de LongJmp         }
    mov ax,seg @data      { restaurar el segmento de dato del }
    mov ds,ax             { TP6                               }

    push cx               { poner en pila los par metros para }
    push dx               { la rutina LiberarMemoria:         }
    push bx               {   tama¤o bloque, direcci¢n bloque }
    call LiberarMemoria   { liberar del heap el bloque espec. }

    pop ax                { recuperar en "ax" el resultado.   }
    pop bp                { recuperar el BP del proc. llamador}
    retf                  { regresar al proceso llamador      }
  end;
end;

END.

