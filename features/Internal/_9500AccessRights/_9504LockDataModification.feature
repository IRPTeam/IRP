#language: en
@tree
@Positive
@AccessRights

Feature: lock data modification


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: 950400 preparation
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink 'e1cib/list/Document.PriceList'
	And I go to line in "List" table
		| 'Number'         |
		| '100' |
	And in the table "List" I click the button named "ListContextMenuPost"
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description" |
				| "TestExtension" |
			When add test extension
	* Filling settings for attribute from extension
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name' |
			| 'Catalog_Currencies'   |
		And I select current line in "List" table
		And I move to "Extension attributes" tab
		And in the table "ExtensionAttributes" I click "Fill attributes list" button
		And "ExtensionAttributes" table became equal
			| '#' | 'Required' | 'Attribute'      | 'Show' | 'UI group' | 'Show in HTML' |
			| '1' | 'No'       | 'REP_Attribute1' | 'No'   | ''         | 'No'           |
		And I set "Show" checkbox in "ExtensionAttributes" table
		And I select current line in "ExtensionAttributes" table
		And I click choice button of the attribute named "ExtensionAttributesInterfaceGroup" in "ExtensionAttributes" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Accounting information' |
		And I select current line in "List" table
		And I finish line editing in "ExtensionAttributes" table
		And I click "Save and close" button
	* Filling in attribute from extension
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I input "2" text in "REP_Attribute1" field
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'     |
			| 'American dollar' |
		And I select current line in "List" table
		And I input "3" text in "REP_Attribute1" field
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description' |
			| 'Euro'        |
		And I select current line in "List" table
		And I input "4" text in "REP_Attribute1" field
		And I click "Save and close" button
		And I close all client application windows
	* Tax
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
		When Create catalog CancelReturnReasons objects
	* Change test user info
			Given I open hyperlink "e1cib/list/Catalog.Users"
			And I go to line in "List" table
					| 'Description'                 |
					| 'Arina Brown (Financier 3)' |
			And I select current line in "List" table
			And I select "English" exact value from "Data localization" drop-down list	
			And I click "Save" button
			Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
			And I go to line in "List" table
				| 'Description'    |
				| 'Administrators' |
			And I select current line in "List" table
			And I click "Save and close" button	
	* Load SI and change it date
		When Create document SalesInvoice objects (stock control)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '251'    |
		And I select current line in "List" table
		And I save "CurrentDate() - 8 * 24 * 60 * 60" in "$$$$Date1$$$$" variable
		And I input "$$$$Date1$$$$" variable value in "Date" field
		And I move to the next attribute
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Basic Price Types?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button	
		And I click "Post and close" button
		And I close all client application windows
	* Load SO and change it date
		When Create document SalesOrder objects
	* Load PO
		When Create document PurchaseOrder objects
		And I close all client application windows
		
		

Scenario: 950403 check function option UseLockDataModification
	When in sections panel I select "Settings"
	And functions panel does not contain menu items
		| "Lock data modification reasons" |
		| "Lock data modification rules" |
	And I set "True" value to the constant "UseLockDataModification"
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient


	

Scenario: 950405 create reasons for documents with different comparison type
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule for SO (<=)
		And I click the button named "FormCreate"
		And I input "lock documents" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Sales order" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Date" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "<=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I select current line in "RuleList" table
		And I input "08.10.2020 00:00:00" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
	* Create rule for SI (in)
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Sales invoice" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Partner term" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "in" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I select current line in "RuleList" table
		And I input "Basic Partner terms, without VAT" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check saving
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And "List" table contains lines
			| 'Reference'            |
			| 'lock documents' |
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
			Given Recent TestClient message contains "lock documents" string by template
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
			Given Recent TestClient message contains "lock documents" string by template
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
			Given Recent TestClient message contains "lock documents" string by template
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
				| '15' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock documents" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '15' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock documents" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '15' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock documents" string by template
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
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Reference'            |
			| 'lock documents' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows	
		


