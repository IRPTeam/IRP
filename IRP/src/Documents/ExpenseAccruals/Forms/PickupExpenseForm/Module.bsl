// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillExpenseValueTable();
EndProcedure


#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure ExpenseValueTableSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.ExpenseValueTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	
	Result = New Array();
	Result.Add(New Structure("Amount, Basis", CurrentData.Amount, CurrentData.Document));
	Close(Result);		
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure FillExpenseValueTable()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6070T_OtherPeriodsExpenses.Basis AS Document,
	|	R6070T_OtherPeriodsExpenses.Currency AS Currency,
	|	R6070T_OtherPeriodsExpenses.TransactionCurrency AS TransactionCurrency,
	|	R6070T_OtherPeriodsExpenses.CurrencyMovementType AS CurrencyMovementType,
	|	R6070T_OtherPeriodsExpenses.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(&BalancePeriod, Company = &Company
	|	AND Branch = &Branch
	|	AND CurrencyMovementType = &CurrencyMovementType
	|	AND OtherPeriodExpenseType = VALUE(Enum.OtherPeriodExpenseType.ExpenseAccruals)
	|	AND Currency = &Currency
	|	AND CASE
	|		WHEN &TransactionType = VALUE(Enum.AccrualsTransactionType.Accrual)
	|			THEN Basis REFS Document.PurchaseInvoice
	|		ELSE Basis REFS Document.ExpenseAccruals
	|	END) AS R6070T_OtherPeriodsExpenses";
	
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Branch", Parameters.Branch);
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	Query.SetParameter("Currency", Parameters.Currency);
	Query.SetParameter("TransactionType", Parameters.TransactionType);
	
//	CurrentTransactionType = Parameters.TransactionType;
//	If CurrentTransactionType = Enums.AccrualsTransactionType.Accrual Then 
//		Query.Text = StrReplace(Query.Text, "&DocTypeFilter", "VALUETYPE(Basis) = TYPE(Document.PurchaseInvoice)");
//	ElsIf CurrentTransactionType = Enums.AccrualsTransactionType.Void 
//		Or CurrentTransactionType = Enums.AccrualsTransactionType.Reverse Then
//		Query.Text = StrReplace(Query.Text, "&DocTypeFilter", "VALUETYPE(Basis) = TYPE(Document.ExpenseAccruals)");
//	Else
//		Query.Text = StrReplace(Query.Text, "&DocTypeFilter", "True");
//	EndIf;
//	
	BalancePeriod = Undefined;
	If ValueIsFilled(Parameters.Ref) And Parameters.Ref.Posted Then
		BalancePeriod = New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding);
	Else
		BalancePeriod = CommonFunctionsServer.GetCurrentSessionDate();
	EndIf;
	Query.SetParameter("BalancePeriod", BalancePeriod);
	QueryResult = Query.Execute();
	QuerySelection_Document = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection_Document.Next() Do
		
		NewRow = ExpenseValueTable.Add();
		FillPropertyValues(NewRow, QuerySelection_Document);
		
	EndDo;
EndProcedure

#EndRegion

