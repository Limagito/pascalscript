unit uPSR_classes;

{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils {+}{$IFNDEF FPC},RTLConsts{$ENDIF}{+.};

procedure RIRegisterTStrings(cl: TPSRuntimeClassImporter; Streams: Boolean);
procedure RIRegisterTStringList(cl: TPSRuntimeClassImporter);
{$IFNDEF PS_MINIVCL}
procedure RIRegisterTBITS(Cl: TPSRuntimeClassImporter);
{$ENDIF}
procedure RIRegisterTSTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTHANDLESTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTFILESTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTSTRINGSTREAM(Cl: TPSRuntimeClassImporter);
{$IFNDEF PS_MINIVCL}
procedure RIRegisterTCUSTOMMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTRESOURCESTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTPARSER(Cl: TPSRuntimeClassImporter);
{$IFDEF DELPHI3UP}
procedure RIRegisterTOWNEDCOLLECTION(Cl: TPSRuntimeClassImporter);
{$ENDIF}
procedure RIRegisterTCOLLECTION(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCOLLECTIONITEM(Cl: TPSRuntimeClassImporter);
{$ENDIF}

procedure RIRegister_Classes(Cl: TPSRuntimeClassImporter; Streams: Boolean{$IFDEF D4PLUS}=True{$ENDIF});

implementation
uses
  {+}SysUtils,{+.}Classes;

procedure TStringsCapacityR(Self: TStrings; var T: Longint); begin T := Self.Capacity; end;
procedure TStringsCapacityW(Self: TStrings; T: Longint); begin Self.Capacity := T; end;
procedure TStringsDelimiterR(Self: TStrings; var T: char); begin T := Self.Delimiter; end;
procedure TStringsDelimiterW(Self: TStrings; T: char); begin Self.Delimiter:= T; end;
{$IFDEF DELPHI2006UP}
procedure TStringsStrictDelimiterR(Self: TStrings; var T: boolean); begin T := Self.StrictDelimiter; end;
procedure TStringsStrictDelimiterW(Self: TStrings; T: boolean); begin Self.StrictDelimiter:= T; end;
{$ENDIF}
procedure TStringsDelimitedTextR(Self: TStrings; var T: string); begin T := Self.DelimitedText; end;
procedure TStringsDelimitedTextW(Self: TStrings; T: string); begin Self.DelimitedText:= T; end;
procedure TStringsNameValueSeparatorR(Self: TStrings; var T: char); begin T := Self.NameValueSeparator; end;
procedure TStringsNameValueSeparatorW(Self: TStrings; T: char); begin Self.NameValueSeparator:= T; end;
procedure TStringsQuoteCharR(Self: TStrings; var T: char); begin T := Self.QuoteChar; end;
procedure TStringsQuoteCharW(Self: TStrings; T: char); begin Self.QuoteChar:= T; end;

procedure TStringsCountR(Self: TStrings; var T: Longint); begin T := Self.Count; end;

procedure TStringsTextR(Self: TStrings; var T: string); begin T := Self.Text; end;
procedure TStringsTextW(Self: TStrings; T: string); begin Self.Text:= T; end;

procedure TStringsCommaTextR(Self: TStrings; var T: string); begin T := Self.CommaText; end;
procedure TStringsCommaTextW(Self: TStrings; T: string); begin Self.CommaText:= T; end;

procedure TStringsObjectsR(Self: TStrings; var T: TObject; I: Longint);
begin
T := Self.Objects[I];
end;
procedure TStringsObjectsW(Self: TStrings; const T: TObject; I: Longint);
begin
  Self.Objects[I]:= T;
end;

procedure TStringsStringsR(Self: TStrings; var T: string; I: Longint);
begin
T := Self.Strings[I];
end;
procedure TStringsStringsW(Self: TStrings; const T: string; I: Longint);
begin
  Self.Strings[I]:= T;
end;

procedure TStringsNamesR(Self: TStrings; var T: string; I: Longint);
begin
T := Self.Names[I];
end;
procedure TStringsValuesR(Self: TStrings; var T: string; const I: string);
begin
T := Self.Values[I];
end;
procedure TStringsValuesW(Self: TStrings; Const T, I: String);
begin
  Self.Values[I]:= T;
end;

procedure TStringsValueFromIndexR(Self: TStrings; var T: string; const I: Longint);
begin
T := Self.ValueFromIndex[I];
end;
procedure TStringsValueFromIndexW(Self: TStrings; Const T: String; I: Longint);
begin
  Self.ValueFromIndex[I]:= T;
end;

procedure RIRegisterTStrings(cl: TPSRuntimeClassImporter; Streams: Boolean); // requires TPersistent
begin
  with Cl.Add(TStrings) do
  begin
{$IFDEF DELPHI2005UP}
    RegisterConstructor(@TStrings.CREATE, 'Create');
{$ENDIF}

    RegisterVirtualMethod(@TStrings.Add, 'Add');
    RegisterMethod(@TStrings.Append, 'Append');
    RegisterVirtualMethod(@TStrings.AddStrings, 'AddStrings');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Clear, 'Clear');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Delete, 'Delete');
    RegisterVirtualMethod(@TStrings.IndexOf, 'IndexOf');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Insert, 'Insert');
    RegisterPropertyHelper(@TStringsCapacityR, @TStringsCapacityW, 'Capacity');
    RegisterPropertyHelper(@TStringsDelimiterR, @TStringsDelimiterW, 'DELIMITER');
{$IFDEF DELPHI2006UP}
    RegisterPropertyHelper(@TStringsStrictDelimiterR, @TStringsStrictDelimiterW, 'StrictDelimiter');
{$ENDIF}
    RegisterPropertyHelper(@TStringsDelimitedTextR, @TStringsDelimitedTextW, 'DelimitedText');
    RegisterPropertyHelper(@TStringsNameValueSeparatorR, @TStringsNameValueSeparatorW, 'NameValueSeparator');
    RegisterPropertyHelper(@TStringsQuoteCharR, @TStringsQuoteCharW, 'QuoteChar');
    RegisterPropertyHelper(@TStringsCountR, nil, 'Count');
    RegisterPropertyHelper(@TStringsTextR, @TStringsTextW, 'Text');
    RegisterPropertyHelper(@TStringsCommaTextR, @TStringsCommatextW, 'CommaText');
    if Streams then
    begin
      RegisterVirtualMethod(@TStrings.LoadFromFile, 'LoadFromFile');
      RegisterVirtualMethod(@TStrings.SaveToFile, 'SaveToFile');
    end;
    RegisterPropertyHelper(@TStringsStringsR, @TStringsStringsW, 'Strings');
    RegisterPropertyHelper(@TStringsObjectsR, @TStringsObjectsW, 'Objects');

    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TStrings.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TStrings.EndUpdate, 'EndUpdate');
    RegisterMethod(@TStrings.Equals,  'Equals');
    RegisterVirtualMethod(@TStrings.Exchange, 'Exchange');
    RegisterMethod(@TStrings.IndexOfName, 'IndexOfName');
    if Streams then
      RegisterVirtualMethod(@TStrings.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TStrings.Move, 'Move');
    if Streams then
      RegisterVirtualMethod(@TStrings.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TStrings.SetText, 'SetText');
    RegisterPropertyHelper(@TStringsNamesR, nil, 'Names');
    RegisterPropertyHelper(@TStringsValuesR, @TStringsValuesW, 'Values');
    RegisterPropertyHelper(@TStringsValueFromIndexR, @TStringsValueFromIndexW, 'ValueFromIndex');
    RegisterVirtualMethod(@TSTRINGS.ADDOBJECT, 'AddObject');
    RegisterVirtualMethod(@TSTRINGS.GETTEXT, 'GetText');
    RegisterMethod(@TSTRINGS.INDEXOFOBJECT, 'IndexOfObject');
    RegisterMethod(@TSTRINGS.INSERTOBJECT, 'InsertObject');
    {$ENDIF}
  end;
