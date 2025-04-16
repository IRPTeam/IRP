#language: en
@tree
@Positive
@Sales

Functionality: sales order closing

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _0230000 preparation (Sales order closing)
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
		When Create catalog BusinessUnits objects
		When Create catalog Companies objects (partners company)
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
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog CancelReturnReasons objects
		When Create catalog Partners objects
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
		When Create catalog AccessGroups objects
		When Create catalog AccessProfiles objects
		When Create catalog Users objects
	* Create test SO
		When Create document SO, SI, SC objects (SI before SC for check closing)
		When Create document SO, SC, SI objects (for order closing)
	* Repost
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Date'                |
			| '10.04.2025 22:03:13' |
		And I click the button named "FormPost"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Date'                |
			| '10.04.2025 22:04:36' |
		And I click the button named "FormPost"

		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(132).GetObject().Write(DocumentWriteMode.Posting);"     |
	* User rights 
		Given I open hyperlink 'e1cib/list/Catalog.AccessProfiles'
		And I go to line in "List" table
			| "Code" | "Description" |
			| "6"    | "Run client"  |
		And I select current line in "List" table	
		And I go to line in "Roles" table
			| "Configuration" | "Presentation" | "Use" |
			| "IRP"           | "Full access"  | "No"  |
		And I activate field named "RolesConfiguration" in "Roles" table
		And I activate field named "RolesUse" in "Roles" table
		And I change checkbox named "RolesUse" in "Roles" table
		And I finish line editing in "Roles" table
		And I click the button named "FormWrite"
		And in the table "Roles" I click the button named "RolesUpdateRoles"
		And I click the button named "FormWriteAndClose"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
//		And In the command interface I select "Settings" "User access groups"
		And I go to line in "List" table
			| 'Description' |
			| 'Run client'  |
		And I select current line in "List" table
		And I move to the tab named "GroupUsers"
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of the attribute named "UsersUser" in "Users" table
		And I go to line in "List" table
			| "Description" |
			| "Admin"       |
		And I click the button named "FormChoose"
		And I click the button named "FormWriteAndClose"
				
				
Scenario: _0230001 check preparation
	When check preparation


Scenario: _0230001 create and check filling Sales order closing (SO not shipped)
	* Create Sales order closing 
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '132'      | '09.02.2021 19:53:45'    |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "SalesOrder" became equal to "Sales order 132 dated 09.02.2021 19:53:45"
		And "ItemList" table contains lines
			| 'Item'      | 'Quantity'   | 'Unit'   | 'Store'      | 'Item key'   | 'Procurement method'   | 'Cancel'   | 'Delivery date'   | 'Cancel reason'   | 'Sales person'       |
			| 'Dress'     | '1,000'      | 'pcs'    | 'Store 02'   | 'XS/Blue'    | 'Stock'                | 'Yes'      | '09.02.2021'      | ''                | 'Alexander Orlov'    |
			| 'Shirt'     | '10,000'     | 'pcs'    | 'Store 02'   | '36/Red'     | 'No reserve'           | 'Yes'      | '09.02.2021'      | ''                | ''                   |
			| 'Boots'     | '24,000'     | 'pcs'    | 'Store 02'   | '37/18SD'    | 'Purchase'             | 'Yes'      | '09.02.2021'      | ''                | ''                   |
			| 'Service'   | '1,000'      | 'pcs'    | 'Store 02'   | 'Internet'   | ''                     | 'Yes'      | '09.02.2021'      | ''                | ''                   |
		Then the number of "ItemList" table lines is "equal" "4"
	* Filling in cancel reason and post Sales order closing
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'      |
			| 'not available'    |
		And I select current line in "List" table	
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '36/Red'      |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '37/18SD'     |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'      | 'Item key'    |
			| 'Service'   | 'Internet'    |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrderClosing0230001$$" variable
		And I delete "$$SalesOrderClosing0230001$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrderClosing0230001$$"
		And I save the window as "$$SalesOrderClosing0230001$$"
	* Check SO lock
		And I click Open button of "Sales order" field
		Then the form attribute named "ClosingOrder" became equal to "$$SalesOrderClosing0230001$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And "List" table contains lines
			| 'Number'                                |
			| '$$NumberSalesOrderClosing0230001$$'    |
		And I close all client application windows
	

