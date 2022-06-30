unit AMUserType;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,jpeg,pngimage, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls,Vcl.Forms,  Vcl.Dialogs, Vcl.StdCtrls,  System.SyncObjs,
  IOUtils,DateUtils,RegularExpressions,JsonDataObjects,math,IdHashMessageDigest,
  WideStrUtils,System.Rtti,Registry,tlhelp32,IdCoderMIME, IdCoder, IdCoder3to4,axCtrls,ShellApi,
  Vcl.ExtCtrls,mmsystem,System.Generics.Collections,TypInfo,Vcl.ComCtrls,Types,ClipBrd,Character,
  IdGlobal;


  type
   TAmProcType = (amProcLoc,amProcObj,amProcRef);

 procedure EmptyProcedure(p:Pointer);
 procedure EmpProcedure(p:Pointer);
 const
   APP_ERROR_SOFT = wm_user+9250233;
 type
  TProcDefault = procedure of object;
  TProcDefaultStr = procedure(str:string) of object;
  TProcDefaultInt = procedure (int:integer) of object;
  TProcDefaultObjStrInt = procedure(S:Tobject;str:string;int:int64) of object;
  TProcDefaultObj2Str = procedure(S:Tobject;Str1,Str2:string) of object;
  TProcDefaultObjVarBoolean = procedure(S:Tobject;var V:boolean) of object;
  TProcDefaultObjWMsg = procedure(S:Tobject;msg : TMsg) of object;
  TProcDefaultError = procedure(Sender:Tobject;const Msg:string; E:Exception=nil) of object;
  TProcColorObj  =  procedure(S:Tobject;Color : TColor) of object;
  TProcColorVar  =  procedure(var Color : TColor) of object;
  TProcColorValue  =  procedure( Color : TColor) of object;
  TProcColorConst  =  procedure(const  Color : TColor) of object;


  TAmMnMx = record
    Mn,Mx,Value:integer;
    function Random:integer;
    procedure MnMaxAProcent(AProcent:integer;AValue:integer);
  end;



 type
  UserConst = record
    const
    FormatDateTime : string ='dd.MM.yyyy" "HH:mm:ss';
    FormatDate : string ='dd.MM.yyyy';
  end;



{types}
type
   PObject = ^TObject;
   TAmProcDestroyEvent  = reference to procedure (Sender: TObject; Value: Pointer);
   IAmInterface  =Interface (IInterface)
   end;
   IAmInterfaceDestroy  =Interface (IAmInterface)
         function  GetOnDestroy:TNotifyEvent;
         Procedure SetOnDestroy(Proc:TNotifyEvent);

         function  GetOnDestroyProc:TAmProcDestroyEvent;
         Procedure SetOnDestroyProc(Proc:TAmProcDestroyEvent);
   end;
Tbytes4096= array[1..4096] of byte;
TamArrayOfReal = array of real;
PAmArray7Bool = ^TAmArray7Bool;
TAmArray7Bool = array[0..7] of boolean;
PAmArrayBits = ^TAmArrayBits;
TAmArrayBits = array of TAmArray7Bool;
PBytes = ^TBytes;

  PAmTextId=^TAmTextId;
  TAmTextId = record
     IsGood:boolean;
     Id:int64;
     Name:string;
     procedure SetValue(Value:string); overload;
     function  SetValue(AId:Int64;AName:string):PAmTextId; overload;
     function GetValue:string;
  end;

{2 типа цело численные значений}
TAmIntB = -1..Integer.MaxValue;
TAmIntB64 = -1..Int64.MaxValue;
TAmString = type string;





type
  PBoolTri =^TBoolTri;
  TBoolTri = (bNot,bFalse, bTrue);

  TBoolTriHelper = record helper for TBoolTri
  public
 //  class operator Implicit(const Value: Boolean): TBoolTri;
   // class operator Implicit(const Value: TBoolTriEnum): TBoolTri;
   // class operator Implicit(const Value: TBoolTri): TBoolTriEnum;
  //  class operator Equal(const lhs, rhs: TBoolTri): Boolean;
  //  class operator LogicalOr(const A, B: TBoolTri): TBoolTri;
  //  class operator LogicalAnd(const A, B: TBoolTri): TBoolTri;

    function ToString: string;
    function ToBool(ResultDefIfValue_bNot:Boolean=False):Boolean;
    function DefTrue:Boolean;
    function DefFalse:Boolean;
    function ToInt:integer;
    function IsValid:boolean;



    procedure SetValue(S:string);overload;
    procedure SetValue(S:Char);overload;
    procedure SetValue(S:integer);overload;
    procedure SetValue(S:int64);overload;
    procedure SetValue(S:TDateTime);overload;
    procedure SetValue(S:Double);overload;
    procedure SetValue(S:Single);overload;
    procedure SetValue(S:Real);overload;
    procedure SetValue(S:SmallInt);overload;
    procedure SetValue(S:Word);overload;
    procedure SetValue(S:Byte);overload;
    procedure SetValue(S:Extended);overload;
    procedure SetValue(S:Boolean);overload;
    procedure SetValue(S:Cardinal);overload;
    procedure SetValue(S:UInt64);overload;
    procedure SetValue(S:ShortInt);overload;


  end;


   TAmIntBHelper = record helper for TAmIntB
       public
        const
         MinValue=-1;
         MaxValue= Integer.MaxValue;
        procedure Init;
        function  I:integer;
   end;
    TAmIntB64Helper = record helper for TAmIntB64
       public
        const
         MinValue=-1;
         MaxValue= Int64.MaxValue;
        procedure Init;
        function  I:Int64;
   end;
   TDateTimeHelper  =  record helper for TDateTime
    public

     function  IsValid:boolean;
     function  IsValidUnix:boolean;

     function  IsValidStr(S:string):boolean;
     procedure SetDate(s:string);
     function SetDateElseNow(s:string):TDateTime;
     function IncStepTime(stepHour,stepMin:integer;hour1,Min1:integer;Var Hour2:Integer;Var Min2:integer):boolean;
     function  DataTimeToString(d,m,y,yIs2,h,n,s,z:boolean):string; overload;
     function  DataTimeToStringDef():string; overload;
     class function  DataTimeToStringCL(D:TDateTime):string;inline;static;
     function  DataTimeToString:string; overload;
     function  DataToString(d,m,y,yIs2:boolean):string;
     function  TimeToString(h,m,s,z:boolean):string;
     function  TimeToStrHM(separator:string=':'):string;
     function GetUnix:Int64;
     procedure SetUnix(V:Int64);
     class function TimeInRange(t1,t2,ANow:TTime):boolean; static; inline;
   end;

   TAmStringHelper = record helper for TAmString
      public
       procedure Clear;
       procedure Apped(s:string;denlim:string);
       procedure AppedNotDublPos(s:string;denlim:string);
       function IsDublValue(s:string;denlim:string):boolean;
       function IsSuch(s:string;denlim:string):boolean;

   end;

  // для сравнения строк разными способами
   PAmStrCmp =^TAmStrCmp;
   TAmStrCmp  = record
     type
      TFunRef = reference to function (Value,Pattern,Source:string):boolean;
      TFunObj = function (Value,Pattern,Source:string):boolean of object;
      TFunLoc = function (Value,Pattern,Source:string):boolean;
      // способы сравнения используются в TAmStrCmp.Cmp
      TEnum = (ascmpsNone, // выключено TAmStrCmp.Cmp = bnot
               ascmpsCustom, // выключено TAmStrCmp.Cmp = bnot но можно как то внешне эт использовать
               ascmpsPos,    // pos
               ascmpsPosInvert,  // обратный pos   а найденая позиция будет с началаа
               ascmpsReg,    // регулярные выражения Pattern помещать в  TAmStrCmp.Value
               ascmpsCmp,   // обчыное равенство
               ascmpsCmpCase, // обчыное равенство без учета регистра
               ascmpsFunRef,  // запускает кастомному процедуру сравнения
               ascmpsFunLoc,  // запускает кастомному процедуру сравнения
               ascmpsFunObj);   // запускает кастомному процедуру сравнения

      TPrm = record
      case TEnum of
           ascmpsNone,
           ascmpsCustom:(
                        b:byte;{не указывать}
                      );


           ascmpsPos,
           ascmpsPosInvert:(
                        PosResult:integer; //результат позиция
                        PosOffset:integer; //параметр функции system.pos
                        // PosIsLast можно применять как с  ascmpsPos  так и с ascmpsPosInvert
                        PosIsLast:boolean; // PosIsLast =true то PosResult позиция с конца иначе как обычно с начала
                        PosResultCmp1:boolean;// вернуть btrue если  PosResult = 1 иначе если btrue если PosResult<>0
                       );


           ascmpsReg:
                      (
                        RegIsBegin:boolean;  // добавить к регярному выражению ^
                        RegIsEnd:boolean     // добавить к регярному выражению $
                      );


           ascmpsCmp,
           ascmpsCmpCase: (
                        ResultFerstCh:Char; {если равно то первый символ строки здесь}
                       );

           // с проц думаю нечего объяснять
           ascmpsFunRef:(FunRef:Pointer); //TFunRef
           ascmpsFunLoc :(FunLoc:Pointer); //TFunLoc
           //что бы получить Code Data   используй M{TMethod}:= MyFunObj;
           ascmpsFunObj:(FunObjCode,FunObjData:Pointer); //TFunObj
      end;

    var
     Typ:TEnum;
     IdCustom:Word; //свободное поле можо использовать когда   Typ = ascmpsCustom
     Prm:TPrm;
     Value:string; // указывается значение что сравнивать а с чем будет предано в  function Cmp(Source:string) если typ =  ascmpsReg укажите сюда регулярное выражение
     Rreg:string;//тут будет результат что нашла регулярка   если typ =  ascmpsReg
     procedure Clear;
     function Cmp(Source:string):TBoolTri;
     procedure ObjectSaveToJson(J:TJsonObject);
     procedure ObjectLoadFromJson(J:TJsonObject);
     procedure CopyFrom(Source:PAmStrCmp);
   end;


  type
  TALF = record
      const
       amp:string='&';
       q:string='q';
       w:string='w';
       e:string='e';
       r:string='r';
       t:string='t';
       y:string='y';
       u:string='u';
       i:string='i';
       o:string='o';
       p:string='p';
       a:string='a';
       s:string='s';
       d:string='d';
       f:string='f';
       g:string='g';
       h:string='h';
       j:string='j';
       k:string='k';
       l:string='l';
       z:string='z';
       x:string='x';
       c:string='c';
       v:string='v';
       b:string='b';
       n:string='n';
       m:string='m';
       й:string='й';
       ц:string='ц';
       у_r:string='у';
       к:string='к';
       е_r:string='е';
       н:string='н';
       г:string='г';
       ш:string='ш';
       щ:string='щ';
       з:string='з';
       х_r:string='х';
       ъ:string='ъ';
       ф:string='ф';
       ы:string='ы';
       в_r:string='в';
       а_r:string='а';
       п:string='п';
       р:string='р';
       о_r:string='о';
       л:string='л';
       д:string='д';
       ж:string='ж';
       э:string='э';
       я:string='я';
       ч:string='ч';
       с_r:string='с';
       м:string='м';
       и:string='и';
       т:string='т';
       ь:string='ь';
       б:string='б';
       ю:string='ю';

       Qb:string='Q';
       Wb:string='W';
       Eb:string='E';
       Rb:string='R';
       Tb:string='T';
       Yb:string='Y';
       Ub:string='U';
       Ib:string='I';
       Ob:string='O';
       Pb:string='P';
       Ab:string='A';
       Sb:string='S';
       Db:string='D';
       Fb:string='F';
       Gb:string='G';
       Hb:string='H';
       Jb:string='J';
       Kb:string='K';
       Lb:string='L';
       Zb:string='Z';
       Xb:string='X';
       Cb:string='C';
       Vb:string='V';
       Bb:string='B';
       Nb:string='N';
       Mb:string='M';
       Йб:string='Й';
       Цб:string='Ц';
       Уб:string='У';
       Кб:string='К';
       Еб:string='Е';
       Нб:string='Н';
       Гб:string='Г';
       Шб:string='Ш';
       Щб:string='Щ';
       Зб:string='З';
       Хб:string='Х';
       Ъб:string='Ъ';
       Фб:string='Ф';
       Ыб:string='Ы';
       Вб:string='В';
       Аб:string='А';
       Пб:string='П';
       Рб:string='Р';
       Об:string='О';
       Лб:string='Л';
       Дб:string='Д';
       Жб:string='Ж';
       Эб:string='Э';
       Яб:string='Я';
       Чб:string='Ч';
       Сб:string='С';
       Мб:string='М';
       Иб:string='И';
       Тб:string='Т';
       Ьб:string='Ь';
       Бб:string='Б';
       Юб:string='Ю';
       VarNullStr:string='';

       VarZero:integer=0;
       var1:integer=1;
       var2 :integer=2;
       var3:integer=3;
       var4:integer=4;
       var5:integer=5;
       var6:integer=6;
       var7:integer=7;
       var8:integer=8;
       var9:integer=9;
      var
      value:string;
  end;
  // укомпанованная структура
  { TAmCaseRec<T> показан пример реализации  когда в record есть
    др несколько record  но всегда заполняется только 1
    при условии что внутри др record есть поля не типизированной длинны

    для того что бы не занимать память которая никак не будет использована
    и что бы вручную выделять New и не чистить Dispose памать record

    так же это способ позволяет не писать код для копирования всех полей в другой record
    а обойтись обычным присвоением R2:=R1;

    type начинать читать с  TRecBase
    это та запись которой пользуемся внешне

    TRecBase  = record
    strict private
      CaseVar :IInterface;
     public
      typ:integer;
      function Rec1:PSim_Obj_1;
      function Rec2:PSim_Obj_2;
      procedure Load;
    end;
     typ:integer; показывает что именно хранится в  CaseVar :IInterface;

       внещне получится сл.
       var Rec:TRecBase;
       i:integer;
       begin
           Rec.Load; //>>  на практике в load передается jsonObject Rec.Load(J['todo'].ObjectValue);


           case Rec.typ of
             1: i:=Rec.Rec1.i;
             2: i:=Rec.Rec2.i2;
             else i:=-1;
           end;
       end;

       заметте что  Rec1 Rec2 вернет указатели на запись

       итак
      TSim_Obj_1
      TSim_Obj_1 записи которые могут использоватся где угодно

      остальные типы данных служат что бы реализовать нашу цель

     укомпонованная структура находится в TAmCaseRec<T>
   type
    ////////////////////
    PSim_Obj_1 = ^TSim_Obj_1;
    TSim_Obj_1= record
     s:string;
     i:integer;
     procedure Load;
    end;
    //////////////////



    ISim_Obj_1 = Interface (IInterface)
      function Get:PSim_Obj_1;
    End;
    OSim_Obj_1 =class (TInterfacedObject,ISim_Obj_1)
       Rec:TSim_Obj_1;
       function Get:PSim_Obj_1;
       destructor Destroy;override;
    end;

    ///////////////////////////
    PSim_Obj_2 = ^TSim_Obj_2;
    TSim_Obj_2= record
     ud2:integer;
     s:string;
     name2:string;
     i2:integer;
     procedure Load;
    end;
    ///////////////////////////////

    ISim_Obj_2 = Interface (IInterface)
      function Get:PSim_Obj_2;
    End;
    OSim_Obj_2 =class (TInterfacedObject,ISim_Obj_2)
       Rec:TSim_Obj_2;
       function Get:PSim_Obj_2;
       destructor Destroy;override;
    end;



    // итоговой вариант пример

procedure TRecBase.Load(Atyp:integer);
var I1:TAmCaseRec<TSim_Obj_1>.I;
    I2:TAmCaseRec<TSim_Obj_2>.I;
begin
   typ:=Atyp;
   case typ of
        1:begin
           I1:=TAmCaseRec<TSim_Obj_1>.New;
           I1.Get.Load;
           CaseVar:=I1;

        end;
        2:begin
           I2:=TAmCaseRec<TSim_Obj_2>.New;
           I2.Get.Load;
           CaseVar:=I2;
        end
        else CaseVar:=nil;
   end;
end;
function TRecBase.Rec1:TAmCaseRec<TSim_Obj_1>.P;
begin
   Result:= TAmCaseRec<TSim_Obj_1>.I(CaseVar).Get;
end;
function TRecBase.Rec2:TAmCaseRec<TSim_Obj_2>.P;
begin
   Result:= TAmCaseRec<TSim_Obj_2>.I(CaseVar).Get;
end;
  TAmCaseRec<T : record> =  record
    type
       P =  ^T;
       I =   Interface (IInterface) function Get:P; end;
       O =   class (TInterfacedObject,I)var Rec:T;function Get:P;end;
       class function New:I; static; inline;
  end;

class function TAmCaseRec<T>.New:I;
begin
   Result:=O.Create;
end;
function TAmCaseRec<T>.O.Get:P;
begin
   Result:= @Rec;
end;
  }


 type
   TTypeKindSet =set of TTypeKind;
   PIAmCaseObjBase = ^IAmCaseObjBase;
   IAmCaseObjBase  =Interface (IAmInterfaceDestroy)
         function GetValuePointer:Pointer;
         procedure SetInstanceInterface(Value:PIAmCaseObjBase);
   end;

  TAmCaseObj<T> =  record
    type

       P =   ^T;
       I =   Interface (IAmCaseObjBase)
                 function GetT:T;
                 function GetP:P;
                 Procedure SetT(Value:T);
                 Procedure SetP(Value:P);
                 Procedure GetVar(var Value:T);


       end;
       O =   class (TInterfacedObject,I)
             public
              var Value:T;
              InstanceInterface:PIAmCaseObjBase;
              OnDestroy:TNotifyEvent;
              OnDestroyProc:TAmProcDestroyEvent;
              function GetT:T;
              function GetP:P;
              function GetValuePointer:Pointer;
              procedure SetT(AValue:T);
              procedure SetP(AValue:P);
              procedure GetVar(var AValue:T);
              function  GetOnDestroy:TNotifyEvent;
              procedure SetOnDestroy(AOnDestroy:TNotifyEvent);
              function  GetOnDestroyProc:TAmProcDestroyEvent;
              Procedure SetOnDestroyProc(Proc:TAmProcDestroyEvent);
              procedure SetInstanceInterface(Value:PIAmCaseObjBase);
              constructor Create;
              destructor Destroy;override;
       end;
       public


         class function New:I; static; inline;
         class procedure CreateError(Source:IAmInterface;place:string); static; inline;
         class procedure IsError(Source:IAmInterface;place:string); static; inline;
         class function IsInterface(Source:IAmInterface):boolean; static; inline;
         class function GetT(Source:IAmInterface):T; static; inline;
         class function GetP(Source:IAmInterface):P; static; inline;
         class function GetPointer(Source:IAmInterface):Pointer; static; inline;
         class procedure SetT(Source:IAmInterface;Value:T); static; inline;
         class procedure SetP(Source:IAmInterface;Value:P); static; inline;
         class procedure GetVar(Source:IAmInterface;var Value:T); static; inline;
         class function GetOnDestroy(Source:IAmInterface):TNotifyEvent; static; inline;
         class procedure SetOnDestroy(Source:IAmInterface;Proc:TNotifyEvent); static; inline;
  end;

  // укомпанованная структура
  //если в record есть куча разных рекордод
  //но всегда заполнятся только один из них и это T
  // это тож что и  record case но для нетипизированных типов
  // также жтот тип можно использовать если есть какой то класс
  // его нужно же создать и удалить а делать это сложно то
  //можно заменить его рекордом с аналогичными методами
  //и в рекорде при кажлом вызове чекать создался ли класс
  //при создании указать процедуру событиее удаления объекта и все
  //см пример как сделано в TAmListVar<T> =record  procedure TamListVar<T>.InitCheck;
  // см пример как сделано в AmCrypto.Classes.TAmCrt<T:TAmClassCrtCustom> = record
  TAmCaseRec =  record
       strict private
         CaseInterface : IAmCaseObjBase;
       public
         procedure Clear;
         function IsAssignedInterface:boolean;
         procedure New<T>;

         //медленный способ достпупа к ссылке на   TAmCaseObj<T>.O.Value;
         //с проверкой на совпадения типов
         function GetP<T>:Pointer;
         function GetT<T>:T;
         procedure SetT<T>(Value:T);

         //установка T может привести к не моментальной ощибке если ^T <> Pointer
         // SetP<TMyRec>(@MyRec) так правильно
         procedure SetP<T>(Value:Pointer{^T});  // Value это ^T

         //быстрый способ достпупа к ссылке на   TAmCaseObj<T>.O.Value;
         //без проверок типов
         function GetValuePointer:Pointer;

         // получить событие когда  TAmCaseObj<T>.O будет удалятся
         function GetOnDestroy:TNotifyEvent;
         procedure SetOnDestroy(Proc:TNotifyEvent);

         // на практике лучше это событие использовать
         function GetOnDestroyProc:TAmProcDestroyEvent;
         procedure SetOnDestroyProc(Proc:TAmProcDestroyEvent);
  end;
  TAmRecordInterface =  TAmCaseRec;


function AmArrayOfRealToJsonString(aReal:TamArrayOfReal):string;
function AmJsonStringToArrayOfReal(JsonString:string):TamArrayOfReal;


type
AmCase = class
  type
   I32 =class
       type
        TArr = record
        case Boolean of
          True : (Bytes: array[0..3] of Byte);
          False: (Int  : Int32);
        end;
        PArr = ^TArr;
   end;
   TCardinal =  class
       type
        TArr = record
        case Integer of

          0: (C  : Cardinal);
          1 : (w1,w2:Word);
          2 : (B: array[0..3] of Byte);
        end;
        PArr = ^TArr;

  end;
   Int64 =  class
       type
        TArr = record
        case Integer of
          0:  (L  : Int64);
          1:  (I1,I2:integer);
          3 : (W1,W2,W3,W4:Word);
          4 : (B: array[0..8] of Byte);
        end;
        PArr = ^TArr;
  end;
end;

type
 AmStream = class
   const MaxSizeString :int64 =200*1000000;//200Mb
   class function SteamToStr(Strm:TStream;var S:string):boolean; static; //inline;
  class procedure StrToSteam(Strm:TStream;S:String); static; // inline;
 end;
 AmBit = class

         {
          в одном байте 8 бит
          бит это 1 или 0

          байт 255 имеет [1,1,1,1,1,1,1] это аналогично  [true,true,true,true,true,true,true]

          пример как получить доступ к битам и чето там изменить или прочитать
        var
            Buf:TBytes;
            Bts:TAmArrayBits;
            s:string;
        begin
            S:='1234';
            Buf:=AmBytes(s);

            Bts:=AmBit.BytesToArrayBitsType(Buf);

            ///////////////////
            if length(Bts)>1 then
            Bts[1][2]:= not Bts[1][2]; // изменяем во 2 м байте 3й бит на противоположный
            // в данном примере двойка в строке '1234' заменится на шестерку  '1634'
            //или так можно Bts[1][2]:= true ;

            /////////////////


           setlength(Buf,0);
           // и обратно преобразовывает набор бит в байты а потом в строку
           Buf:= AmBit.ArrayBitsToBytesType(Bts);

           S:= AmStr(Buf);// >>  S='1634'
         }

       //input type | (array of byte)  << >>    (array of array of bit)
       class function BytesToArrayBitsType(buf:TBytes):TAmArrayBits;
       class function ArrayBitsToBytesType(ArrayBits:TAmArrayBits):TBytes;

       //input type  | (byte)  << >>    (array of bit)
       class function BitsToByteType(Bits:TAmArray7Bool):byte;
       class function ByteToBitsType(b:byte):TAmArray7Bool;





       //input pointer | (array of byte)  << >>    (array of array of bit)
       class procedure BytesToArrayBits(b:Pbyte;Result:PAmArray7Bool;Count:integer);
       class procedure ArrayBitsToBytes(Bits:PAmArray7Bool;Result:Pbyte;Count:integer);

       class procedure BytesToArrayBits2(Buff:PBytes;Result:PAmArrayBits);
       class procedure ArrayBitsToBytes2(ArrayBits:PAmArrayBits;Result:PBytes);



       //input pointer  | (byte)  << >>    (array of bit)
       class procedure BitsToByte(Bits:PAmArray7Bool;Result:Pbyte);
       class procedure ByteToBits(b:Pbyte;Result:PAmArray7Bool);




       //  hlp bit
       class function BitGetMask(N:Cardinal):Cardinal;
       class function BitGetPos(N:Cardinal):Cardinal;
       class function BitTrue(Src: Cardinal; bit: Cardinal): Cardinal;
       class function BitFalse(Src: Cardinal; bit: Cardinal): Cardinal;
       class function BitInvert(Src: Cardinal; bit: Cardinal): Cardinal;
       class function BitGet(Src: Cardinal; bit: Cardinal): Boolean;
       class function BitSet(Value:Boolean;Src: Cardinal; bit: Cardinal): Cardinal;
 end;
function AmAddresToByteStr(A:Pointer;Size:integer):string;
procedure AmAddressShow(Caption:string;A:Pointer;Size:integer);

Procedure  AmByteWrite(Source:Pointer;var Desc:Pointer;Siz:Integer);
Procedure  AmByteRead(var Source:Pointer;Desc:Pointer;Siz:Integer);

function  IntToBin(Value: integer; Digits: integer): string;
function  amBytes( Value:string):TBytes; overload;
function  amBytesCount( Value:string):Integer;
Procedure  amBytes(var Buff:TBytes; Value:string;DeLimiter:string) overload;
function  amBytes( Value:Integer):TBytes;overload;
function  amBytes( Value:Word):TBytes;overload;
function  amBytes( Value:Int64):TBytes;overload;
function  amBytesDeleteNull( Bytes:TBytes):TBytes;
function  amBytes( Value:Real):TBytes;overload;
function  amArray(var Value:string;DeLimiter:string):TArray<string>; overload;
function  amArray(L:Tstrings):TArray<string>;     overload;
function  amStr(var Value:TArray<string>;DeLimiter:string):string; overload;
function  AmStr(Value:TBytes;DeLimiter:string):string; overload;
function amInt64(value:TBytes):int64; overload; inline;
function  AmStrSizeFile(V:Int64):string;

function MyStrToBool(str: string;def:boolean=false): Boolean;
function MyStrToInt(str: string;def:integer=0): integer;
function MyStrToInt64(str: string;def:int64=0): int64;
function MyStrToDateTime(str: string;Deff:string=''): TDateTime;
function MyStrToColor(str:string;deff:Tcolor=0):Tcolor;


function amInt(Bytes:Tbytes):integer; overload; inline;
function amHexToInt(s:string):integer; overload; inline;
function amHexToP(s:string):Pointer; overload; inline;
function amInt(value:string):integer; overload; inline;
function amInt(value:boolean):integer;overload; inline;
function amInt64(value:string):int64; overload; inline;
function amInt(value:real):integer;  overload; inline;

function amInt(value:string;deff:integer):integer; overload;inline;
function amInt64(value:string;deff:int64):int64;  overload; inline;
function amInt(value:real;deff:integer):integer;  overload; inline;
function AmStrIndexOf(L:TStrings; Name:string):integer;
function AmStrIndexOfTextId(L:TStrings; AId:Int64):integer;

function amReal(Bytes:Tbytes):Real; overload; inline;
function amReal(value:integer):Real;  overload; inline;
function amReal(value:string):Real;  overload; inline;
function amReal(value:integer;deff:Real):Real;  overload;inline;
function amReal(value:string;deff:Real):Real;  overload;inline;


function  AmStrCopy(V:string;Count:integer):string;
function  AmStrCutMore(V:string;Count:integer):string;
function amStrSpace(value: string;CharCount:integer=3): string;  //разделить сторку пробелами 1 000 000
function amStr(value:SmallInt):string; overload; inline;
function amStr(value:Word):string; overload;  inline;
function amStr(value:integer):string; overload; inline;
function amStr(value:int64):string;  overload;inline;
function amStr(value:real):string;  overload;  inline;
function amStr(Value: Extended):string;overload;inline;
function amStrReal(Value: Extended):string; inline;
function amStr(value:double):string;  overload; inline;
function amStrRound(value:real;roundCount:integer=-2):string;  overload;inline;
function amStr(value:boolean):string; overload; inline;
function amStrColor(value:Tcolor):string; overload;  inline;
function amStr(value:Tdate):string; overload;  inline;
function amStr(value:Tdatetime):string; overload;
function amStr(value:Tdatetime;full:boolean;Format:string=''):string; overload;inline; //если   full =true то FormatDateTime('dd.mm.yyyy" "hh:nn:ss:zzz',value);
function amStr(const a: Tarray<Char>): string; overload;inline;
function amStr(const a: array of Char): string; overload;
function amStr(aStream: TStream): string; overload; inline;
function AmStrTrade(val:real):string;inline;
function AmStrTradeRound(val:real):string;inline;
//function AmStrKysr2(val:real):string;inline;
//function AmStrKysr(val:real):string; inline;
function amStr(var Bytes:TBytes):string; overload; inline;
function amStr(var Bytes:Tbytes4096):string; overload; inline;
function amStr(var Bytes;Count:integer):string; overload; inline;
function amStr(pByte:Pointer;Count:integer):string; overload; inline;

function amBytesToStr(var Bytes;Count:integer):string;overload;  inline;
function amStrDecode(V:string):string;overload;  inline;

function amBytesToStr(pByte:Pointer;Count:integer):string; overload; inline;
procedure amStrToBytes(S:String;pByt:Pointer;Count:integer);inline;

function amBool(value:string):Boolean; overload; inline;
function amBool(value:integer):Boolean;overload; inline;
function amBool(value:string;deff:boolean):Boolean; overload; inline;
function amBool(value:integer;deff:boolean):Boolean;overload; inline;
function amBool(value:real;deff:boolean):Boolean;overload; inline;
function amBool(value:double;deff:boolean):Boolean;overload; inline;

function amDateTimeCorrect (value:TDateTime):TDateTime;overload;// inline;
function amDate (value:string):TDateTime;overload; inline;
function amDate (value:string;deff:string):TDateTime; overload; inline;
function amDate (value:string;deff:TDate):TDate;overload; inline;
function amDateTime (value:string):TDateTime; overload; inline;
function amDateTime2000 (value:string):TDateTime; inline;
function amDateTime (value:string;deff:string):TDateTime; overload;inline;
function amDateTime (value:string;deff:TDateTime):TDateTime; overload; inline;

function amColor   (value:string):TColor; overload;inline;
function amColor   (value:string;deff:TColor):TColor;overload; inline;
function amColor   (value:string;deff:string):TColor;overload; inline;


{files}
procedure AmAppedTextFile(const aFile: string; const Msg: string);
function  AmSizeFile(FNameFull: string): int64;
function GetFileDate(FileName: string): string;
function RenameFileRandom(FullPatch: string): Boolean;
function GetInDirOneRandomFile(patch1,listFormat:string):string;
function GetOneFile_InDirOrFile(patch1,listFormat:string;var NameSmena:boolean ):string; //инпут или файл или папка result один файл с папки или сам файл
function AmIsFileInUse(const FullPatch: string): Boolean;

function AmIsFileInUseWaitFor(const FullPatch: string;Second:integer=1): Boolean;
function AmFileIsFree(const FullPatch: string): Boolean;
function AmFileIsFreeRead(const FullPatch: string): Boolean;
function AmCheckFile(const FullNameFile: string): Boolean;
function serchAccObj(amyid: string;aObj:Tjsonobject;aPath:string='acc'): integer;
function CountPos(const subtext: string; Text: string): Integer;
function AmPosArray(A:TArray<string>;Input:string):boolean;
function AmPosArrayIndexOf(A:TArray<string>;Input:string;var Index:integer;var APos:integer):boolean;
function AmPosArrayIndexOfRevers(A:TArray<string>;Input:string;var Index:integer;var APos:integer):boolean;
function AmCmpArray(A1,A2:TArray<string>):boolean;

function generatPass(count: integer): string;
function generatNumb(count: integer): string;
function generatPassC(count: integer): string;


function GetValueYarc(Color:TColor):integer; //по колору определить яркость if GetValueYarc(mycol)<35 then темный
function SetValueYarc(Color:TColor;val:byte):TColor;

function md5(s: string): string;
function md5Bytes(s:TBytes): TBytes;
function HookEcode(s: string): string;
function HookDecode(s: string): string;
function Hook2Ecode(s: string): string;  //перемешивает символы в строке
function Hook2Decode(s: string): string; //восстанавливает строку



{поиск в байтах}
 type
  AmPosBytes = class
       type
        TPosFileItem = record
          Result: boolean;
          Ferst, Last, Size: int64;
        end;
               TSetSymbol  = set of byte;
        type   PKeyValue=^TKeyValue;
               TKeyValue =record
                BPatern,   //что ишем какой Key ищем
                BSource:Tbytes;//где ишем
                CountBPatern,  //количество байт от что ишем
                CountBSource,  //количество байт от где ишем
                Offset:integer;  // смешение что бы не перебирать каждый байт зависит от длинны type или строки можно и 1 но это плохо
                SymbolBegin, //символы byte которые означают что это начало записи SymbolBegin:=[10]; любой из указанных означает что сейчас начнется новая запись
                SymbolEndKey: byte;    //символ означает что это конец key дальше value
                SymbolEnd :TSetSymbol//символы byte которые означают что это конец записи SymbolEnd:=[13];
                //сторока может быть такой #10+'12345'+':'+'bla bla...'+#13
                // #10+'12345'+#13 если bla bla нет то SymbolEndKey = SymbolEnd передать что они равны

                //ReCallback,ReEtap,ReEnd,  // установить в 0 до вызова внешнего цикла обрашения к файлу
               // ReLast,ReFerst,ReSize:int64; // установить в Int64.MinValue когда найден результат здесь булет первая и последняя позиция вхождения

        end;
      class function IncCallback (BPatern:Tbytes;BSource:Tbytes;CountBPatern,CountBSource:int64;var Callback:int64):int64;
      class function Incer (BPatern:Tbytes;BSource:Tbytes;CountBPatern,CountBSource:int64):int64;
      class function Careta (BPatern,BSource:Tbytes;CountBPatern,CountBSource,offset:int64;var Callback:int64):int64;




      class Procedure KeyValue(P:TKeyValue;IsBeginFile:boolean;var ReCallback,ReEtap,ReEnd,ReLast,ReFerst:int64);

      class Procedure SizeFixed(P:TKeyValue;IsBeginFile:boolean;var ReCallback,ReEtap,ReEnd,ReLast,ReFerst:int64);

      type
      PPosTxt = ^TPosTxt;

      TPosTxt = record
       public
        var ReCallback, ReEtap, ReLast,
        ReFerst: int64;
        ChangeReFerst:boolean;
        SizeFile: int64;
        PosFile: int64;
        IsBeginFile: boolean;
       ////////////////////////////
        BPatern, // что ишем какой Key ищем
        BSource: Tbytes; // где ишем
        CountBPatern, // количество байт от что ишем
        CountBSource, // количество байт от где ишем

        Offset: integer;
        // смешение что бы не перебирать каждый байт зависит от длинны type или строки можно и 1 но это плохо
        SymbolBegin,
        // символы byte которые означают что это начало записи SymbolBegin:=[10]; любой из указанных означает что сейчас начнется новая запись
        SymbolEndKey: byte; // символ означает что это конец key дальше value
        SymbolEnd: AmPosBytes.TSetSymbol;
        // символы byte которые означают что это конец записи SymbolEnd:=[13];


        // сторока может быть такой #10+'12345'+':'+'bla bla...'+#13
        // #10+'12345'+#13 если bla bla нет то SymbolEndKey = SymbolEnd передать что они равны

        // ReCallback,ReEtap,ReEnd,  // установить в 0 до вызова внешнего цикла обрашения к файлу
        // ReLast,ReFerst,ReSize:int64; // установить в Int64.MinValue когда найден результат здесь булет первая и последняя позиция вхождения

      end;

      class function PosTxt(P: PPosTxt): boolean;
  end;


type ToTypes = class
public
Class function  ToBytesArray<T>(value:TArray<T>):TBytes;overload; inline; static;
Class function  ToBytes<T>(value:T):TBytes;overload; inline; static;
Class procedure  ToBytes<T>(value:T;var B:TBytes);overload; inline; static;
Class procedure  ToBytesBuffer<T>(value:T;var B); inline; static;
Class procedure  ToBytesPbyte<T>(value:T;B:Pbyte);inline; static;
Class function  ToType<T>(Bytes:TBytes):T;overload; inline; static;
Class procedure ToType<T>(Bytes:TBytes;var X:T);overload; inline; static;
Class procedure ToTypeBuffer<T>(var B;var X:T); inline; static;
Class procedure ToTypePbyte<T>(B:Pbyte;var X:T); inline; static;

Class function  ToBytesRtti<T>(value:T):TBytes; inline; static;
Class function  ToTypeRtti<T>(Bytes:TBytes):T; inline; static;

Class function BtoS(p:Pbyte;pCount:integer):String; //inline; static;
Class procedure StoB(S:String;p:Pbyte;pCount:integer);//inline; static;
end;

//добавить прогу в автозапуск системы
type ToStartWindows = record
Class procedure  Add; inline; static;
Class procedure  Delete; inline; static;
end;


{циклы ожидания выполнения условий}
type ToWaitFor = record
     Type Tfun = reference to function : boolean;
Class function  Go(SecondMax:integer;Fun:Tfun;aAutoSleep:boolean=false):boolean; inline; static;
Class function  GoDelay(SecondMax:integer;Fun:Tfun):boolean; inline; static;
Class function  GoSleep(SecondMax:integer;Fun:Tfun):boolean; inline; static;
Class function  GoSleepInterval(MiliSecondsSleep,IntervalCheckFun:integer;Fun:Tfun):boolean; inline; static;
end;

  // много поточный доспуп к простым переменным
  // и выполненение с ними простых действий переменная
  //не может быть больще sizeof(int64)
  type
  AmAtomic =  class //TInterlocked
        type
         Lock = TInterlocked;
       //Getter вернет значение Target
       //Setter вернет предыдущее значение  Target
       //Iif выполнить операциию сравнения и если равно заменит  Target  на новое вернет старое значение

        {integer}
       class Function Getter(var Target:Integer):integer;  overload; static; inline;
       class Function Setter(var Target:Integer;Value:Integer):integer; overload; static; inline;
       class Function Iif(var Target:Integer;NewValue: integer;Comparand :Integer):integer; overload; static; inline;

       class Function Getter(var Target:Word):Word;  overload; static; inline;
       class Function Setter(var Target:Word;Value:Word):Word; overload; static; inline;


       class Function Getter(var Target:Int64):Int64;  overload; static; inline;
       class Function Setter(var Target:Int64;Value:Int64):Int64; overload; static; inline;
       class Function Inc(var Target:Int64;CountAdd: Int64=1):Int64; overload; static; inline;
       class Function NewId(var Target:Int64):Int64; overload; static; inline;

       class Function Getter(var Target:Cardinal):Cardinal;  overload; static; inline;
       class Function Setter(var Target:Cardinal;Value:Cardinal):Cardinal; overload; static; inline;





       class Function Getter(var Target:Pointer):Pointer;  overload; static; inline;
       class Function Setter(var Target:Pointer;Value:Pointer):Pointer; overload; static; inline;
       class Function Clear(var Target:Pointer):Pointer; overload; static; inline;


       class Function Getter(var Target:HWND):HWND;  overload; static; inline;
       class Function Setter(var Target:HWND;Value:HWND):HWND; overload; static; inline;

       class Function Inc(var Target:Cardinal;CountAdd: integer=1):Cardinal; overload; static; inline;
       class Function NewId(var Target:Cardinal):Cardinal; overload; static; inline;
       class Function Iif(var Target:Cardinal;NewValue: Cardinal;Comparand :Cardinal):Cardinal;overload; static; inline;

       class Function Getter(var Target:Boolean):Boolean;  overload; static; inline;
       class Function Setter(var Target:Boolean;Value:Boolean):Boolean; overload; static; inline;


       class Function Getter(var Target:TBoolTri):TBoolTri;  overload; static; inline;
       class Function Setter(var Target:TBoolTri;Value:TBoolTri):TBoolTri; overload; static; inline;


       class Function Getter(var Target:TDateTime):TDateTime;  overload; static; inline;
       class Function Setter(var Target:TDateTime;Value:TDateTime):TDateTime;overload; static; inline;

       class function Getter<T: class>(var Target: T): T; overload; static; inline;
       class function Setter<T: class>(var Target: T; Value: T): T; overload; static; inline;
  end;

{переменная зашишеная критической секцией}
type TamVarCs<T> = class
   type
    P=^T;
    private
      Fval:T;
      FCs:TCriticalSection;
      function GetVal:T;
      procedure SetVal(v:T);
      function GetPointed:P;
      procedure SetPointed(v:P);
    public
      procedure Enter;
      function  TryEnter:boolean;
      procedure Leave;
      property Val: T Read  GetVal Write SetVal;
      property Pointed: P Read GetPointed Write SetPointed;
      constructor Create;
      destructor Destroy; override;
end;

type TAmAutoFreeObject = class
       type
         TList = class (TList<TAmAutoFreeObject>)
           {protected
             CounterId:Cardinal;
             IsMaxValuePassed :boolean;
             IsDestroing:boolean;
             function ObjectIndexOfBin(Item:TAmAutoFreeObject):integer;
             procedure ObjectAdd(Item:TAmAutoFreeObject);
             procedure ObjectDelete(Item:TAmAutoFreeObject);
             }
           public
            // constructor Create;
            // destructor Destroy; override;
         end;
         {
     private
      Id:Cardinal;
     public
     }
      constructor Create;
      destructor Destroy; override;
end;


//для перессылки сообщения через PostMessage
type TamPostMessage<T> = class (TAmAutoFreeObject)
    public
     str1,str2,str3,str4:string;
     int1,int2,int3,int4:integer;
     intL1,intL2,intL3,intL4:int64;
     real1,real2,real3,real4:real;
     bool1,bool2,bool3,bool4:boolean;
     p1,p2,p3,p4:Pointer;
     Records:T;
end;

 //для перессылки сообщения через PostMessage и ожидания выполнения
type TamPostMessageResult<T1,T2> = class (TamPostMessage<T1>)
     type
     TPostMessageCS = (recsNone,recsNoSend,recsOk,recsTimeOut,recsError);
     private
      FEventSend:TEvent;

     public
     const ConstInitObject=99;
     var
     InitObject:byte;
     Result:TamVarCs<T2>;
     function PostMessageWaitFor(aHandle:HWND;aMessage:UINT;SecondWaitFor:Integer;Fun:ToWaitFor.Tfun):longBool;

     //если использовать PostMessageLock то в той процедуре которой отпраляется сообщение вызвать  SignalSetEvent
     // что уведомит PostMessageLock что та процедура выполнилась и результат получен
     // используется в рамках одной программы что бы пересылать сообщения меж программами нужно взять класс в модуле AmHandleObject
     function PostMessageLock(aHandle:HWND;aMessage:UINT;TimeOutSeconds:Cardinal):TPostMessageCS;
     procedure SignalSetEvent;
     constructor Create;
     Destructor Destroy; override;
end;


  // пересылка сообщений с ожиданием тайаута типа SendMessage  но лучше
type amSendMessage = class

     class function SendTimeOut(aHandle,Msg,WParam,Lparam:Cardinal;TimeOut:UINT=2000):Lresult;static;
     class function Def(aHandle,Msg,WParam,Lparam:Cardinal;var ResultMsg:DWORD;TimeOut:UINT=2000):Lresult;static;
end;

// регурярные выражения
type AmReg = record
     Class procedure GetAllValue(var Arr:TArray<string>;Regulur,Input:string);inline; static;
     Class function GetValue(Regulur,Input:string):string;inline; static;
     Class function Replace(Regulur,Input,Replaced:string):string;inline; static;
end;

// memory в строку и обратно формат Base64 для картинок удобно
type AmBase64 = record
     Class function  Base64ToStream(S:TStream;value:string):boolean;inline; static;
     Class function  StreamToBase64(S:TStream;var value:string):boolean;inline; static;
end;

//Функция возврящает количество байт выделенных под Pointer.
//Размер округляется в большую сторону до DWORD (4 байт).
Function GetPointerSize(Const P: Pointer): Integer;
//убить процесс
function KillTask(ExeFileName: string): Integer;

// sleep для главного потока приложения
procedure Delay(ms: Cardinal);

// sleep2 для главного потока приложения
procedure DelayP(ms: Cardinal);

// автоопределение какой sleep использовать
procedure AutoSleep(ms: Cardinal);

// в каком потоке выполняется эта функция


function AmMainPot:Cardinal;
function AmIsMainPot:boolean;
function AmGetIdPot:Cardinal;
function AmGetIdMainPot:Cardinal;

// функция pos но ищет с конца
function PosR2( const FindS, SrcS: string;offset:integer=1): Integer;

// зеркально отражает строку
function InvertS(const S: string): string;

// находятся ли мыщка на элементе
Function MouseInControl(WC:TWincontrol;IsCanFocus:boolean=true):boolean;
Function MouseControlAtPos(Pos:TPoint;WC:TWincontrol=nil):TControl;
function MouseForControl(AControl: TWinControl): TPoint;


// не доделаный ресурс
type TamResource = class
      private
        Cs:Tevent;
        procedure CsOpen;
        procedure CsClose;

      public
        Class function    CreateAndGetStream(ResourceNameIndificator:string):TResourceStream; inline; static;

        function          GetStreamCs(ResourceNameIndificator:string):TResourceStream;
        Class function    GetString(var ResultText:string; ResourceNameIndificator:string):boolean; inline; static;

        function          GetStringCs(var ResultText:string; ResourceNameIndificator:string):boolean;

        //TArrByte;   если filename ='' то с текущей проги если есть то c LoadLibrary
        Class function    GetBytes_for_ArrByte(const FileNameExe:string;ResourceNameIndificator:string;L:Pointer):boolean;


        Class function    LoadToPicture(Picture: TPicture;ResourceNameIndificator:string):boolean; inline; static;

        //  FileNameExe не должен быть запушен
        Class function    UpdateExe_for_ArrByte(FileNameExe, ResourceNameIndificator:string;L:Pointer):boolean;

        Class function    UpdateExe(FileNameExe, ResourceNameIndificator:string;data: TStream;AType: PChar{RT_RCDATA}):boolean;

   
        constructor Create;
        destructor Destroy; override;
end;






// поиск с сравнением своей функцией
type amSerch = record
     Type Tfun = reference to function(index:integer) : boolean;
     Type TfunInt = reference to function(index:integer) : integer;
     Type TfunReal = reference to function(index:integer) : Real;
     //функция ищет index в списке когда уже примерно известен index  шаг вперед шаг  назад
     // когда нашли сравнением то что искали Tfun должна вернеуть true
     Class function  StepMinMax(Count:integer;PredIndex:integer; FunSerch:Tfun):integer; inline; static;

     // где каждый елемент массива это  Arr[PredIndex(+-1...)].JsonObject[Pole].value = Value
     Class function  Json_StepMinMax_Object_IndexOf(Arr:TJsonArray;Pole:String;Value:String;PredIndex:integer):integer; static;





     ////////////////////////////////////////////////////////////////////////////////////////////
     //бинарный поиск с делением на 2
     {FunSerch:Tfun(Int Real) должна вернуть 0 -1 или 1
       0 когда равно
       1 когда больше
       -1 когда мешьще}
     //найти самый подходяший индес для вставки нового елемента т.е список будет отсортирован


     // MaxIndex = true result = индекс элемента, начиная с которого значения в массиве превышают заданное значение
     // MaxIndex = false точный поиск если не найден result = -1
     Class function  RecurceFind(L, R: Integer;FunctionSerch:TfunInt;MaxIndex:boolean): Integer;inline;static;
     Class function  BinaryIndex(CountBegin,CountEnd:integer;MaxIndex:boolean;var Iter:integer; FunSerch:TfunInt):integer;  inline;static;

     // в приоритете пользуюся в основном этим (без рекрусии)
     // переделан в поиск максимального индекса куда можно добавить элемент если MaxIndex=true
     Class function  BinaryIndex2(CountBegin,CountEnd:integer;MaxIndex:boolean;var Iter:integer;  FunSerch:amSerch.TfunReal):integer;  inline;static;

     // как оказалось лучще всегде этим искать
     // result = true если найдено  FoundIndex номер элемента
     // result = false не найдено FoundIndex для вставки (максимально близкий)
     Class function  BinaryIndex3(var FoundIndex:integer; IndexBegin,IndexEnd:integer; FunSerch:amSerch.TfunReal):boolean;  inline;static;
     Class function  BinaryIndex3_d(var FoundIndex:integer; IndexBegin,IndexEnd:integer; FunSerch:amSerch.TfunReal):boolean;  static;

             {
           Bol:=AmSerch.BinaryIndex3(IndexInsert,0,List.Count-1,
            function(ind:integer):real
            var p,p2:real;
            begin
              p:= List[ind].Price ;//здесь идет перебор значений
              p2:= Item.Price; //то что ищем и с чем сравниваем
              Result:=p-p2; //от меньшему к большего

              если строка Result:=AnsiCompareStr(  List[ind].Name , Item.Name );
            end);

            //добавление с сортировкой
          if Bol then                                                  List[IndexInsert]:=Item
          else if (IndexInsert<0) or (IndexInsert> List.Count-1) then  List.Add(Item)
          else                                                         List.Insert(IndexInsert,Item);

           или удаление
          if Bol then List.Delete(IndexInsert);

           Bol:=AmSerch.BinaryIndex3(IndexInsert,0,List.Count-1,
            function(ind:integer):real
            var p,p2:real;
            begin
              p:= List[ind].Price ;
              p2:= Item.Price;
              p:=p-p2; //от меньшему к большего

              if p>0 then        Result:= 1
              else if p<0  then  Result:= -1
              else               Result:= 0;

              если строка Result:=AnsiCompareStr(  List[ind] , SerchString );

            end);}



     // возращает IsNeedAdd (нужно ли выполить Add) или  false то  IndexInsert
     Class procedure   Bin_IsAdd(var IsNeedAdd:boolean;var IndexInsert:integer;CountEnd:integer;FunSerch:amSerch.TfunReal) ; inline;static;


     // бинараный поиск в отсортированном TJsonArray
     // где каждый елемент массива это int в строковом представлении
     Class function  Json_Bin_StrToInt_IndexOf(var Index:integer;SerchInt:integer;Arr:TJsonArray):boolean;  static;
     // где каждый елемент массива это string
     Class function  Json_Bin_Str_IndexOf(var Index:integer;SerchString:string;Arr:TJsonArray):boolean;  static;



    // бинараный поиск в отсортированном стринг листе для строк  line='123:ewrwer (123 --> key)  (: --> Denlim)   (ewrwer --> Value)
     Class function  StrList_Bin_KeyValue_IndexOf(ListTxt:TStringList;SerchKey,Denlim:string;MaxIndex:boolean):integer;  static;

     //добавление в стринг лист  для строк  новое значение с вычеслением индекса куда нужно добавить key value что бы список остался отсортированным
     Class function  StrList_Bin_AddSort(ListTxt:TStringList;Key,Value,Denlim:string):integer; static;



     //////////////////////////////////////////////////////////////////////////////////////////




     // это другой алгоритм поиска в тестах показал не постояннство
     // хорошо рабатает когда почти все элементы массива присутсвуют и их много больше 10000000 и они отсортированы
     Class function  InterpolationInt(  SerchInteger:integer;
                                          CountBegin,
                                          CountEnd:integer;
                                          MaxIndex:boolean;
                                          var Iter:integer;
                                          FunGetElem:TfunInt
                                          ):integer; static;
end;

 type
   PAmRecMsgError =^TAmRecMsgError;
   TAmRecMsgError  = record
      IsError:boolean;
      CodeInt:Integer;
      Msg:string;
      StackTraceAM:string;
      P:Pointer;
      function NewMsg(Place:string;AMsg:string):string;
      function AddMsg(Place:string;AMsg:string):string;
      function NewError(Place:string;E:exception):string;
      function AddError(Place:string;E:exception):string;
      procedure AddStackTrace(AStackTrace:string);
      procedure Clear;
   end;
//загрузка json
type amJson=record
  private
   Class procedure CaseLoad(Source:Pointer;
                            ACase:integer;
                            var J:TJsonBaseObject;
                            Error:PAmRecMsgError); static; //inline;
  public
   Class function LoadTextBase(TextJson:string;Error:PAmRecMsgError=nil):TJsonBaseObject; static; //inline;
   Class function LoadFileBase(FileNameFull:string;Error:PAmRecMsgError=nil):TJsonBaseObject; inline; static;
   Class function LoadStreamBase(Stream: TStream;Error:PAmRecMsgError=nil):TJsonBaseObject; inline; static;


   Class function LoadObjectText(TextJson:string;Error:PAmRecMsgError=nil):TJsonObject;static; //inline;

   Class function LoadObjectFile(FileNameFull:string;Error:PAmRecMsgError=nil):TJsonObject; inline; static;

   Class function LoadObjectStream(Stream: TStream;Error:PAmRecMsgError=nil):TJsonObject;     inline; static;



   Class function LoadArrayText(TextJsonArray:string;Error:PAmRecMsgError=nil):TJsonArray;     inline; static;

   Class function LoadArrayFile(FileNameFull:string;Error:PAmRecMsgError=nil):TJsonArray;     inline; static;

   Class function LoadArrayStream(Stream: TStream;Error:PAmRecMsgError=nil):TJsonArray;     inline; static;


   Class function ArrRealToStr(aReal: TamArrayOfReal):string;     inline; static;
   Class function ArrStrToReal(Str: string):TamArrayOfReal;     inline; static;
   Class function IsDataType(P:TJsonDataValueHelper;Typ:TJsonDataType):boolean;     inline; static;
   Class function ToNode(L:TTreeView;Base:TJsonBaseObject;IsNeedType:boolean):boolean; static;
   Class function ValueNodeToNameVarTypeValue(ValueInput:string;out NameVar:string; out NameType:string; out Value:string):boolean;static;
   Class function ToNodeJsonText(L:TTreeView;JsonText:String;IsNeedType:boolean):boolean; static;
   Class function ToStrNull(const F:TJsonDataValueHelper):string;static;  inline;
   Class function ToStrOA(const F:TJsonDataValueHelper):string;static;  inline;

end;


type
  TAmTreeViewHlp = class
      private
       FL:TTreeView;
       procedure L_Obj(J:TJsonObject;AParent:TTreeNode;IsNeedType:boolean);
       procedure L_Arr(J:TJsonArray;AParent:TTreeNode;IsNeedType:boolean);
       procedure L_Value(V:PJsonDataValue;AParent:TTreeNode;IsNeedType:boolean);

     public
       procedure Clear;
       function LoadJson(Base:TJsonBaseObject;IsNeedType:boolean):boolean;
       class function ParsValueToParam(ValueInput:string;out NameVar:string; out NameType:string; out Value:string):boolean;static;
       constructor Create(L:TTreeView);
  end;




// trect tsize tpoint к строке и обратно
type AmRectSize = record
     Class function __aInt(sur:string;serh:string;deff:integer):integer;  inline; static;
     Class function RectToStr(aRect:Trect):string;inline; static;
     Class function StrToRect(aStr:string):Trect;inline; static;

     Class function SizeToStr(aSize:TSize):string;inline; static;
     Class function StrToSize(aStr:string):TSize;inline; static;

     Class function PointToStr(aPoint:TPoint):string;inline; static;
     Class function StrToPoint(aStr:string):TPoint;inline; static;

end;

Type
 TAmResult16 = record
   type
   TIndex = 1..16;
   TVal = 0..9;
   private
   var
    FVal:string[16];

    function GetV(index:TIndex):TVal;
    procedure SetV(index:TIndex;V:TVal);
   public
    Procedure Zero;
    property Val[Index:TIndex] :TVal read GetV write SetV;

 end;

Type
 AmUnix = record
  Class procedure SecondsToFormat(CountSeconds:int64;var Days:integer;var Hours:integer;var Minutes:integer;var Seconds:integer);inline; static;
  Class Function DateCount(CountSeconds:int64):string;inline; static;
  Class Function DateCountToSecond(DateCountString:string):int64;inline; static;
  Class Function DateTimeIncTime(ADate:TDateTime;ATime:TTime):TDateTime;inline; static;
  Class Function DateTimeUTC_To_UnixMilliSeconds(ADateTime:TDateTime):int64;inline; static;
  Class Function UnixMilliSeconds_To_DateTimeUTC(AUnix:Int64):TDateTime;inline; static;

  Class Function DateTime_To_Unix(ADateTime:TDateTime):int64;inline; static;
  Class Function Unix_To_DateTime(AUnix:Int64):TDateTime; inline; static;

  Class Function DateTimeUTC_To_Unix(ADateTime:TDateTime):int64; inline; static;
  Class Function Unix_To_DateTimeUTC(AUnix:Int64):TDateTime;  inline; static;

  Class Function UTC_Now:TDateTime; inline; static;
  Class Function UTC_MsToDt(AUnix:Int64):TDateTime; inline; static;
  Class Function UTC_DtToMs(ADateTime:TDateTime):int64;  inline; static;
  Class Function SecondsBetween(A,B:TDateTime):int64;  inline; static;
  Class Function DateNoSpace(date,time:string):TDatetime;  inline; static;


 end;


Type
 AmFile = class
  const
       kb1 = 1024;
       mb1 = kb1*1000;
       gb1 = mb1*1000;

   class Var ExePathFile:TAmVarCs<string>;
   Class function  SizeFile( aFile: string ): int64;  inline; static;
   Class function  AddToFile     ( const aFile: string; const Msg: string ):string;inline; static;
   Class function  CountLn     ( const aFile: string):int64; static;
   Class function  CountLnAtSize (  aFile: string):string; static;
   Class function  SizeFileStr (Size:int64):string; overload; static;
   Class function  SizeFileStr (aFile: string):string; overload; static;

   Class function  SizeFileStr_def1 (Size:int64):string; static;
   Class function  SizeFileStr_b (Size: int64):string; static;
   Class function  SizeFileStr_kb (Size:int64):string; static;
   Class function  SizeFileStr_mb (Size:int64):string; static;
   Class function  SizeFileStr_gb (Size:int64):string; static;

   Class procedure ReCteateFile  ( aFile : String;MinSizeFile:int64=6420606);inline; static;
   Class procedure ReCteateFileData  ( aFile : String;MinSizeFile:int64;var LastData:TDatetime;AIncHour:integer=10);inline; static;
   Class procedure ListFileDir(Path: string; FileList: TStrings); overload;static;
   Class Function ListFileDirIndexOf(Path: string; FileName: string):integer; overload;static;
   Class Function GetFileTxt(NameFile:string):string;static;
   Class Function IsFile(F:String):boolean;  static;
   Class Function IsPath(aPath:String):boolean;  static;
   Class function IsFreeFile(const FullPatch: string): Boolean;  static;
   Class function IsFreeReadFile(const FullPatch: string): Boolean;  static;
   Class function GetHandleFileWaitFor(AFileName: string;Mode: Word;TimeOutMax:Cardinal):THandle;  static;
   Class function GetHandleFile(AFileName: string;Mode: Word):THandle;  static;


   Class Function IsValidNameFile(F:String):boolean; static;
   Class Function IsRelativePath(F:String):boolean; static;

   Class procedure ListFileDir(Path: string;var  FileList: TArray<string>);overload; static;
   Class procedure ListFileDir(Path: string;FileList: TStringList);overload;static;
   Class Function DirAllDelete(Dir: string):boolean;inline; static;
   Class Function DirAllDelete2(Dir: string;DeleteAllFilesAndFolders:boolean=true;StopIfNotAllDeleted:boolean=true; RemoveRoot:boolean=true):boolean;inline; static;
   Class Function DirAllCopy(DirOld,DirNew: string):boolean;inline; static;
   Class function  DirAddNew( const aPath: string):string;inline; static;

    // Value - ExtractFilePath(Application.ExeName)
   Class function  GetLocalPathFile( const Value: string):string;inline; static;

    //ExtractFilePath(Application.ExeName) + aPath
   Class function  GetFullPathFile( const Value: string):string;inline; static;

   //ExtractFilePath(Application.ExeName)
   Class function  LocalPath:string;inline; static;

   Class function ShellOpen(aPathFile:string):int64;
   Class function ShellOpenSelect(aPathFile:string):int64;
   Class function SizePath(const aPathFile:string):Int64; static;


   {
    Диск = C:
    Каталог = C:\Program Files\Borland\Delphi7\Projects
    Путь = C:\Program Files\Borland\Delphi7\Projects\
    Имя = Unit1.dcu
    Расширение = .dcu
   }
    //Диск = C:
   Class function  ExtractFileDisk( const Value: string):string;inline; static;

    //Каталог = C:\Program Files\Borland\Delphi7\Projects
   Class function  ExtractFileDir( const Value: string):string;inline; static;

   //Путь = C:\Program Files\Borland\Delphi7\Projects\
   Class function  ExtractFilePath( const Value: string):string;inline; static;

   //Имя = Unit1.dcu
   Class function  ExtractFileName( const Value: string):string;inline; static;

   //Расширение = .dcu
   Class function  ExtractFileExt( const Value: string):string;inline; static;

   {
    OldName = Unit1.dcu
    NewName = Unit1.new
   }
   Class function  ChangeFileExt( const Value,NewExt: string):string;inline; static;

 end;

 type
 AmLang =record
      Class function  IsRussian: boolean;  inline; static;
      Class function  IsRussianInstruction: boolean; inline; static;
 end;

 AmMusic = record
      Class procedure   PlaySoundTheadFile(FileName:string);  static;
      Class procedure   PlaySoundTheadResource(ResourceNameIndificator:string); static;
      Class procedure   PlaySoundResource(ResourceNameIndificator:string); static;
 end;

 AmMath = record
   Class Function   IsRange(value,mn,mx:integer):boolean;  static;
   Class Function   CountZnakInt(I:int64):integer;  static;
   Class Function   CountZnakZeroFrac(drob:Extended):integer;  static;
   Class Function   RoundLeft(const AValue: Extended;const ADigit: TRoundToEXRangeExtended):Extended; static;
   Class Function   FloorLeft(const AValue: Extended;const ADigit: TRoundToEXRangeExtended):Extended; static;
   Class Function   CeilLeft(const AValue: Extended;const ADigit: TRoundToEXRangeExtended):Extended; static;

   Class function RandomRange(a,b: integer): integer; static;
   Class function RandomRangeListNotDublicat(a,b,Count: integer;ArrInt:{PArrInt}Pointer):boolean; static;
   Class function RandomRangeList(a,b,Count: integer;ArrInt:{PArrInt}Pointer):boolean; static;

   Class function RandomRangeAlign4Low_OlD(a,b: integer): integer; static;
   Class function RandomRangeRoundLow(mn,mx,Amod: integer): integer; static;
   Class function RandomRangeRoundHigh(mn,mx,Amod: integer): integer; static;
   Class function RoundLow(Value: integer;AMod:integer): integer; static;
   Class function RoundHigh(Value: integer;AMod:integer): integer; static;

   Class function Align4Low(Value: Cardinal): Cardinal; static;
   Class function Align4High(Value: Cardinal): Cardinal; static;


   Class function Align8Low(Value: Cardinal): Cardinal; static;
   Class function Align16Low(Value: Cardinal): Cardinal; static;
  end;



 AmRecordHlp = record
    type
     TPointerVar  = record
       Instance:Pointer;
       NameField:string;
       size:Integer;
       Info:PTypeInfo;
     end;
     TMemberNode = class
       type
         TArrValue= array of TValue;
         TArrString= TArray<string>;



         TItem = record
            Member:TRttiMember;
            APath:ShortString;
            prtIndexPrm:ShortString;
            ArrStr:TArrString;

         end;

        private
          FMember : TArray<TItem>; // path from root
          rttiContext : TRttiContext;
          RootType:Pointer;  // type TObject ссылка на сам тип данных record obj  и т.д
          RootInstance:Pointer;  // var My:TObject ссылка на саму переменную
          RootTypeInfo:PtypeInfo; // TypeInfo(T);  см GetRoot
          
           function GetNameFromIndexedProperty(Input:string; out AName:string;out prtIndexPrm:string; out ArrStr:TArrString ):Boolean;
           function GetArgPropertyIndexed(prp:TRttiIndexedProperty;ArrStr:TArrString):TArrValue;
           function GetValueHlpRoot:TValue;
           function GetValueHlp(Index:integer;RootValue:TValue):TValue;
           function GetPonterHlpRefer(Index:integer;LastValue:TValue):Pointer;
           function GetIsRecordHlp(Index:integer):boolean;

           procedure SetValueHlp(Index:integer;P:Pointer;Value:TValue);
           //procedure SetValueHlp(Index:integer);
           procedure SetValueHlpRefer(Index:integer;ValueLast,Value:TValue);

        public
          function GetRoot<T>(var Instance:T;out Error:string):boolean;
          function GetPath(APath:string;out Error :string):boolean;
          function LastType:TRttiType;
          function GetValue:TValue;
          procedure SetValue(Value:TValue);
          property Member :TArray<TItem> Read FMember;

     end;

     //тоже самое что и  class Function GetSetValDouble<T> но оптимизировано под одну переменную что бы производительность сохранить
     TPerformanceMemory<T> = class
         private
           Node:TMemberNode;
           Instance:T;
         public
           ErrorLast:string;
           Function GetSetValDouble(IsGet:boolean;APath:string;var Variable:Double):boolean;
           constructor Create(AInstance:T);
           destructor Destroy ; override;
     end;




     private
       class function CompareVariantTypeKind(IsGet:boolean;fld:TTypeKind;VarResult:TTypeKind):boolean; static;

     public
       class Function SetGetValue(IsGet:boolean;Kind:TTypeKind;Info:PTypeInfo;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean; static;
       class Function SetGetValue_Int(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean; static;
       class Function SetGetValue_Int64(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean; static;
       class Function SetGetValue_Real(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean; static;
       class Function SetGetValue_Bool(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean; static;
       class Function SetGetValue_Str(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean; static;

       class Function ToValue<T>(X:T;out Value:TValue):boolean; static;
       class Function ToType<T>(Value:TValue;out X:T):boolean; static;




       class procedure RecFinal<T>(var Instance:T);  static;
       class Function Clear<T>(var Instance:T;out Error:string; Db:boolean=false;Di:integer=0;Ds:string=''):boolean; static;
       class procedure ClearInternal(InstanceData,InstanceType:Pointer;Db:boolean=false;Di:integer=0;Ds:string=''); static;
       class procedure ClearInternalValue(var V:TValue;Db:boolean=false;Di:integer=0;Ds:string=''); static;

       class Function GetSetVal<T1,T2>(IsGet:boolean;var Instance:T1;PathFieldName:string;var  Variable:T2;out Error:string):boolean; static;
       class Function GetSetValStr<T>(IsGet:boolean;var Instance:T;PathFieldName:string;var  Variable:string;out Error:string):boolean; static;
       class Function GetSetValDouble<T>(IsGet:boolean;var Instance:T;PathFieldName:string;var  Variable:Double;out Error:string):boolean; static;
       class Function GetTypeInfo<T>(var Instance:T;PathFieldName:string):PTypeInfo;static;
       class Function GetTypeKind<T>(var Instance:T;PathFieldName:string):TTypeKind;static;
       class Function GetTypeKindRef<T>(Instance:T):TTypeKind;static;
       class Function GetTypeInfoRef(Instance:PtypeInfo):PtypeInfo;static;
       class Function GetArrayFieldName<T>(var Instance:T;isF,isPr,isProdesure:boolean):TArray<string>;static;
       class Function EnumToStr<T>(Instance:T):string  ;static;
       class Function EnumToEnum<T>(Instance:string):T  ;static;
       class Function EnumStrToInt<T>(Instance:string):integer  ;static;

       class Function EnumSetToTypSet<T>(Instance:string):T  ;static;
       class Function EnumSetToString<T>(Instance:T):string  ;static;


       // превратить record, array, class,  interface в json
       // затем сам json можно будет в файл сохранить или в TreeView загрузить
       class Function ToJsonField<T>(var Instance:T;
                                    MaxLevelRecursPars:integer;
                                    NeedNameType:boolean;
                                    ClassBlack,ClassWhite:TArray<TClass>):TJsonObject; static;
       // обратная функция предыдущей т.е загрузка с json в  переменную
       class Function FromJsonField<T>(var Instance:T;J:TJsonObject):boolean; static;

       // инициализация переменных TObject в объексте Instance
       // AffectedClass класс который инициализировать не трогая детей и предков
       // AffectedClass = nil не рекомендуется
       //Instance  is AffectedClass  = true должно быть так
       // StopParentClass задать класс предка на ком нужно остановится (не очищая его на ком остановились) по гинеологическому древу можно nil
       // при AffectedClass<>nil StopParentClass безполезен т.к  AffectedClass эт только 1 класс
       class procedure ObjectFieldsInit(Instance:TObject;AffectedClass,StopParentClass:TClass);static;
       //освободить переменных TObject в объексте Instance  и превратить в nil
       class procedure ObjectFieldsFree(Instance:TObject;AffectedClass,StopParentClass:TClass);static;

       // в переменной получить список указателей на переменные т.е поля которые являются TTypeKind
       // если T это TObject можно указать AffectedClass,StopParentClass
       class function ObjectGetFieldsListPointerVar(Instance:TObject;AffectedClass,StopParentClass:TClass;Filtr:TTypeKindSet ):TArray<TPointerVar>;static;

       class procedure FindType;static;
       class function GetInlineSize(TypeInfo: PTypeInfo): Integer; static;
  
  
      // class Function GetArrayFieldName2<T>(var Instance:T;isF,isPr,isProdesure:boolean):TArray<string>;static;
 end;

   Type AmEnumConverter = class
       type
        TEnumBuffer = set of Byte;
       const
        BitsPerByte = 8;
        ByteBoundaryMask = not (BitsPerByte - 1);
   private
        class procedure StringToEnumSetInfo(const Str: string;CompInfo: PTypeInfo; CompData: PTypeData;var Value: TEnumBuffer);
   public
        class function EnumToInt<T>(const enValue: T): Integer;
        class function EnumToString<T>(enValue: T): string;
        class procedure StringToEnum<T>(strValue:String; var enValue:T);overload;
        class procedure StringToEnum<T>(strValue:String; var enValue:Integer);overload;
        class procedure StringToEnumSet<T>(Instance:string;var Result:T);
        class function EnumSetToString<T>(Instance: T): string;
   end;

 AmConvertTrade = record

     Class Function Round8(val:real):real;static;
     Class Function Str(val:real):string;static;
 end;

 AmColorConvert = record
    Class Function ColorToRGB(val:TColor;var R:Byte;Var G:Byte; var B:Byte):boolean;static;
    Class Function RGBToColor(R,G,B:Byte):TColor;static;
    Class Function RGBToYCbCr(R,G,B:Byte;var Y:byte;var Cb:byte;var Cr:byte ):boolean;static;
    Class Function YCbCrToRGB(Y,Cb,Cr:Byte;var R:byte;var G:byte;var B:byte ):boolean;static;
    Class Function YCbCrToRGB2(Y,Cb,Cr:Byte;var R:byte;var G:byte;var B:byte ):boolean;static;

    Class Function GetY(val:TColor):byte;static;
    Class Function GetCb(val:TColor):byte;static;
    Class Function GetCr(val:TColor):byte;static;

    Class Function SetY(val:TColor;aY:byte):TColor;static;
    Class Function SetCb(val:TColor;aCb:byte):TColor;static;
    Class Function SetCr(val:TColor;aCr:byte):TColor;static;

    Class Function SetY_delta(var val:TColor;aYDelta:byte):boolean;static;
    Class Function SetCb_delta(var val:TColor;aCbDelta:byte):boolean;static;
    Class Function SetCr_delta(var val:TColor;aCrDelta:byte):boolean;static;

    Class Function ToStringRGB(val:TColor):string;static;




 end;

  AmColorConvert2 = record  //Преобразование цвета RGB to HLS
    Const
    HLSMAX = 240;
    RGBMAX = 255;
    UNDEFINED = 160;//(HLSMAX*2) div 3;
    { H-оттенок, L -яркость, S-насыщенность(контраст) }

    Class Function ColorToRGB(val:TColor;var R:integer;Var G:integer; var B:integer):boolean;static;
    Class Function RGBToColor(R,G,B:integer):TColor;static;

    Class Function ColorRamdom(Lmin:integer=20;Lmax:integer=220;Smin:integer=20;Smax:integer=220):TColor;static;
    Class Function HLSToColor(H,L,S:integer):TColor;static;
    Class procedure ColorToHLS(val:TColor;var H:integer;var L:integer;var S:integer);static;



    Class procedure RGBtoHLS(R,G,B:integer;var H:integer;var L:integer;var S:integer );static;
    Class procedure HLStoRGB(H,L,S:integer;var R:integer;var G:integer;var B:integer );static;

    Class Function GetH(val:TColor):integer;static;
    Class Function GetL(val:TColor):integer;static;
    Class Function GetS(val:TColor):integer;static;

    Class Function SetH(val:TColor;xH:integer):TColor;static;
    Class Function SetL(val:TColor;xL:integer):TColor;static;
    Class Function SetS(val:TColor;xS:integer):TColor;static;

    // изменение яркости  по границе
    Class Function DeltaL(val:TColor;xDelta,border:byte):TColor;static;
    Class Function DeltaH(val:TColor;xDelta,border:byte):TColor;static;
    Class Function DeltaS(val:TColor;xDelta,border:byte):TColor;static;

    Class Function DeltaLHS(val:TColor;xDelta,border:byte):TColor;static;

    Class Function IncL(val:TColor;Value:Integer):TColor;static;
 end;

Type
 AmUnixRound = record
     Class function FloorToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime; static;
     Class Function DtToFloorMinutes(Data:TDatetime;minutes:integer):TDateTime;   static;
     Class Function DtToWeekBegin(Data:TDatetime):TDateTime;   static;
     Class Function DtToWeekNextBegin(Data:TDatetime):TDateTime;   static;
     Class Function DtToMothBegin(Data:TDatetime):TDateTime;   static;
     Class Function DtToMothNextBegin(Data:TDatetime):TDateTime;   static;
 end;


 Type
  TAmApplicationGlobalEvent = class
    private
     procedure AppMessage (var Msg: TMsg; var Handled: Boolean);
    public
     F:TList<TMessageEvent>;
     procedure OnMessageApp(Proc:TMessageEvent);
     Constructor Create();
     Destructor Destroy;override;

  end;
  Type
   AmCompare = record
      Class function IsCompare(IsASC:boolean;Input,DefR:real):integer;  static;
      Class function IsRangeProcent(Input,DefR,Procent:real):boolean;  static;
      Class function IsCompareProcent(IsASC:boolean;Input,DefR,Procent:real):integer;  static;
   end;
   Type
   AmInternet = record
      Class function Connected:boolean; static;
   end;







    {
     получить доступ к предкам даж если их методы виртуальные
     дети выполнятся не будут

     пример
         TV1 = class
            public
             A:integer;
             function GetH:integer;virtual;
         end;

         TV2 =class (TV1)
            public
              B:integer;
             function GetH:integer;override;
         end;
        //////////////////////////////////
        function TV2.GetH:integer;
        begin
          Result:=inherited +B;
        end;
        function TV1.GetH:integer;
        begin
          Result:=A;
        end;
        procedure TForm1.Panel1Click(Sender: TObject);
          var I:TV2;
          s:integer;
        begin

           I:=TV2.Create;
           I.B:=2;
           I.A:=1;

           //хочу получить доступ с формы к TV1.GetH что бы  TV2.GetH не выполнялся
           AmVirtual<TV2,TV1>.G(I,
           procedure(X2:TV1)
           begin
            s:=X2.GetH;
           end);

           showmessage( s.ToString);  // >> 1
           showmessage( I.GetH.ToString);//>> 3
           I.free;
        end;
    }
  type
   AmVirtual<T1,T2:class> =class
    type
     TProc = reference to procedure (X2:T2);
      class procedure G(X1:T1;Proc:TProc);static;
   end;

  type
   AmClass = class
      class function IsClassRef(A:TObject; B:TClass):boolean; static;
      class procedure ListParent(L:TStrings;A:TObject); static;
      class function IsClass(A:TObject; B:TClass):boolean; static;
      class procedure VirtMetod<T1,T2:class>(X1:T1;Proc:AmVirtual<T1,T2>.TProc); static;

   end;
  type
   AmDebug=class
      Type



       TProcTrack =record
        Result:boolean;
        Address: Pointer;
        CodeProc: Pointer;
        SizeProc:Dword;
        UnitName: string;
        ClassName: string;
        ProcName: string;
        ProcedureName: string;
        OffsetFromProcName: Integer;    // Offset from Address to ProcedureName symbol location
        LineNumber: Integer;            // Line number
        OffsetFromLineNumber: Integer;  // Offset from Address to LineNumber symbol location
        SourceName: string;             // Module file name
        BinaryFileName: string;         // Name of the binary file containing the symbol
       end;
       PProcTrack =^TProcTrack;
      private
        class procedure CopyToTrack(Track,P:Pointer);static;
      public
      class procedure LocationInfo(OutTrack:PProcTrack;ACurrentAddress:Pointer=nil);static;
      class function ProcAddress(UnitName,ClassName,ProcName:string;ACurrentAddress:Pointer=nil):Pointer; static;

      class function CurrentAddress:Pointer; static;
      class function CurrentProcAddress:Pointer; static;
      class function CurrentProcName(IsNeedUnitName:boolean=true):string; static;
      class procedure CurrentProcTrack(OutTrack:PProcTrack); static;


      class function ProcName(IsNeedUnitName:boolean=true;AProcAddress:Pointer=nil):string; static;
      class procedure ProcTrack(AProcAddress:Pointer;OutTrack:PProcTrack); static;

      class function CurrentStackTracing():string; static;
   //   class function StackTracing(ACurrentAddress:Pointer;OutTrack:PProcTrack):string; static;



      class function CurrentThreadId:Cardinal; static;
      class function IsMainThread:boolean; static;
      class function MainThreadId:Cardinal; static;
   end;


   type
     TAmToJsonVariableRtti = class
        Type
         TParam =record
            Level:integer;
            MaxLevel:integer;
            NeedNameType:boolean;

           // AffectedClass,StopParentClass:TClass;IsAllLevelClass:boolean;


            ClassWhite:TArray<TClass>;

            {в что ClassBlack.InheritsFrom(ObjParent.ClassType) и ниже кроме ClassWhite нельзя парсить}
            ClassBlack:TArray<TClass>;

         end;
         PParam = ^TParam;
     private
           procedure AddJsonValue(P:PParam;F:TJsonDataValueHelper;V :TValue; LastType:TRttiType);
           procedure ParsJsonValue(P:PParam;J:TJsonObject;Instance:Pointer;LastType:TRttiType);
           function  CanConinue(HandleParent:PTypeInfo;P:PParam;isFP:boolean ):boolean;

           procedure LoadJsonObject(F:TJsonDataValueHelper;Instance:Pointer; Field:TRttiField);
     public
        //VarFieldsToJson
       // превратить record, array, class,  interface в json
       // затем сам json можно будет в файл сохранить или в TreeView загрузить

       // у класса можно получить опреденный уровень полей в Tmemo только поля TWinControl
       // (Memo1,6,true,[TMemo],[TWinControl]);

       // все до WinControl включая WinControl
       //(Memo1,6,true,[TWinControl],[TWinControl]);

       // все до WinControl
       //(Memo1,6,true,[TWinControl],[]);

       // только Memo
       //(Memo1,6,true,[TMemo],[TMemo]);

       // [] = это arrray  [TMemo,TWinControl,TLabel]

       procedure VarFieldsToJson<T>(var  Result:TJsonObject; var Instance:T;
                                    MaxLevelRecursPars:integer;
                                    NeedNameType:boolean;
                                    ClassBlack,ClassWhite:TArray<TClass>);
       function VarFieldsFromJson<T>(var Instance:T;J:TJsonObject):boolean;
     end;

  AmStringSplit = class
  // result count Length Array
     class function Split(Separator:string; S:String;var A:TArray<string>):Integer;  inline;

     // type TArray<string>
     class function SplitForArrayOfString(Separator:string; S:PString;ArrayOfString:Pointer):Integer;   inline;

     // type TArrStr
     class function SplitForArrStr(Separator:string; S:PString;ArrStr:Pointer):Integer; inline;


     // type custom pointer  DynArrayString = та ссылка что вернет DynArraySetLength(); и ее подобные
     class function SplitArrayCustomPointer(Separator:string; S:PString;DynArrayString:Pointer;CountMax:Integer):Integer;  inline;
  end;
  AmStringHlp = class


    // вернуть строку с опред колво Ch
    class function GetCountChar(ACount:integer;Ch:Char):string;
    // сколько пробелов по бокам
    class function CountSpace(S:string;isleft:boolean=true):integer;


    // функция pos но ищет с конца
    class function PosInvert( const FindS, SrcS: string;offset:integer=1): Integer;
    class function PosInvertLast( const FindS, SrcS: string;offset:integer=1): Integer;
    class function PosLast( const FindS, SrcS: string;offset:integer=1): Integer;
    class function Pos( const FindS, SrcS: string;offset:integer=1): Integer;
    // зеркально отражает строку
    class function Invert(const S: string): string;


    class function CountPos(const subtext: string; Text: string): Integer;
    class function PosArray(A:TArray<string>;Input:string):boolean;
    class function PosArrayIndexOf(IsRevers:boolean;A:TArray<string>;Input:string;var Index:integer;var APos:integer):boolean;
    class function CmpArray(A1,A2:TArray<string>):boolean;

    type
    //  result 0  =  continue;
    //  result 1  = exit;
    TFunPravilo  = reference to function (C: Char;Position:integer): integer;

    // вернет позицию как pos но еще выполнит правило
    class function PosToken(IsRevers:boolean;Token:string;Source:string;startPos:integer;Pravilo:TFunPravilo):integer;
    class function PosTokens(IsRevers:boolean;Tokens:TArray<string>;Source:string;startPos:integer;Pravilo:TFunPravilo;out IndexToken:integer):integer;

     class function _PrSpace(C: Char;Position:integer): integer;
     class function PosToken_PrSpace(IsRevers:boolean;Token:string;Source:string;startPos:integer;Pravilo:integer=0):integer;
     class function PosTokens_PrSpace(IsRevers:boolean;Tokens:TArray<string>;Source:string;startPos:integer;Pravilo:integer;out IndexToken:integer):integer;
  end;

  AmEncoding =class
         type
         TLocClass =class(TEncoding)
          class function ClassGetChars(Source:TEncoding;Bytes: PByte; ByteCount: Integer; Chars: PChar; CharCount: Integer): Integer;
         end;

       //Arr type TArrByte
       class function Utf8_BToS_ForArrByte(ArrByte:Pointer;Str:PString):integer; inline;
       class function Utf8_SToB_ForArrByte(ArrByte:Pointer;Str:PString):integer; inline;
       class function Utf8_SToB_GetCount(Str:PString):integer;   inline;

       class function Ansi_BToS_ForArrByte(ArrByte:Pointer;Str:PString):integer; inline;
       class function Ansi_SToB_ForArrByte(ArrByte:Pointer;Str:PString):integer;  inline;
       class function Ansi_SToB_GetCount(Str:PString):integer;       inline;

       class function Def_BToS_GetCount(CodePage,Flag:Cardinal;Arr:Pointer;ArrCount:Integer):integer;      inline;
       class function Def_BToS(CodePage,Flag:Cardinal;Arr:Pointer;ArrCount:Integer;Str:PString;StrCount:Integer):integer;   inline;

       class function Def_SToB_GetCount(CodePage,Flag:Cardinal;Str:PString;StrCount:Integer):integer;   inline;
       class function Def_SToB(CodePage,Flag:Cardinal;Arr:Pointer;ArrCount:Integer;Str:PString;StrCount:Integer):integer; inline;


  end;
  AmBoard = class
    Class function  TextGet:string;
    Class procedure TextSet(S:string);
  end;



    function AmSystemInfo_IsDebugConfigEx:BOOL;stdcall; exports  AmSystemInfo_IsDebugConfigEx;
    function AmSystemInfo_IsDebugConfig_Module(hModule:Cardinal):TboolTri;
    function AmSystemInfo_IsDebugConfig_FileName(FileName:string):TboolTri;



   type
    AmSystemInfo=class
    private
     class var FIsInitProgram:boolean;
    public
     class function IsDebugConf:boolean;
     class function IsInitProgram:boolean;
     class procedure IsNotInitProgramRaise(Address:Pointer=nil);
     class procedure IsInitProgramSet;
     class procedure ReportMemory(Value:boolean);

     class function GetMacList(const List: TStrings; Machine: string=''): Integer;
     class function GetMacDen(denlim:string='|'; Machine: string=''): string;
     class function GetSerialNumDisk_C:string;
     class function GetINVIDIA(denlim:string='|'):string;
     class procedure GetINVIDIA_List(L:TStrings);
     class procedure GetHardDiskSerialnumberList(L:TStrings);
     class function GetHardDiskSerialnumber(DenLim:string='|'):string;
     class function GetHardDiskIndex(Index:integer):string;
      //JclSysInfo
     // class function IsDebug:boolean; static;
     //function GetLocalComputerName: string;
     //function GetLocalUserName: string;
      {  function GetUserDomainName(const CurUser: string): string;
        function GetWorkGroupName: WideString;

        function GetDomainName: string;

        function GetRegisteredCompany: string;
        function GetRegisteredOwner: string;
        function GetBIOSName: string;
        function GetBIOSCopyright: string;
        function GetBIOSExtendedInfo: string;
        function GetBIOSDate: TDateTime;
function IsMainAppWindow(Wnd: THandle): Boolean;
function IsWindowResponding(Wnd: THandle; Timeout: Integer): Boolean;

function GetWindowIcon(Wnd: THandle; LargeIcon: Boolean): HICON;
function GetWindowCaption(Wnd: THandle): string;
function TerminateTask(Wnd: THandle; Timeout: Integer): TJclTerminateAppResult;
function TerminateApp(ProcessID: DWORD; Timeout: Integer): TJclTerminateAppResult;

function GetPidFromProcessName(const ProcessName: string): THandle;
function GetProcessNameFromWnd(Wnd: THandle): string;
function GetProcessNameFromPid(PID: DWORD): string;
function GetMainAppWndFromPid(PID: DWORD): THandle;
function GetWndFromPid(PID: DWORD; const WindowClassName: string): HWND;

function GetWindowsVersion: TWindowsVersion;
function GetWindowsEdition: TWindowsEdition;
function NtProductType: TNtProductType;
function GetWindowsVersionString: string;
function GetWindowsEditionString: string;
function GetWindowsProductString: string;
function NtProductTypeString: string;
function GetWindowsBuildNumber: Integer;
function GetWindowsMajorVersionNumber: Integer;
function GetWindowsMinorVersionNumber: Integer;
function GetWindowsVersionNumber: string;
function GetWindowsServicePackVersion: Integer;
function GetWindowsServicePackVersionString: string;
function GetOpenGLVersion(const Win: THandle; out Version, Vendor: AnsiString): Boolean;
function GetNativeSystemInfo(var SystemInfo: TSystemInfo): Boolean;
function GetProcessorArchitecture: TProcessorArchitecture;
function IsWindows64: Boolean;
function JclCheckWinVersion(Major, Minor: Integer): Boolean;


function GetMacAddresses(const Machine: string; const Addresses: TStrings): Integer;

function IsExcelInstalled: Boolean;
        }
    end;
    AmRaise = class

      class function MsgDefault(__ReturnAddr:Pointer=nil):string;
      class function MsgSystem():string;
      class function MsgSystemFull(__ReturnAddr:Pointer=nil):string;

      class procedure RaiseDefaultProgram(S:string;__ReturnAddr:Pointer=nil);
      class procedure RaiseSystemProgram(S:string);
      class procedure RaiseSystemFullProgram(S:string;__ReturnAddr:Pointer=nil);
      class procedure RaiseForThread(S:string;__ReturnAddr:Pointer=nil);

      class procedure RaiseDefault(S:string;__ReturnAddr:Pointer=nil);
      class procedure RaiseSystem(S:string);
      class procedure RaiseSystemFull(S:string;__ReturnAddr:Pointer=nil);

      class procedure __Program(S:string);
      class procedure showmessage(Message:string;Stack:string;TimeOutSeconds:Cardinal);
      class procedure ShowMessagePost(Message:string;Stack:string);
      class procedure ShowMessageAny(Message:string;Stack:string);
    end;

    AmShell=class
      //JclShell;
    end;
   AmHex16 = class
       class function BtoH_for_ArrByte(ArrByte:Pointer;FormatBegin:string='';FormatEnd:string=''):string;
       class function BtoH_for_Bytes(ArrByte:TBytes;FormatBegin:string='';FormatEnd:string=''):string;
       class function BtoH_for_Pointer(B:Pbyte;Count:integer;FormatBegin:string='';FormatEnd:string=''):string;


       class procedure HtoB_for_ArrByte(ArrByte:Pointer;S:string;FormatBegin:string='';FormatEnd:string='');
       class procedure HtoB_for_Bytes(ArrByte:PBytes;S:string;FormatBegin:string='';FormatEnd:string='');


       class procedure  HtoB_GetCount(S:Pstring;out SizeOne:integer;out Count:integer;FormatBegin:string='';FormatEnd:string='');
       class procedure  HtoB_for_Pointer(B:Pbyte;S:Pstring;CountBegin,SizeOne,Count:integer);

   end;
  AmIf = class
     class function Ravno12(s1,s2:string;ResulTrue,ResultFalse:string):string;
     class function Bool(V:boolean;ResulTrue,ResultFalse:string):string;
  end;
   var ApplicationGlobalEvent:TAmApplicationGlobalEvent;
       AmAutoFreeObjectList:TAmAutoFreeObject.TList;

implementation
uses AmLogTo,AmList,Wininet,JclDebug,JclSysUtils,JclSysInfo,dprocess,magwmi,AmControls;
resourcestring
  AmRaise__Program = 'AmRaise.__Program not initization (после закрытия окна программа завершится!) Msg>>:'#13#10;




 { TAmStrCmp }
procedure TAmStrCmp.Clear;
begin
   AmRecordHlp.RecFinal(self);
end;
procedure TAmStrCmp.CopyFrom(Source:PAmStrCmp);
begin
   AmRecordHlp.RecFinal(self);
   Typ:=       Source.Typ;
   IdCustom:=  Source.IdCustom;
   Value:=     Source.Value;
   Rreg:=      Source.Rreg;
   Prm:=       Source.Prm;
end;
procedure TAmStrCmp.ObjectSaveToJson(J:TJsonObject);
var L:TArrByteRec;
begin
    J['Typ'].Value:= AmRecordHlp.EnumToStr(Typ);
    J['IdCustom'].IntValue:= Integer(IdCustom);
    L.Count:=sizeof(Prm);
    move(Prm, L.P^,L.Count);
    J['Prm'].Value:= L.Fun.ToStrSetHex16_FrtStd;
    J['Value'].Value:=Value;
    J['Rreg'].Value:=Rreg;
end;
procedure TAmStrCmp.ObjectLoadFromJson(J:TJsonObject);
var TypS:string;
TypI,TypC:integer;
 L:TArrByteRec;
begin
    AmRecordHlp.RecFinal(self);
    TypS:= J['Typ'].Value;
    TypI:= AmRecordHlp.EnumStrToInt<TEnum>(TypS);
    TypC:=Integer(System.High(TEnum))+1;


    if (TypC>0) and (TypI<=TypC-1) then
      Typ:= TEnum(TypI)
    else
      raise Exception.Create('Error TAmStrCmp.ObjectLoadFromJson диапозон превыжен TEnum i='+TypI.ToString +' countMax='+TypC.ToString);

    IdCustom:= word(J['IdCustom'].IntValue);
    Value:=  J['Value'].Value;
    Rreg :=  J['Rreg'].Value;

    L.Count:=sizeof(Prm);
    L.Fun.StrSetHex16_FrtStd(J['Prm'].Value);
    if L.Count=sizeof(Prm) then
    move(L.P^,Prm,L.Count);


    case Typ of
         ascmpsFunRef:Prm.FunRef:=nil;
         ascmpsFunLoc:Prm.FunLoc:=nil;
         ascmpsFunObj:begin
            Prm.FunObjCode:=nil;
            Prm.FunObjData:=nil;
         end;
    end;


end;
function TAmStrCmp.Cmp(Source:string):TBoolTri;
  var i:integer;
   function LocCmpIsNull():boolean;
   begin
     if length(Value)<=0 then
                  exit(false);
     if length(Source)<=0 then
                  exit(false);
     Result:=true;
   end;
   var M:TMethod;
begin
    Result:=bfalse;
    case Typ of
               ascmpsNone: // выключено TAmStrCmp.Cmp = bnot
               begin
                 Result:=bnot;
               end;
               ascmpsCustom: // выключено TAmStrCmp.Cmp = bnot но можно как то внешне эт использовать
               begin
                 Result:=bnot;
               end;
               ascmpsPos,
               ascmpsPosInvert:    // pos
               begin
                  if not LocCmpIsNull then
                  exit;

                  if  Prm.PosOffset<=0 then
                  Prm.PosOffset:=1;

                  if Typ = ascmpsPos then
                  begin
                     if Prm.PosIsLast then
                          Prm.PosResult:= AmStringHlp.PosLast(Value,Source,Prm.PosOffset)
                     else
                          Prm.PosResult:= AmStringHlp.Pos(Value,Source,Prm.PosOffset);
                  end
                  else if Typ = ascmpsPosInvert then
                  begin
                     if Prm.PosIsLast then
                          Prm.PosResult:= AmStringHlp.PosInvertLast(Value,Source,Prm.PosOffset)
                     else
                          Prm.PosResult:= AmStringHlp.PosInvert(Value,Source,Prm.PosOffset);
                  end
                  else exit(bnot);

                  if Prm.PosResultCmp1 then
                  begin
                    if Prm.PosResult =1 then
                    Result:= btrue;
                  end
                  else if Prm.PosResult<>0 then
                  Result:= btrue;
               end;
               ascmpsReg:    // регулярные выражения Pattern помещать в  TAmStrCmp.Value
               begin
                  if not LocCmpIsNull then
                  exit;
                  if Prm.RegIsBegin then
                  begin
                    if Value[1]<>'^' then
                    Value:= '^'+Value;
                  end;
                  if Prm.RegIsEnd then
                  begin
                    if Value[Length(Value)]<>'$' then
                    Value:= Value+'$';
                  end;
                  Rreg:= AmReg.GetValue(Value,Source);
                  if Length(Rreg)>0 then
                  Result:=btrue;

               end;
               ascmpsCmp:   // обчыное равенство
               begin
                 Result.SetValue( Boolean(Value = Source) );
                 if Result =bTrue  then
                 begin
                    if length(Value)>0 then
                    Prm.ResultFerstCh:= Value[1]
                    else
                    Prm.ResultFerstCh:=#0;
                 end;
               end;
               ascmpsCmpCase: // обчыное равенство без учета регистра
               begin
                 Result.SetValue( Boolean(AnsiLowercase(Value) = AnsiLowercase(Source)) );
                 if Result =bTrue  then
                 begin
                    if length(Value)>0 then
                    Prm.ResultFerstCh:= Value[1]
                    else
                    Prm.ResultFerstCh:=#0;
                 end;
               end;
               ascmpsFunRef:  // запускает кастомному процедуру сравнения
               begin
                 if Assigned(Prm.FunRef) then
                    Result.SetValue( TFunRef(Prm.FunRef)(Value,Rreg,Source) )
                 else
                  Result:= bnot;
               end;
               ascmpsFunLoc:
               begin
                 if Assigned(Prm.FunLoc) then
                    Result.SetValue( TFunLoc(Prm.FunLoc)(Value,Rreg,Source) )
                 else
                  Result:= bnot;
               end;
               ascmpsFunObj:   // запускает кастомному процедуру сравнения
               begin
                 if Assigned(Prm.FunObjCode) and Assigned(Prm.FunObjData) then
                 begin
                    M.Code:= Prm.FunObjCode;
                    M.Data:= Prm.FunObjData;
                    Result.SetValue( TFunObj(M)(Value,Rreg,Source) );
                 end
                 else
                  Result:= bnot;
               end
               else
               Result:=bnot;
    end;
end;






class procedure AmRaise.showmessage(Message:string;Stack:string;TimeOutSeconds:Cardinal);
begin
  if AmIsMainPot and  (AmLogTo.DefaultFormException<>nil) then
  AmLogTo.DefaultFormException.Show(Message,Stack)
//  else                 AmLogTo.DefaultFormException.ShowSend(Message,Stack,TimeOutSeconds)

end;
class procedure AmRaise.ShowMessageAny(Message:string;Stack:string);
begin
  if AmIsMainPot then
  showmessage(Message,Stack,10)
  else ShowMessagePost(Message,Stack);
end;
class procedure AmRaise.ShowMessagePost(Message:string;Stack:string);
begin
 if AmLogTo.DefaultFormException<>nil then
 AmLogTo.DefaultFormException.ShowPost(Message,Stack);
end;
class procedure AmRaise.__Program(S:string);
begin
    if not  AmSystemInfo.IsInitProgram and AmIsMainPot then
    begin
     {$IFDEF DEBUG}
      AmRaise.showmessage(AmRaise__Program+S,AmDebug.CurrentStackTracing,30);
      {$ENDIF}
      {$IFDEF RELEASE}
       AmRaise.showmessage(AmRaise__Program+S,'',30);
      {$ENDIF}
       Halt;
       raise Exception.Create('I')
    end
    else
     raise Exception.Create(S);

end;
class procedure AmRaise.RaiseForThread(S:string;__ReturnAddr:Pointer=nil);
begin
    if not Assigned(__ReturnAddr) then
    __ReturnAddr:= ReturnAddress;
    S:=S+MsgSystemFull(__ReturnAddr);

  if not  AmIsMainPot then
  begin
     {$IFDEF DEBUG}
     AmLogTo.DefaultFormException.ShowSend(S,AmDebug.CurrentStackTracing,15)

      {$ENDIF}
      {$IFDEF RELEASE}
       AmLogTo.DefaultFormException.ShowSend(S,'',5)
      {$ENDIF}
  end;

  raise Exception.Create(S);
end;
class procedure AmRaise.RaiseDefaultProgram(S:string;__ReturnAddr:Pointer=nil);
begin
    if not Assigned(__ReturnAddr) then
    __ReturnAddr:= ReturnAddress;
    __Program(S+msgDefault(__ReturnAddr));
end;
class procedure AmRaise.RaiseSystemProgram(S:string);
begin
    __Program(S+MsgSystem());
end;
class procedure AmRaise.RaiseSystemFullProgram(S:string;__ReturnAddr:Pointer=nil);
begin
    if not Assigned(__ReturnAddr) then
    __ReturnAddr:= ReturnAddress;
    __Program(S+MsgSystemFull(__ReturnAddr));
end;
class procedure AmRaise.RaiseDefault(S:string;__ReturnAddr:Pointer=nil);
begin
    if not Assigned(__ReturnAddr) then
    __ReturnAddr:= ReturnAddress;
    raise Exception.Create(S+MsgDefault(__ReturnAddr));
end;
class procedure AmRaise.RaiseSystem(S:string);
begin
     raise Exception.Create(S+MsgSystem());
end ;
class procedure AmRaise.RaiseSystemFull(S:string;__ReturnAddr:Pointer=nil);
begin
    if not Assigned(__ReturnAddr) then
    __ReturnAddr:= ReturnAddress;
     raise Exception.Create(S+MsgSystemFull(__ReturnAddr));
end;

class function AmRaise.MsgDefault(__ReturnAddr:Pointer=nil):string;
 var OutTrack:AmDebug.TProcTrack;
begin
    Result:='';
   {$IFDEF DEBUG}
     if not Assigned(__ReturnAddr) then
     __ReturnAddr:= ReturnAddress;
     AmDebug.ProcTrack(__ReturnAddr,@OutTrack);
     if OutTrack.Result then
     Result:= ' Addr:[$'+IntToHex(Integer(__ReturnAddr))+'] '+OutTrack.UnitName+ '.'+ OutTrack.ProcedureName +' Size:'+ OutTrack.SizeProc.ToString +' LileNumber:'+OutTrack.LineNumber.ToString
     else
     Result:=   ' Addr:[$'+IntToHex(Integer(__ReturnAddr))+'] ';
   {$ENDIF}
   {$IFDEF RELEASE}
     if Assigned(__ReturnAddr) then
     Result:=   ' Addr:[$'+IntToHex(Integer(__ReturnAddr))+'] ';
   {$ENDIF}
end;
class function AmRaise.MsgSystem():string;
 var Er:DWord;
begin
      Er:= GetLastError;
      if Er<>0 then
      Result:= ' ErrorCode['+ IntTostr(Er) +'] Message['+ SysErrorMessage(Er)+'] '
      else Result:='';
end;
class function AmRaise.MsgSystemFull(__ReturnAddr:Pointer=nil):string;
begin
      if not Assigned(__ReturnAddr) then
      __ReturnAddr:= ReturnAddress;
      Result:=MsgSystem +  MsgDefault(__ReturnAddr);
end;

class function AmIf.Ravno12(s1,s2:string;ResulTrue,ResultFalse:string):string;
begin
  if s1=s2 then  REsult:= ResulTrue
  else           REsult:= ResultFalse

end;
class function AmIf.Bool(V:boolean;ResulTrue,ResultFalse:string):string;
begin
  if V then Result:=  ResulTrue
  else    Result:= ResultFalse ;
  
end;


class function AmHex16.BtoH_for_ArrByte(ArrByte:Pointer;FormatBegin:string='';FormatEnd:string=''):string;
var A:PArrByte;
begin
   A:= PArrByte(ArrByte);
   if A.Count>0 then
   Result:= BtoH_for_Pointer(Pbyte(A.ArrayInstancePointer),A.Count,FormatBegin,FormatEnd)
   else Result:='';
end;
class function AmHex16.BtoH_for_Bytes(ArrByte:TBytes;FormatBegin:string='';FormatEnd:string=''):string;
var C:Integer;
begin
  C:=Length(ArrByte);
  if C>0 then   
  Result:= BtoH_for_Pointer(Pbyte(@ArrByte[0]),C,FormatBegin,FormatEnd)
  else Result:='';
end;
class function AmHex16.BtoH_for_Pointer(B:Pbyte;Count:integer;FormatBegin:string='';FormatEnd:string=''):string;
      const
        BytesHex: array[0..15] of char =
          ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
 AchB,AchE :TArray<char>;
 Lb,Le:integer;
 i,x:integer;
 SizeOne:integer;
begin
        AchB:= TArray<char>(FormatBegin);
        AchE:= TArray<char>(FormatEnd);
        Lb :=  length(AchB);
        Le :=  length(AchE);
        SizeOne:=   Lb + Le;
        SizeOne:=   max(2 ,2 * SizeOne);

        SetLength(Result, Count * SizeOne);
        for i := 0 to Count - 1 do begin

          for x := 0 to Lb - 1 do
            Result[i * SizeOne + x+ 1] := AchB[x];

          Result[i * SizeOne + Lb + 1] := BytesHex[B^ shr 4];
          Result[i * SizeOne + Lb + 2] := BytesHex[B^ and $0F];

          for x := 0 to Le - 1 do
            Result[i * SizeOne + Lb + 2 + x + 1] := AchE[x];
          inc(B);
         // Result[i * 5 + 5] := '';
        end;
end;
class procedure AmHex16.HtoB_for_ArrByte(ArrByte:Pointer;S:string;FormatBegin:string='';FormatEnd:string='');
var A:PArrByte;
 SizeOne, Count:integer;
begin
   A:= PArrByte(ArrByte);
   HtoB_GetCount(@S,SizeOne,Count,FormatBegin,FormatEnd);
   A.Count:= Count;
   HtoB_for_Pointer(Pbyte(A.ArrayInstancePointer),@S,length(FormatBegin),SizeOne, Count);
   A.UpdateA;
end;
class procedure AmHex16.HtoB_for_Bytes(ArrByte:PBytes;S:string;FormatBegin:string='';FormatEnd:string='');
var
 SizeOne, Count:integer;
begin
   HtoB_GetCount(@S,SizeOne,Count,FormatBegin,FormatEnd);
   SetLength(ArrByte^,Count);
   if Count>0 then   
   HtoB_for_Pointer(Pbyte(@ArrByte^[0]),@S,length(FormatBegin),SizeOne, Count);
end;
class procedure  AmHex16.HtoB_GetCount(S:Pstring;out SizeOne:integer;out Count:integer;FormatBegin:string='';FormatEnd:string='');
begin
    SizeOne:=   length(FormatBegin) + length(FormatEnd);
    SizeOne:=   max(2 ,2 * SizeOne);
    Count:=length(S^) div SizeOne;
end;
class procedure  AmHex16.HtoB_for_Pointer(B:Pbyte;S:Pstring;CountBegin,SizeOne,Count:integer);
 var
 i:integer;
 Str:string;
begin
    i:=0;
    while i<Count do
    begin
        Str:= Copy(S^,i*SizeOne +CountBegin + 1 ,2);
        B^:= Byte(AmHexToInt(Str));
        inc(B);
        inc(i);

    end;
end;



function AmSystemInfo_IsDebugConfig_Module(hModule:Cardinal):TboolTri;
var P:Pointer;
type TProc = function:BOOL ;
//var  i:boolean;
begin
   Result:= bnot;
   if hModule=0 then exit;
   P:= GetProcAddress(hModule,Pchar('AmSystemInfo_IsDebugConfig'));
   if Assigned(P) then    
   Result.SetValue(Boolean(TProc(P)()));
end;
function AmSystemInfo_IsDebugConfig_FileName(FileName:string):TboolTri;
var hModule:Cardinal;
begin
   Result:= bnot;
   hModule:= LoadLibrary(PChar(FileName));
   if hModule=0 then exit;
   try
        Result:= AmSystemInfo_IsDebugConfig_Module(hModule);
   finally
      FreeLibrary(hModule);
   end;
end;
function AmSystemInfo_IsDebugConfigEx:BOOL;
begin
     {$IFDEF DEBUG}
      Result:= TRUE;
      {$ENDIF}
      {$IFDEF RELEASE}
      Result:= FALSE;
      {$ENDIF}
end;
class function AmSystemInfo.IsDebugConf:boolean;
begin
     {$IFDEF DEBUG}
      Result:= TRUE;
      {$ENDIF}
      {$IFDEF RELEASE}
      Result:= FALSE;
      {$ENDIF}
end;
class function AmSystemInfo.IsInitProgram:boolean;
begin
 Result:= AmAtomic.Getter(FIsInitProgram);
end;
class procedure AmSystemInfo.IsNotInitProgramRaise(Address:Pointer=nil);
begin
  if not IsInitProgram then   
  AmRaise.RaiseDefaultProgram('Error Unit [AmUserType] Field [AmSystemInfo.IsInitProgram=false]',Address);
end;
class procedure AmSystemInfo.IsInitProgramSet;
begin
  AmAtomic.Setter(FIsInitProgram,true);
end;
class procedure AmSystemInfo.ReportMemory(Value:boolean);
begin
 reportmemoryleaksonshutdown:= Value;
end;
class function AmSystemInfo.GetMacList(const List: TStrings; Machine: string=''): Integer;
begin
  try
    Result:= JclSysInfo.GetMacAddresses(Machine,List);
  except
     Result:=0;
     List.Clear;

  end;
end;
class function AmSystemInfo.GetMacDen(denlim:string='|'; Machine: string=''): string;
var L:TStringlist;

begin
   L:= TStringlist.Create;
   try
      L.Duplicates :=dupIgnore;
      L.Sorted:=true;
      GetMacList(L,Machine);
      Result:=Result.Join(denlim,AmArray(L))
   finally
    L.Free;
   end;
end;
class function AmSystemInfo.GetSerialNumDisk_C:string;
//получаем серийник диска С
var
VolumeSerialNumber : DWORD;
MaximumComponentLength : DWORD;
FileSystemFlags : DWORD;
begin

  try
    GetVolumeInformation('C:\',  nil, 0, @VolumeSerialNumber,
    MaximumComponentLength, FileSystemFlags,  nil,  0);
    Result := IntToHex(HiWord(VolumeSerialNumber), 4) +   '-' +
    IntToHex(LoWord(VolumeSerialNumber), 4);
  except
     Result:='';
  end;
end;
class procedure AmSystemInfo.GetINVIDIA_List(L:TStrings);
var
  lpDisplayDevice: TDisplayDevice;
  dwFlags: DWORD;
  cc: DWORD;
begin
  try
      L.Clear;
      lpDisplayDevice.cb := sizeof(lpDisplayDevice);
      dwFlags := 0;
      cc := 0;

      while EnumDisplayDevices(nil, cc, lpDisplayDevice, dwFlags) do
      begin
        Inc(cc);
        L.Add(lpDisplayDevice.DeviceString);
        {Так же мы увидим дополнительную информацию в lpDisplayDevice}
        //form2.show;
      end;
  except
      L.Clear;
  end;
end;
class function AmSystemInfo.GetINVIDIA(denlim:string='|'):string;
var L:TStringlist;

begin
   L:= TStringlist.Create;
   try
      L.Duplicates :=dupIgnore;
      L.Sorted:=true;
      GetINVIDIA_List(L);
      Result:=Result.Join(denlim,AmArray(L))
   finally
    L.Free;
   end;
end;
class function AmSystemInfo.GetHardDiskSerialnumber(DenLim:string='|'):string;
var L:TStringlist;

begin
   L:= TStringlist.Create;
   try
      //L.Duplicates :=dupIgnore;
     // L.Sorted:=true;
      GetHardDiskSerialnumberList(L);
      Result:=Result.Join(denlim,AmArray(L))
   finally
    L.Free;
   end;

end;
class procedure AmSystemInfo.GetHardDiskSerialnumberList(L:TStrings);
  //получаем номер жесткого диск модель имя номер
  // требуется модуль dprocess в implementation;
var outputed: ansistring;
res:string;
A:TArray<string>;
begin
   showmessage('AmSystemInfo.GetHardDiskSerialnumberList не работатет не дописан код');
res:='';

 try
  RunCommand('cmd', ['/c',' chcp 65001 && wmic diskdrive get SerialNumber'], outputed, [poNewProcessGroup]);
  res:= UnicodeString(outputed);
  A:= res.Split([#13,#10]);
  //TStringlist(L).text:=res;
  //owmessage(res);
  res:= res.Replace(' ','');
  res:= res.Replace(' ','');
  res:= res.Replace(#10,'');
  res:= res.Replace(#13,'');
  res:= res.Replace('/','');
  res:= res.Replace('\','');
  res:= res.Replace('.','');
  res:= res.Replace(',','');
  res:= trim(res);
  if pos('SerialNumber',res)<>0 then
  begin
     res:=res.Split(['SerialNumber'])[1];

  end;

 except

 end;


  if trim(res)='' then res:='NoNum';
  //Result:=res;
end;
class function AmSystemInfo.GetHardDiskIndex(Index:integer):string;
begin
   try
    Result:= MagWmiGetDiskSerial(Index).trim;
   except
     Result:='';
   end;

end;

Class function  AmBoard.TextGet:string;
begin
  Result:= Clipboard.AsText;
end;
Class procedure AmBoard.TextSet(S:string);
begin
  Clipboard.AsText:=s;
end;


class function AmEncoding.TLocClass.ClassGetChars(Source:TEncoding;Bytes: PByte; ByteCount: Integer; Chars: PChar; CharCount: Integer): Integer;
begin
  Result:=0;
  //Result:= Source.GetChars(Bytes,ByteCount,Chars,CharCount);
end;

class function AmEncoding.Ansi_BToS_ForArrByte(ArrByte:Pointer;Str:PString):integer;
var Arr:PArrByte;
begin
  Arr:= PArrByte(ArrByte);
  Result:=Arr.Count;
  SetString(Str^, PAnsiChar(Arr.ArrayInstancePointer),Result);
end;
class function AmEncoding.Ansi_SToB_ForArrByte(ArrByte:Pointer;Str:PString):integer;
var Arr:PArrByte;
begin
  Arr:= PArrByte(ArrByte);
  Result:=length(Str^);
  Arr.Count:=Result;
  move(Pchar(AnsiString(Str^))^,Pointer(Arr.ArrayInstancePointer)^,Result);
  Arr.UpdateA;
end;
class function AmEncoding.Ansi_SToB_GetCount(Str:PString):integer;
begin
  Result:= length(Str^);
end;

class function AmEncoding.Utf8_BToS_ForArrByte(ArrByte:Pointer;Str:PString):integer;
var Arr:PArrByte;
begin
   Arr:= PArrByte(ArrByte);
   Result:=Def_BToS_GetCount( CP_UTF8, 0,Arr.ArrayInstancePointer,Arr.Count);
   SetLength(Str^, Result);
   Result:=Def_BToS(CP_UTF8, 0,Arr.ArrayInstancePointer,Arr.Count,Str,Result);
end;
class function AmEncoding.Utf8_SToB_ForArrByte(ArrByte:Pointer;Str:PString):integer;
var Arr:PArrByte;
begin
  Arr:= PArrByte(ArrByte);
  Arr.Count := Def_SToB_GetCount(CP_UTF8, 0,Str, length(Str^));
  Arr.Count := Def_SToB(CP_UTF8, 0,Arr.ArrayInstancePointer,Arr.Count, Str, length(Str^));
  Result:= Arr.Count;
end;
class function AmEncoding.Utf8_SToB_GetCount(Str:PString):integer;
begin
 Result:=  Def_SToB_GetCount(CP_UTF8, 0,Str, length(Str^));
end;


class function AmEncoding.Def_BToS_GetCount(CodePage,Flag:Cardinal;Arr:Pointer;ArrCount:Integer):integer;
begin
  Result := UnicodeFromLocaleChars(CodePage, Flag, MarshaledAString(Arr),
   ArrCount, nil, 0);
end;
class function AmEncoding.Def_BToS(CodePage,Flag:Cardinal;Arr:Pointer;ArrCount:Integer;Str:PString;StrCount:Integer):integer;
begin
  Result:=  UnicodeFromLocaleChars(CodePage, Flag, MarshaledAString(Arr),
    ArrCount, Pchar(Pointer(Str)^), StrCount);
end;
class function AmEncoding.Def_SToB_GetCount(CodePage,Flag:Cardinal;Str:PString;StrCount:Integer):integer;
begin
  Result := LocaleCharsFromUnicode(CodePage, Flag, Pchar(Pointer(Str)^), StrCount,
  nil, 0, nil, nil);
end;
class function AmEncoding.Def_SToB(CodePage,Flag:Cardinal;Arr:Pointer;ArrCount:Integer;Str:PString;StrCount:Integer):integer;
begin
   Result := LocaleCharsFromUnicode(CodePage, Flag, Pchar(Pointer(Str)^), StrCount,
    MarshaledAString(Arr), ArrCount, nil, nil);
end;



    {AmStringHlp}
// вернуть строку с опред колво Ch
class function AmStringHlp.GetCountChar(ACount:integer;Ch:Char):string;
var i:integer;
begin
   Result:='';
   for I := 0 to ACount-1 do
   if Result = '' then Result:=Ch
   else                Result:=Result+Ch;
end;
// сколько пробелов по бокам
class function AmStringHlp.CountSpace(S:string;isleft:boolean=true):integer;
var i:integer;
begin
   Result:=0;
   if isleft then
   begin
   for I := 1 to length(s) do
     if s[i]<>' ' then exit
     else inc(result);
   end
   else
   begin
     for I := length(s) downto 1 do
       if s[i]<>' ' then exit
       else inc(result);
   end;
end;

// функция pos но ищет с конца
class function AmStringHlp.PosInvert( const FindS, SrcS: string;offset:integer=1): Integer;
begin
    Result:=PosR2(FindS,SrcS,offset);
end;
class function AmStringHlp.PosInvertLast( const FindS, SrcS: string;offset:integer=1): Integer;
begin
  Result:= Pos(InvertS(FindS), InvertS(SrcS),offset);
end;
class function AmStringHlp.PosLast( const FindS, SrcS: string;offset:integer=1): Integer;
begin
   Result:= system.Pos(FindS,SrcS,offset);
  if Result <> 0 then
    Result := Length(SrcS) - Length(FindS) - Result + 2;
end;
class function AmStringHlp.Pos( const FindS, SrcS: string;offset:integer=1): Integer;
begin
  Result:= system.Pos(FindS,SrcS,offset);
end;

// зеркально отражает строку
class function AmStringHlp.Invert(const S: string): string;
begin
    Result:= InvertS(S);
end;


class function AmStringHlp.CountPos(const subtext: string; Text: string): Integer;
begin
  Result:= AmUsertype.CountPos(subtext,Text);
end;
class function AmStringHlp.PosArray(A:TArray<string>;Input:string):boolean;
begin
   result:= AmPosArray(A,Input);
end;
class function AmStringHlp.PosArrayIndexOf(IsRevers:boolean;A:TArray<string>;Input:string;var Index:integer;var APos:integer):boolean;
begin
  if IsRevers then Result:= AmPosArrayIndexOfRevers(A,Input,Index,APos)
  else             Result:= AmPosArrayIndexOf(A,Input,Index,APos);
end;
class function AmStringHlp.CmpArray(A1,A2:TArray<string>):boolean;
begin
  result:= AmCmpArray(A1,A2);
end;
class function AmStringHlp._PrSpace(C: Char;Position:integer): integer;
begin
 case C of ' ',#13,#10:Result:=0; else Result:=1;end;
end;
class function AmStringHlp.PosTokens_PrSpace(IsRevers:boolean;Tokens:TArray<string>;Source:string;startPos:integer;Pravilo:integer;out IndexToken:integer):integer;
var F:TFunPravilo;
begin
    F:=nil;
    case Pravilo of
           0:F:= _PrSpace;
           else  AmRaise.RaiseDefault('AmStringHlp.PosTokens_PrSpace не указана функция правила');
    end;
   Result:=PosTokens(IsRevers,Tokens,Source,startPos,F,IndexToken);
end;
class function AmStringHlp.PosToken_PrSpace(IsRevers:boolean;Token:string;Source:string;startPos:integer;Pravilo:integer=0):integer;
var F:TFunPravilo;
begin
    F:=nil;
    case Pravilo of
           0:F:= _PrSpace;
           else  AmRaise.RaiseDefault('AmStringHlp.PosToken_PrSpace не указана функция правила');
    end;
   Result:=PosToken(IsRevers,Token,Source,startPos,F);
end;
// вернет позицию как pos но еще выполнит правило
class function AmStringHlp.PosToken(IsRevers:boolean;Token:string;Source:string;startPos:integer;Pravilo:TFunPravilo):integer;
var i,x,rResult,xPr:integer;
A,B:char;
  function ifwhile:boolean;
  begin
    if not IsRevers then  Result:=i<=length(Source)
    else                   Result:=i>=1;
  end;
  function ifcmp:boolean;
  begin
     if IsRevers then
     begin
      if x = length(Token) then
      rResult:=i;
      Result:= x = 1;
     end
     else
     begin
      if x = 1 then
      rResult:=i;
      Result:= x = length(Token);
     end;
  end;
  procedure InitstartPos;
  begin
    if IsRevers then
    x:=length(Token)
    else
    x:=1;
    startPos:= max(1,startPos);
    i:= startPos;
    if IsRevers then
    i:=length(Token) + (- startPos +1);

  end;
  procedure LocDef;
  begin
    rResult:=0;
  end;
begin

    Result:=0;
    rResult:=0;
    InitstartPos;

    if length(Token)>0 then
    while ifwhile   do
    begin
       try
         A:=  Char(Source[i]).ToLower;
         B:= Char(Token[x]).ToLower;
         if A<>B then
         begin
             LocDef;
             if not Assigned(Pravilo) then
             continue;
             xPr:=Pravilo(A,i);
             case xPr of
                    1:exit;
             end;

         end
         else
         begin
            if ifcmp then
            begin
              Result:=  rResult;
              break;
            end;
            if IsRevers then
            dec(x)
            else
            inc(x);
         end;


       finally
            if IsRevers then
            dec(i)
            else
            inc(i);
       end;
    end;

end;
class function AmStringHlp.PosTokens(IsRevers:boolean;Tokens:TArray<string>;Source:string;startPos:integer;Pravilo:TFunPravilo;out IndexToken:integer):integer;
var i:integer;
begin
    IndexToken:=-1;
    Result:=-1;
    for I := 0 to length(Tokens)-1 do
    begin
       Result:= PosToken(IsRevers,Tokens[i],Source,startPos,Pravilo);
       if Result>0 then
       begin
           IndexToken:=i;
           break;
       end;
    end;
end;



         {AmStringSplit}
class function AmStringSplit.Split(Separator:string; S:String;var A:TArray<string>):Integer;
begin
 Result:= SplitForArrayOfString(Separator,@S,@A);
end;
class function AmStringSplit.SplitForArrayOfString(Separator:string; S:PString;ArrayOfString:Pointer):Integer;
begin
  //   var A:TArray<string>;
  //SetLength(A,20);
  //Count:= SplitForArrayOfString(Separator,@S,@A);

  Result:= SplitArrayCustomPointer(Separator,S,PPointer(ArrayOfString)^,length(Tarray<string>(PPointer(ArrayOfString)^)));
end;
class function AmStringSplit.SplitForArrStr(Separator:string; S:PString;ArrStr:Pointer):Integer;
var L:PArrStr;
begin
  // var A:TArrStr;
  //A.count:=20;
  // SplitForArrStr(Separator,@S,@A);
   L:= PArrStr(ArrStr);
   Result:= SplitArrayCustomPointer(Separator,S,L.ArrayInstancePointer,L.Capacity);
   L.Count:=Result;
   L.UpdateA;
end;
class function AmStringSplit.SplitArrayCustomPointer(Separator:string; S:PString;DynArrayString:Pointer;CountMax:Integer):Integer;
var
u,y:integer;
sl:string;
begin
  y:=1;
  Result:=0;
  if (length(Separator)=0) or (length(S^)=0) then exit;
  while y<=Length(s^) do
  begin
      u:=pos(Separator,s^,y);
      if u<>0 then
      begin
        if Result>=CountMax-1 then
        raise Exception.Create('Error AmStringSplit.SplitArrayCustomPointer Размер array превышен');
        
        TArray<string>(DynArrayString)[Result]:=(Copy(s^,y,u-y));
        y:=u+length(Separator);
      end
      else
      begin
        if Result>=CountMax-1 then
        raise Exception.Create('Error AmStringSplit.SplitArrayCustomPointer Размер array превышен');
        TArray<string>(DynArrayString)[Result]:=(Copy(s^,y,Length(s^)-y+1));
        y:=Length(s^)+1;
      end;
      inc(Result);
  end;
  sl:=Copy(s^,length(s^)-length(Separator)+1,length(Separator));
  if sl=Separator then
  begin
        if Result>=CountMax-1 then
        raise Exception.Create('Error AmStringSplit.SplitArrayCustomPointer Размер array превышен');
    TArray<string>(DynArrayString)[Result]:='';
    inc(Result);
  end;

end;


procedure TAmToJsonVariableRtti.AddJsonValue(P:PParam;F:TJsonDataValueHelper;V :TValue; LastType:TRttiType);
var Dym:TRttiDynamicArrayType;
i,Count:integer;
VA :TValue;
rttiContext : TRttiContext;
s,AName:string;
RTyp:TRttiType;
  enumBuffer: set of Byte;
  enumType: PTypeInfo;
  enumData: PTypeData;
  enumDenLimiter:boolean;
  Ps:Pointer;
begin
{ TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
  tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
  tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
  tkClassRef, tkPointer, tkProcedure, tkMRecord);}



     case V.Kind of
         tkInterface    : begin
                           if  V.AsInterface is tOBJECT then
                            begin

                              if P.Level>P.MaxLevel then
                              begin
                                 F.Value:='[break:MaxLevel:tkInterface]';
                                 exit;
                              end;
                              inc(P.Level);
                              try
                                 if P.NeedNameType then
                                 AName:='Object:'+ TObject(V.AsInterface).ClassName
                                 else
                                 AName:= 'Object';
                                 RTyp:= rttiContext.GetType(TObject(V.AsInterface).ClassInfo);
                                 ParsJsonValue(P,F.ObjectValue[AName].ObjectValue,TObject(V.AsInterface),RTyp);
                              finally
                               dec(P.Level);
                              end;


                             // F.Value:=  TObject(V.AsInterface).ClassName;
                            end;

                          end;
        tkInteger       : F.IntValue:=       V.AsInteger;
        tkPointer       : begin
                             RTyp:=nil;
                             Ps:= V.AsType<Pointer>;

                             if (V.TypeInfo <> typeinfo(Pointer)) and (V.TypeInfo <> typeinfo(PPointer)) then
                             begin
                                  {
                                try
                                   if (V.TypeInfo = typeinfo(PChar)) then
                                   begin
                                     AName:= 'Type:'+V.TypeInfo.Name;
                                     F.ObjectValue[AName].Value:= string(PChar(Ps));
                                     Ps:=nil;
                                   end;
                                except
                                end;
                                }

                                 if Ps<>nil then                                 
                                 begin
                                     enumType := V.TypeInfo.TypeData.RefType^;
                                     RTyp:= rttiContext.GetType(enumType);
                                     AName:= 'Type:'+string(enumType.Name);
                                     if Ps<>Pointer($FFFFFFFF) then
                                     begin
                                         try
                                           TValue.Make(
                                             Ps,
                                            enumType,
                                            VA);
                                         except
                                           Ps:=nil;
                                         end;
                                     end
                                     else
                                     begin

                                     end;
                                 end;

                             end
                             else
                             begin
                                Ps:=nil;
                             end;
                             F.ObjectValue['Addr'].Value:= '$'+ IntToHex(Integer(V.AsType<Pointer>));

                                 try
                                 if (Ps <> nil) and (Ps<>Pointer($FFFFFFFF)) and (RTyp<>nil) then
                                 AddJsonValue(P,F.ObjectValue[AName],VA,RTyp);
                                 except
                                   //Ps:=nil;
                                 end;
                           //ParsJsonValue(P,F.ObjectValue[AName].ObjectValue,TObject(V.AsInterface),RTyp);

                         // F.IntValue:=   VA.AsInteger;
                          // F.Value:=      '$'+ IntToHex(Integer(V.AsType<Pointer>));
                          end;

        tkEnumeration   : begin

                           F.Value:=  GetEnumName(V.TypeInfo, V.AsOrdinal);

                          end;
        tkFloat         : begin

                              if V.TypeInfo = TypeInfo(TDateTime) then
                              F.DateTimeValue:=  V.AsExtended
                              else
                              F.FloatValue:=    V.AsExtended;


                          end;
        tkSet           : begin
                              V.ExtractRawData(@enumBuffer);

                              if V.TypeInfo=nil then  exit;
                              if V.TypeInfo.TypeData=nil then  exit;
                              if V.TypeInfo.TypeData.CompType=nil then  exit;

                              enumType := V.TypeInfo.TypeData.CompType^;



                              if enumType=nil then  exit;

                              enumData := enumType.TypeData;
                              if enumData=nil then  exit;
                              s:=string(V.TypeInfo.Name)+':[';
                              enumDenLimiter:=false;
                              for i := enumData.MinValue to enumData.MaxValue do
                              if i in enumBuffer then
                              begin
                               if enumDenLimiter then
                               s:= s+', ';
                               s:= s+ GetEnumName(enumType, i);
                               enumDenLimiter:=true;
                              end;
                              s:= s+']';
                              F.Value:=  s;


                          end;
        tkVariant       :  F.VariantValue:=  V.AsVariant;
        tkInt64         :  F.LongValue:=     V.AsInt64;

        tkChar,
        tkWChar,
        tkLString,
        tkWString,
        tkUString,
        tkString       :   F.Value:=         V.AsString;


        tkMRecord,
         tkRecord :      begin
                              if P.Level>P.MaxLevel then
                              begin
                                 F.Value:='[break:MaxLevel:tkRecord]';
                                 exit;
                              end;
                           inc(P.Level);
                           ParsJsonValue(P, F.ObjectValue,V.GetReferenceToRawData,LastType);
                           dec(P.Level);
                         end;


        tkClass :        begin
                              if P.Level>P.MaxLevel then
                              begin
                                 F.Value:='[break:MaxLevel:tkClass]';
                                 exit;
                              end;
                           inc(P.Level);
                           ParsJsonValue(P, F.ObjectValue,V.AsObject,LastType);
                           dec(P.Level);
                         end;
        tkClassRef :     begin
                          F.Value:=         V.AsClass.ClassName;

                         end;

        tkDynArray,
        tkArray        : begin
                            if P.Level>P.MaxLevel then
                            begin
                                F.Value:='[break:MaxLevel:tkArray]';
                               exit;
                            end;
                            Count:= V.GetArrayLength;
                            F.ArrayValue.Count:=Count;
                             for I := 0 to Count-1 do
                             begin
                                 VA:=V.GetArrayElement(i);
                                // s:=VA.TypeInfo.Name;

                                 RTyp:= rttiContext.GetType(VA.TypeInfo);
                                 if  (RTyp<> nil) then
                                 begin
                                 inc(P.Level);
                                 AddJsonValue(P,F.ArrayValue[i],VA,RTyp);
                                 dec(P.Level);
                                 end;

                             end;
                         end;
     end;


end;
procedure TAmToJsonVariableRtti.ParsJsonValue(P:PParam;J:TJsonObject;Instance:Pointer; LastType:TRttiType);
var ListF:TArray<TRttiField>;
fld:TRttiField;
AName:string;
R:boolean;
begin
   if Instance=nil then  exit;

   ListF:=LastType.GetFields;
   for fld in ListF do
   if  (fld<> nil) and (fld.FieldType<>nil) then
   begin
         R:=true;
         if (fld.Parent<>nil) then
         R:= CanConinue(fld.Parent.Handle,P,false);

         if R then
         begin
            if P.NeedNameType then AName:= fld.Name +':'+fld.FieldType.Name
            else         AName:= fld.Name;

           AddJsonValue(P,J[AName],fld.GetValue(Instance),fld.FieldType);
         end
        // else break;
   end;
end;
function  TAmToJsonVariableRtti.CanConinue(HandleParent:PTypeInfo;P:PParam;isFP:boolean ):boolean;
var ObjParent:TObject;


  function Loc_Black:boolean;
  var   Cl,Cl2:TClass;
   s:string;
  begin
          Result:= true;
          if   not (ObjParent=nil) then
          for Cl in  P.ClassBlack do
          begin
              s:=ObjParent.ClassType.ClassName;
              if (Cl.InheritsFrom(ObjParent.ClassType))  then
              begin
                  Result:=false;
                  for Cl2 in  P.ClassWhite do
                  if ObjParent.ClassType = Cl2 then
                  begin
                    Result:=true;
                    exit;
                  end;
                  exit;
              end;
          end;
  end;
begin
        Result:=false;
       // if isFP then exit(true);

        ObjParent:=nil;

        if (HandleParent<>nil)
        and (HandleParent.TypeData<>nil) then
        begin
             if HandleParent.Kind  = tkClass then
             begin
              ObjParent:=  TObject(HandleParent.TypeData);
             // s:= ObjParent.ClassName;
              if not  Loc_Black then exit;
             end;
        end;

       Result:=true;



      //  if (P.StopParentClass.InheritsFrom(ObjParent.ClassType))  then exit(false);


      // Result:= (P.AffectedClass = nil)
      // or ( ObjParent = nil)
      // or (ObjParent.ClassType =  P.AffectedClass);


end;
procedure TAmToJsonVariableRtti.VarFieldsToJson<T>(var  Result:TJsonObject;var Instance:T;
                                    MaxLevelRecursPars:integer;
                                    NeedNameType:boolean;
                                    ClassBlack,ClassWhite:TArray<TClass>);
var
  fld : TRttiField;
  rttiContext : TRttiContext;
  rttiType:TRttiType;
  ListF:TArray<TRttiField>;
  V:     TValue;
  Node:AmRecordHlp.TMemberNode;
  R:boolean;
  Value:TValue;
  Level:integer;
  Error,AName:string;
  P:TParam;

begin
  {
    MaxLevelRecursPars 1000 эт очень много программа может вылетить
    от переполнении стека
    попробуй отправить сюла Tform и с 1000 и прога вылетит
    и оч долго будет с 15
    т.к в Tcompanent есть ссылки на паренты объектов

    также можн ограничить какой именно класс парсить если это класс
    или до какого класса парсить
    что бы не доходить до  Tcompanent или TWinControl

    если T is TObject
    то AffectedClass,StopParentClass:TClass можно заполнять что бы они не nil

    можно задать затрагиваемый класс AffectedClass а  StopParentClass = nil
    или    AffectedClass = nil
    StopParentClass установить например  TWinControl дойдя до него парсинг остановится

   AffectedClass StopParentClass

   IsAllLevelClass =true   AffectedClass StopParentClass применяется для всех уровней
   иначе только для   Instance:T;


      case RootTypeInfo.Kind of
           tkClass: begin
  }

   P.Level:= 0;
   P.MaxLevel:= MaxLevelRecursPars;
   P.NeedNameType:=     NeedNameType;
   P.ClassBlack:=    ClassBlack;
   P.ClassWhite:=  ClassWhite;



   if P.MaxLevel<1 then P.MaxLevel:=1;
   if P.MaxLevel>1000 then
   P.MaxLevel:=1000;




  Node:=AmRecordHlp.TMemberNode.Create;
  try
    R:= Node.GetRoot(Instance,Error);
    if not  R then exit;

    if Node.RootTypeInfo.Kind = tkClass then
    begin
         {  if Assigned(P.AffectedClass) then
           begin
             if not (TObject(Node.RootInstance) is P.AffectedClass)  then
             raise Exception.Create('Error.TAmToJsonVariableRtti.VarFieldsToJson класс AffectedClass не яаляется предком Instance');
           end;
           if Assigned(P.StopParentClass) then
           begin
             if not (TObject(Node.RootInstance) is P.StopParentClass)  then
             raise Exception.Create('Error.TAmToJsonVariableRtti.VarFieldsToJson класс StopParentClass не яаляется предком Instance');
           end; }

    end;




    ListF:=rttiContext.GetType(Node.RootType).GetFields;
    for fld in ListF do
    if  (fld<> nil) and (fld.FieldType<>nil) then
    begin
         AName:= fld.Name;
         R:=true;
         if (fld.Parent<>nil) then
         R:= CanConinue(fld.Parent.Handle,@P,true);
       //  R:= R and CanConinue(fld.Handle,@P,true);

         if R then
         begin
            if P.NeedNameType then AName:= fld.Name +':'+fld.FieldType.Name
            else                   AName:= fld.Name;
            inc(P.Level);
            AddJsonValue(@P,Result[AName],fld.GetValue(Node.RootInstance),fld.FieldType);
            dec(P.Level);
         end




    end;
  finally
    Node.Free;
  end;
end;

procedure TAmToJsonVariableRtti.LoadJsonObject(F:TJsonDataValueHelper;Instance:Pointer; Field:TRttiField);
begin
{ TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
  tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
  tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
  tkClassRef, tkPointer, tkProcedure, tkMRecord);}



     case Field.FieldType.Handle.Kind of
         tkInterface    : begin

                          end;
        tkInteger       :  Pinteger(integer(Instance) + Field.Offset)^:=  F.IntValue;
        tkPointer       : ;

        tkEnumeration   : begin

                           //F.Value:=  GetEnumName(V.TypeInfo, V.AsOrdinal);

                          end;
        tkFloat         : begin

                             //// if V.TypeInfo = TypeInfo(TDateTime) then
                             // F.DateTimeValue:=  V.AsExtended
                             // else
                             // F.FloatValue:=    V.AsExtended;


                          end;
        tkSet           : begin


                          end;
        tkVariant       : ; //F.VariantValue:=  V.AsVariant;
        tkInt64         :PInt64(integer(Instance) + Field.Offset)^:=  F.LongValue;

        tkChar,
        tkWChar,
        tkLString,
        tkWString,
        tkUString,
        tkString       : PString(integer(Instance) + Field.Offset)^:=  F.Value;


        tkMRecord,
         tkRecord :      begin
                            {  if P.Level>P.MaxLevel then
                              begin
                                 F.Value:='[break:MaxLevel:tkRecord]';
                                 exit;
                              end;
                           inc(P.Level);
                           ParsJsonValue(P, F.ObjectValue,V.GetReferenceToRawData,LastType);
                           dec(P.Level);
                           }
                         end;


        tkClass :        begin
                           {   if P.Level>P.MaxLevel then
                              begin
                                 F.Value:='[break:MaxLevel:tkClass]';
                                 exit;
                              end;
                           inc(P.Level);
                           ParsJsonValue(P, F.ObjectValue,V.AsObject,LastType);
                           dec(P.Level);}
                         end;

        tkDynArray,
        tkArray        : begin

                         //  if Field.FieldType.Handle.Kind = tkDynArray then


                           { if P.Level>P.MaxLevel then
                            begin
                                F.Value:='[break:MaxLevel:tkArray]';
                               exit;
                            end;
                            Count:= V.GetArrayLength;
                            F.ArrayValue.Count:=Count;
                             for I := 0 to Count-1 do
                             begin
                                 VA:=V.GetArrayElement(i);
                                // s:=VA.TypeInfo.Name;

                                 RTyp:= rttiContext.GetType(VA.TypeInfo);
                                 if  (RTyp<> nil) then
                                 begin
                                 inc(P.Level);
                                 AddJsonValue(P,F.ArrayValue[i],VA,RTyp);
                                 dec(P.Level);
                                 end;

                             end;   }
                         end;
     end;

end;
function TAmToJsonVariableRtti.VarFieldsFromJson<T>(var Instance:T;J:TJsonObject):boolean;
var
  fld : TRttiField;
  rttiContext : TRttiContext;
  ListF:TArray<TRttiField>;
  V:     TValue;
  Node:AmRecordHlp.TMemberNode;
  R:boolean;
  Value:TValue;
  ANameRt,ATypeRt:string;
  ANameJs,ATypeJs,Error:string;
  i:integer;
  FJs:TJsonDataValueHelper;
begin

  Node:=AmRecordHlp.TMemberNode.Create;
  try
    R:= Node.GetRoot(Instance,Error);
    if not  R then exit;




    ListF:=rttiContext.GetType(Node.RootType).GetFields;
    for fld in ListF do
    if  (fld<> nil) and (fld.FieldType<>nil) then
    begin
         ANameRt:= fld.Name;
         ATypeRt:= fld.FieldType.Name;
         R:=true;
         i:=J.IndexOf(ANameRt+':'+ATypeRt);
         if i<0 then raise Exception.Create('Error Нет такого поля а json'+ANameRt+':'+ATypeRt);

         FJs:= J[ANameRt+':'+ATypeRt];

         LoadJsonObject(J[ANameRt+':'+ATypeRt],Node.RootInstance,fld);




     //   if P.NeedNameType then AName:= fld.Name +':'+fld.FieldType.Name
     //   else                   AName:= fld.Name;

       // AddJsonValue(@P,Result[AName],fld.GetValue(Node.RootInstance),fld.FieldType);






    end;
  finally
    Node.Free;
  end;

end;








procedure TAmRecMsgError.AddStackTrace(AStackTrace:string);
begin
 StackTraceAM:=   StackTraceAM+AStackTrace;
end;
function TAmRecMsgError.NewMsg(Place:string;AMsg:string):string;
begin
  IsError:=true;
   Result:= Place +' '+AMsg;
   Msg := Result;
end;
function TAmRecMsgError.AddMsg(Place:string;AMsg:string):string;
begin
  IsError:=true;
  Result:=  Place +' '+AMsg;
  if Msg='' then  Msg:= Result
  else
  begin
    Msg:= Msg+#13#10;
    Msg:= Msg+Result;
  end;

end;
function TAmRecMsgError.NewError(Place:string;E:exception):string;
begin
  IsError:=true;
  Result:=Place +' '+E.Message;
  Msg:= Result;
  StackTraceAM:=   E.StackTrace;
end;
function TAmRecMsgError.AddError(Place:string;E:exception):string;
begin
  IsError:=true;
  if Msg<>'' then
  Msg:=  Msg+#13#10;

  if StackTraceAM<>'' then
  begin
   StackTraceAM:=  StackTraceAM+#13#10;
   StackTraceAM := StackTraceAM+ '-------------------------------'+#13#10;
  end;
  Result:=Place +' '+E.Message;
  Msg:= Msg+Result;
  StackTraceAM:=   StackTraceAM+E.StackTrace;
end;
procedure TAmRecMsgError.Clear;
begin
  IsError:=false;
  CodeInt:=0;
  Msg:='';
  StackTraceAM:='';
  P:=nil;
end;



class procedure AmDebug.CopyToTrack(Track,P:Pointer);
var OutTrack:PProcTrack;
    J: PJclLocationInfo;
begin
   OutTrack:= PProcTrack(Track);
   J:= PJclLocationInfo(P);
  if  Assigned(P) and Assigned(J.Address) then
  begin
     OutTrack.Result:=            true;
     OutTrack.Address:=           J.Address;
     OutTrack.CodeProc:=          Pointer(Cardinal(J.Address) - Cardinal(J.OffsetFromProcName));
     OutTrack.UnitName:=          J.UnitName;
     OutTrack.ClassName:=         J.ClassName;
     OutTrack.ProcName:=          J.ProcName;
     OutTrack.SizeProc :=         J.SizeProc;
     OutTrack.ProcedureName:=     J.ProcedureName;
     OutTrack.OffsetFromProcName:=J.OffsetFromProcName;
     OutTrack.LineNumber:=        J.LineNumber;
     OutTrack.OffsetFromLineNumber:=J.OffsetFromLineNumber;
     OutTrack.SourceName:=        J.SourceName;
     OutTrack.BinaryFileName:=    J.BinaryFileName;
  end
  else
  begin
  Finalize(OutTrack^);
  ResetMemory(OutTrack^, SizeOf(OutTrack^));
  end
end;

class function AmDebug.CurrentAddress:Pointer;
begin
  Result:=ReturnAddress;
end;
class procedure AmDebug.LocationInfo(OutTrack:PProcTrack;ACurrentAddress:Pointer=nil);
var J: TJclLocationInfo;
begin
  if OutTrack=nil then exit;
  Finalize(OutTrack^);
  ResetMemory(OutTrack^, SizeOf(OutTrack^));
  OutTrack.Result:=false;
  if ACurrentAddress=nil then
  ACurrentAddress:=  ReturnAddress;
  J:=JclDebug.GetLocationInfo(ACurrentAddress);
  CopyToTrack(OutTrack,@J);
end;
class function AmDebug.ProcAddress(UnitName,ClassName,ProcName:string;ACurrentAddress:Pointer=nil):Pointer;
var J: TJclLocationInfo;
OutTrack:TProcTrack;
begin
  Result:=nil;
  OutTrack.Result:=false;
  if ACurrentAddress=nil then
  ACurrentAddress:=  ReturnAddress;
  J:=JclDebug.GetLocationInfo(ACurrentAddress,UnitName,ClassName,ProcName);
  CopyToTrack(@OutTrack,@J);
  if OutTrack.Result and Assigned(OutTrack.CodeProc) then
  Result:= OutTrack.CodeProc;
end;
class function AmDebug.CurrentProcAddress:Pointer;
var OutTrack:TProcTrack;
begin
  Result:=nil;
  LocationInfo(@OutTrack,ReturnAddress);
  if OutTrack.Result then
  Result:= OutTrack.CodeProc;
end;
class procedure AmDebug.CurrentProcTrack(OutTrack:PProcTrack);
begin
  ProcTrack(ReturnAddress,OutTrack);
end;
class procedure AmDebug.ProcTrack(AProcAddress:Pointer;OutTrack:PProcTrack);
begin
  if OutTrack=nil then exit;
  if AProcAddress=nil then
  AProcAddress:=  ReturnAddress;
  Finalize(OutTrack^);
  ResetMemory(OutTrack^, SizeOf(OutTrack^));
  LocationInfo(OutTrack,AProcAddress);
end;
class function AmDebug.ProcName(IsNeedUnitName:boolean=true;AProcAddress:Pointer=nil):string;
var OutTrack:TProcTrack;
begin
  Result:='';
  if AProcAddress=nil then
  AProcAddress:= ReturnAddress;

  LocationInfo(@OutTrack,AProcAddress);
  if OutTrack.Result then
  begin
     if IsNeedUnitName and (OutTrack.UnitName<>'') then
     Result:=OutTrack.UnitName+'.'+OutTrack.ProcedureName
     else
     Result:=OutTrack.ProcedureName
  end;
end;
class function AmDebug.CurrentProcName(IsNeedUnitName:boolean=true):string;
begin
  Result:=ProcName(IsNeedUnitName,ReturnAddress);
end;
class function AmDebug.CurrentStackTracing():string;
var Stack: JclDebug.TJclStackInfoList;
    L: TStringList;
begin
       Stack := JclDebug.JclCreateStackList(False, 3, ReturnAddress);
      try
        L := TStringList.Create;
        try
          Stack.AddToStrings(L, True, True, True, True);
          Result:= L.Text;
        finally
          FreeAndNil(L);
        end;
      finally
        FreeAndNil(Stack);
      end;
end;


class function AmDebug.CurrentThreadId:Cardinal;
begin
Result:= AmGetIdPot;
end;
class function AmDebug.IsMainThread:boolean;
begin
  Result:=AmIsMainPot;
end;
class function AmDebug.MainThreadId:Cardinal;
begin
 Result:= AmGetIdMainPot;
end;

   {
class operator TBoolTriHelper.Implicit(const Value: Boolean): TBoolTri;
begin
  if Value then
    Self := bTrue
  else
    Self := bFalse;
end;

class operator TBoolTriHelper.Implicit(const Value: TBoolTriEnum): TBoolTri;
begin
  Result.Value := Value;
end;

class operator TBoolTriHelper.Implicit(const Value: TBoolTri): TBoolTriEnum;
begin
  Result := Value.Value;
end;


class operator TBoolTri.Equal(const lhs, rhs: TBoolTri): Boolean;
begin
  Result := lhs.Value=rhs.Value;
end;

class operator TBoolTri.LogicalOr(const A, B: TBoolTri): TBoolTri;
begin
  if      (A.Value=bTrue)   or (B.Value=bTrue)  then   Result := bTrue
  else if (A.Value=bFalse) and (B.Value=bFalse) then   Result := bFalse
  else                                                   Result := bNot;
end;
class operator TBoolTri.LogicalAnd(const A, B: TBoolTri): TBoolTri;
begin
  if      (A.Value=bTrue)  and (B.Value=bTrue)  then   Result := bTrue
  else if (A.Value=bFalse) and (B.Value=bFalse) then   Result := bFalse
  else                                                   Result := bNot;
end;
  }
function TBoolTriHelper.ToString: string;
begin
  case Self of
  bFalse:
    Result := 'False';
  bTrue:
    Result := 'True';
  bNot:
    Result := 'Not';
  end;
end;
procedure TBoolTriHelper.SetValue(S:string);
begin
   if LowerCase(S)='true' then self:=bTrue
   else if LowerCase(S)='false' then self:=bFalse
   else if LowerCase(S)='btrue' then self:=bTrue
   else if LowerCase(S)='bfalse' then self:=bFalse
   else if LowerCase(S)='0' then self:=bFalse
   else if LowerCase(S)='-1' then self:=bTrue
   else if LowerCase(S)='1' then self:=bTrue

   else                          self:=bNot;
   
end;
procedure TBoolTriHelper.SetValue(S:Char);
begin
  case S of
       '0': self:=bFalse ;
       '1': self:=bTrue;
       else self:=bNot;
  end;
end;
procedure TBoolTriHelper.SetValue(S:integer);
begin
   SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:int64);
begin
 SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:TDateTime);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:Double);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:Single);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:Real);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:SmallInt);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:Word);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:Byte);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:Cardinal);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:UInt64);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:ShortInt);
begin
SetValue(Extended(S));
end;
procedure TBoolTriHelper.SetValue(S:Extended);
begin
  if S=0 then
   self:=bFalse
  else if (s = -1) or  (s =1)  then
   self:=bTrue
  else self:=bNot;


end;
procedure TBoolTriHelper.SetValue(S:Boolean);
begin
  if S then self:=bTrue
  else      self:=bFalse ;
end;


function TBoolTriHelper.ToBool(ResultDefIfValue_bNot:Boolean=False):Boolean;
begin
 Result := False;
  case self of
  bFalse:
    Result := False;
  bTrue:
    Result := True;
  bNot:
    Result := ResultDefIfValue_bNot;
  end;
end;
function TBoolTriHelper.DefFalse:Boolean;
begin
 Result := ToBool(False);
end;

function TBoolTriHelper.DefTrue:Boolean;
begin
 Result := ToBool(True);
end;
function TBoolTriHelper.ToInt:integer;
begin
 Result:= ToBool(false).ToInteger;
end;
function TBoolTriHelper.IsValid:boolean;
begin
 Result:= not (self = bNot);
end;

procedure TAmIntBHelper.Init;
begin
self:=  MinValue;
end;
function TAmIntBHelper.I;
begin
 Result:=Integer(self);
end;
procedure TAmIntB64Helper.Init;
begin
self:=  MinValue;
end;
function TAmIntB64Helper.I;
begin
 Result:=Int64(self);
end;



procedure TAmStringHelper.Clear;
begin
 self:='';
end;
procedure TAmStringHelper.Apped(s:string;denlim:string);
begin
  if length(self)<=0 then
  self:=s
  else
  self:=  self +denlim+s;
end;

function TAmStringHelper.IsSuch(s:string;denlim:string):boolean;
begin
  Result:= IsDublValue(s,denlim);
end;
function TAmStringHelper.IsDublValue(s:string;denlim:string):boolean;
begin
     Result:=true;
     if length(self)<=0 then
     begin
       Result:=false;
     end
     else if pos(denlim,self)=0 then
     begin
       if s<>self then
       Result:=false;
     end
     else
     begin
        if ( pos(s+denlim,self)=0 ) and ( pos(denlim+s,self)=0 ) then
          Result:=false;
     end;
end;
procedure TAmStringHelper.AppedNotDublPos(s:string;denlim:string);
begin
  if not IsDublValue(s,denlim) then
  Apped(s,denlim);
end;
          { TDateTimeHelper }
function  TDateTimeHelper.IsValid:boolean;
begin

 Result:=(Real(self)>1) and  (Real(self)< Integer.MaxValue);
end;
function  TDateTimeHelper.IsValidStr(S:string):boolean;
var V: TDateTime;
begin
  Result:=TryStrToDateTime(S,V);
end;
function TDateTimeHelper.SetDateElseNow(s:string):TDateTime;
begin
  if not TryStrToDateTime(s,Self) then
  Self:= now;
  Result:=Self;
end;
procedure TDateTimeHelper.SetDate(s:string);
begin
 if not TryStrToDateTime(s,Self)then
 self:=0;
end;
function TDateTimeHelper.IncStepTime(stepHour,stepMin:integer;hour1,Min1:integer;Var Hour2:Integer;Var Min2:integer):boolean;
  var D:TDatetime;
  he,me,se,mse:word;
begin
    Result:= TryEncodeTime(hour1, Min1, 0, 0, D);
    Hour2:=0;
    Min2:=0;
    if Result then
    begin
        D:=IncMinute(D, stepMin + (stepHour * MinsPerHour));
        DecodeTime(D,he,me,se,mse);
        Hour2:= he;
        Min2:= me;
    end;
end;
function  TDateTimeHelper.DataTimeToString:string;
begin
     Result:=AmStr(TDateTime(Self),true);
end;
function  TDateTimeHelper.DataTimeToStringDef():string;
begin
  Result:= DataTimeToString(true,true,true,true,true,true,true,false);
end;
class function  TDateTimeHelper.DataTimeToStringCL(D:TDateTime):string;
begin
  Result:= D.DataTimeToStringDef;
end;
function   TDateTimeHelper.DataToString(d,m,y,yIs2:boolean):string;
var f:string;
begin
    if d then f:= 'dd';
    if m and (f<>'') then f:= f+'.mm'
    else                  f:= 'mm';


    if      y and (f<>'') and     yIs2 then f:= f+'.yy'
    else if y and (f<>'') and not yIs2 then f:= f+'.yyyy'
    else if y             and     yIs2 then f:= 'yy'
    else if y             and not yIs2 then f:= 'yyyy';
    Result:=AmStr(TDateTime(Self),false,f);
end;
function   TDateTimeHelper.TimeToStrHM(separator:string):string;
begin
   if separator='' then separator:=':';
   
   Result:=AmStr(TDateTime(Self),false,'hh'+separator+'nn');
end;
function   TDateTimeHelper.TimeToString(h,m,s,z:boolean):string;
var f:string;
begin
    if h then f:= 'hh';

    if m and (f<>'') then f:= f+'.nn'
    else if m then     f:= 'nn';

    if s and (f<>'') then f:= f+'.ss'
    else if s then        f:= 'ss';

    if z and (f<>'') then f:= f+'.zzz'
    else  if z then       f:= 'zzz';
    Result:=AmStr(TDateTime(Self),false,f);
end;
function  TDateTimeHelper.DataTimeToString(d,m,y,yIs2,h,n,s,z:boolean):string;
var f:string;
 function LocFun(uper:boolean;Input,ValueTrue:string;denlimiter:string):string;
// var S:string;
 begin
    Result:=Input;
    if uper then
    begin
     if (Result<>'') then
      Result:= Result+denlimiter+ValueTrue
     else Result:= ValueTrue;
    end
 end;

 function LocFunYYYY(uper,yIs2:boolean;Input:string):string;
 begin
     Result:=   Input;
     if y then
     begin
        if yIs2 then Result:=LocFun(m,Result,'yy','.')
        else         Result:=LocFun(m,Result,'yyyy','.');
     end;
 end;
begin
    f:='';
    f:=LocFun(d,f,'dd','.');
    f:=LocFun(m,f,'mm','.');
    f:=LocFunYYYY(y,yIs2,f);


    if True in [h,n,s,z] then
    begin
          if f<>'' then
          f:= f+'" "';
          f:=LocFun(h,f,'hh','');
          f:=LocFun(n,f,'nn',':');
          f:=LocFun(s,f,'ss',':');
          f:=LocFun(z,f,'zzz',':');
    end;

    if f='' then
    Result:=AmStr(TDateTime(Self),true)
    else
    Result:=AmStr(TDateTime(Self),false,f);


end;
function  TDateTimeHelper.IsValidUnix:boolean;
var
d:TDateTime;
begin
  if IsValid then
  begin
  d.SetDate('01.01.1970 3:00:00');
  Result:= Self > d
  end
  else Result:=false;
end;
function TDateTimeHelper.GetUnix:Int64;
begin
 Result:= AmUnix.DateTime_To_Unix(self);
end;
procedure TDateTimeHelper.SetUnix(V:Int64);
begin
   Self:=AmUnix.Unix_To_DateTimeUTC(V);
end;
class function TDateTimeHelper.TimeInRange(t1,t2,ANow:TTime):boolean;
begin
    if T1 < T2 then
     Result:= (T1 <= ANow) and (T2 > ANow)
    else if T1 > T2 then
     Result:= (ANow >= T1) or (T2 > ANow)
    else
      Result := true;
end;

    {TAmTextId}
procedure TAmTextId.SetValue(Value:string);
begin
    AmRecordHlp.RecFinal(self);
    Value:=trim(Value);
    if (Value<>'') and (pos(':',Value)<>0) then
    begin
       Id:= AmInt64(Value.Split([':'])[0],Int64.MinValue);
       Name:= Value.Split([':'])[1];
       IsGood:= Id<>Int64.MinValue;
    end;
end;
function TAmTextId.SetValue(AId:Int64;AName:string):PAmTextId;
begin
   IsGood:=true;
   Id:= AId;
   Name:= AName;
   Result:=@Self;
end;
function TAmTextId.GetValue:string;
begin
   if IsGood then
   Result:=  Id.ToString+':'+Name;
end;

////////
    {TAmCaseRec}
procedure TAmCaseRec.New<T>;
begin
 Clear;
 CaseInterface:= TAmCaseObj<T>.New;
 //CaseInterface.SetInstanceInterface(@CaseInterface);
end;
function TAmCaseRec.IsAssignedInterface:boolean;
begin
 Result:= Assigned(CaseInterface);
end;
procedure TAmCaseRec.Clear;
begin
CaseInterface:=nil;
end;
function TAmCaseRec.GetP<T>:Pointer;
begin
  Result:= TAmCaseObj<T>.GetPointer(CaseInterface);
end;
function TAmCaseRec.GetT<T>:T;
begin
 Result:=TAmCaseObj<T>.GetT(CaseInterface);
end;
procedure TAmCaseRec.SetT<T>(Value:T);
begin
  TAmCaseObj<T>.SetT(CaseInterface,Value);
end;
procedure TAmCaseRec.SetP<T>(Value:Pointer);
begin
  // Value это ^T  иначе может быть куча ошибок и не сразу а через сотни строк кода
  TAmCaseObj<T>.SetP(CaseInterface,TAmCaseObj<T>.P(Value));
end;
function TAmCaseRec.GetValuePointer:Pointer;
begin
  if CaseInterface=nil then
  raise Exception.Create('Error.TAmCaseRec.GetValuePointer CaseInterface=nil');
  Result:=CaseInterface.GetValuePointer;
end;
function TAmCaseRec.GetOnDestroy:TNotifyEvent;
begin
  if CaseInterface=nil then
  raise Exception.Create('Error.TAmCaseRec.GetOnDestroy CaseInterface=nil');
  Result:=CaseInterface.GetOnDestroy;
end;
procedure TAmCaseRec.SetOnDestroy(Proc:TNotifyEvent);
begin
  if CaseInterface=nil then
  raise Exception.Create('Error.TAmCaseRec.SetOnDestroy CaseInterface=nil');
  CaseInterface.SetOnDestroy(Proc);
end;
function TAmCaseRec.GetOnDestroyProc:TAmProcDestroyEvent;
begin
  if CaseInterface=nil then
  raise Exception.Create('Error.TAmCaseRec.GetOnDestroyProc CaseInterface=nil');
  Result:=CaseInterface.GetOnDestroyProc;
end;
procedure TAmCaseRec.SetOnDestroyProc(Proc:TAmProcDestroyEvent);
begin
  if CaseInterface=nil then
  raise Exception.Create('Error.TAmCaseRec.SetOnDestroyProc CaseInterface=nil');
  CaseInterface.SetOnDestroyProc(Proc);
end;
////////
    {TAmCaseObj<T>}

class function TAmCaseObj<T>.New:I;
begin
   Result:=O.Create;
end;
class procedure TAmCaseObj<T>.IsError(Source:IAmInterface;place:string);
begin
  if not IsInterface(Source) then
  CreateError(Source,place);
end;
class function TAmCaseObj<T>.IsInterface(Source:IAmInterface):boolean;
begin
  Result:= Assigned(Source) and (TInterfacedObject(Source) is O);
end;
class procedure TAmCaseObj<T>.CreateError(Source:IAmInterface;place:string);
var sNameType,sNameTypeClassGet,sNameTypeClass:string;
    Typ:PTypeInfo;
begin
    Typ:=TypeInfo(T);
    if Assigned(Typ) then
    sNameType:= string(Typ.Name)
    else  sNameType:='T';
    place:= 'Error.TAmCaseObj<'+sNameType+'>.'+place;

    if Assigned(Source) then
          sNameTypeClassGet:=TInterfacedObject(Source).ClassName
    else
         sNameTypeClassGet:='nil';

    raise Exception.Create(place+' Несовпадение  типов данных! ['+O.ClassName +'],['+sNameTypeClassGet+']');
end;
class function TAmCaseObj<T>.GetT(Source:IAmInterface):T;
begin
   IsError(Source,'GetT');
   Result:=I(Source).GetT;
end;
class function TAmCaseObj<T>.GetP(Source:IAmInterface):P;
begin
   IsError(Source,'GetP');
   Result:=I(Source).GetP;
end;
class function TAmCaseObj<T>.GetPointer(Source:IAmInterface):Pointer;
begin
   IsError(Source,'GetP');
   Result:=I(Source).GetValuePointer;
end;
class procedure TAmCaseObj<T>.SetT(Source:IAmInterface;Value:T);
begin
   IsError(Source,'SetT');
   I(Source).SetT(Value);
end;
class procedure TAmCaseObj<T>.SetP(Source:IAmInterface;Value:P);
begin
   IsError(Source,'SetP');
   I(Source).SetP(Value);
end;
class procedure TAmCaseObj<T>.GetVar(Source:IAmInterface;var Value:T);
begin
   IsError(Source,'GetVar');
   I(Source).GetVar(Value);
end;
class function TAmCaseObj<T>.GetOnDestroy(Source:IAmInterface):TNotifyEvent;
begin
   IsError(Source,'GetOnDestroy');
   Result:= I(Source).GetOnDestroy;
end;
class procedure TAmCaseObj<T>.SetOnDestroy(Source:IAmInterface;Proc:TNotifyEvent);
begin
   IsError(Source,'SetOnDestroy');
    I(Source).SetOnDestroy(Proc);
end;


constructor TAmCaseObj<T>.O.Create;
begin
  inherited;
  OnDestroy:=nil;
  OnDestroyProc:=nil;
  InstanceInterface:=nil;
end;
destructor TAmCaseObj<T>.O.Destroy;
begin
   if Assigned(InstanceInterface) then
   InstanceInterface^:=nil;
   if Assigned(OnDestroy) then
    OnDestroy(self);
  if Assigned(OnDestroyProc) then
  OnDestroyProc(Self,GetValuePointer);
  OnDestroy:=nil;
  OnDestroyProc:=nil;
   inherited;
end;
procedure TAmCaseObj<T>.O.SetInstanceInterface(Value:PIAmCaseObjBase);
begin
 InstanceInterface:= Value;
end;
function TAmCaseObj<T>.O.GetT:T;
begin
 Result:= Value;
end;
function TAmCaseObj<T>.O.GetP:P;
begin
 Result:= @Value;
end;
function TAmCaseObj<T>.O.GetValuePointer:Pointer;
begin
 Result:= @Value;
end;
procedure TAmCaseObj<T>.O.SetT(AValue:T);
begin
 Value:= AValue;
end;
procedure TAmCaseObj<T>.O.SetP(AValue:P);
begin
 Value:= AValue^;
end;
procedure TAmCaseObj<T>.O.GetVar(var AValue:T);
begin
  AValue:= Value;
end;
function  TAmCaseObj<T>.O.GetOnDestroy:TNotifyEvent;
begin
  Result:= OnDestroy;
end;
procedure TAmCaseObj<T>.O.SetOnDestroy(AOnDestroy:TNotifyEvent);
begin
 OnDestroy:= AOnDestroy;
end;
function   TAmCaseObj<T>.O.GetOnDestroyProc:TAmProcDestroyEvent;
begin
 Result:= OnDestroyProc;
end;
Procedure  TAmCaseObj<T>.O.SetOnDestroyProc(Proc:TAmProcDestroyEvent);
begin
OnDestroyProc:= Proc;
end;


     


                 {AmClass}
class function AmClass.IsClassRef(A:TObject; B:TClass):boolean;
var
  ClassRef: TClass;
begin
  Result:=false;
  if A=nil then exit;
  
  ClassRef := A.ClassType;
  while ClassRef <> nil do
  begin
     Result:=  ClassRef =  B;
    if Result then break;
    ClassRef := ClassRef.ClassParent;
  end;
end;
class procedure AmClass.ListParent(L:TStrings;A:TObject);
var
  ClassRef: TClass;
begin
   L.clear;
  if A=nil then exit;

  ClassRef := A.ClassType;
  while ClassRef <> nil do
  begin
    L.add(ClassRef.ClassName);
    ClassRef := ClassRef.ClassParent;
  end;

end;
class function AmClass.IsClass(A:TObject; B:TClass):boolean;
begin
  Result:=false;
  if A=nil then exit;
  Result := A is B;
end;
class procedure AmClass.VirtMetod<T1,T2>(X1:T1;Proc:AmVirtual<T1,T2>.TProc);
begin
    AmVirtual<T1,T2>.G(X1,Proc);
end;

class procedure AmVirtual<T1,T2>.G(X1:T1;Proc:TProc);
 type
 PClass = ^TClass;
 var
 ClassOld: TClass;
begin
 ClassOld := PClass(X1)^;
 PClass(X1)^ := T2;
 try
   proc(X1 as T2);
 finally
  PClass(X1)^ := ClassOld;
 end;
end;


Class function AmInternet.Connected:boolean;
var
  lpdwConnectionTypes: DWORD;
begin
  lpdwConnectionTypes := INTERNET_CONNECTION_MODEM +
                         INTERNET_CONNECTION_LAN +
                         INTERNET_CONNECTION_PROXY;
  { Returns TRUE if there is an active modem or a LAN Internet connection,
    or FALSE if there is no Internet connection, or if all possible Internet
    connections are not currently active.}
  Result := InternetGetConnectedState(@lpdwConnectionTypes, 0);

end;

Class function AmCompare.IsCompare(IsASC:boolean;Input,DefR:real):integer;
begin

  if Input < DefR then
    Result := -1
  else if  Input > DefR then
    Result := 1
  else
   Result := 0;

  if (Result<>0) and not IsASC then
  Result:= -Result;


end;
Class function AmCompare.IsRangeProcent(Input,DefR,Procent:real):boolean;
var AMin,AMax:real;
begin
 if Procent<=0 then
 begin
     Result:= Input = DefR;
 end
 else
 begin
 
  AMin:= (100-Procent)* DefR /100 ;
  AMax:= (100+Procent)* DefR /100 ;
  Result:= (Input<AMax) and (Input>AMin);
 end;
end;
Class function AmCompare.IsCompareProcent(IsASC:boolean;Input,DefR,Procent:real):integer;
begin
  if  IsRangeProcent(Input,DefR,Procent)  then
  Result:=0
  else
  Result:= IsCompare(IsASC,Input,DefR);
end;



                       {TAmApplicationGlobalEvent}
Constructor TAmApplicationGlobalEvent.Create();
begin
   inherited;
   F:=  TList<TMessageEvent>.Create;
   Application.OnMessage:=AppMessage;
end;
Destructor TAmApplicationGlobalEvent.Destroy;
begin
   F.clear;
   FreeAndNil(F);
   inherited
end;
procedure TAmApplicationGlobalEvent.OnMessageApp(Proc:TMessageEvent);
begin
   F.Add(Proc);
end;
procedure TAmApplicationGlobalEvent.AppMessage (var Msg: TMsg; var Handled: Boolean);
var
  I: Integer;
  Proc:TMessageEvent;
begin
    for I := 0 to F.Count-1 do
    begin
      Proc:= F[i];
      if Assigned(Proc) then
      Proc(Msg,Handled);
    end;
end;
Class function AmUnixRound.FloorToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime;
begin
   if 0=TheRoundStep  then FloorToNearest:=TheDateTime
   else  Result:=Floor(TheDateTime/TheRoundStep)*TheRoundStep;
end;
Class Function AmUnixRound.DtToFloorMinutes(Data:TDatetime;minutes:integer):TDateTime;
var tim: TDatetime;
begin
  tim:=   minutes / MinsPerDay;
   Result:= FloorToNearest(Data,tim);
end;
Class Function AmUnixRound.DtToWeekBegin(Data:TDatetime):TDateTime;
var
ADayOfWeek:word;
begin
   ADayOfWeek:=DayOfTheWeek(Data);
   Result:=incDay(Data,-(ADayOfWeek-1));
   Result:=DtToFloorMinutes(Result,60*24);

end;
Class Function AmUnixRound.DtToWeekNextBegin(Data:TDatetime):TDateTime;
begin
    Result:= DtToWeekBegin(Data);
    Result:=IncWeek(Result,1);
end;
Class Function AmUnixRound.DtToMothBegin(Data:TDatetime):TDateTime;
var
ADayOf:word;
begin
   ADayOf:=DayOf(Data);
   Result:=incDay(Data,-(ADayOf-1));
   Result:=DtToFloorMinutes(Result,60*24);

end;
Class Function AmUnixRound.DtToMothNextBegin(Data:TDatetime):TDateTime;
begin
   Result:=DtToMothBegin(Data);
   Result:=IncMonth(Result,1);
end;

Class Function AmColorConvert2.GetH(val:TColor):integer;
var H,L,S,R,G,B:integer;
begin
    ColorToRGB(val,R,G,B);
    RGBtoHLS(R,G,B,H,L,S);
    Result:=H;

end;
Class Function AmColorConvert2.GetL(val:TColor):integer;
var H,L,S,R,G,B:integer;
begin
    ColorToRGB(val,R,G,B);
    RGBtoHLS(R,G,B,H,L,S);
    Result:=L;

end;
Class Function AmColorConvert2.GetS(val:TColor):integer;
var H,L,S,R,G,B:integer;
begin
    ColorToRGB(val,R,G,B);
    RGBtoHLS(R,G,B,H,L,S);
    Result:=S;

end;
Class Function AmColorConvert2.SetH(val:TColor;xH:integer):TColor;
var H,L,S,R,G,B:integer;
begin
    xH:= min(xH,HLSMAX);
    ColorToRGB(val,R,G,B);
    RGBtoHLS(R,G,B,H,L,S);
    H:=xH;
    HLStoRGB(H,L,S,R,G,B);
    Result:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert2.SetL(val:TColor;xL:integer):TColor;
var H,L,S,R,G,B:integer;
begin
    xL:= min(xL,HLSMAX);
    ColorToRGB(val,R,G,B);
    RGBtoHLS(R,G,B,H,L,S);
    L:=xL;
    HLStoRGB(H,L,S,R,G,B);
    Result:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert2.SetS(val:TColor;xS:integer):TColor;
var H,L,S,R,G,B:integer;
begin
    xS:= min(xS,HLSMAX);
    ColorToRGB(val,R,G,B);
    RGBtoHLS(R,G,B,H,L,S);
    S:=xS;
    HLStoRGB(H,L,S,R,G,B);
    Result:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert2.IncL(val:TColor;Value:integer):TColor;
var H,S,L:integer;
begin
   ColorToHLS(val,H,L,S);
   L:= L+Value;
   Result:=HLSToColor(H,L,S);
end;
Class function AmColorConvert2.DeltaL(val:TColor;xDelta,border:byte):TColor;
var H,S,L:integer;
begin
   ColorToHLS(val,H,L,S);
   if L<border then  L:= L+xDelta
   else           L:= L -xDelta;
   Result:=HLSToColor(H,L,S);
end;
Class Function AmColorConvert2.DeltaH(val:TColor;xDelta,border:byte):TColor;
var H,S,L:integer;
begin
   ColorToHLS(val,H,L,S);
   if H<border then  H:= byte(H+xDelta)
   else           H:= byte(H -xDelta);
   Result:=HLSToColor(H,L,S);
end;
Class Function AmColorConvert2.DeltaS(val:TColor;xDelta,border:byte):TColor;
var H,S,L:integer;
begin
   ColorToHLS(val,H,L,S);
   if S<border then  S:= byte(S+xDelta)
   else           S:= byte(S -xDelta);
   Result:=HLSToColor(H,L,S);
end;
Class Function AmColorConvert2.DeltaLHS(val:TColor;xDelta,border:byte):TColor;
var H,S,L:integer;
begin
   ColorToHLS(val,H,L,S);
   if S<border then  S:= byte(S+xDelta)
   else           S:= byte(S -xDelta);

   if H<border then  H:= byte(H+xDelta)
   else           H:= byte(H -xDelta);

   if L<border then  L:= byte(L+xDelta)
   else           L:= byte(L -xDelta);   
   Result:=HLSToColor(H,L,S);
end;

Class Function AmColorConvert2.ColorToRGB(val:TColor;var R:integer;Var G:integer; var B:integer):boolean;
var R1,G1,B1:Byte;
begin
   AmColorConvert.ColorToRGB(val,R1,G1,B1);
   R:=R1;
   G:=G1;
   B:=B1;
   Result:=true;
end;
Class Function AmColorConvert2.RGBToColor(R,G,B:integer):TColor;
begin
   Result:=AmColorConvert.RGBToColor(R,G,B)
end;
Class Function AmColorConvert2.ColorRamdom(Lmin:integer=20;Lmax:integer=220;Smin:integer=20;Smax:integer=220):TColor;
begin
     Lmin:=  math.RandomRange(Lmin,Lmax);
     Smin:=  math.RandomRange(Smin,Smax);
     Result:=HLSToColor(math.RandomRange(0,HLSMAX),Lmin,Smin);
end;
Class Function AmColorConvert2.HLSToColor(H,L,S:integer):TColor;
var R,G,B:integer;
begin
    HLStoRGB(H,L,S,R,G,B);
    Result:=RGBToColor(R,G,B);
end;
Class procedure AmColorConvert2.ColorToHLS(val:TColor;var H:integer;var L:integer;var S:integer);
var R,G,B:integer;
begin
    ColorToRGB(val,R,G,B);
    RGBtoHLS(R,G,B,H,L,S);
end;
Class procedure AmColorConvert2.RGBtoHLS(R,G,B:integer;var H:integer;var L:integer;var S:integer );
Var
cMax,cMin : integer;
Rdelta,Gdelta,Bdelta : single;
Begin
    cMax := max( max(R,G), B);
    cMin := min( min(R,G), B);
    L := round( ( ((cMax+cMin)*HLSMAX) + RGBMAX )/(2*RGBMAX) );
    if (cMax = cMin) then
    begin
      S := 0; H := UNDEFINED;
    end
    else
    begin
      if (L <= (HLSMAX/2)) then
      S := round( ( ((cMax-cMin)*HLSMAX) + ((cMax+cMin)/2) ) / (cMax+cMin) )
      else
      S := round( ( ((cMax-cMin)*HLSMAX) + ((2*RGBMAX-cMax-cMin)/2) )
      / (2*RGBMAX-cMax-cMin) );

      Rdelta := ( ((cMax-R)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
      Gdelta := ( ((cMax-G)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);
      Bdelta := ( ((cMax-B)*(HLSMAX/6)) + ((cMax-cMin)/2) ) / (cMax-cMin);


      if (R = cMax) then      H := round(Bdelta - Gdelta)
      else if (G = cMax) then H := round( (HLSMAX/3) + Rdelta - Bdelta)
      else                    H := round( ((2*HLSMAX)/3) + Gdelta - Rdelta );

      if (H < 0) then H:=H + HLSMAX;
      if (H > HLSMAX) then H:= H - HLSMAX;
    end;
    if S<0 then S:=0; if S>HLSMAX then S:=HLSMAX;
    if L<0 then L:=0; if L>HLSMAX then L:=HLSMAX;
end;

Class procedure AmColorConvert2.HLStoRGB(H,L,S:integer;var R:integer;var G:integer;var B:integer );
Var
Magic1,Magic2 : single;
      function HueToRGB(n1,n2,hue : single) : single;
      begin
              if (hue < 0) then      hue := hue+HLSMAX;
              if (hue > HLSMAX) then hue:=hue -HLSMAX;

              if      (hue < (HLSMAX/6)) then      result:= ( n1 + (((n2-n1)*hue+(HLSMAX/12))/(HLSMAX/6)) )
              else if (hue < (HLSMAX/2)) then      result:=n2
              else if (hue < ((HLSMAX*2)/3)) then  result:= ( n1 + (((n2-n1)*(((HLSMAX*2)/3)-hue)+(HLSMAX/12))/(HLSMAX/6)))
              else                                 result:= ( n1 );
      end;
begin
      if (S = 0) then
      begin
          B:=round( (L*RGBMAX)/HLSMAX ); R:=B; G:=B;
      end
      else
      begin
          if (L <= (HLSMAX/2)) then Magic2 := (L*(HLSMAX + S) + (HLSMAX/2))/HLSMAX
          else                      Magic2 := L + S - ((L*S)  + (HLSMAX/2))/HLSMAX;

          Magic1 := 2*L-Magic2;

          R := round( (HueToRGB(Magic1,Magic2,H+(HLSMAX/3))*RGBMAX + (HLSMAX/2))/HLSMAX );
          G := round( (HueToRGB(Magic1,Magic2,H)*RGBMAX + (HLSMAX/2)) / HLSMAX );
          B := round( (HueToRGB(Magic1,Magic2,H-(HLSMAX/3))*RGBMAX + (HLSMAX/2))/HLSMAX );
      end;

      if R<0 then R:=0; if R>RGBMAX then R:=RGBMAX;
      if G<0 then G:=0; if G>RGBMAX then G:=RGBMAX;
      if B<0 then B:=0; if B>RGBMAX then B:=RGBMAX;
end;


Class Function AmColorConvert.ColorToRGB(val:TColor;var R:Byte;Var G:Byte; var B:Byte):boolean;
begin
  if val < 0 then
  val := GetSysColor(val and $000000FF);
  r:=GetRValue(val);
  g:=GetGValue(val);
  b:=GetBValue(val);
  Result:=true;
end;
Class Function AmColorConvert.RGBToColor(R,G,B:Byte):TColor;
begin
   Result:= RGB(R,G,B);
end;
Class Function AmColorConvert.RGBToYCbCr(R,G,B:Byte;var Y:byte;var Cb:byte;var Cr:byte ):boolean;
begin
  Y := round( 0.299  * R + 0.587  * G + 0.114 * B); // Канал яркости
 // Y :=round( 0.2126* R + 0.7152* G + 0.0722* B);
  Cb := round(-0.1687 * R - 0.3313 * G + 0.5   * B + 128.0);
  Cr := round( 0.5    * R - 0.4187 * G - 0.0813* B + 128.0);
  Result:=true;
end;
Class Function AmColorConvert.YCbCrToRGB(Y,Cb,Cr:Byte;var R:byte;var G:byte;var B:byte ):boolean;
var v: Integer;
begin


    v := round(Y + 1.772 * (Cb - 128.0));
    if v > 255 then v := 255 else if v < 0 then v := 0;
    B := v;

    v := round(Y - 0.34414 * (Cb - 128.0) - 0.71414 * (Cr - 128.0));
    if v > 255 then v := 255 else if v < 0 then v := 0;
    G := v;

    v := round(Y + 1.402 * (Cr - 128.0));
    if v > 255 then v := 255 else if v < 0 then v := 0;
    R := v;
    Result:=true;
end;
Class Function AmColorConvert.YCbCrToRGB2(Y,Cb,Cr:Byte;var R:byte;var G:byte;var B:byte ):boolean;
begin
  // Y := Trunc( Sqrt(Sqr(0.299  * R) + Sqr(0.587  * G) + Sqr(0.114 * B)));

//Y := Trunc( 0.299  * R + 0.587  * G + 0.114 * B); // Канал яркости
//Cb := Trunc(-0.1687 * R - 0.3313 * G + 0.5   * B + 128.0);
//Cr := Trunc( 0.5    * R - 0.4187 * G - 0.0813* B + 128.0);
  Result:=true;

 // Y  := (R *  0.29900) + (G *  0.58700) + (B *  0.11400);

 // (R *  0.29900):=  (G *  0.58700) + (B *  0.11400) - Y;





  //Cb = R * -0.16874 + G * -0.33126 + B *  0.50000 + 128;
 // Cr = R *  0.50000 + G * -0.41869 + B * -0.08131 + 128;
end;
Class Function AmColorConvert.GetY(val:TColor):byte;
var Y,Cb,Cr,R,G,B:byte;
begin
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);
    Result:=Y;
end;
Class Function AmColorConvert.GetCb(val:TColor):byte;
var Y,Cb,Cr,R,G,B:byte;
begin
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);
    Result:=Cb;

end;
Class Function AmColorConvert.GetCr(val:TColor):byte;
var Y,Cb,Cr,R,G,B:byte;
begin
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);
    Result:=Cr;
end;
Class Function AmColorConvert.SetY(val:TColor;aY:byte):TColor;
var Y,Cb,Cr,R,G,B:byte;
begin
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);
    Y:= aY;
    YCbCrToRGB(Y,Cb,Cr,R,G,B);
    Result:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert.SetCb(val:TColor;aCb:byte):TColor;
var Y,Cb,Cr,R,G,B:byte;
begin
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);
    Cb:= aCb;
    YCbCrToRGB(Y,Cb,Cr,R,G,B);
    Result:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert.SetCr(val:TColor;aCr:byte):TColor;
var Y,Cb,Cr,R,G,B:byte;
begin
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);
    Cr:= aCr;
    YCbCrToRGB(Y,Cb,Cr,R,G,B);
    Result:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert.SetY_delta(var val:TColor;aYDelta:byte):boolean;
var Y,Cb,Cr,R,G,B,bt:byte;
v:integer;
begin
    Result:=true;
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);

    v:=Y+aYDelta;
    if v<0 then
    begin
       bt:=0;
       Result:=false;
    end
    else if v>255 then
    begin
     bt:=255;
     Result:=false;
    end
    else bt:=byte(v);

    Y:=bt;

    YCbCrToRGB(Y,Cb,Cr,R,G,B);
    val:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert.SetCb_delta(var val:TColor;aCbDelta:byte):boolean;
var Y,Cb,Cr,R,G,B,bt:byte;
v:integer;
begin
    Result:=true;
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);

    v:=Cb+aCbDelta;
    if v<0 then
    begin
       bt:=0;
       Result:=false;
    end
    else if v>255 then
    begin
     bt:=255;
     Result:=false;
    end
    else bt:=byte(v);

    Cb:=bt;

    YCbCrToRGB(Y,Cb,Cr,R,G,B);
    val:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert.SetCr_delta(var val:TColor;aCrDelta:byte):boolean;
var Y,Cb,Cr,R,G,B,bt:byte;
v:integer;
begin
    Result:=true;
    ColorToRGB(val,R,G,B);
    RGBToYCbCr(R,G,B,Y,Cb,Cr);

    v:=Cr+aCrDelta;
    if v<0 then
    begin
       bt:=0;
       Result:=false;
    end
    else if v>255 then
    begin
     bt:=255;
     Result:=false;
    end
    else bt:=byte(v);

    Cr:=bt;

    YCbCrToRGB(Y,Cb,Cr,R,G,B);
    val:=RGBToColor(R,G,B);

end;
Class Function AmColorConvert.ToStringRGB(val:TColor):string;
var Y,Cb,Cr,R,G,B:byte;
begin
       ColorToRGB(val,R,G,B);
       RGBToYCbCr(R,G,B,Y,Cb,Cr);

        Result:=
       'Y:'+inttostr(Y)+#13#10+
       'Cb:'+inttostr(Cb)+#13#10+
       'Cr:'+inttostr(Cr)+#13#10+

       'R:'+inttostr(R)+#13#10+
       'G:'+inttostr(G)+#13#10+
       'B:'+inttostr(B)+#13#10;
end;

function GetValueYarc(Color:TColor):integer;
begin
Result:= AmColorConvert.GetY(Color);
{
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  Result:=round((0.299*R)+(0.587*G)+(0.114*B));
  }
end;
function SetValueYarc(Color:TColor;val:byte):TColor; //по колору определить яркость if GetValueYarc(mycol)<35 then темный
begin
Result:= AmColorConvert.SetY(Color,val);
end;

Class Function AmConvertTrade.Round8(val:real):real;
begin
   Result:= math.RoundTo(val,-8);
end;
Class Function AmConvertTrade.Str(val:real):string;
begin

end;

class function AmEnumConverter.EnumToInt<T>(const enValue: T): Integer;
begin
   Result := 0;
   Move(enValue, Result, sizeOf(enValue));
end;

class function AmEnumConverter.EnumToString<T>(enValue: T): string;
begin
{
         MetodStr:= AmUsertype.AmRecordHlp.EnumToStr(Metod);
         SObj['data']['Cookies']['metod'].Value:= MetodStr;
}
  Result := GetEnumName(TypeInfo(T), EnumToInt(enValue));
end;

class procedure AmEnumConverter.StringToEnum<T>(strValue: String; var enValue:T);
   var
       Temp:Integer;
       PTemp : pointer;
       C:Integer;
begin
    StringToEnum<T>(strValue,Temp);
    PTemp := @Temp;
    enValue := T(PTemp^);
end;
class procedure AmEnumConverter.StringToEnum<T>(strValue:String; var enValue:Integer);
   var Tipo : PTypeInfo;
begin
    Tipo := TypeInfo(T);
    enValue := GetEnumValue(Tipo, strValue);

{
             MetodStr:=  ObjInput['data']['Cookies']['metod'].Value;
             MetodInt:= AmUsertype.AmRecordHlp.EnumStrToInt<TamBrApiMetodCookies>(MetodStr);
             MetodCount:=Integer(System.High(TamBrApiMetodCookies))+1;
             if (MetodCount>0) and (MetodInt<=MetodCount-1) then
             Metod:= TamBrApiMetodCookies(MetodInt)
             else Metod:=BrApiCookiesNone;
}

end;
class function AmEnumConverter.EnumSetToString<T>(Instance: T): string;
var PTyp:PTypeInfo;
  enumBuffer: TEnumBuffer absolute Instance;
  enumType: PTypeInfo;
  enumData: PTypeData;
  enumDenLimiter:boolean;
  i:integer;
begin
    Result:='';
    PTyp:= TypeInfo(T);
    if (PTyp = nil) or (PTyp.Kind <> tkSet) then
      exit;
    if PTyp.TypeData=nil then  exit;
    if PTyp.TypeData.CompType=nil then  exit;
    enumType := PTyp.TypeData.CompType^;
    if enumType=nil then  exit;
    enumData := enumType.TypeData;
    if enumData=nil then  exit;

    enumDenLimiter:=false;
    for i := enumData.MinValue to enumData.MaxValue do
    if i in enumBuffer then
    begin
     if enumDenLimiter then
     Result:= Result+', ';
     Result:= Result+ GetEnumName(enumType, i);
     enumDenLimiter:=true;
    end;
end;
class procedure AmEnumConverter.StringToEnumSet<T>(Instance:string;var Result:T);
var
  PTyp:PTypeInfo;
  enumBuffer: TEnumBuffer absolute Result;
  enumType: PTypeInfo;
  enumData: PTypeData;
  MinValue, MaxValue: Integer;
begin
    PTyp:= TypeInfo(T);

    if (PTyp = nil) or (PTyp.Kind <> tkSet) then
      exit;

    if PTyp.TypeData=nil then  exit;
    if PTyp.TypeData.CompType=nil then  exit;
    enumType := PTyp.TypeData.CompType^;
    if enumType=nil then  exit;
    enumData := enumType.TypeData;
    if enumData=nil then  exit;

    MinValue := enumData.MinValue and ByteBoundaryMask;
    MaxValue := (enumData.MaxValue + BitsPerByte - 1) and ByteBoundaryMask;
    FillChar(enumBuffer, (MaxValue - MinValue) div BitsPerByte, 0);
    StringToEnumSetInfo(Instance, enumType, enumData, enumBuffer);
    //Value:= T(enumBuffer);

end;
class procedure AmEnumConverter.StringToEnumSetInfo(const Str: string;
                                                   CompInfo: PTypeInfo;
                                                   CompData: PTypeData;
                                                   var Value: TEnumBuffer);
var
Names: TArray<string>;
Element: Integer;
MinElement: Integer;
I: Integer;
begin
    MinElement := CompData.MinValue and ByteBoundaryMask;
    if Length(Str)>0 then
    Names:= Str.Split([',']);
    for I := 0 to length(Names)-1 do
    begin
       Names[i]:= Names[i].Trim;
       Element := GetEnumValue(CompInfo, Names[i]);
       if (Element < 0)
       or (Element < CompData.MinValue)
       or (Element > CompData.MaxValue) then  continue;
       Include(Value, Element - MinElement);
    end;
end;
                 {AmRecordHlp}
class Function AmRecordHlp.SetGetValue_Int(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean;
begin
  Result:= SetGetValue(IsGet,
                                           tkInteger,TypeInfo(Integer)
                    ,XVar,ResultD,ResultS);
end;
class Function AmRecordHlp.SetGetValue_Int64(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean;
begin
  Result:= SetGetValue(IsGet,
                                           tkInt64,TypeInfo(Int64)
                    ,XVar,ResultD,ResultS);
end;
class Function AmRecordHlp.SetGetValue_Real(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean;
begin
  Result:= SetGetValue(IsGet,
                                           tkFloat,TypeInfo(Double)
                    ,XVar,ResultD,ResultS);
end;
class Function AmRecordHlp.SetGetValue_Bool(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean;
begin
  Result:= SetGetValue(IsGet,
                                           tkEnumeration,TypeInfo(Boolean)
                    ,XVar,ResultD,ResultS);
end;
class Function AmRecordHlp.SetGetValue_Str(IsGet:boolean;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean;
begin
  Result:= SetGetValue(IsGet,
                                           tkString,TypeInfo(string)
                    ,XVar,ResultD,ResultS);
end;
class Function AmRecordHlp.SetGetValue(IsGet:boolean;Kind:TTypeKind;Info:PTypeInfo;XVar:Pointer;ResultD:Pdouble;ResultS:Pstring):boolean;
//var Val:TValue;
begin
             Result:=true;
             if (Info = TypeInfo(Integer))
             or  (Kind in [tkInteger]) then
             begin
                 if IsGet then
                 begin
                  if Assigned(ResultD) then ResultD^:= PInteger(XVar)^
                  else                      ResultS^:= AmStr(Integer(PInteger(XVar)^));

                 end
                 else
                 begin
                    if Assigned(ResultD) then PInteger(XVar)^:=round(ResultD^)
                    else                      PInteger(XVar)^:=AmInt(ResultS^,0);

                 end;
             end
             else if (Info = TypeInfo(String))
             or  (Kind in [tkString,tkLString,tkWString,tkUString]) then
             begin

                 if IsGet then
                 begin
                  if Assigned(ResultD) then ResultD^:= AmReal(String(PString(XVar)^))
                  else                      ResultS^:= PString(XVar)^;

                 end
                 else
                 begin
                    if Assigned(ResultD) then PString(XVar)^:=AmStr(Double(ResultD^))
                    else                      PString(XVar)^:=ResultS^;

                 end;

             end
             else if (Info = TypeInfo(Int64))
             or  (Kind in [tkInt64]) then
             begin
                 if IsGet then
                 begin
                  if Assigned(ResultD) then ResultD^:= PInt64(XVar)^
                  else                      ResultS^:= AmStr(Int64(PInt64(XVar)^));

                 end
                 else
                 begin
                    if Assigned(ResultD) then PInt64(XVar)^:=round(ResultD^)
                    else                      PInt64(XVar)^:=AmInt64(ResultS^,0);

                 end;
             end
             else if ( Info = TypeInfo(TDateTime) )
                 or  ( Info = TypeInfo(Real) )
                 or  ( Info = TypeInfo(Double) )
                 or  ( Info = TypeInfo(Extended) )
                 or  ( Info = TypeInfo(Single) )
                 or  (Kind in [tkFloat])
             then
             begin

                 if IsGet then
                 begin
                  if Assigned(ResultD) then ResultD^:= Pdouble(XVar)^
                  else                      ResultS^:= AmStr(Real(Pdouble(XVar)^));

                 end
                 else
                 begin
                    if Assigned(ResultD) then Pdouble(XVar)^:=ResultD^
                    else                      Pdouble(XVar)^:=AmReal(ResultS^,0);

                 end;

             end
             else if (Info = TypeInfo(Boolean) )then
             begin
                 if IsGet then
                 begin
                  if Assigned(ResultD) then ResultD^:= AmInt(Boolean(PBoolean(XVar)^))
                  else                      ResultS^:= AmStr(Boolean(PBoolean(XVar)^));

                 end
                 else
                 begin
                    if Assigned(ResultD) then PBoolean(XVar)^:=AmBool(Round(ResultD^))
                    else                      PBoolean(XVar)^:=AmBool(String(ResultS^),False);

                 end;
             end

             else
             begin
               Result:=False;
             end;

end;
class Function AmRecordHlp.ToValue<T>(X:T;out Value:TValue):boolean;
var Context : TRttiContext;
begin

end;
class Function AmRecordHlp.ToType<T>(Value:TValue;out X:T):boolean;
begin

end;
class procedure AmRecordHlp.RecFinal<T>(var Instance:T);
begin
  System.Finalize(Instance);
  System.FillChar(Instance,sizeof(Instance),0);
end;
class Function AmRecordHlp.Clear<T>(var Instance:T;out Error:string; Db:boolean=false;Di:integer=0;Ds:string=''):boolean;
var
  Node:TMemberNode;
begin
   // A:=GetFields(MyRec);
  Node:=TMemberNode.Create;
  try
    Result:= Node.GetRoot(Instance,Error);
    if not  Result then exit;
    ClearInternal(Node.RootInstance,Node.RootType,Db,Di,Ds);
    Result:=true;
  finally
    Node.Free;
  end;


end;
class procedure AmRecordHlp.ClearInternal(InstanceData,InstanceType:Pointer;Db:boolean=false;Di:integer=0;Ds:string='');
var
  fld : TRttiField;
  rttiContext : TRttiContext;
  ListF:TArray<TRttiField>;
  V:     TValue;
begin
{TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
    tkClassRef, tkPointer, tkProcedure, tkMRecord);}
    if (InstanceData=nil) or (InstanceType=nil) then  exit;


   // PtypeInfo(InstanceType).Kind = tkDynArray
    ListF:=rttiContext.GetType(InstanceType).GetFields;
    for fld in ListF do
    begin

      if not Assigned(fld.FieldType) then continue;
      V:=fld.GetValue(InstanceData);
      ClearInternalValue(V,Db,Di,Ds);
      fld.SetValue(InstanceData, V);
    end;
end;
class procedure AmRecordHlp.ClearInternalValue(var V:TValue;Db:boolean=false;Di:integer=0;Ds:string='');
//var
 // V2:     TValue;

  //I,C:integer;
begin
   case V.Kind of
          tkDynArray   :  begin


                 // C:=V.GetArrayLength;

                  // for I :=0  to C-1 do
                  // begin
                     //  v2:=  V.GetArrayElement(I);
                     //  ClearInternalValue(v2,Db,Di,Ds);
                      // V.SetArrayElement(I,v2);
                 //  end;
                  // P:= V.GetReferenceToRawData;
                 //   I := 0;
                 // DynArraySetLength(PPointer(v.GetReferenceToRawData)^, v.TypeInfo, 1, @I);
                 DynArrayClear(PPointer(v.GetReferenceToRawData)^, V.TypeInfo); //DynArraySetLength

          end;
          tkInteger,
          tkInt64,
          tkFloat :      V:= DI;

          tkString,
          tkLString,
          tkWString,
          tkUString   :  V:=  DS;

          tkMethod,
          tkProcedure,
          tkPointer,
        //  tkClass,
          tkInterface,
          tkClassRef :   V:=  nil;
          tkChar,
          tkWChar     :  V:=  #0;

          tkRecord,
          tkMRecord   : begin
                 ClearInternal(v.GetReferenceToRawData,V.TypeInfo,Db,Di,Ds);
          end;
          tkEnumeration:begin
              if (v.TypeInfo = System.TypeInfo(Boolean)) then
              v:= Db
              else
              v:=TValue.FromOrdinal(v.TypeInfo,0);
          end;
    end;

end;


class function AmRecordHlp.CompareVariantTypeKind(IsGet:boolean;fld:TTypeKind;VarResult:TTypeKind):boolean;

const  List : TTypeKinds  = [tkInteger,tkFloat,tkString,tkLString, tkWString,tkInt64,tkUString];
 function LocResult(rlt:TTypeKind;fd:TTypeKind):boolean;
 begin
    if IsGet then    
     Result:= (rlt = tkVariant)  and (fd in List)
    else Result:=false;
 end;
 function LocFld(rlt:TTypeKind;fd:TTypeKind):boolean;
 begin
    if not IsGet then
     Result:= (fd = tkVariant)  and (rlt in List)
    else Result:=false;
 end;
begin
  Result:= (fld  =  VarResult)
  or LocFld(fld, VarResult )
    or LocResult(VarResult ,fld);

end;
class Function AmRecordHlp.GetSetVal<T1,T2>(
                                                 IsGet          : boolean;
                                             var Instance       : T1;
                                                 PathFieldName  : String;
                                             Var Variable       : T2;
                                             out Error          : String):boolean;
var
  InfoVariable: PTypeInfo;
  Val:TValue;
  Node:TMemberNode;
  Ftype:TRttiType;
begin
  Result:=False;
  Error:='';
  Node:=TMemberNode.Create;
  try
     try
          Result:= Node.GetRoot(Instance,Error);
          if not  Result then exit;
          Result:=Node.GetPath(PathFieldName,Error);
          if not  Result then exit;

          InfoVariable:= TypeInfo(T2);


          Ftype:= Node.LastType;


           // проверим что типы записи и чтения совпадают
          if  Assigned(Ftype)
          and CompareVariantTypeKind(IsGet,Ftype.TypeKind,InfoVariable.Kind) then
          begin
             if IsGet then
             begin
               //получить TValue последего элемента в пути
               Val:=Node.GetValue();

               //преобразуем  TValue в наш тип
               Variable:=Val.AsType<T2>;//  GetValCust(InfoVarResult.Kind,VarReadWrite,Val) ;
               //Result удачно ли выполнилось
             end
             else
             begin
               //это  Write преобразуем наш тип в TValue
               Val:=Val.From<T2>(Variable);
               //запишем послднему новое значение
               Node.SetValue(Val);
             end;


          end
          else
          begin
             if Assigned(Ftype) then
             Error:='Тип чтения ['+ string(Ftype.ToString) +'] и записи [' +string(InfoVariable.Name)+ '] не совпадают для поля['+string(PathFieldName)+']  в типе данных['+string(Node.RootTypeInfo.Name)+']'
             else
             Error:='Тип чтения ['+ 'неопределено' +'] и записи [' +string(InfoVariable.Name)+ '] не совпадают для поля['+string(PathFieldName)+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';
             Result:=false;
          end;

     except
      on e:exception do
           begin
             if Assigned(Ftype) then
             Error:='Error конвертации типа данных '+e.Message+' Тип чтения ['+ string(Ftype.ToString) +'] и записи [' +string(InfoVariable.Name)+ '] не совпадают для поля['+string(PathFieldName)+']  в типе данных['+string(Node.RootTypeInfo.Name)+']'
             else
             Error:='Error конвертации типа данных '+e.Message+'  Тип чтения ['+ 'неопределено' +'] и записи [' +string(InfoVariable.Name)+ '] не совпадают для поля['+string(PathFieldName)+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';
             Result:=false;
           end;

     end;
  finally
    Node.Free;
  end;
end;
constructor AmRecordHlp.TPerformanceMemory<T>.Create(AInstance:T);
begin
   inherited Create;
   Instance:=AInstance;
   Node:=TMemberNode.Create;

end;
destructor AmRecordHlp.TPerformanceMemory<T>.Destroy ;
begin
    FreeAndNil(Node);
    inherited;
end;
Function AmRecordHlp.TPerformanceMemory<T>.GetSetValDouble(
                                  IsGet:boolean;APath:string;var Variable:Double):boolean;
begin
  Result:=false;
end;   {
class Function AmRecordHlp.GetArrayFieldName2<T>(var Instance:T;isF,isPr,isProdesure:boolean;out ListName:TArray<string>;):boolean;
var s,i:integer;
var VarE:string;
var
 c : TRttiContext;
 m : TRttiMethod;
 f:TRttiField;
 p:TRttiProperty;
 pi:TRttiIndexedProperty;

 procedure Get(Arr:TArray<string>;var index:integer; Mem:TRttiMember );
 var  p:TRttiProperty;
      m : TRttiMethod;
      f:TRttiField;
      pi:TRttiIndexedProperty;
      Ap:TArray<TRttiProperty>;
      Am:TArray<TRttiMethod>;
      Af:TArray<TRttiField>;
      Api:TArray<TRttiIndexedProperty>;

      Cp,Cm,Cf,Cpi,i:integer;
      s:string;
   procedure GetCount;
   begin
       s:= Mem.Name;
       if  Mem  is TRttiProperty then
       begin
           Ap:=TRttiProperty(Mem).PropertyType.GetProperties;
           Cp:=Length(Ap);
           Am:=TRttiProperty(Mem).PropertyType.GetMethods;
           cm:=Length(Am);
           Af:=TRttiProperty(Mem).PropertyType.GetFields;
           cf:=Length(Af);
           Api:= TRttiProperty(Mem).PropertyType.GetIndexedProperties;
           Cpi:= Length(Api);
       end
       else if Mem is TRttiMethod then
       begin
           Ap:=TRttiMethod(Mem).ReturnType.GetProperties;
           Cp:=Length(Ap);
           Am:=TRttiMethod(Mem).ReturnType.GetMethods;
           cm:=Length(Am);
           Af:=TRttiMethod(Mem).ReturnType.GetFields;
           cf:=Length(Af);
           Api:= TRttiMethod(Mem).ReturnType.GetIndexedProperties;
           Cpi:= Length(Api);
       end
       else if Mem is TRttiField then
       begin
           Ap:=TRttiField(Mem).FieldType.GetProperties;
           Cp:=Length(Ap);
           Am:=TRttiField(Mem).FieldType.GetMethods;
           cm:=Length(Am);
           Af:=TRttiField(Mem).FieldType.GetFields;
           cf:=Length(Af);
           Api:= TRttiField(Mem).FieldType.GetIndexedProperties;
           Cpi:= Length(Api);
       end
       else if Mem is TRttiIndexedProperty then
       begin
           Ap:=TRttiIndexedProperty(Mem).PropertyType.GetProperties;
           Cp:=Length(Ap);
           Am:=TRttiIndexedProperty(Mem).PropertyType.GetMethods;
           cm:=Length(Am);
           Af:=TRttiIndexedProperty(Mem).PropertyType.GetFields;
           cf:=Length(Af);
           Api:= TRttiIndexedProperty(Mem).PropertyType.GetIndexedProperties;
           Cpi:= Length(Api);
       end;


   end;
 begin

             GetCount;
             s:=  TRttiProperty(Mem).Name;
             for i:=0 to cp-1 do
             begin
                 p:= Ap[i];
                 if index>=length(Arr) then
                 begin
                   scpDemo.InsertList.Add(p.Name);
                   scpDemo.ItemList.Add(p.ToString);
                 end
                 else if Arr[index] = p.name then
                 begin

                     inc(index);
                     Get(Arr,index,p);
                     exit;

                 end;


             end;

             for i:=0 to cm-1 do
             begin
                 m:=Am[i];
                 if index>=length(Arr) then
                 begin
                   scpDemo.InsertList.Add(m.Name);
                   scpDemo.ItemList.Add(m.ToString);
                 end
                 else if Arr[index] = m.name then
                 begin

                     inc(index);
                     Get(Arr,index,m);
                     exit;

                 end;


             end;


             for i:=0 to cf-1 do
             begin
                 f:=Af[i];
                 if index>=length(Arr) then
                 begin
                   scpDemo.InsertList.Add(f.Name);
                   scpDemo.ItemList.Add(f.ToString);
                 end
                 else if Arr[index] = f.name then
                 begin

                     inc(index);
                     Get(Arr,index,f);
                     exit;

                 end;


             end;

             for i:=0 to cpi-1 do
             begin
                 pi:=Api[i];
                 if index>=length(Arr) then
                 begin
                   scpDemo.InsertList.Add(pi.Name);
                   scpDemo.ItemList.Add(pi.ToString);
                 end
                 else if Arr[index] = pi.name then
                 begin

                     inc(index);
                     Get(Arr,index,pi);
                     exit;

                 end;


             end;


 end;
   var index:integer;
   Arr:Tarray<string>;
   Sk:integer;
   Pole:string;
var
    R:boolean;

begin



  begin
       Arr:= VarE.Split(['.']);
       if Length(Arr)>0 then
       if Arr[0]<>'Rec' then exit;

        index:=1;

      //Rec.Form.Constraints
       c := TRttiContext.Create;
       for p in c.GetType(TypeInfo(TAnderCode)).GetProperties do
       begin
            if index>=length(Arr) then
            begin
               scpDemo.InsertList.Add(p.Name);
               scpDemo.ItemList.Add(p.ToString);
            end
            else if Arr[index] = p.name then
            begin

              inc(index);
              Get(Arr,index,p);
               CanExecute:=true;
              exit;
            end;
       end;

       for m in c.GetType(TypeInfo(TAnderCode)).GetMethods do
       begin
            if index>=length(Arr) then
            begin
               scpDemo.InsertList.Add(m.Name);
               scpDemo.ItemList.Add(m.ToString);
            end
            else if Arr[index] = m.name then
            begin

              inc(index);
              Get(Arr,index,m);
              CanExecute:=true;
              exit;
            end;
       end;

       for f in c.GetType(TypeInfo(TAnderCode)).GetFields do
       begin
            if index>=length(Arr) then
            begin
               scpDemo.InsertList.Add(f.Name);
               scpDemo.ItemList.Add(f.ToString);
            end
            else if Arr[index] = f.name then
            begin

              inc(index);
              Get(Arr,index,f);
              CanExecute:=true;
              exit;
            end;
       end;

       for pi in c.GetType(TypeInfo(TAnderCode)).GetIndexedProperties do
       begin
            if index>=length(Arr) then
            begin
               scpDemo.InsertList.Add(pi.Name);
               scpDemo.ItemList.Add(pi.ToString);
            end
            else if Arr[index] = pi.name then
            begin

              inc(index);
              Get(Arr,index,pi);
              CanExecute:=true;
              exit;
            end;
       end;


      c.Free;
      CanExecute:=true;

  end;





end;  }
class procedure AmRecordHlp.FindType;
var rttiContext : TRttiContext;
begin
  rttiContext.FindType('System.Integer')
end;
class Function AmRecordHlp.EnumToStr<T>(Instance:T):string  ;
begin
{
         MetodStr:= AmUsertype.AmRecordHlp.EnumToStr(Metod);
         SObj['data']['Cookies']['metod'].Value:= MetodStr;
}
  Result:= AmEnumConverter.EnumToString(Instance)
end;
class Function AmRecordHlp.EnumToEnum<T>(Instance:string):T  ;
begin
  AmEnumConverter.StringToEnum(Instance,Result);
end;
class Function AmRecordHlp.EnumStrToInt<T>(Instance:string):integer  ;
begin
{
             MetodStr:=  ObjInput['data']['Cookies']['metod'].Value;
             MetodInt:= AmUsertype.AmRecordHlp.EnumStrToInt<TamBrApiMetodCookies>(MetodStr);
             MetodCount:=Integer(System.High(TamBrApiMetodCookies))+1;
             if (MetodCount>0) and (MetodInt<=MetodCount-1) then
             Metod:= TamBrApiMetodCookies(MetodInt)
             else Metod:=BrApiCookiesNone;
}
 AmEnumConverter.StringToEnum<T>(Instance,Result);
end;
class Function AmRecordHlp.EnumSetToTypSet<T>(Instance:string):T ;
begin
   AmEnumConverter.StringToEnumSet(Instance,Result);
end;
class Function AmRecordHlp.EnumSetToString<T>(Instance:T):string;
begin
  Result:= AmEnumConverter.EnumSetToString(Instance);
end;


class Function AmRecordHlp.FromJsonField<T>(var Instance:T;J:TJsonObject):boolean;
var P:TAmToJsonVariableRtti;
begin
   P:=TAmToJsonVariableRtti.Create;
   try
     //try
       Result:= P.VarFieldsFromJson(Instance,J);
     {except
       on e:exception do
        raise Exception.Create('Error.AmRecordHlp.ToJsonField<T> '+e.Message);
     end;}
   finally
    P.Free;
   end;
end;
class Function AmRecordHlp.ToJsonField<T>(var Instance:T;
                            MaxLevelRecursPars:integer;
                            NeedNameType:boolean;
                            ClassBlack,ClassWhite:TArray<TClass>):TJsonObject;
var P:TAmToJsonVariableRtti;
begin
   P:=TAmToJsonVariableRtti.Create;
   Result:=  TJsonObject.Create;
   try
     //try
        P.VarFieldsToJson(Result,Instance,MaxLevelRecursPars,NeedNameType,ClassBlack,ClassWhite);
     {except
       on e:exception do
        raise Exception.Create('Error.AmRecordHlp.ToJsonField<T> '+e.Message);
     end;}
   finally
    P.Free;
   end;
end;
class function AmRecordHlp.ObjectGetFieldsListPointerVar(Instance:TObject;AffectedClass,StopParentClass:TClass;Filtr:TTypeKindSet):TArray<TPointerVar>;
var

    L:TAmListVar<TPointerVar>;
    Item:TPointerVar;


var rttiContext : TRttiContext;
    RootType:Pointer;
    RootInstance:Pointer;
    ArrRttiField:TArray<TRttiField>;
    Field:TRttiField;
    Value:TValue;
    R:boolean;
    ObjParent:TObject;
//    Obj:TObject;
    //s:string;
//    V:TValue;
begin
  SetLength(Result,0);
  L.Init;
  try
     R:=false;
     if Assigned(AffectedClass) then
     begin
       if not (Instance is AffectedClass) then
       raise Exception.Create('Error.AmRecordHlp.ObjectGetFieldsListPointerVar класс AffectedClass не яаляется предком Instance');
     end;
     if Assigned(StopParentClass) then
     begin
       if not (Instance is StopParentClass)  then
       raise Exception.Create('Error.AmRecordHlp.ObjectGetFieldsListPointerVar класс StopParentClass не яаляется предком Instance');
     end;
     if Assigned(AffectedClass) then
     RootType:= AffectedClass.ClassInfo
     else
     RootType:= PObject(@Instance)^.ClassType.ClassInfo;

     RootInstance:=  PObject(@Instance)^;

    Value:=nil;
    ArrRttiField:=rttiContext.GetType(RootType).GetFields();
    for  Field in ArrRttiField do
    begin
       ObjParent:=  TObject(Field.Parent.Handle.TypeData);
       if StopParentClass<>nil then
       if ObjParent.ClassType = StopParentClass then break;

     //  s:= TObject(Field.Parent.Handle.TypeData).ClassName;
       if (AffectedClass = nil) or (ObjParent.ClassType =  AffectedClass) then
       begin
        if not R then R:=true;
        if (Filtr=[]) or ( Field.FieldType.TypeKind in Filtr) then
        begin

           
           Item.Instance:=  Pointer(Cardinal(RootInstance) + Cardinal(Field.Offset));
           Item.NameField:= Field.Name;
           Item.size:=      GetInlineSize(Field.FieldType.Handle);
           Item.Info:= Field.FieldType.Handle;
           L.Add(Item);
            {
           if Field.FieldType.TypeKind =tkustring then
           begin
            V:=  Field.GetValue(RootInstance);
            s:=PString(Item.Instance)^
           end;
           }
        end;
       end
       else break;
    end;
  finally
   Result:= L.ArrCopy;
   L.Free;
  end;
end;
class function AmRecordHlp.GetInlineSize(TypeInfo: PTypeInfo): Integer;
begin
  if TypeInfo = nil then
    Exit(0);

  case TypeInfo^.Kind of
    tkInteger, tkEnumeration, tkChar, tkWChar:
      case GetTypeData(TypeInfo)^.OrdType of
        otSByte, otUByte: Exit(1);
        otSWord, otUWord: Exit(2);
        otSLong, otULong: Exit(4);
      else
        Exit(0);
      end;
    tkSet:
      begin
        Result := SizeOfSet(TypeInfo);
{$IF   SizeOf(Extended) > SizeOf(TMethod)}
        if Result > SizeOf(Extended) then
          Result := -Result;
{$ELSE SizeOf(Extended) <= SizeOf(TMethod)}
        if Result > SizeOf(TMethod) then
          Result := -Result;
{$ENDIF}
        Exit;
      end;
    tkFloat:
      case GetTypeData(TypeInfo)^.FloatType of
        ftSingle: Exit(4);
        ftDouble: Exit(8);
        ftExtended: Exit(SizeOf(Extended));
        ftComp: Exit(8);
        ftCurr: Exit(8);
      else
        Exit(0);
      end;
    tkClass:
{$IFDEF AUTOREFCOUNT}
      Exit(-SizeOf(Pointer));
{$ELSE  AUTOREFCOUNT}
      Exit(SizeOf(Pointer));
{$ENDIF AUTOREFCOUNT}
    tkClassRef: Exit(SizeOf(Pointer));
    tkMethod: Exit(SizeOf(TMethod));
    tkInt64: Exit(8);
    tkDynArray, tkUString, tkLString, tkWString, tkInterface: Exit(-SizeOf(Pointer));
{$IFNDEF NEXTGEN}
    tkString: Exit(-GetTypeData(TypeInfo)^.MaxLength - 1);
{$ENDIF !NEXTGEN}
    tkPointer: Exit(SizeOf(Pointer));
    tkProcedure: Exit(SizeOf(Pointer));
    tkRecord, tkMRecord: Exit(-GetTypeData(TypeInfo)^.RecSize);
    tkArray: Exit(-GetTypeData(TypeInfo)^.ArrayData.Size);
    tkVariant: Exit(-SizeOf(Variant));
  else
    Exit(0);
  end;
end;
class procedure AmRecordHlp.ObjectFieldsFree(Instance:TObject;AffectedClass,StopParentClass:TClass);
var rttiContext : TRttiContext;
    RootType:Pointer;
    RootInstance:Pointer;
    ArrRttiField:TArray<TRttiField>;
    Field:TRttiField;
    Value:TValue;
    R:boolean;
    ObjParent:TObject;
    Obj:TObject;
  //  s:string;
begin
   R:=false;
   if Assigned(AffectedClass) then
   begin
     if not (Instance is AffectedClass) then
     raise Exception.Create('Error.AmRecordHlp.ObjectFieldsFree класс AffectedClass не яаляется предком Instance');
   end;
   if Assigned(StopParentClass) then
   begin
     if not (Instance is StopParentClass)  then
     raise Exception.Create('Error.AmRecordHlp.ObjectFieldsFree класс StopParentClass не яаляется предком Instance');
   end;
   if Assigned(AffectedClass) then
   RootType:= AffectedClass.ClassInfo
   else
   RootType:= PObject(@Instance)^.ClassType.ClassInfo;

   RootInstance:=  PObject(@Instance)^;

  Value:=nil;
  ArrRttiField:=rttiContext.GetType(RootType).GetFields();
  for  Field in ArrRttiField do
  begin
     ObjParent:=  TObject(Field.Parent.Handle.TypeData);
     if StopParentClass<>nil then
     if ObjParent.ClassType = StopParentClass then break;

   //  s:= TObject(Field.Parent.Handle.TypeData).ClassName;
     if (AffectedClass = nil) or (ObjParent.ClassType =  AffectedClass) then
     begin
      if not R then R:=true;
      if Field.FieldType.TypeKind = tkClass then
      begin
         Obj:=Field.GetValue(RootInstance).AsObject;
         if Obj<>nil then
         begin
           Obj.Free;
           Field.SetValue(RootInstance,Value);
         end;
      end;
     end
     else break;
  end;

end;
class procedure AmRecordHlp.ObjectFieldsInit(Instance:TObject;AffectedClass,StopParentClass:TClass);
var rttiContext : TRttiContext;
    RootType:Pointer;
    RootInstance:Pointer;
    ArrRttiField:TArray<TRttiField>;
    Field:TRttiField;
    Value:TValue;
    R:boolean;
    ObjParent:TObject;
//    s:string;
begin
   R:=false;
   if Assigned(AffectedClass) then
   begin
     if not (Instance is AffectedClass)  then
     raise Exception.Create('Error.AmRecordHlp.ObjectFieldsInit класс AffectedClass не яаляется предком Instance');
   end;
   if Assigned(StopParentClass) then
   begin
     if not (Instance is StopParentClass)  then
     raise Exception.Create('Error.AmRecordHlp.ObjectFieldsInit класс StopParentClass не яаляется предком Instance');
   end;
   if Assigned(AffectedClass) then
   RootType:= AffectedClass.ClassInfo
   else
   RootType:= PObject(@Instance)^.ClassType.ClassInfo;

   RootInstance:=  PObject(@Instance)^;

  Value:=nil;
  ArrRttiField:=rttiContext.GetType(RootType).GetFields();
  for  Field in ArrRttiField do
  begin

     ObjParent:=  TObject(Field.Parent.Handle.TypeData);
   //  s:= ObjParent.ClassName;

     if StopParentClass<>nil then
     if ObjParent.ClassType = StopParentClass then break;
     

     if (AffectedClass = nil) or (ObjParent.ClassType =  AffectedClass) then
     begin
      if not R then R:=true;
      if Field.FieldType.TypeKind = tkClass then
      Field.SetValue(RootInstance,Value);
     end
     else break;
  end;

end;
class Function AmRecordHlp.GetArrayFieldName<T>(var Instance:T;isF,isPr,isProdesure:boolean):TArray<string>;
var Node:TMemberNode;
 R:boolean;
 Error:string;
 RttiField:TArray<TRttiField>;
 i,coumt,CountResult:integer;
begin
    SetLength(Result,0);
    CountResult:=0;
    Node:=TMemberNode.Create;
    try
       R:= Node.GetRoot(Instance,Error);
       if not  R then exit;

      if isF then
      begin
        RttiField:= Node.rttiContext.GetType(Node.RootType).GetFields();

        coumt:=   length(RttiField);
        CountResult:= CountResult+ coumt;
        for I := 0 to coumt-1 do
        Result[CountResult+i]:=RttiField[i].Name;
      end;

        
     { if not Assigned(FMember[0].Member) then
      begin
          FMember[0].Member:= rttiContext.GetType(RootType).GetProperty(Arr[0]);
          if not Assigned(FMember[0].Member) then
          begin
             if GetNameFromIndexedProperty(Arr[0],AName,prtIndexPrm,ArrStr) then
             begin
             FMember[0].Member:= rttiContext.GetType(RootType).GetIndexedProperty(AName);
             FMember[0].prtIndexPrm:= prtIndexPrm;
             FMember[0].ArrStr:= ArrStr;
             end;
             if not Assigned(FMember[0].Member) then
             begin
               Error:='Не найдено поле['+APath+'] в типе данных['+RootTypeInfo.Name+']';
               exit(False);
             end;

          end;

      end;

      mem:= FMember[0].Member;
      }

    finally
      Node.Free;
    end;
end;

class Function AmRecordHlp.GetSetValDouble<T>(IsGet          : boolean;
                                             var Instance       : T;
                                                 PathFieldName  : String;
                                             Var Variable       : Double;
                                             out Error          : String):boolean;
var
  Val:TValue;
  Node:TMemberNode;
  Ftype:TRttiType;
  AInt:integer;
  AInt64:Int64;
  AReal:Real;
  ABoolean:Boolean;
  ADate:TDateTime;
begin
  Result:=False;
  Error:='';
  Node:=TMemberNode.Create;
  try
     try



          Result:= Node.GetRoot(Instance,Error);
          if not  Result then exit;
          Result:=Node.GetPath(PathFieldName,Error);
          if not  Result then exit;






 { TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
    tkClassRef, tkPointer, tkProcedure, tkMRecord);   }

          Ftype:= Node.LastType;
         // Showmessage(GetEnumname(TypeInfo(TTypeKind),Ord(Ftype.TypeKind)));

          if  Assigned(Ftype) then
          begin

              Result:=true;
             if (Ftype.Handle = TypeInfo(Integer))
             or  (Ftype.TypeKind in [tkInteger]) then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  AInt:= Val.AsType<Integer>;
                  Variable:= AInt;
                 end
                 else
                 begin
                    AInt:= Round(Variable);
                    Val:=Val.From<Integer>(AInt);
                    Node.SetValue(Val);
                 end;
             end
             else if (Ftype.Handle = TypeInfo(String))
             or  (Ftype.TypeKind in [tkString,tkLString,tkWString,tkUString]) then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  Variable:= AmReal(Val.AsType<String>,0);

                 end
                 else
                 begin
                    Val:=Val.From<String>(AmStr(Real(Variable)));
                    Node.SetValue(Val);
                 end;
             end
             else if (Ftype.Handle = TypeInfo(Int64))
             or  (Ftype.TypeKind in [tkInt64]) then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  AInt64:= Val.AsType<Int64>;
                  Variable:= AInt64;
                 end
                 else
                 begin
                    AInt64:= Round(Variable);
                    Val:=Val.From<Int64>(AInt64);
                    Node.SetValue(Val);
                 end;
             end
             else if ( Ftype.Handle = TypeInfo(TDateTime) )
                 or  ( Ftype.Handle = TypeInfo(Real) )
                 or  ( Ftype.Handle = TypeInfo(Double) )
                 or  ( Ftype.Handle = TypeInfo(Extended) )
                 or  ( Ftype.Handle = TypeInfo(Single) )
                 or  (Ftype.TypeKind in [tkFloat])
             then
             begin

                 if IsGet then Variable:= Node.GetValue().AsExtended
                 else Node.SetValue(TValue.From(Variable));

             end
             else if (Ftype.Handle = TypeInfo(Boolean) )then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  ABoolean:= Val.AsType<boolean>;
                  Variable:= AmInt(ABoolean);
                 end
                 else
                 begin
                    ABoolean:= AmBool(Variable,False);
                    //ABoolean:=false;
                    Val:=Val.From(ABoolean);
                    Node.SetValue(Val);

                 end;
             end
             else if ((Ftype.TypeKind in [tkEnumeration]) )then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  AInt64:= Val.AsOrdinal;
                  Variable:= AInt64;
                 end
                 else
                 begin
                    AInt64:= Round(Variable);
                    Val:=Val.From(AInt64);
                    Node.SetValue(Val);

                 end;
             end
             else
             begin
               Result:=false;
               Error:=' Такой тип данных не поддерживается для конвертации в Double Тип чтения ['+ Ftype.ToString +'] для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';

               exit;
             end;




          end
          else
          begin
             Error:='Тип чтения ['+ 'неопределено' +'] не совпадают для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';
             Result:=false;
          end;

     except
      on e:exception do
           begin
             if Assigned(Ftype) then
             Error:='Error конвертации типа данных '+e.Message+' Тип чтения ['+ Ftype.ToString +'] для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']'
             else
             Error:='Error конвертации типа данных '+e.Message+'  Тип чтения ['+ 'неопределено' +'] для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';
             Result:=false;
           end;

     end;
  finally
    Node.Free;
  end;

end;
class Function AmRecordHlp.GetSetValStr<T>(
                                                 IsGet          : boolean;
                                             var Instance       : T;
                                                 PathFieldName  : String;
                                             Var Variable       : String;
                                             out Error          : String):boolean;
var
  Val:TValue;
  Node:TMemberNode;
  Ftype:TRttiType;
  AInt:integer;
  AInt64:Int64;
  AReal:Real;
  ABoolean:Boolean;
  ADate:TDateTime;
begin
  Result:=False;
  Error:='';
  Node:=TMemberNode.Create;
  try
     try



          Result:= Node.GetRoot(Instance,Error);
          if not  Result then exit;
          Result:=Node.GetPath(PathFieldName,Error);
          if not  Result then exit;


 { TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
    tkClassRef, tkPointer, tkProcedure, tkMRecord);   }

          Ftype:= Node.LastType;
         // Showmessage(GetEnumname(TypeInfo(TTypeKind),Ord(Ftype.TypeKind)));

          if  Assigned(Ftype) then
          begin
             Result:=true;
             if ( Ftype.Handle = TypeInfo(TDateTime) ) then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  ADate:= Val.AsType<TDateTime>;
                  Variable:= AmStr(ADate,False,'dd.mm.yy" "hh:nn:ss');
                 end
                 else
                 begin
                    ADate:= AmDateTime(Variable,0);
                    Val:=Val.From<TDateTime>(ADate);
                    Node.SetValue(Val);

                 end;
             end
             else if (Ftype.Handle = TypeInfo(Integer))
             or  (Ftype.TypeKind in [tkInteger]) then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  AInt:= Val.AsType<Integer>;
                  Variable:= AmStr(AInt);
                 end
                 else
                 begin
                    AInt:= AmInt(Variable,0);
                    Val:=Val.From<Integer>(AInt);
                    Node.SetValue(Val);
                 end;
             end
             else if (Ftype.Handle = TypeInfo(String))
             or  (Ftype.TypeKind in [tkString,tkLString,tkWString,tkUString]) then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  Variable:= Val.AsType<String>;

                 end
                 else
                 begin
                    Val:=Val.From<String>(Variable);
                    Node.SetValue(Val);
                 end;
             end
             else if (Ftype.Handle = TypeInfo(Int64))
             or  (Ftype.TypeKind in [tkInt64]) then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  AInt64:= Val.AsType<Int64>;
                  Variable:= AmStr(AInt64);
                 end
                 else
                 begin
                    AInt64:= AmInt64(Variable,0);
                    Val:=Val.From<Int64>(AInt64);
                    Node.SetValue(Val);
                 end;
             end
             else if (Ftype.Handle = TypeInfo(Real) )
             or  ( Ftype.Handle = TypeInfo(Double) )
             or  ( Ftype.Handle = TypeInfo(Extended) )
             or  ( Ftype.Handle = TypeInfo(Single) )
             or  (Ftype.TypeKind in [tkFloat])
             then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  AReal:= Val.AsExtended;
                  Variable:= AmStr(AReal);
                 end
                 else
                 begin
                    AReal:= AmReal(Variable,0);
                    Val:=Val.From(AReal);
                    Node.SetValue(Val);

                 end;
                 
             end
             else if (Ftype.Handle = TypeInfo(Boolean) )then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  ABoolean:= Val.AsType<boolean>;
                  Variable:= AmStr(ABoolean);
                 end
                 else
                 begin
                    ABoolean:= AmBool(Variable,False);
                    Val:=Val.From(ABoolean);
                    Node.SetValue(Val);

                 end;
             end
             else if ((Ftype.TypeKind in [tkEnumeration]) )then
             begin
                 if IsGet then
                 begin
                  Val:=Node.GetValue();
                  AInt64:= Val.AsOrdinal;
                  Variable:= AmStr(AInt64);
                 end
                 else
                 begin
                    AInt64:= AmInt64(Variable,0);
                    Val:=Val.From(AInt64);
                    Node.SetValue(Val);

                 end;
             end
             else
             begin
               Result:=false;
               Error:=' Такой тип данных не поддерживается для конвертации в строку Тип чтения ['+ Ftype.ToString +'] для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';

               exit;
             end;




          end
          else
          begin
             Error:='Тип чтения ['+ 'неопределено' +'] не совпадают для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';
             Result:=false;
          end;

     except
      on e:exception do
           begin
             if Assigned(Ftype) then
             Error:='Error конвертации типа данных '+e.Message+' Тип чтения ['+ Ftype.ToString +'] для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']'
             else
             Error:='Error конвертации типа данных '+e.Message+'  Тип чтения ['+ 'неопределено' +'] для поля['+PathFieldName+']  в типе данных['+string(Node.RootTypeInfo.Name)+']';
             Result:=false;

           end;

     end;
  finally
    Node.Free;
  end;
end;
class Function AmRecordHlp.GetTypeInfo<T>(var Instance:T;PathFieldName:string):PTypeInfo;
var Node:TMemberNode;
    R:boolean;
    Error:string;
    Ftype:TRttiType;
begin
  Result:=nil;
  Node:=TMemberNode.Create;
  try
      R:= Node.GetRoot(Instance,Error);
      if not  R then exit;
      R:=Node.GetPath(PathFieldName,Error);
      if not  R then exit;

      Ftype:= Node.LastType;
      if Assigned(Ftype) then
      Result:=Ftype.Handle;
  finally
    Node.Free;
  end;
end;
class Function AmRecordHlp.GetTypeInfoRef(Instance:PtypeInfo):PtypeInfo;
var R:boolean;
P:PTypeInfo;
    D:PTypeData;
begin
   P:= Instance;
   R:=true;
   Result:=nil;
   while R do
   if P.Kind = tkPointer then
   begin
    D:= P.TypeData;
    if (D<>nil) and (D.RefType<>nil) then
    begin
      P:=D.RefType^;
      Result:= P;
    end
    else
    begin
        Result:=P;
        R:=false;
    end;
   end
   else
   begin
     Result:=P;
     R:=false;
   end;
end;
class Function AmRecordHlp.GetTypeKindRef<T>(Instance:T):TTypeKind;
var P:PTypeInfo;
    D:PTypeData;
    R:boolean;
    V:TValue;
begin

   P:=PTypeInfo(TypeInfo(T));
   Result:= P.Kind;
   R:=true;
   while R do
   if P.Kind = tkPointer then
   begin
    D:= P.TypeData;
    if (D<>nil) and (D.RefType<>nil) then
    begin
      P:=D.RefType^;
      Result:= P.Kind;
    end
    else
    begin
        Result:=P.Kind;
        R:=false;
    end;
   end
   else
   begin
     Result:=P.Kind;
     R:=false;
   end;
end;
class Function AmRecordHlp.GetTypeKind<T>(var Instance:T;PathFieldName:string):TTypeKind;
var Node:TMemberNode;
    R:boolean;
    Error:string;
    Ftype:TRttiType;
begin
  Result:=tkUnknown;
  Node:=TMemberNode.Create;
  try
      R:= Node.GetRoot(Instance,Error);
      if not  R then exit;
      R:=Node.GetPath(PathFieldName,Error);
      if not  R then exit;
      Ftype:= Node.LastType;
      if Assigned(Ftype) then
      Result:=Ftype.TypeKind;
  finally
    Node.Free;
  end;

end;
             {TMemberNode}
function AmRecordHlp.TMemberNode.LastType:TRttiType;
var mem: TRttiMember;
begin
   mem:=FMember[High(FMember)].Member;
  if mem is TRttiField then
     Result := TRttiField(mem).FieldType
  else if mem is  TRttiProperty then
      Result := TRttiProperty(mem).PropertyType
  else if mem is  TRttiIndexedProperty then
      Result := TRttiIndexedProperty(mem).PropertyType
  else
    Result:=nil;
end;
function AmRecordHlp.TMemberNode.GetRoot<T>(var Instance:T;out Error:string):boolean;
begin
      Result:=true;
      RootTypeInfo:=TypeInfo(T);
      //посмотрим с каким типом переменной придется работать
      case RootTypeInfo.Kind of
           tkClass: begin
               RootType:= PObject(@Instance)^.ClassType.ClassInfo;
               RootInstance:=  PObject(@Instance)^;
           end;
           tkRecord:begin
               RootType:= RootTypeInfo;
               RootInstance:=  @Instance;
           end
           else
           begin
             RootType:=nil;
             RootInstance:=nil;
             Error:='Тип данных ['+RootTypeInfo.Name+'] не является tkClass,tkRecord он равен['+string(GetEnumname( TypeInfo(TTypeKind), Ord(RootTypeInfo.Kind) ))+']';
             Result:=false;
           end;

      end;
end;
function AmRecordHlp.TMemberNode.GetNameFromIndexedProperty(Input:string;
                                                           out AName:string;
                                                           out prtIndexPrm:string;
                                                           out ArrStr:TArrString):Boolean;
 var Arr:TArrString;
begin
   Result:=False;
   AName:='';
   prtIndexPrm:='';
   if (pos('[',Input)<>0) and (pos(']',Input)<>0) then
   begin
        Result:=true;
    //    ArrHlp.Split(Input,['[',']']);
     //   AName:= ArrHlp.List[0];
     //   prtIndexPrm:= trim(ArrHlp.List[1]);

        Arr:= Input.Split(['[',']']);
         AName:=  Arr[0];
         prtIndexPrm:= Arr[1];
         ArrStr:= prtIndexPrm.Split([',']);

      ///  ArrStr.Split(prtIndexPrm,[',']);
      //  ArrStr:=



       // prtIndexPrm:= trim(Input.Split(['['])[1]);
      //  prtIndexPrm:= trim(prtIndexPrm.Split([']'])[0]);
      //  prtIndexPrm:=prtIndexPrm.Replace(' ','');
       // ArrStr:= prtIndexPrm.Split([',']);

   end;
   
end;
function AmRecordHlp.TMemberNode.GetArgPropertyIndexed(prp:TRttiIndexedProperty;ArrStr:TArrString):TArrValue;
var
  m: TRttiMethod;
  p: TArray<TRttiParameter>;
  i: Integer;
  inced:integer;
 { TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
    tkClassRef, tkPointer, tkProcedure, tkMRecord);   }
  function Loc_GetVal(InfType:TRttiType; S:String):TValue;
  begin
     if      (InfType.Handle  = TypeInfo(Integer))
             or (InfType.TypeKind in [tkInteger] ) then
             Result:= TValue.From(AmInt(S,0))


     else if ( InfType.Handle = TypeInfo(String) )
          or ( InfType.TypeKind in [tkString,tkLString,tkWString,tkUString] ) then
          Result:= TValue.From(S)


     else if InfType.Handle  = TypeInfo(TDateTime) then
          Result:= TValue.From(AmDateTime(S,0))

     else if     ( InfType.Handle = TypeInfo(Real) )
             or  ( InfType.Handle = TypeInfo(Double) )
             or  ( InfType.Handle = TypeInfo(Extended) )
             or  ( InfType.Handle = TypeInfo(Single) )
             or  ( InfType.TypeKind in [tkFloat] )  then
             Result:= TValue.From(AmReal(S,0))


    else if    ( InfType.Handle = TypeInfo(Int64))
            or ( InfType.TypeKind in [tkInt64] ) then
            Result:= TValue.From(AmInt64(S,0))


    else if (InfType.Handle = TypeInfo(Boolean) )then
            Result:= TValue.From(AmBool(S,FAlse))

    else if ((InfType.TypeKind in [tkEnumeration]) )then
            Result:= TValue.From(AmInt64(S,0))

  end;

begin
   inced:=0;
   try
      SetLength(Result,Length(ArrStr));

      m := prp.ReadMethod;
      if m <> nil then
      begin
        p := m.GetParameters;
        for i := 0 to Length(p) - 1 do
        begin
             Result[inced]:=  Loc_GetVal(p[i].ParamType,ArrStr[inced]);
             inc(inced);
        end;

      end
      else
      begin
        m := prp.WriteMethod;
        if m = nil then
          Exit();
        p := m.GetParameters;
        for i := 0 to Length(p) - 2 do
        begin
             Result[inced]:=  Loc_GetVal(p[i].ParamType,ArrStr[inced]);
             inc(inced);
        end;

      end;
   finally
       SetLength(Result,inced);
   end;

end;
function AmRecordHlp.TMemberNode.GetPath(APath:string; out Error :string):boolean;
var
  i:integer;

  mem:TRttiMember;
//  Val:TValue;
  AName,prtIndexPrm:string;
  Arr,Arrstr:TArrString;


begin
      Error:='';
      Result:=true;
      if length(APath)=0 then
      begin
         Error:=  'APath = Пусто';
         exit(False);
      end;
    //  PatchArr.Count:= AmHlpStr.Split(APath,['.'],PatchArr.List);

      Arr:=APath.Split(['.']);

      if not Assigned(RootType)
      or not Assigned(RootInstance)
      or not Assigned(RootTypeInfo) then
      begin
         Error:=  'Root = nil';
         exit(False);
      end;



      //в список занесем все найденые элементы до искомого пути
      SetLength(FMember,length(Arr));


      FMember[0].APath:= ShortString(Arr[0]);
      FMember[0].Member:= rttiContext.GetType(RootType).GetField(Arr[0]);
      if not Assigned(FMember[0].Member) then
      begin
          FMember[0].Member:= rttiContext.GetType(RootType).GetProperty(Arr[0]);
          if not Assigned(FMember[0].Member) then
          begin
             if GetNameFromIndexedProperty(Arr[0],AName,prtIndexPrm,ArrStr) then
             begin
             FMember[0].Member:= rttiContext.GetType(RootType).GetIndexedProperty(AName);
             FMember[0].prtIndexPrm:= ShortString(prtIndexPrm);
             FMember[0].ArrStr:= ArrStr;
             end;
             if not Assigned(FMember[0].Member) then
             begin
               Error:='Не найдено поле['+APath+'] в типе данных['+string(RootTypeInfo.Name)+']';
               exit(False);
             end;
             
          end;
          
      end;
      
      mem:= FMember[0].Member;




      for I := 1 to length(Arr)-1 do
      begin


             FMember[i].APath:=  ShortString(Arr[i]);


             if mem is TRttiField then
             begin
                mem:= FMember[i-1].Member;


                //if Arr[i]='My' then
               // begin
                 //  mem:=TRttiField(mem).FieldType.GetField(Arr[i]);
                  // Error:=TRttiField(mem).FieldType.AsInstance.Name;
               // end
               // else
                mem:=TRttiField(mem).FieldType.GetField(Arr[i]);


                if Assigned(mem) then
                begin
                  FMember[i].Member:=mem;
                  continue;
                end;
                mem:= FMember[i-1].Member;
                mem:=TRttiField(mem).FieldType.GetProperty(Arr[i]);
                if Assigned(mem) then
                begin
                  FMember[i].Member:=mem;
                  continue;
                end;

                if GetNameFromIndexedProperty(Arr[i],AName,prtIndexPrm,ArrStr) then
                begin
                    mem:= FMember[i-1].Member;
                    mem:=TRttiField(mem).FieldType.GetIndexedProperty(AName);
                    if Assigned(mem) then
                    begin
                      FMember[i].Member:=mem;
                      FMember[i].prtIndexPrm:=ShortString(prtIndexPrm);
                      FMember[i].ArrStr:= ArrStr;
                      continue;
                    end;
                end;
                Error:='Не найдено поле['+APath+'] в типе данных['+string(RootTypeInfo.Name)+']';
                Exit(False);


             end;
             if mem is TRttiProperty then
             begin
                mem:= FMember[i-1].Member;
                mem:=TRttiProperty(mem).PropertyType.GetField(Arr[i]);
                if Assigned(mem) then
                begin
                  FMember[i].Member:=mem;
                  continue;
                end;
                mem:= FMember[i-1].Member;
                mem:=TRttiProperty(mem).PropertyType.GetProperty(Arr[i]);
                if Assigned(mem) then
                begin
                  FMember[i].Member:=mem;
                  continue;
                end;

                if GetNameFromIndexedProperty(Arr[i],AName,prtIndexPrm,ArrStr) then
                begin
                    mem:= FMember[i-1].Member;
                    mem:=TRttiProperty(mem).PropertyType.GetIndexedProperty(AName);
                    if Assigned(mem) then
                    begin
                      FMember[i].Member:=mem;
                      FMember[i].prtIndexPrm:=ShortString(prtIndexPrm);
                      FMember[i].ArrStr:= ArrStr;
                      continue;
                    end;
                end;
                Error:='Не найдено поле['+APath+'] в типе данных['+string(RootTypeInfo.Name)+']';
                Exit(False);
             end;

             if mem is TRttiIndexedProperty then
             begin
                mem:= FMember[i-1].Member;
                mem:=TRttiIndexedProperty(mem).PropertyType.GetField(Arr[i]);
                if Assigned(mem) then
                begin
                  FMember[i].Member:=mem;
                  continue;
                end;
                mem:= FMember[i-1].Member;
                mem:=TRttiIndexedProperty(mem).PropertyType.GetProperty(Arr[i]);
                if Assigned(mem) then
                begin
                  FMember[i].Member:=mem;
                  continue;
                end;

                if GetNameFromIndexedProperty(Arr[i],AName,prtIndexPrm,ArrStr) then
                begin
                    mem:=TRttiIndexedProperty(mem).PropertyType.GetIndexedProperty(AName);
                    if Assigned(mem) then
                    begin
                      FMember[i].Member:=mem;
                      FMember[i].prtIndexPrm:=ShortString(prtIndexPrm);
                      FMember[i].ArrStr:= ArrStr;
                      continue;
                    end;
                end;
                Error:='Не найдено поле['+APath+'] в типе данных['+string(RootTypeInfo.Name)+']';
                Exit(False);
             end;

      end;
end;
function AmRecordHlp.TMemberNode.GetIsRecordHlp(Index:integer):boolean;
var mem:TRttiMember;
begin
     Result:=false;
      mem:=FMember[Index].Member;
      if       mem is  TRttiField then Result:= TRttiField(mem).FieldType.IsRecord
      else if  mem is  TRttiProperty then Result:=TRttiProperty(mem).PropertyType.IsRecord
      else if  mem is  TRttiIndexedProperty then Result:=TRttiIndexedProperty(mem).PropertyType.IsRecord;

end;
function AmRecordHlp.TMemberNode.GetPonterHlpRefer(Index:integer;LastValue:TValue):Pointer;
begin
      if GetIsRecordHlp(Index-1) then
        Result:= LastValue.GetReferenceToRawData
      else
        Result:= LastValue.AsObject;
end;
function AmRecordHlp.TMemberNode.GetValueHlpRoot():TValue;
var mem:TRttiMember;
begin
  mem:=FMember[0].Member;
  if mem is TRttiField then
     Result := TRttiField(mem).GetValue(RootInstance)
  else if mem is  TRttiProperty then
      Result := TRttiProperty(mem).GetValue(RootInstance)
  else if mem is  TRttiIndexedProperty then
      Result := TRttiIndexedProperty(mem).GetValue(RootInstance,
      GetArgPropertyIndexed(TRttiIndexedProperty(mem),FMember[0].ArrStr))
  else
  exit;
end;
function AmRecordHlp.TMemberNode.GetValueHlp(Index:integer;RootValue:TValue):TValue;
var P:Pointer;
mem:TRttiMember;
begin
      //for i:=1 to Length(FMember)-2 do // we'll stop before the last FMember element
      //  if FMember[i-1].FieldType.IsRecord then
        //  Values[i] := FMember[i].GetValue(Values[i-1].GetReferenceToRawData)
       // else
        //  Values[i] := FMember[i].GetValue(Values[i-1].AsObject);


      mem:=FMember[Index].Member;
      Result:= RootValue;

      P:=GetPonterHlpRefer(Index,Result);

      if mem is TRttiField then                 Result :=TRttiField(mem).GetValue(P)
      else if mem is  TRttiProperty then        Result :=TRttiProperty(mem).GetValue(P)
      else if mem is  TRttiIndexedProperty then Result :=TRttiIndexedProperty(mem).GetValue(P,
      GetArgPropertyIndexed(TRttiIndexedProperty(mem),FMember[Index].ArrStr))


end;
function AmRecordHlp.TMemberNode.GetValue:TValue;
var i:Integer;
begin
  Result:=GetValueHlpRoot();
  for i:=1 to High(FMember) do
  Result:=GetValueHlp(i,Result);
end;
procedure AmRecordHlp.TMemberNode.SetValueHlp(Index:integer;P:Pointer;Value:TValue);
var mem:TRttiMember;
begin
  mem:=FMember[Index].Member;
  if mem is TRttiField then
     TRttiField(mem).SetValue(P,Value)
  else if mem is  TRttiProperty then
      TRttiProperty(mem).SetValue(P,Value)
  else if mem is  TRttiIndexedProperty then
      TRttiIndexedProperty(mem).SetValue(P,
      GetArgPropertyIndexed(TRttiIndexedProperty(mem),FMember[Index].ArrStr),Value)
  else
  exit;
end;
procedure AmRecordHlp.TMemberNode.SetValueHlpRefer(Index:integer;ValueLast,Value:TValue);
var P:Pointer;
begin
      P:=GetPonterHlpRefer(Index,ValueLast);
      SetValueHlp(Index,P,Value);

end;
procedure AmRecordHlp.TMemberNode.SetValue(Value:TValue);
var Values:array of TValue;
var i:Integer;

begin
  if Length(FMember) = 1 then
    SetValueHlp(0,RootInstance,Value)
  else
    begin

      SetLength(Values, Length(FMember)-1);
      Values[0] :=GetValueHlpRoot();

      for i:=1 to Length(FMember)-2 do
      Values[i] :=GetValueHlp(i,Values[i-1]);

      SetValueHlpRefer(High(FMember),Values[High(FMember)-1],Value);


      i := High(FMember)-1;
      while (i >= 0) and GetIsRecordHlp(i) do
      begin
        if i = 0 then
          SetValueHlp(0,RootInstance,Values[0])
        else
          SetValueHlpRefer(i,Values[i-1],Values[i]);
        Dec(i)
      end;
    end;
end;









                {AmMath}

Class Function   AmMath.CeilLeft(const AValue: Extended;const ADigit: TRoundToEXRangeExtended):Extended;
var i,a,cel:integer;
begin
   Result:= AValue;
   cel:= Trunc(Result);
   i:=CountZnakInt(cel);
   if i=0 then i:=-CountZnakZeroFrac(Result);
   i:=i-ADigit;
    if i>0 then
    begin
       for a := 0 to i-1 do Result:= Result / 10;
       Result:= Ceil(Result);
       for a := 0 to i-1 do Result:= Result * 10;
    end
    else
    begin
       for a :=  i+1 to 0 do Result:= Result * 10;
       Result:= Ceil(Result);
       for a :=  i+1 to 0 do Result:= Result / 10;
    end;

end;

Class Function   AmMath.FloorLeft(const AValue: Extended;const ADigit: TRoundToEXRangeExtended):Extended;
var i,a,cel:integer;
begin
   Result:= AValue;
   cel:= Trunc(Result);
   i:=CountZnakInt(cel);
   if i=0 then i:=-CountZnakZeroFrac(Result);
   i:=i-ADigit;
    if i>0 then
    begin
       for a := 0 to i-1 do Result:= Result / 10;
       Result:= Floor(Result);
       for a := 0 to i-1 do Result:= Result * 10;
    end
    else
    begin
       for a :=  i+1 to 0 do Result:= Result * 10;
       Result:= Floor(Result);
       for a :=  i+1 to 0 do Result:= Result / 10;
    end;



end;
Class Function  AmMath.RoundLeft(const AValue: Extended;const ADigit: TRoundToEXRangeExtended):Extended;
var i,cel:integer;
begin
   Result:= AValue;
   cel:= Trunc(Result);
   i:=CountZnakInt(cel);
   if i=0 then i:=-CountZnakZeroFrac(Result);
   i:=i-ADigit;
   Result:= math.roundTo(AValue,i);
end;
Class Function   AmMath.IsRange(value,mn,mx:integer):boolean;
begin
  Result:= (value>=mn) and  (value<=mx)
end;
Class Function   AmMath.CountZnakInt(I:int64):integer;
begin
   Result:=0;
   while (I<>0) do
   begin
     I:= I div 10;
      inc(Result);
   end;
end;
Class Function   AmMath.CountZnakZeroFrac(drob:Extended):integer;
var a:integer;
begin
      Result:=0;
      for a := 0 to 10 do
      begin
      drob:=drob*10;
      if drob>1 then break
      else inc(Result);
      end;
end;
Class function AmMath.RandomRange(a,b: integer): integer;
begin
 Result:= math.RandomRange(a,b);
end;
Class function AmMath.RandomRangeListNotDublicat(a,b,Count: integer;ArrInt:{PArrInt}Pointer):boolean;
var i, k,pCount,p: integer;
    L:PArrInt;
begin
      if a>b then
      begin
        k:=a;
        a :=b;
        b :=k;
      end;
      k:= b - a ;
      L:= PArrInt(ArrInt);
      if Count >= k  then
      begin
        L.count:= k;
        for I := 0 to k-1 do
        begin
           L.Arr[i]:= a + i;
        end;
        L.RandomExchangeList;
      end
      else
      begin
          pCount:= Count*5;
          L.count:= Count;
          p:=0;
          i := 0;
          while (i < Count) and (p < pCount) do
          begin
            L.Arr[i] := math.RandomRange(a,b);
            for k := 0 to i - 1 do
            if L.Arr[k] = L.Arr[i] then
            begin
              dec(i);
              break;
            end;
            inc(i);
            inc(p);
          end;
      end;
      Result:=true;
end;
Class function AmMath.RandomRangeList(a,b,Count: integer;ArrInt:{PArrInt}Pointer):boolean;
var i, k: integer;
    L:PArrInt;
begin
      if a>b then
      begin
        k:=a;
        a :=b;
        b :=k;
      end;
      L:= PArrInt(ArrInt);
      L.count:= Count;
      for I := 0 to Count-1 do
      L.Arr[i]:=  math.RandomRange(a,b);
      L.RandomExchangeList;
      Result:=true;
end;
Class function AmMath.RandomRangeAlign4Low_OlD(a,b: integer): integer;
begin
  Result:= Integer(Align4Low( Cardinal(math.RandomRange( a , b ))) );
end;
Class function AmMath.RandomRangeRoundLow(mn,mx,Amod: integer): integer;
begin
 Result:= RoundLow( math.RandomRange( mn , mx + 1 ),Amod );
 if Result>mx then
 begin
   Result:= mx;
   Result:=RoundLow(Result,Amod);
 end
 else if  Result<mn then
 begin
   Result:= mn;
   Result:=RoundHigh(Result,Amod);
 end;
end;
Class function AmMath.RandomRangeRoundHigh(mn,mx,Amod: integer): integer;
begin
 Result:= RoundHigh( math.RandomRange( mn , mx + 1),Amod );
 if Result>mx then
 begin
   Result:= mx;
   Result:=RoundLow(Result,Amod);
 end
 else if  Result<mn then
 begin
   Result:= mn;
   Result:=RoundHigh(Result,Amod);
 end;



end;
Class function AmMath.RoundLow(Value: integer;AMod:integer): integer;
begin
  Result:= Value;
  if AMod>0 then
  begin
  Value:= Value mod  AMod ;
  Result:=  Result - Value;
  end;
end;
Class function AmMath.RoundHigh(Value: integer;AMod:integer): integer;
begin
  Result:= Value;
  if AMod>0 then
  begin
  Value:= Value mod  AMod ;
  Result:=  Result + AMod - Value;
  end;
end;
Class function AmMath.Align4Low(Value: Cardinal): Cardinal;
begin
   Result := (Value + 3) and not 3;
end;
Class function AmMath.Align4High(Value: Cardinal): Cardinal;
begin
  Result:= Value;
  Value:= Value mod  4 ;
  Result:=  Result + 4 - Value;
end;

Class function AmMath.Align8Low(Value: Cardinal): Cardinal;
begin
  Result := (Value + 7) and not 7;
end;
Class function AmMath.Align16Low(Value: Cardinal): Cardinal;
begin
 Result := (Value + 15) and not 15;
end;






Class procedure   AmMusic.PlaySoundTheadFile(FileName:string);
begin
 TThread.CreateAnonymousThread( procedure
 var R:TMemoryStream;
 begin
  try
    R:=  TMemoryStream.Create;
    try
      if FileExists(FileName) then
      begin
          R.LoadFromFile(FileName);
          SndPlaySound(R.Memory, SND_MEMORY);
      end;

    finally
      R.Free;
    end;
  except

  end;
 end).Start;
end;
 Class procedure   AmMusic.PlaySoundResource(ResourceNameIndificator:string);
 var R:TResourceStream;
 begin
  try
    R:=  TamResource.CreateAndGetStream(ResourceNameIndificator);
    try

      //Ms.LoadFromFile('D:\Загрузки\1.wav');
      SndPlaySound(R.Memory, SND_MEMORY);
    finally
      R.Free;
    end;
  except

  end;
 end;
Class procedure   AmMusic.PlaySoundTheadResource(ResourceNameIndificator:string);
begin
 TThread.CreateAnonymousThread( procedure
 begin
  PlaySoundResource(ResourceNameIndificator);
 end).Start;
end;
procedure PlaySoundLocal;

begin
 TThread.CreateAnonymousThread( procedure
 var R:TResourceStream;
 begin
  try
    R:=  TamResource.CreateAndGetStream('Message_wav');
    try

      //Ms.LoadFromFile('D:\Загрузки\1.wav');
      SndPlaySound(R.Memory, SND_MEMORY);
    finally
      R.Free;
    end;
  except

  end;
 end).Start;

//   hResource:=LoadResource( hInstance, FindResource(hInstance, name, RT_RCDATA));
  //  pData := LockResource(hResource);
  //  SndPlaySound(pData, SND_MEMORY);
   // FreeResource(hResource);
     //             mciSendString(PChar('Play "D:\Загрузки\1.wav"'),nil,0,0);
end;

Class function  AmLang.IsRussianInstruction: boolean;
var s:string;
begin
     Result:=  IsRussian;
     if not Result then
     begin
       s:='Язык системы не русский'+#13#10+
       'Измените язык системы на русский'+#13#10+
       'панель управления >> региональные стандарты >> дополнительно >> изменить язык системы '+#13#10+
       'Из выподающего списка выбрать "Русский" После этого перезагрузите компьютер';
       showmessage(s);
     end;

end;
Class function  AmLang.IsRussian: boolean;
var
  i: integer;
begin
 Result:=false;
 i := Lo(GetUserDefaultUILanguage); // нижнего байта достаточно для определения языка, вида надписей на кнопках и т.п.
// Это может быть не так для экзотических языков, но с ними я не сталкивался

 case i of $19: Result:=true;end;
end;
Class Function Amfile.DirAllDelete2(Dir: string;DeleteAllFilesAndFolders:boolean=true;StopIfNotAllDeleted:boolean=true; RemoveRoot:boolean=true):boolean;
var
  i: Integer;
  SRec: TSearchRec;
  FN: string;
begin
  Result := False;
  if not DirectoryExists(Dir) then
    exit;
  Result := True;
  // Добавляем слэш в конце и задаем маску - "все файлы и директории"
  Dir := IncludeTrailingBackslash(Dir);
  i := FindFirst(Dir + '*', faAnyFile, SRec);
  try
    while i = 0 do
    begin
      // Получаем полный путь к файлу или директорию
      FN := Dir + SRec.Name;
      // Если это директория
      if SRec.Attr = faDirectory then
      begin
        // Рекурсивный вызов этой же функции с ключом удаления корня
        if (SRec.Name <> '') and (SRec.Name <> '.') and (SRec.Name <> '..') then
        begin
          if DeleteAllFilesAndFolders then
            FileSetAttr(FN, faArchive);
          Result := DirAllDelete2(FN, DeleteAllFilesAndFolders,
            StopIfNotAllDeleted, True);
          if not Result and StopIfNotAllDeleted then
            exit;
        end;
      end
      else // Иначе удаляем файл
      begin
        if DeleteAllFilesAndFolders then
          FileSetAttr(FN, faArchive);
        Result := DeleteFile(FN);
        if not Result and StopIfNotAllDeleted then
          exit;
      end;
      // Берем следующий файл или директорию
      i := FindNext(SRec);
    end;
  finally
    FindClose(SRec);
  end;
  if not Result then
    exit;
  if RemoveRoot then // Если необходимо удалить корень - удаляем
    if not RemoveDir(Dir) then
      Result := false;
end;

Class Function AmFile.DirAllDelete(Dir: string):boolean;//inline; static;
var
  CF: TSHFileOpStruct;
begin
 with CF do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SIMPLEPROGRESS  or FOF_NOCONFIRMATION;
    pFrom  := PChar(Dir + #0);
  end;
  Result := (0 = ShFileOperation(CF));
end;
Class Function AmFile.DirAllCopy(DirOld,DirNew: string):boolean;
var CF:TSHFileOpStruct;
begin
  if not FileExists(DirNew)  then
     try System.SysUtils.ForceDirectories(DirNew)except end;
   CF.Wnd:=0;
   CF.pFrom:=PWideChar(DirOld+ #0);//откуда копируем файлы для вас будет ваша папка
   CF.pTo:=PWideChar(DirNew+ #0);//куда копируем если такого каталога нет то будет предложено его создать
   CF.wFunc:=FO_COPY;//задаём флаг копирования
   CF.fFlags:=FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS or FOF_NOCONFIRMATION ;//пусть будет этот флаг
   Result:= (ShFileOperation(CF) = 0);

end;
Class function   AmFile.DirAddNew( const aPath: string):string;
begin
   if not DirectoryExists(aPath)  then
   try System.SysUtils.ForceDirectories(aPath)except end;
end;
Class Function AmFile.IsValidNameFile(F:String):boolean;
begin
    Result:= (F<>'') and (Length(F)<255) and not AmPosArray(['/','\',':','.',','],F);
end;
Class Function  AmFile.IsRelativePath(F:String):boolean;
begin
   Result:=System.SysUtils.IsRelativePath(F);
end;
Class Function AmFile.IsFile(F:String):boolean;
begin
  Result:=(F<>'') and FileExists(F);
end;
Class Function AmFile.IsPath(aPath:String):boolean;
begin
  Result:= (aPath<>'') and DirectoryExists(aPath);
end;
Class function AmFile.IsFreeFile(const FullPatch: string): Boolean;
begin
    Result:= AmFileIsFree(FullPatch);
end;
Class function AmFile.IsFreeReadFile(const FullPatch: string): Boolean;
begin
     Result:= AmFileIsFreeRead(FullPatch);
end;
Class function AmFile.GetHandleFile(AFileName: string;Mode: Word):THandle;
var
  LShareMode: Word;
begin
  if (Mode and fmCreate = fmCreate) then
  begin
    LShareMode := Mode and $FF;
    if LShareMode = $FF then
      LShareMode := fmShareExclusive;
    Result:=FileCreate(AFileName, LShareMode, 0)
  end
  else
   Result:= FileOpen(AFileName, Mode)
end;

Class function AmFile.GetHandleFileWaitFor(AFileName: string;Mode: Word;TimeOutMax:Cardinal):THandle;
begin
    Result:= GetHandleFile(AFileName,Mode);
    while (TimeOutMax>0) and  not ((Result>0) and  (Result<>INVALID_HANDLE_VALUE)) do
    begin
       sleep(500);
       Result:= GetHandleFile(AFileName,Mode);
       dec(TimeOutMax,500);
    end;
end;
Class Function AmFile.GetFileTxt(NameFile:string):string;
var L:TStringList;
begin
    if FileExists(NameFile) then
    begin
      L:=TStringlist.Create;
      try
        L.LoadFromFile(NameFile);
        Result:=L.Text;
      finally
        L.Free;
      end;
    end
    else
    begin
      raise Exception.Create('Error Message AmFile.GetFileTxt не найден файл');
    end;


end;
Class Function AmFile.ListFileDirIndexOf(Path: string; FileName: string):integer;
var L:TStringList;
begin
    L:=  TStringList.Create;
    try
       ListFileDir(Path,L);
       Result:=AmStrIndexOf(L,FileName);
    finally
      L.Free;
    end;
end;
Class procedure AmFile.ListFileDir(Path: string; FileList: TStrings);
 var
   SR: TSearchRec;
begin
 FileList.clear;
 if (Path<>'') and  (FindFirst(Path + '*.*', faAnyFile, SR) = 0) then
 begin
   repeat
     if (SR.Attr <> faDirectory) then
     begin
       FileList.Add(SR.Name);
     end;
   until FindNext(SR) <> 0;
   FindClose(SR);
 end;
end;
Class procedure AmFile.ListFileDir(Path: string;var  FileList: TArray<string>);
 var
   SR: TSearchRec;
   i:integer;
begin
 setlength(FileList,0);
 i:=0;
 if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then
 begin
   repeat
     if (SR.Attr <> faDirectory) then
     begin
       inc(i);
       setlength(FileList,i);
       FileList[i-1]:=SR.Name;

     end;
   until FindNext(SR) <> 0;
   FindClose(SR);
 end;

end;
Class procedure AmFile.ListFileDir(Path: string;FileList: TStringList);
 var
   SR: TSearchRec;
begin
 FileList.Clear;
 if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then
 begin
   repeat
     if (SR.Attr <> faDirectory) then
     begin
       FileList.Add(SR.Name);

     end;
   until FindNext(SR) <> 0;
   FindClose(SR);
 end;

end;

Class Function AmFile.SizeFile( aFile: string ):int64;
var F: TFileStream;
begin
    Result:=-1;
    try
      F:=TFileStream.Create(aFile, fmOpenRead);

      try
        Result:=F.Size;
      finally
        F.Free;
      end;
    except   end;

end;
Class function  AmFile.AddToFile     ( const aFile: string; const Msg: string ):string;
var myFile : TextFile;
begin
     //or  TFile.AppendAllText
  Result:='';
  try

      if FileExists(aFile) then
      begin
        AssignFile(myFile, aFile);
        Append(myFile);
        WriteLn(myFile, Msg);
        CloseFile(myFile);
      end
      else
      begin
        AssignFile(myFile, aFile);
        ReWrite(myFile);
        WriteLn(myFile, Msg);
        CloseFile(myFile);
      end;

  except
    On E: Exception Do
    Result:='ErrorCode Запись в файл AmFile.AddToFile' + E.ClassName + '  ' + E.Message;
  end;

end;
Class function  AmFile.CountLn( const aFile: string):int64;
var
  f: TextFile;
  S:string;
begin
 Result := -1;
 if FileExists(aFile) then
 begin
  AssignFile(f, aFile);
  Reset(f);
  Result := 0;
  while not EOF(f) do
  begin
    Readln(f,S);
    Inc(Result);
  end;
  CloseFile(f);
 end;

end;
Class function  AmFile.CountLnAtSize (  aFile: string):string;
var s:int64;
begin
    aFile:= GetFullPathFile(aFile);
    s:=SizeFile(aFile);
    if s>1024*1000*5 then Result:='размер: '+(s div (1024*1000)).tostring+' Mb'
    else if s=-1 then Result:='пока файл не создан'         
    else Result:='линий:'+ CountLn(aFile).ToString;

end;

Class function  AmFile.SizeFileStr (aFile: string):string;
begin
   Result:=SizeFileStr(SizeFile(aFile));
end;
Class function  AmFile.SizeFileStr (Size:int64):string;
begin
  Result:= SizeFileStr_def1(Size);
end;
Class function  AmFile.SizeFileStr_def1 (Size:int64):string;
begin
   if Size<kb1 then
      Result:= SizeFileStr_b(Size)
   else if Size < mb1 then
     Result:= SizeFileStr_kb(Size)
   else if Size < gb1 then
     Result:= SizeFileStr_mb(Size)
   else
    Result:= SizeFileStr_gb(Size)
end;
Class function  AmFile.SizeFileStr_b (Size: int64):string;
begin
   Result:= Size.ToString +' b';
end;
Class function  AmFile.SizeFileStr_kb (Size:int64):string;
begin
    Result:= FormatFloat('0.000',Size/kb1) +' Kb'
end;
Class function  AmFile.SizeFileStr_mb (Size:int64):string;
begin
  Result:= FormatFloat('0.000',Size/mb1) +' Mb'
end;
Class function  AmFile.SizeFileStr_gb (Size:int64):string;
begin
  Result:= FormatFloat('0.000',Size/gb1) +' Gb'
end;
Class procedure AmFile.ReCteateFile  ( aFile : String;MinSizeFile:int64=6420606);
{var RenamePatch:string;
begin
          if FileExists(aFile) then
          begin
            if SizeFile(aFile)>MinSizeFile then //6420606
            begin
              RenamePatch:= ExtractFilePath (aFile)+
                                'log_'+FormatDateTime('yy-mm-dd" "hh-mm', now)+'.txt';
               RenameFile(aFile,RenamePatch);
            end;
          end;}
var Path,FileName,Ext:string;
begin
          if FileExists(aFile) then
          begin
            if SizeFile(aFile)>MinSizeFile then //6420606
            begin
              Path:= ExtractFilePath (aFile);
              FileName:= ExtractFileName (aFile);
              Ext:= ExtractFileExt(aFile);
              FileName:=FileName.Replace(Ext,'');
              FileName:= Path+FileName+'_'+FormatDateTime('yy-mm-dd" "hh-mm', now)+Ext;
              RenameFile(aFile,FileName);
            end;
          end;
end;
Class procedure AmFile.ReCteateFileData  ( aFile : String;MinSizeFile:int64;var LastData:TDatetime;AIncHour:integer=10);
begin
    if (now > Dateutils.IncHour(LastData,AIncHour)) then
    begin
      LastData:=now;
      ReCteateFile(aFile,MinSizeFile);
    end;

end;




    // Value - ExtractFilePath(Application.ExeName)
Class function  AmFile.GetLocalPathFile( const Value: string):string;
var P:string;
begin
   P:= LocalPath;
   Result:=Value;
  if Pos(P,Result)=1 then
  delete(Result,1,length(P));
end;

    //ExtractFilePath(Application.ExeName) + aPath
Class function  AmFile.GetFullPathFile( const Value: string):string;
begin
//ExpandFileName
 // Result:=AmReg.GetValue('\w+\:\\',Value);
  if IsRelativePath(Value) then  Result:= LocalPath+Value
  else  Result:= Value;
end;

//ExtractFilePath(Application.ExeName)
Class function AmFile.LocalPath:string;
begin
    Result:=ExtractFilePath(ExePathFile.Val);
end;

Class function AmFile.ShellOpen(aPathFile:string):int64;
begin
   Result:=ShellExecute(Application.Handle, 'open', PChar(aPathFile), '', nil, SW_SHOWNORMAL);
   if Result>32 then
   SetForegroundWindow(Result);
end;
Class function AmFile.ShellOpenSelect(aPathFile:string):int64;
begin
   Result:=ShellExecute(Application.Handle, 'OPEN', 'EXPLORER', PChar('/select, '+ aPathFile), '', SW_SHOWNORMAL);
   if Result>32 then    
   SetForegroundWindow(Result);
end;


Class function AmFile.SizePath(const aPathFile: string): Int64;

var vvPath:string;
      procedure GetDirSize(const aPath: string; var SizeDir: Int64);
      var
        SR: TSearchRec;
        tPath: string;
      begin
        tPath := IncludeTrailingBackSlash(aPath);
        if FindFirst(tPath + '*.*', faAnyFile, SR) = 0 then
        begin
          try
            repeat
              if (SR.Name = '.') or (SR.Name = '..') then
                Continue;
              if (SR.Attr and faDirectory) <> 0 then
              begin
                GetDirSize(tPath + SR.Name, SizeDir);
                Continue;
              end;
              SizeDir := SizeDir +
                (SR.FindData.nFileSizeHigh shl 32) +
                SR.FindData.nFileSizeLow;
            until FindNext(SR) <> 0;
          finally
            FindClose(SR);
          end;
        end;
      end;
begin
  vvPath:= aPathFile;
  Result:=0;
  GetDirSize(vvPath,Result);
end;
{
Диск = C:
Каталог = C:\Program Files\Borland\Delphi7\Projects
Путь = C:\Program Files\Borland\Delphi7\Projects\
Имя = Unit1.dcu
Расширение = .dcu
}
//Диск = C:
Class function  AmFile.ExtractFileDisk( const Value: string):string;
begin
    Result:= System.SysUtils.ExtractFileDrive(Value);
end;

//Каталог = C:\Program Files\Borland\Delphi7\Projects
Class function  AmFile.ExtractFileDir( const Value: string):string;
begin
    Result:= System.SysUtils.ExtractFileDir(Value);
end;

//Путь = C:\Program Files\Borland\Delphi7\Projects\
Class function  AmFile.ExtractFilePath( const Value: string):string;
begin
  Result:= System.SysUtils.ExtractFilePath(Value);
end;

//Имя = Unit1.dcu
Class function  AmFile.ExtractFileName( const Value: string):string;
begin
   Result:= System.SysUtils.ExtractFileName(Value);
end;

//Расширение = .dcu
Class function  AmFile.ExtractFileExt( const Value: string):string;
begin
   Result:= System.SysUtils.ExtractFileExt(Value);
end;

{
OldName = Unit1.dcu
NewName = Unit1.new
}
Class function  AmFile.ChangeFileExt( const Value,NewExt: string):string;
begin
  Result:= System.SysUtils.ChangeFileExt(Value,NewExt);
end;




Class procedure AmUnix.SecondsToFormat(CountSeconds:int64;var Days:integer;var Hours:integer;var Minutes:integer;var Seconds:integer);
const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
begin
  Days := CountSeconds div SecPerDay;
  Hours := (CountSeconds mod SecPerDay) div SecPerHour;
  Minutes := ((CountSeconds mod SecPerDay) mod SecPerHour) div SecPerMinute;
  Seconds := ((CountSeconds mod SecPerDay) mod SecPerHour) mod SecPerMinute;
  //ms := 0;
 // Result := dd + EncodeTime(hh, mm, ss, ms);
end;
Class Function AmUnix.DateCount(CountSeconds:int64):string;
var
ss, mm, hh, dd: integer;
begin
  SecondsToFormat(CountSeconds,dd,hh,mm,ss);
  Result:=AmStr(dd)+'d '+amstr(hh)+'h '+amstr(mm)+'m '+amstr(ss)+'s';
end;
Class Function AmUnix.DateCountToSecond(DateCountString:string):int64;
const
  SecPerDay = 86400;
  SecPerHour = 3600;
  SecPerMinute = 60;
var
ss, mm, hh, dd: string;
v:string;
begin
    ss:='';
    mm:='';
    hh:='';
    dd:='';
    Result :=-1;
    v:=amreg.GetValue('\d+d',DateCountString);
    if v<>'' then  dd:= v.Replace('d','');

    v:=amreg.GetValue('\d+h',DateCountString);
    if v<>'' then  hh:= v.Replace('h','');

    v:=amreg.GetValue('\d+m',DateCountString);
    if v<>'' then  mm:= v.Replace('m','');

    v:=amreg.GetValue('\d+s',DateCountString);
    if v<>'' then  ss:= v.Replace('s','');

    if (dd<>'')and (hh<>'')and(mm<>'')and(ss<>'') then
    begin
       //Result := AmInt(dd,0) + EncodeTime(AmInt(hh,0), AmInt(mm,0), AmInt(ss,0), 0);

       Result := (AmInt(dd,0) * SecPerDay)   +   (AmInt(hh,0) * SecPerHour) +
                 (AmInt(mm,0) * SecPerMinute)   +   AmInt(dd,0);
    end;
    

end;
Class Function AmUnix.UTC_Now:TDateTime;
var
    ST : SystemTime;

begin
  GetSystemTime(ST);
  Result := EncodeDate(ST.wYear, ST.wMonth, ST.wDay) +
  EncodeTime(ST.wHour, ST.wMinute, ST.wSecond, ST.wMilliseconds);
end;
Class Function AmUnix.SecondsBetween(A,B:TDateTime):int64;
begin
    Result:= dateUtils.SecondsBetween(A,B);
end;
Class Function AmUnix.UTC_MsToDt(AUnix:Int64):TDateTime;
begin
   Result:= UnixMilliSeconds_To_DateTimeUTC(AUnix);
end;
Class Function AmUnix.UTC_DtToMs(ADateTime:TDateTime):int64;
begin
   Result:=DateTimeUTC_To_UnixMilliSeconds(ADateTime);
end;


Class Function AmUnix.DateTimeUTC_To_UnixMilliSeconds(ADateTime:TDateTime):int64;
begin
    Result:=MilliSecondsBetween(ADateTime, UnixDateDelta);
end;
Class Function AmUnix.UnixMilliSeconds_To_DateTimeUTC(AUnix:Int64):TDateTime;
begin
  Result:= IncMilliSecond(UnixDateDelta,AUnix);
end;

Class Function AmUnix.DateTime_To_Unix(ADateTime:TDateTime):int64;
begin
Result:=DateUtils.DateTimeToUnix(ADateTime,false);
end;
Class Function AmUnix.Unix_To_DateTime(AUnix:Int64):TDateTime;
begin
Result:=DateUtils.UnixToDateTime(AUnix,false);
end;
Class Function AmUnix.DateTimeUTC_To_Unix(ADateTime:TDateTime):int64;
begin
Result:=DateUtils.DateTimeToUnix(ADateTime,true);
end;
Class Function AmUnix.Unix_To_DateTimeUTC(AUnix:Int64):TDateTime;
begin
Result:=DateUtils.UnixToDateTime(AUnix,true);
end;
Class Function AmUnix.DateTimeIncTime(ADate:TDateTime;ATime:TTime):TDateTime;
begin
     Result:= ADate;
     Result:=IncHour(Result,HourOf(ATime));
     Result:=IncMinute(Result,MinuteOf(ATime));
end;
Class Function AmUnix.DateNoSpace(date,time:string):TDatetime;
    var
      wYear, wMonth, wDay: Word;
      wHour,wMin,wSec:Word;

      dt,tt: TDateTime;
begin
     dt:=0;
     Result:=0;
     wYear :=  AmInt(Copy(date, 1, 4),0);
     wMonth := AmInt(Copy(date, 5, 2),0);
     wDay :=   AmInt(Copy(date, 7, 2),0);
     if TryEncodeDate(wYear, wMonth, wDay,dt) then
     begin
            wHour :=  AmInt(Copy(time, 1, 2),0);
            wMin :=   AmInt(Copy(time, 3, 2),0);
            wSec :=   AmInt(Copy(time, 5, 2),0);
           if  TryEncodeTime(wHour,wMin,wSec,0,tt) then
           dt:=dt+ tt;
           Result:= dt;
     end;

end;

function TAmResult16.GetV(index:TIndex):TVal;
begin
    Result:=AmInt(string(FVal[index]),0);
end;
procedure TAmResult16.SetV(index:TIndex;V:TVal);
var S:String;
begin
    S:=AmStr(V);
    FVal[index]:=AnsiChar(S[1]);
end;
Procedure TAmResult16.Zero;
begin
   FVal:='';
end;

function AmArrayOfRealToJsonString(aReal:TamArrayOfReal):string;
var J:TJsonArray;
  I,M: integer;
begin
   M:= Length(aReal);
   J:=  TJsonArray.Create;
   try
     for I := 0 to M-1 do J.Add(amStr(aReal[i]));
     Result:= J.ToJSON(true);
   finally
     J.Free;
   end;
end;
function AmJsonStringToArrayOfReal(JsonString:string):TamArrayOfReal;
var J:TJsonArray;
  I: integer;
begin

   J:=  AmJson.LoadArrayText(JsonString);
   try
     SetLength(Result,J.Count);
     for I := 0 to J.Count-1 do Result[i]:= AmReal(J[I].Value,0);
   finally
     J.Free;
   end;

end;

Class function AmRectSize.__aInt(sur:string;serh:string;deff:integer):integer;
begin
   Result:=AmInt( amReg.GetValue( '\d+',  amReg.GetValue(''+ serh+'\:\d+\|',sur)  ) ,  deff  );
end;
Class function AmRectSize.RectToStr(aRect:Trect):string;
begin
   Result:= 'Left:'+aRect.Left.ToString+'|' +
            'Top:'+aRect.Top.ToString+'|' +
            'Right:'+aRect.Right.ToString+'|' +
            'Bottom:'+aRect.Bottom.ToString+'|';


end;
Class function AmRectSize.StrToRect(aStr:string):Trect;
begin
     Result:= Rect(
                    __aInt(aStr,'Left',0),
                    __aInt(aStr,'Top',0),
                    __aInt(aStr,'Right',0),
                    __aInt(aStr,'Bottom',0)
                  );
end;

Class function AmRectSize.SizeToStr(aSize:TSize):string;
begin
  Result:= PointToStr(Point(aSize.cx,aSize.cy));
end;
Class function AmRectSize.StrToSize(aStr:string):TSize;
var aPoint:TPoint;
begin
  aPoint:=StrToPoint(aStr);
  Result.cx:= aPoint.X;
  Result.cy:= aPoint.Y;
end;

Class function AmRectSize.PointToStr(aPoint:TPoint):string;
begin
   Result:= 'X:'+aPoint.X.ToString+'|' +
            'Y:'+aPoint.Y.ToString+'|' ;
end;
Class function AmRectSize.StrToPoint(aStr:string):TPoint;
begin
     Result:= Point(
                    __aInt(aStr,'X',0),
                    __aInt(aStr,'Y',0)
                  );
end;


       {TAmTreeViewHlp}
constructor TAmTreeViewHlp.Create(L:TTreeView);
begin
   inherited Create;
   FL:= L;
end;
procedure TAmTreeViewHlp.Clear;
begin
    SendMessage(FL.Handle, WM_SETREDRAW, 0, 0);
    FL.Items.Clear;
    SendMessage(FL.Handle, WM_SETREDRAW, 1, 0);
    InvalidateRect(FL.Handle, nil, True);
end;

function TAmTreeViewHlp.LoadJson(Base:TJsonBaseObject;IsNeedType:boolean):boolean;
begin
      if not Assigned(Base) then exit(false);
     Result:=true;
     Clear;
     if Base is TJsonObject then
     L_Obj(TJsonObject(Base),nil,IsNeedType)
     else if Base is TJsonArray  then
     L_Arr(TJsonArray(Base),nil,IsNeedType)
     else Result:=false;
          
end;
procedure TAmTreeViewHlp.L_Obj(J:TJsonObject;AParent:TTreeNode;IsNeedType:boolean);
var i:integer;
Item:TTreeNode;
begin
    for I := J.Count-1 downto 0 do
    begin
         Item:=FL.Items.AddChildFirst(AParent,J.Names[i]);


         if       J.Items[i].Typ = jdtObject then     L_Obj(J.Items[i].ObjectValue,Item,IsNeedType)
         else if  J.Items[i].Typ = jdtArray then      L_Arr(J.Items[i].ArrayValue,Item,IsNeedType)
         else                                         L_Value(J.Items[i],Item,IsNeedType);
    end;
      
end;
procedure TAmTreeViewHlp.L_Arr(J:TJsonArray;AParent:TTreeNode;IsNeedType:boolean);
var i:integer;
Item:TTreeNode;
begin
    for I := J.Count-1 downto 0 do
    begin
         Item:=FL.Items.AddChildFirst(AParent,'['+I.ToString+']');

         if       J.Items[i].Typ = jdtObject then     L_Obj(J.Items[i].ObjectValue,Item,IsNeedType)
         else if  J.Items[i].Typ = jdtArray then      L_Arr(J.Items[i].ArrayValue,Item,IsNeedType)
         else                                         L_Value(J.Items[i],Item,IsNeedType);
    end;

end;
class function TAmTreeViewHlp.ParsValueToParam(ValueInput:string;out NameVar:string; out NameType:string; out Value:string):boolean;
var pos_b,pos_e,pos_v:integer;
begin
     {var and type not " :   'VarName:Integer="Value";'
                             'VarName:Integer}
         Result:=false;
         Value:= '';
         NameVar:= '';
         NameType:= '';

    if ValueInput='' then exit;
   // ValueInput:= 'id:TAmIntB64;';
    pos_v:= pos(':',ValueInput);
    pos_b:= pos('="',ValueInput,pos_v);
    pos_e:=PosR2('"',ValueInput);

    if (pos_b+2< pos_e) and (pos_v< pos_b)  then
    begin
         Value:= copy(ValueInput,pos_b+2,(pos_e-pos_b-2));
         NameVar:= copy(ValueInput,1,pos_v-1);
         NameType:= copy(ValueInput,pos_v+1,pos_b-pos_v-1);
         Result:=true;
    end
    else if (pos_e=0) and (pos_v>0)  then
    begin
         pos_e:=PosR2(';',ValueInput);
         if (pos_v>0) then
         begin
         NameVar:= copy(ValueInput,1,pos_v-1);
         NameType:= copy(ValueInput,pos_v+1,pos_e-pos_v-1);
         Result:=true;
         end;
    end;
         


end;
procedure TAmTreeViewHlp.L_Value(V:PJsonDataValue;AParent:TTreeNode;IsNeedType:boolean);
var S:string;
    function Loc_GetValue(T,V:string):string;
    begin
      if IsNeedType then
       Result:= AParent.Text + ':'+T+'="'+V+'";'
       else
       Result:= AParent.Text + '="'+V+'";';
    end;
begin
 //  AParent.Text;
    case V.Typ of
       { jdtString:      FL.Items.AddChildFirst(AParent,'String:'+V.Value);
        jdtInt:         FL.Items.AddChildFirst(AParent,'Int:'+AmStr(V.IntValue));
        jdtLong:        FL.Items.AddChildFirst(AParent,'Int64:'+AmStr(V.LongValue));
        jdtULong:       FL.Items.AddChildFirst(AParent,'UInt64:'+AmStr(Int64(V.ULongValue)));
        jdtFloat:       FL.Items.AddChildFirst(AParent,'Float:'+AmStr(V.FloatValue));
        jdtDateTime:    FL.Items.AddChildFirst(AParent,'DateTime:'+AmStr(V.DateTimeValue));
        jdtUtcDateTime: FL.Items.AddChildFirst(AParent,'UtcDateTime:'+AmStr(V.UtcDateTimeValue));
        jdtBool:        FL.Items.AddChildFirst(AParent,'Bool:'+AmStr(V.BoolValue));
           }
        jdtString:        AParent.Text :=  Loc_GetValue('String',V.Value);
        jdtInt:         AParent.Text :=   Loc_GetValue('Integer',AmStr(V.IntValue));
        jdtLong:        AParent.Text :=   Loc_GetValue('Int64',AmStr(V.LongValue));
        jdtULong:       AParent.Text :=   Loc_GetValue('UInt64',AmStr(Int64(V.ULongValue)));
        jdtFloat:       begin
                          if IsNan(V.FloatValue)  then
                           AParent.Text :=   Loc_GetValue('Float','0')
                           else
                           AParent.Text :=   Loc_GetValue('Float',AmStr(V.FloatValue));
        end;

        jdtDateTime:    begin
                          if IsNan(V.DateTimeValue) then
                           AParent.Text :=   Loc_GetValue('DateTime',AmStr(TDateTime(0)))
                           else
                           AParent.Text :=   Loc_GetValue('DateTime',AmStr(V.DateTimeValue));
        end;
        jdtUtcDateTime: AParent.Text :=   Loc_GetValue('UtcDateTime',AmStr(V.UtcDateTimeValue));
        jdtBool:        AParent.Text :=   Loc_GetValue('Bool',AmStr(V.BoolValue));
    end;
end;




Class procedure amJson.CaseLoad(Source:Pointer;
                                ACase:integer;
                                var J:TJsonBaseObject;
                                Error:PAmRecMsgError);
var s:string;
begin
     if Assigned(Error) then
     begin
        Error.IsError:=false;
        Error.Msg:='';
     end;
     J:=nil;
     try
         try
              case ACase of
                     1: J:=TJsonBaseObject.Parse(PString(Source)^);
                     2:begin
                         if FileExists(PString(Source)^) then
                         J:=TJsonBaseObject.ParseFromFile(PString(Source)^,false)
                         else raise Exception.Create('Error amJson.CaseLoad not file '+PString(Source)^);
                     end;
                     3: J:=TJsonBaseObject.ParseFromStream(TStream(Source),nil,false);
                     else
                     raise Exception.Create('Error amJson.CaseLoad ACase invalid')
              end;
              if Assigned(J) then
              begin
        
                 if J is Tjsonobject then
                 begin
                     s:=Tjsonobject(J)['TestLoadString1234567890']['TestLoadString1234567890'].Value;
                     Tjsonobject(J).Remove('TestLoadString1234567890');
                 end
                 else  if not ( J is Tjsonarray ) then
                 raise Exception.Create('Error amJson.CaseLoad Obj is not [Tjsonarray, Tjsonobject]')

              end
              else raise Exception.Create('Error amJson.CaseLoad not Create Object')
         except
           on e:exception do
           raise Exception.Create(e.Message);
         end;

     except
       on e:exception do
       begin
         J:=  Tjsonobject.create;
         if Assigned(Error) then
         begin
            Error.IsError:=true;
            Error.Msg:=e.Message;
            Error.StackTraceAM:=e.StackTrace;
         end;
       end;
     end;

end;
Class function amJson.LoadStreamBase(Stream: TStream;Error:PAmRecMsgError=nil):TJsonBaseObject;
begin
    CaseLoad(Pointer(Stream),3,Result,Error);
end;
Class function amJson.LoadFileBase(FileNameFull:string;Error:PAmRecMsgError=nil):TJsonBaseObject;
begin
    CaseLoad(@FileNameFull,2,Result,Error);
end;
Class function amJson.LoadTextBase(TextJson:string;Error:PAmRecMsgError=nil):TJsonBaseObject;
begin
    CaseLoad(@TextJson,1,Result,Error);
end;
Class function amJson.LoadObjectText(TextJson:string;Error:PAmRecMsgError=nil):TJsonObject;
var E:TAmRecMsgError;
    J:TJsonBaseObject;
begin
     if not Assigned(Error) then  Error:= @E;
     J:=LoadTextBase(TextJson,Error);
     if Assigned(J) and (J is TJsonObject) then Result:=  TJsonObject(J)
     else
     begin
        if not Error.IsError then
        begin
          Error.IsError:=true;
          Error.Msg:='Error.amJson.LoadObjectText Object is Array';
        end;
        if Assigned(J) then J.Free;
        Result:= TJsonObject.Create;
     end;
end;
Class function amJson.LoadObjectFile(FileNameFull:string;Error:PAmRecMsgError=nil):TJsonObject;
var E:TAmRecMsgError;
    J:TJsonBaseObject;
begin
     if not Assigned(Error) then  Error:= @E;
     J:=LoadFileBase(FileNameFull,Error);
     if Assigned(J) and (J is TJsonObject) then Result:=  TJsonObject(J)
     else
     begin
        if not Error.IsError then
        begin
          Error.IsError:=true;
          Error.Msg:='Error.amJson.LoadObjectFile Object is Array';
        end;
        if Assigned(J) then J.Free;
        Result:= TJsonObject.Create;
     end;
end;
Class function amJson.LoadObjectStream(Stream: TStream;Error:PAmRecMsgError=nil):TJsonObject;
var E:TAmRecMsgError;
    J:TJsonBaseObject;
begin
     if not Assigned(Error) then  Error:= @E;
     J:=LoadStreamBase(Stream,Error);
     if Assigned(J) and (J is TJsonObject) then Result:=  TJsonObject(J)
     else
     begin
        if not Error.IsError then
        begin
          Error.IsError:=true;
          Error.Msg:='Error.amJson.LoadObjectStream Object is Array';
        end;
        if Assigned(J) then J.Free;
        Result:= TJsonObject.Create;
     end;
end;
Class function amJson.LoadArrayText(TextJsonArray:string;Error:PAmRecMsgError=nil):TJsonArray;
var E:TAmRecMsgError;
    J:TJsonBaseObject;
begin
     if not Assigned(Error) then  Error:= @E;
     J:=LoadTextBase(TextJsonArray,Error);
     if Assigned(J) and (J is TJsonArray) then Result:=  TJsonArray(J)
     else
     begin
        if not Error.IsError then
        begin
          Error.IsError:=true;
          Error.Msg:='Error.amJson.LoadArrayText Array is Object';
        end;
        if Assigned(J) then J.Free;
        Result:= TJsonArray.Create;
     end;
end;
Class function amJson.LoadArrayFile(FileNameFull:string;Error:PAmRecMsgError=nil):TJsonArray;
var E:TAmRecMsgError;
    J:TJsonBaseObject;
begin
     if not Assigned(Error) then  Error:= @E;
     J:=LoadFileBase(FileNameFull,Error);
     if Assigned(J) and (J is TJsonArray) then Result:=  TJsonArray(J)
     else
     begin
        if not Error.IsError then
        begin
          Error.IsError:=true;
          Error.Msg:='Error.amJson.LoadArrayFile Array is Object';
        end;
        if Assigned(J) then J.Free;
        Result:= TJsonArray.Create;
     end;

end;
Class function amJson.LoadArrayStream(Stream: TStream;Error:PAmRecMsgError=nil):TJsonArray;
var E:TAmRecMsgError;
    J:TJsonBaseObject;
begin
     if not Assigned(Error) then  Error:= @E;
     J:=LoadStreamBase(Stream,Error);
     if Assigned(J) and (J is TJsonArray) then Result:=  TJsonArray(J)
     else
     begin
        if not Error.IsError then
        begin
          Error.IsError:=true;
          Error.Msg:='Error.amJson.LoadArrayStream Array is Object';
        end;
        if Assigned(J) then J.Free;
        Result:= TJsonArray.Create;
     end;
end;
Class function amJson.ArrRealToStr(aReal: TamArrayOfReal):string;
begin
   Result:=AmArrayOfRealToJsonString(aReal);
end;
Class function amJson.ArrStrToReal(Str: string):TamArrayOfReal;
begin
   Result:= AmJsonStringToArrayOfReal(Str);
end;
Class function amJson.IsDataType(P:TJsonDataValueHelper;Typ:TJsonDataType):boolean;
begin
  Result:= P.Typ =Typ;
end;
Class function amJson.ToNodeJsonText(L:TTreeView;JsonText:String;IsNeedType:boolean):boolean;
var Base:  TJsonBaseObject;
begin
    Base:= LoadTextBase(PWideChar(JsonText));
    try
       Result:=ToNode(L,Base,IsNeedType);
    finally
      Base.free;
    end;
end;
Class function  amJson.ValueNodeToNameVarTypeValue(ValueInput:string;out NameVar:string; out NameType:string; out Value:string):boolean;
begin
    Result:=TAmTreeViewHlp.ParsValueToParam(ValueInput,NameVar,NameType,Value);
end;
Class function amJson.ToNode(L:TTreeView;Base:TJsonBaseObject;IsNeedType:boolean):boolean;
var C:TAmTreeViewHlp;
begin
  C:=  TAmTreeViewHlp.create(L);
  try
  Result:=  C.LoadJson(Base,IsNeedType);
  finally
    C.free;
  end;
end;
Class function amJson.ToStrNull(const F:TJsonDataValueHelper):string;
begin
    Result:='';
    if not F.IsNull then
    Result:= F.Value;
    {
    begin
       if (F.Typ in [ jdtArray, jdtObject])  then
       begin
          case F.Typ of
               jdtArray: Error:=  'Error amJson.ToStr Value is Array path['+F.Patch3+']';
               jdtObject: Error:=  'Error amJson.ToStr Value is Object path['+F.Patch3+']';
          end;

       end
       else Result:= F.Value
    end;
     }
end;
Class function amJson.ToStrOA(const F:TJsonDataValueHelper):string;
begin
    Result:='';
    if not F.IsNull then
    begin
       if (F.Typ in [ jdtArray, jdtObject])  then
       begin
          case F.Typ of
               jdtArray: Result:=  'jdtArray';
               jdtObject: Result:=  'jdtObject';
          end;

       end
       else Result:= F.Value
    end;

end;

Class function amSerch.InterpolationInt(
                                          SerchInteger:integer;
                                          CountBegin,
                                          CountEnd:integer;
                                          MaxIndex:boolean;
                                          var Iter:integer;
                                          FunGetElem:TfunInt
                                          ):integer;
var
  L, H, I, C, F: Integer;
  S:boolean;
begin
  Result := -1;
  S := False;
  L := CountBegin;
  H := CountEnd;
  Iter := 0;

  while L <= H do
    begin

      Inc(Iter);
      if L = H then I := L else
        begin
          F := FunGetElem(L);
          I := L + ((SerchInteger - F) * (H - L)) div (FunGetElem(H) - F);
        end;
    //  if I<0 then I:=0;  // иногда без этих строк вылазит за границы массива и ошибку выдает
    //  if I>CountEnd then I:=CountEnd;

      C := FunGetElem(I) - SerchInteger;
      if C < 0 then L := I + 1 else
        begin
          H := I - 1;
          if C = 0 then
            begin

              L := I;
              S := True;
            end;
        end
    end;
  if MaxIndex or S then  Result := L;

end;
Class function amSerch.RecurceFind(L, R: Integer;FunctionSerch:TfunInt;MaxIndex:boolean): Integer;
  var
    M: Integer;
    Fs:integer;
  begin
    //inc(Iter);
    if R < L then
    begin
      if MaxIndex then Result := L
      else Result := -1; //eсли поиск точный
     // logmain.Log('BinaryIndex  точный ResultIndex='+Result.ToString);
      Exit;
    end;
    M := (L + R) div 2;

    Fs:=FunctionSerch(M);
    //logmain.Log('BinaryIndex  точный Fs='+Fs.ToString);
    if Fs=0 then
    begin
      Result := M;
     // logmain.Log('BinaryIndex ResultIndex='+Result.ToString);
      Exit;
    end
    else if Fs>0 then Result := RecurceFind(L, M - 1,FunctionSerch,MaxIndex)
    else              Result := RecurceFind(M + 1, R,FunctionSerch,MaxIndex)



   (* if Fs=1{=} then
    begin
      Result := M;
      Exit;
    end
    else if Fs=2{>} then
    begin
       Result := RecurceFind(L, M - 1)
    end
    else if Fs=3{<} then
    begin
        Result := RecurceFind(M + 1, R)
    end
    else
    begin
      {error сюда код не должен заходить}
      Result := -1000;
      Exit;
    end;  }
     *)



   { if A[M] = X then
    begin
      Result := M;
      Exit;
    end;
    if A[M] > X then
      Result := RecurceFind(L, M - 1)
    else
      Result := RecurceFind(M + 1, R)  }
  end;
Class function  amSerch.BinaryIndex(CountBegin,CountEnd:integer;MaxIndex:boolean;var Iter:integer;  FunSerch:TfunInt):integer;


begin
   Iter:=0;
  Result:=-1;
  try
   Result := RecurceFind(CountBegin, CountEnd,FunSerch,MaxIndex);
  except
    logmain.Log('BinaryIndex ErrorRRRRRRRRRRRRRRRRRRRRRRRRRRRRR='+Result.ToString);
  end;

end;
Class function  amSerch.Json_Bin_StrToInt_IndexOf(var Index:integer;SerchInt:integer;Arr:TJsonArray):boolean;
begin
    Result:= amSerch.BinaryIndex3(Index,0,Arr.Count-1,
    function(ind:integer):real
    var p,p2:integer;
    var C:string;
    begin
      C:= Arr[ind].Value;
      p:= AmInt(C,-1);
      p2:= SerchInt;
      Result:= p-p2 ;
    end);

end;
Class function  amSerch.Json_Bin_Str_IndexOf(var Index:integer;SerchString:string;Arr:TJsonArray):boolean;
begin
    Result:= amSerch.BinaryIndex3(Index,0,Arr.Count-1,
    function(ind:integer):real
    var C:string;
    begin
      C:= Arr[ind].Value;
      Result:=AnsiCompareStr(C,SerchString);
    end);

end;

Class function  amSerch.StrList_Bin_KeyValue_IndexOf(ListTxt:TStringList;SerchKey,Denlim:string;MaxIndex:boolean):integer;
var Iter: Integer;
begin
      if (Denlim='') or (SerchKey='')  then  exit(-1);
      Result:= BinaryIndex2(0,ListTxt.Count-1,MaxIndex,Iter,
      function(ind:integer):Real
      var s:string;
      begin
        s:= ListTxt[ind];
        if pos(Denlim,s)<>0 then
        begin
          s:=s.Split([Denlim])[0];
        end;

        Result:=AnsiCompareStr(s,SerchKey);
       {  if s = Port then  Result:=0
         else if s < Port then Result:=-1
        else Result:=1 }

      end);

end;

     //добавление в стринг лист новое значение с вычеслением индекса куда нужно добавить key value что бы список остался отсортированным
Class function  amSerch.StrList_Bin_AddSort(ListTxt:TStringList;Key,Value,Denlim:string):integer;
begin
           if (Denlim='') or (Key='')  then  exit(-1);
           Result:= StrList_Bin_KeyValue_IndexOf(ListTxt,Key,Denlim,true);
           if (Result<0) or (Result>ListTxt.Count-1)  then ListTxt.Add(Key+Denlim+Value)
           else ListTxt.Insert(Result,Key+Denlim+Value);
end;
Class procedure   amSerch.Bin_IsAdd(var IsNeedAdd:boolean;var IndexInsert:integer;CountEnd:integer;FunSerch:amSerch.TfunReal) ;
var Iter: Integer;
begin
       IndexInsert:= BinaryIndex2(0,CountEnd,true,Iter,FunSerch);
       IsNeedAdd:= (IndexInsert<0) or (IndexInsert>CountEnd);
end;
Class function  amSerch.BinaryIndex3_d(var FoundIndex:integer; IndexBegin,IndexEnd:integer; FunSerch:amSerch.TfunReal):boolean;
  var
  L, H: Integer;
  mid: Integer;
  cmp:real;
begin

  Result := False;
  L := IndexBegin;
  H := IndexBegin + IndexEnd;
  while L <= H do
  begin
    mid := L + (H - L) shr 1;
    cmp := FunSerch(mid);
    if cmp < 0 then
      L := mid + 1
    else
    begin
      H := mid - 1;
      if cmp = 0 then
        Result := True;
    end;
  end;
  FoundIndex := L;

end;

Class function  amSerch.BinaryIndex3(var FoundIndex:integer; IndexBegin,IndexEnd:integer; FunSerch:amSerch.TfunReal):boolean;
//var
 // L, H, I, C: Integer;
  var
  L, H: Integer;
  mid: Integer;
  cmp:real;
begin

  Result := False;
  L := IndexBegin;
  H := IndexBegin + IndexEnd;
  while L <= H do
  begin
    mid := L + (H - L) shr 1;
    cmp := FunSerch(mid);
    if cmp < 0 then
      L := mid + 1
    else
    begin
      H := mid - 1;
      if cmp = 0 then
        Result := True;
    end;
  end;
  FoundIndex := L;


(*
  Index := -1;
  Result := False;
  L := CountBegin;
  H := CountEnd;
  //{$ifdef algorithm_debug}
  //Iter := 0;
  //{$endif}
  while L <= H do
  begin
   // {$ifdef algorithm_debug}
   // Inc(Iter);
    //{$endif}
  //  logmain.Log('BinaryIndex2  1');
    I := (L + H) shr 1;
   //  logmain.Log('BinaryIndex2  2');
    C := FunSerch(I);
    // logmain.Log('BinaryIndex2  3');
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  //  logmain.Log('BinaryIndex2  4');
  end;
  Index := L;

  *)

end;
Class function  amSerch.BinaryIndex2(CountBegin,CountEnd:integer;MaxIndex:boolean;var Iter:integer;  FunSerch:amSerch.TfunReal):integer;  //inline;static;
var
  I: Integer;
  R,OneIt:boolean;
begin
  Result := -1;
  R := BinaryIndex3(I,CountBegin,CountEnd,FunSerch);
  OneIt:= CountBegin <= CountEnd ;
  if OneIt and (MaxIndex or R) then
  Result := I;
end;

Class function amSerch.StepMinMax(Count:integer;PredIndex:integer; FunSerch:Tfun):integer;
var i: integer;
   EndUp,EndDown:integer;
   GoUp,GoDown:boolean;

begin
  //функция ищет index в списке когда уже примерно известен index
  // делает шаг PredIndex-1 потом PredIndex+1 и.д
  // если не найден то -1 вернет

  {      функция сравнения может быть такой
         Value:='....';
         index:=amSerch.StepMinMax (
                      memo3.Lines.count,
                      12,
                      function (ind:integer) :boolean begin  Result:= memo3.Lines[ind]=Value end
         );


            function (ind:integer) :boolean;
            begin
              Result:= ListUser['Data']['List'].Items[ind][PoleName]=Value
            end;

  }
  Result:=-1;
  if PredIndex<0 then  PredIndex:=0;

  EndUp:=PredIndex;
  EndDown:=PredIndex+1;
  if EndUp>=Count  then EndUp:= Count-1;
  if EndDown<0  then EndDown:= 0;

  GoUp:=true;
  GoDown:=true;

   I := 1;
   //x:=0;
   while (Count>0) and ( GoUp or  GoDown )  do
   begin
     // inc(x);

       if (i = 1) and GoUp then
       begin

           if GoDown then i:=2;
           if (EndUp>=0) then
           begin
             if  FunSerch(EndUp) then
             begin
              Result:= EndUp;
              break;
             end;
             dec(EndUp);

           end else GoUp:=false;

       end
       else if (i = 2 ) and GoDown then
       begin
           if GoUp then i:=1;
           if (EndDown < Count) then
           begin
             if  FunSerch(EndDown) then
             begin
              Result:= EndDown;
              break;
             end;
             inc(EndDown);
           end else GoDown:=false;
       end;

      // else break;



   end;
  //logmain.Log('Count iteration='+x.tostring);
end;
Class function  amSerch.Json_StepMinMax_Object_IndexOf(Arr:TJsonArray;Pole:String;Value:String;PredIndex:integer):integer;
//var C:integer;
begin
  Result:=-1;
  try

         if Pole='' then exit;
         Result:=amSerch.StepMinMax (
                      Arr.Count,
                      PredIndex,
                      function (ind:integer) :boolean
                      begin  Result:= Arr[ind][Pole].Value=Value end
         );

  except
  showmessage('Error amSerch.Json_StepMinMax_Object_IndexOf');

  end;
 // AmLogTo.AmLog('Json_StepMinMax_Object_IndexOf'+C.ToString);
end;




Function MouseControlAtPos(Pos:TPoint;WC:TWincontrol=nil):TControl;
var
 cl,cl_tmp:TControl;
begin
 Result:=nil;
 if Assigned(WC) then
 begin
    cl := WC.ControlAtPos(WC.ScreenToClient(Pos),true,true);
    while assigned(cl) and (cl is TWinControl) do
    begin
     cl_tmp:=TWinControl(cl).ControlAtPos(TWinControl(cl).ScreenToClient(Pos),true,true);
     if assigned(cl_tmp) then cl:=cl_tmp else break;
    end;
    Result:=cl;
 end
 else
 begin
 


  if Screen.ActiveForm<>nil then
   with Screen.ActiveForm do
   begin
    cl := ControlAtPos(ScreenToClient(Pos),true,true);
    while assigned(cl) and (cl is TWinControl) do
    begin
     cl_tmp:=TWinControl(cl).ControlAtPos(TWinControl(cl).ScreenToClient(Pos),true,true);
     if assigned(cl_tmp) then cl:=cl_tmp else break;
    end;
    Result:=cl;
   end;
 end;

end;
Function MouseInControl(WC:TWincontrol;IsCanFocus:boolean=true):boolean;
var x1,x2,y1,y2:INTEGER;
ptm:tpoint;
begin
 Result:=false;
 if not  Assigned(WC) then exit;
 if IsCanFocus and not WC.CanFocus then   exit;

 ptm:=Mouse.CursorPos;
 x1:=Wc.ClientOrigin.x; //top-left
 y1:=Wc.ClientOrigin.y;
 x2:=x1+Wc.ClientWidth;
 y2:=y1+Wc.ClientHeight;
 result:=(ptm.x>=x1) and (ptm.x<=x2) and (ptm.y>=y1)and(ptm.y<=y2);
end;
function MouseForControl(AControl: TWinControl): TPoint;
var
  P: TPoint;
begin
  GetCursorPos(P);
  ScreenToClient(AControl.Handle, P );
  result := P;
end;

constructor TamResource.Create;
begin
   inherited create;
   cS  := tevent.create(nil, false, true, '');
end;
destructor TamResource.Destroy;
begin
   cS.Free;
   inherited Destroy;
end;
procedure TamResource.CsOpen;
begin
    cS.WaitFor(infinite);
end;
procedure TamResource.CsClose;
begin
     cS.SetEvent;
end;
Class function    TamResource.LoadToPicture(Picture: TPicture;ResourceNameIndificator:string):boolean;
var Stream:TStream;
begin
    REsult:=False;
    Stream:=AmUSerType.TamResource.CreateAndGetStream(ResourceNameIndificator);
    Try
      try
      Picture.LoadFromStream(Stream);
      REsult:=true;
      except

      end;
    Finally
       Stream.Free;
    End;
end;
Class function    TamResource.CreateAndGetStream(ResourceNameIndificator:string):TResourceStream;
begin
     Result := TResourceStream.Create(hInstance, ResourceNameIndificator, RT_RCDATA);

end;
function    TamResource.GetStreamCs(ResourceNameIndificator:string):TResourceStream;
begin
  CsOpen;
  try
       Result :=CreateAndGetStream(ResourceNameIndificator);
  finally
    CsClose;
  end;

end;
Class function    TamResource.GetString(var ResultText:string; ResourceNameIndificator:string):boolean;
var Stream:TStream;
//List:Tstringlist;
Arr:Tbytes;
begin
   ResultText:='';
   Result:=false;
   try
    Stream := TResourceStream.Create(hInstance, ResourceNameIndificator, RT_RCDATA);
    //List:= Tstringlist.Create;
    try
       Stream.Position:=0;
       setlength(Arr,Stream.Size);
       Stream.Read(Arr,Stream.Size) ;

    //  List.LoadFromStream(Stream);
       ResultText:= AmStr(Arr);
       Result:=true;
    finally
      Stream.Free;
     // List.Free;
    end;
   except

   end;

end;
Class function    TamResource.GetBytes_for_ArrByte(const FileNameExe:string; ResourceNameIndificator:string;L:Pointer):boolean;
var P:PArrByte;
    Phlp:TArrByteHlp;
    Strm:TResourceStream;
    HandleModul:Cardinal;
begin
    P:= PArrByte(L);
    P.InitCheck;
    Phlp.List:= P;
    result:=false;
    try
         if FileNameExe <> '' then
         HandleModul:= LoadLibrary(PChar(FileNameExe))
         else HandleModul:= hInstance;
         if HandleModul=0 then exit;
         try
                Strm:=TResourceStream.Create(HandleModul, ResourceNameIndificator, MakeIntResource(10));
                try
                   Phlp.StreamToBytes(Strm);
                   result:=true;
                finally
                  Strm.Free;
                end;
         finally
            if FileNameExe <> '' then
            FreeLibrary(HandleModul);
         end;
    except end;
end;

function   TamResource.GetStringCs(var ResultText:string; ResourceNameIndificator:string):boolean;
begin
  CsOpen;
  try
       Result :=GetString(ResultText,ResourceNameIndificator);

  finally
    CsClose;
  end;
end;
Class function    TamResource.UpdateExe_for_ArrByte(FileNameExe, ResourceNameIndificator:string;L:Pointer):boolean;
var P:PArrByte;
poi:Pointer;
ms:TMemoryStream;
begin
   p:= PArrByte(L);
   ms:=TMemoryStream.Create;
   try
      poi:= P.ArrayInstancePointer;
      ms.Write(poi^,p.Count);
      ms.Position:=0;
      Result:=UpdateExe(FileNameExe,ResourceNameIndificator,ms,MakeIntResource(10));
   finally
     ms.Free;
   end;
end;
Class function    TamResource.UpdateExe(FileNameExe, ResourceNameIndificator:string;data: TStream;AType: PChar):boolean;
var
  hFile: HWND;
  Buf: array of Byte;
begin
  Result:=false;
  try
    //if AType=nil then
    //AType:= RT_RCDATA;


    hFile := BeginUpdateResourceW(Pchar(FileNameExe), False);
    try
     if hFile = 0 then
      begin
        exit;//RaiseLastOSError;
      end;
      SetLength(Buf, data.Size);
      data.Position := 0;
      data.Read(Buf[0], data.Size);
      if not UpdateResourceW(hFile, MakeIntResource(10), Pchar(ResourceNameIndificator),0, @Buf[0],  // AType: PChar =  RT_RCDATA
        data.Size) then
        exit;//RaiseLastOSError;

      Result:=true;
    finally
      EndUpdateResourceW(hFile, False);
      Finalize(Buf);
    end;
  except

  end;

end;






Class function  AmBase64.Base64ToStream(S:TStream;value:string):boolean;
var coder: TIdDecoderMIME;
begin
  Result:=false;
  if length(value)>0 then begin
        value :=value.Replace(#10,'');
        value :=value.Replace(#13,'');
  end
  else exit;

  coder:= TIdDecoderMIME.Create(nil);
  try

        try
            coder.DecodeBegin(S);
            coder.Decode(value);
            coder.DecodeEnd;
            if S.Size>0 then
            begin
               s.Position:=0;
               Result:=true;
            end;
        except
        end;
  finally
    coder.Free;
  end;


end;
Class function   AmBase64.StreamToBase64(S:TStream;var value:string):boolean;
var coder: TIdEncoderMIME;
begin
  Result:=false;
  value:='';
  coder:= TIdEncoderMIME.Create(nil);
  try
    if S.Size>0 then  S.Position:=0
    else exit;
    
     try
      value :=coder.Encode(S);

      if length(value)>0 then
      begin
      value :=value.Replace(#10,'');
      value :=value.Replace(#13,'');
      Result:=true;
      end;
     except

     end;


  finally
    coder.Free;
  end;
   if S.Size>0 then  S.Position:=0;

end;


Class procedure AmReg.GetAllValue(var Arr:TArray<string>;Regulur,Input:string);
var Col:TMatchCollection;
I:integer;
begin

   Col:= TregEx.Create(Regulur).Matches(Input);
   setlength(Arr,Col.Count);
   for I := 0 to Col.Count-1 do Arr[i]:=  Col[i].Value;

end;
Class function AmReg.GetValue(Regulur,Input:string):string;
begin
   Result:=TregEx.Create(Regulur).Match(Input).Value;
end;
Class function AmReg.Replace(Regulur,Input,Replaced:string):string;
begin
    Result:=TregEx.Create(Regulur).Replace(Input,Replaced);
end;
function InvertS(const S: string): string;
{Инверсия строки S}
var
i, Len: Integer;
begin
  Len := Length(S);
  SetLength(Result, Len);
  for i := 1 to Len do
    Result[i] := S[Len - i + 1];
end;
function PosR2( const FindS, SrcS: string;offset:integer=1): Integer;
{Функция возвращает начало последнего вхождения
 подстроки FindS в строку SrcS, т.е. первое с конца.
 Если возвращает ноль, то подстрока не найдена.
 Можно использовать в текстовых редакторах
 при поиске текста вверх от курсора ввода.}



var
  ps: Integer;
//  s:string;
begin
  {Например: нужно найти последнее вхождение
   строки 'ро' в строке 'пирожок в коробке'.
   Инвертируем обе строки и получаем
     'ор' и 'екборок в кожорип',
   а затем ищем первое вхождение с помощью стандартной
   функции Pos(Substr, S: string): string;
   Если подстрока Substr есть в строке S, то
   эта функция возвращает позицию первого вхождения,
   а иначе возвращает ноль.}
  //SrcS:= InvertS(SrcS);

  ps := Pos(InvertS(FindS), InvertS(SrcS),offset);
  {Если подстрока найдена определяем её истинное положение
   в строке, иначе возвращаем ноль}
  if ps <> 0 then
    Result := Length(SrcS) - Length(FindS) - ps + 2
  else
    Result := 0;
end;

class function amSendMessage.SendTimeOut(aHandle,Msg,WParam,Lparam:Cardinal;TimeOut:UINT=2000):Lresult;
var
     Pw             : WinApi.Windows.PDWORD_PTR;
     Re             : DWORD;
begin 
//     Result:=0;
     Re:=0;
     Pw:=@Re;
     Result:=SendMessageTimeout(aHandle,Msg,WParam,Lparam,SMTO_NORMAL,TimeOut,Pw);
     if Result>0 then Result:= Pw^;
end;
class function amSendMessage.Def(aHandle,Msg,WParam,Lparam:Cardinal;var ResultMsg:DWORD;TimeOut:UINT=2000):Lresult;
var  Pw: WinApi.Windows.PDWORD_PTR;
begin
//     Result:=0;
     ResultMsg:=0;
     Pw:=@ResultMsg;
     Result:=SendMessageTimeout(aHandle,Msg,WParam,Lparam,SMTO_NORMAL,TimeOut,Pw);
end;

constructor TamPostMessageResult<T1,T2>.Create;
begin
   inherited Create ;
   InitObject:=Byte(ConstInitObject);
   FEventSend:=TEvent.Create(nil, false, true, '');
   Result:= TamVarCs<T2>.create;
end;
Destructor TamPostMessageResult<T1,T2>.Destroy;
begin
   if InitObject<> Byte(ConstInitObject) then
   exit;
   InitObject:=0;
   Result.Free;
   FreeAndNil(FEventSend);
   inherited Destroy ;
end;
procedure TamPostMessageResult<T1,T2>.SignalSetEvent;
begin
   if InitObject<> Byte(ConstInitObject) then
   exit;
   if Assigned(FEventSend) then
   FEventSend.SetEvent;
end;
function TamPostMessageResult<T1,T2>.PostMessageLock(aHandle:HWND;aMessage:UINT;TimeOutSeconds:Cardinal):TPostMessageCS;
var R:bool;
    dwResult:Cardinal;
    H: array[0..0] of THandle;
begin
   if TimeOutSeconds=0 then
   TimeOutSeconds:=Cardinal.MaxValue
   else
   TimeOutSeconds:=TimeOutSeconds*1000;

   //(recsNone,recsNoSend,recsOk,recsTimeOut,recsError)
   FEventSend.ResetEvent;
   R:=Winapi.Windows.PostMessage(aHandle,aMessage,0,LPARAM(self));
   if R then
   begin
     H[0]:=FEventSend.Handle;
     dwResult := WaitForMultipleObjects (1, @H, False, TimeOutSeconds );
     if dwResult = WAIT_TIMEOUT then Result:= recsTimeOut
     else if dwResult = WAIT_FAILED then Result:= recsError
     else if dwResult = 0  then  Result:= recsOk
     else Result:= recsNone;
          
   end
   else Result:=recsNoSend;


end;
function TamPostMessageResult<T1,T2>.PostMessageWaitFor(aHandle:HWND;aMessage:UINT;SecondWaitFor:Integer;Fun:ToWaitFor.Tfun):longBool;
begin
  Result:=Winapi.Windows.PostMessage(aHandle,aMessage,0,LPARAM(self));
  if Result then
  begin
     Result:=ToWaitFor.Go(SecondWaitFor,Fun,true);
  end;


end;




{ AmAtomic TInterlocked}




                        {integer}
class function AmAtomic.Getter(var Target: Integer): integer;
begin
   Result:=lock.CompareExchange(Target,0,0);
end;
class Function AmAtomic.Setter(var Target: Integer; Value: Integer):integer;
begin
   Result:=lock.Exchange(Target,Value);
end;
class Function AmAtomic.Iif(var Target:Integer;NewValue: integer;Comparand :Integer):integer;
begin
   Result:=lock.CompareExchange(Target,NewValue,Comparand);
end;
    {word}
class Function  AmAtomic.Getter(var Target:word):word;
begin
    Result:=word(Lock.CompareExchange(Integer((@Target)^),Integer(0),Integer(0)));
end;
class Function AmAtomic.Setter(var Target:word;Value:word):word;
begin
  Result:=word(Lock.Exchange(Integer((@Target)^),Integer(Value)));
end;




             {Int64}
class Function AmAtomic.Getter(var Target:Int64):Int64;
begin
    Result := lock.CompareExchange(Target, 0, 0);
end;
class Function AmAtomic.Setter(var Target:Int64;Value:Int64):Int64;
begin
 Result:=lock.Exchange(Target,Value);
end;
class Function AmAtomic.Inc(var Target:Int64;CountAdd: Int64=1):Int64;
begin
  Result:=lock.Add(Target,CountAdd);
end;
class Function AmAtomic.NewId(var Target:Int64):Int64;
begin
   repeat
      Result:= Inc(Target);
   until Result<>0;
end;



class Function AmAtomic.Getter(var Target:HWND):HWND;
begin
    Result:=HWND(Lock.CompareExchange(Integer((@Target)^),Integer(0),Integer(0)));
end;
class Function AmAtomic.Setter(var Target:HWND;Value:HWND):HWND;
begin
  Result:=HWND(Lock.Exchange(Integer((@Target)^),Integer(Value)));
end;


class Function AmAtomic.Getter(var Target:Pointer):Pointer;
begin
   Result:=Lock.CompareExchange(Target,nil,nil);
end;
class Function AmAtomic.Setter(var Target:Pointer;Value:Pointer):Pointer;
begin
   Result:=Lock.Exchange(Target,Value);
end;
class Function AmAtomic.Clear(var Target:Pointer):Pointer;
begin
   Result:=Lock.CompareExchange(Target,nil,Getter(Target));
end;



             {Cardinal}
class Function  AmAtomic.Getter(var Target:Cardinal):Cardinal;
begin
    Result:=Cardinal(Lock.CompareExchange(Integer((@Target)^),Integer(0),Integer(0)));
end;
class Function AmAtomic.Setter(var Target:Cardinal;Value:Cardinal):Cardinal;
begin
  Result:=Cardinal(Lock.Exchange(Integer((@Target)^),Integer(Value)));
end;
class Function  AmAtomic.Iif(var Target:Cardinal;NewValue: Cardinal;Comparand :Cardinal):Cardinal;
begin
 Result:=Cardinal(Iif(Integer((@Target)^),Integer(NewValue),Integer(Comparand)));
end;
class Function AmAtomic.Inc(var Target:Cardinal;CountAdd: integer=1):Cardinal;
begin
  Result := Cardinal(  TInterlocked.Add(Integer((@Target)^), CountAdd )  );
end;
class Function AmAtomic.NewId(var Target:Cardinal):Cardinal;
begin
   repeat
      Result:= Inc(Target);
   until Result<>0;
end;


                {Boolean}
class Function AmAtomic.Getter(var Target:Boolean):Boolean;
begin
   Result:=Boolean(Lock.CompareExchange(Integer((@Target)^),Integer(false),Integer(false)));
end;
class Function AmAtomic.Setter(var Target:Boolean;Value:Boolean):Boolean;
begin
    Result:=Boolean(Lock.Exchange(Integer((@Target)^),Integer(Value)));
end;

                {TBoolTri}
class Function AmAtomic.Getter(var Target:TBoolTri):TBoolTri;
begin
   Result:=TBoolTri(Lock.CompareExchange(Integer((@Target)^),Integer(bnot),Integer(bnot)));
end;
class Function AmAtomic.Setter(var Target:TBoolTri;Value:TBoolTri):TBoolTri;
begin
    Result:=TBoolTri(Lock.Exchange(Integer((@Target)^),Integer(Value)));
end;




class function AmAtomic.Getter(var Target: TDateTime): TDateTime;
begin
   Result := TDateTime(Lock.CompareExchange(Double((@Target)^), 0,0));
end;

class Function AmAtomic.Setter(var Target: TDateTime; Value: TDateTime):TDateTime;
begin
  Result := TDateTime(Lock.Exchange(Double((@Target)^), Double(Value)));
end;

class function AmAtomic.Getter<T>(var Target: T): T;
begin
   Lock.Exchange<T>(Result,Target);
end;
class function AmAtomic.Setter<T>(var Target: T; Value: T): T;
begin
   Result:=Lock.Exchange<T>(Target,Value);
end;

       {TamVarCs<T>}
constructor TamVarCs<T>.Create;
begin
    inherited Create ;
    FCs:=TCriticalSection.Create;
end;
Destructor TamVarCs<T>.Destroy;
begin
   FreeAndNil(FCs);
  inherited Destroy ;
end;
procedure TamVarCs<T>.Enter;
begin
  FCs.Enter;
end;
function  TamVarCs<T>.TryEnter:boolean;
begin
  Result:=  FCs.TryEnter;
end;
procedure TamVarCs<T>.Leave;
begin
  FCs.Leave;
end;
function TamVarCs<T>.GetVal:T;
begin
  Enter;
  Try
    Result:=Fval;
  Finally
   Leave;
  End;
end;
procedure TamVarCs<T>.SetVal(v:T);
begin
  Enter;
  Try
    Fval:=v;
  Finally
    Leave;
  End;
end;
function TamVarCs<T>.GetPointed:P;
begin
  Enter;
  Try
    Result:=@Fval;
  Finally
    Leave;
  End;
end;
procedure TamVarCs<T>.SetPointed(v:P);
begin
  Enter;
  Try
    Fval:=v^;
  Finally
    Leave;
  End;
end;

function AmMainPot:Cardinal;
begin
   Result:= AmAtomic.Getter(MainThreadId)
end;
function AmIsMainPot:boolean;
begin
   Result:= AmMainPot     =  GetCurrentThreadId ;
end;
function AmGetIdPot:Cardinal;
begin
   Result:= GetCurrentThreadId;
end;
function AmGetIdMainPot:Cardinal;
begin
    Result:= AmMainPot ;
end;

procedure AutoSleep(ms: Cardinal);
begin
  if MainThreadId     =  GetCurrentThreadId then Delay(ms)
  else Sleep(ms);
end;

procedure Delay(ms: Cardinal);
var
  TheTime: Cardinal;
begin
  TheTime := GetTickCount + ms;
  while GetTickCount < TheTime do
  begin
     Application.ProcessMessages;


    sleep(1);
     //ShowMessage(inttostr(GetTickCount));
  end;

end;
procedure DelayP(ms: Cardinal);
var
  TheTime: Cardinal;
begin
  TheTime := GetTickCount + ms;
  while GetTickCount < TheTime do
  begin
     Application.ProcessMessages;



     //ShowMessage(inttostr(GetTickCount));
  end;

end;

Class function ToWaitFor.Go(SecondMax:integer;Fun:Tfun;aAutoSleep:boolean=false):boolean;
var i:integer;
begin
    i:=0;
    Result:=Fun;
    while  not Result and (i<=SecondMax*10) do
    begin
      Result:= Fun;
      if Result then break;
      if aAutoSleep then  AutoSleep(100)
      else  sleep(100);
      inc(i);
    end;

end;
Class function  ToWaitFor.GoDelay(SecondMax:integer;Fun:Tfun):boolean;
var i:integer;
begin
    i:=0;
    Result:=Fun;
    while  not Result and (i<=SecondMax*10) do
    begin
      Result:= Fun;
      if Result then break;
      delay(100);
      inc(i);
    end;

end;
Class function  ToWaitFor.GoSleep(SecondMax:integer;Fun:Tfun):boolean;
var i:integer;
begin
    i:=0;
    Result:=Fun;
    while  not Result and (i<=SecondMax*10) do
    begin
      Result:= Fun;
      if Result then break;
      Sleep(100);
      inc(i);
    end;

end;
Class function  ToWaitFor.GoSleepInterval(MiliSecondsSleep,IntervalCheckFun:integer;Fun:Tfun):boolean;
var i,Counter:integer;
begin
    if MiliSecondsSleep<=0 then
    MiliSecondsSleep:=1;
    if IntervalCheckFun<=0 then
    IntervalCheckFun:=1;

    Counter:= MiliSecondsSleep div  IntervalCheckFun;
    i:=0;
    Result:=Fun;
    while  not Result and (i<=Counter) do
    begin
      Result:= Fun;
      if Result then break;
      Sleep(IntervalCheckFun);
      inc(i);
    end;

end;
function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := sizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then


      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));




    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;


Class procedure  ToStartWindows.Add;
var
  reg: tregistry;
begin
    reg := tregistry.Create;
    try
     reg.rootkey := HKEY_CURRENT_USER;
     if reg.openkey('software\microsoft\windows\currentversion\run', false) then
      reg.WriteString(Application.Title, Application.ExeName);
    finally
    reg.closekey;
    reg.Free;
    end;

end;
Class procedure  ToStartWindows.Delete;
var
  reg: tregistry;
begin
    reg := tregistry.Create;
    try
      reg.rootkey := HKEY_CURRENT_USER;
      if reg.openkey('software\microsoft\windows\currentversion\run', false) then
        reg.DeleteValue(Application.Title);

    finally
      reg.closekey;
      reg.Free;
    end;

end;
Class function  ToTypes.ToBytesArray<T>(value:TArray<T>):TBytes;
var Sz:integer;
begin
  Sz:= Length(value) * Sizeof(T);
  SetLength(Result,Sz);
  if (Sz>0) and (Length(value)>0) then
  Move(value[0], Result[0], Sz);
end;
Class function  ToTypes.ToBytes<T>(value:T):TBytes;
begin
     SetLength(Result,SizeOf(value));
     Move(value, Result[0], Length(Result)*SizeOf(Result[0]));
end;
Class procedure  ToTypes.ToBytes<T>(value:T;var B:TBytes);
begin
     SetLength(B,SizeOf(value));
     Move(value, B[0], Length(B)*SizeOf(B[0]));
end;
Class procedure  ToTypes.ToBytesBuffer<T>(value:T;var B);
begin
    // перед вызовом нужно установить размер  SetLength(B,SizeOf(X));   b - это же array of byte
    //ToBytesBuffer (X,B[0])
    Move(value, B, SizeOf(value));
end;
Class procedure  ToTypes.ToBytesPbyte<T>(value:T;B:Pbyte);
begin
    // перед вызовом нужно установить размер  SetLength(B,SizeOf(X));   b - это же array of byte
    //ToBytesPbyte (X,@B[0])
    Move(value, PByte(B)^, SizeOf(value));
end;
Class function  ToTypes.ToType<T>(Bytes:TBytes):T;
begin
   //каждая переменная в этом типе T должна быть фиксированной длинны типа string[32] или array[0..10]
   //если нужно иначе тогда каждую переменную сами переводите в  TBytes

     if (Bytes<>nil) and  (length(Bytes)>0) and (length(Bytes)>=SizeOf(Result)) then
      Move(Bytes[0],Result, SizeOf(Result));

end;
Class procedure ToTypes.ToType<T>(Bytes:TBytes;var X:T);
begin
   //каждая переменная в этом типе T должна быть фиксированной длинны типа string[32] или array[0..10]
   //если нужно иначе тогда каждую переменную сами переводите в  TBytes
     if (Bytes<>nil) and  (length(Bytes)>0) then
      Move(Bytes[0],X, SizeOf(X));
end;
Class procedure ToTypes.ToTypeBuffer<T>(var B;var X:T);
begin
   //каждая переменная в этом типе T должна быть фиксированной длинны типа string[32] или array[0..10]
   //если нужно иначе тогда каждую переменную сами переводите в  TBytes
   // ToTypeBuffer(B[0],X)

   Move(B,X, SizeOf(X));
end;
Class procedure ToTypes.ToTypePbyte<T>(B:Pbyte;var X:T);
begin
   //каждая переменная в этом типе T должна быть фиксированной длинны типа string[32] или array[0..10]
   //если нужно иначе тогда каждую переменную сами переводите в  TBytes
  // ToTypePbyte(@B[0],X)
   Move(PByte(B)^,X, SizeOf(X));
end;
Class function  ToTypes.ToBytesRtti<T>(value:T):TBytes;
var val:TValue;
begin
    val:= TValue.From<T>(value);
    if val.Kind in [tkUString,tkChar,tkString,tkWChar,tkLString,tkWString] then
    begin
      result:=AmBytes(val.AsString);
    end
    else Result:= ToBytes<T>(value);
end;
Class function  ToTypes.ToTypeRtti<T>(Bytes:TBytes):T;
var val:TValue;
    str:string;
begin
    val:= TValue.From<T>(result);
    if val.Kind in [tkUString,tkChar,tkString,tkWChar,tkLString,tkWString] then
    begin
      str:=AmStr(Bytes);
      val:= TValue.From<string>(str);
      Result:= val.AsType<T>;
    end
    else Result:= ToType<T>(Bytes);
end;
Class function ToTypes.BtoS(p:Pbyte;pCount:integer):String;
begin
    SetString(Result, PAnsiChar(p),pCount);
    if length(Result)>0 then    
    Result:= Result.Split([#0])[0];
end;
Class procedure ToTypes.StoB(S:String;p:Pbyte;pCount:integer);
var sl,i:integer;
begin
   sl:=Length(S);
   if sl>0 then
   Move(S[1],p^,sl)
   else
   begin
      for I := 0 to pCount-1 do
      begin
      P^:=0;
      inc(p);
      end;
        
   end;
end;

class Procedure AmPosBytes.SizeFixed(P:TKeyValue;IsBeginFile:boolean;var ReCallback,ReEtap,ReEnd,ReLast,ReFerst:int64);
var CSource,CPatern,CountBSource:integer;
begin




   CPatern := 0;
   CSource := 0;
   CountBSource:= P.CountBSource-1;
   if ReCallback>0 then
   begin
     CPatern:= ReCallback;
     ReCallback:=0;
   end;


   while CSource <= CountBSource do
   begin
      if P.BSource[CSource] = P.BPatern[CPatern] then
      begin
         if CPatern = P.CountBPatern-1 then
         begin
               ReLast:= CSource+1;
               ReFerst:= CSource - CPatern ;
               ReEtap :=0;
               exit;
         end else inc(CPatern);

         inc(CSource);
      end
      else
      begin
         CSource:= CSource + (P.Offset- CPatern);
         CPatern := 0;
      end;
   end;


   if (CPatern>0) and (ReFerst=Int64.MinValue) then ReCallback:= CPatern;
end;

class Procedure AmPosBytes.KeyValue(P:TKeyValue;IsBeginFile:boolean;var ReCallback,ReEtap,ReEnd,ReLast,ReFerst:int64);
var CSource,CPatern,CountBSource:integer;
    SymbolBegin:byte;
begin




     CPatern := 0;
     CSource := 0;
     CountBSource:= P.CountBSource-1;
     SymbolBegin:=P.SymbolBegin;
     if ReCallback>0 then
     begin
       CPatern:= ReCallback;
       ReCallback:=0;
     end;


    while CSource <= CountBSource do
    begin



        if (ReEtap =0) then
        begin
           if (SymbolBegin=0) then
           begin
               inc(ReEtap); //1
               if CPatern<>0 then CPatern := 0;
           end
           else
           begin
             if(P.BSource[CSource] = SymbolBegin)   then
             begin
               inc(ReEtap); //1
               if CPatern<>0 then CPatern := 0;

             end;
              inc(CSource);
           end;


          // showmessage(Char(P.BSource[CSource]));
        end
        else if (ReEtap =1) then
        begin
           if P.BSource[CSource] = P.BPatern[CPatern] then
           begin

             if CPatern = P.CountBPatern-1 then
             begin
                Inc(ReEtap);  //2
                if P.SymbolEndKey in P.SymbolEnd then
                begin
                     Inc(ReEtap); //3
                     ReEnd:=0;
                end
             end
             else inc(CPatern);
             inc(CSource);

           end else
           begin

                  if  (
                      (P.BSource[CSource] =   SymbolBegin)
                      or  (P.BSource[CSource] in P.SymbolEnd)
                      )
                  and (SymbolBegin<>0)
                  then
                  else
                  begin
                     CSource:= CSource + (P.Offset-1- CPatern)+1;
                  end;
                  //if CPatern<>0 then
                  CPatern := 0;
                  ReEtap:=0;

           end;
        end
        else if (ReEtap =2) then
        begin


            if  P.BSource[CSource] = P.SymbolEndKey then
            begin
               Inc(ReEtap); //3
               ReEnd:=0;
            end
            else ReEtap:=0;
            inc(CSource);

        end
        else if (ReEtap =3) then
        begin


            if P.BSource[CSource] in P.SymbolEnd  then
            begin
         //  showmessage(ReEtap.ToString +'  ' +P.BSource[CSource].ToString  +' '+CSource.ToString+' '+ CountBSource.ToString);


               ReLast:= CSource;
               ReFerst:= CSource - CPatern - ReEnd;
               if SymbolBegin<>0 then dec(ReFerst); //-1{SymbolBegin}

               dec(ReFerst);  //-1{SymbolEnd} ;

               ReFerst:=ReFerst;
             //  if not (P.SymbolBegin in P.SymbolEnd ) then dec(ReFerst);//
               if not (P.SymbolEndKey in P.SymbolEnd) then
               dec(ReFerst); //-1{SymbolEndKey}

              // ReSize :=  ReLast -  ReFerst;
               {
                  result позиция вхождения SymbolBegin с учетом разрыва блока
                  т.е некий (file[WasByte+result] = SymbolBegin) and (file[WasByte+ResultPositionLast] = SymbolEnd)
               }
               ReEtap :=0;
               exit;
            end
            else if (P.BSource[CSource] = P.SymbolBegin)  then
            begin
               ReFerst:= Int64.MinValue;
               ReEtap :=0;
               ReEnd:=0;
            end
            else
            begin
            inc(ReEnd);
            inc(CSource);
            end;
        end;






    end;

    if (CPatern>0) and (ReFerst=Int64.MinValue) then ReCallback:= CPatern;





end;

class function AmPosBytes.Careta (BPatern,BSource:Tbytes;CountBPatern,CountBSource,offset:int64;var Callback:int64):int64;
var CSource,CPatern:int64;
begin // поиск байтов в байтах  метод карета сдвиг до следушей строки  +x  70-150 ms  в 127 Mbytes
//мы знаем то что мы ишем находится в начале стоки и знаем длинну строк в файле  string[x] тогда offset x-1
{  в файле это
541859275
547613169
558907277//тогда если после цифр точно нет пустых символов byte=0 то  offset = 8  таже можео и 6  можно и 5  чем меньше тем скорось меньшн  тестил  offset=1   400 ms  в 127 Mbytes  на последнюю строку
564283664
569804500
574030271

 PosBytes_Careta не найдет первую стороку у нее нет #10 к файлу ее можно добавить
}



     result:=Int64.MinValue;
     CPatern := 0;
     CSource := 0;
     dec(CountBSource);
     dec(CountBPatern);  //582280790



     if Callback>0 then
     begin
       //Form1.Memo1.Lines.Add('Вызван Callback');  раскоментить сторку и посмотреть как часто вызвается
       //на стыке 2х блоков возможен разрыв дынных поэтому
       //что бы запомнить прошлый результат есть Callback
       //котрый в внешней процедуре установить в ноль перед запуском цикла обрашения к файлу
       // но если на 100 процентов знаем длинну стороки то  Callback не нужен и эту проверку можно удалить

        {
        пример когда включается Callback  Найден результат с помошью Callback
        он отрицательный  это значит что в предыдушем блоке нужно отнять и получится позиция вхождения

        Result:=-1;
        while ...
        begin
            ...
           ResultPos  :=PosBytes_Careta(BufPos,Buf,CountBufPos,CountWasRead,8,Callback);
           if ResultPos>Int64.MinValue then
           begin
             Result:=ResultByte  + ResultPos;
             break;
             (ResultByte- *это счетчик пройденных байтов с файла*)
             (*ResultPos - ответ который может быть отрицательным*);
           end;
         ...
        end;

       // Вот пример когда включается Callback  Найден результат с помошью Callback
       // Button5Click это только пример понять логику
        procedure TForm1.Button5Click(Sender: TObject);
        var Buf:Tbytes;
        BufPos:Tbytes;
        Result,ResultPos:int64;
        Callback:int64;
        begin
           Callback:=0;
           Result:=-1;
           BufPos:= AmBytes('1234567890'); //ишем эту строку  в 2 подхода

           Buf:= AmBytes('asdasdasd sad '+#13#10+'12345');//1й блок c файла  иметируем разрыв стоки
           ResultPos:=PosBytes_Careta(BufPos,Buf,length(BufPos),length(Buf),1,Callback);
           //Callback именился а ResultPos=Int64.MinValue как и прежде

           Buf:= AmBytes('67890выф ыв'); //2й блок c файла
           ResultPos:=PosBytes_Careta(BufPos,Buf,length(BufPos),length(Buf),1,Callback);
           //Callback именился на 0  а ResultPos<>Int64.MinValue

           if ResultPos>Int64.MinValue then Result:= ResultPos;
           Memo1.Lines.Add(amstr(Result)); //-5

           //теперь можно узнать какая позиция вхождения
           используя код который в самом начале этого комментария

        end;
        }

       CPatern:= Callback;
       Callback:=0;
          while CSource <=CountBSource do
          begin
            if BSource[CSource] = BPatern[CPatern] then
            begin
             //  showmessage('333333');
              if CPatern = CountBPatern then
              begin

                result:= CSource - CPatern;
                exit;
              end;
               inc(CPatern); inc(CSource);
            end
            else
            begin
              inc(CSource);
              if CPatern<>0 then CPatern := 0;
              break;
            end;
          end;
     end;






     while CSource <=CountBSource do
     begin
      //  showmessage('2222 ' +inttostr(BSource[CSource]) +'  '+inttostr(BPatern[CPatern])  );
       if BSource[CSource] in [10] then
       begin
         inc(CSource);
             // showmessage('11111');

          while CSource <=CountBSource do     // CSource := 0 to CountBSource-1
          begin
           //  showmessage('3333 ' +inttostr(BSource[CSource]) +'  '+inttostr(BPatern[CPatern])  );
            if BSource[CSource] = BPatern[CPatern] then
            begin
             //  showmessage('333333');
              if CPatern = CountBPatern then
              begin

                result:= CSource - CPatern;
                exit;
              end;
               inc(CPatern);
               inc(CSource);
            end
            else
            begin

              if CPatern<>0 then
              begin
                CPatern := 0;
                inc(CSource,1);
              end
              else inc(CSource,offset);
              break;
            end;


          end;
       end else inc(CSource);
     end;

     if (CPatern>0) and (result=Int64.MinValue) then  Callback:= CPatern;

end;
class function AmPosBytes.Incer(BPatern:Tbytes;BSource:Tbytes;CountBPatern,CountBSource:int64):int64;
var Callback:int64;
begin
    Callback:=0;
    Result:= IncCallback(BPatern,BSource,CountBPatern,CountBSource,Callback);
end;
class function AmPosBytes.IncCallback (BPatern:Tbytes;BSource:Tbytes;CountBPatern,CountBSource:int64;var Callback:int64):int64;
var CSource,CSourceCallBack,CPatern:int64;
begin // поиск байтов в байтах  метод классика +1  500-650 ms  в 127 Mbytes
    //showmessage(inttostr(BPatern[c])+'  '+ Inttostr(CountBPatern) +'  '+ Inttostr(CountBSource));
     result:=Int64.MinValue;
     CPatern := 0;
//     CSource := 0;
     CSourceCallBack:=0;
     dec(CountBSource);
     dec(CountBPatern);

     if Callback>0 then
     begin

       CPatern:= Callback;
       Callback:=0;
          while CSourceCallBack <=CountBSource do
          begin
            if BSource[CSourceCallBack] = BPatern[CPatern] then
            begin

              if CPatern = CountBPatern then
              begin

                result:= CSourceCallBack - CPatern;
                exit;
              end;
               inc(CPatern); inc(CSourceCallBack);
            end
            else
            begin
              inc(CSourceCallBack);
              if CPatern<>0 then CPatern := 0;
              break;
            end;
          end;
     end;


    for CSource := CSourceCallBack to CountBSource do
    begin

      if BSource[CSource]=BPatern[CPatern] then
      begin
        if CPatern = CountBPatern then
        begin
          result:= CSource - CPatern;
          break;
        end;
         inc(CPatern);
      end else if CPatern<>0 then CPatern := 0;

    end;

    if (CPatern>0) and (result=Int64.MinValue) then  Callback:= CPatern;
end;


class function AmPosBytes.PosTxt(P: PPosTxt): boolean;
var
  CSource, CPatern, CountBSource: integer;
  SymbolBegin: byte;
begin
  Result := false;
  CPatern := 0;
  CSource := 0;
  CountBSource := P.CountBSource - 1;
  SymbolBegin := P.SymbolBegin;
  if P.ReCallback > 0 then
  begin
    CPatern := P.ReCallback;
    P.ReCallback := 0;
  end;

  while CSource <= CountBSource do
  begin

    if (P.ReEtap = 0) then
    begin
      if (SymbolBegin = 0) or P.IsBeginFile then
      begin
        if P.IsBeginFile then
        begin
          P.IsBeginFile := false;
        end;

        inc(P.ReEtap); // 1
        if CPatern <> 0 then
          CPatern := 0;
      end
      else
      begin
        if (P.BSource[CSource] = SymbolBegin) then
        begin
          inc(P.ReEtap); // 1
          if CPatern <> 0 then
            CPatern := 0;
        end;
        inc(CSource);
      end;

      // showmessage(Char(P.BSource[CSource]));
    end
    else if (P.ReEtap = 1) then
    begin
      if P.BSource[CSource] = P.BPatern[CPatern] then
      begin

        if CPatern = P.CountBPatern - 1 then
        begin

          if CPatern = 0 then
          begin
            P.ReFerst := CSource;
            P.ChangeReFerst := true;
          end;

          inc(P.ReEtap); // 2
          if P.SymbolEndKey in P.SymbolEnd then
          begin
            inc(P.ReEtap); // 3

          end;
          if ((P.PosFile >= P.SizeFile) and (CSource >= CountBSource)) then
          begin
            P.ReEtap := 3;
          end
          else
            inc(CSource);

        end

        else
        begin
          if CPatern = 0 then
          begin
            P.ReFerst := CSource;
            P.ChangeReFerst := true;
          end;

          inc(CPatern);
          inc(CSource);
        end;

      end
      else
      begin

        if (

            (P.BSource[CSource] = SymbolBegin)
            or
            (P.BSource[CSource] in P.SymbolEnd)
           )
           and
           (SymbolBegin <> 0) then
        else
        begin
          CSource := max(CSource+1, CSource + (P.Offset - 1 - CPatern) + 1);
        end;
        // if CPatern<>0 then
        CPatern := 0;
        P.ReEtap := 0;

      end;
    end
    else if (P.ReEtap = 2) then
    begin

      if (P.BSource[CSource] = P.SymbolEndKey) then
      begin
        inc(P.ReEtap); // 3

        inc(CSource);
      end
      else if (P.BSource[CSource] in P.SymbolEnd) then
      begin
        inc(P.ReEtap); // 3

      end
      else
      begin
        P.ReEtap := 0;
        inc(CSource);
      end;

    end
    else if (P.ReEtap = 3) then
    begin

      if (P.BSource[CSource] in P.SymbolEnd) or
        ((P.PosFile >= P.SizeFile) and (CSource >= CountBSource)) then
      begin
        // showmessage(ReEtap.ToString +'  ' +P.BSource[CSource].ToString  +' '+CSource.ToString+' '+ CountBSource.ToString);

        P.ReLast := CSource;
        if not((P.PosFile >= P.SizeFile) and (CSource >= CountBSource)) then
          dec(P.ReLast); // -1{SymbolEnd} ;

        // ReFerst:= CSource - CPatern -1;
        // if ReEnd>0 then
        // ReFerst:= ReFerst - ReEnd -1;
        // if (SymbolBegin<>0) and not isBedinFileExp then dec(ReFerst); //-1{SymbolBegin}

        P.ReFerst := P.ReFerst;
        // if not (P.SymbolBegin in P.SymbolEnd ) then dec(ReFerst);//
        // if not IsNotKey and not (P.SymbolEndKey in P.SymbolEnd) then
        // dec(ReFerst); //-1{SymbolEndKey}

        // ReSize :=  ReLast -  ReFerst;
        {
          result позиция вхождения SymbolBegin с учетом разрыва блока
          т.е некий (file[WasByte+result] = SymbolBegin) and (file[WasByte+ResultPositionLast] = SymbolEnd)
        }
        P.ReEtap := 0;
        Result := true;
        exit;
      end
      else if (P.BSource[CSource] = P.SymbolBegin) then
      begin
        P.ReFerst := int64.MinValue;
        P.ReEtap := 0;

      end
      else
      begin
        inc(CSource);
      end;
    end;

  end;

  if (CPatern > 0) and not Result then
    P.ReCallback := CPatern;

end;


function AmCheckFile(const FullNameFile: string): Boolean;
begin
  Result:= FileExists(FullNameFile) ;
  if Result then   REsult:=AmFileIsFree(FullNameFile);
  
end;
function AmFileIsFree(const FullPatch: string): Boolean;
begin
   Result:=not AmIsFileInUse(FullPatch);
end;
function AmFileIsFreeRead(const FullPatch: string): Boolean;
var
 HFileRes: HFILE;
begin
// Result := False;
 HFileRes := CreateFile(PChar(FullPatch),
                        GENERIC_READ,
                        FILE_SHARE_READ,
                        nil,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL,
                        0);
 Result := (HFileRes <> INVALID_HANDLE_VALUE);
 if  Result then
   CloseHandle(HFileRes);

end;
function AmIsFileInUse(const FullPatch: string): Boolean;
var
 HFileRes: HFILE;
begin
// Result := False;
 HFileRes := CreateFile(PChar(FullPatch),
                        GENERIC_READ or GENERIC_WRITE,
                        0,
                        nil,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL,
                        0);
 Result := (HFileRes = INVALID_HANDLE_VALUE);
 if not Result then
   CloseHandle(HFileRes);
end;
function AmIsFileInUseWaitFor(const FullPatch: string;Second:integer=1): Boolean;
var I:integer;
begin
    Result:=false;
    if Second<0 then Second:=0;
    for I := 0 to Second do
    begin
       Result:= AmIsFileInUse(FullPatch);
       if not Result then break;
       sleep(1000);
       
    end;


end;
procedure AmAppedTextFile(const aFile: string; const Msg: string);
var myFile : TextFile;
begin
     //or  TFile.AppendAllText
  try
       raise Exception.Create('Error Message');
      if FileExists(aFile) then
      begin
        AssignFile(myFile, aFile);
        Append(myFile);
        WriteLn(myFile, Msg);
        CloseFile(myFile);
      end
      else
      begin
        AssignFile(myFile, aFile);
        ReWrite(myFile);
        WriteLn(myFile, Msg);
        CloseFile(myFile);
      end;

  except
    On E: Exception Do
   if Assigned(LogMain) then LogMain.LogError('ErrorCode Запись в файл AmUserType.AddToFile',nil,e,true);

  end;


end;
function AmSizeFile(FNameFull: string): int64;
var F: TFileStream;
begin
Result:=0;
    try
      F:=TFileStream.Create(FNameFull, fmOpenRead);
      Result:=F.Size;
      F.Free;
  except
    On E: Exception Do
    if Assigned(LogMain) then LogMain.LogError('ErrorCode Запись в файл AmUserType.SizeFile',nil,e,true);

  end;

end;
function AmSizeFileWin(const aFileName: string): Int64;
var AttributeData: TWin32FileAttributeData;
begin
 Result := -1;
  try
        if GetFileAttributesEx(PChar(aFileName), GetFileExInfoStandard, @AttributeData) then
        begin
          Int64Rec(Result).Lo := AttributeData.nFileSizeLow;
          Int64Rec(Result).Hi := AttributeData.nFileSizeHigh;
        end
        else
          Result := -1;
  except
    On E: Exception Do
    if Assigned(LogMain) then LogMain.LogError('AmUserType.FileGetSize',nil,e,true);

  end;


end;
function GetFileDate(FileName: string): string;
{
var
  FHandle: Integer;
begin
  FHandle := FileOpen(FileName, 0);
  try
    Result := DateTimeToStr(FileDateToDateTime(FileGetDate(FHandle)));
  finally
    FileClose(FHandle);
  end;
  }
var
  intFileAge: LongInt;
begin
  intFileAge := FileAge(FileName);
  if intFileAge = -1 then
    Result := ''
  else
    Result := DateTimeToStr(FileDateToDateTime(intFileAge));
end;

function GetOneFile_InDirOrFile(patch1,listFormat:string;var NameSmena:boolean ):string;
var
I,Maxcount:integer;
Sr:integer;
begin
 //Sr 0=папка
 //Sr 1=файл
   result:='';
   Sr:=0;
try
   if TregEx.Create('\s*\w\:\\').Match(patch1).Value=''  then exit;

    patch1:=trim(patch1);
    Maxcount:=CountPos(',',listFormat);

    for I := 0 to Maxcount do
    begin
       if TregEx.Create('\\.+\.'+listFormat.Split([','])[i]).Match(patch1).Value<>'' then
       begin
          Sr:=1;
          NameSmena:=false;
          break;
       end;

    end;

    if Sr=0 then
    begin

       //patch1:=ExtractFileDir(patch1);
       //showmessage(patch1);

       patch1:= GetInDirOneRandomFile(patch1,listFormat);
    end;
    Result:= patch1;
except
  On E: Exception Do
  if Assigned(LogMain) then LogMain.LogError('ErrorCode Запись в файл AmUserType.GetOneFile_InDirOrFile',nil,e,true);

end;




end;
function GetInDirOneRandomFile(patch1,listFormat:string):string;
var
  a:tstringlist;
  FindFile: TSearchRec;
  I,Maxcount:integer;
begin
    //patch1='C:\papka';
 Result:='';
 a:=tstringlist.Create;
 try
  try
   if (length(patch1)>0) then
   begin
    Maxcount:=CountPos(',',listFormat);
    if not (patch1[ length(patch1)] = '\') then patch1:=patch1+'\';


    for I := 0 to Maxcount do
    begin

      if FindFirst(patch1+'*.'+listFormat.Split([','])[i], faAnyFile, FindFile)=0 then
      begin
          repeat
             a.Add(FindFile.Name);
          until FindNext(FindFile) <> 0;

      end;
    end;
     FindClose(FindFile);


     if a.Count>0 then
     begin
        Result:= patch1+a[math.RandomRange(0,a.Count)];
     end;
   end;
  except
    On E: Exception Do
    if Assigned(LogMain) then LogMain.LogError('ErrorCode Запись в файл AmUserType.GetInDirOneRandomFile',nil,e,true);

  end;
 finally
  a.Free;
 end;

end;

function RenameFileRandom(FullPatch: string): Boolean;
var newName,generat_Name:string;

begin
  result:=false;
 try

    generat_Name:= generatPass(12);
    newName := ExtractFilePath(FullPatch)  + generat_Name + ExtractFileExt(FullPatch);
    if RenameFile(FullPatch, newName) then
    begin
        result:=true;
    end;
  except
    On E: Exception Do
   if Assigned(LogMain) then LogMain.LogError('ErrorCode Запись в файл AmUserType.RenameFileRandom',nil,e,true);

  end;
end;

Procedure  AmByteWrite(Source:Pointer;var Desc:Pointer;Siz:Integer);
begin
  if (Source<>nil) and (Desc<>nil) then
  begin
   System.move(Source^,Desc^,Siz);
   System.inc(Pbyte(Desc),Siz);
  end;
end;
Procedure  AmByteRead(var Source:Pointer;Desc:Pointer;Siz:Integer);
begin
  if (Source<>nil) and (Desc<>nil) then
  begin
   System.move(Source^,Desc^,Siz);
   System.inc(Pbyte(Source),Siz);
  end;
end;
function AmAddresToByteStr(A:Pointer;Size:integer):string;
var Aa:TArrByteRec;
    p:Pointer;
begin
    Aa.List.Count:=Size;
    p:= Aa.List.ArrayInstancePointer;
    move(A^,p^,Size);
    Result:= Aa.Fun.ToStr;
end;
procedure AmAddressShow(Caption:string;A:Pointer;Size:integer);
var s:string;
begin
    s:= AmAddresToByteStr(A,Size);
    s:=  s+'size:'+Size.ToString;
    AmDialog.InputBox('',Caption, s);
end;

function  IntToBin(Value: integer; Digits: integer): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to Digits - 1 do
    if Value and (1 shl i) > 0 then
      result := '1' + result
    else
      result := '0' + result;

end;
function BitCount(x:byte):byte;
begin
//Создать функцию, которая бы возвращала кол-во бит в переданном ей байте - Delphi - Ответ 8742507
  Result := 0;
  while x>0 do
  begin
    Result:=Result+(x and 1);
    x:=x shr 1;
  end;
end;
   {AmBit}
class function AmBit.BitGetMask(N:Cardinal):Cardinal;
begin
  Result:= 1 shl N;
end;
class function AmBit.BitGetPos(N:Cardinal):Cardinal;
begin
  Result:= BitGetMask(N);
end;
class function AmBit.BitTrue(Src: Cardinal; bit: Cardinal): Cardinal;
begin
  Result := Src or BitGetMask(bit);
end;
class function AmBit.BitFalse(Src: Cardinal; bit: Cardinal): Cardinal;
begin
  Result := Src and not BitGetMask(bit);
end;
class function AmBit.BitInvert(Src: Cardinal; bit: Cardinal): Cardinal;
begin
  Result := Src xor BitGetMask(bit);
end;
class function AmBit.BitSet(Value:Boolean;Src: Cardinal; bit: Cardinal): Cardinal;
begin
    if Value then Result:= BitTrue(Src,bit)
    else          Result:= BitFalse(Src,bit);
end;
class function AmBit.BitGet(Src: Cardinal; bit: Cardinal): Boolean;
begin
  Result := ( Src and BitGetMask(bit) ) <> 0;
end;
class procedure AmBit.ByteToBits(b:Pbyte;Result:PAmArray7Bool);
var I: Integer;
begin
    if Assigned(Result) then
    for I := 0 to 7 do
    Result[i]:= BitGet(b^,i);
end;
class procedure AmBit.BitsToByte(Bits:PAmArray7Bool;Result:Pbyte);
var I: Integer;
begin

    if Assigned(Result) then
    for I := 0 to 7 do
    Result^:= BitSet(Bits[i],Result^,i);
end;
class procedure  AmBit.BytesToArrayBits(b:Pbyte;Result:PAmArray7Bool;Count:integer);
var I: Integer;
begin
   if Assigned(b) and Assigned(Result) then
    for I := 0 to Count-1 do
    begin
       ByteToBits(b,Result);
       inc(b);
       inc(Result);
    end;

      
end;
class procedure AmBit.ArrayBitsToBytes(Bits:PAmArray7Bool;Result:Pbyte;Count:integer);
var I: Integer;
begin
   if Assigned(Bits) and Assigned(Result) then
    for I := 0 to Count-1 do
    begin
       BitsToByte(Bits,Result);
       inc(Result);
       inc(Bits);
    end;

end;
class procedure AmBit.BytesToArrayBits2(Buff:PBytes;Result:PAmArrayBits);
var Count:integer;
begin
   if Assigned(Buff) and Assigned(Result) then
   begin
     Count:= Length(Buff^);
     SetLength(Result^,Count);

     if Count>0 then     
     BytesToArrayBits(@Buff^[0],@Result^[0],Count);
   end;
end;
class procedure AmBit.ArrayBitsToBytes2(ArrayBits:PAmArrayBits;Result:PBytes);
var Count:integer;
begin
   if Assigned(ArrayBits) and Assigned(Result) then
   begin
     Count:= Length(ArrayBits^);
     SetLength(Result^,Count);

     if Count>0 then
     ArrayBitsToBytes(@ArrayBits^[0],@Result^[0],Count);
   end;

end;
class function AmBit.BitsToByteType(Bits:TAmArray7Bool):byte;
begin
  BitsToByte(@Bits,@Result);
end;
class function AmBit.ByteToBitsType(b:byte):TAmArray7Bool;
begin
  ByteToBits(@b,@Result);
end;
class function AmBit.BytesToArrayBitsType(buf:TBytes):TAmArrayBits;
begin
  BytesToArrayBits2(@buf,@Result);
end;
class function AmBit.ArrayBitsToBytesType(ArrayBits:TAmArrayBits):TBytes;
begin
  ArrayBitsToBytes2(@ArrayBits,@Result);
end;

    {AmStream}
class function AmStream.SteamToStr(Strm:TStream;var S:string):boolean;
var
b:Tbytes;
r:integer;
begin
  S:='';
  Result:=false;
  if Assigned(Strm) and  (Strm.size<MaxSizeString) then
  begin
      Strm.Position:=0;
      SetLength(b,Strm.Size);
      r:=Strm.Read(b[0],Strm.Size);
      SetLength(B, r);
      if r>0 then      
      S:=AmStr(B);
      Strm.Position:=0;
      Result:=true;
  end;
end;
class procedure AmStream.StrToSteam(Strm:TStream;S:String);
var b:TBytes;
begin
    Strm.Position:=0;
    b:= AmBytes(S);
    Strm.Write(b[0],length(b));
    Strm.Position:=0;

end;
function  amStr(var Bytes:Tbytes4096):string;
begin
    SetString(Result, PAnsiChar(@Bytes[1]), length(Bytes));
    if  not  IsUTF8String(RawByteString(Result)) then           Result:=string(AnsiToUtf8(Result))
    else if  HasExtendCharacter(RawByteString(Result))  then    Result:=UTF8ToString(RawByteString(Result));
end;
function amStr(var Bytes;Count:integer):string;
begin
   Result:= amBytesToStr(Bytes,Count);
end;
function amStrDecode(V:string):string;overload;  inline;
begin
    Result:=V;
    if  not  IsUTF8String(RawByteString(Result)) then           Result:=string(AnsiToUtf8(Result))
    else if  HasExtendCharacter(RawByteString(Result))  then    Result:=UTF8ToString(RawByteString(Result));
end;
function amStr(pByte:Pointer;Count:integer):string;
begin
     Result:=amBytesToStr(pByte,Count);
end;
function amBytesToStr(var Bytes;Count:integer):string;
begin
    SetString(Result, PAnsiChar(@Bytes), Count);
    if  not  IsUTF8String(RawByteString(Result)) then           Result:=string(AnsiToUtf8(Result))
    else if  HasExtendCharacter(RawByteString(Result))  then    Result:=UTF8ToString(RawByteString(Result));
end;
function amBytesToStr(pByte:Pointer;Count:integer):string;
begin
    SetString(Result, PAnsiChar(pByte), Count);
    if  not  IsUTF8String(RawByteString(Result)) then           Result:=string(AnsiToUtf8(Result))
    else if  HasExtendCharacter(RawByteString(Result))  then    Result:=UTF8ToString(RawByteString(Result));
end;
procedure amStrToBytes(S:String;pByt:Pointer;Count:integer);
var B:TBytes;
begin
    b:=AmBytes(S);
    if length(b)>0 then
    move(b[0],Pbyte(pByt)^,min(Count,length(b)));
end;
function AmStr(var Bytes:TBytes):string;
begin
   // Size := TEncoding.GetBufferEncoding(Buffer, Encoding, nil);
   // showmessage(Encoding.GetString(Buffer, Size, Length(Buffer) - Size));

    SetString(Result, PAnsiChar(@Bytes[0]), length(Bytes));
    if  not  IsUTF8String(RawByteString(Result)) then
    Result:=string(AnsiToUtf8(Result))
    else if  HasExtendCharacter(RawByteString(Result))  then
    Result:=UTF8ToString(RawByteString(Result));
end;
function AmBytes( Value:string):TBytes;
var Encoding:  TEncoding;
begin
    Encoding:=TEncoding.UTF8;
    result := Encoding.GetBytes(value);
end;
function  amBytesCount( Value:string):Integer;
var Encoding:  TEncoding;
begin
    Encoding:=TEncoding.UTF8;
    result := Encoding.GetByteCount(Value);
end;
function  AmArray(var Value:string;DeLimiter:string):TArray<string>;
begin
  result:= Value.Split(DeLimiter);
end;
function  amArray(L:Tstrings):TArray<string>;
var
  I: Integer;
begin
   SetLength(result,L.count);
   for I := 0 to L.count-1 do
   Result[i]:= L[i];
end;
function  AmStr(var Value:TArray<string>;DeLimiter:string):string;
var i,m:int64;
begin
    m:=length(Value);
    for I := 0 to m-1 do
    begin
      result:= result+Value[i];
      if I<> m-1 then   result:= result+ DeLimiter;
    end;

end;
Procedure  amBytes(var Buff:TBytes; Value:string;DeLimiter:string);
var Arr:Tarray<string>;
    M,I:integer;
begin
   Arr:= Value.Split([DeLimiter]);
   M:= Length(Arr);
   SetLength(Buff,M);
   for I := 0 to M-1 do Buff[i]:=AmInt(Arr[i],0);

end;
function  AmStr(Value:TBytes;DeLimiter:string):string;
var i,m:int64;
begin
    m:=length(Value);
    for I := 0 to m-1 do
    begin
      result:= result+inttostr(Value[i]);
      if I<> m-1 then   result:= result+ DeLimiter;
    end;

end;
function  AmStrCopy(V:string;Count:integer):string;
begin
  if V<>'' then
  Result:= Copy(V,1,min(length(V),Count))
  else Result:='';
end;
function  AmStrCutMore(V:string;Count:integer):string;
begin
  Result:= AmStrCopy(V,Count);
  if length(Result)<>length(V) then Result:=Result+'…';
end;
function amStrSpace(value: string;CharCount:integer=3): string;
var i,v:integer;
begin
  value:=value.Replace(' ','');
  v:=0;
  Result:='';
  for I := length(value) downto 1 do
  begin
    if (v mod CharCount=0) and (Result<>'') then Result:= ' '+Result;
    Result:=  value[i] +Result;
    inc(v);
  end;
end;
function amInt(Bytes:Tbytes):integer;
begin
     result:=-1;
     Move(Bytes[0], result, SizeOf(result));
end;
function amHexToInt(s:string):integer;
begin
   if length(s)=0 then exit(0);
   if s[1]<>'$' then  s:= '$'+s;
   Result:= AmInt(s);
end;
function amHexToP(s:string):Pointer;
begin
   Result:= Pointer(amHexToInt(s));
end;
function  amBytes( Value:Integer):TBytes;
begin
     SetLength(Result,SizeOf(value));
     Move(Value, result[0], Length(result)*SizeOf(result[0]));
end;
function  amBytes( Value:Word):TBytes;overload;
begin
     SetLength(Result,SizeOf(value));
     Move(Value, result[0], SizeOf(Value));
end;
function  amBytes( Value:Int64):TBytes;
begin
     SetLength(Result,SizeOf(value));
     Move(Value, result[0], Length(result)*SizeOf(result[0]));
end;
function amInt64(value:TBytes):int64;
begin
     result:=-1;
     Move(value[0], result, SizeOf(result));
end;
function  AmStrSizeFile(V:Int64):string;
begin
    if V<1000 then Result:= V.ToString+' b'
    else if (V>=1000) and (V<1000000) then Result:=FloatTostr( math.RoundTo(V /1000,-2) )+' Kb'
    else if (V>=Power(10,6)) and (V<Power(V,9)) then Result:=FloatTostr( math.RoundTo(V /Power(10,6),-2) )+' Mb'
    else Result:=FloatTostr( math.RoundTo(V /Power(10,9),-2) )+' Gb';

end;
function  amBytesDeleteNull( Bytes:TBytes):TBytes;

begin

      
end;
function amReal(Bytes:Tbytes):Real;

begin
     result:=-1;
     Move(Bytes[0], result, SizeOf(result));
end;
function  amBytes( Value:Real):TBytes;
begin
     SetLength(Result,SizeOf(value));
     Move(Value, result[0], Length(result)*SizeOf(result[0]));
end;

function amInt(value:string):integer;                 begin   result:=amInt(value,0); end;
function amInt(value:boolean):integer;                begin   result:= value.ToInteger; end;
function amInt(value:real):integer;                   begin   result:= round(value); end;
function amInt(value:real;deff:integer):integer;      begin   try result:= round(value);  except result:= deff end; end;
function amInt64(value:string):int64;                 begin   result:= amInt64(value,0) end;


function amInt(value:string;deff:integer):integer;    begin   result:=StrToIntDef(value,deff); end;
function amInt64(value:string;deff:int64):int64;      begin   result:=StrToInt64Def(value,deff); end;


function amReal(value:integer):Real;                  begin   result:= amReal(value,0) end;
function amReal(value:string):Real;                   begin   result:= amReal(value,0); end;
function amReal(value:integer;deff:Real):Real;        begin   try result:= value;  except result:= deff end; end;
function amReal(value:string;deff:Real):Real;
begin

   try
      if value<>'' then
      begin
      if pos('.',value)<>0 then value:=value.replace('.',',');
      if pos(FormatSettings.ThousandSeparator,value)<>0 then
      value:=value.replace(FormatSettings.ThousandSeparator,'');

      if pos(' ',value)<>0 then
      value:=value.replace(' ','');
      result:= StrToFloatDef(value,deff);
      end
      else Result:=deff;

   except result:= deff end;
end;
function AmStrIndexOf(L:TStrings; Name:string):integer;
var
  I: Integer;
begin
  for I := 0 to L.count-1 do
  if l[i]=Name then exit(i);
  Result:=-1;
end;
function AmStrIndexOfTextId(L:TStrings; AId:Int64):integer;
var H:TAmTextId;
var
  I: Integer;
begin
  for I := 0 to L.count-1 do
  begin
    H.SetValue(l[i]);
    if H.IsGood and (H.Id = AId)  then exit(i);
    
  end;
  Result:=-1;
end;


function amStr(value:Word):string;  begin   result:= inttostr(value); end;
function amStr(value:SmallInt):string; begin   result:= inttostr(value); end;
function amStr(value:integer):string; begin   result:= inttostr(value); end;
function amStr(value:int64):string;   begin   result:= inttostr(value); end;
function amStr(value:real):string;   begin   result:= floattostr(value); end;
function amStr(Value: Extended):string; begin   result:= floattostr(value); end;
function amStrReal(Value: Extended):string;  begin   result:= floattostr(value); end;
function amStr(value:double):string;  begin   result:= floattostr(value); end;
function amStrRound(value:real;roundCount:integer=-2):string;
begin
 result:= floattostr( math.RoundTo(value,roundCount));
end;

function amStr(value:boolean):string; begin   result:= booltostr(value); end;

function amStrColor(value:Tcolor):string;  begin   result:= ColorToString(value); end;

function amDateTimeCorrect (value:TDateTime):TDateTime;
begin
  Result:= value;
  if Real(Result)> integer.MaxValue-700000 then
  Real(Result):=  integer.MaxValue-700000
  else if Real(Result)<=0.0 then
  Real(Result):=0.0;
end;
function amStr(value:Tdatetime):string;
begin
   Value:=amDateTimeCorrect(value);
   result:= dateTimeToStr(value);
end;
function amStr(value:Tdatetime;full:boolean;Format:string=''):string;
begin
  Value:=amDateTimeCorrect(value);
  if full then result:= FormatDateTime('dd.mm.yyyy" "hh:nn:ss:zzz',value)
  else if (Format<>'') then result:= FormatDateTime(Format,value)
  else result:=amStr(value);
end;
function amStr(const a: Tarray<Char>): string;
begin
  if Length(a)>0 then
    SetString(Result, PChar(@a[0]), Length(a))
  else
    Result := '';
end;
function amStr(const a: array of Char): string; overload;
begin
  if Length(a)>0 then
    SetString(Result, PChar(@a[0]), Length(a))
  else
    Result := '';
end;
function amStr(aStream: TStream): string;
var
  SS: TStringStream;
begin
  if aStream <> nil then
  begin
    SS := TStringStream.Create('');
    try
      aStream.Position:=0;
      SS.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end else
  begin
    Result := '';
  end;
end;
(*
function AmStrKysr(val:real):string;
var d:real;
 function Zr(s:string):string;
 var A:TArray<string>;
 count,Z,i:integer;
 begin
   A:=S.split([',']);
   if Length(A)>1 then
   begin
     Result:=A[1];
     Z:=Length(A[1]);
     count:=0;
     i:=Z;
     while i>0 do
     begin
        dec(i);
       if Result[i] in [' ','0'] then inc(count)
       else break;
     end;
     if Z-count<>Z  then SetLength(Result,Z-count);

     Result:= A[0]+','+Result;
   end;

 end;
begin
    d:=abs(val);
    if      d<0.0000001{0}    then Result:=                FormatFloat('0.00E-', Val)
    else if d<0.000001{00}    then Result:=               FormatFloat('00.00E-0', Val)
    else if d<0.00001{000}    then Result:=              FormatFloat('000.00E-0', Val)
    else if d<0.0001{0 000}   then Result:=            FormatFloat('0 000.00E-0', Val)
    else if d<0.001{00 000}   then Result:=           FormatFloat('00 000.00E-0', Val)
    else if d<0.01{000 000}   then Result:=           FormatFloat('000 000.0E-0', Val)
    else if d<10              then Result:=                FormatFloat('0.00 000 000', val)
    else if d<100             then Result:=               FormatFloat('00.00 000 000', val)
    else if d<1000            then Result:=              FormatFloat('000.00 000 000', val)
    else if d<10000           then Result:=            FormatFloat('0 000.00 000 000', val)
    else if d<100000          then Result:=           FormatFloat('00 000.00 000 000', val)
    else if d<1000000         then Result:=          FormatFloat('000 000.00 000 000', val)
    else if d<10000000        then Result:=        FormatFloat('0 000 000.00 000 000', val)
    else if d<100000000       then Result:=       FormatFloat('00 000 000.00 000 000', val)
    else if d<1000000000      then Result:=      FormatFloat('000 000 000.00 000 000', val)
    else if d<10000000000     then Result:=    FormatFloat('0 000 000 000.00 000 000', val)
    else if d<100000000000    then Result:=   FormatFloat('00 000 000 000.00 000 000', val)
    else                           Result:=   AmStr(Val);
end;
function AmStrKysr2(val:real):string;
var d:real;
begin
    d:=abs(val);
    if      d<0.0000001{0}    then Result:=                FormatFloat('0.00E-', Val)
    else if d<0.000001{00}    then Result:=               FormatFloat('00.00E-0', Val)
    else if d<0.00001{000}    then Result:=              FormatFloat('000.00E-0', Val)
    else if d<0.0001{0 000}   then Result:=            FormatFloat('0 000.00E-0', Val)
    else if d<0.001{00 000}   then Result:=           FormatFloat('00 000.00E-0', Val)
    else if d<0.1{00 000}   then   Result:=                FormatFloat('0.0000000', Val)
    else if d<10              then Result:=                FormatFloat('0.000000', val)
    else if d<100             then Result:=               FormatFloat('00.00000', val)
    else if d<1000            then Result:=              FormatFloat('000.0000', val)
    else if d<10000           then Result:=            FormatFloat('0 000.000', val)
    else if d<100000          then Result:=           FormatFloat('00 000.00', val)
    else if d<1000000         then Result:=          FormatFloat('000 000.0', val)
    else if d<10000000        then Result:=        FormatFloat('0 000 000', val)
    else if d<100000000       then Result:=       FormatFloat('00 000 000', val)
    else if d<1000000000      then Result:=      FormatFloat('000 000 000', val)
    else if d<10000000000     then Result:=    FormatFloat('0 000 000 000', val)
    else if d<100000000000    then Result:=   FormatFloat('00 000 000 000', val)
    else                           Result:=   AmStr(Val);
end;
*)
function AmStrTrade(val:real):string;
begin
   Result:=  FormatFloat('#,##0.## ### ###', val);
end;
function AmStrTradeRound(val:real):string;
var d:real;
begin
    d:=abs(val);


    if   d<0.0000001{0}    then Result:=                FormatFloat('#,##0.## ### ### ###', Val)
    else if d<0.01{ 000 000}       then Result:=                FormatFloat('#,##0.## ### ###', Val)
    else if d<0.1{0 000 000}  then Result:=                FormatFloat('#,##0.## ###', Val)
    else if d<1{.00 000 000}  then Result:=                FormatFloat('#,##0.## ###', Val)
    else if d<10              then Result:=                FormatFloat('#,##0.####', val)
    else if d<100             then Result:=               FormatFloat('#,##0.###', val)
    else if d<1000            then Result:=              FormatFloat('#,##0.##', val)
    else if d<10000           then Result:=            FormatFloat('#,##0.##', val)
    else if d<100000          then Result:=           FormatFloat('#,##0.##', val)
    else if d<1000000         then Result:=          FormatFloat('#,##0.#', val)
    else                           Result:=        FormatFloat('#,##0', val)


end;
function amStr(value:Tdate):string; begin   result:= dateToStr(value); end;

function amBool(value:double;deff:boolean):Boolean;     begin   Result:=amBool(Real(value),deff);end;

function amBool(value:string):Boolean;                   begin   result:= amBool(value,FALSE); end;
function amBool(value:integer):Boolean;                  begin   result:= amBool(value,false); end;
function amBool(value:string;deff:boolean):Boolean;      begin  result:= StrToBoolDef(value,deff)end;
function amBool(value:integer;deff:boolean):Boolean;     begin   try result:= value.ToBoolean;  except result:= deff end; end;
function amBool(value:real;deff:boolean):Boolean;        begin   Result:=amBool( Integer(round(value)),deff);end;



function amDate (value:string):TDateTime;                    begin   TryStrToDate(value,result); end;
function amDate (value:string;deff:string):TDateTime;        begin  result:= amDateTime(value,deff) end;
function amDate (value:string;deff:TDate):TDate;         begin   Result:=StrToDateDef(value,deff)  end;
function amDateTime (value:string):TDateTime;            begin   TryStrToDateTime(value,Result); end;
function amDateTime2000 (value:string):TDateTime;        begin   result:= StrToDateTimeDef(value,StrToDateTime('01.01.2000 00:00:00:000'));end;



function amDateTime (value:string;deff:string):TDateTime;
var R:boolean;
begin
  try
     R:= TryStrToDateTime(value,result);
     if not  R then
     begin
       if not TryStrToDateTime(deff,result) then
       result:= StrToDateTime('01.01.2000 00:00:00:000');
     end;

  except result:= StrToDateTime(deff);  end;
end;
function amDateTime (value:string;deff:TDateTime):TDateTime;  begin Result:=StrToDateTimeDef(value,deff);  end;

function amColor   (value:string):TColor;   begin   result:= stringtoColor(value); end;
function amColor   (value:string;deff:TColor):TColor;  begin   try result:= stringtoColor(value);  except result:= deff;  end; end;
function amColor   (value:string;deff:string):TColor;begin   try result:= stringtoColor(value);  except result:= stringtoColor(deff);  end; end;


function MYstrtobool(str: string;def:boolean=false): Boolean;
begin
  try
    Result := StrToBoolDef(str,def);
  except
    Result := def;
  end;
end;
function MYstrtoint64(str: string;def:int64=0): int64;
begin
  try
   Result := strtoint64Def(str,def);
  except
    Result := def;
  end;
end;
function MYstrtoint(str: string;def:integer=0): integer;
begin
  try
    if length(TregEx.create('\d+').Match(str).Value)>10 then Result := 2147000000
    else Result := strtointDef(str,def);
  except
    Result := def;
  end;
end;
function MystrToColor(str:string;deff:Tcolor=0):Tcolor;
begin
  try
    Result := stringtoColor(str);
  except
    Result := deff;
  end;
end;
function MYStrToDateTime(str: string;Deff:string=''): TDateTime;
begin
  try
    Result := StrToDateTimeDef(str,StrToDateTime(Deff));
  except
   if Deff='' then Result := StrToDateTime('18.06.2019 05:39:53:283')
   else  Result := StrToDateTime(Deff);
  end;
end;




function serchAccObj(amyid: string;aObj:Tjsonobject;aPath:string='acc'): integer;
var
  i: integer;
begin
  Result := -1;
   try
      for i := 0 to aObj[aPath].Count - 1 do
      begin
        if (aObj[aPath].Items[i]['myid'] = amyid) then
        begin
          Result := i;
          break;
        end;
      end;
  except
    On E: Exception Do
    AmLog('ErrorCode Запись в файл AmUserType.serchAccObj',e);

  end;
end;
{
function serchAccControl(amyid: string;aScrollBox:TScrollBox;aClass:TClass): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to aScrollBox.ControlCount - 1 do
  begin
    try

       if aScrollBox.Controls[i].ClassType is aClass then
       begin

          if (aScrollBox.Controls[i] as aClass). = amyid then
          begin
            Result := i;
            break;
          end;

       end;

    except end;
  end;

end;
}
function CountPos(const subtext: string; Text: string): Integer;
begin
  if (length(subtext) = 0) or (length(Text) = 0) or (pos(subtext, Text) = 0)
  then
    Result := 0
  else
    Result := (length(Text) - length(StringReplace(Text, subtext, '',
      [rfReplaceAll]))) div length(subtext);
end;
function AmPosArrayIndexOfRevers(A:TArray<string>;Input:string;var Index:integer;var APos:integer):boolean;
var I:integer;
begin
  Result:=false;
  if Length(Input)>0 then
  for I := 0 to Length(A)-1 do
  begin
      APos:= posR2(A[i],Input);
      if APos<>0 then
      begin
          Index:=i;
          Result:=true;
          exit;
      end;
  end;
end;
function AmPosArrayIndexOf(A:TArray<string>;Input:string;var Index:integer;var APos:integer):boolean; overload;
var I:integer;
begin
  Result:=false;
  if Length(Input)>0 then
  for I := 0 to Length(A)-1 do
  begin
      APos:= pos(A[i],Input);
      if APos<>0 then
      begin
          Index:=i;
          Result:=true;
          exit;
      end;
  end;

end;

function  AmPosArray(A:TArray<string>;Input:string):boolean;
var I,X:integer;
begin
  Result:=AmPosArrayIndexOf(A,Input,I,X);
end;
function AmCmpArray(A1,A2:TArray<string>):boolean;
var i:integer;
begin
    Result:=false;
    if Length(A1) = Length(A2) then
    begin
      for I := 0 to length(A1)-1 do
      if A1[i]<>A2[i] then  exit;
    end;
   Result:=true;
end;
function generatPassC(count: integer): string;
var
   strW,strC: string;
begin
   Randomize;
   //string with all possible chars
  strW    := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  strC:='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789012345678901234567890';
   Result := '';
   repeat
     if Length(Result)>0 then
      Result := Result + strC[Random(Length(strC)) + 1]
      else
      Result := Result + strW[Random(Length(strW)) + 1];

   until (Length(Result) = count);


end;
function generatNumb(count: integer): string;
var
   strC: string;
begin
   Randomize;
   strC:='1234567890';
   Result := '';
   repeat
     Result := Result + strC[Random(Length(strC)) + 1];
   until (Length(Result) = count);



end;
function generatPass(count: integer): string;
var
   strW,strC: string;
begin
   Randomize;
   //string with all possible chars
  strW    := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  strC:='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
   Result := '';
   repeat
     if Length(Result)>0 then
      Result := Result + strW[Random(Length(strW)) + 1]
      else
      Result := Result + strC[Random(Length(strC)) + 1];

   until (Length(Result) = count);


   {
   exit;
  Result:='JGdu3E983koW';
  wordlist:='q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,Q,W,E,R,T,Y,U,I,O,P,A,S'+
  ',D,F,G,H,J,K,L,Z,X,C,V,B,N,M';
  countMAx:=CountPos(',',wordlist)-1;
  worded:='';
  for I := 0 to count  do
  begin
     worded:=worded+wordlist.Split([','])[math.RandomRange(0,countMAx)];
  end;
  Result:=worded;
   }
end;





function md5(s: string): string;
begin
  //IdHashMessageDigest
  Result := '';
  with TIdHashMessageDigest5.Create do
  try
  Result := AnsiLowerCase(HashStringAsHex(s));
  finally
  Free;
  end;
end;
function md5Bytes(s:TBytes): TBytes;
begin
  with TIdHashMessageDigest5.Create do
  try
  Result := TBytes(HashBytes(TIdBytes(s)));
  finally
  Free;
  end;
end;


function Hook2Ecode(s: string): string;
const

list0:array [0..100] of integer=(2,18,36,52,20,26,49,91,29,31,33,47,88,74,87,10,7,60,47,21,20,85,43,58,60,92,54,35,84,31,23,66,74,67,68,5,27,68,33,35,1,59,32,84,96,28,91,98,72,17,2,64,21,48,20,4,73,47,1,66,2,72,23,80,23,70,66,54,45,3,41,30,96,24,70,41,25,3,91,14,77,18,20,14,72,65,87,49,43,60,48,52,5,30,35,16,77,20,75,63,74);
list1:array [0..100] of integer=(60,22,61,18,67,59,18,62,79,74,19,31,51,21,94,90,53,3,28,23,46,59,29,73,40,30,61,76,46,37,70,96,88,95,61,25,25,57,41,31,1,45,80,52,41,17,10,72,40,97,25,27,9,37,64,20,3,98,9,66,19,84,90,74,47,51,18,34,20,68,63,83,75,29,66,65,52,16,37,1,67,69,76,26,42,34,47,90,83,51,53,2,47,51,17,58,12,49,66,21,64);

var
d,h:char;
i,contInput:integer;
begin



  //qwertyuiopasdfghjklzxcvbnm
  //qwdojiseprauyfghtklzbxvcnm18

   contInput:=length(s);

   for I := 99 downto 0 do
   begin
      if (list0[i]<contInput) and (list1[i]<contInput) then
      begin
         d:= s[list0[i]];
         h :=s[list1[i]];
         s[list1[i]]:= d;
         s[list0[i]]:=h;
      end;
   end;
  result:=s;

end;
function Hook2Decode(s: string): string;
const

list0:array [0..100] of integer=(2,18,36,52,20,26,49,91,29,31,33,47,88,74,87,10,7,60,47,21,20,85,43,58,60,92,54,35,84,31,23,66,74,67,68,5,27,68,33,35,1,59,32,84,96,28,91,98,72,17,2,64,21,48,20,4,73,47,1,66,2,72,23,80,23,70,66,54,45,3,41,30,96,24,70,41,25,3,91,14,77,18,20,14,72,65,87,49,43,60,48,52,5,30,35,16,77,20,75,63,74);
list1:array [0..100] of integer=(60,22,61,18,67,59,18,62,79,74,19,31,51,21,94,90,53,3,28,23,46,59,29,73,40,30,61,76,46,37,70,96,88,95,61,25,25,57,41,31,1,45,80,52,41,17,10,72,40,97,25,27,9,37,64,20,3,98,9,66,19,84,90,74,47,51,18,34,20,68,63,83,75,29,66,65,52,16,37,1,67,69,76,26,42,34,47,90,83,51,53,2,47,51,17,58,12,49,66,21,64);

var
d,h:char;
i,contInput:integer;
begin



  //qwertyuiopasdfghjklzxcvbnm
  //qwdojiseprauyfghtklzbxvcnm18

   contInput:=length(s);
   showmessage(inttostr(contInput));
   for I := 0 to 99 do
   begin
      if (list0[i]<contInput) and (list1[i]<contInput) then
      begin
         d:= s[list0[i]];
         h :=s[list1[i]];
         s[list1[i]]:= d;
         s[list0[i]]:=h;
      end;
   end;
  result:=s;
end;







function HookEcode(s: string): string;
const
list:string='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
b,c,contInput,counlist:integer;
ch:string;
Co2:integer;
  function num (s:string;m:integer):integer;
  var i:integer;
  begin
    result:=-1;

    for i := 1 to m do
    begin
       if list[i]= s then result:=i;
    end;
  end;
begin
    //df43c24069b4e1b24e577a33fcd3f04ea36f20811b0f6c5025dc6f2ca63bd65af5f4ebf6995758fae8251

    Co2:=math.RandomRange(10,20);
    contInput:=length(s);
    counlist:=  length(list) ;

     for b := 1 to contInput do
     begin
       ch:= s[b];
        c:=num(ch,counlist);
        if c>0 then
        begin
           c:=c+Co2;
            if c<counlist then
            begin
               ch:= list[c];
            end;
        end;
       result:= result +ch;
     end;

     //result:=result+ inttostr(Co2);

end;
function HookDecode(s: string): string;
const
list:string='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
b,c,contInput,counlist:integer;
ch:string;
Co2:integer;
  function num (s:string;m:integer):integer;
  var i:integer;
  begin
    result:=-1;

    for i := 1 to m do
    begin
       if list[i]= s then result:=i;
    end;
  end;
begin
    //df43c24069b4e1b24e577a33fcd3f04ea36f20811b0f6c5025dc6f2ca63bd65af5f4ebf6995758fae8251
    Co2:=strtoint(s[1]+s[2]);

    Delete(s,1,2);

    contInput:=length(s);
    counlist:=  length(list) ;

     for b := 1 to contInput do
     begin
       ch:= s[b];
        c:=num(ch,counlist);
        if c>0 then
        begin
           c:=c-Co2;
            if c<counlist then
            begin
               ch:= list[c];
            end;
        end;
       result:= result +ch;
     end;

   //  result:=result+ inttostr(Co2);

end;

Function GetPointerSize(Const P: Pointer): Integer;
Begin
  If P = Nil Then
    Result := -1
  Else
    Result := Integer(Pointer((Integer(p) - 4))^) And $7FFFFFFC - 4;
End;




constructor TAmAutoFreeObject.Create;
begin
  inherited;
 // AmAutoFreeObjectList.ObjectAdd(self);
end;
destructor  TAmAutoFreeObject.Destroy;
begin
  // if not AmAutoFreeObjectList.IsDestroing then

   inherited;
end;


 {
type TAmAutoFreeObject = class
       type
         TList = class (TList<TAmAutoFreeObject>)
           protected
             CounterId:Cardinal;
             IsMaxValuePassed :boolean;
             IsDestroing:boolean;
             function ObjectIndexOfBin(Item:TAmAutoFreeObject):integer;
             procedure ObjectAdd(Item:TAmAutoFreeObject);
             procedure ObjectDelete(Item:TAmAutoFreeObject);
           public
             constructor Create;
             destructor Destroy; override;
         end;
     private
      Id:Cardinal;
     public
      constructor Create;
      destructor Destroy; override;
end;


 }

function TAmMnMx.Random:integer;
begin
  Result:= math.RandomRange(mn,mx+1);
  Value:=Result;
end;
procedure TAmMnMx.MnMaxAProcent(AProcent:integer;AValue:integer);
begin
    mn:= (100-Aprocent)*AValue div 100;
    mx:= (100+Aprocent)*AValue div 100;
    Value:= AValue;
end;



procedure EmptyProcedure(p:Pointer);
begin

end;
procedure EmpProcedure(p:Pointer);
begin

end;



initialization
begin

   {$IFDEF DEBUG}
    reportmemoryleaksonshutdown:=false;
    {$ENDIF}
    {$IFDEF RELEASE}
     reportmemoryleaksonshutdown:=false;
    {$ENDIF}


   AmSystemInfo.FIsInitProgram:=false;
   ApplicationGlobalEvent:=TAmApplicationGlobalEvent.Create;
   AmAutoFreeObjectList:= TAmAutoFreeObject.TList.Create;
   AmFile.ExePathFile:= TAmVarCs<string>.create;
   AmFile.ExePathFile.Val:=ParamStr(0);


end;
finalization
begin
   FreeAndNil(ApplicationGlobalEvent);
   FreeAndNil(AmAutoFreeObjectList);
   FreeAndNil(AmFile.ExePathFile);
end;


end.





























