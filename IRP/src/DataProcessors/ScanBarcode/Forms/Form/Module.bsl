&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Object.Basis = Parameters.Basis;

	SetParameters("User", SessionParameters.CurrentUser);
	SetParameters("Basis", Object.Basis);
	SetParameters("OnlyMy", OnlyMy);
EndProcedure

&AtClient
Procedure EnterCountOnScan(Command)
	Items.ItemListEnterCountOnScan.Check = Not Items.ItemListEnterCountOnScan.Check;
	ByOneScan = Items.ItemListEnterCountOnScan.Check; 
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	FillItemList(FormOwner.Object);
EndProcedure

&AtServer
Procedure FillItemList(Val Owner)
	VT = Owner.ItemList.Unload();
	Object.ItemList.Load(InformationRegisters.T1010S_ScannedBarcode.GetCommonTable(Object.Basis, VT));
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
	ClientModule = FormOwner.GetProcessingModule().Client;   
	For Each Row In Object.ItemList Do
		If Row.Quantity = Row.ScannedQuantity Then
			Continue; 
		ElsIf Row.Quantity = 0 Then             
			
			FillingValues = New Structure();
			FillingValues.Insert("Item"     , Row.Item);
			FillingValues.Insert("ItemKey"  , Row.ItemKey);
			FillingValues.Insert("Unit"     , Row.Unit);
			FillingValues.Insert("Quantity" , Row.ScannedQuantity);
			NewRow = ViewClient_V2.ItemListAddFilledRow(FormOwner.Object, FormOwner, FillingValues);
						
		ElsIf Row.ScannedQuantity = 0 Then
			RowsToDelete = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey));
			For Each RowToDelete In RowsToDelete Do
				FormOwner.Object.ItemList.Delete(RowToDelete);
			EndDo;   
			ClientModule.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, FormOwner.Items.ItemList);
		ElsIf Row.Quantity > Row.ScannedQuantity Then
			
			Diff = Row.Quantity - Row.ScannedQuantity;
			RowWithDiff = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey))[0];
			ViewClient_V2.SetItemListQuantity(FormOwner.Object, FormOwner, RowWithDiff, Diff);
					
		ElsIf Row.Quantity < Row.ScannedQuantity Then  
			
			Diff = Row.ScannedQuantity - Row.Quantity;
			RowWithDiff = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey))[0];
			ViewClient_V2.SetItemListQuantity(FormOwner.Object, FormOwner, RowWithDiff, Diff);
			
		Else
			Continue;
		EndIf;
	EndDo;        
	
	FormOwner.Modified = True;
	Close();
EndProcedure

&AtClient
Procedure ScanHistoryRefreshRequestProcessing(Item)
	SetParameters("OnlyMy", OnlyMy);
EndProcedure

&AtClient
Procedure ScanHistoryOnChange(Item)
	FillItemList(FormOwner.Object);
EndProcedure

&AtClient
Procedure ItemListRefreshRequestProcessing(Item)
	FillItemList(FormOwner.Object);
EndProcedure
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Async Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	If Not Result.FoundedItems.Count()
		And Result.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, Result.Barcodes[0]));
		Return;
	EndIf;

	For Each Row In Result.FoundedItems Do
#If Not WebClient Then		
		If Not ByOneScan Then
			Filter = New Structure();
			Filter.Insert("ItemKey", Row.ItemKey);
			Filter.Insert("Unit", Row.Unit);
			SearchInItemList = Object.ItemList.FindRows(Filter);
			Row.Insert("CurrentQuantity", 0);
			Row.Insert("Diff", 0);
			Row.Insert("QuantityAtDocument", 0);
			If SearchInItemList.Count() Then
				Row.QuantityAtDocument = SearchInItemList[0].Quantity;
				Row.CurrentQuantity = SearchInItemList[0].ScannedQuantity;
				Row.Diff = Row.QuantityAtDocument - Row.CurrentQuantity;
			EndIf;
			NotifyOnClosing = New NotifyDescription("OnEditQuantityEnd", ThisObject);
			OpenForm("DataProcessor.ScanBarcode.Form.RowForm", New Structure("FillingData" ,Row), ThisObject, , , , NotifyOnClosing);
		Else
			OnEditQuantityEnd(Row);
		EndIf;
#Else		
		OnEditQuantityEnd(Row);
#EndIf
		
	EndDo;

EndProcedure

&AtClient
Procedure OnEditQuantityEnd(Row, AddInfo = Undefined) Export
	If Row = Undefined Then
		Return;
	EndIf;
		
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