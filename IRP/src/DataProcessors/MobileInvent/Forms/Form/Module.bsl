
#Region Barcode
&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	Settings = BarcodeClient.GetBarcodeSettings();
	//@skip-warning
	Settings.MobileBarcodeModule = ThisObject;
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, , Settings);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure InputBarcode(Command)
	Barcode = 0;
	ShowInputNumber(New NotifyDescription("AddBarcodeAfterEnd", ThisForm), Barcode, R().SuggestionToUser_2);
EndProcedure

&AtClient
Procedure AddBarcodeAfterEnd(Number, AdditionalParameters) Export
	If Not ValueIsFilled(Number) Then
		Return;
	EndIf;
	Barcode = Format(Number, "NG=");
	If Object.Ref.IsEmpty() Then
		DocumentIsSet = False;
		Message = FindAndSetDocument(Barcode, DocumentIsSet);
		If Not DocumentIsSet Then
			CommonFunctionsClientServer.ShowUsersMessage(Message);
		EndIf;
		Return;
	EndIf;
	SearchByBarcode(Undefined, Barcode);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	If Object.Ref.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_025, "DocumentRef");
	EndIf;
	
	For Each Row In Result.FoundedItems Do
		
		If Row.isService Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_026, Row.Item));
			BarcodeClient.CloseMobileScanner();	
			Return;
		EndIf;
		
		NewRow = Object.ItemList.Add();
		NewRow.Key = New UUID;
		FillPropertyValues(NewRow, Row);
		NewRow.PhysCount = Row.Quantity;
		NewRow.Barcode = Result.Barcodes[0];
		NewRow.Date = CurrentDate();
		
		If Row.UseSerialLotNumber And NewRow.SerialLotNumber.IsEmpty() Then
			BarcodeClient.CloseMobileScanner();		
			StartEditQuantity(NewRow.GetID(), True);	
		EndIf;
	EndDo;
	
	If Result.FoundedItems.Count() Then
		If RuleEditQuantity Then
			BarcodeClient.CloseMobileScanner();
			StartEditQuantity(NewRow.GetID(), True);
		EndIf;
		Write();
	EndIf;

EndProcedure

// Scan barcode end mobile.
// 
// Parameters:
//  Barcode - String - Barcode
//  Result - Boolean - Result
//  Message - String - Message
//  Parameters - See BarcodeClient.GetBarcodeSettings
&AtClient
Procedure ScanBarcodeEndMobile(Barcode, Result, Message, Parameters) Export
	
	Message = "";
	
	If Object.Ref.IsEmpty() Then
		Message = FindAndSetDocument(Barcode, Result);

		If Result Then
			BarcodeClient.CloseMobileScanner();
		EndIf;
	Else
		ProcessBarcodeResult = Barcodeclient.ProcessBarcode(Barcode, Parameters);
		If ProcessBarcodeResult Then
			If Parameters.Result.FoundedItems[0].isService And Parameters.Filter.DisableIfIsService Then
				Message = StrTemplate(R().InfoMessage_026, Parameters.Result.FoundedItems[0].Item);
				Result = False;
			Else
				Message = R().S_018;
			EndIf;
		Else
			Result = False;
			Message = StrTemplate(R().S_019, Barcode);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure OpenRow(Command)
	RowSelected = Items.ItemList.CurrentRow;
	StartEditQuantity(RowSelected);
EndProcedure

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	StartEditQuantity(RowSelected);
EndProcedure

&AtClient
Procedure StartEditQuantity(Val RowSelected, AutoMode = False)
	
	If RowSelected = Undefined Then
		Return;
	EndIf;
	
	Structure = New Structure();
	ItemListRow = Object.ItemList.FindByID(RowSelected);
	Structure.Insert("ItemRef", Undefined);
	Structure.Insert("ItemKey", ItemListRow.ItemKey);
	Structure.Insert("SerialLotNumber", ItemListRow.SerialLotNumber);
	Structure.Insert("Quantity", ItemListRow.PhysCount);
	Structure.Insert("RowID", RowSelected);
	Structure.Insert("AutoMode", AutoMode);
	NotifyOnClosing = New NotifyDescription("OnEditQuantityEnd", ThisObject);
	OpenForm("DataProcessor.MobileInvent.Form.RowForm", Structure, ThisObject, , , , NotifyOnClosing);
