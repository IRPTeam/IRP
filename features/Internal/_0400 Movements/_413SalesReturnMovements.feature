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
		When Create catalog Countries objects
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
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create information register Taxes records (VAT)
		When settings for Main Company (commission trade)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load Bank receipt
		When Create document BankReceipt objects (check movements, advance)
		And I execute 1C:Enterprise script at server
				| "Documents.BankReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Load SO
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		When Create document SalesOrder objects (SI more than SO)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Goods
		When Create document GoodsReceipt objects (check movements, transaction type - return from customers)
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(125).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Sales return order
		When Create document SalesReturnOrder objects (check movements)
		And Delay 5
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows
		When Create document SalesInvoice objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
				| "Documents.BankReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Load Sales return
		When Create document SalesReturn objects (check movements)
		When Create document SalesReturn objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(102).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(103).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(105).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '104'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		When Create document SalesReturn objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(106).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(106).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(107).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(107).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(108).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(108).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(109).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(109).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
	* Load document commission trade
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		When Create document SalesInvoice and SalesReturn objects (comission trade)
		When Create document SalesInvoice objects (comission trade, consignment)
		When Create document SalesReturn objects (comission trade, consignment)
		When Create document SalesReturn objects (serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(194).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(194).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(193).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(193).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(192).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(193).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(193).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesReturn.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);"    |
	// * Check query for sales return movements
	// 	Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
	// 	And in the table "Info" I click "Fill movements" button		
		And I close all client application windows
		

Scenario: _0413001 check preparation
	When check preparation	

Scenario: _041301 check Sales return movements by the Register "R5010 Reconciliation statement"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                    | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '-1 254'      | 'Main Company'   | 'Distribution department'   | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP'     |
	And I close all client application windows


Scenario: _041303 check Sales return movements by the Register  "R2005 Sales special offers" based on SI
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
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
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3e3ebfe7-f1bc-44c6-8ba7-1cc33e188a71' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3e3ebfe7-f1bc-44c6-8ba7-1cc33e188a71' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3e3ebfe7-f1bc-44c6-8ba7-1cc33e188a71' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '39150742-fcd4-41df-b03e-206a14da9527' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '39150742-fcd4-41df-b03e-206a14da9527' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '39150742-fcd4-41df-b03e-206a14da9527' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-113,85'      | '-96,48'     | '-5,99'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3e3ebfe7-f1bc-44c6-8ba7-1cc33e188a71' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '4686a3ba-3189-4fa0-9387-27a8b0455bfe' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '4686a3ba-3189-4fa0-9387-27a8b0455bfe' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '4686a3ba-3189-4fa0-9387-27a8b0455bfe' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-84,57'       | '-71,67'     | '-4,45'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '39150742-fcd4-41df-b03e-206a14da9527' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-16,26'       | '-13,78'     | '-0,86'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '4686a3ba-3189-4fa0-9387-27a8b0455bfe' | 'DocumentDiscount' |		
	And I close all client application windows

Scenario: _041304 check Sales return movements by the Register  "R2002 Sales returns"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''          | ''        | ''           | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                  | ''                                     | ''              | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''        | ''           | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                  | ''                                     | ''              | ''                | ''                     |
			| 'Register  "R2002 Sales returns"'            | ''                    | ''          | ''        | ''           | ''             | ''                        | ''                             | ''         | ''                                          | ''         | ''                  | ''                                     | ''              | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | ''        | ''           | 'Dimensions'   | ''                        | ''                             | ''         | ''                                          | ''         | ''                  | ''                                     | ''              | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Quantity'  | 'Amount'  | 'Net amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Return reason' | 'Sales person'    | 'Deferred calculation' |
			| ''                                           | '12.03.2021 08:44:18' | '-2'        | '-665'    | '-563,56'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | ''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-2'        | '-665'    | '-563,56'    | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | ''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-2'        | '-665'    | '-563,56'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | ''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-2'        | '-113,85' | '-96,48'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | ''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-494'    | '-418,64'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | ''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-494'    | '-418,64'    | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | ''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-494'    | '-418,64'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | ''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-95'     | '-80,51'     | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | ''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''              | ''                | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-95'     | '-80,51'     | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | ''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''              | ''                | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-95'     | '-80,51'     | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | ''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''              | ''                | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-84,57'  | '-71,67'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | ''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | ''              | 'Alexander Orlov' | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '-1'        | '-16,26'  | '-13,78'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | ''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''              | ''                | 'No'                   |		
	And I close all client application windows

Scenario: _041305 check Sales return movements by the Register  "R4050 Stock inventory"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'   | ''              | ''                      | ''            | ''               | ''           | ''            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''           | ''            |
			| 'Register  "R4050 Stock inventory"'            | ''              | ''                      | ''            | ''               | ''           | ''            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''            |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'    |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '1'           | 'Main Company'   | 'Store 02'   | 'XS/Blue'     |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '2'           | 'Main Company'   | 'Store 02'   | '36/Red'      |
	And I close all client application windows


Scenario: _041306 check Sales return movements by the Register  "R2021 Customer transactions"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''                  | ''                       | ''                              |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''                  | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'      | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''                  | ''                       | ''                              |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''                  | 'Attributes'             | ''                              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                        | 'Order'   | 'Project'           | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '-1 254'      | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales return 101 dated 12.03.2021 08:44:18'   | ''        | 'Project 01'        | 'No'                     | ''                              |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '-1 254'      | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales return 101 dated 12.03.2021 08:44:18'   | ''        | 'Project 01'        | 'No'                     | ''                              |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '-1 254'      | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales return 101 dated 12.03.2021 08:44:18'   | ''        | 'Project 01'        | 'No'                     | ''                              |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '-214,68'     | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales return 101 dated 12.03.2021 08:44:18'   | ''        | 'Project 01'        | 'No'                     | ''                              |
	And I close all client application windows

Scenario: _041307 check Sales return movements by the Register  "R2040 Taxes incoming"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'   | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''           | ''                     |
			| 'Document registrations records'               | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''           | ''                     |
			| 'Register  "R2040 Taxes incoming"'             | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''           | ''                     |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'        | ''             | 'Dimensions'     | ''                          | ''      | ''           | ''                     |
			| ''                                             | ''              | ''                      | 'Taxable amount'   | 'Tax amount'   | 'Company'        | 'Branch'                    | 'Tax'   | 'Tax rate'   | 'Tax movement type'    |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '80,51'            | '14,49'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'        | ''                     |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '418,64'           | '75,36'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'        | ''                     |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '563,56'           | '101,44'       | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'        | ''                     |
	And I close all client application windows

Scenario: _041308 check Sales return movements by the Register  "R4014 Serial lot numbers"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'      |
			| '1 112'       |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 1 112 dated 20.05.2022 18:36:56' | ''            | ''                    | ''          | ''             | ''             | ''      | ''         | ''                  |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''      | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'         | ''            | ''                    | ''          | ''             | ''             | ''      | ''         | ''                  |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''      | ''         | ''                  |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'       | 'Store' | 'Item key' | 'Serial lot number' |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '5'         | 'Main Company' | 'Front office' | ''      | 'PZU'      | '8908899877'        |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '5'         | 'Main Company' | 'Front office' | ''      | 'PZU'      | '8908899879'        |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '5'         | 'Main Company' | 'Front office' | ''      | 'UNIQ'     | '09987897977889'    |
			| ''                                             | 'Receipt'     | '20.05.2022 18:36:56' | '5'         | 'Main Company' | 'Front office' | ''      | 'UNIQ'     | '09987897977890'    |		
	And I close all client application windows

Scenario: _041309 check Sales return movements by the Register  "R5021 Revenues"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''          | ''                  | ''             | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| 'Document registrations records'             | ''                    | ''          | ''                  | ''             | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| 'Register  "R5021 Revenues"'                 | ''                    | ''          | ''                  | ''             | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| ''                                           | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''                        | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''           |
			| ''                                           | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'                  | 'Profit loss center'      | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project'    |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | '-665'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'Local currency'               | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | '-665'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'en description is empty'      | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | '-494'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'Local currency'               | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | '-494'              | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'en description is empty'      | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-96,48'    | '-113,85'           | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'USD'      | ''                    | 'Reporting currency'           | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | '-95'               | 'Main Company' | 'Distribution department' | 'Front office'            | 'Revenue'      | 'Internet' | 'TRY'      | ''                    | 'Local currency'               | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | '-95'               | 'Main Company' | 'Distribution department' | 'Front office'            | 'Revenue'      | 'Internet' | 'TRY'      | ''                    | 'en description is empty'      | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-71,67'    | '-84,57'            | 'Main Company' | 'Distribution department' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'USD'      | ''                    | 'Reporting currency'           | 'Project 01' |
			| ''                                           | '12.03.2021 08:44:18' | '-13,78'    | '-16,26'            | 'Main Company' | 'Distribution department' | 'Front office'            | 'Revenue'      | 'Internet' | 'USD'      | ''                    | 'Reporting currency'           | 'Project 01' |
	And I close all client application windows



Scenario: _041310 check Sales return movements by the Register  "R4010 Actual stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'              | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '2'           | 'Store 02'     | '36/Red'     | ''                     |
		
	And I close all client application windows


Scenario: _041311 check Sales return movements by the Register  "R4010 Actual stocks" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4010 Actual stocks"    |
	And I close all client application windows

Scenario: _041312 check Sales return movements by the Register  "R4011 Free stocks" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4011 Free stocks"    |
	And I close all client application windows

Scenario: _041313 check Sales return movements by the Register  "R4011 Free stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                | ''              | ''                      | ''            | ''             | ''            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '2'           | 'Store 02'     | '36/Red'      |
	And I close all client application windows

Scenario: _041314 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'      | ''              | ''                      | ''            | ''             | ''                                             | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                             | ''            |
			| 'Register  "R4031 Goods in transit (incoming)"'   | ''              | ''                      | ''            | ''             | ''                                             | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                             | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                        | 'Item key'    |
			| ''                                                | 'Receipt'       | '12.03.2021 08:44:18'   | '1'           | 'Store 02'     | 'Sales return 101 dated 12.03.2021 08:44:18'   | 'XS/Blue'     |
	And I close all client application windows


Scenario: _041315 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'      | ''              | ''                      | ''            | ''             | ''                                              | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                              | ''            |
			| 'Register  "R4031 Goods in transit (incoming)"'   | ''              | ''                      | ''            | ''             | ''                                              | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                              | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                         | 'Item key'    |
			| ''                                                | 'Receipt'       | '12.03.2021 08:59:52'   | '2'           | 'Store 02'     | 'Goods receipt 125 dated 12.03.2021 08:56:32'   | 'XS/Blue'     |
	And I close all client application windows

Scenario: _041315 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'      | ''              | ''                      | ''            | ''             | ''                                              | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                              | ''            |
			| 'Register  "R4031 Goods in transit (incoming)"'   | ''              | ''                      | ''            | ''             | ''                                              | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                              | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                         | 'Item key'    |
			| ''                                                | 'Receipt'       | '12.03.2021 08:59:52'   | '2'           | 'Store 02'     | 'Goods receipt 125 dated 12.03.2021 08:56:32'   | 'XS/Blue'     |
	And I close all client application windows

