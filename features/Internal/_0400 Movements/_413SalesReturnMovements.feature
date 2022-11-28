#language: en
@tree
@Positive
@Movements
@MovementsSalesReturn

Feature: check Sales return movements


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _041300 preparation (Sales return)
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog LegalNameContracts objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create document ShipmentConfirmation (stock control serial lot numbers)
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
		When settings for Main Company (commission trade)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load Bank receipt
		When Create document BankReceipt objects (check movements, advance)
		And I execute 1C:Enterprise script at server
 			| "Documents.BankReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load SO
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		When Create document SalesOrder objects (SI more than SO)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |	
	* Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Goods
		When Create document GoodsReceipt objects (check movements, transaction type - return from customers)
		And I execute 1C:Enterprise script at server
 			| "Documents.GoodsReceipt.FindByNumber(125).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales return order
		When Create document SalesReturnOrder objects (check movements)
		And Delay 5
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows
		When Create document SalesInvoice objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document BankReceipt objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
 			| "Documents.BankReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales return
		When Create document SalesReturn objects (check movements)
		When Create document SalesReturn objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '104' |
		And in the table "List" I click the button named "ListContextMenuPost"
		When Create document SalesReturn objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesReturn.FindByNumber(106).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(107).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(108).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(109).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows
	* Load document commission trade
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		When Create document SalesInvoice and SalesReturn objects (comission trade)
		When Create document SalesInvoice objects (comission trade, consignment)
		When Create document SalesReturn objects (comission trade, consignment)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(194).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(193).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(193).GetObject().Write(DocumentWriteMode.Posting);" |
	* Check query for sales return movements
		Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
		And in the table "Info" I click "Fill movements" button
		And "Info" table contains lines
			| '#'   | 'Document'    | 'Register'                         | 'Recorder' | 'Conditions'                                                                                                                                                                                                                                    | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 'Parameters'                      | 'Receipt' | 'Expense' |
			| '489' | 'SalesReturn' | 'R8011B_TradeAgentSerialLotNumber' | 'Yes'      | 'SerialLotNumbers.IsReturnFromTradeAgent'                                                                                                                                                                                                       | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    SerialLotNumbers.Period AS Period,\n    SerialLotNumbers.Company AS Company,\n    SerialLotNumbers.ItemKey AS ItemKey,\n    SerialLotNumbers.Partner AS Partner,\n    SerialLotNumbers.Agreement AS Agreement,\n    SerialLotNumbers.SerialLotNumber AS SerialLotNumber,\n    SerialLotNumbers.Quantity AS Quantity\nINTO R8011B_TradeAgentSerialLotNumber\nFROM\n    SerialLotNumbers AS SerialLotNumbers\nWHERE\n    SerialLotNumbers.IsReturnFromTradeAgent'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'Yes'     |
			| '490' | 'SalesReturn' | 'T2015S_TransactionsInfo'          | 'Yes'      | 'ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                 | 'SELECT\n    ItemList.Period AS Date,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Currency AS Currency,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    TRUE AS IsCustomerTransaction,\n    ItemList.BasisDocument AS TransactionBasis,\n    -SUM(ItemList.Amount) AS Amount,\n    TRUE AS IsDue\nINTO T2015S_TransactionsInfo\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsReturnFromCustomer\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.Currency,\n    ItemList.Partner,\n    ItemList.LegalName,\n    ItemList.Agreement,\n    ItemList.BasisDocument'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '491' | 'SalesReturn' | 'T6020S_BatchKeysInfo'             | 'Yes'      | 'Query 0:\nTRUE\nQuery 1:\nNOT ItemList.IsService\nItemList.IsReturnFromTradeAgent'                                                                                                                                                             | 'SELECT\n    BatchKeysInfo.Period AS Period,\n    BatchKeysInfo.Company AS Company,\n    BatchKeysInfo.Currency AS Currency,\n    BatchKeysInfo.CurrencyMovementType AS CurrencyMovementType,\n    BatchKeysInfo.Direction AS Direction,\n    BatchKeysInfo.SalesInvoice AS SalesInvoice,\n    BatchKeysInfo.ItemKey AS ItemKey,\n    BatchKeysInfo.Store AS Store,\n    SUM(BatchKeysInfo.Quantity) AS Quantity,\n    SUM(BatchKeysInfo.Amount) AS Amount,\n    SUM(BatchKeysInfo.AmountTax) AS AmountTax,\n    BatchKeysInfo.BatchConsignor AS BatchConsignor\nINTO T6020S_BatchKeysInfo\nFROM\n    BatchKeysInfo AS BatchKeysInfo\nWHERE\n    TRUE\n\nGROUP BY\n    BatchKeysInfo.Period,\n    BatchKeysInfo.Company,\n    BatchKeysInfo.Currency,\n    BatchKeysInfo.CurrencyMovementType,\n    BatchKeysInfo.Direction,\n    BatchKeysInfo.SalesInvoice,\n    BatchKeysInfo.ItemKey,\n    BatchKeysInfo.Store,\n    BatchKeysInfo.BatchConsignor\n\nUNION ALL\n\nSELECT\n    ItemList.Period,\n    ItemList.Company,\n    UNDEFINED,\n    UNDEFINED,\n    VALUE(Enum.BatchDirection.Expense),\n    UNDEFINED,\n    ItemList.ItemKey,\n    ItemList.TradeAgentStore,\n    SUM(ItemList.Quantity),\n    0,\n    0,\n    UNDEFINED\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.IsReturnFromTradeAgent\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.ItemKey,\n    ItemList.TradeAgentStore'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '492' | 'SalesReturn' | 'R6060T_CostOfGoodsSold'           | 'Yes'      | ''                                                                                                                                                                                                                                              | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ''                                | 'No'      | 'No'      |
			| '493' | 'SalesReturn' | 'R2005T_SalesSpecialOffers'        | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                          | 'SELECT\n    OffersInfo.Period AS Period,\n    OffersInfo.RowKey AS RowKey,\n    OffersInfo.ItemKey AS ItemKey,\n    OffersInfo.Company AS Company,\n    OffersInfo.Branch AS Branch,\n    OffersInfo.Currency AS Currency,\n    OffersInfo.SpecialOffer AS SpecialOffer,\n    OffersInfo.Invoice AS Invoice,\n    OffersInfo.OffersAmount AS OffersAmount,\n    OffersInfo.SalesAmount AS SalesAmount,\n    OffersInfo.NetAmount AS NetAmount\nINTO R2005T_SalesSpecialOffers\nFROM\n    OffersInfo AS OffersInfo\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '494' | 'SalesReturn' | 'R5010B_ReconciliationStatement'   | 'Yes'      | 'ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                 | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.LegalName AS LegalName,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.Currency AS Currency,\n    -SUM(ItemList.Amount) AS Amount,\n    ItemList.Period AS Period\nINTO R5010B_ReconciliationStatement\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsReturnFromCustomer\n\nGROUP BY\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.LegalName,\n    ItemList.LegalNameContract,\n    ItemList.Currency,\n    ItemList.Period'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'No'      |
			| '495' | 'SalesReturn' | 'R4010B_ActualStocks'              | 'Yes'      | 'Query Receipt:\nNOT ItemList.IsService\nNOT ItemList.UseGoodsReceipt\nNOT ItemList.GoodsReceiptExists\nQuery Expense:\nNOT ItemList.IsService\nNOT ItemList.UseGoodsReceipt\nNOT ItemList.GoodsReceiptExists\nItemList.IsReturnFromTradeAgent' | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END AS SerialLotNumber,\n    SUM(CASE\n            WHEN SerialLotNumbers.SerialLotNumber IS NULL\n                THEN ItemList.Quantity\n            ELSE SerialLotNumbers.Quantity\n        END) AS Quantity\nINTO R4010B_ActualStocks\nFROM\n    ItemList AS ItemList\n        LEFT JOIN SerialLotNumbers AS SerialLotNumbers\n        ON ItemList.Key = SerialLotNumbers.Key\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseGoodsReceipt\n    AND NOT ItemList.GoodsReceiptExists\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Store,\n    ItemList.ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    ItemList.Period,\n    ItemList.TradeAgentStore,\n    ItemList.ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END,\n    SUM(CASE\n            WHEN SerialLotNumbers.SerialLotNumber IS NULL\n                THEN ItemList.Quantity\n            ELSE SerialLotNumbers.Quantity\n        END)\nFROM\n    ItemList AS ItemList\n        LEFT JOIN SerialLotNumbers AS SerialLotNumbers\n        ON ItemList.Key = SerialLotNumbers.Key\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseGoodsReceipt\n    AND NOT ItemList.GoodsReceiptExists\n    AND ItemList.IsReturnFromTradeAgent\n\nGROUP BY\n    ItemList.Period,\n    ItemList.ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END,\n    ItemList.TradeAgentStore'                                                                                                                 | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'Yes'     |
			| '496' | 'SalesReturn' | 'T3010S_RowIDInfo'                 | 'Yes'      | ''                                                                                                                                                                                                                                              | 'SELECT\n    RowIDInfo.RowRef AS RowRef,\n    RowIDInfo.BasisKey AS BasisKey,\n    RowIDInfo.RowID AS RowID,\n    RowIDInfo.Basis AS Basis,\n    ItemList.Key AS Key,\n    ItemList.Price AS Price,\n    ItemList.Ref.Currency AS Currency,\n    ItemList.Unit AS Unit\nINTO T3010S_RowIDInfo\nFROM\n    Document.SalesReturn.ItemList AS ItemList\n        INNER JOIN Document.SalesReturn.RowIDInfo AS RowIDInfo\n        ON (RowIDInfo.Ref = &Ref)\n            AND (ItemList.Ref = &Ref)\n            AND (RowIDInfo.Key = ItemList.Key)\n            AND (RowIDInfo.Ref = ItemList.Ref)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '497' | 'SalesReturn' | 'R2002T_SalesReturns'              | 'Yes'      | 'ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                 | 'SELECT\n    ItemList.SalesInvoice AS Invoice,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.UseGoodsReceipt AS UseGoodsReceipt,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.SalesReturnOrder AS SalesReturnOrder,\n    ItemList.SalesReturnOrderExists AS SalesReturnOrderExists,\n    ItemList.SalesReturn AS SalesReturn,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.AdvanceBasis AS AdvanceBasis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Period AS Period,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.AgingSalesInvoice AS AgingSalesInvoice,\n    ItemList.RowKey AS RowKey,\n    ItemList.GoodsReceiptExists AS GoodsReceiptExists,\n    ItemList.GoodsReceipt AS GoodsReceipt,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.IsService AS IsService,\n    ItemList.ReturnReason AS ReturnReason,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.PriceType AS PriceType,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.Key AS Key,\n    ItemList.IsReturnFromTradeAgent AS IsReturnFromTradeAgent,\n    ItemList.IsReturnFromCustomer AS IsReturnFromCustomer,\n    ItemList.TradeAgentStore AS TradeAgentStore\nINTO R2002T_SalesReturns\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '498' | 'SalesReturn' | 'R4050B_StockInventory'            | 'Yes'      | 'Query Receipt:\nSUM(ItemList.Quantity - ISNULL(ConsignorBatches.Quantity, 0)) > 0\nQuery Expense:\nNOT ItemList.IsService\nItemList.IsReturnFromTradeAgent'                                                                                    | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    SUM(ItemList.Quantity - ISNULL(ConsignorBatches.Quantity, 0)) AS Quantity\nINTO R4050B_StockInventory\nFROM\n    ItemListGrouped AS ItemList\n        LEFT JOIN ConsignorBatchesGrouped AS ConsignorBatches\n        ON ItemList.Company = ConsignorBatches.Company\n            AND ItemList.ItemKey = ConsignorBatches.ItemKey\n            AND ItemList.Store = ConsignorBatches.Store\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.Store,\n    ItemList.ItemKey\n\nHAVING\n    SUM(ItemList.Quantity - ISNULL(ConsignorBatches.Quantity, 0)) > 0\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.TradeAgentStore,\n    ItemList.ItemKey,\n    SUM(ItemList.Quantity)\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.IsReturnFromTradeAgent\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.TradeAgentStore,\n    ItemList.ItemKey'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'Yes'     |
			| '499' | 'SalesReturn' | 'R2001T_Sales'                     | 'Yes'      | 'ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                 | 'SELECT\n    -ItemList.Quantity AS Quantity,\n    -ItemList.Amount AS Amount,\n    -ItemList.NetAmount AS NetAmount,\n    -ItemList.OffersAmount AS OffersAmount,\n    ItemList.SalesInvoice AS Invoice,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.UseGoodsReceipt AS UseGoodsReceipt,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.SalesReturnOrder AS SalesReturnOrder,\n    ItemList.SalesReturnOrderExists AS SalesReturnOrderExists,\n    ItemList.SalesReturn AS SalesReturn,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.AdvanceBasis AS AdvanceBasis,\n    ItemList.Quantity AS Quantity1,\n    ItemList.Amount AS Amount1,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Period AS Period,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.AgingSalesInvoice AS AgingSalesInvoice,\n    ItemList.RowKey AS RowKey,\n    ItemList.GoodsReceiptExists AS GoodsReceiptExists,\n    ItemList.GoodsReceipt AS GoodsReceipt,\n    ItemList.NetAmount AS NetAmount1,\n    ItemList.IsService AS IsService,\n    ItemList.ReturnReason AS ReturnReason,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.OffersAmount AS OffersAmount1,\n    ItemList.PriceType AS PriceType,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.Key AS Key,\n    ItemList.IsReturnFromTradeAgent AS IsReturnFromTradeAgent,\n    ItemList.IsReturnFromCustomer AS IsReturnFromCustomer,\n    ItemList.TradeAgentStore AS TradeAgentStore\nINTO R2001T_Sales\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                                                                                                                                                                                         | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '500' | 'SalesReturn' | 'R2021B_CustomersTransactions'     | 'Yes'      | 'Query Receipt:\nItemList.IsReturnFromCustomer\nQuery Expense:\nOffsetOfAdvances.Document = &Ref'                                                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Currency AS Currency,\n    ItemList.LegalName AS LegalName,\n    ItemList.Partner AS Partner,\n    ItemList.Agreement AS Agreement,\n    ItemList.BasisDocument AS Basis,\n    UNDEFINED AS Key,\n    UNDEFINED AS CustomersAdvancesClosing,\n    -SUM(ItemList.Amount) AS Amount\nINTO R2021B_CustomersTransactions\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsReturnFromCustomer\n\nGROUP BY\n    ItemList.Agreement,\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.Currency,\n    ItemList.LegalName,\n    ItemList.Partner,\n    ItemList.Period,\n    ItemList.BasisDocument\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    OffsetOfAdvances.Period,\n    OffsetOfAdvances.Company,\n    OffsetOfAdvances.Branch,\n    OffsetOfAdvances.Currency,\n    OffsetOfAdvances.LegalName,\n    OffsetOfAdvances.Partner,\n    OffsetOfAdvances.Agreement,\n    OffsetOfAdvances.TransactionDocument,\n    OffsetOfAdvances.Key,\n    OffsetOfAdvances.Recorder,\n    OffsetOfAdvances.Amount\nFROM\n    InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances\nWHERE\n    OffsetOfAdvances.Document = &Ref'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'Yes'     |
			| '501' | 'SalesReturn' | 'R4011B_FreeStocks'                | 'Yes'      | 'NOT ItemList.IsService\nNOT ItemList.UseGoodsReceipt\nNOT ItemList.GoodsReceiptExists'                                                                                                                                                         | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Quantity AS Quantity\nINTO R4011B_FreeStocks\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseGoodsReceipt\n    AND NOT ItemList.GoodsReceiptExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'No'      |
			| '502' | 'SalesReturn' | 'T6010S_BatchesInfo'               | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                          | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '503' | 'SalesReturn' | 'R4031B_GoodsInTransitIncoming'    | 'Yes'      | '(ItemList.UseGoodsReceipt\n    OR ItemList.GoodsReceiptExists)'                                                                                                                                                                                | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    CASE\n        WHEN ItemList.GoodsReceiptExists\n            THEN ItemList.GoodsReceipt\n        ELSE ItemList.SalesReturn\n    END AS Basis,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.UseGoodsReceipt AS UseGoodsReceipt,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.SalesReturnOrder AS SalesReturnOrder,\n    ItemList.SalesReturnOrderExists AS SalesReturnOrderExists,\n    ItemList.SalesReturn AS SalesReturn,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.AdvanceBasis AS AdvanceBasis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Period AS Period,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.AgingSalesInvoice AS AgingSalesInvoice,\n    ItemList.RowKey AS RowKey,\n    ItemList.GoodsReceiptExists AS GoodsReceiptExists,\n    ItemList.GoodsReceipt AS GoodsReceipt,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.IsService AS IsService,\n    ItemList.ReturnReason AS ReturnReason,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.PriceType AS PriceType,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.Key AS Key,\n    ItemList.IsReturnFromTradeAgent AS IsReturnFromTradeAgent,\n    ItemList.IsReturnFromCustomer AS IsReturnFromCustomer,\n    ItemList.TradeAgentStore AS TradeAgentStore\nINTO R4031B_GoodsInTransitIncoming\nFROM\n    ItemList AS ItemList\nWHERE\n    (ItemList.UseGoodsReceipt\n            OR ItemList.GoodsReceiptExists)'                                                                                                                                                                                                                                                                                                                        | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'No'      |
			| '504' | 'SalesReturn' | 'R8012B_ConsignorInventory'        | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                          | 'SELECT\n    &Period AS Period,\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ConsignorBatches.Company AS Company,\n    ConsignorBatches.ItemKey AS ItemKey,\n    ConsignorBatches.SerialLotNumber AS SerialLotNumber,\n    ConsignorBatches.Batch.Partner AS Partner,\n    ConsignorBatches.Batch.Agreement AS Agreement,\n    SUM(ConsignorBatches.Quantity) AS Quantity\nINTO R8012B_ConsignorInventory\nFROM\n    ConsignorBatches AS ConsignorBatches\nWHERE\n    TRUE\n\nGROUP BY\n    ConsignorBatches.Company,\n    ConsignorBatches.ItemKey,\n    ConsignorBatches.SerialLotNumber,\n    ConsignorBatches.Batch.Partner,\n    ConsignorBatches.Batch.Agreement'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'No'      |
			| '505' | 'SalesReturn' | 'R8014T_ConsignorSales'            | 'Yes'      | ''                                                                                                                                                                                                                                              | 'SELECT\n    ReturnedConsignorBatches.Period AS Period,\n    ConsignorSales.RowKey AS Key,\n    ConsignorSales.RowKey AS RowKey,\n    ConsignorSales.Currency AS Currency,\n    -ReturnedConsignorBatches.Quantity AS Quantity,\n    -CASE\n        WHEN ConsignorSales.Quantity = 0\n            THEN 0\n        ELSE ConsignorSales.NetAmount / ConsignorSales.Quantity * ReturnedConsignorBatches.Quantity\n    END AS NetAmount,\n    -CASE\n        WHEN ConsignorSales.Quantity = 0\n            THEN 0\n        ELSE ConsignorSales.Amount / ConsignorSales.Quantity * ReturnedConsignorBatches.Quantity\n    END AS Amount,\n    ConsignorSales.Period AS Period1,\n    ConsignorSales.Recorder AS Recorder,\n    ConsignorSales.LineNumber AS LineNumber,\n    ConsignorSales.Active AS Active,\n    ConsignorSales.RowKey AS RowKey1,\n    ConsignorSales.Company AS Company,\n    ConsignorSales.Partner AS Partner,\n    ConsignorSales.Agreement AS Agreement,\n    ConsignorSales.SalesInvoice AS SalesInvoice,\n    ConsignorSales.PurchaseInvoice AS PurchaseInvoice,\n    ConsignorSales.ItemKey AS ItemKey,\n    ConsignorSales.SerialLotNumber AS SerialLotNumber,\n    ConsignorSales.Unit AS Unit,\n    ConsignorSales.PriceType AS PriceType,\n    ConsignorSales.DontCalculateRow AS DontCalculateRow,\n    ConsignorSales.CurrencyMovementType AS CurrencyMovementType,\n    ConsignorSales.Currency AS Currency1,\n    ConsignorSales.PriceIncludeTax AS PriceIncludeTax,\n    ConsignorSales.ConsignorPrice AS ConsignorPrice,\n    ConsignorSales.Price AS Price,\n    ConsignorSales.Quantity AS Quantity1,\n    ConsignorSales.NetAmount AS NetAmount1,\n    ConsignorSales.Amount AS Amount1\nINTO R8014T_ConsignorSales\nFROM\n    ConsignorSales AS ConsignorSales\n        INNER JOIN ReturnedConsignorBatches AS ReturnedConsignorBatches\n        ON (ReturnedConsignorBatches.Company = ConsignorSales.Company)\n            AND (ReturnedConsignorBatches.SalesInvoice = ConsignorSales.SalesInvoice)\n            AND (ReturnedConsignorBatches.ItemKey = ConsignorSales.ItemKey)\n            AND (ReturnedConsignorBatches.SerialLotNumber = ConsignorSales.SerialLotNumber)\n            AND (ReturnedConsignorBatches.BatchConsignor = ConsignorSales.PurchaseInvoice)' | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '506' | 'SalesReturn' | 'R5011B_CustomersAging'            | 'Yes'      | 'OffsetOfAging.Document = &Ref'                                                                                                                                                                                                                 | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    OffsetOfAging.Period AS Period,\n    OffsetOfAging.Company AS Company,\n    OffsetOfAging.Branch AS Branch,\n    OffsetOfAging.Partner AS Partner,\n    OffsetOfAging.Agreement AS Agreement,\n    OffsetOfAging.Currency AS Currency,\n    OffsetOfAging.Invoice AS Invoice,\n    OffsetOfAging.PaymentDate AS PaymentDate,\n    OffsetOfAging.Amount AS Amount,\n    OffsetOfAging.Recorder AS AgingClosing\nINTO R5011B_CustomersAging\nFROM\n    InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging\nWHERE\n    OffsetOfAging.Document = &Ref'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'Yes'     |
			| '507' | 'SalesReturn' | 'R2020B_AdvancesFromCustomers'     | 'Yes'      | ''                                                                                                                                                                                                                                              | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ''                                | 'No'      | 'No'      |
			| '508' | 'SalesReturn' | 'R5021T_Revenues'                  | 'Yes'      | 'ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                 | 'SELECT\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.UseGoodsReceipt AS UseGoodsReceipt,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.SalesReturnOrder AS SalesReturnOrder,\n    ItemList.SalesReturnOrderExists AS SalesReturnOrderExists,\n    ItemList.SalesReturn AS SalesReturn,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.AdvanceBasis AS AdvanceBasis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount1,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Period AS Period,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.AgingSalesInvoice AS AgingSalesInvoice,\n    ItemList.RowKey AS RowKey,\n    ItemList.GoodsReceiptExists AS GoodsReceiptExists,\n    ItemList.GoodsReceipt AS GoodsReceipt,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.IsService AS IsService,\n    ItemList.ReturnReason AS ReturnReason,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.PriceType AS PriceType,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.Key AS Key,\n    ItemList.IsReturnFromTradeAgent AS IsReturnFromTradeAgent,\n    ItemList.IsReturnFromCustomer AS IsReturnFromCustomer,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    -ItemList.NetAmount AS Amount,\n    -ItemList.Amount AS AmountWithTaxes\nINTO R5021T_Revenues\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsReturnFromCustomer'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'No'      |
			| '509' | 'SalesReturn' | 'R2040B_TaxesIncoming'             | 'Yes'      | 'Taxes.IsReturnFromCustomer'                                                                                                                                                                                                                    | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    -Taxes.TaxableAmount AS Field1,\n    -Taxes.TaxAmount AS Field2,\n    Taxes.Period AS Period,\n    Taxes.Company AS Company,\n    Taxes.Branch AS Branch,\n    Taxes.Tax AS Tax,\n    Taxes.TaxRate AS TaxRate,\n    Taxes.TaxAmount AS TaxAmount,\n    Taxes.TaxableAmount AS TaxableAmount,\n    Taxes.IsReturnFromTradeAgent AS IsReturnFromTradeAgent,\n    Taxes.IsReturnFromCustomer AS IsReturnFromCustomer\nINTO R2040B_TaxesIncoming\nFROM\n    Taxes AS Taxes\nWHERE\n    Taxes.IsReturnFromCustomer'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'No'      |
			| '510' | 'SalesReturn' | 'R8013B_ConsignorBatchWiseBalance' | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                          | 'SELECT\n    &Period AS Period,\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ConsignorBatches.Company AS Company,\n    ConsignorBatches.Batch AS Batch,\n    ConsignorBatches.Store AS Store,\n    ConsignorBatches.ItemKey AS ItemKey,\n    ConsignorBatches.SerialLotNumber AS SerialLotNumber,\n    SUM(ConsignorBatches.Quantity) AS Quantity\nINTO R8013B_ConsignorBatchWiseBalance\nFROM\n    ConsignorBatches AS ConsignorBatches\nWHERE\n    TRUE\n\nGROUP BY\n    ConsignorBatches.Company,\n    ConsignorBatches.Batch,\n    ConsignorBatches.Store,\n    ConsignorBatches.SerialLotNumber,\n    ConsignorBatches.ItemKey'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'No'      |
			| '511' | 'SalesReturn' | 'R8010B_TradeAgentInventory'       | 'Yes'      | 'NOT ItemList.IsService\nItemList.IsReturnFromTradeAgent'                                                                                                                                                                                       | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Partner AS Partner,\n    ItemList.Agreement AS Agreement,\n    SUM(ItemList.Quantity) AS Quantity\nINTO R8010B_TradeAgentInventory\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.IsReturnFromTradeAgent\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.ItemKey,\n    ItemList.Partner,\n    ItemList.Agreement'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'Yes'     |
			| '512' | 'SalesReturn' | 'R6020B_BatchBalance'              | 'Yes'      | ''                                                                                                                                                                                                                                              | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ''                                | 'No'      | 'No'      |
			| '513' | 'SalesReturn' | 'T1040T_AccountingAmounts'         | 'Yes'      | ''                                                                                                                                                                                                                                              | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ''                                | 'No'      | 'No'      |
			| '514' | 'SalesReturn' | 'R4014B_SerialLotNumber'           | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                          | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    SerialLotNumbers.Period AS Period,\n    SerialLotNumbers.Company AS Company,\n    SerialLotNumbers.Branch AS Branch,\n    SerialLotNumbers.Key AS Key,\n    SerialLotNumbers.SerialLotNumber AS SerialLotNumber,\n    SerialLotNumbers.StockBalanceDetail AS StockBalanceDetail,\n    SerialLotNumbers.Quantity AS Quantity,\n    SerialLotNumbers.ItemKey AS ItemKey,\n    SerialLotNumbers.Partner AS Partner,\n    SerialLotNumbers.Agreement AS Agreement,\n    SerialLotNumbers.IsReturnFromTradeAgent AS IsReturnFromTradeAgent\nINTO R4014B_SerialLotNumber\nFROM\n    SerialLotNumbers AS SerialLotNumbers\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'No'      |
			| '515' | 'SalesReturn' | 'R2031B_ShipmentInvoicing'         | 'Yes'      | 'Query Receipt:\nItemList.UseGoodsReceipt\nNOT ItemList.GoodsReceiptExists\nQuery Expense:\nTRUE'                                                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.SalesReturn AS Basis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Period AS Period,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Store AS Store\nINTO R2031B_ShipmentInvoicing\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.UseGoodsReceipt\n    AND NOT ItemList.GoodsReceiptExists\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    GoodReceipts.GoodsReceipt,\n    GoodReceipts.Quantity,\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.Period,\n    ItemList.ItemKey,\n    ItemList.Store\nFROM\n    ItemList AS ItemList\n        INNER JOIN GoodReceiptInfo AS GoodReceipts\n        ON ItemList.RowKey = GoodReceipts.Key\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 'Ref: Sales return\nPeriod: Date' | 'Yes'     | 'Yes'     |
			| '516' | 'SalesReturn' | 'R2012B_SalesOrdersInvoiceClosing' | 'Yes'      | 'ItemList.SalesReturnOrderExists'                                                                                                                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesReturnOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.UseGoodsReceipt AS UseGoodsReceipt,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.SalesReturnOrder AS SalesReturnOrder,\n    ItemList.SalesReturnOrderExists AS SalesReturnOrderExists,\n    ItemList.SalesReturn AS SalesReturn,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.AdvanceBasis AS AdvanceBasis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Period AS Period,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.AgingSalesInvoice AS AgingSalesInvoice,\n    ItemList.RowKey AS RowKey,\n    ItemList.GoodsReceiptExists AS GoodsReceiptExists,\n    ItemList.GoodsReceipt AS GoodsReceipt,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.IsService AS IsService,\n    ItemList.ReturnReason AS ReturnReason,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.PriceType AS PriceType,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.Key AS Key,\n    ItemList.IsReturnFromTradeAgent AS IsReturnFromTradeAgent,\n    ItemList.IsReturnFromCustomer AS IsReturnFromCustomer,\n    ItemList.TradeAgentStore AS TradeAgentStore\nINTO R2012B_SalesOrdersInvoiceClosing\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.SalesReturnOrderExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 'Ref: Sales return\nPeriod: Date' | 'No'      | 'Yes'     |		
		And I close all client application windows
		

