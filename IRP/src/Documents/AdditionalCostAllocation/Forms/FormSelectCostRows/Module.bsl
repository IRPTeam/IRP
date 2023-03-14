
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6070T_OtherPeriodsExpenses.Basis AS Document,
	|	R6070T_OtherPeriodsExpenses.RowID,
	|	R6070T_OtherPeriodsExpenses.ItemKey,
	|	R6070T_OtherPeriodsExpenses.Currency,
	|	R6070T_OtherPeriodsExpenses.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(&BalancePeriod, Company = &Company
	|	AND CurrencyMovementType = &CurrencyMovementType) AS R6070T_OtherPeriodsExpenses
	|TOTALS
	|BY
	|	Document";
	
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);

	BalancePeriod = Undefined;
	If ValueIsFilled(Parameters.Ref) And Parameters.Ref.Posted Then
		BalancePeriod = New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding);
	Else
		BalancePeriod = EndOfDay(Parameters.Date);
	EndIf;
	Query.SetParameter("BalancePeriod", BalancePeriod);
	QueryResult = Query.Execute();
	QuerySelection_Document = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection_Document.Next() Do
		NewRow_TopLevel = ThisObject.CostRowsTree.GetItems().Add();
		NewRow_TopLevel.Level = 1;
		NewRow_TopLevel.Icon = 1;
		NewRow_TopLevel.Document = QuerySelection_Document.Document;
		NewRow_TopLevel.Presentation = String(QuerySelection_Document.Document);
		QuerySelection_Details = QuerySelection_Document.Select();
		TotalAmount = 0;
		TotalCurrency = Undefined;
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
			TotalAmount = TotalAmount + NewRow_SecondLevel.Amount;
			TotalCurrency = NewRow_SecondLevel.Currency;
		EndDo;
		NewRow_TopLevel.Amount = TotalAmount;
		NewRow_TopLevel.Currency = TotalCurrency;
	EndDo;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.CostRowsTree, ThisObject.CostRowsTree.GetItems());
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure("SelectedRows", New Array());
	For Each Row_TopLevel In ThisObject.CostRowsTree.GetItems() Do
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			If Not Row_SecondLevel.Use Then
				Continue;
			EndIf;
			SelectedRow = New Structure();
			SelectedRow.Insert("RowID"    , Row_SecondLevel.RowID);
			SelectedRow.Insert("Basis"    , Row_TopLevel.Document);
			SelectedRow.Insert("ItemKey"  , Row_SecondLevel.ItemKey);
			SelectedRow.Insert("Currency" , Row_SecondLevel.Currency);
			SelectedRow.Insert("Amount"   , Row_SecondLevel.Amount);
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
Procedure CostRowsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CostRowsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

