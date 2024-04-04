#language: en
@tree
@Positive

@UserSettings

Feature: check filling in user settings

As a developer
I want to create a system of custom settings
For ease of filling in documents


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _200000 preparation (user settings)
	When set True value to the constant
	When set True value to the constant Use commission trading
	When set True value to the constant Use salary
	When set True value to the constant Use fixed assets
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
		When Create catalog Countries objects
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
		When Create catalog BusinessUnits objects
		When Create information register UserSettings records (Retail document)
		When Create catalog UserGroups objects
		When Create information register Taxes records (VAT)
	* Workstation
		When create Workstation
	
Scenario: _2000001 check preparation
	When check preparation

Scenario: _200001 customize the CI user settings
	Given I open hyperlink "e1cib/list/Catalog.Users"
	And I go to line in "List" table
		| 'Login'   |
		| 'CI'      |
	And I select current line in "List" table
	And I input "CI" text in the field named "Description_en"
	And I select "English" exact value from "Interface localization" drop-down list
	And I click "Save" button
	And I click "Settings" button
	* Fill in custom settings for Sales order
		And I go to line in "MetadataTree" table
		| 'Group name'    |
		| 'Sales order'   |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use'    |
			| 'Partner term'   | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Sales invoice
		And I go to line in "MetadataTree" table
			| 'Group name'       |
			| 'Sales invoice'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use'    |
			| 'Partner term'   | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Purchase order
		And I go to line in "MetadataTree" table
			| 'Group name'        |
			| 'Purchase order'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Purchase invoice
		And I go to line in "MetadataTree" table
			| 'Group name'          |
			| 'Purchase invoice'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Bank payment
		And I go to line in "MetadataTree" table
			| 'Group name'      |
			| 'Bank payment'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Account'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'TRY'        | 'Bank account, TRY'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Currency'     | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
	* Fill in custom settings for Bank receipt
		And I go to line in "MetadataTree" table
			| 'Group name'      |
			| 'Bank receipt'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Account'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, USD'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Currency'     | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code'   | 'Description'        |
			| 'USD'    | 'American dollar'    |
		And I select current line in "List" table
	* Fill in custom settings for Bundling
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Bundling'      |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash transfer order
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Cash transfer order'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Sender'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Receiver'     | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'USD'        | 'Bank account, USD'    |
		And I select current line in "List" table
	* Fill in custom settings for GoodsReceipt
		And I go to line in "MetadataTree" table
		| 'Group name'      |
		| 'Goods receipt'   |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Fill in custom settings for Purchase return
		And I go to line in "MetadataTree" table
		| 'Group name'        |
		| 'Purchase return'   |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Fill in custom settings for Purchase return order
		And I go to line in "MetadataTree" table
			| 'Group name'               |
			| 'Purchase return order'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Fill in custom settings for Sales return order
		And I go to line in "MetadataTree" table
			| 'Group name'            |
			| 'Sales return order'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Fill in custom settings for Sales return
		And I go to line in "MetadataTree" table
			| 'Group name'      |
			| 'Sales return'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Fill in custom settings for Reconciliation statement
		And I go to line in "MetadataTree" table
			| 'Group name'                  |
			| 'Reconciliation statement'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Fill in custom settings for Cash payment
		And I go to line in "MetadataTree" table
		| 'Group name'     |
		| 'Cash payment'   |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use'    |
			| 'Cash account'   | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Currency'     | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Currencies" window is opened
		And I go to line in "List" table
			| 'Code'   | 'Description'    |
			| 'EUR'    | 'Euro'           |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash receipt
		And I go to line in "MetadataTree" table
			| 'Group name'      |
			| 'Cash receipt'    |
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use'    |
			| 'Cash account'   | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Currency'     | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Currencies" window is opened
		And I go to line in "List" table
			| 'Code'   | 'Description'        |
			| 'USD'    | 'American dollar'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash expense
		And I go to line in "MetadataTree" table
			| 'Group name'      |
			| 'Cash expense'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Account'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Cash expense
		And I go to line in "MetadataTree" table
			| 'Group name'      |
			| 'Cash revenue'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Account'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Incoming payment order
		And I go to line in "MetadataTree" table
			| 'Group name'                |
			| 'Incoming payment order'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Account'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Currency'     | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code'   | 'Description'        |
			| 'USD'    | 'American dollar'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Fill in custom settings for Outgoing payment order
		And I go to line in "MetadataTree" table
			| 'Group name'                |
			| 'Outgoing payment order'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Account'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Currency'     | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Code'   | 'Description'        |
			| 'USD'    | 'American dollar'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Fill in custom settings for Inventory transfer
		And I go to line in "MetadataTree" table
			| 'Group name'            |
			| 'Inventory transfer'    |
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use'    |
			| 'Store sender'   | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'       | 'Use'    |
			| 'Store receiver'   | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'      | 'Use'    |
			| 'Store transit'   | 'No'     |
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'                  |
			| 'Inventory transfer order'    |
	* Fill in custom settings for Inventory transfer order
		And I go to line in "MetadataTree" table
			| 'Group name'                  |
			| 'Inventory transfer order'    |
		And I go to line in "MetadataTree" table
			| 'Group name'     | 'Use'    |
			| 'Store sender'   | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'       | 'Use'    |
			| 'Store receiver'   | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Fill in custom settings for Shipment confirmation
		And I go to line in "MetadataTree" table
			| 'Group name'               |
			| 'Shipment confirmation'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	* Fill in custom settings for Unbundling
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Unbundling'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
	* Fill in custom settings for Internal supply request 
		And I go to line in "MetadataTree" table
			| 'Group name'                 |
			| 'Internal supply request'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Store'        | 'No'     |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for PlannedReceiptReservation
		And I go to line in "MetadataTree" table
			| 'Group name'                     |
			| 'Planned receipt reservation'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Sales order closing
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Sales order closing'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Work order
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Work order'    |
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Work sheet
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Work sheet'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Use" field in "MetadataTree" table
		And I change "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
	* Fill in custom settings for Sales report from trade agent
		And I go to line in "MetadataTree" table
			| 'Group name'                       |
			| 'Sales report from trade agent'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Sales report to consignor
		And I go to line in "MetadataTree" table
			| 'Group name'                   |
			| 'Sales report to consignor'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Retail shipment confirmation
		And I go to line in "MetadataTree" table
			| 'Group name'                      |
			| 'Retail shipment confirmation'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Retail goods receipt
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Retail goods receipt'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Employee firing
		And I go to line in "MetadataTree" table
			| 'Group name'         |
			| 'Employee firing'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Employee hiring
		And I go to line in "MetadataTree" table
			| 'Group name'         |
			| 'Employee hiring'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Employee sick leave
		And I go to line in "MetadataTree" table
			| 'Group name'         |
			| 'Employee sick leave'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Employee vacation
		And I go to line in "MetadataTree" table
			| 'Group name'           |
			| 'Employee vacation'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Employee transfer
		And I go to line in "MetadataTree" table
			| 'Group name'           |
			| 'Employee transfer'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Payroll
		And I go to line in "MetadataTree" table
			| 'Group name' |
			| 'Payroll'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Currency'     | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Debit/Credit note
		And I go to line in "MetadataTree" table
			| 'Group name'           |
			| 'Debit/Credit note'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Fill in custom settings for Time sheet
		And I go to line in "MetadataTree" table
			| 'Group name'           |
			| 'Time sheet'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Company'      | 'No'     |
		And I select current line in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use'    |
			| 'Branch'       | 'No'     |
		And I activate "Group name" field in "MetadataTree" table
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	And I click "Ok" button
	* Open user settings
		And I click "Settings" button
		Then "Edit user settings" window is opened
		And in the table "MetadataTree" I click "Collapse all" button
		And in the table "MetadataTree" I click "Expande all" button
		Then user message window does not contain messages
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
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
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
			| 'Description'     |
			| 'Anna Petrova'    |
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

