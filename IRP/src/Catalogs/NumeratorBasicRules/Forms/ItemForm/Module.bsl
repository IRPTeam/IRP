
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	SetItemsVisible(ThisObject);
	
	PrifixType = DocumentNumberingClientServer.GetNumberPrifixType();
	Items.CompanyPrefixLabel.Title = PrifixType.CompanyPrefix;
	Items.BranchPrefixLabel.Title = PrifixType.BranchPrefix;
	Items.DocumentPrefixLabel.Title = PrifixType.DocumentPrefix;
	Items.CatalogPrefixLabel.Title = PrifixType.CatalogPrefix;
	
	LoadDocumentTransactionTypes(); 
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion

#Region FormCommands

&AtClient
Procedure Check(Command)
	
	Items.ResultLabel.Title = "";
	
	If ValueIsFilled(Example) Then
		NumeratorDescription = DocumentNumberingClientServer.GetNumeratorDescription();
		NumeratorDescription.BasicRule.UseCompanyPrefix = Object.UseCompanyPrefix;
		NumeratorDescription.BasicRule.UseBranchPrefix = Object.UseBranchPrefix;
		NumeratorDescription.BasicRule.UseCatalogPrefix = Object.UseCatalogPrefix;
		NumeratorDescription.BasicRule.UseDocumentPrefix = Object.UseDocumentPrefix;
		NumeratorDescription.BasicRule.UseTransactionTypePrefix = Object.UseTransactionTypePrefix;
		NumeratorDescription.BasicRule.PrefixTemplate = Object.PrefixTemplate;
		For Each PrefixRow In Object.CompanyPrefixes Do
			NumeratorDescription.BasicRule.CompanyPrefixes.Insert(PrefixRow.Company, PrefixRow.Prefix);
		EndDo;
		For Each PrefixRow In Object.BranchPrefixes Do
			NumeratorDescription.BasicRule.BranchPrefixes.Insert(PrefixRow.Branch, PrefixRow.Prefix);
		EndDo;
		For Each PrefixRow In Object.CatalogPrefixes Do
			NumeratorDescription.BasicRule.CatalogPrefixes.Insert(PrefixRow.Catalog, PrefixRow.Prefix);
		EndDo;
		For Each PrefixRow In Object.DocumentPrefixes Do
			If NumeratorDescription.BasicRule.DocumentPrefixes.Get(PrefixRow.Document) = Undefined Then
				NumeratorDescription.BasicRule.DocumentPrefixes.Insert(PrefixRow.Document, New Map);
			EndIf;
			If Object.UseTransactionTypePrefix Then
				NumeratorDescription.BasicRule.DocumentPrefixes[PrefixRow.Document].Insert(
					PrefixRow.TransactionType, PrefixRow.Prefix);
			Else
				NumeratorDescription.BasicRule.DocumentPrefixes[PrefixRow.Document].Insert(
					Undefined, PrefixRow.Prefix);
			EndIf;
		EndDo;
		DocumentDescription = DocumentNumberingServer.GetSourceDescriptionForNumerator(Example, NumeratorDescription);
		Items.ResultLabel.Title = DocumentNumberingServer.GetBasisPrefix(NumeratorDescription, DocumentDescription);
	EndIf;
	
	If Not ValueIsFilled(Example) Then
		Items.ResultLabel.BackColor = Items.GroupTesting.BackColor;
	ElsIf IsBlankString(Items.ResultLabel.Title) Then
		Items.ResultLabel.BackColor = WebColors.MistyRose;
	Else
		Items.ResultLabel.BackColor = WebColors.PaleGreen;
	EndIf;

EndProcedure

#EndRegion

#Region FormItemsEvent

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure UseCompanyPrefixOnChange(Item)
	SetItemsVisible(ThisObject);
	AddToPrefixTemplate(DocumentNumberingClientServer.GetNumberPrifixType().CompanyPrefix);
EndProcedure

&AtClient
Procedure UseBranchPrefixOnChange(Item)
	SetItemsVisible(ThisObject);
	AddToPrefixTemplate(DocumentNumberingClientServer.GetNumberPrifixType().BranchPrefix);
EndProcedure

