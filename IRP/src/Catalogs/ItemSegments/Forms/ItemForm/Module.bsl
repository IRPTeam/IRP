#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Object.Ref.IsEmpty() Then
		Items.GroupContent.Visible = False;
	Else
		SegmentParameter = ContentSegment.Parameters.Items.Find("Segment");
		SegmentParameter.Value = Object.Ref;
		SegmentParameter.Use = True;
	EndIf;
	LoadDataFromTable_OnCreateAtServer();
	
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
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

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region LOAD_DATA_FROM_TABLE

&AtServer
Procedure LoadDataFromTable_OnCreateAtServer()
	NewAttributeName_Fields = "LoadDataFromTable_Fields";
	NewAttributeName_Target = "LoadDataFromTable_Target";
	NewAttributeName_EndNotify = "LoadDataFromTable_EndNotify";
	NewAttributeName_UseFormNotify = "LoadDataFromTable_UseFormNotify";
	
	NewAttributes = New Array; // Array of FormAttribute
	NewAttributes.Add(New FormAttribute(NewAttributeName_Fields, New TypeDescription("")));
	NewAttributes.Add(New FormAttribute(NewAttributeName_Target, New TypeDescription("String")));
	NewAttributes.Add(New FormAttribute(NewAttributeName_EndNotify, New TypeDescription("String")));
	NewAttributes.Add(New FormAttribute(NewAttributeName_UseFormNotify, New TypeDescription("Boolean")));
	ChangeAttributes(NewAttributes);

	FieldsForLoadData = New Structure;
	AttributesForLoadData = New Array; // Array of MetadataObjectAttribute
	AttributesForLoadData.Add(Metadata.InformationRegisters.ItemSegments.Dimensions.Item);
	AttributesForLoadData.Add(Metadata.InformationRegisters.ItemSegments.Dimensions.ItemKey);
	For Each ItemAttribute In AttributesForLoadData Do
		ItemDescription = New Structure;
		ItemDescription.Insert("Name", ItemAttribute.Name);
		ItemDescription.Insert("Synonym", ItemAttribute.Synonym);
		ItemDescription.Insert("Type", ItemAttribute.Type);
		FieldsForLoadData.Insert(ItemAttribute.Name, ItemDescription); 
	EndDo;
	
	ThisObject[NewAttributeName_Fields] = FieldsForLoadData;
	ThisObject[NewAttributeName_Target] = "Quantity";
	ThisObject[NewAttributeName_EndNotify] = "LoadDataFromTableEnd";
	ThisObject[NewAttributeName_UseFormNotify] = True;
EndProcedure

&AtClient
Procedure LoadDataFromTable(Command)
	//@skip-check use-non-recommended-method
	InternalCommandModule = GetForm("DataProcessor.InternalCommands.Form.LoadDataFromTable");
	InternalCommandModule.RunCommandAction(Object.Ref, ThisObject, Items.ContentSegmentLoadDataFromTable, Object);
EndProcedure

&AtClient
Procedure LoadDataFromTableEnd(Result, AddInfo) Export
	If Not Result = Undefined Then
		LoadDataFromTableEndAtServer(Result.Address);
	EndIf;
EndProcedure

&AtServer
Procedure LoadDataFromTableEndAtServer(TableAddress)
	
	ItemArray = New Array;
	ItemKeyArray = New Array;
	
	DataTable = GetFromTempStorage(TableAddress);
	For Each TableRow In DataTable Do
		If Not TableRow.ItemKey.IsEmpty() Then
			ItemKeyArray.Add(TableRow.ItemKey);
		ElsIf Not TableRow.Item.IsEmpty() Then
			ItemKeyArray.Add(TableRow.Item);
		EndIf;
	EndDo;
	
	If ItemArray.Count() > 0 Then
		Catalogs.ItemSegments.SaveItemsToSegment(Object.Ref, ItemArray);
	EndIf;
	If ItemKeyArray.Count() > 0 Then
		Catalogs.ItemSegments.SaveItemsToSegment(Object.Ref, ItemKeyArray);
	EndIf;
	Catalogs.ItemSegments.CheckContent(Object.Ref);
	
	Items.ContentSegment.Refresh();
	
EndProcedure	

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure Check(Command)
	CheckAtServer(Object.Ref);
	Items.ContentSegment.Refresh();
EndProcedure

&AtServerNoContext
Procedure CheckAtServer(Segment)
	Catalogs.ItemSegments.CheckContent(Segment);
EndProcedure

&AtClient
Procedure ContentSegmentBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	
	FillingValues = New Structure;
	FillingValues.Insert("Segment", Object.Ref);
	If Clone And Items.ContentSegment.CurrentData <> Undefined Then
		FillingValues.Insert("Item", Items.ContentSegment.CurrentData.Item);
		FillingValues.Insert("ItemKey", Items.ContentSegment.CurrentData.ItemKey);
	EndIf;
	FormParameters = New Structure("FillingValues", FillingValues);
	
	OpenForm("InformationRegister.ItemSegments.RecordForm", FormParameters,,,,, 
		New NotifyDescription("AddRowFinish", ThisObject));
EndProcedure

&AtClient
Procedure AddRowFinish(Result, AddInfo) Export
	Items.ContentSegment.Refresh();
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
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