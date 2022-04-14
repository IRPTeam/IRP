#language: en
@tree
@Positive
@FillingDocuments

Feature: check filling in expence and revenue



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _0202100 preparation (filling expence, revenue)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
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
		When Create catalog PlanningPeriods objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create catalog PartnerItems objects
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
		When Create catalog CancelReturnReasons objects
	
Scenario: _0202101 filling revenue type in the SI (from Company)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (Company)
	* Select Company
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'XS/Blue' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type' | 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Rent'         | 'Dress' | 'XS/Blue'  | '1,000' | 'pcs'  |
	* Reselect Company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company'     |
		And I select current line in "List" table
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'             | 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Telephone communications' | 'Dress' | 'XS/Blue'  | '1,000' | 'pcs'  |
	And I close all client application windows
	

Scenario: _0202102 filling expense type in the PO (from Company)
	And I close all client application windows
	* Select Company
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Service'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'Rent' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in Expense type
		And "ItemList" table became equal
			| 'Expense type' | 'Item'    | 'Item key' | 'Q'     | 'Unit' |
			| 'Rent'         | 'Service' | 'Rent'     | '1,000' | 'pcs'  |
	* Reselect Company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company'     |
		And I select current line in "List" table
	* Check filling in Expense type
		And "ItemList" table became equal
			| 'Expense type'             | 'Item'    | 'Item key' | 'Q'     | 'Unit' |
			| 'Telephone communications' | 'Service' | 'Rent'     | '1,000' | 'pcs'  |
	And I close all client application windows
			
Scenario: _0202103 filling revenue type in the SR (from Company)
	And I close all client application windows
	* Select Company
		Given I open hyperlink "e1cib/list/Document.SalesReturn"	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'XS/Blue' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type' | 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Rent'         | 'Dress' | 'XS/Blue'  | '1,000' | 'pcs'  |
	* Reselect Company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company'     |
		And I select current line in "List" table
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'             | 'Item'  | 'Item key' | 'Q'     | 'Unit' |
			| 'Telephone communications' | 'Dress' | 'XS/Blue'  | '1,000' | 'pcs'  |
	And I close all client application windows		
						

Scenario: _0202104 filling expense type in the PR (from Company)
	And I close all client application windows
	* Select Company
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Service'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'Rent' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in Expense type
		And "ItemList" table became equal
			| 'Expense type' | 'Item'    | 'Item key' | 'Q'     | 'Unit' |
			| 'Rent'         | 'Service' | 'Rent'     | '1,000' | 'pcs'  |
	* Reselect Company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company'     |
		And I select current line in "List" table
	* Check filling in Expense type
		And "ItemList" table became equal
			| 'Expense type'             | 'Item'    | 'Item key' | 'Q'     | 'Unit' |
			| 'Telephone communications' | 'Service' | 'Rent'     | '1,000' | 'pcs'  |
	And I close all client application windows
		
Scenario: _0202103 filling revenue type in the SI (from item type)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item type)
	* Check in tne SI
		* Select Company
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
			And I click "Create" button
			And I click Choice button of the field named "Company"
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company'     |
			And I select current line in "List" table
		* Select Item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item key'  |
				| 'XS/Blue' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table		
		* Check filling in revenue type
			And "ItemList" table became equal
				| 'Revenue type' | 'Item'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Rent'         | 'Dress' | 'XS/Blue'  | '1,000' | 'pcs'  |
		* Reselect item
			And I click Choice button of the field named "Company"
			And I go to line in "List" table
				| 'Description' |
				| 'Second Company'     |
			And I select current line in "List" table
		* Check filling in revenue type
			And "ItemList" table became equal
				| 'Revenue type'             | 'Item'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Telephone communications' | 'Dress' | 'XS/Blue'  | '1,000' | 'pcs'  |
	And I close all client application windows					


Scenario: _999999 close TestClient session
	And I close TestClient session