&AtClient
Procedure UseDocumentPrefixOnChange(Item)
	SetItemsVisible(ThisObject);
	AddToPrefixTemplate(DocumentNumberingClientServer.GetNumberPrifixType().DocumentPrefix);
EndProcedure

&AtClient
Procedure UseCatalogPrefixOnChange(Item)
	SetItemsVisible(ThisObject);
	AddToPrefixTemplate(DocumentNumberingClientServer.GetNumberPrifixType().CatalogPrefix);
EndProcedure

&AtClient
Procedure UseTransactionTypePrefixOnChange(Item)
	SetItemsVisible(ThisObject);
EndProcedure

&AtClient
Procedure PrefixLabelClick(Item)
	AddToPrefixTemplate(Item.Title);
EndProcedure

&AtClient
Procedure ExampleOnChange(Item)
	Check(Item);
EndProcedure

&AtClient
Procedure DocumentPrefixesOnActivateCell(Item)
	CurrentRow = Item.CurrentData;
	If Item.CurrentItem = Items.DocumentPrefixesTransactionType Then
		If Not ValueIsFilled(CurrentRow.Document) Then
			Items.DocumentPrefixesTransactionType.TypeRestriction = FormData.DocumentTransactionTypes[Undefined];
		Else
			NewTypeRestriction = FormData.DocumentTransactionTypes[CurrentRow.Document];
			If NewTypeRestriction = Undefined Then
				Items.DocumentPrefixesTransactionType.TypeRestriction = FormData.DocumentTransactionTypes[Undefined];
			Else
				Items.DocumentPrefixesTransactionType.TypeRestriction = NewTypeRestriction;
			EndIf;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure DocumentPrefixesDocumentOnChange(Item)
	CurrentRow = Items.DocumentPrefixes.CurrentData;
	If Not ValueIsFilled(CurrentRow.Document) Then
		CurrentRow.TransactionType = Undefined;
	Else
		NewTypeRestriction = FormData.DocumentTransactionTypes[CurrentRow.Document]; // TypeDescription
		If NewTypeRestriction = Undefined Then
			CurrentRow.TransactionType = Undefined;
		Else
			If Not NewTypeRestriction.ContainsType(TypeOf(CurrentRow.TransactionType)) Then
				CurrentRow.TransactionType = Undefined;
			EndIf;
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region Private

&AtClientAtServerNoContext
Procedure SetItemsVisible(Form)
	
	Form.Items.GroupCompanyPrefixes.Visible 	= Form.Object.UseCompanyPrefix; 
	Form.Items.GroupBranchPrefixes.Visible 		= Form.Object.UseBranchPrefix; 
	Form.Items.GroupDocumentPrefixes.Visible 	= Form.Object.UseDocumentPrefix;
	Form.Items.GroupCatalogPrefixes.Visible 	= Form.Object.UseCatalogPrefix;
	
	Form.Items.DocumentPrefixesTransactionType.Visible 	= Form.Object.UseTransactionTypePrefix;
	
EndProcedure

&AtServer
Procedure LoadDocumentTransactionTypes()
	
	FormData = New Structure();
	
	DocumentTransactionTypes = New Map;
	DocumentTransactionTypes.Insert(Undefined, New TypeDescription("Undefined"));
	
	Docs = Catalogs.ConfigurationMetadata.Select(Catalogs.ConfigurationMetadata.Documents);
	While Docs.Next() Do
		DocumentMetadata = Metadata.FindByFullName(Docs.ObjectFullName);
		If DocumentMetadata = Undefined Or DocumentMetadata.Attributes.Find("TransactionType") = Undefined Then
			Continue;
		EndIf;
		DocumentTransactionTypes.Insert(Docs.Ref, DocumentMetadata.Attributes.TransactionType.Type);
	EndDo;
	
	FormData.Insert("DocumentTransactionTypes", DocumentTransactionTypes);
	
EndProcedure

&AtClient
Procedure AddToPrefixTemplate(PrefixPart)
	If StrFind(Object.PrefixTemplate, PrefixPart) = 0 Then
		Object.PrefixTemplate = Object.PrefixTemplate + PrefixPart; 
	EndIf;
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

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName)
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion

#EndRegion