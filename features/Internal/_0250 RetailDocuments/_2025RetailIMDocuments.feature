#language: en
@tree
@Positive
@RetailDocuments

Feature: check filling in retail IM documents (Retail SO - Retail SC - Retail GR)

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _0155100 preparation (Retail SO - Retail SC - Retail GR)
	When set True value to the constant
	* Load info
		When Create catalog BusinessUnits objects
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
		When Create catalog Partners objects (Customer)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Partners and Payment type (Bank)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create PaymentType (advance)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog Users objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail document)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog UserGroups objects
	* Create payment terminal
		When Create catalog PaymentTerminals objects
	* Create PaymentTypes
		When Create catalog PaymentTypes objects
	* Create BankTerms
		When Create catalog BankTerms objects (for retail)	
	* Workstation
		When create Workstation
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	* Load RSO
		When create RetailSalesOrder objects
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create RetailSalesOrder, RetailGoodsReceipt, RetailShipmentConfirmation, BR and CR objects for check links IM documents in POS
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(317).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(318).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailShipmentConfirmation.FindByNumber(317).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailShipmentConfirmation.FindByNumber(318).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailGoodsReceipt.FindByNumber(317).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(317).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(317).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesOrder - RetailShipmentConfirmation - RetailSalesReceipt (different Branch)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(720).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailShipmentConfirmation.FindByNumber(721).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1708).GetObject().Write(DocumentWriteMode.Posting);"    |
	
Scenario: _01551001 check preparation
	When check preparation	

	
				
Scenario: _0155250 create retail sales order
	* Preparation
		When set True value to the constant Use retail orders
	* Create retail sales receipt (with pre-payment)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling header
			And I select "Retail sales" exact value from "Transaction type" drop-down list
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I click Select button of "Retail customer" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Sam Jons'        |
			And I select current line in "List" table
			And I activate field named "ItemListLineNumber" in "ItemList" table
		* Check filling
			Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
			Then the form attribute named "Partner" became equal to "Retail customer"
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
			Then the form attribute named "Agreement" became equal to "Retail partner term"
			Then the form attribute named "Status" became equal to "Approved"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "TransactionType" became equal to "Retail sales"		
		* Filling items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			And I activate field named "ItemKey" in "List" table
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I select current line in "List" table
		* Filling payments
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I click choice button of "Payment type" attribute in "Payments" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Card 02'         |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate "Bank term" field in "Payments" table
			And I click choice button of "Bank term" attribute in "Payments" table
			Then "Bank terms" window is opened
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "1 000,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table
			And I click "Post" button
		* Check payments
			And "Payments" table became equal
				| '#' | 'Amount'   | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term'    | 'Account'        | 'Percent' |
				| '1' | '1 000,00' | '20,00'      | 'Card 02'      | ''                 | 'Bank term 01' | 'Transit Second' | '2,00'    |
		* Post Sales order
			And I delete "$$NumberSalesOrder50$$" variable
			And I delete "$$SalesOrder50$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder50$$"
			And I click the button named "FormPost"
			And I save the window as "$$SalesOrder50$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
				| 'Number'                     |
				| '$$NumberSalesOrder50$$'     |
			And I close all client application windows
						
					
Scenario: _0155255 create Bank receipt based on retail sales order
	And I close all client application windows
	* Select retail sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"									
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Create bank receipt
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
	* Check filling
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "TransactionType" became equal to "Retail customer advance"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#'   | 'Commission'   | 'Retail customer'   | 'Expense type'   | 'Payment type'   | 'Commission percent'   | 'Additional analytic'   | 'Payment terminal'   | 'Bank term'      | 'Order'                                       | 'Total amount'   | 'Financial movement type'   | 'Profit loss center'    |
			| '1'   | '20,00'        | 'Sam Jons'          | ''               | 'Card 02'        | '2,00'                 | ''                      | ''                   | 'Bank term 01'   | 'Sales order 314 dated 09.01.2023 12:49:08'   | '1 000,00'       | ''                          | ''                      |
		And I activate "Total amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 010,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table	
		And I click "Post" button
		And I delete "$$NumberBankReceipt314$$" variable
		And I delete "$$BankReceipt314$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt314$$"
		And I click the button named "FormPost"
		And I save the window as "$$BankReceipt314$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And "List" table contains lines
			| 'Number'                      |
			| '$$NumberBankReceipt314$$'    |
		And I close all client application windows		
				
	
		
Scenario: _0155260 create Cash receipt based on retail sales order
	And I close all client application windows
	* Select retail sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"									
		And I go to line in "List" table
			| 'Number'    |
			| '315'       |
	* Create cash receipt
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
	* Check filling
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Retail customer advance"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#'   | 'Retail customer'   | 'Order'                                       | 'Total amount'   | 'Financial movement type'    |
			| '1'   | 'Sam Jons'          | 'Sales order 315 dated 09.01.2023 13:02:11'   | '1 000,00'       | ''                           |
		And I click "Post" button
		And I delete "$$NumberCashReceipt315$$" variable
		And I delete "$$CashReceipt315$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt315$$"
		And I click the button named "FormPost"
		And I save the window as "$$CashReceipt315$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.CashReceipt"		
		And "List" table contains lines
			| 'Number'                      |
			| '$$NumberCashReceipt315$$'    |
		And I close all client application windows

Scenario: _0155265 create retail sales receipt based on retail sales order
	And I close all client application windows
	* Select retail sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"									
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Create retail sales receipt
		And I click the button named "FormDocumentRetailSalesReceiptGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Sales person'   | 'Price type'          | 'Item'    | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Detail'   | 'Sales order'                                 | 'Revenue type'    |
			| '1'   | ''               | 'Basic Price Types'   | 'Dress'   | 'XS/Blue'    | ''                     | 'No'                   | ''                     | 'pcs'    | '158,64'       | ''                    | '2,000'      | '520,00'   | '18%'   | ''                | '881,36'       | '1 040,00'       | ''                      | 'Store 01'   | ''         | 'Sales order 314 dated 09.01.2023 12:49:08'   | ''                |
			| '2'   | ''               | 'Basic Price Types'   | 'Boots'   | '37/18SD'    | ''                     | 'No'                   | ''                     | 'pcs'    | '213,56'       | ''                    | '2,000'      | '700,00'   | '18%'   | ''                | '1 186,44'     | '1 400,00'       | ''                      | 'Store 01'   | ''         | 'Sales order 314 dated 09.01.2023 12:49:08'   | ''                |
		And "Payments" table became equal
			| '#'   | 'Amount'     | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Bank term'   | 'Account'   | 'Percent'    |
			| '1'   | '1 010,00'   | ''             | 'Advance'        | ''                   | ''            | ''          | ''           |
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Cash'           |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "1 430,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table	
		And I click "Post" button
		And I delete "$$NumberRetailSalesReceipt314$$" variable
		And I delete "$$RetailSalesReceipt314$$" variable
		And I save the value of "Number" field as "$$NumberRetailSalesReceipt314$$"
		And I click the button named "FormPost"
		And I save the window as "$$RetailSalesReceipt314$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"		
		And "List" table contains lines
			| 'Number'                             |
			| '$$NumberRetailSalesReceipt314$$'    |
		And I close all client application windows

Scenario: _0155266 create Retail SC based on Retail sales order
	And I close all client application windows
	* Select retail sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"									
		And I go to line in "List" table
			| 'Number'    |
			| '315'       |
	* Create retail shipment confirmation
		And I click the button named "FormDocumentRetailShipmentConfirmationGenerate"
		And I click "Ok" button
	* Check filling retail shipment confirmation
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Courier" became equal to ""
		Then the form attribute named "TransactionType" became equal to "Courier delivery"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Item'    | 'Item key'   | 'Serial lot numbers'   | 'Unit'   | 'Quantity'   | 'Store'      | 'Sales order'                                  |
			| '1'   | 'Dress'   | 'XS/Blue'    | ''                     | 'pcs'    | '2,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
			| '2'   | 'Boots'   | '37/18SD'    | ''                     | 'pcs'    | '3,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
		And I close all client application windows

Scenario: _0155267 create Retail SC (link form)
	And I close all client application windows
	* Create retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"		
		And I click the button named "FormCreate"
	* Filling main details
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Retail customer" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I select "Courier delivery" exact value from "Transaction type" drop-down list
		And I click Select button of "Courier" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Foxred'         |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Filling retail shipment confirmation
		* Add Dress
			And in the table "ItemList" I click "Search by barcode" button
			And I input "2202283705" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click "Search by barcode" button
			And I input "2202283705" text in the field named "Barcode"
			And I move to the next attribute
		* Add Boots
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add item with one SLN
			And in the table "ItemList" I click "Search by barcode" button
			And I input "9009099" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click "Search by barcode" button
			And I input "9009099" text in the field named "Barcode"
			And I move to the next attribute
		* Select sln
			And in the table "ItemList" I click "Search by barcode" button
			And I input "67789997777801" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I go to line in "List" table
				| 'Serial number'     |
				| '9090098908'        |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
	* Check filling
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Courier" became equal to "Foxred"
		Then the form attribute named "TransactionType" became equal to "Courier delivery"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Item'                           | 'Item key'   | 'Serial lot numbers'   | 'Unit'   | 'Quantity'   | 'Store'      | 'Sales order'                                  |
			| '1'   | 'Dress'                          | 'XS/Blue'    | ''                     | 'pcs'    | '2,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
			| '2'   | 'Boots'                          | '37/18SD'    | ''                     | 'pcs'    | '2,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
			| '3'   | 'Product 7 with SLN (new row)'   | 'PZU'        | '9009099'              | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
			| '4'   | 'Product 7 with SLN (new row)'   | 'PZU'        | '9009099'              | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
			| '5'   | 'Product 1 with SLN'             | 'ODS'        | '9090098908'           | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
		And I click "Post" button
		And I delete "$$NumberRSC01$$" variable
		And I delete "$$RSC01$$" variable
		And I delete "$$DateRSC01$$" variable
		And I save the value of "Number" field as "$$NumberRSC01$$"
		And I save the window as "$$RSC01$$"
		And I save the value of the field named "Date" as "$$DateRSC01$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'             |
			| '$$NumberRSC01$$'    |
		And I close all client application windows


