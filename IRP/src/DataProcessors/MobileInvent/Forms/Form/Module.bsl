
&AtClient
Var Sound Export; // See FillSoundList

#Region FormEvent

&AtClient
Procedure OnOpen(Cancel)
	Sound = FillSoundList();
	HideWhenMobileEmulatorBarcode();
	BarcodeHasAnyCharactersOnChange(Undefined);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ErrorSound = DataProcessors.MobileInvent.GetTemplate("ErrorSound");
EndProcedure

#EndRegion

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
//	ElsIf EventName = "NewBarcode" And Not IsInputAvailable() Then 
//		MobileSubsystem.Play(Sound.Error);
	EndIf;
EndProcedure

&AtClient
Procedure InputBarcode(Command)
	Barcode = 0;
	ShowInputNumber(New NotifyDescription("AddBarcodeAfterEnd", ThisForm), Barcode, R().SuggestionToUser_2);
EndProcedure

&AtClient
Procedure ScanEmulatorOnChange(Item)
	HideWhenMobileEmulatorBarcode();
EndProcedure

&AtClient
Procedure HideWhenMobileEmulatorBarcode()
	Items.InputBarcode.Visible = Not ScanEmulator;
	Items.SearchByBarcode.Visible = Not ScanEmulator;
	Items.GroupInputBarcode.Visible = ScanEmulator;
EndProcedure

&AtClient
Procedure BarcodeInputOnChange(Item)
	ManualInputBarcode(BarcodeInput);
EndProcedure

&AtClient
Procedure AddBarcodeAfterEnd(Number, AdditionalParameters) Export
	If Not ValueIsFilled(Number) Then
		Return;
	EndIf;
	Barcode = Format(Number, "NG=");
	ManualInputBarcode(Barcode);
EndProcedure

&AtClient
Procedure ManualInputBarcode(Barcode)
	If Object.Ref.IsEmpty() Then
		DocumentIsSet = False;
		Message = FindAndSetDocument(Barcode, DocumentIsSet);
		If Not DocumentIsSet Then
			CommonFunctionsClientServer.ShowUsersMessage(Message);
		EndIf;
		BarcodeInput = "";
		AttachIdleHandler("BeginEditBarcode", 0.1, True);
		Return;
	EndIf;
	SearchByBarcode(Undefined, Barcode);
EndProcedure

&AtClient
Async Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	Info = "";          
	
	If Object.Ref.IsEmpty() Then
		DocumentIsSet = False;
		Message = FindAndSetDocument(Result.Barcodes[0], DocumentIsSet);
		If Not DocumentIsSet Then
			CommonFunctionsClientServer.ShowUsersMessage(Message);
		EndIf;
		BarcodeInput = "";
		Return;
	EndIf;
	
	If Object.Ref.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_025, "DocumentRef");
	EndIf;
	
	For Each Row In Result.FoundedItems Do
		
		If Row.isService Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_026, Row.Item));
			BarcodeClient.CloseMobileScanner();
			AttachIdleHandler("BeginEditBarcode", 0.1, True);   
			MobileSubsystem.Play(Sound.Error);
			Return;
		EndIf;
		
		Filter = New Structure;
		Filter.Insert("Item", Row.Item);
		Filter.Insert("ItemKey", Row.ItemKey);
		Filter.Insert("SerialLotNumber", Row.SerialLotNumber);
		
		If Row.EachSerialLotNumberIsUnique And Object.ItemList.FindRows(Filter).Count() Then
			BarcodeInput = StrTemplate(R().Error_113, Row.SerialLotNumber);
			DoMessageBoxAsync(BarcodeInput, 10);   
			MobileSubsystem.Play(Sound.Error);

			Return;
		EndIf;
		
		NewRow = Object.ItemList.Insert(0);
		Items.ItemList.CurrentRow = Object.ItemList[0].GetID();

		NewRow.Key = New UUID;
		FillPropertyValues(NewRow, Row);
		NewRow.PhysCount = Row.Quantity;
		NewRow.Barcode = Result.Barcodes[0];
		NewRow.Date = CommonFunctionsServer.GetCurrentSessionDate();
		
		If Row.UseSerialLotNumber And NewRow.SerialLotNumber.IsEmpty() Then
			BarcodeClient.CloseMobileScanner();		
			StartEditQuantity(NewRow.GetID(), True);	
			If ScanEmulator Then
				BarcodeInput = "";			
				AttachIdleHandler("BeginEditBarcode", 0.1, True);	
			EndIf;
		EndIf;     
		MobileSubsystem.Vibrate();
	EndDo;
	
	If Result.FoundedItems.Count() Then
		If RuleEditQuantity Then
			BarcodeClient.CloseMobileScanner();
			StartEditQuantity(NewRow.GetID(), True);
		EndIf;
		Write();      
		BarcodeInput = "";
		If ScanEmulator Then
			AttachIdleHandler("BeginEditBarcode", 0.1, True);
		EndIf;
	Else           
		MobileSubsystem.Play(Sound.Error);
		If ScanEmulator Then
			Info = StrTemplate(R().S_019, Result.Barcodes[0]);
			BarcodeInput = "";
			AttachIdleHandler("BeginEditBarcode", 0.1, True);
		Else
			DoMessageBoxAsync(StrTemplate(R().S_019, Result.Barcodes[0]));
		EndIf;                                               
	EndIf;

EndProcedure

&AtClient
Procedure BarcodeHasAnyCharactersOnChange(Item)
	#IF MobileClient THEN
		If BarcodeHasAnyCharacters Then
			Items.BarcodeInput.SpecialTextInputMode = SpecialTextInputMode.Auto;
		Else
			Items.BarcodeInput.SpecialTextInputMode = SpecialTextInputMode.Digits;
		EndIf;
	#ENDIF
EndProcedure

&AtClient
Procedure BeginEditBarcode() Export
	ThisObject.CurrentItem = Items.BarcodeInput;
#If MobileClient Then
	ThisObject.BeginEditingItem();
#EndIf
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

&AtClient
Procedure ItemListBeforeRowChange(Item, Cancel)
	Cancel = True;
	StartEditQuantity(Items.ItemList.CurrentRow);
EndProcedure

&AtServer
Function FillSoundList()
	Sounds = New Structure;
	Sounds.Insert("Error", DataProcessors.MobileInvent.GetTemplate("ErrorSound"));
	Sounds.Insert("Done", DataProcessors.MobileInvent.GetTemplate("Done"));
	Sounds.Insert("SameItemKeyBarcode", DataProcessors.MobileInvent.GetTemplate("SameItemKeyBarcode"));
	Return Sounds;
EndFunction

