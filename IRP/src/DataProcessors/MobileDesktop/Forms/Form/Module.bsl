
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
	
	QueryResult = Query.Execute().Unload();
	ItemKey = QueryResult[0].Ref;
	
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
Procedure ItemOnChange(Item)
	ItemOnChangeAtServer();
	SetPictureView();
	ShowStatus();
EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	SetPictureView();
	ShowStatus();
EndProcedure


&AtClient
Procedure SearchByBarcode(Command)
	DocumentsClient.SearchByBarcode(Command, Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(BarcodeItems, Parameters) Export
	For Each Row In BarcodeItems Do
		Item =  Row.Item;
		ItemKey =  Row.ItemKey;
		If Not ValueIsFilled(ItemKey) Then
			ItemOnChangeAtServer()
		EndIf;
		SetPictureView();
		
		#If MobileClient Then
		MultimediaTools.CloseBarcodeScanning();
		#EndIf
		ShowStatus();
		Barcode = Row.Barcode;
		Return;
	EndDo;
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

