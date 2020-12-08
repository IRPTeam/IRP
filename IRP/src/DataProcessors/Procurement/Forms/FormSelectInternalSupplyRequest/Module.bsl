
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each Row In Parameters.ArrayOfSupplyRequest Do
		NewRow = ThisObject.TableOfInternalSupplyRequest.Add();
		NewRow.InternalSupplyRequest = Row.InternalSupplyRequest;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity; 
		NewRow.ProcurementDate = Row.ProcurementDate;
		NewRow.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfResult = New Array();
	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		If Not Row.Use Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("InternalSupplyRequest", Row.InternalSupplyRequest);
		NewRow.Insert("RowKey", Row.RowKey);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("ProcurementDate", Row.ProcurementDate);
		ArrayOfResult.Add(NewRow);
	EndDo;
	Close(ArrayOfResult);
EndProcedure

&AtClient
Procedure TableOfInternalSupplyRequestBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TableOfInternalSupplyRequestBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CheckAll(Command)
	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		Row.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		Row.Use = False;
	EndDo;
EndProcedure
