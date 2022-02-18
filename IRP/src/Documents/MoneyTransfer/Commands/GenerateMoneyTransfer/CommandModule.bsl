&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);
	For Each FillingData In DocumentStructure Do
		OpenForm("Document.MoneyTransfer.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_CashTransferOrder = New Array();
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.CashTransferOrder") Then
			ArrayOf_CashTransferOrder.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_CashTransferOrder(ArrayOf_CashTransferOrder));	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn"           , New TypeDescription("String"));
	ValueTable.Columns.Add("Company"           , New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Branch"            , New TypeDescription("CatalogRef.BusinessUnits"));
	ValueTable.Columns.Add("CashTransferOrder" , New TypeDescription("DocumentRef.CashTransferOrder"));
	
	ValueTable.Columns.Add("Sender"       , New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("SendCurrency" , New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("SendFinancialMovementType", New TypeDescription("CatalogRef.ExpenseAndRevenueTypes"));
	ValueTable.Columns.Add("SendAmount"   , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	
	ValueTable.Columns.Add("Receiver"        , New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("ReceiveCurrency" , New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("ReceiveFinancialMovementType", New TypeDescription("CatalogRef.ExpenseAndRevenueTypes"));
	ValueTable.Columns.Add("ReceiveAmount"   , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;

	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, Company, Branch, CashTransferOrder,
		|Sender, SendCurrency, SendFinancialMovementType, SendAmount,
		|Receiver, ReceiveCurrency, ReceiveFinancialMovementType, ReceiveAmount");

	ArrayOfResults = New Array();

	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn"                      , Row.BasedOn);
		Result.Insert("Company"                      , Row.Company);
		Result.Insert("Branch"                       , Row.Branch);
		Result.Insert("CashTransferOrder"            , Row.CashTransferOrder);
		Result.Insert("Sender"                       , Row.Sender);
		Result.Insert("SendCurrency"                 , Row.SendCurrency);
		Result.Insert("SendFinancialMovementType"    , Row.SendFinancialMovementType);
		Result.Insert("SendAmount"                   , Row.SendAmount);
		Result.Insert("Receiver"                     , Row.Receiver);
		Result.Insert("ReceiveCurrency"              , Row.ReceiveCurrency);
		Result.Insert("ReceiveFinancialMovementType" , Row.ReceiveFinancialMovementType);
		Result.Insert("ReceiveAmount"                , Row.ReceiveAmount);
		
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments)
	Result = DocMoneyTransferServer.GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments);
	ErrorDocuments = New Array();
	For Each BasisDocument In ArrayOfBasisDocuments Do
		If Result.Count() Then
			If Not Result.FindRows(New Structure("CashTransferOrder", BasisDocument)).Count() Then
				ErrorDocuments.Add(BasisDocument);
			EndIf;
		Else
			ErrorDocuments.Add(BasisDocument);
		EndIf;
	EndDo;
	
	For Each Document In ErrorDocuments Do
		ErrorMessageText = StrTemplate(R().Error_105, Document);
		CommonFunctionsClientServer.ShowUsersMessage(ErrorMessageText);
	EndDo;
	Return Result;
EndFunction
