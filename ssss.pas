program KR6;

uses crt;

type
TData = Integer;//Тип основных данных списка.
TPElem = ^TElem;//Указатель на элемент списка.
TElem = record //Элемент списка.
Data: TData; //Основные данные.
FDel: Boolean; //True - элемент должен быть удалён. Иначе - False.
PNext, PPrev: TPElem; //Указатели на следующий и на предыдущий элеметы списка.
end;

//Список.//
TDList = record
Cnt: Integer; //Количество элементов в списке.
PFirst: TPElem; //Указатель на первый элемент списка.
end;

//Меню.//
massiv = array [1..100] of string[128];

var
punkt: massiv;
num: integer;
pos, t: integer;
L: TDList;
Cmd, Cnt: Integer;

//Процедуры для работы с двунаправленным кольцевым списоком.

//Процедура начальной инициализации. Внимание! Эту процедуру можно выполнять
//только в отношении пустого списка. Иначе, будут утечки памяти.
{procedure Init(var aList : TDList);
begin
aList.Cnt := 0;
aList.PFirst := nil;
end;
}
//Удаление двунаправленного кольцевого списка из памяти и инициализация.
procedure Free(var aList: TDList);
var
PElem, PDel: TPElem;
c: char;
begin
if aList.PFirst = nil then Exit;

PElem := aList.PFirst;
repeat
PDel := PElem;
PElem := PElem^.PNext;
Dispose(PDel);
until PElem = aList.PFirst;
{Init(aList);}
writeln;
writeln('Список удален');
writeln('Для перехода к оглавлению нажмите Enter');
repeat
c := readkey;
until c = #13;
end;

//Добавление элемента в конец двунаправленного кольцевого списка.
//Если список пуст, то новый элемент становится первым элементом списка.
//Если список не пуст, то новый элемент добавляется перед первым элементом списка.
procedure Add(var aList: TDList; const aData: TData);
var
PElem: TPElem;
begin
New(PElem);
PElem^.Data := aData;
PElem^.FDel := False;
if aList.PFirst = nil then begin//Если список пуст.
aList.PFirst := PElem;
PElem^.PNext := PElem; //Указатель на самого себя.
PElem^.PPrev := PElem; //Указатель на самого себя.
end else begin//Если список не пуст.
PElem^.PNext := aList.PFirst;
PElem^.PPrev := aList.PFirst^.PPrev;
PElem^.PPrev^.PNext := PElem;
PElem^.PNext^.PPrev := PElem;
end;
Inc(aList.Cnt);
end;

//Диалог для добавления элементов в конец списка.
procedure WorkAdd(var aList: TDList);
var
c: char;
S: String;
Data: TData;
Code: Integer;
begin
clrscr;
Writeln('Добавление элементов в список.');
Writeln('Ввод каждого значения завершайте нажатием Enter.');
Writeln('Чтобы прекратить ввод оставьте пустую строку и нажмите Enter.');
repeat
Write('Элемент №', aList.Cnt + 1, ': ');
Readln(S);
if S = '' then begin
Writeln('Отмена.');
Code := 0;
end else begin
Val(S, Data, Code);
if Code = 0 then begin
Add(aList, Data);
Writeln('Элемент добавлен.');
Code := 1;
end else
Writeln('Неверный ввод. Повторите.');
end;
until Code = 0;
Writeln('Ввод элементов списка завершён.');
writeln;
writeln('Для перехода к оглавлению нажмите Enter');
repeat
c := readkey;
until c = #13;
end;


//Распечатка двунаправленного кольцевого списка.
procedure Print(const aList: TDList);
var
PElem: TPElem;
c: char;
begin
if aList.PFirst = nil then Exit;
PElem := aList.PFirst;
repeat
if PElem <> aList.PFirst then Write(', ');
Write(PElem^.Data);
PElem := PElem^.PNext;
until PElem = aList.PFirst;
writeln;
writeln('Для перехода к оглавлению нажмите Enter');
repeat
c := readkey;
until c = #13;
end;


procedure menu(var punkt: massiv; var num: integer);
var
x, y, i: integer;
c: char;
begin
clrscr;
x := 1;
y := 1;
gotoxy(x, y);
textcolor(White);
write('Список доступных действий:');
x := 1;
y := 1;
num := 1;
repeat
for i := 1 to 4 do
begin
gotoxy(x, y + i);
if i = num
then begin textcolor(0);textbackground(15); end
else begin textcolor(15);textbackground(0); end;
write(punkt[i]);
end;
c := readkey;
if c = #0 then
begin
c := readkey;
case c of
#32: if num = 1 then num := 4 else dec(num);
#40: if num = 4 then num := 1 else inc(num);
end;
end;
until c = #13;
textcolor(15);
textbackground(0);
end;

begin
clrscr;
writeln;
{Init(L); }
pos := 1;
punkt[1] := 'Добавление элемента в список';
punkt[2] := 'Показать список';
punkt[3] := 'Удалить список';
punkt[4] := 'Выход';
repeat
menu(punkt, num);
case num of
1: WorkAdd(L);
2:
if L.PFirst = nil then
Writeln('Спиосок пуст.')
else begin
writeln;
Writeln('Содержимое списка:');
Print(L);
Writeln;
end;
3, 4: Free(L);
else
Writeln('Незарегистрированная команда. Повторите ввод.');
end;
until num = 4;
writeln;
writeln('Работа программы завершена. Для выхода нажмите Enter');
Readln;
end.