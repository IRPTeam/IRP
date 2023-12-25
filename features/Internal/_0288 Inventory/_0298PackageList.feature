#language: en
@tree
@Positive
@Inventory



Feature: create package list operation in count by location


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _029800 preparation (package list operation in count by location)
	When set True value to the constant
	* Load info
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
		When Create catalog CancelReturnReasons objects
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create information register CurrencyRates records
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
		When Create catalog Partners objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create information register Taxes records (VAT)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Barcodes records
		And I close all client application windows

Scenario: _0298001 check preparation
	When check preparation	

Scenario: _0298002 create package list operation in count by location (use SLN)
	And I close all client application windows
	* Create package list
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"	
		And I move to "Rules" tab
		And I set checkbox "Use serial lot"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| Description     |
			| Store 02        |
		And I select current line in "List" table
	* Add items
		* Scan item without serial lot number
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283705" text in the field named "Barcode"
			And I move to the next attribute
			And I activate "Phys. count" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "2,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Scan item with serial lot number (with barcode)
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "23455677788976667" text in the field named "Barcode"
			And I move to the next attribute
			And I input "1,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add item input by string
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I select current line in "List" table
			And I activate "Phys. count" field in "ItemList" table
			And I input "5,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
	* Check
		And I click the button named "FormWrite"
		And "ItemList" table contains lines
			| '#' | 'Date' | 'Barcode'           | 'Item'               | 'Item key' | 'Serial lot number' | 'Unit' | 'Phys. count' |
			| '1' | '*'    | '2202283705'        | 'Dress'              | 'XS/Blue'  | ''                  | 'pcs'  | '2,000'       |
			| '2' | '*'    | '23455677788976667' | 'Product 1 with SLN' | 'PZU'      | '8908899877'        | 'pcs'  | '1,000'       |
			| '3' | ''     | ''                  | 'Dress'              | 'XS/Blue'  | ''                  | 'pcs'  | '5,000'       |
		Then the number of "ItemList" table lines is "равно" "3"
		Then the form attribute named "TransactionType" became equal to "Package"
	And I close all client application windows