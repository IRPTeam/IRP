#language: en
@tree
@Positive
@Services

Feature: work sheet

As a financier
I want to fill out the information on the services I received and which I provided
For cost analysis

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029300 preparation (work sheet)
	When set True value to the constant
	* Load info
		When Create catalog ItemTypes objects (Furniture)	
		When Create catalog Items objects (Table)
		When Create catalog ItemKeys objects (Table)
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog PriceTypes objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog PaymentTypes objects 
		When create items for work order
		When Create catalog BillOfMaterials objects
		When Create information register Taxes records (VAT)
	* Price list
		When Create document PriceList objects (for works)
		And I execute 1C:Enterprise script at server
			| "Documents.PriceList.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PriceList.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Discount
		When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	* WO
		When Create document Work order without SO
		And I execute 1C:Enterprise script at server
			| "Documents.WorkOrder.FindByNumber(30).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Work order with SO
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(182).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.WorkOrder.FindByNumber(31).GetObject().Write(DocumentWriteMode.Posting);"    |
	

Scenario: _0293001 check preparation
	When check preparation	


Scenario: _0293002 create Work sheet based on Work order without SO (link, unlink)
	And I close all client application windows
	* Select WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '30'        |
	* Create WS
		And I click "Work sheet" button
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table became equal
			| 'Row presentation'                          | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Work order 30 dated 22.09.2022 10:59:11'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Assembly (Assembly)'                       | 'Yes'   | '1,000'      | 'pcs'    | '200,00'   | 'TRY'         |
			| 'Installation (Installation)'               | 'Yes'   | '1,000'      | 'pcs'    | '100,00'   | 'TRY'         |
		And I click "Ok" button
	* Check filling
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#'   | 'Item'           | 'Item key'       | 'Bill of materials'        | 'Unit'   | 'Quantity'   | 'Sales order'   | 'Work order'                                 |
			| '1'   | 'Assembly'       | 'Assembly'       | 'Assembly'                 | 'pcs'    | '1,000'      | ''              | 'Work order 30 dated 22.09.2022 10:59:11'    |
			| '2'   | 'Installation'   | 'Installation'   | 'Furniture installation'   | 'pcs'    | '1,000'      | ''              | 'Work order 30 dated 22.09.2022 10:59:11'    |
		
		And "Materials" table contains lines
			| 'Cost write off'         | 'Item (BOM)'   | 'Item key'     | 'Item key (BOM)'   | 'Unit (BOM)'   | 'Quantity (BOM)'   | 'Store'      | 'Item'         | 'Unit'   | 'Quantity'    |
			| 'Include to work cost'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | 'pcs'          | '2,000'            | 'Store 01'   | 'Material 1'   | 'pcs'    | '2,000'       |
			| 'Include to work cost'   | 'Material 2'   | 'Material 2'   | 'Material 2'       | 'pcs'          | '2,000'            | 'Store 01'   | 'Material 2'   | 'pcs'    | '2,000'       |
			| 'Include to work cost'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | 'pcs'          | '2'                | 'Store 01'   | 'Material 1'   | 'pcs'    | '2'           |
			| 'Include to work cost'   | 'Material 2'   | 'Material 2'   | 'Material 2'       | 'pcs'          | '4'                | 'Store 01'   | 'Material 2'   | 'pcs'    | '4'           |
			| 'Include to work cost'   | 'Material 3'   | 'Material 3'   | 'Material 3'       | 'kg'           | '1,521'            | 'Store 01'   | 'Material 3'   | 'kg'     | '1,521'       |
		Then the form attribute named "Branch" became equal to "Workshop 1"
	* Unlink
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
		And "ItemList" table became equal
			| '#'   | 'Item'           | 'Item key'       | 'Bill of materials'        | 'Unit'   | 'Quantity'   | 'Sales order'   | 'Work order'    |
			| '1'   | 'Assembly'       | 'Assembly'       | 'Assembly'                 | 'pcs'    | '1,000'      | ''              | ''              |
			| '2'   | 'Installation'   | 'Installation'   | 'Furniture installation'   | 'pcs'    | '1,000'      | ''              | ''              |
	* Link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'      | 'Unit'    |
			| 'TRY'        | '200,00'   | '1,000'      | 'Assembly (Assembly)'   | 'pcs'     |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'              | 'Unit'    |
			| '2'   | '1,000'      | 'Installation (Installation)'   | 'pcs'     |
		And I expand a line in "BasisesTree" table
			| 'Row presentation'                           |
			| 'Work order 30 dated 22.09.2022 10:59:11'    |
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'              | 'Unit'    |
			| 'TRY'        | '100,00'   | '1,000'      | 'Installation (Installation)'   | 'pcs'     |
		And I click the button named "Link"
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#'   | 'Item'           | 'Item key'       | 'Bill of materials'        | 'Unit'   | 'Quantity'   | 'Sales order'   | 'Work order'                                 |
			| '1'   | 'Assembly'       | 'Assembly'       | 'Assembly'                 | 'pcs'    | '1,000'      | ''              | 'Work order 30 dated 22.09.2022 10:59:11'    |
			| '2'   | 'Installation'   | 'Installation'   | 'Furniture installation'   | 'pcs'    | '1,000'      | ''              | 'Work order 30 dated 22.09.2022 10:59:11'    |
	* Delete all rows and add rows again
		Then I select all lines of "ItemList" table
		And I delete a line in "ItemList" table
		And in the table "ItemList" I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'           | 'Item key'       | 'Bill of materials'        | 'Unit'   | 'Quantity'   | 'Sales order'   | 'Work order'                                 |
			| 'Assembly'       | 'Assembly'       | 'Assembly'                 | 'pcs'    | '1,000'      | ''              | 'Work order 30 dated 22.09.2022 10:59:11'    |
			| 'Installation'   | 'Installation'   | 'Furniture installation'   | 'pcs'    | '1,000'      | ''              | 'Work order 30 dated 22.09.2022 10:59:11'    |
		Then the number of "ItemList" table lines is "равно" "2"
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberWorkSheet1$$" variable
		And I delete "$$WorkSheet1$$" variable
		And I save the value of "Number" field as "$$NumberWorkSheet1$$"
		And I save the window as "$$WorkSheet1$$"
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table
		And I click the button named "FormPostAndClose"		
				
					
