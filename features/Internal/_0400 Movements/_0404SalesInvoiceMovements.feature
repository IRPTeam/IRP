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
	* Unpost SO closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		If "List" table contains lines Then
				| "Number"     |
				| "1"          |
			And I execute 1C:Enterprise script at server
					| "Documents.SalesOrderClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.UndoPosting);"      |
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
		When Create catalog Countries objects
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
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog Items objects (commission trade)
		When Create information register Taxes records (VAT)
	When Create Document discount
	When settings for Main Company (commission trade)
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
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
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrder objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
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
		When Create document SalesInvoice objects (with aging, prepaid)
		When Create document SalesInvoiceobjects (stock control serial lot numbers)
		When Create document SalesInvoice and SalesReturn objects (comission trade)
		When Create document SalesInvoice objects (comission trade, consignment)
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		When Create document SalesInvoiceobjects (serial lot numbers sales)
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
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(191).GetObject().Write(DocumentWriteMode.Write);"      |
		And Delay 5
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
			| "Documents.SalesInvoice.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check query for sales invoice movements
		// Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
		// And in the table "Info" I click "Fill movements" button
	And I close all client application windows
		


Scenario: _0401301 check preparation
	When check preparation

//1


Scenario: _0401311 check Sales invoice movements by the Register  "R2005 Sales special offers" SO-SC-SI (with special offers)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
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
			| ''                                          | '28.01.2021 18:48:53' | '16,26'        | '13,78'      | '0,86'          | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '84,57'        | '71,67'      | '4,45'          | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '569,24'       | '482,41'     | '29,96'         | ''                 | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |	
		And I close all client application windows
		
Scenario: _040132 check Sales invoice movements by the Register  "R5010 Reconciliation statement"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'    | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                    | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                             | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP'     |
		And I close all client application windows
		
Scenario: _040133 check Sales invoice movements by the Register  "R4010 Actual stocks" (use SC, SC first)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'    |
			
		And I close all client application windows
		
Scenario: _040134 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2011 Shipment of sales orders" 
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2011 Shipment of sales orders"'    |
		And I close all client application windows
		
Scenario: _040135 check Sales invoice movements by the Register  "R4050 Stock inventory"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''              | ''                      | ''            | ''               | ''           | ''            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''           | ''            |
			| 'Register  "R4050 Stock inventory"'           | ''              | ''                      | ''            | ''               | ''           | ''            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''            |
			| ''                                            | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '1'           | 'Main Company'   | 'Store 02'   | 'XS/Blue'     |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '10'          | 'Main Company'   | 'Store 02'   | '36/Red'      |
			
		And I close all client application windows
		
Scenario: _040136 check Sales invoice movements by the Register  "R2001 Sales"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                          | ''         |''                  | ''                                     | ''                |
			| 'Document registrations records'            | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                          | ''         |''                  | ''                                     | ''                |
			| 'Register  "R2001 Sales"'                   | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                          | ''         |''                  | ''                                     | ''                |
			| ''                                          | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''                             | ''         | ''                                          | ''         |''                  | ''                                     | ''                |
			| ''                                          | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' |'Serial lot number' |'Row key'                              | 'Sales person'    |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '16,26'  | '13,78'      | '0,86'          | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' |''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '84,57'  | '71,67'      | '4,45'          | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  |''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' |''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' |''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Internet' |''                  | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  |''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  |''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  |''                  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '569,24' | '482,41'     | '29,96'         | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   |''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   |''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   |''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'Alexander Orlov' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   |''                  | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'Alexander Orlov' |		
		And I close all client application windows
		
Scenario: _040137 check Sales invoice movements by the Register  "R2021 Customer transactions"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''           | ''                       | ''                              |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''           | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'     | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''           | ''                       | ''                              |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''           | 'Attributes'             | ''                              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                       | 'Order'                                     | 'Project'    | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '670,08'      | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''           | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''           | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''           | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''           | 'No'                     | ''                              |
		And I close all client application windows
				

Scenario: _040138 check Sales invoice movements by the Register  "R4011 Free stocks" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'    |
		And I close all client application windows
		
Scenario: _040139 check Sales invoice movements by the Register  "R4012 Stock Reservation" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
			
		And I close all client application windows
		
Scenario: _040140 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
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
			| ''                                              | 'Receipt'     | '28.01.2021 18:48:53' | '1'         | 'Store 02'   | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '28.01.2021 18:48:53' | '10'        | 'Store 02'   | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | '36/Red'   |		
		And I close all client application windows
		
Scenario: _040141 check Sales invoice movements by the Register  "R5011 Customers aging" (without aging)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5011 Customers aging"
		And I click "Registrations report" button
		And I select "R5011 Customers aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5011 Customers aging"'    |
			
		And I close all client application windows
		
Scenario: _040142 check Sales invoice movements by the Register  "R2020 Advances from customer" (without advances)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer"'    |
			
		And I close all client application windows
		
Scenario: _040143 check Sales invoice movements by the Register  "R2040 Taxes incoming"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''           | ''                     |
			| 'Document registrations records'              | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''           | ''                     |
			| 'Register  "R2040 Taxes incoming"'            | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''           | ''                     |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'        | ''             | 'Dimensions'     | ''                          | ''      | ''           | ''                     |
			| ''                                            | ''              | ''                      | 'Taxable amount'   | 'Tax amount'   | 'Company'        | 'Branch'                    | 'Tax'   | 'Tax rate'   | 'Tax movement type'    |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '80,51'            | '14,49'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'        | ''                     |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '418,64'           | '75,36'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'        | ''                     |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '2 817,8'          | '507,2'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'        | ''                     |
			
		And I close all client application windows
		
Scenario: _040144 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"'    |
			
		And I close all client application windows
		
Scenario: _040145 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (without serial lot numbers)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4014 Serial lot numbers"'    |
			
		And I close all client application windows
		
Scenario: _040146 check Sales invoice movements by the Register  "R2031 Shipment invoicing" SO-SC-SI
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
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
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '1'         | 'Main Company' | 'Distribution department' | 'Store 02' | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '10'        | 'Main Company' | 'Distribution department' | 'Store 02' | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | '36/Red'   |		
		And I close all client application windows
		
Scenario: _040147 check Sales invoice movements by the Register  "R2012 Invoice closing of sales orders" (SO exists)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
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
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'Internet' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |		
		And I close all client application windows

//2


		
Scenario: _0401442 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"'   | ''              | ''                      | ''            | ''               | ''               | ''                                          | ''           | ''           | ''                                        |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                                          | ''           | ''           | ''                                        |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Basis'                                     | 'Store'      | 'Item key'   | 'Row key'                                 |
			| ''                                              | 'Expense'       | '28.01.2021 18:49:39'   | '5'           | 'Main Company'   | 'Main Company'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Store 02'   | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'    |
			| ''                                              | 'Expense'       | '28.01.2021 18:49:39'   | '10'          | 'Main Company'   | 'Main Company'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Store 02'   | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'    |
	
		And I close all client application windows
		
Scenario: _0401443 check Sales invoice movements by the Register  "R4011 Free stocks" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'    |
		And I close all client application windows

Scenario: _0401444 check Sales invoice movements by the Register  "R4012 Stock Reservation" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
		And I close all client application windows

Scenario: _0401445 check Sales invoice movements by the Register  "R4010 Actual stocks" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'    |
		And I close all client application windows	

Scenario: _0401446 check Sales invoice movements by the Register  "R5021 Revenues"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Period'                | 'Amount'    | 'Amount with taxes'   | 'Dimensions'     | ''                          | ''          | ''           | ''      | ''   | ''                           |
			| '28.01.2021 18:49:39'   | '13,78'     | '16,26'               | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'Internet'   | 'USD'   | ''   | 'Reporting currency'         |
			| '28.01.2021 18:49:39'   | '80,51'     | '95'                  | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'Internet'   | 'TRY'   | ''   | 'Local currency'             |
			| '28.01.2021 18:49:39'   | '80,51'     | '95'                  | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'Internet'   | 'TRY'   | ''   | 'TRY'                        |
			| '28.01.2021 18:49:39'   | '80,51'     | '95'                  | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'Internet'   | 'TRY'   | ''   | 'en description is empty'    |
			| '28.01.2021 18:49:39'   | '358,36'    | '422,86'              | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'XS/Blue'    | 'USD'   | ''   | 'Reporting currency'         |
			| '28.01.2021 18:49:39'   | '482,41'    | '569,24'              | 'Main Company'   | 'Distribution department'   | 'Revenue'   | '36/Red'     | 'USD'   | ''   | 'Reporting currency'         |
			| '28.01.2021 18:49:39'   | '2 093,2'   | '2 470'               | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'XS/Blue'    | 'TRY'   | ''   | 'Local currency'             |
			| '28.01.2021 18:49:39'   | '2 093,2'   | '2 470'               | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'XS/Blue'    | 'TRY'   | ''   | 'TRY'                        |
			| '28.01.2021 18:49:39'   | '2 093,2'   | '2 470'               | 'Main Company'   | 'Distribution department'   | 'Revenue'   | 'XS/Blue'    | 'TRY'   | ''   | 'en description is empty'    |
			| '28.01.2021 18:49:39'   | '2 817,8'   | '3 325'               | 'Main Company'   | 'Distribution department'   | 'Revenue'   | '36/Red'     | 'TRY'   | ''   | 'Local currency'             |
			| '28.01.2021 18:49:39'   | '2 817,8'   | '3 325'               | 'Main Company'   | 'Distribution department'   | 'Revenue'   | '36/Red'     | 'TRY'   | ''   | 'TRY'                        |
			| '28.01.2021 18:49:39'   | '2 817,8'   | '3 325'               | 'Main Company'   | 'Distribution department'   | 'Revenue'   | '36/Red'     | 'TRY'   | ''   | 'en description is empty'    |
		And I close all client application windows	


