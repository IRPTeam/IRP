#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, );
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("LedgerType");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CSV

// Create CSV.
// 
// Parameters:
//  DocRef - DocumentRef.ELedgerRegistry - Doc ref
// 
// Returns:
//  TextDocument - Create CSV
Function CreateCSV(DocRef) Export
	LocalizationCode = DocRef.LedgerType.ELedgerLocalizationCode;
	If Not ValueIsFilled(LocalizationCode) Then
		Raise StrTemplate("Not filled localization code for ledger type [%1]", DocRef.LedgerType);
	EndIf;
	
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
		
		BasisLongDescription = "";
		BasisShortDescription = "";
		
		If ValueIsFilled(QuerySelection.Ref.Basis) Then
			MetadataRef = GetConfigurationMetadataRef(QuerySelection.Ref.Basis);
			If ValueIsFilled(MetadataRef) Then
				BasisLongDescription = MetadataRef.ELedgerLongDescription;	
				BasisShortDescription = MetadataRef.ELedgerShortDescription;	
			EndIf;
		EndIf;
		
		Header = CreateHeader(QuerySelection.Ref, BasisShortDescription, LocalizationCode);
		csv.AddLine(StrConcat(ClearStrings(Header), Chars.Tab));
		
		Records = CreateRecords(LineNumber, QuerySelection.Ref, BasisLongDescription, LocalizationCode);		
		For Each Record In Records Do
			csv.AddLine(StrConcat(ClearStrings(Record), Chars.Tab));
		EndDo;	
	EndDo;
	
	Return csv;
EndFunction

Function ClearStrings(Strings)
	For i=0 To Strings.Count() -1 Do
		_String = TrimAll(String(Strings[i]));
		_String = StrReplace(_String, Chars.Tab, " ");
		_String = StrReplace(_String, "¶", "");
		_String = StrReplace(_String, Chars.LF, "");
		
		Strings[i] = _String;
	EndDo;
	Return Strings;
EndFunction

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

Function CreateHeader(JERef, BasisShortDescription, LocalizationCode)
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
	Values.Add(Format(JERef.Number, "NG=0"));
	
	// Comment
	Comment = JERef.Comment;
	If IsBlankString(Comment) 
		And ValueIsFilled(JEBasis) And ValueIsFilled(JEBasis.Comment) Then
		Comment = JEBasis.Comment;
		
		Comment = TrimAll(BasisShortDescription + " " + Left(Comment, 100));
	EndIf;
	
	If Not IsBlankString(Comment) Then
		Values.Add(Comment);
	Else
		Values.Add("");
	EndIf;
	
	// Total Dr Amount
	Values.Add(Format(JERef.DocumentAmount, "NFD=2; NDS=.; NG=;"));
	
	// Total Cr Amount
	Values.Add(Format(JERef.DocumentAmount, "NFD=2; NDS=.; NG=;"));
	
	// Sequental number
	Values.Add(Format(JERef.SequentalNumber, "NG=0"));
	
	Return Values;
EndFunction

