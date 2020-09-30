
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	
	Items.AttributesInterfaceGroup.Visible =
		Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_Items")
		Or Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_Partners");
	
	IsCatalog_ItemKeys =
		Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_ItemKeys")
		Or Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_PriceKeys");
	
	Items.GroupAttributesItemKeys.Visible = IsCatalog_ItemKeys;
	Items.GroupAttributes.Visible = Not IsCatalog_ItemKeys;
	
	If IsCatalog_ItemKeys Then
		OnlyAffectPricing = Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_PriceKeys");
		FillAttributesTree(GetItemTypesTree(), ThisObject.AttributesTree, OnlyAffectPricing);
	EndIf;
	ExtensionServer.AddAtributesFromExtensions(ThisObject, Object.Ref, Items.Pages);

EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		UpdateAttributesTree();
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If Not (CurrentObject.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_Items")
			Or CurrentObject.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_Partners")) Then
		For Each Row In CurrentObject.Attributes Do
			Row.InterfaceGroup = Undefined;
		EndDo;
	EndIf;
	For Each Row In Object.Attributes Do
		If Not IsBlankString(Row.ConditionData) Then
			FilterRow = New Structure("Attribute", Row.Attribute);
			CurrentObjectRows = CurrentObject.Attributes.FindRows(FilterRow);
			CurrentObjectRow = CurrentObjectRows[0];
			ConditionData = CommonFunctionsServer.DeserializeXMLUseXDTO(Row.ConditionData);
			CurrentObjectRow.Condition = New ValueStorage(ConditionData, New Deflation(9));
			Row.ConditionData = "";
		EndIf;
	EndDo;
	For Each Row In Object.Properties Do
		If Not IsBlankString(Row.ConditionData) Then
			FilterRow = New Structure("Property", Row.Property);
			CurrentObjectRows = CurrentObject.Properties.FindRows(FilterRow);
			CurrentObjectRow = CurrentObjectRows[0];
			ConditionData = CommonFunctionsServer.DeserializeXMLUseXDTO(Row.ConditionData);
			CurrentObjectRow.Condition = New ValueStorage(ConditionData, New Deflation(9));
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
	Items.EditItemType.Enabled =
		CurrentData <> Undefined
		And ValueIsFilled(CurrentData.ItemType)
		And Not ServiceSystemServer.GetObjectAttribute(CurrentData.ItemType, "IsFolder");
	
	Items.DeleteItemType.Enabled =
		CurrentData <> Undefined
		And ValueIsFilled(CurrentData.ItemType)
		And ValueIsFilled(CurrentData.Attribute)
		And Not ServiceSystemServer.GetObjectAttribute(CurrentData.ItemType, "IsFolder");
EndProcedure

&AtClient
Procedure AttributesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Then
		Cancel = True;
		CurrentData = Items.Attributes.CurrentData;
		If Not CopiedAttribute.IsEmpty()
			Or Not CurrentData.IsConditionSet Then
			Return;
		EndIf;		
		NewRow = Object.Attributes.Add();
		FillPropertyValues(NewRow, CurrentData);
		NewRow.Unprocessed = True;
		CopiedAttribute = Items.Attributes.CurrentData.Attribute;
		Items.Attributes.CurrentRow = NewRow.GetID();
		AttachIdleHandler("CopyAttributesRow", 0.1, True);
		Items.Attributes.ChangeRow();		
	EndIf;
EndProcedure

&AtClient
Procedure PropertiesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Then
		Cancel = True;
		CurrentData = Items.Properties.CurrentData;
		If Not CopiedAttribute.IsEmpty()
			Or Not CurrentData.IsConditionSet Then
			Return;
		EndIf;		
		NewRow = Object.Properties.Add();
		FillPropertyValues(NewRow, CurrentData);
		NewRow.Unprocessed = True;
		CopiedAttribute = Items.Properties.CurrentData.Property;
		Items.Properties.CurrentRow = NewRow.GetID();
		AttachIdleHandler("CopyPropertiesRow", 0.1, True);
		Items.Properties.ChangeRow();
	EndIf;
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
	
	If ValueIsFilled(CurrentData.ItemType)
		And ValueIsFilled(CurrentData.Attribute) Then
		
		DeleteItemTypeAtServer(CurrentData.ItemType, CurrentData.Attribute);
		UpdateAttributesTree();
	EndIf;
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
	ExpandTree(ThisObject.AttributesTree, ThisObject.AttributesTree.GetItems());
EndProcedure

&AtServer
Procedure UpdateAttributesTreeAtServer()
	ThisObject.AttributesTree.GetItems().Clear();
	OnlyAffectPricing = Object.Ref = PredefinedValue("Catalog.AddAttributeAndPropertySets.Catalog_PriceKeys");
	FillAttributesTree(GetItemTypesTree(), ThisObject.AttributesTree, OnlyAffectPricing);
EndProcedure

&AtClient
Procedure ExpandTree(Tree, TreeRows)
	For Each ItemTreeRows In TreeRows Do
		ThisObject.Items.AttributesTree.Expand(ItemTreeRows.GetID());
		ExpandTree(Tree, ItemTreeRows.GetItems());
	EndDo;
EndProcedure

&AtClient
Procedure SetCondition(TableName, ColumnName, AddInfo = Undefined)
	If AddInfo = Undefined Then
		AddInfo = New Structure();
	EndIf;
	AddInfo.Insert("TableName", TableName);
	AddInfo.Insert("ColumnName", ColumnName);
	
	If Not ValueIsFilled(Object.Ref) Or ThisObject.Modified Then
		QuestionToUserNotify = New NotifyDescription("SetConditionNotify", ThisObject, AddInfo);
		ShowQueryBox(QuestionToUserNotify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		SetConditionNotify(DialogReturnCode.Yes, AddInfo);
	EndIf;
EndProcedure

&AtClient
Procedure SetConditionNotify(Result, AddInfo = Undefined) Export
	If Result = DialogReturnCode.Yes And Write() Then
		CurrentRow = Items[AddInfo.TableName].CurrentData;
		If CurrentRow = Undefined Then
			Return;
		EndIf;
		
		AddInfo.Insert("Element", CurrentRow[AddInfo.ColumnName]);
		
		Notify = New NotifyDescription("OnFinishEditFilter", ThisObject, AddInfo);
		OpeningParameters = New Structure();
		OpeningParameters.Insert("SavedSettings", GetSettings(CurrentRow[AddInfo.ColumnName], AddInfo));
		OpeningParameters.Insert("Ref", Object.Ref);
		OpenForm("Catalog.AddAttributeAndPropertySets.Form.EditCondition", OpeningParameters, ThisObject, , , , Notify);
	EndIf;
EndProcedure

&AtClient
Procedure OnFinishEditFilter(Result, AddInfo = Undefined) Export
	If TypeOf(Result) = Type("Structure") Then
		SaveSettings(AddInfo.Element, Result.Settings, AddInfo);
	EndIf;
EndProcedure

&AtServer
Function GetSettings(Element, AddInfo = Undefined)
	Filter = New Structure(AddInfo.ColumnName, Element);
	CatalogObject = Object.Ref.GetObject();
	ArrayOfRows = CatalogObject[AddInfo.TableName].FindRows(Filter);
	If ArrayOfRows.Count() Then
		Return ArrayOfRows[0].Condition.Get();
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Procedure SaveSettings(Element, Settings, AddInfo = Undefined)
	Filter = New Structure(AddInfo.ColumnName, Element);
	CatalogObject = Object.Ref.GetObject();
	ArrayOfRows = CatalogObject[AddInfo.TableName].FindRows(Filter);
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
Procedure CopyAttributesRow()
	If CopiedAttribute.IsEmpty() Then
		Return;
	EndIf;
	AddInfo = New Structure();
	AddInfo.Insert("TableName", "Attributes");
	AddInfo.Insert("ColumnName", "Attribute");
	CopyAttributesPropertiesRowAtServer(AddInfo);
EndProcedure

&AtClient
Procedure CopyPropertiesRow()
	If CopiedAttribute.IsEmpty() Then
		Return;
	EndIf;
	AddInfo = New Structure();
	AddInfo.Insert("TableName", "Properties");
	AddInfo.Insert("ColumnName", "Property");
	CopyAttributesPropertiesRowAtServer(AddInfo);
EndProcedure

&AtServer
Procedure CopyAttributesPropertiesRowAtServer(AddInfo)
	SourceFilter = New Structure;
	SourceFilter.Insert(AddInfo.ColumnName, CopiedAttribute);
	SourceFilter.Insert("Unprocessed", False);	
	FoundSourceRows = Object[AddInfo.TableName].FindRows(SourceFilter);
	
	DestinationFilter = New Structure;
	DestinationFilter.Insert(AddInfo.ColumnName, CopiedAttribute);
	DestinationFilter.Insert("Unprocessed", True);	
	FoundDestinationRows = Object[AddInfo.TableName].FindRows(DestinationFilter);
	
	If FoundSourceRows.Count()
		And FoundDestinationRows.Count() Then
		DestinationRow = FoundDestinationRows[0];
		SourceRow = FoundSourceRows[0];
		If IsBlankString(SourceRow.ConditionData) Then			
			ConditionData = GetSettings(SourceRow[AddInfo.ColumnName], AddInfo);
			DestinationRow.ConditionData = CommonFunctionsServer.SerializeXMLUseXDTO(ConditionData);
		Else
			DestinationRow.ConditionData = SourceRow.ConditionData;
		EndIf;
		DestinationRow.Unprocessed = False;
	EndIf;
	
	CopiedAttribute = ChartsOfCharacteristicTypes.AddAttributeAndProperty.EmptyRef();	
EndProcedure

#EndRegion