//3


		
		
Scenario: _0401333 check Sales invoice movements by the Register  "R4010 Actual stocks" (SO-SI-SC, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
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
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 112 dated 23.05.2022 16:25:33'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                 | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                | 'Expense'       | '23.05.2022 16:25:33'   | '23'          | 'Store 02'     | 'PZU'        | '8908899879'           |
		And I close all client application windows
		
Scenario: _0401343 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" (SO-SI, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R2011 Shipment of sales orders"
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'  | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                                        | ''         | ''                                     |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Order'                                   | 'Item key' | 'Row key'                              |
			| ''                                           | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Main Company' | 'Distribution department' | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |		
		And I close all client application windows
	
		
		
Scenario: _0401383 check Sales invoice movements by the Register  "R4011 Free stocks" (SO-SI-SC, PM - Not Stock)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'               | ''              | ''                      | ''            | ''             | ''            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                            | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:50:57'   | '24'          | 'Store 02'     | '37/18SD'     |
		And I close all client application windows 



Scenario: _0401385 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" SO-SI-SC (use and not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
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
			| ''                                              | 'Receipt'     | '28.01.2021 18:50:57' | '24'        | 'Store 02'   | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/18SD'  |		
		And I close all client application windows


//4

Scenario: _0401314 check Sales invoice movements by the Register  "R5011 Customers aging" (use Aging, Receipt)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R5011 Customers aging"
		And I click "Registrations report" button
		And I select "R5011 Customers aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                            | ''          | ''                                            | ''                      | ''                 |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                            | ''          | ''                                            | ''                      | ''                 |
			| 'Register  "R5011 Customers aging"'           | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                            | ''          | ''                                            | ''                      | ''                 |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                            | ''          | ''                                            | ''                      | 'Attributes'       |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Currency'   | 'Agreement'                   | 'Partner'   | 'Invoice'                                     | 'Payment date'          | 'Aging closing'    |
			| ''                                            | 'Receipt'       | '16.02.2021 10:59:49'   | '23 374'      | 'Main Company'   | 'Distribution department'   | 'USD'        | 'Personal Partner terms, $'   | 'Kalipso'   | 'Sales invoice 4 dated 16.02.2021 10:59:49'   | '23.02.2021 00:00:00'   | ''                 |
		And I close all client application windows 


Scenario: _0401315 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (use Serial lot number)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'   | ''              | ''                      | ''            | ''               | ''                          | ''        | ''           | ''                     |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''                          | ''        | ''           | ''                     |
			| 'Register  "R4014 Serial lot numbers"'        | ''              | ''                      | ''            | ''               | ''                          | ''        | ''           | ''                     |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''        | ''           | ''                     |
			| ''                                            | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'                    | 'Store'   | 'Item key'   | 'Serial lot number'    |
			| ''                                            | 'Expense'       | '16.02.2021 10:59:49'   | '10'          | 'Main Company'   | 'Distribution department'   | ''        | '36/Red'     | '0512'                 |
		And I close all client application windows 

Scenario: _0401316 check Sales invoice movements by the Register  "R2022 Customers payment planning" (use Aging, Receipt)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R2022 Customers payment planning"
		And I click "Registrations report" button
		And I select "R2022 Customers payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'      | ''              | ''                      | ''            | ''               | ''                          | ''                                            | ''                  | ''          | ''                             |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                            | ''                  | ''          | ''                             |
			| 'Register  "R2022 Customers payment planning"'   | ''              | ''                      | ''            | ''               | ''                          | ''                                            | ''                  | ''          | ''                             |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                                            | ''                  | ''          | ''                             |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Basis'                                       | 'Legal name'        | 'Partner'   | 'Agreement'                    |
			| ''                                               | 'Receipt'       | '16.02.2021 10:59:49'   | '23 374'      | 'Main Company'   | 'Distribution department'   | 'Sales invoice 4 dated 16.02.2021 10:59:49'   | 'Company Kalipso'   | 'Kalipso'   | 'Personal Partner terms, $'    |
		And I close all client application windows 

Scenario: _0401317 check there is no Sales invoice movements by the Register  "R2022 Customers payment planning" (without Aging)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R2022 Customers payment planning"
		And I click "Registrations report" button
		And I select "R2022 Customers payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'    |
			| 'Document registrations records'               |
		And I close all client application windows 

Scenario: _0401318 check there is no Sales invoice movements by the Register  "R2022 Customers payment planning" (Aging - pre-paid)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '112'       |
	* Check movements by the Register  "R2022 Customers payment planning"
		And I click "Registrations report" button
		And I select "R2022 Customers payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 112 dated 30.05.2021 12:48:26'    | ''              | ''                      | ''            | ''               | ''                          | ''                                              | ''                  | ''          | ''                                    |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                              | ''                  | ''          | ''                                    |
			| 'Register  "R2022 Customers payment planning"'   | ''              | ''                      | ''            | ''               | ''                          | ''                                              | ''                  | ''          | ''                                    |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                                              | ''                  | ''          | ''                                    |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Basis'                                         | 'Legal name'        | 'Partner'   | 'Agreement'                           |
			| ''                                               | 'Receipt'       | '30.05.2021 12:48:26'   | '400'         | 'Main Company'   | 'Distribution department'   | 'Sales invoice 112 dated 30.05.2021 12:48:26'   | 'Company Kalipso'   | 'Kalipso'   | 'Basic Partner terms, without VAT'    |
		And I close all client application windows 


Scenario: _0401320 check Sales invoice movements by the Register  "R4012 Stock Reservation" (without SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
		And I close all client application windows

Scenario: _0401317 check Sales invoice movements by the Register  "R2031 Shipment invoicing" (SI first, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                            | ''            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                            | ''            |
			| 'Register  "R2031 Shipment invoicing"'        | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                            | ''            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                                            | ''            |
			| ''                                            | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'                    | 'Store'      | 'Basis'                                       | 'Item key'    |
			| ''                                            | 'Receipt'       | '16.02.2021 10:59:49'   | '1'           | 'Main Company'   | 'Distribution department'   | 'Store 02'   | 'Sales invoice 4 dated 16.02.2021 10:59:49'   | 'XS/Blue'     |
			| ''                                            | 'Receipt'       | '16.02.2021 10:59:49'   | '24'          | 'Main Company'   | 'Distribution department'   | 'Store 02'   | 'Sales invoice 4 dated 16.02.2021 10:59:49'   | '37/18SD'     |
		And I close all client application windows

Scenario: _0401318 check Sales invoice movements by the Register  "R4011 Free stocks" (SI first, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'               | ''              | ''                      | ''            | ''             | ''            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                            | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                            | 'Expense'       | '16.02.2021 10:59:49'   | '20'          | 'Store 02'     | '36/Red'      |
		And I close all client application windows

Scenario: _0401319 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI first, use and not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'       | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| 'Register  "R4032 Goods in transit (outgoing)"'   | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                            | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                       | 'Item key'    |
			| ''                                                | 'Receipt'       | '16.02.2021 10:59:49'   | '1'           | 'Store 02'     | 'Sales invoice 4 dated 16.02.2021 10:59:49'   | 'XS/Blue'     |
			| ''                                                | 'Receipt'       | '16.02.2021 10:59:49'   | '24'          | 'Store 02'     | 'Sales invoice 4 dated 16.02.2021 10:59:49'   | '37/18SD'     |
		And I close all client application windows

//8 SI>SO

Scenario: _0401325 check Sales invoice movements by the Register  "R4011 Free stocks" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'    |
		And I close all client application windows
	
Scenario: _0401326 check Sales invoice movements by the Register  "R4012 Stock Reservation" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
		And I close all client application windows


Scenario: _0401327 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 8 dated 18.02.2021 10:48:46'       | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| 'Register  "R4032 Goods in transit (outgoing)"'   | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                            | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                       | 'Item key'    |
			| ''                                                | 'Receipt'       | '18.02.2021 10:48:46'   | '10'          | 'Store 02'     | 'Sales invoice 8 dated 18.02.2021 10:48:46'   | 'XS/Blue'     |
			| ''                                                | 'Receipt'       | '18.02.2021 10:48:46'   | '15'          | 'Store 02'     | 'Sales invoice 8 dated 18.02.2021 10:48:46'   | 'XS/Blue'     |
		And I close all client application windows

Scenario: _0401327 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 8 dated 18.02.2021 10:48:46'       | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| 'Register  "R4032 Goods in transit (outgoing)"'   | ''              | ''                      | ''            | ''             | ''                                            | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                            | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                       | 'Item key'    |
			| ''                                                | 'Receipt'       | '18.02.2021 10:48:46'   | '10'          | 'Store 02'     | 'Sales invoice 8 dated 18.02.2021 10:48:46'   | 'XS/Blue'     |
			| ''                                                | 'Receipt'       | '18.02.2021 10:48:46'   | '15'          | 'Store 02'     | 'Sales invoice 8 dated 18.02.2021 10:48:46'   | 'XS/Blue'     |
		And I close all client application windows

// Commission trade

Scenario: _0401330 check Sales invoice movements by the Register  "R4010 Actual stocks" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '192'      |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19'   | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'               | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'          | ''           | ''                     |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Store'               | 'Item key'   | 'Serial lot number'    |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '1'           | 'Trade agent store'   | '37/18SD'    | ''                     |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '2'           | 'Trade agent store'   | 'PZU'        | '8908899877'           |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '2'           | 'Trade agent store'   | 'PZU'        | '8908899879'           |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '2'           | 'Trade agent store'   | 'UNIQ'       | ''                     |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '4'           | 'Trade agent store'   | 'XS/Blue'    | ''                     |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '1'           | 'Store 01'            | '37/18SD'    | ''                     |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Store 01'            | 'PZU'        | '8908899877'           |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Store 01'            | 'PZU'        | '8908899879'           |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Store 01'            | 'UNIQ'       | ''                     |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '4'           | 'Store 01'            | 'XS/Blue'    | ''                     |
	And I close all client application windows
				
Scenario: _0401331 check Sales invoice movements by the Register  "R4011 Free stocks" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '192'      |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                 | ''              | ''                      | ''            | ''             | ''            |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '1'           | 'Store 01'     | '37/18SD'     |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Store 01'     | 'UNIQ'        |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '4'           | 'Store 01'     | 'XS/Blue'     |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '4'           | 'Store 01'     | 'PZU'         |
		And I close all client application windows
		
Scenario: _0401332 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '192'      |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19'   | ''              | ''                      | ''            | ''               | ''                          | ''        | ''           | ''                     |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''                          | ''        | ''           | ''                     |
			| 'Register  "R4014 Serial lot numbers"'          | ''              | ''                      | ''            | ''               | ''                          | ''        | ''           | ''                     |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''        | ''           | ''                     |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'                    | 'Store'   | 'Item key'   | 'Serial lot number'    |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Main Company'   | 'Distribution department'   | ''        | 'PZU'        | '8908899877'           |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Main Company'   | 'Distribution department'   | ''        | 'PZU'        | '8908899879'           |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Main Company'   | 'Distribution department'   | ''        | 'UNIQ'       | '899007790088'         |
		And I close all client application windows	

Scenario: _0401333 check Sales invoice movements by the Register  "R4050 Stock inventory" (Shipment to trade agent)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '192'      |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 192 dated 02.11.2022 10:53:19'   | ''              | ''                      | ''            | ''               | ''                    | ''            |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''                    | ''            |
			| 'Register  "R4050 Stock inventory"'             | ''              | ''                      | ''            | ''               | ''                    | ''            |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                    | ''            |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'               | 'Item key'    |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '1'           | 'Main Company'   | 'Trade agent store'   | '37/18SD'     |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '2'           | 'Main Company'   | 'Trade agent store'   | 'UNIQ'        |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '4'           | 'Main Company'   | 'Trade agent store'   | 'XS/Blue'     |
			| ''                                              | 'Receipt'       | '02.11.2022 10:53:19'   | '4'           | 'Main Company'   | 'Trade agent store'   | 'PZU'         |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '1'           | 'Main Company'   | 'Store 01'            | '37/18SD'     |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '2'           | 'Main Company'   | 'Store 01'            | 'UNIQ'        |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '4'           | 'Main Company'   | 'Store 01'            | 'XS/Blue'     |
			| ''                                              | 'Expense'       | '02.11.2022 10:53:19'   | '4'           | 'Main Company'   | 'Store 01'            | 'PZU'         |
	And I close all client application windows						





Scenario: _0401336 check Sales invoice movements by the Register  "R2001 Sales" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401337 check Sales invoice movements by the Register  "R2021 Customer transactions" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401338 check Sales invoice movements by the Register  "R2040 Taxes incoming" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401339 check Sales invoice movements by the Register  "R5010 Reconciliation statement" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "R5010 Reconciliation statementg"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement"'    |
		And I close all client application windows

Scenario: _0401340 check Sales invoice movements by the Register  "R5021 Revenues" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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

Scenario: _0401341 check Sales invoice movements by the Register  "R2001 Sales" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'              | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                     | ''                    | ''          | ''       | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| ''                                            | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''                             | ''         | ''                                            | ''         | ''                  | ''                                     | ''             |
			| ''                                            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                     | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '17,12'  | '14,51'      | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '09987897977889'    | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '89,02'  | '75,44'      | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | ''                  | '5742dfd4-05ae-4cc4-83cd-22be8886e921' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '100'    | '84,75'      | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '09987897977889'    | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '100'    | '84,75'      | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '09987897977889'    | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '100'    | '84,75'      | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '09987897977889'    | '0e840263-804e-4014-969b-fc359e012989' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '520'    | '440,68'     | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | ''                  | '5742dfd4-05ae-4cc4-83cd-22be8886e921' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '520'    | '440,68'     | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | ''                  | '5742dfd4-05ae-4cc4-83cd-22be8886e921' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '1'         | '520'    | '440,68'     | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'XS/Blue'  | ''                  | '5742dfd4-05ae-4cc4-83cd-22be8886e921' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '68,48'  | '58,03'      | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '11111111111111'    | '6e1ae606-a795-4a61-81b9-913bb616bb2e' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '188,32' | '159,59'     | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'M/Black'  | ''                  | 'b214841c-117e-4560-8216-50ea42a6ffdd' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '400'    | '338,98'     | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '11111111111111'    | '6e1ae606-a795-4a61-81b9-913bb616bb2e' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '400'    | '338,98'     | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '11111111111111'    | '6e1ae606-a795-4a61-81b9-913bb616bb2e' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '400'    | '338,98'     | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'UNIQ'     | '11111111111111'    | '6e1ae606-a795-4a61-81b9-913bb616bb2e' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'M/Black'  | ''                  | 'b214841c-117e-4560-8216-50ea42a6ffdd' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'M/Black'  | ''                  | 'b214841c-117e-4560-8216-50ea42a6ffdd' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'M/Black'  | ''                  | 'b214841c-117e-4560-8216-50ea42a6ffdd' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '4'         | '136,96' | '136,96'     | ''              | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'PZU'      | '0514'              | 'ecc17d2f-2741-47bb-8146-a0d224225c2a' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '4'         | '800'    | '800'        | ''              | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'PZU'      | '0514'              | 'ecc17d2f-2741-47bb-8146-a0d224225c2a' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '4'         | '800'    | '800'        | ''              | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'PZU'      | '0514'              | 'ecc17d2f-2741-47bb-8146-a0d224225c2a' | ''             |
			| ''                                            | '04.11.2022 16:33:38' | '4'         | '800'    | '800'        | ''              | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'PZU'      | '0514'              | 'ecc17d2f-2741-47bb-8146-a0d224225c2a' | ''             |		
	And I close all client application windows	

Scenario: _0401342 check Sales invoice movements by the Register  "R2021 Customer transactions" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'       | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'         | 'Partner'    | 'Agreement'                  | 'Basis'                                         | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '499,9'       | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '2 920'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '2 920'       | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '2 920'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
		And I close all client application windows
		
Scenario: _0401343 check Sales invoice movements by the Register  "R2021 Customer transactions" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'       | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''                           | ''                                              | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'         | 'Partner'    | 'Agreement'                  | 'Basis'                                         | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '499,9'       | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '2 920'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '2 920'       | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '2 920'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | 'Basic Partner terms, TRY'   | 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''        | ''        | 'No'                     | ''                              |
		And I close all client application windows	

Scenario: _0401344 check Sales invoice movements by the Register  "R2040 Taxes incoming" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''              | ''                     |
			| 'Document registrations records'                | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''              | ''                     |
			| 'Register  "R2040 Taxes incoming"'              | ''              | ''                      | ''                 | ''             | ''               | ''                          | ''      | ''              | ''                     |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'        | ''             | 'Dimensions'     | ''                          | ''      | ''              | ''                     |
			| ''                                              | ''              | ''                      | 'Taxable amount'   | 'Tax amount'   | 'Company'        | 'Branch'                    | 'Tax'   | 'Tax rate'      | 'Tax movement type'    |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '84,75'            | '15,25'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'           | ''                     |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '338,98'           | '61,02'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'           | ''                     |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '440,68'           | '79,32'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'           | ''                     |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '800'              | ''             | 'Main Company'   | 'Distribution department'   | 'VAT'   | 'Without VAT'   | ''                     |
			| ''                                              | 'Receipt'       | '04.11.2022 16:33:38'   | '932,2'            | '167,8'        | 'Main Company'   | 'Distribution department'   | 'VAT'   | '18%'           | ''                     |
		And I close all client application windows		

Scenario: _0401345 check Sales invoice movements by the Register  "R4010 Actual stocks" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
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
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '1'         | 'Store 02'   | 'UNIQ'     | ''                  |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Store 02'   | 'UNIQ'     | '11111111111111'    |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Store 02'   | 'M/Black'  | ''                  |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '4'         | 'Store 02'   | 'PZU'      | ''                  |
		And I close all client application windows	

Scenario: _0401346 check Sales invoice movements by the Register  "R4011 Free stocks" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
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
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '1'         | 'Store 02'   | 'UNIQ'     |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Store 02'   | 'UNIQ'     |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '2'         | 'Store 02'   | 'M/Black'  |
			| ''                                            | 'Expense'     | '04.11.2022 16:33:38' | '4'         | 'Store 02'   | 'PZU'      |		
		And I close all client application windows	

Scenario: _0401347 check Sales invoice movements by the Register  "R4050 Stock inventory" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38'   | ''              | ''                      | ''            | ''               | ''           | ''            |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''           | ''            |
			| 'Register  "R4050 Stock inventory"'             | ''              | ''                      | ''            | ''               | ''           | ''            |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''            |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'    |
			| ''                                              | 'Expense'       | '04.11.2022 16:33:38'   | '1'           | 'Main Company'   | 'Store 02'   | 'XS/Blue'     |
			| ''                                              | 'Expense'       | '04.11.2022 16:33:38'   | '1'           | 'Main Company'   | 'Store 02'   | 'UNIQ'        |
		And I close all client application windows	

Scenario: _0401348 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report info" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''                    | ''           | ''             | ''                        | ''      | ''         | ''                  | ''         |
			| 'Register  "R4014 Serial lot numbers"'        | ''                    | ''           | ''             | ''                        | ''      | ''         | ''                  | ''         |
			| ''                                            | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Store' | 'Item key' | 'Serial lot number' | 'Quantity' |
			| ''                                            | '04.11.2022 16:33:38' | 'Expense'    | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '09987897977889'    | '1'        |
			| ''                                            | '04.11.2022 16:33:38' | 'Expense'    | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '11111111111111'    | '2'        |
			| ''                                            | '04.11.2022 16:33:38' | 'Expense'    | 'Main Company' | 'Distribution department' | ''      | 'PZU'      | '0514'              | '4'        |
		And I close all client application windows

Scenario: _0401349 check absence Sales invoice movements by the Register  "T2015 Transactions info" (Shipment to trade agent)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '192'       |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows

Scenario: _0401350 check Sales invoice movements by the Register  "T2015 Transactions info" (consignor and own stocks)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '194'      |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 194 dated 04.11.2022 16:33:38' | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''         | ''                 | ''                         | ''                      | ''                        | ''                                            | ''          | ''          |
			| 'Document registrations records'              | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''         | ''                 | ''                         | ''                      | ''                        | ''                                            | ''          | ''          |
			| 'Register  "T2015 Transactions info"'         | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''         | ''                 | ''                         | ''                      | ''                        | ''                                            | ''          | ''          |
			| ''                                            | 'Resources' | ''       | ''        | 'Dimensions'   | ''                        | ''      | ''                    | ''                                     | ''         | ''         | ''                 | ''                         | ''                      | ''                        | ''                                            | ''          | ''          |
			| ''                                            | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'  | 'Legal name'       | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                           | 'Unique ID' | 'Project'   |
			| ''                                            | '2 920'     | 'Yes'    | 'No'      | 'Main Company' | 'Distribution department' | ''      | '04.11.2022 16:33:38' | '                                    ' | 'TRY'      | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '*'         | ''          |
		And I close all client application windows


Scenario: _0401341 check Sales invoice movements by the Register  "R2001 Sales" (serial lot numbers)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'   |
		| '1 113'      |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | ''                    | ''          | ''       | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                              | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'                | ''                    | ''          | ''       | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                              | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                       | ''                    | ''          | ''       | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                              | ''         | ''                  | ''                                     | ''             |
			| ''                                              | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''       | ''                             | ''         | ''                                              | ''         | ''                  | ''                                     | ''             |
			| ''                                              | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice'                                       | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                              | '14.12.2023 15:34:46' | '1'         | '5,71'   | '4,84'       | '0,29'          | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '1'         | '33,33'  | '28,25'      | '1,67'          | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '1'         | '33,33'  | '28,25'      | '1,67'          | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '1'         | '33,33'  | '28,25'      | '1,67'          | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '2'         | '11,41'  | '9,67'       | '0,57'          | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899877'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '2'         | '66,67'  | '56,5'       | '3,33'          | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899877'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '2'         | '66,67'  | '56,5'       | '3,33'          | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899877'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '2'         | '66,67'  | '56,5'       | '3,33'          | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899877'        | '2ecbdb37-8599-4dda-af5d-a1f321bf10d8' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '11,41'  | '9,67'       | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0512'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '17,12'  | '14,51'      | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '21f825ed-4514-4c49-8473-76e29ca1c56e' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '66,67'  | '56,5'       | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0512'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '66,67'  | '56,5'       | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0512'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '66,67'  | '56,5'       | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0512'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '100'    | '84,75'      | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '21f825ed-4514-4c49-8473-76e29ca1c56e' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '100'    | '84,75'      | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '21f825ed-4514-4c49-8473-76e29ca1c56e' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '100'    | '84,75'      | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '8908899879'        | '21f825ed-4514-4c49-8473-76e29ca1c56e' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '282,48' | '239,39'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'S/Yellow' | ''                  | 'af905e80-5db0-4fc3-b2e1-b21116b73e39' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '1 650'  | '1 398,31'   | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'S/Yellow' | ''                  | 'af905e80-5db0-4fc3-b2e1-b21116b73e39' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '1 650'  | '1 398,31'   | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'S/Yellow' | ''                  | 'af905e80-5db0-4fc3-b2e1-b21116b73e39' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '3'         | '1 650'  | '1 398,31'   | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'S/Yellow' | ''                  | 'af905e80-5db0-4fc3-b2e1-b21116b73e39' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '5'         | '103,58' | '87,78'      | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'UNIQ'     | '0512'              | '441b2862-0c2d-4b83-9829-15ba83f8dec5' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '5'         | '605'    | '512,71'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'UNIQ'     | '0512'              | '441b2862-0c2d-4b83-9829-15ba83f8dec5' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '5'         | '605'    | '512,71'     | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'UNIQ'     | '0512'              | '441b2862-0c2d-4b83-9829-15ba83f8dec5' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '5'         | '605'    | '512,71'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'UNIQ'     | '0512'              | '441b2862-0c2d-4b83-9829-15ba83f8dec5' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '6'         | '22,83'  | '19,34'      | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0514'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '6'         | '133,33' | '112,99'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0514'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '6'         | '133,33' | '112,99'     | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0514'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
			| ''                                              | '14.12.2023 15:34:46' | '6'         | '133,33' | '112,99'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 113 dated 14.12.2023 15:34:46' | 'PZU'      | '0514'              | '8b8d0dae-6d20-4471-be06-d8563cea1e7d' | ''             |
		And I close all client application windows		
				
		
Scenario: _0401429 Sales invoice clear posting/mark for deletion
		And I close all client application windows
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'    |
			| 'Document registrations records'               |
		And I close current window
	* Post Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4050 Stock inventory'          |
			| 'R2001 Sales'                    |
			| 'R2021 Customer transactions'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'    |
			| 'Document registrations records'               |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4050 Stock inventory'          |
			| 'R2001 Sales'                    |
			| 'R2021 Customer transactions'    |
		And I close all client application windows
