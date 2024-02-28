
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
	|	TransactionsBalance.Basis.Partner AS Partner,
	|	TransactionsBalance.Basis.Agreement AS Agreement,
	|	TransactionsBalance.AmountBalance AS Amount,
	|	TransactionsBalance.Order,
	|	TransactionsBalance.Project,
	|	TransactionsBalance.Basis.LegalName AS LegalName,
	|	TransactionsBalance.Basis.LegalNameContract AS LegalNameContract
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(&Boundary, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND VALUETYPE(Basis) IN (&AllowedTypes)
	|	AND CASE
	|		WHEN &Filter_Partner
	|			THEN Partner = &Partner
	|		ELSE TRUE
	|	END) AS TransactionsBalance
	|WHERE
	|	TransactionsBalance.AmountBalance > 0
	|	AND NOT TransactionsBalance.Basis.Ref IS NULL
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
	
	ArrayOfSelectedDocuments = New Array();
	For Each Row In ThisObject.SelectedDocuments Do
		ArrayOfSelectedDocuments.Add(Row.Document);
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
	
	If Items.Documents.SelectedRows.Count() > 1 Then
		For Each SelectedRow In Items.Documents.SelectedRows Do
			ArrayOfRows.Add(ThisObject.Documents.FindByID(SelectedRow));
		EndDo;
	Else
		For Each Row In ThisObject.Documents Do
			ArrayOfRows.Add(Row);
		EndDo;
	EndIf;
	
	Result = New Array();
	
	_Amount = ThisObject.Amount;
	For Each Row In ArrayOfRows Do
		If Not ValueIsFilled(_Amount) Then
			Break;
		EndIf;
		
		Row.Payment = Min(_Amount, Row.Amount);
		_Amount = _Amount - Row.Payment;
			
		ResultRow = New Structure("BasisDocument, Partner, Agreement, TotalAmount, Order, Project, LegalName, LegalNameContract");
		FillPropertyValues(ResultRow, Row);
		
		ResultRow.TotalAmount = Row.Payment;
		ResultRow.BasisDocument = Row.Document;
		ResultRow.Insert("Payee", Row.LegalName);
		ResultRow.Insert("Payer", Row.LegalName);
		
		Result.Add(ResultRow);
	EndDo;

	Return Result;
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



