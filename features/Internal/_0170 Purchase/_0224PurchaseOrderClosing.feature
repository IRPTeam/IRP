#language: en
@tree
@Positive
@Purchase

Functionality: purchase order closing

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _0224000 preparation (Purchase order closing)
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
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
		When Create catalog AccessGroups objects
		When Create catalog AccessProfiles objects
		When Create catalog Users objects		
	* Create test PO
		When Create document PO, GR, PI objects (for check closing)
		When Create document PO, SO objects (for check double closing)
		When Create document PO, GR, PI objects (for order closing)
	* Repost
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1124).GetObject().Write(DocumentWriteMode.Write);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1124).GetObject().Write(DocumentWriteMode.Write);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(11).GetObject().Write(DocumentWriteMode.Write);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(37).GetObject().Write(DocumentWriteMode.Write);"     |
			| "Documents.PurchaseOrder.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);"   |
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

Scenario: _02240001 check preparation
	When check preparation

Scenario: _0224001 create and check filling Purchase order closing (PO not shipped)
	* Create Purchase order closing 
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '37'       | '09.03.2021 14:29:00'    |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "PurchaseOrder" became equal to "Purchase order 37 dated 09.03.2021 14:29:00"
		And "ItemList" table contains lines
			| 'Item'      | 'Item key'   | 'Quantity'   | 'Unit'   | 'Store'      | 'Cancel'   | 'Delivery date'   | 'Cancel reason'    |
			| 'Shirt'     | '38/Black'   | '2,000'      | 'pcs'    | 'Store 03'   | 'Yes'      | '11.03.2021'      | ''                 |
			| 'Dress'     | 'XS/Blue'    | '96,000'     | 'pcs'    | 'Store 03'   | 'Yes'      | '11.03.2021'      | ''                 |
			| 'Service'   | 'Rent'       | '1,000'      | 'pcs'    | 'Store 03'   | 'Yes'      | '11.03.2021'      | ''                 |
		Then the number of "ItemList" table lines is "equal" "3"
	// * Try to post document without filling in cancel reason
	// 	And I click the button named "FormPost"
	// 	Then I wait that in user messages the "Cancel reason has to be filled if string was canceled" substring will appear in "10" seconds
	* Filling in cancel reason and post Purchase order closing
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
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'      | 'Item key'    |
			| 'Service'   | 'Rent'        |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrderClosing0224001$$" variable
		And I delete "$$PurchaseOrderClosing0224001$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrderClosing0224001$$"
		And I save the window as "$$PurchaseOrderClosing0224001$$"
	* Check PO lock
		And I click Open button of "Purchase order" field
		Then the form attribute named "ClosingOrder" became equal to "$$PurchaseOrderClosing0224001$$"
		And I close all client application windows
	* Check ban on deleation of PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '37'       | '09.03.2021 14:29:00'    |
		And I click the button named "FormSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click the button named "Button0"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Related document exists: $$PurchaseOrderClosing0224001$$'|
		And I close all client application windows		
	* Check ban on unposting of PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '37'       | '09.03.2021 14:29:00'    |
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Related document exists: $$PurchaseOrderClosing0224001$$'|
		And I close all client application windows		


Scenario: _0230002 create and check filling Purchase order closing (PO partially shipped)
		And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		If "List" table contains lines Then
				| "Number"                                    |
				| "$$NumberPurchaseOrderClosing0224001$$"     |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrderClosing.FindByNumber($$NumberPurchaseOrderClosing0224001$$).GetObject().Write(DocumentWriteMode.UndoPosting);"     |
	* Post PI and GR for PO 37
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Create Purchase order closing 
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '37'       | '09.03.2021 14:29:00'    |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"	
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "PurchaseOrder" became equal to "Purchase order 37 dated 09.03.2021 14:29:00"
		And "ItemList" table contains lines
			| 'Item'      | 'Item key'   | 'Quantity'   | 'Unit'   | 'Store'      | 'Cancel'   | 'Delivery date'   | 'Cancel reason'    |
			| 'Shirt'     | '38/Black'   | '1,000'      | 'pcs'    | 'Store 03'   | 'No'       | '11.03.2021'      | ''                 |
			| 'Dress'     | 'XS/Blue'    | '8,000'      | 'pcs'    | 'Store 03'   | 'Yes'      | '11.03.2021'      | ''                 |
			| 'Service'   | 'Rent'       | '1,000'      | 'pcs'    | 'Store 03'   | 'Yes'      | '11.03.2021'      | ''                 |
		Then the number of "ItemList" table lines is "equal" "3"
		And for each line of "ItemList" table I do
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check PO mark
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And "List" table contains lines
			| 'Number'   | 'Closed'    |
			| '37'       | 'Yes'       |
	* Check PO lock
		And I go to line in "List" table
			| 'Number' | 'Closed' | 'Date'                |
			| '37'     | 'Yes'    | '09.03.2021 14:29:00' |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And in the table "ItemList" I click "Add" button'    |
			| 'And I click "Post and close" button'                 |
		And I close current window
	* Check PI lock	
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' | 'Date'                |
			| '37'     | '09.03.2021 15:17:48' |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		When I Check the steps for Exception
			| 'And I select "Boots" exact value from "Item" drop-down list in "ItemList" table'    |
		* Unlink and try change PI
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
		* Repost PI	
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
				| 'Number' | 'Date'                |
				| '37'     | '09.03.2021 15:17:48' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages				
	* Check GR lock	
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' | 'Date'                |
			| '37'     | '09.03.2021 15:16:42' |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		When I Check the steps for Exception
			| 'And I select "Boots" exact value from "Item" drop-down list in "ItemList" table'    |		
		* Unlink and try change GR
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I change checkbox "Linked documents"
			And in the table "ResultsTree" I click "Unlink all" button
			And I click "Ok" button
			And I select current line in "ItemList" table
			And I activate "Item" field in "ItemList" table
			And I select "Boots" exact value from "Item" drop-down list in "ItemList" table
			Then user message window does not contain messages
			And I finish line editing in "ItemList" table
		* Close GR
			And I close current window
			Then "1C:Enterprise" window is opened
			And I click "No" button	
		* Repost GR
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			And I go to line in "List" table
				| 'Number' | 'Date'                |
				| '37'     | '09.03.2021 15:16:42' |
			And in the table "List" I click the button named "ListContextMenuPost"
			Then user message window does not contain messages
	* Repost PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' | 'Closed' | 'Date'                |
			| '37'     | 'Yes'    | '09.03.2021 14:29:00' |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
		And I close all client application windows

Scenario: _0230003 create Purchase order closing and check for double records
	And I close all client application windows
	* Create Purchase order closing by CI User (Save)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '38'     |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		And I click "Save" button
		And I delete "$$NumberPurchaseOrderClosing0224002$$" variable
		And I delete "$$PurchaseOrderClosing0224002$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrderClosing0224002$$"
		And I save the window as "$$PurchaseOrderClosing0224002$$"		
		And I close current test client session
	* Create Purchase order closing by CI Test User (Post) 
		And I connect "new" TestClient using "Admin" login and " " password
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"		
		And I go to line in "List" table
			| 'Number' |
			| '38'     |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		And I click "Post and close" button
		And I close "new" TestClient
	* Post Purchase order closing by CI User (Post)
		And I connect "This Client" TestClient using "CI" login and "ci" password
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| "Number"                                    |
			| "$$NumberPurchaseOrderClosing0224002$$"     |
		And I select current line in "List" table
		And I click "Post and close" button	
		Then there are lines in TestClient message log
			|'Order already closed'|
	And I close all client application windows

Scenario: _0230004 create Purchase order closing (different ItemKey)
	And I close all client application windows
	* Create SOC
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Date'                |
			| '10.04.2025 22:01:33' |
		Then "Purchase orders" window is opened
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		And I click "Save" button
		And I delete "$$NumberPurchaseOrderClosing0230004$$" variable
		And I delete "$$PurchaseOrderClosing0230004$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrderClosing0230004$$"
		And I save the window as "$$PurchaseOrderClosing0230004$$"
		And I click "Post" button
	* Check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the number of "ItemList" table lines is "равно" 0
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "TransactionType" became equal to "Purchase"
	And I close all client application windows