Scenario: 950406 create rules for documents (number of days from the current date for User)
	And I connect "Этот клиент" profile of TestClient
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
				| "Number" |
				| "16" |
				And I go to line in "List" table
					| 'Number'         |
					| '15' |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I move to "Other" tab
				And I input "0" text in "Number" field
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
				And I input "16" text in "Number" field
				And I click "Post and close" button
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule for SI (<=)
		And I click the button named "FormCreate"
		And I input "number of days from the current date for User" text in "ENG" field
		And I move to "Users" tab
		And in the table "UserList" I click the button named "UserListAdd"
		And I click choice button of "User" attribute in "UserList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Arina Brown (Financier 3)' |
		And I select current line in "List" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Sales invoice" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Date" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "<=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I set checkbox named "RuleListSetValueAsCode" in "RuleList" table
		And I input "BegOfDay(CurrentSessionDate()) - 7 * 24 * 60 * 60" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
		And I connect "TestAdmin1" TestClient using "ABrown" login and "" password
	* Check lock data
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '251'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for User" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '16'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages
	* Change user and check lock data (user without locks)
		And I close TestClient session
		Then I connect launched Test client "Этот клиент"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '251'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages



Scenario: 9504061 create rules for documents (number of days from the current date for User group)
	And I connect "Этот клиент" profile of TestClient
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
				| "Number" |
				| "16" |
				And I go to line in "List" table
					| 'Number'         |
					| '15' |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I move to "Other" tab
				And I input "0" text in "Number" field
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
				And I input "16" text in "Number" field
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
			| 'Reference'            |
			| 'number of days from the current date for User' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'number of days from the current date for User' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule for SI (<=)
		And I click the button named "FormCreate"
		And I input "number of days from the current date for User group" text in "ENG" field
		And I move to "Access groups" tab
		And in the table "AccessGroupList" I click the button named "AccessGroupListAdd"		
		And I click choice button of "Access group" attribute in "AccessGroupList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Administrators' |
		And I select current line in "List" table		
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Sales invoice" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Date" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "<=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I set checkbox named "RuleListSetValueAsCode" in "RuleList" table
		And I input "BegOfDay(CurrentSessionDate()) - 7 * 24 * 60 * 60" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
		And I connect "TestAdmin1" TestClient using "ABrown" login and "" password
	* Check lock data
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '251'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for User group" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '16'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages
	* Change user and check lock data (user without locks)
		And I close TestClient session
		Then I connect launched Test client "Этот клиент"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '251'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages

Scenario: 9504062 create rules for documents (number of days from the current date for all objects)
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	If "List" table contains lines Then
			| 'Reference'            |
			| 'number of days from the current date for User group' |
		And I go to line in "List" table
			| 'Reference'      |
			| 'number of days from the current date for User group' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Create rule for all objects
		And I click the button named "FormCreate"
		And I input "number of days from the current date for all objects" text in "ENG" field
		And I set checkbox "Set one rule for all objects"
		And I set checkbox "For all users"
		Then "Lock data modification reasons (create) *" window is opened
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Sales order" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Sales invoice" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I finish line editing in "RuleList" table
		And I select "Date" exact value from the drop-down list named "Attribute"
		And I select "<=" exact value from the drop-down list named "ComparisonType"
		And I set checkbox named "SetValueAsCode"
		And I input "BegOfDay(CurrentSessionDate()) - 7 * 24 * 60 * 60" text in the field named "Value"
		And I click "Save and close" button
	* Check lock data
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '251'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for all objects" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for all objects" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'    |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages
				
		
				

Scenario: 950407 create rules for accumulation register
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
				| "Number" |
				| "16" |
				And I go to line in "List" table
					| 'Number'         |
					| '15' |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Document.SalesOrder'
		If "List" table does not contain lines Then
				| "Number" |
				| "2" |
				And I go to line in "List" table
					| 'Number'         |
					| '1' |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Reference'            |
				| 'number of days from the current date for all objects' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'number of days from the current date for all objects' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule for R4011 Free stocks (=)
		And I click the button named "FormCreate"
		And I input "lock accumulation register" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "R4011 Free stocks" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Store" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I go to line in "List" table
			| 'Description' | 
			| 'Store 02'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "RuleList" table
	* Create rule for R2021 Customer transactions (in)
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "R2021 Customer transactions" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Partner" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "in" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I activate field named "RuleListValue" in "RuleList" table
		And I select current line in "RuleList" table
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I select "Kalipso" by string from the drop-down list named "RuleListValue" in "RuleList" table
		And I finish line editing in "RuleList" table
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
			Given Recent TestClient message contains "lock accumulation register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock accumulation register" string by template
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
			Given Recent TestClient message contains "lock accumulation register" string by template
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
				| '16' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"			
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock accumulation register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '15' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock accumulation register" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '16' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock accumulation register" string by template
			And I close all client application windows
		* Modification (re-Posting)
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'         |
				| '16' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
	* Delete rules
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Reference'            |
			| 'lock accumulation register' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows	