Scenario: _200006 check filling in field from custom user settings in Work order
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
	And I close all client application windows

Scenario: _200007 check filling in field from custom user settings in Work sheet
	Given I open hyperlink "e1cib/list/Document.WorkSheet"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
	And I close all client application windows

Scenario: _200008 check filling in field from custom user settings in Bundling
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows


Scenario: _200009 check filling in field from custom user settings in Cash payment
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №3"
		Then the form attribute named "Currency" became equal to "EUR"
	And I close all client application windows

Scenario: _200010 check filling in field from custom user settings in Cash receipt
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №3"
		Then the form attribute named "Currency" became equal to "USD"
	And I close all client application windows

Scenario: _200011 check filling in field from custom user settings in Cash transfer
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №3"
		Then the form attribute named "Receiver" became equal to "Bank account, USD"
	And I close all client application windows



Scenario: _200013 check filling in field from custom user settings in Goods receipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200014 check filling in field from custom user settings in Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario: _200015 check filling in field from custom user settings in Internal supply request
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I close all client application windows


Scenario: _200016 check filling in field from custom user settings in Inventory transfer
	Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
	If "List" table does not contain lines Then
			| "Metadata object"              | "Attribute name"    |
			| "Document.InventoryTransfer"   | "Company"           |
		And I click the button named "FormCreate"
		And I click Select button of "User or group" field
		And I go to line in "" table
			| ''        |
			| 'User'    |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		And I input "Document.InventoryTransfer" text in "Metadata object" field
		And I input "Company" text in "Attribute name" field
		And I select "Regular" exact value from "Kind of attribute" drop-down list
		And I click Select button of "Value" field
		And I go to line in "" table
			| ''           |
			| 'Company'    |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
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

