#language: en
@tree
@Positive
@Retail

Feature: change rights (POS)

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _0260200 change rights (POS)
	When set True value to the constant
	When set True value to the constant Use consolidated retail sales
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog BusinessUnits objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog Partners and Payment type (Bank)
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
		When Create catalog Stores objects
		When Create catalog Partners objects
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
		When Create catalog Users objects (change rights)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When update ItemKeys
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create POS cash account objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail)
		When Create catalog ExpenseAndRevenueTypes objects
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog UserGroups objects
	* Create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And I input "Payment terminal 01" text in the field named "Description_en"
		And I click "Save and close" button
	* Create PaymentTypes
		When Create catalog PaymentTypes objects
	* Bank terms
		When Create catalog BankTerms objects (for Shop 02)		
	* Workstation
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	

Scenario: _0260209 check that change price and Return in POS is not available for CI user
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
		And I click "Open session" button
	* Add item and try change price
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		When I Check the steps for Exception
			|'And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table'|
		And I finish line editing in "ItemList" table
	* Try make return
		When I Check the steps for Exception
			|'And I click "Return" button'|
		And I delete a line in "ItemList" table
		
Scenario: _0260210 one-time change of access rights (POS)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Add item and try change price
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I click "Change rights" button
		Then "Change right" window is opened
		And I click "SearchByBarcode" button
		And I input "12345" text in the field named "InputFld"
		And I click the button named "OK"
		And I click "Ok" button	
		Then the form attribute named "UserAdmin" became equal to "Arina Brown (Financier 3)"
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '100,00' | '2,000'    | ''       | '200,00' |		
		And I click "Return" button
		And I click "Payment return" button
		And I click the button named "Enter"
		Then the form attribute named "UserAdmin" became equal to ""
	* Check the return of access rights
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		When I Check the steps for Exception
			|'And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table'|
		And I finish line editing in "ItemList" table
		When I Check the steps for Exception
			|'And I click "Return" button'|
		And I delete a line in "ItemList" table		


Scenario: _0260212 keep rights when change access rights (POS)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Change rights and return item
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I click "Change rights" button
		Then "Change right" window is opened
		And I click "SearchByBarcode" button
		And I input "12345" text in the field named "InputFld"
		And I click the button named "OK"
		And I set checkbox "Keep rights"
		And I click "Ok" button	
		Then the form attribute named "UserAdmin" became equal to "Arina Brown (Financier 3)"
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '100,00' | '2,000'    | ''       | '200,00' |		
		And I click "Return" button
		And I click "Payment return" button
		And I click the button named "Enter"
		Then the form attribute named "UserAdmin" became equal to "Arina Brown (Financier 3)"
	* Change price and return
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '100,00' | '1,000'    | ''       | '100,00' |		
		And I click "Return" button
		And I click "Payment return" button
		And I click the button named "Enter"
		Then the form attribute named "UserAdmin" became equal to "Arina Brown (Financier 3)"
	* Check the return of access rights	
		And I click "Rollback rights" button
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		When I Check the steps for Exception
			|'And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table'|
		And I finish line editing in "ItemList" table
		When I Check the steps for Exception
			|'And I click "Return" button'|
		And I delete a line in "ItemList" table
	

Scenario: _0260214 settings of access rights from user group
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.Users"		
		And I go to line in "List" table
			| 'Login' |
			| 'CI'    |
		And I select current line in "List" table
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description' |
			| 'Manager'     |
		And I select current line in "List" table
		And I click "Save" button
		And I click "Settings" button
		Then "Edit user settings" window is opened
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Disable - Change price' |
		And I activate "Use" field in "MetadataTree" table
		And I remove "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Create return' |
		And I remove "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
		And I click "Save and close" button
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Add item and try change price
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		When I Check the steps for Exception
			|'And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table'|
		And I finish line editing in "ItemList" table
	* Try make return
		When I Check the steps for Exception
			|'And I click "Return" button'|
		And I delete a line in "ItemList" table


				