Scenario: _0293002 create Work sheet based on SO
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '182'       |
	* Create WS
		And I click "Work sheet" button
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 182 dated 22.09.2022 11:13:46'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Delivery (Delivery)'                         | 'Yes'   | '1,000'      | 'pcs'    | '120,00'   | 'TRY'         |
		And I click "Ok" button				
	* Check filling
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#'   | 'Item'       | 'Item key'   | 'Unit'   | 'Quantity'   | 'Sales order'                                 | 'Work order'    |
			| '1'   | 'Delivery'   | 'Delivery'   | 'pcs'    | '1,000'      | 'Sales order 182 dated 22.09.2022 11:13:46'   | ''              |
		Then the form attribute named "Branch" became equal to "Front office"
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberWorkSheet2$$" variable
		And I delete "$$WorkSheet2$$" variable
		And I save the value of "Number" field as "$$NumberWorkSheet2$$"
		And I save the window as "$$WorkSheet2$$"
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table
		And I click the button named "FormPostAndClose"		
						
					
Scenario: _0293003 create Work sheet based on WO with SO
	And I close all client application windows
	* Select WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '31'        |
	* Create WS
		And I click "Work sheet" button	
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Use'   | 'Quantity'   | 'Unit'   | 'Price'    | 'Currency'    |
			| 'Sales order 182 dated 22.09.2022 11:13:46'   | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Work order 31 dated 22.09.2022 12:41:21'     | 'Yes'   | ''           | ''       | ''         | ''            |
			| 'Installation (Installation)'                 | 'Yes'   | '1,000'      | 'pcs'    | '100,00'   | 'TRY'         |
			| 'Assembly (Assembly)'                         | 'Yes'   | '1,000'      | 'pcs'    | '100,00'   | 'TRY'         |
		Then "Add linked document rows" window is opened
		And I click "Ok" button
	* Check filling
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#'   | 'Item'           | 'Item key'       | 'Bill of materials'        | 'Unit'   | 'Quantity'   | 'Sales order'                                 | 'Work order'                                 |
			| '1'   | 'Installation'   | 'Installation'   | 'Furniture installation'   | 'pcs'    | '1,000'      | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'Work order 31 dated 22.09.2022 12:41:21'    |
			| '2'   | 'Assembly'       | 'Assembly'       | 'Assembly'                 | 'pcs'    | '1,000'      | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'Work order 31 dated 22.09.2022 12:41:21'    |
		
		And "Materials" table became equal
			| '#'   | 'Cost write off'         | 'Item (BOM)'   | 'Item key'     | 'Item key (BOM)'   | 'Unit (BOM)'   | 'Quantity (BOM)'   | 'Store'      | 'Item'         | 'Unit'   | 'Quantity'    |
			| '1'   | 'Include to work cost'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | 'pcs'          | '2,000'            | 'Store 01'   | 'Material 1'   | 'pcs'    | '2,000'       |
			| '2'   | 'Include to work cost'   | 'Material 2'   | 'Material 2'   | 'Material 2'       | 'pcs'          | '4,000'            | 'Store 01'   | 'Material 2'   | 'pcs'    | '4,000'       |
			| '3'   | 'Include to work cost'   | 'Material 3'   | 'Material 3'   | 'Material 3'       | 'kg'           | '1,521'            | 'Store 01'   | 'Material 3'   | 'kg'     | '1,521'       |
			| '4'   | 'Include to work cost'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | 'pcs'          | '2'                | 'Store 01'   | 'Material 1'   | 'pcs'    | '2'           |
			| '5'   | 'Include to work cost'   | 'Material 2'   | 'Material 2'   | 'Material 2'       | 'pcs'          | '2'                | 'Store 01'   | 'Material 2'   | 'pcs'    | '2'           |
	
		Then the form attribute named "Branch" became equal to "Front office"
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table	
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberWorkSheet3$$" variable
		And I delete "$$WorkSheet3$$" variable
		And I save the value of "Number" field as "$$NumberWorkSheet3$$"
		And I save the window as "$$WorkSheet3$$"
		And I click the button named "FormPostAndClose"		
							
