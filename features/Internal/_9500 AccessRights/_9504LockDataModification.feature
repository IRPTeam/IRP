#language: en
@tree
@Positive
@AccessRights

Feature: lock data modification

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: 950400 preparation
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink 'e1cib/list/Document.PriceList'
	And I go to line in "List" table
		| 'Number'   |
		| '100'      |
	And in the table "List" I click the button named "ListContextMenuPost"
	* Filling settings for attribute from extension
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Catalog_Currencies'      |
		And I select current line in "List" table
		And I move to "Extension attributes" tab
		And in the table "ExtensionAttributes" I click "Fill attributes list" button
		And "ExtensionAttributes" table became equal
			| '#'   | 'Required'   | 'Attribute'        | 'Show'   | 'UI group'   | 'Show in HTML'    |
			| '1'   | 'No'         | 'REP_Attribute1'   | 'No'     | ''           | 'No'              |
		And I set "Show" checkbox in "ExtensionAttributes" table
		And I select current line in "ExtensionAttributes" table
		And I click choice button of the attribute named "ExtensionAttributesInterfaceGroup" in "ExtensionAttributes" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Accounting information'    |
		And I select current line in "List" table
		And I finish line editing in "ExtensionAttributes" table
		And I click "Save and close" button
	* Filling in attribute from extension
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I input "2" text in "REP_Attribute1" field
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'        |
			| 'American dollar'    |
		And I select current line in "List" table
		And I input "3" text in "REP_Attribute1" field
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Euro'           |
		And I select current line in "List" table
		And I input "4" text in "REP_Attribute1" field
		And I click "Save and close" button
		And I close all client application windows
		When Create information register Taxes records (VAT)
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
		When Create catalog CancelReturnReasons objects
		When Create catalog Companies objects (own Second company)
	* Change test user info
			Given I open hyperlink "e1cib/list/Catalog.Users"
			And I go to line in "List" table
					| 'Description'                    |
					| 'Arina Brown (Financier 3)'      |
			And I select current line in "List" table
			And I select "English" exact value from "Data localization" drop-down list	
			And I click "Save" button
			Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
			And I go to line in "List" table
				| 'Description'        |
				| 'Administrators'     |
			And I select current line in "List" table
			And I click "Save and close" button	
	* Load SI and change it date
		When Create document SalesInvoice objects (stock control)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
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
		When Data preparation for LockDataModificationReasons (LockDataModificationReasons (9 reasons for 3 registers) + SO)
		When Data preparation for LockDataModificationReasons (LockDataModificationReasons (2 reasons for 1 register) + StockAdjustmentAsSurplus)
		When Data preparation for LockDataModificationReasons (LockDataModificationReasons (2 reasons for 1 document) + StockAdjustmentAsWriteOff)
		When Data preparation for LockDataModificationReasons (LockDataModificationReasons (3 reasons for 3 documents) + RSC, RGR, SC)
	* Load documents
		When Create document PurchaseOrder objects
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server	
				| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseOrder objects (with aging, prepaid, post-shipment credit)	
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document GoodsReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server	
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
				// | "Documents.GoodsReceipt.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.GoodsReceipt.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseInvoice objects (with aging, prepaid, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window
		
Scenario: 9504001 check preparation
	When check preparation		

Scenario: 950403 check function option UseLockDataModification
	When in sections panel I select "Settings"
	And functions panel does not contain menu items
		| "Lock data modification reasons"   |
		| "Lock data modification rules"     |
	And I execute 1C:Enterprise script at server
				| "Constants.UseLockDataModification.Set(True);"     |
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
			|  'Description'      |
			| 'lock documents'    |
		And I close all client application windows
	* Check rules (=)
		* Modification
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'     |
				| '1'          |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock documents" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'     |
				| '1'          |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I move to "Other" tab
			And I input "07.10.2020 00:00:00" text in "Date" field
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I move to the next attribute
			If current window header is "Update item list info" Then
				And I click "OK" button		
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock documents" string by template
			And I close all client application windows
		* Marked for deletion
			Given I open hyperlink 'e1cib/list/Document.SalesOrder'
			And I go to line in "List" table
				| 'Number'     |
				| '1'          |
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
				| 'Number'     |
				| '1'          |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Save" button
			And I click "Post and close" button
			And "List" table contains lines
				| 'Number'     |
				| '1'          |
				| '108'        |
			And I close all client application windows			
	* Check rules (in)
		* Modification
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'     |
				| '15'         |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock documents" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'     |
				| '15'         |
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
				| 'Number'     |
				| '15'         |
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
				| 'Number'     |
				| '1'          |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click "Save" button
			And I click "Post and close" button
			Then user message window does not contain messages
			And "List" table contains lines
				| 'Number'     |
				| '1'          |
				| '108'        |
			And I close all client application windows	
	* Delete rules
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Description'         |
			| 'lock documents'    |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows	
		


Scenario: 950406 create rules for documents (number of days from the current date for User)
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
				| "Number"     |
				| "16"         |
				And I go to line in "List" table
					| 'Number'      |
					| '15'          |
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
			| 'Description'                  |
			| 'Arina Brown (Financier 3)'    |
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
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for User" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '16'        |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages
	* Change user and check lock data (user without locks)
		And I close TestClient session
		Then I connect launched Test client "Этот клиент"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages



Scenario: 9504061 create rules for documents (number of days from the current date for User group)
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
				| "Number"     |
				| "16"         |
				And I go to line in "List" table
					| 'Number'      |
					| '15'          |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I move to "Other" tab
				And I input "0" text in "Number" field
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
				And I input "16" text in "Number" field
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
			| 'Description'                                        |
			| 'number of days from the current date for User'    |
			And I go to line in "List" table
				| 'Description'                                         |
				| 'number of days from the current date for User'     |
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
			| 'Description'       |
			| 'Administrators'    |
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
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for User group" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '16'        |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages
	* Change user and check lock data (user without locks)
		And I close TestClient session
		Then I connect launched Test client "Этот клиент"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Post and close" button
		Then user message window does not contain messages

Scenario: 9504062 create rules for documents (number of days from the current date for all objects)
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	If "List" table contains lines Then
			| 'Description'                                              |
			| 'number of days from the current date for User group'    |
		And I go to line in "List" table
			| 'Description'                                              |
			| 'number of days from the current date for User group'    |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Create rule for all objects
		And I click the button named "FormCreate"
		And I input "number of days from the current date for all objects" text in "ENG" field
		And I set checkbox "Set one rule for all objects"
		And I set checkbox "For all users"
		Then "Lock data modification reason (create) *" window is opened
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
			| 'Number'    |
			| '251'       |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for all objects" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*number of days from the current date for all objects" string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "9,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table		
		And I click "Post and close" button
		Then user message window does not contain messages
				
		
				

Scenario: 950407 create rules for accumulation register
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
				| "Number"     |
				| "16"         |
				And I go to line in "List" table
					| 'Number'      |
					| '15'          |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Document.SalesOrder'
		If "List" table does not contain lines Then
				| "Number"     |
				| "2"          |
				And I go to line in "List" table
					| 'Number'      |
					| '1'           |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Description'                                                |
				| 'number of days from the current date for all objects'     |
			And I go to line in "List" table
				| 'Description'                                                |
				| 'number of days from the current date for all objects'     |
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
			| 'Description'    |
			| 'Store 02'       |
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
				| 'Number'     |
				| '108'        |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
			Then "1C:Enterprise" window is opened
			And I click "OK" button			
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock accumulation register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'     |
				| '1'          |
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
				| 'Number'     |
				| '108'        |
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
				| 'Number'     |
				| '108'        |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
	* Check rules (in)
		* Modification (UndoPosting)
			Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
			And I go to line in "List" table
				| 'Number'     |
				| '16'         |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"			
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock accumulation register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'     |
				| '15'         |
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
				| 'Number'     |
				| '16'         |
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
				| 'Number'     |
				| '16'         |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
	* Delete rules
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Description'                     |
			| 'lock accumulation register'    |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows	

// Scenario: 950408 create rules for accumulation register (two rules for one register)
// 	And I close all client application windows
// 	* Create rule for AccumulationRegister.R4010B_ActualStocks
// 		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
// 		And I click the button named "FormCreate"
// 		And I input "lock accumulation register (two rules for one register)" text in "ENG" field
// 		And I set checkbox "For all users"
// 		* First rule
// 			And in the table "RuleList" I click the button named "RuleListAdd"
// 			And I select "R4050 Stock inventory" exact value from "Type" drop-down list in "RuleList" table
// 			And I move to the next attribute
// 			And I select "Store" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
// 			And I move to the next attribute
// 			And I select "=" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
// 			And I move to the next attribute
// 			And I click choice button of the attribute named "RuleListValue" in "RuleList" table
// 			And I go to line in "List" table
// 				| 'Description'    |
// 				| 'Store 01'       |
// 			And I select current line in "List" table
// 			And I finish line editing in "RuleList" table
// 		* Second rule
// 			And in the table "RuleList" I click the button named "RuleListAdd"
// 			And I select "R4050 Stock inventory" exact value from "Type" drop-down list in "RuleList" table
// 			And I move to the next attribute
// 			And I select "Period" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
// 			And I move to the next attribute
// 			And I select "<" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
// 			And I move to the next attribute
// 			Then "lock accumulation register (two rules for one register) (Lock data modification reason)" window is opened
// 			And I activate field named "RuleListValue" in "RuleList" table
// 			And I select current line in "RuleList" table
// 			And I input "20.02.2024 00:00:00" text in the field named "RuleListValue" of "RuleList" table
// 			And I finish line editing in "RuleList" table
// 			And I click "Save and close" button
// 	* Check rules (=)


Scenario: 950409 create rules for information register (with recorder)
	* Preparation
		Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
		If "List" table does not contain lines Then
			| "Number"    |
			| "16"        |
				And I go to line in "List" table
					| 'Number'      |
					| '15'          |
				And in the table "List" I click the button named "ListContextMenuCopy"
				And I click "Post and close" button
		Given I open hyperlink 'e1cib/list/Document.SalesOrder'
		If "List" table does not contain lines Then
				| "Number"     |
				| "108"        |
				And I go to line in "List" table
					| 'Number'      |
					| '1'           |
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
			| 'Item key'    | 'Item'        |
			| '38/Yellow'   | 'Trousers'    |
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
				| 'Number'     |
				| '108'        |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
			Then "1C:Enterprise" window is opened
			And I click "OK" button			
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock information register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'     |
				| '1'          |
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
				| 'Number'     |
				| '108'        |
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
				| 'Number'     |
				| '108'        |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
			And I close all client application windows
	* Check rules (in)
		* Modification (UndoPosting)
			Given I open hyperlink 'e1cib/list/Document.PriceList'
			And I go to line in "List" table
				| 'Number'     |
				| '100'        |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"			
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock information register" string by template
		* Create new
			And I go to line in "List" table
				| 'Number'     |
				| '100'        |
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
				| 'Number'     |
				| '100'        |
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
				| 'Number'     |
				| '100'        |
			And in the table "List" I click the button named "ListContextMenuPost"
			When I Check the steps for Exception
				| 'Then "1C:Enterprise" window is opened'    |
			Then user message window does not contain messages
			And I close all client application windows
		* Delete rules
			Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
			And I go to line in "List" table
				| 'Description'                     |
				| 'lock information register'     |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I close all client application windows	

