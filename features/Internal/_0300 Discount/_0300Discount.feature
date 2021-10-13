#language: en
@tree
@Positive
@Discount


Feature: special offers

As a sales manager
I want to create a basic system of discounts: price type discount, 5+1 type discount, range discount (manually selected), information message.
For calculating special offers in documents

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _03000 preparation (Discount)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects
	* Tax settings
		When filling in Tax settings for company
	

Scenario: _030001 add Plugin SpecialMessage
	Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#/DataProcessor/SpecialOffer_Message.epf"
	And I click the button named "FormAddExtDataProc"
	And I input "" text in "Path to plugin for test" field
	And I input "ExternalSpecialMessage" text in "Name" field
	And I click Open button of the field named "Description_en"
	And I input "ExternalSpecialMessage" text in the field named "Description_en"
	And I input "ExternalSpecialMessage" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button
	And I wait "Plugins (create)" window closing in 10 seconds
	Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalSpecialMessage"

Scenario: _030002 add Plugin DocumentDiscount
	Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#/DataProcessor/DocumentDiscount.epf"
	And I click the button named "FormAddExtDataProc"
	And I input "" text in "Path to plugin for test" field
	And I input "DocumentDiscount" text in "Name" field
	And I click Open button of the field named "Description_en"
	And I input "DocumentDiscount" text in the field named "Description_en"
	And I input "DocumentDiscount" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button
	And I wait "Plugins (create)" window closing in 10 seconds
	Then I check for the "ExternalDataProc" catalog element with the "Description_en" "DocumentDiscount"

Scenario: _030003 add Plugin SpecialRules
	Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#/DataProcessor/SpecialOfferRules.epf"
	And I click the button named "FormAddExtDataProc"
	And I input "" text in "Path to plugin for test" field
	And I input "ExternalSpecialOfferRules" text in "Name" field
	And I click Open button of the field named "Description_en"
	And I input "ExternalSpecialOfferRules" text in the field named "Description_en"
	And I input "ExternalSpecialOfferRules" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button
	And I wait "Plugins (create)" window closing in 10 seconds
	Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalSpecialOfferRules"

Scenario: _030004 add Plugin RangeDiscount
	Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#/DataProcessor/RangeDiscount.epf"
	And I click the button named "FormAddExtDataProc"
	And I input "" text in "Path to plugin for test" field
	And I input "ExternalRangeDiscount" text in "Name" field
	And I click Open button of the field named "Description_en"
	And I input "ExternalRangeDiscount" text in the field named "Description_en"
	And I input "ExternalRangeDiscount" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button
	And I wait "Plugins (create)" window closing in 10 seconds
	Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalRangeDiscount"


Scenario: _030005 add Plugin FivePlusOne
	* Opening a form to add Plugin
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I click the button named "FormCreate"
	* Add Plugin FivePlusOneType
		And I select external file "#workingDir#/DataProcessor/FivePlusOne.epf"
		And I click the button named "FormAddExtDataProc"
		And I input "" text in "Path to plugin for test" field
		And I input "ExternalFivePlusOne" text in "Name" field
		And I click Open button of the field named "Description_en"
		And I input "ExternalFivePlusOne" text in the field named "Description_en"
		And I input "ExternalFivePlusOne" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	Then I check for the "ExternalDataProc" catalog element with the "Description_en" "ExternalFivePlusOne"


Scenario: _030006 create Special Offer Types (price type)
	When select the plugin to create the type of special offer
	And I input "Discount Price 1" text in the field named "Description_en"
	And I input "Discount Price 1" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	When move on to the Price Type settings
	And I go to line in "List" table
		| 'Description'            |
		| 'Discount Price TRY 1' |
	And I select current line in "List" table
	When save the special offer setting
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Discount Price 1"
	When select the plugin to create the type of special offer
	And I input "Discount Price 2" text in the field named "Description_en"
	And I input "Discount Price 2" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	When move on to the Price Type settings
	And I go to line in "List" table
		| 'Description'            |
		| 'Discount Price TRY 2' |
	And I select current line in "List" table
	When save the special offer setting
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Discount Price 2"
	When select the plugin to create the type of special offer
	And I input "Discount 1 without Vat" text in the field named "Description_en"
	And I input "Discount 1 without Vat" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	When move on to the Price Type settings
	And I go to line in "List" table
		| 'Description'            |
		| 'Discount 1 TRY without VAT' |
	And I select current line in "List" table
	When save the special offer setting
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Discount 1 without Vat"
	When select the plugin to create the type of special offer
	And I input "Discount 2 TRY without VAT" text in the field named "Description_en"
	And I input "Discount 2 TRY without VAT" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	When move on to the Price Type settings
	And I go to line in "List" table
		| 'Description'            |
		| 'Discount 2 TRY without VAT' |
	And I select current line in "List" table
	When save the special offer setting
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Discount 2 TRY without VAT"

