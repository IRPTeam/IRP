&AtClient
Var Sound Export; // See FillSoundList

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
	Sound = FillSoundList();
EndProcedure

&AtServer
Procedure FillItemList(Val Owner)
	ItemTable = Owner.ItemList.Unload();
	HideDecoration = ItemTable.Count() = 0; 
	
	SerialLotTable = Undefined;
	If TypeOf(Owner) = Type("FormDataStructure") Then
		If Owner.Property("UseSerialLotNumber") And Owner.UseSerialLotNumber = False
				Or Owner.Property("UseSerialLot") And Owner.UseSerialLot = False Then
			ThisObject.UseSerialLot = False;
		ElsIf Owner.Property("SerialLotNumbers") Then
			SerialLotTable = Owner.SerialLotNumbers.Unload();
			ThisObject.UseSerialLot = True;
		Else
			If Not ItemTable.Columns.Find("SerialLotNumber") = Undefined Then
				SerialLotTable = ItemTable;
				ThisObject.UseSerialLot = True;
			EndIf;
		EndIf;
	EndIf;
	
	Object.ItemList.Load(
		InformationRegisters.T1010S_ScannedBarcode.GetCommonTable(
			Object.Basis, ItemTable, ThisObject.UseSerialLot, SerialLotTable));
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
		If Row.Quantity = Row.ScannedQuantity And Row.SerialLotNumber = Row.ScannedSerialLotNumber Then
			Continue; 
			
		ElsIf Row.Quantity = 0 Then             
			AddItemAndSerialLotNumber(Row);
						
		ElsIf Row.ScannedQuantity = 0 Then
			
			If ThisObject.UseSerialLot And Row.UseSerialLotNumber Then
				DeleteSerialLotNumber(Row, ClientModule);
			Else
				RowsToDelete = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey));
				For Each RowToDelete In RowsToDelete Do
					FormOwner.Object.ItemList.Delete(RowToDelete);
				EndDo;   
				ClientModule.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, FormOwner.Items.ItemList);
			EndIf;
			
		ElsIf Not Row.Quantity = Row.ScannedQuantity And Row.SerialLotNumber = Row.ScannedSerialLotNumber Then
			
			If ThisObject.UseSerialLot And Row.UseSerialLotNumber Then
				DeleteSerialLotNumber(Row, ClientModule);
				AddItemAndSerialLotNumber(Row);
			Else
				RowWithDiff = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey))[0];
				ViewClient_V2.SetItemListQuantity(FormOwner.Object, FormOwner, RowWithDiff, Row.ScannedQuantity);
			EndIf;
					
		ElsIf Not Row.SerialLotNumber = Row.ScannedSerialLotNumber Then
			ChangeSerialLotNumber(Row, ClientModule);
			
		Else
			Continue;
		EndIf;
	EndDo;        
	
	FormOwner.Modified = True;
	Close();
	
EndProcedure

&AtClient
Procedure AddItemAndSerialLotNumber(Row)
	
	FillingValues = New Structure();
	FillingValues.Insert("Item"           , Row.Item);
	FillingValues.Insert("ItemKey"        , Row.ItemKey);
	FillingValues.Insert("SerialLotNumber", Row.ScannedSerialLotNumber);
	FillingValues.Insert("Unit"           , Row.Unit);
	FillingValues.Insert("Quantity"       , Row.ScannedQuantity);
	NewRow = ViewClient_V2.ItemListAddFilledRow(FormOwner.Object, FormOwner, FillingValues);
	
	If ThisObject.UseSerialLot And Row.UseSerialLotNumber Then
		SerialLotNumberInfo = New Structure;
		SerialLotNumberInfo.Insert("RowKey", NewRow.Key);
		SerialLotNumberInfo.Insert("SerialLotNumbers", New Array);
		
		SerialLotNumberData = New Structure;
		SerialLotNumberData.Insert("SerialLotNumber", Row.ScannedSerialLotNumber);
		SerialLotNumberData.Insert("Quantity", Row.ScannedQuantity);
		SerialLotNumberInfo.SerialLotNumbers.Add(SerialLotNumberData);
		
		FormParameters = New Structure;
		FormParameters.Insert("Form", FormOwner);
		FormParameters.Insert("Object", FormOwner.Object);
		
		SerialLotNumberClient.AddNewSerialLotNumbers(SerialLotNumberInfo, FormParameters);
	EndIf;
	
