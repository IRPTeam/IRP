// @strict-types

#Region Public

// Get command description.
// 
// Parameters:
//  CommandName - String - Command name
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function GetCommandDescription(CommandName) Export
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
	If CommandName = "SetNotActive" Then
		
		CommandDescription.Name = "SetNotActive";
		//@skip-check statement-type-change, property-return-type
		CommandDescription.Title = R().InternalCommands_SetNotActive;
		//@skip-check statement-type-change, property-return-type
		CommandDescription.TitleCheck = R().InternalCommands_SetNotActive_Check;
		CommandDescription.ToolTip = CommandDescription.Title; 
		CommandDescription.Picture = "IconSetNotActive";
		CommandDescription.PictureCheck = "IconSetActive";
		CommandDescription.EnableChecking = True;
		
		CommandDescription.LocationGroup = "CommandBar.Tools";
		CommandDescription.LocationInCommandBar = "InAdditionalSubmenu"; //ButtonLocationInCommandBar.InAdditionalSubmenu
		CommandDescription.ModifiesStoredData = True;
		
		CommandDescription.UsingObjectForm = True;
		
		CommandDescription.HasActionOnCommandCreate = True;
		CommandDescription.HasActionAfterRunning = True;
		
		Targets = CommandDescription.Targets;
		For Each ContentItem In Metadata.CommonAttributes.NotActive.Content Do
			If ContentItem.Use = Metadata.ObjectProperties.CommonAttributeUse.Use  Then
				Targets.Add(ContentItem.Metadata.FullName());
			EndIf;
		EndDo;
		CommandDescription.Targets = New FixedArray(Targets);
		
	ElsIf CommandName = "ShowNotActive" Then
		
		CommandDescription.Name = "ShowNotActive";
		//@skip-check statement-type-change, property-return-type
		CommandDescription.Title = R().InternalCommands_ShowNotActive;
		//@skip-check statement-type-change, property-return-type
		CommandDescription.TitleCheck = R().InternalCommands_ShowNotActive_Check;
		CommandDescription.ToolTip = CommandDescription.Title;
		CommandDescription.Picture = "IconShowAnyActive";
		CommandDescription.PictureCheck = "IconShowOnlyActive";
		CommandDescription.EnableChecking = True;
		
		CommandDescription.LocationGroup = "CommandBar.Tools";
		CommandDescription.LocationInCommandBar = "InAdditionalSubmenu"; //ButtonLocationInCommandBar.InAdditionalSubmenu
		CommandDescription.ModifiesStoredData = True;
		
		CommandDescription.HasActionInitialization = True;
		CommandDescription.HasActionOnCommandCreate = True;
		
		CommandDescription.UsingListForm = True;
		CommandDescription.UsingChoiceForm = True;
		
		Targets = CommandDescription.Targets;
		For Each ContentItem In Metadata.CommonAttributes.NotActive.Content Do
			If ContentItem.Use = Metadata.ObjectProperties.CommonAttributeUse.Use  Then
				Targets.Add(ContentItem.Metadata.FullName());
			EndIf;
		EndDo;
		CommandDescription.Targets = New FixedArray(Targets);

	ElsIf CommandName = "GroupEditingProperties" Then
		
		CommandDescription.Name = "GroupEditingProperties";
		//@skip-check statement-type-change, property-return-type
		CommandDescription.Title = Metadata.DataProcessors.InternalCommands.Forms.GroupEditingProperties.Synonym;
		CommandDescription.ToolTip = CommandDescription.Title;
		CommandDescription.Picture = "SpreadsheetReadOnly";
		CommandDescription.Representation = "Picture";
		
		CommandDescription.LocationGroup = "CommandBar.Tools";
		CommandDescription.LocationInCommandBar = "InCommandBarAndInAdditionalSubmenu"; //ButtonLocationInCommandBar.InAdditionalSubmenu
		CommandDescription.ModifiesStoredData = True;
		
		CommandDescription.HasActionOnCommandCreate = True;
		
		CommandDescription.UsingListForm = True;
		CommandDescription.UsingChoiceForm = True;
		
		Targets = CommandDescription.Targets;
		For Each ContentItem In Metadata.Catalogs Do
			If ContentItem <> Metadata.Catalogs.AccessKey
					AND ContentItem <> Metadata.Catalogs.DepreciationSchedules 
					AND ContentItem <> Metadata.Catalogs.EmployeeSchedule
					AND ContentItem <> Metadata.Catalogs.FixedAssets
					AND ContentItem <> Metadata.Catalogs.FixedAssetsLedgerTypes
					AND ContentItem <> Metadata.Catalogs.PrintInfo
					AND ContentItem <> Metadata.Catalogs.Projects Then
				Targets.Add(ContentItem.FullName());
			EndIf;
		EndDo;
		For Each ContentItem In Metadata.Documents Do
			If ContentItem <> Metadata.Documents.AdditionalAccrual
					AND ContentItem <> Metadata.Documents.AdditionalDeduction 
					AND ContentItem <> Metadata.Documents.CommissioningOfFixedAsset
					AND ContentItem <> Metadata.Documents.DebitCreditNote
					AND ContentItem <> Metadata.Documents.DecommissioningOfFixedAsset
					AND ContentItem <> Metadata.Documents.DepreciationCalculation
					AND ContentItem <> Metadata.Documents.EmployeeFiring
					AND ContentItem <> Metadata.Documents.EmployeeHiring
					AND ContentItem <> Metadata.Documents.EmployeeSickLeave
					AND ContentItem <> Metadata.Documents.EmployeeTransfer
					AND ContentItem <> Metadata.Documents.EmployeeVacation
					AND ContentItem <> Metadata.Documents.FixedAssetTransfer
					AND ContentItem <> Metadata.Documents.ModernizationOfFixedAsset
					AND ContentItem <> Metadata.Documents.RetailReceiptCorrection
					AND ContentItem <> Metadata.Documents.VisitorCounter Then
				Targets.Add(ContentItem.FullName());
			EndIf;
		EndDo;
		CommandDescription.Targets = New FixedArray(Targets);

	EndIf;
	
	Return CommandDescription;
	