Scenario: _030007 create Special Offer Types special message (Notification)
	When choose the plugin to create a special offer type (message)
	And I input "Special Message Notification" text in the field named "Description_en"
	And I input "Special Message Notification" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I select "Notification" exact value from "Message type" drop-down list
	And I input "Message Notification" text in "Message Description_en" field
	And I input "Message Notification" text in "Message Description_tr" field
	When save the special offer setting
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Special Message Notification"


Scenario: _030008 create Special Offer Rule RangeDiscount
	* Selecting external processor to create a special offer rule RangeDiscount
		Given I open hyperlink "e1cib/list/Catalog.SpecialOfferRules"
		And I click the button named "FormCreate"
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'ExternalRangeDiscount' |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		* Filling the rule name
			And I input "Range Discount Basic (Dress)" text in the field named "Description_en"
			And I input "Range Discount Basic (Dress)" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
	* Filling special offer rule: Basic Partner terms TRY, Dress,3
		And I click "Set settings" button
		And I click Select button of "Partner terms" field
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Value" attribute in "ValueList" table
		And I go to line in "List" table
		| 'Description'             |
		| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I finish line editing in "ValueList" table
		And I click "OK" button
		And I click the button named "ItemKeysTableAdd"
		And I click Open button of "Item key" field
		And I click choice button of "Item key" attribute in "ItemKeysTable" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'      |
			| 'S/Yellow' |
		And I click the button named "FormChoose"
		Then "Range discount" window is opened
		And I finish line editing in "ItemKeysTable" table
		And in the table "ItemKeysTable" I click the button named "ItemKeysTableAdd"
		And I click choice button of "Item key" attribute in "ItemKeysTable" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'      |
			| 'XS/Blue' |
		And I click the button named "FormChoose"
		And I click "Save settings" button
		And Delay 10
		And I click "Save and close" button
		And Delay 10
	Then I check for the "SpecialOfferRules" catalog element with the "Description_en" "Range Discount Basic (Dress)"
	* Selecting external processor to create a special offer rule RangeDiscount
		Given I open hyperlink "e1cib/list/Catalog.SpecialOfferRules"
		And I click the button named "FormCreate"
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'ExternalRangeDiscount' |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		* Filling the rule name
			And I input "Range Discount Basic (Trousers)" text in the field named "Description_en"
			And I input "Range Discount Basic (Trousers)" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
	* Filling special offer rule: Basic Partner terms TRY, Trousers
		And I click "Set settings" button
		And I click Select button of "Partner terms" field
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Value" attribute in "ValueList" table
		And I go to line in "List" table
		| 'Description'             |
		| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I finish line editing in "ValueList" table
		And I click "OK" button
		And I click the button named "ItemKeysTableAdd"
		And I click Open button of "Item key" field
		And I click choice button of "Item key" attribute in "ItemKeysTable" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'      |
			| '36/Yellow' |
		And I click the button named "FormChoose"
		And I finish line editing in "ItemKeysTable" table
		And I click "Save settings" button
		And Delay 10
		And I click "Save and close" button
		And Delay 10
	Then I check for the "SpecialOfferRules" catalog element with the "Description_en" "Range Discount Basic (Trousers)"
	

