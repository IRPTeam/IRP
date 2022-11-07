
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.Currency = Parameters.Currency;
	ThisObject.Store = Parameters.Store;
	ThisObject.Workstation = Parameters.Workstation;
	ThisObject.ConsolidatedRetailSales = Parameters.ConsolidatedRetailSales; 
	
	CRS_Attributes = CommonFunctionsServer.GetAttributesFromRef(
			ThisObject.ConsolidatedRetailSales, 
			"Company, Branch, CashAccount, OpeningDate");
	ThisObject.Company = CRS_Attributes.Company;
	ThisObject.Branch = CRS_Attributes.Branch;
	ThisObject.CashAccount = CRS_Attributes.CashAccount;
	ThisObject.OpeningDate = CRS_Attributes.OpeningDate;
	
	Items.FormCloseSession.Title = Parameters.Title;
	
	TotalPerSession = GetTotalPerSession();
	TotalAtPOS = GetTotalAtPOS();
	
EndProcedure

&AtServer
Function GetTotalAtPOS()
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	R3010B_CashOnHandBalance.Currency,
	|	R3010B_CashOnHandBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.Balance(, Company = &Company
	|	AND Branch = &Branch
	|	AND Account = &Account
	|	AND Currency = &Currency
	|	AND CurrencyMovementType = &CurrencyMovementType) AS R3010B_CashOnHandBalance";
	
	Query.SetParameter("Company", ThisObject.Company);
	Query.SetParameter("Currency", ThisObject.Currency);
	Query.SetParameter("Branch", ThisObject.Branch);
	Query.SetParameter("Account", ThisObject.CashAccount);
	
	LegalCurrencies = Catalogs.Companies.GetLegalCurrencies(ThisObject.Company);
	If LegalCurrencies.Count() Then
		Query.SetParameter("CurrencyMovementType", LegalCurrencies[0].CurrencyMovementType);
	Else
		Query.SetParameter("CurrencyMovementType", Undefined);
	EndIf;
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.AmountBalance;
	EndIf;
	
	Return 0;
EndFunction

&AtServer
Function GetTotalPerSession()
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.ConsolidatedRetailSales,
	|	SUM(RetailSalesReceipt.DocumentAmount) AS DocumentAmount
	|FROM
	|	Document.RetailSalesReceipt AS RetailSalesReceipt
	|WHERE
	|	RetailSalesReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|	AND RetailSalesReceipt.Posted
	|GROUP BY
	|	RetailSalesReceipt.ConsolidatedRetailSales";
	Query.SetParameter("ConsolidatedRetailSales", ConsolidatedRetailSales);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.DocumentAmount;
	EndIf;
	
	Return 0;
EndFunction

&AtClient
Procedure CloseSession(Command)
	Close(DialogReturnCode.OK);
EndProcedure
