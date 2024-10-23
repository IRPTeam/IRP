#language: en
@tree
@Positive
@Services

Feature: incoming services

As a financier
I want to fill out the information on the services I received and which I provided
For cost analysis

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029100 preparation
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
		When Create catalog Partners objects (Ferron BP)
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
		When Create information register Taxes records (VAT)

Scenario: _0291001 check preparation
	When check preparation	


Scenario: _029101 create item type for services
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	And I click the button named "FormCreate"
	And I input "Service" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Service TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I change "Type" radio button value to "Service"
	And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
	And I click choice button of "Attribute" attribute in "AvailableAttributes" table
	And I click the button named "FormCreate"
	And I input "Service type" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Service type TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button
	And I go to line in "List" table
		| Description    |
		| Service type   |
	And I click the button named "FormChoose"
	And I finish line editing in "AvailableAttributes" table
	And I click "Save and close" button
	And Delay 2
	Then I check for the "ItemTypes" catalog element with the "Description_en" "Service"

Scenario: _029102 create Item - Service
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I click the button named "FormCreate"
	And I input "Service" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Service TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click Select button of "Item type" field
	And I go to line in "List" table
		| Description   |
		| Service       |
	And I select current line in "List" table
	And I click Select button of "Unit" field
	And I go to line in "List" table
		| Description   |
		| pcs           |
	And I select current line in "List" table
	And I click "Save" button
	And In this window I click command interface button "Item keys"
	* Adding an item key for Internet service
		And I click the button named "FormCreate"
		And I click Select button of "Service type" field
		And I click the button named "FormCreate"
		And I input "Internet" text in the field named "Description_en"
		And I click Open button of "ENG" field
		And I input "Internet TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Adding an item key for Rent
		And I click the button named "FormCreate"
		And I click Select button of "Service type" field
		And I click the button named "FormCreate"
		And I input "Rent" text in the field named "Description_en"
		And I click Open button of "ENG" field
		And I input "Rent TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click "Save and close" button
	And I close all client application windows
	

Scenario: _029103 create a Purchase order for service
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in Company and Status
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description           |
			| Vendor Ferron, TRY    |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Service        |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I activate "Profit loss center" field in "ItemList" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Front office'   |
		And I select current line in "List" table
		And I activate "Expense type" field in "ItemList" table
		And I click choice button of "Expense type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Telephone communications'   |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1000,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input end of the current month date in "Delivery date" field
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder029103$$" variable
		And I delete "$$PurchaseOrder029103$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder029103$$"
		And I save the window as "$$PurchaseOrder029103$$"
		And I click the button named "FormPostAndClose"
		* Check creation
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And "List" table contains lines
				| 'Number'                            |
				| '$$NumberPurchaseOrder029103$$'     |
		And I close all client application windows


Scenario: _029104 create a Purchase invoice for service 
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number'                          |
		| '$$NumberPurchaseOrder029103$$'   |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseInvoiceGenerate"
	And I click "Ok" button
	* Check the filling of the tabular part
		And "ItemList" table contains lines
		| 'Price'     | 'Item'     | 'VAT'  | 'Item key'  | 'Quantity'  | 'Tax amount'  | 'Unit'  | 'Net amount'  | 'Total amount'  | 'Expense type'              | 'Profit loss center'  | 'Purchase order'            |
		| '1 000,00'  | 'Service'  | '18%'  | 'Internet'  | '1,000'     | '152,54'      | 'pcs'   | '847,46'      | '1 000,00'      | 'Telephone communications'  | 'Front office'        | '$$PurchaseOrder029103$$'   |
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseInvoice029104$$" variable
	And I delete "$$PurchaseInvoice029104$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseInvoice029104$$"
	And I save the window as "$$PurchaseInvoice029104$$"
	And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029104$$'    |
		And I close all client application windows
		
	
	
	
Scenario: _029106 create a Purchase invoice for service and product (based on Purchase order, Store use Goods receipt)
		* Create Item Router
			Given I open hyperlink "e1cib/list/Catalog.Items"
			And I click the button named "FormCreate"
			And I input "Router" text in the field named "Description_en"
			And I click Select button of "Item type" field
			And I click the button named "FormCreate"
			And I input "Equipment" text in the field named "Description_en"
			And I click "Save and close" button
			And I click the button named "FormChoose"
			And I click Select button of "Unit" field
			And I select current line in "List" table
			And I click "Save" button
			And In this window I click command interface button "Item keys"
			And I click the button named "FormCreate"
			And I click "Save and close" button
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
		* Filling in vendor information
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, TRY     |
			And I select current line in "List" table
		* Filling in items table ((add product and service))
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Service         |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I activate "Profit loss center" field in "ItemList" table
			And I click choice button of "Profit loss center" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
			| Description                 |
			| Telephone communications    |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Router          |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I click the button named "FormChoose"
			And I activate "Profit loss center" field in "ItemList" table
			And I click choice button of "Profit loss center" attribute in "ItemList" table
			And I go to line in "List" table
				| Description      |
				| Front office     |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description     |
				| Software        |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice029106$$" variable
			And I delete "$$PurchaseInvoice029106$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice029106$$"
			And I save the window as "$$PurchaseInvoice029106$$"
			And I click the button named "FormPost"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'                             |
			| '$$NumberPurchaseInvoice029106$$'    |
		And I close all client application windows



Scenario: _029107 create a Sales order for service and product (Store does not use Shipment confirmation)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	Then "Partner terms" window is opened
	And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
	And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Service        |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item      | Item key    |
			| Service   | Rent        |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'    | 'Item'      | 'VAT'   | 'Item key'   | 'Procurement method'   | 'Price type'                | 'Quantity'   | 'Offers amount'   | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'    |
			| '100,00'   | 'Service'   | '18%'   | 'Rent'       | ''                     | 'en description is empty'   | '1,000'      | ''                | 'pcs'    | 'No'                   | '15,25'        | '84,75'        | '100,00'         | ''         |
		Then the form attribute named "ItemListTotalNetAmount" became equal to "84,75"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "15,25"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "100,00"
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Table'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Table'   | 'Table'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "700,00" text in "Price" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalNetAmount" became equal to "6 016,95"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 083,05"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "7 100,00"
		And "ItemList" table contains lines
			| 'Price'    | 'Item'      | 'VAT'   | 'Item key'   | 'Procurement method'   | 'Price type'                | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '100,00'   | 'Service'   | '18%'   | 'Rent'       | ''                     | 'en description is empty'   | '1,000'      | 'pcs'    | 'No'                   | '15,25'        | '84,75'        | '100,00'         | ''            |
			| '700,00'   | 'Table'     | '18%'   | 'Table'      | 'Stock'                | 'en description is empty'   | '10,000'     | 'pcs'    | 'No'                   | '1 067,80'     | '5 932,20'     | '7 000,00'       | 'Store 01'    |
		And I input end of the current month date in "Delivery date" field
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder029107$$" variable
		And I delete "$$SalesOrder029107$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029107$$"
		And I save the window as "$$SalesOrder029107$$"
		And I click the button named "FormPost"
		And I close all client application windows
		
	

Scenario: _029115 create a Sales invoice for service and product (Store does not use Shipment confirmation, based on $$SalesOrder029107$$)
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder029107$$'    |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029115$$" variable
		And I delete "$$SalesInvoice029115$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029115$$"
		And I save the window as "$$SalesInvoice029115$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberSalesInvoice029115$$'    |
		And I close all client application windows

	

	

Scenario: _029130 create Retail sales receipt for service and product
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Ferron BP'     |
	And I select current line in "List" table
	Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
	And I select current line in "List" table
	* Filling in items tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Table'          |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Table'          |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service'        |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'      | 'Item key'    |
			| 'Service'   | 'Internet'    |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "50,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I click choice button of "Payment type" attribute in "Payments" table
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "450,00" text in the field named "PaymentsAmount" of "Payments" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Currency'   | 'Description'     |
			| 'TRY'        | 'Cash desk №4'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I finish line editing in "Payments" table
	* Check movements
		And I click the button named "FormPost"
		And I delete "$$NumberRetailSalesReceipt029130$$" variable
		And I delete "$$RetailSalesReceipt029130$$" variable
		And I save the value of "Number" field as "$$NumberRetailSalesReceipt029130$$"
		And I save the window as "$$RetailSalesReceipt029130$$"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$RetailSalesReceipt029130$$'     | ''         | ''            | ''         | ''             | ''                | ''               | ''         | ''           | ''               | ''                               | ''           | ''                    | ''           |
			| 'Document registrations records'   | ''         | ''            | ''         | ''             | ''                | ''               | ''         | ''           | ''               | ''                               | ''           | ''                    | ''           |
			| 'Register  "R2050 Retail sales"'   | ''         | ''            | ''         | ''             | ''                | ''               | ''         | ''           | ''               | ''                               | ''           | ''                    | ''           |
			| ''                                 | 'Period'   | 'Resources'   | ''         | ''             | ''                | 'Dimensions'     | ''         | ''           | ''               | ''                               | ''           | ''                    | ''           |
			| ''                                 | ''         | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'   | 'Store'      | 'Sales person'   | 'Retail sales receipt'           | 'Item key'   | 'Serial lot number'   | 'Row key'    |
			| ''                                 | '*'        | '1'           | '50'       | '42,37'        | ''                | 'Main Company'   | ''         | ''           | ''               | '$$RetailSalesReceipt029130$$'   | 'Internet'   | ''                    | '*'          |
			| ''                                 | '*'        | '1'           | '200'      | '169,49'       | ''                | 'Main Company'   | ''         | 'Store 01'   | ''               | '$$RetailSalesReceipt029130$$'   | 'Table'      | ''                    | '*'          |
			| ''                                 | '*'        | '1'           | '200'      | '169,49'       | ''                | 'Main Company'   | ''         | 'Store 01'   | ''               | '$$RetailSalesReceipt029130$$'   | 'Table'      | ''                    | '*'          |
		And I close all client application windows
	

		

				
Scenario: _029140 create PurchaseReturn for service and product (based on $$PurchaseInvoice029106$$)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'                            |
		| '$$NumberPurchaseInvoice029106$$'   |
	And I click the button named "FormDocumentPurchaseReturnGenerate"
	And I click "Ok" button	
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturn029140$$" variable
	And I delete "$$PurchaseReturn029140$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturn029140$$"
	And I save the window as "$$PurchaseReturn029140$$"
	And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberPurchaseReturn029140$$'    |
		And I close all client application windows

	
	
				
Scenario: _029141 create Purchase return order and Purchase return for service and product (based on $$PurchaseInvoice029106$$)
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	If "List" table contains lines Then
		| "Number"                           |
		| "$$NumberPurchaseReturn029140$$"   |
		And I go to line in "List" table
			| 'Number'                            |
			| '$$NumberPurchaseReturn029140$$'    |
		And I activate "Partner" field in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'                            |
		| '$$NumberPurchaseInvoice029106$$'   |
	And I click the button named "FormDocumentPurchaseReturnOrderGenerate"
	And I click "Ok" button	
	And I select "Approved" exact value from "Status" drop-down list
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturnOrder029141$$" variable
	And I delete "$$PurchaseReturnOrder029141$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder029141$$"
	And I save the window as "$$PurchaseReturnOrder029141$$"
	And I click "Registrations report" button
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I go to line in "List" table
		| 'Number'                                |
		| '$$NumberPurchaseReturnOrder029141$$'   |
	And I click the button named "FormDocumentPurchaseReturnGenerate"
	And I click "Ok" button	
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturn029141$$" variable
	And I delete "$$PurchaseReturn029141$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturn029141$$"
	And I save the window as "$$PurchaseReturn029141$$"
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And "List" table contains lines
		| 'Number'                           |
		| '$$NumberPurchaseReturn029141$$'   |
	And I close all client application windows
	
Scenario: _029142 create Purchase return for service and product without Purchase invoice
	* Create PurchaseReturn
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Table'          |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service'        |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'      | 'Item key'    |
			| 'Service'   | 'Internet'    |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "50,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn029142$$" variable
		And I delete "$$PurchaseReturn029142$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn029142$$"
		And I save the window as "$$PurchaseReturn029142$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberPurchaseReturn029142$$'    |
		And I close all client application windows
		


Scenario: _029150 create Retail return receipt for service and product
	* Create Retail return receipt based on Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'                                |
			| '$$NumberRetailSalesReceipt029130$$'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I click "Ok" button	
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt029150$$" variable
		And I delete "$$RetailReturnReceipt029150$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt029150$$"
		And I save the window as "$$RetailReturnReceipt029150$$"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "R2050 Retail sales"'   | ''         | ''            | ''         | ''             | ''                | ''               | ''         | ''           | ''               | ''                               | ''           | ''                    | ''           |
			| ''                                 | 'Period'   | 'Resources'   | ''         | ''             | ''                | 'Dimensions'     | ''         | ''           | ''               | ''                               | ''           | ''                    | ''           |
			| ''                                 | ''         | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'   | 'Store'      | 'Sales person'   | 'Retail sales receipt'           | 'Item key'   | 'Serial lot number'   | 'Row key'    |
			| ''                                 | '*'        | '-1'          | '-50'      | '-42,37'       | ''                | 'Main Company'   | '*'        | ''           | ''               | '$$RetailSalesReceipt029130$$'   | 'Internet'   | ''                    | '*'          |
			| ''                                 | '*'        | '-1'          | '-200'     | '-169,49'      | ''                | 'Main Company'   | '*'        | 'Store 01'   | ''               | '$$RetailSalesReceipt029130$$'   | 'Table'      | ''                    | '*'          |
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "R3010 Cash on hand"'   | ''              | ''         | ''            | ''               | ''         | ''               | ''           | ''                       | ''                               | ''                       | ''   | ''   | ''   | ''   | ''    |
			| ''                                 | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''               | ''           | ''                       | ''                               | 'Attributes'             | ''   | ''   | ''   | ''   | ''    |
			| ''                                 | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'   | ''   | ''   | ''   | ''   | ''    |
			| ''                                 | 'Expense'       | '*'        | '77,04'       | 'Main Company'   | '*'        | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                     | ''   | ''   | ''   | ''   | ''    |
			| ''                                 | 'Expense'       | '*'        | '450'         | 'Main Company'   | '*'        | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                     | ''   | ''   | ''   | ''   | ''    |
			| ''                                 | 'Expense'       | '*'        | '450'         | 'Main Company'   | '*'        | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                     | ''   | ''   | ''   | ''   | ''    |
		
		And I close all client application windows
	* Create Retail return receipt without Retail sales receipt
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, TRY'      |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Table'           |
			And I select current line in "List" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I input "20,00" text in "Landed cost" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Service'         |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key'     |
				| 'Service'    | 'Internet'     |
			And I select current line in "List" table
			And I activate "Price" field in "ItemList" table
			And I input "50,00" text in "Price" field of "ItemList" table
			And I input "20,00" text in "Landed cost" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "250,00" text in the field named "PaymentsAmount" of "Payments" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			And I go to line in "List" table
				| 'Currency'    | 'Description'      |
				| 'TRY'         | 'Cash desk №4'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I finish line editing in "Payments" table
			And I click the button named "FormPost"
			And I delete "$$NumberRetailReturnReceipt029150$$" variable
			And I delete "$$RetailReturnReceipt029150$$" variable
			And I save the value of "Number" field as "$$NumberRetailReturnReceipt029150$$"
			And I save the window as "$$RetailReturnReceipt029150$$"	
			And I close all client application windows
	* Check creation	
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
			And "List" table contains lines
				| 'Number'                                  |
				| '$$NumberRetailReturnReceipt029150$$'     |
			And I close all client application windows