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
Procedure SetDefaultSettings(Command)
	SetDefaultSettingsAtServer();
EndProcedure

&AtServer
Procedure SetDefaultSettingsAtServer()
	UserSettingsServer.SetDefaultUserSettings_ByUser(ThisObject.UserOrGroup);
	CreateMetadataTree();	
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
	
	RefreshReusableValues();
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
			
			If NewRow.Value = Undefined 
					And TypeOf(Row.TypeRestriction) = Type("TypeDescription") Then
				NewRow.Value = Row.TypeRestriction.AdjustValue();
			EndIf;
		EndIf;
		CollectSettingsFromTree(Row.GetItems(), TableOfSettings, ArrayOfSavedAttributes);
	EndDo;
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
	
	// Additional settings
	NewRow = New Structure();
	NewRow.Insert("GroupName", R().Add_Setiings_001);
	NewRow.Insert("PictureIndex", 10);
	NewRow.Insert("Rows", New Array());
	ArrayOfRows = New Array();
	ArrayOfRows.Add(NewRow);
	If GetAdditionalSettings(NewRow, TableOfSettings) Then
		PutMetadataToTree(ArrayOfRows, ThisObject.MetadataTree.GetItems());
	EndIf;
	
	// Documents
	NewRow = New Structure();
	NewRow.Insert("GroupName", "Documents");
	NewRow.Insert("PictureIndex", 1);
	NewRow.Insert("Rows", New Array());
	ArrayOfRows = New Array();
	ArrayOfRows.Add(NewRow);
	If ExtractMetadata(Metadata.Documents, TableOfSettings, ArrayOfSavedAttributes, NewRow, 1, ExistPredefinedDataNames) Then
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
Function ExtractMetadata(MetadataCollection, TableOfSettings, ArrayOfSavedAttributes, RowOwner, PictureIndex, ExistPredefinedDataNames)
	Query = New Query();
	Query.Text = 
	"SELECT DISTINCT
	|	UserSettings.MetadataObject,
	|	UserSettings.AttributeName,
	|	UserSettings.KindOfAttribute
	|FROM
	|	InformationRegister.UserSettings AS UserSettings";
	QueryResult = Query.Execute();
	SettingsFromRegister = QueryResult.Unload();
	
	MetadataTable = New ValueTable();
	MetadataTable.Columns.Add("Synonym");
	MetadataTable.Columns.Add("MetadataObject");
	
	For Each MetadataObject In MetadataCollection Do
		NewRow = MetadataTable.Add();
		NewRow.Synonym = MetadataObject.Synonym;
		NewRow.MetadataObject = MetadataObject;
	EndDo;
	
	MetadataTable.Sort("Synonym");
	
	Show = False;

	For Each Row In MetadataTable Do

		NewRow = New Structure();
		NewRow.Insert("FullName"     , Row.MetadataObject.FullName());
		NewRow.Insert("Name"         , Row.MetadataObject.Name);
		NewRow.Insert("Synonym"      , Row.MetadataObject.Synonym);
		NewRow.Insert("PictureIndex" , PictureIndex);
		NewRow.Insert("Rows"         , New Array());

		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Standard) <> Undefined Then
			If GetStandardAttributes(Row.MetadataObject, NewRow, TableOfSettings, 
				SettingsFromRegister.Copy(New Structure("KindOfAttribute", Enums.KindsOfAttributes.Standard))) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Regular) <> Undefined Then
			If GetRegularAttributes(Row.MetadataObject, NewRow, TableOfSettings,
				SettingsFromRegister.Copy(New Structure("KindOfAttribute", Enums.KindsOfAttributes.Regular))) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Common) <> Undefined Then
			If GetCommonAttributes(Row.MetadataObject, NewRow, TableOfSettings,
				SettingsFromRegister.Copy(New Structure("KindOfAttribute", Enums.KindsOfAttributes.Common))) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Additional) <> Undefined Then
			If GetAdditionalAttributes(Row.MetadataObject, NewRow, TableOfSettings, ExistPredefinedDataNames,
				SettingsFromRegister.Copy(New Structure("KindOfAttribute", Enums.KindsOfAttributes.Additional))) Then
				Show = True;
			EndIf;
		EndIf;
		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Column) <> Undefined Then
			If GetTabularSections(Row.MetadataObject, NewRow, TableOfSettings,
				SettingsFromRegister.Copy(New Structure("KindOfAttribute", Enums.KindsOfAttributes.Column))) Then
				Show = True;
			EndIf;
		EndIf;

		If ArrayOfSavedAttributes.Find(Enums.KindsOfAttributes.Custom) <> Undefined Then
			If GetCustomAttributes(Row.MetadataObject, NewRow, TableOfSettings,
				SettingsFromRegister.Copy(New Structure("KindOfAttribute", Enums.KindsOfAttributes.Custom))) Then
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
	ArrayOfSavedAttributes.Add(Enums.KindsOfAttributes.AdditionalSetting);
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
	If AttributeInfo.KindOfAttribute = Enums.KindsOfAttributes.Regular 
		Or AttributeInfo.KindOfAttribute = Enums.KindsOfAttributes.Common 
		Or AttributeInfo.KindOfAttribute = Enums.KindsOfAttributes.Column Then
		If Not AccessRight("View", AttributeInfo.Metadata, Metadata.Roles.FilterForUserSettings) Then
			Return False;
		EndIf;
	EndIf;

	Return True;