Scenario: _0155268 create Retail GR based on Retail SC
	And I close all client application windows
	* Select Retail SC
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"									
		And I go to line in "List" table
			| 'Number'             |
			| '$$NumberRSC01$$'    |
	* Create retail GR
		And I click the button named "FormDocumentRetailGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Courier" became equal to "Foxred"
		Then the form attribute named "TransactionType" became equal to "Courier delivery"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Item'                           | 'Item key'   | 'Serial lot numbers'   | 'Unit'   | 'Quantity'   | 'Store'      | 'Sales order'                                  |
			| '1'   | 'Product 7 with SLN (new row)'   | 'PZU'        | '9009099'              | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
			| '2'   | 'Product 7 with SLN (new row)'   | 'PZU'        | '9009099'              | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
			| '3'   | 'Product 1 with SLN'             | 'ODS'        | '9090098908'           | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
			| '4'   | 'Dress'                          | 'XS/Blue'    | ''                     | 'pcs'    | '2,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
			| '5'   | 'Boots'                          | '37/18SD'    | ''                     | 'pcs'    | '2,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
	* Change quantity and check shipment confirmation table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Show hidden tables" button
		And I move to "ShipmentConfirmations (5)" tab
		And "ShipmentConfirmations" table became equal
			| 'Quantity' | 'Quantity in shipment confirmation' |
			| '1,000'    | '1,000'                             |
			| '1,000'    | '1,000'                             |
			| '1,000'    | '1,000'                             |
			| '1,000'    | '2,000'                             |
			| '2,000'    | '2,000'                             |						
		And I close all client application windows
		
Scenario: _0155269 create Retail sales receipt based on Retail SC
	And I close all client application windows
	* Select Retail SC
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"									
		And I go to line in "List" table
			| 'Number'             |
			| '$$NumberRSC01$$'    |
	* Create retail sales receipt
		And I click "Retail sales receipt" button
		And I click "Ok" button
	* Check filling
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Price type'        | 'Item'                         | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'                               |
			| 'Basic Price Types' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009099'            | 'pcs'  | ''           | '1,000'    | ''       | '18%' | ''              | ''           | ''             | 'Store 01' | ''                                          |
			| 'Basic Price Types' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009099'            | 'pcs'  | ''           | '1,000'    | ''       | '18%' | ''              | ''           | ''             | 'Store 01' | ''                                          |
			| 'Basic Price Types' | 'Product 1 with SLN'           | 'ODS'      | '9090098908'         | 'pcs'  | ''           | '1,000'    | ''       | '18%' | ''              | ''           | ''             | 'Store 01' | ''                                          |
			| 'Basic Price Types' | 'Dress'                        | 'XS/Blue'  | ''                   | 'pcs'  | '150,71'     | '2,000'    | '520,00' | '18%' | '52,00'         | '837,29'     | '988,00'       | 'Store 01' | 'Sales order 315 dated 09.01.2023 13:02:11' |
			| 'Basic Price Types' | 'Boots'                        | '37/18SD'  | ''                   | 'pcs'  | '202,88'     | '2,000'    | '700,00' | '18%' | '70,00'         | '1 127,12'   | '1 330,00'     | 'Store 01' | 'Sales order 315 dated 09.01.2023 13:02:11' |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "1 964,41"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "353,59"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "2 318,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows
		

