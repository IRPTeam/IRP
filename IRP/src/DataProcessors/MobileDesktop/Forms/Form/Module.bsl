
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAttributesFromExtensions(ThisObject, DataProcessors.MobileDesktop, Items.PageAddInfo);
EndProcedure

&AtServer
Procedure ItemOnChangeAtServer()
	Query = New Query;
	Query.Text = 
		"SELECT
		|	ItemKeys.Ref AS Ref
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|WHERE
		|	ItemKeys.Item = &Item
		|	AND NOT ItemKeys.DeletionMark";
	
	Query.SetParameter("Item", Item);
	
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
	ArrayOfFiles = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(Item);
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
	Row = New Structure;
	Row.Insert("Item", Item);
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
	Row = New Structure;
	Row.Insert("Item", Item);
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
	AddInfo = New Structure("MobileModule", ThisObject);
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, , AddInfo);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", ThisObject);
	NotifyParameters.Insert("Object", Object);
	
	If AdditionalParameters.FoundedItems.Count() Then
		#If MobileClient Then
		MultimediaTools.CloseBarcodeScanning();
		#EndIf
	EndIf;
	
	For Each Row In AdditionalParameters.FoundedItems Do
		FillData(Row);
	EndDo;

EndProcedure

&AtClient
Procedure FillData(Row)
	Item =  Row.Item;
	ItemKey =  Row.ItemKey;
	If Not ValueIsFilled(ItemKey) Then
		ItemOnChangeAtServer();
	EndIf;

	SetPictureView();
	ShowStatus();
	Barcode = Row.Barcode;
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
	If Not ValueIsFilled(Item) OR
		Not ValueIsFilled(ItemKey) Then
		Return;
	EndIf;
	Reg = InformationRegisters.BarcodeScanInfoCheck.CreateRecordSet();
	Reg.Filter.Item.Set(Item);
	Reg.Filter.ItemKey.Set(ItemKey);
	Reg.Read();
	If Reg.Count() Then
		Status = Reg[0].Status;
		Items.OK.Representation = ?(Status, ButtonRepresentation.PictureAndText, ButtonRepresentation.Text);
		Items.NotOK.Representation = ?(Not Status, ButtonRepresentation.PictureAndText, ButtonRepresentation.Text);
	EndIf;
EndProcedure


&AtServer
Procedure WriteReg(Status)
	If Not ValueIsFilled(Item) OR
		Not ValueIsFilled(ItemKey) Then
		Return;
	EndIf;
	Reg = InformationRegisters.BarcodeScanInfoCheck.CreateRecordSet();
	Reg.Filter.Item.Set(Item);
	Reg.Filter.ItemKey.Set(ItemKey);
	NewReg = Reg.Add();
	NewReg.Item = Item;
	NewReg.ItemKey = ItemKey;
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