EndProcedure

&AtClient
Procedure DeleteSerialLotNumber(Row, ClientModule)

	If FormOwner.Object.Property("SerialLotNumbers") Then
		
		SerialLotMap = New Map;
		
		RowsToDelete = FormOwner.Object.SerialLotNumbers.FindRows(New Structure("SerialLotNumber", Row.SerialLotNumber));
		For Each RowToDelete In RowsToDelete Do
			If Not ValueIsFilled(Row.SerialLotNumber) Then
				ItemRows = FormOwner.Object.ItemList.FindRows(New Structure("Key", RowToDelete.Key));
				If ItemRows.Count() Then
					If Not ItemRows[0].ItemKey = Row.ItemKey Then
						Continue;
					EndIf;
				EndIf;
			EndIf;
			If SerialLotMap.Get(RowToDelete.Key) = Undefined Then
				SerialLotMap.Insert(RowToDelete.Key, RowToDelete.Quantity);
			Else
				SerialLotMap.Insert(RowToDelete.Key, SerialLotMap.Get(RowToDelete.Key) + RowToDelete.Quantity);
			EndIf;
			FormOwner.Object.SerialLotNumbers.Delete(RowToDelete);
		EndDo;
		
		If SerialLotMap.Count() Then
			For Each SerialLotKeyValue In SerialLotMap Do
				LineKey = SerialLotKeyValue.Key; // String
				LineQuantity = SerialLotKeyValue.Value; // Number
				ItemRows = FormOwner.Object.ItemList.FindRows(New Structure("Key", LineKey));
				If ItemRows.Count() Then
					ItemRow = ItemRows[0];
					If ItemRow.Quantity > LineQuantity Then
						ViewClient_V2.SetItemListQuantity(
							FormOwner.Object, FormOwner, ItemRow, (ItemRow.Quantity - LineQuantity));
					Else
						FormOwner.Object.ItemList.Delete(ItemRow);
						ClientModule.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, FormOwner.Items.ItemList);
					EndIf;
				EndIf;
			EndDo;
			SerialLotNumberClient.UpdateSerialLotNumbersPresentation(FormOwner.Object);
			SourceOfOriginClient.UpdateSourceOfOriginsQuantity(FormOwner.Object, FormOwner);
		Else
			RowsToDelete = FormOwner.Object.ItemList.FindRows(New Structure("ItemKey", Row.ItemKey));
			For Each RowToDelete In RowsToDelete Do
				FormOwner.Object.ItemList.Delete(RowToDelete);
			EndDo;   
			ClientModule.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, FormOwner.Items.ItemList);
		EndIf;
		
	Else
		
		RowsToDelete = FormOwner.Object.ItemList.FindRows(
			New Structure("ItemKey, SerialLotNumber", Row.ItemKey, Row.SerialLotNumber));
		For Each RowToDelete In RowsToDelete Do
			FormOwner.Object.ItemList.Delete(RowToDelete);
		EndDo;   
		ClientModule.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, FormOwner.Items.ItemList);
		
	EndIf;
	
EndProcedure

