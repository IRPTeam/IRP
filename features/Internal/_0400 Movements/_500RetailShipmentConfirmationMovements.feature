#language: en
@tree
@Movements3
@RetailShipmentConfirmation

Feature: check Retail shipment confirmation movements

Variables:
import "Variables.feature"


Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _050000 preparation (Retail shipment confirmation movements)
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

	
Scenario: _050001 check preparation
	When check preparation	

Scenario: _050002 check Retail shipment confirmation movements by the Register  "R2011 Shipment of sales orders"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R2011 Shipment of sales orders" 
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31' | ''            | ''                    | ''          | ''             | ''       | ''                                          | ''         | ''                                     |
			| 'Document registrations records'                             | ''            | ''                    | ''          | ''             | ''       | ''                                          | ''         | ''                                     |
			| 'Register  "R2011 Shipment of sales orders"'                 | ''            | ''                    | ''          | ''             | ''       | ''                                          | ''         | ''                                     |
			| ''                                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                                          | ''         | ''                                     |
			| ''                                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch' | 'Order'                                     | 'Item key' | 'Row key'                              |
			| ''                                                           | 'Expense'     | '24.05.2023 14:43:31' | '2'         | 'Main Company' | ''       | 'Sales order 314 dated 09.01.2023 12:49:08' | 'XS/Blue'  | '23b88999-d27d-462f-94f4-fa7b09b4b20c' |
			| ''                                                           | 'Expense'     | '24.05.2023 14:43:31' | '2'         | 'Main Company' | ''       | 'Sales order 314 dated 09.01.2023 12:49:08' | '37/18SD'  | '5bdde23c-effa-4551-9989-3e2d76766c28' |
		
		
Scenario: _050003 check Retail shipment confirmation movements by the Register  "R4010 Actual stocks"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                               | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                              | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '1'           | 'Store 01'     | 'PZU'        | '8908899877'           |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '1'           | 'Store 01'     | 'PZU'        | '8908899879'           |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '2'           | 'Store 01'     | 'XS/Blue'    | ''                     |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '2'           | 'Store 01'     | '37/18SD'    | ''                     |
	

		
Scenario: _050004 check Retail shipment confirmation movements by the Register  "R4011 Free stocks"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'                               | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                                | ''              | ''                      | ''            | ''             | ''            |
			| ''                                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '2'           | 'Store 01'     | 'PZU'         |
		And I close all client application windows	

Scenario: _050005 check Retail shipment confirmation movements by the Register  "R4012 Stock Reservation"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R4012 Stock Reservation" 
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | ''              | ''                      | ''            | ''             | ''           | ''                                             |
			| 'Document registrations records'                               | ''              | ''                      | ''            | ''             | ''           | ''                                             |
			| 'Register  "R4012 Stock Reservation"'                          | ''              | ''                      | ''            | ''             | ''           | ''                                             |
			| ''                                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                                             |
			| ''                                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Order'                                        |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '2'           | 'Store 01'     | 'XS/Blue'    | 'Sales order 314 dated 09.01.2023 12:49:08'    |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '2'           | 'Store 01'     | '37/18SD'    | 'Sales order 314 dated 09.01.2023 12:49:08'    |
		

Scenario: _050006 check Retail shipment confirmation movements by the Register  "R4032 Goods in transit (outgoing)"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)" 
		And I click "Registrations report info" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31' | ''                    | ''           | ''         | ''                                                           | ''         | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"'              | ''                    | ''           | ''         | ''                                                           | ''         | ''         |
			| ''                                                           | 'Period'              | 'RecordType' | 'Store'    | 'Basis'                                                      | 'Item key' | 'Quantity' |
			| ''                                                           | '24.05.2023 14:43:31' | 'Expense'    | 'Store 01' | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31' | 'XS/Blue'  | '2'        |
			| ''                                                           | '24.05.2023 14:43:31' | 'Expense'    | 'Store 01' | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31' | '37/18SD'  | '2'        |
			| ''                                                           | '24.05.2023 14:43:31' | 'Expense'    | 'Store 01' | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31' | 'PZU'      | '2'        |		
		

Scenario: _050007 check Retail shipment confirmation movements by the Register  "T3010S Row ID info"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "T3010S Row ID info" 
		And I click "Registrations report" button
		And I select "T3010S Row ID info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                            | ''                                        |
			| 'Document registrations records'                               | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                            | ''                                        |
			| 'Register  "T3010S Row ID info"'                               | ''                                       | ''        | ''           | ''       | ''                                       | ''                                       | ''            | ''                                            | ''                                        |
			| ''                                                             | 'Resources'                              | ''        | ''           | ''       | 'Dimensions'                             | ''                                       | ''            | ''                                            | ''                                        |
			| ''                                                             | 'Row ref'                                | 'Price'   | 'Currency'   | 'Unit'   | 'Key'                                    | 'Row ID'                                 | 'Unique ID'   | 'Basis'                                       | 'Basis key'                               |
			| ''                                                             | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | ''        | ''           | 'pcs'    | 'fe9b7e17-0419-4895-a5e1-5779327de17f'   | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | '*'           | 'Sales order 314 dated 09.01.2023 12:49:08'   | '23b88999-d27d-462f-94f4-fa7b09b4b20c'    |
			| ''                                                             | '5bdde23c-effa-4551-9989-3e2d76766c28'   | ''        | ''           | 'pcs'    | '86947203-17b3-4616-8b9a-0ec9eec73967'   | '5bdde23c-effa-4551-9989-3e2d76766c28'   | '*'           | 'Sales order 314 dated 09.01.2023 12:49:08'   | '5bdde23c-effa-4551-9989-3e2d76766c28'    |
			| ''                                                             | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | ''        | ''           | 'pcs'    | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | '*'           | ''                                            | '                                    '    |


Scenario: _050008 check Retail shipment confirmation movements by the Register  "TM1010B Row ID movements"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "TM1010B Row ID movements" 
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | ''              | ''                      | ''            | ''                                       | ''                                       | ''          | ''                                                             | ''                                        |
			| 'Document registrations records'                               | ''              | ''                      | ''            | ''                                       | ''                                       | ''          | ''                                                             | ''                                        |
			| 'Register  "TM1010B Row ID movements"'                         | ''              | ''                      | ''            | ''                                       | ''                                       | ''          | ''                                                             | ''                                        |
			| ''                                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'                             | ''                                       | ''          | ''                                                             | ''                                        |
			| ''                                                             | ''              | ''                      | 'Quantity'    | 'Row ref'                                | 'Row ID'                                 | 'Step'      | 'Basis'                                                        | 'Basis key'                               |
			| ''                                                             | 'Receipt'       | '24.05.2023 14:43:31'   | '2'           | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | 'RSR&RGR'   | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | 'fe9b7e17-0419-4895-a5e1-5779327de17f'    |
			| ''                                                             | 'Receipt'       | '24.05.2023 14:43:31'   | '2'           | '5bdde23c-effa-4551-9989-3e2d76766c28'   | '5bdde23c-effa-4551-9989-3e2d76766c28'   | 'RSR&RGR'   | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | '86947203-17b3-4616-8b9a-0ec9eec73967'    |
			| ''                                                             | 'Receipt'       | '24.05.2023 14:43:31'   | '2'           | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'   | 'RSR&RGR'   | 'Retail shipment confirmation 314 dated 24.05.2023 14:43:31'   | '6aa911bd-d4ff-42e6-ab59-fc9936af589f'    |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '2'           | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | '23b88999-d27d-462f-94f4-fa7b09b4b20c'   | 'RSR&RSC'   | 'Sales order 314 dated 09.01.2023 12:49:08'                    | '23b88999-d27d-462f-94f4-fa7b09b4b20c'    |
			| ''                                                             | 'Expense'       | '24.05.2023 14:43:31'   | '2'           | '5bdde23c-effa-4551-9989-3e2d76766c28'   | '5bdde23c-effa-4551-9989-3e2d76766c28'   | 'RSR&RSC'   | 'Sales order 314 dated 09.01.2023 12:49:08'                    | '5bdde23c-effa-4551-9989-3e2d76766c28'    |


Scenario: _050009 check Retail shipment confirmation (without SO) movements  by the Register  "R4012 Stock Reservation"
		And I close all client application windows
	* Select Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '315'       |
	* Check movements by the Register "R4012 Stock Reservation" 
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
		And I close all client application windows