Scenario: _041316 check Sales return movements by the Register  "R2031 Shipment invoicing" (use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '101'       |
	* Check movements by the Register  "R2031 Shipment invoicing""
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                             | ''            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                             | ''            |
			| 'Register  "R2031 Shipment invoicing"'         | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                             | ''            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                                             | ''            |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'                    | 'Store'      | 'Basis'                                        | 'Item key'    |
			| ''                                             | 'Receipt'       | '12.03.2021 08:44:18'   | '1'           | 'Main Company'   | 'Distribution department'   | 'Store 02'   | 'Sales return 101 dated 12.03.2021 08:44:18'   | 'XS/Blue'     |
	And I close all client application windows

Scenario: _041317 check Sales return movements by the Register  "R2031 Shipment invoicing" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
	* Check movements by the Register  "R2031 Shipment invoicing""
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52' | ''            | ''                    | ''          | ''             | ''       | ''         | ''                                            | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''       | ''         | ''                                            | ''         |
			| 'Register  "R2031 Shipment invoicing"'       | ''            | ''                    | ''          | ''             | ''       | ''         | ''                                            | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''         | ''                                            | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch' | 'Store'    | 'Basis'                                       | 'Item key' |
			| ''                                           | 'Expense'     | '12.03.2021 08:59:52' | '2'         | 'Main Company' | ''       | 'Store 02' | 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'XS/Blue'  |
	And I close all client application windows

Scenario: _041318 check Sales return movements by the Register  "R2012 Invoice closing of sales orders" (without SRO)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
	* Check movements by the Register  "R2012 Invoice closing of sales orders""
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R2012 Invoice closing of sales orders"    |
	And I close all client application windows

Scenario: _041319 check Sales return movements by the Register  "R2012 Invoice closing of sales orders" (with SRO)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '104'       |
	* Check movements by the Register  "R2012 Invoice closing of sales orders""
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 104 dated 12.03.2021 09:20:35'          | ''              | ''                      | ''            | ''         | ''             | ''               | ''                          | ''                                                   | ''           | ''           | ''                                        |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''         | ''             | ''               | ''                          | ''                                                   | ''           | ''           | ''                                        |
			| 'Register  "R2012 Invoice closing of sales orders"'   | ''              | ''                      | ''            | ''         | ''             | ''               | ''                          | ''                                                   | ''           | ''           | ''                                        |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''                          | ''                                                   | ''           | ''           | ''                                        |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'                    | 'Order'                                              | 'Currency'   | 'Item key'   | 'Row key'                                 |
			| ''                                                    | 'Expense'       | '12.03.2021 09:20:35'   | '1'           | '95'       | '80,51'        | 'Main Company'   | 'Distribution department'   | 'Sales return order 102 dated 12.03.2021 09:19:54'   | 'TRY'        | 'Internet'   | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0'    |
			| ''                                                    | 'Expense'       | '12.03.2021 09:20:35'   | '1'           | '494'      | '418,64'       | 'Main Company'   | 'Distribution department'   | 'Sales return order 102 dated 12.03.2021 09:19:54'   | 'TRY'        | 'XS/Blue'    | '0cb89084-5857-45fc-b333-4fbec2c2e90a'    |
			| ''                                                    | 'Expense'       | '12.03.2021 09:20:35'   | '10'          | '3 325'    | '2 817,8'      | 'Main Company'   | 'Distribution department'   | 'Sales return order 102 dated 12.03.2021 09:19:54'   | 'TRY'        | '36/Red'     | '3a8fe357-b7bd-4d83-8816-c8348bbf4595'    |
			| ''                                                    | 'Expense'       | '12.03.2021 09:20:35'   | '24'          | '15 960'   | '13 525,42'    | 'Main Company'   | 'Distribution department'   | 'Sales return order 102 dated 12.03.2021 09:19:54'   | 'TRY'        | '36/18SD'    | 'db32e58d-ac68-45b6-b0b5-b90d6c02fbff'    |
	And I close all client application windows

Scenario: _041320 check Sales return with serial lot numbers movements by the Register  "R4010 Actual stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
		And I select current line in "List" table
		And I activate "Use goods receipt" field in "ItemList" table
		And for each line of "ItemList" table I do
			And I remove "Use goods receipt" checkbox in "ItemList" table		
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 1 112 dated 20.05.2022 18:36:56'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                               | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                               | 'Receipt'       | '20.05.2022 18:36:56'   | '5'           | 'Store 02'     | 'PZU'        | '8908899877'           |
			| ''                                               | 'Receipt'       | '20.05.2022 18:36:56'   | '5'           | 'Store 02'     | 'PZU'        | '8908899879'           |
			| ''                                               | 'Receipt'       | '20.05.2022 18:36:56'   | '10'          | 'Store 02'     | 'XL/Green'   | ''                     |
			| ''                                               | 'Receipt'       | '20.05.2022 18:36:56'   | '10'          | 'Store 02'     | 'UNIQ'       | ''                     |
	And I close all client application windows

Scenario: _041321 check Sales return movements by the Register  "R2012 Invoice closing of sales orders" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "T2015 Transactions info""
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "T2015 Transactions info"    |
	And I close all client application windows


Scenario: _041326 check Sales return movements by the Register  "T2015 Transactions info"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '106'       |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 106 dated 21.04.2021 14:19:47' | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''        | ''              | ''                         | ''                      | ''                        | ''                                           | ''          | ''          |
			| 'Document registrations records'             | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''        | ''              | ''                         | ''                      | ''                        | ''                                           | ''          | ''          |
			| 'Register  "T2015 Transactions info"'        | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''        | ''              | ''                         | ''                      | ''                        | ''                                           | ''          | ''          |
			| ''                                           | 'Resources' | ''       | ''        | 'Dimensions'   | ''                        | ''      | ''                    | ''                                     | ''         | ''        | ''              | ''                         | ''                      | ''                        | ''                                           | ''          | ''          |
			| ''                                           | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner' | 'Legal name'    | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                          | 'Unique ID' | 'Project'   |
			| ''                                           | '-9 360'    | 'Yes'    | 'No'      | 'Main Company' | 'Distribution department' | ''      | '21.04.2021 14:19:47' | '                                    ' | 'TRY'      | 'Lunch'   | 'Company Lunch' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | 'Sales return 106 dated 21.04.2021 14:19:47' | '*'         | ''          |
	And I close all client application windows




Scenario: _041325 check Sales return movements by the Register  "R2001 Sales"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '107'       |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 107 dated 21.04.2021 14:24:43' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'             | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                    | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| ''                                           | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| ''                                           | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                     | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-520'   | '-440,68'    | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | ''                  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-520'   | '-440,68'    | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | ''                  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-520'   | '-440,68'    | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | ''                  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |
			| ''                                           | '21.04.2021 14:24:43' | '-1'        | '-89,02' | '-75,44'     | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'XS/Blue'  | ''                  | 'f441f6a4-f90d-4139-a593-e2d3d7c111ef' | ''             |		
	And I close all client application windows

Scenario: _041327 check Sales return movements by the Register  "R2001 Sales" (withot SI)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 102 dated 12.03.2021 08:50:27' | ''                    | ''          | ''        | ''           | ''              | ''             | ''                     | ''                             | ''         | ''                                           | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'             | ''                    | ''          | ''        | ''           | ''              | ''             | ''                     | ''                             | ''         | ''                                           | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                    | ''                    | ''          | ''        | ''           | ''              | ''             | ''                     | ''                             | ''         | ''                                           | ''         | ''                  | ''                                     | ''             |
			| ''                                           | 'Period'              | 'Resources' | ''        | ''           | ''              | 'Dimensions'   | ''                     | ''                             | ''         | ''                                           | ''         | ''                  | ''                                     | ''             |
			| ''                                           | ''                    | 'Quantity'  | 'Amount'  | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'               | 'Multi currency movement type' | 'Currency' | 'Invoice'                                    | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-665'    | '-563,56'    | '-35'           | 'Main Company' | 'Logistics department' | 'Local currency'               | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | ''                  | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-665'    | '-563,56'    | '-35'           | 'Main Company' | 'Logistics department' | 'TRY'                          | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | ''                  | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-665'    | '-563,56'    | '-35'           | 'Main Company' | 'Logistics department' | 'en description is empty'      | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | ''                  | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-2'        | '-113,85' | '-96,48'     | '-5,99'         | 'Main Company' | 'Logistics department' | 'Reporting currency'           | 'USD'      | 'Sales return 102 dated 12.03.2021 08:50:27' | '36/Red'   | ''                  | '512b5626-66dc-4fc0-b96e-359108f4d7b7' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-494'    | '-418,64'    | '-26'           | 'Main Company' | 'Logistics department' | 'Local currency'               | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | ''                  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-494'    | '-418,64'    | '-26'           | 'Main Company' | 'Logistics department' | 'TRY'                          | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | ''                  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-494'    | '-418,64'    | '-26'           | 'Main Company' | 'Logistics department' | 'en description is empty'      | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | ''                  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '-84,57'  | '-71,67'     | '-4,45'         | 'Main Company' | 'Logistics department' | 'Reporting currency'           | 'USD'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'XS/Blue'  | ''                  | 'c77b27bd-8d19-4d55-b590-bd5ecc463efd' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '0,86'    | '0,73'       | '-0,86'         | 'Main Company' | 'Logistics department' | 'Reporting currency'           | 'USD'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Internet' | ''                  | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '5'       | '4,24'       | '-5'            | 'Main Company' | 'Logistics department' | 'Local currency'               | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Internet' | ''                  | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '5'       | '4,24'       | '-5'            | 'Main Company' | 'Logistics department' | 'TRY'                          | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Internet' | ''                  | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |
			| ''                                           | '12.03.2021 08:50:27' | '-1'        | '5'       | '4,24'       | '-5'            | 'Main Company' | 'Logistics department' | 'en description is empty'      | 'TRY'      | 'Sales return 102 dated 12.03.2021 08:50:27' | 'Internet' | ''                  | 'af263f16-367e-4b29-ab41-7bc578d06d4b' | ''             |	
	And I close all client application windows

Scenario: _041328 check Sales return movements by the Register  "R2001 Sales" (serial lot numbers)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 1 113 dated 14.12.2023 18:57:00' | ''                    | ''          | ''        | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'               | ''                    | ''          | ''        | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                      | ''                    | ''          | ''        | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''             |
			| ''                                             | 'Period'              | 'Resources' | ''        | ''           | ''              | 'Dimensions'   | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''             |
			| ''                                             | ''                    | 'Quantity'  | 'Amount'  | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice'                                      | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-133,32' | '-112,98'    | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-133,32' | '-112,98'    | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-133,32' | '-112,98'    | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-22,82'  | '-19,34'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-605'    | '-512,71'    | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-605'    | '-512,71'    | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-605'    | '-512,71'    | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-103,58' | '-87,78'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-1 650'  | '-1 398,31'  | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-1 650'  | '-1 398,31'  | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-1 650'  | '-1 398,31'  | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-282,48' | '-239,39'    | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-99,99'  | '-84,74'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-99,99'  | '-84,74'     | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-99,99'  | '-84,74'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-66,66'  | '-56,49'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-66,66'  | '-56,49'     | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-66,66'  | '-56,49'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-17,12'  | '-14,51'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-11,41'  | '-9,67'      | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-66,67'  | '-56,5'      | '-3,33'         | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-66,67'  | '-56,5'      | '-3,33'         | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-66,67'  | '-56,5'      | '-3,33'         | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-11,41'  | '-9,67'      | '-0,57'         | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-33,33'  | '-28,25'     | '-1,67'         | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-33,33'  | '-28,25'     | '-1,67'         | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-33,33'  | '-28,25'     | '-1,67'         | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-5,71'   | '-4,84'      | '-0,29'         | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''             |	
	And I close all client application windows

Scenario: _041329 check Sales return movements by the Register  "R2002 Sales returns" (serial lot numbers)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 1 113 dated 14.12.2023 18:57:00' | ''                    | ''          | ''        | ''           | ''             | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''        | ''           | ''             | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| 'Register  "R2002 Sales returns"'              | ''                    | ''          | ''        | ''           | ''             | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | ''        | ''           | 'Dimensions'   | ''       | ''                             | ''         | ''                                             | ''         | ''                  | ''                                     | ''              | ''             | 'Attributes'           |
			| ''                                             | ''                    | 'Quantity'  | 'Amount'  | 'Net amount' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice'                                      | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Return reason' | 'Sales person' | 'Deferred calculation' |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-133,32' | '-112,98'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-133,32' | '-112,98'    | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-133,32' | '-112,98'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-6'        | '-22,82'  | '-19,34'     | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0514'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-605'    | '-512,71'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-605'    | '-512,71'    | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-605'    | '-512,71'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-5'        | '-103,58' | '-87,78'     | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'UNIQ'     | '0512'              | '35d19216-50b7-4790-9eed-8c4fa5b16767' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-1 650'  | '-1 398,31'  | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-1 650'  | '-1 398,31'  | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-1 650'  | '-1 398,31'  | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-282,48' | '-239,39'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'S/Yellow' | ''                  | '2679c802-6b8e-4ee0-aa63-6e5587c6c060' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-99,99'  | '-84,74'     | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-99,99'  | '-84,74'     | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-99,99'  | '-84,74'     | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-66,66'  | '-56,49'     | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-66,66'  | '-56,49'     | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-66,66'  | '-56,49'     | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-17,12'  | '-14,51'     | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | 'db4bd01a-2928-41df-944c-a07977d99a33' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-3'        | '-11,41'  | '-9,67'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '0512'              | '6aecbde5-7832-4b86-a407-38a2d629bc91' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-66,67'  | '-56,5'      | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-66,67'  | '-56,5'      | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-66,67'  | '-56,5'      | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-2'        | '-11,41'  | '-9,67'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899877'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-33,33'  | '-28,25'     | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-33,33'  | '-28,25'     | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-33,33'  | '-28,25'     | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |
			| ''                                             | '14.12.2023 18:57:00' | '-1'        | '-5,71'   | '-4,84'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales return 1 113 dated 14.12.2023 18:57:00' | 'PZU'      | '8908899879'        | '64da38a6-fd64-473e-abf6-a53ac267001a' | ''              | ''             | 'No'                   |	
	And I close all client application windows

Scenario: _041330 Sales return clear posting/mark for deletion
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'    |
			| 'Document registrations records'                |
		And I close current window
	* Post Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2031 Shipment invoicing'             |
			| 'R5010 Reconciliation statement'       |
			| 'R2002 Sales returns'                  |
			| 'R4050 Stock inventory'                |
			| 'R2021 Customer transactions'          |
			| 'R4031 Goods in transit (incoming)'    |
			| 'R2040 Taxes incoming'                 |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'    |
			| 'Document registrations records'                |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2031 Shipment invoicing'             |
			| 'R5010 Reconciliation statement'       |
			| 'R2002 Sales returns'                  |
			| 'R4050 Stock inventory'                |
			| 'R2021 Customer transactions'          |
			| 'R4031 Goods in transit (incoming)'    |
			| 'R2040 Taxes incoming'                 |
		And I close all client application windows

Scenario: _041328 check Sales return movements by the Register  "R4010 Actual stocks" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27'   | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'              | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'          | ''           | ''                     |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'               | 'Item key'   | 'Serial lot number'    |
			| ''                                             | 'Receipt'       | '02.11.2022 10:53:27'   | '1'           | 'Store 01'            | 'XS/Blue'    | ''                     |
			| ''                                             | 'Receipt'       | '02.11.2022 10:53:27'   | '2'           | 'Store 01'            | 'PZU'        | '8908899877'           |
			| ''                                             | 'Receipt'       | '02.11.2022 10:53:27'   | '2'           | 'Store 01'            | 'PZU'        | '8908899879'           |
			| ''                                             | 'Expense'       | '02.11.2022 10:53:27'   | '1'           | 'Trade agent store'   | 'XS/Blue'    | ''                     |
			| ''                                             | 'Expense'       | '02.11.2022 10:53:27'   | '2'           | 'Trade agent store'   | 'PZU'        | '8908899877'           |
			| ''                                             | 'Expense'       | '02.11.2022 10:53:27'   | '2'           | 'Trade agent store'   | 'PZU'        | '8908899879'           |
		And I close all client application windows
		
Scenario: _041329 check Sales return movements by the Register  "R4011 Free stocks" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                | ''              | ''                      | ''            | ''             | ''            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                             | 'Receipt'       | '02.11.2022 10:53:27'   | '1'           | 'Store 01'     | 'XS/Blue'     |
			| ''                                             | 'Receipt'       | '02.11.2022 10:53:27'   | '4'           | 'Store 01'     | 'PZU'         |
		And I close all client application windows				

Scenario: _041331 check Sales return movements by the Register  "R4050 Stock inventory" (Return from trade agent)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report info" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 192 dated 02.11.2022 10:53:27' | ''                    | ''           | ''             | ''                  | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'          | ''                    | ''           | ''             | ''                  | ''         | ''         |
			| ''                                           | 'Period'              | 'RecordType' | 'Company'      | 'Store'             | 'Item key' | 'Quantity' |
			| ''                                           | '02.11.2022 10:53:27' | 'Receipt'    | 'Main Company' | 'Store 01'          | 'XS/Blue'  | '1'        |
			| ''                                           | '02.11.2022 10:53:27' | 'Receipt'    | 'Main Company' | 'Store 01'          | 'PZU'      | '4'        |
			| ''                                           | '02.11.2022 10:53:27' | 'Expense'    | 'Main Company' | 'Trade agent store' | 'XS/Blue'  | '1'        |
			| ''                                           | '02.11.2022 10:53:27' | 'Expense'    | 'Main Company' | 'Trade agent store' | 'PZU'      | '4'        |	
		And I close all client application windows	
	

Scenario: _041334 check Sales return movements by the Register  "R2001 Sales" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2001 Sales"'    |
		And I close all client application windows

Scenario: _041335 check Sales return movements by the Register  "R2002 Sales returns" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2002 Sales returns"'    |
		And I close all client application windows

Scenario: _041336 check Sales return movements by the Register  "R2021 Customer transactions" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2021 Customer transactions"'    |
		And I close all client application windows

Scenario: _041337 check Sales return movements by the Register  "R2040 Taxes incoming" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2040 Taxes incoming"'    |
		And I close all client application windows

Scenario: _041338 check Sales return movements by the Register  "R5021 Revenues" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5021 Revenues"'    |
		And I close all client application windows

Scenario: _041339 check Sales return movements by the Register  "R5021 Revenues" (Return from trade agent)
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5021 Revenues"'    |
		And I close all client application windows
