#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

#Region GENERATE_BY_BASIS

Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments, EndOfDate = Undefined) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R3035T_CashPlanning.BasisDocument AS BasisDocument,
	|	R3035T_CashPlanning.Recorder AS Recorder
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning AS R3035T_CashPlanning
	|WHERE
	|	R3035T_CashPlanning.BasisDocument IN (&ArrayOfBasisDocuments)
	|	AND (R3035T_CashPlanning.Recorder REFS Document.BankPayment
	|	OR R3035T_CashPlanning.Recorder REFS Document.BankReceipt
	|	OR R3035T_CashPlanning.Recorder REFS Document.CashPayment
	|	OR R3035T_CashPlanning.Recorder REFS Document.CashReceipt)
	|	AND
	|		R3035T_CashPlanning.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ArrayOfBasisDocumentsClear = New Array();
	For Each BasisDocument In ArrayOfBasisDocuments Do
		If Not QuerySelection.FindNext(BasisDocument, "BasisDocument") Then
			ArrayOfBasisDocumentsClear.Add(BasisDocument);
		EndIf;
	EndDo;
	If Not ArrayOfBasisDocumentsClear.Count() Then
		// error, BP/BR/CP/CR exists
		Return New ValueTable();
	EndIf;
	
	TempTableManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text = GetDocumentTable_CashTransferOrder_QueryText();
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocumentsClear);
	Query.SetParameter("UseArrayOfBasisDocuments", True);
	If EndOfDate = Undefined Then
		Query.SetParameter("EndOfDate", CurrentDate());
	Else
		Query.SetParameter("EndOfDate", EndOfDate);
	EndIf;

	Query.Execute();
	Query.Text =
	"SELECT
	|	tmp.BasedOn,
	|	tmp.Company,
	|	tmp.Branch,
	|	tmp.CashTransferOrder,
	|	tmp.Sender,
	|	tmp.SendCurrency,
	|	tmp.SendFinancialMovementType,
	|	tmp.SendAmount,
	|	tmp.Receiver,
	|	tmp.ReceiveCurrency,
	|	tmp.ReceiveFinancialMovementType,
	|	tmp.ReceiveAmount
	|FROM
	|	tmp_CashTransferOrder AS tmp";
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_CashTransferOrder_QueryText() Export
	Return 
	"SELECT ALLOWED
	|	""CashTransferOrder"" AS BasedOn,
	|	Incoming.Company AS Company,
	|	Incoming.Branch AS Branch,
	|	Incoming.Account AS Receiver,
	|	Incoming.Currency AS ReceiveCurrency,
	|	Incoming.FinancialMovementType AS ReceiveFinancialMovementType,
	|	Incoming.AmountTurnover AS ReceiveAmount,
	|	Incoming.BasisDocument AS CashTransferOrder
	|INTO tmp_Incoming
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(, &EndOfDate,,
	|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &UseArrayOfBasisDocuments
	|			THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|		ELSE TRUE
	|	END) AS Incoming
	|		INNER JOIN Document.CashTransferOrder AS Doc
	|		ON Incoming.BasisDocument = Doc.Ref
	|WHERE
	|	Incoming.AmountTurnover > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	""CashTransferOrder"" AS BasedOn,
	|	Outgoing.Company AS Company,
	|	Outgoing.Branch AS Branch,
	|	Outgoing.Account AS Sender,
	|	Outgoing.Currency AS SendCurrency,
	|	Outgoing.FinancialMovementType AS SendFinancialMovementType,
	|	Outgoing.AmountTurnover AS SendAmount,
	|	Outgoing.BasisDocument AS CashTransferOrder
	|INTO tmp_Outgoing
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(, &EndOfDate,,
	|		CashFlowDirection = VALUE(Enum.CashFlowDirections.Outgoing)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &UseArrayOfBasisDocuments
	|			THEN BasisDocument IN (&ArrayOfBasisDocuments)
	|		ELSE TRUE
	|	END) AS Outgoing
	|		INNER JOIN Document.CashTransferOrder AS Doc
	|		ON Outgoing.BasisDocument = Doc.Ref
	|WHERE
	|	Outgoing.AmountTurnover > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ISNULL(tmp_Outgoing.BasedOn, tmp_Incoming.BasedOn) AS BasedOn,
	|	ISNULL(tmp_Outgoing.Company, tmp_Incoming.Company) AS Company,
	|	ISNULL(tmp_Outgoing.Branch, tmp_Incoming.Branch) AS Branch,
	|	ISNULL(tmp_Outgoing.CashTransferOrder, tmp_Incoming.CashTransferOrder) AS CashTransferOrder,
	|	tmp_Outgoing.Sender AS Sender,
	|	tmp_Outgoing.SendCurrency AS SendCurrency,
	|	tmp_Outgoing.SendFinancialMovementType AS SendFinancialMovementType,
	|	tmp_Outgoing.SendAmount AS SendAmount,
	|	tmp_Incoming.Receiver AS Receiver,
	|	tmp_Incoming.ReceiveCurrency AS ReceiveCurrency,
	|	tmp_Incoming.ReceiveFinancialMovementType AS ReceiveFinancialMovementType,
	|	tmp_Incoming.ReceiveAmount AS ReceiveAmount
	|INTO tmp_CashTransferOrder
	|FROM
	|	tmp_Outgoing AS tmp_Outgoing
	|		FULL JOIN tmp_Incoming AS tmp_Incoming
	|		ON tmp_Outgoing.CashTransferOrder = tmp_Incoming.CashTransferOrder";
EndFunction

Function GetDocumentTable_CashTransferOrder_ForClient(ArrayOfBasisDocuments, ObjectRef = Undefined) Export
	EndOfDate = Undefined;
	If ValueIsFilled(ObjectRef) Then
		EndOfDate = New Boundary(ObjectRef.PointInTime(), BoundaryType.Excluding);
	EndIf;
	ArrayOfResults = New Array();
	ValueTable = GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments, EndOfDate);
	For Each Row In ValueTable Do
		NewRow = New Structure();
		NewRow.Insert("BasedOn"                      , Row.BasedOn);
		NewRow.Insert("Company"                      , Row.Company);
		NewRow.Insert("Branch"                       , Row.Branch);
		NewRow.Insert("CashTransferOrder"            , Row.CashTransferOrder);
		NewRow.Insert("Sender"                       , Row.Sender);
		NewRow.Insert("SendCurrency"                 , Row.SendCurrency);
		NewRow.Insert("SendFinancialMovementType"    , Row.SendFinancialMovementType);
		NewRow.Insert("SendAmount"                   , Row.SendAmount);
		NewRow.Insert("Receiver"                     , Row.Receiver);
		NewRow.Insert("ReceiveCurrency"              , Row.ReceiveCurrency);
		NewRow.Insert("ReceiveFinancialMovementType" , Row.ReceiveFinancialMovementType);
		NewRow.Insert("ReceiveAmount"                , Row.ReceiveAmount);
		ArrayOfResults.Add(NewRow);
	EndDo;
	Return ArrayOfResults;
EndFunction

#EndRegion

#Region LIST_FROM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region SERVICE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title), Form.Items[Atr].Title,
			Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion
