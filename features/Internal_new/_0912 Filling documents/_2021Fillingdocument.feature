#language: en
@tree
@Positive
@FillingDocuments

Feature: check filling in and re-filling in documents forms + currency form connection



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _0154100 preparation ( filling documents)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
	* For the test of completing the purchase documents
		* Preparation: creating a vendor partner term for NDB
			Given I open hyperlink "e1cib/list/Catalog.Agreements"
			And I click the button named "FormCreate"
			And I input "Partner term vendor NDB" text in "ENG" field
			And I change "Type" radio button value to "Vendor"
			And I change "AP/AR posting detail" radio button value to "By documents"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'NDB'         |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' |  'Source'       | 'Type'      |
				| 'TRY'      |  'Forex Seling' | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       | 'Reference'         |
				| 'TRY'      | 'Basic Price Types' | 'Basic Price Types' |
			And I select current line in "List" table
			And I input "01.11.2018" text in "Start using" field
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click "Save and close" button
			And I close all client application windows
		* Preparation: creating a vendor partner term for Avira Vendor
			Given I open hyperlink "e1cib/list/Catalog.Agreements"
			And I click the button named "FormCreate"
			And I input "Partner term vendor Partner Kalipso" text in "ENG" field
			And I change "Type" radio button value to "Vendor"
			And I change "AP/AR posting detail" radio button value to "By documents"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Avira'         |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' |  'Source'       | 'Type'      |
				| 'TRY'      |  'Forex Seling' | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       | 'Reference'         |
				| 'TRY'      | 'Basic Price Types' | 'Basic Price Types' |
			And I select current line in "List" table
			And I input "01.11.2018" text in "Start using" field
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click "Save and close" button
			And I close all client application windows
	And Delay 5
	* For the test of choice Planing transaction basis in bank/cash documents
		* Creating a Cashtransfer order to move money between cash accounts
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberCashTransferOrder01541001$$" |
				And I click the button named "FormCreate"
				And I click Select button of "Company" field
				And I go to line in "List" table
					| Description  |
					| Main Company |
				And I select current line in "List" table
				* Filling Sender and Send amount
					And I click Select button of "Sender" field
					And I go to line in "List" table
						| Description    |
						| Cash desk №1 |
					And I select current line in "List" table
					And I input "400,00" text in "Send amount" field
					And I click Select button of "Send currency" field
					And I go to line in "List" table
						| Code | Description     |
						| USD  | American dollar |
					And I select current line in "List" table
				* Filling Receiver and Receive amount
					And I click Select button of "Receiver" field
					And I go to line in "List" table
						| Description    |
						| Cash desk №2 |
					And I select current line in "List" table
					And I input "400,00" text in "Receive amount" field
					And I click Select button of "Receive currency" field
					And I go to line in "List" table
						| Code | Description     |
						| USD  | American dollar |
					And I activate "Description" field in "List" table
					And I select current line in "List" table
				And I click the button named "FormPost"
				And I delete "$$NumberCashTransferOrder01541001$$" variable
				And I delete "$$CashTransferOrder01541001$$" variable
				And I save the value of "Number" field as "$$NumberCashTransferOrder01541001$$"
				And I save the window as "$$CashTransferOrder01541001$$"
				And I click the button named "FormPostAndClose"
				And Delay 5
				* Check creation
					Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
					And "List" table contains lines
					| Number | Sender        | Receiver     | Company      |
					| $$NumberCashTransferOrder01541001$$      | Cash desk №1 | Cash desk №2 | Main Company |
				And I close all client application windows
			And Delay 5
		* Create Cashtransfer order for currency exchange (cash accounts)
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberCashTransferOrder01541002$$" |
				And I click the button named "FormCreate"
				And I click Select button of "Company" field
				And I go to line in "List" table
					| Description  |
					| Main Company |
				And I select current line in "List" table
				* Filling Sender and Send amount
					And I click Select button of "Sender" field
					And I go to line in "List" table
						| Description    |
						| Cash desk №2 |
					And I select current line in "List" table
					And I input "210,00" text in "Send amount" field
					And I click Select button of "Send currency" field
					And I go to line in "List" table
						| Code | Description     |
						| USD  | American dollar |
					And I select current line in "List" table
				* Filling Receiver and Receive amount
					And I click Select button of "Receiver" field
					And I go to line in "List" table
						| Description    |
						| Cash desk №1 |
					And I select current line in "List" table
					And I input "1200,00" text in "Receive amount" field
					And I click Select button of "Receive currency" field
					And I go to line in "List" table
						| Code | Description  |
						| TRY  | Turkish lira |
					And I activate "Description" field in "List" table
					And I select current line in "List" table
					And I click Select button of "Cash advance holder" field
					And I go to line in "List" table
						| 'Description' |
						| 'Arina Brown' |
					And I select current line in "List" table
				And I click the button named "FormPost"
				And I delete "$$NumberCashTransferOrder01541002$$" variable
				And I delete "$$CashTransferOrder01541002$$" variable
				And I save the value of "Number" field as "$$NumberCashTransferOrder01541002$$"
				And I save the window as "$$CashTransferOrder01541002$$"
				And I click the button named "FormPostAndClose"
				And Delay 5
				* Check creation
					Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
					And "List" table contains lines
					| Number | Sender       | Receiver     | Company      |
					| $$NumberCashTransferOrder01541002$$      | Cash desk №2 | Cash desk №1 | Main Company |
				And I close all client application windows
			And Delay 5
		* Create Cashtransfer order for currency exchange (bank accounts)
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberCashTransferOrder01541003$$" |
				Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
				And I click the button named "FormCreate"
				And I click Select button of "Company" field
				And I go to line in "List" table
					| Description  |
					| Main Company |
				And I select current line in "List" table
				* Filling Sender and Send amount
					And I click Select button of "Sender" field
					And I go to line in "List" table
						| Description    |
						| Bank account, TRY |
					And I select current line in "List" table
					And I input "1150,00" text in "Send amount" field
				* Filling Receiver and Receive amount
					And I click Select button of "Receiver" field
					And I go to line in "List" table
						| Description    |
						| Bank account, EUR |
					And I select current line in "List" table
					And I input "175,00" text in "Receive amount" field
				And I click the button named "FormPost"
				And I delete "$$NumberCashTransferOrder01541003$$" variable
				And I delete "$$CashTransferOrder01541003$$" variable
				And I save the value of "Number" field as "$$NumberCashTransferOrder01541003$$"
				And I save the window as "$$CashTransferOrder01541003$$"
				And I click the button named "FormPostAndClose"
				And Delay 5
				* Check creation
					Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
					And "List" table contains lines
					| Number  | Sender            | Receiver          | Company      |
					| $$NumberCashTransferOrder01541003$$      | Bank account, TRY | Bank account, EUR | Main Company |
				And I close all client application windows
			And Delay 5
		* Create Cash transfer order for cash transfer between bank accounts in one currency
			* Create Cash transfer order for cash transfer between bank accounts in one currency
				Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
				If "List" table does not contain lines Then
					| "Number" |
					| "$$NumberCashTransferOrder01541004$$" |
					Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
					And I click the button named "FormCreate"
					And I click Select button of "Company" field
					And I go to line in "List" table
						| Description  |
						| Main Company |
					And I select current line in "List" table
					* Filling Sender and Send amount
						And I click Select button of "Sender" field
						And I go to line in "List" table
							| Description    |
							| Bank account 2, EUR |
						And I select current line in "List" table
						And I input "1150,00" text in "Send amount" field
					* Filling Receiver and Receive amount
						And I click Select button of "Receiver" field
						And I go to line in "List" table
							| Description    |
							| Bank account, EUR |
						And I select current line in "List" table
						And I input "1150,00" text in "Receive amount" field
					And I click the button named "FormPost"
					And I delete "$$NumberCashTransferOrder01541004$$" variable
					And I delete "$$CashTransferOrder01541004$$" variable
					And I save the value of "Number" field as "$$NumberCashTransferOrder01541004$$"
					And I save the window as "$$CashTransferOrder01541004$$"
					And I click the button named "FormPostAndClose"
					And Delay 5
					* Check creation
						Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
						And "List" table contains lines
						| Number  | Sender              | Receiver          | Company      |
						| $$NumberCashTransferOrder01541004$$      | Bank account 2, EUR | Bank account, EUR | Main Company |
					And I close all client application windows
	* Check or create SalesInvoice024025
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024025$$" |
			When create SalesInvoice024025
		When Create catalog Users objects
	* Check or create SalesInvoice024016
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024016$$" |
			When create SalesInvoice024016 (Shipment confirmation does not used)
	* Check or create $$PurchaseInvoice29604$$
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice29604$$" |
			When create a purchase invoice for the purchase of sets and dimensional grids at the tore 02
	* Check or create $$PurchaseInvoice30004$$
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice30004$$" |
			When create purchase invoice without order (Vendor Ferron, USD)