Scenario: _0155270 create Retail GR	(link)			
	And I close all client application windows
	* Create retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"		
		And I click the button named "FormCreate"
	* Filling main details
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Retail customer" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I select "Courier delivery" exact value from "Transaction type" drop-down list
		And I click Select button of "Courier" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Foxred'         |
		And I select current line in "List" table
	* Filling retail goods receipt
		* Add Dress
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283705" text in the field named "Barcode"
			And I move to the next attribute
		* Add Boots
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select current line in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Boots'    | '37/18SD'      |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add item with one SLN
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "9009099" text in the field named "Barcode"
			And I move to the next attribute
		* Select sln
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "67789997777801" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I go to line in "List" table
				| 'Serial number'     |
				| '9090098908'        |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button			
	* Link
		And in the table "ItemList" I click "Link unlink basis documents" button
		And I click "Auto link" button
		And I click "Ok" button
	* Check
		And "ItemList" table contains lines
			| 'Item'                           | 'Item key'   | 'Serial lot numbers'   | 'Unit'   | 'Quantity'   | 'Store'      | 'Sales order'                                  |
			| 'Dress'                          | 'XS/Blue'    | ''                     | 'pcs'    | '1,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
			| 'Boots'                          | '37/18SD'    | ''                     | 'pcs'    | '1,000'      | 'Store 01'   | 'Sales order 315 dated 09.01.2023 13:02:11'    |
			| 'Product 7 with SLN (new row)'   | 'PZU'        | '9009099'              | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
			| 'Product 1 with SLN'             | 'ODS'        | '9090098908'           | 'pcs'    | '1,000'      | 'Store 01'   | ''                                             |
		And I click "Post" button
		And I delete "$$NumberRGR01$$" variable
		And I delete "$$RGR01$$" variable
		And I delete "$$DateRGR01$$" variable
		And I save the value of "Number" field as "$$NumberRGR01$$"
		And I save the window as "$$RGR01$$"
		And I save the value of the field named "Date" as "$$DateRGR01$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'             |
			| '$$NumberRGR01$$'    |
		And I close all client application windows
				
				
Scenario: _0155271 create Retail sales receipt based on RSC with GR
	And I close all client application windows
	* Select Retail SC
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"									
		And I go to line in "List" table
			| 'Number'             |
			| '$$NumberRSC01$$'    |
	* Create retail sales receipt
		And I click "Retail sales receipt" button
		And I click "Ok" button
	* Check filling
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| 'Price type'        | 'Item'                         | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'                               |
			| 'Basic Price Types' | 'Product 7 with SLN (new row)' | 'PZU'      | '9009099'            | 'pcs'  | ''           | '1,000'    | ''       | '18%' | ''              | ''           | ''             | 'Store 01' | ''                                          |
			| 'Basic Price Types' | 'Dress'                        | 'XS/Blue'  | ''                   | 'pcs'  | '75,36'      | '1,000'    | '520,00' | '18%' | '26,00'         | '418,64'     | '494,00'       | 'Store 01' | 'Sales order 315 dated 09.01.2023 13:02:11' |
			| 'Basic Price Types' | 'Boots'                        | '37/18SD'  | ''                   | 'pcs'  | '101,44'     | '1,000'    | '700,00' | '18%' | '35,00'         | '563,56'     | '665,00'       | 'Store 01' | 'Sales order 315 dated 09.01.2023 13:02:11' |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "982,20"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "176,80"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 159,00"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "61,00"	
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows


Scenario: _0155272 create RSC - RGR - RSR transaction type (pickup), without retail sales receipt
	And I close all client application windows
	* Create Retail shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"		
		And I click the button named "FormCreate"
		* Filling main details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Retail customer" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Sam Jons'        |
			And I select current line in "List" table
			And I select "Pickup" exact value from "Transaction type" drop-down list
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Filling retail shipment confirmation
			* Add Dress
				And in the table "ItemList" I click "Search by barcode" button
				And I input "2202283705" text in the field named "Barcode"
				And I move to the next attribute
			* Add item with one SLN
				And in the table "ItemList" I click "Search by barcode" button
				And I input "9009099" text in the field named "Barcode"
				And I move to the next attribute
				And in the table "ItemList" I click "Search by barcode" button
				And I input "9009099" text in the field named "Barcode"
				And I move to the next attribute
			* Select sln
				And in the table "ItemList" I click "Search by barcode" button
				And I input "67789997777801" text in the field named "Barcode"
				And I move to the next attribute
				And in the table "SerialLotNumbers" I click "Add" button
				And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
				And I go to line in "List" table
					| 'Serial number'      |
					| '9090098908'         |
				And I select current line in "List" table
				And I activate "Quantity" field in "SerialLotNumbers" table
				And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
				And I finish line editing in "SerialLotNumbers" table
				And I click "Ok" button
		* Check filling
			Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
			Then the form attribute named "TransactionType" became equal to "Pickup"
			Then the form attribute named "Store" became equal to "Store 02"
			And "ItemList" table became equal
				| '#'    | 'Item'                            | 'Item key'    | 'Serial lot numbers'    | 'Unit'    | 'Quantity'    | 'Store'       | 'Sales order'     |
				| '1'    | 'Dress'                           | 'XS/Blue'     | ''                      | 'pcs'     | '1,000'       | 'Store 02'    | ''                |
				| '2'    | 'Product 7 with SLN (new row)'    | 'PZU'         | '9009099'               | 'pcs'     | '1,000'       | 'Store 02'    | ''                |
				| '3'    | 'Product 7 with SLN (new row)'    | 'PZU'         | '9009099'               | 'pcs'     | '1,000'       | 'Store 02'    | ''                |
				| '4'    | 'Product 1 with SLN'              | 'ODS'         | '9090098908'            | 'pcs'     | '1,000'       | 'Store 02'    | ''                |
			And I click "Post" button
			And I delete "$$NumberRSC02$$" variable
			And I delete "$$RSC02$$" variable
			And I delete "$$DateRSC02$$" variable
			And I save the value of "Number" field as "$$NumberRSC02$$"
			And I save the window as "$$RSC02$$"
			And I save the value of the field named "Date" as "$$DateRSC02$$"
			And I click "Post and close" button
		* Check creation
			And "List" table contains lines
				| 'Number'              |
				| '$$NumberRSC02$$'     |
			And I close all client application windows
	* Create RGR
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"		
		And I click the button named "FormCreate"
		* Filling main details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Retail customer" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Sam Jons'        |
			And I select current line in "List" table
			And I select "Pickup" exact value from "Transaction type" drop-down list
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Filling retail GR
			* Add Dress
				And in the table "ItemList" I click the button named "SearchByBarcode"
				And I input "2202283705" text in the field named "Barcode"
				And I move to the next attribute
			* Add item with one SLN
				And in the table "ItemList" I click the button named "SearchByBarcode"
				And I input "9009099" text in the field named "Barcode"
				And I move to the next attribute
			* Select sln
				And in the table "ItemList" I click the button named "SearchByBarcode"
				And I input "67789997777801" text in the field named "Barcode"
				And I move to the next attribute
				And in the table "SerialLotNumbers" I click "Add" button
				And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
				And I go to line in "List" table
					| 'Serial number'      |
					| '9090098908'         |
				And I select current line in "List" table
				And I activate "Quantity" field in "SerialLotNumbers" table
				And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
				And I finish line editing in "SerialLotNumbers" table
				And I click "Ok" button
		* Link
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I click "Auto link" button
			And I click "Ok" button
		* Check
			And I click "Show hidden tables" button
			And I move to "ShipmentConfirmations (3)" tab
			And "ShipmentConfirmations" table became equal
				| 'Key'    | 'Shipment confirmation'    | 'Quantity'    | 'Quantity in shipment confirmation'    | 'Basis key'     |
				| '*'      | '$$RSC02$$'                | '1,000'       | '1,000'                                | '*'             |
				| '*'      | '$$RSC02$$'                | '1,000'       | '1,000'                                | '*'             |
				| '*'      | '$$RSC02$$'                | '1,000'       | '1,000'                                | '*'             |
			And I close current window
			And I click "Post" button
			And I delete "$$NumberRGR02$$" variable
			And I delete "$$RGR02$$" variable
			And I delete "$$DateRGR02$$" variable
			And I save the value of "Number" field as "$$NumberRGR02$$"
			And I save the window as "$$RGR02$$"
			And I save the value of the field named "Date" as "$$DateRGR02$$"
			And I click "Post and close" button
		* Check creation
			And "List" table contains lines
				| 'Number'              |
				| '$$NumberRGR02$$'     |
			And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"					
		And I go to line in "List" table
			| 'Number'             |
			| '$$NumberRSC02$$'    |
		And I click "Retail sales receipt" button
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#'   | 'Price type'          | 'Item'                           | 'Sales person'   | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Source of origins'   | 'Quantity'   | 'Price'   | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Detail'   | 'Sales order'   | 'Revenue type'    |
			| '1'   | 'Basic Price Types'   | 'Product 7 with SLN (new row)'   | ''               | 'PZU'        | ''                     | 'No'                   | '9009099'              | 'pcs'    | ''             | ''                    | '1,000'      | ''        | '18%'   | ''                | ''             | ''               | ''                      | 'Store 02'   | ''         | ''              | ''                |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
	And I close all client application windows
	
				
Scenario: _0155273 select items from RSC in POS
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"	
	* Select retail customer
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Daniel Smith' |
		And I select current line in "List" table
		And I click "OK" button
	* Select RSC with RGR based on RSO
		And I click "Select basis document" button
		And "SalesOrders" table became equal
			| 'Number' | 'Date'                | 'Amount'   | 'Retail customer' | 'Branch' | 'Description' |
			| '317'    | '11.08.2023 15:50:42' | '3 183,00' | 'Daniel Smith'    | ''       | ''            |
			| '318'    | '11.08.2023 15:51:30' | '1 188,00' | 'Daniel Smith'    | ''       | ''            |
		And "RetailShipmentConfirmation" table became equal
			| 'Number' | 'Date'                | 'Retail customer' | 'Courier' | 'Transaction type' | 'Branch' |
			| '317'    | '11.08.2023 16:02:15' | 'Daniel Smith'    | ''        | 'Courier delivery' | ''       |
			| '318'    | '11.08.2023 16:07:56' | 'Daniel Smith'    | ''        | 'Courier delivery' | ''       |
		And I go to line in "RetailShipmentConfirmation" table
			| 'Number' | 'Date'                | 'Retail customer' | 'Courier' | 'Transaction type' | 'Branch' |
			| '317'    | '11.08.2023 16:02:15' | 'Daniel Smith'    | ''        | 'Courier delivery' | ''       |
		And I activate field named "SalesOrdersDate" in "SalesOrders" table
		And I activate field named "RetailShipmentConfirmationDate" in "RetailShipmentConfirmation" table
		And in the table "SalesOrders" I click "Select" button
		Then "Select sales person" window is opened
		And I go to line in "" table
			| 'Column1'       |
			| 'David Romanov' |
		And I click "OK" button		
	* Check
		And "ItemList" table became equal
			| 'Item'                         | 'Sales person'  | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress'                        | 'David Romanov' | 'XS/Blue'  | ''        | '520,00' | '1,000'    | '26,00'  | '494,00' |
			| 'Product 7 with SLN (new row)' | 'David Romanov' | 'PZU'      | '9009099' | '200,00' | '1,000'    | ''       | '200,00' |		
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And "Payments" table became equal
			| 'Payment done' | 'Payment type' | 'Amount' |
			| ' '            | 'Advance'      | '20,00'  |
			| ' '            | 'Cash'         | '674,00' |
		And I click "OK" button
		And I move to the next attribute
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'                         | 'Sales person'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order'                               | 'Revenue type' |
			| '1' | 'Basic Price Types'       | 'Dress'                        | 'David Romanov' | 'XS/Blue'  | ''                   | 'No'                 | ''                   | 'pcs'  | '76,46'      | ''                  | '1,000'    | '520,00' | '18%' | '18,78'         | '424,76'     | '501,22'       | ''                    | 'Store 01' | ''       | 'Sales order 317 dated 11.08.2023 15:50:42' | ''             |
			| '2' | 'en description is empty' | 'Product 7 with SLN (new row)' | 'David Romanov' | 'PZU'      | ''                   | 'No'                 | '9009099'            | 'pcs'  | '29,41'      | ''                  | '1,000'    | '200,00' | '18%' | '7,22'          | '163,37'     | '192,78'       | ''                    | 'Store 01' | ''       | 'Sales order 317 dated 11.08.2023 15:50:42' | ''             |
	And I close all client application windows
	


Scenario: _0155274 select items from RSO in POS		
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"	
	* Select retail customer
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Daniel Smith' |
		And I select current line in "List" table
		And I click "OK" button		
	* Select RSO
		And I click "Select basis document" button
		And I go to line in "SalesOrders" table
			| 'Amount'   | 'Date'                | 'Number' | 'Retail customer' |
			| '1 188,00' | '11.08.2023 15:51:30' | '318'    | 'Daniel Smith'    |
		And in the table "SalesOrders" I click "Select" button
		If "Select sales person" window is opened Then
			And I go to line in "" table
				| 'Column1'       |
				| 'David Romanov' |
			And I click "OK" button		
	* Check 
		And "ItemList" table became equal
			| 'Item'                         | 'Item key' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress'                        | 'XS/Blue'  | '520,00' | '2,000'    | '52,00'  | '988,00' |
			| 'Product 7 with SLN (new row)' | 'PZU'      | '200,00' | '1,000'    | ''       | '200,00' |
		And I go to line in "ItemList" table
			| 'Item'                         | 'Item key' | 'Price'  | 'Quantity' | 'Total'  |
			| 'Product 7 with SLN (new row)' | 'PZU'      | '200,00' | '1,000'    | '200,00' |
		And I activate "Serials" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Serials" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'PZU'   | '9009099'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Cash (/)" button
		And I click "OK" button
	* Check RSO is not displayed again
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Daniel Smith' |
		And I select current line in "List" table
		And I click "OK" button	
		And I click "Select basis document" button
		And "SalesOrders" table does not contain lines
			| 'Number' | 'Date'                | 'Amount'   | 'Retail customer' | 'Branch' | 'Description' |
			| '318'    | '11.08.2023 15:51:30' | '1 188,00' | 'Daniel Smith'    | ''       | ''            |
		And I close all client application windows
		
				
