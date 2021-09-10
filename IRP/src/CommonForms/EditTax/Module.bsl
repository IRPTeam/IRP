&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MainTableKey      = Parameters.MainTableData.Key;
	ThisObject.MainTableCurrency = Parameters.MainTableData.Currency;

	For Each Row In Parameters.ArrayOfTaxListRows Do
		FillPropertyValues(ThisObject.TaxTable.Add(), Row);
	EndDo;

	CreateTaxTree();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	TaxesClient.ExpandTaxTree(ThisObject.Items.TaxTree, ThisObject.TaxTree.GetItems());
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfTaxListRows = New Array();
	For Each Row In ThisObject.TaxTable Do
		NewRowTaxList = New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
		FillPropertyValues(NewRowTaxList, Row);
		ArrayOfTaxListRows.Add(NewRowTaxList);
	EndDo;
	Close(New Structure("Key, ArrayOfTaxListRows", ThisObject.MainTableKey, ArrayOfTaxListRows));
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure TaxTreeManualAmountOnChange(Item)
	CurrentData = Items.TaxTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Filter = New Structure();
	Filter.Insert("Key", CurrentData.Key);
	Filter.Insert("Tax", CurrentData.Tax);
	Filter.Insert("TaxRate", CurrentData.TaxRate);
	Filter.Insert("Analytics", CurrentData.Analytics);

	ArrayOfTaxRows = ThisObject.TaxTable.FindRows(Filter);

	For Each ItemOfTaxRows In ArrayOfTaxRows Do
		ItemOfTaxRows.ManualAmount = CurrentData.ManualAmount;
	EndDo;

	CreateTaxTree();

	TaxesClient.ExpandTaxTree(ThisObject.Items.TaxTree, ThisObject.TaxTree.GetItems());
	ThisObject.Items.TaxTree.CurrentRow = TaxesClient.FindRowInTree(Filter, ThisObject.TaxTree);
EndProcedure

&AtClient
Procedure TaxTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TaxTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtServer
Procedure CreateTaxTree()
	MainTable = New ValueTable();
	MainTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	MainTable.Columns.Add("Currency", New TypeDescription("CatalogRef.Currencies"));

	NewRowMainTable = MainTable.Add();
	NewRowMainTable.Key      = ThisObject.MainTableKey;
	NewRowMainTable.Currency = ThisObject.MainTableCurrency;

	Query = New Query();
	Query.Text =
	"SELECT *
	|INTO MainTable
	|FROM
	|	&MainTable AS MainTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TaxList.Key,
	|	TaxList.Tax,
	|	TaxList.Analytics,
	|	TaxList.TaxRate,
	|	TaxList.ManualAmount,
	|	TaxList.Amount,
	|	TaxList.IncludeToTotalAmount
	|INTO TaxList
	|FROM
	|	&TaxList AS TaxList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TaxList.Key AS Key,
	|	TaxList.Tax AS Tax,
	|	TaxList.Analytics AS Analytics,
	|	MainTable.*,
	|	TaxList.TaxRate AS TaxRate,
	|	TaxList.ManualAmount AS ManualAmount,
	|	TaxList.Amount AS Amount,
	|	CASE
	|		WHEN TaxList.IncludeToTotalAmount
	|			THEN TaxList.Amount
	|		ELSE 0
	|	END AS TotalAmount,
	|	CASE
	|		WHEN TaxList.IncludeToTotalAmount
	|			THEN TaxList.ManualAmount
	|		ELSE 0
	|	END AS TotalManualAmount
	|FROM
	|	TaxList AS TaxList
	|		INNER JOIN MainTable AS MainTable
	|		ON TaxList.Key = MainTable.Key";
	Query.SetParameter("MainTable", MainTable);
	Query.SetParameter("TaxList", ThisObject.TaxTable.Unload());

	QueryTable = Query.Execute().Unload();
	Table1 = QueryTable.Copy();

	Table1.GroupBy("Key, Tax, Currency, TaxRate", "TotalManualAmount, TotalAmount");

	ThisObject.TaxTree.GetItems().Clear();
	ThisObject.TotalTaxAmount = 0;
	For Each Row1 In Table1 Do
		NewRow1 = ThisObject.TaxTree.GetItems().Add();
		FillPropertyValues(NewRow1, Row1);
		NewRow1.Amount = Row1.TotalAmount;
		NewRow1.ManualAmount = Row1.TotalManualAmount;
		NewRow1.Level = 1;
		NewRow1.RowPresentation = StrTemplate("%1 - %2 - %3", Row1.Tax, Row1.Currency, Row1.TaxRate);
		ThisObject.TotalTaxAmount = ThisObject.TotalTaxAmount + Row1.TotalManualAmount;
		Filter1 = New Structure("Key, Tax, Currency, TaxRate");

		FillPropertyValues(Filter1, Row1);
		Table2 = QueryTable.Copy(Filter1);
		Table2.GroupBy("Key, Analytics", "ManualAmount, Amount");

		For Each Row2 In Table2 Do
			If ValueIsFilled(Row2.Analytics) Then
				NewRow1.ReadOnly = True;
				NewRow1.PictureEdit = 1;
				NewRow2 = NewRow1.GetItems().Add();
				FillPropertyValues(NewRow2, Row1);
				FillPropertyValues(NewRow2, Row2);
				NewRow2.RowPresentation = StrTemplate("%1", Row2.Analytics);

				NewRow2.Level = 2;
			EndIf;
		EndDo;
	EndDo;
EndProcedure