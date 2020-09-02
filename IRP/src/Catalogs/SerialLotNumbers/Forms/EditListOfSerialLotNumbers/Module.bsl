
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.RowKey = Parameters.RowKey;
	ThisObject.Item = Parameters.Item;
	ThisObject.ItemKey = Parameters.ItemKey;
	For Each Row In Parameters.SerialLotNumbers Do
		NewRow = ThisObject.SerialLotNumbers.Add();
		NewRow.SerialLotNumber = Row.SerialLotNumber;
		NewRow.Quantity = Row.Quantity;
	EndDo;	
EndProcedure

&AtClient
Procedure Ok(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	Result = New Structure();
	Result.Insert("RowKey", ThisObject.RowKey);
	Result.Insert("Item", ThisObject.Item);
	Result.Insert("ItemKey", ThisObject.ItemKey);
	Result.Insert("SerialLotNumbers", New Array());
	For Each Row In ThisObject.SerialLotNumbers Do
		Result.SerialLotNumbers.Add(
		New Structure("SerialLotNumber, Quantity", Row.SerialLotNumber, Row.Quantity));
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	RowIndex = 0;
	For Each Row In SerialLotNumbers Do
		If Not ValueIsFilled(Row.SerialLotNumber) Then
			Cancel = True; 
			CommonFunctionsClientServer.ShowUsersMessage(
			StrTemplate(R().Error_010, "Serial lot number"), 
			"SerialLotNumbers[" + Format(RowIndex, "NZ=0; NG=0;") + "].SerialLotNumber", 
			ThisObject);
		EndIf;
		If Not ValueIsFilled(Row.Quantity) Then
			Cancel = True; 
			CommonFunctionsClientServer.ShowUsersMessage(
			StrTemplate(R().Error_010, "Quantity"), 
			"SerialLotNumbers[" + Format(RowIndex, "NZ=0; NG=0;") + "].Quantity", 
			ThisObject);
		EndIf;		
		RowIndex = RowIndex + 1;
	EndDo;	
EndProcedure