EndProcedure

&AtClient
Procedure OnEditQuantityEnd(Result, AddInfo) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ItemListRow = Object.ItemList.FindByID(Result.RowID);
	ItemListRow.SerialLotNumber = Result.SerialLotNumber;
	ItemListRow.PhysCount = Result.Quantity;
	Write();
EndProcedure

&AtClient
Procedure CompleteLocation()
	NotifyDescription = New NotifyDescription("InputQuantityEnd", ThisObject);
	If Not SecondTryToInputQuantity Then
		Write();
		Text = R().QuestionToUser_018;
	Else
		Text = R().InfoMessage_009;
	EndIf;
	ShowInputNumber(NotifyDescription, "", Text);
EndProcedure

&AtClient
Procedure InputQuantityEnd(Quantity, Parameters) Export
	If Quantity <> Object.ItemList.Total("PhysCount") Then
		If Not SecondTryToInputQuantity Then
			SecondTryToInputQuantity = True;
			CompleteLocation();
		Else
			CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_010);
			Object.ItemList.Clear();
			Write();
		EndIf;
	Else
		SecondTryToInputQuantity = False;
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_011);
		SaveAndUpdateDocument();
	EndIf;
EndProcedure

&AtServer
Procedure SaveAndUpdateDocument()
	Object.Status = Catalogs.ObjectStatuses.Complete;
	Write();
	FillDocumentObject(Documents.PhysicalCountByLocation.EmptyRef());
EndProcedure

&AtServer
Function FindAndSetDocument(Number, Result, AddInfo = Undefined)

	Query = New Query();
	Query.Text =
	"SELECT
	|	PhysicalCountByLocation.Ref
	|FROM
	|	Document.PhysicalCountByLocation AS PhysicalCountByLocation
	|WHERE
	|	PhysicalCountByLocation.Number = &Number";

	Query.SetParameter("Number", Number(Number));

	QueryResult = Query.Execute();

	SelectionDetailRecords = QueryResult.Select();

	If SelectionDetailRecords.Next() Then
		FillDocumentObject(SelectionDetailRecords.Ref);
		Result = True;
		Return SelectionDetailRecords.Ref;
	Else
		Result = False;
		Return StrTemplate(R().Error_083, Number);
	EndIf;

EndFunction

&AtClient
Procedure DocumentRefOnChange(Item)
	FillDocumentObject(DocumentRef);
EndProcedure

&AtServer
Procedure FillDocumentObject(DocRef)
	DocumentRef = DocRef;
	If DocumentRef.IsEmpty() Then
		ValueToFormAttribute(Documents.PhysicalCountByLocation.CreateDocument(), "Object");
		LockFormDataForEdit();
	Else

		If DocRef.Status = Catalogs.ObjectStatuses.Complete Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_014, DocRef.Number));
			FillDocumentObject(Documents.PhysicalCountByLocation.EmptyRef());
			Return;
		ElsIf Not DocRef.ResponsibleUser.isEmpty() And Not DocRef.ResponsibleUser = SessionParameters.CurrentUser Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_012, DocRef.Number,
				DocRef.ResponsibleUser));
			FillDocumentObject(Documents.PhysicalCountByLocation.EmptyRef());
			Return;
		EndIf;

		DocObj = DocRef.GetObject();

		ValueToFormAttribute(DocObj, "Object");

		Object.ResponsibleUser = SessionParameters.CurrentUser;
		Write();
		Items.ItemListSerialLotNumber.Visible = DocRef.PhysicalInventory.UseSerialLot;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_013, DocObj.Number));
	EndIf;

	RuleEditQuantity = Object.RuleEditQuantity;
EndProcedure