Scenario: _030009 create Special Offer Rule Present Discount
	* Selecting external processor to create a special offer rule 5+1
		Given I open hyperlink "e1cib/list/Catalog.SpecialOfferRules"
		And I click the button named "FormCreate"
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'ExternalFivePlusOne' |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
	* Filling the rule name
		And I input "All items 5+1, Discount on Basic Partner terms" text in the field named "Description_en"
		And I input "All items 5+1 TR, Discount on Basic Partner terms" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save" button
	* Filling special offer rule: Basic Partner terms TRY, all items, 5+1, multiple 
		And I click the button named "FormSetSettings"
		And I click Select button of "Partner terms" field
		And I click the button named "Assortment"
		And I go to line in "List" table
			| Description                   |
			| Personal Partner terms, $ |
		And I select current line in "List" table
		And I go to line in "List" table
			| Description                   |
			| Basic Partner terms, TRY |
		And I select current line in "List" table
		And I click the button named "FormChoose"
		And I close "Partner terms" window
		And I click "OK" button
		And I input "5" text in "Quantity more than" field
		And I input "1" text in "Quantity free" field
		And I change checkbox "For each case"
		And I click Select button of "Item keys" field
		And I click the button named "Assortment"
		Then I select all lines of "List" table
		And I click the button named "FormChoose"
		And I close "Item keys" window
		Then "Value list" window is opened
		And I click "OK" button
		And I click "Save settings" button
		And Delay 10
		And I click "Save and close" button
		And Delay 10
	Then I check for the "SpecialOfferRules" catalog element with the "Description_en" "All items 5+1, Discount on Basic Partner terms"
	* Create rule Basic Partner terms TRY, Dress and Trousers 4+1, multiple
		* Select Plugin for special offer rule 4+1
			Given I open hyperlink "e1cib/list/Catalog.SpecialOfferRules"
			And I click the button named "FormCreate"
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			And I select current line in "List" table
			And I click Open button of the field named "Description_en"
		* Filling the rule name
			And I input "Dress and Trousers 4+1, Discount on Basic Partner terms" text in the field named "Description_en"
			And I input "Dress and Trousers 4+1 TR, Discount on Basic Partner terms" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
		* Filling special offer rule: Basic Partner terms TRY, 4+1, multiple 
			And I click the button named "FormSetSettings"
			And I click Select button of "Partner terms" field
			And I click the button named "Assortment"
			Then "Partner terms" window is opened
			And I go to line in "List" table
				| 'Description'              |
				| 'Personal Partner terms, $' |
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I close "Partner terms" window
			And I click "OK" button
			And I input "4" text in "Quantity more than" field
			And I input "1" text in "Quantity free" field
			And I change checkbox "For each case"
			And I click Select button of "Item keys" field
			And I click the button named "Assortment"
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key'  |
				| 'XS/Blue'   |
			And I click the button named "FormChoose"
			And I go to line in "List" table
				| 'Item key'  |
				| '36/Yellow' |
			And I click the button named "FormChoose"
			And I close "Item keys" window
			And I click "OK" button
			And I click "Save settings" button
			And Delay 10
			And I click "Save and close" button
			And Delay 10
	Then I check for the "SpecialOfferRules" catalog element with the "Description_en" "Dress and Trousers 4+1, Discount on Basic Partner terms"
	* Create rule Basic Partner terms TRY, Dress and Trousers 3+1, not multiple
		* Select Plugin for special offer rule 3+1
			Given I open hyperlink "e1cib/list/Catalog.SpecialOfferRules"
			And I click the button named "FormCreate"
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			And I select current line in "List" table
			And I click Open button of the field named "Description_en"
		* Filling the rule name
			And I input "Dress and Trousers 3+1, Discount on Basic Partner terms" text in the field named "Description_en"
			And I input "Dress and Trousers 3+1 TR, Discount on Basic Partner terms" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
		* Filling special offer rule: Basic Partner terms TRY
			And I click the button named "FormSetSettings"
			And I click Select button of "Partner terms" field
			And I click the button named "Assortment"
			And I go to line in "List" table
				| 'Description'              |
				| 'Personal Partner terms, $' |
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I close "Partner terms" window
			And I click "OK" button
			And I input "3" text in "Quantity more than" field
			And I input "1" text in "Quantity free" field
			And I click Select button of "Item keys" field
			And I click the button named "Assortment"
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key'  |
				| 'XS/Blue'   |
			And I click the button named "FormChoose"
			And I go to line in "List" table
				| 'Item key'  |
				| '36/Yellow' |
			And I click the button named "FormChoose"
			And I close "Item keys" window
			Then "Value list" window is opened
			And I click "OK" button
			And I click "Save settings" button
			And Delay 10
			And I click "Save and close" button
			And Delay 10
	Then I check for the "SpecialOfferRules" catalog element with the "Description_en" "Dress and Trousers 3+1, Discount on Basic Partner terms"


Scenario: _030010 create Special Offer Types special message (DialogBox)
	When choose the plugin to create a special offer type (message)
	And I input "Special Message DialogBox" text in the field named "Description_en"
	And I input "Special Message DialogBox" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I select "DialogBox" exact value from "Message type" drop-down list
	And I input "Message 2" text in "Message Description_en" field
	And I input "Message 2" text in "Message Description_tr" field
	When save the special offer setting
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Special Message DialogBox"
	And I close all client application windows

