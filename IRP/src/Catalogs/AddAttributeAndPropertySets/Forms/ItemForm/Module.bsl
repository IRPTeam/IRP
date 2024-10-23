
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);

	Items.AttributesInterfaceGroup.Visible = Object.Ref = PredefinedValue(
		"Catalog.AddAttributeAndPropertySets.Catalog_Items") Or Object.Ref = PredefinedValue(
		"Catalog.AddAttributeAndPropertySets.Catalog_Partners");

	Items.AttributesCopyInterfaceGroup.Visible = Items.AttributesInterfaceGroup.Visible; 

	IsCatalog_ItemKeys = Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_ItemKeys")
		Or Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_PriceKeys");

	Items.GroupAttributesItemKeys.Visible = IsCatalog_ItemKeys;
	Items.GroupAttributes.Visible = Not IsCatalog_ItemKeys;

	If IsCatalog_ItemKeys Then
		OnlyAffectPricing = Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_PriceKeys");
		FillAttributesTree(GetItemTypesTree(), ThisObject.AttributesTree, OnlyAffectPricing);
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		UpdateAttributesTree();
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Not (CurrentObject.Ref = Catalogs.AddAttributeAndPropertySets.Catalog_Items
		Or CurrentObject.Ref = Catalogs.AddAttributeAndPropertySets.Catalog_Partners) Then
		For Each Row In CurrentObject.Attributes Do
			Row.InterfaceGroup = Undefined;
		EndDo;
	EndIf;
	WriteCondition(CurrentObject, "Attributes"          , "Attribute");
	WriteCondition(CurrentObject, "Properties"          , "Property");
	WriteCondition(CurrentObject, "ExtensionAttributes" , "Attribute");
EndProcedure

&AtServer
Procedure WriteCondition(CurrentObject, TableName, ColumnName)
	For Each Row In Object[TableName] Do
		If Not IsBlankString(Row.ConditionData) Then
			ConditionData  = CommonFunctionsServer.DeserializeXMLUseXDTO(Row.ConditionData);
			FilterRow = New Structure(ColumnName, Row[ColumnName]);
			CurrentObject[TableName].FindRows(FilterRow)[0].Condition = 
				New ValueStorage(ConditionData, New Deflation(9));
			Row.ConditionData = "";
		EndIf;
	EndDo;	
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdateAddAttributeAndPropertySets", New Structure(), ThisObject);
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers

&AtClient
Procedure AttributesTreeOnActivateRow(Item)
	CurrentData = Items.AttributesTree.CurrentData;
	Items.EditItemType.Enabled = CurrentData <> Undefined And ValueIsFilled(CurrentData.ItemType)
		And Not ServiceSystemServer.GetObjectAttribute(CurrentData.ItemType, "IsFolder");

	Items.DeleteItemType.Enabled = CurrentData <> Undefined And ValueIsFilled(CurrentData.ItemType) And ValueIsFilled(
		CurrentData.Attribute) And Not ServiceSystemServer.GetObjectAttribute(CurrentData.ItemType, "IsFolder");
EndProcedure

&AtClient
Procedure AttributesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Then
		Cancel = True;
		BeforeAddRowIsClone("Attributes", "Attribute", "CopyAttributesRow");
	EndIf;
EndProcedure

&AtClient
Procedure PropertiesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Then
		Cancel = True;
		BeforeAddRowIsClone("Properties", "Property", "CopyPropertiesRow");
	EndIf;
EndProcedure

&AtClient
Procedure ExtensionAttributesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Then
		Cancel = True;
		BeforeAddRowIsClone("ExtensionAttributes", "Attribute", "CopyExtensionAttributesRow");
	EndIf;
EndProcedure

&AtClient
Procedure BeforeAddRowIsClone(TableName, ColumnName, AttachIdleHandler)
	CurrentData = Items[TableName].CurrentData;
	If ValueIsFilled(ThisObject.CopiedAttribute) Or Not CurrentData.IsConditionSet Then
		Return;
	EndIf;
	ThisObject.CopiedAttribute = CurrentData[ColumnName];
	NewRow = Object[TableName].Add();
	FillPropertyValues(NewRow, CurrentData);
	NewRow.Unprocessed = True;
	Items[TableName].CurrentRow = NewRow.GetID();
	AttachIdleHandler(AttachIdleHandler, 0.1, True);
	Items[TableName].ChangeRow();
EndProcedure

&AtClient
Procedure AttributesCollectionOnChange(Item)
	Items.Attributes.CurrentData.PathForTag = "";
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure SetConditionAttribute(Command)
	SetCondition("Attributes", "Attribute");
EndProcedure

&AtClient
Procedure SetConditionProperty(Command)
	SetCondition("Properties", "Property");
EndProcedure

