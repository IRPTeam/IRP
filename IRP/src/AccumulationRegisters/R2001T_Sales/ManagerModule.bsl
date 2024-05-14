
Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	If Not RowIDInfoServer.LinkedRowsIntegrityIsEnable() Then
		Return True;
	EndIf;
	
	Query = New Query();
	//@skip-check bsl-ql-hub
	Query.Text = 
	"SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	Records.Quantity
	|INTO Records_InDocument_NotFiltered
	|FROM
	|	&Records_InDocument AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	Records.Quantity
	|INTO Records_InDocument
	|FROM
	|	Records_InDocument_NotFiltered AS Records
	|WHERE
	|	NOT Records.Invoice.Ref IS NULL
	|	AND Records.Invoice.Ref REFS Document.SalesInvoice
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_InDocument.ItemKey,
	|	ItemList_InDocument.LineNumber
	|INTO ItemList_InDocument
	|FROM
	|	&ItemList_InDocument AS ItemList_InDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	Records.CurrencyMovementType,
	|	Records.Quantity
	|INTO Records_Exists_NotFiltered
	|FROM
	|	&Records_Exists AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	Records.Quantity
	|INTO Records_Exists
	|FROM
	|	Records_Exists_NotFiltered AS Records
	|WHERE
	|	Records.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND NOT Records.Invoice.Ref IS NULL
	|	AND Records.Invoice.Ref REFS Document.SalesInvoice
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	Records.Quantity,
	|	ItemList_InDocument.LineNumber
	|INTO Records_with_LineNumbers
	|FROM
	|	Records_InDocument AS Records
	|		LEFT JOIN ItemList_InDocument AS ItemList_InDocument
	|		ON Records.ItemKey = ItemList_InDocument.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	Records.Quantity,
	|	Records.LineNumber
	|INTO Sales_All
	|FROM
	|	Records_with_LineNumbers AS Records
	|
	|UNION ALL
	|
	|SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	Records.Quantity,
	|	UNDEFINED
	|FROM
	|	Records_Exists AS Records
	|		LEFT JOIN Records_with_LineNumbers AS Records_with_LineNumbers
	|		ON Records.ItemKey = Records_with_LineNumbers.ItemKey
	|		AND Records.Invoice = Records_with_LineNumbers.Invoice
	|WHERE
	|	Records_with_LineNumbers.ItemKey IS NULL
	|	AND NOT &Unposting
	|;
	|//////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Invoice,
	|	Records.ItemKey,
	|	MIN(Records.LineNumber) AS LineNumber,
	|	SUM(Records.Quantity) AS Quantity
	|INTO Sales
	|FROM
	|	Sales_All AS Records
	|GROUP BY
	|	Records.Invoice,
	|	Records.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R2001T_SalesTurnovers.Invoice,
	|	R2001T_SalesTurnovers.ItemKey,
	|	SUM(R2001T_SalesTurnovers.QuantityTurnover) AS QuantityBalance
	|INTO SalesBalance
	|FROM
	|	AccumulationRegister.R2001T_Sales.Turnovers(, , , (Invoice, ItemKey, CurrencyMovementType) IN
	|		(SELECT
	|			Sales.Invoice,
	|			Sales.ItemKey,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			Sales AS Sales)) AS R2001T_SalesTurnovers
	|GROUP BY
	|	R2001T_SalesTurnovers.Invoice,
	|	R2001T_SalesTurnovers.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Sales.ItemKey.Item AS Item,
	|	Sales.ItemKey AS ItemKey,
	|	Sales.Invoice,
	|	SalesBalance.QuantityBalance AS QuantityBalance,
	|	case
	|		when Sales.Quantity < 0
	|			then -Sales.Quantity
	|		else Sales.Quantity
	|	end AS Quantity,
	|	-SalesBalance.QuantityBalance AS LackOfBalance,
	|	Sales.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	Sales AS Sales
	|		INNER JOIN SalesBalance AS SalesBalance
	|		ON Sales.Invoice = SalesBalance.Invoice
	|		AND Sales.ItemKey = SalesBalance.ItemKey
	|WHERE
	|	SalesBalance.QuantityBalance < 0
	|
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Records_InDocument", Records_InDocument);
	Query.SetParameter("ItemList_InDocument", ItemList_InDocument);
	Query.SetParameter("Records_Exists", Records_Exists);
	Query.SetParameter("Unposting", Unposting);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "Invoice, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "Quantity");
		ErrorParameters.Insert("FilterColumns", "Invoice, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Return");
		ErrorParameters.Insert("RecordType", RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction

#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion