
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6080T_OtherPeriodsRevenues.Basis AS Document,
	|	R6080T_OtherPeriodsRevenues.RowID,
	|	R6080T_OtherPeriodsRevenues.ItemKey,
	|	R6080T_OtherPeriodsRevenues.Currency,
	|	R6080T_OtherPeriodsRevenues.RevenueType,
	|	R6080T_OtherPeriodsRevenues.ProfitLossCenter,
	|	R6080T_OtherPeriodsRevenues.AmountBalance AS Amount,
	|	R6080T_OtherPeriodsRevenues.AmountTaxBalance AS TaxAmount
	|FROM
	|	AccumulationRegister.R6080T_OtherPeriodsRevenues.Balance(&BalancePeriod, Company = &Company
	|	AND CurrencyMovementType = &CurrencyMovementType
	|	AND OtherPeriodRevenueType = VALUE(Enum.OtherPeriodRevenueType.ItemsRevenue)) AS R6080T_OtherPeriodsRevenues
	|TOTALS
	|BY
	|	Document";
	
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);

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
		NewRow_TopLevel = ThisObject.RevenueRowsTree.GetItems().Add();
		NewRow_TopLevel.Level = 1;
		NewRow_TopLevel.Icon = 1;
		NewRow_TopLevel.Document = QuerySelection_Document.Document;
		NewRow_TopLevel.Presentation = String(QuerySelection_Document.Document);
		QuerySelection_Details = QuerySelection_Document.Select();
		TotalAmount    = 0;
		TotalTaxAmount = 0;
		TotalCurrency  = Undefined;
		While QuerySelection_Details.Next() Do
			NewRow_SecondLevel = NewRow_TopLevel.GetItems().Add();
			NewRow_SecondLevel.Level = 2;
			NewRow_SecondLevel.Icon = 0;
			FillPropertyValues(NewRow_SecondLevel, QuerySelection_Details);
			NewRow_SecondLevel.Presentation = String(NewRow_SecondLevel.ItemKey.Item) + ", " + String(NewRow_SecondLevel.ItemKey);
			If DocumentsClientServer.FindRowInArrayOfStructures(Parameters.SelectedRows, "RowID, Basis", 
				QuerySelection_Details.RowID, QuerySelection_Details.Document) <> Undefined Then
				NewRow_SecondLevel.Use = True;
			EndIf;
			TotalAmount    = TotalAmount    + NewRow_SecondLevel.Amount;
			TotalTaxAmount = TotalTaxAmount + NewRow_SecondLevel.TaxAmount;
			TotalCurrency  = NewRow_SecondLevel.Currency;
		EndDo;
		NewRow_TopLevel.Amount    = TotalAmount;
		NewRow_TopLevel.TaxAmount = TotalTaxAmount;
		NewRow_TopLevel.Currency  = TotalCurrency;
	EndDo;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	CommonFormActions.ExpandTree(Items.RevenueRowsTree, ThisObject.RevenueRowsTree.GetItems());
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure("SelectedRows", New Array());
	For Each Row_TopLevel In ThisObject.RevenueRowsTree.GetItems() Do
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			If Not Row_SecondLevel.Use Then
				Continue;
			EndIf;
			SelectedRow = New Structure();
			SelectedRow.Insert("RowID"    , Row_SecondLevel.RowID);
			SelectedRow.Insert("Basis"    , Row_TopLevel.Document);
			SelectedRow.Insert("ItemKey"  , Row_SecondLevel.ItemKey);
			SelectedRow.Insert("RevenueType"       , Row_SecondLevel.RevenueType);
			SelectedRow.Insert("ProfitLossCenter"  , Row_SecondLevel.ProfitLossCenter);
			SelectedRow.Insert("Currency" , Row_SecondLevel.Currency);
			SelectedRow.Insert("Amount"   , Row_SecondLevel.Amount);
			SelectedRow.Insert("TaxAmount", Row_SecondLevel.TaxAmount);
			Result.SelectedRows.Add(SelectedRow);
		EndDo;
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);	
EndProcedure

&AtClient
Procedure RevenueRowsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure RevenueRowsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