Scenario: _0413001 check preparation
	When check preparation	

Scenario: _041301 check Sales return movements by the Register "R5010 Reconciliation statement"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                  | ''                    |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                  | ''                    |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                  | ''                    |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                  | ''                    |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Currency' | 'Legal name'        | 'Legal name contract' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'Main Company' | 'Distribution department' | 'TRY'      | 'Company Ferron BP' | 'Contract Ferron BP'  |
	And I close all client application windows


Scenario: _041303 check Sales return movements by the Register  "R2005 Sales special offers" based on SI
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| 'Document registrations records'             | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| 'Register  "R2005 Sales special offers"'     | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| ''                                           | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| ''                                           | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Special offer'    |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-113,85'      | '-96,48'     | '-5,99'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-84,57'       | '-71,67'     | '-4,45'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-16,26'       | '-13,78'     | '-0,86'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
					
	And I close all client application windows

Scenario: _041304 check Sales return movements by the Register  "R2002 Sales returns"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''              | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''              | ''                | ''                     |
			| 'Register  "R2002 Sales returns"'            | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''              | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''              | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Return reason' | 'Sales person'    | 'Deferred calculation' |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '16,26'  | '13,78'      | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | ''                | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '84,57'  | '71,67'      | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | ''                | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | ''                | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | ''                | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '113,85' | '96,48'      | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '665'    | '563,56'     | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '665'    | '563,56'     | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '665'    | '563,56'     | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'Alexander Orlov' | 'No'                   |
	And I close all client application windows