Scenario: 950410 check rules for accumulation and information registers (9 rules for 3 register)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.LockDataModificationReasons"
		And I go to line in "List" table
			| 'Advanced mode' | 'Description'                                                   | 'For all users' | 'One rule' |
			| 'No'            | '3 rules for 3 register (Free stock, Price, Stock reservation)' | 'Yes'           | 'No'       |
		And I select current line in "List" table
		And I remove checkbox "Disable rule"
		And I click "Save and close" button
	* Check rule - accumulations registers
		Given I open hyperlink "e1cib/list/Document.SalesOrder"				
		And I go to line in "List" table
			| 'Amount' | 'Date'                | 'Number' |
			| '920,00' | '30.12.2023 00:00:00' | '107'    |
		And I select current line in "List" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Data lock reasons:\n3 rules for 3 register (Free stock, Price, Stock reservation)'|
	* Change item in the SO and check rule
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I activate "Item key" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "L/Green" from "Item key" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Store 02" by string from the drop-down list named "ItemListStore" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Data lock reasons:\n3 rules for 3 register (Free stock, Price, Stock reservation)'|
	* Change reserve method and check rule
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		When I Check the steps for Exception
			| 'Then "1C:Enterprise" window is opened'    |
		Then user message window does not contain messages
	* Check rule - information registers
		Given I open hyperlink "e1cib/list/Document.PriceList"		
		And I go to line in "List" table
			| 'Date'                | 'Number' | 'Price list type'    | 'Price type'        |
			| '01.11.2018 12:32:22' | '2'      | 'Price by item keys' | 'Basic Price Types' |
		And I select current line in "List" table
		And I go to line in "ItemKeyList" table
			| 'Item'  | 'Item key' | 'Price'  |
			| 'Dress' | 'M/White'  | '520,00' |
		And I activate "Price" field in "ItemKeyList" table
		And I select current line in "ItemKeyList" table
		And I input "510,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Data lock reasons:\n3 rules for 3 register (Free stock, Price, Stock reservation)'|
	And I close all client application windows

Scenario: 9504101 check rules for accumulation registers (2 rules for 1 register)
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Preparation
		And I go to line in "List" table
			| 'Description'                                                   |
			| '3 rules for 3 register (Free stock, Price, Stock reservation)' |
		And I select current line in "List" table
		And I set checkbox "Disable rule"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'                                                   |
			| '2 rules for 1 register (R4052T_StockAdjustmentAsSurplus)' |
		And I select current line in "List" table
		And I remove checkbox "Disable rule"
		And I click "Save and close" button
	* Check rule
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"				
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '19.02.2024 12:00:00' | '1 902'  |
		And I select current line in "List" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Data lock reasons:\n2 rules for 1 register (R4052T_StockAdjustmentAsSurplus)'|		
	* Change date and check rule
		And I move to "Other" tab
		And I input "28.02.2024 00:00:00" text in the field named "Date"
		And I click "Post" button
		When I Check the steps for Exception
			| 'Then "1C:Enterprise" window is opened'    |
		Then user message window does not contain messages
	And I close all client application windows
				
Scenario: 9504102 check rules for documents (2 rules for 1 document)
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Preparation
		And I go to line in "List" table
			| 'Description'                                              |
			| '2 rules for 1 register (R4052T_StockAdjustmentAsSurplus)' |
		And I select current line in "List" table
		And I set checkbox "Disable rule"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'                                        |
			| '2 rules for 1 document (StockAdjustmentAsWriteOff)' |
		And I select current line in "List" table
		And I remove checkbox "Disable rule"
		And I click "Save and close" button	
	* Check rule
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"				
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '19.02.2024 12:00:00' | '1 019'  |
		And I select current line in "List" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Data lock reasons:\n2 rules for 1 document (StockAdjustmentAsWriteOff)'|
	* Change date and check rule
		And I move to "Other" tab
		And I input "28.02.2024 00:00:00" text in the field named "Date"
		And I click "Post" button
		When I Check the steps for Exception
			| 'Then "1C:Enterprise" window is opened'    |
		Then user message window does not contain messages
	And I close all client application windows	

Scenario: 9504103 check rules for documents (3 rules for 3 documents)
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Preparation
		And I go to line in "List" table
			| 'Description'                                        |
			| '2 rules for 1 document (StockAdjustmentAsWriteOff)' |
		And I select current line in "List" table
		And I set checkbox "Disable rule"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'                                                                                   |
			| '3 rules for 3 document (RetailGoodsReceipt, RetailShipmentConfirmation, ShipmentConfirmation)' |
		And I select current line in "List" table
		And I remove checkbox "Disable rule"
		And I click "Save and close" button	
	* Check rule for first document
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"				
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '19.02.2024 12:00:00' | '109'    |
		And I select current line in "List" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Data lock reasons:\n3 rules for 3 document (RetailGoodsReceipt, RetailShipmentConfirmation, ShipmentConfirmation)'|
		* Change date and check rule
			And I move to "Other" tab
			And I input "28.02.2024 00:00:00" text in the field named "Date"
			And I click "Post" button
			When I Check the steps for Exception
				| 'Then "1C:Enterprise" window is opened'    |
			Then user message window does not contain messages		
	* Check rule for second document
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"				
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '20.02.2024 12:00:00' | '109'    |
		And I select current line in "List" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"			
		Then there are lines in TestClient message log
			|'Data lock reasons:\n3 rules for 3 document (RetailGoodsReceipt, RetailShipmentConfirmation, ShipmentConfirmation)'|
		* Change date and check rule
			And I move to "Other" tab
			And I input "28.02.2024 00:00:00" text in the field named "Date"
			And I click "Post" button
			When I Check the steps for Exception
				| 'Then "1C:Enterprise" window is opened'    |
			Then user message window does not contain messages	
	* Check rule for third document
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"				
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '21.02.2024 12:00:00' | '109'    |
		And I select current line in "List" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"			
		Then there are lines in TestClient message log
			|'Data lock reasons:\n3 rules for 3 document (RetailGoodsReceipt, RetailShipmentConfirmation, ShipmentConfirmation)'|
		* Change date and check rule
			And I move to "Other" tab
			And I input "28.02.2024 00:00:00" text in the field named "Date"
			And I click "Post" button
			When I Check the steps for Exception
				| 'Then "1C:Enterprise" window is opened'    |
			Then user message window does not contain messages
		And I close all client application windows
		