&AtClient
Procedure ChangeSerialLotNumber(Row, ClientModule)

	If FormOwner.Object.Property("SerialLotNumbers") Then
		
		SerialLotMap = New Map;
		
		RowsToChange = FormOwner.Object.SerialLotNumbers.FindRows(
			New Structure("SerialLotNumber", Row.SerialLotNumber));
			
		isFirst = True;
		For Each RowToChange In RowsToChange Do
			If isFirst Then
				SerialLotMap.Insert(RowToChange.Key, Row.ScannedQuantity - Row.Quantity);
				RowToChange.Quantity = Row.ScannedQuantity;
			Else
				If SerialLotMap.Get(RowToChange.Key) = Undefined Then
					SerialLotMap.Insert(RowToChange.Key, 0 - RowToChange.Quantity);
				Else
					SerialLotMap.Insert(RowToChange.Key, SerialLotMap.Get(RowToChange.Key) - RowToChange.Quantity);
				EndIf;
				FormOwner.Object.SerialLotNumbers.Delete(RowToChange);
			EndIf;
		EndDo;
		
		For Each SerialLotKeyValue In SerialLotMap Do
			LineKey = SerialLotKeyValue.Key; // String
			LineQuantity = SerialLotKeyValue.Value; // Number
			ItemRows = FormOwner.Object.ItemList.FindRows(New Structure("Key", LineKey));
			If ItemRows.Count() Then
				ItemRow = ItemRows[0];
				NewQuantity = ItemRow.Quantity + LineQuantity; 
				If NewQuantity > 0 Then
					ViewClient_V2.SetItemListQuantity(
						FormOwner.Object, FormOwner, ItemRow, NewQuantity);
				Else
					FormOwner.Object.ItemList.Delete(ItemRow);
					ClientModule.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, FormOwner.Items.ItemList);
				EndIf;
			EndIf;
		EndDo;
		
		SerialLotNumberClient.UpdateSerialLotNumbersPresentation(FormOwner.Object);
		SourceOfOriginClient.UpdateSourceOfOriginsQuantity(FormOwner.Object, FormOwner);
		
	Else
		
		RowsToChange = FormOwner.Object.ItemList.FindRows(
			New Structure("SerialLotNumber, Quantity", Row.SerialLotNumber, Row.Quantity));
			
		For Each RowToChange In RowsToChange Do
			RowToChange.SerialLotNumber = Row.ScannedSerialLotNumber;
			ViewClient_V2.SetItemListQuantity(FormOwner.Object, FormOwner, RowToChange, Row.ScannedQuantity);
		EndDo;   
		
	EndIf;
	
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

	If Not Result.FoundedItems.Count() And Result.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, Result.Barcodes[0]));
		MobileSubsystem.Play(Sound.Error);
		Return;
	EndIf;

	For Each Row In Result.FoundedItems Do
		If Not ThisObject.UseSerialLot Then
			Row.SerialLotNumber = PredefinedValue("Catalog.SerialLotNumbers.EmptyRef");
		EndIf;
#If Not WebClient Then		
		If Not ByOneScan Then
			Filter = New Structure();
			Filter.Insert("ItemKey", Row.ItemKey);
			Filter.Insert("ScannedSerialLotNumber", Row.SerialLotNumber);
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
			If ThisObject.UseSerialLot And Row.UseSerialLotNumber And Not ValueIsFilled(Row.SerialLotNumber) Then
				MobileSubsystem.Play(Sound.NeedSerialLot);
			EndIf;
			NotifyOnClosing = New NotifyDescription("OnEditQuantityEnd", ThisObject);
			FormParameters = New Structure("FillingData, UseSerialLot", 
				Row, ThisObject.UseSerialLot And Row.UseSerialLotNumber);
			OpenForm("DataProcessor.ScanBarcode.Form.RowForm", FormParameters, ThisObject, , , , NotifyOnClosing);
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
	Filter.Insert("ScannedSerialLotNumber", Row.SerialLotNumber);
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
		ItemListRow.ScannedSerialLotNumber = Row.SerialLotNumber;
		ItemListRow.UseSerialLotNumber = Row.UseSerialLotNumber;
	EndIf;

	SaveBarcode(Object.Basis, Row.Barcode, Row.Quantity);
	Modified = True;
	
	If Not ItemListRow = Undefined Then
		Items.ItemList.CurrentRow = ItemListRow.GetID();
	EndIf;
	
	MobileSubsystem.Play(Sound.Done);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item) Export
	Return;
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtServerNoContext
Procedure SaveBarcode(Basis, Barcode, Quantity)
	InformationRegisters.T1010S_ScannedBarcode.SaveBarcode(Basis, Barcode, Quantity);
EndProcedure

&AtServer
Procedure SetParameters(Name, Value)
	ScanHistory.Parameters.SetParameterValue(Name, Value);
EndProcedure

&AtServer
Function FillSoundList()
	Sounds = New Structure;
	Sounds.Insert("Error", DataProcessors.MobileInvent.GetTemplate("ErrorSound"));
	Sounds.Insert("Done", DataProcessors.MobileInvent.GetTemplate("Done"));
	Sounds.Insert("NeedSerialLot", DataProcessors.MobileInvent.GetTemplate("SameItemKeyBarcode"));
	Return Sounds;
EndFunction