Scenario: _041305 check Sales return movements by the Register  "R4050 Stock inventory"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'          | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '2'         | 'Main Company' | 'Store 02' | '36/Red'   |
	And I close all client application windows


Scenario: _041306 check Sales return movements by the Register  "R2021 Customer transactions"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                           | ''      | ''                     | ''                           |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                           | ''      | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'    | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                           | ''      | ''                     | ''                           |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                           | ''      | 'Attributes'           | ''                           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                      | 'Order' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales return 101 dated 12.03.2021 08:44:18' | ''      | 'No'                   | ''                           |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales return 101 dated 12.03.2021 08:44:18' | ''      | 'No'                   | ''                           |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales return 101 dated 12.03.2021 08:44:18' | ''      | 'No'                   | ''                           |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-214,68'   | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales return 101 dated 12.03.2021 08:44:18' | ''      | 'No'                   | ''                           |
	And I close all client application windows

Scenario: _041307 check Sales return movements by the Register  "R2040 Taxes incoming"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'           | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''                        | ''    | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Branch'                  | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '80,51'          | '14,49'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '418,64'         | '75,36'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '563,56'         | '101,44'     | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
	And I close all client application windows

Scenario: _041308 check Sales return movements by the Register  "R4014 Serial lot numbers"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '105' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 105 dated 12.03.2021 09:49:05' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''         | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'       | ''            | ''                    | ''          | ''             | ''                        | ''         | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Item key' | 'Serial lot number' |
			| ''                                           | 'Receipt'     | '12.03.2021 09:49:05' | '10'        | 'Main Company' | 'Distribution department' | ''         | '36/Red'   | '0512'              |
	And I close all client application windows

Scenario: _041309 check Sales return movements by the Register  "R5021 Revenues"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''          | ''                  | ''             | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| 'Document registrations records'             | ''                    | ''          | ''                  | ''             | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| 'Register  "R5021 Revenues"'                 | ''                    | ''          | ''                  | ''             | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                           | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                           | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'                  | 'Profit loss center'      | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | '-665'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | '-665'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | '-665'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | '-494'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | '-494'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | '-494'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                           | '12.03.2021 08:44:18' | '-96,48'    | '-113,85'           | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | '-95'               | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'Interner' | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | '-95'               | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'Interner' | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | '-95'               | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'Interner' | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                           | '12.03.2021 08:44:18' | '-71,67'    | '-84,57'            | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                           | '12.03.2021 08:44:18' | '-13,78'    | '-16,26'            | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'Interner' | 'USD'      | ''                    | 'Reporting currency'           |		
	And I close all client application windows



Scenario: _041310 check Sales return movements by the Register  "R4010 Actual stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'            | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '2'         | 'Store 02'   | '36/Red'   | ''                  |
		
	And I close all client application windows


Scenario: _041311 check Sales return movements by the Register  "R4010 Actual stocks" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4010 Actual stocks" |	
	And I close all client application windows

Scenario: _041312 check Sales return movements by the Register  "R4011 Free stocks" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4011 Free stocks" |	
	And I close all client application windows

Scenario: _041313 check Sales return movements by the Register  "R4011 Free stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'              | ''            | ''                    | ''          | ''           | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '2'         | 'Store 02'   | '36/Red'   |			
	And I close all client application windows

Scenario: _041314 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'    | ''            | ''                    | ''          | ''           | ''                                           | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                           | ''         |
			| 'Register  "R4031 Goods in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''                                           | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                           | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                      | 'Item key' |
			| ''                                              | 'Receipt'     | '12.03.2021 08:44:18' | '1'         | 'Store 02'   | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  |
	And I close all client application windows


Scenario: _041315 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'    | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Register  "R4031 Goods in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                            | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                       | 'Item key' |
			| ''                                              | 'Receipt'     | '12.03.2021 08:59:52' | '2'         | 'Store 01'   | 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'XS/Blue'  |		
	And I close all client application windows

Scenario: _041315 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'    | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Register  "R4031 Goods in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                            | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                       | 'Item key' |
			| ''                                              | 'Receipt'     | '12.03.2021 08:59:52' | '2'         | 'Store 01'   | 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'XS/Blue'  |		
	And I close all client application windows

Scenario: _041316 check Sales return movements by the Register  "R2031 Shipment invoicing" (use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2031 Shipment invoicing""
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                           | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                           | ''         |
			| 'Register  "R2031 Shipment invoicing"'       | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                           | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                                           | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Basis'                                      | 'Item key' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '1'         | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  |
	And I close all client application windows

Scenario: _041317 check Sales return movements by the Register  "R2031 Shipment invoicing" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R2031 Shipment invoicing""
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                            | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                            | ''         |
			| 'Register  "R2031 Shipment invoicing"'       | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                            | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                                            | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Basis'                                       | 'Item key' |
			| ''                                           | 'Expense'     | '12.03.2021 08:59:52' | '2'         | 'Main Company' | 'Distribution department' | 'Store 01' | 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'XS/Blue'  |
	And I close all client application windows

Scenario: _041318 check Sales return movements by the Register  "R2012 Invoice closing of sales orders" (without SRO)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders""
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R2012 Invoice closing of sales orders" |	
	And I close all client application windows

Scenario: _041319 check Sales return movements by the Register  "R2012 Invoice closing of sales orders" (with SRO)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '104' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders""
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 104 dated 12.03.2021 09:20:35'        | ''            | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                                                 | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                                                 | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                                                 | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                        | ''                                                 | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Branch'                  | 'Order'                                            | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |
	And I close all client application windows

Scenario: _041320 check Sales return with serial lot numbers movements by the Register  "R4010 Actual stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '1 112' |
		And I select current line in "List" table
		And I activate "Use goods receipt" field in "ItemList" table
		And for each line of "ItemList" table I do
			And I remove "Use goods receipt" checkbox in "ItemList" table		
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 1 112 dated 20.05.2022 18:36:56' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'              | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '5'         | 'Store 02'   | 'PZU'      | '8908899877'        |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '5'         | 'Store 02'   | 'PZU'      | '8908899879'        |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '10'        | 'Store 02'   | 'XL/Green' | ''                  |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '10'        | 'Store 02'   | 'UNIQ'     | ''                  |		
	And I close all client application windows

Scenario: _041326 check Sales return movements by the Register  "T2015 Transactions info"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '106' |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 106 dated 21.04.2021 14:19:47' | ''          | ''       | ''        | ''                    | ''                                     | ''             | ''                        | ''         | ''        | ''              | ''                         | ''      | ''                      | ''                        | ''                                           | ''          |
			| 'Document registrations records'             | ''          | ''       | ''        | ''                    | ''                                     | ''             | ''                        | ''         | ''        | ''              | ''                         | ''      | ''                      | ''                        | ''                                           | ''          |
			| 'Register  "T2015 Transactions info"'        | ''          | ''       | ''        | ''                    | ''                                     | ''             | ''                        | ''         | ''        | ''              | ''                         | ''      | ''                      | ''                        | ''                                           | ''          |
			| ''                                           | 'Resources' | ''       | ''        | 'Dimensions'          | ''                                     | ''             | ''                        | ''         | ''        | ''              | ''                         | ''      | ''                      | ''                        | ''                                           | ''          |
			| ''                                           | 'Amount'    | 'Is due' | 'Is paid' | 'Date'                | 'Key'                                  | 'Company'      | 'Branch'                  | 'Currency' | 'Partner' | 'Legal name'    | 'Agreement'                | 'Order' | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                          | 'Unique ID' |
			| ''                                           | '-9 360'    | 'Yes'    | 'No'      | '21.04.2021 14:19:47' | '                                    ' | 'Main Company' | 'Distribution department' | 'TRY'      | 'Lunch'   | 'Company Lunch' | 'Basic Partner terms, TRY' | ''      | 'No'                    | 'Yes'                     | 'Sales return 106 dated 21.04.2021 14:19:47' | '*'         |		
	And I close all client application windows




Scenario: _041325 check Sales return movements by the Register  "R2001 Sales"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '107' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 107 dated 21.04.2021 14:24:43' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| 'Document registrations records'             | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                    | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| ''                                           | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| ''                                           | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                     | 'Item key' | 'Row key'                              | 'Sales person' |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-520'   | '-440,68'    | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-520'   | '-440,68'    | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-520'   | '-440,68'    | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-89,02' | '-75,44'     | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |
	And I close all client application windows

Scenario: _041327 check Sales return movements by the Register  "R2001 Sales" (withot SI)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 102 dated 12.03.2021 08:50:27' | ''                    | ''          | ''        | ''           | ''              | ''             | ''                     | ''                             | ''         | ''                                           | ''         | ''                                     | ''             |
			| 'Document registrations records'             | ''                    | ''          | ''        | ''           | ''              | ''             | ''                     | ''                             | ''         | ''                                           | ''         | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                    | ''                    | ''          | ''        | ''           | ''              | ''             | ''                     | ''                             | ''         | ''                                           | ''         | ''                                     | ''             |
			| ''                                           | 'Period'              | 'Resources' | ''        | ''           | ''              | 'Dimensions'   | ''                     | ''                             | ''         | ''                                           | ''         | ''                                     | ''             |
			| ''                                           | ''                    | 'Quantity'  | 'Amount'  | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'               | 'Multi currency movement type' | 'Currency' | 'Invoice'                                    | 'Item key' | 'Row key'                              | 'Sales person' |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-665'    | '-563,56'    | '-35'           | 'Main Company' | 'Logistics department' | 'Local currency'               | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-665'    | '-563,56'    | '-35'           | 'Main Company' | 'Logistics department' | 'TRY'                          | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-665'    | '-563,56'    | '-35'           | 'Main Company' | 'Logistics department' | 'en description is empty'      | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-113,85' | '-96,48'     | '-5,99'         | 'Main Company' | 'Logistics department' | 'Reporting currency'           | 'USD'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-494'    | '-418,64'    | '-26'           | 'Main Company' | 'Logistics department' | 'Local currency'               | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-494'    | '-418,64'    | '-26'           | 'Main Company' | 'Logistics department' | 'TRY'                          | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-494'    | '-418,64'    | '-26'           | 'Main Company' | 'Logistics department' | 'en description is empty'      | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-95'     | '-80,51'     | '-5'            | 'Main Company' | 'Logistics department' | 'Local currency'               | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Interner' | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-95'     | '-80,51'     | '-5'            | 'Main Company' | 'Logistics department' | 'TRY'                          | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Interner' | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-95'     | '-80,51'     | '-5'            | 'Main Company' | 'Logistics department' | 'en description is empty'      | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Interner' | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-84,57'  | '-71,67'     | '-4,45'         | 'Main Company' | 'Logistics department' | 'Reporting currency'           | 'USD'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-16,26'  | '-13,78'     | '-0,86'         | 'Main Company' | 'Logistics department' | 'Reporting currency'           | 'USD'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Interner' | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |
	And I close all client application windows


Scenario: _041330 Sales return clear posting/mark for deletion
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2031 Shipment invoicing' |
			| 'R5010 Reconciliation statement' |
			| 'R2002 Sales returns' |
			| 'R4050 Stock inventory' |
			| 'R2021 Customer transactions' |
			| 'R4031 Goods in transit (incoming)' |
			| 'R2040 Taxes incoming' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2031 Shipment invoicing' |
			| 'R5010 Reconciliation statement' |
			| 'R2002 Sales returns' |
			| 'R4050 Stock inventory' |
			| 'R2021 Customer transactions' |
			| 'R4031 Goods in transit (incoming)' |
			| 'R2040 Taxes incoming' |
		And I close all client application windows

Scenario: _041328 check Sales return movements by the Register  "R4010 Actual stocks" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27' | ''            | ''                    | ''          | ''                  | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''                  | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'            | ''            | ''                    | ''          | ''                  | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'        | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'             | 'Item key' | 'Serial lot number' |
			| ''                                           | 'Receipt'     | '02.11.2022 10:53:27' | '1'         | 'Store 01'          | 'XS/Blue'  | ''                  |
			| ''                                           | 'Receipt'     | '02.11.2022 10:53:27' | '2'         | 'Store 01'          | 'PZU'      | '8908899877'        |
			| ''                                           | 'Receipt'     | '02.11.2022 10:53:27' | '2'         | 'Store 01'          | 'PZU'      | '8908899879'        |
			| ''                                           | 'Expense'     | '02.11.2022 10:53:27' | '1'         | 'Trade agent store' | 'XS/Blue'  | ''                  |
			| ''                                           | 'Expense'     | '02.11.2022 10:53:27' | '2'         | 'Trade agent store' | 'PZU'      | '8908899877'        |
			| ''                                           | 'Expense'     | '02.11.2022 10:53:27' | '2'         | 'Trade agent store' | 'PZU'      | '8908899879'        |
		And I close all client application windows
		
Scenario: _041329 check Sales return movements by the Register  "R4011 Free stocks" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'              | ''            | ''                    | ''          | ''           | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                           | 'Receipt'     | '02.11.2022 10:53:27' | '1'         | 'Store 01'   | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '02.11.2022 10:53:27' | '4'         | 'Store 01'   | 'PZU'      |		
		And I close all client application windows				

Scenario: _041331 check Sales return movements by the Register  "R4050 Stock inventory" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27' | ''            | ''                    | ''          | ''             | ''                  | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                  | ''         |
			| 'Register  "R4050 Stock inventory"'          | ''            | ''                    | ''          | ''             | ''                  | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                  | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'             | 'Item key' |
			| ''                                           | 'Receipt'     | '02.11.2022 10:53:27' | '1'         | 'Main Company' | 'Store 01'          | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '02.11.2022 10:53:27' | '4'         | 'Main Company' | 'Store 01'          | 'PZU'      |
			| ''                                           | 'Expense'     | '02.11.2022 10:53:27' | '1'         | 'Main Company' | 'Trade agent store' | 'XS/Blue'  |
			| ''                                           | 'Expense'     | '02.11.2022 10:53:27' | '4'         | 'Main Company' | 'Trade agent store' | 'PZU'      |		
		And I close all client application windows	

Scenario: _041332 check Sales return movements by the Register  "R8010 Trade agent inventory" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R8010 Trade agent inventory"
		And I click "Registrations report" button
		And I select "R8010 Trade agent inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27' | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           |
			| 'Register  "R8010 Trade agent inventory"'    | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''              | ''                           |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Partner'       | 'Agreement'                  |
			| ''                                           | 'Expense'     | '02.11.2022 10:53:27' | '1'         | 'Main Company' | 'XS/Blue'  | 'Trade agent 1' | 'Trade agent partner term 1' |
			| ''                                           | 'Expense'     | '02.11.2022 10:53:27' | '4'         | 'Main Company' | 'PZU'      | 'Trade agent 1' | 'Trade agent partner term 1' |		
		And I close all client application windows

Scenario: _041333 check Sales return movements by the Register  "R8011 Trade agent serial lot number" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R8011 Trade agent serial lot number"
		And I click "Registrations report" button
		And I select "R8011 Trade agent serial lot number" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27'      | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           | ''                  |
			| 'Document registrations records'                  | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           | ''                  |
			| 'Register  "R8011 Trade agent serial lot number"' | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           | ''                  |
			| ''                                                | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''              | ''                           | ''                  |
			| ''                                                | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Partner'       | 'Agreement'                  | 'Serial lot number' |
			| ''                                                | 'Expense'     | '02.11.2022 10:53:27' | '2'         | 'Main Company' | 'PZU'      | 'Trade agent 1' | 'Trade agent partner term 1' | '8908899877'        |
			| ''                                                | 'Expense'     | '02.11.2022 10:53:27' | '2'         | 'Main Company' | 'PZU'      | 'Trade agent 1' | 'Trade agent partner term 1' | '8908899879'        |	
		And I close all client application windows	

Scenario: _041334 check Sales return movements by the Register  "R2001 Sales" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2001 Sales"'       | 
		And I close all client application windows

Scenario: _041335 check Sales return movements by the Register  "R2002 Sales returns" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2002 Sales returns"'       | 
		And I close all client application windows

Scenario: _041336 check Sales return movements by the Register  "R2021 Customer transactions" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2021 Customer transactions"'       | 
		And I close all client application windows

Scenario: _041337 check Sales return movements by the Register  "R2040 Taxes incoming" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2040 Taxes incoming"'       | 
		And I close all client application windows

Scenario: _041338 check Sales return movements by the Register  "R5021 Revenues" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5021 Revenues"'       | 
		And I close all client application windows

Scenario: _041339 check Sales return movements by the Register  "R5021 Revenues" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5021 Revenues"'       | 
		And I close all client application windows


Scenario: _041340 check Sales return movements by the Register  "R8012 Consignor inventory" (Return Consignor stocks)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '193' |
	* Check movements by the Register  "R8012 Consignor inventory"
		And I click "Registrations report" button
		And I select "R8012 Consignor inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 193 dated 05.11.2022 00:00:00' | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         |
			| 'Register  "R8012 Consignor inventory"'      | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                  | ''            | ''                         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Serial lot number' | 'Partner'     | 'Agreement'                |
			| ''                                           | 'Receipt'     | '05.11.2022 00:00:00' | '1'         | 'Main Company' | 'UNIQ'     | '09987897977889'    | 'Consignor 1' | 'Consignor partner term 1' |
			| ''                                           | 'Receipt'     | '05.11.2022 00:00:00' | '2'         | 'Main Company' | 'S/Yellow' | ''                  | 'Consignor 1' | 'Consignor partner term 1' |		
		And I close all client application windows	

Scenario: _041341 check Sales return movements by the Register  "R8013 Consignor batch wise balance" (Return Consignor stocks)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '193' |
	* Check movements by the Register  "R8013 Consignor batch wise balance"
		And I click "Registrations report" button
		And I select "R8013 Consignor batch wise balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 193 dated 05.11.2022 00:00:00'     | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  |
			| 'Register  "R8013 Consignor batch wise balance"' | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                               | ''         | ''         | ''                  |
			| ''                                               | ''            | ''                    | 'Quantity'  | 'Company'      | 'Batch'                                          | 'Store'    | 'Item key' | 'Serial lot number' |
			| ''                                               | 'Receipt'     | '05.11.2022 00:00:00' | '1'         | 'Main Company' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Store 02' | 'UNIQ'     | '09987897977889'    |
			| ''                                               | 'Receipt'     | '05.11.2022 00:00:00' | '2'         | 'Main Company' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Store 02' | 'S/Yellow' | ''                  |		
		And I close all client application windows