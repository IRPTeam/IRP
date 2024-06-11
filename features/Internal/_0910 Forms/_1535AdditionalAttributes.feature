#language: en
@tree
@Positive

@AdditionalAttributes

Feature: additional attributes check


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _0153500 preparation
	When set True value to the constant
	When set True value to the constant Use accounting
	And Delay 1
	When set True value to the constant Use salary
	When set True value to the constant Use fixed assets
	And Delay 1
	When set True value to the constant Use commission trading
	* Load info
		When Create catalog Countries objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create catalog Partners objects (Kalipso)
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
		When Create catalog ObjectStatuses objects
		When Create catalog ObjectStatuses objects (cheque bond)
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog AddAttributeAndProperty (boolean)
		When Create chart of characteristic types AddAttributeAndProperty objects (collection)
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
		When Create catalog Projects objects
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog ChequeBonds objects
		When Create catalog CashAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog BankTerms objects
		When Create catalog Incoterms objects
		When Create catalog SpecialOfferRules objects (Test)
		When Create catalog SpecialOfferTypes objects (Test)
		When Create catalog SpecialOffers objects (Test)
		When Create catalog CashStatementStatuses objects (Test)
		When Create catalog Hardware objects  (Test)
		When Create catalog Workstations objects  (Test)
		When Create catalog ItemSegments objects
		When Create catalog PaymentTypes objects
		When Create information register Taxes records (VAT)
	* Load additional attribute hyperlink
		When Create catalog AddAttributeAndProperty (hyperlink)

Scenario: _01535001 check preparation
	When check preparation


Scenario: _0154001 check that additional attributes and properties are displayed on the form without reopening (catalog Item key)
	* Create item type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click Open button of "ENG" field
		And I input "Test TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Create item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click Open button of "ENG" field
		And I input "Test TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| Description    |
			| pcs            |
		And I select current line in "List" table
	* Open item key and check that additional properties are not displayed on it (not specified in the item type)
		And In this window I click command interface button "Item keys"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click the button named "FormCreate"
		Then the form attribute named "Item" became equal to "Test"
		Then the form attribute named "ItemType" became equal to "Test"
		Then the form attribute named "InheritUnit" became equal to "pcs"
		Then the form attribute named "SpecificationMode" became equal to "No"
	* Add a new attribute to the item type without re-open the form
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table	
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I click the button named "FormChoose"
		And I finish line editing in "AvailableAttributes" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form for item key
		When I click command interface button "Test (Item)"
		And field "Test" is present on the form
	And I close all client application windows


Scenario: _0154002 check that additional attributes and properties and properties are displayed on the form without reopening (catalog Item)
	Then I check for the "Items" catalog element with the "Description_en" "Test"
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open Item form
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected Item additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Items           |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I activate "UI group" field in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| Description         |
			| Main information    |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
		When I click command interface button "Test (Item)"
	* Check that the additional Test attribute and properties has been displayed on the form
		And field "Test" is present on the form
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _0154003 check that additional attributes and properties are displayed on the form without reopening (catalog Item type)
	Then I check for the "ItemTypes" catalog element with the "Description_en" "Test"
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open Item form type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected Item type additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_ItemTypes       |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Item types" text in the field named "Description_en"
		And I click "Save and close" button
		When I click command interface button "Item types"
	* Check that the additional Test attribute has been displayed on the form
		And field "Test" is present on the form
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows
		

Scenario: _0154004 check that additional attributes and properties are displayed on the form without reopening (catalog Partners)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I set checkbox "Customer"
		And I click "Save and close" button
	* Open Partners form
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected Partners additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Partners        |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| Description         |
			| Main information    |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Test (Partner)"
		And field "Test" is present on the form
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
	And I close all client application windows


Scenario: _01540050 check that additional attributes and properties are displayed on the form without reopening (catalog User groups)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Catalog_UserGroups
		Given I open hyperlink "e1cib/list/Catalog.UserGroups"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_UserGroups      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "UserGroups" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "User groups"
		And field "Test" is present on the form
		And I close current window
	And I close all client application windows


