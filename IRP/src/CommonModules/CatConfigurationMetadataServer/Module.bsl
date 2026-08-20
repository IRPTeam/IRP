#Region Public

Function CheckDescriptionDuplicateEnabled(Object) Export
	If Not Saas.isAreaActive() Then
		Return False;
	EndIf;

	MetadataFullName = Object.Metadata().FullName();
	Query = New Query();
	Query.Text = "SELECT ALLOWED TOP 1
				 |	ConfigurationMetadata.CheckDescriptionDuplicate
				 |FROM
				 |	Catalog.ConfigurationMetadata AS ConfigurationMetadata
				 |WHERE
				 |	ConfigurationMetadata.ObjectFullName = &ObjectFullName";
	Query.SetParameter("ObjectFullName", MetadataFullName);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return False;
	Else
		QuerySelect = QueryExecution.Select();
		QuerySelect.Next();
		Return QuerySelect.CheckDescriptionDuplicate;
	EndIf;
EndFunction

Function CheckDescriptionFillingEnabled(Object) Export
	If Not Saas.isAreaActive() Then
		Return False;
	EndIf;
	MetadataFullName = Object.Metadata().FullName();
	Query = New Query();
	Query.Text = "SELECT ALLOWED TOP 1
				 |	ConfigurationMetadata.CheckDescriptionFilling
				 |FROM
				 |	Catalog.ConfigurationMetadata AS ConfigurationMetadata
				 |WHERE
				 |	ConfigurationMetadata.ObjectFullName = &ObjectFullName";
	Query.SetParameter("ObjectFullName", MetadataFullName);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return False;
	Else
		QuerySelect = QueryExecution.Select();
		QuerySelect.Next();
		Return QuerySelect.CheckDescriptionFilling;
	EndIf;
EndFunction

Procedure RefillMetadata() Export
	RefillCatalogs();
	RefillDocuments();
EndProcedure

// Get configuration metadata item by object.
// 
// Parameters:
//  Object - CatalogObjectCatalogName, DocumentObjectDocumentName - Object
// 
// Returns:
//  CatalogRef.ConfigurationMetadata
Function GetConfigurationMetadataItemByObject(Object) Export
	Return GetConfigurationMetadataItemByFullName(Object.Ref.Metadata().FullName());
EndFunction

Function GetConfigurationMetadataItemByFullName(ObjectFullName) Export
	ReturnValue = Undefined;
	Query = New Query();
	Query.Text = "SELECT
				 |	ConfigurationMetadata.Ref
				 |FROM
				 |	Catalog.ConfigurationMetadata AS ConfigurationMetadata
				 |WHERE
				 |	ConfigurationMetadata.ObjectFullName = &ObjectFullName
				 |	AND NOT ConfigurationMetadata.DeletionMark
				 |	AND NOT ConfigurationMetadata.Unused";
	Query.SetParameter("ObjectFullName", ObjectFullName);
	QueryExecution = Query.Execute();
	If Not QueryExecution.IsEmpty() Then
		QuerySelection = QueryExecution.Select();
		QuerySelection.Next();
		ReturnValue = QuerySelection.Ref;
	EndIf;
	Return ReturnValue;
EndFunction

// Get metadata by configuration metadata.
// 
// Parameters:
//  Ref - CatalogRef.ConfigurationMetadata - Ref
// 
// Returns:
//  MetadataObject
Function GetMetadataByConfigurationMetadata(Ref) Export

	Return Metadata.FindByFullName(Ref.ObjectFullName);
	
EndFunction

// Get attribute names by object.
// 
// Parameters:
//  Object - DocumentObject, CatalogObject - Object
// 
// Returns:
//  Structure - Get attribute names by object:
// * Attributes - Map :
// ** Key - String - name of attribute
// ** Value - String - synonym of attribute
// * Tables - Map :
// ** Key - String - name of table
// ** Value - Structure :
// *** Synonym - String - synonym of table
// *** Attributes - Map :
// **** Key - String - name of attribute
// **** Value - String - synonym of attribute
Function GetAttributeNamesByObject(Object) Export
	
	Result = New Structure;
	Result.Insert("Attributes", New Map);
	Result.Insert("Tables", New Map);
	
	MetaObject = Object.Ref.Metadata();
	
	For Each AttributItem In Metadata.CommonAttributes Do
		If Not CommonFunctionsServer.isCommonAttributeUseForMetadata(AttributItem.Name, MetaObject) Then
			Continue;
		EndIf;
		Result.Attributes.Insert(AttributItem.Name, AttributItem.Synonym);
	EndDo;
	For Each AttributItem In MetaObject.Attributes Do
		Result.Attributes.Insert(AttributItem.Name, AttributItem.Synonym);
	EndDo;
	
	For Each TabularItem In MetaObject.TabularSections Do
		TableStructure = New Structure;
		TableStructure.Insert("Synonym", TabularItem.Synonym);
		TableStructure.Insert("Attributes", New Map);
		For Each AttributItem In TabularItem.Attributes Do
			TableStructure.Attributes.Insert(AttributItem.Name, AttributItem.Synonym);
		EndDo;
		Result.Tables.Insert(TabularItem.Name, TableStructure);
	EndDo;
	
	Return Result;
	
