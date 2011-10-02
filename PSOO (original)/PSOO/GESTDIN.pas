UNIT GestDin;
{ La unidad provee herramientas que interceptan el manejo din mico de la /// }
{ memoria realizado por Turbo Pascal V6.0, logr ndo de esta manera aumentar  }
{ la rapidez del mismo.                                                      }
{    Cabe aclarar que no se trata de un manejador din mico con una sofisti-  }
{ cada pol¡tica de asignaci¢n, sino mas bien de uno simple.                  }
{    Esa simplesa lo hace r pido pero a su vez, aplicable con ‚xito solo a   }
{ un cierto caso bien definido para el cual fu‚ concebido:                   }
{    * El conjunto de todas las posibles medidas de bloques que se solicitan,}
{ debe ser finito y de pocos elementos.                                      }
{    * El manejo din mico debe ser intenso.                                  }
{                                                                            }
{    El manejador de corrutinas constituye un buen candidato para utilizar   }
{ este gestor, ya que encaja perfectamente en la situaci¢n que definimos.    }
{                                                                            }
{ REFERENCIAS: consultar la secci¢n *** del "Manual del PSOO" para mayores   }
{ detalles.                                                                  }


INTERFACE
{ Las declaraciones que se realicen en este p rrafo ser n accesibles al pro- }
{ grama que utilice esta unidad.                                             }

type
  Blq=record
        tam:word;
        PtrBlqLibre:pointer;
      end;

procedure IniciarGestorDinamico(TamDin:word;FactorAumento:real);
procedure ObtenerMemoria(i:word; var p:pointer);
procedure LiberarMemoria(i:word; p:pointer);
function  ErrorMemoLlena(tam:word):integer;

IMPLEMENTATION
{ Las declaraciones que se realicen en este p rrafo no ser n accesibles al   }
{ programa que utilice esta unidad.                                          }

uses printer;

var
    TamMinDin:word;       { tama¤o m¡nimo del vector del gestor din mico     }
    FactorAmpl:real;      { fator de amplificaci¢n del vector din mico.      }
    CantElem:word;        { cantidad de elementos con que cuenta actualmente }
                          { el vector din mico.                              }
    Linf,                 { apunta al primer elemento del vector             }
    Lsup:pointer;         { apunta a la siguiente entrada libre para agregar }
                          { un elemento.                                     }

procedure CorrLlena; forward;
procedure ErrorTamMin(TamMin:word); forward;

{----------------------------------------------------------------------------}

procedure MiGetMem(i:word);
{ Obtiene "i" bytes de la memoria din mica del TP6. La direcci¢n de la zona  }
{ otorgada se encuentra en los registros DX:AX.                              }

var
  p:pointer;
begin
  GetMem(p,i);
end;

{----------------------------------------------------------------------------}
{-----------------   E L   G E S T O R   D I N A M I C O   ------------------}
{----------------------------------------------------------------------------}

{----------------I-N-I-C-I-A-R---G-E-S-T-O-R---D-I-N-A-M-I-C-O---------------}

procedure IniciarGestorDinamico(TamDin:word;FactorAumento:real);
{ Inicia las estructuras que utiliza el gestor.                              }

begin
  if (TamDin>10922) or (TamDin<2) then ErrorTamMin(TamDin);
                                 { testear tama¤o m¡nimo del vector din mico }
  CantElem:=1;
  TamMinDin:=TamDin;
  FactorAmpl:=FactorAumento;
  getmem(Linf,(TamMinDin+1)*6);
  fillchar(Linf^,(TamMinDin+1)*6,0); { llenar vector con ceros }
  Lsup:=Linf;                    { puntero limite superior = inferior }
end;

{------------------------O-B-T-E-N-E-R---M-E-M-O-R-I-A-----------------------}

procedure ObtenerMemoria(i:word; var p:pointer);
{ Toma un block de "i" bytes del heap del TP6 y almacena su direcci¢n en "p".}
{ Utiliza su propio gestor de memoria din mica. Cuando dicho gestor fracasa  }
{ en la busqueda de un block adecuado, se utiliza el del TP6.                }
{   El trabajo coordinado de ambos gestores redunda en una mayor velocidad   }
{ de manipulaci¢n de la memoria din mica.                                    }

begin
  asm
    mov ax,i              { ax=tama¤o del block solicitado }
    push bp
    les si,Linf           { es:si=l¡mite inferior del vector del gestor }
    les di,Lsup           { es:di=l¡mite superior del vector del gestor }

@bucle:                   { ciclo de la busqueda binaria.               }
    cmp di,si
    jc @NuevoNodo
      push ax             {}
      mov dx,0            {}
      mov ax,di           {}
      sub ax,si           {}
      mov cx,12           {}
      div cx              { es:bp=punto medio del vector entre es:si y es:di }
      mov cx,6            {}
      mul cx              {}
      mov bp,si           {}
      add bp,ax           {}
      pop ax              {}

      cmp es:[bp],ax
      jnz @NoEs           { si el tama¤o del bloque coincide con el buscado..}
        mov dx,es:[bp+4]     { ... asignar un bloque libre del gestor }
        mov di,bp
        pop bp
        cmp dx,0
        jz @N_nodo           { si la asignaci¢n es posible ....              }
        push ds                 { ... efectuar la asignaci¢n y ...  }
        mov ax,es:[di+2]
        mov ds,dx
        mov si,ax
        mov bx,ds:[si]
        mov cx,ds:[si+2]
        mov es:[di+2],bx        { ... eliminar el bloque del gestor }
        mov es:[di+4],cx
        pop ds
        jmp @fin                { ir a FIN }

@NoEs:jc @EstaDer         { ... si el bloque es mas grande que el buscado ...}
        mov di,bp            { ... buscar por el lado izquierdo     }
        sub di,6
        jmp @bucle           { continuar la busqueda }
@EstaDer:                 { ... si es mas peque¤o ....                       }
        mov si,bp            { ... buscar por el lado derecho       }
        add si,6
        jmp @bucle           { continuar la busqueda }

@NuevoNodo:               { incorporo un bloque de nuevo tama¤o al gestor.   }
    pop bp

    mov dx,CantElem       {} 
    cmp dx,TamMinDin      {}
    jnz @sigo             {}
      push dx             {}
      push ax             {}
      les si,Linf         { es:si=l¡mite inferior del vector del gestor }
      sub di,si
      push di
      call Corrllena      {}
      pop di
      les si,Linf         { es:si=l¡mite inferior del vector del gestor }
      add di,si
      pop ax              {}
      pop dx              {}
                          {}
@sigo:                    {}
    inc dx                {}
    mov CantElem,dx       {}
    les si,Lsup           {}
    add si,4              { desplaza nodos hacia la derecha una posici¢n }
@arr:                     {}
    cmp di,si             {}
    jnc @termino          {}
      mov dx,es:[si]      {}
      mov es:[si+6],dx    {}
      dec si              {}
      dec si              {}
      jmp @arr            {}
@termino:                 {}
    les si,Lsup           {}
    add si,6              {}
    mov word ptr Lsup,si  {}

    add di,6              {}
    mov es:[ di ],ax          { incorpora una entrada bac¡a al vector del }
    mov word ptr es:[di+2],0  { manipulador de memoria din mica.          }
    mov word ptr es:[di+4],0  {}

@N_nodo:                  { ... si no es posible una asignaci¢n de memoria.. }
    push ax                  { ... pedir bloque al administrador de TP6 }
    call MiGetMem            {}
@fin:
    les di,p
    mov es:[di],ax
    mov es:[di+2],dx    
  end;
end;

{------------------------L-I-B-E-R-A-R---M-E-M-O-R-I-A-----------------------}

procedure LiberarMemoria(i:word; p:pointer);
{ Debuelve al gestor especial el bloque de "i" bytes apuntado por "p".       }
label fin;

begin
  asm
    mov ax,i              { ax=tama¤o del block solicitado }
    push bp
    les si,Linf           { es:si=l¡mite inferior del vector del gestor (1) }
    les di,Lsup           { es:di=l¡mite superior del vector del gestor }
@bucle:                   { ciclo de la busqueda binaria.               }
    cmp di,si
    jc @NoHayBloqueAsignado
      push ax             {}
      mov dx,0            {}
      mov ax,di           {}
      sub ax,si           {}
      mov cx,12           {}
      div cx              { es:bp=punto medio del vector entre es:si y es:di }
      mov cx,6            {}
      mul cx              {}
      mov bp,si           {}
      add bp,ax           {}
      pop ax              {}

      cmp es:[bp],ax
      jnz @NoEs           { si el tama¤o del bloque coincide con el buscado..}
        mov si,bp         {}
        pop bp            {}
        push ds           {}
        lds bx,p          {}
        mov ax,es:[si+2]  {}
        mov dx,es:[si+4]  {...incorpora el bloque a la lista de nodos libres }
        mov ds:[ bx ],ax  {}
        mov ds:[bx+2],dx  {}
        mov es:[si+2],bx  {}
        mov es:[si+4],ds  {}
        pop ds            {}
        jmp fin           { ir a FIN }
@NoEs:jc @EstaDer         { ... si el bloque es mas grande que el buscado ...}
        mov di,bp            { ... buscar por el lado izquierdo     }
        sub di,6
        jmp @bucle           { continuar la busqueda }
@EstaDer:                 { ... si es mas peque¤o ....                       }
        mov si,bp            { ... buscar por el lado derecho       }
        add si,6
        jmp @bucle           { continuar la busqueda }
@NoHayBloqueAsignado:
    pop bp
  end;

  freemem(p,i);

Fin:
end;

{----------------------------------------------------------------------------}

function  ErrorMemoLlena(tam:word):integer;
{ Esta funci¢n reemplaza durante la ejecuci¢n del programa, al manipulador de}
{ errores de la memoria din mica del TP6.                                    }
{ Ante una falla dememoria, realiza los siguientes pasos:                    }
{      - Intenta liberar la memoria din mica ocupada por la lista de bloques }
{        libres.                                                             }
{      - Si es posible, reintenta asignar la memoria repitiendo la petici¢n  }
{        al gestor din mico del PASCAL.                                      }
{      - Si no es posible emite el correspondiente error de memoria llena y  }
{        detiene la ejecuci¢n del programa que estaba corriendo.             }

var
  expl:pointer;     { puntero auxiliar usado a manera de ¡ndice }

procedure BorrarBlqLibres(cab:pointer;tam:word);
var
  expl,aux:pointer;

begin
  expl:=cab;
  while seg(pointer(expl^))<>0 do
    begin
      aux:=expl;
      expl:=pointer(expl^);
      freemem(aux,tam);
    end;
end;

begin
  if tam<>0 then
    begin
      expl:=Linf;
      while (expl<>Lsup) and (seg(Blq(Expl^).PtrBlqLibre)=0)  do
        expl:=Ptr(seg(expl^),ofs(expl^)+6);
      if expl<>Lsup then
        begin
          expl:=Linf;
          while expl<>Lsup do
            begin
              BorrarBlqLibres(Blq(Expl^).PtrBlqLibre,Blq(expl^).tam);
              Blq(expl^).PtrBlqLibre:=Ptr(0,0);
              expl:=Ptr(seg(expl^),ofs(expl^)+6);
            end;

          CantElem:=1;
          fillchar(Linf^,(TamMinDin+1)*6,0);      { llenar vector con ceros }
          Lsup:=Linf;                    { puntero l¡mite superior=inferior }

          ErrorMemoLlena:=2;
        end
      else
        begin
          writeln(' *** ERROR: la memoria din mica se ha desbordado...');
          writeln('            Posibles razones:');
          writeln('              - Demasiados objetos din micos en memoria.');
          writeln('              - Puntero(s) perdido(s) provoca(n) mal func.');
          writeln('              - Se pide m s memoria de la que se devuelve');
          halt;
        end;
    end
  else
        ErrorMemoLlena:=0;
end;

{----------------------------------------------------------------------------}

procedure CorrLLena;
var
  aux:pointer;     { puntero auxiliar de prop¢sitos generales }
  NuevoTam:word;   { nuevo tama¤o del vector din mico         }
begin
  NuevoTam:=trunc(CantElem*FactorAmpl);         {   nuevo tama¤o    }
  if NuevoTam>10922 then
    begin
      writeln('*** ERROR: administrador de corrutinas sobrecargado... ');
      HALT;
    end;

  GetMem(aux,(NuevoTam+1)*6);                   { pido nuevo vector }
  asm
    push ds

    mov cx,CantElem          { cx= cantidad de words del vector viejo    }
    mov dx,cx
    shl cx,1
    add cx,dx

    les si,Linf              { es:si= puntero al inicio del vector viejo }
    lds di,aux               { es:di= puntero al inicio del vector nuevo }

@CopioOtro:                  {}
      mov ax,es:[si]         {}
      mov ds:[di],ax         {}
      inc si                 {}{ copiar vector viejo en el nuevo }
      inc si                 {}
      inc di                 {}
      inc di                 {}
    loop @CopioOtro          {}


    mov ax,00h
    mov cx,NuevoTam          { cx= cant. de words libres del nuevo vector   }
    inc cx
    sub cx,dx
    mov dx,cx
    shl cx,1
    add cx,dx

@LlenarOtro:                 {}
      mov ds:[di],ax         {}
      inc di                 {}{ marca exedente del vector nuevo como vac¡o }
      inc di                 {}
    loop @LLenarOtro         {}

    pop ds
  end;

  FreeMem(Linf,(TamMinDin+1)*6);             { liberar memoria del vector viejo }
  Linf:=aux;                                       { actualiza los punteros }
  Lsup:=Ptr(seg(Linf^),ofs(Linf^)+(CantElem-1)*6); {   al vector din mico   }
  TamMinDin:=NuevoTam;        { actualiza el tama¤o m¡nimo del nuevo vector }

end;

                   {---------------------------------------}

procedure  ErrorTamMin(TamMin:word);
begin
  writeln('*** ERROR: el tama¤o m¡nimo especificado para el vector din mico');
  writeln('           de CORRUTINAS es incorrecto: ',TamMin,' (2..10922)');
  halt;
end;

END.
