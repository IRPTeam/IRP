
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentName = Parameters.DocumentName;
	For Each Row In Parameters.TransactionTypes Do
		NewRow = ThisObject.TransactionTypes.Add();
		NewRow.TransactionType = Row.TransactionType;
		NewRow.Use = Row.Use;
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure();
	Result.Insert("DocumentName", ThisObject.DocumentName);
	ArrayOfTransactionTypes = New Array();
	For Each Row In ThisObject.TransactionTypes Do
		If Not Row.Use Then
			Continue;
		EndIf;
		ArrayOfTransactionTypes.Add(New Structure("TransactionType", Row.TransactionType));
	EndDo;
	Result.Insert("TransactionTypes", ArrayOfTransactionTypes);
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure TransactionTypesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TransactionTypesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure
