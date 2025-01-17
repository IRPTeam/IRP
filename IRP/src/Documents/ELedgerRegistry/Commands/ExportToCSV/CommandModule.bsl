
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	csv = CreateCSV(CommandParameter);
	csv.Show("eLedger");
EndProcedure

&AtServer
Function CreateCSV(DocRef)
	LocalizationCode = SessionParameters.InterfaceLocalizationCode;
	csv = New TextDocument();
	
	Identifier = CreateIdentifier(DocRef.Company, DocRef.BeginDate, DocRef.EndDate);
	csv.AddLine(StrConcat(ClearStrings(Identifier), Chars.Tab));
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	JournalEntry.Ref
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	NOT JournalEntry.DeletionMark
	|	AND JournalEntry.ELedgerRegistry = &ELedgerRegistry
	|
	|ORDER BY
	|	JournalEntry.SequentalNumber";
	Query.SetParameter("ELedgerRegistry", DocRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	LineNumber = 1;
	
	While QuerySelection.Next() Do
		Header = CreateHeader(QuerySelection.Ref, LocalizationCode);
		csv.AddLine(StrConcat(ClearStrings(Header), Chars.Tab));
		
		Records = CreateRecords(LineNumber, QuerySelection.Ref, LocalizationCode);		
		For Each Record In Records Do
			csv.AddLine(StrConcat(ClearStrings(Record), Chars.Tab));
		EndDo;	
	EndDo;
	
	Return csv;
EndFunction

&AtServer
Function ClearStrings(Strings)
	For i=0 To Strings.Count() -1 Do
		Strings[i] = StrReplace(TrimAll(String(Strings[i])), Chars.Tab, " ");
	EndDo;
	Return Strings;
EndFunction

&AtServer
Function CreateIdentifier(Company, BeginDate, EndDate)
	Values = New Array();
	
	Values.Add("Y");
	Values.Add(Format(BeginDate,"DF=yyyy-MM-dd"));
	Values.Add(Format(EndDate,"DF=yyyy-MM-dd"));
	
	If ValueIsFilled(Company.BatchID) Then
		Values.Add(Company.BatchID);
	EndIf;
	
	If ValueIsFilled(Company.EntityID) Then
		Values.Add(Company.EntityID);
	EndIf;
	
	Return Values;
EndFunction

&AtServer
Function CreateHeader(JERef, LocalizationCode)
	Values = New Array();
	
	Values.Add("H");
	
	JEBasis = JERef.Basis;
	
	// Author
	Author = Undefined;
	If ValueIsFilled(JEBasis) Then
		Author = JEBasis.Author;
	Else
		Author = JERef.Author;
	EndIf;
	
	If ValueIsFilled(Author) And ValueIsFilled(Author.Partner) Then
		Values.Add(Author.Partner["Description_" + LocalizationCode]);
	Else
		Values.Add("");
	EndIf;
	
	// Date
	Values.Add(Format(JERef.Date,"DF=yyyy-MM-dd"));
		
	// Number
	Values.Add(String(JERef.Number));
	
	// Comment
	Comment = Undefined;
	If ValueIsFilled(JEBasis) And ValueIsFilled(JEBasis.Comment) Then
		Comment = JEBasis.Comment;
	Else
		Comment = JERef.Comment;
	EndIf;
	
	If ValueIsFilled(Comment) Then
		Values.Add(Comment);
	Else
		Values.Add("");
	EndIf;
	
	// Total Dr Amount
	Values.Add(Format(JERef.DocumentAmount, "NFD=2; NDS=.; NG=;"));
	
	// Total Cr Amount
	Values.Add(Format(JERef.DocumentAmount, "NFD=2; NDS=.; NG=;"));
	
	// Sequental number
	Values.Add(String(JERef.SequentalNumber));
	
	Return Values;
EndFunction

&AtServer
Function CreateRecords(LineNumber, JERef, LocalizationCode)
	Result = New Array();
	
	// Document type, number, ref, date, payment method
	DocumentType = "";
	DocumentTypeDescription = "";
	DocumentNumber = "";
	DocumentRef = "";
	DocumentDate = "";
	DocumentPaymentMethod = "";
	
	If ValueIsFilled(JERef.Basis) Then
		
		DocumentRef = String(JERef.Number);
		DocumentDate = Format(JERef.Basis.Date,"DF=yyyy-MM-dd");
			
		If TypeOf(JERef.Basis) = Type("DocumentRef.SalesInvoice") Then
			DocumentType = "invoice";
			DocumentNumber = JERef.Basis.DocumentNumber;
		ElsIf TypeOf(JERef.Basis) = Type("DocumentRef.PurchaseInvoice") Then
			DocumentType = "invoice";
			DocumentNumber = JERef.Basis.DocumentNumber;
		Else
			DocumentType = "other";
			DocumentTypeDescription = JERef.Basis.Metadata().Synonym;
		EndIf;
		
		If TypeOf(JERef.Basis) = Type("DocumentRef.BankPayment")
			Or TypeOf(JERef.Basis) = Type("DocumentRef.BankReceipt") Then
			DocumentPaymentMethod = "banka";
		ElsIf TypeOf(JERef.Basis) = Type("DocumentRef.CashPayment")
			Or TypeOf(JERef.Basis) = Type("DocumentRef.CashReceipt") Then
			DocumentPaymentMethod = "nakit";
		EndIf;
	EndIf;
	
	Records = AccountingRegisters.Basic.CreateRecordSet();
	Records.Filter.Recorder.Set(JERef);
	Records.Read();
	
	For Each Record In Records Do
		
		OperationDescription = GetOperationDecription(Record, LocalizationCode);
		
		// Debit
		ValuesDr = New Array();
		
		// Line number
		ValuesDr.Add(String(LineNumber));
		LineNumber = LineNumber + 1;
		
		// Sequental number
		ValuesDr.Add(String(JERef.SequentalNumber));
		
		AccountMainDr = GetMainAccount(Record, "AccountDr");
		AccountSubDr = GetSubAccount(Record, "AccountDr");
		
		If ValueIsFilled(AccountMainDr) Then
			ValuesDr.Add(String(AccountMainDr.Code));
			ValuesDr.Add(AccountMainDr["Description_" + LocalizationCode]);
		Else
			Raise StrTemplate("Not defined Account main Dr [%1] [%2]", JERef, Record.AccountDr);
		EndIf;
		
		If ValueIsFilled(AccountSubDr) Then
			ValuesDr.Add(String(AccountSubDr.Code));
			ValuesDr.Add(AccountSubDr["Description_" + LocalizationCode]);
		Else
			Raise StrTemplate("Not defined Account sub Dr [%1] [%2]", JERef, Record.AccountDr);
		EndIf;
		
		ValuesDr.Add(Format(Record.Amount, "NFD=2; NDS=.; NG=;"));
		ValuesDr.Add("D");
		ValuesDr.Add(Format(JERef.Date,"DF=yyyy-MM-dd"));
		
		ValuesDr.Add(DocumentType);
		ValuesDr.Add(DocumentTypeDescription);
		ValuesDr.Add(DocumentNumber);
		ValuesDr.Add(DocumentRef);
		ValuesDr.Add(DocumentDate);
		ValuesDr.Add(DocumentPaymentMethod);
		ValuesDr.Add(OperationDescription);
		ValuesDr.Add("TRY");
		
		// Credit
		ValuesCr = New Array();
		
		// Line number
		ValuesCr.Add(String(LineNumber));
		LineNumber = LineNumber + 1;
		
		// Sequental number
		ValuesCr.Add(String(JERef.SequentalNumber));
		
		AccountMainCr = GetMainAccount(Record, "AccountCr");
		AccountSubCr = GetSubAccount(Record, "AccountCr");
		
		If ValueIsFilled(AccountMainCr) Then
			ValuesCr.Add(String(AccountMainCr.Code));
			ValuesCr.Add(AccountMainCr["Description_" + LocalizationCode]);
		Else
			Raise StrTemplate("Not defined Account main Cr [%1] [%2]", JERef, Record.AccountCr);
		EndIf;
		
		If ValueIsFilled(AccountSubCr) Then
			ValuesCr.Add(String(AccountSubCr.Code));
			ValuesCr.Add(AccountSubCr["Description_" + LocalizationCode]);
		Else
			Raise StrTemplate("Not defined Account sub Cr [%1] [%2]", JERef, Record.AccountCr);
		EndIf;
		
		ValuesCr.Add(Format(Record.Amount, "NFD=2; NDS=.; NG=;"));
		ValuesCr.Add("D");
		ValuesCr.Add(Format(JERef.Date,"DF=yyyy-MM-dd"));
		
		ValuesCr.Add(DocumentType);
		ValuesCr.Add(DocumentTypeDescription);
		ValuesCr.Add(DocumentNumber);
		ValuesCr.Add(DocumentRef);
		ValuesCr.Add(DocumentDate);
		ValuesCr.Add(DocumentPaymentMethod);
		ValuesCr.Add(OperationDescription);
		ValuesCr.Add("TRY");
		
				
		Result.Add(ValuesDr);		
		Result.Add(ValuesCr);		
	EndDo;
	
	Return Result;
EndFunction

&AtServer
Function GetMainAccount(Record, AccountType)
	If ValueIsFilled(Record[AccountType].Parent) Then
		Return GetParentAccount(Record[AccountType].Parent);
	Else
		Return Record.AccountDr;
	EndIf;
EndFunction

&AtServer
Function GetSubAccount(Record, AccountType)
	If ValueIsFilled(Record[AccountType].Parent) Then
		Return Record[AccountType];
	Else
		ExtDimensionType = Undefined;
		
		For Each Row In Record[AccountType].ExtDimensionTypes Do
			If Row.ELedgerDetailed Then
				ExtDimensionType = Row.ExtDimensionType;
				Break;
			EndIf;		
		EndDo;
		
		If ExtDimensionType <> Undefined Then
			For Each Row In Record.ExtDimensionsDr Do
				If Row.Key = ExtDimensionType Then
					Return Row.Value;
				EndIf;
			EndDo;
		EndIf;
		
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Function GetParentAccount(Parent)
	If Not ValueIsFilled(Parent.Parent) Then
		Return Parent;
	Else
		Return GetParentAccount(Parent.Parent);
	EndIf;
EndFunction

&AtServer
Function GetOperationDecription(Record, LocalizationCode)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.DetailComment
	|FROM
	|	InformationRegister.T9070S_ELedgerDetailComments AS Reg
	|WHERE
	|	Reg.Company = &Company
	|	AND Reg.LedgerType = &LedgerType
	|	AND Reg.AccountingOperation = &AccountingOperation
	|	AND Reg.LocalizationCode = &LocalizationCode";
	Query.SetParameter("Company", Record.Company);
	Query.SetParameter("LedgerType", Record.LedgerType);
	Query.SetParameter("AccountingOperation", Record.Operation);
	Query.SetParameter("LocalizationCode", LocalizationCode);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	OperationDescription = "";
	
	If QuerySelection.Next() Then
		If ValueIsFilled(QuerySelection.DetailComment) Then
			OperationDescription = QuerySelection.DetailComment;
		EndIf;
	EndIf;
	
	Return OperationDescription;
EndFunction