Scenario: _0154101 check filling in and re-filling Sales order
	And I close all client application windows
	* Open the Sales order creation form
		Given I open hyper link "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company NDB"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Partner term NDB"
	* Check filling in Company from Partner term
		* Change company in Sales order
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			And I click Open button of "Partner term" field
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click "Save and close" button
		* Re-selection of the agreement and check of the store refill (items not added)
			And I click Select button of "Partner term" field
			And I select current line in "List" table
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selection partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price re-filling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Procurement method' | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | 'Stock'              | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | 'Stock'              | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Procurement method' | 'Tax amount'  | 'SalesTax'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | 'Stock'              | '*'           | '*'         | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | 'Stock'              | '*'           | '*'         | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			If "ItemList" table does not contain "VAT" column Then
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
		* Tax calculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | ''       | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | ''       | 'Shirt'    | '18%' | '38/Black'  | 'Stock'              | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And in the table "ItemList" I click "SearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 4
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | 'Stock'              | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | 'Stock'              | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | 'Stock'              | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
			And Delay 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And in the table "ItemList" I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title' |
				| 'Dress' |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'  | 'Title'   | 'Unit' |
				| '520,00' | 'XS/Blue' | 'pcs'  |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | 'XS/Blue'   | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "287,53"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "1 482,47"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check filling in the Price includes tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price includes tax is not ticked 
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check that the Price includes tax checkbox value has been filled out from the partner term
			Then the form attribute named "PriceIncludeTax" became equal to "No"
		* Check tax recalculation 
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '112,71'     | '1%'       | '2,000' | 'pcs'  | '593,22'     | '705,93'       | 'Store 02' |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '88,56'      | '1%'       | '1,000' | 'pcs'  | '466,10'     | '554,66'       | 'Store 02' |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '83,73'      | '1%'       | '1,000' | 'pcs'  | '440,68'     | '524,41'       | 'Store 02' |
		* Change of partner term to what was earlier
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		* Tax recalculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And I click "Save" button
			And I move to the tab named "GroupCurrency"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '303,08' | '1'            |
		* Check recalculate Total amount and Net amount when change Tax rate
			* Price includes tax
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '5,45'       | '1%'       | '1,000' | 'pcs'  | '544,55'     | '550,00'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 566,37"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "203,63"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price doesn't include tax
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
				And I move to "Other" tab
				And I remove checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '7,00'       | '1%'       | '2,000' | 'pcs'  | '700,00'     | '707,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1%'       | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1%'       | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
				









Scenario: _0154102 check filling in and re-filling Sales invoice
	And I close all client application windows
	* Open the Sales invoice creation form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company NDB"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Partner term NDB"
	* Check filling in Company from Partner term
		* Change company in Sales order
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			And I click Open button of "Partner term" field
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click "Save and close" button
		* Re-selection of the agreement and check of the store refill (items not added)
			And I click Select button of "Partner term" field
			And I select current line in "List" table
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selecting a partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price re-filling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'SalesTax'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '*'         | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | '*'           | '*'         | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			If "ItemList" table does not contain "VAT" column Then
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
		* Tax calculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | ''       | 'Trousers' | '18%' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | ''       | 'Shirt'    | '18%' | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And in the table "ItemList" I click "SearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 2
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
			And Delay 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And in the table "ItemList" I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title' |
				| 'Dress' |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'  | 'Title'   | 'Unit' |
				| '520,00' | 'XS/Blue' | 'pcs'  |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | 'XS/Blue'   | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
		Then the form attribute named "ItemListTotalNetAmount" became equal to "1 482,47"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "287,53"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check filling in the Price includes tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price includes tax is not ticked 
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check that the Price includes tax checkbox value has been filled out from the partner term
			Then the form attribute named "PriceIncludeTax" became equal to "No"
		* Check tax recalculation 
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '112,71'     | '1%'       | '2,000' | 'pcs'  | '593,22'     | '705,93'       | 'Store 02' |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '88,56'      | '1%'       | '1,000' | 'pcs'  | '466,10'     | '554,66'       | 'Store 02' |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '83,73'      | '1%'       | '1,000' | 'pcs'  | '440,68'     | '524,41'       | 'Store 02' |
		* Change of partner term to what was earlier
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		* Tax recalculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And I move to the tab named "GroupCurrency"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'         | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'         | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'         | '5,8400'            | '303,08' | '1'            |
		* Check recalculate Total amount and Net amount when change Tax rate
			* Price includes tax
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '5,45'       | '1%'       | '1,000' | 'pcs'  | '544,55'     | '550,00'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 566,37"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "203,63"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price doesn't include tax
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
				And I move to "Other" tab
				And I remove checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '7,00'       | '1%'       | '2,000' | 'pcs'  | '700,00'     | '707,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1%'       | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1%'       | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
				And I close all client application windows


Scenario: _0154103 check Sales order when changing date
	And I close all client application windows
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in partner and Legal name
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I select current line in "List" table
	* Filling in an Partner term
		And I click Select button of "Partner term" field
		Then the number of "List" table lines is "меньше или равно" 4
		And I go to line in "List" table
			| 'Description'                   |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
	* Add items and check prices on the current date
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/Brown'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Dress' | '18%' | 'M/Brown'  | '81,22'      | '1%'       | '1,000' | 'pcs'  | '418,78'     | '500,00'       | 'Store 01' |
	* Change of date and check of price and tax recalculation
		And I move to "Other" tab
		And I expand "More" group
		And I input "01.11.2018 10:00:00" text in "Date" field
		And I move to "Item list" tab
		Then "Update item list info" window is opened
		Then the form attribute named "Prices" became equal to "Yes"
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Price'    | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | '1 000,00' | 'M/Brown'  | '1,000' | ''           | 'pcs'  | '1 000,00'     | '1 000,00'     | 'Store 01' |
	* Check the list of partner terms
		And I click Select button of "Partner term" field
		And "List" table contains lines
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, $'           |
			| 'Basic Partner terms, without VAT' |
			| 'Personal Partner terms, $'        |
			| 'Sale autum, TRY'               |
		And I close "Partner terms" window
	* Check the recount of the currency table when the date is changed
		And I move to the tab named "GroupCurrency"
		And "ObjectCurrencies" table became equal
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,0000'            | '200,00' | '1'            |

Scenario: _0154104 check Sales invoice when changing date
	* Open the Sales invoice creation form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in partner and Legal name
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I select current line in "List" table
	* Filling in an Partner term
		And I click Select button of "Partner term" field
		Then the number of "List" table lines is "меньше или равно" 4
		And I go to line in "List" table
			| 'Description'                   |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
	* Add items and check prices on the current date
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/Brown'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Dress' | '18%' | 'M/Brown'  | '81,22'      | '1%'       | '1,000' | 'pcs'  | '418,78'     | '500,00'       | 'Store 01' |
	* Change of date and check of price and tax recalculation
		And I move to "Other" tab
		And I expand "More" group
		And I input "01.11.2018 10:00:00" text in "Date" field
		And I move to "Item list" tab
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Price'    | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | '1 000,00' | 'M/Brown'  | '1,000' | ''           | 'pcs'  | '1 000,00'     | '1 000,00'     | 'Store 01' |
	* Check the list of partner terms
		And I click Select button of "Partner term" field
		And "List" table contains lines
		| 'Description'                   |
		| 'Basic Partner terms, TRY'         |
		| 'Basic Partner terms, $'           |
		| 'Basic Partner terms, without VAT' |
		| 'Personal Partner terms, $'        |
		| 'Sale autum, TRY'               |
		And I close "Partner terms" window
	* Check the recount of the currency table when the date is changed
		And I move to the tab named "GroupCurrency"
		And "ObjectCurrencies" table became equal
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,0000'            | '200,00' | '1'            |

