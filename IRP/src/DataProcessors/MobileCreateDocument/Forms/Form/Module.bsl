
// @strict-types

&AtClient
Var Sound Export; // See FillSoundList

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ByOneScan = True;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	Sound = FillSoundList();
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

// Search by barcode end.
// 
// Parameters:
//  Result - See BarcodeServer.SearchByBarcodes
//  AdditionalParameters - Structure - Additional parameters
&AtClient
Async Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	If Not Result.FoundedItems.Count() And Result.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, Result.Barcodes[0]));
		MobileSubsystem.Play(Sound.Error);
		Return;
	EndIf;

	For Each Row In Result.FoundedItems Do
#If Not WebClient Then		
		If Not ByOneScan Then
			Filter = New Structure();
			Filter.Insert("ItemKey", Row.ItemKey);
			Filter.Insert("SerialLotNumber", Row.SerialLotNumber);
			Filter.Insert("Unit", Row.Unit);
			SearchInItemList = Object.ItemList.FindRows(Filter);
			Row.Insert("CurrentQuantity", 0);
			Row.Insert("Diff", 0);
			Row.Insert("QuantityAtDocument", 0);
			If SearchInItemList.Count() Then
				Row.QuantityAtDocument = SearchInItemList[0].Quantity;
				Row.CurrentQuantity = SearchInItemList[0].Quantity;
				Row.Diff = Row.QuantityAtDocument - Row.CurrentQuantity;
			EndIf;
			If Row.UseSerialLotNumber And Not ValueIsFilled(Row.SerialLotNumber) Then
				MobileSubsystem.Play(Sound.NeedSerialLot);
			EndIf;
			NotifyOnClosing = New NotifyDescription("OnEditQuantityEnd", ThisObject);
			FormParameters = New Structure("FillingData, UseSerialLot", Row, Row.UseSerialLotNumber);
			OpenForm("DataProcessor.MobileCreateDocument.Form.RowForm", FormParameters, ThisObject, , , , NotifyOnClosing);
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
	Filter.Insert("SerialLotNumber", Row.SerialLotNumber);
	Filter.Insert("Unit", Row.Unit);
	SearchInItemList = Object.ItemList.FindRows(Filter);
	If SearchInItemList.Count() Then
		ItemListRow = SearchInItemList[0];
		ItemListRow.Quantity = ItemListRow.Quantity + Row.Quantity;
	Else
		ItemListRow = Object.ItemList.Add();
		ItemListRow.Item = Row.Item;
		ItemListRow.ItemKey = Row.ItemKey;
		ItemListRow.Unit = Row.Unit;
		ItemListRow.Quantity = Row.Quantity;
		ItemListRow.SerialLotNumber = Row.SerialLotNumber;
		ItemListRow.UseSerialLotNumber = Row.UseSerialLotNumber;
	EndIf;

	Modified = True;
	
	If Not ItemListRow = Undefined Then
		Items.ItemList.CurrentRow = ItemListRow.GetID();
	EndIf;
	
	MobileSubsystem.Play(Sound.Done);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item) Export
	
	CurrentRow = Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	NotifyOnClosing = New NotifyDescription("OnEditQuantityEnd", ThisObject);
	FormParameters = New Structure("FillingData, UseSerialLot", CurrentRow, CurrentRow.UseSerialLotNumber);
	OpenForm("DataProcessor.MobileCreateDocument.Form.RowForm", FormParameters, ThisObject, , , , NotifyOnClosing);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	Return;
EndProcedure

#Region CreateDocuments

&AtClient
Procedure CreateSC(Command)
	CreateDocument("ShipmentConfirmation");
EndProcedure

&AtClient
Procedure CreateIT(Command)
	CreateDocument("InventoryTransfer");
EndProcedure

&AtClient
Procedure CreateGR(Command)
	CreateDocument("GoodsReceipt");
EndProcedure

&AtServer
Procedure CreateDocument(DocName) 
	
	If Object.ItemList.Count() = 0 Then
		Return;
	EndIf;
	
	BeginTransaction();
	Try
		Wrapper = BuilderAPI.Initialize(DocName, , , "ItemList");
		BuilderAPI.SetProperty(Wrapper, "Date", CommonFunctionsServer.GetCurrentSessionDate());
		
		If DocName = "InventoryTransfer" Then
			BuilderAPI.SetProperty(Wrapper, "StoreReceiver", Object.StoreReceiver);
		EndIf;
		
		For Each ItemListRow In Object.ItemList Do
			NewRow = BuilderAPI.AddRow(Wrapper, "ItemList");
			BuilderAPI.SetRowProperty(Wrapper, NewRow, "Item", ItemListRow.Item);
			BuilderAPI.SetRowProperty(Wrapper, NewRow, "ItemKey", ItemListRow.ItemKey);
			BuilderAPI.SetRowProperty(Wrapper, NewRow, "Unit", ItemListRow.Unit);
			BuilderAPI.SetRowProperty(Wrapper, NewRow, "Quantity", ItemListRow.Quantity);
			
			If ItemListRow.UseSerialLotNumber Then
				NewSerialRow = BuilderAPI.AddRow(Wrapper, "SerialLotNumbers");
				NewSerialRow.Key = NewRow.Key;
				//@skip-check property-return-type, bsl-legacy-check-static-feature-access-for-unknown-left-part
				NewSerialRow.SerialLotNumber = ItemListRow.SerialLotNumber;
				NewSerialRow.Quantity = ItemListRow.Quantity;
			EndIf;
		EndDo;
		Doc = BuilderAPI.Write(Wrapper);
		Modified = False;
		CommonFunctionsClientServer.ShowUsersMessage(Doc.Ref);
		Object.ItemList.Clear();   
		Items.MainPages.CurrentPage = Items.PageItemList;      
		CommitTransaction();
	Except
		RollbackTransaction();
		CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.BriefErrorDescription(ErrorInfo()));
	EndTry;	
EndProcedure

#EndRegion

// Fill sound list.
// 
// Returns:
//  Structure - Fill sound list:
// * Error - BinaryData - 
// * Done - BinaryData - 
// * NeedSerialLot - BinaryData - 
&AtServer
Function FillSoundList()
	Sounds = New Structure;
	Sounds.Insert("Error", DataProcessors.MobileInvent.GetTemplate("ErrorSound"));
	Sounds.Insert("Done", DataProcessors.MobileInvent.GetTemplate("Done"));
	Sounds.Insert("NeedSerialLot", DataProcessors.MobileInvent.GetTemplate("SameItemKeyBarcode"));
	Return Sounds;
EndFunction

&AtClient
Procedure BeforeClose(Cancel, Exit, MessageText, StandardProcessing)
	If Object.ItemList.Count() > 0 Then
		Cancel = True;
	EndIf;
EndProcedure

&AtClient
Procedure ClearItemList(Command)
	Object.ItemList.Clear();
EndProcedure
