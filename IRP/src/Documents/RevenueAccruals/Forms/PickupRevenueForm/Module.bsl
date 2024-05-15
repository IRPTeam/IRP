// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillRevenueTable();
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure RevenueValueTableSelection(Item, RowSelected, Field, StandardProcessing)	
	CurrentData = Items.RevenueValueTable.CurrentData;
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
Procedure FillRevenueTable()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6080T_OtherPeriodsRevenues.Basis AS Document,
	|	R6080T_OtherPeriodsRevenues.Currency AS Currency,
	|	R6080T_OtherPeriodsRevenues.TransactionCurrency AS TransactionCurrency,
	|	R6080T_OtherPeriodsRevenues.CurrencyMovementType AS CurrencyMovementType,
	|	R6080T_OtherPeriodsRevenues.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R6080T_OtherPeriodsRevenues.Balance(&BalancePeriod, Company = &Company
	|	AND CurrencyMovementType = &CurrencyMovementType
	|	AND OtherPeriodRevenueType = VALUE(Enum.OtherPeriodRevenueType.RevenueAccruals)
	|	AND Currency = &Currency
	|	AND CASE
	|		WHEN &TransactionType = VALUE(Enum.AccrualsTransactionType.Accrual)
	|			THEN Basis REFS Document.SalesInvoice
	|		ELSE Basis REFS Document.RevenueAccruals
	|	END) AS R6080T_OtherPeriodsRevenues";
	
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Branch", Parameters.Branch);
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	Query.SetParameter("Currency", Parameters.Currency);
	Query.SetParameter("TransactionType", Parameters.TransactionType);
	
//	CurrentTransactionType = Parameters.TransactionType;
//	If CurrentTransactionType = Enums.AccrualsTransactionType.Accrual Then 
//		Query.Text = StrReplace(Query.Text, "&DocTypeFilter", "VALUETYPE(Basis) = TYPE(Document.SalesInvoice)");
//	ElsIf CurrentTransactionType = Enums.AccrualsTransactionType.Void 
//		Or CurrentTransactionType = Enums.AccrualsTransactionType.Reverse Then
//		Query.Text = StrReplace(Query.Text, "&DocTypeFilter", "VALUETYPE(Basis) = TYPE(Document.RevenueAccruals)");
//	Else
//		Query.Text = StrReplace(Query.Text, "&DocTypeFilter", "True");
//	EndIf;
	
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
		
		NewRow = RevenueValueTable.Add();
		FillPropertyValues(NewRow, QuerySelection_Document);
		
	EndDo;
EndProcedure

#EndRegion

