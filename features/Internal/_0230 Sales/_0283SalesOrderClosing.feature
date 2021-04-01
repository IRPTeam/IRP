#language: en
@tree
@Positive
@Sales

Functionality: sales order closing



Scenario: _0230000 preparation (Sales order closing)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When update ItemKeys
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog CancelReturnReasons objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company
	* Create test SO
		When Create document SalesOrder objects (SI before SC for check closing)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _0230001 create and check filling Sales order closing (SO not shipped)
	* Create Sales order closing 
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  | 'Date'                |
			| '32'      | '09.02.2021 19:53:45'	|	
		And I click the button named "FormDocumentSalesOrderClosingGenerateSalesOrderClosing"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "SalesOrder" became equal to "Sales order 32 dated 09.02.2021 19:53:45"
		Then the form attribute named "CloseOrder" became equal to "Yes"
		And "ItemList" table contains lines
			| 'Price type'              | 'Item'    | 'Dont calculate row' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'    | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Revenue type' | 'Detail' | 'Item key' | 'Procurement method' | 'Cancel' | 'Delivery date' | 'Cancel reason' |
			| 'Basic Price Types'       | 'Dress'   | 'No'                 | '1,000'  | 'pcs'  | '79,32'      | '520,00'   | ''              | '440,68'     | '520,00'       | 'Store 02' | 'Revenue'      | ''       | 'XS/Blue'  | 'Stock'              | 'Yes'    | '09.02.2021'    | ''              |
			| 'Basic Price Types'       | 'Shirt'   | 'No'                 | '10,000' | 'pcs'  | '533,90'     | '350,00'   | ''              | '2 966,10'   | '3 500,00'     | 'Store 02' | 'Revenue'      | ''       | '36/Red'   | 'No reserve'         | 'Yes'    | '09.02.2021'    | ''              |
			| 'Basic Price Types'       | 'Boots'   | 'No'                 | '24,000' | 'pcs'  | '2 562,71'   | '8 400,00' | ''              | '14 237,29'  | '16 800,00'    | 'Store 02' | 'Revenue'      | ''       | '37/18SD'  | 'Purchase'           | 'Yes'    | '09.02.2021'    | ''              |
			| 'en description is empty' | 'Service' | 'No'                 | '1,000'  | 'pcs'  | '15,25'      | '100,00'   | ''              | '84,75'      | '100,00'       | 'Store 02' | 'Revenue'      | ''       | 'Interner' | ''                   | 'Yes'    | '09.02.2021'    | ''              |
		Then the number of "ItemList" table lines is "equal" "4"
		Then the form attribute named "Currency" became equal to "TRY"
	* Try to post document without filling in cancel reason
		And I click the button named "FormPost"
		Then I wait that in user messages the "Cancel reason has to be filled if string was canceled" substring will appear in "10" seconds
	* Filling in cancel reason and post Sales order closing
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'   |
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'not available' |
		And I select current line in "List" table	
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '36/Red'   |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "ItemList" table
		And I select "not available" exact value from "Cancel reason" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key' |
			| 'Service' | 'Interner' |
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
			| 'Number'                |
			| '$$NumberSalesOrderClosing0230001$$' |
		And I close all client application windows
	

Scenario: _0230002 create and check filling Sales order closing (SO partially shipped)
	* Preparation
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		If "List" table contains lines Then
				| "Number" |
				| "$$NumberSalesOrderClosing0230001$$" |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrderClosing.FindByNumber($$NumberSalesOrderClosing0230001$$).GetObject().Write(DocumentWriteMode.UndoPosting);" |
	* Load SI and SC for SO 32
		When Create document SalesInvoice objects (for check SO closing)
		When Create document ShipmentConfirmation objects (check SO closing)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |	
		And I execute 1C:Enterprise script at server
 			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
	* Create Sales order closing 
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  | 'Date'                |
			| '32'      | '09.02.2021 19:53:45'	|
		And I click the button named "FormDocumentSalesOrderClosingGenerateSalesOrderClosing"	
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "SalesOrder" became equal to "Sales order 32 dated 09.02.2021 19:53:45"
		And "ItemList" table contains lines
			| 'Business unit'           | 'Price type'              | 'Item'    | 'Dont calculate row' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'    | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Revenue type' | 'Detail' | 'Item key' | 'Procurement method' | 'Cancel' | 'Delivery date' | 'Cancel reason' |
			| 'Distribution department' | 'Basic Price Types'       | 'Shirt'   | 'No'                 | '1,000'  | 'pcs'  | '53,39'      | '350,00'   | ''              | '296,61'     | '350,00'       | 'Store 02' | 'Revenue'      | ''       | '36/Red'   | 'No reserve'         | 'Yes'    | '09.02.2021'    | ''              |
			| 'Distribution department' | 'Basic Price Types'       | 'Boots'   | 'No'                 | '24,000' | 'pcs'  | '2 562,71'   | '8 400,00' | ''              | '14 237,29'  | '16 800,00'    | 'Store 02' | 'Revenue'      | ''       | '37/18SD'  | 'Purchase'           | 'Yes'    | '09.02.2021'    | ''              |
			| 'Front office'            | 'en description is empty' | 'Service' | 'No'                 | '1,000'  | 'pcs'  | '15,25'      | '100,00'   | ''              | '84,75'      | '100,00'       | 'Store 02' | 'Revenue'      | ''       | 'Interner' | ''                   | 'Yes'    | '09.02.2021'    | ''              |
		Then the number of "ItemList" table lines is "equal" "3"
		And I close all client application windows



# Scenario: _0230003 manually filling in Sales order closing (SO partially shipped)
# 	* Preparation
# 		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
# 		If "List" table contains lines Then
# 				| "Number" |
# 				| "$$NumberSalesOrderClosing0230001$$" |
# 			And I execute 1C:Enterprise script at server
# 				| "Documents.SalesOrderClosing.FindByNumber($$NumberSalesOrderClosing0230001$$).GetObject().Write(DocumentWriteMode.UndoPosting);" |
# 		* Load SI for SO 32
# 			When Create document SalesInvoice objects (for check SO closing)
# 			And I execute 1C:Enterprise script at server
#  				| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |	
# 	* Create Sales order closing  
# 		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
# 		And I click the button named "FormCreate"
# 		And I click Select button of "Partner" field
# 		And I go to line in "List" table
# 			| 'Description' |
# 			| 'Ferron BP'   |
# 		And I select current line in "List" table
# 		And I click Select button of "Legal name" field
# 		And I go to line in "List" table
# 			| 'Description'       |
# 			| 'Company Ferron BP' |
# 		And I select current line in "List" table
# 		And I click Select button of "Partner term" field
# 		And I go to line in "List" table
# 			| 'Description'              |
# 			| 'Basic Partner terms, TRY' |
# 		And I select current line in "List" table
# 		And I select "Approved" exact value from "Status" drop-down list
# 		And I click Select button of "Sales order" field
# 		And I go to line in "List" table
# 			| 'Number' |
# 			| '32'     |
# 		And I select current line in "List" table
# 	* Filling in Sales order closing
# 		And I set checkbox "Close order"
# 		And I click "Fill by order" button
# 		Then the form attribute named "Store" became equal to "Store 02"
# 		And "ItemList" table contains lines
# 			| 'Business unit'           | 'Price type'              | 'Item'    | 'Dont calculate row' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'    | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Revenue type' | 'Detail' | 'Item key' | 'Procurement method' | 'Cancel' | 'Delivery date' | 'Cancel reason' |
# 			| 'Distribution department' | 'Basic Price Types'       | 'Shirt'   | 'No'                 | '1,000'  | 'pcs'  | '53,39'      | '350,00'   | ''              | '296,61'     | '350,00'       | 'Store 02' | 'Revenue'      | ''       | '36/Red'   | 'No reserve'         | 'Yes'    | '09.02.2021'    | ''              |
# 			| 'Distribution department' | 'Basic Price Types'       | 'Boots'   | 'No'                 | '24,000' | 'pcs'  | '2 562,71'   | '8 400,00' | ''              | '14 237,29'  | '16 800,00'    | 'Store 02' | 'Revenue'      | ''       | '37/18SD'  | 'Purchase'           | 'Yes'    | '09.02.2021'    | ''              |
# 			| 'Front office'            | 'en description is empty' | 'Service' | 'No'                 | '1,000'  | 'pcs'  | '15,25'      | '100,00'   | ''              | '84,75'      | '100,00'       | 'Store 02' | 'Revenue'      | ''       | 'Interner' | ''                   | 'Yes'    | '09.02.2021'    | ''              |
# 		Then the number of "ItemList" table lines is "equal" "3"
# 		And I close all client application windows
			

		
				

		
				



				

		
				
		
				
				

		
				
		


