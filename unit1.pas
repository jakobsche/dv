unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, ExtDlgs, ComCtrls, Types, process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image: TImage;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenPictureDialog: TOpenDialog;
    ImageMagick: TProcess;
    StatusBar: TPanel;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImageMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    TempFileName: string;
    TempFileExt: string;
  end;

var
  Form1: TForm1;

implementation

uses Patch;

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem4Click(Sender: TObject);
const
  BufferSize = $FFFF;
var
  S: TFileStream;
  ReadBytes: Cardinal;
  Buffer: array[0..$FFFE] of Byte;
begin
  if OpenPictureDialog.Execute then begin
      S := TFileStream.Create(TempFileName, fmCreate);
      try
        ImageMagick.Parameters[0] := OpenPictureDialog.FileName;
        ImageMagick.Execute;
        ReadBytes := ImageMagick.Output.NumBytesAvailable;
        while ImageMagick.Running or (ReadBytes > 0) do begin
          if ReadBytes > BufferSize then ReadBytes := BufferSize;
          ReadBytes := ImageMagick.Output.Read(Buffer, ReadBytes);
          if ReadBytes > 0 then S.Write(Buffer, ReadBytes);
          {Application.ProcessMessages;}
          ReadBytes := ImageMagick.Output.NumBytesAvailable;
        end;
      finally
        S.Free;
      end;
      try
        Image.Picture.Clear;
        Image.Picture.LoadFromFile(TempFileName);
        Image.Repaint;
        Application.ProcessMessages;
        StatusBar.Caption:= Format('%s geladen', [ImageMagick.Parameters[0]]);
      except
        on EInvalidGraphic do raise;
      end;
  end;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  Close
end;

procedure TForm1.ImageMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TempFileExt := '.png';
  TempFileName := ChangeFileExt(SysUtils.GetTempFileName, TempFileExt);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  DeleteFile(TempFileName);
end;

end.

