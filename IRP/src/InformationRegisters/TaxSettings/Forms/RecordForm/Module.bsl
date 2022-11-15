&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If ValueIsFilled(Record.ItemKey) Then
		ThisObject.RecordType = "ItemKey";
	ElsIf ValueIsFilled(Record.Item) Then
		ThisObject.RecordType = "Item";
	ElsIf ValueIsFilled(Record.ItemType) Then
		ThisObject.RecordType = "ItemType";
	ElsIf ValueIsFilled(Record.Agreement) Then
		ThisObject.RecordType = "Agreement";
	Else
		ThisObject.RecordType = "All";
	EndIf;
	SetVisible();
	FillTaxRateChoiceList();
	FillRecordTypeChoiceList();
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	If Not FOServer.IsUseCommissionTrading() Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, DataCompositionComparisonType.Equal));
		OpenSettings.FillingData = New Structure("OurCompany", True);
	EndIf;
	
	DocumentsClient.CompanyStartChoice(Record, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);	
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	If Not FOServer.IsUseCommissionTrading() Then
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	EndIf;
	
	DocumentsClient.CompanyEditTextChange(Record, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters);	
EndProcedure

&AtClient
Procedure RecordTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtServer
Procedure FillTaxRateChoiceList()
	ThisObject.Items.TaxRate.ChoiceList.LoadValues(TaxesServer.GetTaxRatesByTax(Record.Tax));
EndProcedure

&AtServer
Procedure FillRecordTypeChoiceList()
	ThisObject.Items.RecordType.ChoiceList.Add("All", R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("ItemKey", Metadata.Catalogs.ItemKeys.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("Item", Metadata.Catalogs.Items.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("ItemType", Metadata.Catalogs.ItemTypes.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("Agreement", Metadata.Catalogs.Agreements.ObjectPresentation);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If ThisObject.RecordType <> "ItemType" Then
		CurrentObject.ItemType = Undefined;
	EndIf;

	If ThisObject.RecordType <> "Item" Then
		CurrentObject.Item = Undefined;
	EndIf;

	If ThisObject.RecordType <> "ItemKey" Then
		CurrentObject.ItemKey = Undefined;
	EndIf;

	If ThisObject.RecordType <> "Agreement" Then
		CurrentObject.Agreement = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.ItemType.Visible = ThisObject.RecordType = "ItemType";
	Items.Item.Visible = ThisObject.RecordType = "Item";
	Items.ItemKey.Visible = ThisObject.RecordType = "ItemKey";
	Items.Agreement.Visible = ThisObject.RecordType = "Agreement";
EndProcedure

&AtClient
Procedure TaxRateStartListChoice(Item, StandardProcessing)
	FillTaxRateChoiceList();
EndProcedure

&AtClient
Procedure TaxOnChange(Item)
	FillTaxRateChoiceList();
EndProcedure