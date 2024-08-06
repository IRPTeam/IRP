
&AtClient
Procedure CheckAll(Command)
	For Each Row In Documents Do
		Row.Check = True;
	EndDo;
	CalculateAmount();
EndProcedure

&AtClient
Procedure UnckeckAll(Command)
	For Each Row In Documents Do
		Row.Check = False;
	EndDo;
	CalculateAmount();
EndProcedure

&AtClient
Procedure DocumentsCheckOnChange(Item)
	CalculateAmount();		
EndProcedure

&AtServer
Procedure CalculateAmount()	
	TempTableDocuments = Documents.Unload(New Structure("Check", True), "Check, Amount");
	Amount = TempTableDocuments.Total("Amount");	
EndProcedure	


&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.RegisterName      = Parameters.RegisterName;
	ThisObject.DocRef            = Parameters.Ref;
	ThisObject.Company           = Parameters.Company;
	ThisObject.Branch            = Parameters.Branch;
	ThisObject.Currency          = Parameters.Currency;
	For Each Row In Parameters.SelectedDocuments Do
		NewRow = ThisObject.SelectedDocuments.Add();
		NewRow.Document = Row;	
	EndDo;
	
	For Each Row In Parameters.AllowedTypes Do
		NewRow = ThisObject.AllowedTypes.Add();
		NewRow.Type = Row;	
	EndDo;
	
	If Parameters.Property("SelectedPositionWithoutDocuments") Then
		For Each Row In Parameters.SelectedPositionWithoutDocuments Do
			NewRow = SelectedDocuments.Add();
			NewRow.Partner = Row.Partner;
			NewRow.Agreement = Row.Agreement;
		EndDo;	
	EndIf;	
	
	FillTable();
EndProcedure

&AtClient
Procedure FilterPartnerOnChange(Item)
	FillTable();
EndProcedure

