unit main;
interface
uses
  SysUtils, Windows, Messages,Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,    

  O_VEC, oo,
  omatr,mmspusk, method,  NW_MET;

  

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{uses   UtilBox;}

{$R *.DFM}
 //------------------------------------------------------------------------------
 //------------------------------------------------------------------------------
procedure TForm1.Button1Click(Sender: TObject);
 var fptr1 : ofun;   omsgr : omin;
     n,  n0, ii,i:integer;      nn: array [1..10] of longint;
     iin: array [1..10] of integer; h,f,ee:real;
      s,sn: string;
      Start, Finish, TimeLen : Cardinal; TimeL : Double;
    // x,x1,y : vec;
begin   ee:=1.0e-4;

  oo.ListBox1:=ListBox1;  //    omsgr.ListBox1:=ListBox1; //
  open_f;
  writeln(fileptr1^);
  omsgr:=   nortyk     .init;

  N_it:=0;  N_fg :=0;     Start := GetTickCount; //засекли начало выполнения операции

          qqmax:=3; qqmin:=0.8;  //задаем одномерный спуск параметры

          fptr1:=ofun.init(300,100);
           omsgr.run(fptr1);


     N_it:=N_it+omsgr.it;     N_fg :=N_fg+fptr1.ifun;      sn:=fptr1.name2;
           fptr1.done;

Finish := GetTickCount;
TimeLen := Finish - Start;
TimeL := TimeLen / 1000;
TimeLen := TimeLen div 1000;
    s:=Format('    N_it=%7d, N_fg=%7d, TIME=%8.4f',[N_it,N_fg,TimeL]);
    writeln(fileptr1^,sn,s);
    omsgr.done;

writeln(fileptr_ee0^,'------------------------------------------------------------------------');
closse_f;
 ListBox1.Items.Add('Конец');
end;  //TForm1.MIN1Click(Sender: TObject);

end.

