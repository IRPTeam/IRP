#Region FormEventHandlers

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocFixedAssetRevaluationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocFixedAssetRevaluationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocFixedAssetRevaluationClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure CalculationsFixedAssetOnChange(Item)
	CurrentId = Items.Calculations.CurrentRow;
	CalculationsFixedAssetOnChangeAtServer(CurrentId);	
EndProcedure

&AtServer
Procedure CalculationsFixedAssetOnChangeAtServer(ID)
	CurrentData = Object.Calculations.FindByID(ID);
	DataTable = Documents.FixedAssetRevaluation.GetCalculations(
		Object.Ref,
		Object.Date,
		Object.Company,
		Object.Branch,
		CurrentData.FixedAsset);
	If DataTable.Count() > 0 Then
		PropertyString = "ProfitLossCenter, LedgerType, Schedule, CalculationMethod, Currency, ExpenseType, AmountBalance, Amount, NewAmountBalance";
		FillPropertyValues(CurrentData, DataTable[0], PropertyString);
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
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
EndProcedure

&AtClient
Procedure EditCurrencies(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V7(Object, Undefined, 
		CurrenciesServer.GetLandedCostCurrency(Object.Company), 0);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New CallbackDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure SetNewNumber(Command)
	SetNewNumberAtServer();
EndProcedure

&AtServer
Procedure SetNewNumberAtServer()
	If Object.NumeratorRules.IsEmpty() Then
		Object.NumeratorRules = 
			NumberingRulesServer.GetNumeratorGroupForDocument(Object.Ref.Metadata().FullName(), Object);
	EndIf;
	NumberingRulesServer.SetSourceNewNumber(Object);
EndProcedure

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
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure FillCalculations(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	FillCalculationsAtServer();
EndProcedure

&AtServer
Procedure FillCalculationsAtServer()
	Object.Calculations.Load(
		Documents.FixedAssetRevaluation.GetCalculations(Object.Ref, Object.Date, Object.Company, Object.Branch));
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.Calculations.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "Calculations");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, "Calculations");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
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

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocFixedAssetRevaluationClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocFixedAssetRevaluationClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocFixedAssetRevaluationClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocFixedAssetRevaluationClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region CALCULATIONS

&AtClient
Procedure CalculationsAfterDeleteRow(Item)
	DocFixedAssetRevaluationClient.CalculationsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CalculationsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocFixedAssetRevaluationClient.CalculationsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter)
EndProcedure

&AtClient
Procedure CalculationsSelection(Item, RowSelected, Field, StandardProcessing)
	DocFixedAssetRevaluationClient.CalculationsSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure CalculationsBeforeDeleteRow(Item, Cancel)
	DocFixedAssetRevaluationClient.CalculationsBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure CalculationsNewAmountBalanceOnChange(Item)
	DocFixedAssetRevaluationClient.CalculationsNewAmountBalanceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CalculationsAmountOnChange(Item)
	DocFixedAssetRevaluationClient.CalculationsAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion