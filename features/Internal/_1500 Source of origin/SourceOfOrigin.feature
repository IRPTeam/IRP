#language: en
@tree
@SourceOfOrigin

Feature: Source of origin

Variables:
import "Variables.feature"

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _150041 preparation
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers with source of origin)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Agreements objects (commision trade, own companies)
		When Create information register TaxSettings records (Concignor 1)
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
		When Create catalog Partners objects 
		When Create catalog Countries objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Barcodes records with source of origin
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Partners objects
		When Data preparation (comission stock)
		When Create catalog SourceOfOrigins objects
		When Create catalog PaymentTypes objects
		When Create catalog BankTerms objects (for Shop 02)
		When Create catalog TaxExemptionReasons objects
		When Create information register Taxes records (VAT)
	* Landed cost settings for company	
			Given I open hyperlink "e1cib/list/Catalog.Companies"
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I select "Company" exact value from the drop-down list named "Type"
			And I move to "Landed cost" tab
			And I click Select button of "Currency movement type" field
			And I go to line in "List" table
				| 'Currency'    | 'Deferred calculation'    | 'Description'       | 'Source'          | 'Type'      |
				| 'TRY'         | 'No'                      | 'Local currency'    | 'Forex Seling'    | 'Legal'     |
			And I select current line in "List" table
			Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
			And I click "Save and close" button
			And I wait "Main Company (Company) *" window closing in 20 seconds
			Then "Companies" window is opened
			And I go to line in "List" table
				| 'Description'        |
				| 'Second Company'     |
			And I select current line in "List" table
			And I select "Company" exact value from the drop-down list named "Type"
			And I move to "Landed cost" tab
			And I click Select button of "Currency movement type" field
			And I go to line in "List" table
				| 'Currency'    | 'Deferred calculation'    | 'Description'       | 'Source'          | 'Type'      |
				| 'TRY'         | 'No'                      | 'Local currency'    | 'Forex Seling'    | 'Legal'     |
			And I select current line in "List" table
			Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
			And I click "Save and close" button
			And I wait "Second Company (Company) *" window closing in 20 seconds
	And I close all client application windows

Scenario: _150042 check preparation
	When check preparation	

Scenario: _150043 create source of origin
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.SourceOfOrigins"
	* Create source of origin for item
		And I click "Create" button
		And I click Choice button of the field named "Owner"
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''        |
			| 'Item'    |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Product 3 with SLN'    |
		And I select current line in "List" table
		Then "Source of origin (create) *" window is opened
		And I input "Source 1" text in "Source of origin" field
		And I input "8997777777889999" text in "Custom product ID" field
		And I input "78899997667888788" text in "Custom declaration ID" field
		And I click Select button of "Country of origin" field
		Then "Countries" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Kazakhstan'     |
		And I select current line in "List" table
		And I change checkbox "Batch balance detail"
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Source of origin'   | 'Country of origin'   | 'Owner'                 |
			| 'Source 1'           | 'Kazakhstan'          | 'Product 3 with SLN'    |
		And I close all client application windows
	* Create source of origin for item type	
		Given I open hyperlink "e1cib/list/Catalog.SourceOfOrigins"
		And I click "Create" button
		And I click Choice button of the field named "Owner"
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''             |
			| 'Item type'    |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Clothes'        |
		And I select current line in "List" table
		Then "Source of origin (create) *" window is opened
		And I input "Source 2" text in "Source of origin" field
		And I input "7997777777889910" text in "Custom product ID" field
		And I input "78899997667888788" text in "Custom declaration ID" field
		And I click Select button of "Country of origin" field
		Then "Countries" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Kazakhstan'     |
		And I select current line in "List" table
		And I change checkbox "Batch balance detail"
		And I click "Save and close" button		
	* Check
		And "List" table contains lines
			| 'Source of origin'   | 'Country of origin'   | 'Owner'      |
			| 'Source 2'           | 'Kazakhstan'          | 'Clothes'    |
				
Scenario: _150045 check filling source of origin in the Opening entry
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OpeningEntry"
	And I click "Create" button	
	And I click Choice button of the field named "Company"
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	* Filling inventory
		* First item
			And in the table "Inventory" I click the button named "InventoryAdd"
			And I activate field named "InventoryItem" in "Inventory" table
			And I click choice button of the attribute named "InventoryItem" in "Inventory" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "InventoryItemKey" in "Inventory" table
			And I click choice button of the attribute named "InventoryItemKey" in "Inventory" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I select current line in "List" table
			And I activate field named "InventoryStore" in "Inventory" table
			And I click choice button of the attribute named "InventoryStore" in "Inventory" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I activate field named "InventoryQuantity" in "Inventory" table
			And I input "2,000" text in the field named "InventoryQuantity" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventoryPrice" in "Inventory" table
			And I select current line in "Inventory" table
			And I input "50,00" text in the field named "InventoryPrice" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventoryAmountTax" in "Inventory" table
			And I select current line in "Inventory" table
			And I input "20,00" text in the field named "InventoryAmountTax" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventorySerialLotNumber" in "Inventory" table
			And I select current line in "Inventory" table
			And I activate field named "InventorySourceOfOrigin" in "Inventory" table
			And I select current line in "Inventory" table
			And I click choice button of the attribute named "InventorySourceOfOrigin" in "Inventory" table
			And "List" table became equal
				| 'Source of origin'      | 'Country of origin'    | 'Custom product ID'    | 'Custom declaration ID'    | 'Owner'      | 'Inactive'    |
				| 'Source 2'              | 'Kazakhstan'           | '7997777777889910'     | '78899997667888788'        | 'Clothes'    | 'No'          |
				| 'Source of origin 5'    | 'Turkey'               | '9000991'              | '8900091'                  | 'Clothes'    | 'No'          |
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 5'     |
			And I select current line in "List" table
		* Second item
			And in the table "Inventory" I click the button named "InventoryAdd"
			And I activate field named "InventoryItem" in "Inventory" table
			And I click choice button of the attribute named "InventoryItem" in "Inventory" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "InventoryItemKey" in "Inventory" table
			And I click choice button of the attribute named "InventoryItemKey" in "Inventory" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'M/White'      |
			And I select current line in "List" table
			And I activate field named "InventoryStore" in "Inventory" table
			And I click choice button of the attribute named "InventoryStore" in "Inventory" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I activate field named "InventoryQuantity" in "Inventory" table
			And I input "2,000" text in the field named "InventoryQuantity" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventoryPrice" in "Inventory" table
			And I select current line in "Inventory" table
			And I input "50,00" text in the field named "InventoryPrice" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventoryAmountTax" in "Inventory" table
			And I select current line in "Inventory" table
			And I input "20,00" text in the field named "InventoryAmountTax" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventorySerialLotNumber" in "Inventory" table
			And I select current line in "Inventory" table
			And I activate field named "InventorySourceOfOrigin" in "Inventory" table
			And I select current line in "Inventory" table
			And I click choice button of the attribute named "InventorySourceOfOrigin" in "Inventory" table
			* Create source of origin
				And I click the button named "FormCreate"
				Then the form attribute named "Owner" became equal to "M/White"
				And I input "Source of origin 3" text in "Source of origin" field
				And I input "9089809" text in "Custom product ID" field
				And I input "78998789" text in "Custom declaration ID" field
				And I click Select button of "Country of origin" field
				And I go to line in "List" table
					| 'Description'      |
					| 'Kazakhstan'       |
				And I select current line in "List" table
				And I change checkbox "Batch balance detail"
				And I click "Save and close" button
				And I go to line in "List" table
					| 'Owner'       | 'Source of origin'        |
					| 'M/White'     | 'Source of origin 3'      |
				And I activate "Source of origin" field in "List" table
				And I select current line in "List" table
		* Third item with SLN
			And in the table "Inventory" I click the button named "InventoryAdd"
			And I activate field named "InventoryItem" in "Inventory" table
			And I click choice button of the attribute named "InventoryItem" in "Inventory" table
			And I go to line in "List" table
				| 'Description'            |
				| 'Product 3 with SLN'     |
			And I select current line in "List" table
			And I activate field named "InventoryItemKey" in "Inventory" table
			And I click choice button of the attribute named "InventoryItemKey" in "Inventory" table
			And I go to line in "List" table
				| 'Item'                  | 'Item key'     |
				| 'Product 3 with SLN'    | 'UNIQ'         |
			And I select current line in "List" table
			And I activate field named "InventoryStore" in "Inventory" table
			And I click choice button of the attribute named "InventoryStore" in "Inventory" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I activate field named "InventoryQuantity" in "Inventory" table
			And I input "2,000" text in the field named "InventoryQuantity" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventoryPrice" in "Inventory" table
			And I select current line in "Inventory" table
			And I input "50,00" text in the field named "InventoryPrice" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventoryAmountTax" in "Inventory" table
			And I select current line in "Inventory" table
			And I input "20,00" text in the field named "InventoryAmountTax" of "Inventory" table
			And I finish line editing in "Inventory" table
			And I activate field named "InventorySerialLotNumber" in "Inventory" table
			And I select current line in "Inventory" table
			And I activate field named "InventorySourceOfOrigin" in "Inventory" table
			And I select current line in "Inventory" table
			And I click choice button of the attribute named "InventorySourceOfOrigin" in "Inventory" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 4'     |
			And I select current line in "List" table
			And I click choice button of the attribute named "InventorySerialLotNumber" in "Inventory" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977893'     |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table		
		* Check filling Opening entry
			And "Inventory" table became equal
				| 'Amount'    | 'Item'                  | 'Item key'    | 'Store'       | 'Quantity'    | 'Price'    | 'Amount tax'    | 'Item serial/lot number'    | 'Source of origin'       |
				| '100,00'    | 'Dress'                 | 'XS/Blue'     | 'Store 01'    | '2,000'       | '50,00'    | '20,00'         | ''                          | 'Source of origin 5'     |
				| '100,00'    | 'Dress'                 | 'M/White'     | 'Store 01'    | '2,000'       | '50,00'    | '20,00'         | ''                          | 'Source of origin 3'     |
				| '100,00'    | 'Product 3 with SLN'    | 'UNIQ'        | 'Store 01'    | '2,000'       | '50,00'    | '20,00'         | '09987897977893'            | 'Source of origin 4'     |
		* Post
			And I click the button named "FormPost"
			And I delete "$$OpeningEntry150045$$" variable
			And I delete "$$NumberOpeningEntry150045$$" variable
			And I save the window as "$$OpeningEntry150045$$"
			And I save the value of the field named "Number" as "$$NumberOpeningEntry150045$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                           |
				| '$$NumberOpeningEntry150045$$'     |
			And I close all client application windows
		
					
