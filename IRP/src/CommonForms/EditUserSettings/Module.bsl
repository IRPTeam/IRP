&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("UserOrGroup") Then
		ThisObject.UserOrGroup = Parameters.UserOrGroup;
		If ValueIsFilled(ThisObject.UserOrGroup) Then
			// set title
			If TypeOf(ThisObject.UserOrGroup) = Type("CatalogRef.Users") Then
				Items.UserOrGroup.Title = R().Form_008;
				Items.MetadataTreeValueFromGroup.Visible = True;
			ElsIf TypeOf(ThisObject.UserOrGroup) = Type("CatalogRef.UserGroups") Then
				Items.UserOrGroup.Title = R().Form_009;
				Items.MetadataTreeValueFromGroup.Visible = False;
			Else
				Items.UserOrGroup.Title = "";
			EndIf;

			CreateMetadataTree();
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure Ok(Command)
	SaveMetadataTree();
	Close();
EndProcedure

&AtClient
Procedure MetadataTreeOnActivateRow(Item)
	CurrentRowID = Items.MetadataTree.CurrentRow;
	If CurrentRowID = Undefined Then
		Return;
	EndIf;
	CurrentRow = ThisObject.MetadataTree.FindByID(CurrentRowID);
	TypeRestriction = CurrentRow.TypeRestriction;
	If TypeRestriction <> New typeDescription() Then
		Items.MetadataTreeValue.TypeRestriction = TypeRestriction;
		Items.MetadataTreeValue.ReadOnly = False;
	Else
		Items.MetadataTreeValue.ReadOnly = True;
	EndIf;
	If CurrentRow.KindOfAttribute = PredefinedValue("Enum.KindsOfAttributes.Additional") Then
		ArrayOfChoiceParameters = New Array();
		ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.Owner", CurrentRow.AddAttributeRef));
		Items.MetadataTreeValue.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
	EndIf;
EndProcedure

&AtClient
Procedure MetadataTreeValueOnChange(Item)
	CurrentRowID = Items.MetadataTree.CurrentRow;
	If CurrentRowID = Undefined Then
		Return;
	EndIf;
	CurrentRow = ThisObject.MetadataTree.FindByID(CurrentRowID);
	CurrentRow.Use = ValueIsFilled(CurrentRow.Value);
EndProcedure

&AtClient
Procedure FilterByAttributeName(Command)
	Return;
EndProcedure

&AtServer
Procedure SaveMetadataTree()
	ArrayOfSavedAttributes = GetArrayOfSavedAttributes();
	TableOfSettings = GetEmptyTableOfSettings();
	CollectSettingsFromTree(ThisObject.MetadataTree.GetItems(), TableOfSettings, ArrayOfSavedAttributes);
	// clear And write new
	RecordSet = InformationRegisters.UserSettings.CreateRecordSet();
	RecordSet.Filter.UserOrGroup.Set(ThisObject.UserOrGroup);
	RecordSet.Load(TableOfSettings);
	RecordSet.Write();
EndProcedure

&AtServer
Procedure CollectSettingsFromTree(TreeRows, TableOfSettings, ArrayOfSavedAttributes)
	For Each Row In TreeRows Do
		If Row.Use And ArrayOfSavedAttributes.Find(Row.KindOfAttribute) <> Undefined Then
			NewRow = TableOfSettings.Add();
			NewRow.UserOrGroup = ThisObject.UserOrGroup;
			NewRow.MetadataObject = Row.FullName;
			NewRow.AttributeName = Row.Name;
			NewRow.Value = Row.Value;
			NewRow.KindOfAttribute = Row.KindOfAttribute;
		EndIf;
		CollectSettingsFromTree(Row.GetItems(), TableOfSettings, ArrayOfSavedAttributes);
	EndDo;
EndProcedure

&AtClient
Procedure OnlyUsedRows(Command)
	Return;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtServer
Procedure CreateMetadataTree()
	ThisObject.MetadataTree.GetItems().Clear();
	TableOfSettings = GetEmptyTableOfSettings();
	ArrayOfSavedAttributes = GetArrayOfSavedAttributes();
	ExistPredefinedDataNames = GetExistPredefinedDataNames();
	// Documents
	NewRow = New Structure();
	NewRow.Insert("GroupName", "Documents");
	NewRow.Insert("PictureIndex", 1);
	NewRow.Insert("Rows", New Array());
	ArrayOfRows = New Array();
	ArrayOfRows.Add(NewRow);
	If ExtractMetadata(Metadata.Documents, TableOfSettings, ArrayOfSavedAttributes, NewRow, 1,
		ExistPredefinedDataNames) Then
		PutMetadataToTree(ArrayOfRows, ThisObject.MetadataTree.GetItems());
	EndIf;
	
	// Catalogs
	NewRow = New Structure();
	NewRow.Insert("GroupName", "Catalogs");
	NewRow.Insert("PictureIndex", 8);
	NewRow.Insert("Rows", New Array());
	ArrayOfRows = New Array();
	ArrayOfRows.Add(NewRow);
	If ExtractMetadata(Metadata.Catalogs, TableOfSettings, ArrayOfSavedAttributes, NewRow, 8, ExistPredefinedDataNames) Then
		PutMetadataToTree(ArrayOfRows, ThisObject.MetadataTree.GetItems());
	EndIf;
	
	// Custom
	NewRow = New Structure();
	NewRow.Insert("GroupName", "Common");
	NewRow.Insert("PictureIndex", 7);
	NewRow.Insert("Rows", New Array());
	ArrayOfRows = New Array();
	ArrayOfRows.Add(NewRow);
	If GetCustomCommonSettings(NewRow, TableOfSettings) Then
		PutMetadataToTree(ArrayOfRows, ThisObject.MetadataTree.GetItems());
	EndIf;

	LoadSettings(TableOfSettings, ThisObject.UserOrGroup);
EndProcedure

&AtServer
Procedure PutMetadataToTree(Source, TreeRow)
	For Each s0 In Source Do
		If s0.Property("Rows") Then
			If s0.Rows.Count() Then
				r0 = TreeRow.Add();
				FillPropertyValues(r0, s0);
				PutMetadataToTree(s0.Rows, r0.GetItems());
			EndIf;
		Else
			FillPropertyValues(TreeRow.Add(), s0);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function ExtractMetadata(MetadataCollection, TableOfSettings, ArrayOfSavedAttributes, RowOwner, PictureIndex,
	ExistPredefinedDataNames)
	Show = False;
	For Each MetadataObject In MetadataCollection Do

		NewRow = New Structure();
		NewRow.Insert("FullName", MetadataObject.FullName());
		NewRow.Insert("Name", MetadataObject.Name);
		NewRow.Insert("Synonym", MetadataObject.Synonym);
		NewRow.Insert("PictureIndex", PictureIndex);
		NewRow.Insert("Rows", New Array());

		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Standard) <> Undefined Then
			If GetStandardAttributes(MetadataObject, NewRow, TableOfSettings) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Regular) <> Undefined Then
			If GetRegularAttributes(MetadataObject, NewRow, TableOfSettings) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Common) <> Undefined Then
			If GetCommonAttributes(MetadataObject, NewRow, TableOfSettings) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Additional) <> Undefined Then
			If GetAdditionalAttributes(MetadataObject, NewRow, TableOfSettings, ExistPredefinedDataNames) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Column) <> Undefined Then
			If GetTabularSections(MetadataObject, NewRow, TableOfSettings) Then
				Show = True;
			EndIf;
		EndIf;

		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Custom) <> Undefined Then
			If GetCustomAttributes(MetadataObject, NewRow, TableOfSettings) Then
				Show = True;
			EndIf;
		EndIf;

		RowOwner.Rows.Add(NewRow);

	EndDo;
	Return Show;
EndFunction

&AtServer
Procedure LoadSettings(TableOfSettings, UserOrGroup)
	Tree = FormAttributeToValue("MetadataTree");
	If TypeOf(ThisObject.UserOrGroup) = Type("CatalogRef.Users") Then
		LoadSettingsToTree(Tree, TableOfSettings, ThisObject.UserOrGroup, "Value", True);
		LoadSettingsToTree(Tree, TableOfSettings, ThisObject.UserOrGroup.UserGroup, "ValueFromGroup");
	Else
		LoadSettingsToTree(Tree, TableOfSettings, ThisObject.UserOrGroup, "Value", True);
	EndIf;
	ValueToFormAttribute(Tree, "MetadataTree");
EndProcedure

