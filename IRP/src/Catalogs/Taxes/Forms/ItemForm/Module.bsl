#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	If Object.Type <> Enums.TaxType.Rate Then
		Object.TaxRates.Clear();
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupMainPages);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	UseTaxRate = Object.Type = PredefinedValue("Enum.TaxType.Rate");
	Form.Items.TaxRates.Visible = UseTaxRate;
	Form.Items.GroupTaxRates.Visible = UseTaxRate;
	
	For Each Row In Form.Object.UseDocuments Do
		ArrayOfTransactionTypes = Object.TransactionTypes.FindRows(New Structure("DocumentName", Row.DocumentName));
		Presentations = New Array();
		For Each Item In ArrayOfTransactionTypes Do
			Presentations.Add(String(Item.TransactionType));
		EndDo;
		Row.TransactionTypes = StrConcat(Presentations, " ,");
	EndDo;
EndProcedure

&AtClient
Procedure UseDocumentsDocumentNameStartChoice(Item, ChoiceData, StandardProcessing)
	Items.UseDocumentsDocumentName.ChoiceList.Clear();
	DocumentNameChoiceList = TaxesServer.GetDocumentsWithTax();
	For Each DocumentName In DocumentNameChoiceList Do
		If Object.UseDocuments.FindRows(New Structure("DocumentName", DocumentName.Value)).Count() Then
			Continue;
		EndIf;
		Items.UseDocumentsDocumentName.ChoiceList.Add(DocumentName.Value, DocumentName.Presentation);
	EndDo;
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure SetTransactionTypes(Command)
	CurrentData = Items.UseDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfAllTransactionTypes = GetTransactionTypesForDocument(CurrentData.DocumentName);
	
	If ArrayOfAllTransactionTypes = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage("Document don't have transaction types");
		Return;
	EndIf;
	
	OpenParameters = New Structure();
	OpenParameters.Insert("DocumentName", CurrentData.DocumentName);
	OpenParameters.Insert("TransactionTypes", ArrayOfAllTransactionTypes);
	Notify = new NotifyDescription("ChoiceTransactionTypesEnd", ThisObject);
	OpenForm("Catalog.Taxes.Form.ChoiceTransactionTypes", OpenParameters, ThisObject, , , , Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ChoiceTransactionTypesEnd(Result, Parameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ArrayForDelete = Object.TransactionTypes.FindRows(New Structure("DocumentName", Result.DocumentName));
	For Each Row In ArrayForDelete Do
		Object.TransactionTypes.Delete(Row);
	EndDo;
	
	For Each Row In Result.TransactionTypes Do
		NewRow = Object.TransactionTypes.Add();
		NewRow.TransactionType = Row.TransactionType;
		NewRow.DocumentName = Result.DocumentName;
	EndDo;
	SetVisibilityAvailability(Object, ThisObject);
	ThisObject.Modified = True;
EndProcedure

&AtServer
Function GetTransactionTypesForDocument(DocumentName)
	Attr = Metadata.Documents[DocumentName].Attributes;
	AttrTransactionType = Attr.Find("TransactionType");
	If AttrTransactionType = Undefined Then
		Return Undefined;
	EndIf;
	
	MetadataEnum = Metadata.FindByType(AttrTransactionType.Type.Types()[0]);
	
	ArrayOfResults = New Array();
	For Each Value In MetadataEnum.EnumValues Do
		Result = New Structure("TransactionType, Use");
		EnumRef = Enums[MetadataEnum.Name][Value.Name];
		Result.TransactionType = EnumRef;
		
		If Object.TransactionTypes.FindRows(
			New Structure("DocumentName, TransactionType",DocumentName, EnumRef)).Count() Then
				Result.Use = True;
		EndIf;
					
		ArrayOfResults.Add(Result);
	EndDo;
	
	Return ArrayOfResults;
EndFunction

&AtClient
Procedure TypeOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion
