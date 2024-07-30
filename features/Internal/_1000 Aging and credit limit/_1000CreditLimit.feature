#language: en
@tree
@Positive
@AgingAndCreditLimit

Feature: credit limit

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _1000000 preparation (credit limit)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
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
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
	* Creation of a Sales order on Crystal, Basic Partner terms, TRY, Sales invoice before Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I click "List" button			
			And I go to line in "List" table
				| 'Description'     |
				| 'Crystal'         |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Shirt'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '38/Black'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '36/18SD'      |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Boots (12 pcs)'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme
			And I move to "Other" tab
			And I click the button named "FormPost"
			And I delete "$$SalesOrder20400011$$" variable
			And I delete "$$NumberSalesOrder20400011$$" variable
			And I save the window as "$$SalesOrder20400011$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400011$$"
			And I click the button named "FormPostAndClose"
	* Creation of a Sales order on Kalipso, Basic Partner terms, TRY, Shipment confirmation before Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'S/Yellow'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '36/18SD'      |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Boots (12 pcs)'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme and document number
			And I move to "Other" tab
			And I click the button named "FormPost"
			And I delete "$$SalesOrder20400012$$" variable
			And I delete "$$NumberSalesOrder20400012$$" variable
			And I save the window as "$$SalesOrder20400012$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400012$$"
			And I click the button named "FormPostAndClose"
	* Creation of a Sales order on Crystal, Basic Partner terms, TRY, Sales invoice before Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Crystal'         |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'M/White'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '36/18SD'      |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Boots (12 pcs)'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$SalesOrder20400014$$" variable
			And I delete "$$NumberSalesOrder20400014$$" variable
			And I save the window as "$$SalesOrder20400014$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400014$$"
			And I click the button named "FormPostAndClose"
	* Create Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		Then "Sales orders" window is opened
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesOrder20400012$$'    |
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button	
		And I move to "Other" tab
		And I click the button named "FormPost"
		And I delete "$$ShipmentConfirmation20400018$$" variable
		And I delete "$$NumberShipmentConfirmation20400018$$" variable
		And I save the window as "$$ShipmentConfirmation20400018$$"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation20400018$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Check documents
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table contains lines Then
			| "Number"    |
			| "1"         |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		If "List" table contains lines Then
			| "Number"    |
			| "1"         |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		If "List" table contains lines Then
			| "Number"    |
			| "1"         |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
	* Create CustomersAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I input current date in the field named "EndOfPeriod"
		And I input current date in the field named "BeginOfPeriod"
		And I click "Post and close" button
		And I close all client application windows
		
Scenario: _10000001 check preparation
	When check preparation
			
						


Scenario: _1000001 filling in credit limit in the Partner term
	Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Basic Partner terms, TRY
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I set checkbox "Use credit limit"
		And I input "10000,00" text in "Amount" field
		And I click "Save and close" button
	* DFC Customer by Partner terms
	Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I go to line in "List" table
			| 'Description'                      |
			| 'DFC Customer by Partner terms'    |
		And I select current line in "List" table
		And I input "" text in "Partner" field
		And I input "" text in "Legal name" field
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Retail'         |
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I set checkbox "Use credit limit"
		And I input "4000,00" text in "Amount" field
		And I click "Save and close" button


Scenario: _1000002 check credit limit when post Sales invoice based on Sales order (Ap-Ar posting detail by documents)
	* Create Sales invoice for $$SalesOrder20400011$$
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesOrder20400011$$'    |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I delete "$$SalesInvoice20400011$$" variable	
		And I delete "$$NumberSalesInvoice20400011$$" variable
		And I save the window as "$$SalesInvoice20400011$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice20400011$$"
		And I click the button named "FormPostAndClose"
		Then user message window does not contain messages
	* Create Sales invoice for $$SalesOrder20400014$$ and check credit limit
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesOrder20400014$$'    |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I click the button named "FormPostAndClose"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Credit limit exceeded. Limit: 10 000, limit balance: 200, transaction: 13 260, lack: 13 060 TRY" substring will appear in 20 seconds
		And I click the button named "FormWrite"
		And I delete "$$SalesInvoice20400014$$" variable
		And I delete "$$NumberSalesInvoice20400014$$" variable
		And I save the window as "$$SalesInvoice20400014$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice20400014$$"
		And I close all client application windows
	* Create payment (10 000) and try post $$SalesInvoice20400014$$
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                            |
			| '$$NumberSalesInvoice20400011$$'    |
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		And I input current date in the field named "Date"
		And I click the button named "FormPost"
		And I delete "$$BankReceipt20400011$$" variable
		And I delete "$$NumberBankReceipt20400011$$" variable
		And I save the window as "$$BankReceipt20400011$$"
		And I save the value of "Number" field as "$$NumberBankReceipt20400011$$"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                            |
			| '$$NumberSalesInvoice20400014$$'    |
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Credit limit exceeded. Limit: 10 000, limit balance: 200, transaction: 13 260, lack: 13 060 TRY" substring will appear in 20 seconds
	* Create payment (3 060 - advance) and try post $$SalesInvoice20400014$$
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I move to "Payments" tab
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №1'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Crystal'        |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "3 500,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I select "Basic Partner terms, TRY" from "Partner term" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table	
		And I click the button named "FormPost"
		And I input current date in "Date" field
		And I click the button named "FormPostAndClose"
	* Post CustomersAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Check sales invoice posting		
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                            |
			| '$$NumberSalesInvoice20400014$$'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages	
		And I close all client application windows
				
		
				
		
Scenario: _1000003 check credit limit when post	Sales invoice based in Shipment confirmation (Ap-Ar posting detail by partner term)
	* Create Sales invoice, partner term DFC Customer by Partner terms (Kalipso)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer information
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                       |
				| 'DFC Customer by Partner terms'     |
			And I select current line in "List" table
		* Select store 
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
		And I click "OK" button
		Then I wait that in user messages the "Credit limit exceeded. Limit: 4 000, limit balance: 4 000, transaction: 6 490, lack: 2 490 TRY" substring will appear in 20 seconds                           
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'L/Green'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I delete "$$NumberSalesInvoice10000031$$" variable
		And I delete "$$SalesInvoice10000031$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice10000031$$"
		And I save the window as "$$SalesInvoice10000031$$"
		And I click the button named "FormPostAndClose"
	* Create Sales invoice, partner term DFC Customer by Partner terms (Lomaniti)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer information
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Lomaniti'        |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                       |
				| 'DFC Customer by Partner terms'     |
			And I select current line in "List" table
		* Select store 
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I delete "$$NumberSalesInvoice10000032$$" variable
		And I delete "$$SalesInvoice10000032$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice10000032$$"
		And I save the window as "$$SalesInvoice10000032$$"
		And I click the button named "FormPostAndClose"	
	* Create advance payment from Kalipso and check Sales invoice post
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I move to "Payments" tab
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №1'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "10 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Partner term" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I select "DFC Customer by Partner terms" from "Partner term" drop-down list by string in "PaymentList" table	
		And I click the button named "FormPostAndClose"			
		* Create SI and filling in customer information
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                       |
				| 'DFC Customer by Partner terms'     |
			And I select current line in "List" table
		* Select store 
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "50,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I click "OK" button
			Then I wait that in user messages the "Credit limit exceeded. Limit: 4 000, limit balance: 4 000, transaction: 6 490, lack: 2 490 TRY" substring will appear in 20 seconds
			And I close all client application windows
			

Scenario: _999999 close TestClient session
	* Clear postings
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table contains lines Then
			| "Partner"    |
			| "Kalipso"    |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		If "List" table contains lines Then
			| 'Number'    |
			| '1'         |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Close TestClient session				
		And I close TestClient session
