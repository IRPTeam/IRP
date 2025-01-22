
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	
	NumberParts = DocumentNumberingClientServer.GetNumberParts();
	Items.LabelNumber.Title = NumberParts.Number;
	Items.LabelBasic.Title = NumberParts.Basic;
	Items.LabelYear2.Title = NumberParts.Year2;
	Items.LabelYear4.Title = NumberParts.Year4;
	Items.LabelQuarter.Title = NumberParts.Quarter;
	Items.LabelMonth1.Title = NumberParts.Month1;
	Items.LabelMonth2.Title = NumberParts.Month2;
	Items.LabelWeek1.Title = NumberParts.Week1;
	Items.LabelWeek2.Title = NumberParts.Week2;
	
	LoadConfigurationAttributes();
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
Procedure ExampleOnChange(Item)
	Check(Item);
EndProcedure

&AtClient
Procedure LabelHintClick(Item)
	AddToTemplate(Item.Title);
EndProcedure

&AtClient
Procedure CatalogsCatalogOnChange(Item)
	CurrentRow = Items.Catalogs.CurrentData;
	If Not ValueIsFilled(CurrentRow.Catalog) Then
		CurrentRow.NumberName = "";
		CurrentRow.DateName = "";
	EndIf;
EndProcedure

&AtClient
Procedure DocumentsDocumentOnChange(Item)
	CurrentRow = Items.Documents.CurrentData;
	If Not ValueIsFilled(CurrentRow.Document) Then
		CurrentRow.NumberName = "";
	EndIf;
EndProcedure

&AtClient
Procedure CatalogsDateNameStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	
	Item.ChoiceList.Clear();
	
	CurrentRow = Items.Catalogs.CurrentData;
	NewData = FormData.CatalogDates.Get(CurrentRow.Catalog);
	If NewData <> Undefined Then
		Item.ChoiceList.LoadValues(NewData);
	EndIf;
	
EndProcedure

&AtClient
Procedure CatalogsNumberNameStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	
	Item.ChoiceList.Clear();
	
	CurrentRow = Items.Catalogs.CurrentData;
	NewData = FormData.CatalogNumbers.Get(CurrentRow.Catalog);
	If NewData <> Undefined Then
		Item.ChoiceList.LoadValues(NewData);
	EndIf;
	
EndProcedure

&AtClient
Procedure DocumentsNumberNameStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	
	Item.ChoiceList.Clear();
	
	CurrentRow = Items.Documents.CurrentData;
	NewData = FormData.DocumentNumbers.Get(CurrentRow.Document);
	If NewData <> Undefined Then
		Item.ChoiceList.LoadValues(NewData);
	EndIf;
	
EndProcedure

#EndRegion

#Region FormCommands

&AtClient
Procedure Check(Command)
	
	Items.ResultLabel.Title = "";
	
	If ValueIsFilled(Example) Then
		NumeratorWrapper = New Structure(
			"Ref, 
			|BasicRule, 
			|BeginDate, 
			|EndDate, 
			|ByDefault, 
			|NumberingPeriod, 
			|NumberTemplate, 
			|StartNumber, 
			|TotalLength, 
			|WithoutLeadingZeros");
		FillPropertyValues(NumeratorWrapper, Object);
		NumeratorWrapper.Insert("Catalogs", New Array);
		For Each CatalogRow In Object.Catalogs Do
			NumeratorWrapper.Catalogs.Add(New Structure("Catalog,DateName", CatalogRow.Catalog, CatalogRow.DateName));
		EndDo;
		NumeratorDescription = DocumentNumberingServer.FillNumeratorDescription(NumeratorWrapper);
		DocumentDescription = DocumentNumberingServer.GetSourceDescriptionForNumerator(Example, NumeratorDescription);
		Items.ResultLabel.Title = 
			DocumentNumberingServer.MakeNumber(NumeratorDescription, DocumentDescription, Object.StartNumber);
	EndIf;
	
	If IsBlankString(Items.ResultLabel.Title) Then
		Items.ResultLabel.BackColor = WebColors.MistyRose;
	Else
		Items.ResultLabel.BackColor = WebColors.PaleGreen;
	EndIf;

EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure AddToTemplate(TemplatePart)
	If StrFind(Object.NumberTemplate, TemplatePart) = 0 Then
		Object.NumberTemplate = Object.NumberTemplate + TemplatePart; 
	EndIf;
EndProcedure

&AtServer
Procedure LoadConfigurationAttributes()
	
	FormData = New Structure();
	
	CatalogDates = New Map;
	CatalogNumbers = New Map;
	DocumentNumbers = New Map;
	
	Cats = Catalogs.ConfigurationMetadata.Select(Catalogs.ConfigurationMetadata.Catalogs);
	While Cats.Next() Do
		CatalogMetadata = Metadata.FindByFullName(Cats.ObjectFullName); // MetadataObjectCatalog
		If CatalogMetadata = Undefined Then
			Continue;
		EndIf;
		If CatalogDates.Get(Cats.Ref) = Undefined Then
			CatalogDates.Insert(Cats.Ref, New Array);
		EndIf;
		If CatalogNumbers.Get(Cats.Ref) = Undefined Then
			CatalogNumbers.Insert(Cats.Ref, New Array);
		EndIf;
		For Each AttributeItem In CatalogMetadata.Attributes Do
			If AttributeItem.Type.ContainsType(Type("Date")) Then
				CatalogDates.Get(Cats.Ref).Add(AttributeItem.Name);
			EndIf;
			If AttributeItem.Type.ContainsType(Type("String")) Then
				CatalogNumbers.Get(Cats.Ref).Add(AttributeItem.Name);
			EndIf;
		EndDo;
		For Each AttributeItem In Metadata.CommonAttributes Do
			ContentItem = AttributeItem.Content.Find(CatalogMetadata);
			If ContentItem <> Undefined And ContentItem.Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
				If AttributeItem.Type.ContainsType(Type("Date")) Then
					CatalogDates.Get(Cats.Ref).Add(AttributeItem.Name);
				EndIf;
				If AttributeItem.Type.ContainsType(Type("String")) Then
					CatalogNumbers.Get(Cats.Ref).Add(AttributeItem.Name);
				EndIf;
			EndIf;
		EndDo;
	EndDo;
	
	Docs = Catalogs.ConfigurationMetadata.Select(Catalogs.ConfigurationMetadata.Documents);
	While Docs.Next() Do
		DocumentMetadata = Metadata.FindByFullName(Docs.ObjectFullName); // MetadataObjectDocument
		If DocumentMetadata = Undefined Then
			Continue;
		EndIf;
		If DocumentNumbers.Get(Docs.Ref) = Undefined Then
			DocumentNumbers.Insert(Docs.Ref, New Array);
		EndIf;
		For Each AttributeItem In DocumentMetadata.Attributes Do
			If AttributeItem.Type.ContainsType(Type("String")) Then
				DocumentNumbers.Get(Docs.Ref).Add(AttributeItem.Name);
			EndIf;
		EndDo;
		For Each AttributeItem In Metadata.CommonAttributes Do
			ContentItem = AttributeItem.Content.Find(DocumentMetadata);
			If ContentItem <> Undefined And ContentItem.Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
				If AttributeItem.Type.ContainsType(Type("String")) Then
					DocumentNumbers.Get(Docs.Ref).Add(AttributeItem.Name);
				EndIf;
			EndIf;
		EndDo;
	EndDo;
	
	FormData.Insert("CatalogDates", CatalogDates);
	FormData.Insert("CatalogNumbers", CatalogNumbers);
	FormData.Insert("DocumentNumbers", DocumentNumbers);
	
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