Scenario: _030011 create Special Offer Types Present Discount
	* Select plugin for special offer 5+1
		Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
		And I click the button named "FormCreate"
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'ExternalFivePlusOne' |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
	* Filling in type name
		And I input "All items 5+1, Discount on Basic Partner terms" text in the field named "Description_en"
		And I input "All items 5+1 TR, Discount on Basic Partner terms" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save" button
	* Filling in type: Basic Partner terms TRY, all items, 5+1, multiple
		And I click the button named "FormSetSettings"
		And Delay 2
		And I click Select button of "Partner terms" field
		And I click the button named "Assortment"
		And I go to line in "List" table
			| 'Description'              |
			| 'Personal Partner terms, $' |
		And I go to line in "List" table
			| 'Description'             |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I close "Partner terms" window
		And I click "OK" button
		And Delay 2
		And I input "5" text in "Quantity more than" field
		And I input "1" text in "Quantity free" field
		And I change checkbox "For each case"
		And I click Select button of "Item keys" field
		And I click the button named "Assortment"
		Then "Item keys" window is opened
		Then I select all lines of "List" table
		And I click the button named "FormChoose"
		And I close "Item keys" window
		And I click "OK" button
		And Delay 2
		And I click "Save settings" button
		And Delay 10
		And I click "Save and close" button
		And Delay 10
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "All items 5+1, Discount on Basic Partner terms"
	* Create type Basic Partner terms TRY, Dress and Trousers 4+1, multiple
		* Select plugin for special offer 4+1
			Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
			And I click the button named "FormCreate"
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			And I select current line in "List" table
			And I click Open button of the field named "Description_en"
		* Filling in type name
			And I input "Dress,2 4+1, Discount on Basic Partner terms" text in the field named "Description_en"
			And I input "Dress,2 4+1 TR, Discount on Basic Partner terms" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
		* Filling in type: Basic Partner terms TRY, all items, 4+1, multiple 
			And I click the button named "FormSetSettings"
			And Delay 2
			And I click Select button of "Partner terms" field
			And I click the button named "Assortment"
			Then "Partner terms" window is opened
			And I go to line in "List" table
				| 'Description'              |
				| 'Personal Partner terms, $' |
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I close "Partner terms" window
			And I click "OK" button
			And Delay 2
			And I input "4" text in "Quantity more than" field
			And I input "1" text in "Quantity free" field
			And I change checkbox "For each case"
			And I click Select button of "Item keys" field
			And I click the button named "Assortment"
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key'  |
				| 'XS/Blue'   |
			And I click the button named "FormChoose"
			And I go to line in "List" table
				| 'Item key'  |
				| '36/Yellow' |
			And I click the button named "FormChoose"
			And I close "Item keys" window
			And I click "OK" button
			And Delay 2
			And I click "Save settings" button
			And Delay 10
			And I click "Save and close" button
			And Delay 10
		Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Dress,2 4+1, Discount on Basic Partner terms"
	* Create type Basic Partner terms TRY, Dress 3+1, not multiple
		* Select plugin for special offer 4+1
			Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
			And I click the button named "FormCreate"
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'                 |
				| 'ExternalFivePlusOne' |
			And I select current line in "List" table
			And I click Open button of the field named "Description_en"
		* Filling in type name
			And I input "Dress,2 3+1, Discount on Basic Partner terms" text in the field named "Description_en"
			And I input "Dress,2 3+1 TR, Discount on Basic Partner terms" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
		* Filling in type: Basic Partner terms TRY, all items, 4+1, multiple
			And I click the button named "FormSetSettings"
			And Delay 2
			And I click Select button of "Partner terms" field
			And I click the button named "Assortment"
			Then "Partner terms" window is opened
			And I go to line in "List" table
				| 'Description'              |
				| 'Personal Partner terms, $' |
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I close "Partner terms" window
			And I click "OK" button
			And Delay 2
			And I input "3" text in "Quantity more than" field
			And I input "1" text in "Quantity free" field
			And I click Select button of "Item keys" field
			And I click the button named "Assortment"
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key'  |
				| 'XS/Blue'   |
			And I click the button named "FormChoose"
			And I go to line in "List" table
				| 'Item key'  |
				| '36/Yellow' |
			And I click the button named "FormChoose"
			And I close "Item keys" window
			And I click "OK" button
			And Delay 2
			And I click "Save settings" button
			And Delay 10
			And I click "Save and close" button
			And Delay 10
		Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Dress,2 3+1, Discount on Basic Partner terms"

Scenario: _030012 create Special Offer Types Range Discount
	* Select plugin for special offer Range Discount
		Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
		And I click the button named "FormCreate"
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'ExternalRangeDiscount' |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
	* Filling in type name
		And I input "Range Discount Basic (Dress)" text in the field named "Description_en"
		And I input "Range Discount Basic (Dress)" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save" button
	* Filling in type: Basic Partner terms TRY, Dress,3
		And I click "Set settings" button
		And in the table "ItemKeysTable" I click the button named "ItemKeysTableAdd"
		And I click choice button of "Item key" attribute in "ItemKeysTable" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I move to the next attribute
		And I input "3" text in "Min percent" field of "ItemKeysTable" table
		And I activate "Max percent" field in "ItemKeysTable" table
		And I input "10" text in "Max percent" field of "ItemKeysTable" table
		And I finish line editing in "ItemKeysTable" table
		And in the table "ItemKeysTable" I click the button named "ItemKeysTableAdd"
		And I click choice button of "Item key" attribute in "ItemKeysTable" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'S/Yellow' |
		And I select current line in "List" table
		And I move to the next attribute
		And I input "4" text in "Min percent" field of "ItemKeysTable" table
		And I activate "Max percent" field in "ItemKeysTable" table
		And I input "8" text in "Max percent" field of "ItemKeysTable" table
		And I finish line editing in "ItemKeysTable" table
		And I click "Save settings" button
		And Delay 2
		And I click "Save and close" button
		And Delay 10
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Range Discount Basic (Dress)"
	* Create Types Range Discount Basic (Trousers)
		* Select plugin for special offer Range Discount
			Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
			And I click the button named "FormCreate"
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'                 |
				| 'ExternalRangeDiscount' |
			And I select current line in "List" table
			And I click Open button of the field named "Description_en"
		* Filling in type name
			And I input "Range Discount Basic (Trousers)" text in the field named "Description_en"
			And I input "Range Discount Basic (Trousers)" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
		* Filling in type: Basic Partner terms TRY, Dress
			And I click "Set settings" button
			And in the table "ItemKeysTable" I click the button named "ItemKeysTableAdd"
			And I click choice button of "Item key" attribute in "ItemKeysTable" table
			And I go to line in "List" table
				| 'Item key'  |
				| '36/Yellow' |
			And I select current line in "List" table
			And I move to the next attribute
			And I input "5" text in "Min percent" field of "ItemKeysTable" table
			And I activate "Max percent" field in "ItemKeysTable" table
			And I input "7" text in "Max percent" field of "ItemKeysTable" table
			And I finish line editing in "ItemKeysTable" table
			And I click "Save settings" button
			And Delay 2
			And I click "Save and close" button
			And Delay 10
	Then I check for the "SpecialOfferTypes" catalog element with the "Description_en" "Range Discount Basic (Trousers)"	


Scenario: _030013 create Special Offer Rules (Partner term)
	When select the plugin to create the rule of special offer
	And I input "Discount on Basic Partner terms" text in the field named "Description_en"
	And I input "Discount on Basic Partner terms" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I input "Partner terms in list " text in "Name" field
	And I select "Partner terms in list" exact value from "Rule type" drop-down list
	And I click Select button of "Partner terms" field
	And Delay 2
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Value" attribute in "ValueList" table
	And I go to line in "List" table
		| 'Description'             |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And Delay 1
	And I finish line editing in "ValueList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Value" attribute in "ValueList" table
	And I go to line in "List" table
		| 'Description'             |
		| 'Retail partner term' |
	And I select current line in "List" table
	And I finish line editing in "ValueList" table
	And I click "OK" button
	When save the special offer setting
	Then I check for the "SpecialOfferRules" catalog element with the "Description_en" "Discount on Basic Partner terms"
	When select the plugin to create the rule of special offer
	And I input "Discount on Basic Partner terms without Vat" text in the field named "Description_en"
	And I input "Discount on Basic Partner terms without Vat" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I select "Partner terms in list" exact value from "Rule type" drop-down list
	And I click Select button of "Partner terms" field
	And Delay 2
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Value" attribute in "ValueList" table
	And I go to line in "List" table
		| 'Description'             |
		| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	And Delay 1
	And I finish line editing in "ValueList" table
	And I click "OK" button
	When save the special offer setting
	Then I check for the "SpecialOfferRules" catalog element with the "Description_en" "Discount on Basic Partner terms"



Scenario: _030014 create Special Offer (group Maximum by row/Special Offers Maximum by row)
	When choose the plugin to create a special offer
	And I input "Special Offers" text in the field named "Description_en"
	And I input "Special Offers" text in the field named "Description_tr"
	And I click "Ok" button
	And I change checkbox "Group types"
	And I click "Save" button
	And I click "Set settings" button
	And Delay 2
	And I select "Maximum by row" exact value from "Type joining" drop-down list
	When save the special offer setting
	And I click the button named "FormChoose"
	And I click Open button of the field named "Description_en"
	And I input "Special Offers" text in the field named "Description_en"
	And I input "Special Offers" text in the field named "Description_tr"
	And I click "Ok" button
	And I input "1" text in "Priority" field
	And I click "Save and close" button
	And Delay 10
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Special Offers"
	When choose the plugin to create a special offer
	And I input "Maximum" text in the field named "Description_en"
	And I input "Maximum" text in the field named "Description_tr"
	And I click "Ok" button
	And I change checkbox "Group types"
	And I click "Save" button
	And I click "Set settings" button
	And Delay 2
	And I select "Maximum by row" exact value from "Type joining" drop-down list
	When save the special offer setting
	And I click the button named "FormChoose"
	And I click Open button of the field named "Description_en"
	And I input "Maximum" text in the field named "Description_en"
	And I input "Maximum" text in the field named "Description_tr"
	And I click "Ok" button
	And I input "3" text in "Priority" field
	And I click "Save and close" button
	And Delay 10
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Maximum"

Scenario: _030015 create Special Offer (group Sum)
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
	And I input "Sum" text in the field named "Description_en"
	And I input "Sum" text in the field named "Description_tr"
	And I click "Ok" button
	And I change checkbox "Group types"
	And I click "Save" button
	And I click "Set settings" button
	And Delay 2
	And I select "Sum" exact value from "Type joining" drop-down list
	When save the special offer setting
	And I click the button named "FormChoose"
	And I click Open button of the field named "Description_en"
	And I input "Sum" text in the field named "Description_en"
	And I input "Sum" text in the field named "Description_tr"
	And I click "Ok" button
	And I input "1" text in "Priority" field
	And I click "Save and close" button
	And Delay 10
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Sum"

