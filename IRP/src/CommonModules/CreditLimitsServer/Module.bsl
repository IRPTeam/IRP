
Procedure CheckCreditLimit(Ref, Cancel) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	R2021B_CustomersTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Partner = &Partner
	|	AND Agreement = &Agreement) AS R2021B_CustomersTransactionsBalance";
	Query.SetParameter("Period", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Query.SetParameter("Partner", Ref.Partner);
	Query.SetParameter("Agreement", Ref.Agreement);

	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then

		CreditLimitAmount = Ref.Agreement.CreditLimitAmount;

		If (QuerySelection.AmountBalance + Ref.DocumentAmount) > CreditLimitAmount Then
			Cancel = True;
			Message = StrTemplate(R().Error_085, CreditLimitAmount, CreditLimitAmount - QuerySelection.AmountBalance,
				Ref.DocumentAmount, (QuerySelection.AmountBalance + Ref.DocumentAmount) - CreditLimitAmount,
				Ref.Currency);
			CommonFunctionsClientServer.ShowUsersMessage(Message);
		EndIf;
	EndIf;
EndProcedure

Procedure CheckCreditLimitByPartner(ShipmentDoc, Date, Cancel) Export
	DocumentType = TypeOf(ShipmentDoc);
	
	If DocumentType = Type("DocumentRef.SalesInvoice") Then
		DocumentData = GetInvoiceAmount(ShipmentDoc);
	ElsIf DocumentType = Type("DocumentRef.ShipmentPlaningOrder")
	 		Or DocumentType = Type("DocumentRef.ShipmentConfirmation") Then
		DocumentData = GetShipmentAmount(ShipmentDoc);
	Else
		Raise StrTemplate("Unsupported document type [%1]", TypeOf(ShipmentDoc));
	EndIf;
	
	LimitAmount = GetCreditLimits(ShipmentDoc, Date, DocumentData.Partner, DocumentData.CurrencyMovementType);
	If LimitAmount = 0 Then
		Return;
	EndIf;
	
	DebtData = GetDebtAmount(ShipmentDoc, DocumentData.Partner, DocumentData.Currency);
	
	If (DebtData.DebtAmount + DocumentData.Amount) > LimitAmount Then
		Cancel = True;
		Message = StrTemplate(R().Error_085, LimitAmount, LimitAmount - DebtData.DebtAmount,
			DocumentData.Amount, (DebtData.DebtAmount + DocumentData.Amount) -LimitAmount,
			DebtData.Currency);
		CommonFunctionsClientServer.ShowUsersMessage(Message);
	EndIf;
EndProcedure

Function GetCreditLimits(ShipmentDoc, Date, Partner, CurrencyMovementType)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SUM(ISNULL(CreditLimitsSliceLast.LimitAmount, 0)) AS LimitAmount
	|FROM
	|	InformationRegister.CreditLimits.SliceLast(&Period, Partner = &Partner
	|	AND CurrencyMovementType = &CurrencyMovementType) AS CreditLimitsSliceLast";
	
	Query.SetParameter("Partner", Partner);
	Query.SetParameter("CurrencyMovementType", CurrencyMovementType);
	Query.SetParameter("Period", CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(ShipmentDoc, Date));
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	LimitAmount = 0;
	
	If QuerySelection.Next() Then
		LimitAmount = QuerySelection.LimitAmount;
	EndIf;
	Return LimitAmount;
EndFunction

Function GetDebtAmount(ShipmentDoc, Partner, Currency)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R5020B_PartnersBalanceBalance.Partner AS Partner,
	|	R5020B_PartnersBalanceBalance.TransactionCurrency AS Currency,
	|	SUM(R5020B_PartnersBalanceBalance.CustomerTransactionBalance +
	|		R5020B_PartnersBalanceBalance.CustomerAdvanceBalance) AS DebtAmount
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance.Balance(&BalancePeriod, Partner = &Partner
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Currency = &Currency) AS R5020B_PartnersBalanceBalance
	|GROUP BY
	|	R5020B_PartnersBalanceBalance.Partner,
	|	R5020B_PartnersBalanceBalance.TransactionCurrency";
	
	If ValueIsFilled(ShipmentDoc) Then
		BalancePeriod = New Boundary(ShipmentDoc.PointInTime(), BoundaryType.Excluding);
	Else
		BalancePeriod = New Boundary(ShipmentDoc.Date, BoundaryType.Excluding);
	EndIf;
	
	Query.SetParameter("Partner", Partner);
	Query.SetParameter("BalancePeriod", BalancePeriod);
	Query.SetParameter("Currency", Currency);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Structure("Partner, Currency, DebtAmount", Undefined, Undefined, 0);
	
	If QuerySelection.Next() Then
		Result.Partner = QuerySelection.Partner;
		Result.Currency = QuerySelection.Currency;
		Result.DebtAmount = QuerySelection.DebtAmount;
	EndIf;
	Return Result;
EndFunction

Function GetShipmentAmount(ShipmentDoc)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Quantity AS ShipmentQuantity,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS Basis
	|INTO Shipment
	|FROM
	|	Document.ShipmentPlaningOrder.ItemList AS ItemList
	|		INNER JOIN Document.ShipmentPlaningOrder.RowIDInfo AS RowIDInfo
	|		ON ItemList.Key = RowIDInfo.Key
	|		AND RowIDInfo.Basis REFS Document.SalesOrder
	|		AND ItemList.Ref = &ShipmentDoc
	|GROUP BY
	|	ItemList.Quantity,
	|	RowIDInfo.RowID,
	|	RowIDInfo.Basis
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Shipment.ShipmentQuantity AS ShipmentQuantity,
	|	Shipment.Basis AS Basis,
	|	SalesOrderRowIDInfo.Key AS Key
	|INTO Ordering
	|FROM
	|	Shipment AS Shipment
	|		INNER JOIN Document.SalesOrder.RowIDInfo AS SalesOrderRowIDInfo
	|		ON Shipment.RowID = SalesOrderRowIDInfo.RowID
	|		AND SalesOrderRowIDInfo.Ref = CAST(Shipment.Basis AS Document.SalesOrder)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ROUND(SUM(CASE
	|		WHEN ISNULL(SalesOrderItemList.Quantity, 0) = 0
	|		OR ISNULL(SalesOrderCurrencies.Multiplicity, 0) = 0
	|			THEN 0
	|		ELSE ISNULL(SalesOrderItemList.TotalAmount, 0) * ISNULL(SalesOrderCurrencies.Rate, 0) /
	|			ISNULL(SalesOrderCurrencies.Multiplicity, 0) / ISNULL(SalesOrderItemList.Quantity, 0) * Ordering.ShipmentQuantity
	|	END), 2) AS ShipmentAmount,
	|	SalesOrderItemList.Ref.Partner,
	|	SalesOrderItemList.Ref.Agreement,
	|	SalesOrderItemList.Ref.Agreement.CurrencyMovementType AS CurrencyMovementType,
	|	SalesOrderItemList.Ref.Agreement.CurrencyMovementType.Currency AS Currency
	|FROM
	|	Ordering AS Ordering
	|		LEFT JOIN Document.SalesOrder.ItemList AS SalesOrderItemList
	|		ON SalesOrderItemList.Key = Ordering.Key
	|		AND SalesOrderItemList.Ref = CAST(Ordering.Basis AS Document.SalesOrder)
	|		LEFT JOIN Document.SalesOrder.Currencies AS SalesOrderCurrencies
	|		ON SalesOrderCurrencies.MovementType = SalesOrderCurrencies.Ref.Agreement.CurrencyMovementType
	|		AND SalesOrderCurrencies.Ref = CAST(Ordering.Basis AS Document.SalesOrder)
	|GROUP BY
	|	SalesOrderItemList.Ref.Partner,
	|	SalesOrderItemList.Ref.Agreement,
	|	SalesOrderItemList.Ref.Agreement.CurrencyMovementType,
	|	SalesOrderItemList.Ref.Agreement.CurrencyMovementType.Currency";

	Query.Text = StrReplace(Query.Text, "ShipmentPlaningOrder", ShipmentDoc.Metadata().Name);	
	Query.SetParameter("ShipmentDoc", ShipmentDoc);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Structure("Partner, Agreement, CurrencyMovementType, Currency, Amount", 
		Undefined, Undefined, Undefined, Undefined, 0);
	
	If QuerySelection.Next() Then
		Result.Partner = QuerySelection.Partner;
		Result.Agreement = QuerySelection.Agreement;
		Result.CurrencyMovementType = QuerySelection.CurrencyMovementType;
		Result.Currency = QuerySelection.Currency;
		Result.Amount = QuerySelection.ShipmentAmount;
	EndIf;
	Return Result;
EndFunction
	
Function GetInvoiceAmount(ShipmentDoc)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.TotalAmount AS TotalAmount,
	|	ItemList.Ref AS Ref
	|INTO ItemList
	|FROM
	|	Document.SalesInvoice.ItemList AS ItemList
	|WHERE
	|	ItemList.Ref = &ShipmentDoc
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(CASE
	|		WHEN ISNULL(Currencies.Multiplicity, 0) = 0
	|			THEN 0
	|		ELSE ISNULL(ItemList.TotalAmount, 0) * ISNULL(Currencies.Rate, 0) / ISNULL(Currencies.Multiplicity, 0)
	|	END) AS InvoiceAmount,
	|	ItemList.Partner AS Partner,
	|	ItemList.Agreement AS Agreement,
	|	ItemList.Agreement.CurrencyMovementType AS CurrencyMovementType,
	|	ItemList.Agreement.CurrencyMovementType.Currency AS Currency
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN Document.SalesInvoice.Currencies AS Currencies
	|		ON Currencies.MovementType = ItemList.Agreement.CurrencyMovementType
	|		AND Currencies.Ref = ItemList.Ref
	|GROUP BY
	|	ItemList.Partner,
	|	ItemList.Agreement,
	|	ItemList.Agreement.CurrencyMovementType,
	|	ItemList.Agreement.CurrencyMovementType.Currency";
		
	Query.SetParameter("ShipmentDoc", ShipmentDoc);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Structure("Partner, Agreement, CurrencyMovementType, Currency, Amount", 
		Undefined, Undefined, Undefined, Undefined, 0);
	
	If QuerySelection.Next() Then
		Result.Partner = QuerySelection.Partner;
		Result.Agreement = QuerySelection.Agreement;
		Result.CurrencyMovementType = QuerySelection.CurrencyMovementType;
		Result.Currency = QuerySelection.Currency;
		Result.Amount = QuerySelection.InvoiceAmount;
	EndIf;
	Return Result;
EndFunction

	