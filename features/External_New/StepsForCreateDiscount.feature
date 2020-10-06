#language: en
@ExportScenarios
@IgnoreOnCIMainBuild

Feature: export scenarios for special offers

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: select the plugin to create the type of special offer 
	Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"

Scenario: select the plugin to create the rule of special offer 
	Given I open hyperlink "e1cib/list/Catalog.SpecialOfferRules"
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"


Scenario: move on to the Price Type settings
	And I click "Set settings" button
	And I click Select button of "Price type" field

Scenario: save the special offer setting
	And I click "Save settings" button
	And Delay 2
	And I click "Save and close" button
	And Delay 5

Scenario: choose the plugin to create a special offer type (message)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
		| 'Description'           | 
		| 'ExternalSpecialMessage' | 
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"


Scenario: choose the plugin to create a special offer
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreateFolder"
	And I click Select button of "Special offer type" field
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
		| 'Description'                 |
		| 'ExternalSpecialOfferRules' |
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"

Scenario: open a special offer window
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreate"
	And I click Select button of "Special offer type" field
	And Delay 2

Scenario: enter the discount period this month
	And I input begin of the current month date in "Start of" field
	And I input end of the current month date in "End of" field

Scenario: add a special offer rule
	And in the table "Rules" I click the button named "RulesAdd"
	And I click choice button of "Rule" attribute in "Rules" table
	And Delay 1

Scenario: save the rule for a special offer
	And I select current line in "List" table
	And Delay 1
	And I finish line editing in "Rules" table
	And I click "Save and close" button
	And Delay 10

Scenario: move the Discount 2 without Vat special offer from Maximum to Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 2 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And in the table "List" I click the button named "ListContextMenuLevelDown"
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move Discount 2 without Vat and Discount 1 without Vat discounts from the group Minimum to the group Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	And I click the button named "FormChoose"
	Then "Special offers" window is opened
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 2 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	And I click the button named "FormChoose"

Scenario: transfer Discount 2 without Vat and Discount 1 without Vat discounts from Maximum to Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"
	Then "Special offers" window is opened
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 2 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: transfer the Discount Price 2 discount to the Minimum group
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: change the Discount Price 2 manual
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And I select current line in "List" table
	And I set checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window


Scenario: change the manual setting of the Discount Price 1 discount.
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And I select current line in "List" table
	And I set checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: change the auto setting of the Discount Price 2
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window


Scenario: change the auto setting of the special offer Discount Price 1
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario:  move the Discount Price 1 to Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario:  move the Discount Price 1 to Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Maximum'            |
	And I click the button named "FormChoose"

Scenario:  move the Discount Price 2 special offer to Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Maximum'            |
	And I click the button named "FormChoose"

Scenario: move the special offer Discount Price 2 to Minimum (for test)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move the Discount Price 1 to Sum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: move the Discount Price 2 special offer to Sum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: change the priority Discount Price 1 from 1 to 3
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And I select current line in "List" table
	And I input "3" text in "Priority" field
	And I click "Save and close" button
	And Delay 2


Scenario: change the priority Discount Price 1 to 1
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And I select current line in "List" table
	And I input "1" text in "Priority" field
	And I click "Save and close" button
	And Delay 2

Scenario: change the priority special offer Discount Price 2 from 4 to 2
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And I select current line in "List" table
	And I input "2" text in "Priority" field
	And I click "Save and close" button
	And Delay 2

Scenario: move the Discount 1 without Vat discount to Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move the Discount 2 without Vat discount to the Minimum group
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 2 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move the Discount 1 without Vat discount to the Sum group
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"


Scenario: move the Discount 1 without Vat discount to the Sum in Minimum group
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 2 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: move the group Sum in Minimum to Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'      |
		| 'Sum in Minimum' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move the Discount 1 without Vat discount to Sum in Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: move the Discount 2 without Vat discount to Special Offers
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 2 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I click the button named "FormChoose"

Scenario: move Discount 1 without Vat in Special Offers
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I click the button named "FormChoose"

Scenario: change auto setting 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: change auto setting 4+1 Dress and Trousers, Discount on Basic Partner terms
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: change auto setting All items 5+1, Discount on Basic Partner terms
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: change manually setting 4+1 Dress and Trousers, Discount on Basic Partner terms
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	And I select current line in "List" table
	And I set checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: change manually setting 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	And I select current line in "List" table
	And I set checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: change manually setting All items 5+1, Discount on Basic Partner terms
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	And I select current line in "List" table
	And I set checkbox "Manually"
	And I click "Save" button
	And Delay 2
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: move the discount All items 5+1, Discount on Basic Partner terms to the group Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Minimum'            |
	And I click the button named "FormChoose"

Scenario: move the discount All items 5+1, Discount on Basic Partner terms to the group Sum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Sum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Sum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: change Type joing in the group Maximum to Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'      |
			| 'Maximum' |
		And in the table "List" I click the button named "ListContextMenuChange"
		And I click Open button of "Special offer type" field
		And I click "Set settings" button
		Then "Special offer rules" window is opened
		And I select "Maximum" exact value from "Type joining" drop-down list
		And I click "Save settings" button
		And I click "Save and close" button
		And Delay 10
		And I click "Save and close" button
		And Delay 10

Scenario: change Type joing in the group Maximum to MaximumInRow
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'      |
			| 'Maximum' |
		And in the table "List" I click the button named "ListContextMenuChange"
		And I click Open button of "Special offer type" field
		And I click "Set settings" button
		Then "Special offer rules" window is opened
		And I select "Maximum by row" exact value from "Type joining" drop-down list
		And I click "Save settings" button
		And I click "Save and close" button
		And Delay 10
		And I click "Save and close" button
		And Delay 10

Scenario: move the discount All items 5+1, Discount on Basic Partner terms to the group Special Offers
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I go to line in "List" table
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	And I click the button named "FormChoose"

Scenario: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Special Offers
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I go to line in "List" table
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	And I click the button named "FormChoose"

Scenario: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Special Offers
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I go to line in "List" table
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	And I click the button named "FormChoose"

Scenario: move Discount Price 1 to Special Offers
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 1' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I go to line in "List" table
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	And I click the button named "FormChoose"

Scenario: move Discount Price 1 to the group Special Offers
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount Price 2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I go to line in "List" table
        | 'Special offer type' | 'Priority' |
        | 'Special Offers'     | '1'        |
	And I click the button named "FormChoose"

Scenario: move the discount All items 5+1, Discount on Basic Partner terms to the group Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'All items 5+1, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I click "List" button
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Maximum'            |
	And I click the button named "FormChoose"

Scenario: move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I click "List" button
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Maximum'            |
	And I click the button named "FormChoose"

Scenario: move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| '4+1 Dress and Trousers, Discount on Basic Partner terms' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I click "List" button
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Maximum'            |
	And I click the button named "FormChoose"


	

Scenario: create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'Lomaniti' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Lomaniti'  |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Dress' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
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
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"




Scenario: changing the manual apply of Discount 2 without Vat for test
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 2 without Vat' |
	And I select current line in "List" table
	And Delay 2
	And I set checkbox named "Manually"
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window
