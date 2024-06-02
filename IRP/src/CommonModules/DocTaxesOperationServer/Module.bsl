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
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("LegalNameContract");
	AttributesArray.Add("TransactionType");
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

Function FillTaxesIncomingOutgoing(FormUUID, DocRef, DocDate, Company, Branch, Currency, RegName) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Taxes.TaxRate AS VatRate,
	|	Taxes.InvoiceType AS InvoiceType,
	|	Taxes.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R1040B_TaxesOutgoing.Balance(&BalancePeriod, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS Taxes";
	
	Query.Text = StrReplace(Query.Text, "R1040B_TaxesOutgoing", RegName);
	
	If ValueIsFilled(DocRef) Then
		Query.SetParameter("BalancePeriod", New Boundary(DocRef.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("BalancePeriod", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(DocRef, DocDate));
	EndIf;
	
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("Branch"   , Branch);
	Query.SetParameter("Currency" , Currency);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	GroupColumn = "VatRate, InvoiceType";
	SumColumn = "Amount";
	QueryTable.GroupBy(GroupColumn, SumColumn);
	Address = PutToTempStorage(QueryTable, FormUUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, GroupColumn, SumColumn);
EndFunction

Function CalculateTaxDifference(val DocObject) Export
	Result = New Array();
	
	TotalTaxAmount_Incoming = DocObject.TaxesIncoming.Total("Amount");
	TotalTaxAmount_Outgoing = DocObject.TaxesOutgoing.Total("Amount");
	
	If TotalTaxAmount_Incoming < TotalTaxAmount_Outgoing Then
		MinTableName = "TaxesIncoming";
		MaxTableName = "TaxesOutgoing";
	Else
		MinTableName = "TaxesOutgoing";
		MaxTableName = "TaxesIncoming";
	EndIf;		
		
	MinTable = DocObject[MinTableName].Unload();
	MaxTable = DocObject[MaxTableName].Unload();
	
	If DocObject.TransactionType = Enums.TaxesOperationTransactionType.TaxOffset
		Or DocObject.TransactionType = Enums.TaxesOperationTransactionType.TaxOffsetAndPayment Then
		Calculate_TaxOffset(MinTableName, MinTable, MaxTableName, MaxTable, Result);
	EndIf;
	
	If DocObject.TransactionType = Enums.TaxesOperationTransactionType.TaxPayment
		Or DocObject.TransactionType = Enums.TaxesOperationTransactionType.TaxOffsetAndPayment Then		
		Calculate_TaxPayment(MinTableName, MinTable, Result);
		Calculate_TaxPayment(MaxTableName, MaxTable, Result);
	EndIf;
	
	Return Result;
EndFunction

Function GetTaxesDifferenceRow()
	Return New Structure("Key, IncomingVatRate, IncomingInvoiceType, OutgoingVatRate, OutgoingInvoiceType, Amount");
EndFunction

Function Calculate_TaxOffset(MinTableName, MinTable, MaxTableName, MaxTable, Result)
	For Each MinRow In MinTable Do
		
		For Each MaxRow In MaxTable Do
			
			If Not ValueIsFilled(MinRow.Amount) Then
				Continue;
			EndIf;
			
			If Not ValueIsFilled(MaxRow.Amount) Then
				Continue;
			EndIf;
			 
			DiffRow = GetTaxesDifferenceRow();
			Result.Add(DiffRow);
			DiffRow.Key = String(New UUID());	
			
			If MinTableName = "TaxesIncoming" Then
				DiffRow.IncomingVatRate = MinRow.VatRate;
				DiffRow.IncomingInvoiceType = MinRow.InvoiceType;
			ElsIf MinTableName = "TaxesOutgoing" Then
				DiffRow.OutgoingVatRate = MinRow.VatRate;
				DiffRow.OutgoingInvoiceType = MinRow.InvoiceType;
			EndIf;
			
			If MaxTableName = "TaxesIncoming" Then
				DiffRow.IncomingVatRate = MaxRow.VatRate;
				DiffRow.IncomingInvoiceType = MaxRow.InvoiceType;
			ElsIf MaxTableName = "TaxesOutgoing" Then
				DiffRow.OutgoingVatRate = MaxRow.VatRate;
				DiffRow.OutgoingInvoiceType = MaxRow.InvoiceType;
			EndIf;
						
			DiffRow.Amount = Min(MaxRow.Amount, MinRow.Amount);
			
			MinRow.Amount = MinRow.Amount - DiffRow.Amount;
			MaxRow.Amount = MaxRow.Amount - DiffRow.Amount;
			
		EndDo;
	EndDo;
	Return Result;
EndFunction

Function Calculate_TaxPayment(TableName, Table, Result)
	For Each Row In Table Do
		If Not ValueIsFilled(Row.Amount) Then
			Continue;
		EndIf;
		
		DiffRow = GetTaxesDifferenceRow();
		Result.Add(DiffRow);
		DiffRow.Key = String(New UUID());	
			
		If TableName = "TaxesIncoming" Then
			DiffRow.IncomingVatRate = Row.VatRate;
			DiffRow.IncomingInvoiceType = Row.InvoiceType;
		ElsIf TableName = "TaxesOutgoing" Then
			DiffRow.OutgoingVatRate = Row.VatRate;
			DiffRow.OutgoingInvoiceType = Row.InvoiceType;
		EndIf;
		
		DiffRow.Amount = Row.Amount;
		Row.Amount = Row.Amount - DiffRow.Amount;	
	EndDo;
EndFunction