Scenario: _0154105 check filling in and re-filling Purchase order
	* Open the Purchase order creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company NDB"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Partner term vendor NDB"
	* Check filling in Company from Partner term
		* Change company in the Purchase order
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			And I click Open button of "Partner term" field
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click "Save and close" button
		* Re-selection of the agreement and check of the store refill (items not added)
			And I click Select button of "Partner term" field
			And I select current line in "List" table
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I click "List" button					
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selecting a partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'            |
				| Partner Kalipso Vendor |
			And I select current line in "List" table
			And I click Open button of "Partner term" field
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And I click "Save and close" button
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And Delay 2
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     |
				| 'Trousers' | '*'      | '38/Yellow' | '1,000' |
			And Delay 2
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price re-filling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | '*'           | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			If "ItemList" table does not contain "VAT" column Then
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| Partner Kalipso Vendor |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I change checkbox "Do you want to replace filled stores with store Store 02?"
			And I click "OK" button
		* Tax calculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And I click "ItemListSearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 2
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title' |
				| 'Dress' |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'  | 'Title'   | 'Unit' |
				| '440,68' | 'XS/Blue' | 'pcs'  |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
		Then the form attribute named "ItemListTotalNetAmount" became equal to "1 271,19"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "228,81"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 500,00"
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check filling in the Price includes tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price includes tax is ticked
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| Partner Kalipso Vendor |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check that the Price includes tax checkbox value has been filled out from the partner term
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		* Check tax recalculation 
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 02' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 02' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 02' |
		* Change of partner term to what was earlier
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			Then the form attribute named "PriceIncludeTax" became equal to "No"
		* Tax recalculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling in currency tab
			And I move to the tab named "GroupCurrency"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'  | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '357,64'  | '1'            |
		* Check recalculate Total amount and Net amount when change Tax rate
			* Price includes tax
				And I move to "Other" tab
				And I set checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | ''           | '1,000' | 'pcs'  | '550,00'     | '550,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 583,90"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "186,10"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price doesn't include tax
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
				And I move to "Other" tab
				And I remove checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | ''           | '2,000' | 'pcs'  | '700,00'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | '99,00'      | '1,000' | 'pcs'  | '550,00'     | '649,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '93,60'      | '1,000' | 'pcs'  | '520,00'     | '613,60'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"




Scenario: _0154106 check filling in and re-filling Purchase invoice
	And I close all client application windows
	* Open the Purchase invoice creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company NDB"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Partner term vendor NDB"
	* Check filling in Company from Partner term
		* Change company in the Purchase invoice
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			And I click Open button of "Partner term" field
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click "Save and close" button
		* Re-selection of the agreement and check of the store refill (items not added)
			And I click Select button of "Partner term" field
			And I select current line in "List" table
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selecting a partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'            |
				| Partner Kalipso Vendor |
			And I select current line in "List" table
			And I click Open button of "Partner term" field
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And I click "Save and close" button
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check re-filling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price re-filling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
				| '350,00' | 'Shirt'    | '*'    | '38/Black'  | '*'           | '2,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			If "ItemList" table does not contain "VAT" column Then
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| Partner Kalipso Vendor |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I change checkbox "Do you want to replace filled stores with store Store 02?"
			And I click "OK" button
		* Tax calculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And I click "SearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 2
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title' |
				| 'Dress' |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'  | 'Title'   | 'Unit' |
				| '440,68' | 'XS/Blue' | 'pcs'  |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | '51,71'      | 'pcs'  | '287,27'     | '338,98'       | 'Store 03' |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'     | 'Item key' |
			| 'Trousers' | '38/Yellow' |
		Then the form attribute named "ItemListTotalNetAmount" became equal to "1 271,19"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "228,81"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 500,00"
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 03' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 03' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 03' |
	* Check filling in the Price includes tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price includes tax is ticked
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| Partner Kalipso Vendor |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check that the Price includes tax checkbox value has been filled out from the partner term
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		* Check tax recalculation 
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | '90,49'      | 'pcs'  | '502,73'     | '593,22'       | 'Store 02' |
				| '466,10' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | '71,10'      | 'pcs'  | '395,00'     | '466,10'       | 'Store 02' |
				| '440,68' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | '67,22'      | 'pcs'  | '373,46'     | '440,68'       | 'Store 02' |
		* Change of partner term to what was earlier
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			Then the form attribute named "PriceIncludeTax" became equal to "No"
		* Tax recalculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling in currency tab
			And I move to the tab named "GroupCurrency"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'  | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '2 088,6' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '357,64'  | '1'            |
		* Check tax recalculation when choosing a tax rate manually
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I activate "VAT" field in "ItemList" table
			And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
			And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
		* Check recalculate Total amount and Net amount when change Tax rate
			* Price includes tax
				And I move to "Other" tab
				And I set checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | ''           | '1,000' | 'pcs'  | '550,00'     | '550,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 583,90"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "186,10"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price doesn't include tax
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  |
					| 'Dress' | 'L/Green'  | '550,00' |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
				And I move to "Other" tab
				And I remove checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | ''           | '2,000' | 'pcs'  | '700,00'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | '99,00'      | '1,000' | 'pcs'  | '550,00'     | '649,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '93,60'      | '1,000' | 'pcs'  | '520,00'     | '613,60'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"

Scenario: _0154107 check filling in and re-filling Cash receipt (transaction type Payment from customer)
	And I close all client application windows
	* Open the Cash receipt creation form
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Check the default transaction type 'Payment from customer'
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
	* Check filling in company
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Check filling in currency before select cash account
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
	* Check filling in cash account (multicurrency)
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №1 |
		And I select current line in "List" table
	* Re-selection of cash registers with a fixed currency and verification of overfilling of the Currency field
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №4 |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "TRY"
	* Check currency re-selection and clearing the "Cash / Bank accounts" field if the currency is fixed at the cash account
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		Then the form attribute named "CashAccount" became equal to ""
	* Select a multi-currency cash account and checking that the Currency field will not be cleared
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description  |
			| Cash desk №1 |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "USD"
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payer'|
			| 'NDB'       | 'Company NDB'  |
		And in the table "PaymentList" I click "Delete" button
	* Check filling in partner term when adding a partner if the partner has only one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Nicoletta'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                              | 'Payer'             |
			| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
		And in the table "PaymentList" I click "Delete" button
	* Check the display to select only available partner terms
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Kalipso   |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description       |
			| Company Kalipso |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And "List" table contains lines
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Personal Partner terms, $'   |      
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
	* Filter check on the basis documents depending on Partner term
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And "List" table does not contain lines
			| 'Document'          | 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '$$SalesInvoice024016$$' | '554,66'          | 'Main Company' | 'Company Kalipso' | 'Kalipso' |
		And I go to line in "List" table
			| 'Document'          | 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '$$SalesInvoice024025$$' | '11 000,00'        | 'Main Company' | 'Company Kalipso' | 'Kalipso' |
		And I click "Select" button
	* Check clearing basis document when clearing partner term
		And I select current line in "PaymentList" table
		And I click Clear button of "Partner term" field
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner' | 'Partner term' | 'Amount' | 'Payer'           | 'Basis document' |
			| 'Kalipso' | ''             | '11 000,00'       | 'Company Kalipso' | ''               |
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Nicoletta   |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description       |
			| Company Nicoletta |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Posting by Standard Partner term Customer' |
		And I select current line in "List" table
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the currency form connection
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Kalipso' | 'Company Kalipso' |
		And I select current line in "PaymentList" table
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
			And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "CurrenciesPaymentList" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '17,12'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And "CurrenciesPaymentList" table contains lines
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20*'    | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '100'    | '1'            |
		| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '200'    | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '200'    | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '*'                 | '40*'     | '1'            |
		And Delay 5
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Kalipso' | 'Company Kalipso' |
		And I select current line in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		If user messages contain "Specify a base document for line 1." string Then

Scenario: _0154108 total amount calculation in Cash receipt
	* Open form Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "460,00"
		
Scenario: _0154109 check filling in and re-filling Bank receipt (transaction type Payment from customer)
	* Open form Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
	* Check the default transaction type 'Payment from customer'
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
	* Check filling in company
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Check filling in currencies before select an account
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
	* Bank account selection and check of Currency field refilling
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "TRY"
	* Check currency re-selection and clearing the "Account" field
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		Then the form attribute named "Account" became equal to ""
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payer'|
			| 'NDB'       | 'Company NDB'  |
		And in the table "PaymentList" I click "Delete" button
	* Check filling in partner term when adding a partner if the partner has only one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Nicoletta'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                              | 'Payer'             |
			| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
		And in the table "PaymentList" I click "Delete" button
	* Check the display to select only available partner terms
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Kalipso   |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description       |
			| Company Kalipso |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And "List" table contains lines
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Personal Partner terms, $'   |      
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
	* Filter check on the basis documents depending on Partner term
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And "List" table does not contain lines
			| 'Document'          | 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '$$SalesInvoice024016$$' | '554,66'          | 'Main Company' | 'Company Kalipso' | 'Kalipso' |
		And I go to line in "List" table
			| 'Document'          | 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '$$SalesInvoice024025$$' | '11 000,00'        | 'Main Company' | 'Company Kalipso' | 'Kalipso' |
		And I click "Select" button
	* Check clearing basis document when clearing partner term
		And I select current line in "PaymentList" table
		And I click Clear button of "Partner term" field
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term' | 'Amount' | 'Payer'             | 'Basis document' |
			| 'Kalipso' | ''          | '11 000,00'       | 'Company Kalipso' | ''               |
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Nicoletta   |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description       |
			| Company Nicoletta |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Posting by Standard Partner term Customer' |
		And I select current line in "List" table
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the currency form connection
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Kalipso' | 'Company Kalipso' |
		And I select current line in "PaymentList" table
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "CurrenciesPaymentList" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '17,12'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And I go to line in "PaymentList" table
		| 'Amount' | 'Partner'   | 'Payer'             |
		| '200,00' | 'Nicoletta' | 'Company Nicoletta' |
		And "CurrenciesPaymentList" table contains lines
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '40,00'  | '1'            |
		And I go to line in "PaymentList" table
		| 'Amount' | 'Partner'   | 'Payer'             |
		| '100,00' | 'Kalipso' | 'Company Kalipso' |
		And "CurrenciesPaymentList" table contains lines
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20,00'  | '1'            |
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Kalipso' | 'Company Kalipso' |
		And I select current line in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		If user messages contain "Specify a base document for line 1." string Then

