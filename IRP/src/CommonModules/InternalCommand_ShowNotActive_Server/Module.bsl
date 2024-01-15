// @strict-types

#Region Public

// See InternalCommandsServer.GetCommandDescription 
//@skip-check statement-type-change, property-return-type
Function GetCommandDescription() Export
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
	CommandDescription.Name = "ShowNotActive";
	CommandDescription.Title = R().InternalCommands_ShowNotActive;
	CommandDescription.TitleCheck = R().InternalCommands_ShowNotActive_Check;
	CommandDescription.ToolTip = CommandDescription.Title;
	CommandDescription.Picture = "IconShowAnyActive";
	CommandDescription.PictureCheck = "IconShowOnlyActive";
	
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
	
	Return New FixedStructure(CommandDescription);
	
EndFunction

#EndRegion

#Region Internal

// Initialization.
Procedure Initialization() Export
	
	Data = New Map;
	For Each ContentItem In Metadata.CommonAttributes.NotActive.Content Do
		If ContentItem.Use = Metadata.ObjectProperties.CommonAttributeUse.Use  Then
			Data.Insert(ContentItem.Metadata.FullName(), False);
		EndIf;
	EndDo;
	
	SessionParameters.NotActiveCatalogsShowing = New FixedMap(Data);
	
EndProcedure

// On command create.
// 
// Parameters:
//  CommandButton - FormButton - Command button
//  CommandDescription - See InternalCommandsServer.GetCommandDescription
//  Form - ClientApplicationForm - Form
//  MainAttribute - DynamicList - Main attribute
//  ObjectFullName - String - Object full name
//  FormType - EnumRef.FormTypes - Form type
//  AddInfo - Undefined - Add info
Procedure OnCommandCreate(CommandButton, CommandDescription, Form, MainAttribute, ObjectFullName, FormType, AddInfo = Undefined) Export
	
	NotActiveShowing = SessionParameters.NotActiveCatalogsShowing[ObjectFullName]; // Boolean
	CommandButton.Check = NotActiveShowing;
	
	OriginalQuery = True;
	FormQueryText = MainAttribute.QueryText;
	If Not MainAttribute.CustomQuery Then
		FormQueryText = "Select * From " + MainAttribute.MainTable;
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
	MainAttribute.QueryText = QueryText;
	MainAttribute.Parameters.SetParameterValue("ShowNotActive", NotActiveShowing); 
	
	ConditionalAppearanceItem = MainAttribute.ConditionalAppearance.Items.Add();
	//@skip-check new-font
	ConditionalAppearanceItem.Appearance.SetParameterValue("Font", New Font(,,,,, True));
	FilterItem = ConditionalAppearanceItem.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
	FilterItem.LeftValue = New DataCompositionField("NotActive");
	FilterItem.RightValue = True;
	FilterItem.Use = True;
	
EndProcedure

// Change showing status.
// 
// Parameters:
//  ObjectFullName - String - Object full name
// 
// Returns:
//  Boolean - Change showing status
Function ChangeShowingStatus(ObjectFullName) Export
	
	NotActiveCatalogsShowingMap = New Map(SessionParameters.NotActiveCatalogsShowing);
	NotActiveCatalogsShowingMap[ObjectFullName] = Not NotActiveCatalogsShowingMap[ObjectFullName];
	
	Result = NotActiveCatalogsShowingMap[ObjectFullName]; // Boolean
	
	SessionParameters.NotActiveCatalogsShowing = New FixedMap(NotActiveCatalogsShowingMap);
	
	Return Result;
	
EndFunction

#EndRegion