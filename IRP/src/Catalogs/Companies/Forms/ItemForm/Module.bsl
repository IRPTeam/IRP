#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	IDInfoServer.OnCreateAtServer(ThisObject, "GroupContactInformation");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);

	If Parameters.Key.IsEmpty() Then
		If Parameters.FillingValues.Property("Partner") Then
			Object.OurCompany = False;
			Items.OurCompany.Visible = False;
		EndIf;
		SetVisible();
	EndIf;
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupPages);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ReadTaxes();
	ReadLadgerTypes();
	SetVisible();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	IDInfoClient.NotificationProcessing(ThisObject, Object.Ref, EventName, Parameter, Source);
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	If EventName = "UpdateIDInfo" Then
		IDInfoCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("Writing_CatCompany", , Parameters.Key);
	ReadTaxes();
	ReadLadgerTypes();
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Object.OurCompany Then
		If ThisObject.RewriteTaxes Then
			CatCompaniesServer.WriteTaxesIntoFormTable(ThisObject, CurrentObject.Ref);
		EndIf;
		If ThisObject.RewriteLadgerTypes Then
			CatCompaniesServer.WriteLadgerTypesFormTable(ThisObject, CurrentObject.Ref);
		EndIf;
	Else
		CatCompaniesServer.ClearTaxesIntoFormTable(CurrentObject.Ref);
		CatCompaniesServer.ClearLadgerTypesFormTable(CurrentObject.Ref);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	If Not Object.OurCompany Then
		CurrentObject.Currencies.Clear();
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	IDInfoServer.AfterWriteAtServer(ThisObject, CurrentObject, WriteParameters);
	SetVisible();
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	If Object.OurCompany Then
		For Index = 0 To ThisObject.CompanyTaxes.Count() - 1 Do
			Row = ThisObject.CompanyTaxes[Index];
			If Not ValueIsFilled(Row.Period) Then
				Cancel = True;
				MessageText = StrTemplate(R().Error_010, R().Form_032);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, "CompanyTaxes[" + Format(Index, "NG=0;")
					+ "].Period");
			EndIf;
		EndDo;
		For Index = 0 To ThisObject.CompanyLadgerTypes.Count() - 1 Do
			Row = ThisObject.CompanyLadgerTypes[Index];
			If Not ValueIsFilled(Row.Period) Then
				Cancel = True;
				MessageText = StrTemplate(R().Error_010, R().Form_032);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, "CompanyLadgerTypes[" + Format(Index, "NG=0;")
					+ "].Period");
			EndIf;
		EndDo;
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure CurrenciesMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", GetListOfSupportedMovementTypes(),
		DataCompositionComparisonType.InList));
	OpenSettings.FormName = "ChartOfCharacteristicTypes.CurrencyMovementType.ChoiceForm";

	DocumentsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);

EndProcedure

&AtClient
Procedure CurrenciesMovementTypeEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", GetListOfSupportedMovementTypes(),
		ComparisonType.InList));
	DocumentsClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

&AtClient
Function GetListOfSupportedMovementTypes()
	ListOfCurrencyMovementTypes = New ValueList();
	ListOfCurrencyMovementTypes.Add(PredefinedValue("Enum.CurrencyType.Legal"));
	ListOfCurrencyMovementTypes.Add(PredefinedValue("Enum.CurrencyType.Budgeting"));
	ListOfCurrencyMovementTypes.Add(PredefinedValue("Enum.CurrencyType.Reporting"));
	Return ListOfCurrencyMovementTypes;
EndFunction

&AtClient
Procedure OurOnChange(Item)
	SetVisible();
EndProcedure

&AtServer
Procedure SetVisible()
	Items.GroupCurrencies.Visible = Object.OurCompany;
	Items.GroupTaxes.Visible = Object.OurCompany;
	Items.GroupLadgerTypes.Visible = Object.OurCompany;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure IDInfoOpening(Item, StandardProcessing) Export
	IDInfoClient.IDInfoOpening(Item, StandardProcessing, Object, ThisObject);
EndProcedure

&AtClient
Procedure StartEditIDInfo(Result, Parameters) Export
	IDInfoClient.StartEditIDInfo(ThisObject, Result, Parameters);
EndProcedure

&AtClient
Procedure EndEditIDInfo(Result, Parameters) Export
	IDInfoClient.EndEditIDInfo(Object, Result, Parameters);
EndProcedure

#Region Taxes

&AtClient
Procedure CompanyTaxesOnChange(Item)
	ThisObject.RewriteTaxes = True;
EndProcedure

&AtClient
Procedure CompanyTaxesOnStartEdit(Item, NewRow, Clone)
	If NewRow Then
		Item.CurrentData.Use = True;
	EndIf;
EndProcedure

&AtServer
Procedure ReadTaxes()
	CatCompaniesServer.ReadTaxesIntoFormTable(ThisObject);
EndProcedure

#EndRegion

#Region LadgerTypes

&AtClient
Procedure CompanyLadgerTypesOnChange(Item)
	ThisObject.RewriteLadgerTypes = True;
EndProcedure

&AtClient
Procedure CompanyLadgerTypesOnStartEdit(Item, NewRow, Clone)
	If NewRow Then
		Item.CurrentData.Use = True;
	EndIf;
EndProcedure

&AtServer
Procedure ReadLadgerTypes()
	CatCompaniesServer.ReadLadgerTypesFormTable(ThisObject);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtServer
Procedure IDInfoCreateFormControl()
	IDInfoServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion