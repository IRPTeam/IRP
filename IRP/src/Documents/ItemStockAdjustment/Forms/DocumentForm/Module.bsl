
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocItemStockAdjustmentServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.DocStorno = DocStornoServer.IsDocumentWithStorno(Object.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocItemStockAdjustmentServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocItemStockAdjustmentServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocItemStockAdjustmentClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;

	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Parameter);
	EndIf;
	
	If EventName = "Storno" Then
		ThisObject.DocStorno = DocStornoServer.IsDocumentWithStorno(Object.Ref);
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure FormUpdateFormAttributes(Direction) Export
	UpdateFormAttributes(Object, ThisObject, Direction);
EndProcedure

&AtClientAtServerNoContext
Procedure UpdateFormAttributes(Object, Form, Direction)
	Return;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
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
	
	If Not Form.ReadOnly Then
		Form.ReadOnly = ValueIsFilled(Form.DocStorno);
	EndIf;
	Form.Items.GroupHeadStorno.Visible = ValueIsFilled(Form.DocStorno);
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

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocItemStockAdjustmentClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocItemStockAdjustmentClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocItemStockAdjustmentClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocItemStockAdjustmentClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocItemStockAdjustmentClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocItemStockAdjustmentClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocItemStockAdjustmentClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocItemStockAdjustmentClient.ItemListItemOnChange(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocItemStockAdjustmentClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocItemStockAdjustmentClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocItemStockAdjustmentClient.ItemListItemKeyOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocItemStockAdjustmentClient.ItemListUnitOnChange(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListUnitStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	DocumentsServer.SetFilterForUnit(CurrentData.Item, ChoiceData, StandardProcessing);	
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocItemStockAdjustmentClient.ItemListQuantityOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

&AtClient
Procedure ItemListQuantityInBaseUnitOnChange(Item)
	DocItemStockAdjustmentClient.ItemListQuantityInBaseUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

&AtClient
Procedure ItemListQuantityIsFixedOnChange(Item)
	DocItemStockAdjustmentClient.ItemListQuantityIsFixedOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocItemStockAdjustmentClient);
	Str.Insert("Server", DocItemStockAdjustmentServer);
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

#Region COPY_PASTE

//@skip-check module-unused-method
&AtClient
Procedure CopyToClipboard(Command)
	CopyPasteClient.CopyToClipboard(Object, ThisObject);
EndProcedure

&AtClient
Procedure CopyToClipboardAfterSetSettings(CopySettings, AddInfo) Export
	If CopySettings = Undefined Then
		Return;
	EndIf;
	
	CopyPasteResult = CopyToClipboardServer(CopySettings);
	CopyPasteClient.AfterCopy(CopyPasteResult);
EndProcedure

&AtServer
Function CopyToClipboardServer(CopySettings)
	Return CopyPasteServer.CopyToClipboard(Object, ThisObject, CopySettings);
EndFunction

//@skip-check module-unused-method
&AtClient
Procedure PasteFromClipboard(Command)
	CopyPasteClient.PasteFromClipboard(Object, ThisObject);
EndProcedure

&AtClient
Procedure PasteFromClipboardAfterSetSettings(PasteSettings, AddInfo) Export
	If PasteSettings = Undefined Then
		Return;
	EndIf;
	
	CopyPasteResult = PasteFromClipboardServer(PasteSettings);
	CopyPasteClient.AfterPaste(Object, ThisObject,CopyPasteResult);
EndProcedure

&AtServer
Function PasteFromClipboardServer(CopySettings)
	Return CopyPasteServer.PasteFromClipboard(Object, ThisObject, CopySettings);
EndFunction

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
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure OpenScanForm(Command)
	DocumentsClient.OpenScanForm(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure EditQuantityInBaseUnit(Command)
	Items.ItemListQuantityInBaseUnit.Visible = Not Items.ItemListQuantityInBaseUnit.Visible;
	Items.ItemListQuantityIsFixed.Visible = Not Items.ItemListQuantityIsFixed.Visible;	 	
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure SetNewNumber(Command)
	SetNewNumberAtServer();
EndProcedure

&AtServer
Procedure SetNewNumberAtServer()
	If Object.NumeratorRules.IsEmpty() Then
		Object.NumeratorRules = 
			NumberingRulesServer.GetNumeratorGroupForDocument(Object.Ref.Metadata().FullName(), Object.Date);
	EndIf;
	NumberingRulesServer.SetSourceNewNumber(Object);
EndProcedure

#EndRegion