Scenario: 950411 create rules for catalog (<)
		And I close all client application windows
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	* Preparation 
		And I go to line in "List" table
			| 'Description'                                                                                   |
			| '3 rules for 3 document (RetailGoodsReceipt, RetailShipmentConfirmation, ShipmentConfirmation)' |
		And I select current line in "List" table
		And I set checkbox "Disable rule"
		And I click "Save and close" button	
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
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10002"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Shirt'           |
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
				| 'Description'     |
				| 'Clothes'         |
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
				| 'Description'     |
				| 'Dress'           |
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
				| 'Description'     |
				| 'Test'            |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows

Scenario: 950412 create rules for catalog (<=)
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	If "List" table contains lines Then
			| 'Description'         |
			| 'lock catalog <'    |
		And I go to line in "List" table
			| 'Description'         |
			| 'lock catalog <'    |
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
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <=" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10004"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <=" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'High shoes'      |
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
				| 'Description'     |
				| 'Clothes'         |
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
				| 'Description'     |
				| 'Dress'           |
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
				| 'Description'     |
				| 'Test 2'          |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows
	

Scenario: 950413 create rules for catalog (>)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Description'           |
				| 'lock catalog <='     |
			And I go to line in "List" table
				| 'Description'           |
				| 'lock catalog <='     |
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
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then user message window does not contain messages
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Shirt'           |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10003"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
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
				| 'Description'     |
				| 'Clothes'         |
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
				| 'Description'     |
				| 'Shirt'           |
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
				| 'Description'     |
				| 'Test 3'          |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows


Scenario: 950414 create rules for catalog (>=)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Description'          |
				| 'lock catalog >'     |
			And I go to line in "List" table
				| 'Description'          |
				| 'lock catalog >'     |
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
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10001"
			And I click "Save" button
			Then user message window does not contain messages
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Shirt'           |
			And I select current line in "List" table
			Then the form attribute named "ItemID" became equal to "10003"
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog >=" string by template
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
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
				| 'Description'     |
				| 'Clothes'         |
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
				| 'Description'     |
				| 'Trousers'        |
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
				| 'Description'     |
				| 'Test 4'          |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows
	

Scenario: 950415 create rules for catalog (=)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Description'           |
				| 'lock catalog >='     |
			And I go to line in "List" table
				| 'Description'           |
				| 'lock catalog >='     |
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
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog item type" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"		
			Then user message window does not contain messages
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 5" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Clothes'         |
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
				| 'Description'     |
				| 'Shoes'           |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
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
				| 'Description'     |
				| 'Test 5'          |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows
	

Scenario: 950416 create rules for catalog (<>)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Description'                  |
				| 'lock catalog item type'     |
			And I go to line in "List" table
				| 'Description'                  |
				| 'lock catalog item type'     |
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
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog <>" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"		
			Then user message window does not contain messages
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Items'
			And I click the button named "FormCreate"
			And I input "Test 6" text in "ENG" field
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Shoes'           |
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
				| 'Description'     |
				| 'Clothes'         |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
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
				| 'Description'     |
				| 'Test 6'          |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows


Scenario: 950417 create rules for catalog (IN HIERARCHY)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Description'           |
				| 'lock catalog <>'     |
			And I go to line in "List" table
				| 'Description'           |
				| 'lock catalog <>'     |
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
				| 'Description'          |
				| 'Partner Ferron 1'     |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN HIERARCHY" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Lomaniti'        |
			And I select current line in "List" table
			And I click the button named "FormWriteAndClose"		
			Then user message window does not contain messages
		* Create new
			Given I open hyperlink 'e1cib/list/Catalog.Partners'
			And I click the button named "FormCreate"
			And I input "Test 7" text in "ENG" field
			And I click Select button of "Main partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I set checkbox named "Customer"			
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN HIERARCHY" string by template	
			And I click Select button of "Main partner" field
			And I click "List" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Alians'          |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description'          |
				| 'Partner Ferron 2'     |
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
				| 'Description'     |
				| 'Test 7'          |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button	
			Then user message window does not contain messages
			And I close all client application windows

	

Scenario: 950418 create rules for catalog (IN)
	* Create rule
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		If "List" table contains lines Then
				| 'Description'                     |
				| 'lock catalog IN HIERARCHY'     |
			And I go to line in "List" table
				| 'Description'                     |
				| 'lock catalog IN HIERARCHY'     |
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
				| 'Description'     |
				| 'Table'           |
			And I select current line in "List" table
			And I click "Save" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "lock catalog IN" string by template	
			And I close current window
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
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
				| 'Description'     |
				| 'Furniture'       |
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
				| 'Description'     |
				| 'Clothes'         |
			And I select current line in "List" table
			And I click "Save and close" button	
			Then user message window does not contain messages
		* Deletion
			And I go to line in "List" table
				| 'Description'     |
				| 'Table'           |
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
				| 'Description'     |
				| 'Test 15'         |
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
				| 'Currency from'    | 'Currency to'    | 'Multiplicity'    | 'Period'                 | 'Rate'      | 'Source'      |
				| 'UAH'              | 'USD'            | '1'               | '07.09.2020 00:00:00'    | '0,036100'  | 'Bank UA'     |
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
				| 'Currency from'    | 'Currency to'    | 'Multiplicity'    | 'Period'                 | 'Rate'      | 'Source'      |
				| 'UAH'              | 'USD'            | '1'               | '07.09.2020 00:00:00'    | '0,036100'  | 'Bank UA'     |
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
				| 'Currency from'    | 'Currency to'    | 'Multiplicity'    | 'Period'                 | 'Rate'      | 'Source'      |
				| 'UAH'              | 'USD'            | '1'               | '07.09.2020 00:00:00'    | '0,036100'  | 'Bank UA'     |
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
				| 'Currency from'    | 'Currency to'    | 'Multiplicity'    | 'Period'                 | 'Rate'      | 'Source'      |
				| 'UAH'              | 'USD'            | '1'               | '07.09.2020 00:00:00'    | '0,036100'  | 'Bank UA'     |
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
				| 'Tax'     |
				| 'VAT'     |
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
				| 'Tax'     |
				| 'VAT'     |
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
				| 'Tax'     |
				| 'VAT'     |
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
				| 'Tax'     |
				| 'VAT'     |
			And I select current line in "List" table
			And I click "Save and close" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Data lock reasons:*" string by template
			Given Recent TestClient message contains "information register (without recorder)" string by template
			And I close all client application windows
	# * Does not fall under the conditions
	# 		Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
	# 		And I go to line in "List" table
	# 			| 'Tax'          |
	# 			| 'SalesTax'     |
	# 		And I select current line in "List" table
	# 		And I click "Save and close" button
	# 		Then user message window does not contain messages
	# 		Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
	# 		And I go to line in "List" table
	# 			| 'Currency from'    | 'Currency to'    | 'Multiplicity'    | 'Period'                 | 'Rate'      | 'Source'           |
	# 			| 'USD'              | 'EUR'            | '1'               | '21.06.2019 17:40:13'    | '1,1235'    | 'Forex Seling'     |
	# 		And I select current line in "List" table
	# 		And I click "Save and close" button
	# 		Then user message window does not contain messages	


Scenario: 950425 check that Disable rule does not work
	* All Reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Description'                                  |
			| 'information register (without recorder)'    |
		And I select current line in "List" table
		And I set checkbox "Disable rule"
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
		And I go to line in "List" table
			| 'Currency from'   | 'Currency to'   | 'Multiplicity'   | 'Period'                | 'Rate'     | 'Source'     |
			| 'UAH'             | 'USD'           | '1'              | '07.09.2020 00:00:00'   | '0,036100' | 'Bank UA'    |
		And I select current line in "List" table
		And I click "Save and close" button
		Then user message window does not contain messages	
		And I close all client application windows
		Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
		And I go to line in "List" table
			| 'Tax'    |
			| 'VAT'    |
		And I select current line in "List" table
		And I click "Save and close" button
		Then user message window does not contain messages	
		And I close all client application windows
	* One rule from reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Description'                                  |
			| 'information register (without recorder)'    |
		And I select current line in "List" table
		And I remove checkbox named "DisableRule"
		And I go to line in "RuleList" table
			| 'Type'                         |
			| 'InformationRegister.Taxes'    |
		And I set checkbox named "RuleListDisableRule" in "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
		Given I open hyperlink 'e1cib/list/InformationRegister.Taxes'
		And I go to line in "List" table
			| 'Tax'    |
			| 'VAT'    |
		And I select current line in "List" table
		And I click "Save and close" button
		Then user message window does not contain messages	
		And I close all client application windows
		Given I open hyperlink 'e1cib/list/InformationRegister.CurrencyRates'
		And I go to line in "List" table
			| 'Currency from'   | 'Currency to'   | 'Multiplicity'   | 'Period'                | 'Rate'     | 'Source'     |
			| 'UAH'             | 'USD'           | '1'              | '07.09.2020 00:00:00'   | '0,036100' | 'Bank UA'    |
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
				| 'Description'     |
				| 'Euro'            |
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
				| 'Description'     |
				| 'Euro'            |
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
				| 'Description'     |
				| 'Euro1'           |
			And I go to line in "List" table
				| 'Description'     |
				| 'Euro'            |
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
				| 'Description'     |
				| 'Euro'            |
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
				| 'Description'         |
				| 'American dollar'     |
			And I select current line in "List" table
			And I click "Save and close" button
			Then user message window does not contain messages

 




Scenario: 950435 check the priorities of a simple and advanced data locking rule
	And I close all client application windows
	* Create simple lock data reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "GR number simple" text in "ENG" field
		And I set checkbox "For all users"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Goods receipt" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I select "Number" exact value from the drop-down list named "RuleListAttribute" in "RuleList" table
		And I move to the next attribute
		And I select "<" exact value from the drop-down list named "RuleListComparisonType" in "RuleList" table
		And I move to the next attribute
		And I click choice button of the attribute named "RuleListValue" in "RuleList" table
		And I select current line in "RuleList" table
		And I input "116" text in the field named "RuleListValue" of "RuleList" table
		And I finish line editing in "RuleList" table
		And I click "Save and close" button
		And "List" table contains lines
			| 'Advanced mode'   | 'For all users'   | 'One rule'   | 'Disable'   | 'Description'         |
			| 'No'              | 'Yes'             | 'No'         | 'No'        | 'GR number simple'    |
	* Create advanced lock data reason
		And I click the button named "FormCreate"
		And I input "GR number advanced" text in "ENG" field
		And I set checkbox "Advanced mode"
		And I set checkbox "For all users"
		And I set checkbox "Set one rule for all objects"
		And I activate field named "RuleListLineNumber" in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Goods receipt" exact value from "Type" drop-down list in "RuleList" table
		And I move to "Advanced rules" tab
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Number" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I activate field named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I select "Less than" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I input "117" text in the field named "SettingsFilterRightValue" of "SettingsFilter" table
		And I finish line editing in "SettingsFilter" table
		And I click "Save and close" button
		And "List" table contains lines
			| 'Advanced mode'   | 'For all users'   | 'One rule'   | 'Disable'   | 'Description'             |
			| 'Yes'             | 'Yes'             | 'Yes'        | 'No'        | 'GR number advanced'    |
	* Check priority
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
		And in the table "List" I click "Post" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "GR number simple" string by template
		And I go to line in "List" table
			| 'Number'    |
			| '116'       |
		And in the table "List" I click "Post" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "GR number advanced:" string by template
		Given Recent TestClient message contains 'Number Less than "117"' string by template	
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button			
		Then user message window does not contain messages						

