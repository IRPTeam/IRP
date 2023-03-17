&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	ArrayOfBasises = New Array();
	ArrayOf_SalesReportToConsignors = New Array();
	
	For Each Basis In CommandParameter Do
		If TypeOf(Basis) = Type("DocumentRef.SalesReportToConsignor") Then
			ArrayOf_SalesReportToConsignors.Add(Basis);
		Else
			ArrayOfBasises.Add(Basis);
		EndIf;	
	EndDo;
	
	If ArrayOfBasises.Count() Then
		FormParameters = New Structure();
		FormParameters.Insert("Filter", New Structure("Basises, Ref", ArrayOfBasises, PredefinedValue("Document.SalesInvoice.EmptyRef")));
		FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo());
		FormParameters.Insert("SetAllCheckedOnOpen", True);

		OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
			New NotifyDescription("AddDocumentRowsContinue", ThisObject), FormWindowOpeningMode.LockOwnerWindow);
	Else
		DocumentStructure = GetDocumentsStructure(ArrayOf_SalesReportToConsignors);

		For Each FillingData In DocumentStructure Do
			OpenForm("Document.SalesInvoice.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
		EndDo;		
	EndIf;
EndProcedure

&AtClient
Procedure AddDocumentRowsContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each FillingValues In Result.FillingValues Do
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.SalesInvoice.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_SalesReportToConsignor(ArrayOfBasisDocuments));
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn"         , New TypeDescription("String"));
	
	DocMetadata = Metadata.Documents.SalesInvoice.Attributes;
	ValueTable.Columns.Add("Company"           , DocMetadata.Company.Type);
	ValueTable.Columns.Add("Partner"           , DocMetadata.Partner.Type);
	ValueTable.Columns.Add("Agreement"         , DocMetadata.Agreement.Type);
	ValueTable.Columns.Add("LegalName"         , DocMetadata.LegalName.Type);
	ValueTable.Columns.Add("LegalNameContract" , DocMetadata.LegalNameContract.Type);
	ValueTable.Columns.Add("PriceIncludeTax"   , DocMetadata.PriceIncludeTax.Type);
	ValueTable.Columns.Add("Currency"          , DocMetadata.Currency.Type);
	ValueTable.Columns.Add("TransactionType"   , DocMetadata.TransactionType.Type);
	
	ItemListMetadata = Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes;
	ValueTable.Columns.Add("Item"             , ItemListMetadata.Item.Type);
	ValueTable.Columns.Add("ItemKey"          , ItemListMetadata.ItemKey.Type);
	ValueTable.Columns.Add("Price"            , ItemListMetadata.Price.Type);
	ValueTable.Columns.Add("Quantity"         , ItemListMetadata.Quantity.Type);
	ValueTable.Columns.Add("ProfitLossCenter" , ItemListMetadata.ProfitLossCenter.Type);
	ValueTable.Columns.Add("RevenueType"      , ItemListMetadata.RevenueType.Type);
	ValueTable.Columns.Add("InventoryOrigin"  , ItemListMetadata.InventoryOrigin.Type);
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;

	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, Company, TransactionType, Partner, Agreement, LegalName, LegalNameContract, PriceIncludeTax, Currency");

	ArrayOfResults = New Array();

	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn"           , Row.BasedOn);		
		Result.Insert("Company"           , Row.Company);
		Result.Insert("TransactionType"   , Row.TransactionType);
		Result.Insert("Partner"           , Row.Partner);
		Result.Insert("Agreement"         , Row.Agreement);
		Result.Insert("LegalName"         , Row.LegalName);
		Result.Insert("LegalNameContract" , Row.LegalNameContract);
		Result.Insert("PriceIncludeTax"   , Row.PriceIncludeTax);
		Result.Insert("Currency"          , Row.Currency);
		Result.Insert("ItemList"          , New Array());

		Filter = New Structure();
		Filter.Insert("BasedOn"           , Row.BasedOn);
		Filter.Insert("Company"           , Row.Company);
		Filter.Insert("TransactionType"   , Row.TransactionType);
		Filter.Insert("Partner"           , Row.Partner);
		Filter.Insert("Agreement"         , Row.Agreement);
		Filter.Insert("LegalName"         , Row.LegalName);
		Filter.Insert("LegalNameContract" , Row.LegalNameContract);
		Filter.Insert("PriceIncludeTax"   , Row.PriceIncludeTax);
		Filter.Insert("Currency"          , Row.Currency);
		
		ItemList = ValueTable.Copy(Filter);
		For Each RowItemList In ItemList Do
			NewRow = New Structure();
			NewRow.Insert("Item"             , RowItemList.Item);
			NewRow.Insert("ItemKey"          , RowItemList.ItemKey);
			NewRow.Insert("InventoryOrigin"  , RowItemList.InventoryOrigin);
			NewRow.Insert("Price"            , RowItemList.Price);
			NewRow.Insert("Quantity"         , RowItemList.Quantity);
			NewRow.Insert("ProfitLossCenter" , RowItemList.ProfitLossCenter);
			NewRow.Insert("RevenueType"      , RowItemList.RevenueType);
			Result.ItemList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_SalesReportToConsignor(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT
	|	""SalesReportToConsignor"" AS BasedOn,
	|	ItemList.Ref.Company AS Company,
	|	VALUE(Enum.SalesTransactionTypes.Sales) AS TransactionType,
	|	VALUE(Enum.InventoryOriginTypes.OwnStocks) AS InventoryOrigin,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.LegalNameContract AS LegalNameContract,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	SUM(ItemList.TradeAgentFeeAmount) AS Price,
	|	1 AS Quantity,
	|	ItemList.Ref.Agreement.TradeAgentFeeItem AS Item,
	|	ItemList.Ref.Agreement.TradeAgentFeeItemKey AS ItemKey,
	|	ItemList.Ref.Agreement.TradeAgentFeeProfitLossCenter AS ProfitLossCenter,
	|	ItemList.Ref.Agreement.TradeAgentFeeExpenseRevenueType AS RevenueType
	|FROM
	|	Document.SalesReportToConsignor.ItemList AS ItemList
	|WHERE
	|	ItemList.Ref IN (&ArrayOfBasisDocuments)
	|	AND ItemList.Ref.Posted
	|GROUP BY
	|	ItemList.Ref.Company,
	|	ItemList.Ref.Partner,
	|	ItemList.Ref.Agreement,
	|	ItemList.Ref.LegalName,
	|	ItemList.Ref.LegalNameContract,
	|	ItemList.Ref.Currency,
	|	ItemList.Ref.PriceIncludeTax,
	|	ItemList.Ref.Agreement.TradeAgentFeeItem,
	|	ItemList.Ref.Agreement.TradeAgentFeeItemKey,
	|	VALUE(Enum.SalesTransactionTypes.Sales),
	|	VALUE(Enum.InventoryOriginTypes.OwnStocks),
	|	ItemList.Ref.Agreement.TradeAgentFeeProfitLossCenter,
	|	ItemList.Ref.Agreement.TradeAgentFeeExpenseRevenueType";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction
