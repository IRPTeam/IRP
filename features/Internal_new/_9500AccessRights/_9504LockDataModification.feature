#language: en
@tree
@Positive
@AccessRights

Feature: lock data modification


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: 950400 preparation
	Then I connect launched Test client "Этот клиент"
	Given I open hyperlink 'e1cib/list/Document.PriceList'
	And I go to line in "List" table
		| 'Number'         |
		| '100' |
	And in the table "List" I click the button named "ListContextMenuPost"



Scenario: 950403 check function option UseLockDataModification
	When in sections panel I select "Settings"
	And functions panel does not contain menu items
		| "Lock data modification reasons" |
		| "Lock data modification rules" |
	And I set "True" value to the constant "UseLockDataModification"
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	When in sections panel I select "Settings"
	And functions panel contains menu items
		| "Lock data modification reasons" |
		| "Lock data modification rules" |


	

Scenario: 950403 create reasons
	And In the command interface I select "Settings" "Lock data modification reasons"
	And I click the button named "FormCreate"
	And I input "Doc lock" text in "ENG" field
	And I click Open button of "ENG" field
	And I input "Doc lock TR" text in "TR" field
	And I click "Ok" button
	And I click "Save and close" button
	And I click the button named "FormCreate"
	And I input "Register lock" text in "ENG" field
	And I click Open button of "ENG" field
	And I input "Register lock TR" text in "TR" field
	And I click "Ok" button
	And I click "Save and close" button
	
		

Scenario: 950405 create rules for documents
	Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
	* Create rule for SO (=)
		And I click the button named "FormCreate"
		And I select "Sales order" exact value from "Type" drop-down list
		And I select "Date" exact value from "Attribute" drop-down list
		And I select "=" exact value from "Comparison type" drop-down list
		And I input "07.10.2020" text in "Value" field
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000001' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Create rule for SI (in)
		And I click the button named "FormCreate"
		And I select "Sales invoice" exact value from "Type" drop-down list
		And I select "Partner term" exact value from "Attribute" drop-down list
		And I select "in" exact value from "Comparison type" drop-down list
		And I input "Basic Partner terms, without VAT" text in "Value" field
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000001' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And I close all client application windows
	* Check saving
		Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
		And "List" table contains lines
		| 'Type'                  | 'Attribute'               | 'Comparison type' | 'Table name' | 'Value'                            | 'Disable rule' | 'Lock data modification reasons' |
		| 'Document.SalesInvoice' | 'Attributes.Agreement'    | 'IN'              | ''           | 'Basic Partner terms, without VAT' | 'Yes'          | 'Doc lock'                       |
		| 'Document.SalesOrder'   | 'StandardAttributes.Date' | '<='              | ''           | '07.10.2020'                       | 'No'           | 'Doc lock'                       |
		And I close all client application windows
	* Check rules (=)
		* Modification
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Doc lock" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I move to "Other" tab
			And I input "07.10.2020 00:00:00" text in "Date" field
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Doc lock" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Doc lock" string by template
			And I close all client application windows
		* Does not fall under the conditions
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Save" button
			And I click "Post and close" button
			And "List" table contains lines
				| 'Number'         |
				| '1' |
				| '2' |
			And I close all client application windows			
	* Check rules (in)
		* Modification
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Doc lock" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Doc lock" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Doc lock" string by template
		* Does not fall under the conditions
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Save" button
			And I click "Post and close" button
			Then user message window does not contain messages
			And "List" table contains lines
				| 'Number'         |
				| '1' |
				| '2' |
			And I close all client application windows	
	* Delete rules
		Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
		And I go to line in "List" table
			| 'Type'               |
			| 'Document.SalesOrder' |
		And in the table "List" I click the button named "ListContextMenuDelete"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| 'Type'               |
			| 'Document.SalesInvoice' |
		And in the table "List" I click the button named "ListContextMenuDelete"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows	
		
				



Scenario: 950407 create rules for accumulation register
	Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
	* Create rule for Order balance (=)
		And I click the button named "FormCreate"
		And I select "Order balance" exact value from "Type" drop-down list
		And I select "Store" exact value from "Attribute" drop-down list
		And I select "=" exact value from "Comparison type" drop-down list
		And I click Select button of "Value" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000002' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Create rule for Partner AR transactions (in)
		And I click the button named "FormCreate"
		And I select "Partner AR transactions" exact value from "Type" drop-down list
		And I select "Partner" exact value from "Attribute" drop-down list
		And I select "IN" exact value from "Comparison type" drop-down list
		And I click Select button of "Value" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'    |
		And I select current line in "List" table
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000002' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Check rules (=)
		* Modification (UndoPosting)
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"			
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Modification (re-Posting)
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
	* Check rules (in)
		* Modification (UndoPosting)
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"			
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Modification (re-Posting)
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
	* Delete rules
		Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
		And I go to line in "List" table
			| 'Type'               |
			| 'AccumulationRegister.OrderBalance' |
		And in the table "List" I click the button named "ListContextMenuDelete"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| 'Type'               |
			| 'AccumulationRegister.PartnerArTransactions' |
		And in the table "List" I click the button named "ListContextMenuDelete"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows


Scenario: 950409 create rules for information register (with recorder)
	Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
	* Create rule for Order balance (=)
		And I click the button named "FormCreate"
		And I select "Sales order turnovers" exact value from "Type" drop-down list
		And I select "Item key" exact value from "Attribute" drop-down list
		And I select "=" exact value from "Comparison type" drop-down list
		And I click Select button of "Value" field
		And I go to line in "List" table
			| 'Item key' | 'Item' |
			| '38/Yellow'| 'Trousers' |
		And I select current line in "List" table
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000002' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Create rule for Prices by item keys (in)
		And I click the button named "FormCreate"
		And I select "Prices by item keys" exact value from "Type" drop-down list
		And I select "Price type" exact value from "Attribute" drop-down list
		And I select "in" exact value from "Comparison type" drop-down list
		And I click Select button of "Value" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Price Types'|
		And I select current line in "List" table
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000002' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Check rules (=)
		* Modification (UndoPosting)
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"			
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Modification (re-Posting)
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'         |
				| '2' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
	* Check rules (in)
		* Modification (UndoPosting)
			Given I open hyperlink 'e1cib/list/Document.PriceList'
			And I go to line in "List" table
				| 'Number'         |
				| '100' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"			
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '100' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.PriceList'
			And I go to line in "List" table
				| 'Number'         |
				| '100' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Modification (re-Posting)
			Given I open hyperlink 'e1cib/list/Document.PriceList'
			And I go to line in "List" table
				| 'Number'         |
				| '100' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
		* Delete rules
			Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
			And I go to line in "List" table
				| 'Type'               |
				| 'AccumulationRegister.SalesOrderTurnovers' |
			And in the table "List" I click the button named "ListContextMenuDelete"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I go to line in "List" table
				| 'Type'               |
				| 'InformationRegister.PricesByItemKeys' |
			And in the table "List" I click the button named "ListContextMenuDelete"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I close all client application windows






Scenario: 950411 create rules for information register (without recorder)
	Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
	* Create rule for Currency rates (=)
		And I click the button named "FormCreate"
		And I select "Currency rates" exact value from "Type" drop-down list
		And I select "Source" exact value from "Attribute" drop-down list
		And I select "=" exact value from "Comparison type" drop-down list
		And I click Select button of "Value" field
		And I go to line in "List" table
			| 'Description' |
			| 'Bank UA'|
		And I select current line in "List" table	
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000002' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Create rule for Company taxes (in)
		And I click the button named "FormCreate"
		And I select "Company taxes" exact value from "Type" drop-down list
		And I select "Tax" exact value from "Attribute" drop-down list
		And I select "IN" exact value from "Comparison type" drop-down list
		And I click Select button of "Value" field
		And I go to line in "List" table
			| 'Description' |
			| 'VAT'|
		And I select current line in "List" table		
		And I click Select button of "Lock data modification reasons" field
		And I go to line in "List" table
			| 'Code'         |
			| '000000000002' |
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Check rules (=)
		* Modification
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '27,7325' | 'Bank UA' |
			And I select current line in "List" table
			And I input "27,7425" text in "Rate" field
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '27,7325' | 'Bank UA' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I input "12.09.2020 00:00:00" text in "Period" field
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Deletion
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '27,7325' | 'Bank UA' |
			And in the table "List" I click the button named "ListContextMenuDelete"				
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Re-Save
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '27,7325' | 'Bank UA' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
	* Check rules (in)
		* Modification
			Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
			And I go to line in "List" table
				| 'Tax' |
				| 'VAT' |
			And I select current line in "List" table
			And I input "01.02.2020" text in "Period" field	
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
			And I go to line in "List" table
				| 'Tax' |
				| 'VAT' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I remove checkbox "Use"
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Deletion
			Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
			And I go to line in "List" table
				| 'Tax' |
				| 'VAT' |
			And in the table "List" I click the button named "ListContextMenuDelete"				
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
		* Re-Save
			Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
			And I go to line in "List" table
				| 'Tax' |
				| 'VAT' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "*Register Lock" string by template
			And I close all client application windows
	* Does not fall under the conditions
			Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
			And I go to line in "List" table
				| 'Tax' |
				| 'SalesTax' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then user message window does not contain messages
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'   | 'Source'       |
				| 'USD'           | 'EUR'         | '1'            | '21.06.2019 17:40:13' | '0,8900' | 'Forex Seling' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then user message window does not contain messages			
	* Delete rules
		Given I open hyperlink 'e1cib/list/InformationRegister.LockDataModificationRules'
		And I go to line in "List" table
			| 'Type'               |
			| 'InformationRegister.CurrencyRates' |
		And in the table "List" I click the button named "ListContextMenuDelete"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| 'Type'               |
			| 'InformationRegister.Taxes' |
		And in the table "List" I click the button named "ListContextMenuDelete"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows	

		
				
		
				

		
				
		
		