Scenario: _0155275 add items in POS	and link lines to basis document
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"	
	* Select retail customer
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Daniel Smith' |
		And I select current line in "List" table
		And I click "OK" button		
	* Add items
		And I click "Search by barcode (F7)" button
		And I input "978020137962" text in the field named "Barcode"
		And I move to the next attribute
		Then "Select sales person" window is opened
		And I go to line in "" table
			| 'Column1'       |
			| 'David Romanov' |
		And I click "OK" button	
		And I click "Link unlink basis documents" button
		And "ItemListRows" table became equal
			| '#' | 'Row presentation' | 'Unit' | 'Quantity' | 'Store'    |
			| '1' | 'Boots (37/18SD)'  | 'pcs'  | '1,000'    | 'Store 01' |
		And "BasisesTree" table became equal
			| 'Row presentation'                          | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales order 317 dated 11.08.2023 15:50:42' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                           | '3,000'    | 'pcs'  | '700,00' | 'TRY'      |
		And I click "Auto link" button
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Boots' | '37/18SD'  | ''        | '700,00' | '1,000'    | '35,00'  | '665,00' |
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Price type'        | 'Item'  | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order'                               | 'Revenue type' |
			| '1' | 'Basic Price Types' | 'Boots' | '37/18SD'  | ''                   | 'No'                 | ''                   | 'pcs'  | '101,44'     | ''                  | '1,000'    | '700,00' | '18%' | '35,00'         | '563,56'     | '665,00'       | ''                    | 'Store 01' | ''       | 'Sales order 317 dated 11.08.2023 15:50:42' | ''             |
		And I close all client application windows
		
				

					