Scenario: 950436 create advanced rules for branch and date
	And I close all client application windows
	And I mark "Catalogs.LockDataModificationReasons" objects for deletion	
	* Create reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I set checkbox "Advanced mode"
		And I set checkbox "For all users"
		And I set checkbox "Set one rule for all objects"
		And I input "Branch and Date for purchase" text in "ENG" field
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Purchase invoice" exact value from "Type" drop-down list in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Purchase order" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Goods receipt" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Internal supply request" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Branch" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Date" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Less than" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I activate "Date" field in "SettingsFilter" table
		And I input "12.02.2021 16:20:00" text in "Date" field of "SettingsFilter" table
		And I finish line editing in "SettingsFilter" table
	* Check filter query tab
		And I move to "Filter query" tab
		And the field named "QueryFilter" is filled		
		And I click "Save and close" button
	* Check creation
		And "List" table contains lines
			| 'Advanced mode'   | 'For all users'   | 'One rule'   | 'Disable'   | 'Description'                     |
			| 'Yes'             | 'Yes'             | 'Yes'        | 'No'        | 'Branch and Date for purchase'    |
	* Check	rules
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button			
		Then user message window does not contain messages	
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Branch and Date for purchase:" string by template
		Given Recent TestClient message contains 'Branch Equal to "Front office" AND Date Less than "12.02.2021 16:20:00"' string by template
		And I go to line in "List" table
			| 'Number'    |
			| '119'       |
		And in the table "List" I click "Post" button			
		Then user message window does not contain messages	
		And I connect "TestAdmin4" TestClient using "ABrown" login and "" password
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button
		And I click "OK" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Branch and Date for purchase:" string by template
		Given Recent TestClient message contains 'Branch Equal to "Front office" AND Date Less than "12.02.2021 16:20:00"' string by template
		And I close TestClient session
		And I connect "Этот клиент" profile of TestClient		

Scenario: 950437 add responsible user in the lock data modification reasons
	And I connect "Этот клиент" profile of TestClient
	And I close all client application windows
	And I mark "Catalogs.LockDataModificationReasons" objects for deletion	
	* Create reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "Branch with responsible user" text in "ENG" field
		And I set checkbox "Advanced mode"
		And I set checkbox "For all users"
		And I set checkbox "Set one rule for all objects"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Goods receipt" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Internal supply request" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		When I Check the steps for Exception
			| 'And I select "Transaction type" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table'    |
		And I select "Branch" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		* Add responsible user
			And I move to "Responsible users" tab
			And in the table "ResponsibleUsers" I click the button named "ResponsibleUsersAdd"
			And I click choice button of the attribute named "ResponsibleUsersUser" in "ResponsibleUsers" table
			And I go to line in "List" table
				| 'Login'     |
				| 'CI'        |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And "ResponsibleUsers" table became equal
				| 'User'     |
				| 'CI'       |
			* Check set current user
				And I delete a line in "ResponsibleUsers" table
				And in the table "ResponsibleUsers" I click "Set current user" button
				And "ResponsibleUsers" table became equal
					| 'User'      |
					| 'CI'        |
			And I click "Save and close" button
		* Check
			And I connect "TestAdmin4" TestClient using "ABrown" login and "" password
			Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
			And I go to line in "List" table
				| 'Description'                      |
				| 'Branch with responsible user'     |
			And I select current line in "List" table
			When I Check the steps for Exception
				| 'And I click choice button of the attribute named "ResponsibleUsersUser" in "ResponsibleUsers" table'     |
			When I Check the steps for Exception
				| 'And I click "Save and close" button'     |
			And I close TestClient session
			And I connect "Этот клиент" profile of TestClient	
			Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
			And I go to line in "List" table
				| 'Description'                      |
				| 'Branch with responsible user'     |
			And I select current line in "List" table			
			And I click "Save and close" button	
			Then user message window does not contain messages		

Scenario: 950438 lock data modification reasons for user
	And I connect "Этот клиент" profile of TestClient
	And I close all client application windows
	And I mark "Catalogs.LockDataModificationReasons" objects for deletion	
	* Create reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "Branch (user)" text in "ENG" field
		And I set checkbox "Advanced mode"
		And I set checkbox "Set one rule for all objects"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Goods receipt" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Internal supply request" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Branch" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		Then "Lock data modification reason (create) *" window is opened
		And I move to "Users" tab
		And in the table "UserList" I click the button named "UserListAdd"
		And I click choice button of the attribute named "UserListUser" in "UserList" table
		And I go to line in "List" table
			| 'Description'                  |
			| 'Arina Brown (Financier 3)'    |
		And I select current line in "List" table
		Then "Lock data modification reason (create) *" window is opened
		And I finish line editing in "UserList" table
		And I click "Save and close" button
		And I wait "Lock data modification reason (create) *" window closing in 20 seconds
	* Check
		And I connect "TestAdmin4" TestClient using "ABrown" login and "" password
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button
		And I click "OK" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Branch (user):" string by template
		Given Recent TestClient message contains 'Branch Equal to "Front office"' string by template
		And I close TestClient session
		And I connect "Этот клиент" profile of TestClient
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button
		Then user message window does not contain messages	


Scenario: 950439 lock data modification reasons for user group
	And I connect "Этот клиент" profile of TestClient
	And I close all client application windows
	And I mark "Catalogs.LockDataModificationReasons" objects for deletion	
	* Create reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I input "Branch (user group)" text in "ENG" field
		And I set checkbox "Advanced mode"
		And I set checkbox "Set one rule for all objects"
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Goods receipt" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Internal supply request" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Branch" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		And I move to "Access groups" tab
		And in the table "AccessGroupList" I click the button named "AccessGroupListAdd"
		And I click choice button of "Access group" attribute in "AccessGroupList" table
		Then "User access groups" window is opened
		And I go to line in "List" table
			| 'Description'       |
			| 'Administrators'    |
		And I select current line in "List" table	
		And I click "Save and close" button
	* Check
		And I connect "TestAdmin4" TestClient using "ABrown" login and "" password
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Branch (user group):" string by template
		And I close TestClient session
		And I connect "Этот клиент" profile of TestClient
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button
		Then user message window does not contain messages

// Scenario: 950440 lock data modification reasons with cross fields
// 	And I connect "Этот клиент" profile of TestClient
// 	And I close all client application windows
// 	And I mark "Catalogs.LockDataModificationReasons" objects for deletion	
// 	* Create reason
// 		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
// 		And I click the button named "FormCreate"
// 		And I input "Date of shipment (cross fields)" text in "ENG" field
// 		And I set checkbox "Advanced mode"
// 		And I set checkbox "For all users"
// 		And I set checkbox "Set one rule for all objects"
// 		And in the table "RuleList" I click the button named "RuleListAdd"
// 		And I select "Sales invoice" exact value from "Type" drop-down list in "RuleList" table
// 		And I move to the next attribute
// 		And I move to "Advanced rules" tab
// 		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
// 		And I select "Date of shipment" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
// 		And I move to the next attribute
// 		And I click choice button of the attribute named "SettingsFilterComparisonType" in "SettingsFilter" table
// 		And I finish line editing in "SettingsFilter" table
// 		And in the table "SettingsFilter" I click the button named "SettingsFilterUseFieldAsValue"
// 		And I select current line in "SettingsFilter" table
// 		And I select "Less than" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
// 		And I activate field named "SettingsFilterRightValue" in "SettingsFilter" table
// 		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
// 		Then "Select field" window is opened
// 		And I expand a line in "Source" table
// 			| 'Available fields' |
// 			| 'Date'             |
// 		And I expand a line in "Source" table
// 			| 'Available fields' |
// 			| 'End dates'        |
// 		And I go to line in "Source" table
// 			| 'Available fields' |
// 			| 'End of week'      |
// 		And I select current line in "Source" table
// 		And I click "Save and close" button
// 		And "List" table contains lines
// 			| 'Advanced mode' | 'For all users' | 'One rule' | 'Disable' |  'Description'                      |
// 			| 'Yes'           | 'Yes'           | 'Yes'      | 'No'      | 'Date of shipment (cross fields)'   |
// 	* Check
// 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
// 		And I go to line in "List" table
// 			| 'Number' |
// 			| '251'    |
// 		And I select current line in "List" table
// 		And I click Select button of "Delivery date" field
// 		And I input current date in "Delivery date" field
// 		And I go to line in "ItemList" table
// 			| 'Item' |
// 			| 'Bag'  |	
// 		And I click "Post" button
// 		And I click "OK" button
// 		Given Recent TestClient message contains "Data lock reasons:*" string by template
// 		Given Recent TestClient message contains "Date of shipment (cross fields):" string by template
// 		Given Recent TestClient message contains 'DateOfShipment Less than Date.EndDates.EndOfWeek' string by template
// 		And I close all client application windows


Scenario: 950441 check is object lock on open (documents)
	And I close all client application windows
	And I mark "Catalogs.LockDataModificationReasons" objects for deletion	
	* Create reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I set checkbox "Advanced mode"
		And I set checkbox "For all users"
		And I set checkbox "Set one rule for all objects"
		And I set checkbox "Check is object locked on open"	
		And I input "Check is object lock on open (documents)" text in "ENG" field
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Purchase invoice" exact value from "Type" drop-down list in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Purchase order" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Goods receipt" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Internal supply request" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Branch" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		And I finish line editing in "SettingsFilter" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterGroupFilterItems"
		And I select "OR group" exact value from "Group type" drop-down list in "SettingsFilter" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Date" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Less than" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I activate "Date" field in "SettingsFilter" table
		And I input "12.02.2021 16:20:00" text in "Date" field of "SettingsFilter" table
		And I finish line editing in "SettingsFilter" table
		And I click "Save and close" button			
	* Check creation
		And "List" table contains lines
			| 'Advanced mode'   | 'For all users'   | 'One rule'   | 'Disable'   | 'Description'                                   |
			| 'Yes'             | 'Yes'             | 'Yes'        | 'No'        | 'Check is object lock on open (documents)'    |
	* Check	rules
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button			
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (documents):" string by template
		Given Recent TestClient message contains '( Branch Equal to "Front office" OR Date Less than "12.02.2021 16:20:00" )' string by template
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And I select current line in "List" table
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (documents):" string by template
		Given Recent TestClient message contains '( Branch Equal to "Front office" OR Date Less than "12.02.2021 16:20:00" )' string by template
		When I Check the steps for Exception
			| 'And I click "Post and close" button'    |
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I move to "Other" tab
		And I input "05.10.2020 00:00:00" text in the field named "Date"
		And I click "Post" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (documents):" string by template
		Given Recent TestClient message contains '( Branch Equal to "Front office" OR Date Less than "12.02.2021 16:20:00" )' string by template
		And I input "05.10.2022 00:00:00" text in the field named "Date"
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click "Post" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (documents):" string by template
		Given Recent TestClient message contains '( Branch Equal to "Front office" OR Date Less than "12.02.2021 16:20:00" )' string by template
		And I input "" text in the field named "Branch"
		And I click "Post" button
		Then user message window does not contain messages	
		And I close all client application windows
																		

Scenario: 950442 check is object lock on open (catalogs)
	And I close all client application windows
	And I mark "Catalogs.LockDataModificationReasons" objects for deletion	
	* Create reason
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click the button named "FormCreate"
		And I set checkbox "Advanced mode"
		And I set checkbox "For all users"
		And I set checkbox "Set one rule for all objects"
		And I set checkbox "Check is object locked on open"	
		And I input "Check is object lock on open (catalogs)" text in "ENG" field
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Items" exact value from "Type" drop-down list in "RuleList" table
		And in the table "RuleList" I click the button named "RuleListAdd"
		And I select "Item keys" exact value from "Type" drop-down list in "RuleList" table
		And I move to the next attribute
		And I move to "Advanced rules" tab
		And I finish line editing in "RuleList" table
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Unit" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from the drop-down list named "SettingsFilterComparisonType" in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		Then "Lock data modification reason (create) *" window is opened
		And I finish line editing in "SettingsFilter" table
		And I click "Save and close" button
	* Check creation
		And "List" table contains lines
			| 'Advanced mode'   | 'For all users'   | 'One rule'   | 'Disable'   | 'Description'                                  |
			| 'Yes'             | 'Yes'             | 'Yes'        | 'No'        | 'Check is object lock on open (catalogs)'    |
	* Check
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click "Save and close" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (catalogs):" string by template
		Given Recent TestClient message contains 'Unit Equal to "pcs"' string by template
		And I close current window
		Given I open hyperlink "e1cib/list/Catalog.ItemKeys"
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And in the table "List" I click "Copy" button
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Black'          |
		And I select current line in "List" table
		And I change the radio button named "UnitMode" value to "Own"
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I click "Save and close" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (catalogs):" string by template
		Given Recent TestClient message contains 'Unit Equal to "pcs"' string by template	
		And I close TestClient session
		
		
Scenario: 950450 check ignore lock modification data
		And I connect "Этот клиент" profile of TestClient
	* Preparation
		And I mark "Catalogs.LockDataModificationReasons" objects for deletion
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I click "Refresh" button	
		And I go to line in "List" table
			| 'Description'                                   |
			| 'Check is object lock on open (documents)'    |
		And Delay 5
		And I activate current test client window
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I go to line in "List" table
			| 'Description'                                  |
			| 'Check is object lock on open (catalogs)'    |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Ignore lock modification data
		And In the command interface I select "Settings" "System settings"
		And I set checkbox "Ignore lock modification data"
	* Check
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click "Save and close" button
		Then user message window does not contain messages	
		And I close all client application windows		
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button
		Then user message window does not contain messages	
		And I close all client application windows	
	* Turn off ignore lock modification data
		And I close all client application windows
		And In the command interface I select "Settings" "System settings"
		Then the form attribute named "IgnoreLockModificationData" became equal to "Yes"		
		And I remove checkbox "Ignore lock modification data"		
	* Check
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click "Post" button	
		And I click "OK" button		
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (documents):" string by template
		Given Recent TestClient message contains '( Branch Equal to "Front office" OR Date Less than "12.02.2021 16:20:00" )' string by template
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I click "OK" button
		Given Recent TestClient message contains "Data lock reasons:*" string by template
		Given Recent TestClient message contains "Check is object lock on open (catalogs):" string by template
		Given Recent TestClient message contains 'Unit Equal to "pcs"' string by template
		And I close all client application windows

		
	
		

Scenario: 950480 check access to the Lock data modification for user with role Full access only read 
	And I connect "SBorisova" TestClient using "SBorisova" login and "F12345" password
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
	And I go to line in "List" table
		| 'Description'                                 |
		| 'information register (without recorder)'   |
	And I select current line in "List" table
	Then the form attribute named "ForAllUsers" became equal to "Yes"
	Then the form attribute named "SetOneRuleForAllObjects" became equal to "No"
	Then the form attribute named "DisableRule" became equal to "No"
	Then the number of "RuleList" table lines is "равно" "2"
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
			

Scenario: 950490 switch off function option and check that rules does not work
	And I connect "Этот клиент" profile of TestClient
	* Preparation
		And I close all client application windows
		And I mark "Catalogs.LockDataModificationReasons" objects for deletion
		Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'
		And I go to line in "List" table
			| 'Description'                   |
			| 'attribute from extension'    |
		And Delay 5
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	And I set "False" value to the constant "UseLockDataModification"
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient
	Given I open hyperlink 'e1cib/list/Catalog.Currencies'
	And I go to line in "List" table
		| 'Description'   |
		| 'Euro'          |
	And I select current line in "List" table
	And I click "Save and close" button
	Then user message window does not contain messages
	When set True value to the constant Use lock data modification
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient


Scenario: 950465 check filter in the LockDataModificationReasons
	And I close all client application windows
	Given I open hyperlink 'e1cib/list/Catalog.LockDataModificationReasons'	
	And I click the button named "FormCreate"
	And I select "Documents" exact value from the drop-down list named "TypeFilter"
	And in the table "RuleList" I click the button named "RuleListAdd"
	When I Check the steps for Exception
		| 'And I select "Item keys" exact value from "Type" drop-down list in "RuleList" table'   |
	And I move to the next attribute
	And I select "Bank receipt" exact value from "Type" drop-down list in "RuleList" table
	And I move to the next attribute
	And in the table "RuleList" I click the button named "RuleListAdd"
	When I Check the steps for Exception
		| 'And I select "Bank receipt" exact value from "Type" drop-down list in "RuleList" table'   |
	And I select "Bank payment" exact value from "Type" drop-down list in "RuleList" table
	And I move to the next attribute
	And I close TestClient session
	And I connect "Этот клиент" profile of TestClient




								

				
						

				
						
				
				