Scenario: _200017 check filling in field from custom user settings in Inventory transfer order
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "StoreSender" became equal to "Store 02"
		Then the form attribute named "StoreReceiver" became equal to "Store 03"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200018 check filling in field from custom user settings in Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Account" became equal to "Cash desk №2"
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200019 check filling in field from custom user settings in Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario: _200020 check filling in field from custom user settings in Purchase order
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Store" became equal to "Store 03"
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario: _200021 check filling in field from custom user settings in Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario: _200022 check filling in field from custom user settings in Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows

Scenario: _200023 check filling in field from custom user settings in Sales invoice
	# the store is filled out of the agreement, if the agreement does not specify, then from user settings. So is the company.
	Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
	If "List" table does not contain lines Then
			| "Metadata object"         | "Attribute name"    |
			| "Document.SalesInvoice"   | "Agreement"         |
		And I click the button named "FormCreate"
		And I click Select button of "User or group" field
		And I go to line in "" table
			| ''        |
			| 'User'    |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		And I input "Document.SalesInvoice" text in "Metadata object" field
		And I input "Agreement" text in "Attribute name" field
		And I select "Regular" exact value from "Kind of attribute" drop-down list
		And I click Select button of "Value" field
		And I go to line in "" table
			| ''                |
			| 'Partner term'    |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _200024 check filling in field from custom user settings in Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows



Scenario: _200026 check filling in field from custom user settings in Unbundling
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 03"
	And I close all client application windows

Scenario: _200027 check filling in field from custom user settings in Reconciliation statement
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Second Company"
	And I close all client application windows


Scenario: _200028 create a custom display setting for entering in a row objects marked for deletion
	* Open Chart of characteristic types - Custom user settings
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CustomUserSettings"
	* Create custom user settings
		And I click the button named "FormCreate"
		And I input "Use object with deletion mark" text in the field named "Description_en"
		And I input "Use_object_with_deletion_mark" text in "Unique ID" field
		And I click Select button of "Value type" field
		And I go to line in "" table
			| ''           |
			| 'Boolean'    |
		And I click "OK" button
		And in the table "RefersToObjects" I click "Add refers to object" button
		And I go to line in "MetadataObjectsTable" table
			| 'Synonym'   | 'Use'    |
			| 'Items'     | 'No'     |
		And I change "Use" checkbox in "MetadataObjectsTable" table
		And I finish line editing in "MetadataObjectsTable" table
		And I go to line in "MetadataObjectsTable" table
			| 'Synonym'                       | 'Use'    |
			| 'Additional attribute values'   | 'No'     |
		And I change "Use" checkbox in "MetadataObjectsTable" table
		And I finish line editing in "MetadataObjectsTable" table
		And I go to line in "MetadataObjectsTable" table
			| 'Synonym'    | 'Use'    |
			| 'Partners'   | 'No'     |
		And I change "Use" checkbox in "MetadataObjectsTable" table
		And I finish line editing in "MetadataObjectsTable" table
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
	* Check custom user settings
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CustomUserSettings"
		And "List" table contains lines
		| 'Description'                     |
		| 'Use object with deletion mark'   |

Scenario: _200029 filling in user settings for a user group
	* Open catalog User Groups
		Given I open hyperlink "e1cib/list/Catalog.UserGroups"
	* Select and filling out a user preference for displaying objects marked for deletion
		And I go to line in "List" table
			| 'Description'    |
			| 'Admin'          |
		And I click "Settings" button
	* Filling in the settings for the display of Additional attribute values ​​marked for deletion when entering by line
		And I go to line in "MetadataTree" table
			| 'Group name'                     |
			| 'Additional attribute values'    |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'                      | 'Use'    |
			| 'Use object with deletion mark'   | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''           |
			| 'Boolean'    |
		And I select current line in "" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
	* Fill in the settings for displaying items marked for deletion when entering by line	
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Items'         |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'                      | 'Use'    |
			| 'Use object with deletion mark'   | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''           |
			| 'Boolean'    |
		And I select current line in "" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
	* Fill in the settings for displaying partners marked for deletion when entering by line
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Partners'      |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'                      | 'Use'    |
			| 'Use object with deletion mark'   | 'No'     |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''           |
			| 'Boolean'    |
		And I select current line in "" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button


