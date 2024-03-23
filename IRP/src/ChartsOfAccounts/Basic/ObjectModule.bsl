
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	Result = GetSearchCodeAndOrder(ThisObject.Code);
	ThisObject.SearchCode = Result.SearchCode;
	If Not ValueIsFilled(ThisObject.Order) Then
		ThisObject.Order = Result.Order;
	EndIf;
EndProcedure

Function GetSearchCodeAndOrder(_Code)
	_SearchCode = _Code;
	Symbols = ".,/|\() ";
	For i = 0 To StrLen(Symbols) - 1 Do
		_SearchCode = StrReplace(_SearchCode, Mid(Symbols, i, 1), "");
	EndDo;
	
	_Order = "";
	For i = 1 To StrLen(_Code) Do
		Symbol = Mid(_Code, i, 1);
		If StrFind("0123456789", Symbol) = 0 Then
			Continue;
		EndIf;
		_Order = "" + _Order + Symbol;
	EndDo;
	
	If Not ValueIsFilled(_Order) Then
		_Order = _SearchCode;
	EndIf;
	
	Return New Structure("SearchCode, Order", _SearchCode, _Order);
EndFunction	
