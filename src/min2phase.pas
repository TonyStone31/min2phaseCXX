unit min2phase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, http;

procedure init;
function writeFile(const name: string): Boolean;
function loadFile(const name: string): Boolean;
function solve(const facelets: string; maxDepth: ShortInt; probeMax, probeMin: LongInt;
               verbose: ShortInt; usedMoves: PByte): string;
function server(port, mReq: Word): Boolean;
function stop: Boolean;
function webSearch(const ip: string; port: LongInt; const facelets: string; maxDepth: ShortInt;
                   probeMax, probeMin: LongInt; verbose: ShortInt; usedMoves: PByte;
                   var time: string): string;

implementation

uses
  info, coords;

procedure init;
begin
  info.init;
  coords.init;
end;

function writeFile(const name: string): Boolean;
var
  out: TFileStream;
begin
  if not coords.isInit then
    init;
  try
    out := TFileStream.Create(name, fmCreate);
    try
      out.Write(coords.coords, SizeOf(coords.coords_t));
      Result := True;
    finally
      out.Free;
    end;
  except
    on E: EFileStreamError do
      Result := False;
  end;
end;

function loadFile(const name: string): Boolean;
var
  inF: TFileStream;
begin
  try
    inF := TFileStream.Create(name, fmOpenRead);
    try
      inF.Read(coords.coords, SizeOf(coords.coords_t));
      info.init;
      Result := True;
    finally
      inF.Free;
    end;
  except
    on E: EFileStreamError do
    begin
      init;
      Result := False;
    end;
  end;
end;

function solve(const facelets: string; maxDepth: ShortInt; probeMax, probeMin: LongInt;
               verbose: ShortInt; usedMoves: PByte): string;
begin
  Result := Search.solve(facelets, maxDepth, probeMax, probeMin, verbose, usedMoves);
end;

function server(port, mReq: Word): Boolean;
begin
  Result := http.init(port, mReq);
end;

function stop: Boolean;
begin
  Result := http.stop;
end;

function webSearch(const ip: string; port: LongInt; const facelets: string; maxDepth: ShortInt;
                   probeMax, probeMin: LongInt; verbose: ShortInt; usedMoves: PByte;
                   var time: string): string;
begin
  Result := http.webSolver(ip, port, facelets, maxDepth, probeMax, probeMin, verbose, usedMoves, time);
end;

end.