Scenario: _01540051 check that additional attributes and properties are displayed on the form without reopening (document InternalSupplyRequest)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding by selected additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name              |
			| Document_InternalSupplyRequest    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "InternalSupplyRequest" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Internal supply request (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'       | 'Test 1'    |
	And I close all client application windows

Scenario: _01540052 check that additional attributes and properties are displayed on the form without reopening (document DebitNote)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create DebitNote
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding by selected Sales invoice additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Document_DebitNote'      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "DebitNote" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Debit note (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'       | 'Test 1'    |
	And I close all client application windows

Scenario: _01540053 check that additional attributes and properties are displayed on the form without reopening (document CreditNote)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create CreditNote
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding by selected Sales invoice additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Document_CreditNote'     |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "CreditNote" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Credit note (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'       | 'Test 1'    |
	And I close all client application windows

Scenario: _01540054 check that additional attributes and properties are displayed on the form without reopening (Catalog_Workstations)
	And I close all client application windows
	* Open a form to create Catalog_Workstations
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Workstations    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Workstations" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Workstations"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Test'           |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
	And I close all client application windows


Scenario: _01540055 check that additional attributes and properties are displayed on the form without reopening (Catalog_Hardware)
	And I close all client application windows
	* Open a form to create Catalog_Hardware
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I click the button named "FormCreate"
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Hardware        |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Hardware" text in the field named "Description_en"
		And I click "Save" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Hardware"
		And I activate "Hardware (create)" form
		Then the form attribute named "__a154" became equal to ""
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Test'           |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _01540056 check that additional attributes and properties are displayed on the form without reopening (Catalog_CashStatementStatuses)
	And I close all client application windows
	* Open a form to create Catalog_CashStatementStatuses
		Given I open hyperlink "e1cib/list/Catalog.CashStatementStatuses"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name             |
			| Catalog_CashStatementStatuses    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "CashStatementStatuses" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Cash statement statuses"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description' |
			| 'Test'        |	
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
	And I close all client application windows

Scenario: _0154006 check that additional attributes and properties are displayed on the form without reopening (document Sales invoice)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Sales Invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding by selected Sales invoice additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name     |
			| Document_SalesInvoice    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Sales invoice" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Sales invoice (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows

Scenario: _01540060 check that additional attributes and properties are displayed on the form without reopening (document PurchaseInvoice)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PurchaseInvoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Document_PurchaseInvoice    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Purchase Invoice" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Purchase invoice (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows

Scenario: _01540061 check that additional attributes and properties are displayed on the form without reopening (document SalesOrder)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create SalesOrder
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_SalesOrder     |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Sales Order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Sales order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'       | 'Test 1'    |
	And I close all client application windows

Scenario: _01540062 check that additional attributes and properties are displayed on the form without reopening (document Purchase Order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PurchaseOrder
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name      |
			| Document_PurchaseOrder    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Purchase Order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Purchase order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'       | 'Test 1'    |
	And I close all client application windows


Scenario: _01540057 check that additional attributes and properties are displayed on the form without reopening (Catalog_ExpenseAndRevenueTypes)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Catalog_ExpenseAndRevenueTypes
		Given I open hyperlink "e1cib/list/Catalog.ExpenseAndRevenueTypes"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name              |
			| Catalog_ExpenseAndRevenueTypes    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'           |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Expense and revenue types" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Expense and revenue types"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Rent'           |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _01540063 check that additional attributes and properties are displayed on the form without reopening (Catalog_BusinessUnits)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Catalog_BusinessUnits
		Given I open hyperlink "e1cib/list/Catalog.BusinessUnits"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name     |
			| Catalog_BusinessUnits    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Business units" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Business units"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _01540058 check adding additional properties for Specifications (Catalog_Specifications)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name      |
			| Catalog_Specifications    |
		And I select current line in "List" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| Description    |
			| Test 1         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Specifications" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table contains lines
		| 'Property'  | 'Value'   |
		| 'Test 1'    | ''        |
	And I close all client application windows


Scenario: _015400640 check that additional attributes and properties are displayed on the form without reopening (Catalog_Agreements)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Partner terms
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Agreements      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Partner terms" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Partner terms"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows



Scenario: _015400641 check that additional attributes and properties are displayed on the form without reopening (Catalog_Cash/Bank accounts)
Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create CashAccounts
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_CashAccounts    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cash/Bank accounts" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Cash/Bank accounts"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №1'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400642 check that additional attributes and properties are displayed on the form without reopening (Catalog_Companies)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Companies
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Companies       |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Companies" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Companies"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'        |
			| 'Company Kalipso'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400644 check that additional attributes and properties are displayed on the form without reopening (Catalog_Countries)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Countries
		Given I open hyperlink "e1cib/list/Catalog.Countries"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Countries       |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Countries" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Countries"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Turkey'         |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400645 check that additional attributes and properties are displayed on the form without reopening (Catalog_Currencies)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Currencies
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Currencies      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Currencies" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Currencies"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400646 check that additional attributes and properties are displayed on the form without reopening (Catalog_Price types)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PriceTypes
		Given I open hyperlink "e1cib/list/Catalog.PriceTypes"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_PriceTypes      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Price types" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Price types"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'          |
			| 'Basic Price Types'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400647 check that additional attributes and properties are displayed on the form without reopening (Catalog_Item serial/lot number)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create SerialLotNumbers
		Given I open hyperlink "e1cib/list/Catalog.SerialLotNumbers"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Catalog_SerialLotNumbers    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Item serial/lot number" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Item serial/lot numbers"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Serial number'    |
			| '12345456'         |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400648 check that additional attributes and properties are displayed on the form without reopening (Catalog_Stores)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Stores
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Stores          |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Stores" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Stores"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400649 check that additional attributes and properties are displayed on the form without reopening (Catalog_Taxes)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Tax types
		Given I open hyperlink "e1cib/list/Catalog.Taxes"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Taxes           |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Tax types" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Tax types"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'VAT'            |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400650 check that additional attributes and properties are displayed on the form without reopening (Catalog_Units)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to createItem units
		Given I open hyperlink "e1cib/list/Catalog.Units"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Units           |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Units" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Item units"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows



Scenario: _015400651 check that additional attributes and properties are displayed on the form without reopening (Catalog_Users)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Users
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Users           |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Users" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Users"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400652 check that additional attributes and properties are displayed on the form without reopening (document Bank payment)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create BankPayment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_BankPayment    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Bank payment" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Bank payment (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400653 check that additional attributes and properties are displayed on the form without reopening (document Bank receipt)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create BankReceipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_BankReceipt    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Bank receipt" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Bank receipt (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400655 check that additional attributes and properties are displayed on the form without reopening (document Bundling)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_Bundling       |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Bundling" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Bundling (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400656 check that additional attributes and properties are displayed on the form without reopening (document Cash expense)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create CashExpense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_CashExpense    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cash expense" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cash expense (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400657 check that additional attributes and properties are displayed on the form without reopening (document Cash payment)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create CashPayment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_CashPayment    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cash payment" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cash payment (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows



Scenario: _015400658 check that additional attributes and properties are displayed on the form without reopening (document Cash receipt)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create CashReceipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_CashReceipt    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cash receipt" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cash receipt (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows




Scenario: _015400659 check that additional attributes and properties are displayed on the form without reopening (document Cash revenue)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create CashRevenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_CashRevenue    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cash revenue" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cash revenue (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400660 check that additional attributes and properties are displayed on the form without reopening (document Cash transfer order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Document_CashTransferOrder    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cash transfer order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cash transfer order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400662 check that additional attributes and properties are displayed on the form without reopening (document Goods receipt)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name     |
			| Document_GoodsReceipt    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Goods receipt" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Goods receipt (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows



Scenario: _015400663 check that additional attributes and properties are displayed on the form without reopening (document Incoming payment order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create IncomingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name             |
			| Document_IncomingPaymentOrder    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Incoming payment order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Incoming payment order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400664 check that additional attributes and properties are displayed on the form without reopening (document Inventory transfer)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Document_InventoryTransfer    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Inventory transfer" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Inventory transfer (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400665 check that additional attributes and properties are displayed on the form without reopening (document Inventory transfer order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name               |
			| Document_InventoryTransferOrder    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Inventory transfer order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Inventory transfer order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows





Scenario: _015400668 check that additional attributes and properties are displayed on the form without reopening (document Labeling)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Labeling
		Given I open hyperlink "e1cib/list/Document.Labeling"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_Labeling       |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Labeling" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Labeling (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400669 check that additional attributes and properties are displayed on the form without reopening (document Opening entry)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create OpeningEntry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name     |
			| Document_OpeningEntry    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Opening entry" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Opening entry (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows

Scenario: _015400670 check that additional attributes and properties are displayed on the form without reopening (document Outgoing payment order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create OutgoingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name             |
			| Document_OutgoingPaymentOrder    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Outgoing payment order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Outgoing payment order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400671 check that additional attributes and properties are displayed on the form without reopening (document Physical count by location)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name                |
			| Document_PhysicalCountByLocation    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Physical count by location" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Location count (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		# And I select current line in "List" table	
		# And I click "Save" button
		# And I click "Add properties" button
		# And "Properties" table became equal
		# 	| 'Property' | 'Value' |
		# 	| 'Test'     | ''      |	
	And I close all client application windows


Scenario: _015400672 check that additional attributes and properties are displayed on the form without reopening (document Physical inventory)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Document_PhysicalInventory    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Physical inventory" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Physical inventory (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400673 check that additional attributes and properties are displayed on the form without reopening (document Price list)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PriceList
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_PriceList      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Price list" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Price list (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows



Scenario: _015400674 check that additional attributes and properties are displayed on the form without reopening (document Purchase return)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PurchaseReturn
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Document_PurchaseReturn    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Purchase return" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Purchase return (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows



Scenario: _015400675 check that additional attributes and properties are displayed on the form without reopening (document Purchase return order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PurchaseReturnOrder
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name            |
			| Document_PurchaseReturnOrder    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Purchase return order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Purchase return order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows




Scenario: _015400676 check that additional attributes and properties are displayed on the form without reopening (document Reconciliation statement)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create ReconciliationStatement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name                |
			| Document_ReconciliationStatement    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Reconciliation statement" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Reconciliation statement (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows



Scenario: _015400677 check that additional attributes and properties are displayed on the form without reopening (document Sales return)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_SalesReturn    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Sales return" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Sales return (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400678 check that additional attributes and properties are displayed on the form without reopening (document Sales return order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name         |
			| Document_SalesReturnOrder    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Sales return order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Sales return order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows



Scenario: _015400679 check that additional attributes and properties are displayed on the form without reopening (document Shipment confirmation)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create ShipmentConfirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name             |
			| Document_ShipmentConfirmation    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Shipment confirmation" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Shipment confirmation (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400680 check that additional attributes and properties are displayed on the form without reopening (document Stock adjustment as surplus)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name                 |
			| Document_StockAdjustmentAsSurplus    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Stock adjustment as surplus" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Stock adjustment as surplus (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows

Scenario: _015400681 check that additional attributes and properties are displayed on the form without reopening (document Stock adjustment as write-off)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name                  |
			| Document_StockAdjustmentAsWriteOff    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Stock adjustment as write off" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Stock adjustment as write-off (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400683 check that additional attributes and properties are displayed on the form without reopening (document Unbundling)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_Unbundling     |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Unbundling" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Unbundling (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows

Scenario: _015400684 check that additional attributes and properties are displayed on the form without reopening (document Retail sales receipt)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Unbundling
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_RetailSalesReceipt    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "RetailSalesReceipt" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Retail sales receipt (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400685 check that additional attributes and properties are displayed on the form without reopening (document Retail return receipt)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Unbundling
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name            |
			| Document_RetailReturnReceipt    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "RetailReturnReceipt" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Retail return receipt (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows

Scenario: _015400687 check that additional attributes and properties are displayed on the form without reopening (document Cash statement)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Unbundling
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name      |
			| Document_CashStatement    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cash statement" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cash statement (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows

Scenario: _015400688 check that additional attributes and properties are displayed on the form without reopening (Catalog_PaymentTerminals)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Payment terminals
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Catalog_PaymentTerminals    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "PaymentTerminals" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Payment terminals"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button	
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400689 check that additional attributes and properties are displayed on the form without reopening (Catalog_RetailCustomers)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Retail customers
		Given I open hyperlink "e1cib/list/Catalog.RetailCustomers"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_RetailCustomers    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "RetailCustomers" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Retail customers"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'      |
			| 'Test01 Test01'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400690 check that additional attributes and properties are displayed on the form without reopening (Catalog_BankTerms)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create BankTerms
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_BankTerms       |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "BankTerms" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Bank terms"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Test01'         |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400691 check that additional attributes and properties are displayed on the form without reopening (Catalog_SpecialOffers)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create SpecialOffers
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name     |
			| Catalog_SpecialOffers    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "SpecialOffers" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Special offers"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'             |
			| 'Test special offer01'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400692 check that additional attributes and properties are displayed on the form without reopening (Catalog_SpecialOfferRules)
	And I close all client application windows
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create SpecialOfferRules
		Given I open hyperlink "e1cib/list/Catalog.SpecialOfferRules"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name         |
			| Catalog_SpecialOfferRules    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "SpecialOfferRules" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Special offer rules"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'                |
			| 'Test special offer rule'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400693 check that additional attributes and properties are displayed on the form without reopening (Catalog_SpecialOfferType)
	And I close all client application windows
	* Open a form to create SpecialOfferType
		Given I open hyperlink "e1cib/list/Catalog.SpecialOfferTypes"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'         |
			| 'Catalog_SpecialOfferTypes'    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "SpecialOfferType" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Special offer types"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'             |
			| 'Test special offer01'    |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400694 check that additional attributes and properties are displayed on the form without reopening (Catalog_ItemSegments)
	And I close all client application windows
	* Open a form to create ItemSegments
		Given I open hyperlink "e1cib/list/Catalog.ItemSegments"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_ItemSegments    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "ItemSegments" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Item segments"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Sale autum'     |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400695 check that additional attributes and properties are displayed on the form without reopening (Catalog_TaxRates)
	And I close all client application windows
	* Open a form to create TaxRates
		Given I open hyperlink "e1cib/list/Catalog.TaxRates"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_TaxRates        |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "TaxRates" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Tax rates"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| '8%'             |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400696 check that additional attributes and properties are displayed on the form without reopening (Catalog_PaymentTypes)
	And I close all client application windows
	* Open a form to create PaymentTypes
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_PaymentTypes    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "PaymentTypes" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Payment types"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400698 check that additional attributes and properties are displayed on the form without reopening (Catalog_PartnerSegments)
	And I close all client application windows
	* Open a form to create PartnerSegments
		Given I open hyperlink "e1cib/list/Catalog.PartnerSegments"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_PartnerSegments    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "PartnerSegments" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Partner segments"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'Retail'         |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400699 check that additional attributes and properties are displayed on the form without reopening (document PlannedReceiptReservation)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create PlannedReceiptReservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name                  |
			| Document_PlannedReceiptReservation    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Planned receipt reservation" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Planned receipt reservation (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400700 check that additional attributes and properties are displayed on the form without reopening (document SalesOrderClosing)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create SalesOrderClosing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Document_SalesOrderClosing    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Sales order closing" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Sales order closing (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400701 check that additional attributes and properties are displayed on the form without reopening (document ItemStockAdjustment)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create ItemStockAdjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name            |
			| Document_ItemStockAdjustment    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Item stock adjustment" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Item stock adjustment (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
		And I close "Edit add properties" window
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'     |
			| 'Test 1'     | 'Test 1'    |
	And I close all client application windows


Scenario: _015400702 check that additional attributes and properties are displayed on the form without reopening (document Money transfer)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create MoneyTransfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name      |
			| Document_MoneyTransfer    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Money transfer" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Money transfer (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
	And I close all client application windows


Scenario: _015400703 check that additional attributes and properties are displayed on the form without reopening (document Manual register entries)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create ManualRegisterEntry
		Given I open hyperlink "e1cib/list/Document.ManualRegisterEntry"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name            |
			| Document_ManualRegisterEntry    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Manual register entry" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Manual register entry (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
	And I close all client application windows

Scenario: _015400704 check that additional attributes and properties are displayed on the form without reopening (catalog LegalNameContracts)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create LegalNameContracts
		Given I open hyperlink "e1cib/list/Catalog.LegalNameContracts"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description"
		And I click "Save and close" button
	* Open LegalNameContracts form
		Given I open hyperlink "e1cib/list/Catalog.LegalNameContracts"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected LegalNameContracts additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Catalog_LegalNameContracts    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Legal name contracts"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400705 check that additional attributes and properties are displayed on the form without reopening (catalog CancelReturnReasons)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create CancelReturnReasons
		Given I open hyperlink "e1cib/list/Catalog.CancelReturnReasons"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open CancelReturnReasons form
		Given I open hyperlink "e1cib/list/Catalog.CancelReturnReasons"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected CancelReturnReasons additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Catalog_CancelReturnReasons    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cancel/Return reasons"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400706 check that additional attributes and properties are displayed on the form without reopening (catalog ExternalDataProc)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create ExternalDataProc
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I input "Test" text in the field named "Name"
		And I click "Save and close" button
	* Open ExternalDataProc form
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected ExternalDataProc additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Catalog_ExternalDataProc    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Plugins"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400707 check that additional attributes and properties are displayed on the form without reopening (catalog AccessProfiles)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create AccessProfiles
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open AccessProfiles form
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected AccessProfiles additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name      |
			| Catalog_AccessProfiles    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "User access profiles"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400708 check that additional attributes and properties are displayed on the form without reopening (catalog FileStorageVolumes)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create FileStorageVolumes
		Given I open hyperlink "e1cib/list/Catalog.FileStorageVolumes"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description"
		And I click "Save and close" button
	* Open FileStorageVolumes form
		Given I open hyperlink "e1cib/list/Catalog.FileStorageVolumes"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected FileStorageVolumes additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Catalog_FileStorageVolumes    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "File storage volumes"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400709 check that additional attributes and properties are displayed on the form without reopening (catalog FileStoragesInfo)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create FileStoragesInfo
		Given I open hyperlink "e1cib/list/Catalog.FileStoragesInfo"
		And I click the button named "FormCreate"
		And I input "Test" text in "Path to catalog at server" field
		And I click "Save and close" button
	* Open FileStoragesInfo form
		Given I open hyperlink "e1cib/list/Catalog.FileStoragesInfo"
		And I go to line in "List" table
			| Path to catalog at server    |
			| Test                         |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected FileStoragesInfo additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Catalog_FileStoragesInfo    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "File storages info"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400710 check that additional attributes and properties are displayed on the form without reopening (catalog LedgerTypeVariants)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create LedgerTypeVariants
		Given I open hyperlink "e1cib/list/Catalog.LedgerTypeVariants"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open LedgerTypeVariants form
		Given I open hyperlink "e1cib/list/Catalog.LedgerTypeVariants"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected LedgerTypeVariants additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Catalog_LedgerTypeVariants    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Ledger type variants"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400711 check that additional attributes and properties are displayed on the form without reopening (catalog IntegrationSettings)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create IntegrationSettings
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description"
		And I click "Save and close" button
	* Open IntegrationSettings form
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
	* Adding by selected IntegrationSettings additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Catalog_IntegrationSettings    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Integration settings"
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400712 check that additional attributes and properties are displayed on the form without reopening (catalog EquipmentDrivers)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create EquipmentDrivers
		Given I open hyperlink "e1cib/list/Catalog.EquipmentDrivers"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description"
		And I input "11.2" text in "AddIn ID" field	
		And I click "Save and close" button
	* Open EquipmentDrivers form
		Given I open hyperlink "e1cib/list/Catalog.EquipmentDrivers"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected EquipmentDrivers additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Catalog_EquipmentDrivers    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Equipment drivers"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400713 check that additional attributes and properties are displayed on the form without reopening (catalog PlanningPeriods)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create PlanningPeriods
		Given I open hyperlink "e1cib/list/Catalog.PlanningPeriods"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description"
		And I click "Save and close" button
	* Open PlanningPeriods form
		Given I open hyperlink "e1cib/list/Catalog.PlanningPeriods"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected PlanningPeriods additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_PlanningPeriods    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Planning periods"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400714 check that additional attributes and properties are displayed on the form without reopening (catalog PaymentSchedules)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create PaymentSchedules
		Given I open hyperlink "e1cib/list/Catalog.PaymentSchedules"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open PaymentSchedules form
		Given I open hyperlink "e1cib/list/Catalog.PaymentSchedules"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected PaymentSchedules additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Catalog_PaymentSchedules    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Payment terms"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400715 check that additional attributes and properties are displayed on the form without reopening (catalog ObjectStatuses)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create ObjectStatuses
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I expand current line in "List" table
		And I go to line in "List" table
			| 'Description'             |
			| 'IncomingPaymentOrder'    |
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open ObjectStatuses form
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected ObjectStatuses additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name      |
			| Catalog_ObjectStatuses    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Objects statuses"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400717 check that additional attributes and properties are displayed on the form without reopening (catalog AccessGroups)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create AccessGroups
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open AccessGroups form
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected AccessGroups additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_AccessGroups    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "User access groups"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'       | ''         |
	And I close all client application windows

Scenario: _015400718 check that additional attributes and properties are displayed on the form without reopening (catalog TaxAnalytics)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create TaxAnalytics
		Given I open hyperlink "e1cib/list/Catalog.TaxAnalytics"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open TaxAnalytics form
		Given I open hyperlink "e1cib/list/Catalog.TaxAnalytics"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected TaxAnalytics additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_TaxAnalytics    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Tax additional analytics"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400719 check that additional attributes and properties are displayed on the form without reopening (catalog UnitsOfMeasurement)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create UnitsOfMeasurement
		Given I open hyperlink "e1cib/list/Catalog.UnitsOfMeasurement"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open UnitsOfMeasurement form
		Given I open hyperlink "e1cib/list/Catalog.UnitsOfMeasurement"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected UnitsOfMeasurement additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name          |
			| Catalog_UnitsOfMeasurement    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Units of measurement"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400720 check that additional attributes and properties are displayed on the form without reopening (catalog AccountingOperations)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create AccountingOperations
		Given I open hyperlink "e1cib/list/Catalog.AccountingOperations"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open AccountingOperations form
		Given I open hyperlink "e1cib/list/Catalog.AccountingOperations"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected AccountingOperations additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name            |
			| Catalog_AccountingOperations    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Accounting operations"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400721 check that additional attributes and properties are displayed on the form without reopening (catalog InterfaceGroups)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create InterfaceGroups
		Given I open hyperlink "e1cib/list/Catalog.InterfaceGroups"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open InterfaceGroups form
		Given I open hyperlink "e1cib/list/Catalog.InterfaceGroups"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected InterfaceGroups additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_InterfaceGroups    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "UI groups"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400722 check that additional attributes and properties are displayed on the form without reopening (catalog EmployeeSchedule)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create EmployeeSchedule
		Given I open hyperlink "e1cib/list/Catalog.EmployeeSchedule"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I select "Day" exact value from the drop-down list named "Type"
		And I click "Save and close" button
	* Open EmployeeSchedule form
		Given I open hyperlink "e1cib/list/Catalog.EmployeeSchedule"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected EmployeeSchedule additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_EmployeeSchedule    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Employee schedule"
		// When I click command interface button "UI groups"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400723 check that additional attributes and properties are displayed on the form without reopening (catalog EmployeePositions)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create EmployeePositions
		Given I open hyperlink "e1cib/list/Catalog.EmployeePositions"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open EmployeePositions form
		Given I open hyperlink "e1cib/list/Catalog.EmployeePositions"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected EmployeePositions additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_EmployeePositions    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		// When I click command interface button "UI groups"
		When in opened panel I select "Employee positions"	
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400724 check that additional attributes and properties are displayed on the form without reopening (catalog AccrualAndDeductionTypes)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create AccrualAndDeductionTypes
		Given I open hyperlink "e1cib/list/Catalog.AccrualAndDeductionTypes"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I select "Accrual" exact value from the drop-down list named "Type"		
		And I click "Save and close" button
	* Open AccrualAndDeductionTypes form
		Given I open hyperlink "e1cib/list/Catalog.AccrualAndDeductionTypes"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected AccrualAndDeductionTypes additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_AccrualAndDeductionTypes    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		// When I click command interface button "UI groups"
		When in opened panel I select "Accrual and deduction types"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400725 check that additional attributes and properties are displayed on the form without reopening (catalog SalaryCalculationType)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create SalaryCalculationType
		Given I open hyperlink "e1cib/list/Catalog.SalaryCalculationType"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click "Save and close" button
	* Open SalaryCalculationType form
		Given I open hyperlink "e1cib/list/Catalog.SalaryCalculationType"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected SalaryCalculationType additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_SalaryCalculationType    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Salary calculation types"
		// When I click command interface button "UI groups"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _01540064 check that additional attributes and properties are displayed on the form without reopening (Catalog_ChequeBonds)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Catalog_ChequeBonds
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_ChequeBonds     |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cheque Bonds" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Cheque bonds"
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Cheque No'       |
			| 'Own cheque 1'    |
		And I select current line in "List" table
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I input "100,00" text in the field named "Amount"
		And I click "Save" button	
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400661 check that additional attributes and properties are displayed on the form without reopening (document Cheque bond transaction)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name              |
			| Document_ChequeBondTransaction    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Cheque bond transaction" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Cheque bond transaction (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400662 check that additional attributes and properties are displayed on the form without reopening (document Work order)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_WorkOrder      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Work order" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Work order (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400663 check that additional attributes and properties are displayed on the form without reopening (document Work sheet)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_WorkSheet      |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Work sheet" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Work sheet (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400664 check that additional attributes and properties are displayed on the form without reopening (Catalog_BillOfMaterials)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Create BillOfMaterials
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I click the button named "FormCreate"
		And I input "Test" text in the field named "Description_en"
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I click Choice button of the field named "ItemKey"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '38/18SD'     |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Accountants office'    |
		And I select current line in "List" table		
		And I click "Save and close" button
	* Open BillOfMaterials form
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And field "Test" is not present on the form
	* Adding by selected BillOfMaterials additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name       |
			| Catalog_BillOfMaterials    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Bill of materials"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _0154006831 check that additional attributes and properties are displayed on the form without reopening (Catalog_Incoterms)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Incoterms
		Given I open hyperlink "e1cib/list/Catalog.Incoterms"
		And I click the button named "FormCreate"
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Catalog_Incoterms       |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Incoterms" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When in opened panel I select "Incoterms"
		And I activate "Incoterm (create)" window 
		And field "Test" is present on the form
		And I close current window
		And I go to line in "List" table
			| 'Description'    |
			| 'CIF'            |
		And I select current line in "List" table
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400665 check that additional attributes and properties are displayed on the form without reopening (document SalesReportFromTradeAgent)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Sales report from trade agent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name                  |
			| Document_SalesReportFromTradeAgent    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Sales report from trade agent" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Sales report from trade agent (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400666 check that additional attributes and properties are displayed on the form without reopening (document SalesReportToConsignor)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name               |
			| Document_SalesReportToConsignor    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Sales report to consignor" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Sales report to consignor (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows



Scenario: _015400667 check that additional attributes and properties are displayed on the form without reopening (document Retail shipment confirmation)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name                   |
			| Document_RetailShipmentConfirmation    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Retail shipment confirmation" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Retail shipment confirmation (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows


Scenario: _015400668 check that additional attributes and properties are displayed on the form without reopening (document Retail goods receipt)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_RetailGoodsReceipt    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Retail goods receipt" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Retail goods receipt (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400671 check that additional attributes and properties are displayed on the form without reopening (document Employee firing)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Employee firing
		Given I open hyperlink "e1cib/list/Document.EmployeeFiring"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_EmployeeFiring    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Employee firing" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Employee firing (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400672 check that additional attributes and properties are displayed on the form without reopening (document Employee hiring)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Employee hiring
		Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_EmployeeHiring    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Employee hiring" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Employee hiring (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400673 check that additional attributes and properties are displayed on the form without reopening (document Employee sick leave)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Employee sick leave
		Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_EmployeeSickLeave    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Employee sick leave" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Employee sick leave (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400674 check that additional attributes and properties are displayed on the form without reopening (document Employee transfer)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Employee transfer
		Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_EmployeeTransfer    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Employee transfer" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Employee transfer (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400675 check that additional attributes and properties are displayed on the form without reopening (document Employee vacation)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Employee vacation
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_EmployeeVacation    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Employee vacation" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Employee vacation (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows
	
Scenario: _015400676 check that additional attributes and properties are displayed on the form without reopening (document Time sheet)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Time sheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_TimeSheet    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Time sheet" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Time sheet (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400676 check that additional attributes and properties are displayed on the form without reopening (document Additional deduction)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Additional deduction
		Given I open hyperlink "e1cib/list/Document.AdditionalDeduction"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_AdditionalDeduction    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Additional deduction" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Additional deduction (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400677 check that additional attributes and properties are displayed on the form without reopening (document Additional accrual)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Additional accrual
		Given I open hyperlink "e1cib/list/Document.AdditionalAccrual"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_AdditionalAccrual    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Additional accrual" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Additional accrual (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400678 check that additional attributes and properties are displayed on the form without reopening (document Payroll)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name           |
			| Document_Payroll    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "Payroll" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Payroll (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400682 check that additional attributes and properties are displayed on the form without reopening (document DebitCreditNote)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Document_DebitCreditNote    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "DebitCreditNote" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Debit/Credit note (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400683 check that additional attributes and properties are displayed on the form without reopening (document RevenueAccruals)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create RevenueAccruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Document_RevenueAccruals    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "RevenueAccruals" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Revenue accrual (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows

Scenario: _015400684 check that additional attributes and properties are displayed on the form without reopening (document ExpenseAccruals)
	Then I check for the "AddAttributeAndPropertyValues" charts of characteristic types with the Description Eng "Test"
	* Open a form to create ExpenseAccruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I click the button named "FormCreate"
		And I move to "Other" tab
		And field "Test" is not present on the form
	* Adding additional Test attribute without closing the form
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name        |
			| Document_ExpenseAccruals    |
		And I select current line in "List" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| Description    |
			| Test           |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I input "ExpenseAccruals" text in the field named "Description_en"
		And I click "Save and close" button
	* Check that the additional Test attribute has been displayed on the form
		When I click command interface button "Expense accrual (create)"
		And field "Test" is present on the form
		And I click Select button of "Test" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Test 1'         |
		And I select current line in "List" table
		Then "Test" form attribute became equal to "Test 1"
		And I click "Save" button
		And I click "Add properties" button
		And "Properties" table became equal
			| 'Property'   | 'Value'    |
			| 'Test 1'     | ''         |
	And I close all client application windows
	
Scenario: _015400670 check AddAttribute with type hyperlink
	And I close all client application windows
	* Select AddAttribute with type hyperlink
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
		And I go to line in "List" table
			| 'Description'               |
			| 'Add attribute (hyperlink)' |
		And I select current line in "List" table
		And I set checkbox "Is URL"
		And I click "Save and close" button
	* Adding additional Add attribute (hyperlink) for Item
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name |
			| Catalog_Items        |
		And I select current line in "List" table
		And in the table "Attributes" I click "Add" button
		And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Add attribute (hyperlink)' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
	* Check
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3"
		And I click the hyperlink named "__e19e213c0a1647deb8835dab2a35086f_EditURL"
		And I input "123" text in "Add attribute (hyperlink)" field
		And I click the hyperlink named "__e19e213c0a1647deb8835dab2a35086f_SaveURL"
		And I click "123" hyperlink
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		And I close all client application windows

Scenario: _015400672 check AddAttribute with type (boolean)
	And I close all client application windows
	* Adding additional Add attribute (boolean) for PO
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name    |
			| Document_PurchaseOrder  |
		And I select current line in "List" table
		And in the table "Attributes" I click "Add" button
		And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Add attribute (boolean)' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
	* Check
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I move to the tab named "GroupOther"
		And I set checkbox named "__e19e213c0a1647deb8835dab2a35089f"
		And I click the button named "FormWrite"
		Then the form attribute named "__e19e213c0a1647deb8835dab2a35089f" became equal to "Yes"
	And I close all client application windows
									
Scenario: _015400673 check add common attribute to attribute set
	And I close all client application windows
	* Adding additional Add attribute (UniqueID) for Company
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| Predefined data name  |
			| Catalog_Companies     |
		And I select current line in "List" table
		And I move to the tab named "GroupExtensionAttributes"
		And in the table "ExtensionAttributes" I click the button named "ExtensionAttributesAdd"
		And I input "Author" text in the field named "ExtensionAttributesAttribute" of "ExtensionAttributes" table
		And I change checkbox named "ExtensionAttributesShow" in "ExtensionAttributes" table
		And I finish line editing in "ExtensionAttributes" table
		And I click the button named "FormWriteAndClose"
	* Check
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I move to "External attributes" tab
		Then the field named "Author" is filled	
	And I close all client application windows

Scenario: _015400680 check add attributes (collection, Projects and Stores)
	And I close all client application windows
	* Setting additional attributes collection for SI
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Description'   |
			| 'Sales invoice' |
		And I select current line in "List" table
		* Projects collection
			And in the table "Attributes" I click "Add" button
			And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
			And I go to line in "List" table
				| 'Description'                      |
				| 'Add atribute Projects collection' |
			And I select current line in "List" table
			And I activate field named "AttributesCollection" in "Attributes" table
			And I finish line editing in "Attributes" table
			And I set checkbox named "AttributesCollection" in "Attributes" table
			And I finish line editing in "Attributes" table
			And I activate "Path for tag" field in "Attributes" table
			And I select current line in "Attributes" table
			And I input "ItemList.AdditionalAnalytic" text in "Path for tag" field of "Attributes" table
			And I finish line editing in "Attributes" table
		* Stores collection
			And in the table "Attributes" I click "Add" button
			And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
			And I go to line in "List" table
				| 'Description'                      |
				| 'Add atribute Stores collection' |
			And I select current line in "List" table
			And I activate field named "AttributesCollection" in "Attributes" table
			And I finish line editing in "Attributes" table
			And I set checkbox named "AttributesCollection" in "Attributes" table
			And I finish line editing in "Attributes" table
			And I activate "Path for tag" field in "Attributes" table
			And I select current line in "Attributes" table
			And I input "ItemList.Store" text in "Path for tag" field of "Attributes" table
			And I finish line editing in "Attributes" table
		And I click "Save and close" button
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I select from "Legal name" drop-down list by "Company Ferron BP" string
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I select from "Partner term" drop-down list by "Basic Partner terms, TRY" string
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "dress" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "XS/Blue" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Additional analytic" attribute in "ItemList" table
		And I go to line in "" table
			| ''        |
			| 'Project' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'|
			| 'Project 02' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select "boots" from "Item" drop-down list by string in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select "39/18SD" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Store 02" by string from the drop-down list named "ItemListStore" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Additional analytic" attribute in "ItemList" table
		And I go to line in "" table
			| ''         |
			| 'Project'  |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Description'|
			| 'Project 01' |
		And I select current line in "List" table	
		And I click "Save" button
		And I save the value of the field named "Number" as "Number"
		And I close current window			
	* Check additional attributes collection
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Description'   |
			| 'Sales invoice' |
		And I select current line in "List" table
		And I go to line in "Attributes" table
			| 'Attribute'                        |
			| 'Add atribute Projects collection' |
		And I activate "Path for tag" field in "Attributes" table
		And I select current line in "Attributes" table
		And I input "" text in "Path for tag" field of "Attributes" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute'                      |
			| 'Add atribute Stores collection' |
		And I select current line in "Attributes" table
		And I input "" text in "Path for tag" field of "Attributes" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
		And I wait "Sales invoice (Additional attribute set) *" window closing in 20 seconds
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'   |
			| '$Number$' |
		And I select current line in "List" table
		Then the form attribute named "__151d5bf741df34c5c81b30e019f7cbb69" became equal to "Project 02; Project 01"
		Then the form attribute named "__151d5bf742df34c5c81b30e019f7cbb67" became equal to "Store 01; Store 02"
	And I close all client application windows
	
Scenario: _015400681 check multistring additional attributes
	And I close all client application windows
	* Setting additional attributes collection for SI
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Description'   |
			| 'Sales invoice' |
		And I select current line in "List" table
		And in the table "Attributes" I click "Add" button
		And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Country of consignment' |
		And I select current line in "List" table	
		And I set checkbox named "AttributesCollection" in "Attributes" table	
		And I click "Save and close" button
	* Check
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Country of consignment" field
		And I click the button named "Add"
		And I click choice button of the attribute named "Value" in "ValueList" table
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Country of consignment' |  'Turkey'        |
		And I select current line in "List" table
		And I finish line editing in "ValueList" table
		And I click the button named "Add"
		And I click choice button of the attribute named "Value" in "ValueList" table
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Country of consignment' |  'Poland'        |
		And I select current line in "List" table
		And I finish line editing in "ValueList" table
		And I click the button named "OK"
		Then the form attribute named "_V123449" became equal to "Turkey; Poland"
		And I click "Save" button	
		Then the form attribute named "_V123449" became equal to "Turkey; Poland"	
	And I close all client application windows

Scenario: _015400685 check filter for additional attributes
	And I close all client application windows
	* Add additional attributes for partner
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Description' |
			| 'Partners'    |
		And I select current line in "List" table
		* Business region
			And in the table "Attributes" I click "Add" button
			And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Business region' |
			And I select current line in "List" table
			And I finish line editing in "Attributes" table
		* Country of consignment (with filter)
			And in the table "Attributes" I click the button named "AttributesAdd"
			And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
			Then "Additional attribute types" window is opened
			And I go to line in "List" table
				| 'Description'            |
				| 'Country of consignment' |
			And I select current line in "List" table
			And I finish line editing in "Attributes" table
			And in the table "Attributes" I click the button named "AttributesSetCondition"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "Edit condition" window is opened
			And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
			And I select "Ref.Business region" by string from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
			And I activate field named "SettingsFilterRightValue" in "SettingsFilter" table
			And I select "Turkey" by string from the drop-down list named "SettingsFilterRightValue" in "SettingsFilter" table
			And I finish line editing in "SettingsFilter" table
			And I click "Ok" button
			And I click "Save and close" button
		* Check filter
			Given I open hyperlink "e1cib/list/Catalog.Partners"			
			And I go to line in "List" table
				| 'Description' |
				| 'Big foot'    |
			And I select current line in "List" table
			And I click Select button of "Business region" field
			And I go to line in "List" table
				| 'Additional attribute' | 'Description'   |
				| 'Business region'      | 'Region Turkey' |
			And I select current line in "List" table
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description' |
				| 'Big foot'    |
			And I select current line in "List" table
			Then the form attribute named "_V123449" became equal to ""
			And I select from "Country of consignment" drop-down list by "turkey" string
			Then the form attribute named "_V123449" became equal to "Turkey"			
			And I click "Save and close" button			
		* Check button verify
			Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
			And I go to line in "List" table
				| 'Description' |
				| 'Partners'    |
			And I select current line in "List" table
			And I go to line in "Attributes" table
				| 'Attribute'              |
				| 'Country of consignment' |
			And I activate "Path for tag" field in "Attributes" table
			And in the table "Attributes" I click "Set condition" button
			And in the table "ResultTable" I click "Verify" button
			And "ResultTable" table contains lines
				| 'Ref'      |
				| 'Big foot' |
			Then the number of "ResultTable" table lines is "меньше или равно" "3"
	And I close all client application windows