Scenario: _030016 create Special Offer (group Minimum )
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
	And I input "Minimum" text in the field named "Description_en"
	And I input "Minimum" text in the field named "Description_tr"
	And I click "Ok" button
	And I change checkbox "Group types"
	And I click "Save" button
	And I click "Set settings" button
	And Delay 2
	And I select "Minimum" exact value from "Type joining" drop-down list
	When save the special offer setting
	And I click the button named "FormChoose"
	And I click Open button of the field named "Description_en"
	And I input "Minimum" text in the field named "Description_en"
	And I input "Minimum" text in the field named "Description_tr"
	And I click "Ok" button
	And I input "2" text in "Priority" field
	And I click "Save and close" button
	And Delay 10
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Minimum"

Scenario: _030017 create Special Offer (manual) Discount Price 1-2 (discount price, group maximum)
	When open a special offer window
	And I go to line in "List" table
		| 'Description'        |
		| 'Discount Price 1' |
	And I select current line in "List" table
	And I input "1" text in "Priority" field
	And I change checkbox "Manually"
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "Discount Price 1" text in the field named "Description_en"
	And I input "Discount Price 1" text in the field named "Description_tr"
	And I click "Ok" button
	And I select "Sales" exact value from "Document type" drop-down list
	When enter the discount period this month
	When add a special offer rule
	And I go to line in "List" table
		| 'Description'                    |
		| 'Discount on Basic Partner terms' |
	When save the rule for a special offer
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And Delay 1
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Maximum'            |
	And I click the button named "FormChoose"
	When open a special offer window
	And I go to line in "List" table
		| 'Description'        |
		| 'Discount Price 2' |
	And I select current line in "List" table
	And I input "2" text in "Priority" field
	And I change checkbox "Manually"
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "Discount Price 2" text in the field named "Description_en"
	And I input "Discount Price 2" text in the field named "Description_tr"
	And I click "Ok" button
	And I select "Sales" exact value from "Document type" drop-down list
	When enter the discount period this month
	When add a special offer rule
	And I go to line in "List" table
		| 'Description'                    |
		| 'Discount on Basic Partner terms' |
	When save the rule for a special offer
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And Delay 1
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Maximum'            |
	And I click the button named "FormChoose"
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Discount Price 1"
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Discount Price 2"

Scenario: _030018 create Special Offer - Special Message (Notification)
	When open a special offer window
	And I go to line in "List" table
		| 'Description'        |
		| 'Special Message Notification' |
	And I select current line in "List" table
	And Delay 2
	And I input "1" text in "Priority" field
	When enter the discount period this month
	And I click Open button of the field named "Description_en"
	And I input "Special Message Notification" text in the field named "Description_en"
	And I input "Special Message Notification" text in the field named "Description_tr"
	And I click "Ok" button
	And I select "Sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	When add a special offer rule
	And I go to line in "List" table
		| 'Description'                    |
		| 'Discount on Basic Partner terms' |
	When save the rule for a special offer
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Special Message Notification"
	Then "Special offers" window is opened
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
	| 'Special offer type' |
	| 'Maximum'            |
	And I click the button named "FormChoose"

Scenario: _030019 create Special Offer - Special Message (DialogBox)
	When open a special offer window
	And I go to line in "List" table
		| 'Description'        |
		| 'Special Message DialogBox' |
	And I select current line in "List" table
	And Delay 2
	And I input "2" text in "Priority" field
	When enter the discount period this month
	And I click Open button of the field named "Description_en"
	And I input "Special Message DialogBox" text in the field named "Description_en"
	And I input "Special Message DialogBox" text in the field named "Description_tr"
	And I click "Ok" button
	And I select "Sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	When add a special offer rule
	And I go to line in "List" table
		| 'Description'                    |
		| 'Discount on Basic Partner terms without Vat' |
	When save the rule for a special offer
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Special Message DialogBox"
	Then "Special offers" window is opened
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
	| 'Special offer type' |
	| 'Maximum'            |
	And I click the button named "FormChoose"


Scenario: _030020 create Special Offer, automatic use Discount Price 1-2 without Vat (discount price, group minimum)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I click the button named "FormCreate"
	And I click Select button of "Special offer type" field
	Then "Special offer types" window is opened
	And I go to line in "List" table
		| 'Description'        |
		| 'Discount 1 without Vat' |
	And I select current line in "List" table
	And I input "3" text in "Priority" field
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "Discount 1 without Vat" text in the field named "Description_en"
	And I input "Discount 1 without Vat" text in the field named "Description_tr"
	And I click "Ok" button
	And I select "Sales" exact value from "Document type" drop-down list
	When enter the discount period this month
	When add a special offer rule
	And I go to line in "List" table
		| 'Description'                    |
		| 'Discount on Basic Partner terms without Vat' |
	When save the rule for a special offer
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I click the button named "FormCreate"
	And I click Select button of "Special offer type" field
	Then "Special offer types" window is opened
	And I go to line in "List" table
		| 'Description'        |
		| 'Discount 2 TRY without VAT' |
	And I select current line in "List" table
	And I input "4" text in "Priority" field
	And I select "Sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "Discount 2 without Vat" text in the field named "Description_en"
	And I input "Discount 2 without Vat" text in the field named "Description_tr"
	And I click "Ok" button
	When enter the discount period this month
	When add a special offer rule
	And I go to line in "List" table
		| 'Description'                    |
		| 'Discount on Basic Partner terms without Vat' |
	When save the rule for a special offer
	When move the Discount 1 without Vat discount to Minimum
	When move the Discount 2 without Vat discount to the Minimum group 
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Discount 2 without Vat"
	Then I check for the "SpecialOffers" catalog element with the "Description_en" "Discount 1 without Vat"


