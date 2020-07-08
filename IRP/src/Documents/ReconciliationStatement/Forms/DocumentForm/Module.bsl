#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocReconciliationStatementServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetConditionalAppearance();
	DocReconciliationStatementServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocReconciliationStatementServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocumentsClient.SetTextOfDescriptionAtForm(Object, ThisObject);
EndProcedure

#EndRegion

&AtServer
Procedure SetConditionalAppearance() Export
	ConditionalAppearance.Items.Clear();
	
	Arr = New Array();
	Arr.Add("OpeningBalanceDebit");
	Arr.Add("OpeningBalanceCredit");
	Arr.Add("ClosingBalanceDebit");
	Arr.Add("ClosingBalanceCredit");
	
	For Each ItemName In Arr Do
		// >0
		AppearanceElement = ConditionalAppearance.Items.Add();
		
		FieldElement = AppearanceElement.Fields.Items.Add();
		FieldElement.Field = New DataCompositionField(ItemName);
		
		FilterElement = AppearanceElement.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterElement.LeftValue = New DataCompositionField("Object." + ItemName);
		FilterElement.ComparisonType = DataCompositionComparisonType.Greater;
		FilterElement.RightValue = 0;
		
		AppearanceElement.Appearance.SetParameterValue("TextColor", WebColors.Green);
		
		// <0
		AppearanceElement = ConditionalAppearance.Items.Add();
		
		FieldElement = AppearanceElement.Fields.Items.Add();
		FieldElement.Field = New DataCompositionField(ItemName);
		
		FilterElement = AppearanceElement.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterElement.LeftValue = New DataCompositionField("Object." + ItemName);
		FilterElement.ComparisonType = DataCompositionComparisonType.Less;
		FilterElement.RightValue = 0;
		
		AppearanceElement.Appearance.SetParameterValue("TextColor", WebColors.Red);
	EndDo;
	
EndProcedure

&AtClient
Procedure Fill(Command)
	If CheckFilling() Then
		FillAtServer();
	EndIf;
EndProcedure

&AtServer
Procedure FillAtServer()
	Query = New Query();
	Query.Text =
		"SELECT
		|	ReconciliationStatementBalance.AmountBalance AS OpeningBalance
		|FROM
		|	AccumulationRegister.ReconciliationStatement.Balance(BEGINOFPERIOD(&StartDate, DAY), Company = &Company
		|	AND LegalName = &LegalName
		|	AND Currency = &Currency) AS ReconciliationStatementBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ReconciliationStatementBalance.AmountBalance AS ClosingBalance
		|FROM
		|	AccumulationRegister.ReconciliationStatement.Balance(ENDOFPERIOD(&EndDate, DAY), Company = &Company
		|	AND LegalName = &LegalName
		|	AND Currency = &Currency) AS ReconciliationStatementBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ReconciliationStatementTurnovers.Period AS Date,
		|	ReconciliationStatementTurnovers.Recorder AS Document,
		|	ReconciliationStatementTurnovers.AmountReceipt AS Debit,
		|	ReconciliationStatementTurnovers.AmountExpense AS Credit
		|FROM
		|	AccumulationRegister.ReconciliationStatement.Turnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY),
		|		Recorder, Company = &Company
		|	AND LegalName = &LegalName
		|	AND Currency = &Currency) AS ReconciliationStatementTurnovers";
	Query.SetParameter("StartDate", Object.BeginPeriod);
	Query.SetParameter("EndDate", Object.EndPeriod);
	Query.SetParameter("Company", Object.Company);
	Query.SetParameter("LegalName", Object.LegalName);
	Query.SetParameter("Currency", Object.Currency);
	
	ArrayOfResults = Query.ExecuteBatch();
	OpeningBalance = 0;
	QuerySelection = ArrayOfResults[0].Select();
	If QuerySelection.Next() Then
		OpeningBalance = QuerySelection.OpeningBalance;
	EndIf;
	If OpeningBalance > 0 Then
		Object.OpeningBalanceDebit = OpeningBalance;
		Object.OpeningBalanceCredit = 0;
	Else
		Object.OpeningBalanceCredit = - OpeningBalance;
		Object.OpeningBalanceDebit = 0;
	EndIf;
	
	ClosingBalance = 0;
	QuerySelection = ArrayOfResults[1].Select();
	If QuerySelection.Next() Then
		ClosingBalance = QuerySelection.ClosingBalance;
	EndIf;
	If ClosingBalance > 0 Then
		Object.ClosingBalanceDebit = ClosingBalance;
		Object.ClosingBalanceCredit = 0;
	Else
		Object.ClosingBalanceCredit = - ClosingBalance;
		Object.ClosingBalanceDebit = 0;
	EndIf;
	
	Object.Transactions.Clear();
	QuerySelection = ArrayOfResults[2].Select();
	While QuerySelection.Next() Do
		FillPropertyValues(Object.Transactions.Add(), QuerySelection);
	EndDo;
	
	DocReconciliationStatementServer.SetVisibility(Object, ThisObject);
EndProcedure

&AtClient
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocReconciliationStatementClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocReconciliationStatementClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocReconciliationStatementClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocReconciliationStatementClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocReconciliationStatementClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocReconciliationStatementClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocReconciliationStatementClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocReconciliationStatementClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Commands

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
Procedure PartnerOnChange(Item)
	DocReconciliationStatementClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameOnChange(Item)
	DocReconciliationStatementClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocReconciliationStatementClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocReconciliationStatementClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion