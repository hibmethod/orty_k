program min1;

uses
  Forms,
  main in 'MAIN.PAS' {Form1},
  O_VEC in '..\vect_matr\O_VEC.pas',
  OO in '..\U_MIN\OO.PAS',
  METHOD in '..\U_MIN\METHOD.PAS',
  OMATR in '..\U_MIN\OMATR.PAS',
  MMSPUSK in '..\U_MIN\MMSPUSK.PAS',
  NW_MET in '..\U_MIN\NW_MET.PAS';

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