Scenario: _200030  adding a group of user settings for the user
	* Open user catalog
		Given I open hyperlink "e1cib/list/Catalog.Users"
	* Select user
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
	* Specify custom settings group
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Admin'          |
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
			| 'Description'    |
			| 'Size'           |
		And I select current line in "List" table
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Size'                   | '100'            |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* create a Partner and marking it for deletion
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Delete1" text in the field named "Description_en"
		And I set checkbox "Customer"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Delete1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Check the selection by line of partner marked for deletion
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		When I Check the steps for Exception
			| 'And I select from "Partner" drop-down list by "Delete" string'    |
		And I input "" text in "Partner" field
		And I close all client application windows
	* Check the selection by line marked for AddAttributeAndPropertyValues deletion
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
		| 'Description'   |
		| 'Shirt'         |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		When I Check the steps for Exception
			| 'And I select from "Size" drop-down list by '100' string'    |
		And I input "" text in "Size" field
		And I close all client application windows


Scenario: _200032 check the availability of editing custom settings from the user list
	* Open user list
		Given I open hyperlink "e1cib/list/Catalog.Users"
	* Check that custom settings are opened from the user list
		And I go to line in "List" table
		| 'Description'                            |
		| 'Alexander Orlov (Commercial Agent 2)'   |
		And I click "Settings" button
		Then "Edit user settings" window is opened
	And I close all client application windows

Scenario: _200033 check filling in field from custom user settings in Retail return receipt
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Branch" became equal to "Shop 01"
	And I close all client application windows

Scenario: _200034 check filling in field from custom user settings in Cash statement
	Given I open hyperlink "e1cib/list/Document.CashStatement"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "CashAccount" became equal to "Cash desk №4"
	And I close all client application windows	

Scenario: _200035 check filling in field from custom user settings in Planned receipt reservation
	Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows	

Scenario: _200036 check filling in field from custom user settings in Sales order closing
	Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
	And I close all client application windows	


Scenario: _200037 check filling in field from custom user settings in Sales report from trade agent
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200038 check filling in field from custom user settings in Sales report to consignor
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200039 check filling in field from custom user settings in Retail shipment confirmation
	Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
	And I close all client application windows

Scenario: _200040 check filling in field from custom user settings in Retail goods receipt
	Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
	And I close all client application windows

Scenario: _200041 check filling in field from custom user settings in Employee firing
	Given I open hyperlink "e1cib/list/Document.EmployeeFiring"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200042 check filling in field from custom user settings in Employee hiring
	Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200043 check filling in field from custom user settings in EmployeeSickLeave
	Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _200044 check filling in field from custom user settings in EmployeeTransfer
	Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _2000455 check filling in field from custom user settings in EmployeeVacation
	Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _2000456 check filling in field from custom user settings in Payroll
	Given I open hyperlink "e1cib/list/Document.Payroll"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
	And I close all client application windows

Scenario: _2000457 check filling in field from custom user settings in TimeSheet
	Given I open hyperlink "e1cib/list/Document.TimeSheet"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _2000458 check filling in field from custom user settings in DebitCreditNote
	Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
	And I click the button named "FormCreate"
	* Check that fields are filled in from user settings
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _0154200 check user settings priority
		When Create information register UserSettings records (for workstation)
		When Create second Workstation			
	* Set user group in the workstation
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 02'    |
		And I select current line in "List" table
		And I click Select button of "User group" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Manager'        |
		And I select current line in "List" table
		And I click "Save and close" button
	* Select workstation	
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 02'    |
		And I click "Set current workstation" button	
	* Check filling branch from personal user settings
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		Then the form attribute named "Branch" became equal to "Shop 01"
		And I close all client application windows
	* Delete Branch for RSR from personal user settings
		Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
		And I go to line in "List" table
			| 'Attribute name'   | 'Kind of attribute'   | 'Metadata object'               | 'User or group'   | 'Value'      |
			| 'Branch'           | 'Common'              | 'Document.RetailSalesReceipt'   | 'CI'              | 'Shop 01'    |
		And I delete a line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Check filling branch from workstation user group
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 02'    |
		And I click "Set current workstation" button
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		Then the form attribute named "Branch" became equal to "Distribution department"
		And I close all client application windows
	* Check filling branch from user group (workstation with empty user group)
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		Then the form attribute named "Branch" became equal to "Logistics department"
						