EndFunction

// Get customized attributes by object.
// 
// Parameters:
//  Object - CatalogObjectCatalogName, DocumentObjectDocumentName - Object
// 
// Returns:
//  See GetCustomizedAttributesByMetadataRef
Function GetCustomizedAttributesByObject(Object) Export
	
	MetadataRef = CatConfigurationMetadataServer.GetConfigurationMetadataItemByObject(Object);
	Return GetCustomizedAttributesByMetadataRef(MetadataRef);
	
EndFunction

// Get customized attributes by metadata ref.
// 
// Parameters:
//  MetadataRef - CatalogRef.ConfigurationMetadata - Metadata ref
// 
// Returns:
// 	Structure - Get customized attributes by metadata ref: 
//  * Important - Map - important attributes :
//		** Key - String - Table name
//		** Value - Array of String - Attributes name
//  * NotAudit - Map - not audit attributes :
//		** Key - String - Table name
//		** Value - Array of String - Attributes name
//  * ReadOnly - Map - read only attributes :
//		** Key - String - Table name
//		** Value - Array of String - Attributes name
//  * Hidden - Map - hidden attributes :
//		** Key - String - Table name
//		** Value - Array of String - Attributes name
Function GetCustomizedAttributesByMetadataRef(MetadataRef) Export
	
	Result = New Structure(
		"Important,	NotAudit,	ReadOnly,	Hidden", 
		New Map,	New Map,	New Map,	New Map);
	
	Query = New Query;
	Query.SetParameter("MetadataRef", MetadataRef);
	
	Query.Text =
	"SELECT
	|	Attributes.TabularName AS TabularName,
	|	Attributes.AttributeName AS AttributeName
	|FROM
	|	Catalog.ConfigurationMetadata.ImportantAttributes AS Attributes
	|WHERE
	|	Attributes.Ref = &MetadataRef
	|TOTALS
	|BY
	|	TabularName
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Attributes.TabularName AS TabularName,
	|	Attributes.AttributeName AS AttributeName
	|FROM
	|	Catalog.ConfigurationMetadata.NotAuditAttributes AS Attributes
	|WHERE
	|	Attributes.Ref = &MetadataRef
	|TOTALS
	|BY
	|	TabularName
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Attributes.TabularName AS TabularName,
	|	Attributes.AttributeName AS AttributeName
	|FROM
	|	Catalog.ConfigurationMetadata.ReadOnlyAttributes AS Attributes
	|WHERE
	|	Attributes.Ref = &MetadataRef
	|TOTALS
	|BY
	|	TabularName
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Attributes.TabularName AS TabularName,
	|	Attributes.AttributeName AS AttributeName
	|FROM
	|	Catalog.ConfigurationMetadata.HiddenAttributes AS Attributes
	|WHERE
	|	Attributes.Ref = &MetadataRef
	|TOTALS
	|BY
	|	TabularName";
	
	QueryResults = Query.ExecuteBatch();
	
	SelectionTabular = QueryResults[0].Select(QueryResultIteration.ByGroups);
	While SelectionTabular.Next() Do
		Attributes = New Array; // Array of String
		SelectionDetail = SelectionTabular.Select();
		While SelectionDetail.Next() Do
			Attributes.Add(SelectionDetail.AttributeName);
		EndDo;
		Result.Important.Insert(SelectionTabular.TabularName, Attributes);
	EndDo;
	
	SelectionTabular = QueryResults[1].Select(QueryResultIteration.ByGroups);
	While SelectionTabular.Next() Do
		Attributes = New Array; // Array of String
		SelectionDetail = SelectionTabular.Select();
		While SelectionDetail.Next() Do
			Attributes.Add(SelectionDetail.AttributeName);
		EndDo;
		Result.NotAudit.Insert(SelectionTabular.TabularName, Attributes);
	EndDo;
	
	SelectionTabular = QueryResults[2].Select(QueryResultIteration.ByGroups);
	While SelectionTabular.Next() Do
		Attributes = New Array; // Array of String
		SelectionDetail = SelectionTabular.Select();
		While SelectionDetail.Next() Do
			Attributes.Add(SelectionDetail.AttributeName);
		EndDo;
		Result.ReadOnly.Insert(SelectionTabular.TabularName, Attributes);
	EndDo;
	
	SelectionTabular = QueryResults[3].Select(QueryResultIteration.ByGroups);
	While SelectionTabular.Next() Do
		Attributes = New Array; // Array of String
		SelectionDetail = SelectionTabular.Select();
		While SelectionDetail.Next() Do
			Attributes.Add(SelectionDetail.AttributeName);
		EndDo;
		Result.Hidden.Insert(SelectionTabular.TabularName, Attributes);
	EndDo;
	
	Return Result;
	
