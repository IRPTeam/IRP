#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: create discount Message Dialog Box 2 (Message 3)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreate"
	And I click Select button of "Special offer type" field
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
			| 'Description'                   |
			| 'ExternalSpecialMessage' |
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I select "DialogBox" exact value from "Message type" drop-down list
	And I input "Message 3" text in "Message Description_en" field
	And I input "Message 3" text in "Message Description_tr" field
	And I click "Save settings" button
	And I click "Save and close" button
	And I wait "DialogBox2 (Special offer types) *" window closing in 20 seconds
	And I click the button named "FormChoose"
	And I input "8" text in "Priority" field
	And I input "01.01.2019  0:00:00" text in "Start of" field
	And I select "Sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And in the table "Rules" I click the button named "RulesAdd"
	And I click choice button of "Rule" attribute in "Rules" table
	And I go to line in "List" table
			| 'Description'                                |
			| 'Discount on Basic Partner terms without Vat' |
	And I select current line in "List" table
	And I finish line editing in "Rules" table
	And I click "Save and close" button
	And Delay 2
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 2 without Vat' |
	And I go to line in "List" table
			| 'Description'  |
			| 'DialogBox2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I click "List" button
	And I go to line in "List" table
			| 'Priority' | 'Special offer type' |
			| '1'        | 'Sum'                |
	And I click the button named "FormChoose"

Scenario: transfer the discount Discount 1 without Vat from Sum to Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I expand a line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '1'        | 'Special Offers'     |
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	And I click the button named "FormChoose"



Scenario: changing the auto apply of Discount 1 without Vat
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 1 without Vat' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: create an order for MIO Basic Partner terms, without VAT (High shoes and Boots)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'High shoes' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '39/19SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Boots' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "4,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post" button



Scenario: transfer the Discount 1 without Vat discount from Maximum to Minimum.
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And in the table "List" I click the button named "ListContextMenuLevelDown"
	And Delay 2
	And I move one level down in "List" table
	And Delay 1
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	And I click the button named "FormChoose"





Scenario: choose the unit of measurement pcs
		And I click choice button of "Unit" attribute in "ItemKeyList" table
		And I go to line in "List" table
		| Description |
		| pcs         |
		And I select current line in "List" table