&AtServer
Procedure LoadSettingsToTree(Tree, TableOfSettings, UserOrGroup, ValueColumnName, SetUseIfValueIsSet = False)
	TableOfSettings.FillValues(UserOrGroup, "UserOrGroup");
	SavedSettings = GetSavedSettings(TableOfSettings);

	For Each Row In SavedSettings Do
		ArrayOfRows = Tree.Rows.FindRows(New Structure("SettingID", Row.SettingID), True);
		If ArrayOfRows.Count() Then
			ArrayOfRows[0][ValueColumnName] = Row.Value;
			If SetUseIfValueIsSet Then
				ArrayOfRows[0].Use = True;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function GetSavedSettings(TableOfSettings)
	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.UserOrGroup,
	|	tmp.MetadataObject,
	|	tmp.AttributeName,
	|	tmp.SettingID
	|INTO tmp
	|FROM
	|	&TableOfSettings AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.SettingID,
	|	UserSettings.Value
	|FROM
	|	tmp AS tmp
	|		INNER JOIN InformationRegister.UserSettings AS UserSettings
	|		ON tmp.UserOrGroup = UserSettings.UserOrGroup
	|		AND tmp.MetadataObject = UserSettings.MetadataObject
	|		AND tmp.AttributeName = UserSettings.AttributeName";
	Query.SetParameter("TableOfSettings", TableOfSettings);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetEmptyTableOfSettings()
	InfoRegMetadata = Metadata.InformationRegisters.UserSettings;
	TableOfSettings = New ValueTable();
	TableOfSettings.Columns.Add("UserOrGroup", InfoRegMetadata.Dimensions.UserOrGroup.Type);
	TableOfSettings.Columns.Add("MetadataObject", InfoRegMetadata.Dimensions.MetadataObject.Type);
	TableOfSettings.Columns.Add("AttributeName", InfoRegMetadata.Dimensions.AttributeName.Type);
	TableOfSettings.Columns.Add("SettingID", New TypeDescription("UUID"));
	TableOfSettings.Columns.Add("Value", InfoRegMetadata.Resources.Value.Type);
	TableOfSettings.Columns.Add("KindOfAttribute", InfoRegMetadata.Resources.KindOfAttribute.Type);
	Return TableOfSettings;
EndFunction

&AtServer
Function GetArrayOfSavedAttributes()
	ArrayOfSavedAttributes = New Array();
	ArrayOfSavedAttributes.Add(Enums.KindsOfAttributes.Regular);
	ArrayOfSavedAttributes.Add(Enums.KindsOfAttributes.Common);
	ArrayOfSavedAttributes.Add(Enums.KindsOfAttributes.Additional);
	ArrayOfSavedAttributes.Add(Enums.KindsOfAttributes.Column);
	ArrayOfSavedAttributes.Add(Enums.KindsOfAttributes.Custom);
	Return ArrayOfSavedAttributes;
EndFunction

&AtServer
Function GetExistPredefinedDataNames()
	Query = New Query();
	Query.Text =
	"SELECT
	|	AddAttributeAndPropertySets.PredefinedDataName
	|FROM
	|	Catalog.AddAttributeAndPropertySets AS AddAttributeAndPropertySets
	|WHERE
	|	AddAttributeAndPropertySets.Predefined";
	QueryResult = Query.Execute();
	Return QueryResult.Unload().UnloadColumn("PredefinedDataName");
EndFunction

&AtServer
Procedure AddRowToTableOfSettings(TableOfSettings, MetadataObject, AttributeName, SettingID)
	NewRow = TableOfSettings.Add();
	NewRow.MetadataObject = MetadataObject;
	NewRow.AttributeName = AttributeName;
	NewRow.SettingID = SettingID;
EndProcedure

&AtServer
Function FilterIsOk(AttributeInfo)
	If AttributeInfo.KindOfAttribute = Enums.KindsOfAttributes.Regular Or AttributeInfo.KindOfAttribute
		= Enums.KindsOfAttributes.Common Or AttributeInfo.KindOfAttribute = Enums.KindsOfAttributes.Column Then
		If Not AccessRight("View", AttributeInfo.Metadata, Metadata.Roles.FilterForUserSettings) Then
			Return False;
		EndIf;
	EndIf;

	Return True;
EndFunction