Scenario: _0230002 create and check filling Sales order closing (SO partially shipped)
	* Preparation
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		If "List" table contains lines Then
				| "Number"                                 |
				| "$$NumberSalesOrderClosing0230001$$"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrderClosing.FindByNumber($$NumberSalesOrderClosing0230001$$).GetObject().Write(DocumentWriteMode.UndoPosting);"     |
	* Post SI and SC for SO 132
		And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(132).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Create Sales order closing 
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '132'      | '09.02.2021 19:53:45'    |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"	
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "SalesOrder" became equal to "Sales order 132 dated 09.02.2021 19:53:45"
		And "ItemList" table contains lines
			| 'Item'      | 'Quantity'   | 'Unit'   | 'Item key'   | 'Procurement method'   | 'Cancel'   | 'Delivery date'   | 'Cancel reason'    |
			| 'Shirt'     | '1,000'      | 'pcs'    | '36/Red'     | 'No reserve'           | 'Yes'      | '09.02.2021'      | ''                 |
			| 'Boots'     | '24,000'     | 'pcs'    | '37/18SD'    | 'Purchase'             | 'Yes'      | '09.02.2021'      | ''                 |
			| 'Service'   | '1,000'      | 'pcs'    | 'Internet'   | ''                     | 'Yes'      | '09.02.2021'      | ''                 |
		Then the number of "ItemList" table lines is "equal" "3"
		And for each line of "ItemList" table I do
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check SO mark
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And "List" table contains lines
			| 'Number'   | 'Closed'    |
			| '132'      | 'Yes'       |
	* Check SO lock
		And I go to line in "List" table
			| 'Number' | 'Closed' | 'Date'                |
			| '132'    | 'Yes'    | '09.02.2021 19:53:45' |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And in the table "ItemList" I click "Add" button'    |
			| 'And I click "Post and close" button'                 |
		And I close current window
	* Check SI lock	
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' | 'Date'                |
			| '132'    | '10.02.2021 13:58:29' |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		When I Check the steps for Exception
			| 'And I select "Boots" exact value from "Item" drop-down list in "ItemList" table'    |
		* Unlink and try change SI
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I change checkbox "Linked documents"
			And in the table "ResultsTree" I click "Unlink all" button
			And I click "Ok" button
			And I select current line in "ItemList" table
			And I activate "Item" field in "ItemList" table
			And I select "Boots" exact value from "Item" drop-down list in "ItemList" table
			Then user message window does not contain messages
			And I finish line editing in "ItemList" table
		* Close
			And I close current window
			Then "1C:Enterprise" window is opened
			And I click "No" button	
		* Repost SI	
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number' | 'Date'                |
				| '132'    | '10.02.2021 13:58:29' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages				
	* Check SC lock	
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' | 'Date'                |
			| '1'      | '15.02.2021 08:42:56' |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		When I Check the steps for Exception
			| 'And I select "Boots" exact value from "Item" drop-down list in "ItemList" table'    |		
		* Unlink and try change SC
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I change checkbox "Linked documents"
			And in the table "ResultsTree" I click "Unlink all" button
			And I click "Ok" button
			And I select current line in "ItemList" table
			And I activate "Item" field in "ItemList" table
			And I select "Boots" exact value from "Item" drop-down list in "ItemList" table
			Then user message window does not contain messages
			And I finish line editing in "ItemList" table
		* Close SC
			And I close current window
			Then "1C:Enterprise" window is opened
			And I click "No" button	
		* Repost SC
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I go to line in "List" table
				| 'Number' | 'Date'                |
				| '1'      | '15.02.2021 08:42:56' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
	* Repost SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' | 'Closed' | 'Date'                |
			| '132'    | 'Yes'    | '09.02.2021 19:53:45' |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
		And I close all client application windows

Scenario: _0230003 create Sales order closing and check for double records
	And I close all client application windows
	* Create Purchase order closing by CI User (Save)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I click "Save" button
		And I delete "$$NumberSalesOrderClosing0224002$$" variable
		And I delete "$$SalesOrderClosing0224002$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrderClosing0224002$$"
		And I save the window as "$$SalesOrderClosing02240022$$"		
		And I close current test client session
	* Create Purchase order closing by CI Test User (Post) 
		And I connect "new" TestClient using "Admin" login and " " password
		Given I open hyperlink "e1cib/list/Document.SalesOrder"		
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I click "Post and close" button
		And I close "new" TestClient
	* Post Purchase order closing by CI User (Post)
		And I connect "This Client" TestClient using "CI" login and "ci" password
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| "Number"                                    |
			| "$$NumberSalesOrderClosing0224002$$"     |
		And I select current line in "List" table
		And I click "Post and close" button	
		Then there are lines in TestClient message log
			|'Order already closed'|
	And I close all client application windows

Scenario: _0230004 create Sales order closing (different ItemKey)
	And I close all client application windows
	* Create SOC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Date'                |
			| '10.04.2025 22:03:13' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I click "Save" button
		And I delete "$$NumberSalesOrderClosing0230004$$" variable
		And I delete "$$SalesOrderClosing0230004$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrderClosing0230004$$"
		And I save the window as "$$SalesOrderClosing0230004$$"
	* Check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "TransactionType" became equal to "Sales"	
		Then the number of "ItemList" table lines is "равно" 0					
	And I close all client application windows	