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
			And I input "50,00" text in "Amount" field of "ItemList" table
			And I input "10,00" text in "Amount tax" field of "ItemList" table
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
			And I input "50,00" text in "Amount" field of "ItemList" table
			And I input "10,00" text in "Amount tax" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check
			And "ItemList" table contains lines
				| 'Revenue type'    | 'Amount'    | 'Item'                  | 'Item key'    | 'Profit loss center'         | 'Serial lot numbers'    | 'Unit'    | 'Source of origins'     | 'Quantity'    | 'Price'    | 'Amount tax'     |
				| 'Revenue'         | '50,00'     | 'Dress'                 | 'XS/Blue'     | 'Distribution department'    | ''                      | 'pcs'     | 'Source of origin 5'    | '2,000'       | '25,00'    | '10,00'          |
				| 'Revenue'         | '50,00'     | 'Product 3 with SLN'    | 'UNIQ'        | 'Distribution department'    | '09987897977895'        | 'pcs'     | 'Source of origin 6'    | '2,000'       | '25,00'    | '10,00'          |
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
				| 'Revenue type'    | 'Amount'    | 'Item'                  | 'Item key'    | 'Profit loss center'         | 'Serial lot numbers'    | 'Unit'    | 'Source of origins'     | 'Quantity'    | 'Price'    | 'Amount tax'     |
				| 'Revenue'         | '50,00'     | 'Dress'                 | 'XS/Blue'     | 'Distribution department'    | ''                      | 'pcs'     | 'Source of origin 5'    | '2,000'       | '25,00'    | '10,00'          |
				| 'Revenue'         | '50,00'     | 'Product 3 with SLN'    | 'UNIQ'        | 'Distribution department'    | '09987897977895'        | 'pcs'     | 'Source of origin 6'    | '2,000'       | '25,00'    | '10,00'          |
				| ''                | ''          | 'Dress'                 | 'M/Brown'     | ''                           | ''                      | 'pcs'     | 'Source of origin 5'    | '1,000'       | ''         | ''               |
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