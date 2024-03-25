
&AtClient
Var Sound Export; // See FillSoundList

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAttributesFromExtensions(ThisObject, DataProcessors.MobileDesktop, Items.PageAddInfo);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	Sound = FillSoundList();
	SetVisible();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtServer
Procedure ItemOnChangeAtServer()
	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemKeys.Ref AS Ref
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Item = &Item
	|	AND NOT ItemKeys.DeletionMark";

	Query.SetParameter("Item", ItemRef);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		ItemKey = QuerySelection.Ref;
	Else
		ItemKey = Catalogs.ItemKeys.EmptyRef();
	EndIf;

EndProcedure

&AtServer
Procedure SetPictureView()
	ArrayOfFiles = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(ItemRef);
	If ArrayOfFiles.Count() Then
		If ArrayOfFiles[0].isPreviewSet Then
			PictureDecoration = GetURL(ArrayOfFiles[0], "Preview");
		EndIf;

	Else
		ArrayOfFiles = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(ItemKey);
		If ArrayOfFiles.Count() And ArrayOfFiles[0].isPreviewSet Then
			PictureDecoration = GetURL(ArrayOfFiles[0], "Preview");
		Else
			PictureDecoration = Undefined;
		EndIf;

	EndIf;
EndProcedure

&AtClient
Procedure ItemOnChange(ItemData)
	ItemOnChangeAtServer();
	Row = New Structure();
	Row.Insert("Item", ItemRef);
	Row.Insert("ItemKey", ItemKey);
	Row.Insert("Barcode", "");
	Barcodes = BarcodeClient.GetBarcodesByItemKey(ItemKey);
	If Barcodes.Count() Then
		Row.Insert("Barcode", Barcodes[0]);
	EndIf;
	FillData(Row);
EndProcedure

&AtClient
Procedure ItemKeyOnChange(ItemData)
	Row = New Structure();
	Row.Insert("Item", ItemRef);
	Row.Insert("ItemKey", ItemKey);
	Row.Insert("Barcode", "");
	Barcodes = BarcodeClient.GetBarcodesByItemKey(ItemKey);
	If Barcodes.Count() Then
		Row.Insert("Barcode", Barcodes[0]);
	EndIf;
	FillData(Row);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	If Result.FoundedItems.Count() Then
#If MobileClient Then
		MultimediaTools.CloseBarcodeScanning();
#EndIf
		If CountScanTheSameItem <= 1 Then
		Else
			If AlreadyScanCount = 0 Then
				AlreadyScanCount = 1;
			Else
				If ItemKey = Result.FoundedItems[0].ItemKey Then
					AlreadyScanCount = AlreadyScanCount + 1;
					
					If AlreadyScanCount = CountScanTheSameItem Then
						AlreadyScanCount = 0
					EndIf;
				Else
					MobileSubsystem.Play(Sound.Error);
					CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Mob_001, Result.FoundedItems[0].ItemKey, ItemKey));
					Return;
				EndIf;
			EndIf;
		EndIf;
	Else
		For Each Row In Result.Barcodes Do
			Barcode = StrTemplate(R().S_019, Row);
		EndDo;
		MobileSubsystem.Play(Sound.Error);
	EndIf;

	For Each Row In Result.FoundedItems Do
		FillData(Row);
		MobileSubsystem.Vibrate();
	EndDo;

EndProcedure

&AtClient
Procedure HideScanButtonOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure HideStatusButtonOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure FillData(Row)
	ItemRef =  Row.Item;
	ItemKey =  Row.ItemKey;
	If Not ValueIsFilled(ItemKey) Then
		ItemOnChangeAtServer();
	EndIf;
	SerialLotNumber = Row.SerialLotNumber;
	SetPictureView();
	ShowStatus();
	Items.SerialLotNumber.Visible = Row.UseSerialLotNumber;
	Barcode = Row.Barcode;
EndProcedure

&AtClient
Procedure Clear(Command)
	AlreadyScanCount = 0;
	Barcode = "";
	ItemKey = Undefined;
	ItemRef = Undefined;
	Photo = Undefined;
	PictureDecoration = Undefined;
	SerialLotNumber = Undefined;
	UseSeriallotNumber = False;
EndProcedure

&AtClient
Procedure ScanBarcodeEndMobile(Barcode, Result, Message, Parameters) Export
	ProcessBarcodeResult = Barcodeclient.ProcessBarcode(Barcode, Parameters);
	If ProcessBarcodeResult Then
		Message = R().S_018;
	Else
		Result = False;
		Message = StrTemplate(R().S_019, Barcode);
	EndIf;
EndProcedure

&AtServer
Procedure ShowStatus()
	Items.OK.Representation = ButtonRepresentation.Text;
	Items.NotOK.Representation = ButtonRepresentation.Text;
	If Not ValueIsFilled(ItemRef) Or Not ValueIsFilled(ItemKey) Then
		Return;
	EndIf;
	Reg = InformationRegisters.BarcodeScanInfoCheck.CreateRecordSet();
	Reg.Filter.Item.Set(ItemRef);
	Reg.Filter.ItemKey.Set(ItemKey);
	Reg.Filter.SerialLotNumber.Set(SerialLotNumber);
	Reg.Read();
	If Reg.Count() Then
		Status = Reg[0].Status;
		Items.OK.Representation = ?(Status, ButtonRepresentation.PictureAndText, ButtonRepresentation.Text);
		Items.NotOK.Representation = ?(Not Status, ButtonRepresentation.PictureAndText, ButtonRepresentation.Text);
	EndIf;
EndProcedure

&AtServer
Procedure WriteReg(Status)
	If Not ValueIsFilled(ItemRef) Or Not ValueIsFilled(ItemKey) Then
		Return;
	EndIf;
	Reg = InformationRegisters.BarcodeScanInfoCheck.CreateRecordSet();
	Reg.Filter.Item.Set(ItemRef);
	Reg.Filter.ItemKey.Set(ItemKey);
	Reg.Filter.SerialLotNumber.Set(SerialLotNumber);
	NewReg = Reg.Add();
	NewReg.Item = ItemRef;
	NewReg.ItemKey = ItemKey;
	NewReg.SerialLotNumber = SerialLotNumber;
	NewReg.Status = Status;
	NewReg.User = SessionParameters.CurrentUser;
	Reg.Write(True);

	Items.OK.Representation = ?(Status, ButtonRepresentation.PictureAndText, ButtonRepresentation.Text);
	Items.NotOK.Representation = ?(Not Status, ButtonRepresentation.PictureAndText, ButtonRepresentation.Text);
EndProcedure

&AtClient
Procedure OK(Command)
	WriteReg(True);
EndProcedure

&AtClient
Procedure NotOK(Command)
	WriteReg(False);
EndProcedure

&AtServer
Function FillSoundList()
	Sounds = New Structure;
	Sounds.Insert("Error", DataProcessors.MobileInvent.GetTemplate("ErrorSound"));
	Sounds.Insert("Done", DataProcessors.MobileInvent.GetTemplate("Done"));
	Sounds.Insert("SameItemKeyBarcode", DataProcessors.MobileInvent.GetTemplate("SameItemKeyBarcode"));
	Return Sounds;
EndFunction

&AtClient
Procedure SetVisible()
	Items.FormSearchByBarcode.Visible = Not HideScanButton;
	Items.GroupBottom.Visible = Not HideStatusButton;
EndProcedure