Scenario: _0293004 create Work sheet without bases document
	And I close all client application windows
	* Open WS form
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click the button named "FormCreate"
	* Filling main attributes
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Kalipso"		
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling works tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Assembly'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Installation'    |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'Furniture installation'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Delivery'       |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Check
		And "ItemList" table became equal
			| '#'   | 'Item'           | 'Item key'       | 'Bill of materials'        | 'Unit'   | 'Quantity'   | 'Sales order'   | 'Work order'    |
			| '1'   | 'Assembly'       | 'Assembly'       | 'Assembly'                 | 'pcs'    | '1,000'      | ''              | ''              |
			| '2'   | 'Installation'   | 'Installation'   | 'Furniture installation'   | 'pcs'    | '1,000'      | ''              | ''              |
			| '3'   | 'Delivery'       | 'Delivery'       | ''                         | 'pcs'    | '1,000'      | ''              | ''              |
		And "Materials" table became equal
			| '#'   | 'Cost write off'         | 'Item (BOM)'   | 'Item key'     | 'Item key (BOM)'   | 'Unit (BOM)'   | 'Quantity (BOM)'   | 'Store'      | 'Item'         | 'Unit'   | 'Quantity'    |
			| '1'   | 'Include to work cost'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | 'pcs'          | '2,000'            | 'Store 01'   | 'Material 1'   | 'pcs'    | '2,000'       |
			| '2'   | 'Include to work cost'   | 'Material 2'   | 'Material 2'   | 'Material 2'       | 'pcs'          | '2,000'            | 'Store 01'   | 'Material 2'   | 'pcs'    | '2,000'       |
			| '3'   | 'Include to work cost'   | 'Material 1'   | 'Material 1'   | 'Material 1'       | 'pcs'          | '2'                | 'Store 01'   | 'Material 1'   | 'pcs'    | '2'           |
			| '4'   | 'Include to work cost'   | 'Material 2'   | 'Material 2'   | 'Material 2'       | 'pcs'          | '4'                | 'Store 01'   | 'Material 2'   | 'pcs'    | '4'           |
			| '5'   | 'Include to work cost'   | 'Material 3'   | 'Material 3'   | 'Material 3'       | 'kg'           | '1,521'            | 'Store 01'   | 'Material 3'   | 'kg'     | '1,521'       |
	* Add workers
		And I move to "Workers" tab
		And in the table "Workers" I click the button named "WorkersAdd"
		And I activate "Employee" field in "Workers" table
		And I select current line in "Workers" table
		And I click choice button of "Employee" attribute in "Workers" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Alexander Orlov'    |
		And I select current line in "List" table
		And I activate field named "WorkersUnit" in "Workers" table
		And I click choice button of the attribute named "WorkersUnit" in "Workers" table
		And I go to line in "List" table
			| 'Description'    |
			| 'hour'           |
		And I select current line in "List" table
		And I activate field named "WorkersQuantity" in "Workers" table
		And I input "2,000" text in the field named "WorkersQuantity" of "Workers" table
		And I finish line editing in "Workers" table
		And in the table "Workers" I click the button named "WorkersAdd"
		And I activate "Employee" field in "Workers" table
		And I click choice button of "Employee" attribute in "Workers" table
		And I go to line in "List" table
			| 'Description'      |
			| 'David Romanov'    |
		And I select current line in "List" table
		And I activate field named "WorkersUnit" in "Workers" table
		And I click choice button of the attribute named "WorkersUnit" in "Workers" table
		And I go to line in "List" table
			| 'Description'    |
			| 'hour'           |
		And I select current line in "List" table
		And I activate field named "WorkersQuantity" in "Workers" table
		And I input "2,500" text in the field named "WorkersQuantity" of "Workers" table
		And I finish line editing in "Workers" table
	* Check workers tab
		And "Workers" table became equal
			| '#'   | 'Employee'          | 'Unit'   | 'Quantity'    |
			| '1'   | 'Alexander Orlov'   | 'hour'   | '2,000'       |
			| '2'   | 'David Romanov'     | 'hour'   | '2,500'       |
	* Filling branch and currency
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'    |
			| 'Workshop 1'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberWorkSheet4$$" variable
		And I delete "$$WorkSheet4$$" variable
		And I save the value of "Number" field as "$$NumberWorkSheet4$$"
		And I save the window as "$$WorkSheet4$$"
		And I click the button named "FormPostAndClose"
	* Check document creation
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And "List" table contains lines
			| 'Number'                 | 'Company'         |
			| '$$NumberWorkSheet4$$'   | 'Main Company'    |
		And I close all client application windows

