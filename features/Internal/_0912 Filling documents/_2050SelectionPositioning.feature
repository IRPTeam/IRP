#language: en
@tree
@Positive
@FillingDocuments

Functionality: selection positiong in the choice forms


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _0205000 preparation ( selection positiong)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
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
		When Create catalog Companies objects (second company Ferron BP)
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


Scenario: _0205002 partner selection positiong in the Sales order
	* Open SO form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Select partner
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'     |
		And I select current line in "List" table
	* Check selection positiong
		And I click Select button of "Partner" field
		And the current line of "List" table is equal to
			| 'Description' |
			| 'DFC'     |
		And I close all client application windows
		
Scenario: _0205004 Legal name selection positiong in the Sales order
	* Open SO form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Select partner and legal name
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Aldis'     |
		And I select current line in "List" table
	* Check selection positiong
		And I click Select button of "Legal name" field
		And the current line of "List" table is equal to
			| 'Description' |
			| 'Company Aldis'     |
		And I close all client application windows				
				
		
Scenario: _0205006 agreement selection positiong in the Sales order
	* Open SO form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Select partner, legal name, agreement
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, without VAT'     |
		And I select current line in "List" table
	* Check selection positiong
		And I click Select button of "Partner term" field
		And the current line of "List" table is equal to
			| 'Description' |
			| 'Basic Partner terms, without VAT'     |
		And I close all client application windows					


Scenario: _0205008 store selection positiong in the Sales order
	* Open SO form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Select store
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 07'     |
		And I select current line in "List" table
	* Check selection positiong
		And I click Select button of "Store" field
		And the current line of "List" table is equal to
			| 'Description' |
			| 'Store 07'     |
		And I close all client application windows	

Scenario: _0205010 store selection positiong in the Bundling
	* Open Bundling form
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Select store
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 07'     |
		And I select current line in "List" table
	* Check selection positiong
		And I click Select button of "Store" field
		And the current line of "List" table is equal to
			| 'Description' |
			| 'Store 07'     |
		And I close all client application windows	

Scenario: _0205012 item selection positiong in the Sales order
	* Open SO form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Select item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table	
	* Check selection positiong
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And the current line of "List" table is equal to
			| 'Description' |
			| 'Boots'       |
		And I close all client application windows	

Scenario: _0205014 item selection positiong in the Bundling (Item bundle)
	* Open Bundling form
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Select Item bundle
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
	* Check selection positiong
		And I click Select button of "Item bundle" field
		And the current line of "List" table is equal to
			| 'Description' |
			| 'Boots'       |
		And I close all client application windows

Scenario: _0205016 item selection positiong in the Bundling
	* Open Bundling form
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Select item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check selection positiong
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And the current line of "List" table is equal to
			| 'Description' |
			| 'Boots'       |
		And I close all client application windows

Scenario: _0205018 Pick up items selection positiong in the Sales order
	* Open SO form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Select partner, legal name, agreement
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, without VAT'     |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click "Pickup" button
		And I go to line in "ItemList" table
			| 'Title' | 'Unit' |
			| 'Boots' | 'pcs'  |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'Title'   | 'Unit' |
			| '37/18SD' | 'pcs'  |
		And I select current line in "ItemKeyList" table
		And in the table "ItemKeyList" I click the button named "ItemKeyListCommandBack"
		And I go to line in "ItemList" table
			| 'Title'      | 'Unit' |
			| 'High shoes' | 'pcs'  |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'Title'   | 'Unit' |
			| '37/19SD' | 'pcs'  |
		And I select current line in "ItemKeyList" table
		And I click "Transfer to document" button			
	* Check selection positiong
		And in the table "ItemList" I click "Pickup" button
		And the current line of "ItemList" table is equal to
			| 'Title'      |
			| 'High shoes' |
		And I close all client application windows		