Scenario: 950409 create rules for information register (with recorder)
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
			| "Number" |
			| "16"  |
				And I go to line in "List" table
					| 'Number'         |
					| '15' |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Document.SalesOrder'
		If "List" table does not contain lines Then
				| "Number" |
				| "2" |
				And I go to line in "List" table
					| 'Number'         |
					| '1' |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I click "Post and close" button
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule for Order balance (=)
		And I click the button named "FormCreate"
		And I input "lock information register" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "R2010 Sales orders" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item key" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I go to line in "List" table
			| 'Item key' | 'Item' |
			| '38/Yellow'| 'Trousers' |
		And I select current line in "List" table
		And I finish line editing in "RuleList" table
	* Create rule for Prices by item keys (in)
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Prices by item keys" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Price type" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "in" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I select "Basic Price Types" by string from the drop-down list named "RuleListValue" in "RuleList" table
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
			Given Recent TestClient message contains "lock information register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '1' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock information register" string by template
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
			Given Recent TestClient message contains "lock information register" string by template
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
			Given Recent TestClient message contains "lock information register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'         |
				| '100' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock information register" string by template
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
			Given Recent TestClient message contains "lock information register" string by template
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
			Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
			And I go to line in "List" table
				| 'Reference'            |
				| 'lock information register' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I close all client application windows	


		

Scenario: 950411 create rules for catalog (<)
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule
		And I click the button named "FormCreate"
		And I input "lock catalog <" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item ID" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "<" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I input "10003" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button	
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10002"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10003"
			And I click "Save" button
			Then user message window does not contain messages
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Clothes'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I input "1000" text in "Item ID" field
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <" string by template
			And I input "1888" text in "Item ID" field
			And I click "Save and close" button	
			Then user message window does not contain messages	
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Test'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows

Scenario: 950412 create rules for catalog (<=)
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	If "List" table contains lines Then
			| 'Reference'            |
			| 'lock catalog <' |
		And I go to line in "List" table
			| 'Reference'      |
			| 'lock catalog <' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "lock catalog <=" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item ID" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "<=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I input "10004" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <=" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10004"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <=" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10005"
			And I click "Save" button
			Then user message window does not contain messages
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 2" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Clothes'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I input "10004" text in "Item ID" field
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <=" string by template
			And I input "1000" text in "Item ID" field
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <=" string by template
			And I input "1888" text in "Item ID" field
			And I click "Save and close" button	
			Then user message window does not contain messages	
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <=" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Test 2'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows
	

Scenario: 950413 create rules for catalog (>)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Reference'            |
				| 'lock catalog <=' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'lock catalog <=' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "lock catalog >" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item ID" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select ">" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I input "10002" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then user message window does not contain messages
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10003"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10002"
			And I click "Save" button
			Then user message window does not contain messages
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 3" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Clothes'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I input "12222" text in "Item ID" field
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >" string by template
			And I input "100" text in "Item ID" field
			And I click "Save and close" button	
			Then user message window does not contain messages	
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Test 3'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows


Scenario: 950414 create rules for catalog (>=)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Reference'            |
				| 'lock catalog >' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'lock catalog >' |		
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "lock catalog >=" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item ID" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select ">=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I input "10002" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then user message window does not contain messages
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10003"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >=" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'       |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10002"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >=" string by template
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 4" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Clothes'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I input "20003" text in "Item ID" field
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >=" string by template
			And I input "10002" text in "Item ID" field
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >=" string by template
			And I input "100" text in "Item ID" field
			And I click "Save and close" button	
			Then user message window does not contain messages	
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >=" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Test 4'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows
	

Scenario: 950415 create rules for catalog (=)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Reference'            |
				| 'lock catalog >=' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'lock catalog >=' |		
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "lock catalog item type" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item type" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I select "Clothes" by string from the drop-down list named "RuleListValue" in "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog item type" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"		
			Then user message window does not contain messages
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 5" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Clothes'     |
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog item type" string by template	
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Shoes'     |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog item type" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Test 5'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows
	

Scenario: 950416 create rules for catalog (<>)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Reference'            |
				| 'lock catalog item type' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'lock catalog item type' |	
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "lock catalog <>" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item type" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "<>" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I select "Clothes" by string from the drop-down list named "RuleListValue" in "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <>" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"		
			Then user message window does not contain messages
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 6" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Shoes'     |
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <>" string by template	
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Clothes'     |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <>" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Test 6'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows


Scenario: 950417 create rules for catalog (IN HIERARCHY)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Reference'            |
				| 'lock catalog <>' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'lock catalog <>' |	
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "lock catalog IN HIERARCHY" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Partners" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Ref" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "IN HIERARCHY" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I select "Ferron BP" by string from the drop-down list named "RuleListValue" in "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Partners'
			And I click "List" button				
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Ferron 1'       |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN HIERARCHY" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Lomaniti'       |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"		
			Then user message window does not contain messages
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Partners'
			And I click the button named "FormCreate"
			And I input "Test 7" text in "ENG" field
			And I click Select button of "Main partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'     |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN HIERARCHY" string by template	
			And I click Select button of "Main partner" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description' |
				| 'Alians'     |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Ferron 2'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN HIERARCHY" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Partners'
			And I go to line in "List" table
				| 'Description' |
				| 'Test 7'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows

	

Scenario: 950418 create rules for catalog (IN)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Reference'            |
				| 'lock catalog IN HIERARCHY' |
			And I go to line in "List" table
				| 'Reference'      |
				| 'lock catalog IN HIERARCHY' |	
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "lock catalog IN" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Item type" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "IN" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I select "Furniture" by string from the drop-down list named "RuleListValue" in "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rule
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Table'       |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"		
			Then user message window does not contain messages
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 15" text in "ENG" field
			And I click Select button of "Item type" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description' |
				| 'Furniture'     |
			And I select current line in "List" table
			And I click Select button of "Unit" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN" string by template	
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Clothes'     |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description' |
				| 'Table'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN" string by template	
			And I close current window
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I go to line in "List" table
				| 'Description' |
				| 'Test 15'       |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows



Scenario: 950420 create rules for information register (without recorder)
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule for Currency rates (=)
		And I click the button named "FormCreate"
		And I input "information register (without recorder)" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Currency rates" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Source" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I select "Bank UA" by string from the drop-down list named "RuleListValue" in "RuleList" table
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Company taxes" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Tax" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "IN" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I select current line in "RuleList" table
		And I input "VAT" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
	* Check rules (=)
		* Modification
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '0,0361' | 'Bank UA' |
			And I select current line in "List" table
			And I input "27,7425" text in "Rate" field
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "information register (without recorder)" string by template
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '0,0361' | 'Bank UA' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I input "12.09.2020 00:00:00" text in "Period" field
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "information register (without recorder)" string by template
			And I close all client application windows
		* Deletion
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '0,0361' | 'Bank UA' |
			And in the table "List" I click the button named "ListContextMenuDelete"				
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "information register (without recorder)" string by template
			And I close all client application windows
		* Re-Save
			Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
			And I go to line in "List" table
				| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
				| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '0,0361' | 'Bank UA' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "information register (without recorder)" string by template
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
			Given Recent TestClient message contains "information register (without recorder)" string by template
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
			Given Recent TestClient message contains "information register (without recorder)" string by template
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
			Given Recent TestClient message contains "information register (without recorder)" string by template
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
			Given Recent TestClient message contains "information register (without recorder)" string by template
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
				| 'USD'           | 'EUR'         | '1'            | '21.06.2019 17:40:13' | '1,1235' | 'Forex Seling' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then user message window does not contain messages	


Scenario: 950425 check that Disable rule does not work
	* All Reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Reference'      |
			| 'information register (without recorder)' |	
		And I select current line in "List" table
		And I set checkbox "Disable rule"
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
		And I go to line in "List" table
			| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
			| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '0,0361' | 'Bank UA' |
		And I select current line in "List" table
		And I click "Save and close" button
		Then user message window does not contain messages	
		And I close all client application windows
		Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
		And I go to line in "List" table
			| 'Tax' |
			| 'VAT' |
		And I select current line in "List" table
		And I click "Save and close" button
		Then user message window does not contain messages	
		And I close all client application windows
	* One rule from reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Reference'      |
			| 'information register (without recorder)' |
		And I select current line in "List" table
		And I remove checkbox named "DisableRule"
		And I go to line in "RuleList" table
			| 'Type'                      |
			| 'InformationRegister.Taxes' |
		And I set checkbox named "RuleListDisableRule" in "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
		And I go to line in "List" table
			| 'Tax' |
			| 'VAT' |
		And I select current line in "List" table
		And I click "Save and close" button
		Then user message window does not contain messages	
		And I close all client application windows
		Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
		And I go to line in "List" table
			| 'Currency from' | 'Currency to' | 'Multiplicity' | 'Period'              | 'Rate'    | 'Source'  |
			| 'UAH'           | 'USD'         | '1'            | '07.09.2020 00:00:00' | '0,0361' | 'Bank UA' |
		And I select current line in "List" table
		And I input "27,7425" text in "Rate" field
		And I click "Save and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "information register (without recorder)" string by template
		And I close all client application windows
	
		
Scenario: 950430 create rules for attribute from extension
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Create rule for Currency catalog (=)
		And I click the button named "FormCreate"
		And I input "attribute from extension" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Currencies" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "REP_Attribute1" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I input "4" text in the field named "RuleListValue" of "RuleList" table
		And I click "Save and close" button
	* Check rules
		* Modification
			Given I open hyperlink 'e1cib/list/Catalog.Currencies'
			And I go to line in "List" table
				| 'Description' |
				| 'Euro' |
			And I select current line in "List" table
			And I input "978" text in "Numeric code" field	
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "attribute from extension" string by template
			And I close all client application windows
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Currencies'
			And I go to line in "List" table
				| 'Description' |
				| 'Euro' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click Open button of "ENG" field
			And I input "Euro1" text in "ENG" field
			And I input "Euro1" text in "TR" field
			And I click "Ok" button
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "attribute from extension" string by template
			And I close all client application windows
		* Deletion
			Given I open hyperlink 'e1cib/list/Catalog.Currencies'
			And "List" table does not contain lines
				| 'Description' |
				| 'Euro1' |
			And I go to line in "List" table
				| 'Description' |
				| 'Euro' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"					
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "attribute from extension" string by template
			And I close all client application windows
		* Re-Save
			Given I open hyperlink 'e1cib/list/Catalog.Currencies'
			And I go to line in "List" table
				| 'Description' |
				| 'Euro' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "attribute from extension" string by template
			And I close all client application windows
	* Does not fall under the conditions
			Given I open hyperlink 'e1cib/list/Catalog.Currencies'
			And I go to line in "List" table
				| 'Description' |
				| 'American dollar' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then user message window does not contain messages
			
			
		

Scenario: 950480 check access to the Lock data modification for user with role Full access only read 
	And I connect "SBorisova" TestClient using "SBorisova" login and "F12345" password
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	And I go to line in "List" table
		| 'Reference'      |
		| 'information register (without recorder)' |	
	And I select current line in "List" table
	Then the form attribute named "ForAllUsers" became equal to "Yes"
	Then the form attribute named "SetOneRuleForAllObjects" became equal to "No"
	Then the form attribute named "Decoration1" became equal to "Decoration1"
	Then the form attribute named "DisableRule" became equal to "No"
	And "RuleList" table contains lines
		| '#' | 'Type'                              | 'Attribute'         | 'Comparison type' | 'Value'   | 'Disable rule' | 'Set value as code' |
		| '1' | 'InformationRegister.CurrencyRates' | 'Dimensions.Source' | '='               | 'Bank UA' | 'No'           | 'No'                |
		| '2' | 'InformationRegister.Taxes'         | 'Dimensions.Tax'    | 'IN'              | 'VAT'     | 'Yes'          | 'No'                |
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
			


	Scenario: 950490 switch off function option and check that rules does not work
			And I connect "Этот клиент" profile of TestClient
			And I set "False" value to the constant "UseLockDataModification"
			And I close TestClient session
			And I connect "Этот клиент" profile of TestClient
			Given I open hyperlink 'e1cib/list/Catalog.Currencies'
			And I go to line in "List" table
				| 'Description' |
				| 'Euro' |
			And I select current line in "List" table
			And I click "Save and close" button
			Then user message window does not contain messages
			And I set "True" value to the constant "UseLockDataModification"
			And I close TestClient session
			And I connect "Этот клиент" profile of TestClient



								

				
						

				
						
				
				