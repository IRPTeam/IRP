#language: en
@tree
@Positive
@Other

Feature: check post/unpost/mark for deletion from report Related documents


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _300520 preparation (check post/unpost/mark for deletion from report Related documents)
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		

Scenario: _3005201 check preparation
	When check preparation

Scenario: _300521 check post/unpost/mark for deletion from report "Related documents"
	And I close all client application windows
	* Preparation
		* Create Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Ferron BP TR'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02 TR'     |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers TR'     |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'           | 'Item key'         |
				| 'Trousers TR'    | '38/Yellow TR'     |
			And I select current line in "List" table
			And I click Select button of "Manager segment" field
			And I go to line in "List" table
				| 'Description'     |
				| '2 Region'        |
			And I select current line in "List" table
			And I move to "Other" tab
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder300521$$" variable
			And I delete "$$SalesOrder300521$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder300521$$"
			And I save the window as "$$SalesOrder300521$$"
		* Create Shipment confirmation based on SO
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			And I click "Ok" button		
			And I click the button named "FormPost"
			And I delete "$$NumberShipmentConfirmation300521$$" variable
			And I delete "$$ShipmentConfirmation300521$$" variable
			And I save the value of "Number" field as "$$NumberShipmentConfirmation300521$$"
			And I save the window as "$$ShipmentConfirmation300521$$"
			And I click the button named "FormPostAndClose"
			And Delay 5
		* Create Sales invoice based on created SC
			And I click the button named "FormDocumentSalesInvoiceGenerate"
			And I click "Ok" button
			And I move to "Other" tab
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice300521$$" variable
			And I delete "$$SalesInvoice300521$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice300521$$"
			And I save the window as "$$SalesInvoice300521$$"
			And I click the button named "FormPostAndClose"
			And Delay 5
		* Open Related documents
			When in opened panel I select "$$SalesOrder300521$$"
			And I click "*Related documents" button
			And "DocumentsTree" table became equal
				| 'Presentation'                       |
				| '$$SalesOrder300521$$'               |
				| '$$ShipmentConfirmation300521$$'     |
				| '$$SalesInvoice300521$$'             |
		* Check unpost Sales invoice from report Related documents
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreeUnpost"
			And the current line of "DocumentsTree" table is equal to
				| 'Presentation'               |
				| '$$SalesInvoice300521$$'     |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
			And Delay 10
			And "List" table does not contain lines
			| 'Recorder'                   |
			| '$$SalesInvoice300521$$*'    |
		* Check post Sales invoice from report Related documents
			When in opened panel I select "*Related documents"
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreePost"
			And the current line of "DocumentsTree" table is equal to
				| 'Presentation'               |
				| '$$SalesInvoice300521$$'     |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
			And I click "Refresh" button
			And Delay 10
			And "List" table contains lines
				| 'Recorder'                   |
				| '$$SalesInvoice300521$$'     |
		* Mark for deletion Sales invoice from report Related documents
			When in opened panel I select "*Related documents"
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreeDelete"
			And the current line of "DocumentsTree" table is equal to
				| 'Presentation'               |
				| '$$SalesInvoice300521$$'     |
			And I go to the last line in "DocumentsTree" table
		* Unmark for deletion  Sales invoice from report Related documents
			When in opened panel I select "*Related documents"
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreeDelete"
			And I go to the last line in "DocumentsTree" table
		* Open document from list form
			And I go to the first line in "DocumentsTree" table
			And I select current line in "DocumentsTree" table
			Then "$$SalesOrder300521$$" window is opened
			And I close current window
		* Click Edit command
			And I go to the first line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreeEdit"
			Then "$$SalesOrder300521$$" window is opened
			And I close current window
		* Click Refresh command
			And in the table "DocumentsTree" I click the button named "DocumentsTreeRefresh"
			Then user message window does not contain messages
		* Delete, F9
			And I go to the first line in "DocumentsTree" table
			And I press keyboard shortcut "F9"
			Then user message window does not contain messages	
			And I press keyboard shortcut "Delete"	
			Then user message window does not contain messages
			And "DocumentsTree" table contains lines
				| 'Presentation'                       |
				| '$$SalesOrder300521$$'               |
				| '$$ShipmentConfirmation300521$$'     |
				| '$$SalesInvoice300521$$'             |
		And I close all client application windows

Scenario: _300522 show colums in the report "Related documents"
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberSalesOrder300521$$'  |
		And I click "*Related documents" button
	* Show column
		And in the table "DocumentsTree" I click "Show columns" button
		And I go to line in "AllAttributesValueTable" table
			| 'Check' | 'Name'    |
			| 'No'    | 'Company' |
		And I set "Check" checkbox in "AllAttributesValueTable" table
		And I finish line editing in "AllAttributesValueTable" table
		And I go to line in "AllAttributesValueTable" table
			| 'Check' | 'Name'       |
			| 'No'    | 'Legal name' |
		And I set "Check" checkbox in "AllAttributesValueTable" table
		And I finish line editing in "AllAttributesValueTable" table
		And I go to line in "AllAttributesValueTable" table
			| 'Check' | 'Name'    |
			| 'No'    | 'Partner' |
		And I set "Check" checkbox in "AllAttributesValueTable" table
		And I finish line editing in "AllAttributesValueTable" table
	* Check
		And "DocumentsTree" table became equal
			| 'Presentation'                   | 'Amount' | 'Company'         | 'Partner'      | 'Legal name'           |
			| '$$SalesOrder300521$$'           | '400,00' | 'Main Company TR' | 'Ferron BP TR' | 'Company Ferron BP TR' |
			| '$$ShipmentConfirmation300521$$' | ''       | 'Main Company TR' | 'Ferron BP TR' | 'Company Ferron BP TR' |
			| '$$SalesInvoice300521$$'         | '400,00' | 'Main Company TR' | 'Ferron BP TR' | 'Company Ferron BP TR' |
		And I go to line in "AllAttributesValueTable" table
			| 'Check' | 'Name'    |
			| 'Yes'   | 'Company' |
		And I remove "Check" checkbox in "AllAttributesValueTable" table
		And "DocumentsTree" table became equal
			| 'Presentation'                   | 'Amount' | 'Partner'      | 'Legal name'           |
			| '$$SalesOrder300521$$'           | '400,00' | 'Ferron BP TR' | 'Company Ferron BP TR' |
			| '$$ShipmentConfirmation300521$$' | ''       | 'Ferron BP TR' | 'Company Ferron BP TR' |
			| '$$SalesInvoice300521$$'         | '400,00' | 'Ferron BP TR' | 'Company Ferron BP TR' |
		And I close all client application windows