Scenario: _0154110 total amount calculation in Bank receipt
	* Open form Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "460,00"



Scenario: _0154111 check filling in and re-filling Cash payment (transaction type Payment to the vendor)
	* Open form Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Check the default transaction type 'Payment from customer'
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
	* Check filling in company
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Check filling in currency before select cash account
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
	* Check filling in cash account (multicurrency)
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №1 |
		And I select current line in "List" table
	* Re-selection of cash registers with a fixed currency and verification of overfilling of the Currency field
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №4 |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "TRY"
	* Check currency re-selection and clearing the "Cash / Bank accounts" field if the currency is fixed at the cash account
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		Then the form attribute named "CashAccount" became equal to ""
	* Select a multi-currency cash account and checking that the Currency field will not be cleared
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description  |
			| Cash desk №1 |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "USD"
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'|
			| 'NDB'       | 'Company NDB'  |
		And in the table "PaymentList" I click "Delete" button
	* Check filling in partner term when adding a partner if the partner has only one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Veritas'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                               | 'Payee'             |
			| 'Veritas'   | 'Posting by Standard Partner term (Veritas)' | 'Company Veritas' |
		And in the table "PaymentList" I click "Delete" button
	* Check the display to select only available partner terms
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And "List" table contains lines
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
	* Filter check on the basis documents depending on Partner term
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And "List" table does not contain lines
			| 'Document' 	| 'Amount'| 'Company'      | 'Legal name'        | 'Partner'   |
			| '$$PurchaseInvoice30004$$'	| '4 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		And I go to line in "List" table
		| 'Document' 	| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
		| '$$PurchaseInvoice29604$$'	| '13 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		And I click "Select" button
	* Check clearing basis document when clearing partner term
		And I select current line in "PaymentList" table
		And I click Clear button of "Partner term" field
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term' | 'Amount' | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''          | '13 000,00'       | 'Company Ferron BP' | ''               |
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Veritas   |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Company Veritas ' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Posting by Standard Partner term (Veritas)' |
		And I select current line in "List" table
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the currency form connection
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		And I select current line in "PaymentList" table
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
			And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Veritas'   | 'Company Veritas '  |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'             | '17,12'  | '1'            |
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20,00'  | '1'            |
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '40*'     | '1'            |
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		And I select current line in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click the button named "FormPost"
		If user messages contain "Specify a base document for line 1." string Then

Scenario: _0154112 total amount calculation in Cash payment
	* Open form Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "460,00"


Scenario: _0154113 check filling in and re-filling Bank payment (transaction type Payment to the vendor)
	* Open form Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
	* Check the default transaction type 'Payment from customer'
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
	* Check filling in company
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Check filling in currency before selecting a bank account
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
	* Bank account selection and check of Currency field refilling
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "TRY"
	* Check currency re-selection and clearing the "Account" field in case of a fixed currency
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| USD  |
		And I select current line in "List" table
		Then the form attribute named "Account" became equal to ""
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
	* Check the choice of a partner in the tabular section and filling in the legal name if one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'|
			| 'NDB'       | 'Company NDB'  |
		And in the table "PaymentList" I click "Delete" button
	* Check filling in partner term when adding a partner if the partner has only one
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Veritas'         |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                               | 'Payee'             |
			| 'Veritas'   | 'Posting by Standard Partner term (Veritas)' | 'Company Veritas' |
		And in the table "PaymentList" I click "Delete" button
	* Check the display to select only available partner terms
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And "List" table contains lines
			| 'Description'                   |
			| 'Basic Partner terms, TRY'         |
			| 'Basic Partner terms, without VAT' |
			| 'Vendor Ferron, TRY'            |
			| 'Vendor Ferron, USD'            |
			| 'Vendor Ferron, EUR'            |
			| 'Ferron, USD'                   |
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
	* Filter check on the basis documents depending on Partner term
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And "List" table does not contain lines
			| 'Document' 	| 'Amount'| 'Company'      | 'Legal name'        | 'Partner'   |
			| '$$PurchaseInvoice30004$$'	| '4 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		And I go to line in "List" table
		| 'Document' 	| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
		| '$$PurchaseInvoice29604$$'	| '13 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		And I click "Select" button
	* Check clearing basis document when clearing partner term
		And I select current line in "PaymentList" table
		And I click Clear button of "Partner term" field
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term' | 'Amount' | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''          | '13 000,00'       | 'Company Ferron BP' | ''               |
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the unavailability of the choice of the base document when choosing Partner term with the Ap/ar  by Standard Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Veritas   |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Company Veritas ' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Posting by Standard Partner term (Veritas)' |
		And I select current line in "List" table
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the currency form connection
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		And I select current line in "PaymentList" table
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
			And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Veritas'   | 'Company Veritas '  |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'             | '17,12'  | '1'            |
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,84*'            | '34,25'  | '1'            |
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '20,00'  | '1'            |
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5*'                | '40*'     | '1'            |
	* Check that it is impossible to post the document without a completed basis document when choosing a partner term with Ap-Ar By documents
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Ferron BP' | 'Company Ferron BP' |
		And I select current line in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click the button named "FormPost"
		If user messages contain "Specify a base document for line 1." string Then

Scenario: _0154114 total amount calculation in Bank payment
	* Open form Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "460,00"

Scenario: _01541140 total amount calculation in Incoming payment order
	* Open form Bank payment
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I click the button named "FormCreate"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "460,00"

Scenario: _01541141 total amount calculation in Outgoing payment order
	* Open form Bank payment
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I click the button named "FormCreate"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "460,00"

Scenario: _0154115 check filling in and re-filling Cash transfer order
	* Open form Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check filling in currency when selecting a bank/cash account with fixed currency
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		And I select current line in "List" table
		Then the form attribute named "ReceiveCurrency" became equal to "USD"
		Then the form attribute named "SendCurrency" became equal to "TRY"
	* Check filling in currency when re-select "Sender" and "Receiver"
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'EUR'      | 'Bank account, EUR' |
		And I select current line in "List" table
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		Then the form attribute named "ReceiveCurrency" became equal to "TRY"
		Then the form attribute named "SendCurrency" became equal to "EUR"
	* Check filling in ammount in Receive amount from Send amount in the case of the same currencies
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I input "100,00" text in "Send amount" field
		And I move to the next attribute
		And the editing text of form attribute named "ReceiveAmount" became equal to "100,00"
		And the editing text of form attribute named "SendAmount" became equal to "100,00"
	* Check filling in Send date and Receive date
		And I input "01.01.2020  0:00:00" text in "Date" field
		And I move to the next attribute
		And I save the value of "Send date" field as "Senddate"
		Then "Senddate" variable is equal to "01.01.2020"
		And I save the value of "Receive date" field as "Receivedate"
		Then "Receivedate" variable is equal to "01.01.2020"
		And I input "01.03.2020  0:00:00" text in "Date" field
		And I move to the next attribute
		And I save the value of "Send date" field as "Senddate"
		Then "Senddate" variable is equal to "01.03.2020"
		And I save the value of "Receive date" field as "Receivedate"
		Then "Receivedate" variable is equal to "01.03.2020"
	* Check the drawing of Cash advance holder field in case of currency exchange through cash accounts
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		Then the form attribute named "CashAdvanceHolder" became equal to ""
		And I click Select button of "Cash advance holder" field
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
	* Check form by currency
			And I input "584,00" text in "Receive amount" field
			And I move to the next attribute
			And "ObjectCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '564,97' | '1'            |
			| 'Reporting currency' | 'Reporting' | 'USD'           | 'USD'      | '1'                 | '100'    | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '584'    | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '100,00' | '1'            |

Scenario: _01541151 check that the amount sent and received in Cash transfer order is the same
	* Check cash transfer between two cash account
		* Open form Cash transfer order
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling data
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №2' |
			And I select current line in "List" table
			And I click Select button of "Send currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I input "100,00" text in "Send amount" field
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №1' |
			And I select current line in "List" table
			And I click Select button of "Receive currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I input "120,00" text in "Receive amount" field
		* Check message when post document
			And I click the button named "FormPost"
			Then I wait that in user messages the "Currency transfer is available only when amounts are equal." substring will appear in 10 seconds
			And I close all client application windows
	* Check cash transfer from cash account to bank account
		* Open form Cash transfer order
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling data
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №2' |
			And I select current line in "List" table
			And I click Select button of "Send currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I input "100,00" text in "Send amount" field
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
			And I input "120,00" text in "Receive amount" field
		* Check message when post document
			And I click the button named "FormPost"
			Then I wait that in user messages the "Currency transfer is available only when amounts are equal." substring will appear in 10 seconds
			And I close all client application windows
	* Check cash transfer from bank account to cash account
		* Open form Cash transfer order
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling data
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №2' |
			And I select current line in "List" table
			And I click Select button of "Receive currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I input "100,00" text in "Send amount" field
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
			And I input "120,00" text in "Receive amount" field
		* Check message when post document
			And I click the button named "FormPost"
			Then I wait that in user messages the "Currency transfer is available only when amounts are equal." substring will appear in 10 seconds
			And I close all client application windows
	* Check cash transfer between two bank account
		* Open form Cash transfer order
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling data
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account 2, EUR' |
			And I select current line in "List" table
			And I input "100,00" text in "Send amount" field
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, EUR' |
			And I select current line in "List" table
			And I input "120,00" text in "Receive amount" field
		* Check message when post document
			And I click the button named "FormPost"
			Then I wait that in user messages the "Currency transfer is available only when amounts are equal." substring will appear in 10 seconds
			And I close all client application windows



Scenario: _0154116 check filling in and re-filling Cash expence
	* Open form Cash expence
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filter check by Account depending on the company
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And "List" table does not contain lines
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
		And I close current window
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And "List" table contains lines
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
			| 'Cash desk №3'      | ''         |
			| 'Bank account, TRY' | 'TRY'      |
			| 'Bank account, USD' | 'USD'      |
			| 'Bank account, EUR' | 'EUR'      |
			| 'Cash desk №4'      | 'TRY'      |
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the Net amount and VAT calculation when filling in the Total amount
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'              |
			| 'Telephone communications' |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "220,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Telephone communications' | 'TRY'      | '18%' | '33,56'      | '220,00'       |
	* Check the recalculation of Total amount when Tax changes
		And I move to "Tax list" tab
		And I activate "Manual amount" field in "TaxTree" table
		And I go to line in "TaxTree" table
			| 'Business unit'     |
			| 'Accountants office' |
		And I select current line in "TaxTree" table
		And I input "33,55" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I move to "Payment list" tab
		And "PaymentList" table contains lines
			| 'Net amount' | 'Expense type'               | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Telephone communications'   | 'TRY'      | '18%' | '33,55'      | '219,99'       |
	* Check the Net amount recalculation when Total amount changes and with changes in taxes
		And I input "220,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit'      | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,45'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,00'       |
	* Check the Total amount recalculation when Net amount changes and with changes in taxes
		And I input "187,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Expense type'                     | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Telephone communications'         | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Check the currency form connection
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '37,77'  | '1'            |
	* Add one more line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Front office'    |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Software'    |
		And I select current line in "List" table
		And I activate "VAT" field in "PaymentList" table
		And I select "18%" exact value from "VAT" drop-down list in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I expand a line in "TaxTree" table
			| 'Amount' | 'Currency' | 'Manual amount' | 'Tax' |
			| '69,66'  | 'TRY'      | '69,55'         | 'VAT' |
		And I finish line editing in "PaymentList" table
	* Manual tax correction by line
		And I move to "Tax list" tab
		And I go to line in "TaxTree" table
			| 'Amount' | 'Business unit' | 'Currency' |
			| '36,00'  | 'Front office'  | 'TRY'      |
		And I select current line in "TaxTree" table
		And I input "38,00" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I move to "Payment list" tab
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit'      | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,55'       |
			| '200,00'     | 'Front office'       | 'Software'                 | 'TRY'      | '18%' | '38,00'      | '238,00'       |
	* Delete a line and check the total amount conversion
		And I activate field named "PaymentListCurrency" in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Business unit'      | 'Currency' | 'Expense type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Accountants office' | 'TRY'      | 'Telephone communications' | '187,00'     | '33,55'      | '220,55'       | '18%' |
		And in the table "PaymentList" I click the button named "PaymentListContextMenuDelete"
		And the editing text of form attribute named "PaymentListTotalNetAmount" became equal to "200,00"
		And the editing text of form attribute named "PaymentListTotalTaxAmount" became equal to "38,00"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "238,00"
	* Change Account
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Check that the Account does not change when you click No in the message window
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And "PaymentList" table does not contain lines
			| 'Net amount' | 'Business unit' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Change the company (without taxes) and check to delete the VAT column
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I wait that "PaymentList" table will not contain lines for 20 seconds
		| 'VAT' | 'Tax amount' |
		| '18%' | '38,00'      |
	* Change the company to the one with taxes and check the form by currency
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		* Exchange rate change in the form by currency
			And I go to line in "PaymentListCurrencies" table
			| 'Amount' | 'Currency' | 'Currency from' | 'Movement type'      | 'Multiplicity' | 'Rate presentation' | 'Type'      |
			| '40,41'  | 'USD'      | 'TRY'           | 'Reporting currency' | '1'            | '5,8400'            | 'Reporting' |
			And I activate field named "PaymentListCurrenciesAmount" in "PaymentListCurrencies" table
			And I select current line in "PaymentListCurrencies" table
			And I input "50,00" text in the field named "PaymentListCurrenciesAmount" of "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
			| 'Amount' | 'Currency' | 'Currency from' | 'Movement type'      | 'Multiplicity' | 'Rate presentation' | 'Type'      |
			| '50,00'  | 'USD'      | 'TRY'           | 'Reporting currency' | '1'            | '4,7200'            | 'Reporting' |
	* Add one more line with different cureency
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Software'    |
		And I select current line in "List" table
		And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I activate "VAT" field in "PaymentList" table
		And I select "0%" exact value from "VAT" drop-down list in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'TRY'      | '18%' | '36,00'      | '236,00'       |
			| '100,00'     | 'Accountants office' | 'Software'     | 'USD'      | '0%'  | ''           | '100,00'       |
		And I go to line in "PaymentList" table
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '100,00'     | 'Accountants office' | 'Software'     | 'USD'      | '0%'  | ''           | '100,00'       |
	* Check the addition of a line to the form by currency
		And I go to line in "PaymentListCurrencies" table
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '564,97' | '1'            |
	* Change of currency on the first line and check of form on currencies
		And I go to line in "PaymentList" table
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'TRY'      | '18%' | '36,00'      | '236,00'       |
		And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I go to line in "PaymentList" table
			| 'Net amount' | 'Business unit'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'USD'      | '18%' | '36,00'      | '236,00'       |
		And I go to line in "PaymentListCurrencies" table
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '1 333,33' | '1'            |
	* Manual correction of tax rate and check of tax calculations
		And I go to line in "PaymentList" table
			| 'Business unit' | 'Currency' | 'Expense type' | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Front office'  | 'USD'      | 'Software'     | '200,00'     | '36,00'      | '236,00'       | '18%' |
		And I select current line in "PaymentList" table
		And I select "8%" exact value from "VAT" drop-down list in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '8%'  | '16,00'      | '216,00'       |
		And "TaxTree" table contains lines
			| 'Tax' | 'Currency' | 'Business unit' | 'Amount' | 'Expense type' | 'Tax rate' | 'Manual amount' |
			| 'VAT' | 'USD'      | ''              | '16,00'  | ''             | ''         | '16,00'         |
			| 'VAT' | 'USD'      | 'Front office'  | '16,00'  | 'Software'     | '8%'       | '16,00'         |
	And I close all client application windows



Scenario: _0154117 check filling in and re-filling Cash revenue
	* Open form Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filter check by Account depending on the company
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And "List" table does not contain lines
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
		And I close current window
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And "List" table contains lines
			| 'Description'       | 'Currency' |
			| 'Cash desk №1'      | ''         |
			| 'Cash desk №2'      | ''         |
			| 'Cash desk №3'      | ''         |
			| 'Bank account, TRY' | 'TRY'      |
			| 'Bank account, USD' | 'USD'      |
			| 'Bank account, EUR' | 'EUR'      |
			| 'Cash desk №4'      | 'TRY'      |
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the Net amount and VAT calculation when filling in the Total amount
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Accountants office' |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'              |
			| 'Telephone communications' |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "220,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Telephone communications' | 'TRY'      | '18%' | '33,56'      | '220,00'       |
	* Check the recalculation of Total amount when Tax changes
		And I move to "Tax list" tab
		And I activate "Manual amount" field in "TaxTree" table
		And I go to line in "TaxTree" table
		| 'Business unit'     |
		| 'Accountants office' |
		And I select current line in "TaxTree" table
		And I input "33,55" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I move to "Payment list" tab
		And "PaymentList" table contains lines
		| 'Net amount' | 'Revenue type'               | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '186,44'     | 'Telephone communications'   | 'TRY'      | '18%' | '33,55'      | '219,99'       |
	* Check the Net amount recalculation when Total amount changes and with changes in taxes
		And I input "220,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And "PaymentList" table contains lines
		| 'Net amount' | 'Business unit'      | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '186,45'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,00'       |
	* Check the Total amount recalculation when Net amount changes and with changes in taxes
		And I input "187,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And "PaymentList" table contains lines
		| 'Net amount' | 'Revenue type'                     | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '187,00'     | 'Telephone communications'         | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Check the currency form connection
		And "PaymentListCurrencies" table contains lines
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '37,77'  | '1'            |
	* Add one more line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListBusinessUnit" in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Front office'    |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Software'    |
		And I select current line in "List" table
		And I activate "VAT" field in "PaymentList" table
		And I select "18%" exact value from "VAT" drop-down list in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I expand a line in "TaxTree" table
			| 'Amount' | 'Currency' | 'Manual amount' | 'Tax' |
			| '69,66'  | 'TRY'      | '69,55'         | 'VAT' |
		And I finish line editing in "PaymentList" table
	* Manual tax correction by line
		And I move to "Tax list" tab
		And I go to line in "TaxTree" table
			| 'Amount' | 'Business unit' | 'Currency' |
			| '36,00'  | 'Front office'  | 'TRY'      |
		And I select current line in "TaxTree" table
		And I input "38,00" text in "Manual amount" field of "TaxTree" table
		And I finish line editing in "TaxTree" table
		And I move to "Payment list" tab
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit'      | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,55'       |
			| '200,00'     | 'Front office'       | 'Software'                 | 'TRY'      | '18%' | '38,00'      | '238,00'       |
	* Delete a line and check the total amount conversion
		And I activate field named "PaymentListCurrency" in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Business unit'      | 'Currency' | 'Revenue type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Accountants office' | 'TRY'      | 'Telephone communications' | '187,00'     | '33,55'      | '220,55'       | '18%' |
		And in the table "PaymentList" I click the button named "PaymentListContextMenuDelete"
		And the editing text of form attribute named "PaymentListTotalNetAmount" became equal to "200,00"
		And the editing text of form attribute named "PaymentListTotalTaxAmount" became equal to "38,00"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "238,00"
	* Change Account
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And "PaymentList" table contains lines
			| 'Net amount' | 'Business unit' | 'Revenue type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Check that the Account does not change when you click in the No message window
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And "PaymentList" table does not contain lines
			| 'Net amount' | 'Business unit' | 'Revenue type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'  | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
	* Change the company (without taxes) and check to delete the VAT column
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I wait that "PaymentList" table will not contain lines for 20 seconds
		| 'VAT' | 'Tax amount' |
		| '18%' | '38,00'      |
	* Check the manually tax rate correction
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I activate "VAT" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I select "8%" exact value from "VAT" drop-down list in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Revenue type' | 'Total amount' | 'Currency' | 'VAT' | 'Tax amount' |
			| '200,00'     | 'Software'     | '216,00'       | 'TRY'      | '8%'  | '16,00'      |
		And "TaxTree" table contains lines
			| 'Tax' | 'Tax rate' | 'Currency' | 'Amount' | 'Manual amount' |
			| 'VAT' | ''         | 'TRY'      | '16,00'  | '16,00'         |
			| 'VAT'    | '8%'    | 'TRY'         | '16,00'  | '16,00'         |
		And I close all client application windows

Scenario: _0154118 check the details cleaning on the form Cash receipt 
	* Open form CashReceipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Filling in the details of the document CashReceipt
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
	* Fillin in Partner, Payer and Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Nicoletta   |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| 'Partner'   | 'Partner term'                              | 'Payer'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payer' when re-selecting the type of operation to Currency exchange
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Amount' | 'Amount exchange' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''       | ''                | ''                          |
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''          | ''       | ''      | ''               | ''                          |
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		And I close all client application windows


Scenario: _0154119 check the details cleaning on the form Cash payment when re-selecting the type of operation
	* Open form CashPayment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Filling in the details of the document CashPayment
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
	* Fillin in Partner, Payer and Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Nicoletta   |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| 'Partner'   | 'Partner term'                              | 'Payee'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payee' when re-selecting the type of operation to Currency exchange
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Amount' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''       | ''                          |
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''          | ''       | ''      | ''               | ''                          |
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		And I close all client application windows

Scenario: _0154120 check the details cleaning on the form Bank receipt when re-selecting the type of operation
	* Open form BankReceipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
	* Filling in the details of the document CashReceipt
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
	* Fillin in Partner, Payer and Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Nicoletta   |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| 'Partner'   | 'Partner term'                              | 'Payer'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payer' when re-selecting the type of operation to Currency exchange
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Amount' | 'Amount exchange' | 'Planning transaction basis' |
		| '1' | ''       | ''                | ''                          |
		* Check filling in Transit account form Accountant
			Then the form attribute named "TransitAccount" became equal to "Transit Main"
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''          | ''          | ''       | ''      | ''               | ''                          |
		Then the form attribute named "TransitAccount" became equal to ""
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		And I close all client application windows


Scenario: _0154121 check the details cleaning on the form Bank payment when re-selecting the type of operation
	* Open form BankPayment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
	* Filling in the details of the document BankPayment
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
	* Fillin in Partner, Payer and Partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Nicoletta   |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| 'Partner'   | 'Partner term'                              | 'Payee'             |
		| 'Nicoletta' | 'Posting by Standard Partner term Customer' | 'Company Nicoletta' |
	* Check clearing fields 'Partner term' and 'Payee' when re-selecting the type of operation to Currency exchange
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Amount' | 'Planning transaction basis' |
		| '1' | ''       | ''                          |
		* Check filling in Transit account from Accountant
			Then the form attribute named "TransitAccount" became equal to "Transit Main"
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''          | ''          | ''       | ''      | ''               | ''                          |
		Then the form attribute named "TransitAccount" became equal to ""
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner' | 'Partner term' | 'Amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		And I close all client application windows


Scenario: _0154122 check filling in and re-filling Reconcilation statement
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click the button named "FormCreate"
	* Filling in basic details
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Begin period" field
		And I input "01.01.2020" text in "Begin period" field
		And I input "01.01.2025" text in "End period" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And in the table "Transactions" I click "Fill" button
	* Check that the transaction table is filled out
		And While the number of "Transactions" table lines "больше" 0 Then
		And I click the button named "FormPost"
		And "Transactions" table does not contain lines
			| 'Document'            | 'Credit'     | 'Debit'     |
			| '$$PurchaseInvoice018001$$' | '137 000,00' | ''          |
			| '$$SalesInvoice024001$$'    | ''           | '4 350,00'  |
			| '$$SalesInvoice024008$$'    | ''           | '11 099,93' |
	* Check re-filling when re-selecting a partner
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table contains lines
			| 'Document'            | 'Credit'     | 'Debit'     |
			| '$$PurchaseInvoice29604$$' | '13 000,00' | ''          |
		And I click the button named "FormPost"
	* Check re-filling when re-selecting a currency
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' |
			| 'USD'  |
		And I select current line in "List" table
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table does not contain lines
			| 'Document'            | 'Credit'     | 'Debit'     |
			| '$$PurchaseInvoice2004$$' | '4 000,00' | ''          |
	* Check refilling at company re-selection
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Second Company' |
		And I select current line in "List" table
		And in the table "Transactions" I click "Fill" button
		Then the number of "Transactions" table lines is "равно" 0
	* Check re-filling when re-selecting a legal name (partner previous)
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And While the number of "Transactions" table lines "больше" 0 Then
		And I click the button named "FormPost"
		And I close all client application windows


Scenario: _0154123 filling in Transit account from Account when exchanging currency (Bank Receipt)
	And I close all client application windows
	* Open form Bank Receipt and select transaction type Currency exchange
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Check filling in Transit account 
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, USD' |
		And I select current line in "List" table
		Then the form attribute named "TransitAccount" became equal to "Transit Second"
	* Check filling in Transit account when re-select Bank account
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		Then the form attribute named "TransitAccount" became equal to "Transit Main"
		And I close all client application windows

Scenario: _0154124 filling in Transit account from Account when exchanging currency (Bank Payment)
	And I close all client application windows
	* Open form Bank Payment and select transaction type Currency exchange
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Check filling in Transit account 
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		And I select current line in "List" table
		Then the form attribute named "TransitAccount" became equal to "Transit Second"
	* Check filling in Transit account when re-select Bank account
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		Then the form attribute named "TransitAccount" became equal to "Transit Main"
		And I close all client application windows


Scenario: _0154125 check the selection by Planing transaction basis in Bank payment document in case of currency exchange
	* Open form Bank Payment and select transaction type Currency exchange
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'         |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the selection by Planing transaction basis
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I go to line in "List" table
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the selected document is in BankPayment
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | '$$CashTransferOrder01541003$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And I go to line in "List" table
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when post Bank Payment
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And I go to line in "List" table
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And I go to line in "List" table
		| 'Number' | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click the button named "FormPost"
		And I save the value of "Number" field as "Number"
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "Cancel" button
	* Check clearing Planing transaction basis in case of transaction type change
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	And I close all client application windows
	

Scenario: _0154126 check the selection by Planing transaction basis in BankReceipt in case of currency exchange
	* Open form Bank Payment and select transaction type Currency exchange
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'         |
			| 'EUR'      | 'Bank account, EUR' |
		And I select current line in "List" table
	* Check the selection by Planing transaction basis
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the selected document is in BankPayment
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | '$$CashTransferOrder01541003$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form (Bank Receipt posted)
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click the button named "FormPost"
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "Cancel" button
	* Check clearing Planing transaction basis in case of transaction type change
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	And I close all client application windows


Scenario: _0154127 check the selection by Planing transaction basis in Cash Payment in case of currency exchange
	* Open form CashPayment and select transaction type Currency exchange
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'         |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
		| 'Code' | 'Description'     |
		| 'USD'  | 'American dollar' |
		And I select current line in "List" table
	* Check the selection by Planing transaction basis
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the selected document is in Cash Payment
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | '$$CashTransferOrder01541002$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Cash Payment posted
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click the button named "FormPost"
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "Cancel" button
	* Check clearing Planing transaction basis in case of transaction type change
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	And I close all client application windows


Scenario: _0154128 check the selection by Planing transaction basis in CashReceipt in case of currency exchange
	* Open form CashReceipt and select transaction type Currency exchange
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'         |
			| 'Cash desk №1' |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
	* Check the selection by Planing transaction basis
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
			| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
			| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the selected document is in CashReceipt
		And "PaymentList" table contains lines
			| 'Amount' | 'Planning transaction basis' |
			| '100,00' | '$$CashTransferOrder01541002$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
			| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
			| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Cash Receipt posted 
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'USD'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click the button named "FormPost"
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "Cancel" button
	* Check clearing Planing transaction basis in case of transaction type change
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	And I close all client application windows

Scenario:  _0154129 check the selection by Planing transaction basis in BankPayment in case of cash transfer
	* Open form Bank Payment and select transaction type Cash transfer order
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'         |
			| 'EUR'      | 'Bank account 2, EUR' |
		And I select current line in "List" table
	* Check the selection by Planing transaction basis
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the selected document is in BankPayment
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | '$$CashTransferOrder01541004$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Bank Payment posted
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click the button named "FormPost"
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "Cancel" button
	* Check clearing Planing transaction basis in case of transaction type change
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	And I close all client application windows

Scenario:  _0154130 check the selection by Planing transaction basis in Bank Receipt in case of cash transfer
	* Open form Bank Receipt and select transaction type Cash transfer order
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'         |
			| 'EUR'      | 'Bank account, EUR' |
		And I select current line in "List" table
	* Check the selection by Planing transaction basis
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListAmount" of "PaymentList" table
	* Check that the selected document is in BankReceipt
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '100,00' | '$$CashTransferOrder01541004$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Bank Receipt posted
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Q"
		Then "Q" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I click the button named "FormPost"
	* Check not clearing Planning transaction basis in case of cancellation when changing the type of transaction
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "Cancel" button
	* Check clearing Planing transaction basis in case of transaction type change
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| 'Amount' | 'Planning transaction basis' |
		| '200,00' | ''                          |
	And I close all client application windows

Scenario: _053014 check the display of details on the form Bank payment with the type of operation Currency exchange
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Currency exchange"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is available
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* And I check the display of the tabular part
		Then the form attribute named "TransitAccount" became equal to "Transit Main"
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And "PaymentList" table contains lines
			| '#' | 'Amount' | 'Planning transaction basis' |
			| '1' | ''       | ''                          |




Scenario: _0154131  check currency form in  Bank Receipt
	* Filling in Bank Receipt
		* Filling the document header
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I click the button named "FormCreate"
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Bank account selection and check of Currency field refilling
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
			Then the form attribute named "Currency" became equal to "TRY"
		* Check the choice of a partner in the tabular section and filling in the legal name if one
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'NDB'         |
			And I select current line in "List" table
			And I input "200,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
	* Check form by currency
		* Basic recalculation at the rate
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recalculation of Rate presentation when changing Amount
			And I input "35,00" text in the field named "CurrenciesPaymentListAmount" of "CurrenciesPaymentList" table
			And I finish line editing in "CurrenciesPaymentList" table
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Recount Amount when changing Multiplicity
			And I input "2" text in "Multiplicity" field of "CurrenciesPaymentList" table
			And I finish line editing in "CurrenciesPaymentList" table
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Recount Amount when changing Multiplicity
			And I input "6,0000" text in "Rate presentation" field of "CurrenciesPaymentList" table
			And I finish line editing in "CurrenciesPaymentList" table
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Recount Amount when changing payment amount
			And I input "250,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "CurrenciesPaymentList" table
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Check the standard currency rate when adding the next line
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click Clear button of the attribute named "PaymentListPayer" in "PaymentList"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Veritas   |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Company Veritas ' |
			And I select current line in "List" table
			And I input "200,00" text in "Amount" field of "PaymentList" table
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recount when currency changes
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			And I select current line in "List" table
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'TRY'            | 'Partner term' | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
			And I go to line in "CurrenciesPaymentList" table
				| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'TRY'            | 'Partner term' | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
		# * Reverse rate display check
		# 	Given double click at "reverse" picture
		# 	And I go to line in "PaymentList" table
		# 		| 'Partner term'                               | 'Amount' | 'Partner' | 'Payer'            |
		# 		| 'Posting by Standard Partner term (Veritas)' | '200,00' | 'Veritas' | 'Company Veritas ' |
		# 	And I activate "Partner term" field in "PaymentList" table
		# 	And "CurrenciesPaymentList" table contains lines
		# 		| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
		# 		| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		And I close all client application windows

Scenario: _0154132  check currency form in Incoming payment order
	* Filling in Incoming payment order
		* Filling the document header
			Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Bank account selection and check of Currency field refilling
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
			Then the form attribute named "Currency" became equal to "TRY"
		* Check the choice of a partner in the tabular section and filling in the legal name if one
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'NDB'         |
			And I select current line in "List" table
			And I input "200,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
	* Check form by currency
		* Basic recalculation at the rate
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recalculation of Rate presentation when changing Amount
			And I input "35,00" text in the field named "PaymentListCurrenciesAmount" of "PaymentListCurrencies" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Recount Amount when changing Multiplicity
			And I input "2" text in "Multiplicity" field of "PaymentListCurrencies" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Recount Amount when changing Multiplicity Rate presentation
			And I input "6,0000" text in "Rate presentation" field of "PaymentListCurrencies" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Recount Amount when changing payment amount
			And I input "250,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Check the standard currency rate when adding the next line
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Veritas   |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Company Veritas ' |
			And I select current line in "List" table
			And I input "200,00" text in "Amount" field of "PaymentList" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recount when currency changes
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			And I select current line in "List" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
		# * Reverse rate display check 
		# 	Given double click at "reverse" picture
		# 	And I go to line in "PaymentList" table
		# 		| 'Amount' | 'Partner' | 'Payer'            |
		# 		| '200,00' | 'Veritas' | 'Company Veritas ' |
		# 	And "PaymentListCurrencies" table contains lines
		# 		| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
		# 		| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		And I close all client application windows


