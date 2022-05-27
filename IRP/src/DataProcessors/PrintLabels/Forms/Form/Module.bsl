#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	BarcodeTypeChoiceList = New ValueList();
	BarcodeTypeChoiceList.Add("Auto", "Auto");
	BarcodeTypeChoiceList.Add("EAN8", "EAN-8");
	BarcodeTypeChoiceList.Add("EAN13", "EAN-13");
	BarcodeTypeChoiceList.Add("EAN128", "EAN-128");
	BarcodeTypeChoiceList.Add("CODE39", "Code 39");
	BarcodeTypeChoiceList.Add("CODE128", "Code 128");
	BarcodeTypeChoiceList.Add("ITF14", "ITF-14");

	Items.BarcodeType.ChoiceList.Clear();
	Items.ItemListBarcodeType.ChoiceList.Clear();
	For Each ChoiceListItem In BarcodeTypeChoiceList Do
		Items.BarcodeType.ChoiceList.Add(ChoiceListItem.Value, ChoiceListItem.Presentation);
		Items.ItemListBarcodeType.ChoiceList.Add(ChoiceListItem.Value, ChoiceListItem.Presentation);
	EndDo;

EndProcedure

#EndRegion

#Region SaveLoadSettings

&AtClient
Procedure SaveSettings(Command)
	SaveSettingsAtServer();
EndProcedure

&AtClient
Procedure LoadSettings(Command)
	RestoreSettingsAtServer();
EndProcedure

&AtServer
Procedure SaveSettingsAtServer()

	GetIgnoredAttributeNames = GetIgnoredAttributeNames();

	SaveStructure = New Structure();

	FormAttributes = ThisObject.GetAttributes();
	For Each Attribute In FormAttributes Do
		If GetIgnoredAttributeNames.Find(Attribute.Name) <> Undefined Then
			Continue;
		EndIf;
		If Attribute.ValueType = New TypeDescription("ValueTable") Then
			SaveStructure.Insert(Attribute.Name, ThisObject.FormAttributeToValue(Attribute.Name));
		Else
			SaveStructure.Insert(Attribute.Name, ThisObject[Attribute.Name]);
		EndIf;
	EndDo;

	SaveSettings = New ValueStorage(SaveStructure, New Deflation(9));
	CommonSettingsStorage.Save("DataProcessorPrintLabels", , SaveSettings, , "DataProcessorPrintLabels");

EndProcedure

&AtServer
Procedure RestoreSettingsAtServer()

	GetIgnoredAttributeNames = GetIgnoredAttributeNames();

	RestoreSettings = CommonSettingsStorage.Load("DataProcessorPrintLabels", , , "DataProcessorPrintLabels");
	If RestoreSettings = Undefined Then
		Return;
	EndIf;
	RestoreStructure = RestoreSettings.Get();

	FormAttributes = ThisObject.GetAttributes();
	For Each Attribute In FormAttributes Do
		If GetIgnoredAttributeNames.Find(Attribute.Name) <> Undefined Then
			Continue;
		EndIf;
		If Not RestoreStructure.Property(Attribute.Name) Then
			Continue;
		EndIf;
		If Attribute.ValueType.Types().Find(TypeOf(RestoreStructure[Attribute.Name])) = Undefined Then
			Continue;
		EndIf;
		If TypeOf(RestoreStructure[Attribute.Name]) = Type("ValueTable") Then
			ThisObject.ValueToFormAttribute(RestoreStructure[Attribute.Name], Attribute.Name);
		Else
			ThisObject[Attribute.Name] = RestoreStructure[Attribute.Name];
		EndIf;
	EndDo;

EndProcedure

&AtServer
Function GetIgnoredAttributeNames()
	IgnoredAttributesNames = New Array();
	IgnoredAttributesNames.Add("Object");
	Return IgnoredAttributesNames;
EndFunction

#EndRegion

&AtClient
Procedure Fill(Command)
	ItemList.Clear();
	FillAtServer();
EndProcedure

&AtClient
Procedure BarcodeTypeOnChange(Item)
	For Each Row In Items.ItemList.SelectedRows Do
		Items.ItemList.RowData(Row).BarcodeType = ThisObject.BarcodeType;
	EndDo;
EndProcedure

&AtServer
Procedure FillAtServer()
	DataProcessorObject = FormAttributeToValue("Object");
	DataProcessorObject.FillAtServer(Object, ThisObject);
EndProcedure

#Region Print