&AtServer
Function GetStandardAttributes(MetadataObject, RowOwner, TableOfSettings)
	// Standard attributes
	For Each Attribute In MetadataObject.StandardAttributes Do
		NewRow = New Structure();
		NewRow.Insert("Name", Attribute.Name);
		NewRow.Insert("FullName", MetadataObject.FullName());
		NewRow.Insert("Synonym", ?(ValueIsFilled(Attribute.Synonym), Attribute.Synonym, Attribute.Name));
		NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Standard);
		NewRow.Insert("TypeRestriction", Attribute.Type);
		NewRow.Insert("SettingID", New UUID());
		NewRow.Insert("PictureIndex", 2);
		NewRow.Insert("Metadata", Attribute);
		If FilterIsOk(NewRow) Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
	EndDo;

	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetRegularAttributes(MetadataObject, RowOwner, TableOfSettings)
	// Attributes
	For Each Attribute In MetadataObject.Attributes Do
		NewRow = New Structure();
		NewRow.Insert("Name", Attribute.Name);
		NewRow.Insert("FullName", MetadataObject.FullName());
		NewRow.Insert("Synonym", ?(ValueIsFilled(Attribute.Synonym), Attribute.Synonym, Attribute.Name));
		NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Regular);
		NewRow.Insert("TypeRestriction", Attribute.Type);
		NewRow.Insert("SettingID", New UUID());
		NewRow.Insert("PictureIndex", 3);
		NewRow.Insert("Metadata", Attribute);
		If FilterIsOk(NewRow) Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetCommonAttributes(MetadataObject, RowOwner, TableOfSettings)
	// Common attributes
	For Each CommonAttribute In Metadata.CommonAttributes Do
		Content = CommonAttribute.Content.Find(MetadataObject);

		If Not Content = Undefined Then
			If Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use Or (Content.Use
				= Metadata.ObjectProperties.CommonAttributeUse.Auto And CommonAttribute.AutoUse
				= Metadata.ObjectProperties.CommonAttributeAutoUse.Use) Then
				NewRow = New Structure();
				NewRow.Insert("Name", CommonAttribute.Name);
				NewRow.Insert("FullName", MetadataObject.FullName());
				NewRow.Insert("Synonym", ?(ValueIsFilled(CommonAttribute.Synonym), CommonAttribute.Synonym,
					CommonAttribute.Name));
				NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Common);
				NewRow.Insert("TypeRestriction", CommonAttribute.Type);
				NewRow.Insert("SettingID", New UUID());
				NewRow.Insert("PictureIndex", 4);
				NewRow.Insert("Metadata", CommonAttribute);
				If FilterIsOk(NewRow) Then
					RowOwner.Rows.Add(NewRow);
				EndIf;
				
				// TableOfSettings
				AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
			EndIf;
		EndIf;
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetAdditionalAttributes(MetadataObject, RowOwner, TableOfSettings, ExistPredefinedDataNames)
	PredefinedDataName = StrReplace(MetadataObject.FullName(), ".", "_");
	If ExistPredefinedDataNames.Find(PredefinedDataName) = Undefined Then
		Return False;
	EndIf;
	
	// Add Attributes
	Query = New Query();
	Query.Text =
	"SELECT
	|	AddAttributeAndPropertySets.Ref AS Ref,
	|	AddAttributeAndPropertySetsAttributes.Attribute AS Attribute,
	|	AddAttributeAndPropertySetsAttributes.Attribute.UniqueID AS UniqueID
	|FROM
	|	Catalog.AddAttributeAndPropertySets AS AddAttributeAndPropertySets
	|		INNER JOIN Catalog.AddAttributeAndPropertySets.Attributes AS AddAttributeAndPropertySetsAttributes
	|		ON AddAttributeAndPropertySets.Predefined
	|		AND AddAttributeAndPropertySets.PredefinedDataName = &PredefinedDataName
	|		AND AddAttributeAndPropertySets.Ref = AddAttributeAndPropertySetsAttributes.Ref";

	Query.SetParameter("PredefinedDataName", PredefinedDataName);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		NewRow = New Structure();
		NewRow.Insert("Name", QuerySelection.UniqueID);
		NewRow.Insert("FullName", MetadataObject.FullName());
		NewRow.Insert("Synonym", String(QuerySelection.Attribute));
		NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Additional);
		NewRow.Insert("TypeRestriction", QuerySelection.Attribute.ValueType);
		NewRow.Insert("SettingID", New UUID());
		NewRow.Insert("AddAttributeRef", QuerySelection.Attribute);
		NewRow.Insert("PictureIndex", 5);
		If FilterIsOk(NewRow) Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetTabularSections(MetadataObject, RowOwner, TableOfSettings)
	// Tabular sections
	ArrayOfTabularSections = New Array();

	For Each TabularSection In MetadataObject.TabularSections Do
		NewRow_TabularSection = New Structure();
		NewRow_TabularSection.Insert("Name", TabularSection.Name);
		NewRow_TabularSection.Insert("Synonym", ?(ValueIsFilled(TabularSection.Synonym), TabularSection.Synonym,
			TabularSection.Name));
		NewRow_TabularSection.Insert("KindOfAttribute", Enums.KindsOfAttributes.TabularSection);
		NewRow_TabularSection.Insert("PictureIndex", 6);
		NewRow_TabularSection.Insert("Rows", New Array());
		ArrayOfTabularSections.Add(NewRow_TabularSection);
		For Each Column In TabularSection.Attributes Do
			NewRow = New Structure();
			NewRow.Insert("Name", TabularSection.Name + "." + Column.Name);
			NewRow.Insert("FullName", MetadataObject.FullName());
			NewRow.Insert("Synonym", ?(ValueIsFilled(Column.Synonym), Column.Synonym, Column.Name));
			NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Column);
			NewRow.Insert("TypeRestriction", Column.Type);
			NewRow.Insert("SettingID", New UUID());
			NewRow.Insert("PictureIndex", 3);
			NewRow.Insert("Metadata", Column);
			If FilterIsOk(NewRow) Then
				NewRow_TabularSection.Rows.Add(NewRow);
			EndIf;
			// TableOfSettings
			AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
		EndDo;
	EndDo;

	For Each TabularSection In ArrayOfTabularSections Do
		If Not TabularSection.Rows.Count() Then
			Continue;
		EndIf;
		RowOwner.Rows.Add(TabularSection);
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetCustomAttributes(MetadataObject, RowOwner, TableOfSettings)
	Query = New Query();
	Query.Text =
	"SELECT
	|	CustomUserSettingsRefersToObjects.Ref AS Ref,
	|	CustomUserSettingsRefersToObjects.Ref.UniqueID AS UniqueID
	|FROM
	|	ChartOfCharacteristicTypes.CustomUserSettings.RefersToObjects AS CustomUserSettingsRefersToObjects
	|WHERE
	|	CustomUserSettingsRefersToObjects.FullName = &FullName
	|	AND
	|	NOT CustomUserSettingsRefersToObjects.Ref.IsCommon
	|	AND
	|	NOT CustomUserSettingsRefersToObjects.Ref.DeletionMark
	|GROUP BY
	|	CustomUserSettingsRefersToObjects.Ref,
	|	CustomUserSettingsRefersToObjects.Ref.UniqueID";
	Query.SetParameter("FullName", MetadataObject.FullName());
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		NewRow = New Structure();
		NewRow.Insert("Name", QuerySelection.UniqueID);
		NewRow.Insert("FullName", MetadataObject.FullName());
		NewRow.Insert("Synonym", String(QuerySelection.Ref));
		NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Custom);
		NewRow.Insert("TypeRestriction", QuerySelection.Ref.ValueType);
		NewRow.Insert("SettingID", New UUID());
		NewRow.Insert("PictureIndex", 9);
		If FilterIsOk(NewRow) Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetCustomCommonSettings(RowOwner, TableOfSettings)
	Query = New Query();
	Query.Text =
	"SELECT
	|	CustomUserSettings.Ref AS Ref,
	|	CustomUserSettings.Ref.UniqueID AS UniqueID
	|FROM
	|	ChartOfCharacteristicTypes.CustomUserSettings AS CustomUserSettings
	|WHERE
	|	CustomUserSettings.IsCommon
	|	AND
	|	NOT CustomUserSettings.DeletionMark";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		NewRow = New Structure();
		NewRow.Insert("Name", QuerySelection.UniqueID);
		NewRow.Insert("Synonym", String(QuerySelection.Ref));
		NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Custom);
		NewRow.Insert("TypeRestriction", QuerySelection.Ref.ValueType);
		NewRow.Insert("SettingID", New UUID());
		NewRow.Insert("PictureIndex", 9);
		If FilterIsOk(NewRow) Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, "", NewRow.Name, NewRow.SettingID);
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

#Region FormCommandsEventHandlers

&AtClient
Procedure MetadataTreeCollapseAll(Command)
	CollapseTreeRows(MetadataTree);
EndProcedure

&AtClient
Procedure MetadataTreeExpandAll(Command)
	For Each Row In MetadataTree.GetItems() Do
		Items.MetadataTree.Expand(Row.GetID(), True);
	EndDo;
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure CollapseTreeRows(Row)
	ChildRows = Row.GetItems();
	For Each ChildRow In ChildRows Do
		CollapseTreeRows(ChildRow);
		Items.MetadataTree.Collapse(ChildRow.GetID());
	EndDo;
EndProcedure

#EndRegion