#language: en
@tree
@Positive
@Other


Feature: data multi-language

As a Developer
I want to develop a mechanism
To store data in different languages

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _300600 preparation (data multi-language)

	* Constants
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
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		* Check or create SalesOrder023001
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			If "List" table does not contain lines Then
					| "Number" |
					| "$$NumberSalesOrder023001$$" |
				* Open users list
					Given I open hyperlink "e1cib/list/Catalog.Users"
				* Change localization code for CI
					And I go to line in "List" table
						| 'Description' |
						| 'CI'          |
					And I select current line in "List" table
					And I input "en" text in "Localization code" field
					And I click "Save and close" button
				And I close TestClient session
				Given I open new TestClient session or connect the existing one
				When create SalesOrder023001
				* Open users list
					Given I open hyperlink "e1cib/list/Catalog.Users"
				* Change localization code for CI
					And I go to line in "List" table
						| 'Description' |
						| 'CI'          |
					And I select current line in "List" table
					And I input "tr" text in "Localization code" field
					And I click "Save and close" button
				And I close TestClient session



Scenario: _300601 display check Description tr
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And "List" table contains lines
		| Description             | Item type  |
		| Dress TR                | Clothes TR |
		| Trousers TR             | Clothes TR |
		| Shirt TR                | Clothes TR |
		| Boots TR                | Shoes TR   |
		| High shoes TR           | Shoes TR   |
		| Box TR                  | Box TR     |
		| Bound Dress+Shirt TR    | Clothes TR |
		| Bound Dress+Trousers TR | Clothes TR |
		| Service TR              | Service TR |
		| Router                  | Equipment  |
	And I close all client application windows

Scenario: _300602 check that the English name of the catalog element is saved and displayed in the list
	* Prepare
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data item name' |
			| 'Catalog_Items'             |
		And I select current line in "List" table
		If "Attributes" table does not contain lines Then
			| "Attribute" |
			| "Article TR" |
			And in the table "Attributes" I click the button named "AttributesAdd"
			And I click choice button of "Attribute" attribute in "Attributes" table
			And I go to line in "List" table
				| 'Description' |
				| 'Article TR'     |
			And I select current line in "List" table
		And I go to line in "Attributes" table
			| 'Attribute'  |
			| 'Article TR' |
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
	Given I open hyperlink "e1cib/list/Catalog.Items"
	* Create item only with Description en
		And I click the button named "FormCreate"
		And I click Open button of "TR" field
		And I input "Candy Fruit" text in the field named "Description_en"
		And I click "Ok" button
		And I click Select button of "Item type" field
		And I click the button named "FormCreate"
		And I input "Candy Fruit TR" text in the field named "Description_tr"
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I click the button named "FormCreate"
		And I input "Taste TR" text in the field named "Description_tr"
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I finish line editing in "AvailableAttributes" table
		And I click "Save and close" button
		And I go to line in "List" table
			| Description |
			| Candy TR       |
		And I click the button named "FormChoose"
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| Description |
			| adet        |
		And I select current line in "List" table
		And I click "Save" button
	* Check description display in Item form
		Then the form attribute named "Description_en" became equal to "Candy Fruit"
		Then the form attribute named "Description_tr" became equal to ""
	And I close all client application windows
	* Check description display in list form
		# if there is no Description_tr, then Description_en should be displayed
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And "List" table contains lines
		| 'Description'             |
		| 'Candy Fruit'                |

Scenario: _300603 search by Description_en and Description_tr in the Items catalog
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I click the button named "FormFind"
	And I select "Description" exact value from "&Search in" drop-down list
	And I input "rui" text in "F&ind" field
	And I click "&Find" button
	And "List" table became equal
		| 'Description' |
		| 'Candy Fruit'    |
	And I click the button named "FormCancelSearch"
	And I click the button named "FormFind"
	And I select "Description" exact value from "&Search in" drop-down list
	And I input "tr" text in "F&ind" field
	And I click "&Find" button
	And "List" table does not contain lines
		| 'Description'             |
		| 'Candy Fruit'                |
	And I close all client application windows



Scenario: _300604 Turkish description search in Sales order
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	* Check list display
		And "List" table contains lines
		| 'Number'                     | 'Partner'      | 'Status'      | 'Σ'        | 'Currency' |
		| '$$NumberSalesOrder023001$$' | 'Ferron BP TR' | 'Approved TR' | '4 350,00' | 'TRY'      |
	* Check the Turkish search on the order form
		And I click the button named "FormCreate"
		And I input "Kalipso TR" text in "Partner" field
		And I select from "Partner" drop-down list by "kali" string
		And I input "Kalip" text in "Legal name" field
		And I select from "Legal name" drop-down list by "kali" string
		And I click Select button of "Partner term" field
		Then "Partner terms" window is opened
		And I go to line in "List" table
			| Description           |
			| Basic Partner terms, TRY |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Kalipso TR"
		Then the form attribute named "LegalName" became equal to "Company Kalipso TR"
		Then the form attribute named "Status" became equal to "Approved TR"
		Then the form attribute named "Company" became equal to "Main Company TR"
		Then the form attribute named "Store" became equal to "Store 01 TR"
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "fruit" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Shirt TR    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item     | Item key    |
			| Shirt TR | 38/Black TR |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| Item     |
			| Candy Fruit |
		And I delete a line in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'    | 'Q'     |
			| 'Shirt TR' | '38/Black TR' | '1,000' |
		And I close all client application windows



Scenario: _300605 check the display of the Turkish name in the list by the element for which initially there was only an English name
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I go to line in "List" table
		| Description    |
		| Candy Fruit       |
	And I select current line in "List" table
	And I input "Candy Fruit TR" text in the field named "Description_tr"
	And I click "Save and close" button
	And "List" table contains lines
		| Description             | Item type     |
		| Candy Fruit TR             | Candy TR      |
	And I close all client application windows


Scenario: _300606 check the opening of the catalog element for which the additional details filter is installed (English locale)
	Given I open hyperlink "e1cib/list/Catalog.Partners"
	And I go to line in "List" table
		| Description    |
		| Ferron BP TR       |
	Then system warning window does not appear
	And I select current line in "List" table
	Then "Ferron BP TR (Partner)" window is opened
	And I close all client application windows

Scenario: _300607 Change localization code for CI on en
	* Change localization code for CI
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Description' |
			| 'CI'          |
		And I select current line in "List" table
		And I input "en" text in "Localization code" field
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one













