// @strict-types

#Region Form

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.Currency = Parameters.Currency;
	ThisObject.Store = Parameters.Store;
	ThisObject.Workstation = Parameters.Workstation;
	ThisObject.ConsolidatedRetailSales = Parameters.ConsolidatedRetailSales; 
	
	CRS_Attributes = CommonFunctionsServer.GetAttributesFromRef(
			ThisObject.ConsolidatedRetailSales, "Company, Branch, CashAccount, OpeningDate");
	FillPropertyValues(ThisObject, CRS_Attributes);
	
	LoadSessionData();
	
	ThisObject.Items.ClosingPages.PagesRepresentation = FormPagesRepresentation.None;
	SetCurrentPage();
	
EndProcedure

&AtServer
Procedure LoadSessionData()
	
	SetExistingWarningDocuments();
	ReadCashOperations();
	ReadTerminalOperations();
	ReadBalanceData();
	
EndProcedure

&AtServer
Procedure SetCurrentPage()

	If WarningDocumentsAreExisted Then
		ChangePage(ThisObject.Items.WarningsPage, ThisObject);
		Return; 
	EndIf;
	
	areAmountsEqual = True;
	For Each TableItem In CashTable Do
		If Not TableItem.AmountInBase = TableItem.AmountInRegister Then
			areAmountsEqual = False;
			Break;
		EndIf;
	EndDo;
	If Not areAmountsEqual And Not CashConfirm Then
		ChangePage(ThisObject.Items.CashboxesPage, ThisObject);
		Return;
	EndIf;
	
	areAmountsEqual = True;
	For Each TableItem In TerminalTable Do
		If Not TableItem.AmountInBase = TableItem.AmountInTerminal Then
			areAmountsEqual = False;
			Break;
		EndIf;
	EndDo;
	If Not areAmountsEqual And Not TerminalConfirm Then
		ChangePage(ThisObject.Items.TerminalsPage, ThisObject);
		Return;
	EndIf;
	
	If Not BalanceEnd = BalanceReal And Not BalanceConfirm Then
		ChangePage(ThisObject.Items.BalancePage, ThisObject);
		Return;
	EndIf;
	
	ChangePage(ThisObject.Items.FinishPage, ThisObject);

EndProcedure

&AtClient
Procedure PreviousPage(Command)
	
	If ThisObject.Items.ClosingPages.CurrentPage = ThisObject.Items.FinishPage Then
		ChangePage(ThisObject.Items.BalancePage, ThisObject);
	ElsIf ThisObject.Items.ClosingPages.CurrentPage = ThisObject.Items.BalancePage Then
		ChangePage(ThisObject.Items.TerminalsPage, ThisObject);
	ElsIf ThisObject.Items.ClosingPages.CurrentPage = ThisObject.Items.TerminalsPage Then
		ChangePage(ThisObject.Items.CashboxesPage, ThisObject);
	EndIf;
	
EndProcedure

// Change page.
// 
// Parameters:
//  Page - FormGroup - Page
//  Form - ClientApplicationForm - Form
&AtClientAtServerNoContext
Procedure ChangePage(Page, Form)
	Form.Items.ClosingPages.CurrentPage = Page;
	Form.Title = Page.Title;
EndProcedure
	
&AtClient
Procedure CloseSession(Command)
	Close(DialogReturnCode.OK);
EndProcedure

#EndRegion

#Region Warnings

// Set existing warning documents.
&AtServer
Procedure SetExistingWarningDocuments()
	ThisObject.ListOfWarningDocuments.Parameters.SetParameterValue(
			"ConsolidatedRetailSales", ThisObject.ConsolidatedRetailSales);
	ThisObject.Items.ListOfWarningDocuments.Refresh();

	Query = New Query;
	Query.Text = ThisObject.ListOfWarningDocuments.QueryText;
	Query.SetParameter("ConsolidatedRetailSales", ThisObject.ConsolidatedRetailSales);
	WarningDocumentsAreExisted = Not Query.Execute().IsEmpty();
EndProcedure

&AtClient
Procedure DeleteDoc(Command)
	CurrentRow = Items.ListOfWarningDocuments.CurrentRow; // DocumentRef
	If Not CurrentRow = Undefined Then
		DeleteDocAtServer(CurrentRow);
	EndIf;
EndProcedure

