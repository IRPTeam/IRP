#language: en
@tree
@Positive

@UserSettings

Feature: check filling in user settings

As a developer
I want to create a system of custom settings
For ease of filling in documents


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _200000 preparation (user settings)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog Users objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog CashAccounts objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Companies objects (own Second company)
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
		When Create catalog Partners objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	


Scenario: _200001 customize the CI user settings
	Given I open hyperlink "e1cib/list/Catalog.Users"
	And I go to line in "List" table
		| 'Login' |
		| 'CI'          |
	And I select current line in "List" table
	And I input "CI" text in the field named "Description_en"
	And I input "en" text in "Interface localization code" field
	And I click "Save" button
	And I click "Settings" button
	* Fill in custom settings for Sales order
		And I go to line in "MetadataTree" table
		| 'Group name'  |
		| 'Sales order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Partner term'  | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Sales invoice
		And I go to line in "MetadataTree" table
			| 'Group name'  |
			| 'Sales invoice' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Partner term'  | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Purchase order
		And I go to line in "MetadataTree" table
			| 'Group name'  |
			| 'Purchase order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Purchase invoice
		And I go to line in "MetadataTree" table
			| 'Group name'  |
			| 'Purchase invoice' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Bank payment
		And I go to line in "MetadataTree" table
			| 'Group name'   |
			| 'Bank payment' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
	* Fill in custom settings for Bank receipt
		And I go to line in "MetadataTree" table
			| 'Group name'   |
			| 'Bank receipt' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, USD' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
	* Fill in custom settings for Bundling
		And I go to line in "MetadataTree" table
			| 'Group name' |
			| 'Bundling'   |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash transfer order
		And I go to line in "MetadataTree" table
			| 'Group name'          |
			| 'Cash transfer order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Sender'     | 'No'  |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Receiver'   | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		And I select current line in "List" table
	* Fill in custom settings for Invoice match
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Invoice match' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Fill in custom settings for GoodsReceipt
		And I go to line in "MetadataTree" table
		| 'Group name'    |
		| 'Goods receipt' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Fill in custom settings for Purchase return
		And I go to line in "MetadataTree" table
		| 'Group name'    |
		| 'Purchase return' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
	* Fill in custom settings for Purchase return order
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Purchase return order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
	* Fill in custom settings for Sales return order
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Sales return order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
	* Fill in custom settings for Sales return
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Sales return' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
	* Fill in custom settings for Reconciliation statement
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Reconciliation statement' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
	* Fill in custom settings for Cash payment
		And I go to line in "MetadataTree" table
		| 'Group name'   |
		| 'Cash payment' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use' |
			| 'Cash account' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Currencies" window is opened
		And I go to line in "List" table
			| 'Code' | 'Description' |
			| 'EUR'  | 'Euro'        |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash receipt
		And I go to line in "MetadataTree" table
			| 'Group name'   |
			| 'Cash receipt' |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use' |
			| 'Cash account' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Currencies" window is opened
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash expense
		And I go to line in "MetadataTree" table
			| 'Group name'   |
			| 'Cash expense' |
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash expense
		And I go to line in "MetadataTree" table
			| 'Group name'   |
			| 'Cash revenue' |
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Incoming payment order
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Incoming payment order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Fill in custom settings for Outgoing payment order
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Outgoing payment order' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Account'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №3' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Currency'   | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Fill in custom settings for Inventory transfer
		And I go to line in "MetadataTree" table
			| 'Group name'         |
			| 'Inventory transfer' |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use' |
			| 'Store sender' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use' |
			| 'Store receiver' | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'    | 'Use' |
			| 'Store transit' | 'No'  |
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'               |
			| 'Inventory transfer order' |
	* Fill in custom settings for Inventory transfer order
		And I go to line in "MetadataTree" table
			| 'Group name'               |
			| 'Inventory transfer order' |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use' |
			| 'Store sender' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use' |
			| 'Store receiver' | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Fill in custom settings for Shipment confirmation
		And I go to line in "MetadataTree" table
			| 'Group name'            |
			| 'Shipment confirmation' |
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Fill in custom settings for Unbundling
		And I go to line in "MetadataTree" table
			| 'Group name' |
			| 'Unbundling' |
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
		And I select current line in "List" table
	* Fill in custom settings for Internal supply request 
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Internal supply request' |
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	And I click "Ok" button
	And I click "Save and close" button


Scenario: _200002 check filling in field from custom user settings in Sales order (partner has an agreement that's specified in the settings)
	# the store is filled from the agreement, if not specified in the agreement, then from the user settings
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Status" became equal to "Approved"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	* Check the filling in of fields when selecting a partner who has an agreement 'Basic Partner terms, TRY'
	# completed fields should not be cleared
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Status" became equal to "Approved"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And I close all client application windows

Scenario: _200003 check filling in field from custom user settings in Sales order (partner does not have an agreement that is specified in the settings)
	# the store is filled from the agreement, if not specified in the agreement, then from the user settings
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Status" became equal to "Approved"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	* Check the filling in of fields when selecting a partner who has an agreement 'Basic Partner terms, TRY'
	# completed fields should not be cleared
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Anna Petrova'   |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to ""
		Then the form attribute named "Agreement" became equal to ""
		Then the form attribute named "Status" became equal to "Approved"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And I close all client application windows


Scenario: _200004 check filling in field from custom user settings in Bank payment
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "Currency" became equal to "TRY"
	And I close all client application windows

Scenario: _200005 check filling in field from custom user settings in Bank receipt
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, USD"
		Then the form attribute named "Currency" became equal to "USD"
	And I close all client application windows



Scenario:  _200008 check filling in field from custom user settings in Bundling
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows


Scenario:  _200009 check filling in field from custom user settings in Cash payment
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №3"
		Then the form attribute named "Currency" became equal to "EUR"
	And I close all client application windows

Scenario:  _200010 check filling in field from custom user settings in Cash receipt
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №3"
		Then the form attribute named "Currency" became equal to "USD"
	And I close all client application windows

Scenario:  _200011 check filling in field from custom user settings in Cash transfer
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №3"
		Then the form attribute named "Receiver" became equal to "Bank account, USD"
	And I close all client application windows

Scenario:  _200012 check filling in field from custom user settings in Invoice match
	Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario:  _200013 check filling in field from custom user settings in Goods receipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario:  _200014 check filling in field from custom user settings in Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario:  _200015 check filling in field from custom user settings in Internal supply request
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I close all client application windows


Scenario:  _200016 check filling in field from custom user settings in Inventory transfer
	Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
	If "List" table does not contain lines Then
			| "Metadata object"            | "Attribute name" |
			| "Document.InventoryTransfer" |"Company"         |
		And I click the button named "FormCreate"
		And I click Select button of "User or group" field
		And I go to line in "" table
			| ''     |
			| 'User' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Login' |
			| 'CI'          |
		And I select current line in "List" table
		And I input "Document.InventoryTransfer" text in "Metadata object" field
		And I input "Company" text in "Attribute name" field
		And I select "Regular" exact value from "Kind of attribute" drop-down list
		And I click Select button of "Value" field
		And I go to line in "" table
			| ''        |
			| 'Company' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "StoreSender" became equal to "Store 02"
		Then the form attribute named "StoreReceiver" became equal to "Store 03"
		Then the form attribute named "StoreTransit" became equal to "Store 02"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario:  _200017 check filling in field from custom user settings in Inventory transfer order
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "StoreSender" became equal to "Store 02"
		Then the form attribute named "StoreReceiver" became equal to "Store 03"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario:  _200018 check filling in field from custom user settings in Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Account" became equal to "Cash desk №2"
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario:  _200019 check filling in field from custom user settings in Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario:  _200020 check filling in field from custom user settings in Purchase order
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Store" became equal to "Store 03"
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario:  _200021 check filling in field from custom user settings in Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario:  _200022 check filling in field from custom user settings in Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario:  _200023 check filling in field from custom user settings in Sales invoice
	# the store is filled out of the agreement, if the agreement doesn't specify, then from user settings. So is the company.
	Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
	If "List" table does not contain lines Then
			| "Metadata object"            | "Attribute name" |
			| "Document.SalesInvoice" |"Agreement"         |
		And I click the button named "FormCreate"
		And I click Select button of "User or group" field
		And I go to line in "" table
			| ''     |
			| 'User' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Login' |
			| 'CI'          |
		And I select current line in "List" table
		And I input "Document.SalesInvoice" text in "Metadata object" field
		And I input "Agreement" text in "Attribute name" field
		And I select "Regular" exact value from "Kind of attribute" drop-down list
		And I click Select button of "Value" field
		And I go to line in "" table
			| ''        |
			| 'Partner term' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario:  _200024 check filling in field from custom user settings in Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows



Scenario:  _200026 check filling in field from custom user settings in Unbundling
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 03"
	And I close all client application windows

Scenario:  _200027 check filling in field from custom user settings in Reconciliation statement
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows


Scenario:  _200028 create a custom display setting for entering in a row objects marked for deletion
	* Open Chart of characteristic types - Custom user settings
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CustomUserSettings"
	* Create custom user settings
		And I click the button named "FormCreate"
		And I input "Use object with deletion mark" text in the field named "Description_en"
		And I input "Use_object_with_deletion_mark" text in "Unique ID" field
		And I click Select button of "Value type" field
		And I go to line in "" table
			| ''        |
			| 'Boolean' |
		And I click "OK" button
		And in the table "RefersToObjects" I click "Add refers to object" button
		And I go to line in "MetadataObjectsTable" table
			| 'Synonym' | 'Use' |
			| 'Items'   | 'No'  |
		And I change "Use" checkbox in "MetadataObjectsTable" table
		And I finish line editing in "MetadataObjectsTable" table
		And I go to line in "MetadataObjectsTable" table
			| 'Synonym'                           | 'Use' |
			| 'Additional attribute values' | 'No'  |
		And I change "Use" checkbox in "MetadataObjectsTable" table
		And I finish line editing in "MetadataObjectsTable" table
		And I go to line in "MetadataObjectsTable" table
			| 'Synonym'  | 'Use' |
			| 'Partners' | 'No'  |
		And I change "Use" checkbox in "MetadataObjectsTable" table
		And I finish line editing in "MetadataObjectsTable" table
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
	* Check custom user settings
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CustomUserSettings"
		And "List" table contains lines
		| 'Description'                   |
		| 'Use object with deletion mark' |

Scenario: _200029 filling in user settings for a user group
	* Open catalog User Groups
		Given I open hyperlink "e1cib/list/Catalog.UserGroups"
	* create a new group and filling out a user preference for displaying objects marked for deletion
		And I click the button named "FormCreate"
		And I input "Admin" text in the field named "Description_en"
		And I click "Save" button
		And I click "Settings" button
	* Filling in the settings for the display of Additional attribute values ​​marked for deletion when entering by line
		And I go to line in "MetadataTree" table
			| 'Group name'                        |
			| 'Additional attribute values' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'                    | 'Use' |
			| 'Use object with deletion mark' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''        |
			| 'Boolean' |
		And I select current line in "" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
	* Fill in the settings for displaying items marked for deletion when entering by line	
		And I go to line in "MetadataTree" table
			| 'Group name' |
			| 'Items'      |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'                    | 'Use' |
			| 'Use object with deletion mark' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''        |
			| 'Boolean' |
		And I select current line in "" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
	* Fill in the settings for displaying partners marked for deletion when entering by line
		And I go to line in "MetadataTree" table
			| 'Group name' |
			| 'Partners'   |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'                    | 'Use' |
			| 'Use object with deletion mark' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''        |
			| 'Boolean' |
		And I select current line in "" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Saving the group
		And I click "Save and close" button

Scenario: _200030  adding a group of user settings for the user
	* Open user catalog
		Given I open hyperlink "e1cib/list/Catalog.Users"
	* Select user
		And I go to line in "List" table
			| 'Login' |
			| 'CI'          |
		And I select current line in "List" table
	* Specify custom settings group
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description' |
			| 'Admin'       |
		And I select current line in "List" table
	* Save settings
		And I click "Save and close" button

Scenario: _200031 line entry check of objects marked for deletion (AddAttributeAndPropertyValues and Partner)
	* create an AddAttributeAndPropertyValues and marking it for deletion
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And I click the button named "FormCreate"
		And I input "100" text in the field named "Description_en"
		And I click Select button of "Additional attribute" field
		And I go to line in "List" table
			| 'Description' |
			| 'Size'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Size'          | '100'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* create a Partner and marking it for deletion
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Delete" text in the field named "Description_en"
		And I set checkbox "Customer"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'      |
			| 'Delete' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Check the selection by line of partner marked for deletion
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		When I Check the steps for Exception
			|'And I select from "Partner" drop-down list by "Delete" string'|
		And I input "" text in "Partner" field
		And I close all client application windows
	* Check the selection by line marked for AddAttributeAndPropertyValues deletion
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
		| 'Description' |
		| 'Shirt'       |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		When I Check the steps for Exception
			|'And I select from "Size" drop-down list by '100' string'|
		And I input "" text in "Size" field
		And I close all client application windows


Scenario: _200032 check the availability of editing custom settings from the user list
	* Open user list
		Given I open hyperlink "e1cib/list/Catalog.Users"
	* Check that custom settings are opened from the user list
		And I go to line in "List" table
		| 'Description'                          |
		| 'Alexander Orlov (Commercial Agent 2)' |
		And I click "Settings" button
		Then "Edit user settings" window is opened
	And I close all client application windows


	


Scenario: _999999 close TestClient session
	And I close TestClient session