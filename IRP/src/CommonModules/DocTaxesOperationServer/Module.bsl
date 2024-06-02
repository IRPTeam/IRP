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
	|	Taxes.TaxableAmountBalance AS NetAmount,
	|	Taxes.TaxAmountBalance AS TaxAmount,
	|	Taxes.TaxableAmountBalance + Taxes.TaxAmountBalance AS TotalAmount
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
	
	GroupColumn = "VatRate";
	SumColumn = "NetAmount, TaxAmount, TotalAmount";
	QueryTable.GroupBy(GroupColumn, SumColumn);
	Address = PutToTempStorage(QueryTable, FormUUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, GroupColumn, SumColumn);
EndFunction

Function CalculateTaxDifference(val DocObject) Export
	Result = New Array();
	
	TotalTaxAmount_Incoming = DocObject.TaxesIncoming.Total("TaxAmount");
	TotalTaxAmount_Outgoing = DocObject.TaxesOutgoing.Total("TaxAmount");
	
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
	Return New Structure("Key, IncomingVatRate, OutgoingVatRate, NetAmount, TaxAmount");
EndFunction

Function Calculate_TaxOffset(MinTableName, MinTable, MaxTableName, MaxTable, Result)
	For Each MinRow In MinTable Do
		
		For Each MaxRow In MaxTable Do
			
			If Not ValueIsFilled(MinRow.NetAmount) 
				And Not ValueIsFilled(MinRow.TaxAmount) Then
					Continue;
			EndIf;
			
			If Not ValueIsFilled(MaxRow.NetAmount) 
				And Not ValueIsFilled(MaxRow.TaxAmount) Then
					Continue;
			EndIf;
			 
			DiffRow = GetTaxesDifferenceRow();
			Result.Add(DiffRow);
			DiffRow.Key = String(New UUID());	
			
			If MinTableName = "TaxesIncoming" Then
				DiffRow.IncomingVatRate = MinRow.VatRate;
			ElsIf MinTableName = "TaxesOutgoing" Then
				DiffRow.OutgoingVatRate = MinRow.VatRate;
			EndIf;
			
			If MaxTableName = "TaxesIncoming" Then
				DiffRow.IncomingVatRate = MaxRow.VatRate;
			ElsIf MaxTableName = "TaxesOutgoing" Then
				DiffRow.OutgoingVatRate = MaxRow.VatRate;
			EndIf;
						
			DiffRow.NetAmount = Min(MaxRow.NetAmount, MinRow.NetAmount);
			DiffRow.TaxAmount = Min(MaxRow.TaxAmount, MinRow.TaxAmount);
			
			MinRow.NetAmount = MinRow.NetAmount - DiffRow.NetAmount;
			MinRow.TaxAmount = MinRow.TaxAmount - DiffRow.TaxAmount;
			
			MaxRow.NetAmount = MaxRow.NetAmount - DiffRow.NetAmount;
			MaxRow.TaxAmount = MaxRow.TaxAmount - DiffRow.TaxAmount;
			
		EndDo;
	EndDo;
	Return Result;
EndFunction

Function Calculate_TaxPayment(TableName, Table, Result)
	For Each Row In Table Do
		DiffRow = GetTaxesDifferenceRow();
		Result.Add(DiffRow);
		DiffRow.Key = String(New UUID());	
			
		If TableName = "TaxesIncoming" Then
			DiffRow.IncomingVatRate = Row.VatRate;
		ElsIf TableName = "TaxesOutgoing" Then
			DiffRow.OutgoingVatRate = Row.VatRate;
		EndIf;
		
		DiffRow.NetAmount = Row.NetAmount;
		DiffRow.TaxAmount = Row.TaxAmount;
			
		Row.NetAmount = Row.NetAmount - DiffRow.NetAmount;
		Row.TaxAmount = Row.TaxAmount - DiffRow.TaxAmount;	
	EndDo;
EndFunction