end;

procedure TSTRINGLISTCASESENSITIVE_R(Self: TSTRINGLIST; var T: BOOLEAN); begin T := Self.CASESENSITIVE; end;
procedure TSTRINGLISTCASESENSITIVE_W(Self: TSTRINGLIST; const T: BOOLEAN); begin Self.CASESENSITIVE := T; end;
procedure TSTRINGLISTDUPLICATES_R(Self: TSTRINGLIST; var T: TDUPLICATES); begin T := Self.DUPLICATES; end;
procedure TSTRINGLISTDUPLICATES_W(Self: TSTRINGLIST; const T: TDUPLICATES); begin Self.DUPLICATES := T; end;
procedure TSTRINGLISTSORTED_R(Self: TSTRINGLIST; var T: BOOLEAN); begin T := Self.SORTED; end;
procedure TSTRINGLISTSORTED_W(Self: TSTRINGLIST; const T: BOOLEAN); begin Self.SORTED := T; end;
procedure TSTRINGLISTONCHANGE_R(Self: TSTRINGLIST; var T: TNOTIFYEVENT);
begin
T := Self.ONCHANGE; end;
procedure TSTRINGLISTONCHANGE_W(Self: TSTRINGLIST; const T: TNOTIFYEVENT);
begin
Self.ONCHANGE := T; end;
procedure TSTRINGLISTONCHANGING_R(Self: TSTRINGLIST; var T: TNOTIFYEVENT); begin T := Self.ONCHANGING; end;
procedure TSTRINGLISTONCHANGING_W(Self: TSTRINGLIST; const T: TNOTIFYEVENT); begin Self.ONCHANGING := T; end;
procedure RIRegisterTSTRINGLIST(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TSTRINGLIST) do
  begin
{$IFDEF DELPHI2005UP}
    RegisterConstructor(@TStringList.CREATE, 'Create');
{$ENDIF}
    RegisterVirtualMethod(@TSTRINGLIST.FIND, 'Find');
    RegisterVirtualMethod(@TSTRINGLIST.SORT, 'Sort');
    RegisterPropertyHelper(@TSTRINGLISTCASESENSITIVE_R, @TSTRINGLISTCASESENSITIVE_W, 'CaseSensitive');
    RegisterPropertyHelper(@TSTRINGLISTDUPLICATES_R, @TSTRINGLISTDUPLICATES_W, 'Duplicates');
    RegisterPropertyHelper(@TSTRINGLISTSORTED_R, @TSTRINGLISTSORTED_W, 'Sorted');
    RegisterEventPropertyHelper(@TSTRINGLISTONCHANGE_R, @TSTRINGLISTONCHANGE_W, 'OnChange');
    RegisterEventPropertyHelper(@TSTRINGLISTONCHANGING_R, @TSTRINGLISTONCHANGING_W, 'OnChanging');
  end;
