
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	UpdateRolesAtServer();
	UpdateAttributesAtServer();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	For Each TreeItem In AccessToEditAttributesTree.GetItems() Do
		Items.AccessToEditAttributesTree.Expand(TreeItem.GetID(), True);
	EndDo;
	For Each TreeItem In AccessToViewAttributesTree.GetItems() Do
		Items.AccessToViewAttributesTree.Expand(TreeItem.GetID(), True);
	EndDo;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	If CurrentObject.AdditionalProperties.Property("UsersEventOnWriteResult") Then
		For Each Row In CurrentObject.AdditionalProperties.UsersEventOnWriteResult.ArrayOfResults Do
			CommonFunctionsClientServer.ShowUsersMessage(Row.Message);
		EndDo;
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.Roles.Load(ThisObject.Roles.Unload(New Structure("Use", True)));
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	
	CurrentObject.AccessToEditAttributes.Clear();
	For Each Row In AccessToEditAttributesTree.GetItems() Do
		SaveAccessDataToTabularSection(CurrentObject.AccessToEditAttributes, Row);
	EndDo;
	
	CurrentObject.AccessToViewAttributes.Clear();
	For Each Row In AccessToViewAttributesTree.GetItems() Do
		SaveAccessDataToTabularSection(CurrentObject.AccessToViewAttributes, Row);
	EndDo;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure UpdateRoles(Command)
	UpdateRolesAtServer();
EndProcedure

&AtClient
Procedure SelectAllToEdit(Command)
	For Each SubRow In AccessToEditAttributesTree.GetItems() Do
		SetMarkForAll(SubRow, True)
	EndDo;
EndProcedure

&AtClient
Procedure SelectAllToView(Command)
	For Each SubRow In AccessToViewAttributesTree.GetItems() Do
		SetMarkForAll(SubRow, True)
	EndDo;
EndProcedure

&AtClient
Procedure UnselectAllToEdit(Command)
	For Each SubRow In AccessToEditAttributesTree.GetItems() Do
		SetMarkForAll(SubRow, False)
	EndDo;
EndProcedure

&AtClient
Procedure UnselectAllToView(Command)
	For Each SubRow In AccessToViewAttributesTree.GetItems() Do
		SetMarkForAll(SubRow, False)
	EndDo;
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

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure UpdateRolesAtServer()
	For Each Role In Metadata.Roles Do
		If Role = Metadata.Roles.FilterForUserSettings Then
			Continue;
		EndIf;

		If Saas.isSaasMode() And Role = Metadata.Roles.FullAccess Then
			Continue;
		EndIf;

		ExtRole = Role.ConfigurationExtension();
		NameExt = ?(ExtRole = Undefined, "IRP", ExtRole.Name);

		If ThisObject.Roles.FindRows(New Structure("Role, Configuration", Role.Name, NameExt)).Count() Then
			Continue;
		EndIf;

		StrRole = Roles.Add();
		StrRole.Role = Role.Name;
		StrRole.Presentation = Role.Presentation();

		StrRole.Configuration = NameExt;

		Filter = New Structure("Role, Configuration", StrRole.Role, StrRole.Configuration);
		StrRole.Use = Object.Roles.FindRows(Filter).Count() > 0;
	EndDo;
EndProcedure

