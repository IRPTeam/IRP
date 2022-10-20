#language: en
@tree
@Positive
@Services

Feature: work order

As a financier
I want to fill out the information on the services I received and which I provided
For cost analysis

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029200 preparation (work order)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Price list
		When Create document PriceList objects (for works)
		And I execute 1C:Enterprise script at server
			| "Documents.PriceList.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PriceList.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
	* Discount
		When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
	* SO
		When Create document SalesOrder objects (with works)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(183).GetObject().Write(DocumentWriteMode.Posting);" |
	

Scenario: _0292001 check preparation
	When check preparation	


Scenario: _029201 create work order
		And I close all client application windows
	* Open WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click "Create" button
	* Filling main attributes
		Then the form attribute named "Status" became equal to "Wait"		
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'              |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Add works
		* First work
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Assembly'    |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate "Price" field in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Bill of materials" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Bill of materials" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Assembly'    |
			And I select current line in "List" table
		* Check materials tab
			And "Materials" table became equal
				| '#' | 'Cost write off'       | 'Item'       | 'Item key'   | 'Procurement method' | 'Unit' | 'Store'    | 'Quantity' |
				| '1' | 'Include to work cost' | 'Material 1' | 'Material 1' | 'Stock'              | 'pcs'  | 'Store 01' | '2,000'    |
				| '2' | 'Include to work cost' | 'Material 2' | 'Material 2' | 'Stock'              | 'pcs'  | 'Store 01' | '2,000'    |
		* Second work
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Installation' |
			And I select current line in "List" table
			And I activate "Bill of materials" field in "ItemList" table
			And I click choice button of "Bill of materials" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'Furniture installation' |
			And I select current line in "List" table
			And I activate "Price" field in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check material tab
			And "Materials" table contains lines
				| '#' | 'Cost write off'       | 'Item'       | 'Item key'   | 'Procurement method' | 'Unit' | 'Store'    | 'Quantity' |
				| '3' | 'Include to work cost' | 'Material 1' | 'Material 1' | 'Stock'              | 'pcs'  | 'Store 01' | '2,000'    |
				| '4' | 'Include to work cost' | 'Material 2' | 'Material 2' | 'Stock'              | 'pcs'  | 'Store 01' | '4,000'    |
				| '5' | 'Include to work cost' | 'Material 3' | 'Material 3' | 'Stock'              | 'kg'   | 'Store 01' | '1,521'    |
		* Add workers
			And I move to "Workers" tab
			And in the table "Workers" I click the button named "WorkersAdd"
			And I activate "Employee" field in "Workers" table
			And I select current line in "Workers" table
			And I click choice button of "Employee" attribute in "Workers" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Alexander Orlov' |
			And I select current line in "List" table
			And I activate field named "WorkersUnit" in "Workers" table
			And I click choice button of the attribute named "WorkersUnit" in "Workers" table
			And I go to line in "List" table
				| 'Description' |
				| 'hour'        |
			And I select current line in "List" table
			And I activate field named "WorkersQuantity" in "Workers" table
			And I input "2,000" text in the field named "WorkersQuantity" of "Workers" table
			And I finish line editing in "Workers" table
			And in the table "Workers" I click the button named "WorkersAdd"
			And I activate "Employee" field in "Workers" table
			And I click choice button of "Employee" attribute in "Workers" table
			And I go to line in "List" table
				| 'Description'   |
				| 'David Romanov' |
			And I select current line in "List" table
			And I activate field named "WorkersUnit" in "Workers" table
			And I click choice button of the attribute named "WorkersUnit" in "Workers" table
			And I go to line in "List" table
				| 'Description' |
				| 'hour'        |
			And I select current line in "List" table
			And I activate field named "WorkersQuantity" in "Workers" table
			And I input "2,500" text in the field named "WorkersQuantity" of "Workers" table
			And I finish line editing in "Workers" table
		* Check workers tab
			And "Workers" table became equal
				| '#' | 'Employee'        | 'Unit' | 'Quantity' |
				| '1' | 'Alexander Orlov' | 'hour' | '2,000'    |
				| '2' | 'David Romanov'   | 'hour' | '2,500'    |
		* Filling branch
			And I move to "Other" tab
			And I click Choice button of the field named "Branch"
			And I go to line in "List" table
				| 'Description' |
				| 'Workshop 1'  |
			And I select current line in "List" table
			And I select "Approved" exact value from the drop-down list named "Status"			
		* Post document
			And I click the button named "FormPost"
			And I delete "$$NumberWorkOrder1$$" variable
			And I delete "$$WorkOrder1$$" variable
			And I save the value of "Number" field as "$$NumberWorkOrder1$$"
			And I save the window as "$$WorkOrder1$$"
			And I click the button named "FormPostAndClose"
		* Check document creation
			Given I open hyperlink "e1cib/list/Document.WorkOrder"
			And "List" table contains lines
				| 'Number'                    | 'Company'      |
				| '$$NumberWorkOrder1$$'      | 'Main Company' |
			And I close all client application windows
							
Scenario: _029202 create work order	based on Sales order
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"							
		And I go to line in "List" table
			| 'Number' |
			| '183'    |
	* Create WO
		And I click "Work order" button
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'    | 'Unit' | 'Use' |
			| 'TRY'      | '120,00' | '1,000'    | 'Delivery (Delivery)' | 'pcs'  | 'Yes' |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check WO
		And "ItemList" table became equal
			| '#' | 'Item'         | 'Price type'        | 'Item key'     | 'Bill of materials'      | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Quantity' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order'                               |
			| '1' | 'Installation' | 'Basic Price Types' | 'Installation' | 'Furniture installation' | 'pcs'  | 'No'                 | '14,49'      | '1,000'    | '100,00' | '5,00'          | '80,51'      | '95,00'        | 'Sales order 183 dated 22.09.2022 11:13:46' |
			| '2' | 'Assembly'     | 'Basic Price Types' | 'Assembly'     | 'Assembly'               | 'pcs'  | 'No'                 | '14,49'      | '1,000'    | '100,00' | '5,00'          | '80,51'      | '95,00'        | 'Sales order 183 dated 22.09.2022 11:13:46' |
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Front office"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "161,02"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "190,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Change status
		And I select "Approved" exact value from the drop-down list named "Status"
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberWorkOrder2$$" variable
		And I delete "$$WorkOrder2$$" variable
		And I save the value of "Number" field as "$$NumberWorkOrder2$$"
		And I save the window as "$$WorkOrder2$$"
		And I click the button named "FormPostAndClose"
	* Check document creation
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And "List" table contains lines
			| 'Number'                    | 'Company'      |
			| '$$NumberWorkOrder2$$'      | 'Main Company' |
		And I close all client application windows	
				
				
				
Scenario: _029203 create work order	based on Sales order (link form)
	And I close all client application windows
	* Open WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click "Create" button
	* Filling main attributes
		Then the form attribute named "Status" became equal to "Wait"		
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'              |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"		
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
	* Select work from SO
		And in the table "ItemList" I click "Add basis documents" button
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'    | 'Unit' | 'Use' |
			| 'TRY'      | '120,00' | '1,000'    | 'Delivery (Delivery)' | 'pcs'  | 'No'  |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check filling WO
		And "ItemList" table became equal
			| '#' | 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order'                               |
			| '1' | 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | '1,000'    | '120,00' | '6,00'          | '96,61'      | '114,00'       | 'Sales order 183 dated 22.09.2022 11:13:46' |
	* Unlink
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I set checkbox "Linked documents"
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                          |
			| 'Sales order 183 dated 22.09.2022 11:13:46' |
		And I activate field named "ResultsTreeRowPresentation" in "ResultsTree" table
		And in the table "ResultsTree" I click "Unlink all" button
	* Check
		And I click "Ok" button
		And "ItemList" table became equal
			| '#' | 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order'    |
			| '1' | 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | '1,000'    | '120,00' | '6,00'          | '96,61'      | '114,00'       | ''               |
	* Link back 
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'    | 'Unit' |
			| 'TRY'      | '120,00' | '1,000'    | 'Delivery (Delivery)' | 'pcs'  |
		And in the table "BasisesTree" I click the button named "Link"
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order'                               |
			| '1' | 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | '1,000'    | '120,00' | '6,00'          | '96,61'      | '114,00'       | 'Sales order 183 dated 22.09.2022 11:13:46' |
		And I close all client application windows
				
						

