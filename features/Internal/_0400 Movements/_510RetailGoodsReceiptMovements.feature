#language: en
@tree
@Movements3
@RetailGoodsReceiptMovements

Feature: check Retail goods receipt movements

Variables:
import "Variables.feature"


Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _050000 preparation (Retail goods receipt movements movements)
	When set True value to the constant
	* Load info
		When Create catalog BusinessUnits objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (Customer)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Partners and Payment type (Bank)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create PaymentType (advance)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog Users objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail document)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog UserGroups objects
	* Create payment terminal
		When Create catalog PaymentTerminals objects
	* Create PaymentTypes
		When Create catalog PaymentTypes objects
	* Create BankTerms
		When Create catalog BankTerms objects (for retail)	
	* Workstation
		When create Workstation
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	* Load RSO
		When create RetailSalesOrder objects
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Retail shipment confirmation
		When create RetailShipmentConfirmation objects
		And I execute 1C:Enterprise script at server
			| "Documents.RetailShipmentConfirmation.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailShipmentConfirmation.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Retail goods receipt
		When create RetailGoodsReceipt
		And I execute 1C:Enterprise script at server
			| "Documents.RetailGoodsReceipt.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create RetailGoodsReceipt objects with Retail return receipt
		And I execute 1C:Enterprise script at server
			| "Documents.RetailGoodsReceipt.FindByNumber(1204).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _051001 check preparation
	When check preparation	

Scenario: _051002 check Retail goods receipt movements by the Register  "R4010 Actual stocks"
		And I close all client application windows
	* Select Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail goods receipt 314 dated 24.05.2023 15:17:43'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                      | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                     | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                     | 'Receipt'       | '24.05.2023 15:17:43'   | '1'           | 'Store 01'     | 'XS/Blue'    | ''                     |
			| ''                                                     | 'Receipt'       | '24.05.2023 15:17:43'   | '1'           | 'Store 01'     | 'PZU'        | '8908899877'           |
			| ''                                                     | 'Receipt'       | '24.05.2023 15:17:43'   | '1'           | 'Store 01'     | 'PZU'        | '8908899879'           |

Scenario: _051003 check Retail goods receipt movements by the Register  "R4011 Free stocks"
		And I close all client application windows
	* Select Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail goods receipt 314 dated 24.05.2023 15:17:43'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                        | ''              | ''                      | ''            | ''             | ''            |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                                     | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                                     | 'Receipt'       | '24.05.2023 15:17:43'   | '1'           | 'Store 01'     | 'XS/Blue'     |
			| ''                                                     | 'Receipt'       | '24.05.2023 15:17:43'   | '2'           | 'Store 01'     | 'PZU'         |
		
				
Scenario: _051004 check Retail goods receipt movements by the Register  "R4032 Goods in transit (outgoing)"
		And I close all client application windows
	* Select Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)" 
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail goods receipt 314 dated 24.05.2023 15:17:43'   | ''              | ''                      | ''            | ''             | ''                                                             | ''            |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''             | ''                                                             | ''            |
			| 'Register  "R4032 Goods in transit (outgoing)"'        | ''              | ''                      | ''            | ''             | ''                                                             | ''            |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                                             | ''            |
			| ''                                                     | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                                        | 'Item key'    |
			| ''                                                     | 'Expense'       | '24.05.2023 15:17:43'   | '-2'          | 'Store 01'     | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | 'XS/Blue'     |
			| ''                                                     | 'Expense'       | '24.05.2023 15:17:43'   | '-2'          | 'Store 01'     | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | 'PZU'         |
		

Scenario: _051004 check Retail goods receipt movements by the Register  "TM1010B Row ID movements"
		And I close all client application windows
	* Select Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "TM1010B Row ID movements" 
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail goods receipt 314 dated 24.05.2023 15:17:43'   | ''              | ''                      | ''            | ''                                       | ''                                       | ''          | ''                                                             | ''                                        |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''                                       | ''                                       | ''          | ''                                                             | ''                                        |
			| 'Register  "TM1010B Row ID movements"'                 | ''              | ''                      | ''            | ''                                       | ''                                       | ''          | ''                                                             | ''                                        |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'                             | ''                                       | ''          | ''                                                             | ''                                        |
			| ''                                                     | ''              | ''                      | 'Quantity'    | 'Row ref'                                | 'Row ID'                                 | 'Step'      | 'Basis'                                                        | 'Basis key'                               |
			| ''                                                     | 'Expense'       | '24.05.2023 15:17:43'   | '1'           | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | 'RSR&RGR'   | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | 'fe9b7e17-0419-4895-a5e1-5779327de17f'    |
			| ''                                                     | 'Expense'       | '24.05.2023 15:17:43'   | '2'           | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | 'RSR&RGR'   | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'    |
		

Scenario: _051005 check Retail goods receipt movements by the Register  "T3010S Row ID info"
		And I close all client application windows
	* Select Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register "T3010S Row ID info" 
		And I click "Registrations report" button
		And I select "T3010S Row ID info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail goods receipt 314 dated 24.05.2023 15:17:43'   | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                                             | ''                                        |
			| 'Document registrations records'                       | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                                             | ''                                        |
			| 'Register  "T3010S Row ID info"'                       | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                                             | ''                                        |
			| ''                                                     | 'Resources'                              | ''        | ''           | ''       | 'Dimensions'                             | ''                                       | ''            | ''                                                             | ''                                        |
			| ''                                                     | 'Row ref'                                | 'Price'   | 'Currency'   | 'Unit'   | 'Key'                                    | 'Row ID'                                 | 'Unique ID'   | 'Basis'                                                        | 'Basis key'                               |
			| ''                                                     | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | ''        | ''           | 'pcs'    | '5910bdff-806b-43aa-a45a-5245ebc2e198'   | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | '*'           | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | 'fe9b7e17-0419-4895-a5e1-5779327de17f'    |
			| ''                                                     | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | ''        | ''           | 'pcs'    | '0228da79-bf4c-4579-bb75-a9cca4cb3e56'   | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | '*'           | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'    |
		
				
Scenario: _051010 check Retail goods receipt movements by the Register  "R4010 Actual stocks" (return from customer)
	And I close all client application windows
	* Select Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'      |
			| '1 204'       |
	* Check movements by the Register "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'                      | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                                     | 'Receipt'     | '03.08.2023 10:54:07' | '1'         | 'Store 01'   | 'L/Green'  | ''                  |
			| ''                                                     | 'Receipt'     | '03.08.2023 10:54:07' | '1'         | 'Store 01'   | 'UNIQ'     | ''                  |
			| ''                                                     | 'Receipt'     | '03.08.2023 10:54:07' | '2'         | 'Store 01'   | '38/Black' | ''                  |
			| ''                                                     | 'Receipt'     | '03.08.2023 10:54:07' | '2'         | 'Store 01'   | 'PZU'      | '8908899879'        |
			| ''                                                     | 'Receipt'     | '03.08.2023 10:54:07' | '2'         | 'Store 01'   | 'UNIQ'     | '09987897977891'    |
		
Scenario: _051012 check Retail goods receipt movements by the Register  "R4011 Free stocks" (return from customer)
	And I close all client application windows
	* Select Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I go to line in "List" table
			| 'Number'      |
			| '1 204'       |
	* Check movements by the Register "R4011 Free stocks" 
		And I click "Registrations report info" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail goods receipt 1 204 dated 03.08.2023 10:54:07' | ''                    | ''           | ''         | ''         | ''         |
			| 'Register  "R4011 Free stocks"'                        | ''                    | ''           | ''         | ''         | ''         |
			| ''                                                     | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Quantity' |
			| ''                                                     | '03.08.2023 10:54:07' | 'Receipt'    | 'Store 01' | 'L/Green'  | '1'        |
			| ''                                                     | '03.08.2023 10:54:07' | 'Receipt'    | 'Store 01' | '38/Black' | '2'        |
			| ''                                                     | '03.08.2023 10:54:07' | 'Receipt'    | 'Store 01' | 'PZU'      | '2'        |
			| ''                                                     | '03.08.2023 10:54:07' | 'Receipt'    | 'Store 01' | 'UNIQ'     | '2'        |
			| ''                                                     | '03.08.2023 10:54:07' | 'Receipt'    | 'Store 01' | 'UNIQ'     | '1'        |	
		And I close all client application windows