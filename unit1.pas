unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, CastleControl,
  gamestatemain, CastleApplicationProperties, CastleUIState,
  CastleScene, CastleSceneCore;

type

  { TForm1 }

  TForm1 = class(TForm)
    CastleControl1: TCastleControl;
    procedure FormCreate(Sender: TObject);
  private
    StateMain: TStateMain;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  TCastleControl.MainControl := CastleControl1;  
  ApplicationProperties.LimitFPS := 15;
  StateMain := TStateMain.Create(Self);
  TUIState.Current := StateMain;
end;

end.

