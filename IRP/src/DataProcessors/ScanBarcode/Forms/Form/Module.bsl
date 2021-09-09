
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Object.Basis = Parameters.Basis;
	FillItemList();
	
	SetParameters("User", SessionParameters.CurrentUser);
	SetParameters("Basis", Object.Basis);
	SetParameters("OnlyMy", OnlyMy);
EndProcedure

&AtServer
Procedure FillItemList()
	Object.ItemList.Load(InformationRegisters.T1010S_ScannedBarcode.GetCommonTable(Object.Basis));
EndProcedure

&AtClient
Procedure SetFilterOnlyMy(Command)
	OnlyMy = Not OnlyMy;
	Items.SetFilterOnlyMy.Check = OnlyMy;
	SetParameters("OnlyMy", OnlyMy);
EndProcedure

&AtClient
Procedure MainPagesOnCurrentPageChange(Item, CurrentPage)
	SetParameters("OnlyMy", OnlyMy);
EndProcedure

&AtClient
Procedure Done(Command)
	For Each Row In Object.ItemList Do
		// TODO: Finish export data
	EndDo;
EndProcedure

&AtClient
Procedure ScanHistoryRefreshRequestProcessing(Item)
	SetParameters("OnlyMy", OnlyMy);
EndProcedure

&AtClient
Procedure ScanHistoryOnChange(Item)
	FillItemList();
EndProcedure

&AtClient
Procedure ItemListRefreshRequestProcessing(Item)
	FillItemList();
EndProcedure


&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	AddInfo = New Structure("ClientModule", ThisObject);
	DocumentsClient.SearchByBarcode(Barcode, ThisObject, ThisObject, ThisObject, , AddInfo);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", ThisObject);
	NotifyParameters.Insert("Object", ThisObject);
	
	ItemListRow = Undefined;
	For Each Row In AdditionalParameters.FoundedItems Do
		
		Filter = New Structure();
		Filter.Insert("ItemKey", Row.ItemKey);
		Filter.Insert("Unit", Row.Unit);
		
		SearchInItemList = Object.ItemList.FindRows(Filter);
		
		If SearchInItemList.Count() Then
			ItemListRow = SearchInItemList[0];
			ItemListRow.ScannedQuantity = ItemListRow.ScannedQuantity + Row.Quantity;
		Else
			ItemListRow = Object.ItemList.Add();
			ItemListRow.Item = Row.Item;
			ItemListRow.ItemKey = Row.ItemKey;
			ItemListRow.Unit = Row.Unit;
			ItemListRow.ScannedQuantity = Row.Quantity;
		EndIf;
		
		SaveBarcode(Object.Basis, Row.Barcode, Row.Quantity);
		Modified = True;
	EndDo;
	
	If Not ItemListRow = Undefined Then
		Items.ItemList.CurrentRow = ItemListRow.GetID(); 
	EndIf;
	
EndProcedure

&AtClient
Procedure ItemListOnChange(Item) Export
	Return;
EndProcedure

&AtServerNoContext
Procedure SaveBarcode(Basis, Barcode, Quantity)
	InformationRegisters.T1010S_ScannedBarcode.SaveBarcode(Basis, Barcode, Quantity);
EndProcedure

&AtServer
Procedure SetParameters(Name, Value)
	ScanHistory.Parameters.SetParameterValue(Name, Value);
EndProcedure