EndFunction

// Get metadata customized attributes for user.
// 
// Parameters:
//  MetadataRef - CatalogRef.ConfigurationMetadata - Metadata ref
//  User - CatalogRef.Users - User
// 
// Returns:
//  See GetCustomizedAttributesByMetadataRef
Function GetMetadataCustomizedAttributesForUser(MetadataRef, User) Export
	
	SetPrivilegedMode(True);
	
	CustomizedAttributes = GetCustomizedAttributesByMetadataRef(MetadataRef);
	If CustomizedAttributes.ReadOnly.Count() = 0 And CustomizedAttributes.Hidden.Count() = 0 Then
		Return CustomizedAttributes;
	EndIf;
	
	Query = New Query;
	Query.SetParameter("User", User);
	Query.SetParameter("MetadataRef", MetadataRef);
	Query.Text =
	"SELECT
	|	AccessGroupsUsers.Ref AS Ref
	|INTO tmpGrops
	|FROM
	|	Catalog.AccessGroups.Users AS AccessGroupsUsers
	|WHERE
	|	AccessGroupsUsers.User = &User
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AccessGroupsProfiles.Profile AS Profile
	|INTO tmpProfiles
	|FROM
	|	Catalog.AccessGroups.Profiles AS AccessGroupsProfiles
	|		INNER JOIN tmpGrops AS tmpGrops
	|		ON AccessGroupsProfiles.Ref = tmpGrops.Ref
	|WHERE
	|	NOT AccessGroupsProfiles.Ref.DeletionMark
	|	AND NOT AccessGroupsProfiles.Profile.DeletionMark
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	AccessProfilesAccessToEditAttributes.TabularName AS TabularName,
	|	AccessProfilesAccessToEditAttributes.AttributeName AS AttributeName
	|FROM
	|	Catalog.AccessProfiles.AccessToEditAttributes AS AccessProfilesAccessToEditAttributes
	|		INNER JOIN tmpProfiles AS tmpProfiles
	|		ON AccessProfilesAccessToEditAttributes.Ref = tmpProfiles.Profile
	|WHERE
	|	AccessProfilesAccessToEditAttributes.MetadataRef = &MetadataRef
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	AccessProfilesAccessToViewAttributes.TabularName AS TabularName,
	|	AccessProfilesAccessToViewAttributes.AttributeName AS AttributeName
	|FROM
	|	Catalog.AccessProfiles.AccessToViewAttributes AS AccessProfilesAccessToViewAttributes
	|		INNER JOIN tmpProfiles AS tmpProfiles
	|		ON AccessProfilesAccessToViewAttributes.Ref = tmpProfiles.Profile
	|WHERE
	|	AccessProfilesAccessToViewAttributes.MetadataRef = &MetadataRef";
	QueryResults = Query.ExecuteBatch();
	
	AccessToEditAttributes = QueryResults[2].Select();
	While AccessToEditAttributes.Next() Do
		If CustomizedAttributes.ReadOnly.Get(AccessToEditAttributes.TabularName) = Undefined Then
			Continue;
		EndIf;
		TabularArray = CustomizedAttributes.ReadOnly[AccessToEditAttributes.TabularName]; // Array
		AttributeIndex = TabularArray.Find(AccessToEditAttributes.AttributeName);
		If AttributeIndex <> Undefined Then
			TabularArray.Delete(AttributeIndex);
			If TabularArray.Count() = 0 Then
				CustomizedAttributes.ReadOnly.Delete(AccessToEditAttributes.TabularName);
			EndIf;
		EndIf;
	EndDo;
	
	AccessToViewAttributes = QueryResults[3].Select();
	While AccessToViewAttributes.Next() Do
		If CustomizedAttributes.Hidden.Get(AccessToViewAttributes.TabularName) = Undefined Then
			Continue;
		EndIf;
		TabularArray = CustomizedAttributes.Hidden[AccessToViewAttributes.TabularName]; // Array
		AttributeIndex = TabularArray.Find(AccessToViewAttributes.AttributeName);
		If AttributeIndex <> Undefined Then
			TabularArray.Delete(AttributeIndex);
			If TabularArray.Count() = 0 Then
				CustomizedAttributes.Hidden.Delete(AccessToViewAttributes.TabularName);
			EndIf;
		EndIf;
	EndDo;
	
	Return CustomizedAttributes;
	
