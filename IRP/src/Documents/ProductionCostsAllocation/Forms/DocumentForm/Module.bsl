
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocProductionCostsAllocationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocProductionCostsAllocationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	SetVisibilityAvailability(CurrentObject, ThisObject);
	DocProductionCostsAllocationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocProductionCostsAllocationClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	DocProductionCostsAllocationClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Return;
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocProductionCostsAllocationClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionCostsAllocationClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocProductionCostsAllocationClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region BEGIN_DATE

&AtClient
Procedure BeginDateOnChange(Item)
	DocProductionCostsAllocationClient.BeginDateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region END_DATE

&AtClient
Procedure EndDateOnChange(Item)
	DocProductionCostsAllocationClient.EndDateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PRODUCTION_DURATIONS_LIST

&AtClient
Procedure ProductionDurationsListSelection(Item, RowSelected, Field, StandardProcessing)
	DocProductionCostsAllocationClient.ProductionDurationsListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionDurationsListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocProductionCostsAllocationClient.ProductionDurationsListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ProductionDurationsListBeforeDeleteRow(Item, Cancel)
	DocProductionCostsAllocationClient.ProductionDurationsListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ProductionDurationsListAfterDeleteRow(Item)
	DocProductionCostsAllocationClient.ProductionDurationsListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region PRODUCTION_DURATIONS_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ProductionDurationsListItemOnChange(Item)
	DocProductionCostsAllocationClient.ProductionDurationsListItemOnChange(Object, ThisObject);
EndProcedure

&AtClient
Procedure ProductionDurationsListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionCostsAllocationClient.ProductionDurationsListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionDurationsListItemEditTextChange(Item, Text, StandardProcessing)
	DocProductionCostsAllocationClient.ProductionDurationsListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure ProductionDurationsListItemKeyOnChange(Item)
	DocProductionCostsAllocationClient.ProductionDurationsListItemKeyOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region DURATION

&AtClient
Procedure ProductionDurationsListDurationOnChange(Item)
	DocProductionCostsAllocationClient.ProductionDurationsListDurationOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region AMOUNT

&AtClient
Procedure ProductionDurationsListAmountOnChange(Item)
	DocProductionCostsAllocationClient.ProductionDurationsListAmountOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region PRODUCTION_COSTS_LIST

&AtClient
Procedure ProductionCostsListSelection(Item, RowSelected, Field, StandardProcessing)
	DocProductionCostsAllocationClient.ProductionCostsListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionCostsListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocProductionCostsAllocationClient.ProductionCostsListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ProductionCostsListBeforeDeleteRow(Item, Cancel)
	DocProductionCostsAllocationClient.ProductionCostsListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure ProductionCostsListAfterDeleteRow(Item)
	DocProductionCostsAllocationClient.ProductionCostsListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region PRODUCTION_COSTS_LIST_COLUMNS

#Region EXPENSE_TYPE

&AtClient
Procedure ProductionCostsListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocProductionCostsAllocationClient.ProductionCostsListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ProductionCostsListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocProductionCostsAllocationClient.ProductionCostsListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AMOUNT

&AtClient
Procedure ProductionCostsListAmountOnChange(Item)
	DocProductionCostsAllocationClient.ProductionCostsListAmountOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocStockAdjustmentAsSurplusClient);
	Str.Insert("Server", DocStockAdjustmentAsSurplusServer);
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

#Region ADD_ATRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
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
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure FillCosts(Command)
	Result = FillCostsAtServer();
	Object.ProductionCostsList.Clear();	
	ViewClient_V2.ProductionCostsListLoad(Object, ThisObject, Result.Address, Result.GroupColumn, Result.SumColumn);
EndProcedure

&AtServer
Function FillCostsAtServer()
	QueryParameters = New Structure();
	QueryParameters.Insert("Company"   , Object.Company);
	QueryParameters.Insert("BeginDate" , Object.BeginDate);
	QueryParameters.Insert("EndDate"   , Object.EndDate);
	
	CostsTable = DocProductionCostsAllocationServer.GetCosts(QueryParameters);
	Address = PutToTempStorage(CostsTable, ThisObject.UUID);
	GroupColumn = "ProfitLossCenter, ExpenseType, Currency";
	SumColumn = "Amount";
	Return New Structure("Address, GroupColumn, SumColumn", Address, GroupColumn, SumColumn);
EndFunction

&AtClient
Procedure FillDurations(Command)
	Result = FillDurationsAtServer();
	Object.ProductionDurationsList.Clear();
	ViewClient_V2.ProductionDurationsListLoad(Object, ThisObject, Result.Address, Result.GroupColumn, Result.SumColumn);	
EndProcedure

&AtServer
Function FillDurationsAtServer()
	QueryParameters = New Structure();
	QueryParameters.Insert("Company"   , Object.Company);
	QueryParameters.Insert("BeginDate" , Object.BeginDate);
	QueryParameters.Insert("EndDate"   , Object.EndDate);
	
	CostsTable = DocProductionCostsAllocationServer.GetDurations(QueryParameters);
	Address = PutToTempStorage(CostsTable, ThisObject.UUID);
	GroupColumn = "BusinessUnit, Item, ItemKey";
	SumColumn = "Duration";
	Return New Structure("Address, GroupColumn, SumColumn", Address, GroupColumn, SumColumn);
EndFunction

&AtClient
Procedure AllocateAmounts(Command)
	AllocateAmountsAtServer();
EndProcedure

&AtServer
Procedure AllocateAmountsAtServer()
	TotalAmount = Object.ProductionCostsList.Total("Amount");
	TotalDuration = Object.ProductionDurationsList.Total("Duration");
	
	CostOneHour = 0;
	If TotalDuration <> 0 Then
		CostOneHour = Round(TotalAmount / TotalDuration, 2, RoundMode.Round15as10);
	EndIf;
	
	MaxRow = Undefined;
	For Each Row In Object.ProductionDurationsList Do
		If MaxRow = Undefined Then
			MaxRow = Row;
		Else
			If MaxRow.Duration < Row.Duration Then
				MaxRow = Row;
			EndIf;
		EndIf;
			
		Row.Amount = Row.Duration * CostOneHour;
	EndDo;	
	
	TotalAllocatedAmount = Object.ProductionDurationsList.Total("Amount");
	
	If TotalAmount <> TotalAllocatedAmount Then
		MaxRow.Amount = MaxRow.Amount + (TotalAmount - TotalAllocatedAmount);
	EndIf;
EndProcedure

#EndRegion
