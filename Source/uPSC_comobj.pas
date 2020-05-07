{ compiletime ComObj support }
unit uPSC_comobj;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{

Will register:

function CreateOleObject(const ClassName: String): IDispatch;
function GetActiveOleObject(const ClassName: String): IDispatch;

}

procedure SIRegister_ComObj(cl: TPSPascalCompiler);

implementation

procedure SIRegister_ComObj(cl: TPSPascalCompiler);
begin
{+}
  cl.AddTypeS('HResult', 'LongInt');
  cl.AddTypeS('TGUID', 'record D1: LongWord; D2: Word; D3: Word; D4: array[0..7] of Byte; end;');
  cl.AddTypeS('TCLSID', 'TGUID');
  cl.AddTypeS('TIID', 'TGUID');
  cl.AddTypeS('TOleEnum', 'LongWord');
{$if (defined(DELPHI3UP) or defined(FPC))}
  cl.AddDelphiFunction('function CreateGUID(var Guid: TGUID): HRESULT;');
  cl.AddDelphiFunction('function StringToGUID(const S: string): TGUID;');
  cl.AddDelphiFunction('function GUIDToString(const GUID: TGUID): string;');
  cl.AddDelphiFunction('function IsEqualGUID(const guid1, guid2: TGUID): Boolean;');
{$ifend}
{$IFDEF FPC}
    {$IFNDEF PS_NOINTERFACES}{$IFDEF PS_FPC_HAS_COM}
    cl.AddDelphiFunction('procedure OleCheck(Result: HResult);');
    cl.AddDelphiFunction('function CreateComObject(const ClassID: TGUID): IUnknown;');
    cl.AddDelphiFunction('function CreateOleObject(const ClassName: string): IDispatch;');
    cl.AddDelphiFunction('function GetActiveOleObject(const ClassName: string): IDispatch;');
    {$ENDIF}{$ENDIF}
{$ELSE !FPC}
  cl.AddDelphiFunction('procedure OleCheck(Result: HResult);');
  {$IFNDEF PS_NOINTERFACES}{$IFDEF DELPHI3UP}
  cl.AddDelphiFunction('function CreateComObject(const ClassID: TGUID): IUnknown;');
  {$ENDIF} {$ENDIF}
  cl.AddDelphiFunction('function CreateOleObject(const ClassName: string): IDispatch;');
  cl.AddDelphiFunction('function GetActiveOleObject(const ClassName: string): IDispatch;');
{$ENDIF !FPC}
{+.}
end;

end.