&AtClient
Procedure Print(Command)

	PrintDocs = PrintAtServer();
	For Each Item In PrintDocs Do
		Item.Show();
	EndDo;

EndProcedure

&AtServer
Function PrintAtServer()

	DataProcessorObject = FormAttributeToValue("Object");
	PrintReturn = DataProcessorObject.PrintLabels(Object, ThisObject);

	Return PrintReturn;

EndFunction

&AtClient
Procedure ItemListTemplateOnChange(Item)

	CurrentRowData = Items.ItemList.CurrentData;
	If Not CurrentRowData = Undefined Then
		CurrentRowData.TemplateHash = GetHashOfTemplate(CurrentRowData.Template);
	EndIf;

EndProcedure

&AtServer
Function GetHashOfTemplate(Template)
	ReturnValue = "";
	TemplateStructure = Template.ValueOfTemplate.Get();
	If TemplateStructure <> Undefined Then
		ReturnValue = TemplateStructure.Hash;
	EndIf;
	Return ReturnValue;
EndFunction

&AtClient
Procedure LabelTemplateOnChange(Item)

	For Each Row In Items.ItemList.SelectedRows Do
		Items.ItemList.RowData(Row).Template = ThisObject.LabelTemplate;
		Items.ItemList.RowData(Row).TemplateHash = GetHashOfTemplate(ThisObject.LabelTemplate);
	EndDo;

EndProcedure

&AtClient
Procedure CheckPrintForSelectedRows(Command)
	For Each Row In Items.ItemList.SelectedRows Do
		Items.ItemList.RowData(Row).Print = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckPrintForSelectedRows(Command)
	For Each Row In Items.ItemList.SelectedRows Do
		Items.ItemList.RowData(Row).Print = False;
	EndDo;
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	CurrentRow = ThisObject.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	If Not ValueIsFilled(CurrentRow.PriceType) Then
		CalculationSettings.Insert("ChangePriceType");
		CalculationSettings.ChangePriceType = New Structure("Period, PriceType", CurrentDate(), ThisObject.PriceType);
	EndIf;
	CalculationSettings.Insert("UpdatePrice");
	CalculationSettings.UpdatePrice = New Structure("Period, PriceType", CurrentDate(), CurrentRow.PriceType);
	CalculationSettings.Insert("UpdateBarcode");

	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentRow, CalculationSettings);

	If ValueIsFilled(CurrentRow.Barcode) Then
		If ValueIsFilled(ThisObject.BarcodeType) Then
			CurrentRow.BarcodeType = ThisObject.BarcodeType;
		Else
			CurrentRow.BarcodeType = "";
		EndIf;
	Else
		CurrentRow.BarcodeType = "";
	EndIf;

EndProcedure

&AtClient
Procedure PriceTypeOnChange(Item)
	For Each Row In Items.ItemList.SelectedRows Do
		Items.ItemList.RowData(Row).PriceType = ThisObject.PriceType;
	EndDo;
EndProcedure

&AtClient
Procedure ItemListPriceTypeOnChange(Item)
	CurrentRow = ThisObject.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdatePrice");
	CalculationSettings.UpdatePrice = New Structure("Period, PriceType", CurrentDate(), CurrentRow.PriceType);
	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentRow, CalculationSettings);
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	CurrentRow = ThisObject.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	CurrentRow.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentRow.Item);

	If ValueIsFilled(CurrentRow.ItemKey) And ServiceSystemServer.GetObjectAttribute(CurrentRow.ItemKey, "Item")
		<> CurrentRow.Item Then
		CurrentRow.ItemKey = Undefined;
	EndIf;

	ThisObject.Items.ItemList.Refresh();

	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	If Not ValueIsFilled(CurrentRow.PriceType) Then
		CalculationSettings.Insert("ChangePriceType");
		CalculationSettings.ChangePriceType = New Structure("Period, PriceType", CurrentDate(), ThisObject.PriceType);
	EndIf;
	CalculationSettings.Insert("UpdatePrice");
	CalculationSettings.UpdatePrice = New Structure("Period, PriceType", CurrentDate(), CurrentRow.PriceType);
	CalculationSettings.Insert("UpdateBarcode");

	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentRow, CalculationSettings);

	If ValueIsFilled(CurrentRow.Barcode) Then
		If ValueIsFilled(ThisObject.BarcodeType) Then
			CurrentRow.BarcodeType = ThisObject.BarcodeType;
		Else
			CurrentRow.BarcodeType = "";
		EndIf;
	Else
		CurrentRow.BarcodeType = "";
	EndIf;

EndProcedure

#EndRegion