Scenario: _150047 check filling source of origin in the PI	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"	
	* Select PI
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
		And I select current line in "List" table	
	* Filling in source of origin
		* For Product 4 with SLN
			And I go to line in "ItemList" table
				| 'Item'                  | 'Item key'    | 'Quantity'    | 'Serial lot numbers'     |
				| 'Product 4 with SLN'    | 'UNIQ'        | '10,000'      | '899007790088'           |
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table		
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 6'     |
			And I select current line in "List" table
			And "SourceOfOrigins" table became equal
				| 'Serial lot number'    | 'Source of origin'      | 'Quantity'     |
				| '899007790088'         | 'Source of origin 6'    | '10,000'       |
			And I click "Ok" button
		* For Dress
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'    | 'Price'     | 'Quantity'    | 'Unit'     |
				| 'Dress'    | 'XS/Blue'     | '100,00'    | '20,000'      | 'pcs'      |
			And I activate "Source of origins" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And "List" table contains lines
				| 'Source of origin'      | 'Country of origin'    | 'Custom product ID'    | 'Custom declaration ID'    | 'Owner'      | 'Inactive'    |
				| 'Source 2'              | 'Kazakhstan'           | '7997777777889910'     | '78899997667888788'        | 'Clothes'    | 'No'          |
				| 'Source of origin 5'    | 'Turkey'               | '9000991'              | '8900091'                  | 'Clothes'    | 'No'          |
			Then the number of "List" table lines is "равно" "2"
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 5'     |
			And I select current line in "List" table
			And "SourceOfOrigins" table became equal
				| 'Source of origin'      | 'Quantity'     |
				| 'Source of origin 5'    | '20,000'       |
			And I click "Ok" button		
		* For Product 3 with SLN
			And I go to line in "ItemList" table
				| 'Item'                  | 'Item key'    | 'Quantity'    | 'Serial lot numbers'     |
				| 'Product 3 with SLN'    | 'UNIQ'        | '10,000'      | '09987897977889'         |
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 4'     |
			And I select current line in "List" table
			And I click "Ok" button
			And I go to line in "ItemList" table
				| 'Item'                  | 'Item key'    | 'Quantity'    | 'Serial lot numbers'     |
				| 'Product 3 with SLN'    | 'UNIQ'        | '2,000'       | '09987897977893'         |
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 4'     |
			And I select current line in "List" table
			And I click "Ok" button
			And I go to line in "ItemList" table
				| 'Item'                  | 'Item key'    | 'Quantity'    | 'Serial lot numbers'     |
				| 'Product 3 with SLN'    | 'UNIQ'        | '2,000'       | '09987897977895'         |
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 6'     |
			And I select current line in "List" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
	* Check filling
		And "ItemList" table contains lines
			| '#'   | 'Price type'                | 'Item'                 | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'       | 'Source of origins'    | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Internal supply request'   | 'Store'      | 'Delivery date'   | 'Quantity'   | 'Other period expense type'   | 'Expense type'   | 'Purchase order'   | 'Detail'   | 'Sales order'   | 'Net amount'   | 'Use goods receipt'    |
			| '1'   | 'en description is empty'   | 'Product 1 with SLN'   | 'PZU'        | ''                     | 'No'                   | '213,56'       | 'pcs'    | '8908899877; 8908899879'   | ''                     | '70,00'    | '18%'   | ''                | '1 400,00'       | ''                      | ''                          | 'Store 01'   | ''                | '20,000'     | ''                            | ''               | ''                 | ''         | ''              | '1 186,44'     | 'No'                   |
			| '2'   | 'en description is empty'   | 'Product 4 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '106,78'       | 'pcs'    | '899007790088'             | 'Source of origin 6'   | '70,00'    | '18%'   | ''                | '700,00'         | ''                      | ''                          | 'Store 01'   | ''                | '10,000'     | ''                            | ''               | ''                 | ''         | ''              | '593,22'       | 'No'                   |
			| '3'   | 'en description is empty'   | 'Dress'                | 'XS/Blue'    | ''                     | 'No'                   | '305,08'       | 'pcs'    | ''                         | 'Source of origin 5'   | '100,00'   | '18%'   | ''                | '2 000,00'       | ''                      | ''                          | 'Store 01'   | ''                | '20,000'     | ''                            | ''               | ''                 | ''         | ''              | '1 694,92'     | 'No'                   |
			| '4'   | 'en description is empty'   | 'Boots'                | '37/18SD'    | ''                     | 'No'                   | '305,08'       | 'pcs'    | ''                         | ''                     | '100,00'   | '18%'   | ''                | '2 000,00'       | ''                      | ''                          | 'Store 01'   | ''                | '20,000'     | ''                            | ''               | ''                 | ''         | ''              | '1 694,92'     | 'No'                   |
			| '5'   | 'en description is empty'   | 'Product 3 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '152,54'       | 'pcs'    | '09987897977889'           | 'Source of origin 4'   | '100,00'   | '18%'   | ''                | '1 000,00'       | ''                      | ''                          | 'Store 01'   | ''                | '10,000'     | ''                            | ''               | ''                 | ''         | ''              | '847,46'       | 'No'                   |
			| '6'   | 'en description is empty'   | 'Product 3 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '33,56'        | 'pcs'    | '09987897977893'           | 'Source of origin 4'   | '110,00'   | '18%'   | ''                | '220,00'         | ''                      | ''                          | 'Store 01'   | ''                | '2,000'      | ''                            | ''               | ''                 | ''         | ''              | '186,44'       | 'No'                   |
			| '7'   | 'en description is empty'   | 'Product 3 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '35,08'        | 'pcs'    | '09987897977895'           | 'Source of origin 6'   | '115,00'   | '18%'   | ''                | '230,00'         | ''                      | ''                          | 'Store 01'   | ''                | '2,000'      | ''                            | ''               | ''                 | ''         | ''              | '194,92'       | 'No'                   |
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
		And I select current line in "List" table	
	* Filling source of origin from barcode
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "09987897977893" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "09987897977894" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute	
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "2202283714" text in the field named "Barcode"
		And I move to the next attribute		
		And "ItemList" table contains lines
			| '#'    | 'Price type'                | 'Item'                 | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'               | 'Source of origins'                        | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Internal supply request'   | 'Store'      | 'Delivery date'   | 'Quantity'   | 'Other period expense type'   | 'Expense type'   | 'Purchase order'   | 'Detail'   | 'Sales order'   | 'Net amount'   | 'Use goods receipt'    |
			| '1'    | 'en description is empty'   | 'Product 1 with SLN'   | 'PZU'        | ''                     | 'No'                   | '213,56'       | 'pcs'    | '8908899877; 8908899879'           | ''                                         | '70,00'    | '18%'   | ''                | '1 400,00'       | ''                      | ''                          | 'Store 01'   | ''                | '20,000'     | ''                            | ''               | ''                 | ''         | ''              | '1 186,44'     | 'No'                   |
			| '2'    | 'en description is empty'   | 'Product 4 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '106,78'       | 'pcs'    | '899007790088'                     | 'Source of origin 6'                       | '70,00'    | '18%'   | ''                | '700,00'         | ''                      | ''                          | 'Store 01'   | ''                | '10,000'     | ''                            | ''               | ''                 | ''         | ''              | '593,22'       | 'No'                   |
			| '3'    | 'en description is empty'   | 'Dress'                | 'XS/Blue'    | ''                     | 'No'                   | '305,08'       | 'pcs'    | ''                                 | 'Source of origin 5'                       | '100,00'   | '18%'   | ''                | '2 000,00'       | ''                      | ''                          | 'Store 01'   | ''                | '20,000'     | ''                            | ''               | ''                 | ''         | ''              | '1 694,92'     | 'No'                   |
			| '4'    | 'en description is empty'   | 'Boots'                | '37/18SD'    | ''                     | 'No'                   | '305,08'       | 'pcs'    | ''                                 | ''                                         | '100,00'   | '18%'   | ''                | '2 000,00'       | ''                      | ''                          | 'Store 01'   | ''                | '20,000'     | ''                            | ''               | ''                 | ''         | ''              | '1 694,92'     | 'No'                   |
			| '5'    | 'en description is empty'   | 'Product 3 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '152,54'       | 'pcs'    | '09987897977889'                   | 'Source of origin 4'                       | '100,00'   | '18%'   | ''                | '1 000,00'       | ''                      | ''                          | 'Store 01'   | ''                | '10,000'     | ''                            | ''               | ''                 | ''         | ''              | '847,46'       | 'No'                   |
			| '6'    | 'en description is empty'   | 'Product 3 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '33,56'        | 'pcs'    | '09987897977893'                   | 'Source of origin 4'                       | '110,00'   | '18%'   | ''                | '220,00'         | ''                      | ''                          | 'Store 01'   | ''                | '2,000'      | ''                            | ''               | ''                 | ''         | ''              | '186,44'       | 'No'                   |
			| '7'    | 'en description is empty'   | 'Product 3 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | '35,08'        | 'pcs'    | '09987897977895'                   | 'Source of origin 6'                       | '115,00'   | '18%'   | ''                | '230,00'         | ''                      | ''                          | 'Store 01'   | ''                | '2,000'      | ''                            | ''               | ''                 | ''         | ''              | '194,92'       | 'No'                   |
			| '8'    | 'Vendor price, TRY'         | 'Product 3 with SLN'   | 'UNIQ'       | ''                     | 'No'                   | ''             | 'pcs'    | '09987897977893; 09987897977894'   | 'Source of origin 6; Source of origin 5'   | ''         | '18%'   | ''                | ''               | ''                      | ''                          | 'Store 01'   | ''                | '2,000'      | ''                            | ''               | ''                 | ''         | ''              | ''             | 'No'                   |
			| '9'    | 'Vendor price, TRY'         | 'Dress'                | 'XS/Blue'    | ''                     | 'No'                   | ''             | 'pcs'    | ''                                 | 'Source of origin 6'                       | ''         | '18%'   | ''                | ''               | ''                      | ''                          | 'Store 01'   | ''                | '1,000'      | ''                            | ''               | ''                 | ''         | ''              | ''             | 'No'                   |
			| '10'   | 'Vendor price, TRY'         | 'Dress'                | 'M/Brown'    | ''                     | 'No'                   | ''             | 'pcs'    | ''                                 | 'Source of origin 5'                       | ''         | '18%'   | ''                | ''               | ''                      | ''                          | 'Store 01'   | ''                | '1,000'      | ''                            | ''               | ''                 | ''         | ''              | ''             | 'No'                   |
		And I close all client application windows
					
				
			
Scenario: _150049 check filling source of origin in the StockAdjustmentAsSurplus
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	* Create new
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I activate field named "ItemListItem" in "ItemList" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Filling items and source of origin
		* First item
			And I activate field named "ItemListItem" in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I activate "Source of origins" field in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 5'     |
			And I activate "Custom product ID" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I click "Ok" button
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Profit loss center" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Profit loss center" attribute in "ItemList" table
			Then "Business units" window is opened
			And I go to line in "List" table
				| 'Description'                 |
				| 'Distribution department'     |
			And I select current line in "List" table
			And I activate "Revenue type" field in "ItemList" table
			And I click choice button of "Revenue type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Revenue'         |
			And I select current line in "List" table
			And I input "50,00" text in "Total amount" field of "ItemList" table
			And I finish line editing
			And "ItemList" table became equal
				| "Revenue type" | "Item"  | "Item key" | "Profit loss center"      | "Unit" | "Tax amount" | "Source of origins"  | "Quantity" | "Price" | "VAT" | "Net amount" | "Total amount" |
				| "Revenue"      | "Dress" | "XS/Blue"  | "Distribution department" | "pcs"  | "7,63"       | "Source of origin 5" | "2,000"    | "21,19" | "18%" | "42,37"      | "50,00"        |		
			And I finish line editing in "ItemList" table
		* Second item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'Product 3 with SLN'     |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                  | 'Item key'     |
				| 'Product 3 with SLN'    | 'UNIQ'         |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977895'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Source of origins" field in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 6'     |
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I click "Ok" button
			And I activate "Profit loss center" field in "ItemList" table
			And I click choice button of "Profit loss center" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'                 |
				| 'Distribution department'     |
			And I select current line in "List" table
			And I activate "Revenue type" field in "ItemList" table
			And I click choice button of "Revenue type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Revenue'         |
			And I select current line in "List" table
			And I input "50,00" text in "Total amount" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check
			And "ItemList" table contains lines
				| 'Revenue type' | 'Total amount' | 'Item'               | 'Item key' | 'Profit loss center'      | 'Serial lot numbers' | 'Unit' | 'Source of origins'  | 'Quantity' | 'Price' | 'Tax amount' | 'Net amount' | 'VAT' |
				| 'Revenue'      | '50,00'        | 'Dress'              | 'XS/Blue'  | 'Distribution department' | ''                   | 'pcs'  | 'Source of origin 5' | '2,000'    | '21,19' | '7,63'       | '42,37'      | '18%' |
				| 'Revenue'      | '50,00'        | 'Product 3 with SLN' | 'UNIQ'     | 'Distribution department' | '09987897977895'     | 'pcs'  | 'Source of origin 6' | '2,000'    | '21,19' | '7,63'       | '42,37'      | '18%' |
		* Post
			And I click the button named "FormPost"
			And I delete "$$StockAdjustmentAsSurplus1$$" variable
			And I delete "$$NumberStockAdjustmentAsSurplus1$$" variable
			And I save the window as "$$StockAdjustmentAsSurplus1$$"
			And I save the value of the field named "Number" as "$$NumberStockAdjustmentAsSurplus1$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                                  |
				| '$$NumberStockAdjustmentAsSurplus1$$'     |
			And I go to line in "List" table
				| 'Number'                                  |
				| '$$NumberStockAdjustmentAsSurplus1$$'     |
			And I select current line in "List" table
		* Filling source of origin from barcode
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283714" text in the field named "Barcode"
			And I move to the next attribute		
			And "ItemList" table contains lines
				| 'Revenue type' | 'Total amount' | 'Item'               | 'Item key' | 'Profit loss center'      | 'Serial lot numbers' | 'Unit' | 'Source of origins'  | 'Quantity' | 'Price' | 'Tax amount' |
				| 'Revenue'      | '50,00'        | 'Dress'              | 'XS/Blue'  | 'Distribution department' | ''                   | 'pcs'  | 'Source of origin 5' | '2,000'    | '21,19' | '7,63'       |
				| 'Revenue'      | '50,00'        | 'Product 3 with SLN' | 'UNIQ'     | 'Distribution department' | '09987897977895'     | 'pcs'  | 'Source of origin 6' | '2,000'    | '21,19' | '7,63'       |
				| ''             | ''             | 'Dress'              | 'M/Brown'  | ''                        | ''                   | 'pcs'  | 'Source of origin 5' | '1,000'    | ''      | ''           |
			And I close all client application windows
						
			
Scenario: _150052 check filling source of origin in the SI
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click "Create" button
	* Filling in main info
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Add items and fill source of origin
		* Without serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate "Source of origins" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			Then "Source of origins" window is opened
			And I go to line in "List" table
				| 'Country of origin'    | 'Source of origin'       |
				| 'Turkey'               | 'Source of origin 5'     |
			And I activate "Source of origin" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I activate "Quantity" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click "Ok" button
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* With serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Product 3 with SLN'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                  | 'Item key'     |
				| 'Product 3 with SLN'    | 'UNIQ'         |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			Then "Select serial lot numbers" window is opened
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			Then "Item serial/lot numbers" window is opened
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977893'     |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			Then "Select serial lot numbers *" window is opened
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977895'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Source of origins" field in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 6'     |
			And I activate "Source of origin" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I go to line in "SourceOfOrigins" table
				| 'Quantity'    | 'Serial lot number'     |
				| '2,000'       | '09987897977895'        |
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 4'     |
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Post
			And I click the button named "FormPost"
			And I delete "$$SalesInvoice1$$" variable
			And I delete "$$NumberSalesInvoice1$$" variable
			And I save the window as "$$SalesInvoice1$$"
			And I save the value of the field named "Number" as "$$NumberSalesInvoice1$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                      |
				| '$$NumberSalesInvoice1$$'     |
			And I go to line in "List" table
				| 'Number'                      |
				| '$$NumberSalesInvoice1$$'     |
			And I select current line in "List" table
		* Filling source of origin from barcode
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "09987897977893" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "09987897977894" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283705" text in the field named "Barcode"
			And I move to the next attribute	
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283714" text in the field named "Barcode"
			// And I click the button named "OK"		
			// And "ItemList" table contains lines
			// 	| 'Price type'              | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'             | 'Source of origins'                      | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other period revenue type'   | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Work order' | 'Revenue type' | 'Sales person' |
			// 	| 'Basic Price Types'       | 'Dress'              | 'XS/Blue'  | ''                   | 'No'                 | '158,64'     | 'pcs'  | ''                               | 'Source of origin 5'                     | '2,000'    | '520,00' | '18%' | ''              | '881,36'     | '1 040,00'     | 'No'             | ''                     | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''           | ''             | ''             |
			// 	| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | '122,03'     | 'pcs'  | '09987897977893; 09987897977895' | 'Source of origin 6; Source of origin 4' | '4,000'    | '200,00' | '18%' | ''              | '677,97'     | '800,00'       | 'No'             | ''                     | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''           | ''             | ''             |
			// And I click "Show row key" button
			// And "SourceOfOrigins" table became equal
			// 	| '#' | 'Key' | 'Serial lot number' | 'Source of origin'   | 'Quantity' |
			// 	| '1' | '*'   | ''                  | 'Source of origin 5' | '2,000'    |
			// 	| '2' | '*'   | '09987897977893'    | 'Source of origin 6' | '2,000'    |
			// 	| '3' | '*'   | '09987897977895'    | 'Source of origin 4' | '2,000'    |	
			And I close all client application windows
						
Scenario: _150053 check filling source of origin in the IT
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click "Create" button
	* Filling in main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	* Add items and fill source of origin
		* Without serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'M/White'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate "Source of origins" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			Then "Source of origins" window is opened
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 3'     |
			And I activate "Source of origin" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I activate "Quantity" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click "Ok" button
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* With serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Product 3 with SLN'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                  | 'Item key'     |
				| 'Product 3 with SLN'    | 'UNIQ'         |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			Then "Select serial lot numbers" window is opened
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			Then "Item serial/lot numbers" window is opened
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977893'     |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Source of origins" field in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 4'     |
			And I activate "Source of origin" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
		* Post
			And I click the button named "FormPost"
			And I delete "$$InventoryTransfer1$$" variable
			And I delete "$$NumberInventoryTransfer1$$" variable
			And I save the window as "$$InventoryTransfer1$$"
			And I save the value of the field named "Number" as "$$NumberInventoryTransfer1$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                           |
				| '$$NumberInventoryTransfer1$$'     |
			And I go to line in "List" table
				| 'Number'                           |
				| '$$NumberInventoryTransfer1$$'     |
			And I select current line in "List" table	
			And "ItemList" table contains lines
				| 'Item'                  | 'Item key'    | 'Serial lot numbers'    | 'Unit'    | 'Source of origins'     | 'Quantity'    | 'Inventory transfer order'    | 'Production planning'     |
				| 'Dress'                 | 'M/White'     | ''                      | 'pcs'     | 'Source of origin 3'    | '2,000'       | ''                            | ''                        |
				| 'Product 3 with SLN'    | 'UNIQ'        | '09987897977893'        | 'pcs'     | 'Source of origin 4'    | '2,000'       | ''                            | ''                        |
			And I close all client application windows

Scenario: _150054 check filling source of origin in the RSR
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	And I click "Create" button
	* Filling in main info
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Add items and fill source of origin
		* Without serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate "Source of origins" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			Then "Source of origins" window is opened
			And I go to line in "List" table
				| 'Country of origin'    | 'Source of origin'       |
				| 'Turkey'               | 'Source of origin 5'     |
			And I activate "Source of origin" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I activate "Quantity" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click "Ok" button
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* With serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Product 3 with SLN'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                  | 'Item key'     |
				| 'Product 3 with SLN'    | 'UNIQ'         |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			Then "Select serial lot numbers" window is opened
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			Then "Item serial/lot numbers" window is opened
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977893'     |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			Then "Select serial lot numbers *" window is opened
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977895'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Source of origins" field in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 6'     |
			And I activate "Source of origin" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I go to line in "SourceOfOrigins" table
				| 'Quantity'    | 'Serial lot number'     |
				| '2,000'       | '09987897977895'        |
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 4'     |
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I select current line in "Payments" table
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I click choice button of "Payment type" attribute in "Payments" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Cash'            |
			And I select current line in "List" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "1 840,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table	
		* Post
			And I click the button named "FormPost"
			And I delete "$$RetailSalesReceipt1$$" variable
			And I delete "$$NumberRetailSalesReceipt1$$" variable
			And I save the window as "$$RetailSalesReceipt1$$"
			And I save the value of the field named "Number" as "$$NumberRetailSalesReceipt1$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                            |
				| '$$NumberRetailSalesReceipt1$$'     |
			And I go to line in "List" table
				| 'Number'                            |
				| '$$NumberRetailSalesReceipt1$$'     |
			And I select current line in "List" table	
			And "ItemList" table contains lines
				| 'Price type'                 | 'Item'                  | 'Item key'    | 'Profit loss center'    | 'Dont calculate row'    | 'Tax amount'    | 'Unit'    | 'Serial lot numbers'                | 'Source of origins'                         | 'Quantity'    | 'Price'     | 'VAT'    | 'Offers amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Detail'    | 'Revenue type'    | 'Sales person'     |
				| 'Basic Price Types'          | 'Dress'                 | 'XS/Blue'     | ''                      | 'No'                    | '158,64'        | 'pcs'     | ''                                  | 'Source of origin 5'                        | '2,000'       | '520,00'    | '18%'    | ''                 | '881,36'        | '1 040,00'        | 'Store 01'    | ''          | ''                | ''                 |
				| 'en description is empty'    | 'Product 3 with SLN'    | 'UNIQ'        | ''                      | 'No'                    | '122,03'        | 'pcs'     | '09987897977893; 09987897977895'    | 'Source of origin 6; Source of origin 4'    | '4,000'       | '200,00'    | '18%'    | ''                 | '677,97'        | '800,00'          | 'Store 01'    | ''          | ''                | ''                 |
			And I click "Show row key" button
			And "SourceOfOrigins" table became equal
				| '#'    | 'Key'    | 'Serial lot number'    | 'Source of origin'      | 'Quantity'     |
				| '1'    | '*'      | ''                     | 'Source of origin 5'    | '2,000'        |
				| '2'    | '*'      | '09987897977893'       | 'Source of origin 6'    | '2,000'        |
				| '3'    | '*'      | '09987897977895'       | 'Source of origin 4'    | '2,000'        |
			And I close all client application windows


Scenario: _150055 check filling source of origin in the Stock adjustment as write off
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	And I click "Create" button
	* Filling in main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Add items and fill source of origin
		* Without serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate "Source of origins" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Country of origin'    | 'Source of origin'       |
				| 'Turkey'               | 'Source of origin 5'     |
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I activate "Quantity" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click "Ok" button
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate "Profit loss center" field in "ItemList" table
			And I click choice button of "Profit loss center" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'                 |
				| 'Distribution department'     |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Expense'         |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* With serial lot number
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Product 3 with SLN'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                  | 'Item key'     |
				| 'Product 3 with SLN'    | 'UNIQ'         |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			Then "Select serial lot numbers" window is opened
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			Then "Item serial/lot numbers" window is opened
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977893'     |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			Then "Select serial lot numbers *" window is opened
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '09987897977895'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I activate "Source of origins" field in "ItemList" table
			And I click choice button of "Source of origins" attribute in "ItemList" table
			And I activate "Source of origin" field in "SourceOfOrigins" table
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 6'     |
			And I activate "Source of origin" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I go to line in "SourceOfOrigins" table
				| 'Quantity'    | 'Serial lot number'     |
				| '2,000'       | '09987897977895'        |
			And I select current line in "SourceOfOrigins" table
			And I click choice button of "Source of origin" attribute in "SourceOfOrigins" table
			And I go to line in "List" table
				| 'Source of origin'       |
				| 'Source of origin 4'     |
			And I select current line in "List" table
			And I finish line editing in "SourceOfOrigins" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And I activate "Profit loss center" field in "ItemList" table
			And I click choice button of "Profit loss center" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'                 |
				| 'Distribution department'     |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Expense'         |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Post
			And I click the button named "FormPost"
			And I delete "$$StockAdjustmentAsWriteOff1$$" variable
			And I delete "$$NumberStockAdjustmentAsWriteOff1$$" variable
			And I save the window as "$$StockAdjustmentAsWriteOff1$$"
			And I save the value of the field named "Number" as "$$NumberStockAdjustmentAsWriteOff1$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                                   |
				| '$$NumberStockAdjustmentAsWriteOff1$$'     |
			And I go to line in "List" table
				| 'Number'                                   |
				| '$$NumberStockAdjustmentAsWriteOff1$$'     |
			And I select current line in "List" table	
			And "ItemList" table contains lines
				| 'Item'                  | 'Item key'    | 'Unit'    | 'Serial lot numbers'                | 'Source of origins'                         | 'Quantity'     |
				| 'Dress'                 | 'XS/Blue'     | 'pcs'     | ''                                  | 'Source of origin 5'                        | '2,000'        |
				| 'Product 3 with SLN'    | 'UNIQ'        | 'pcs'     | '09987897977893; 09987897977895'    | 'Source of origin 6; Source of origin 4'    | '4,000'        |
			And I click "Show row key" button
			And "SourceOfOrigins" table became equal
				| '#'    | 'Key'    | 'Serial lot number'    | 'Source of origin'      | 'Quantity'     |
				| '1'    | '*'      | ''                     | 'Source of origin 5'    | '2,000'        |
				| '2'    | '*'      | '09987897977893'       | 'Source of origin 6'    | '2,000'        |
				| '3'    | '*'      | '09987897977895'       | 'Source of origin 4'    | '2,000'        |
			And I close all client application windows						

Scenario: _150056 check filling source of origin in the PR
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click "Create" button
	* Filling in main info
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Add items and fill source of origin
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'            | 'Unit'   | 'Use'    |
			| 'TRY'        | '100,00'   | '10,000'     | 'Product 3 with SLN (UNIQ)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '100,00'   | '20,000'     | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Dont calculate row'   | 'Item'                 | 'Item key'   | 'Net amount'   | 'Price'    | 'Purchase invoice'                                 | 'Quantity'   | 'Serial lot numbers'   | 'Source of origins'    | 'Store'      | 'Tax amount'   | 'Total amount'   | 'Unit'   | 'Use shipment confirmation'   | 'VAT'    |
			| '2'   | 'No'                   | 'Product 3 with SLN'   | 'UNIQ'       | '847,46'       | '100,00'   | 'Purchase invoice 202 dated 30.10.2022 12:00:00'   | '10,000'     | '09987897977889'       | 'Source of origin 4'   | 'Store 01'   | '152,54'       | '1 000,00'       | 'pcs'    | 'No'                          | '18%'    |
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button				
		* Post
			And I click the button named "FormPost"
			And I delete "$$PurchaseReturn1$$" variable
			And I delete "$$NumberPurchaseReturn1$$" variable
			And I save the window as "$$PurchaseReturn1$$"
			And I save the value of the field named "Number" as "$$NumberPurchaseReturn1$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                        |
				| '$$NumberPurchaseReturn1$$'     |
			And I go to line in "List" table
				| 'Number'                        |
				| '$$NumberPurchaseReturn1$$'     |
			And I select current line in "List" table	
			And "ItemList" table became equal
				| 'Item'                  | 'Item key'    | 'Tax amount'    | 'Unit'    | 'Serial lot numbers'    | 'Return reason'    | 'Source of origins'     | 'Price'     | 'VAT'    | 'Total amount'    | 'Store'       | 'Quantity'    | 'Use shipment confirmation'    | 'Purchase invoice'                                  | 'Net amount'     |
				| 'Dress'                 | 'XS/Blue'     | '30,51'         | 'pcs'     | ''                      | ''                 | 'Source of origin 5'    | '100,00'    | '18%'    | '200,00'          | 'Store 01'    | '2,000'       | 'No'                           | 'Purchase invoice 202 dated 30.10.2022 12:00:00'    | '169,49'         |
				| 'Product 3 with SLN'    | 'UNIQ'        | '30,51'         | 'pcs'     | '09987897977889'        | ''                 | 'Source of origin 4'    | '100,00'    | '18%'    | '200,00'          | 'Store 01'    | '2,000'       | 'No'                           | 'Purchase invoice 202 dated 30.10.2022 12:00:00'    | '169,49'         |
			And I click "Show row key" button			
			And "SourceOfOrigins" table became equal
				| '#'    | 'Key'    | 'Serial lot number'    | 'Source of origin'      | 'Quantity'     |
				| '1'    | '*'      | ''                     | 'Source of origin 5'    | '2,000'        |
				| '2'    | '*'      | '09987897977889'       | 'Source of origin 4'    | '2,000'        |
			And I close all client application windows
		

Scenario: _150057 check filling source of origin in the SR
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click "Create" button
	* Filling in main info
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Add items and fill source of origin
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'            | 'Unit'   | 'Use'    |
			| 'TRY'        | '200,00'   | '4,000'      | 'Product 3 with SLN (UNIQ)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '2,000'      | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'   | 'Quantity'    |
			| 'Product 3 with SLN'   | 'UNIQ'       | '4,000'       |
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'   | 'Quantity'    |
			| 'Product 3 with SLN'   | 'UNIQ'       | '2,000'       |
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I go to line in "SerialLotNumbers" table
			| 'Quantity'   | 'Serial lot number'    |
			| '2,000'      | '09987897977895'       |
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I go to line in "SerialLotNumbers" table
			| 'Quantity'   | 'Serial lot number'    |
			| '2,000'      | '09987897977893'       |
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate "Source of origins" field in "ItemList" table
		And I click choice button of "Source of origins" attribute in "ItemList" table
		And "SourceOfOrigins" table became equal
			| 'Serial lot number'   | 'Source of origin'     | 'Quantity'    |
			| '09987897977893'      | 'Source of origin 6'   | '1,000'       |
			| '09987897977895'      | 'Source of origin 4'   | '1,000'       |
		And I close "Edit source of origins" window
		* Post
			And I click the button named "FormPost"
			And I delete "$$SalesReturn1$$" variable
			And I delete "$$NumberSalesReturn1$$" variable
			And I save the window as "$$SalesReturn1$$"
			And I save the value of the field named "Number" as "$$NumberSalesReturn1$$"
			And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                     |
				| '$$NumberSalesReturn1$$'     |
			And I go to line in "List" table
				| 'Number'                     |
				| '$$NumberSalesReturn1$$'     |
			And I select current line in "List" table	
			And "ItemList" table became equal
				| 'Item'                  | 'Item key'    | 'Tax amount'    | 'Unit'    | 'Serial lot numbers'                | 'Source of origins'                         | 'Sales invoice'    | 'Quantity'    | 'Price'     | 'Net amount'    | 'Total amount'    | 'Store'       | 'VAT'     |
				| 'Dress'                 | 'XS/Blue'     | '158,64'        | 'pcs'     | ''                                  | 'Source of origin 5'                        | '*'                | '2,000'       | '520,00'    | '881,36'        | '1 040,00'        | 'Store 01'    | '18%'     |
				| 'Product 3 with SLN'    | 'UNIQ'        | '61,02'         | 'pcs'     | '09987897977893; 09987897977895'    | 'Source of origin 6; Source of origin 4'    | '*'                | '2,000'       | '200,00'    | '338,98'        | '400,00'          | 'Store 01'    | '18%'     |
			And I click "Show row key" button			
			And "SourceOfOrigins" table became equal
				| '#'    | 'Key'    | 'Serial lot number'    | 'Source of origin'      | 'Quantity'     |
				| '1'    | '*'      | ''                     | 'Source of origin 5'    | '2,000'        |
				| '2'    | '*'      | '09987897977893'       | 'Source of origin 6'    | '1,000'        |
				| '3'    | '*'      | '09987897977895'       | 'Source of origin 4'    | '1,000'        |
			And I close all client application windows							
								
Scenario: _150077 try to remove mark Batch balance details in the Source of origin that used in the documents
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.SourceOfOrigins"
	And I go to line in "List" table
		| 'Source of origin'   |
		| 'Source of origin 5' |
	And I select current line in "List" table
	And I remove checkbox "Batch balance detail"
	And I click "Save and close" button
	Then I wait that in user messages the "[Batch balance detail] cannot be changed, has posted documents" substring will appear in 10 seconds
	And I close all client application windows	

Scenario: _150078 check filling source of origin from sln
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click "Create" button
	* Filling in main info
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Scan sln and check source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select "Product 1 with SLN" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "PZU" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate "Serial lot numbers" field in "ItemList" table
		And I click choice button of "Serial lot numbers" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I select "8908899880" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check
		And "ItemList" table contains lines
			| 'Item'               | 'Item key' | 'Unit' | 'Serial lot numbers' | 'Source of origins'  | 'Quantity' |
			| 'Product 1 with SLN' | 'PZU'      | 'pcs'  | '8908899880'         | 'Source of origin 6' | '1,000'    |
	And I close all client application windows

Scenario: _150079 check filling source of origin in SC
	And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click "Create" button
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select "Sales" exact value from the drop-down list named "TransactionType"
		And I select from the drop-down list named "Partner" by "Lomaniti" string
		And I select from the drop-down list named "Store" by "Store 05" string
	* Add Item no Source of origin		
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Skittles" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I input "10 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add Item and Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Bag" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "ODS" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I input "5 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select current line in "SourceOfOrigins" table
		And I select "Source of origin 11" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Add Item with SLN + Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 1 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "PZU" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number" |
			| "17"   | "PZU"   | "8908899879"    |
		And I click the button named "FormChoose"
		And I activate field named "SerialLotNumbersQuantity" in "SerialLotNumbers" table
		And I input "100,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select "Source of origin 9" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Add Item with 2 SLN + 2 Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 3 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "Uniq" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number"  |
			| "23"   | "UNIQ"  | "09987897977895" |
		And I click the button named "FormChoose"
		And I input "200,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number"  |
			| "21"   | "UNIQ"  | "09987897977893" |
		And I click the button named "FormChoose"
		And I input "200,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I activate field named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I click choice button of the attribute named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I close "Source of origins" window
		And I select "Source of origin 4" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I go to line in "SourceOfOrigins" table
			| "Quantity" | "Serial lot number" |
			| "200,000"  | "09987897977893"    |
		And I select "Source 1" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Post
		And I click the button named "FormPost"
		And I delete "$$ShipmentConfirmation01$$" variable
		And I delete "$$NumberShipmentConfirmation01$$" variable
		And I save the window as "$$ShipmentConfirmation01$$"
		And I save the value of the field named "Number" as "$$NumberShipmentConfirmation01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberShipmentConfirmation01$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'             | 'Source of origins'            | 'Quantity'   | 'Unit' | 'Store'    | 'Shipment basis' | 'Sales order' | 'Shipment planing order' | 'Sales invoice' | 'Inventory transfer order' | 'Inventory transfer' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Skittles'           | 'Fruit'    | ''                               | ''                             | '10 000,000' | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '2' | 'Bag'                | 'ODS'      | ''                               | 'Source of origin 11'          | '5 000,000'  | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '3' | 'Product 1 with SLN' | 'PZU'      | '8908899879'                     | 'Source of origin 9'           | '100,000'    | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '4' | 'Product 3 with SLN' | 'UNIQ'     | '09987897977895; 09987897977893' | 'Source of origin 4; Source 1' | '400,000'    | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
	And I close all client application windows	
				
Scenario: _150080 check filling source of origin in GR
	And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click "Create" button
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select "Purchase" exact value from the drop-down list named "TransactionType"
		And I select from the drop-down list named "Partner" by "Veritas" string
		And I select from the drop-down list named "Store" by "Store 05" string
	* Add Item no Source of origin		
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Skittles" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I input "10 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add Item and Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Bag" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "ODS" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I input "5 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select current line in "SourceOfOrigins" table
		And I select "Source of origin 11" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Add Item with SLN + Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 1 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "PZU" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number" |
			| "17"   | "PZU"   | "8908899879"    |
		And I click the button named "FormChoose"
		And I activate field named "SerialLotNumbersQuantity" in "SerialLotNumbers" table
		And I input "100,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select "Source of origin 9" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Add Item with 2 SLN + 2 Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 3 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "Uniq" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number"  |
			| "23"   | "UNIQ"  | "09987897977895" |
		And I click the button named "FormChoose"
		And I input "200,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number"  |
			| "21"   | "UNIQ"  | "09987897977893" |
		And I click the button named "FormChoose"
		And I input "200,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I activate field named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I click choice button of the attribute named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I close "Source of origins" window
		And I select "Source of origin 4" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I go to line in "SourceOfOrigins" table
			| "Quantity" | "Serial lot number" |
			| "200,000"  | "09987897977893"    |
		And I select "Source 1" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Post
		And I click the button named "FormPost"
		And I delete "$$GoodsReceipt01$$" variable
		And I delete "$$NumberGoodsReceipt01$$" variable
		And I save the window as "$$GoodsReceipt01$$"
		And I save the value of the field named "Number" as "$$NumberGoodsReceipt01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'                   |
			| '$$NumberGoodsReceipt01$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'             | 'Source of origins'            | 'Store'    | 'Quantity'   | 'Unit' | 'Receipt basis' | 'Currency' | 'Purchase order' | 'Purchase invoice' | 'Sales order' | 'Sales invoice' | 'Inventory transfer order' | 'Inventory transfer' | 'Internal supply request' | 'Sales return' | 'Sales return order' | 'Production planning' |
			| '1' | 'Skittles'           | 'Fruit'    | ''                               | ''                             | 'Store 05' | '10 000,000' | 'pcs'  | ''              | ''         | ''               | ''                 | ''            | ''              | ''                         | ''                   | ''                        | ''             | ''                   | ''                    |
			| '2' | 'Bag'                | 'ODS'      | ''                               | 'Source of origin 11'          | 'Store 05' | '5 000,000'  | 'pcs'  | ''              | ''         | ''               | ''                 | ''            | ''              | ''                         | ''                   | ''                        | ''             | ''                   | ''                    |
			| '3' | 'Product 1 with SLN' | 'PZU'      | '8908899879'                     | 'Source of origin 9'           | 'Store 05' | '100,000'    | 'pcs'  | ''              | ''         | ''               | ''                 | ''            | ''              | ''                         | ''                   | ''                        | ''             | ''                   | ''                    |
			| '4' | 'Product 3 with SLN' | 'UNIQ'     | '09987897977895; 09987897977893' | 'Source of origin 4; Source 1' | 'Store 05' | '400,000'    | 'pcs'  | ''              | ''         | ''               | ''                 | ''            | ''              | ''                         | ''                   | ''                        | ''             | ''                   | ''                    |


Scenario: _150081 check filling source of origin in SPO
	And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.ShipmentPlaningOrder"
		And I click "Create" button
	* Filling main info
		And I select from the drop-down list named "Partner" by "Lomaniti" string
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Store" by "Store 05" string
		And I click Choice button of the field named "ShipmentPeriod"
		And I click the hyperlink named "SwitchText"
		And I click the button named "MonthPeriod"
		And I click the button named "Select"
	* Add Item and Source of origin
	* Add Item no Source of origin		
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Skittles" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I input "10 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add Item and Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Bag" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "ODS" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I input "5 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select current line in "SourceOfOrigins" table
		And I select "Source of origin 11" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Add Item with SLN + Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 1 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "PZU" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number" |
			| "17"   | "PZU"   | "8908899879"    |
		And I click the button named "FormChoose"
		And I activate field named "SerialLotNumbersQuantity" in "SerialLotNumbers" table
		And I input "100,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select "Source of origin 9" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Add Item with 2 SLN + 2 Source of origin
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 3 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "Uniq" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number"  |
			| "23"   | "UNIQ"  | "09987897977895" |
		And I click the button named "FormChoose"
		And I input "200,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| "Code" | "Owner" | "Serial number"  |
			| "21"   | "UNIQ"  | "09987897977893" |
		And I click the button named "FormChoose"
		And I input "200,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I activate field named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I click choice button of the attribute named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I close "Source of origins" window
		And I select "Source of origin 4" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I go to line in "SourceOfOrigins" table
			| "Quantity" | "Serial lot number" |
			| "200,000"  | "09987897977893"    |
		And I select "Source 1" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
	* Post
		And I click the button named "FormPost"
		And I delete "$$ShipmentPlaningOrder01$$" variable
		And I delete "$$NumberShipmentPlaningOrder01$$" variable
		And I save the window as "$$ShipmentPlaningOrder01$$"
		And I save the value of the field named "Number" as "$$NumberShipmentPlaningOrder01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ShipmentPlaningOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberShipmentPlaningOrder01$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'             | 'Source of origins'            | 'Quantity'   | 'Unit' | 'Store'    | 'Shipment basis' | 'Sales order' |
			| '1' | 'Skittles'           | 'Fruit'    | ''                               | ''                             | '10 000,000' | 'pcs'  | 'Store 05' | ''               | ''            |
			| '2' | 'Bag'                | 'ODS'      | ''                               | 'Source of origin 11'          | '5 000,000'  | 'pcs'  | 'Store 05' | ''               | ''            |
			| '3' | 'Product 1 with SLN' | 'PZU'      | '8908899879'                     | 'Source of origin 9'           | '100,000'    | 'pcs'  | 'Store 05' | ''               | ''            |
			| '4' | 'Product 3 with SLN' | 'UNIQ'     | '09987897977895; 09987897977893' | 'Source of origin 4; Source 1' | '400,000'    | 'pcs'  | 'Store 05' | ''               | ''            |
	And I close all client application windows			