Scenario: _029207 create SI based on Work order (with SO)
	And I close all client application windows
	* Select WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'               |
			| '$$NumberWorkOrder2$$' |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I expand a line in "BasisesTree" table
			| 'Row presentation' | 'Use' |
			| '$$WorkOrder2$$'   | 'Yes' |
		And I click "Ok" button
	* Check filling
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#' | 'Price type'        | 'Item'         | 'Item key'     | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Is additional item revenue' | 'Additional analytic' | 'Store' | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                               | 'Work order'     | 'Revenue type' | 'Sales person' |
			| '1' | 'Basic Price Types' | 'Installation' | 'Installation' | ''                   | 'No'                 | '14,49'      | 'pcs'  | ''                   | '1,000'    | '100,00' | '18%' | '5,00'          | '80,51'      | '95,00'        | 'No'                         | ''                    | ''      | ''              | 'No'                        | ''       | 'Sales order 183 dated 22.09.2022 11:13:46' | '$$WorkOrder2$$' | ''             | ''             |
			| '2' | 'Basic Price Types' | 'Assembly'     | 'Assembly'     | ''                   | 'No'                 | '14,49'      | 'pcs'  | ''                   | '1,000'    | '100,00' | '18%' | '5,00'          | '80,51'      | '95,00'        | 'No'                         | ''                    | ''      | ''              | 'No'                        | ''       | 'Sales order 183 dated 22.09.2022 11:13:46' | '$$WorkOrder2$$' | ''             | ''             |
		
		And "SpecialOffers" table became equal
			| '#' | 'Amount' | 'Special offer'    |
			| '1' | '5,00'   | 'DocumentDiscount' |
			| '2' | '5,00'   | 'DocumentDiscount' |
		
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "161,02"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "28,98"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "190,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice2$$" variable
		And I delete "$$SalesInvoice2$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice2$$"
		And I save the window as "$$SalesInvoice2$$"
		And I click the button named "FormPostAndClose"
	* Check document creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'                  | 'Company'      |
			| '$$NumberSalesInvoice2$$' | 'Main Company' |
		And I close all client application windows	
				

Scenario: _029208 create SI based on Work order (without SO)
	And I close all client application windows
	* Select WO
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I go to line in "List" table
			| 'Number'               |
			| '$$NumberWorkOrder1$$' |
		And I click the button named "FormDocumentSalesInvoiceGenerate"				
		And I click "Ok" button
	* Check SI filling
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'         | 'Item key'     | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Is additional item revenue' | 'Additional analytic' | 'Store' | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Work order'     | 'Revenue type' | 'Sales person' |
			| '1' | 'en description is empty' | 'Assembly'     | 'Assembly'     | ''                   | 'No'                 | '30,51'      | 'pcs'  | ''                   | '1,000'    | '200,00' | '18%' | ''              | '200,00'     | '200,00'       | 'No'                         | ''                    | ''      | ''              | 'No'                        | ''       | ''            | '$$WorkOrder1$$' | ''             | ''             |
			| '2' | 'en description is empty' | 'Installation' | 'Installation' | ''                   | 'No'                 | '15,25'      | 'pcs'  | ''                   | '1,000'    | '100,00' | '18%' | ''              | '100,00'     | '100,00'       | 'No'                         | ''                    | ''      | ''              | 'No'                        | ''       | ''            | '$$WorkOrder1$$' | ''             | ''             |
		Then the form attribute named "Branch" became equal to "Workshop 1"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "300,00"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "45,76"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "300,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice3$$" variable
		And I delete "$$SalesInvoice3$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice3$$"
		And I save the window as "$$SalesInvoice3$$"
		And I click the button named "FormPostAndClose"
	* Check document creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'                  | 'Company'      |
			| '$$NumberSalesInvoice3$$' | 'Main Company' |
		And I close all client application windows				
						
				

				
				
						
							
						
					
				
				
				
		
				

						