EndFunction

&AtServer
Function GetStandardAttributes(MetadataObject, RowOwner, TableOfSettings, SettingsFromRegister)
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
		If FilterIsOk(NewRow) 
			Or SettingsFromRegister.FindRows(New Structure("MetadataObject, AttributeName", NewRow.FullName, NewRow.Name)).Count() <> 0 Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
	EndDo;

	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetRegularAttributes(MetadataObject, RowOwner, TableOfSettings, SettingsFromRegister)
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
		If FilterIsOk(NewRow) 
			Or SettingsFromRegister.FindRows(New Structure("MetadataObject, AttributeName", NewRow.FullName, NewRow.Name)).Count() <> 0 Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetCommonAttributes(MetadataObject, RowOwner, TableOfSettings, SettingsFromRegister)
	// Common attributes
	For Each CommonAttribute In Metadata.CommonAttributes Do
		Content = CommonAttribute.Content.Find(MetadataObject);

		If Not Content = Undefined Then
			If Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use 
				Or (Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Auto 
				And CommonAttribute.AutoUse = Metadata.ObjectProperties.CommonAttributeAutoUse.Use) Then
				NewRow = New Structure();
				NewRow.Insert("Name", CommonAttribute.Name);
				NewRow.Insert("FullName", MetadataObject.FullName());
				NewRow.Insert("Synonym", ?(ValueIsFilled(CommonAttribute.Synonym), CommonAttribute.Synonym, CommonAttribute.Name));
				NewRow.Insert("KindOfAttribute", Enums.KindsOfAttributes.Common);
				NewRow.Insert("TypeRestriction", CommonAttribute.Type);
				NewRow.Insert("SettingID", New UUID());
				NewRow.Insert("PictureIndex", 4);
				NewRow.Insert("Metadata", CommonAttribute);
				If FilterIsOk(NewRow) 
					Or SettingsFromRegister.FindRows(New Structure("MetadataObject, AttributeName", NewRow.FullName, NewRow.Name)).Count() <> 0 Then
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
Function GetAdditionalAttributes(MetadataObject, RowOwner, TableOfSettings, ExistPredefinedDataNames, SettingsFromRegister)
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
		If FilterIsOk(NewRow) 
			Or SettingsFromRegister.FindRows(New Structure("MetadataObject, AttributeName", NewRow.FullName, NewRow.Name)).Count() <> 0 Then
			RowOwner.Rows.Add(NewRow);
		EndIf;
		
		// TableOfSettings
		AddRowToTableOfSettings(TableOfSettings, MetadataObject.FullName(), NewRow.Name, NewRow.SettingID);
	EndDo;
	Return RowOwner.Rows.Count() > 0;
EndFunction

&AtServer
Function GetTabularSections(MetadataObject, RowOwner, TableOfSettings, SettingsFromRegister)
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
			If FilterIsOk(NewRow) 
				Or SettingsFromRegister.FindRows(New Structure("MetadataObject, AttributeName", NewRow.FullName, NewRow.Name)).Count() <> 0 Then
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
Function GetCustomAttributes(MetadataObject, RowOwner, TableOfSettings, SettingsFromRegister)
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
		If FilterIsOk(NewRow) 
			Or SettingsFromRegister.FindRows(New Structure("MetadataObject, AttributeName", NewRow.FullName, NewRow.Name)).Count() <> 0 Then
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

&AtServer
Function GetAdditionalSettings(RowOwner, TableOfSettings)	
	// Additional settings for Point of sale
	FullName = "DataProcessor.PointOfSale.AdditionalSettings";
	
	NewRow_PointOfSales = New Structure();
	NewRow_PointOfSales.Insert("FullName"     , FullName);
	NewRow_PointOfSales.Insert("Name"         , "PointOfSale");
	NewRow_PointOfSales.Insert("Synonym"      , R().Add_Setiings_002);
	NewRow_PointOfSales.Insert("PictureIndex" , 11);
	NewRow_PointOfSales.Insert("Rows"         , New Array());
	
	// change price
	NewSetting = New Structure();
	NewSetting.Insert("Name", "DisableChangePrice");
	NewSetting.Insert("FullName", FullName + ".DisableChangePrice");
	NewSetting.Insert("Synonym" , R().Add_Setiings_003);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_PointOfSales.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	// change price type
	NewSetting = New Structure();
	NewSetting.Insert("Name", "EnableChangePriceType");
	NewSetting.Insert("FullName", FullName + ".EnableChangePriceType");
	NewSetting.Insert("Synonym" , R().Add_Setiings_012);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_PointOfSales.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	// create return
	NewSetting = New Structure();
	NewSetting.Insert("Name", "DisableCreateReturn");
	NewSetting.Insert("FullName", FullName + ".DisableCreateReturn");
	NewSetting.Insert("Synonym" , R().Add_Setiings_004);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_PointOfSales.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	RowOwner.Rows.Add(NewRow_PointOfSales);
	
	// Additional settings for Attached files to documents control
	FullName = "DataProcessor.AttachedFilesToDocumentsControl.AdditionalSettings";
		
	NewRow_AttachedFilesToDocumentsControl = New Structure();
	NewRow_AttachedFilesToDocumentsControl.Insert("FullName"     , FullName);
	NewRow_AttachedFilesToDocumentsControl.Insert("Name"         , "AttachedFilesToDocumentsControl");
	NewRow_AttachedFilesToDocumentsControl.Insert("Synonym"      , R().Add_Settings_013);
	NewRow_AttachedFilesToDocumentsControl.Insert("PictureIndex" , 11);
	NewRow_AttachedFilesToDocumentsControl.Insert("Rows"         , New Array());
	
	// change filters
	NewSetting = New Structure();
	NewSetting.Insert("Name", "EnableChangeFilters");
	NewSetting.Insert("FullName", FullName + ".EnableChangeFilters");
	NewSetting.Insert("Synonym" , R().Add_Settings_014);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_AttachedFilesToDocumentsControl.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	// check mode
	NewSetting = New Structure();
	NewSetting.Insert("Name", "EnableCheckMode");
	NewSetting.Insert("FullName", FullName + ".EnableCheckMode");
	NewSetting.Insert("Synonym" , R().Add_Settings_015);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_AttachedFilesToDocumentsControl.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	//Company
	NewSetting = New Structure();
	NewSetting.Insert("Name", "Company");
	NewSetting.Insert("FullName", FullName + ".Company");
	NewSetting.Insert("Synonym" , R().Add_Settings_016);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("CatalogRef.Companies"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 3);
	NewRow_AttachedFilesToDocumentsControl.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	//Branch
	NewSetting = New Structure();
	NewSetting.Insert("Name", "Branch");
	NewSetting.Insert("FullName", FullName + ".Branch");
	NewSetting.Insert("Synonym" , R().Add_Settings_017);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("CatalogRef.BusinessUnits"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 3);
	NewRow_AttachedFilesToDocumentsControl.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	RowOwner.Rows.Add(NewRow_AttachedFilesToDocumentsControl);
	//
	
	// Additional settings for all documents
	FullName = "Documents.AllDocuments.AdditionalSettings";
	
	NewRow_Documents = New Structure();
	NewRow_Documents.Insert("FullName"     , FullName);
	NewRow_Documents.Insert("Name"         , "Documents");
	NewRow_Documents.Insert("Synonym"      , R().Add_Setiings_005);
	NewRow_Documents.Insert("PictureIndex" , 1);
	NewRow_Documents.Insert("Rows"         , New Array());
	
	// change author
	NewSetting = New Structure();
	NewSetting.Insert("Name", "DisableChangeAuthor");
	NewSetting.Insert("FullName", FullName + ".DisableChangeAuthor");
	NewSetting.Insert("Synonym" , R().Add_Setiings_006);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_Documents.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	RowOwner.Rows.Add(NewRow_Documents);
	
	// Link \ Unlink document rows
	FullName = "Documents.LinkUnlinkDocumentRows.Settings";
	
	NewRow_Documents = New Structure();
	NewRow_Documents.Insert("FullName"     , FullName);
	NewRow_Documents.Insert("Name"         , "LinkUnlinkDocumentRows");
	NewRow_Documents.Insert("Synonym"      , R().Add_Setiings_007);
	NewRow_Documents.Insert("PictureIndex" , 1);
	NewRow_Documents.Insert("Rows"         , New Array());
	
	// Calculate rows on link rows
	NewSetting = New Structure();
	NewSetting.Insert("Name", "DisableCalculateRowsOnLinkRows");
	NewSetting.Insert("FullName", FullName + ".DisableCalculateRowsOnLinkRows");
	NewSetting.Insert("Synonym" , R().Add_Setiings_008);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_Documents.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	// Use reverse basises tree on link rows
	NewSetting = New Structure();
	NewSetting.Insert("Name", "UseReverseBasisesTree");
	NewSetting.Insert("FullName", FullName + ".UseReverseBasisesTree");
	NewSetting.Insert("Synonym" , R().Add_Setiings_009);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_Documents.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	RowOwner.Rows.Add(NewRow_Documents);
	
	// Linked documents
	FullName = "Documents.LinkedDocuments.Settings";
	
	NewRow_Documents = New Structure();
	NewRow_Documents.Insert("FullName"     , FullName);
	NewRow_Documents.Insert("Name"         , "LinkedDocuments");
	NewRow_Documents.Insert("Synonym"      , R().Add_Setiings_010);
	NewRow_Documents.Insert("PictureIndex" , 1);
	NewRow_Documents.Insert("Rows"         , New Array());
	
	// Use reverse tree
	NewSetting = New Structure();
	NewSetting.Insert("Name", "UseReverseTree");
	NewSetting.Insert("FullName", FullName + ".UseReverseTree");
	NewSetting.Insert("Synonym" , R().Add_Setiings_011);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 12);
	NewRow_Documents.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	RowOwner.Rows.Add(NewRow_Documents);
	
	//All Catalogs
	FullName = "Catalogs.AllCatalogs.AdditionalSettings";
	
	NewRow_Catalogs = New Structure();
	NewRow_Catalogs.Insert("FullName"     , FullName);
	NewRow_Catalogs.Insert("Name"         , "Catalogs");
	NewRow_Catalogs.Insert("Synonym"      , R().Add_Settings_018);
	NewRow_Catalogs.Insert("PictureIndex" , 1);
	NewRow_Catalogs.Insert("Rows"         , New Array());
	
	// DontHelpToCreatePartnerDetails
	NewSetting = New Structure();
	NewSetting.Insert("Name", "DontHelpToCreatePartnerDetails");
	NewSetting.Insert("FullName", FullName + ".DontHelpToCreatePartnerDetails");
	NewSetting.Insert("Synonym" , R().Add_Settings_019);
	NewSetting.Insert("KindOfAttribute", Enums.KindsOfAttributes.AdditionalSetting);
	NewSetting.Insert("TypeRestriction", New TypeDescription("Boolean"));
	NewSetting.Insert("SettingID"      , New UUID());
	NewSetting.Insert("PictureIndex"   , 1);
	NewRow_Catalogs.Rows.Add(NewSetting);
	AddRowToTableOfSettings(TableOfSettings, NewSetting.FullName, NewSetting.Name, NewSetting.SettingID);
	
	RowOwner.Rows.Add(NewRow_Catalogs);

	Return True;
EndFunction

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

&AtClient
Procedure CollapseTreeRows(Row)
	ChildRows = Row.GetItems();
	For Each ChildRow In ChildRows Do
		CollapseTreeRows(ChildRow);
		Items.MetadataTree.Collapse(ChildRow.GetID());
	EndDo;
EndProcedure

&AtClient
Procedure MetadataTreeUseOnChange(Item)
	CurrentRow = Items.MetadataTree.CurrentData;
	If CurrentRow.Use And CurrentRow.Value = Undefined 
			And CurrentRow.TypeRestriction.ContainsType(Type("Boolean")) 
			And CurrentRow.TypeRestriction.Types().Count() = 1 Then
		CurrentRow.Value = True;
	EndIf;
EndProcedure