Scenario: _200045 check time zone for user settings
	And I close all client application windows
	* Select time zone for CI
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		And I select "Europe/London" exact value from "Time zone" drop-down list
		And I click "Save and close" button
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		Then the form attribute named "CurrentSessionTimeZone" became equal to "Europe/London"
		And I save the value of "Current database time zone" field as "CurrentDataBaseTime"
		And I save the value of "Current session time" field as "CurrentSessionTime"
		And I save the value of "Current user PC time" field as "CurrentUserPCTime"
	* Change time zone
		And I select "Europe/Oslo" exact value from "Session time zone" drop-down list
		And I click "Update time info" button
		When I Check the steps for Exception
			| 'And "Current session time" field is equal to "$CurrentSessionTime$" variable'    |
	* Check the time zone when re-opening the base
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		Then the form attribute named "CurrentSessionTimeZone" became equal to "Europe/London"
		And I close all client application windows
		

				
Scenario: _200050 check Disable - Change price in POS
	And I close all client application windows
	* Disable - Change price in POS
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Disable - Change price' |
		And I select current line in "MetadataTree" table
		And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check
		And In the command interface I select "Retail" "Point of sale"
		And I expand a line in "ItemsPickup" table
			| 'Item'          |
			| '(10004) Boots' |
		And I go to line in "ItemsPickup" table
			| 'Item'                   |
			| '(10004) Boots, 37/18SD' |
		And I select current line in "ItemsPickup" table
		And "ItemList" table contains lines
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Boots' | ''             | '37/18SD'  | ''        | '700,00' | '1,000'    | ''       | '700,00' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
			| 'And I input "100,00" text in "Price" field of "ItemList" table'    |
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Delete" button
		And I close all client application windows
	* Enable - Change price in POS	
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Disable - Change price' |
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I remove "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button	
	* Check	
		And In the command interface I select "Retail" "Point of sale"
		And I expand a line in "ItemsPickup" table
			| 'Item'          |
			| '(10004) Boots' |
		And I go to line in "ItemsPickup" table
			| 'Item'                   |
			| '(10004) Boots, 37/18SD' |
		And I select current line in "ItemsPickup" table
		And "ItemList" table contains lines
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Boots' | ''             | '37/18SD'  | ''        | '700,00' | '1,000'    | ''       | '700,00' |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And "ItemList" table contains lines
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Boots' | ''             | '37/18SD'  | ''        | '100,00' | '1,000'    | ''       | '100,00' |
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Delete" button	
		

Scenario: _200051 check Disable - Create return
	And I close all client application windows
	* Disable - Create return
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Create return' |
		And I select current line in "MetadataTree" table
		And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check
		And In the command interface I select "Retail" "Point of sale"
		When I Check the steps for Exception
			| 'And I click the button named "Return"'    |	
		And I close all client application windows
	* Enable - Change price in POS	
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Create return' |
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I remove "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button	
	* Check	
		And In the command interface I select "Retail" "Point of sale"
		And I click the button named "Return"
		


Scenario: _200052 check Disable - Change author
	And I close all client application windows
	* Disable - Change author
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Change author' |
		And I select current line in "MetadataTree" table
		And I set "Use" checkbox in "MetadataTree" table
		And "MetadataTree" table contains lines
			| 'Use' | 'Group name'                            | 'Value'                   | 'Value from group' |
			| 'Yes' | 'Disable - Change author'               | 'Yes'                     | ''                 |
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate" 
		When I Check the steps for Exception
			| 'And I click Select button of "Author" field'    |		
		And I close all client application windows
	* Enable - Change author	
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Change author' |
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I remove "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button	
	* Check	
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate" 
		And I click Select button of "Author" field
		And I go to line in "List" table
			| 'Description'               |
			| 'Arina Brown (Financier 3)' |
		And I select current line in "List" table
		Then the form attribute named "Author" became equal to "Arina Brown (Financier 3)"
		And I close all client application windows