EndFunction

// Get command group description.
// 
// Parameters:
//  GroupName - String - Group name
// 
// Returns:
//  See InternalCommandsServer.GetCommandGroupDescription
Function GetCommandGroupDescription(GroupName) Export
	
	CommandGroupDescription = InternalCommandsServer.GetCommandGroupDescription();
	
	GroupNameParts = StrSplit(GroupName, ".", False);
	CommandGroupDescription.Name = GroupNameParts.Get(GroupNameParts.UBound());
	If GroupNameParts.Count() > 1 Then
		GroupNameParts.Delete(GroupNameParts.UBound());
		CommandGroupDescription.LocationGroup = StrConcat(GroupNameParts, ".");
	EndIf;
	
	If Right(CommandGroupDescription.Name, 8) = "_Submenu" Then
		CommandGroupDescription.Type = "Popup";
	EndIf;
	
	Return CommandGroupDescription;
EndFunction

// See InternalCommandsServer.OnCommandCreate
Procedure OnCommandCreate(CommandName, CommandParameters, AddInfo = Undefined) Export
	
	If CommandName = "SetNotActive" Then
		
		//@skip-check property-return-type
		StatusNotActive = CommandParameters.MainAttribute.NotActive; // Boolean
		CommandParameters.CommandButton.Check = StatusNotActive;
		
		If CommandParameters.CommandButton.Check Then
			CommandParameters.CommandButton.Title = 
				?(IsBlankString(CommandParameters.CommandDescription.TitleCheck), 
					CommandParameters.CommandDescription.Title, 
					CommandParameters.CommandDescription.TitleCheck);
			If Not IsBlankString(CommandParameters.CommandDescription.PictureCheck) Then
				CommandPicture = PictureLib[CommandParameters.CommandDescription.PictureCheck]; // Picture
				CommandParameters.CommandButton.Picture = CommandPicture;
			ElsIf Not IsBlankString(CommandParameters.CommandDescription.Picture) Then
				CommandPicture = PictureLib[CommandParameters.CommandDescription.Picture]; // Picture
				CommandParameters.CommandButton.Picture = CommandPicture;
			EndIf;
		EndIf;
		 
	ElsIf CommandName = "ShowNotActive" Then
		
		NotActiveShowing = SessionParameters.NotActiveCatalogsShowing[CommandParameters.ObjectFullName]; // Boolean
		CommandParameters.CommandButton.Check = NotActiveShowing;
		
		OriginalQuery = True;
		FormQueryText = CommandParameters.MainAttribute.QueryText;
		MainAttributeTable = CommandParameters.MainAttribute.MainTable;
		If Not CommandParameters.MainAttribute.CustomQuery Then
			FormQueryText = "Select * From " + MainAttributeTable;
			OriginalQuery = False;
		EndIf;
		
		QueryBuilder = New QueryBuilder(FormQueryText);
		QueryBuilder.FillSettings();
		OldParameters = New Array; // Array of String
		For Each BuilderParameter In QueryBuilder.Parameters Do
			OldParameters.Add(BuilderParameter.Key);
		EndDo; 
		
		If OriginalQuery Then
			QueryBuilder.AvailableFields.Add("NotActive", "NotActive");
			QueryBuilder.SelectedFields.Add("Ref.NotActive", "NotActive");
		EndIf;
		
		NewFilter = QueryBuilder.Filter.Add("Ref.NotActive");
		NewFilter.Set(False, True);
		
		ResultQuery = QueryBuilder.GetQuery();
		QueryText = ResultQuery.Text;
		For Each QueryParameter In ResultQuery.Parameters Do
			If OldParameters.Find(QueryParameter.Key) = Undefined Then
				QueryText = StrReplace(QueryText, "&"+QueryParameter.Key, "FALSE OR &ShowNotActive");
				Break;
			EndIf;
		EndDo;
		CommandParameters.MainAttribute.QueryText = QueryText;
		CommandParameters.MainAttribute.Parameters.SetParameterValue("ShowNotActive", NotActiveShowing); 
		CommandParameters.MainAttribute.MainTable = MainAttributeTable;
		
		ConditionalAppearanceItem = CommandParameters.MainAttribute.ConditionalAppearance.Items.Add();
		//@skip-check new-font
		ConditionalAppearanceItem.Appearance.SetParameterValue("Font", New Font(,,,,, True));
		FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
		FilterItem.LeftValue = New DataCompositionField("NotActive");
		FilterItem.RightValue = True;
		FilterItem.Use = True;
		
	EndIf;
	
EndProcedure

#EndRegion