Scenario: _030021 moving special offer from one group to another
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "Hierarchical list" button
	And I go to line in "List" table
		| 'Description' |
		| 'Maximum'   |
	And I select current line in "List" table
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	And I click the button named "FormChoose"
	Then "Special offers" window is opened
	And I move one level up in "List" table
	And I go to line in "List" table
		| 'Description' |
		| 'Minimum'   |
	And I select current line in "List" table
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	Then "Special offers" window is opened
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	And I click the button named "FormChoose"
	When  move the Discount Price 1 to Maximum

Scenario: _030022 create special offer group within another special offer group
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "Hierarchical list" button
	And I go to line in "List" table
		| 'Description' |
		| 'Minimum'   |
	And I select current line in "List" table
	And I click the button named "FormCreateFolder"
	And Delay 2
	And I click Select button of "Special offer type" field
	And I go to line in "List" table
		| Description |
		| Sum         |
	And I select current line in "List" table
	And I input "10" text in "Priority" field
	And I click Open button of the field named "Description_en"
	And I input "Sum in Minimum" text in the field named "Description_en"
	And I input "Sum in Minimum" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And Delay 2
	And I save the value of "Parent" field as "Minimum"
	And the field named "Parent" is equal to "Minimum" variable
	And I click "Save and close" button

Scenario: _030023 moving a special offer inside another special offer (Parent change)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'      |
		| 'Sum in Minimum' |
	And I click "Edit" button
	And I save the value of "Parent" field as "Sum"
	And the field named "Parent" is equal to "Sum" variable
	And I click "Save and close" button
	And I go to line in "List" table
		| 'Description' |
		| 'Minimum'   |
	And I click "Move to folder" button
	Then "Special offers" window is opened
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Special Offers'     |
	And I click the button named "FormChoose"
	Then "Special offers" window is opened
	And I go to line in "List" table
		| 'Description' |
		| 'Maximum'   |
	And I click "Move to folder" button
	Then "Special offers" window is opened
	And I click "List" button
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Special Offers'     |
	And I click the button named "FormChoose"
	Then "Special offers" window is opened
	And I click "List" button
	And I go to line in "List" table
		| 'Description' |
		| 'Sum'            |
	And I click "Move to folder" button
	Then "Special offers" window is opened
	And I go to line in "List" table
		| 'Special offer type' |
		| 'Special Offers'     |
	And I click the button named "FormChoose"
	Then "Special offers" window is opened
	And I click "Move to folder" button
	And I close current window

Scenario: _030024 create special offer Present Discount
	When open a special offer window
	* Filling in special offer 5+1 (manual)
		And I go to line in "List" table
			| 'Description'                                   |
			| 'All items 5+1, Discount on Basic Partner terms' |
		And I select current line in "List" table
		And I input "4" text in "Priority" field
		When enter the discount period this month
		And I change checkbox "Manually"
		And I select "Sales" exact value from "Document type" drop-down list
		And I set checkbox "Launch"
		And in the table "Rules" I click the button named "RulesAdd"
		And I click choice button of "Rule" attribute in "Rules" table
		And I go to line in "List" table
			| 'Description'                                   |
			| 'All items 5+1, Discount on Basic Partner terms' |
		And I select current line in "List" table
		And I finish line editing in "Rules" table
		And I click Open button of the field named "Description_en"
		And I input "All items 5+1, Discount on Basic Partner terms" text in the field named "Description_en"
		And I input "All items 5+1, Discount on Basic Partner terms" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Create  special offer 4+1, multiple
		When open a special offer window
		* Filling in special offer 4+1 (manual)
			And I go to line in "List" table
				| 'Description'                                   |
				| 'Dress,2 4+1, Discount on Basic Partner terms' |
			And I select current line in "List" table
			And I input "4" text in "Priority" field
			When enter the discount period this month
			And I change checkbox "Manually"
			And I select "Sales" exact value from "Document type" drop-down list
			And I set checkbox "Launch"
			And in the table "Rules" I click the button named "RulesAdd"
			And I click choice button of "Rule" attribute in "Rules" table
			And I go to line in "List" table
				| 'Description'                                   |
				| 'Dress and Trousers 4+1, Discount on Basic Partner terms' |
			And I select current line in "List" table
			And I finish line editing in "Rules" table
			And I click Open button of the field named "Description_en"
			And I input "4+1 Dress and Trousers, Discount on Basic Partner terms" text in the field named "Description_en"
			And I input "4+1 Dress and Trousers TR, Discount on Basic Partner terms" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 10
	* Create special offer 3+1, not multiple
		When open a special offer window
		* Filling in special offer 3+1 (manual)
			And I go to line in "List" table
				| 'Description'                                   |
				| 'Dress,2 3+1, Discount on Basic Partner terms' |
			And I select current line in "List" table
			And I input "4" text in "Priority" field
			When enter the discount period this month
			And I change checkbox "Manually"
			And I select "Sales" exact value from "Document type" drop-down list
			And I set checkbox "Launch"
			And in the table "Rules" I click the button named "RulesAdd"
			And I click choice button of "Rule" attribute in "Rules" table
			And I go to line in "List" table
				| 'Description'                                   |
				| 'Dress and Trousers 3+1, Discount on Basic Partner terms' |
			And I select current line in "List" table
			And I finish line editing in "Rules" table
			And I click Open button of the field named "Description_en"
			And I input "3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms" text in the field named "Description_en"
			And I input "3+1 Dress and Trousers (not multiplicity) TR, Discount on Basic Partner terms" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And Delay 10
	* Save verification
		Then I check for the "SpecialOffers" catalog element with the "Description_en" "3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms"
		Then I check for the "SpecialOffers" catalog element with the "Description_en" "4+1 Dress and Trousers, Discount on Basic Partner terms"
		Then I check for the "SpecialOffers" catalog element with the "Description_en" "All items 5+1, Discount on Basic Partner terms"
	* Moving special offers to the group Maximum
		When move the discount All items 5+1, Discount on Basic Partner terms to the group Maximum
		When move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Maximum
		When move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Maximum