end;

{$IFNDEF PS_MINIVCL}
procedure TBITSBITS_W(Self: TBITS; T: BOOLEAN; t1: INTEGER); begin Self.BITS[t1] := T; end;
procedure TBITSBITS_R(Self: TBITS; var T: BOOLEAN; t1: INTEGER); begin T := Self.Bits[t1]; end;
procedure TBITSSIZE_R(Self: TBITS; T: INTEGER); begin Self.SIZE := T; end;
procedure TBITSSIZE_W(Self: TBITS; var T: INTEGER); begin T := Self.SIZE; end;

procedure RIRegisterTBITS(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TBITS) do
  begin
    RegisterMethod(@TBITS.OPENBIT, 'OpenBit');
    RegisterPropertyHelper(@TBITSBITS_R, @TBITSBITS_W, 'Bits');
    RegisterPropertyHelper(@TBITSSIZE_R, @TBITSSIZE_W, 'Size');
  end;
end;
{$ENDIF}

{+}
procedure TSTREAMPOSITION_R(Self: TSTREAM; var T: {$IFNDEF PS_NOINT64}Int64{$ELSE}LONGINT{$ENDIF}); begin t := Self.POSITION; end;
procedure TSTREAMPOSITION_W(Self: TSTREAM; T: {$IFNDEF PS_NOINT64}Int64{$ELSE}LONGINT{$ENDIF}); begin Self.POSITION := t; end;
procedure TSTREAMSIZE_R(Self: TSTREAM; var T: {$IFNDEF PS_NOINT64}Int64{$ELSE}LONGINT{$ENDIF}); begin t := Self.SIZE; end;
{$IFDEF DELPHI3UP}
procedure TSTREAMSIZE_W(Self: TSTREAM; T: {$IFNDEF PS_NOINT64}Int64{$ELSE}LONGINT{$ENDIF}); begin Self.SIZE := t; end;
{$ENDIF}