EndFunction

// Apply customized attributes to form.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  ObjectFullName - String - Object full name
Procedure ApplyCustomizedAttributesToForm(Form, ObjectFullName) Export
	
	MetadataRef = GetConfigurationMetadataItemByFullName(ObjectFullName);
	CustomizedAttributes = GetMetadataCustomizedAttributesForUser(MetadataRef, SessionParameters.CurrentUser);
	
	If CustomizedAttributes.ReadOnly.Count() = 0 And CustomizedAttributes.Hidden.Count() = 0 Then
		Return;
	EndIf;
	
	ReadOnlyArray = New Array; // Array of String
	For Each AttributeGroup In CustomizedAttributes.ReadOnly Do
		FormGroupName = "Object" + ?(AttributeGroup.Key = "", "", "." + AttributeGroup.Key);
		For Each AttributeName In AttributeGroup.Value Do
			ReadOnlyArray.Add(FormGroupName + "." + AttributeName); 
		EndDo;
	EndDo;
	
	HiddenArray = New Array; // Array of String
	For Each AttributeGroup In CustomizedAttributes.Hidden Do
		FormGroupName = "Object" + ?(AttributeGroup.Key = "", "", "." + AttributeGroup.Key);
		For Each AttributeName In AttributeGroup.Value Do
			HiddenArray.Add(FormGroupName + "." + AttributeName); 
		EndDo;
	EndDo;
	
	For Each FormItem In Form.Items Do
		If TypeOf(FormItem) = Type("FormGroup") 
				OR TypeOf(FormItem) = Type("FormDecoration")
				OR TypeOf(FormItem) = Type("FormItemAddition")
				OR TypeOf(FormItem) = Type("FormButton") Then
			Continue;
		EndIf;
		Try
			ItemDataPath = FormItem.DataPath;
		Except
			Continue;
		EndTry;
		If ReadOnlyArray.Find(ItemDataPath) <> Undefined Then
			FormItem.ReadOnly = True;
		EndIf;
		If HiddenArray.Find(ItemDataPath) <> Undefined Then
			FormItem.Visible = False;
		EndIf;
	EndDo;
	
EndProcedure

// Check attribute exists.
// 
// Parameters:
//  MetadataRef - CatalogRef.ConfigurationMetadata - Metadata ref
//  AttributeName - String - Attribute name
// 
// Returns:
//  Boolean - Check attribute exists
Function CheckAttributeExists(MetadataRef, AttributeName) Export
	
	Try 
		MetaObject = Metadata.FindByFullName(MetadataRef.ObjectFullName); // MetadataObjectCatalog,  MetadataObjectDocument
	Except
		Return False;
	EndTry;
	If TypeOf(MetaObject) <> Type("MetadataObject") Then
		Return False;
	EndIf;
	
	For Each AttributItem In Metadata.CommonAttributes Do
		If Not CommonFunctionsServer.isCommonAttributeUseForMetadata(AttributItem.Name, MetaObject) Then
			Continue;
		EndIf;
		If Not CommonFunctionsServer.isMetadataAvailableByCurrentFunctionalOptions(AttributItem, True) Then
			Continue;
		EndIf;
		
		If AttributItem.Name = AttributeName Then
			Return True;
		EndIf;
	EndDo;
	
	For Each AttributItem In MetaObject.Attributes Do
		If Not CommonFunctionsServer.isMetadataAvailableByCurrentFunctionalOptions(AttributItem, True) Then
			Continue;
		EndIf;
		
		If AttributItem.Name = AttributeName Then
			Return True;
		EndIf;
	EndDo;
	
	Return False;