Scenario: _150082 check Stock balance details, Batch balance details ticks in Source of origin (Item)
	And I close all client application windows
	* Create Source of origin
		Given I open hyperlink "e1cib/list/Catalog.SourceOfOrigins"
		And I click "Create" button
		And I click Choice button of the field named "Owner"
		And I go to line in "" table
			| ""     |
			| "Item" |
		And I click "OK" button
		And I go to line in "List" table
			| "Code" | "Description" |
			| "11"   | "Bag"         |
		And I click the button named "FormChoose"
		And I input "Source of origin 15" text in the field named "Description"
		And I click Choice button of the field named "CountryOfOrigin"
		And I go to line in "List" table
			| "Code" | "Description" |
			| "1"    | "Turkey"      |
		And I click the button named "FormChoose"
		And I change checkbox named "StockBalanceDetail"
		And I change checkbox named "BatchBalanceDetail"
		And I click the button named "FormWrite"
		And I delete "$$CodeSourceOfOrigins01$$" variable
		And I save the value of "Code" field as "$$CodeSourceOfOrigins01$$"
		And I click the button named "FormWriteAndClose"
	* Check
		And I go to line in "List" table
			| 'Code'                      |
			| '$$CodeSourceOfOrigins01$$' |
		And I select current line in "List" table
		And checkbox "Stock balance detail" is equal to "Yes"
		And checkbox "Batch balance detail" is equal to "Yes"
	And I close all client application windows		

Scenario: _150082 check Stock balance details, Batch balance details ticks in Source of origin (ItemKey)
	And I close all client application windows
	* Create Source of origin
		Given I open hyperlink "e1cib/list/Catalog.SourceOfOrigins"
		And I click "Create" button
		And I click Choice button of the field named "Owner"
		And I go to line in "" table
			| ""         |
			| "Item key" |
		And I click "OK" button
		Then "Item keys" window is opened
		And I go to line in "List" table
			| "Code" | "Item" | "Item key" |
			| "27"   | "Bag"  | "ODS"      |
		And I activate field named "ItemKey" in "List" table
		And I click the button named "FormChoose"
		And I input "Source of origin 15/1" text in the field named "Description"
		And I click Choice button of the field named "CountryOfOrigin"
		And I go to line in "List" table
			| "Code" | "Description" |
			| "1"    | "Turkey"      |
		And I click the button named "FormChoose"
		And I change checkbox named "StockBalanceDetail"
		And I change checkbox named "BatchBalanceDetail"
		And I click the button named "FormWrite"
		And I delete "$$CodeSourceOfOrigins02$$" variable
		And I save the value of "Code" field as "$$CodeSourceOfOrigins02$$"
		And I click the button named "FormWriteAndClose"
	* Check
		And I go to line in "List" table
			| 'Code'                      |
			| '$$CodeSourceOfOrigins02$$' |
		And I select current line in "List" table
		And checkbox "Stock balance detail" is equal to "Yes"
		And checkbox "Batch balance detail" is equal to "Yes"
	And I close all client application windows

Scenario: _150083 check Stock balance details, Batch balance details ticks in Source of origin (ItemType)
	And I close all client application windows
	* Create Source of origin
		Given I open hyperlink "e1cib/list/Catalog.SourceOfOrigins"
		And I click "Create" button
		And I click Choice button of the field named "Owner"
		And I go to line in "" table
			| ""          |
			| "Item type" |
		And I click "OK" button
		Then "Item types" window is opened
		And I go to line in "List" table
			| "Code" | "Description" |
			| "10"   | "Bags"        |
		And I activate field named "Description" in "List" table
		And I click the button named "FormChoose"
		And I input "Source of origin BAGS" text in the field named "Description"
		And I click Choice button of the field named "CountryOfOrigin"
		And I go to line in "List" table
			| "Code" | "Description" |
			| "1"    | "Turkey"      |
		And I click the button named "FormChoose"
		And I change checkbox named "StockBalanceDetail"
		And I change checkbox named "BatchBalanceDetail"
		And I click the button named "FormWrite"
		And I delete "$$CodeSourceOfOrigins03$$" variable
		And I save the value of "Code" field as "$$CodeSourceOfOrigins03$$"
		And I click the button named "FormWriteAndClose"
	* Check
		And I go to line in "List" table
			| 'Code'                      |
			| '$$CodeSourceOfOrigins03$$' |
		And I select current line in "List" table
		And checkbox "Stock balance detail" is equal to "Yes"
		And checkbox "Batch balance detail" is equal to "Yes"
	And I close all client application windows

Scenario: _150084 check filling source of origin in SI created from SC
	And I close all client application windows
	* Open SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberShipmentConfirmation01$$' |
		And I select current line in "List" table
	* Create SI
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click the button named "FormOk"
		And I select from the drop-down list named "Agreement" by "TRY" string
		Then "Update item list info" window is opened
		And I change checkbox named "PriceTypes"
		And I change checkbox named "Stores"
		And I click the button named "FormOK"
	* Check
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'             | 'Source of origins'            | 'Quantity'   | 'Price type' | 'Unit' | 'Price' | 'VAT' | 'Offers amount' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Use shipment confirmation' | 'Store'    | 'Project' | 'Delivery date' | 'Sales order' | 'Work order' | 'Profit loss center' | 'Revenue type' | 'Detail' | 'Additional analytic' | 'Other period revenue type' | 'Sales person' | 'Tax exemption reason' |
			| '1' | 'Skittles'           | 'Fruit'    | ''                               | ''                             | '10 000,000' | ''           | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'No'             | 'Yes'                       | 'Store 05' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                     |
			| '2' | 'Bag'                | 'ODS'      | ''                               | 'Source of origin 11'          | '5 000,000'  | ''           | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'No'             | 'Yes'                       | 'Store 05' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                     |
			| '3' | 'Product 1 with SLN' | 'PZU'      | '8908899879'                     | 'Source of origin 9'           | '100,000'    | ''           | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'No'             | 'Yes'                       | 'Store 05' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                     |
			| '4' | 'Product 3 with SLN' | 'UNIQ'     | '09987897977893; 09987897977895' | 'Source of origin 4; Source 1' | '400,000'    | ''           | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'No'             | 'Yes'                       | 'Store 05' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                     |
		And I click the button named "FormPost"
		And I delete "$$SalesInvoice01$$" variable
		And I delete "$$NumberSalesInvoice01$$" variable
		And I save the window as "$$SalesInvoice01$$"
		And I save the value of the field named "Number" as "$$NumberSalesInvoice01$$"
		And I click the button named "FormPostAndClose"	
	And I close all client application windows			

Scenario: _150085 check filling source of origin in SC created from SPO	
	And I close all client application windows
	* Open SPO
		Given I open hyperlink "e1cib/list/Document.ShipmentPlaningOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberShipmentPlaningOrder01$$' |
		And I select current line in "List" table
	* Create SC
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click the button named "FormOk"
	* Check
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'             | 'Source of origins'            | 'Quantity'   | 'Unit' | 'Store'    | 'Shipment basis'             | 'Sales order' | 'Shipment planing order'     | 'Sales invoice' | 'Inventory transfer order' | 'Inventory transfer' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Skittles'           | 'Fruit'    | ''                               | ''                             | '10 000,000' | 'pcs'  | 'Store 05' | '$$ShipmentPlaningOrder01$$' | ''            | '$$ShipmentPlaningOrder01$$' | ''              | ''                         | ''                   | ''                      | ''                |
			| '2' | 'Bag'                | 'ODS'      | ''                               | 'Source of origin 11'          | '5 000,000'  | 'pcs'  | 'Store 05' | '$$ShipmentPlaningOrder01$$' | ''            | '$$ShipmentPlaningOrder01$$' | ''              | ''                         | ''                   | ''                      | ''                |
			| '3' | 'Product 1 with SLN' | 'PZU'      | '8908899879'                     | 'Source of origin 9'           | '100,000'    | 'pcs'  | 'Store 05' | '$$ShipmentPlaningOrder01$$' | ''            | '$$ShipmentPlaningOrder01$$' | ''              | ''                         | ''                   | ''                      | ''                |
			| '4' | 'Product 3 with SLN' | 'UNIQ'     | '09987897977893; 09987897977895' | 'Source of origin 4; Source 1' | '400,000'    | 'pcs'  | 'Store 05' | '$$ShipmentPlaningOrder01$$' | ''            | '$$ShipmentPlaningOrder01$$' | ''              | ''                         | ''                   | ''                      | ''                |
		And I click the button named "FormPost"
		And I delete "$$ShipmentConfirmation02$$" variable
		And I delete "$$NumberShipmentConfirmation02$$" variable
		And I save the window as "$$ShipmentConfirmation02$$"
		And I save the value of the field named "Number" as "$$NumberShipmentConfirmation02$$"
		And I click the button named "FormPostAndClose"	
	And I close all client application windows		