&AtServer
Procedure FillTable()
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED
	|	TransactionsBalance.Basis AS Document,
	|	ISNULL(TransactionsBalance.Basis.Partner, TransactionsBalance.Partner) AS Partner,
	|	ISNULL(TransactionsBalance.Basis.Agreement, TransactionsBalance.Agreement) AS Agreement,
	|	TransactionsBalance.AmountBalance AS Amount,
	|	TransactionsBalance.Order AS Order,
	|	TransactionsBalance.Project AS Project,
	|	ISNULL(TransactionsBalance.Basis.LegalName, TransactionsBalance.LegalName) AS LegalName,
	|	TransactionsBalance.Basis.LegalNameContract AS LegalNameContract,
	|	TransactionsBalance.Basis.Date AS DocDate
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(
	|			&Boundary,
	|			Company = &Company
	|				AND Branch = &Branch
	|				AND Agreement.CurrencyMovementType.Currency = &Currency
	|				AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|				AND (VALUETYPE(Basis) IN (&AllowedTypes)
	|					OR Basis = UNDEFINED)
	|				AND CASE
	|					WHEN &Filter_Partner
	|						THEN Partner = &Partner
	|					ELSE TRUE
	|				END) AS TransactionsBalance
	|WHERE
	|	TransactionsBalance.AmountBalance > 0
	|	AND NOT TransactionsBalance.Basis IN (&SelectedDocuments)
	|
	|ORDER BY
	|	TransactionsBalance.Basis.Date";
	
	Query.Text = StrReplace(Query.Text, "R1021B_VendorsTransactions", ThisObject.RegisterName);
	
	If ValueIsFilled(ThisObject.DocRef) Then
		Query.SetParameter("Boundary", New Boundary(ThisObject.DocRef.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", CommonFunctionsServer.GetCurrentSessionDate());
	EndIf;
	
	ArrayOfAllowedTypes = New Array();
	For Each Row In ThisObject.AllowedTypes Do
		ArrayOfAllowedTypes.Add(Row.Type);	
	EndDo;
	
	TableOfSelectedRowsWithoutDocuments = New ValueTable;
	TableOfSelectedRowsWithoutDocuments.Columns.Add("Partner");
	TableOfSelectedRowsWithoutDocuments.Columns.Add("Agreement");
	
	ArrayOfSelectedDocuments = New Array();
	For Each Row In ThisObject.SelectedDocuments Do
		If ValueIsFilled(Row.Document) Then
			ArrayOfSelectedDocuments.Add(Row.Document);
		Else
			FillPropertyValues(TableOfSelectedRowsWithoutDocuments.Add(), Row);		
		EndIf;
	EndDo;
	
	Query.SetParameter("Company"           , ThisObject.Company);
	Query.SetParameter("Branch"            , ThisObject.Branch);
	Query.SetParameter("Currency"          , ThisObject.Currency);
	Query.SetParameter("AllowedTypes"      , ArrayOfAllowedTypes);
	Query.SetParameter("SelectedDocuments" , ArrayOfSelectedDocuments);
	Query.SetParameter("Filter_Partner"    , ValueIsFilled(ThisObject.FilterPartner));
	Query.SetParameter("Partner"           , ThisObject.FilterPartner);
	
	QueryResult = Query.Execute();
	ThisObject.Documents.Load(QueryResult.Unload());
	For Each Row In ThisObject.Documents Do
		Row.RowKey = String(New UUID());
	EndDo;
	
	ArrayToDelete = New Array;
	For Each Row In ThisObject.Documents Do
		SearchStructure = New Structure("Partner, Agreement", Row.Partner, Row.Agreement);
		If TableOfSelectedRowsWithoutDocuments.FindRows(SearchStructure).Count() > 0 Then
			ArrayToDelete.Add(Row);
		EndIf;	
	EndDo;
	For Each Row In ArrayToDelete Do
		ThisObject.Documents.Delete(Row);
	EndDo;		
EndProcedure

&AtClient
Procedure Ok(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	
	Result = CalculateRows();
	Close(Result);
EndProcedure

&AtClient
Procedure Calculate(Command)
	CalculateRows();
EndProcedure

&AtClient
Function CalculateRows()
	For Each Row In ThisObject.Documents Do
		Row.Payment = 0;
	EndDo;
	
	ArrayOfRows = New Array();
	SelectedRowsArray = Documents.FindRows(New Structure("Check", True));
	
	If SelectedRowsArray.Count() > 0 Then
		For Each SelectedRow In SelectedRowsArray Do
			NewRow = GetEmptyRowTable();
			FillPropertyValues(NewRow, SelectedRow);
			ArrayOfRows.Add(NewRow);
		EndDo;
	Else
		For Each Row In ThisObject.Documents Do
			NewRow = GetEmptyRowTable();
			FillPropertyValues(NewRow, Row);
			ArrayOfRows.Add(NewRow);
		EndDo;
	EndIf;
	
	ArrayOfRows = SortRowsByDate(ArrayOfRows);
	
	Result = New Array();
	
	_Amount = ThisObject.Amount;
	For Each Row In ArrayOfRows Do
		If Not ValueIsFilled(_Amount) Then
			Break;
		EndIf;
		
		Row.Payment = Min(_Amount, Row.Amount);
		_Amount = _Amount - Row.Payment;
		ResultRow = GetEmptyRowTable();
		
		FillPropertyValues(ResultRow, Row);
		
		ResultRow.Insert("TotalAmount",   Row.Payment);
		ResultRow.Insert("BasisDocument", Row.Document);
		ResultRow.Insert("Payee", Row.LegalName);
		ResultRow.Insert("Payer", Row.LegalName);
		
		Result.Add(ResultRow);
		
		DocumentsRows = ThisObject.Documents.FindRows(New Structure("RowKey", Row.RowKey));
		For Each DocumentRow In DocumentsRows Do
			DocumentRow.Payment = Row.Payment;
		EndDo;
		
	EndDo;

	Return Result;
EndFunction	

&AtClientAtServerNoContext
Function GetEmptyRowTable()
	EmptyRow = New Structure();
	EmptyRow.Insert("Agreement");
	EmptyRow.Insert("Amount");
	EmptyRow.Insert("DocDate");
	EmptyRow.Insert("Document");
	EmptyRow.Insert("LegalName");
	EmptyRow.Insert("LegalNameContract");
	EmptyRow.Insert("Order");
	EmptyRow.Insert("Partner");
	EmptyRow.Insert("Payment");
	EmptyRow.Insert("Project");
	EmptyRow.Insert("RowKey");
	Return EmptyRow;
EndFunction

&AtServer
Function SortRowsByDate(ArrayOfRows)
	EmptyTable = ThisObject.Documents.Unload().CopyColumns();
	For Each Row In ArrayOfRows Do
		FillPropertyValues(EmptyTable.Add(), Row);
	EndDo;
	
	EmptyTable.Sort("DocDate");
	
	NewArrayOfRows = New Array();
	
	For Each Row In EmptyTable Do
		NewRow = GetEmptyRowTable();
		FillPropertyValues(NewRow, Row);
		NewArrayOfRows.Add(NewRow);
	EndDo;
	
	Return NewArrayOfRows;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure DocumentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