Scenario: _0155276 check links with different Branches for IM documents (RSO-RSC-RSR-RGR-RRR)
	And I close all client application windows
	* Create RGR (Branch Shop 01)
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I click "Create" button
		* Filling main details
			And I select from the drop-down list named "Company" by "Main Company" string
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I select "Return from customer" exact value from "Transaction type" drop-down list
			And I activate field named "ItemListLineNumber" in "ItemList" table
			And I select from the drop-down list named "Store" by "02" string
			And I select from the drop-down list named "RetailCustomer" by "Daniel Smith" string
			And I select from the drop-down list named "Branch" by "Shop 01" string
		* Filling items
			And in the table "ItemList" I click "Add" button
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "product 5" from "Item" drop-down list by string in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And in the table "SerialLotNumbers" I click "Add" button
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'ODS'   | '90808979899'   |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click "Add" button
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "scarf" from "Item" drop-down list by string in "ItemList" table
			And I finish line editing in "ItemList" table
		* Link to RSC
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I go to line in "ItemListRows" table
				| '#' | 'Quantity' | 'Row presentation'         | 'Store'    | 'Unit' |
				| '1' | '1,000'    | 'Product 5 with SLN (ODS)' | 'Store 02' | 'pcs'  |
			And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
			And I go to line in "BasisesTree" table
				| 'Branch'       | 'Company'      | 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'         | 'Unit' |
				| 'Front office' | 'Main Company' | 'TRY'      | '100,00' | '2,000'    | 'Product 5 with SLN (ODS)' | 'pcs'  |
			And I click the button named "Link"
			And I go to line in "ItemListRows" table
				| '#' | 'Quantity' | 'Row presentation' | 'Store'    | 'Unit' |
				| '2' | '1,000'    | 'Scarf (XS/Red)'   | 'Store 02' | 'pcs'  |
			And I go to line in "BasisesTree" table
				| 'Branch'       | 'Company'      | 'Currency' | 'Price' | 'Quantity' | 'Row presentation' | 'Unit' |
				| 'Front office' | 'Main Company' | 'TRY'      | '70,00' | '2,000'    | 'Scarf (XS/Red)'   | 'pcs'  |
			And I click the button named "Link"
			And I set checkbox "Linked documents"
		* Check
			And "ResultsTree" table became equal
				| 'Row presentation'                                           | 'Company'      | 'Branch'       | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
				| 'Sales order 720 dated 02.04.2024 12:00:00'                  | 'Main Company' | 'Front office' | ''         | ''     | ''       | ''         |
				| 'Retail shipment confirmation 721 dated 09.04.2024 18:34:44' | 'Main Company' | 'Shop 01'      | ''         | ''     | ''       | ''         |
				| 'Retail sales receipt 1 708 dated 09.04.2024 18:35:58'       | 'Main Company' | 'Front office' | ''         | ''     | ''       | ''         |
				| 'Product 5 with SLN (ODS)'                                   | 'Main Company' | 'Front office' | '1,000'    | 'pcs'  | '100,00' | 'TRY'      |
				| 'Scarf (XS/Red)'                                             | 'Main Company' | 'Front office' | '1,000'    | 'pcs'  | '70,00'  | 'TRY'      |
	* Post RGR
		And I click "Ok" button
		And I click "Post" button
		And I delete "$$NumberRGR06$$" variable
		And I delete "$$RGR06$$" variable
		And I delete "$$DateRGR06$$" variable
		And I save the value of "Number" field as "$$NumberRGR06$$"
		And I save the window as "$$RGR06$$"
		And I save the value of the field named "Date" as "$$DateRGR06$$"		
	* Create RRR
		And I click "Sales return" button
		And I click "Ok" button
		* Change branch
			And I move to "Other" tab
			And I select from the drop-down list named "Branch" by "front" string
			And I move to "Item list" tab
			And "ItemList" table became equal
				| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
				| '1' | 'Retail sales receipt 1 708 dated 09.04.2024 18:35:58' | 'Product 5 with SLN' | ''             | 'ODS'      | ''                   | 'No'                 | '15,25'      | '90808979899'        | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 02' | ''             | ''       | '18%' | ''              | ''            | ''                |
				| '2' | 'Retail sales receipt 1 708 dated 09.04.2024 18:35:58' | 'Scarf'              | ''             | 'XS/Red'   | ''                   | 'No'                 | '10,68'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '70,00'  | '59,32'      | '70,00'        | ''                    | 'Store 02' | ''             | ''       | '18%' | ''              | ''            | ''                |
			And in the table "ItemList" I click "Goods receipts" button
			And Delay 2
			And "DocumentsTree" table became equal
				| '#' | 'Presentation'                                         | 'Invoice' | 'QuantityInDocument' | 'Quantity' |
				| ''  | 'Product 5 with SLN (ODS)'                             | '1,000'   | '1,000'              | '1,000'    |
				| '1' | 'Retail goods receipt 1 208 dated 10.04.2024 09:55:45' | ''        | '1,000'              | '1,000'    |
				| ''  | 'Scarf (XS/Red)'                                       | '1,000'   | '1,000'              | '1,000'    |
				| '2' | 'Retail goods receipt 1 208 dated 10.04.2024 09:55:45' | ''        | '1,000'              | '1,000'    |	
		* Unlink and link
			And I close "Linked documents" window
			And I change checkbox "Linked documents"
			And in the table "ResultsTree" I click "Unlink all" button
			And I click "Auto link" button
			And I click "Ok" button
		* Check
			And "ItemList" table became equal
				| '#' | 'Retail sales receipt'                                 | 'Item'               | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
				| '1' | 'Retail sales receipt 1 708 dated 09.04.2024 18:35:58' | 'Product 5 with SLN' | ''             | 'ODS'      | ''                   | 'No'                 | '15,25'      | '90808979899'        | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 02' | ''             | ''       | '18%' | ''              | ''            | ''                |
				| '2' | 'Retail sales receipt 1 708 dated 09.04.2024 18:35:58' | 'Scarf'              | ''             | 'XS/Red'   | ''                   | 'No'                 | '10,68'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '70,00'  | '59,32'      | '70,00'        | ''                    | 'Store 02' | ''             | ''       | '18%' | ''              | ''            | ''                |
			And in the table "ItemList" I click "Goods receipts" button
			And Delay 2
			And "DocumentsTree" table became equal
				| '#' | 'Presentation'                                         | 'Invoice' | 'QuantityInDocument' | 'Quantity' |
				| ''  | 'Product 5 with SLN (ODS)'                             | '1,000'   | '1,000'              | '1,000'    |
				| '1' | 'Retail goods receipt 1 208 dated 10.04.2024 09:55:45' | ''        | '1,000'              | '1,000'    |
				| ''  | 'Scarf (XS/Red)'                                       | '1,000'   | '1,000'              | '1,000'    |
				| '2' | 'Retail goods receipt 1 208 dated 10.04.2024 09:55:45' | ''        | '1,000'              | '1,000'    |	
			And I click "Post" button
			And I delete "$$NumberRRR06$$" variable
			And I save the value of "Number" field as "$$NumberRRR06$$"
			And I click "Post and close" button	
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"		
			And "ItemList" table contains lines
				| 'Number'          |
				| '$$NumberRRR06$$' |
			And I close all client application windows			