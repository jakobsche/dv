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
  SleepTime = 1000;
var
  {S: TFileStream;}
  S: TMemoryStream;
  ReadBytes: Cardinal;
begin
  if OpenPictureDialog.Execute then begin
      {S := TFileStream.Create(TempFileName, fmCreate);}
      S := TMemoryStream.Create;
      try
        ImageMagick.Parameters[0] := OpenPictureDialog.FileName;
        ShowMessageFmt('"%s" wird ausgeführt.', [ImageMagick.Executable]);
        ImageMagick.Execute;
        Sleep(SleepTime);
        Application.ProcessMessages;
        ReadBytes := ImageMagick.Output.NumBytesAvailable;
        if ReadBytes = 0 then begin
          if not ImageMagick.Running then
            ShowMessageFmt('ExitStatus = %d, ExitCode = %d', [ImageMagick.ExitStatus, ImageMagick.ExitCode]);
          Exit
        end;
        while ImageMagick.Running or (ReadBytes > 0) do begin
          ShowMessageFmt('%d Bytes empfangen', [ReadBytes]);
          if ReadBytes > 0 then S.CopyFrom(ImageMagick.Output, ReadBytes);
          Sleep(SleepTime);
          Application.ProcessMessages;
          ReadBytes := ImageMagick.Output.NumBytesAvailable;
        end;
        ShowMessageFmt('Dateigröße: %d Bytes', [S.Size]);
        S.Seek(0, soBeginning);
        Image.Picture.Clear;
        try
          {Image.Picture.LoadFromFile(TempFileName); }
          Image.Picture.PNG.LoadFromStream(S);
          Image.Repaint;
          Application.ProcessMessages;
          StatusBar.Caption:= Format('%s geladen', [ImageMagick.Parameters[0]]);
        except
          on EInvalidGraphic do raise;
        end;
      finally
        S.Free;
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
var
  Env: TEnvironment;
begin
  TempFileExt := '.png';
  TempFileName := ChangeFileExt(SysUtils.GetTempFileName, TempFileExt);
  Env := TEnvironment.Create;
  try
    ImageMagick.Environment := Env;
{$ifdef darwin}
    with ImageMagick.Environment do begin
          Values['MAGICK_HOME'] := Values['HOME'] + '/ImageMagick-7.0.10';
          Values['PATH'] := Values['MAGICK_HOME'] + '/bin:' + Values['PATH'];
          Values['DYLD_LIBRARY_PATH'] := Values['MAGICK_HOME'] + '/lib';
          Values['DISPLAY'] := ':0'
    end;
    with ImageMagick do Executable := Environment.Values['MAGICK_HOME'] + '/bin/' + Executable;
{$endif}
  finally
    Env.Free;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  DeleteFile(TempFileName);
end;

end.

