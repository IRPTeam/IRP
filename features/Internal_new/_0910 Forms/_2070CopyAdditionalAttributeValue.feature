#language: en
@tree
@Positive
@Group12

Feature: copy additional attribute value



Background:
	Given I launch TestClient opening script or connect the existing one
	
Scenario: _207001 copy additional attribute values when create catalog element
	* Add additional attribute 
		* Additional attribute 01
			Given I open hyperlink 'e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty'
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Additional attribute 01" text in the field named "Description_en"
			And I input "Additional attribute 01" text in the field named "Description_tr"
			And I click "Ok" button
			And I click the button named "FormWrite"
			And In this window I click command interface button "Additional attribute values"
			And I click the button named "FormCreate"
			And I input "Value02" text in the field named "Description_en"
			And I click "Save and close" button
			And I click the button named "FormCreate"
			And I input "Value01" text in the field named "Description_en"
			And I click "Save and close" button
			And I close current window
		* Additional attribute 02
			Given I open hyperlink 'e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty'
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Additional attribute 02" text in the field named "Description_en"
			And I input "Additional attribute 02" text in the field named "Description_tr"
			And I click "Ok" button
			And I click the button named "FormWrite"
			And In this window I click command interface button "Additional attribute values"
			And I click the button named "FormCreate"
			And I input "Value02" text in the field named "Description_en"
			And I click "Save and close" button
			And I click the button named "FormCreate"
			And I input "Value01" text in the field named "Description_en"
			And I click "Save and close" button
			And I close current window
	* Additional attributes settings
		* Opening the form for adding additional attributes for Partners
			Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
			And I go to line in "List" table
				| 'Predefined data item name' |
				| 'Catalog_Partners'      |
			And I select current line in "List" table
		* Adding additional attributes
			If "Attributes" table contains lines:
					| 'Attribute' |
					| 'Additional attribute 02'  |
					| 'Additional attribute 01'  |
				And I go to line in "Attributes" table
					| 'Attribute'               |
					| 'Additional attribute 01' |
				And in the table "Attributes" I click the button named "AttributesContextMenuDelete"
				And in the table "Attributes" I click the button named "AttributesContextMenuDelete"	
			And in the table "Attributes" I click the button named "AttributesAdd"
			And I click choice button of "Attribute" attribute in "Attributes" table
			And I go to line in "List" table
				| 'Description' |
				| 'Additional attribute 02'  |
			And I select current line in "List" table
			And in the table "Attributes" I click the button named "AttributesAdd"
			And I click choice button of "Attribute" attribute in "Attributes" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Additional attribute 01' |
			And I select current line in "List" table
			And I finish line editing in "Attributes" table
			And I input "Partners" text in the field named "Description_en"
			And I click "Save and close" button
	* Load test partner
		When Create catalog Partners objects (Partner 01)
	* Filling in additional attributes for Partner 01
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Partner 01'  |
		And I select current line in "List" table
		And I click Select button of "Additional attribute 02" field
		And I go to line in "List" table
			| 'Additional attribute'    | 'Description' |
			| 'Additional attribute 02' | 'Value01'     |
		And I select current line in "List" table
		And I click "Save and close" button
	* Copy partner and check filling in additional attributes
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Partner 01'  |
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then "Additional attribute 02" form attribute became equal to "Value01"
		Then "Additional attribute 01" form attribute became equal to ""
		Then the form attribute named "Description_en" became equal to "Partner 01"
		And I input "Partner 01 (clone)" text in the field named "Description_en"
		And I click "Save" button
		Then "Additional attribute 02" form attribute became equal to "Value01"
		Then the form attribute named "Description_en" became equal to "Partner 01 (clone)"
		And I click "Save and close" button
	* Filling in Additional attribute 01 in User settings for Partners
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Description' |
			| 'CI'  |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Additional attribute 01' |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Additional attribute'    | 'Description' |
			| 'Additional attribute 01' | 'Value01'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Additional attribute 02' |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Additional attribute'    | 'Description' |
			| 'Additional attribute 02' | 'Value02'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check filling in additional attributes from user settings when clone partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Partner 01'  |
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then "Additional attribute 02" form attribute became equal to "Value01"
		Then "Additional attribute 01" form attribute became equal to "Value01"
		Then the form attribute named "Description_en" became equal to "Partner 01"
		And I input "Partner 01 (clone2)" text in the field named "Description_en"
		And I click "Save" button
		Then "Additional attribute 02" form attribute became equal to "Value01"
		Then "Additional attribute 01" form attribute became equal to "Value01"
		Then the form attribute named "Description_en" became equal to "Partner 01 (clone2)"
		And I click "Save and close" button
	* Delete Partner 01, Partner 01 (clone), Partner 01 (clone2)
		And I delete "Partners" catalog element with the Description_en "Partner 01"
		And I delete "Partners" catalog element with the Description_en "Partner 01 (clone)"
		And I delete "Partners" catalog element with the Description_en "Partner 01 (clone2)"
	And I close all client application windows