Scenario: _030025 create Range Discount
	When open a special offer window
	* Filling in special offer Range Discount Basic (Trousers)
		And I go to line in "List" table
			| 'Description'                                   |
			| 'Range Discount Basic (Trousers)' |
		And I select current line in "List" table
		And I input "4" text in "Priority" field
		When enter the discount period this month
		And I change checkbox "Manually"
		And I select "Sales" exact value from "Document type" drop-down list
		And I change checkbox "Launch"
		And I change checkbox "Manual input value"
		And I change "Type" radio button value to "For row"
		And in the table "Rules" I click the button named "RulesAdd"
		And I click choice button of "Rule" attribute in "Rules" table
		And I go to line in "List" table
			| 'Description'                                   |
			| 'Range Discount Basic (Trousers)' |
		And I select current line in "List" table
		And I finish line editing in "Rules" table
		And I click Open button of the field named "Description_en"
		And I input "Range Discount Basic (Trousers)" text in the field named "Description_en"
		And I input "Range Discount Basic (Trousers)" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	When open a special offer window
	* Filling in special offer Range Discount Basic (Dress)
		And I go to line in "List" table
			| 'Description'                                   |
			| 'Range Discount Basic (Dress)' |
		And I select current line in "List" table
		And I input "4" text in "Priority" field
		When enter the discount period this month
		And I change checkbox "Manually"
		And I select "Sales" exact value from "Document type" drop-down list
		And I change checkbox "Launch"
		And I change checkbox "Manual input value"
		And I change "Type" radio button value to "For row"
		And in the table "Rules" I click the button named "RulesAdd"
		And I click choice button of "Rule" attribute in "Rules" table
		And I go to line in "List" table
			| 'Description'                                   |
			| 'Range Discount Basic (Dress)' |
		And I select current line in "List" table
		And I finish line editing in "Rules" table
		And I click Open button of the field named "Description_en"
		And I input "Range Discount Basic (Dress)" text in the field named "Description_en"
		And I input "Range Discount Basic (Dress)" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Save verification
		Then I check for the "SpecialOffers" catalog element with the "Description_en" "Range Discount Basic (Dress)"
		Then I check for the "SpecialOffers" catalog element with the "Description_en" "Range Discount Basic (Trousers)"
		And I close current window

Scenario: _030026 create Document discount
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreate"
	And I input "Document discount" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Document discount TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I select "Purchases and sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	And I click Select button of "Special offer type" field
	And I click the button named "FormCreate"
	And I input "Document discount" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Document discount TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click Select button of "Plugins" field
	Then "Plugins" window is opened
	And I go to line in "List" table
		| Description               |
		| ExternalSpecialOfferRules |
	And I go to line in "List" table
		| Description      |
		| DocumentDiscount |
	And I select current line in "List" table
	And I click "Save and close" button
	And I wait "Special offer type (create) *" window closing in 20 seconds
	Then "Special offer types" window is opened
	And I click the button named "FormChoose"
	And I input "5" text in "Priority" field
	And I input current date in "Start of" field
	And I change checkbox "Manually"
	And I change checkbox "Manual input value"
	And I click "Save and close" button
	And I wait "Special offer (create) *" window closing in 20 seconds
