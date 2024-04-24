// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6070T_OtherPeriodsExpenses.Basis AS Document,
	|	R6070T_OtherPeriodsExpenses.Currency,
	|	R6070T_OtherPeriodsExpenses.TransactionCurrency,
	|	R6070T_OtherPeriodsExpenses.CurrencyMovementType,
	|	R6070T_OtherPeriodsExpenses.AmountBalance AS Amount,
	|	R6070T_OtherPeriodsExpenses.AmountTaxBalance AS TaxAmount
	|FROM
	|	AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(&BalancePeriod, Company = &Company
	|	AND CurrencyMovementType = &CurrencyMovementType
	|	AND OtherPeriodExpenseType = VALUE(Enum.OtherPeriodExpenseType.ExpenseAccruals)
	|	AND Currency = &Currency) AS R6070T_OtherPeriodsExpenses";
	
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	Query.SetParameter("Currency", Parameters.Currency);

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

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure CheckAll(Command)
	For Each Row In ExpenseValueTable Do
		Row.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure Ок(Command)
	
	Array = New Array(); // Array of Structure
	For Each Row In ExpenseValueTable Do
		If Not Row.Use Then
			Continue;
		EndIf;
		Structure = RowEmptyStructure();
		FillPropertyValues(Structure, Row);
		
		Array.Add(Structure);	
	EndDo;
	
	Close(Array);		

EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	For Each Row In ExpenseValueTable Do
		Row.Use = False;
	EndDo;
EndProcedure

#EndRegion

#Region Private

// Row structure.
// 
// Returns:
//  Structure - Row empty structure:
// * Amount - Number - 
// * Currency - CatalogRef.Currencies - 
// * Document - Undefined - 
// * TaxAmount - Number - 
&AtClient
Function RowEmptyStructure()
	
	Structure = New Structure();
	Structure.Insert("Amount", 0);
	Structure.Insert("Currency", PredefinedValue("Catalog.Currencies.EmptyRef"));
	Structure.Insert("Document", Undefined);
	Structure.Insert("TaxAmount", 0);
	
	Return Structure;
EndFunction	

#EndRegion