Scenario: _150086 check filling source of origin in PI created from GR
	And I close all client application windows
	* Open GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'                   |
			| '$$NumberGoodsReceipt01$$' |
		And I select current line in "List" table
	* Create PI
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click the button named "FormOk"
	* Check
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term (Veritas)"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "LegalName" became equal to "Company Veritas "
		Then the form attribute named "Partner" became equal to "Veritas"
		Then the form attribute named "Store" became equal to "Store 05"
		Then the form attribute named "TransactionType" became equal to "Purchase"
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'             | 'Source of origins'            | 'Quantity'   | 'Price type'        | 'Unit' | 'Price' | 'VAT' | 'Offers amount' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Project' | 'Delivery date' | 'Expense type' | 'Profit loss center' | 'Purchase order' | 'Sales order' | 'Internal supply request' | 'Use goods receipt' | 'Detail' | 'Additional analytic' | 'Other period expense type' |
			| '1' | 'Skittles'           | 'Fruit'    | ''                               | ''                             | '10 000,000' | 'Vendor price, TRY' | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'Store 05' | ''        | ''              | ''             | ''                   | ''               | ''            | ''                        | 'Yes'               | ''       | ''                    | ''                          |
			| '2' | 'Bag'                | 'ODS'      | ''                               | 'Source of origin 11'          | '5 000,000'  | 'Vendor price, TRY' | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'Store 05' | ''        | ''              | ''             | ''                   | ''               | ''            | ''                        | 'Yes'               | ''       | ''                    | ''                          |
			| '3' | 'Product 1 with SLN' | 'PZU'      | '8908899879'                     | 'Source of origin 9'           | '100,000'    | 'Vendor price, TRY' | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'Store 05' | ''        | ''              | ''             | ''                   | ''               | ''            | ''                        | 'Yes'               | ''       | ''                    | ''                          |
			| '4' | 'Product 3 with SLN' | 'UNIQ'     | '09987897977893; 09987897977895' | 'Source of origin 4; Source 1' | '400,000'    | 'Vendor price, TRY' | 'pcs'  | ''      | '18%' | ''              | 'No'                 | ''           | ''           | ''             | 'Store 05' | ''        | ''              | ''             | ''                   | ''               | ''            | ''                        | 'Yes'               | ''       | ''                    | ''                          |
		And I click the button named "FormPost"
		And I delete "$$PurchaseInvoice01$$" variable
		And I delete "$$NumberPurchaseInvoice01$$" variable
		And I save the window as "$$PurchaseInvoice01$$"
		And I save the value of the field named "Number" as "$$NumberPurchaseInvoice01$$"
		And I click the button named "FormPostAndClose"	
	And I close all client application windows		

Scenario: _150087 check row separation in SI
	And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Partner" by "Lomaniti" string
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Store" by "Store 05" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
	* Add Item with SLN
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 5 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I select "90808979898" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I input "110,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I select "90808979899" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I input "120,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select "source of origin 6" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I go to line in "SourceOfOrigins" table
			| "Quantity" | "Serial lot number" |
			| "120,000"  | "90808979899"       |
		And I input "source of origin 6" text in the field named "SourceOfOriginsSourceOfOrigin" of "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
		And I input "5,01" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Skittles" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I input "10 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "0,53" text in the field named "ItemListPrice" of "ItemList" table
		And I select "0%" exact value from the drop-down list named "ItemListVatRate" in "ItemList" table
		And I select "Tax exeption reason 1 (0%, All countries)" by string from the drop-down list named "ItemListTaxExemptionReason" in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'       | 'Source of origins'                      | 'Quantity'   | 'Price' | 'Tax exemption reason'                      | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Additional analytic' | 'Project' | 'Store'    | 'Delivery date' | 'Other period revenue type' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Work order' | 'Revenue type' | 'Sales person' |
			| '1' | 'en description is empty' | 'Product 5 with SLN' | 'ODS'      | ''                   | 'No'                 | '175,77'     | 'pcs'  | '90808979898; 90808979899' | 'Source of origin 6; Source of origin 6' | '230,000'    | '5,01'  | ''                                          | '18%' | ''              | '976,53'     | '1 152,30'     | 'No'             | ''                    | ''        | 'Store 01' | ''              | ''                          | 'No'                        | ''       | ''            | ''           | ''             | ''             |
			| '2' | 'en description is empty' | 'Skittles'           | 'Fruit'    | ''                   | 'No'                 | ''           | 'pcs'  | ''                         | ''                                       | '10 000,000' | '0,53'  | 'Tax exeption reason 1 (0%, All countries)' | '0%'  | ''              | '5 300,00'   | '5 300,00'     | 'No'             | ''                    | ''        | 'Store 01' | ''              | ''                          | 'No'                        | ''       | ''            | ''           | ''             | ''             |
		
		Then the form attribute named "ItemListTotalNetAmount" became equal to "6 276,53"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "175,77"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "6 452,30"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		Then the form attribute named "LegalName" became equal to "Company Lomaniti"
		Then the form attribute named "ManagerSegment" became equal to "Region 2"
		Then the form attribute named "Partner" became equal to "Lomaniti"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "TransactionType" became equal to "Sales"
	* Split first Item
		And I go to line in "ItemList" table
			| "#" | "Dont calculate row" | "Item"               | "Item key" | "Net amount" | "Price" | "Price type"              | "Quantity" | "Serial lot numbers"       | "Source of origins"                      | "Store"    | "Tax amount" | "Total amount" | "Unit" | "Use shipment confirmation" | "Use work sheet" | "VAT" |
			| "1" | "No"                 | "Product 5 with SLN" | "ODS"      | "976,53"     | "5,01"  | "en description is empty" | "230,000"  | "90808979898; 90808979899" | "Source of origin 6; Source of origin 6" | "Store 01" | "175,77"     | "1 152,30"     | "pcs"  | "No"                        | "No"             | "18%" |
		And in the table "ItemList" I click the button named "ItemListSplitRow"
		Then "Set the quantity for the new row" window is opened
		And I input "130" text in the field named "InputFld"
		And I click the button named "OK"
	* Check separation
// needs to update
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'       | 'Source of origins'                      | 'Quantity'   | 'Price type'              | 'Unit' | 'Price' | 'VAT' | 'Offers amount' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Use shipment confirmation' | 'Store'    | 'Project' | 'Delivery date' | 'Sales order' | 'Work order' | 'Profit loss center' | 'Revenue type' | 'Detail' | 'Additional analytic' | 'Other period revenue type' | 'Sales person' | 'Tax exemption reason'                      |
			| '1' | 'Product 5 with SLN' | 'ODS'      | '90808979898'              | 'Source of origin 6'                     | '100,000'    | 'en description is empty' | 'pcs'  | '5,01'  | '18%' | ''              | 'No'                 | '76,42'      | '424,58'     | '501,00'       | 'No'             | 'No'                        | 'Store 01' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                                          |
			| '2' | 'Skittles'           | 'Fruit'    | ''                         | ''                                       | '10 000,000' | 'en description is empty' | 'pcs'  | '0,53'  | '0%'  | ''              | 'No'                 | ''           | '5 300,00'   | '5 300,00'     | 'No'             | 'No'                        | 'Store 01' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | 'Tax exeption reason 1 (0%, All countries)' |
			| '3' | 'Product 5 with SLN' | 'ODS'      | '90808979899; 90808979898' | 'Source of origin 6; Source of origin 6' | '130,000'    | 'en description is empty' | 'pcs'  | '5,01'  | '18%' | ''              | 'No'                 | '99,35'      | '551,95'     | '651,30'       | 'No'             | 'No'                        | 'Store 01' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                                          |
		And form attributes have values:
			| 'Name'                     | 'Value'                    |
			| 'Agreement'                | "Basic Partner terms, TRY" |
			| 'Company'                  | "Main Company"             |
			| 'Currency'                 | "TRY"                      |
			| 'CurrencyTotalAmount'      | "TRY"                      |
			| 'ItemListTotalNetAmount'   | "6 276,53"                 |
			| 'ItemListTotalTaxAmount'   | "175,77"                   |
			| 'ItemListTotalTotalAmount' | "6 452,30"                 |
			| 'Legal name'                | "Company Lomaniti"         |
			| 'ManagerSegment'           | "Region 2"                 |
			| 'Partner'                  | "Lomaniti"                 |
			| 'PriceIncludeTax'          | "Yes"                      |
			| 'Store'                    | "Store 01"                 |
			| 'TransactionType'          | "Sales"                    |
		And I go to line in "ItemList" table
			| "#" | "Dont calculate row" | "Item"               | "Item key" | "Net amount" | "Price" | "Price type"              | "Quantity" | "Serial lot numbers"       | "Store"    | "Tax amount" | "Total amount" | "Unit" | "Use shipment confirmation" | "Use work sheet" | "VAT" |
			| "3" | "No"                 | "Product 5 with SLN" | "ODS"      | "551,95"     | "5,01"  | "en description is empty" | "130,000"  | "90808979899; 90808979898" | "Store 01" | "99,35"      | "651,30"       | "pcs"  | "No"                        | "No"             | "18%" |
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		Then "Edit source of origins" window is opened
		And I activate field named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
// needs to update
		And "SourceOfOrigins" table became equal
			| 'Serial lot number' | 'Source of origin'   | 'Quantity' |
			| '90808979899'       | 'Source of origin 6' | '120,000'  |
			| '90808979898'       | 'Source of origin 6' | '10,000'   |
		And I close current window	
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And "SerialLotNumbers" table became equal
			| 'Serial lot number' | 'Quantity' | 'Code is approved' |
			| '90808979899'       | '120,000'  | 'No'               |
			| '90808979898'       | '10,000'   | 'No'               |
		And I close current window	
		And I go to line in "ItemList" table
			| "#" | "Dont calculate row" | "Item"               | "Item key" | "Net amount" | "Price" | "Price type"              | "Quantity" | "Serial lot numbers" | "Source of origins"  | "Store"    | "Tax amount" | "Total amount" | "Unit" | "Use shipment confirmation" | "Use work sheet" | "VAT" |
			| "1" | "No"                 | "Product 5 with SLN" | "ODS"      | "424,58"     | "5,01"  | "en description is empty" | "100,000"  | "90808979898"        | "Source of origin 6" | "Store 01" | "76,42"      | "501,00"       | "pcs"  | "No"                        | "No"             | "18%" |
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And "SourceOfOrigins" table became equal
			| 'Serial lot number' | 'Source of origin'   | 'Quantity' |
			| '90808979898'       | 'Source of origin 6' | '100,000'  |
		And I close current window
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And "SerialLotNumbers" table became equal
			| 'Serial lot number' | 'Quantity' | 'Code is approved' |
			| '90808979898'       | '100,000'  | 'No'               |
		And I close current window		
	* Split second Item
		And I go to line in "ItemList" table
			| "#" | "Dont calculate row" | "Item"     | "Item key" | "Net amount" | "Price" | "Price type"              | "Quantity"   | "Store"    | "Tax exemption reason"                      | "Total amount" | "Unit" | "Use shipment confirmation" | "Use work sheet" | "VAT" |
			| "2" | "No"                 | "Skittles" | "Fruit"    | "5 300,00"   | "0,53"  | "en description is empty" | "10 000,000" | "Store 01" | "Tax exeption reason 1 (0%, All countries)" | "5 300,00"     | "pcs"  | "No"                        | "No"             | "0%"  |
		And in the table "ItemList" I click the button named "ItemListSplitRow"
		Then "Set the quantity for the new row" window is opened
		And I input "5 000" text in the field named "InputFld"
		And I click the button named "OK"
	* Check separation
