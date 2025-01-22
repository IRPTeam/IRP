
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	SetItemsVisible(ThisObject);
	
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

#Region FormItemsEvent

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure UseValuePrefixOnChange(Item)
	SetItemsVisible(ThisObject);
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