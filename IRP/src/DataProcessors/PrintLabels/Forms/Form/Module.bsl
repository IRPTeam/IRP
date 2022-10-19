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
	CurrentData = ThisObject.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	UnitInfo = GetItemInfo.ItemUnitInfo(CurrentData.ItemKey);
	CurrentData.Unit = UnitInfo.Unit;

	If Not ValueIsFilled(CurrentData.PriceType) Then
		CurrentData.PriceType = ThisObject.PriceType;
	EndIf;
	
	PriceParameters = New Structure();
	PriceParameters.Insert("ItemKey"      , CurrentData.ItemKey);
	PriceParameters.Insert("RowPriceType" , CurrentData.PriceType);
	PriceParameters.Insert("Unit"         , CurrentData.Unit);
	PriceParameters.Insert("Period"       , CurrentDate());
	PriceInfo = GetItemInfo.ItemPriceInfo(PriceParameters);
	CurrentData.Price = PriceInfo.Price;
	CurrentData.PriceType = PriceInfo.PriceType;
	
	BarcodesInfo = BarcodeServer.GetBarcodesByItemKey(CurrentData.ItemKey);
	If BarcodesInfo.Count() Then
		CurrentData.Barcode = BarcodesInfo[0];
	Else
		CurrentData.Barcode = "";
	EndIf;

	If ValueIsFilled(CurrentData.Barcode) Then
		If ValueIsFilled(ThisObject.BarcodeType) Then
			CurrentData.BarcodeType = ThisObject.BarcodeType;
		Else
			CurrentData.BarcodeType = "";
		EndIf;
	Else
		CurrentData.BarcodeType = "";
	EndIf;

EndProcedure

&AtClient
Procedure PriceTypeOnChange(Item)
	If Items.ItemList.SelectedRows.Count() Then
		PriceTypeOnChangeAtServer();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListPriceTypeOnChange(Item)
	CurrentData = ThisObject.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(CurrentData.PriceType) Then
		CurrentData.PriceType = ThisObject.PriceType;
	EndIf;
	
	PriceParameters = New Structure();
	PriceParameters.Insert("ItemKey"      , CurrentData.ItemKey);
	PriceParameters.Insert("RowPriceType" , CurrentData.PriceType);
	PriceParameters.Insert("Unit"         , CurrentData.Unit);
	PriceParameters.Insert("Period"       , CurrentDate());
	PriceInfo = GetItemInfo.ItemPriceInfo(PriceParameters);
	CurrentData.Price = PriceInfo.Price;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	CurrentData = ThisObject.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	CurrentData.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentData.Item);

	If ValueIsFilled(CurrentData.ItemKey) 
		And ServiceSystemServer.GetObjectAttribute(CurrentData.ItemKey, "Item") <> CurrentData.Item Then
		CurrentData.ItemKey = Undefined;
	EndIf;

	ThisObject.Items.ItemList.Refresh();

	UnitInfo = GetItemInfo.ItemUnitInfo(CurrentData.ItemKey);
	CurrentData.Unit = UnitInfo.Unit;

	If Not ValueIsFilled(CurrentData.PriceType) Then
		CurrentData.PriceType = ThisObject.PriceType;
	EndIf;

	PriceParameters = New Structure();
	PriceParameters.Insert("ItemKey"      , CurrentData.ItemKey);
	PriceParameters.Insert("RowPriceType" , CurrentData.PriceType);
	PriceParameters.Insert("Unit"         , CurrentData.Unit);
	PriceParameters.Insert("Period"       , CurrentDate());
	PriceInfo = GetItemInfo.ItemPriceInfo(PriceParameters);
	CurrentData.Price = PriceInfo.Price;
	CurrentData.PriceType = PriceInfo.PriceType;
	
	BarcodesInfo = BarcodeServer.GetBarcodesByItemKey(CurrentData.ItemKey);
	If BarcodesInfo.Count() Then
		CurrentData.Barcode = BarcodesInfo[0];
	Else
		CurrentData.Barcode = "";
	EndIf;
	
	If ValueIsFilled(CurrentData.Barcode) Then
		If ValueIsFilled(ThisObject.BarcodeType) Then
			CurrentData.BarcodeType = ThisObject.BarcodeType;
		Else
			CurrentData.BarcodeType = "";
		EndIf;
	Else
		CurrentData.BarcodeType = "";
	EndIf;

EndProcedure

#EndRegion

&AtServer
Procedure PriceTypeOnChangeAtServer()
	SelectedRows = New Array;
	For Each Row In Items.ItemList.SelectedRows Do
		ItemRow = ItemList.FindByID(Row);
		ItemRow.PriceType = ThisObject.PriceType;
		SelectedRows.Add(ItemRow);
	EndDo;
	
	TableItems = ItemList.Unload(SelectedRows, "ItemKey").UnloadColumn("ItemKey");
	ItemsInfo = GetItemInfo.GetInfoByItemsKey(TableItems);
	For Each ItemInfo In ItemsInfo Do
		 ItemInfo.Insert("PriceType", ThisObject.PriceType);
	EndDo;
	ItemPriceTable = GetItemInfo.ItemPriceInfoByTable(ItemsInfo, CurrentDate());
	
	Filter = New Structure("ItemKey, Unit, PriceType");
	For Each Item In SelectedRows Do
		FillPropertyValues(Filter, Item);
		FindRows = ItemPriceTable.FindRows(Filter);
		If FindRows.Count() Then
			Item.Price = FindRows[0].Price;
		Else
			Item.Price = 0;
		EndIf;
	EndDo;
EndProcedure