EndFunction

#EndRegion

#Region Private

Procedure RefillCatalogs()
	MetadataObjectNames = New ValueTable();
	MetadataObjectNames.Columns.Add("ObjectName", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullName", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullSynonym", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
		
	For Each MetadataObject In Metadata.Catalogs Do
		NewRow = MetadataObjectNames.Add();
		NewRow.ObjectName = MetadataObject.Name;
		NewRow.ObjectFullName = MetadataObject.FullName();
		NewRow.ObjectFullSynonym = MetadataObject.Synonym;
	EndDo;
	ProcessRefill(MetadataObjectNames, Catalogs.ConfigurationMetadata.Catalogs);
EndProcedure

Procedure RefillDocuments()
	MetadataObjectNames = New ValueTable();
	MetadataObjectNames.Columns.Add("ObjectName", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullName",
		Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullSynonym",
		Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
	For Each MetadataObject In Metadata.Documents Do
		NewRow = MetadataObjectNames.Add();
		NewRow.ObjectName = MetadataObject.Name;
		NewRow.ObjectFullName = MetadataObject.FullName();
		NewRow.ObjectFullSynonym = MetadataObject.Synonym;
	EndDo;
	ProcessRefill(MetadataObjectNames, Catalogs.ConfigurationMetadata.Documents);
EndProcedure

Procedure ProcessRefill(MetadataObjectNames, Parent)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	MetadataObjectNames.ObjectName AS ObjectName,
	|	MetadataObjectNames.ObjectFullName AS ObjectFullName,
	|	MetadataObjectNames.ObjectFullSynonym AS ObjectFullSynonym
	|INTO MetadataObjectNames
	|FROM
	|	&MetadataObjectNames AS MetadataObjectNames
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ConfigurationMetadata.Ref AS Ref
	|FROM
	|	Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|		LEFT JOIN MetadataObjectNames AS MetadataObjectNames
	|		ON ConfigurationMetadata.ObjectFullName = MetadataObjectNames.ObjectFullName
	|WHERE
	|	NOT ConfigurationMetadata.Unused
	|	AND ConfigurationMetadata.Parent = &Parent
	|	AND MetadataObjectNames.ObjectFullName IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MetadataObjectNames.ObjectName AS ObjectName,
	|	MetadataObjectNames.ObjectFullName AS ObjectFullName,
	|	MetadataObjectNames.ObjectFullSynonym AS ObjectFullSynonym,
	|	ISNULL(ConfigurationMetadata.Ref, VALUE(Catalog.ConfigurationMetadata.EmptyRef)) AS Ref,
	|	ISNULL(ConfigurationMetadata.Unused, FALSE) AS Unused
	|FROM
	|	MetadataObjectNames AS MetadataObjectNames
	|		LEFT JOIN Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|		ON MetadataObjectNames.ObjectFullName = ConfigurationMetadata.ObjectFullName
	|		AND ConfigurationMetadata.Parent = &Parent
	|WHERE
	|	ConfigurationMetadata.Ref IS NULL
	|	OR ISNULL(ConfigurationMetadata.Unused, FALSE)";
	
	Query.SetParameter("Parent", Parent);
	Query.SetParameter("MetadataObjectNames", MetadataObjectNames);
	QueryResults = Query.ExecuteBatch();

	ItemsForMarkingAsUnused = QueryResults[1].Unload();
	For Each Item In ItemsForMarkingAsUnused Do
		ItemObject = Item.Ref.GetObject();
		ItemObject.Unused = True;
		ItemObject.Write();
	EndDo;

	ItemsForCreate = QueryResults[2].Unload();
	For Each Item In ItemsForCreate Do
		If Item.Ref.IsEmpty() Then
			ItemObject = Catalogs.ConfigurationMetadata.CreateItem();
			ItemObject.Parent = Parent;
			ItemObject.ObjectName = Item.ObjectName;
			ItemObject.ObjectFullName = Item.ObjectFullName;
			ItemObject.Description = Item.ObjectFullSynonym;
			ItemObject.Write();
		ElsIf Item.Unused = True Then
			ItemObject = Item.Ref.GetObject();
			ItemObject.Unused = False;
			ItemObject.Write();
		EndIf;
	EndDo;
EndProcedure

#EndRegion