&AtServer
Procedure UpdateAttributesAtServer()
	
	AccessToEditAttributesTree.GetItems().Clear();
	AccessToViewAttributesTree.GetItems().Clear();
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ReadOnlyAttributes.Ref AS MetadataRef,
	|	ReadOnlyAttributes.Ref.Parent AS MetadataGroup,
	|	ReadOnlyAttributes.TabularName AS TabularName,
	|	ReadOnlyAttributes.AttributeName AS AttributeName,
	|	CASE
	|		WHEN CanEditAttributes.MetadataRef IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS Mark
	|FROM
	|	Catalog.ConfigurationMetadata.ReadOnlyAttributes AS ReadOnlyAttributes
	|		LEFT JOIN (SELECT
	|			AccessProfilesAccessToEditAttributes.MetadataRef AS MetadataRef,
	|			AccessProfilesAccessToEditAttributes.TabularName AS TabularName,
	|			AccessProfilesAccessToEditAttributes.AttributeName AS AttributeName
	|		FROM
	|			Catalog.AccessProfiles.AccessToEditAttributes AS AccessProfilesAccessToEditAttributes
	|		WHERE
	|			AccessProfilesAccessToEditAttributes.Ref = &Ref) AS CanEditAttributes
	|		ON CanEditAttributes.MetadataRef = ReadOnlyAttributes.Ref
	|		AND CanEditAttributes.TabularName = ReadOnlyAttributes.TabularName
	|		AND CanEditAttributes.AttributeName = ReadOnlyAttributes.AttributeName
	|TOTALS
	|BY
	|	MetadataGroup,
	|	MetadataRef,
	|	TabularName
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	HiddenAttributes.Ref AS MetadataRef,
	|	HiddenAttributes.Ref.Parent AS MetadataGroup,
	|	HiddenAttributes.TabularName AS TabularName,
	|	HiddenAttributes.AttributeName AS AttributeName,
	|	CASE
	|		WHEN CanViewAttributes.MetadataRef IS NULL
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS Mark
	|FROM
	|	Catalog.ConfigurationMetadata.HiddenAttributes AS HiddenAttributes
	|		LEFT JOIN (SELECT
	|			AccessProfilesAccessToViewAttributes.MetadataRef AS MetadataRef,
	|			AccessProfilesAccessToViewAttributes.TabularName AS TabularName,
	|			AccessProfilesAccessToViewAttributes.AttributeName AS AttributeName
	|		FROM
	|			Catalog.AccessProfiles.AccessToViewAttributes AS AccessProfilesAccessToViewAttributes
	|		WHERE
	|			AccessProfilesAccessToViewAttributes.Ref = &Ref) AS CanViewAttributes
	|		ON CanViewAttributes.MetadataRef = HiddenAttributes.Ref
	|		AND CanViewAttributes.TabularName = HiddenAttributes.TabularName
	|		AND CanViewAttributes.AttributeName = HiddenAttributes.AttributeName
	|TOTALS
	|BY
	|	MetadataGroup,
	|	MetadataRef,
	|	TabularName";
	
	Query.SetParameter("Ref", Object.Ref);
	QueryResults = Query.ExecuteBatch();
	
	ToEditAttributesGroups = QueryResults[0].Select(QueryResultIteration.ByGroups);
	While ToEditAttributesGroups.Next() Do
		GroupBranch = AccessToEditAttributesTree.GetItems().Add();
		GroupBranch.Description = ToEditAttributesGroups.MetadataGroup;
		
		ToEditAttributesMetadatas = ToEditAttributesGroups.Select(QueryResultIteration.ByGroups);
		While ToEditAttributesMetadatas.Next() Do
			MetadataRef = ToEditAttributesMetadatas.MetadataRef;
			
			MetadataBranch = GroupBranch.GetItems().Add();
			MetadataBranch.Description = String(MetadataRef);
			
			Try
				MetaObject = Metadata.FindByFullName(MetadataRef.ObjectFullName); // MetadataObjectCatalog,  MetadataObjectDocument
			Except
				Continue;
			EndTry;
			
			ToEditAttributesTables = ToEditAttributesMetadatas.Select(QueryResultIteration.ByGroups);
			While ToEditAttributesTables.Next() Do
				isTable = ValueIsFilled(ToEditAttributesTables.TabularName);
				
				If isTable Then
					TableBranch = MetadataBranch.GetItems().Add();
					TableBranch.TabularName = ToEditAttributesTables.TabularName;
					Try
						TableBranch.Description = MetaObject.TabularSections[ToEditAttributesTables.TabularName].Synonym;
					Except
						Continue;
					EndTry;
				EndIf;
				
				ToEditAttributes = ToEditAttributesTables.Select();
				While ToEditAttributes.Next() Do
					Try
						If isTable Then
							AttributeBranch = TableBranch.GetItems().Add();
							MetaAttribute = MetaObject.TabularSections[ToEditAttributes.TabularName].Attributes[ToEditAttributes.AttributeName];
						Else
							AttributeBranch = MetadataBranch.GetItems().Add();
							MetaAttribute = Metadata.CommonAttributes.Find(ToEditAttributes.AttributeName);
							If MetaAttribute = Undefined Then
								MetaAttribute = MetaObject.Attributes[ToEditAttributes.AttributeName];
							EndIf;
						EndIf;
					Except
						Continue;
					EndTry;
					AttributeBranch.Mark = ToEditAttributes.Mark;
					AttributeBranch.MetadataRef = ToEditAttributes.MetadataRef;
					AttributeBranch.TabularName = ToEditAttributes.TabularName;
					AttributeBranch.AttributeName = ToEditAttributes.AttributeName;
					AttributeBranch.Description = MetaAttribute.Synonym;
				EndDo;
			EndDo;
		EndDo; 
	EndDo;
	
	ToViewAttributesGroups = QueryResults[1].Select(QueryResultIteration.ByGroups);
	While ToViewAttributesGroups.Next() Do
		GroupBranch = AccessToViewAttributesTree.GetItems().Add();
		GroupBranch.Description = ToViewAttributesGroups.MetadataGroup;
		
		ToViewAttributesMetadatas = ToViewAttributesGroups.Select(QueryResultIteration.ByGroups);
		While ToViewAttributesMetadatas.Next() Do
			MetadataRef = ToViewAttributesMetadatas.MetadataRef;
			
			MetadataBranch = GroupBranch.GetItems().Add();
			MetadataBranch.Description = String(MetadataRef);
			
			Try
				MetaObject = Metadata.FindByFullName(MetadataRef.ObjectFullName); // MetadataObjectCatalog,  MetadataObjectDocument
			Except
				Continue;
			EndTry;
			
			ToViewAttributesTables = ToViewAttributesMetadatas.Select(QueryResultIteration.ByGroups);
			While ToViewAttributesTables.Next() Do
				isTable = ValueIsFilled(ToViewAttributesTables.TabularName);
				
				If isTable Then
					TableBranch = MetadataBranch.GetItems().Add();
					TableBranch.TabularName = ToViewAttributesTables.TabularName;
					Try
						TableBranch.Description = MetaObject.TabularSections[ToViewAttributesTables.TabularName].Synonym;
					Except
						Continue;
					EndTry;
				EndIf;
				
				ToViewAttributes = ToViewAttributesTables.Select();
				While ToViewAttributes.Next() Do
					Try
						If isTable Then
							AttributeBranch = TableBranch.GetItems().Add();
							MetaAttribute = MetaObject.TabularSections[ToViewAttributes.TabularName].Attributes[ToViewAttributes.AttributeName];
						Else
							AttributeBranch = MetadataBranch.GetItems().Add();
							MetaAttribute = Metadata.CommonAttributes.Find(ToViewAttributes.AttributeName);
							If MetaAttribute = Undefined Then
								MetaAttribute = MetaObject.Attributes[ToViewAttributes.AttributeName];
							EndIf;
						EndIf;
					Except
						Continue;
					EndTry;
					AttributeBranch.Mark = ToViewAttributes.Mark;
					AttributeBranch.MetadataRef = ToViewAttributes.MetadataRef;
					AttributeBranch.TabularName = ToViewAttributes.TabularName;
					AttributeBranch.AttributeName = ToViewAttributes.AttributeName;
					AttributeBranch.Description = MetaAttribute.Synonym;
				EndDo;
			EndDo;
		EndDo; 
	EndDo;
	
	TempTree = FormDataToValue(AccessToEditAttributesTree, Type("ValueTree")); // ValueTree
	TempTree.Rows.Sort("TabularName, Description", True); 
	ValueToFormData(TempTree, AccessToEditAttributesTree);
	
	TempTree = FormDataToValue(AccessToViewAttributesTree, Type("ValueTree")); // ValueTree
	TempTree.Rows.Sort("TabularName, Description", True); 
	ValueToFormData(TempTree, AccessToViewAttributesTree);
	
	Items.AccessToEditAttributesTree.Visible = AccessToEditAttributesTree.GetItems().Count(); 
	Items.AccessToViewAttributesTree.Visible = AccessToViewAttributesTree.GetItems().Count(); 

EndProcedure

&AtClient
Procedure SetMarkForAll(Row, Mark)
	
	If Row.AttributeName <> "" Then
		Row.Mark = Mark;
	Else
		For Each SubRow In Row.GetItems() Do
			SetMarkForAll(SubRow, Mark)
		EndDo;
	EndIf;
	
EndProcedure

&AtServer
Procedure SaveAccessDataToTabularSection(AccessAttributes, Row)
	
	If Row.AttributeName <> "" Then
		If Row.Mark Then
			Record = AccessAttributes.Add();
			FillPropertyValues(Record, Row);
		EndIf;
	Else
		For Each SubRow In Row.GetItems() Do
			SaveAccessDataToTabularSection(AccessAttributes, SubRow)
		EndDo;
	EndIf;

EndProcedure