{function TSTREAM_READ(Self: TMemoryStream; Buffer: string; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count <=0 then
    Exit;
  iLen := Length(Buffer);
  if iLen=0 then
    Exit;
  if Count > iLen then
    Count := iLen;
  Result := Self.Read(PChar(Buffer)^, Count*SizeOf(Char));
end;

function TSTREAM_WRITE(Self: TMemoryStream; Buffer: string; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count <=0 then
    Exit;
  iLen := Length(Buffer);
  if iLen=0 then
    Exit;
  if Count > iLen then
    Count := iLen;
  Result := Self.Write(PChar(Buffer)^, Count*SizeOf(Char));
end;{}

//
// TStream.Write
//

function TSTREAM_WRITEA(Self: TMemoryStream; const Buffer: AnsiString; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count <=0 then
    Exit;
  iLen := Length(Buffer);
  if iLen=0 then
    Exit;
  if Count > iLen then
    Count := iLen;
  Result := Self.Write(PAnsiChar(Buffer)^, Count);
end;

function TSTREAM_WRITEB(Self: TMemoryStream; const Buffer: TBytes; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count <=0 then
    Exit;
  iLen := Length(Buffer);
  if iLen=0 then
    Exit;
  if Count > iLen then
    Count := iLen;
  Result := Self.Write(Buffer[0], Count);
end;

function TSTREAM_WRITEW(Self: TMemoryStream; const Buffer: tbtunicodestring; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count <=0 then
    Exit;
  iLen := Length(Buffer);
  if iLen=0 then
    Exit;
  if Count > iLen then
    Count := iLen;
  Result := Self.Write(PWideChar(Buffer)^, Count*2);
end;

//
// TStream.Read
//

function TSTREAM_READA(Self: TMemoryStream; var Buffer: AnsiString; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count=0 then
  begin
    SetLength(Buffer, 0);
    Exit;
  end;
  iLen := Length(Buffer);
  if Count < 0 then
    Count := iLen;
  if iLen <> Count then
    SetLength(Buffer, Count);
  Result := Self.Read(PAnsiChar(Buffer)^, Count);
  if Result <> Count then
  begin
    if Result > 0 then
      SetLength(Buffer, Result)
    else
      SetLength(Buffer, 0);
  end;
end;

function TSTREAM_READB(Self: TMemoryStream; var Buffer: TBytes; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count=0 then
  begin
    SetLength(Buffer, 0);
    Exit;
  end;
  iLen := Length(Buffer);
  if Count < 0 then
    Count := iLen;
  if iLen <> Count then
    SetLength(Buffer, Count);
  Result := Self.Read(Buffer[0], Count);
  if Result <> Count then
  begin
    if Result > 0 then
      SetLength(Buffer, Result)
    else
      SetLength(Buffer, 0);
  end;
end;

function TSTREAM_READW(Self: TMemoryStream; var Buffer: tbtunicodestring; Count: LongInt):LongInt;
var
  iLen: Integer;
begin
  Result := 0;
  if Count=0 then
  begin
    SetLength(Buffer, 0);
    Exit;
  end;
  iLen := Length(Buffer);
  if Count < 0 then
    Count := iLen;
  if iLen <> Count then
    SetLength(Buffer, Count);
  Result := Self.Read(PWideChar(Buffer)^, Count*2) div 2;
  if Result <> Count then
  begin
    if Result > 0 then
      SetLength(Buffer, Result)
    else
      SetLength(Buffer, 0);
  end;
end;

//
// TStream.WriteBuffer
//

procedure TStream_WriteBufferA(Self: TStream; const Buffer: AnsiString; Count: Longint);
var
  iLen: Integer;
begin
  if Count=0 then
    Exit;
  iLen := Length(Buffer);
  if Count<0 then
    Count := iLen;
  //{$IFNDEF FPC}
  //if Count > iLen then
  //begin
  //  raise EWriteError.CreateRes(@SWriteError);
  //end;
  //{$ENDIF}
  if iLen > 0 then
  begin
    if Count > iLen then
      Count := iLen;
    Self.WriteBuffer(PAnsiChar(Buffer)^, Count);
  end;
end;

procedure TStream_WriteBufferB(Self: TStream; const Buffer: TBytes; Count: Longint);
var
  iLen: Integer;
begin
  if Count=0 then
    Exit;
  iLen := Length(Buffer);
  if Count<0 then
    Count := iLen;
  //{$IFNDEF FPC}
  //if Count > iLen then
  //begin
  //  raise EWriteError.CreateRes(@SWriteError);
  //end;
  //{$ENDIF}
  if iLen > 0 then
  begin
    if Count > iLen then
      Count := iLen;
    Self.WriteBuffer(Buffer[0], Count);
  end;
end;

procedure TStream_WriteBufferW(Self: TStream; const Buffer: tbtunicodestring; Count: Longint);
var
  iLen: Integer;
begin
  if Count=0 then
    Exit;
  iLen := Length(Buffer);
  if Count<0 then
    Count := iLen;
  //{$IFNDEF FPC}
  //if Count > iLen then
  //begin
  //  raise EWriteError.CreateRes(@SWriteError);
  //end;
  //{$ENDIF}
  if iLen > 0 then
  begin
    if Count > iLen then
      Count := iLen;
    Self.WriteBuffer(PWideChar(Buffer)^, Count*2);
  end;
end;

//
// TStream.ReadBuffer
//

procedure TStream_ReadBufferA(Self: TStream; var Buffer: AnsiString; Count: Longint);
var
  iLen: Integer;
begin
  if Count<=0 then
  begin
    SetLength(Buffer, 0);
    Exit;
  end;
  iLen := Length(Buffer);
  //{$IFNDEF FPC}
  //if iLen < Count then
  //  raise EReadError.CreateRes(@SReadError);
  //{$ENDIF}
  if iLen <> Count then
    SetLength(Buffer, Count);
  Self.ReadBuffer(PAnsiChar(Buffer)^, Count);
end;

procedure TStream_ReadBufferB(Self: TStream; var Buffer: TBytes; Count: Longint);
var
  iLen: Integer;
begin
  if Count<=0 then
  begin
    SetLength(Buffer, 0);
    Exit;
  end;
  iLen := Length(Buffer);
  //{$IFNDEF FPC}
  //if iLen < Count then
  //  raise EReadError.CreateRes(@SReadError);
  //{$ENDIF}
  if iLen <> Count then
    SetLength(Buffer, Count);
  Self.ReadBuffer(Buffer[0], Count);
end;

procedure TStream_ReadBufferW(Self: TStream; var Buffer: tbtunicodestring; Count: Longint);
var
  iLen: Integer;
begin
  if Count<=0 then
  begin
    SetLength(Buffer, 0);
    Exit;
  end;
  iLen := Length(Buffer);
  //{$IFNDEF FPC}
  //if iLen < Count then
  //  raise EReadError.CreateRes(@SReadError);
  //{$ENDIF}
  if iLen <> Count then
    SetLength(Buffer, Count);
  Self.ReadBuffer(PWideChar(Buffer)^, Count*2);
end;

function TSTREAMDATABYTES_R(Self: TStream): TBytes;
var
  iPos, iSize: Int64;
begin
  iSize := Self.Size;
  if iSize = 0 then
    Exit;
  iPos := Self.Position;
  Self.Position := 0;
  try
    SetLength(Result, iSize);
    Self.ReadBuffer(Pointer(Result)^, iSize);
  finally
    Self.Position := iPos;
  end;
end;
{+.}

procedure RIRegisterTSTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TStream) do
  begin
    {+}
    //RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.Read, 'Read');
    //-RegisterVirtualAbstractMethod(TMemoryStream, @TSTREAM_READ, 'Read');
    //RegisterMethod(@TSTREAM_READ, 'Read');
    RegisterMethod(@TSTREAM_READA, 'Read');
    //RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.Write, 'Write');
    //-RegisterVirtualAbstractMethod(TMemoryStream, @TSTREAM_WRITE, 'Write');
    //RegisterMethod(@TSTREAM_WRITE, 'Write');
    RegisterMethod(@TSTREAM_WRITEA, 'Write');
    {+.}
    RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.Seek, 'Seek');
    {+}
    RegisterMethod(@TSTREAM_READA, 'ReadA');
    RegisterMethod(@TSTREAM_READB, 'ReadB');
    RegisterMethod(@TSTREAM_READW, 'ReadW');
    RegisterMethod(@TSTREAM_WRITEA, 'WriteA');
    RegisterMethod(@TSTREAM_WRITEB, 'WriteB');
    RegisterMethod(@TSTREAM_WRITEW, 'WriteW');
    //RegisterMethod(@TStream.ReadBuffer, 'ReadBuffer');
    RegisterMethod(@TStream_ReadBufferA, 'ReadBuffer');
    //RegisterMethod(@TStream.WriteBuffer, 'WriteBuffer');
    RegisterMethod(@TStream_WriteBufferA, 'WriteBuffer');
    //
    RegisterMethod(@TStream_ReadBufferA, 'ReadBufferA');
    RegisterMethod(@TStream_ReadBufferB, 'ReadBufferB');
    RegisterMethod(@TStream_ReadBufferW, 'ReadBufferW');
    RegisterMethod(@TStream_WriteBufferA, 'WriteBufferA');
    RegisterMethod(@TStream_WriteBufferB, 'WriteBufferB');
    RegisterMethod(@TStream_WriteBufferW, 'WriteBufferW');
    {+.}
    RegisterMethod(@TStream.CopyFrom, 'CopyFrom');
    RegisterPropertyHelper(@TSTREAMPOSITION_R, @TSTREAMPOSITION_W, 'Position');
    RegisterPropertyHelper(@TSTREAMSIZE_R, {$IFDEF DELPHI3UP}@TSTREAMSIZE_W, {$ELSE}nil, {$ENDIF}'Size');
    {+}
    RegisterPropertyHelper(@TSTREAMDATABYTES_R, nil, 'DataBytes');
    {+.}
  end;
end;

procedure THANDLESTREAMHANDLE_R(Self: THANDLESTREAM; var T: {+}THandle{+.}); begin T := Self.HANDLE; end;

procedure RIRegisterTHANDLESTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(THandleStream) do
  begin
    RegisterConstructor(@THandleStream.Create, 'Create');
    RegisterPropertyHelper(@THANDLESTREAMHANDLE_R, nil, 'Handle');
  end;
end;

{$IFDEF FPC}
// mh: because FPC doesn't handle pointers to overloaded functions
function TFileStreamCreate(filename: string; mode: word): TFileStream;
begin
  result := TFileStream.Create(filename, mode);
end;
{$ENDIF}

procedure RIRegisterTFILESTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TFileStream) do
  begin
    {$IFDEF FPC}
    RegisterConstructor(@TFileStreamCreate, 'Create');
    {$ELSE}
    RegisterConstructor(@TFileStream.Create, 'Create');
    {$ENDIF}
  end;
end;

{$IFDEF UNICODE}
  {$IFNDEF FPC}
    {$DEFINE STRINGSTREAMFIX}
  {$ENDIF}
{$ENDIF}

{$IFDEF STRINGSTREAMFIX}
function TStringStreamCreateString(AHidden1: Pointer; AHidden2: Byte;
  //const AString: {$IFDEF UNICODE}UnicodeString{$ELSE}AnsiString{$ENDIF}
  const AString: string
): TStringStream;
begin
  Result := TStringStream.Create(AString);
end;
{$ENDIF}

{+}
function TSTRINGSTREAMDATASTRING_R(Self: TStringStream)
  //: {$IFDEF UNICODE}UnicodeString{$ELSE}AnsiString{$ENDIF}
  : string
;
begin
  Result := string(Self.DataString);
end;
{+.}

procedure RIRegisterTSTRINGSTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TStringStream) do
  begin
    RegisterConstructor({$IFDEF STRINGSTREAMFIX}@TStringStreamCreateString{$ELSE}@TStringStream.Create{$ENDIF}, 'Create');
    {+}
    RegisterPropertyHelper(@TSTRINGSTREAMDATASTRING_R, nil, 'DataString');
    {+.}
  end;
end;

{$IFNDEF PS_MINIVCL}
procedure RIRegisterTCUSTOMMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCustomMemoryStream) do
  begin
    RegisterMethod(@TCustomMemoryStream.SaveToStream, 'SaveToStream');
    RegisterMethod(@TCustomMemoryStream.SaveToFile, 'SaveToFile');
  end;
end;

procedure RIRegisterTMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TMemoryStream) do
  begin
    RegisterMethod(@TMemoryStream.Clear, 'Clear');
    RegisterMethod(@TMemoryStream.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TMemoryStream.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TMemoryStream.SetSize, 'SetSize');
  end;
end;

procedure RIRegisterTRESOURCESTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TResourceStream) do
  begin
    RegisterConstructor(@TResourceStream.Create, 'Create');
    RegisterConstructor(@TResourceStream.CreateFromID, 'CreateFromID');
  end;
end;

procedure TPARSERSOURCELINE_R(Self: TPARSER; var T: INTEGER); begin T := Self.SOURCELINE; end;
procedure TPARSERTOKEN_R(Self: TPARSER; var T: CHAR); begin T := Self.TOKEN; end;

procedure RIRegisterTPARSER(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TParser) do
  begin
    RegisterConstructor(@TParser.Create, 'Create');
    RegisterMethod(@TParser.CheckToken, 'CheckToken');
    RegisterMethod(@TParser.CheckTokenSymbol, 'CheckTokenSymbol');
    RegisterMethod(@TParser.Error, 'Error');
    RegisterMethod(@TParser.ErrorStr, 'ErrorStr');
    RegisterMethod(@TParser.HexToBinary, 'HexToBinary');
    RegisterMethod(@TParser.NextToken, 'NextToken');
    RegisterMethod(@TParser.SourcePos, 'SourcePos');
    RegisterMethod(@TParser.TokenComponentIdent, 'TokenComponentIdent');
    RegisterMethod(@TParser.TokenFloat, 'TokenFloat');
    RegisterMethod(@TParser.TokenInt, 'TokenInt');
    RegisterMethod(@TParser.TokenString, 'TokenString');
    RegisterMethod(@TParser.TokenSymbolIs, 'TokenSymbolIs');
    RegisterPropertyHelper(@TPARSERSOURCELINE_R, nil, 'SourceLine');
    RegisterPropertyHelper(@TPARSERTOKEN_R, nil, 'Token');
  end;
end;

procedure TCOLLECTIONITEMS_W(Self: TCOLLECTION; const T: TCOLLECTIONITEM; const t1: INTEGER);
begin Self.ITEMS[t1] := T; end;

procedure TCOLLECTIONITEMS_R(Self: TCOLLECTION; var T: TCOLLECTIONITEM; const t1: INTEGER);
begin T := Self.ITEMS[t1]; end;

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMCLASS_R(Self: TCOLLECTION; var T: TCOLLECTIONITEMCLASS);
begin T := Self.ITEMCLASS; end;
{$ENDIF}

procedure TCOLLECTIONCOUNT_R(Self: TCOLLECTION; var T: INTEGER);
begin T := Self.COUNT; end;

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMDISPLAYNAME_W(Self: TCOLLECTIONITEM; const T: STRING);
begin Self.DISPLAYNAME := T; end;
{$ENDIF}

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMDISPLAYNAME_R(Self: TCOLLECTIONITEM; var T: STRING);
begin T := Self.DISPLAYNAME; end;
{$ENDIF}

procedure TCOLLECTIONITEMINDEX_W(Self: TCOLLECTIONITEM; const T: INTEGER);
begin Self.INDEX := T; end;

procedure TCOLLECTIONITEMINDEX_R(Self: TCOLLECTIONITEM; var T: INTEGER);
begin T := Self.INDEX; end;

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMID_R(Self: TCOLLECTIONITEM; var T: INTEGER);
begin T := Self.ID; end;
{$ENDIF}

procedure TCOLLECTIONITEMCOLLECTION_W(Self: TCOLLECTIONITEM; const T: TCOLLECTION);
begin Self.COLLECTION := T; end;

procedure TCOLLECTIONITEMCOLLECTION_R(Self: TCOLLECTIONITEM; var T: TCOLLECTION);
begin T := Self.COLLECTION; end;

{$IFDEF DELPHI3UP}
procedure RIRegisterTOWNEDCOLLECTION(Cl: TPSRuntimeClassImporter);
Begin
with Cl.Add(TOWNEDCOLLECTION) do
  begin
  RegisterConstructor(@TOwnedCollection.Create, 'Create');
  end;
end;
{$ENDIF}

procedure RIRegisterTCOLLECTION(Cl: TPSRuntimeClassImporter);
Begin
with Cl.Add(TCollection) do
  begin
  RegisterConstructor(@TCollection.Create, 'Create');
{$IFDEF DELPHI6UP}  {$IFNDEF FPC} RegisterMethod(@TCollection.Owner, 'Owner'); {$ENDIF} {$ENDIF} // no owner in FPC
  RegisterMethod(@TCollection.Add, 'Add');
  RegisterVirtualMethod(@TCollection.BeginUpdate, 'BeginUpdate');
  RegisterMethod(@TCollection.Clear, 'Clear');
{$IFDEF DELPHI5UP}  RegisterMethod(@TCollection.Delete, 'Delete'); {$ENDIF}
  RegisterVirtualMethod(@TCollection.EndUpdate, 'EndUpdate');
{$IFDEF DELPHI3UP}  RegisterMethod(@TCollection.FindItemID, 'FindItemID'); {$ENDIF}
{$IFDEF DELPHI3UP}  RegisterMethod(@TCollection.Insert, 'Insert'); {$ENDIF}
  RegisterPropertyHelper(@TCOLLECTIONCOUNT_R,nil,'Count');
{$IFDEF DELPHI3UP}  RegisterPropertyHelper(@TCOLLECTIONITEMCLASS_R,nil,'ItemClass'); {$ENDIF}
  RegisterPropertyHelper(@TCOLLECTIONITEMS_R,@TCOLLECTIONITEMS_W,'Items');
  end;
end;

procedure RIRegisterTCOLLECTIONITEM(Cl: TPSRuntimeClassImporter);
Begin
with Cl.Add(TCollectionItem) do
  begin
  RegisterVirtualConstructor(@TCollectionItem.Create, 'Create');
  RegisterPropertyHelper(@TCOLLECTIONITEMCOLLECTION_R,@TCOLLECTIONITEMCOLLECTION_W,'Collection');
{$IFDEF DELPHI3UP}  RegisterPropertyHelper(@TCOLLECTIONITEMID_R,nil,'ID'); {$ENDIF}
  RegisterPropertyHelper(@TCOLLECTIONITEMINDEX_R,@TCOLLECTIONITEMINDEX_W,'Index');
{$IFDEF DELPHI3UP}  RegisterPropertyHelper(@TCOLLECTIONITEMDISPLAYNAME_R,@TCOLLECTIONITEMDISPLAYNAME_W,'DisplayName'); {$ENDIF}
  end;
end;
{$ENDIF}

procedure RIRegister_Classes(Cl: TPSRuntimeClassImporter; Streams: Boolean);
begin
  if Streams then
    RIRegisterTSTREAM(Cl);
  RIRegisterTStrings(cl, Streams);
  RIRegisterTStringList(cl);
  {$IFNDEF PS_MINIVCL}
  RIRegisterTBITS(cl);
  {$ENDIF}
  if Streams then
  begin
    RIRegisterTHANDLESTREAM(Cl);
    RIRegisterTFILESTREAM(Cl);
    RIRegisterTSTRINGSTREAM(Cl);
    {$IFNDEF PS_MINIVCL}
    RIRegisterTCUSTOMMEMORYSTREAM(Cl);
    RIRegisterTMEMORYSTREAM(Cl);
    RIRegisterTRESOURCESTREAM(Cl);
    {$ENDIF}
  end;
  {$IFNDEF PS_MINIVCL}
  RIRegisterTPARSER(Cl);
  RIRegisterTCOLLECTIONITEM(Cl);
  RIRegisterTCOLLECTION(Cl);
  {$IFDEF DELPHI3UP}
  RIRegisterTOWNEDCOLLECTION(Cl);
  {$ENDIF}
  {$ENDIF}
end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.