Scenario: _0293008 create SI based on WS without bases document
	And I close all client application windows
	* Select WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table				
			| 'Number'                  |
			| '$$NumberWorkSheet4$$'    |
		And I click "Sales invoice" button
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
	* Check SI filling
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#'   | 'Item'           | 'Item key'       | 'Unit'   | 'Quantity'   | 'VAT'    |
			| '1'   | 'Assembly'       | 'Assembly'       | 'pcs'    | '1,000'      | '18%'    |
			| '2'   | 'Installation'   | 'Installation'   | 'pcs'    | '1,000'      | '18%'    |
			| '3'   | 'Delivery'       | 'Delivery'       | 'pcs'    | '1,000'      | '18%'    |
		And in the table "ItemList" I click "Work sheets" button
		And "DocumentsTree" table became equal
			| 'Presentation'                  | 'Invoice'   | 'QuantityInDocument'   | 'Quantity'    |
			| 'Assembly (Assembly)'           | '1,000'     | '1,000'                | '1,000'       |
			| '$$WorkSheet4$$'                | ''          | '1,000'                | '1,000'       |
			| 'Installation (Installation)'   | '1,000'     | '1,000'                | '1,000'       |
			| '$$WorkSheet4$$'                | ''          | '1,000'                | '1,000'       |
			| 'Delivery (Delivery)'           | '1,000'     | '1,000'                | '1,000'       |
			| '$$WorkSheet4$$'                | ''          | '1,000'                | '1,000'       |
		And I close current window
		Then the form attribute named "Branch" became equal to "Workshop 1"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'AP/AR posting detail'   | 'Code'   | 'Description'                        | 'Kind'       |
			| 'By documents'           | '3'      | 'Basic Partner terms, without VAT'   | 'Regular'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice4$$" variable
		And I delete "$$SalesInvoice4$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice4$$"
		And I save the window as "$$SalesInvoice4$$"
		And I click the button named "FormPostAndClose"
	* Check document creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'                    | 'Company'         |
			| '$$NumberSalesInvoice4$$'   | 'Main Company'    |
		And I close all client application windows
				
											