&AtClient
Procedure SetConditionExtensionAttribute(Command)
	SetCondition("ExtensionAttributes", "Attribute");
EndProcedure

&AtClient
Procedure EditItemType(Command)
	CurrentData = Items.AttributesTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenArgs = New Structure();
	OpenArgs.Insert("Key", CurrentData.ItemType);
	If ServiceSystemServer.GetObjectAttribute(OpenArgs.Key, "IsFolder") Then
		OpenFormName = "Catalog.ItemTypes.Form.GroupForm";
	Else
		OpenFormName = "Catalog.ItemTypes.Form.ItemForm";
	EndIf;
	OpenForm(OpenFormName, OpenArgs, ThisObject);
EndProcedure

&AtClient
Procedure DeleteItemType(Command)
	CurrentData = Items.AttributesTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If ValueIsFilled(CurrentData.ItemType) And ValueIsFilled(CurrentData.Attribute) Then

		DeleteItemTypeAtServer(CurrentData.ItemType, CurrentData.Attribute);
		UpdateAttributesTree();
	EndIf;
EndProcedure

&AtClient
Procedure FillExtensionAttributesList(Command)
	FillExtensionAttributesListAtServer();
EndProcedure

&AtClient
Procedure CopyAttributeRequired(Command)
	If Items.Pages.CurrentPage = Items.GroupExtensionAttributes Then
		FormTable = Items.ExtensionAttributes;
		ObjectTable = Object.ExtensionAttributes;
	Else
		FormTable = Items.Attributes;
		ObjectTable = Object.Attributes;
	EndIf;	
	If FormTable.CurrentData = Undefined Or FormTable.SelectedRows.Count() < 2 Then
		Return;
	EndIf;
	For Each SelectedRow In FormTable.SelectedRows Do
		Row = ObjectTable.FindByID(SelectedRow);
		Row.Required = FormTable.CurrentData.Required;
	EndDo;	
EndProcedure

&AtClient
Procedure CopyAttributeShow(Command)
	If Items.Pages.CurrentPage = Items.GroupExtensionAttributes Then
		FormTable = Items.ExtensionAttributes;
		ObjectTable = Object.ExtensionAttributes;
	Else
		FormTable = Items.Attributes;
		ObjectTable = Object.Attributes;
	EndIf;	
	If FormTable.CurrentData = Undefined Or FormTable.SelectedRows.Count() < 2 Then
		Return;
	EndIf;
	For Each SelectedRow In FormTable.SelectedRows Do
		Row = ObjectTable.FindByID(SelectedRow);
		Row.Show = FormTable.CurrentData.Show;
	EndDo;	
EndProcedure

&AtClient
Procedure CopyAttributeShowInHTML(Command)
	If Items.Pages.CurrentPage = Items.GroupExtensionAttributes Then
		FormTable = Items.ExtensionAttributes;
		ObjectTable = Object.ExtensionAttributes;
	Else
		FormTable = Items.Attributes;
		ObjectTable = Object.Attributes;
	EndIf;	
	If FormTable.CurrentData = Undefined Or FormTable.SelectedRows.Count() < 2 Then
		Return;
	EndIf;
	For Each SelectedRow In FormTable.SelectedRows Do
		Row = ObjectTable.FindByID(SelectedRow);
		Row.ShowInHTML = FormTable.CurrentData.ShowInHTML;
	EndDo;	
EndProcedure

&AtClient
Procedure CopyCondition(Command)
	If Items.Pages.CurrentPage = Items.GroupExtensionAttributes Then
		TableName = "ExtensionAttributes";
	Else
		TableName = "Attributes";
	EndIf;	
	If Items[TableName].CurrentRow = Undefined Or Items[TableName].SelectedRows.Count() < 2 Then
		Return;
	EndIf;	
	IndicesArray = New Array;
	CurrentIndex = 0;
	For Each SelectedRow In Items[TableName].SelectedRows Do
		Row = Object[TableName].FindByID(SelectedRow);
		If SelectedRow <> Items[TableName].CurrentRow Then
			IndicesArray.Add(Object[TableName].IndexOf(Row));
		Else
			CurrentIndex = Object[TableName].IndexOf(Row);
		EndIf;
	EndDo;	
	If Write() Then
		CopyExtensionAttributesConditionAtServer(TableName, CurrentIndex, IndicesArray);
	EndIf; 
EndProcedure

&AtClient
Procedure CopyInterfaceGroup(Command)
	If Items.Pages.CurrentPage = Items.GroupExtensionAttributes Then
		FormTable = Items.ExtensionAttributes;
		ObjectTable = Object.ExtensionAttributes;
	Else
		FormTable = Items.Attributes;
		ObjectTable = Object.Attributes;
	EndIf;	
	If FormTable.CurrentData = Undefined Or FormTable.SelectedRows.Count() < 2 Then
		Return;
	EndIf;
	For Each SelectedRow In FormTable.SelectedRows Do
		Row = ObjectTable.FindByID(SelectedRow);
		Row.InterfaceGroup = FormTable.CurrentData.InterfaceGroup;
	EndDo;	