Function CreateRecords(LineNumber, JERef, BasisLongDescription, LocalizationCode)
	Result = New Array();
	
	// Document type, number, ref, date, payment method
	DocumentType = "";
	DocumentTypeDescription = "";
	DocumentNumber = "";
	DocumentRef = "";
	DocumentDate = "";
	DocumentPaymentMethod = "";
	
	If ValueIsFilled(JERef.Basis) Then
		
		DocumentRef = Format(JERef.Number, "NG=0");
		DocumentDate = Format(JERef.Basis.Date,"DF=yyyy-MM-dd");
		DocumentTypeDescription = BasisLongDescription;
			
		If TypeOf(JERef.Basis) = Type("DocumentRef.SalesInvoice") Then
			DocumentType = "invoice";
		ElsIf TypeOf(JERef.Basis) = Type("DocumentRef.PurchaseInvoice") Then
			DocumentType = "invoice";
			DocumentNumber = TrimAll(JERef.Basis.DocNumber);
		Else
			DocumentType = "other";
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
		If ValueIsFilled(AccountMainDr) Then
			ValuesDr.Add(String(AccountMainDr.Code));
			ValuesDr.Add(AccountMainDr["Description_" + LocalizationCode]);
		Else
			Raise StrTemplate("Not defined Account main Dr [%1] [%2]", JERef, Record.AccountDr.Code);
		EndIf;
		
		AccountSubDr = GetSubAccount(Record, "AccountDr");
		If ValueIsFilled(AccountSubDr) Then
			ValuesDr.Add(AccountSubDr["Description_" + LocalizationCode]);
			If TypeOf(AccountSubDr) = Type("ChartOfAccountsRef.Basic") Then
				ValuesDr.Add(String(AccountSubDr.Code));
			Else
				ArraySubDr = New Array;	
				ArraySubDr.Add(Record.AccountDr.Code);
				ArraySubDr.Add(".");
				ArraySubDr.Add(Format(AccountSubDr.Code, "ND=5; NLZ=; NG=0"));
				
				ValuesDr.Add(StrConcat(ArraySubDr));
			EndIf;
		Else
			Raise StrTemplate("Not defined Account sub Dr [%1] [%2]", JERef, Record.AccountDr.Code);
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
			Raise StrTemplate("Not defined Account main Cr [%1] [%2]", JERef, Record.AccountCr.Code);
		EndIf;
		
		If ValueIsFilled(AccountSubCr) Then
			ValuesCr.Add(AccountSubCr["Description_" + LocalizationCode]);
			If TypeOf(AccountSubCr) = Type("ChartOfAccountsRef.Basic") Then
				ValuesCr.Add(String(AccountSubCr.Code));
			Else
				ArraySubCr = New Array;					ArraySubCr.Add(Record.AccountCr.Code);
				ArraySubCr.Add(".");
				ArraySubCr.Add(Format(AccountSubCr.Code, "ND=5; NLZ=; NG=0"));
				
				ValuesCr.Add(StrConcat(ArraySubCr)); 
			EndIf;
		Else
			Raise StrTemplate("Not defined Account sub Cr [%1] [%2]", JERef, Record.AccountCr.Code);
		EndIf;
		
		ValuesCr.Add(Format(Record.Amount, "NFD=2; NDS=.; NG=;"));
		ValuesCr.Add("C");
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

Function GetMainAccount(Record, AccountType)
	If ValueIsFilled(Record[AccountType].Parent) Then
		Return GetParentAccount(Record[AccountType].Parent);
	Else
		Return Record.AccountDr;
	EndIf;
EndFunction

Function GetSubAccount(Record, AccountType)
	
	ExtDimensionType = Undefined;
	For Each Row In Record[AccountType].ExtDimensionTypes Do
		If Row.ELedgerDetailed Then
			ExtDimensionType = Row.ExtDimensionType;
			Break;
		EndIf;		
	EndDo;
	                                              
	If ExtDimensionType = Undefined Then
		Return Record[AccountType];
	Else
		If ExtDimensionType <> Undefined Then
			For Each Row In ?(AccountType = "AccountDr", Record.ExtDimensionsDr, Record.ExtDimensionsCr) Do
				If Row.Key = ExtDimensionType Then
					Return Row.Value;
				EndIf;
			EndDo;
		EndIf;
		
		Return Undefined;
	EndIf;
EndFunction

Function GetParentAccount(Parent)
	If Not ValueIsFilled(Parent.Parent) Then
		Return Parent;
	Else
		Return GetParentAccount(Parent.Parent);
	EndIf;
EndFunction

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

Function GetConfigurationMetadataRef(BasisRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ConfigurationMetadata.Ref
	|FROM
	|	Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|WHERE
	|	ConfigurationMetadata.Parent = VALUE(Catalog.ConfigurationMetadata.Documents)
	|	AND ConfigurationMetadata.ObjectName = &ObjectName";
	
	Query.SetParameter("ObjectName", BasisRef.Metadata().Name);	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	EndIf;
	
	Return Catalogs.ConfigurationMetadata.EmptyRef();
EndFunction

#EndRegion