Scenario: _0293009 create SI based on WS (with WO and SO)
	And I close all client application windows
	* Select WS
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table				
			| 'Number'                  |
			| '$$NumberWorkSheet3$$'    |
		And I click "Sales invoice" button
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
	* Check SI filling				
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#'   | 'Price type'          | 'Item'           | 'Item key'       | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Other period revenue type'   | 'Additional analytic'   | 'Store'   | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'                                 | 'Work order'                                | 'Revenue type'   | 'Sales person'    |
			| '1'   | 'Basic Price Types'   | 'Installation'   | 'Installation'   | ''                     | 'No'                   | '14,49'        | 'pcs'    | ''                     | '1,000'      | '100,00'   | '18%'   | '5,00'            | '80,51'        | '95,00'          | ''                     | ''                      | ''        | ''                | 'No'                          | ''         | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'Work order 31 dated 22.09.2022 12:41:21'   | ''               | ''                |
			| '2'   | 'Basic Price Types'   | 'Assembly'       | 'Assembly'       | ''                     | 'No'                   | '14,49'        | 'pcs'    | ''                     | '1,000'      | '100,00'   | '18%'   | '5,00'            | '80,51'        | '95,00'          | ''                     | ''                      | ''        | ''                | 'No'                          | ''         | 'Sales order 182 dated 22.09.2022 11:13:46'   | 'Work order 31 dated 22.09.2022 12:41:21'   | ''               | ''                |
		And "SpecialOffers" table became equal
			| '#'   | 'Amount'   | 'Special offer'       |
			| '1'   | '5,00'     | 'DocumentDiscount'    |
			| '2'   | '5,00'     | 'DocumentDiscount'    |
		And in the table "ItemList" I click "Work sheets" button
		And "DocumentsTree" table became equal
			| 'Presentation'                  | 'Invoice'   | 'QuantityInDocument'   | 'Quantity'    |
			| 'Installation (Installation)'   | '1,000'     | '1,000'                | '1,000'       |
			| '$$WorkSheet3$$'                | ''          | '1,000'                | '1,000'       |
			| 'Assembly (Assembly)'           | '1,000'     | '1,000'                | '1,000'       |
			| '$$WorkSheet3$$'                | ''          | '1,000'                | '1,000'       |
		And I close current window
		Then the form attribute named "ManagerSegment" became equal to "Region 1"
		Then the form attribute named "Branch" became equal to "Front office"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "10,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "161,02"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "28,98"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "190,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice5$$" variable
		And I delete "$$SalesInvoice5$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice5$$"
		And I save the window as "$$SalesInvoice5$$"
		And I click the button named "FormPostAndClose"
	* Check document creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'                    | 'Company'         |
			| '$$NumberSalesInvoice5$$'   | 'Main Company'    |
		And I close all client application windows					
