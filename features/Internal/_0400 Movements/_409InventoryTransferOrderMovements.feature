#language: en
@tree
@Positive
@Movements
@MovementsInventoryTransferOrder


Feature: check Inventory transfer order movements



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _04027 preparation (Inventory transfer order)
	When set True value to the constant
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
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
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document InventoryTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |


Scenario: _040322 check Inventory transfer order movements by the Register  "R4011 Free stocks"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '21' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                         | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                      | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                      | 'Expense'     | '16.02.2021 16:14:02' | '10'        | 'Store 02'   | 'XS/Blue'  |
			| ''                                                      | 'Expense'     | '16.02.2021 16:14:02' | '15'        | 'Store 02'   | '36/Red'   |
		And I close all client application windows

		
Scenario: _040332 check Inventory transfer order movements by the Register  "R4035 Incoming stocks" 
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '21' |
	* Check movements by the Register  "R4035 Incoming stocks"
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02' | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Register  "R4035 Incoming stocks"'                     | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          | ''                                             |
			| ''                                                      | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  | 'Order'                                        |
			| ''                                                      | 'Expense'     | '16.02.2021 16:14:02' | '2'         | 'Store 02'   | '36/Yellow' | 'Purchase order 115 dated 12.02.2021 12:44:43' |
			| ''                                                      | 'Expense'     | '16.02.2021 16:14:02' | '10'        | 'Store 02'   | 'S/Yellow'  | 'Purchase order 115 dated 12.02.2021 12:44:43' |
		And I close all client application windows
		


Scenario: _040342 check Inventory transfer order movements by the Register  "R4012 Stock Reservation"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '21' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02' | ''            | ''                    | ''          | ''           | ''         | ''                                                      |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''           | ''         | ''                                                      |
			| 'Register  "R4012 Stock Reservation"'                   | ''            | ''                    | ''          | ''           | ''         | ''                                                      |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                                      |
			| ''                                                      | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                                 |
			| ''                                                      | 'Receipt'     | '16.02.2021 16:14:02' | '10'        | 'Store 02'   | 'XS/Blue'  | 'Inventory transfer order 21 dated 16.02.2021 16:14:02' |
			| ''                                                      | 'Receipt'     | '16.02.2021 16:14:02' | '15'        | 'Store 02'   | '36/Red'   | 'Inventory transfer order 21 dated 16.02.2021 16:14:02' |
		And I close all client application windows



Scenario: _040352 check Inventory transfer order movements by the Register  "R4036 Incoming stock requested"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '21' |
	* Check movements by the Register  "R4036 Incoming stock requested"
		And I click "Registrations report" button
		And I select "R4036 Incoming stock requested" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02' | ''            | ''                    | ''          | ''               | ''                | ''          | ''                                             | ''                                                      |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''               | ''                | ''          | ''                                             | ''                                                      |
			| 'Register  "R4036 Incoming stock requested"'            | ''            | ''                    | ''          | ''               | ''                | ''          | ''                                             | ''                                                      |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'     | ''                | ''          | ''                                             | ''                                                      |
			| ''                                                      | ''            | ''                    | 'Quantity'  | 'Incoming store' | 'Requester store' | 'Item key'  | 'Order'                                        | 'Requester'                                             |
			| ''                                                      | 'Receipt'     | '16.02.2021 16:14:02' | '2'         | 'Store 02'       | 'Store 03'        | '36/Yellow' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Inventory transfer order 21 dated 16.02.2021 16:14:02' |
			| ''                                                      | 'Receipt'     | '16.02.2021 16:14:02' | '10'        | 'Store 02'       | 'Store 03'        | 'S/Yellow'  | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Inventory transfer order 21 dated 16.02.2021 16:14:02' |	
		And I close all client application windows

