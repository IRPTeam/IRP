#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
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
	SerialLotNumbersServer.UpdateSerialLotNumbersPresentation(Object);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("LegalNameContract");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetConsignorSales(Parameters) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ConsignorSales.ItemKey.Item AS Item,
	|	ConsignorSales.ItemKey AS ItemKey,
	|	ConsignorSales.Unit AS Unit,
	|	ConsignorSales.PriceType AS PriceType,
	|	ConsignorPrices.Price AS ConsignorPrice,
	|	ConsignorSales.Price AS Price,
	|	SUM(CASE
	|		WHEN ConsignorSales.QuantityTurnover < 0
	|			THEN -BatchBalance.Quantity
	|		ELSE BatchBalance.Quantity
	|	END) AS Quantity,
	|	SUM(CASE
	|		WHEN ConsignorSales.QuantityTurnover = 0
	|			THEN 0
	|		ELSE CASE
	|			WHEN ConsignorSales.QuantityTurnover < 0
	|				THEN -(ConsignorSales.NetAmountTurnover / ConsignorSales.QuantityTurnover * BatchBalance.Quantity)
	|			ELSE ConsignorSales.NetAmountTurnover / ConsignorSales.QuantityTurnover * BatchBalance.Quantity
	|		END
	|	END) AS NetAmount,
	|	SUM(CASE
	|		WHEN ConsignorSales.QuantityTurnover = 0
	|			THEN 0
	|		ELSE CASE
	|			WHEN ConsignorSales.QuantityTurnover < 0
	|				THEN -(ConsignorSales.AmountTurnover / ConsignorSales.QuantityTurnover * BatchBalance.Quantity)
	|			ELSE ConsignorSales.AmountTurnover / ConsignorSales.QuantityTurnover * BatchBalance.Quantity
	|		END
	|	END) AS TotalAmount,
	|	ConsignorSales.SalesInvoice AS SalesInvoice,
	|	BatchBalance.Batch.Document AS PurchaseInvoice,
	|	ConsignorSales.SerialLotNumber AS SerialLotNumber,
	|	ConsignorSales.SourceOfOrigin AS SourceOfOrigin,
	|	0 AS SumColumn,
	|	TRUE AS Use,
	|	CASE
	|		WHEN BatchBalance.Agreement.TradeAgentFeeType = VALUE(Enum.TradeAgentFeeTypes.Percent)
	|			THEN BatchBalance.Agreement.TradeAgentFeePercent
	|		ELSE 0
	|	END AS TradeAgentFeePercent
	|FROM
	|	AccumulationRegister.R8014T_ConsignorSales.Turnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY),,
	|		Company = &Company
	|	AND PriceIncludeTax = &PriceIncludeTax
	|	AND CurrencyMovementType = &CurrencyMovementType) AS ConsignorSales
	|		INNER JOIN AccumulationRegister.R6020B_BatchBalance AS BatchBalance
	|		ON (BatchBalance.Company = ConsignorSales.Company)
	|		AND (BatchBalance.ItemKey = ConsignorSales.ItemKey)
	|		AND (BatchBalance.Recorder = ConsignorSales.SalesInvoice)
	|		AND (BatchBalance.SourceOfOrigin = ConsignorSales.SourceOfOrigin)
	|		AND (CASE
	|			WHEN ConsignorSales.SerialLotNumber.BatchBalanceDetail
	|				THEN BatchBalance.SerialLotNumber = ConsignorSales.SerialLotNumber
	|			ELSE TRUE
	|		END)
	|		AND (BatchBalance.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks))
	|		AND (BatchBalance.RecordType = VALUE(AccumulationRecordType.Expense))
	|		AND (BatchBalance.Partner = &Partner)
	|		AND (BatchBalance.Agreement = &Agreement)
	|		INNER JOIN AccumulationRegister.R8015T_ConsignorPrices AS ConsignorPrices
	|		ON (ConsignorPrices.Company = ConsignorSales.Company)
	|		AND (ConsignorPrices.Partner = &Partner)
	|		AND (ConsignorPrices.Agreement = &Agreement)
	|		AND (ConsignorPrices.ItemKey = ConsignorSales.ItemKey)
	|		AND (ConsignorPrices.SourceOfOrigin = ConsignorSales.SourceOfOrigin)
	|		AND (ConsignorPrices.SerialLotNumber = ConsignorSales.SerialLotNumber)
	|		AND (ConsignorPrices.CurrencyMovementType = &CurrencyMovementType)
	|		AND (ConsignorPrices.Recorder = BatchBalance.Batch.Document)
	|WHERE
	|	ConsignorSales.QuantityTurnover <> 0
	|GROUP BY
	|	ConsignorSales.ItemKey.Item,
	|	ConsignorSales.ItemKey,
	|	ConsignorSales.Unit,
	|	ConsignorSales.PriceType,
	|	ConsignorPrices.Price,
	|	ConsignorSales.Price,
	|	ConsignorSales.SalesInvoice,
	|	BatchBalance.Batch.Document,
	|	ConsignorSales.SerialLotNumber,
	|	ConsignorSales.SourceOfOrigin,
	|	CASE
	|		WHEN BatchBalance.Agreement.TradeAgentFeeType = VALUE(Enum.TradeAgentFeeTypes.Percent)
	|			THEN BatchBalance.Agreement.TradeAgentFeePercent
	|		ELSE 0
	|	END";
	
	Query.SetParameter("StartDate"       , Parameters.StartDate);
	Query.SetParameter("EndDate"         , Parameters.EndDate);
	Query.SetParameter("Company"         , Parameters.Company);
	Query.SetParameter("Partner"         , Parameters.Partner);
	Query.SetParameter("Agreement"       , Parameters.Agreement);
	Query.SetParameter("PriceIncludeTax" , Parameters.PriceIncludeTax);
	Query.SetParameter("CurrencyMovementType" , ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction
