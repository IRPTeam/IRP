#language: en
@tree
@Positive
@Movements
@MovementsSalesInvoice

Feature: check Sales invoice movements


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040130 preparation (Sales invoice)
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Unpost SO closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		If "List" table contains lines Then
				| "Number" |
				| "1" |
			And I execute 1C:Enterprise script at server
 				| "Documents.SalesOrderClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.UndoPosting);" |
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
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
		When Create catalog LegalNameContracts objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create Document discount
	When settings for Main Company (commission trade)
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
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
		When Create document SalesOrder objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);" |	
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
		When Create document SalesInvoice objects (with aging, prepaid)
		When Create document SalesInvoiceobjects (stock control serial lot numbers)
		When Create document SalesInvoice and SalesReturn objects (comission trade)
		When Create document SalesInvoice objects (comission trade, consignment)
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
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
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);" |
		And Delay 5
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(194).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(193).GetObject().Write(DocumentWriteMode.Posting);" |
	* Check query for sales invoice movements
		Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
		And in the table "Info" I click "Fill movements" button
		And "Info" table contains lines
			| 'Document'     | 'Register'                         | 'Recorder' | 'Conditions'                                                                                                                                                                                                                                                                    | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 'Parameters'                                   | 'Receipt' | 'Expense' |
			| 'SalesInvoice' | 'R8011B_TradeAgentSerialLotNumber' | 'Yes'      | 'SerialLotNumbers.IsShipmentToTradeAgent'                                                                                                                                                                                                                                       | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    SerialLotNumbers.Period AS Period,\n    SerialLotNumbers.Company AS Company,\n    SerialLotNumbers.ItemKey AS ItemKey,\n    SerialLotNumbers.Partner AS Partner,\n    SerialLotNumbers.Agreement AS Agreement,\n    SerialLotNumbers.SerialLotNumber AS SerialLotNumber,\n    SerialLotNumbers.Quantity AS Quantity\nINTO R8011B_TradeAgentSerialLotNumber\nFROM\n    SerialLotNumbers AS SerialLotNumbers\nWHERE\n    SerialLotNumbers.IsShipmentToTradeAgent'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
			| 'SalesInvoice' | 'T2015S_TransactionsInfo'          | 'Yes'      | 'ItemList.IsSales'                                                                                                                                                                                                                                                              | 'SELECT\n    ItemList.Period AS Date,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Currency AS Currency,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.SalesOrder AS Order,\n    TRUE AS IsCustomerTransaction,\n    ItemList.Basis AS TransactionBasis,\n    SUM(ItemList.Amount) AS Amount,\n    TRUE AS IsDue\nINTO T2015S_TransactionsInfo\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsSales\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.Currency,\n    ItemList.Partner,\n    ItemList.LegalName,\n    ItemList.Agreement,\n    ItemList.SalesOrder,\n    ItemList.Basis'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'T6020S_BatchKeysInfo'             | 'Yes'      | 'Query 0:\nQuery 1:'                                                                                                                                                                                                                                                            | 'SELECT\n    BatchKeysInfo_1.ItemKey AS ItemKey,\n    BatchKeysInfo_1.Store AS Store,\n    BatchKeysInfo_1.Company AS Company,\n    SUM(CASE\n            WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0\n                THEN ISNULL(SourceOfOrigins.Quantity, 0)\n            ELSE BatchKeysInfo_1.Quantity\n        END) AS Quantity,\n    BatchKeysInfo_1.Period AS Period,\n    BatchKeysInfo_1.Direction AS Direction,\n    BatchKeysInfo_1.BatchConsignor AS BatchConsignor,\n    ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,\n    ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber\nINTO T6020S_BatchKeysInfo\nFROM\n    BatchKeysInfo_1 AS BatchKeysInfo_1\n        LEFT JOIN SourceOfOrigins AS SourceOfOrigins\n        ON BatchKeysInfo_1.Key = SourceOfOrigins.Key\n            AND (CASE\n                WHEN BatchKeysInfo_1.IsConsignorBatches\n                    THEN BatchKeysInfo_1.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock\n                ELSE TRUE\n            END)\n\nGROUP BY\n    BatchKeysInfo_1.ItemKey,\n    BatchKeysInfo_1.Store,\n    BatchKeysInfo_1.Company,\n    BatchKeysInfo_1.Period,\n    BatchKeysInfo_1.Direction,\n    BatchKeysInfo_1.BatchConsignor,\n    ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),\n    ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))\n\nUNION ALL\n\nSELECT\n    BatchKeysInfo_2.ItemKey,\n    BatchKeysInfo_2.TradeAgentStore,\n    BatchKeysInfo_2.Company,\n    SUM(CASE\n            WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0\n                THEN ISNULL(SourceOfOrigins.Quantity, 0)\n            ELSE BatchKeysInfo_2.Quantity\n        END),\n    BatchKeysInfo_2.Period,\n    BatchKeysInfo_2.Direction,\n    UNDEFINED,\n    ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),\n    ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))\nFROM\n    BatchKeysInfo_2 AS BatchKeysInfo_2\n        LEFT JOIN SourceOfOrigins AS SourceOfOrigins\n        ON BatchKeysInfo_2.Key = SourceOfOrigins.Key\n            AND (CASE\n                WHEN BatchKeysInfo_2.IsConsignorBatches\n                    THEN BatchKeysInfo_2.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock\n                ELSE TRUE\n            END)\n\nGROUP BY\n    BatchKeysInfo_2.ItemKey,\n    BatchKeysInfo_2.TradeAgentStore,\n    BatchKeysInfo_2.Company,\n    BatchKeysInfo_2.Period,\n    BatchKeysInfo_2.Direction,\n    ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),\n    ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))' | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R6060T_CostOfGoodsSold'           | 'Yes'      | ''                                                                                                                                                                                                                                                                              | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | ''                                             | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R2005T_SalesSpecialOffers'        | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                                                          | 'SELECT\n    OffersInfo.Period AS Period,\n    OffersInfo.Invoice AS Invoice,\n    OffersInfo.RowKey AS RowKey,\n    OffersInfo.ItemKey AS ItemKey,\n    OffersInfo.Company AS Company,\n    OffersInfo.Currency AS Currency,\n    OffersInfo.SpecialOffer AS SpecialOffer,\n    OffersInfo.OffersAmount AS OffersAmount,\n    OffersInfo.SalesAmount AS SalesAmount,\n    OffersInfo.NetAmount AS NetAmount,\n    OffersInfo.Branch AS Branch\nINTO R2005T_SalesSpecialOffers\nFROM\n    OffersInfo AS OffersInfo\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R2022B_CustomersPaymentPlanning'  | 'Yes'      | 'SalesInvoicePaymentTerms.Ref = &Ref\nSalesInvoicePaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.PostShipmentCredit)'                                                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    SalesInvoicePaymentTerms.Ref.Date AS Period,\n    SalesInvoicePaymentTerms.Ref.Company AS Company,\n    SalesInvoicePaymentTerms.Ref.Branch AS Branch,\n    SalesInvoicePaymentTerms.Ref AS Basis,\n    SalesInvoicePaymentTerms.Ref.LegalName AS LegalName,\n    SalesInvoicePaymentTerms.Ref.Partner AS Partner,\n    SalesInvoicePaymentTerms.Ref.Agreement AS Agreement,\n    SUM(SalesInvoicePaymentTerms.Amount) AS Amount\nINTO R2022B_CustomersPaymentPlanning\nFROM\n    Document.SalesInvoice.PaymentTerms AS SalesInvoicePaymentTerms\nWHERE\n    SalesInvoicePaymentTerms.Ref = &Ref\n    AND SalesInvoicePaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.PostShipmentCredit)\n\nGROUP BY\n    SalesInvoicePaymentTerms.Ref.Date,\n    SalesInvoicePaymentTerms.Ref.Company,\n    SalesInvoicePaymentTerms.Ref.Branch,\n    SalesInvoicePaymentTerms.Ref,\n    SalesInvoicePaymentTerms.Ref.LegalName,\n    SalesInvoicePaymentTerms.Ref.Partner,\n    SalesInvoicePaymentTerms.Ref.Agreement'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
			| 'SalesInvoice' | 'R5010B_ReconciliationStatement'   | 'Yes'      | 'ItemList.IsSales'                                                                                                                                                                                                                                                              | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.LegalName AS LegalName,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.Currency AS Currency,\n    SUM(ItemList.Amount) AS Amount,\n    ItemList.Period AS Period\nINTO R5010B_ReconciliationStatement\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsSales\n\nGROUP BY\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.LegalName,\n    ItemList.LegalNameContract,\n    ItemList.Currency,\n    ItemList.Period'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
			| 'SalesInvoice' | 'R4010B_ActualStocks'              | 'Yes'      | 'Query Expense:\nNOT ItemList.IsService\nNOT ItemList.UseShipmentConfirmation\nNOT ItemList.ShipmentConfirmationExists\nQuery Receipt:\nNOT ItemList.IsService\nNOT ItemList.UseShipmentConfirmation\nNOT ItemList.ShipmentConfirmationExists\nItemList.IsShipmentToTradeAgent' | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END AS SerialLotNumber,\n    SUM(CASE\n            WHEN SerialLotNumbers.SerialLotNumber IS NULL\n                THEN ItemList.Quantity\n            ELSE SerialLotNumbers.Quantity\n        END) AS Quantity\nINTO R4010B_ActualStocks\nFROM\n    ItemList AS ItemList\n        LEFT JOIN SerialLotNumbers AS SerialLotNumbers\n        ON ItemList.Key = SerialLotNumbers.Key\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseShipmentConfirmation\n    AND NOT ItemList.ShipmentConfirmationExists\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Store,\n    ItemList.ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Receipt),\n    ItemList.Period,\n    ItemList.TradeAgentStore,\n    ItemList.ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END,\n    SUM(CASE\n            WHEN SerialLotNumbers.SerialLotNumber IS NULL\n                THEN ItemList.Quantity\n            ELSE SerialLotNumbers.Quantity\n        END)\nFROM\n    ItemList AS ItemList\n        LEFT JOIN SerialLotNumbers AS SerialLotNumbers\n        ON ItemList.Key = SerialLotNumbers.Key\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseShipmentConfirmation\n    AND NOT ItemList.ShipmentConfirmationExists\n    AND ItemList.IsShipmentToTradeAgent\n\nGROUP BY\n    ItemList.Period,\n    ItemList.TradeAgentStore,\n    ItemList.ItemKey,\n    CASE\n        WHEN SerialLotNumbers.StockBalanceDetail\n            THEN SerialLotNumbers.SerialLotNumber\n        ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)\n    END'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
			| 'SalesInvoice' | 'T3010S_RowIDInfo'                 | 'Yes'      | ''                                                                                                                                                                                                                                                                              | 'SELECT\n    RowIDInfo.RowRef AS RowRef,\n    RowIDInfo.BasisKey AS BasisKey,\n    RowIDInfo.RowID AS RowID,\n    RowIDInfo.Basis AS Basis,\n    ItemList.Key AS Key,\n    ItemList.Price AS Price,\n    ItemList.Ref.Currency AS Currency,\n    ItemList.Unit AS Unit\nINTO T3010S_RowIDInfo\nFROM\n    Document.SalesInvoice.ItemList AS ItemList\n        INNER JOIN Document.SalesInvoice.RowIDInfo AS RowIDInfo\n        ON (RowIDInfo.Ref = &Ref)\n            AND (ItemList.Ref = &Ref)\n            AND (RowIDInfo.Key = ItemList.Key)\n            AND (RowIDInfo.Ref = ItemList.Ref)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R2011B_SalesOrdersShipment'       | 'Yes'      | 'NOT ItemList.IsService\nNOT ItemList.UseShipmentConfirmation\nItemList.SalesOrderExists\nNOT ItemList.ShipmentConfirmationExists'                                                                                                                                              | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.PriceIncludeTax AS PriceIncludeTax,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Basis AS Basis,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.Key AS Key,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.PriceType AS PriceType,\n    ItemList.Price AS Price,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.IsSales AS IsSales,\n    ItemList.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    ItemList.IsOwnStocks AS IsOwnStocks,\n    ItemList.IsConsignorStocks AS IsConsignorStocks\nINTO R2011B_SalesOrdersShipment\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseShipmentConfirmation\n    AND ItemList.SalesOrderExists\n    AND NOT ItemList.ShipmentConfirmationExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R4050B_StockInventory'            | 'Yes'      | 'Query Expense:\nNOT ItemList.IsService\nItemList.IsOwnStocks\nQuery Receipt:\nNOT ItemList.IsService\nItemList.IsShipmentToTradeAgent'                                                                                                                                         | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    SUM(ItemList.Quantity) AS Quantity\nINTO R4050B_StockInventory\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.IsOwnStocks\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.Store,\n    ItemList.ItemKey\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Receipt),\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.TradeAgentStore,\n    ItemList.ItemKey,\n    SUM(ItemList.Quantity)\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.IsShipmentToTradeAgent\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.TradeAgentStore,\n    ItemList.ItemKey'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
			| 'SalesInvoice' | 'R9010B_SourceOfOriginStock'       | 'Yes'      | 'ItemList.IsSales'                                                                                                                                                                                                                                                              | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,\n    SourceOfOrigins.SerialLotNumber AS SerialLotNumber,\n    SUM(SourceOfOrigins.Quantity) AS Quantity\nINTO R9010B_SourceOfOriginStock\nFROM\n    ItemList AS ItemList\n        INNER JOIN SourceOfOrigins AS SourceOfOrigins\n        ON ItemList.Key = SourceOfOrigins.Key\n            AND (NOT SourceOfOrigins.SourceOfOriginStock.Ref IS NULL)\nWHERE\n    ItemList.IsSales\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.Store,\n    ItemList.ItemKey,\n    SourceOfOrigins.SourceOfOriginStock,\n    SourceOfOrigins.SerialLotNumber'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R2001T_Sales'                     | 'Yes'      | 'ItemList.IsSales'                                                                                                                                                                                                                                                              | 'SELECT\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.PriceIncludeTax AS PriceIncludeTax,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Basis AS Basis,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.Key AS Key,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.PriceType AS PriceType,\n    ItemList.Price AS Price,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.IsSales AS IsSales,\n    ItemList.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    ItemList.IsOwnStocks AS IsOwnStocks,\n    ItemList.IsConsignorStocks AS IsConsignorStocks\nINTO R2001T_Sales\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsSales'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R2021B_CustomersTransactions'     | 'Yes'      | 'Query Receipt:\nItemList.IsSales\nQuery Expense:\nOffsetOfAdvances.Document = &Ref'                                                                                                                                                                                            | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Currency AS Currency,\n    ItemList.LegalName AS LegalName,\n    ItemList.Partner AS Partner,\n    ItemList.Agreement AS Agreement,\n    ItemList.Basis AS Basis,\n    ItemList.SalesOrder AS Order,\n    SUM(ItemList.Amount) AS Amount,\n    UNDEFINED AS CustomersAdvancesClosing\nINTO R2021B_CustomersTransactions\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsSales\n\nGROUP BY\n    ItemList.Agreement,\n    ItemList.Basis,\n    ItemList.SalesOrder,\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.Currency,\n    ItemList.LegalName,\n    ItemList.Partner,\n    ItemList.Period\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    OffsetOfAdvances.Period,\n    OffsetOfAdvances.Company,\n    OffsetOfAdvances.Branch,\n    OffsetOfAdvances.Currency,\n    OffsetOfAdvances.LegalName,\n    OffsetOfAdvances.Partner,\n    OffsetOfAdvances.Agreement,\n    OffsetOfAdvances.TransactionDocument,\n    OffsetOfAdvances.TransactionOrder,\n    OffsetOfAdvances.Amount,\n    OffsetOfAdvances.Recorder\nFROM\n    InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances\nWHERE\n    OffsetOfAdvances.Document = &Ref'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
			| 'SalesInvoice' | 'R4011B_FreeStocks'                | 'Yes'      | 'ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)'                                                                                                                                                                                                              | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemListGroup.Period AS Period,\n    ItemListGroup.Store AS Store,\n    ItemListGroup.ItemKey AS ItemKey,\n    ItemListGroup.Quantity - ISNULL(TmpStockReservation.Quantity, 0) AS Quantity\nINTO R4011B_FreeStocks\nFROM\n    ItemListGroup AS ItemListGroup\n        LEFT JOIN TmpStockReservation AS TmpStockReservation\n        ON ItemListGroup.Store = TmpStockReservation.Store\n            AND ItemListGroup.ItemKey = TmpStockReservation.ItemKey\n            AND (TmpStockReservation.Basis = ItemListGroup.SalesOrder)\nWHERE\n    ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R4032B_GoodsInTransitOutgoing'    | 'Yes'      | 'NOT ItemList.IsService\n(ItemList.UseShipmentConfirmation\n    OR ItemList.ShipmentConfirmationExists)'                                                                                                                                                                        | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    CASE\n        WHEN ItemList.ShipmentConfirmationExists\n            THEN ShipmentConfirmations.ShipmentConfirmation\n        ELSE ItemList.Invoice\n    END AS Basis,\n    CASE\n        WHEN ItemList.ShipmentConfirmationExists\n            THEN ShipmentConfirmations.Quantity\n        ELSE ItemList.Quantity\n    END AS Quantity,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity1,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.PriceIncludeTax AS PriceIncludeTax,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Basis AS Basis1,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.Key AS Key,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.PriceType AS PriceType,\n    ItemList.Price AS Price,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.IsSales AS IsSales,\n    ItemList.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    ItemList.IsOwnStocks AS IsOwnStocks,\n    ItemList.IsConsignorStocks AS IsConsignorStocks,\n    ShipmentConfirmations.Key AS Key1,\n    ShipmentConfirmations.ShipmentConfirmation AS ShipmentConfirmation,\n    ShipmentConfirmations.Quantity AS Quantity2\nINTO R4032B_GoodsInTransitOutgoing\nFROM\n    ItemList AS ItemList\n        LEFT JOIN ShipmentConfirmationsInfo AS ShipmentConfirmations\n        ON ItemList.Key = ShipmentConfirmations.Key\nWHERE\n    NOT ItemList.IsService\n    AND (ItemList.UseShipmentConfirmation\n            OR ItemList.ShipmentConfirmationExists)'                                                                                                                                                                                                                                                                                  | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
			| 'SalesInvoice' | 'R4012B_StockReservation'          | 'Yes'      | ''                                                                                                                                                                                                                                                                              | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemListGroup.Period AS Period,\n    ItemListGroup.SalesOrder AS Order,\n    ItemListGroup.ItemKey AS ItemKey,\n    ItemListGroup.Store AS Store,\n    CASE\n        WHEN StockReservation.QuantityBalance > ItemListGroup.Quantity\n            THEN ItemListGroup.Quantity\n        ELSE StockReservation.QuantityBalance\n    END AS Quantity\nINTO R4012B_StockReservation\nFROM\n    TmpItemListGroup AS ItemListGroup\n        INNER JOIN TmpStockReservation AS StockReservation\n        ON ItemListGroup.SalesOrder = StockReservation.Order\n            AND ItemListGroup.ItemKey = StockReservation.ItemKey\n            AND ItemListGroup.Store = StockReservation.Store'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R8012B_ConsignorInventory'        | 'Yes'      | 'ItemList.IsSales\nItemList.IsConsignorStocks'                                                                                                                                                                                                                                  | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.ItemKey AS ItemKey,\n    ConsignorBatches.SerialLotNumber AS SerialLotNumber,\n    ConsignorBatches.Batch.Partner AS Partner,\n    ConsignorBatches.Batch.Agreement AS Agreement,\n    ConsignorBatches.Quantity AS Quantity\nINTO R8012B_ConsignorInventory\nFROM\n    ItemList AS ItemList\n        LEFT JOIN ConsignorBatches AS ConsignorBatches\n        ON ItemList.Key = ConsignorBatches.Key\nWHERE\n    ItemList.IsSales\n    AND ItemList.IsConsignorStocks'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R8014T_ConsignorSales'            | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                                                          | 'SELECT\n    ConsignorSales_1_1.Key AS Key,\n    ConsignorSales_1_1.Period AS Period,\n    ConsignorSales_1_1.RowKey AS RowKey,\n    ConsignorSales_1_1.Company AS Company,\n    ConsignorSales_1_1.Partner AS Partner,\n    ConsignorSales_1_1.Agreement AS Agreement,\n    ConsignorSales_1_1.Currency AS Currency,\n    ConsignorSales_1_1.SalesInvoice AS SalesInvoice,\n    ConsignorSales_1_1.PurchaseInvoice AS PurchaseInvoice,\n    ConsignorSales_1_1.ItemKey AS ItemKey,\n    ConsignorSales_1_1.SerialLotNumber1 AS SerialLotNumber1,\n    ConsignorSales_1_1.Unit AS Unit,\n    ConsignorSales_1_1.Price AS Price,\n    ConsignorSales_1_1.PriceType AS PriceType,\n    ConsignorSales_1_1.PriceIncludeTax AS PriceIncludeTax,\n    ConsignorSales_1_1.TotalQuantity AS TotalQuantity,\n    ConsignorSales_1_1.NetAmount AS NetAmount3,\n    ConsignorSales_1_1.Amount AS Amount3,\n    ConsignorSales_1_1.TotalQuantity1 AS TotalQuantity1,\n    ConsignorSales_1_1.NetAmount1 AS NetAmount1,\n    ConsignorSales_1_1.Amount1 AS Amount1,\n    ConsignorSales_1_1.Quantity AS Quantity,\n    ConsignorSales_1_1.SourceOfOrigin AS SourceOfOrigin,\n    ConsignorSales_1_1.SerialLotNumber AS SerialLotNumber,\n    ConsignorSales_1_1.Key1 AS Key1,\n    ConsignorSales_1_1.TotalQuantity2 AS TotalQuantity2,\n    ConsignorSales_1_1.NetAmount2 AS NetAmount2,\n    ConsignorSales_1_1.Amount2 AS Amount2,\n    ConsignorSales_1_1.ConsignorPrice AS ConsignorPrice,\n    CASE\n        WHEN ConsignorSales_1_1.TotalQuantity = 0\n            THEN 0\n        ELSE ConsignorSales_1_1.NetAmount / ConsignorSales_1_1.TotalQuantity * ConsignorSales_1_1.Quantity\n    END AS NetAmount,\n    CASE\n        WHEN ConsignorSales_1_1.TotalQuantity = 0\n            THEN 0\n        ELSE ConsignorSales_1_1.Amount / ConsignorSales_1_1.TotalQuantity * ConsignorSales_1_1.Quantity\n    END AS Amount\nINTO R8014T_ConsignorSales\nFROM\n    ConsignorSales_1_1 AS ConsignorSales_1_1\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R2013T_SalesOrdersProcurement'    | 'Yes'      | 'NOT ItemList.IsService\nItemList.SalesOrderExists'                                                                                                                                                                                                                             | 'SELECT\n    ItemList.Quantity AS SalesQuantity,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.PriceIncludeTax AS PriceIncludeTax,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Basis AS Basis,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.Key AS Key,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.PriceType AS PriceType,\n    ItemList.Price AS Price,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.IsSales AS IsSales,\n    ItemList.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    ItemList.IsOwnStocks AS IsOwnStocks,\n    ItemList.IsConsignorStocks AS IsConsignorStocks\nINTO R2013T_SalesOrdersProcurement\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.SalesOrderExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R5011B_CustomersAging'            | 'Yes'      | 'Query Receipt:\nPaymentTerms.Ref = &Ref\nQuery Expense:\nOffsetOfAging.Document = &Ref'                                                                                                                                                                                        | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    PaymentTerms.Ref.Date AS Period,\n    PaymentTerms.Ref.Company AS Company,\n    PaymentTerms.Ref.Branch AS Branch,\n    PaymentTerms.Ref.Currency AS Currency,\n    PaymentTerms.Ref.Agreement AS Agreement,\n    PaymentTerms.Ref.Partner AS Partner,\n    PaymentTerms.Ref AS Invoice,\n    PaymentTerms.Date AS PaymentDate,\n    SUM(PaymentTerms.Amount) AS Amount,\n    UNDEFINED AS AgingClosing\nINTO R5011B_CustomersAging\nFROM\n    Document.SalesInvoice.PaymentTerms AS PaymentTerms\nWHERE\n    PaymentTerms.Ref = &Ref\n\nGROUP BY\n    PaymentTerms.Date,\n    PaymentTerms.Ref,\n    PaymentTerms.Ref.Agreement,\n    PaymentTerms.Ref.Company,\n    PaymentTerms.Ref.Branch,\n    PaymentTerms.Ref.Currency,\n    PaymentTerms.Ref.Date,\n    PaymentTerms.Ref.Partner\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    OffsetOfAging.Period,\n    OffsetOfAging.Company,\n    OffsetOfAging.Branch,\n    OffsetOfAging.Currency,\n    OffsetOfAging.Agreement,\n    OffsetOfAging.Partner,\n    OffsetOfAging.Invoice,\n    OffsetOfAging.PaymentDate,\n    OffsetOfAging.Amount,\n    OffsetOfAging.Recorder\nFROM\n    InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging\nWHERE\n    OffsetOfAging.Document = &Ref'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
			| 'SalesInvoice' | 'R2020B_AdvancesFromCustomers'     | 'Yes'      | 'OffsetOfAdvances.Document = &Ref'                                                                                                                                                                                                                                              | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,\n    OffsetOfAdvances.AdvancesOrder AS Order,\n    OffsetOfAdvances.Period AS Period,\n    OffsetOfAdvances.Recorder AS Recorder,\n    OffsetOfAdvances.LineNumber AS LineNumber,\n    OffsetOfAdvances.Active AS Active,\n    OffsetOfAdvances.Document AS Document,\n    OffsetOfAdvances.IsAdvanceRelease AS IsAdvanceRelease,\n    OffsetOfAdvances.Company AS Company,\n    OffsetOfAdvances.Branch AS Branch,\n    OffsetOfAdvances.Currency AS Currency,\n    OffsetOfAdvances.Partner AS Partner,\n    OffsetOfAdvances.LegalName AS LegalName,\n    OffsetOfAdvances.TransactionDocument AS TransactionDocument,\n    OffsetOfAdvances.Agreement AS Agreement,\n    OffsetOfAdvances.Key AS Key,\n    OffsetOfAdvances.AdvancesOrder AS AdvancesOrder,\n    OffsetOfAdvances.TransactionOrder AS TransactionOrder,\n    OffsetOfAdvances.FromAdvanceKey AS FromAdvanceKey,\n    OffsetOfAdvances.ToTransactionKey AS ToTransactionKey,\n    OffsetOfAdvances.FromTransactionKey AS FromTransactionKey,\n    OffsetOfAdvances.ToAdvanceKey AS ToAdvanceKey,\n    OffsetOfAdvances.Amount AS Amount\nINTO R2020B_AdvancesFromCustomers\nFROM\n    InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances\nWHERE\n    OffsetOfAdvances.Document = &Ref'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R5021T_Revenues'                  | 'Yes'      | 'ItemList.IsSales'                                                                                                                                                                                                                                                              | 'SELECT\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount1,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.PriceIncludeTax AS PriceIncludeTax,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Basis AS Basis,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.Key AS Key,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.PriceType AS PriceType,\n    ItemList.Price AS Price,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.IsSales AS IsSales,\n    ItemList.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    ItemList.IsOwnStocks AS IsOwnStocks,\n    ItemList.IsConsignorStocks AS IsConsignorStocks,\n    ItemList.NetAmount AS Amount,\n    ItemList.Amount AS AmountWithTaxes\nINTO R5021T_Revenues\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsSales'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R2040B_TaxesIncoming'             | 'Yes'      | 'Taxes.IsSales'                                                                                                                                                                                                                                                                 | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    Taxes.Period AS Period,\n    Taxes.Company AS Company,\n    Taxes.Tax AS Tax,\n    Taxes.TaxRate AS TaxRate,\n    Taxes.TaxAmount AS TaxAmount,\n    Taxes.TaxableAmount AS TaxableAmount,\n    Taxes.Branch AS Branch,\n    Taxes.IsSales AS IsSales,\n    Taxes.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    Taxes.IsOwnStocks AS IsOwnStocks,\n    Taxes.IsConsignorStocks AS IsConsignorStocks\nINTO R2040B_TaxesIncoming\nFROM\n    Taxes AS Taxes\nWHERE\n    Taxes.IsSales'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
			| 'SalesInvoice' | 'R4034B_GoodsShipmentSchedule'     | 'Yes'      | 'NOT ItemList.IsService\nNOT ItemList.UseShipmentConfirmation\nItemList.SalesOrderExists\nItemList.SalesOrder.UseItemsShipmentScheduling'                                                                                                                                       | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Basis,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.PriceIncludeTax AS PriceIncludeTax,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Basis AS Basis1,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.Key AS Key,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.PriceType AS PriceType,\n    ItemList.Price AS Price,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.IsSales AS IsSales,\n    ItemList.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    ItemList.IsOwnStocks AS IsOwnStocks,\n    ItemList.IsConsignorStocks AS IsConsignorStocks\nINTO R4034B_GoodsShipmentSchedule\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseShipmentConfirmation\n    AND ItemList.SalesOrderExists\n    AND ItemList.SalesOrder.UseItemsShipmentScheduling'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R8013B_ConsignorBatchWiseBalance' | 'Yes'      | ''                                                                                                                                                                                                                                                                              | 'SELECT\n    ConsignorBatchWiseBalance_1.RecordType AS RecordType,\n    ConsignorBatchWiseBalance_1.Period AS Period,\n    ConsignorBatchWiseBalance_1.Company AS Company,\n    ConsignorBatchWiseBalance_1.Batch AS Batch,\n    ConsignorBatchWiseBalance_1.ItemKey AS ItemKey,\n    ConsignorBatchWiseBalance_1.Store AS Store,\n    SUM(CASE\n            WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0\n                THEN ISNULL(SourceOfOrigins.Quantity, 0)\n            ELSE ConsignorBatchWiseBalance_1.Quantity\n        END) AS Quantity,\n    SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,\n    SourceOfOrigins.SerialLotNumberStock AS SerialLotNumber\nINTO R8013B_ConsignorBatchWiseBalance\nFROM\n    ConsignorBatchWiseBalance_1 AS ConsignorBatchWiseBalance_1\n        LEFT JOIN SourceOfOrigins AS SourceOfOrigins\n        ON ConsignorBatchWiseBalance_1.Key = SourceOfOrigins.Key\n            AND ConsignorBatchWiseBalance_1.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock\n\nGROUP BY\n    ConsignorBatchWiseBalance_1.RecordType,\n    ConsignorBatchWiseBalance_1.Period,\n    ConsignorBatchWiseBalance_1.Company,\n    ConsignorBatchWiseBalance_1.Batch,\n    ConsignorBatchWiseBalance_1.ItemKey,\n    ConsignorBatchWiseBalance_1.Store,\n    SourceOfOrigins.SourceOfOriginStock,\n    SourceOfOrigins.SerialLotNumberStock'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R8010B_TradeAgentInventory'       | 'Yes'      | 'NOT ItemList.IsService\nItemList.IsShipmentToTradeAgent'                                                                                                                                                                                                                       | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS Field1,\n    ItemList.Period AS Period,\n    ItemList.Company AS Company,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Partner AS Partner,\n    ItemList.Agreement AS Agreement,\n    SUM(ItemList.Quantity) AS Quantity\nINTO R8010B_TradeAgentInventory\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.IsShipmentToTradeAgent\n\nGROUP BY\n    ItemList.Period,\n    ItemList.Company,\n    ItemList.ItemKey,\n    ItemList.Partner,\n    ItemList.Agreement'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
			| 'SalesInvoice' | 'R6020B_BatchBalance'              | 'Yes'      | ''                                                                                                                                                                                                                                                                              | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | ''                                             | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R6080T_OtherPeriodsRevenues'      | 'Yes'      | 'ItemList.IsAdditionalItemRevenue'                                                                                                                                                                                                                                              | 'SELECT\n    ItemList.Period AS Period,\n    ItemList.Basis AS Basis,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Currency AS Currency,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.IsAdditionalItemRevenue AS IsAdditionalItemRevenue,\n    ItemList.IsService AS IsService,\n    ItemList.RowID AS RowID,\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.NetAmount AS Amount\nINTO R6080T_OtherPeriodsRevenues\nFROM\n    ItemListLandedCost AS ItemList\nWHERE\n    ItemList.IsAdditionalItemRevenue'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
			| 'SalesInvoice' | 'T1040T_AccountingAmounts'         | 'Yes'      | ''                                                                                                                                                                                                                                                                              | ''                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | ''                                             | 'No'      | 'No'      |
			| 'SalesInvoice' | 'R4014B_SerialLotNumber'           | 'Yes'      | 'TRUE'                                                                                                                                                                                                                                                                          | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    SerialLotNumbers.Period AS Period,\n    SerialLotNumbers.Company AS Company,\n    SerialLotNumbers.Branch AS Branch,\n    SerialLotNumbers.Key AS Key,\n    SerialLotNumbers.SerialLotNumber AS SerialLotNumber,\n    SerialLotNumbers.StockBalanceDetail AS StockBalanceDetail,\n    SerialLotNumbers.Quantity AS Quantity,\n    SerialLotNumbers.ItemKey AS ItemKey,\n    SerialLotNumbers.Partner AS Partner,\n    SerialLotNumbers.Agreement AS Agreement,\n    SerialLotNumbers.IsShipmentToTradeAgent AS IsShipmentToTradeAgent\nINTO R4014B_SerialLotNumber\nFROM\n    SerialLotNumbers AS SerialLotNumbers\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
			| 'SalesInvoice' | 'R2031B_ShipmentInvoicing'         | 'Yes'      | 'Query Receipt:\nItemList.UseShipmentConfirmation\nNOT ItemList.ShipmentConfirmationExists\nQuery Expense:\nTRUE'                                                                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Invoice AS Basis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Company AS Company,\n    ItemList.Branch AS Branch,\n    ItemList.Period AS Period,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Store AS Store\nINTO R2031B_ShipmentInvoicing\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.UseShipmentConfirmation\n    AND NOT ItemList.ShipmentConfirmationExists\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    ShipmentConfirmations.ShipmentConfirmation,\n    ShipmentConfirmations.Quantity,\n    ItemList.Company,\n    ItemList.Branch,\n    ItemList.Period,\n    ItemList.ItemKey,\n    ItemList.Store\nFROM\n    ItemList AS ItemList\n        INNER JOIN ShipmentConfirmationsInfo AS ShipmentConfirmations\n        ON ItemList.Key = ShipmentConfirmations.Key\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
			| 'SalesInvoice' | 'R2012B_SalesOrdersInvoiceClosing' | 'Yes'      | 'ItemList.SalesOrderExists'                                                                                                                                                                                                                                                     | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.PriceIncludeTax AS PriceIncludeTax,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.ProfitLossCenter AS ProfitLossCenter,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.Basis AS Basis,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.Key AS Key,\n    ItemList.Branch AS Branch,\n    ItemList.LegalNameContract AS LegalNameContract,\n    ItemList.PriceType AS PriceType,\n    ItemList.Price AS Price,\n    ItemList.SalesPerson AS SalesPerson,\n    ItemList.IsSales AS IsSales,\n    ItemList.IsShipmentToTradeAgent AS IsShipmentToTradeAgent,\n    ItemList.TradeAgentStore AS TradeAgentStore,\n    ItemList.IsOwnStocks AS IsOwnStocks,\n    ItemList.IsConsignorStocks AS IsConsignorStocks\nINTO R2012B_SalesOrdersInvoiceClosing\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.SalesOrderExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |			
		And I close all client application windows

Scenario: _0401301 check preparation
	When check preparation

//1


Scenario: _0401311 check Sales invoice movements by the Register  "R2005 Sales special offers" SO-SC-SI (with special offers)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| 'Document registrations records'            | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| 'Register  "R2005 Sales special offers"'    | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| ''                                          | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| ''                                          | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Special offer'    |
			| ''                                          | '28.01.2021 18:48:53' | '16,26'        | '13,78'      | '0,86'          | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '84,57'        | '71,67'      | '4,45'          | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '569,24'       | '482,41'     | '29,96'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			
		And I close all client application windows
		
Scenario: _040132 check Sales invoice movements by the Register  "R5010 Reconciliation statement"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                  | ''                    |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                  | ''                    |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                  | ''                    |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                  | ''                    |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Currency' | 'Legal name'        | 'Legal name contract' |
			| ''                                           | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'Distribution department' | 'TRY'      | 'Company Ferron BP' | 'Contract Ferron BP'  |
		And I close all client application windows
		
Scenario: _040133 check Sales invoice movements by the Register  "R4010 Actual stocks" (use SC, SC first)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'           |
			
		And I close all client application windows
		
Scenario: _040134 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2011 Shipment of sales orders" 
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2011 Shipment of sales orders"' |
		And I close all client application windows
		
Scenario: _040135 check Sales invoice movements by the Register  "R4050 Stock inventory"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'         | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '10'        | 'Main Company' | 'Store 02' | '36/Red'   |
			
		And I close all client application windows
		
Scenario: _040136 check Sales invoice movements by the Register  "R2001 Sales"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                |
			| 'Document registrations records'            | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                |
			| 'Register  "R2001 Sales"'                   | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                |
			| ''                                          | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''                             | ''         | ''                                          | ''         | ''                                     | ''                |
			| ''                                          | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Sales person'    |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '16,26'  | '13,78'      | '0,86'          | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '84,57'  | '71,67'      | '4,45'          | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '569,24' | '482,41'     | '29,96'         | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'Alexander Orlov' |
			
		And I close all client application windows
		
Scenario: _040137 check Sales invoice movements by the Register  "R2021 Customer transactions"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                                        | ''                     | ''                           |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                                        | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'   | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                                        | ''                     | ''                           |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                                        | 'Attributes'           | ''                           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Order'                                   | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '670,08'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'No'                   | ''                           |
		And I close all client application windows
		
Scenario: _040138 check Sales invoice movements by the Register  "R4011 Free stocks" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'             |
		And I close all client application windows
		
Scenario: _040139 check Sales invoice movements by the Register  "R4012 Stock Reservation" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'                     |
			
		And I close all client application windows
		
Scenario: _040140 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'     | ''            | ''                    | ''          | ''           | ''                                                  | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                                  | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                                  | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                                  | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                             | 'Item key' |
			| ''                                              | 'Receipt'     | '28.01.2021 18:48:53' | '1'         | 'Store 02'   | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '28.01.2021 18:48:53' | '10'        | 'Store 02'   | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | '36/Red'   |
		And I close all client application windows
		
Scenario: _040141 check Sales invoice movements by the Register  "R5011 Customers aging" (without aging)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5011 Customers aging"
		And I click "Registrations report" button
		And I select "R5011 Customers aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5011 Customers aging"'                     |
			
		And I close all client application windows
		
Scenario: _040142 check Sales invoice movements by the Register  "R2020 Advances from customer" (without advances)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer"'                     |
			
		And I close all client application windows
		
Scenario: _040143 check Sales invoice movements by the Register  "R2040 Taxes incoming"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'          | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''                        | ''    | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Branch'                  | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '80,51'          | '14,49'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '418,64'         | '75,36'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '2 817,8'        | '507,2'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			
		And I close all client application windows
		
Scenario: _040144 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"'                     |
			
		And I close all client application windows
		
Scenario: _040145 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (without serial lot numbers)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4014 Serial lot numbers"'                     |
			
		And I close all client application windows
		
Scenario: _040146 check Sales invoice movements by the Register  "R2031 Shipment invoicing" SO-SC-SI
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                                  | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                                  | ''         |
			| 'Register  "R2031 Shipment invoicing"'      | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                                  | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                                                  | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Basis'                                             | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '1'         | 'Main Company' | 'Distribution department' | 'Store 02' | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '10'        | 'Main Company' | 'Distribution department' | 'Store 02' | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | '36/Red'   |
		And I close all client application windows
		
Scenario: _040147 check Sales invoice movements by the Register  "R2012 Invoice closing of sales orders" (SO exists)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                        | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                        | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Branch'                  | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
		And I close all client application windows

//2


		
Scenario: _0401442 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"' | ''            | ''                    | ''          | ''             | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''   | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'      | 'Basis'                                   | 'Store'    | 'Item key' | 'Row key'                              |
			| ''                                            | 'Expense'     | '28.01.2021 18:49:39' | '5'         | 'Main Company' | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                            | 'Expense'     | '28.01.2021 18:49:39' | '10'        | 'Main Company' | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
	
		And I close all client application windows
		
Scenario: _0401443 check Sales invoice movements by the Register  "R4011 Free stocks" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"' |
		And I close all client application windows

Scenario: _0401444 check Sales invoice movements by the Register  "R4012 Stock Reservation" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"' |
		And I close all client application windows

Scenario: _0401445 check Sales invoice movements by the Register  "R4010 Actual stocks" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"' |
		And I close all client application windows	

Scenario: _0401446 check Sales invoice movements by the Register  "R5021 Revenues"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Period'              | 'Amount'    | 'Amount with taxes' | 'Dimensions'   | ''                        | ''        | ''         | ''    | '' | ''                        |
			| '28.01.2021 18:49:39' | '13,78'     | '16,26'             | 'Main Company' | 'Distribution department' | 'Revenue' | 'Interner' | 'USD' | '' | 'Reporting currency'      |
			| '28.01.2021 18:49:39' | '80,51'     | '95'                | 'Main Company' | 'Distribution department' | 'Revenue' | 'Interner' | 'TRY' | '' | 'Local currency'          |
			| '28.01.2021 18:49:39' | '80,51'     | '95'                | 'Main Company' | 'Distribution department' | 'Revenue' | 'Interner' | 'TRY' | '' | 'TRY'                     |
			| '28.01.2021 18:49:39' | '80,51'     | '95'                | 'Main Company' | 'Distribution department' | 'Revenue' | 'Interner' | 'TRY' | '' | 'en description is empty' |
			| '28.01.2021 18:49:39' | '358,36'    | '422,86'            | 'Main Company' | 'Distribution department' | 'Revenue' | 'XS/Blue'  | 'USD' | '' | 'Reporting currency'      |
			| '28.01.2021 18:49:39' | '482,41'    | '569,24'            | 'Main Company' | 'Distribution department' | 'Revenue' | '36/Red'   | 'USD' | '' | 'Reporting currency'      |
			| '28.01.2021 18:49:39' | '2 093,2'   | '2 470'             | 'Main Company' | 'Distribution department' | 'Revenue' | 'XS/Blue'  | 'TRY' | '' | 'Local currency'          |
			| '28.01.2021 18:49:39' | '2 093,2'   | '2 470'             | 'Main Company' | 'Distribution department' | 'Revenue' | 'XS/Blue'  | 'TRY' | '' | 'TRY'                     |
			| '28.01.2021 18:49:39' | '2 093,2'   | '2 470'             | 'Main Company' | 'Distribution department' | 'Revenue' | 'XS/Blue'  | 'TRY' | '' | 'en description is empty' |
			| '28.01.2021 18:49:39' | '2 817,8'   | '3 325'             | 'Main Company' | 'Distribution department' | 'Revenue' | '36/Red'   | 'TRY' | '' | 'Local currency'          |
			| '28.01.2021 18:49:39' | '2 817,8'   | '3 325'             | 'Main Company' | 'Distribution department' | 'Revenue' | '36/Red'   | 'TRY' | '' | 'TRY'                     |
			| '28.01.2021 18:49:39' | '2 817,8'   | '3 325'             | 'Main Company' | 'Distribution department' | 'Revenue' | '36/Red'   | 'TRY' | '' | 'en description is empty' |				
		And I close all client application windows	


//3


		
		