EndProcedure

#EndRegion

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

#Region Private

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Function GetItemTypesTree()
	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemTypes.Ref AS ItemType,
	|	ItemTypes.IsFolder AS isFolder
	|FROM
	|	Catalog.ItemTypes AS ItemTypes
	|WHERE
	|	NOT ItemTypes.DeletionMark
	|AUTOORDER";

	QueryResult = Query.Execute();
	Return QueryResult.Unload(QueryResultIteration.ByGroupsWithHierarchy);
EndFunction

&AtServer
Procedure FillAttributesTree(ItemTypesTree, AttributesTree, OnlyAffectPricing)
	For Each ItemTypesRow In ItemTypesTree.Rows Do
		NewItemTypeRow = AttributesTree.GetItems().Add();
		NewItemTypeRow.Picture = ?(ItemTypesRow.isFolder, 0, 3);
		NewItemTypeRow.ItemType = ItemTypesRow.ItemType;
		NewItemTypeRow.Presentation = String(ItemTypesRow.ItemType);
		If Not ItemTypesRow.IsFolder Then
			For Each AttributeRow In ItemTypesRow.ItemType.AvailableAttributes Do
				If OnlyAffectPricing And Not AttributeRow.AffectPricing Then
					Continue;
				EndIf;
				NewAttributeRow = NewItemTypeRow.GetItems().Add();
				NewAttributeRow.Picture = 4;
				NewAttributeRow.Attribute = AttributeRow.Attribute;
				NewAttributeRow.ItemType = ItemTypesRow.ItemType;
				NewAttributeRow.Presentation = String(AttributeRow.Attribute);
			EndDo;
		EndIf;
		FillAttributesTree(ItemTypesRow, NewItemTypeRow, OnlyAffectPricing);
	EndDo;
EndProcedure

&AtServerNoContext
Procedure DeleteItemTypeAtServer(ItemType, Attribute)
	Catalogs.ItemTypes.DeleteAvailableAttribute(ItemType, Attribute);
EndProcedure

&AtClient
Procedure UpdateAttributesTree()
	UpdateAttributesTreeAtServer();
EndProcedure

&AtServer
Procedure UpdateAttributesTreeAtServer()
	ThisObject.AttributesTree.GetItems().Clear();
	OnlyAffectPricing = Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_PriceKeys");
	FillAttributesTree(GetItemTypesTree(), ThisObject.AttributesTree, OnlyAffectPricing);
EndProcedure

&AtClient
Procedure SetCondition(TableName, ColumnName)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	NotifyParameters = New Structure();
	NotifyParameters.Insert("TableName"   , TableName);
	NotifyParameters.Insert("ColumnName"  , ColumnName);
	NotifyParameters.Insert("CurrentData" , CurrentData[ColumnName]);
	
	If Not ValueIsFilled(Object.Ref) Or ThisObject.Modified Then
		Notify = New NotifyDescription("SetConditionNotify", ThisObject, NotifyParameters);
		ShowQueryBox(Notify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		SetConditionNotify(DialogReturnCode.Yes, NotifyParameters);
	EndIf;
EndProcedure

&AtClient
Procedure SetConditionNotify(Result, AdditionalParameters) Export
	If Result = DialogReturnCode.Yes And Write() Then
		Notify = New NotifyDescription("OnFinishEditFilter", ThisObject, AdditionalParameters);
		OpeningParameters = New Structure();
		OpeningParameters.Insert("SavedSettings", GetSettings(AdditionalParameters));
		OpeningParameters.Insert("Ref", Object.Ref);
		OpenForm("Catalog.AddAttributeAndPropertySets.Form.EditCondition", OpeningParameters, ThisObject, , , , Notify);
	EndIf;
EndProcedure

&AtClient
Procedure OnFinishEditFilter(Result, AdditionalParameters) Export
	If TypeOf(Result) = Type("Structure") Then
		SaveSettings(AdditionalParameters, Result.Settings);
	EndIf;
EndProcedure

&AtServer
Function GetSettings(Parameters)
	Filter = New Structure(Parameters.ColumnName, Parameters.CurrentData);
	CatalogObject = Object.Ref.GetObject();
	ArrayOfRows = CatalogObject[Parameters.TableName].FindRows(Filter);
	If ArrayOfRows.Count() Then
		Return ArrayOfRows[0].Condition.Get();
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Procedure SaveSettings(Parameters, Settings)
	Filter = New Structure(Parameters.ColumnName, Parameters.CurrentData);
	CatalogObject = Object.Ref.GetObject();
	ArrayOfRows = CatalogObject[Parameters.TableName].FindRows(Filter);
	For Each Row In ArrayOfRows Do

		SettingsIsSet = False;
		If Settings <> Undefined Then
			For Each FilterItem In Settings.Filter.Items Do
				If FilterItem.Use Then
					SettingsIsSet = True;
					Break;
				EndIf;
			EndDo;
		EndIf;

		If SettingsIsSet Then
			Row.Condition = New ValueStorage(Settings);
			Row.IsConditionSet = 1;
		Else
			Row.Condition = Undefined;
			Row.IsConditionSet = 0;
		EndIf;

	EndDo;
	CatalogObject.Write();
	ThisObject.Read();
EndProcedure

&AtClient
Procedure CopyAttributesRow() Export
	If ValueIsFilled(ThisObject.CopiedAttribute) Then
		CopyAttributesPropertiesRowAtServer(New Structure("TableName, ColumnName",
			"Attributes", "Attribute"));
	EndIf;
EndProcedure

&AtClient
Procedure CopyPropertiesRow() Export
	If ThisObject.CopiedAttribute.IsEmpty() Then
		CopyAttributesPropertiesRowAtServer(New Structure("TableName, ColumnName",
			"Properties", "Property"));
	EndIf;
EndProcedure

&AtClient
Procedure CopyExtensionAttributesRow() Export
	If ValueIsFilled(ThisObject.CopiedAttribute) Then
		CopyAttributesPropertiesRowAtServer(New Structure("TableName, ColumnName",
			"ExtensionAttributes", "Attribute"));
	EndIf;
EndProcedure

&AtServer
Procedure CopyAttributesPropertiesRowAtServer(Parameters)
	SourceFilter = New Structure();
	SourceFilter.Insert(Parameters.ColumnName, ThisObject.CopiedAttribute);
	SourceFilter.Insert("Unprocessed", False);
	FoundSourceRows = Object[Parameters.TableName].FindRows(SourceFilter);

	DestinationFilter = New Structure();
	DestinationFilter.Insert(Parameters.ColumnName, ThisObject.CopiedAttribute);
	DestinationFilter.Insert("Unprocessed", True);
	FoundDestinationRows = Object[Parameters.TableName].FindRows(DestinationFilter);

	If FoundSourceRows.Count() And FoundDestinationRows.Count() Then
		DestinationRow = FoundDestinationRows[0];
		SourceRow = FoundSourceRows[0];
		If IsBlankString(SourceRow.ConditionData) Then
			Parameters.Insert("CurrentData", SourceRow[Parameters.ColumnName]);
			ConditionData = GetSettings(Parameters);
			DestinationRow.ConditionData = CommonFunctionsServer.SerializeXMLUseXDTO(ConditionData);
		Else
			DestinationRow.ConditionData = SourceRow.ConditionData;
		EndIf;
		DestinationRow.Unprocessed = False;
	EndIf;

	ThisObject.CopiedAttribute = ChartsOfCharacteristicTypes.AddAttributeAndProperty.EmptyRef();
EndProcedure

&AtServer
Procedure FillExtensionAttributesListAtServer()
	Segments = StrSplit(Object.PredefinedDataName, "_");
	If Segments.Count() = 2 Then
		MetadataName = StrReplace(Object.PredefinedDataName, "_", ".");
	Else
		MetadataName = Segments[0]+"."+Segments[1]+"_"+Segments[2];
	EndIf;
	ObjectMetadata = Metadata.FindByFullName(MetadataName);
	For Each Attribute In ObjectMetadata.Attributes Do
		If Not StrFind(Attribute.Name, "_") Then
			Continue;
		EndIf;
		AttributeFilter = New Structure();
		AttributeFilter.Insert("Attribute", Attribute.Name);
		FoundRows = Object.ExtensionAttributes.FindRows(AttributeFilter);
		If FoundRows.Count() Then
			Continue;
		EndIf;
		NewRow = Object.ExtensionAttributes.Add();
		NewRow.Attribute = Attribute.Name;
	EndDo;
EndProcedure

&AtServer
Procedure CopyExtensionAttributesConditionAtServer(TableName, CurrentRow, IndicesArray)
	CatalogObject = Object.Ref.GetObject();
	CurrentData = CatalogObject[TableName].Get(CurrentRow);	
	For Each Index In IndicesArray Do
		Row = CatalogObject[TableName][Index];
		Row.IsConditionSet = CurrentData.IsConditionSet;
		Row.Condition = CurrentData.Condition; 
	EndDo;
	CatalogObject.Write();
	ThisObject.Read();	
EndProcedure

#EndRegion