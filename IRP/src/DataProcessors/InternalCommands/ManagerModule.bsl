// @strict-types

#Region Public

// Get all command descriptions.
// 
// Returns:
//  Array of See InternalCommandsServer.GetCommandDescription
Function GetAllCommandDescriptions() Export
	
	Result = New Array; // Array of See InternalCommandsServer.GetCommandDescription
	
	Result.Add(GetCommandDescription("SetNotActive"));
	Result.Add(GetCommandDescription("ShowNotActive"));
	Result.Add(GetCommandDescription("GroupEditingProperties"));
	Result.Add(GetCommandDescription("CloneValueFromFirstRow"));
	Result.Add(GetCommandDescription("LoadDataFromTable"));
	Result.Add(GetCommandDescription("AuditLock"));
	Result.Add(GetCommandDescription("OpenVendorPrices"));
	
	Return Result;
	
EndFunction

// Get command description.
// 
// Parameters:
//  CommandName - String - Command name
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function GetCommandDescription(CommandName) Export
	
	If CommandName = "SetNotActive" Then
		Return SetNotActive_GetCommandDescription();
		
	ElsIf CommandName = "ShowNotActive" Then
		Return ShowNotActive_GetCommandDescription();

	ElsIf CommandName = "GroupEditingProperties" Then
		Return GroupEditingProperties_GetCommandDescription();

	ElsIf CommandName = "CloneValueFromFirstRow" Then
		Return CloneValueFromFirstRow_GetCommandDescription();
	
	ElsIf CommandName = "LoadDataFromTable" Then
		Return LoadDataFromTable_GetCommandDescription();
	
	ElsIf CommandName = "AuditLock" Then
		Return AuditLock_GetCommandDescription();
	ElsIf CommandName = "OpenVendorPrices" Then	
		Return OpenVendorPrices_GetCommandDescription();
	EndIf;
	
	Raise StrTemplate(R().Exc_011, CommandName);
	
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
		SetNotActive_OnCommandCreate(CommandName, CommandParameters, AddInfo);
		 
	ElsIf CommandName = "ShowNotActive" Then
		ShowNotActive_OnCommandCreate(CommandName, CommandParameters, AddInfo);
		
	ElsIf CommandName = "GroupEditingProperties" Then
		GroupEditingProperties_OnCommandCreate(CommandName, CommandParameters, AddInfo);
		
	ElsIf CommandName = "LoadDataFromTable" Then
		LoadDataFromTable_OnCommandCreate(CommandName, CommandParameters, AddInfo);
		
	ElsIf CommandName = "AuditLock" Then
		AuditLock_OnCommandCreate(CommandName, CommandParameters, AddInfo);
		
	EndIf;
	
EndProcedure

#EndRegion

#Region Internal