Scenario: _0401333 check Sales invoice movements by the Register  "R4010 Actual stocks" (SO-SI-SC, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'           | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Store 02'   | '37/18SD'  | ''                  |
			
		And I close all client application windows

Scenario: _0401334 check Sales invoice movements (with serial lot numbers) by the Register  "R4010 Actual stocks" (SO-SI-SC, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1 112' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 112 dated 23.05.2022 16:25:33' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'               | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                              | 'Expense'     | '23.05.2022 16:25:33' | '23'        | 'Store 02'   | 'PZU'      | '8908899879'        |	
		And I close all client application windows
		
Scenario: _0401343 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" (SO-SI, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2011 Shipment of sales orders"
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'  | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                                        | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Order'                                   | 'Item key' |
			| ''                                           | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Main Company' | 'Distribution department' | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  |
			
		And I close all client application windows
	
		
		
Scenario: _0401383 check Sales invoice movements by the Register  "R4011 Free stocks" (SO-SI-SC, PM - Not Stock)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'             | ''            | ''                    | ''          | ''           | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Store 02'   | '37/18SD'  |
		And I close all client application windows 

Scenario: _0401384 check Sales invoice movements by the Register  "R4012 Stock Reservation" SO-SI-SC (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'                     |
			
		And I close all client application windows

Scenario: _0401385 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" SO-SI-SC (use and not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'     | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                          | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                     | 'Item key' |
			| ''                                              | 'Receipt'     | '28.01.2021 18:50:57' | '1'         | 'Store 02'   | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '28.01.2021 18:50:57' | '10'        | 'Store 02'   | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   |
		And I close all client application windows


//4

Scenario: _0401314 check Sales invoice movements by the Register  "R5011 Customers aging" (use Aging, Receipt)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R5011 Customers aging"
		And I click "Registrations report" button
		And I select "R5011 Customers aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                          | ''        | ''                                          | ''                    | ''              |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                          | ''        | ''                                          | ''                    | ''              |
			| 'Register  "R5011 Customers aging"'         | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                          | ''        | ''                                          | ''                    | ''              |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                          | ''        | ''                                          | ''                    | 'Attributes'    |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Currency' | 'Agreement'                 | 'Partner' | 'Invoice'                                   | 'Payment date'        | 'Aging closing' |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '23 374'    | 'Main Company' | 'Distribution department' | 'USD'      | 'Personal Partner terms, $' | 'Kalipso' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | '23.02.2021 00:00:00' | ''              |
		And I close all client application windows 


Scenario: _0401315 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (use Serial lot number)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                        | ''         | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'      | ''            | ''                    | ''          | ''             | ''                        | ''         | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Item key' | 'Serial lot number' |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10'        | 'Main Company' | 'Distribution department' | ''         | '36/Red'   | '0512'              |
		And I close all client application windows 

Scenario: _0401316 check Sales invoice movements by the Register  "R2022 Customers payment planning" (use Aging, Receipt)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R2022 Customers payment planning"
		And I click "Registrations report" button
		And I select "R2022 Customers payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'    | ''            | ''                    | ''          | ''             | ''                        | ''                                          | ''                | ''        | ''                          |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                        | ''                                          | ''                | ''        | ''                          |
			| 'Register  "R2022 Customers payment planning"' | ''            | ''                    | ''          | ''             | ''                        | ''                                          | ''                | ''        | ''                          |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                                          | ''                | ''        | ''                          |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Basis'                                     | 'Legal name'      | 'Partner' | 'Agreement'                 |
			| ''                                             | 'Receipt'     | '16.02.2021 10:59:49' | '23 374'    | 'Main Company' | 'Distribution department' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' |
		And I close all client application windows 

Scenario: _0401317 check there is no Sales invoice movements by the Register  "R2022 Customers payment planning" (without Aging)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2022 Customers payment planning"
		And I click "Registrations report" button
		And I select "R2022 Customers payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' |
			| 'Document registrations records'            |
		And I close all client application windows 

Scenario: _0401318 check there is no Sales invoice movements by the Register  "R2022 Customers payment planning" (Aging - pre-paid)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '112' |
	* Check movements by the Register  "R2022 Customers payment planning"
		And I click "Registrations report" button
		And I select "R2022 Customers payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 112 dated 30.05.2021 12:48:26'  | ''            | ''                    | ''          | ''             | ''                        | ''                                            | ''                | ''        | ''                                 |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                        | ''                                            | ''                | ''        | ''                                 |
			| 'Register  "R2022 Customers payment planning"' | ''            | ''                    | ''          | ''             | ''                        | ''                                            | ''                | ''        | ''                                 |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                                            | ''                | ''        | ''                                 |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Basis'                                       | 'Legal name'      | 'Partner' | 'Agreement'                        |
			| ''                                             | 'Receipt'     | '30.05.2021 12:48:26' | '400'       | 'Main Company' | 'Distribution department' | 'Sales invoice 112 dated 30.05.2021 12:48:26' | 'Company Kalipso' | 'Kalipso' | 'Basic Partner terms, without VAT' |
		And I close all client application windows 


Scenario: _0401320 check Sales invoice movements by the Register  "R4012 Stock Reservation" (without SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'       | 
		And I close all client application windows

Scenario: _0401317 check Sales invoice movements by the Register  "R2031 Shipment invoicing" (SI first, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                          | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                          | ''         |
			| 'Register  "R2031 Shipment invoicing"'      | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                          | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                                          | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Basis'                                     | 'Item key' |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '1'         | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'XS/Blue'  |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '24'        | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | '37/18SD'  |
		And I close all client application windows

Scenario: _0401318 check Sales invoice movements by the Register  "R4011 Free stocks" (SI first, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'             | ''            | ''                    | ''          | ''           | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '20'        | 'Store 02'   | '36/Red'   |
		And I close all client application windows

Scenario: _0401319 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI first, use and not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'     | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                          | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                     | 'Item key' |
			| ''                                              | 'Receipt'     | '16.02.2021 10:59:49' | '1'         | 'Store 02'   | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '16.02.2021 10:59:49' | '24'        | 'Store 02'   | 'Sales invoice 4 dated 16.02.2021 10:59:49' | '37/18SD'  |
		And I close all client application windows

//8 SI>SO

Scenario: _0401325 check Sales invoice movements by the Register  "R4011 Free stocks" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '8' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'             |
		And I close all client application windows
	
Scenario: _0401326 check Sales invoice movements by the Register  "R4012 Stock Reservation" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '8' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'             |
		And I close all client application windows


Scenario: _0401327 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '8' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 8 dated 18.02.2021 10:48:46'     | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                          | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                     | 'Item key' |
			| ''                                              | 'Receipt'     | '18.02.2021 10:48:46' | '10'        | 'Store 02'   | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '18.02.2021 10:48:46' | '15'        | 'Store 02'   | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'XS/Blue'  |
		And I close all client application windows

Scenario: _0401327 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '8' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 8 dated 18.02.2021 10:48:46'     | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                          | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                     | 'Item key' |
			| ''                                              | 'Receipt'     | '18.02.2021 10:48:46' | '10'        | 'Store 02'   | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '18.02.2021 10:48:46' | '15'        | 'Store 02'   | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'XS/Blue'  |
		And I close all client application windows

// Commission trade

Scenario: _0401330 check Sales invoice movements by the Register  "R4010 Actual stocks" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '192'    |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19' | ''            | ''                    | ''          | ''                  | ''         | ''                  |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''                  | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'             | ''            | ''                    | ''          | ''                  | ''         | ''                  |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'        | ''         | ''                  |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Store'             | 'Item key' | 'Serial lot number' |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '1'         | 'Trade agent store' | '37/18SD'  | ''                  |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Trade agent store' | 'PZU'      | '8908899877'        |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Trade agent store' | 'PZU'      | '8908899879'        |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Trade agent store' | 'UNIQ'     | ''                  |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '4'         | 'Trade agent store' | 'XS/Blue'  | ''                  |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '1'         | 'Store 01'          | '37/18SD'  | ''                  |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Store 01'          | 'PZU'      | '8908899877'        |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Store 01'          | 'PZU'      | '8908899879'        |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Store 01'          | 'UNIQ'     | ''                  |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '4'         | 'Store 01'          | 'XS/Blue'  | ''                  |
	And I close all client application windows
				
Scenario: _0401331 check Sales invoice movements by the Register  "R4011 Free stocks" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '192'    |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'               | ''            | ''                    | ''          | ''           | ''         |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '1'         | 'Store 01'   | '37/18SD'  |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Store 01'   | 'UNIQ'     |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '4'         | 'Store 01'   | 'XS/Blue'  |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '4'         | 'Store 01'   | 'PZU'      |
		And I close all client application windows
		
Scenario: _0401332 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '192'    |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19' | ''            | ''                    | ''          | ''             | ''                        | ''      | ''         | ''                  |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                        | ''      | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'        | ''            | ''                    | ''          | ''             | ''                        | ''      | ''         | ''                  |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''      | ''         | ''                  |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store' | 'Item key' | 'Serial lot number' |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'Distribution department' | ''      | 'PZU'      | '8908899877'        |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'Distribution department' | ''      | 'PZU'      | '8908899879'        |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '899007790088'      |				
		And I close all client application windows	

Scenario: _0401333 check Sales invoice movements by the Register  "R4050 Stock inventory" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '192'    |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19' | ''            | ''                    | ''          | ''             | ''                  | ''         |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                  | ''         |
			| 'Register  "R4050 Stock inventory"'           | ''            | ''                    | ''          | ''             | ''                  | ''         |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                  | ''         |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'             | 'Item key' |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '1'         | 'Main Company' | 'Trade agent store' | '37/18SD'  |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'Trade agent store' | 'UNIQ'     |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '4'         | 'Main Company' | 'Trade agent store' | 'XS/Blue'  |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '4'         | 'Main Company' | 'Trade agent store' | 'PZU'      |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '1'         | 'Main Company' | 'Store 01'          | '37/18SD'  |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'Store 01'          | 'UNIQ'     |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '4'         | 'Main Company' | 'Store 01'          | 'XS/Blue'  |
			| ''                                            | 'Expense'     | '02.11.2022 10:53:19' | '4'         | 'Main Company' | 'Store 01'          | 'PZU'      |		
	And I close all client application windows						

Scenario: _0401334 check Sales invoice movements by the Register  "R8010 Trade agent inventory" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '192'    |
	* Check movements by the Register  "R8010 Trade agent inventory"
		And I click "Registrations report" button
		And I select "R8010 Trade agent inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19' | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           |
			| 'Register  "R8010 Trade agent inventory"'     | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''              | ''                           |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Partner'       | 'Agreement'                  |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '1'         | 'Main Company' | '37/18SD'  | 'Trade agent 1' | 'Trade agent partner term 1' |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'UNIQ'     | 'Trade agent 1' | 'Trade agent partner term 1' |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '4'         | 'Main Company' | 'XS/Blue'  | 'Trade agent 1' | 'Trade agent partner term 1' |
			| ''                                            | 'Receipt'     | '02.11.2022 10:53:19' | '4'         | 'Main Company' | 'PZU'      | 'Trade agent 1' | 'Trade agent partner term 1' |		
	And I close all client application windows

Scenario: _0401335 check Sales invoice movements by the Register  "R8011 Trade agent serial lot number" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '192'    |
	* Check movements by the Register  "R8011 Trade agent serial lot number"
		And I click "Registrations report" button
		And I select "R8011 Trade agent serial lot number" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19'     | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           | ''                  |
			| 'Document registrations records'                  | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           | ''                  |
			| 'Register  "R8011 Trade agent serial lot number"' | ''            | ''                    | ''          | ''             | ''         | ''              | ''                           | ''                  |
			| ''                                                | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''              | ''                           | ''                  |
			| ''                                                | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Partner'       | 'Agreement'                  | 'Serial lot number' |
			| ''                                                | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'PZU'      | 'Trade agent 1' | 'Trade agent partner term 1' | '8908899877'        |
			| ''                                                | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'PZU'      | 'Trade agent 1' | 'Trade agent partner term 1' | '8908899879'        |
			| ''                                                | 'Receipt'     | '02.11.2022 10:53:19' | '2'         | 'Main Company' | 'UNIQ'     | 'Trade agent 1' | 'Trade agent partner term 1' | '899007790088'      |	
	And I close all client application windows	

Scenario: _0401336 check Sales invoice movements by the Register  "R2001 Sales" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401337 check Sales invoice movements by the Register  "R2021 Customer transactions" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401338 check Sales invoice movements by the Register  "R2040 Taxes incoming" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401339 check Sales invoice movements by the Register  "R5010 Reconciliation statement" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '192' |
	* Check movements by the Register  "R5010 Reconciliation statementg"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement"'       | 
		And I close all client application windows

Scenario: _0401340 check Sales invoice movements by the Register  "R5021 Revenues" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401341 check Sales invoice movements by the Register  "R2001 Sales" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| 'Document registrations records'              | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                     | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| ''                                            | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''                             | ''         | ''                                            | ''         | ''                                     | ''             |
			| ''                                            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                     | 'Item key' | 'Row key'                              | 'Sales person' |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '17,12'  | '14,51'      | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '89,02'  | '75,44'      | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | '39043c7e-1198-4ae7-b4f9-408ba4a2a4cc' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '100'    | '84,75'      | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '100'    | '84,75'      | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '100'    | '84,75'      | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '520'    | '440,68'     | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | '39043c7e-1198-4ae7-b4f9-408ba4a2a4cc' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '520'    | '440,68'     | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | '39043c7e-1198-4ae7-b4f9-408ba4a2a4cc' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '520'    | '440,68'     | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | '39043c7e-1198-4ae7-b4f9-408ba4a2a4cc' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '188,32' | '159,59'     | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'S/Yellow' | '06ecf6b9-a5f7-4c78-8b29-072fdc868aa4' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'S/Yellow' | '06ecf6b9-a5f7-4c78-8b29-072fdc868aa4' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'S/Yellow' | '06ecf6b9-a5f7-4c78-8b29-072fdc868aa4' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'S/Yellow' | '06ecf6b9-a5f7-4c78-8b29-072fdc868aa4' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '6'         | '205,44' | '174,1'      | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | 'dabba903-d3bc-4d63-83be-01c89c63e2fa' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '6'         | '1 200'  | '1 016,95'   | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | 'dabba903-d3bc-4d63-83be-01c89c63e2fa' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '6'         | '1 200'  | '1 016,95'   | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | 'dabba903-d3bc-4d63-83be-01c89c63e2fa' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '6'         | '1 200'  | '1 016,95'   | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | 'dabba903-d3bc-4d63-83be-01c89c63e2fa' | ''             |				
	And I close all client application windows	

Scenario: _0401342 check Sales invoice movements by the Register  "R2021 Customer transactions" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | ''                     | ''                           |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'     | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | ''                     | ''                           |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | 'Attributes'           | ''                           |
			| ''                                            | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Legal name'       | 'Partner'  | 'Agreement'                | 'Basis'                                       | 'Order' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '499,9'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '2 920'     | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '2 920'     | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '2 920'     | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
		And I close all client application windows
		
Scenario: _0401343 check Sales invoice movements by the Register  "R2021 Customer transactions" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | ''                     | ''                           |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'     | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | ''                     | ''                           |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                 | ''         | ''                         | ''                                            | ''      | 'Attributes'           | ''                           |
			| ''                                            | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Legal name'       | 'Partner'  | 'Agreement'                | 'Basis'                                       | 'Order' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '499,9'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '2 920'     | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '2 920'     | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '2 920'     | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''      | 'No'                   | ''                           |
		And I close all client application windows	

Scenario: _0401344 check Sales invoice movements by the Register  "R2040 Taxes incoming" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| 'Document registrations records'              | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'            | ''            | ''                    | ''               | ''           | ''             | ''                        | ''    | ''         | ''                  |
			| ''                                            | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''                        | ''    | ''         | ''                  |
			| ''                                            | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Branch'                  | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '84,75'          | '15,25'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '440,68'         | '79,32'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '932,2'          | '167,8'      | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
			| ''                                            | 'Receipt'     | '04.11.2022 16:33:38' | '1 016,95'       | '183,05'     | 'Main Company' | 'Distribution department' | 'VAT' | '18%'      | ''                  |
		And I close all client application windows		

Scenario: _0401345 check Sales invoice movements by the Register  "R4010 Actual stocks" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'             | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '1'         | 'Store 02'   | 'XS/Blue'  | ''                  |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Store 02'   | 'S/Yellow' | ''                  |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '7'         | 'Store 02'   | 'UNIQ'     | ''                  |
		And I close all client application windows	

Scenario: _0401346 check Sales invoice movements by the Register  "R4011 Free stocks" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'               | ''            | ''                    | ''          | ''           | ''         |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '1'         | 'Store 02'   | 'XS/Blue'  |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Store 02'   | 'S/Yellow' |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '7'         | 'Store 02'   | 'UNIQ'     |			
		And I close all client application windows	

Scenario: _0401347 check Sales invoice movements by the Register  "R4050 Stock inventory" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'           | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '1'         | 'Main Company' | 'Store 02' | 'UNIQ'     |		
		And I close all client application windows	

Scenario: _0401348 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''          | ''             | ''                        | ''      | ''         | ''                  |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                        | ''      | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'        | ''            | ''                    | ''          | ''             | ''                        | ''      | ''         | ''                  |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''      | ''         | ''                  |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store' | 'Item key' | 'Serial lot number' |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '1'         | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '09987897977889'    |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '6'         | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '09987897977889'    |
		And I close all client application windows

Scenario: _0401349 check Sales invoice movements by the Register  "R8012 Consignor inventory" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R8012 Consignor inventory"
		And I click "Registrations report" button
		And I select "R8012 Consignor inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         |
			| 'Register  "R8012 Consignor inventory"'       | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                  | ''            | ''                         |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Serial lot number' | 'Partner'     | 'Agreement'                |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Main Company' | 'S/Yellow' | ''                  | 'Consignor 1' | 'Consignor partner term 1' |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Main Company' | 'UNIQ'     | '09987897977889'    | 'Consignor 1' | 'Consignor partner term 1' |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '4'         | 'Main Company' | 'UNIQ'     | '09987897977889'    | 'Consignor 2' | 'Consignor 2 partner term' |		
		And I close all client application windows

Scenario: _0401349 check Sales invoice movements by the Register  "R8013 Consignor batch wise balance" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "R8013 Consignor batch wise balance"
		And I click "Registrations report" button
		And I select "R8013 Consignor batch wise balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38'    | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  | ''                 |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  | ''                 |
			| 'Register  "R8013 Consignor batch wise balance"' | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  | ''                 |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                               | ''         | ''         | ''                  | ''                 |
			| ''                                               | ''            | ''                    | 'Quantity'  | 'Company'      | 'Batch'                                          | 'Store'    | 'Item key' | 'Serial lot number' | 'Source of origin' |
			| ''                                               | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Main Company' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Store 02' | 'S/Yellow' | ''                  | ''                 |
			| ''                                               | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Main Company' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Store 02' | 'UNIQ'     | '09987897977889'    | ''                 |
			| ''                                               | 'Expense'     | '04.11.2022 16:33:38' | '4'         | 'Main Company' | 'Purchase invoice 196 dated 03.11.2022 16:32:57' | 'Store 02' | 'UNIQ'     | '09987897977889'    | ''                 |
		And I close all client application windows

Scenario: _0401350 check Sales invoice movements by the Register  "T2015 Transactions info" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''          | ''       | ''        | ''                    | ''                                     | ''             | ''                        | ''         | ''         | ''                 | ''                         | ''      | ''                      | ''                        | ''                                            | ''          |
			| 'Document registrations records'              | ''          | ''       | ''        | ''                    | ''                                     | ''             | ''                        | ''         | ''         | ''                 | ''                         | ''      | ''                      | ''                        | ''                                            | ''          |
			| 'Register  "T2015 Transactions info"'         | ''          | ''       | ''        | ''                    | ''                                     | ''             | ''                        | ''         | ''         | ''                 | ''                         | ''      | ''                      | ''                        | ''                                            | ''          |
			| ''                                            | 'Resources' | ''       | ''        | 'Dimensions'          | ''                                     | ''             | ''                        | ''         | ''         | ''                 | ''                         | ''      | ''                      | ''                        | ''                                            | ''          |
			| ''                                            | 'Amount'    | 'Is due' | 'Is paid' | 'Date'                | 'Key'                                  | 'Company'      | 'Branch'                  | 'Currency' | 'Partner'  | 'Legal name'       | 'Agreement'                | 'Order' | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                           | 'Unique ID' |
			| ''                                            | '2 920'     | 'Yes'    | 'No'      | '04.11.2022 16:33:38' | '                                    ' | 'Main Company' | 'Distribution department' | 'TRY'      | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | ''      | 'No'                    | 'Yes'                     | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '*'         |
		And I close all client application windows

Scenario: _0401351 check Sales invoice movements by the Register  "T6020 Batch keys info" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '194'    |
	* Check movements by the Register  "T6020 Batch keys info"
		And I click "Registrations report" button
		And I select "T6020 Batch keys info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''                    | ''          | ''       | ''           | ''                  | ''             | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''       | ''     | ''           | ''                                               | ''                  | ''                 |
			| 'Document registrations records'              | ''                    | ''          | ''       | ''           | ''                  | ''             | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''       | ''     | ''           | ''                                               | ''                  | ''                 |
			| 'Register  "T6020 Batch keys info"'           | ''                    | ''          | ''       | ''           | ''                  | ''             | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''       | ''     | ''           | ''                                               | ''                  | ''                 |
			| ''                                            | 'Period'              | 'Resources' | ''       | ''           | ''                  | 'Dimensions'   | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''       | ''     | ''           | ''                                               | ''                  | ''                 |
			| ''                                            | ''                    | 'Quantity'  | 'Amount' | 'Amount tax' | 'Amount cost ratio' | 'Company'      | 'Store'    | 'Item key' | 'Direction' | 'Currency movement type' | 'Currency' | 'Batch document' | 'Sales invoice' | 'Row ID'                               | 'Profit loss center' | 'Expense type' | 'Branch' | 'Work' | 'Work sheet' | 'Batch consignor'                                | 'Serial lot number' | 'Source of origin' |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | ''       | ''           | ''                  | 'Main Company' | 'Store 02' | 'XS/Blue'  | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''       | ''     | ''           | ''                                               | ''                  | ''                 |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | ''       | ''           | ''                  | 'Main Company' | 'Store 02' | 'UNIQ'     | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''       | ''     | ''           | ''                                               | ''                  | ''                 |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | ''       | ''           | ''                  | 'Main Company' | 'Store 02' | 'S/Yellow' | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''       | ''     | ''           | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | ''                  | ''                 |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | ''       | ''           | ''                  | 'Main Company' | 'Store 02' | 'UNIQ'     | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''       | ''     | ''           | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | ''                  | ''                 |
			| ''                                            | '04.11.2022 16:33:38' | '4'         | ''       | ''           | ''                  | 'Main Company' | 'Store 02' | 'UNIQ'     | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''       | ''     | ''           | 'Purchase invoice 196 dated 03.11.2022 16:32:57' | ''                  | ''                 |
		And I close all client application windows
		
Scenario: _0401429 Sales invoice clear posting/mark for deletion
		And I close all client application windows
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4050 Stock inventory' |
			| 'R2001 Sales' |
			| 'R2021 Customer transactions' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4050 Stock inventory' |
			| 'R2001 Sales' |
			| 'R2021 Customer transactions' |
		And I close all client application windows