Scenario: _207002 copy additional attribute values when create document
	* Additional attributes settings
		* Opening the form for adding additional attributes for BankReceipt
			Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
			And I go to line in "List" table
				| 'Predefined data item name' |
				| 'Document_BankReceipt'      |
			And I select current line in "List" table
		* Adding additional attributes
			If "Attributes" table contains lines:
					| 'Attribute' |
					| 'Additional attribute 02'  |
					| 'Additional attribute 01'  |
				And I go to line in "Attributes" table
					| 'Attribute'               |
					| 'Additional attribute 01' |
				And in the table "Attributes" I click the button named "AttributesContextMenuDelete"
				And in the table "Attributes" I click the button named "AttributesContextMenuDelete"	
			And in the table "Attributes" I click the button named "AttributesAdd"
			And I click choice button of "Attribute" attribute in "Attributes" table
			And I go to line in "List" table
				| 'Description' |
				| 'Additional attribute 02'  |
			And I select current line in "List" table
			And in the table "Attributes" I click the button named "AttributesAdd"
			And I click choice button of "Attribute" attribute in "Attributes" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Additional attribute 01' |
			And I select current line in "List" table
			And I finish line editing in "Attributes" table
			And I input "Bank receipt" text in the field named "Description_en"
			And I click "Save and close" button
	* Create test Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Main company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Select button of "Additional attribute 02" field
		And I go to line in "List" table
			| 'Additional attribute'    | 'Description' |
			| 'Additional attribute 02' | 'Value01'     |
		And I select current line in "List" table
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBankReceipt2070022$$"
		And I click "Post and close" button
	* Copy Bank receipt and check filling in additional attributes
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt2070022$$'  |
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then "Additional attribute 02" form attribute became equal to "Value01"
		Then "Additional attribute 01" form attribute became equal to ""
		And I click "Post" button
		Then "Additional attribute 02" form attribute became equal to "Value01"
		And I save the value of "Number" field as "$$NumberBankReceipt2070023$$"
		And I click "Post and close" button
	* Filling in Additional attribute 01 in User settings for Bank receipt
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Description' |
			| 'CI'  |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'              | 'Use' |
			| 'Additional attribute 01' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Additional attribute'    | 'Description' |
			| 'Additional attribute 01' | 'Value02'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'              | 'Use' |
			| 'Additional attribute 02' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Additional attribute'    | 'Description' |
			| 'Additional attribute 02' | 'Value02'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button
	* Check filling in additional attributes from user settings when clone document
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt2070022$$'  |
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then "Additional attribute 02" form attribute became equal to "Value01"
		Then "Additional attribute 01" form attribute became equal to "Value02"
		And I click "Save" button
		Then "Additional attribute 02" form attribute became equal to "Value01"
		Then "Additional attribute 01" form attribute became equal to "Value02"
		And I save the value of "Number" field as "$$NumberBankReceipt2070024$$"
		And I click "Post and close" button
	* Mark created Bank receipt for deletion 
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt2070022$$'  |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt2070023$$'  |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt2070024$$'  |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	And I close all client application windows
	


		
		









