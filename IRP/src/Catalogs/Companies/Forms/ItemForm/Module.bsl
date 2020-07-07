
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	IDInfoServer.OnCreateAtServer(ThisObject, "GroupContactInformation");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	
	If Parameters.Key.IsEmpty() Then
		If Parameters.FillingValues.Property("Partner") Then
			Object.Our = False;
			Items.Our.Visible = False;
		EndIf;
		SetVisible();
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ReadTaxes();
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
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Object.Our Then
		If RewriteTaxes Then
			CatCompaniesServer.WriteTaxesIntoFormTable(ThisObject, CurrentObject.Ref);
		EndIf;
	Else
		CatCompaniesServer.ClearTaxesIntoFormTable(CurrentObject.Ref);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	If Not Object.Our Then
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
	If Object.Our Then
		For Index = 0 To CompanyTaxes.Count() - 1 Do
			Row = CompanyTaxes[Index];
			If Not ValueIsFilled(Row.Period) Then
				Cancel = True;
				MessageText = StrTemplate(R()["Error_010"], "Period");
				CommonFunctionsClientServer.ShowUsersMessage(MessageText,
						"CompanyTaxes[" + Format(Index, "NG=0;") + "].Period");
			EndIf;
		EndDo;
	EndIf;
EndProcedure

#EndRegion


&AtClient
Procedure CurrenciesMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
																	GetListOfSupportedMovementTypes(), 
																	DataCompositionComparisonType.InList));
	OpenSettings.FormName = "ChartOfCharacteristicTypes.CurrencyMovementType.ChoiceForm";
	
	DocumentsClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
	
EndProcedure

&AtClient
Procedure CurrenciesMovementTypeEditTextChange(Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
															   GetListOfSupportedMovementTypes(), 
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
	Items.GroupCurrencies.Visible = Object.Our;
	Items.GroupTaxes.Visible = Object.Our;
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
	RewriteTaxes = True;
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