// Delete doc at server.
// 
// Parameters:
//  DocumentRef - DocumentRef
&AtServer
Procedure DeleteDocAtServer(DocumentRef)
	DocumentObject = DocumentRef.GetObject();
	DocumentObject.SetDeletionMark(True);
	
	LoadSessionData();
	SetCurrentPage();
EndProcedure

&AtClient
Procedure EditDoc(Command)
	CurrentRow = Items.ListOfWarningDocuments.CurrentRow;
	
	Notify = New NotifyDescription("EditDocFinish", ThisObject);
	If TypeOf(CurrentRow) = Type("DocumentRef.RetailSalesReceipt") Then
		OpenForm("Document.RetailSalesReceipt.Form.DocumentForm", 
			New Structure("Key", CurrentRow), 
			ThisObject,
			UUID,,,
			Notify,
			FormWindowOpeningMode.LockWholeInterface);
	ElsIf TypeOf(CurrentRow) = Type("DocumentRef.RetailReturnReceipt") Then
		OpenForm("Document.RetailReturnReceipt.Form.DocumentForm", 
			New Structure("Key", CurrentRow), 
			ThisObject,
			UUID,,,
			Notify,
			FormWindowOpeningMode.LockWholeInterface);
	EndIf;
EndProcedure

// Edit document finish.
// 
// Parameters:
//  Result - Undefined
//  AddInfo - Undefined
&AtClient
Procedure EditDocFinish(Result, AddInfo) Export
	LoadSessionData();
	SetCurrentPage();
EndProcedure

#EndRegion

#Region CashBox

&AtServer
Procedure ReadCashOperations()
	CashTable.Clear();
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.Ref,
	|	TRUE AS Sales
	|INTO tmpRefs
	|FROM
	|	Document.RetailSalesReceipt AS RetailSalesReceipt
	|WHERE
	|	RetailSalesReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|
	|UNION ALL
	|
	|SELECT
	|	RetailReturnReceipt.Ref,
	|	FALSE AS Sales
	|FROM
	|	Document.RetailReturnReceipt AS RetailReturnReceipt
	|WHERE
	|	RetailReturnReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PaymentTypes.Ref
	|INTO tmpCashTypes
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	PaymentTypes.Type = VALUE(Enum.PaymentTypes.Cash)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRefs.Sales AS Sales,
	|	R3050T_PosCashBalancesTurnovers.PaymentType AS PaymentType,
	|	SUM(CASE
	|		WHEN tmpRefs.Sales
	|			THEN R3050T_PosCashBalancesTurnovers.AmountTurnover
	|		ELSE -R3050T_PosCashBalancesTurnovers.AmountTurnover
	|	END) AS Amount
	|FROM
	|	tmpRefs AS tmpRefs
	|		INNER JOIN AccumulationRegister.R3050T_PosCashBalances.Turnovers(,, Recorder, Company = &Company
	|		AND Branch = &Branch
	|		AND PaymentType IN
	|			(SELECT
	|				tmpCashTypes.Ref
	|			FROM
	|				tmpCashTypes)) AS R3050T_PosCashBalancesTurnovers
	|		ON tmpRefs.Ref = R3050T_PosCashBalancesTurnovers.Recorder
	|GROUP BY
	|	tmpRefs.Sales,
	|	R3050T_PosCashBalancesTurnovers.PaymentType
	|
	|ORDER BY
	|	Sales DESC,
	|	PaymentType";
	
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Branch", ThisObject.Branch);
	Query.SetParameter("ConsolidatedRetailSales", ThisObject.ConsolidatedRetailSales);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		Record = CashTable.Add();
		Record.Operation = ?(QuerySelection.Sales, R().InfoMessage_Sales, R().InfoMessage_Returns);
		Record.PaymentType = QuerySelection.PaymentType;
		Record.AmountInBase = QuerySelection.Amount; 
	EndDo;
	
EndProcedure

&AtClient
Procedure CashTableAmountInRegisterOnChange(Item)
	SetCurrentPage();
EndProcedure

&AtClient
Procedure CashConfirmOnChange(Item)
	SetCurrentPage();
EndProcedure

#EndRegion

#Region Terminals

Procedure ReadTerminalOperations()
	TerminalTable.Clear();
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.Ref,
	|	TRUE AS Sales
	|INTO tmpRefs
	|FROM
	|	Document.RetailSalesReceipt AS RetailSalesReceipt
	|WHERE
	|	RetailSalesReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|
	|UNION ALL
	|
	|SELECT
	|	RetailReturnReceipt.Ref,
	|	FALSE AS Sales
	|FROM
	|	Document.RetailReturnReceipt AS RetailReturnReceipt
	|WHERE
	|	RetailReturnReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PaymentTypes.Ref
	|INTO tmpCardTypes
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	PaymentTypes.Type = VALUE(Enum.PaymentTypes.Card)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRefs.Sales AS Sales,
	|	R3050T_PosCashBalancesTurnovers.PaymentType AS PaymentType,
	|	R3050T_PosCashBalancesTurnovers.PaymentTerminal AS PaymentTerminal,
	|	SUM(CASE
	|		WHEN tmpRefs.Sales
	|			THEN R3050T_PosCashBalancesTurnovers.AmountTurnover
	|		ELSE -R3050T_PosCashBalancesTurnovers.AmountTurnover
	|	END) AS Amount
	|FROM
	|	tmpRefs AS tmpRefs
	|		INNER JOIN AccumulationRegister.R3050T_PosCashBalances.Turnovers(,, Recorder, Company = &Company
	|		AND Branch = &Branch
	|		AND PaymentType IN
	|			(SELECT
	|				tmpCardTypes.Ref
	|			FROM
	|				tmpCardTypes)) AS R3050T_PosCashBalancesTurnovers
	|		ON tmpRefs.Ref = R3050T_PosCashBalancesTurnovers.Recorder
	|GROUP BY
	|	tmpRefs.Sales,
	|	R3050T_PosCashBalancesTurnovers.PaymentType,
	|	R3050T_PosCashBalancesTurnovers.PaymentTerminal
	|
	|ORDER BY
	|	Sales DESC,
	|	PaymentTerminal,
	|	PaymentType";
	
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Branch", ThisObject.Branch);
	Query.SetParameter("ConsolidatedRetailSales", ThisObject.ConsolidatedRetailSales);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		Record = TerminalTable.Add();
		Record.Operation = ?(QuerySelection.Sales, R().InfoMessage_Sales, R().InfoMessage_Returns);
		Record.PaymentType = QuerySelection.PaymentType;
		Record.PaymentTerminal = QuerySelection.PaymentType;
		Record.AmountInBase = QuerySelection.Amount; 
	EndDo;
	
EndProcedure

&AtClient
Procedure TerminalTableAmountInTerminalOnChange(Item)
	SetCurrentPage();
EndProcedure

&AtClient
Procedure TerminalConfirmOnChange(Item)
	SetCurrentPage();
EndProcedure

#EndRegion

#Region Balance

&AtServer
Procedure ReadBalanceData()

	Query = New Query;
	Query.Text =
	"SELECT
	|	R3010B_CashOnHandBalanceAndTurnovers.Currency,
	|	R3010B_CashOnHandBalanceAndTurnovers.AmountOpeningBalance,
	|	R3010B_CashOnHandBalanceAndTurnovers.AmountReceipt,
	|	R3010B_CashOnHandBalanceAndTurnovers.AmountExpense,
	|	R3010B_CashOnHandBalanceAndTurnovers.AmountClosingBalance
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.BalanceAndTurnovers(&OpeningDate,,,, Company = &Company
	|	AND Branch = &Branch
	|	AND Account = &Account
	|	AND Currency = &Currency
	|	AND CurrencyMovementType = &CurrencyMovementType) AS R3010B_CashOnHandBalanceAndTurnovers";
	
	Query.SetParameter("OpeningDate", ThisObject.OpeningDate);
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Branch", ThisObject.Branch);
	Query.SetParameter("Account", ThisObject.CashAccount);
	Query.SetParameter("Currency", ThisObject.Currency);
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		ThisObject.BalanceBegin = QuerySelection.AmountOpeningBalance;
		ThisObject.BalanceCashIn = QuerySelection.AmountReceipt;
		ThisObject.BalanceCashOut = QuerySelection.AmountExpense;
		ThisObject.BalanceEnd = QuerySelection.AmountClosingBalance; 
	EndIf;
	
EndProcedure	

&AtClient
Procedure BalanceRealOnChange(Item)
	SetCurrentPage();
EndProcedure

&AtClient
Procedure BalanceConfirmOnChange(Item)
	SetCurrentPage();
EndProcedure

#EndRegion