Scenario: _0154133  check currency form in Outgoing payment order
	* Filling in Outgoing Payment Order
		* Filling the document header
			Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Bank account selection and check of Currency field refilling
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
			Then the form attribute named "Currency" became equal to "TRY"
		* Check the choice of a partner in the tabular section and filling in the legal name if one
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'NDB'         |
			And I select current line in "List" table
			And I input "200,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
	* Check form by currency
		* Basic recalculation at the rate
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recalculation of Rate presentation when changing Amount
			And I input "35,00" text in the field named "PaymentListCurrenciesAmount" of "PaymentListCurrencies" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '35,00'  | '1'            |
		* Recount Amount when changing Multiplicity
			And I input "2" text in "Multiplicity" field of "PaymentListCurrencies" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,7143'            | '17,50'  | '2'            |
		* Recount Amount when changing Multiplicity Rate presentation
			And I input "6,0000" text in "Rate presentation" field of "PaymentListCurrencies" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '16,67'  | '2'            |
		* Recount Amount when changing payment amount
			And I input "250,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentListCurrencies" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '6,0000'            | '20,83'  | '2'            |
		* Check the standard currency rate when adding the next line
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Veritas   |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Company Veritas ' |
			And I select current line in "List" table
			And I input "200,00" text in "Amount" field of "PaymentList" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '34,25'  | '1'            |
		* Recount when currency changes
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			And I select current line in "List" table
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
			And I go to line in "PaymentListCurrencies" table
				| 'Movement type'             | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
				| 'Local currency'            | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'             | '1 129,94' | '1'            |
		# * Reverse rate display check 
		# 	Given double click at "reverse" picture
		# 	And I go to line in "PaymentList" table
		# 		| 'Amount' | 'Partner' | 'Payee'            |
		# 		| '200,00' | 'Veritas' | 'Company Veritas ' |
		# 	And "PaymentListCurrencies" table contains lines
		# 		| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
		# 		| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		And I close all client application windows

Scenario: _0154150 check function DontCalculateRow in the Purchase order
	* Open the Purchase order creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I select current line in "ItemList" table
			And I input "150,00" text in "Tax amount" field of "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "951,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I remove checkbox "Goods receipt before purchase invoice"			
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Purchase invoice bases on Purchase order
		And I click "Purchase invoice" button
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     |
		| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   |
		And I close all client application windows
		

		
					

Scenario: _0154151 check function DontCalculateRow in the Purchase invoice
	* Open the Purchase invoice creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I select current line in "ItemList" table
			And I input "150,00" text in "Tax amount" field of "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "951,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I click the button named "FormPost"
		* Check filling the recalculation check box when creating Purchase return / Purchase return order bases on Purchase invoice
			And I click "Purchase return order" button
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   |
			And I close current window
			And I click "Purchase return" button
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   |
			And I close all client application windows
			
	
Scenario: _0154152 check function DontCalculateRow in the Purchase return
	* Open the Purchase return creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I select current line in "ItemList" table
			And I input "150,00" text in "Tax amount" field of "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "951,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I click the button named "FormPostAndClose"
						

Scenario: _0154153 check function DontCalculateRow in the Purchase return order
	* Open the Purchase return order creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I select current line in "ItemList" table
			And I input "150,00" text in "Tax amount" field of "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "951,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I select "Approved" exact value from "Status" drop-down list				
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Purchase return bases on Purchase return order
		And I click "Purchase return" button
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     |
		| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   |
		And I close all client application windows
	
Scenario: _0154154 check function DontCalculateRow in the Sales order
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '129,95'     | '2,000' | 'pcs'  | 'No'                 | '670,05'     | '800,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			Then "Edit tax" window is opened
			And I activate "Manual amount" field in "TaxTree" table
			And I select current line in "TaxTree" table
			And I input "8,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I go to line in "TaxTree" table
				| 'Amount' | 'Row presentation' |
				| '122,03' | 'VAT - TRY - 18%'  |
			And I select current line in "TaxTree" table
			And I input "122,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I click "Ok" button
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I input "670,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Q'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Q'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "576,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table		
			And I activate "Manual amount" field in "TaxTree" table
			And I select current line in "TaxTree" table
			And I input "8,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I go to line in "TaxTree" table
				| 'Amount' | 'Row presentation' |
				| '122,03' | 'VAT - TRY - 18%'  |
			And I select current line in "TaxTree" table
			And I input "121,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '670,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "671,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 974,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00""
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "800,50" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '800,50'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 974,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 550,50""
		* Add new line and check calculation
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '84,47'      | '435,53'     | '520,00'       |
		* Check calculation when remove "Price includes tax" checkbox
			And I move to "Other" tab
			And I remove checkbox "Price includes tax"
			And I remove checkbox "Shipment confirmations before sales invoice"			
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '98,80'      | '520,00'     | '618,80'       |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 941,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "750,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 691,80"
			And I click the button named "FormPostAndClose"
	* Check filling the recalculation check box when creating Sales invoice bases on Sales order
		And I click "Sales invoice" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
		And I close all client application windows

Scenario: _0154155 check function DontCalculateRow in the Sales invoice
	And I close all client application windows
	* Open the Sales invoice creation form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '129,95'     | '2,000' | 'pcs'  | 'No'                 | '670,05'     | '800,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			Then "Edit tax" window is opened
			And I activate "Manual amount" field in "TaxTree" table
			And I select current line in "TaxTree" table
			And I input "8,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I go to line in "TaxTree" table
				| 'Amount' | 'Row presentation' |
				| '122,03' | 'VAT - TRY - 18%'  |
			And I select current line in "TaxTree" table
			And I input "122,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I click "Ok" button
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I input "670,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Q'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Q'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "576,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table		
			And I activate "Manual amount" field in "TaxTree" table
			And I select current line in "TaxTree" table
			And I input "8,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I go to line in "TaxTree" table
				| 'Amount' | 'Row presentation' |
				| '122,03' | 'VAT - TRY - 18%'  |
			And I select current line in "TaxTree" table
			And I input "121,00" text in "Manual amount" field of "TaxTree" table
			And I finish line editing in "TaxTree" table
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '670,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "671,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 974,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00""
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "800,50" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '800,50'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 974,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 550,50""
		* Add new line and check calculation
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '84,47'      | '435,53'     | '520,00'       |
		* Check calculation when remove "Price includes tax" checkbox
			And I move to "Other" tab
			And I remove checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '98,80'      | '520,00'     | '618,80'       |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 941,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "750,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 691,80"
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Sales return / Sales return order bases on Sales invoice
		And I click "Sales return" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
		And I close current window
		And I click "Sales return order" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
		And I close all client application windows
		
	
	
Scenario: _0154156 check function DontCalculateRow in the Sales return
	* Open the Sales return creation form
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"		
		And I move to "Item list" tab
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I select current line in "ItemList" table
			And I input "150,00" text in "Tax amount" field of "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "951,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
			And I click the button named "Add"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I click the button named "FormPostAndClose"


Scenario: _0154157 check function DontCalculateRow in the Sales return order
	* Open the Sales return order creation form
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"		
		And I move to "Item list" tab
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I select current line in "ItemList" table
			And I input "150,00" text in "Tax amount" field of "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I activate field named "ItemListNetAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "951,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Sales return on Sales return order
		And I click "Sales return" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		And I close all client application windows
		


Scenario: _0154160 check tax and net amount calculation when change total amount in the Purchase invoice
	* Open the Purchase invoice creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Filling in item and item key
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'L/Green' |
		And I select current line in "List" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I move to "More" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |		 			
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I close all client application windows
			

Scenario: _0154161 check tax and net amount calculation when change total amount in the Purchase order
	* Open the Purchase order creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Filling in item and item key
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'L/Green' |
		And I select current line in "List" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I move to "More" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |		 			
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I close all client application windows
			

Scenario: _0154162 check tax and net amount calculation when change total amount in the Purchase return order
	* Open the Purchase return order creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Filling in item and item key
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'L/Green' |
		And I select current line in "List" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | ''              | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I close all client application windows
			
						

Scenario: _0154163 check tax and net amount calculation when change total amount in the Purchase return
	* Open the Purchase return creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company NDB'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor NDB'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Filling in item and item key
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'L/Green' |
		And I select current line in "List" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I close all client application windows
			
						
	
Scenario: _0154164 check tax and net amount calculation when change total amount in the Sales return
	* Open the Sales return creation form
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"
		And I move to "Item list" tab			
	* Filling in item and item key
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'L/Green' |
		And I select current line in "List" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I close all client application windows
									

Scenario: _0154165 check tax and net amount calculation when change total amount in the Sales return order
	* Open the Sales return order creation form
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"
		And I move to "Item list" tab			
	* Filling in item and item key
		And in the table "ItemList" I click the button named "ItemListAdd"	
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'L/Green' |
		And I select current line in "List" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I close all client application windows			

Scenario: _0154180 check that author does not copy when copying a document
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
	And I go to line in "List" table
		| "Number" |
		| "$$NumberSalesInvoice024025$$" |
	And I select current line in "List" table
	* Change author
		And I move to "Other" tab
		And I click Select button of "Author" field
		And I go to line in "List" table
			| 'Description'               |
			| 'Arina Brown (Financier 3)' |
		And I select current line in "List" table
		And I click the button named "FormPost"	
		Then the form attribute named "Author" became equal to "Arina Brown (Financier 3)"
		And I click the button named "FormPostAndClose"
	And in the table "List" I click the button named "ListContextMenuCopy"
	Then the form attribute named "Author" became equal to "CI"
	And I close all client application windows	
	
		
Scenario: _999999 close TestClient session
	And I close TestClient session