
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocWorkSheetServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocWorkSheetServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocWorkSheetServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocWorkSheetClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;

	If EventName = "LockLinkedRows" Then
		If Source <> ThisObject Then
			LockLinkedRows();
		EndIf;
	EndIf;
	
	If Not Source = ThisObject Then
		Return;
	EndIf;	
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocWorkSheetClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
	SetVisibleRows_Materials();
EndProcedure

&AtClient
Procedure API_Callback(TableName, ArrayOfDataPaths) Export
	API_CallbackAtServer(TableName, ArrayOfDataPaths);
EndProcedure

&AtServer
Procedure API_CallbackAtServer(TableName, ArrayOfDataPaths)
	ViewServer_V2.API_CallbackAtServer(Object, ThisObject, TableName, ArrayOfDataPaths);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.AddBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LinkUnlinkBasisDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	
	_QuantityIsFixed = False;
	For Each Row In Object.ItemList Do
		If Row.QuantityIsFixed Then
			_QuantityIsFixed = True;
			Break;
		EndIf;
	EndDo;
	Form.Items.ItemListQuantityIsFixed.Visible = _QuantityIsFixed;
	Form.Items.ItemListQuantityInBaseUnit.Visible = _QuantityIsFixed;
	Form.Items.EditQuantityInBaseUnit.Enabled = Not _QuantityIsFixed;
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

&AtClient
Procedure SetVisibleRows_Materials(ActivateRow = True)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	For Each Row In Object.Materials Do
		Row.IsVisible = Row.KeyOwner = CurrentData.Key;
	EndDo;
	If ActivateRow Then
		VisibleRows = Object.Materials.FindRows(New Structure("IsVisible", True));
		If VisibleRows.Count() Then
			Items.Materials.CurrentRow = VisibleRows[0].GetID();
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocWorkSheetClient.DateOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocWorkSheetClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocWorkSheetClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);	
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocWorkSheetClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);	
EndProcedure

#EndRegion

#Region PARTNER

&AtClient
Procedure PartnerOnChange(Item)
	DocWorkSheetClient.PartnerOnChange(Object, ThisObject, Item);	
EndProcedure

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocWorkSheetClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocWorkSheetClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);	
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure LegalNameOnChange(Item)
	DocWorkSheetClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocWorkSheetClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);	
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocWorkSheetClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region MATERIALS

&AtClient
Procedure MaterialsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocWorkSheetClient.MaterialsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
	SetVisibleRows_Materials(False);
EndProcedure

&AtClient
Procedure MaterialsBeforeDeleteRow(Item, Cancel)
	DocWorkSheetClient.MaterialsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

#Region MATERIALS_COLUMNS

#Region _ITEM

&AtClient
Procedure MaterialsItemOnChange(Item)
	DocWorkSheetClient.MaterialsItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure MaterialsItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocWorkSheetClient.MaterialsItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure MaterialsItemEditTextChange(Item, Text, StandardProcessing)
	DocWorkSheetClient.MaterialsItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure MaterialsItemKeyOnChange(Item)
	DocWorkSheetClient.MaterialsItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure MaterialsUnitOnChange(Item)
	DocWorkSheetClient.MaterialsUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure MaterialsQuantityOnChange(Item)
	DocWorkSheetClient.MaterialsQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COST_WRITE_OFF

&AtClient
Procedure MaterialsCostWriteOffOnChange(Item)
	DocWorkSheetClient.MaterialsCostWriteOffOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region WORKERS

&AtClient
Procedure WorkersBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocWorkSheetClient.WorkersBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocWorkSheetClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocWorkSheetClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocWorkSheetClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocWorkSheetClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	SetVisibleRows_Materials();
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocWorkSheetClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocWorkSheetClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);	
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocWorkSheetClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocWorkSheetClient.ItemListItemKeyOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

&AtClient
Procedure ItemListBillOfMaterialsOnChange(Item)
	DocWorkSheetClient.ItemListBillOfMaterialsOnChange(Object, ThisObject, Item);
	SetVisibleRows_Materials();
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocWorkSheetClient.ItemListUnitOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocWorkSheetClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

&AtClient
Procedure ItemListQuantityInBaseUnitOnChange(Item)
	DocWorkSheetClient.ItemListQuantityInBaseUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

&AtClient
Procedure ItemListQuantityIsFixedOnChange(Item)
	DocWorkSheetClient.ItemListQuantityIsFixedOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocWorkSheetClient);
	Str.Insert("Server", DocWorkSheetServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region COMMANDS

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

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

#Region LINKED_DOCUMENTS

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_WS(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	OpenForm("CommonForm.LinkUnlinkDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject, NotifyParameters), 
			FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_WS(Object));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject, NotifyParameters), 
			FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddOrLinkUnlinkDocumentRowsContinue(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.Modified = True;
	ExtractedData = AddOrLinkUnlinkDocumentRowsContinueAtServer(Result);
	If ExtractedData <> Undefined Then
		ViewClient_V2.OnAddOrLinkUnlinkDocumentRows(ExtractedData, Object, ThisObject, "ItemList");
	EndIf;
	SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(Object);
	SourceOfOriginClient.UpdateSourceOfOriginsPresentation(Object);
EndProcedure

&AtServer
Function AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	ExtractedData = Undefined;
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		LinkedResult = RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues, Result.CalculateRows);
	ElsIf Result.Operation = "AddLinkedDocumentRows" Then
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(Object, Result.FillingValues);
	EndIf;
	ExtractedData = ControllerClientServer_V2.AddLinkedDocumentRows(Object, ThisObject, LinkedResult, "ItemList");
	LockLinkedRows();
	Return ExtractedData;
EndFunction

&AtServer
Procedure LockLinkedRows()
	RowIDInfoServer.LockLinkedRows(Object, ThisObject);
	RowIDInfoServer.SetAppearance(Object, ThisObject);
EndProcedure

&AtServer
Procedure UnlockLockLinkedRows()
	RowIDInfoServer.UnlockLinkedRows(Object, ThisObject);
EndProcedure

&AtClient
Procedure FromUnlockLinkedRows(Command)
	Items.FormUnlockLinkedRows.Check = Not Items.FormUnlockLinkedRows.Check;
	If Items.FormUnlockLinkedRows.Check Then
		UnlockLockLinkedRows();
	Else
		LockLinkedRows();
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, CurrentData.Key, Object.Currency, 0);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditQuantityInBaseUnit(Command)
	Items.ItemListQuantityInBaseUnit.Visible = Not Items.ItemListQuantityInBaseUnit.Visible;
	Items.ItemListQuantityIsFixed.Visible = Not Items.ItemListQuantityIsFixed.Visible;	 	
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
