// @strict-types

#Region Form

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.Currency = Parameters.Currency;
	ThisObject.Store = Parameters.Store;
	ThisObject.Workstation = Parameters.Workstation;
	ThisObject.ConsolidatedRetailSales = Parameters.ConsolidatedRetailSales;
	ThisObject.AutoCreateMoneyTransfer = Parameters.AutoCreateMoneyTransfer; 
	
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
	
	If Not (BalanceEnd = BalanceReal And 
				BalanceCashIn = BalanceRealIn And 
				BalanceCashOut = BalanceRealOut) And 
			Not BalanceConfirm Then
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

&AtClient
Procedure ToCurrent(Command)
	SetCurrentPage();
EndProcedure

// Change page.
// 
// Parameters:
//  Page - FormGroup - Page
//  Form - ClientApplicationForm - Form
&AtClientAtServerNoContext
Procedure ChangePage(Page, Form)
	//@skip-check property-return-type
	Form.Items.ClosingPages.CurrentPage = Page;
	Form.Title = Page.Title;
EndProcedure
	
&AtClient
Procedure CloseSession(Command)
	ClosingData = New Structure;
	
	ClosingData.Insert("BalanceConfirm", ThisObject.BalanceConfirm);
	ClosingData.Insert("CashConfirm", ThisObject.CashConfirm);
	ClosingData.Insert("TerminalConfirm", ThisObject.TerminalConfirm);
	
	ClosingData.Insert("BalanceCashIn", ThisObject.BalanceCashIn);
	ClosingData.Insert("BalanceRealIn", ThisObject.BalanceRealIn);
	ClosingData.Insert("BalanceCashOut", ThisObject.BalanceCashOut);
	ClosingData.Insert("BalanceRealOut", ThisObject.BalanceRealOut);
	ClosingData.Insert("BalanceEnd", ThisObject.BalanceEnd);
	ClosingData.Insert("BalanceReal", ThisObject.BalanceReal);
	
	ClosingData.Insert("AutoCreateMoneyTransfer", ThisObject.AutoCreateMoneyTransfer);
	
	PaymentList = New Array(); // Array of Structure
	For Each TableItem In ThisObject.CashTable Do
		ItemStructure = New Structure;
		ItemStructure.Insert("isReturn", TableItem.isReturn);
		ItemStructure.Insert("PaymentType", TableItem.PaymentType);
		ItemStructure.Insert("Amount", TableItem.AmountInBase);
		ItemStructure.Insert("RealAmount", TableItem.AmountInRegister);
		PaymentList.Add(ItemStructure);
	EndDo;
	For Each TableItem In ThisObject.TerminalTable Do
		ItemStructure = New Structure;
		ItemStructure.Insert("isReturn", TableItem.isReturn);
		ItemStructure.Insert("PaymentType", TableItem.PaymentType);
		ItemStructure.Insert("PaymentTerminal", TableItem.PaymentTerminal);
		ItemStructure.Insert("Amount", TableItem.AmountInBase);
		ItemStructure.Insert("RealAmount", TableItem.AmountInTerminal);
		PaymentList.Add(ItemStructure);
	EndDo; 
	ClosingData.Insert("PaymentList", PaymentList);
	
	Close(ClosingData);
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
	
	QuerySelection = GetCurrentCashOperations();
	While QuerySelection.Next() Do
		Record = CashTable.Add();
		Record.isReturn = QuerySelection.isReturn;
		//@skip-check statement-type-change
		//@skip-check property-return-type
		Record.Operation = ?(QuerySelection.isReturn, R().InfoMessage_Returns, R().InfoMessage_Sales);
		Record.PaymentType = QuerySelection.PaymentType;
		Record.AmountInBase = QuerySelection.Amount; 
	EndDo;
	
EndProcedure

// Get current cash operations.
// 
// Returns:
//  QueryResultSelection - Get current cash operations:
//  * isReturn - Boolean
//  * PaymentType - CatalogRef.PaymentTypes
//  * Amount - Number
&AtServer
Function GetCurrentCashOperations()
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.Ref,
	|	FALSE AS isReturn
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
	|	TRUE AS isReturn
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
	|	tmpRefs.isReturn AS isReturn,
	|	R3050T_PosCashBalancesTurnovers.PaymentType AS PaymentType,
	|	SUM(CASE
	|		WHEN tmpRefs.isReturn
	|			THEN -R3050T_PosCashBalancesTurnovers.AmountTurnover
	|		ELSE R3050T_PosCashBalancesTurnovers.AmountTurnover
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
	|	tmpRefs.isReturn,
	|	R3050T_PosCashBalancesTurnovers.PaymentType
	|
	|ORDER BY
	|	isReturn,
	|	PaymentType";
	
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Branch", ThisObject.Branch);
	Query.SetParameter("ConsolidatedRetailSales", ThisObject.ConsolidatedRetailSales);
	
	QuerySelection = Query.Execute().Select();
	Return QuerySelection
EndFunction

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

&AtServer
Procedure ReadTerminalOperations()
	TerminalTable.Clear();
	
	QuerySelection = GetCurrentTerminalOperations();
	While QuerySelection.Next() Do
		Record = TerminalTable.Add();
		Record.isReturn = QuerySelection.isReturn;
		//@skip-check statement-type-change
		//@skip-check property-return-type
		Record.Operation = ?(QuerySelection.isReturn, R().InfoMessage_Returns, R().InfoMessage_Sales);
		Record.PaymentType = QuerySelection.PaymentType;
		Record.PaymentTerminal = QuerySelection.PaymentTerminal;
		Record.AmountInBase = QuerySelection.Amount; 
	EndDo;
	
EndProcedure

// Get current terminal operations.
// 
// Returns:
//  QueryResultSelection - Get current terminal operations:
//  * isReturn - Boolean
//  * PaymentType - CatalogRef.PaymentTypes
//  * PaymentTerminal - CatalogRef.PaymentTerminals
//  * Amount - Number
&AtServer
Function GetCurrentTerminalOperations()
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.Ref,
	|	FALSE AS isReturn
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
	|	TRUE AS isReturn
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
	|	tmpRefs.isReturn AS isReturn,
	|	R3050T_PosCashBalancesTurnovers.PaymentType AS PaymentType,
	|	R3050T_PosCashBalancesTurnovers.PaymentTerminal AS PaymentTerminal,
	|	SUM(CASE
	|		WHEN tmpRefs.isReturn
	|			THEN -R3050T_PosCashBalancesTurnovers.AmountTurnover
	|		ELSE R3050T_PosCashBalancesTurnovers.AmountTurnover
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
	|	tmpRefs.isReturn,
	|	R3050T_PosCashBalancesTurnovers.PaymentType,
	|	R3050T_PosCashBalancesTurnovers.PaymentTerminal
	|
	|ORDER BY
	|	isReturn,
	|	PaymentTerminal,
	|	PaymentType";
	
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Branch", ThisObject.Branch);
	Query.SetParameter("ConsolidatedRetailSales", ThisObject.ConsolidatedRetailSales);
	
	QuerySelection = Query.Execute().Select();
	Return QuerySelection
EndFunction

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

	QuerySelection = GetCurrentbalance();
	If QuerySelection.Next() Then
		ThisObject.BalanceBegin = QuerySelection.AmountOpeningBalance;
		ThisObject.BalanceCashIn = QuerySelection.AmountReceipt;
		ThisObject.BalanceCashOut = QuerySelection.AmountExpense;
		ThisObject.BalanceEnd = QuerySelection.AmountClosingBalance; 
	EndIf;
	
EndProcedure	

// Get currentbalance.
// 
// Returns:
//  QueryResultSelection - Get currentbalance:
//  * AmountOpeningBalance - Number
//  * AmountReceipt - Number
//  * AmountExpense - Number
//  * AmountClosingBalance - Number
&AtServer
Function GetCurrentbalance()
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
	Return QuerySelection
EndFunction

&AtClient
Procedure BalanceRealOnChange(Item)
	ThisObject.BalanceRealBedin = ThisObject.BalanceReal + ThisObject.BalanceRealOut - ThisObject.BalanceRealIn; 
	SetCurrentPage();
EndProcedure

&AtClient
Procedure BalanceRealInOnChange(Item)
	ThisObject.BalanceRealBedin = ThisObject.BalanceReal + ThisObject.BalanceRealOut - ThisObject.BalanceRealIn; 
	SetCurrentPage();
EndProcedure

&AtClient
Procedure BalanceRealOutOnChange(Item)
	ThisObject.BalanceRealBedin = ThisObject.BalanceReal + ThisObject.BalanceRealOut - ThisObject.BalanceRealIn; 
	SetCurrentPage();
EndProcedure

&AtClient
Procedure BalanceConfirmOnChange(Item)
	SetCurrentPage();
EndProcedure

#EndRegion
