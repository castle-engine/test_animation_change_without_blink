{ Main state, where most of the application logic takes place.

  Feel free to use this code as a starting point for your own projects.
  (This code is in public domain, unlike most other CGE code which
  is covered by the LGPL license variant, see the COPYING.txt file.) }
unit GameStateMain;

interface

uses Classes,
  CastleVectors, CastleUIState, CastleComponentSerialize, CastleUIControls,
  CastleControls, CastleKeysMouse, CastleViewport, CastleScene, X3DNodes;

type
  { Main state, where most of the application logic takes place. }
  TStateMain = class(TUIState)
  private
    { Components designed using CGE editor, loaded from gamestatemain.castle-user-interface. }
    Viewport: TCastleViewport;
    SceneKnight, SceneDragon: TCastleScene;
    ButtonPlayAnimationRandom: TCastleButton;
    ButtonResetAndPlayRandom: TCastleButton;
    ButtonResetAndTimeSensorStartRandom: TCastleButton;
    LabelFps: TCastleLabel;

    { if any TTimeSensorNode was used to start animation using TTimeSensorNode.Start,
      then record it here. }
    SceneKnightSensor: TTimeSensorNode;
    SceneDragonSensor: TTimeSensorNode;

    function SceneRandomAnim(const Scene: TCastleScene): String;
    procedure ClickPlayAnimationRandom(Sender: TObject);
    procedure ClickResetAndPlayRandom(Sender: TObject);
    procedure ClickResetAndTimeSensorStartRandom(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start; override;
    procedure Update(const SecondsPassed: Single; var HandleInput: Boolean); override;
  end;

var
  StateMain: TStateMain;

implementation

uses SysUtils;

{ TStateMain ----------------------------------------------------------------- }

constructor TStateMain.Create(AOwner: TComponent);
begin
  inherited;
  DesignUrl := 'castle-data:/gamestatemain.castle-user-interface';
end;

procedure TStateMain.Start;
begin
  inherited;

  { Find components, by name, that we need to access from code }
  LabelFps := DesignedComponent('LabelFps') as TCastleLabel;
  ButtonPlayAnimationRandom := DesignedComponent('ButtonPlayAnimationRandom') as TCastleButton;
  ButtonResetAndPlayRandom := DesignedComponent('ButtonResetAndPlayRandom') as TCastleButton;
  ButtonResetAndTimeSensorStartRandom := DesignedComponent('ButtonResetAndTimeSensorStartRandom') as TCastleButton;
  Viewport := DesignedComponent('Viewport') as TCastleViewport;
  SceneKnight := DesignedComponent('SceneKnight') as TCastleScene;
  SceneDragon := DesignedComponent('SceneDragon') as TCastleScene;

  ButtonPlayAnimationRandom.OnClick := {$ifdef FPC}@{$endif} ClickPlayAnimationRandom;
  ButtonResetAndPlayRandom.OnClick := {$ifdef FPC}@{$endif} ClickResetAndPlayRandom;
  ButtonResetAndTimeSensorStartRandom.OnClick := {$ifdef FPC}@{$endif} ClickResetAndTimeSensorStartRandom;
end;

procedure TStateMain.Update(const SecondsPassed: Single; var HandleInput: Boolean);
begin
  inherited;
  { This virtual method is executed every frame.}
  LabelFps.Caption := 'FPS: ' + Container.Fps.ToString;
end;

function TStateMain.SceneRandomAnim(const Scene: TCastleScene): String;
begin
  if Scene.AnimationsList.Count <> 0 then
    Result := Scene.AnimationsList[Random(Scene.AnimationsList.Count)]
  else
    Result := '';
end;

procedure TStateMain.ClickPlayAnimationRandom(Sender: TObject);
begin
  if SceneKnightSensor <> nil then
  begin
    SceneKnightSensor.Stop;
    SceneKnightSensor := nil;
  end;
  if SceneDragonSensor <> nil then
  begin
    SceneDragonSensor.Stop;
    SceneDragonSensor := nil;
  end;
  SceneKnight.PlayAnimation(SceneRandomAnim(SceneKnight), true);
  SceneDragon.PlayAnimation(SceneRandomAnim(SceneDragon), true);
end;

procedure TStateMain.ClickResetAndPlayRandom(Sender: TObject);
begin
  if SceneKnightSensor <> nil then
  begin
    SceneKnightSensor.Stop;
    SceneKnightSensor := nil;
  end;
  if SceneDragonSensor <> nil then
  begin
    SceneDragonSensor.Stop;
    SceneDragonSensor := nil;
  end;
  SceneKnight.StopAnimation;
  SceneDragon.StopAnimation;
  SceneKnight.ResetAnimationState;
  SceneDragon.ResetAnimationState;
  SceneKnight.PlayAnimation(SceneRandomAnim(SceneKnight), true);
  SceneDragon.PlayAnimation(SceneRandomAnim(SceneDragon), true);
end;

procedure TStateMain.ClickResetAndTimeSensorStartRandom(Sender: TObject);
begin
  if SceneKnightSensor <> nil then
  begin
    SceneKnightSensor.Stop;
    SceneKnightSensor := nil;
  end;
  if SceneDragonSensor <> nil then
  begin
    SceneDragonSensor.Stop;
    SceneDragonSensor := nil;
  end;
  SceneKnight.StopAnimation;
  SceneDragon.StopAnimation;
  SceneKnight.ResetAnimationState;
  SceneDragon.ResetAnimationState;
  SceneKnightSensor := SceneKnight.AnimationTimeSensor(SceneRandomAnim(SceneKnight));
  SceneKnightSensor.Start(true);
  SceneDragonSensor := SceneDragon.AnimationTimeSensor(SceneRandomAnim(SceneDragon));
  SceneDragonSensor.Start(true);
end;

end.
