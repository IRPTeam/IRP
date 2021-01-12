#language: en
@tree
@Positive
@PhysicalInventory

Feature: mobile forms physical inventory

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _0299100 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ExpenseAndRevenueTypes objects
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
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When update ItemKeys
		* Create test physical inventory and location count
			Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
			And I click the button named "FormCreate"
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 05'    |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Locked" field in "ItemList" table
			And I click "Fill exp. count" button
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberPhysicalInventory0299100$$"
			And I save the window as "$$PhysicalInventory0299100$$"
			And I click the button named "FormPostAndClose"
			And I click "Physical count by location" button
			Then "How many documents to create?" window is opened
			And I input "2" text in "InputFld" field
			And I click "OK" button
			Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
			And "List" table contains lines
				| 'Store'    | 'Status'   | 'Physical inventory'           |
				| 'Store 05' | 'Prepared' | '$$PhysicalInventory0299100$$' |
				| 'Store 05' | 'Prepared' | '$$PhysicalInventory0299100$$' |
			And I close all client application windows
			


Scenario: _0299101 mobile invent
	And In the command interface I select "Mobile" "Mobile invent"
	* Select Location count 
		And I click Select button of "DocumentRef" field
		And I go to the last line in "List" table
		And I select current line in "List" table
		Given Recent TestClient message contains "Current location #* was linked to you. Other users will not be able to scan it." string by template
	* Scan
		And I click "SearchByBarcode" button
		And I input "4820024700016" text in "InputFld" field
		And I click "OK" button
		And I click "SearchByBarcode" button
		And I input "4820024700016" text in "InputFld" field
		And I click "OK" button
		And I click "SearchByBarcode" button
		And I input "2202283713" text in "InputFld" field
		And I click "OK" button
	* Change quantity
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Phys. count' |
			| 'Dress' | 'S/Yellow' | '1,000'       |
		And I select current line in "ItemList" table
		Then "Row form" window is opened
		And I input "124,000" text in "Quantity" field
		And I click "OK" button
		And "ItemList" table contains lines
		| 'Item'  | 'Item key' | 'Phys. count' |
		| 'Boots' | '36/18SD'  | '1,000'       |
		| 'Boots' | '36/18SD'  | '1,000'       |
		| 'Dress' | 'S/Yellow' | '124,000'     |
	* Complete location
		And I click "Complete location" button
		Then "Please enter total quantity" window is opened
		And I input "126" text in "InputFld" field
		And I click "OK" button
		Given Recent TestClient message contains "Total quantity is ok. Please scan and count next location." string by template
	* Check message when enter incorrect total
		And I click Select button of "DocumentRef" field
		And I go to the last line in "List" table
		And I move one line up in "List" table
		And I select current line in "List" table
		Given Recent TestClient message contains "Current location #* was linked to you. Other users will not be able to scan it." string by template
		And I click "SearchByBarcode" button
		And I input "4820024700016" text in "InputFld" field
		And I click "OK" button
		And I click "Complete location" button
		Then "Please enter total quantity" window is opened
		And I input "2" text in "InputFld" field
		And I click "OK" button
		Then "Total quantity doesnt match. Please count one more time. You have one more try." window is opened
		And I input "2" text in "InputFld" field
		And I click "OK" button
		Given Recent TestClient message contains "Total quantity doesnt match. Location need to be count again (current count is annulated)." string by template
	* Сount one more time
		And I click "SearchByBarcode" button
		And I input "4820024700016" text in "InputFld" field
		And I click "OK" button
		And I click "Complete location" button
		Then "Total quantity doesnt match. Please count one more time. You have one more try." window is opened
		And I input "1" text in "InputFld" field
		And I click "OK" button
		Given Recent TestClient message contains "Total quantity is ok. Please scan and count next location." string by template
		And I close all client application windows
				
	
		
				
		
		
				

		
				
		
		
				
		
