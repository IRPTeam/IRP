
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocProductionServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.ProductionPlanningClosing = DocProductionPlanningClosingServer.GetProductionPlanningColosing(CurrentObject.ProductionPlanning);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocProductionServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocProductionServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocProductionClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
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
	DocProductionClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsFilled_ProductionPlanningClosing = ValueIsFilled(Form.ProductionPlanningClosing);
	
	Form.ReadOnly = IsFilled_ProductionPlanningClosing;
	Form.Items.GroupHead.Visible = IsFilled_ProductionPlanningClosing;
	
	_Semiproduct = PredefinedValue("Enum.MaterialTypes.Semiproduct");
	_Material    = PredefinedValue("Enum.MaterialTypes.Material");
	_Service     = PredefinedValue("Enum.MaterialTypes.Service");
	
	For Each Row In Object.Materials Do
		If Not CommonFunctionsClientServer.ObjectHasProperty(Row, "Picture") Then
			Continue;
		EndIf;
		If Row.MaterialType = _Semiproduct Then
			Row.Picture = 2;
		ElsIf Row.MaterialType = _Material Then
			Row.Picture = 3;
		ElsIf Row.MaterialType = _Service Then
			Row.Picture = 1;
		Else
			Row.Picture = -1;
		EndIf;
	EndDo;
	
	isProduce = (Object.TransactionType = PredefinedValue("Enum.ProductionTransactionTypes.Produce"));
	
	Form.Items.PlanningPeriod.Visible = isProduce;
	Form.Items.PlanningPeriodStartDate.Visible = isProduce;
	Form.Items.PlanningPeriodEndDate.Visible   = isProduce;
	Form.Items.ProductionPlanning.Visible      = isProduce;

	Form.Items.BillOfMaterials.Visible           = isProduce;
	Form.Items.DurationOfProduction.Visible      = isProduce;
	Form.Items.ExtraCostAmountByRatio.Visible    = isProduce;
	Form.Items.ExtraCostTaxAmountByRatio.Visible = isProduce;
	
	Form.Items.ExtraDirectCostAmount.Visible    = isProduce;
	Form.Items.ExtraDirectCostTaxAmount.Visible = isProduce;

	Form.Items.MaterialsItemBOM.Visible     = isProduce;
	Form.Items.MaterialsItemKeyBOM.Visible  = isProduce;
	Form.Items.MaterialsUnitBOM.Visible     = isProduce;
	Form.Items.MaterialsQuantityBOM.Visible = isProduce;
	
	Form.Items.MaterialsUpdateByBillOfMaterials.Visible = isProduce;
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

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocProductionClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocProductionClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocProductionClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocProductionClient.TransactionTypeOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region BUSINESS_UNIT

&AtClient
Procedure BusinessUnitOnChange(Item)
	DocProductionClient.BusinessUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PLANNING_PERIOD

&AtClient
Procedure PlanningPeriodOnChange(Item)
	DocProductionClient.PlanningPeriodOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region _ITEM

&AtClient
Procedure ItemOnChange(Item)
	DocProductionClient.ItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemEditTextChange(Item, Text, StandardProcessing)
	DocProductionClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ItemKeyOnChange(Item)
	DocProductionClient.ItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region STORE_PRODUCTION

&AtClient
Procedure StoreProductionOnChange(Item)
	DocProductionClient.StoreProductionOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure QuantityOnChange(Item)
	DocProductionClient.QuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure UnitOnChange(Item)
	DocProductionClient.UnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

&AtClient
Procedure BillOfMaterialsOnChange(Item)
	DocProductionClient.BillOfMaterialsOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region MATERIALS

&AtClient
Procedure MaterialsSelection(Item, RowSelected, Field, StandardProcessing)
	DocProductionClient.MaterialsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure MaterialsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocProductionClient.MaterialsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure MaterialsBeforeDeleteRow(Item, Cancel)
	DocProductionClient.MaterialsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure MaterialsAfterDeleteRow(Item)
	DocProductionClient.MaterialsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region MATERIALS_COLUMNS

#Region MATERIALS_ITEM

&AtClient
Procedure MaterialsItemOnChange(Item)
	DocProductionClient.MaterialsItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure MaterialsItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionClient.MaterialsItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure MaterialsItemEditTextChange(Item, Text, StandardProcessing)
	DocProductionClient.MaterialsItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region MATERIALS_ITEM_KEY

&AtClient
Procedure MaterialsItemKeyOnChange(Item)
	DocProductionClient.MaterialsItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region MATERIALS_UNIT

&AtClient
Procedure MaterialsUnitOnChange(Item)
	DocProductionClient.MaterialsUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region MATERIALS_QUANTITY

&AtClient
Procedure MaterialsQuantityOnChange(Item)
	DocProductionClient.MaterialsQuantityOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region MATERIALS_MATERIALS_TYPE

&AtClient
Procedure MaterialsMaterialTypeOnChange(Item)
	DocProductionClient.MaterialsMaterialTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocProductionClient);
	Str.Insert("Server", DocProductionServer);
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
Procedure GroupTitleCollapsedClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure GroupTitleUncollapsedClick(Item)
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

&AtClient
Procedure UpdateByBillOfMaterials(Command)
	DocProductionClient.UpdateByBillOfMaterials(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion
