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
	* Create test SO
		When Create document SalesOrder objects (SI before SC for check closing)
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"     |
		
Scenario: _0230001 check preparation
	When check preparation


Scenario: _0230001 create and check filling Sales order closing (SO not shipped)
	* Create Sales order closing 
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '32'       | '09.02.2021 19:53:45'    |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "SalesOrder" became equal to "Sales order 32 dated 09.02.2021 19:53:45"
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
	* Load SI and SC for SO 32
		When Create document SalesInvoice objects (for check SO closing)
		When Create document ShipmentConfirmation objects (check SO closing)
		And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Create Sales order closing 
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '32'       | '09.02.2021 19:53:45'    |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"	
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "SalesOrder" became equal to "Sales order 32 dated 09.02.2021 19:53:45"
		And "ItemList" table contains lines
			| 'Item'      | 'Quantity'   | 'Unit'   | 'Item key'   | 'Procurement method'   | 'Cancel'   | 'Delivery date'   | 'Cancel reason'    |
			| 'Shirt'     | '1,000'      | 'pcs'    | '36/Red'     | 'No reserve'           | 'Yes'      | '09.02.2021'      | ''                 |
			| 'Boots'     | '24,000'     | 'pcs'    | '37/18SD'    | 'Purchase'             | 'Yes'      | '09.02.2021'      | ''                 |
			| 'Service'   | '1,000'      | 'pcs'    | 'Internet'   | ''                     | 'Yes'      | '09.02.2021'      | ''                 |
		Then the number of "ItemList" table lines is "equal" "3"
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check SO mark
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And "List" table contains lines
			| 'Number'   | 'Closed'    |
			| '32'       | 'Yes'       |
	* Repost SO
		And I go to line in "List" table
			| 'Number'    |
			| '32'        |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
		And I close all client application windows

