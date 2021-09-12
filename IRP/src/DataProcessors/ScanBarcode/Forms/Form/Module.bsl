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
	ClientModule = FormOwner.GetProccessingModule().Client;   
	For Each Row In Object.ItemList Do
		If Row.Quantity = Row.ScannedQuantity Then
			Continue; 
		ElsIf Row.Quantity = 0 Then             
			NewRow =  FormOwner.Object.ItemList.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Quantity = Row.ScannedQuantity;      
			ClientModule.ItemListOnChange(FormOwner.Object, FormOwner, FormOwner.Items.ItemList, NewRow);
			ClientModule.ItemListQuantityOnChange(FormOwner.Object, FormOwner, FormOwner.Items.ItemList, NewRow);
		ElsIf Row.ScannedQuantity = 0 Then
			RowsToDelete = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey));
			For Each RowToDelete In RowsToDelete Do
				FormOwner.Object.ItemList.Delete(RowToDelete);
			EndDo;   
			ClientModule.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, FormOwner.Items.ItemList);
		ElsIf Row.Quantity > Row.ScannedQuantity Then
			Diff = Row.Quantity - Row.ScannedQuantity;
			RowsWithDiff = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey));
			RowWithDiff = RowsWithDiff[0];
			RowWithDiff.Quantity = RowWithDiff.Quantity - Diff;
			ClientModule.ItemListQuantityOnChange(FormOwner.Object, FormOwner, FormOwner.Items.ItemList, NewRow);
		ElsIf Row.Quantity < Row.ScannedQuantity Then       
			Diff = Row.ScannedQuantity - Row.Quantity; 
			RowsWithDiff = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey));
			RowWithDiff = RowsWithDiff[0];
			RowWithDiff.Quantity = RowWithDiff.Quantity + Diff;
			ClientModule.ItemListQuantityOnChange(FormOwner.Object, FormOwner, FormOwner.Items.ItemList, NewRow);
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
	AddInfo = New Structure("ClientModule", ThisObject);
	DocumentsClient.SearchByBarcode(Barcode, ThisObject, ThisObject, ThisObject, , AddInfo);
EndProcedure

&AtClient
Async Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	If Not AdditionalParameters.FoundedItems.Count()
		And AdditionalParameters.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, AdditionalParameters.Barcodes[0]));
		Return;
	EndIf;

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", ThisObject);
	NotifyParameters.Insert("Object", ThisObject);

	ItemListRow = Undefined;
	For Each Row In AdditionalParameters.FoundedItems Do
#If Not WebClient Then		
		If Not ByOneScan Then
			Row.Quantity = Await InputNumberAsync(0, R().QuestionToUser_018);
		EndIf;
#EndIf
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