Scenario: _200053 check Enable - Change price type
	And I close all client application windows
	* Enable - Change price type in POS
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Enable - Change price type' |
		And I select current line in "MetadataTree" table
		And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check
		And In the command interface I select "Retail" "Point of sale"
		And I expand a line in "ItemsPickup" table
			| 'Item'          |
			| '(10004) Boots' |
		And I go to line in "ItemsPickup" table
			| 'Item'                   |
			| '(10004) Boots, 37/18SD' |
		And I select current line in "ItemsPickup" table
		And "ItemList" table contains lines
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Boots' | ''             | '37/18SD'  | ''        | '700,00' | '1,000'    | ''       | '700,00' |
		And I select current line in "ItemList" table
		* Change price type
			And I select current line in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And "ItemList" table became equal
				| 'Item'  | 'Price type'              | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
				| 'Boots' | 'Basic Price without VAT' | ''             | '37/18SD'  | ''        | '648,15' | '1,000'    | ''       | '648,15' |
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click "Delete" button
			And I close all client application windows
	* Enable - Change price type in POS, Disable - Change price in POS
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Disable - Change price' |
		And I select current line in "MetadataTree" table
		And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check
		And In the command interface I select "Retail" "Point of sale"
		And I expand a line in "ItemsPickup" table
			| 'Item'          |
			| '(10004) Boots' |
		And I go to line in "ItemsPickup" table
			| 'Item'                   |
			| '(10004) Boots, 37/18SD' |
		And I select current line in "ItemsPickup" table
		And "ItemList" table contains lines
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Boots' | ''             | '37/18SD'  | ''        | '700,00' | '1,000'    | ''       | '700,00' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
			| 'And I input "100,00" text in "Price" field of "ItemList" table'    |
		And I select current line in "ItemList" table
		And I click choice button of "Price type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Basic Price without VAT' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item'  | 'Price type'              | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Boots' | 'Basic Price without VAT' | ''             | '37/18SD'  | ''        | '648,15' | '1,000'    | ''       | '648,15' |
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Delete" button
		And I close all client application windows
	* Disable - Change price type in POS	
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Disable - Change price' |
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I remove "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Enable - Change price type' |
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check	
		And In the command interface I select "Retail" "Point of sale"
		And I expand a line in "ItemsPickup" table
			| 'Item'          |
			| '(10004) Boots' |
		And I go to line in "ItemsPickup" table
			| 'Item'                   |
			| '(10004) Boots, 37/18SD' |
		And I select current line in "ItemsPickup" table
		And I select current line in "ItemList" table
		When I Check the steps for Exception
			| 'And I click choice button of "Price type" attribute in "ItemList" table'    |
		And in the table "ItemList" I click "Delete" button		
								
Scenario: _200054 check filling store from user settings when delete row from document (RSR)
	And I close all client application windows
	* Open RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate" 
	* Add row
		And in the table "ItemList" I click "Add" button
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Check Store
		Then the form attribute named "Store" became equal to "Store 01"
	* Delete row and check store
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows
	
Scenario: _200055 check filling store from user settings when delete row from document (RRR)
	And I close all client application windows
	* Open RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate" 
	* Add row
		And in the table "ItemList" I click "Add" button
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Check Store
		Then the form attribute named "Store" became equal to "Store 01"
	* Delete row and check store
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows						
				
Scenario: _200053 check Disable - Calculate rows on link rows
	And I close all client application windows
	* Disable - Calculate rows on link rows
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Calculate rows on link rows' |
		And I select current line in "MetadataTree" table
		And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate" 
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then the form attribute named "CalculateRows" became equal to "No"
		And I close all client application windows
	* Enable - Change author	
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Calculate rows on link rows' |
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I remove "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button	
	* Check	
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate" 
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then the form attribute named "CalculateRows" became equal to "Yes"
		And I close all client application windows

Scenario: _200054 check user settings for catalog Partner term
	And I close all client application windows
	* Settings
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'   |
			| 'CI'      |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'    |
			| 'Partner terms' |
		And I go to line in "MetadataTree" table
			| 'Group name' |
			| 'Price type' |
		And I activate "Value" field in "MetadataTree" table
		And I select "Basic Price Types" from "Value" drop-down list by string in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'         | 
			| 'Price includes tax' |
		And I select current line in "MetadataTree" table
		And I select "Yes" exact value from "Value" drop-down list in "MetadataTree" table
		And I click "Ok" button	
	* Check	
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate" 
		Then the form attribute named "PriceType" became equal to "Basic Price Types"
		And checkbox named "PriceIncludeTax" is equal to "Yes"
	And I close all client application windows
			
				
		