// Before running.
// 
// Parameters:
//  CommandName - String - Command name
//  Targets - AnyRef, Array of AnyRef - Command target
//  Form - ClientApplicationForm - Form
//  CommandFormItem - FormButton - Command form item
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  AddInfo - Undefined - Add info
Procedure BeforeRunning(CommandName, Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

// Run command action.
// 
// Parameters:
//  CommandName - String - Command name
//  Targets - AnyRef, Array of AnyRef - Command target
//  Form - ClientApplicationForm - Form
//  CommandFormItem - FormButton - Command form item
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  AddInfo - Undefined - Add info
Procedure RunCommandAction(CommandName, Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	
	If CommandName = "CloneValueFromFirstRow" Then
		CloneValueFromFirstRow_RunCommandAction(Targets, Form, CommandFormItem, MainAttribute, AddInfo);
		
	EndIf;
	
EndProcedure

// After running.
// 
// Parameters:
//  CommandName - String - Command name
//  Targets - AnyRef, Array of AnyRef - Command target
//  Form - ClientApplicationForm - Form
//  CommandFormItem - FormButton - Command form item
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  AddInfo - Undefined - Add info
Procedure AfterRunning(CommandName, Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Private

#Region SetNotActive

// Set not active get command description.
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function SetNotActive_GetCommandDescription()
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
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
	
	Return CommandDescription;
	
EndFunction

// See InternalCommandsServer.OnCommandCreate
Procedure SetNotActive_OnCommandCreate(CommandName, CommandParameters, AddInfo)

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
		 
EndProcedure

#EndRegion

#Region ShowNotActive

// Show not active get command description.
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function ShowNotActive_GetCommandDescription()
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
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
	
	Return CommandDescription;
	
EndFunction

// See InternalCommandsServer.OnCommandCreate
Procedure ShowNotActive_OnCommandCreate(CommandName, CommandParameters, AddInfo)

	NotActiveShowing = SessionParameters.NotActiveCatalogsShowing[CommandParameters.ObjectFullName]; // Boolean
	CommandParameters.CommandButton.Check = NotActiveShowing;
	
	QuerySchemaAPI = DynamicListAPI.Get(CommandParameters.MainAttribute);
	DynamicListAPI.AddField(QuerySchemaAPI, "NotActive", "NotActive");
	DynamicListAPI.AddFilter(QuerySchemaAPI, "NotActive = FALSE OR &ShowNotActive");
	DynamicListAPI.Set(QuerySchemaAPI);
	CommandParameters.MainAttribute.Parameters.SetParameterValue("ShowNotActive", NotActiveShowing); 
	
	DynamicListAPI.AddAppearance(QuerySchemaAPI, "NotActive", DataCompositionComparisonType.Equal, True, "Font", New Font( , , , , , True));
EndProcedure

#EndRegion

#Region GroupEditingProperties

// Group editing properties get command description.
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function GroupEditingProperties_GetCommandDescription()
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
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
	
	Return CommandDescription;
	
EndFunction

// See InternalCommandsServer.OnCommandCreate
Procedure GroupEditingProperties_OnCommandCreate(CommandName, CommandParameters, AddInfo)

	CommandParameters.CommandButton.Visible = AccessRight("Use", Metadata.DataProcessors.ObjectPropertyEditor);
		 
EndProcedure

#EndRegion

#Region CloneValueFromFirstRow

// Clone value from first row get command description.
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function CloneValueFromFirstRow_GetCommandDescription()
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
	CommandDescription.Name = "CloneValueFromFirstRow";
	//@skip-check statement-type-change, property-return-type
	CommandDescription.Title = Metadata.DataProcessors.InternalCommands.Forms.CloneValueFromFirstRow.Synonym;
	CommandDescription.ToolTip = CommandDescription.Title;
	CommandDescription.Picture = "CloneObject";
	CommandDescription.Representation = "PictureAndText";
	
	CommandDescription.ForTables = True;
	CommandDescription.SpecificTables = "PaymentList, ItemList";
	
	CommandDescription.LocationGroup = "CommandBar.Tools";
	CommandDescription.LocationInCommandBar = "InAdditionalSubmenu"; //ButtonLocationInCommandBar.InAdditionalSubmenu
	CommandDescription.ForContextMenu = True;
	
	CommandDescription.ModifiesStoredData = True;
	CommandDescription.ServerContextRequired = True;
	
	CommandDescription.HasActionOnCommandCreate = True;
	
	CommandDescription.UsingObjectForm = True;
	
	Targets = CommandDescription.Targets;
	
	Targets.Add(Metadata.Documents.PurchaseInvoice.FullName());
	Targets.Add(Metadata.Documents.PurchaseOrder.FullName());
	Targets.Add(Metadata.Documents.PurchaseReturn.FullName());
	Targets.Add(Metadata.Documents.PurchaseReturnOrder.FullName());
	Targets.Add(Metadata.Documents.SalesInvoice.FullName());
	Targets.Add(Metadata.Documents.SalesOrder.FullName());
	Targets.Add(Metadata.Documents.SalesReturn.FullName());
	Targets.Add(Metadata.Documents.SalesReturnOrder.FullName());
	Targets.Add(Metadata.Documents.StockAdjustmentAsSurplus.FullName());
	Targets.Add(Metadata.Documents.StockAdjustmentAsWriteOff.FullName());
	
	Targets.Add(Metadata.Documents.BankPayment.FullName());
	Targets.Add(Metadata.Documents.BankReceipt.FullName());
	Targets.Add(Metadata.Documents.CashPayment.FullName());
	Targets.Add(Metadata.Documents.CashReceipt.FullName());
	Targets.Add(Metadata.Documents.CashExpense.FullName());
	
	CommandDescription.Targets = New FixedArray(Targets);
	
	Return CommandDescription;
	
EndFunction

// See RunCommandAction
Procedure CloneValueFromFirstRow_RunCommandAction(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	
	TableName = StrSplit(CommandFormItem.Name, "_")[1];
	
	TableData = MainAttribute[TableName]; // FormDataCollection
	If TableData.Count() = 0 Then
		Return;
	EndIf;
	
	RowsArray = New Array; // Array of FormDataCollectionItem
	TableItem = Form.Items.Find(TableName); // FormTable
	For Each SelectedRow In TableItem.SelectedRows Do // Number
		TableRecord = TableData.FindByID(SelectedRow);
		If TableData.IndexOf(TableRecord) > 0 Then
			RowsArray.Add(TableRecord);
		EndIf;
	EndDo;
	If RowsArray.Count() = 0 Then
		Return;
	EndIf;
	
	If TableItem.CurrentItem.ReadOnly OR NOT TableItem.CurrentItem.Enabled Then
		Return;
	EndIf;

	EnableColumns = New Array; // Array of String
	EnableColumns.Add("FinancialMovementType");
	EnableColumns.Add("CashFlowCenter");
	EnableColumns.Add("ProfitLossCenter");
	EnableColumns.Add("ExpenseType");
	EnableColumns.Add("RevenueType");
	EnableColumns.Add("ReturnReason");
	EnableColumns.Add("Project");
	
	ColumnName = StrSplit(TableItem.CurrentItem.DataPath, ".")[2];
	If EnableColumns.Find(ColumnName) = Undefined Then
		Return;
	EndIf;
	
	For Each Row In RowsArray Do
		Row[ColumnName] = TableData[0][ColumnName];
	EndDo;

EndProcedure

#EndRegion

#Region LoadDataFromTable

// Load data from table get command description.
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function LoadDataFromTable_GetCommandDescription()
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
	CommandDescription.Name = "LoadDataFromTable";
	CommandDescription.Title = R().LDT_Button_Title;
	CommandDescription.ToolTip = R().LDT_Button_ToolTip; 
	CommandDescription.Picture = "SpreadsheetShowGrid";
	CommandDescription.Representation = "Picture";
	
	CommandDescription.ForTables = True;
	CommandDescription.SpecificTables = "ItemList, ItemKeyList";
	
	CommandDescription.LocationGroup = "CommandBar.Tools";
	CommandDescription.ModifiesStoredData = True;
	
	CommandDescription.UsingObjectForm = True;
	
	CommandDescription.HasActionOnCommandCreate = True;

	Targets = CommandDescription.Targets;
	
	ArrayOfExcludingDocuments = New Array(); // Array of MetadataObject
	ArrayOfExcludingDocuments.Add(Metadata.Documents.SalesOrderClosing);
	ArrayOfExcludingDocuments.Add(Metadata.Documents.PurchaseOrderClosing);
	
	For Each ContentItem In Metadata.Documents Do
		If ArrayOfExcludingDocuments.Find(ContentItem) = Undefined Then
			Targets.Add(ContentItem.FullName());
		EndIf;
	EndDo;
	CommandDescription.Targets = New FixedArray(Targets);
	
	Return CommandDescription;
	
EndFunction

// See InternalCommandsServer.OnCommandCreate
Procedure LoadDataFromTable_OnCommandCreate(CommandName, CommandParameters, AddInfo)

	Form = CommandParameters.Form;
	ObjectMetadata = Metadata.FindByFullName(CommandParameters.ObjectFullName);
	CurrentTableName = StrSplit(CommandParameters.CommandButton.Name, "_")[1];
	
	NewAttributeName_Fields = CommandParameters.CommandButton.Name + "_Fields";
	NewAttributeName_Target = CommandParameters.CommandButton.Name + "_Target";
	NewAttributeName_EndNotify = CommandParameters.CommandButton.Name + "_EndNotify";
	NewAttributeName_UseFormNotify = CommandParameters.CommandButton.Name + "_UseFormNotify";
	
	AttributeExists_Fields = False;
	AttributeExists_Target = False;
	AttributeExists_EndNotify = False;
	AttributeExists_UseFormNotify = False;
	
	FormAttributes = Form.GetAttributes();
	For Each FormAttribute In FormAttributes Do
		If FormAttribute.Name = NewAttributeName_Fields Then
			AttributeExists_Fields = True;
		EndIf;
		If FormAttribute.Name = NewAttributeName_Target Then
			AttributeExists_Target = True;
		EndIf;
		If FormAttribute.Name = NewAttributeName_EndNotify Then
			AttributeExists_EndNotify = True;
		EndIf;
		If FormAttribute.Name = NewAttributeName_UseFormNotify Then
			AttributeExists_UseFormNotify = True;
		EndIf;
	EndDo;
	
	NewAttributes = New Array; // Array of FormAttribute
	If Not AttributeExists_Fields Then
		NewAttributes.Add(New FormAttribute(NewAttributeName_Fields, New TypeDescription("")));
	EndIf;
	If Not AttributeExists_Target Then
		NewAttributes.Add(New FormAttribute(NewAttributeName_Target, New TypeDescription("String")));
	EndIf;
	If Not AttributeExists_EndNotify Then
		NewAttributes.Add(New FormAttribute(NewAttributeName_EndNotify, New TypeDescription("String")));
	EndIf;
	If Not AttributeExists_UseFormNotify Then
		NewAttributes.Add(New FormAttribute(NewAttributeName_UseFormNotify, New TypeDescription("Boolean")));
	EndIf;
	Form.ChangeAttributes(NewAttributes);
		
	If Not AttributeExists_Fields Then
		FieldsForLoadData = New Structure;
		For Each TableChildItem In Form.Items[CurrentTableName].ChildItems Do
			If TableChildItem.Type = FormFieldType.InputField And TableChildItem.Visible Then
				DataPathParts = StrSplit(TableChildItem.DataPath, ".");
				TableName = DataPathParts[1];
				AttributeName = DataPathParts[2];
				//@skip-check wrong-string-literal-content
				TableAttributes = ObjectMetadata["TabularSections"][TableName]["Attributes"]; // MetadataObjectCollection
				ItemAttribute = TableAttributes.Find(AttributeName); // MetadataObjectAttribute
				If Not ItemAttribute = Undefined Then
					ItemDescription = New Structure;
					ItemDescription.Insert("Name", AttributeName);
					ItemDescription.Insert("Synonym", ItemAttribute.Synonym);
					ItemDescription.Insert("Type", ItemAttribute.Type);
					FieldsForLoadData.Insert(AttributeName, ItemDescription); 
				EndIf;
			EndIf;
		EndDo;
		Form[NewAttributeName_Fields] = FieldsForLoadData;
	EndIf;
	
	If Not AttributeExists_Target Then
		If ObjectMetadata = Metadata.Documents.PriceList Then
			Form[NewAttributeName_Target] = "Price";
		Else
			Form[NewAttributeName_Target] = "Quantity";
		EndIf;
	EndIf;
	
	If Not AttributeExists_EndNotify Then
		If ObjectMetadata = Metadata.Documents.PriceList Then
			Form[NewAttributeName_EndNotify] = "LoadDataFromTableEnd_Document_PriceList";
		ElsIf ObjectMetadata = Metadata.Catalogs.ItemSegments Then
			Form[NewAttributeName_EndNotify] = "LoadDataFromTableEnd_Catalog_ItemSegments";
		Else
			Form[NewAttributeName_EndNotify] = "LoadDataFromTableEnd";
		EndIf;
	EndIf;
	
EndProcedure

#EndRegion

#Region AuditLock

// Audit lock command description.
// 
// Returns:
//  See InternalCommandsServer.GetCommandDescription
Function AuditLock_GetCommandDescription()
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
	CommandDescription.Name = "AuditLock";
	//@skip-check statement-type-change, property-return-type
	CommandDescription.Title = R().AuditLock_001;
	//@skip-check statement-type-change, property-return-type
	CommandDescription.TitleCheck = R().AuditLock_002;
	CommandDescription.ToolTip = CommandDescription.Title;
	CommandDescription.Picture = "UserWithAuthentication";
	CommandDescription.PictureCheck = "User";
	CommandDescription.EnableChecking = True;
	
	CommandDescription.LocationGroup = "CommandBar.Tools";
	CommandDescription.LocationInCommandBar = "InAdditionalSubmenu"; //ButtonLocationInCommandBar.InAdditionalSubmenu
	CommandDescription.ModifiesStoredData = False;
	
	CommandDescription.HasActionInitialization = True;
	CommandDescription.HasActionOnCommandCreate = True;
	CommandDescription.HasActionAfterRunning = True;
	
	CommandDescription.UsingListForm = False;
	CommandDescription.UsingChoiceForm = False;
	CommandDescription.UsingObjectForm = True;
	
	Targets = CommandDescription.Targets;
	For Each DocMetadata In Metadata.Documents Do
		Targets.Add(DocMetadata.FullName());
	EndDo;
	
	CommandDescription.Targets = New FixedArray(Targets);
	
	Return CommandDescription;
	
EndFunction

// See InternalCommandsServer.OnCommandCreate
Procedure AuditLock_OnCommandCreate(CommandName, CommandParameters, AddInfo)

	If CommonFunctionsClientServer.ObjectHasProperty(CommandParameters, "MainAttribute") And
		CommonFunctionsClientServer.ObjectHasProperty(CommandParameters.MainAttribute, "Ref") Then
		//@skip-check property-return-type
		CommandParameters.CommandButton.Check = AuditLockPrivileged.LockIsSet(CommandParameters.MainAttribute.Ref);
	EndIf;
	
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
		 
EndProcedure

#EndRegion

#Region OpenVendorPrices
Function OpenVendorPrices_GetCommandDescription()
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
	CommandDescription.Name = "OpenVendorPrices";
	//@skip-check statement-type-change, property-return-type
	CommandDescription.Title = R().OVP_Button_Title;
	//@skip-check statement-type-change, property-return-type
	CommandDescription.ToolTip = R().OVP_Button_Title;
	CommandDescription.Picture = "Price";
	CommandDescription.Representation = "PictureAndText";
	
	CommandDescription.LocationGroup = "FormCommandBar.FormService";
	CommandDescription.ModifiesStoredData = False;
	
	CommandDescription.HasActionInitialization = True;
	CommandDescription.HasActionOnCommandCreate = True;
	CommandDescription.HasActionAfterRunning = True;
	
	CommandDescription.UsingListForm = False;
	CommandDescription.UsingChoiceForm = False;
	CommandDescription.UsingObjectForm = True;
	
	Targets = CommandDescription.Targets;
	
	Targets.Add(Metadata.Documents.PurchaseInvoice.FullName());
	Targets.Add(Metadata.Documents.PurchaseOrder.FullName());
	
	CommandDescription.Targets = New FixedArray(Targets);
	
	Return CommandDescription;
	
EndFunction

#EndRegion

#EndRegion
