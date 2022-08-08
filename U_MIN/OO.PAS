UNIT OO; //  Тестовая функция
INTERFACE
uses
  SysUtils, Windows, Messages,Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,O_VEC;
const
    maxnn = 1005;  //matr  максимальный размер матриц   в методах оптимизации
    maxn = 1005;  //500005; // vec  максимальный размер векторов в методах оптимизации
type

ttext= ^text;
{min}
vec  = array [0..maxn] of real;        tvec = ^vec;    {тип вектор}
matr = array [0..maxnn,0..maxnn] of real;       tmatr= ^matr;   {тип матрица толко в блоке omatr}
ivec  = array [0..maxn] of integer;                  {тип вектор}

ovec= class(TObject)                    {об"ект операций с векторами}
   strcl: string;
   n : integer;                     {размерность}
   name, name2: string;               {имя об"екта}
   constructor init (nn : integer); { n:=nn }
   procedure NULX (var xx : vec);   { xx:=0 }
   procedure INVX (var xx : vec;var yy : vec);   { yy:=-xx }
   procedure yex (var xx, yy : vec);   { yy:=xx }
   procedure YRAX (aa : real;var xx : vec;var yy : vec);   { yy=aa*xx }
   function  SKAL (var xx,yy : vec) : real;    { skal=(xx,yy) }
   function  NORM (var xx : vec ) : real;      { norm=sqrt(xx,xx) }
   procedure ZXAY (var xx,yy : vec; aa : real;var zz : vec);{ zz=xx+aa*yy }
   procedure randX (var xx : vec);
   procedure yexma (var  xx : vec;var a:matr;var yy: vec);
   procedure maeI (var a:matr);
   destructor done ; virtual;       { begin end }
end;


ofun  = class(ovec)
  lmin,Lmax, hn, hmax : real; {начальный и максимальный допустимый шаги поиска = /X - X*/}
  fmin, fn,fk, stepen : real;     {минимум функции, либо значение заведомо меньшее минимума}
  xn : vec;        {начальное приближение минимума X*}
                            { границы для критериев останова }
  eh : real;       {если /X* - X/ < eh, останов}
  egr : real;      {если /gr/ < egr, останов}
  ef : real;       {если f-fmin < ef, останов}
  nu : real;
  ifmax :integer{ integer}; {if ifun > ifmax stop}
  igmax :integer{integer}; {if   ig > igmax stop}
  itmax :integer{integer}; {if   it > itmax stop}
                            { учетная информация }
  ifun,ig :integer{ integer}; {колич. вычисл. функции и градиента}
  iprint : integer;  {промежуток печати результатов}
  filedan, fileres: string;
                            { методы функции }
  constructor init (nin,iprintin:integer); {задание параметров}
  procedure inpar ; virtual;               {задание параметров функции}
  procedure ff (var  x:vec; var f:real) ; virtual;   {вычисление значений функции}
  procedure grad (var x:vec; var g:vec; var f:real); virtual;   {градиент}
  procedure xinit(var x:vec) ; virtual;         {возвращает начальную точку x:=xn}
  procedure itprint(it:integer; fx:real;var x:vec) ; virtual;
  procedure inprint(it:integer; fx:real;var x:vec) ; virtual;
  procedure endprint(it:integer; fx:real;var x:vec) ; virtual;
end;

  procedure open_f;
  procedure closse_f;

var
  //ListBox_G: TListBox;
   ListBox1: TListBox;
   fileptr : ttext;
   fileptr1 : ttext;
   fileptr_ee0 : ttext;
    N_it,N_fg : integer;

IMPLEMENTATION
{--------------------------------------------------------------}
procedure open_f;
begin
  fileptr1:=System.new(ttext);  System.assign(fileptr1^,'test0.txt');
  {$I-}  reset(fileptr1^);  {$I+}
  if IOResult<>0 then System.rewrite(fileptr1^)  else System.append(fileptr1^);
  // writeln(fileptr1^);  writeln(fileptr1^);

    fileptr:=new(ttext);   System.assign(fileptr^, 'test.txt');
  {$I-}  reset(fileptr^); {$I+}
      if IOResult<>0 then rewrite(fileptr^)  else append(fileptr^);
  writeln(fileptr^,'------------------------------------------------------------------------');

    fileptr_ee0:=new(ttext);  System.assign(fileptr_ee0^,'testEE0.txt' );
  {$I-}  reset(fileptr_ee0^); {$I+}
      if IOResult<>0 then rewrite(fileptr_ee0^)  else append(fileptr_ee0^);
  writeln(fileptr_ee0^,'---------------------------------------------------------------------');
end;

procedure closse_f;
begin
 System.close(fileptr1^);
 System. close(fileptr^);
 System. close(fileptr_ee0^);
end;
{--------------------------------------------------------------}

constructor OVEC.init (nn : integer);
begin  inherited create; n:=nn;    end;

procedure OVEC.NULX ( var xx : vec );
var i : integer;
begin     for i:=1 to n do xx[i]:=0;    end;

procedure OVEC.INVX ( var xx : vec; var yy : vec );
var i : integer;
begin     for i:=1 to n do  yy[i]:=-xx[i];    end;

procedure OVEC.yex (var xx, yy : vec); //yy[i]:=xx[i];
var i : integer;
begin     for i:=1 to n do  yy[i]:=xx[i];    end;

procedure OVEC.YRAX ( aa : real; var xx : vec; var yy : vec);
var i : integer;
begin     for i:=1 to n do yy[i]:=aa*xx[i];    end;

function OVEC.SKAL ( var xx,yy : vec) : real;
var i : integer;       skk : real;
begin  skk:=0;  for i:=1 to n do  skk:=skk+xx[i]*yy[i];  skal:=skk; end; { skal }

function OVEC.NORM ( var xx : vec) : real;
var nm : real;
begin     nm:=sqrt(skal(xx,xx));  norm:=nm    end; { norm }

procedure OVEC.ZXAY ( var xx,yy : vec; aa : real;var zz : vec);
var i : integer;
begin     for i:=1 to n do zz[i]:=xx[i]+aa*yy[i];    end; { zxay }

procedure OVEC.randX (var xx : vec);
var i : integer;        nx: real ;
begin     for i:=1 to n do xx[i]:=0.5-random;nx:=1.0/norm(xx);
             for i:=1 to n do xx[i]:=xx[i]*nx;   end;

procedure OVEC.yexma ( var xx : vec;var a:matr;var yy: vec);
var i,j : integer;
begin  nulx(yy);for i:=1 to n do for j:=1 to n do
          yy[i]:=yy[i]+a[j,i]*xx[j];
end;

procedure OVEC.maeI (var a:matr);
var i,j : integer;
begin  for i:=1 to n do for j:=1 to n do  a[i,j]:=0;
     for i:=1 to n do  a[i,i]:=1;
end;

destructor OVEC.done;
begin inherited destroy;    end;
{--------------------------------------------------------------}
                    { Pеализация методов ofun. }
constructor ofun.init(nin,iprintin : Integer);
begin
  inherited create; n:=nin;    iprint:=iprintin;   inpar;   ifun:=0;   ig:=0;
end; { init }

procedure ofun.inpar;
var i : integer;       r : real;
begin   stepen:=2;  r:=10;  hn:=r/5;        { начальный шаг }
     hmax:=2*r;      { максимальный шаг }
     fmin:=0;        { min функции }
     eh:=1.0e-20;   egr:=1.0e-20;   ef:=1.0e-10;   { границы критериев 1}
     ifmax:=52000;    igmax:=52000;      itmax:=52000;       {границы критериев 2}
     name:='sumXi^2*I^6';        {имя функции}
      for i:=1 to n do xn[i]:=r/i;  {начальная точка}
end;

procedure ofun.ff(var x : vec; var f : real); {функция}
var  i : integer;
begin f:=0;  for i:=1 to n do f:=f+x[i]*x[i]*i*i*i*i*i*i;   ifun:=ifun+1;  end;

procedure ofun.grad(var x : vec; var g : vec; var f : real); {градиент}
var   i : integer;
begin ff(x,f);  for i:=1 to n do g[i]:=x[i]*2*i*i*i*i*i*i; ig:=ig+1;  end;

procedure ofun.xinit(var x : vec);
var   i : integer;
begin  for i:=1 to n do x[i]:=xn[i];ifun:=0; ig:=0; end;

procedure ofun.itprint(it:integer; fx:real;var x:vec) ;
begin      end;

procedure ofun.inprint(it:integer; fx:real;var x:vec) ;
begin      end;

procedure ofun.endprint(it:integer; fx:real;var x:vec) ;
begin      end;

{--------------------------------------------------------------}

{--------------------------------------------------------------}

END.


