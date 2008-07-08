unit GeckoStringNG;

interface


{type
  TGeckoString = class
  private
    FString:String;
  public
    class operator Add(a, b: TGeckoString): TGeckoString;
    class operator Implicit(Value : String) : TGeckoString;
    class operator Implicit(Value : WideString) : TGeckoString;
    class operator Implicit(Value : TGeckoString) : WideString;
  end;  }
//type


implementation

   {TMyClass = class
     class operator Add(a, b: TMyClass): TMyClass;      // TMyClass �^�� 2 �̃I�y�����h�̉��Z
     class operator Subtract(a, b: TMyClass): TMyclass; // TMyClass �^�̏��Z
     class operator Implicit(a: Integer): TMyClass;     // Integer ���� TMyClass �^�ւ̈Öق̕ϊ�
     class operator Implicit(a: TMyClass): Integer;     // TMyClass �^���� Integer �ւ̈Öق̕ϊ�
     class operator Explicit(a: Double): TMyClass;      // Double ���� TMyClass �ւ̖����I�ϊ�
   end;}

// Add �̎����̗�
{
class operator TMyClass.Add(a, b: TMyClass): TMyClass;
begin
   // ...
end;}
  {
var
x, y, b: TMyClass;
begin
   x := 12;      // Integer ����̈Öق̕ϊ�
   y := x + x;   // TMyClass.Add(a, b: TMyClass) �̌Ăяo���FTMyClass
   b := b + 100; // TMyClass.Add(b, TMyClass.Implicit(100)) �̌Ăяo��
end;}



end.