// needs to update
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'       | 'Source of origins'                      | 'Quantity'  | 'Price type'              | 'Unit' | 'Price' | 'VAT' | 'Offers amount' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Use shipment confirmation' | 'Store'    | 'Project' | 'Delivery date' | 'Sales order' | 'Work order' | 'Profit loss center' | 'Revenue type' | 'Detail' | 'Additional analytic' | 'Other period revenue type' | 'Sales person' | 'Tax exemption reason'                      |
			| '1' | 'Product 5 with SLN' | 'ODS'      | '90808979898'              | 'Source of origin 6'                     | '100,000'   | 'en description is empty' | 'pcs'  | '5,01'  | '18%' | ''              | 'No'                 | '76,42'      | '424,58'     | '501,00'       | 'No'             | 'No'                        | 'Store 01' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                                          |
			| '2' | 'Skittles'           | 'Fruit'    | ''                         | ''                                       | '5 000,000' | 'en description is empty' | 'pcs'  | '0,53'  | '0%'  | ''              | 'No'                 | ''           | '2 650,00'   | '2 650,00'     | 'No'             | 'No'                        | 'Store 01' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | 'Tax exeption reason 1 (0%, All countries)' |
			| '3' | 'Product 5 with SLN' | 'ODS'      | '90808979899; 90808979898' | 'Source of origin 6; Source of origin 6' | '130,000'   | 'en description is empty' | 'pcs'  | '5,01'  | '18%' | ''              | 'No'                 | '99,35'      | '551,95'     | '651,30'       | 'No'             | 'No'                        | 'Store 01' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | ''                                          |
			| '4' | 'Skittles'           | 'Fruit'    | ''                         | ''                                       | '5 000,000' | 'en description is empty' | 'pcs'  | '0,53'  | '0%'  | ''              | 'No'                 | ''           | '2 650,00'   | '2 650,00'     | 'No'             | 'No'                        | 'Store 01' | ''        | ''              | ''            | ''           | ''                   | ''             | ''       | ''                    | ''                          | ''             | 'Tax exeption reason 1 (0%, All countries)' |
		And form attributes have values:
			| 'Name'                     | 'Value'                    |
			| 'Agreement'                | "Basic Partner terms, TRY" |
			| 'Company'                  | "Main Company"             |
			| 'Currency'                 | "TRY"                      |
			| 'CurrencyTotalAmount'      | "TRY"                      |
			| 'ItemListTotalNetAmount'   | "6 276,53"                 |
			| 'ItemListTotalTaxAmount'   | "175,77"                   |
			| 'ItemListTotalTotalAmount' | "6 452,30"                 |
			| 'Legal name'                | "Company Lomaniti"         |
			| 'ManagerSegment'           | "Region 2"                 |
			| 'Partner'                  | "Lomaniti"                 |
			| 'PriceIncludeTax'          | "Yes"                      |
			| 'Store'                    | "Store 01"                 |
			| 'TransactionType'          | "Sales"                    |
	* Save and Post
		And I click the button named "FormWrite"
		And I delete "$$SalesInvoice02$$" variable
		And I delete "$$NumberSalesInvoice02$$" variable
		And I save the window as "$$SalesInvoice02$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice02$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows													
				
Scenario: _150088 check row separation in SC 
	And I close all client application windows
	* Create SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Store" by "Store 05" string
		And I select "Inventory transfer" exact value from the drop-down list named "TransactionType"
	* Add Item with SLN
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Product 5 with SLN" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I select "90808979898" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I input "110,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I select "90808979899" by string from the drop-down list named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I input "120,000" text in the field named "SerialLotNumbersQuantity" of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click the button named "FormOk"
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And I select "Source of origin 6" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I go to line in "SourceOfOrigins" table
			| "Serial lot number" |
			| "90808979899"       |
		And I select "Source of origin 6" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
		And I finish line editing in "ItemList" table
	* Add Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Dress" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I select "S/Yellow" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		Then "Edit source of origins" window is opened
		And I activate field named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I select "Source 2" by string from the drop-down list named "SourceOfOriginsSourceOfOrigin" in "SourceOfOrigins" table
		And I finish line editing in "SourceOfOrigins" table
		And I click the button named "FormOk"
		And I input "10 000,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 05"
		Then the form attribute named "TransactionType" became equal to "Inventory transfer"
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'       | 'Source of origins'                      | 'Quantity'   | 'Unit' | 'Store'    | 'Shipment basis' | 'Sales order' | 'Shipment planing order' | 'Sales invoice' | 'Inventory transfer order' | 'Inventory transfer' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Product 5 with SLN' | 'ODS'      | '90808979898; 90808979899' | 'Source of origin 6; Source of origin 6' | '230,000'    | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '2' | 'Dress'              | 'S/Yellow' | ''                         | 'Source 2'                               | '10 000,000' | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
	* Split first Item
		And I go to line in "ItemList" table
			| "Item"               |
			| "Product 5 with SLN" |
		And in the table "ItemList" I click the button named "ItemListSplitRow"
		And I input "130" text in the field named "InputFld"
		And I click the button named "OK"
	* Check separation
// needs to update
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'       | 'Source of origins'                      | 'Quantity'   | 'Unit' | 'Store'    | 'Shipment basis' | 'Sales order' | 'Shipment planing order' | 'Sales invoice' | 'Inventory transfer order' | 'Inventory transfer' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Product 5 with SLN' | 'ODS'      | '90808979898'              | 'Source of origin 6'                     | '100,000'    | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '2' | 'Dress'              | 'S/Yellow' | ''                         | 'Source 2'                               | '10 000,000' | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '3' | 'Product 5 with SLN' | 'ODS'      | '90808979899; 90808979898' | 'Source of origin 6; Source of origin 6' | '130,000'    | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
		And form attributes have values:
			| 'Name'            | 'Value'              |
			| 'Company'         | "Main Company"       |
			| 'Store'           | "Store 05"           |
			| 'TransactionType' | "Inventory transfer" |
		And I go to line in "ItemList" table
			| '#' | 'Item'               |
			| '3' | 'Product 5 with SLN' |
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And "SerialLotNumbers" table became equal
			| 'Serial lot number' | 'Quantity' | 'Code is approved' |
			| '90808979899'       | '120,000'  | 'No'               |
			| '90808979898'       | '10,000'   | 'No'               |
		And I close current window
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And "SourceOfOrigins" table became equal
			| 'Serial lot number' | 'Source of origin'   | 'Quantity' |
			| '90808979899'       | 'Source of origin 6' | '120,000'  |
			| '90808979898'       | 'Source of origin 6' | '10,000'   |
		And I close current window
		And I go to line in "ItemList" table
			| "#" | "Item"               |
			| "1" | "Product 5 with SLN" |
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then the form attribute named "AutoCreateNewSerialLotNumbers" became equal to "No"
		And "SerialLotNumbers" table became equal
			| 'Serial lot number' | 'Quantity' | 'Code is approved' |
			| '90808979898'       | '100,000'  | 'No'               |
		And I close current window
		And I click choice button of the attribute named "ItemListSourceOfOriginsPresentation" in "ItemList" table
		And "SourceOfOrigins" table became equal
			| 'Serial lot number' | 'Source of origin'   | 'Quantity' |
			| '90808979898'       | 'Source of origin 6' | '100,000'  |
		And I close current window
	* Split second Item
		And I go to line in "ItemList" table
			| "#" | "Item"  |
			| "2" | "Dress" |
		And in the table "ItemList" I click the button named "ItemListSplitRow"
		Then "Set the quantity for the new row" window is opened
		And I input "5 000" text in the field named "InputFld"
		And I click the button named "OK"
	* Check separation
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Serial lot numbers'       | 'Source of origins'                      | 'Quantity'  | 'Unit' | 'Store'    | 'Shipment basis' | 'Sales order' | 'Shipment planing order' | 'Sales invoice' | 'Inventory transfer order' | 'Inventory transfer' | 'Purchase return order' | 'Purchase return' |
			| '1' | 'Product 5 with SLN' | 'ODS'      | '90808979898'              | 'Source of origin 6'                     | '100,000'   | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '2' | 'Dress'              | 'S/Yellow' | ''                         | 'Source 2'                               | '5 000,000' | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '3' | 'Product 5 with SLN' | 'ODS'      | '90808979899; 90808979898' | 'Source of origin 6; Source of origin 6' | '130,000'   | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
			| '4' | 'Dress'              | 'S/Yellow' | ''                         | 'Source 2'                               | '5 000,000' | 'pcs'  | 'Store 05' | ''               | ''            | ''                       | ''              | ''                         | ''                   | ''                      | ''                |
		And form attributes have values:
			| 'Name'                                   | 'Value'                                                                                                                   | 'HowToSearch' |
			| 'Company'                                | "Main Company"                                                                                                            | ''            |
			| 'Store'                                  | "Store 05"                                                                                                                | ''            |
			| 'TransactionType'                        | "Inventory transfer"                                                                                                      | ''            |
	* Save and Post
		And I click the button named "FormWrite"
		And I delete "$$ShipmentConfirmation03$$" variable
		And I delete "$$NumberShipmentConfirmation03$$" variable
		And I save the window as "$$ShipmentConfirmation03$$"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation03$$"		
		And I click the button named "FormPostAndClose"
	And I close all client application windows						
					