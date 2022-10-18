#language: en
@tree
@Positive
@FillingDocuments

Feature: check filling in and refilling in documents forms + currency form connection

Variables:
import "Variables.feature"

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
		When Create catalog Taxes objects (for work order)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog PlanningPeriods objects
		When create items for work order
		When Create catalog BillOfMaterials objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create catalog PartnerItems objects
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
		When Create catalog CancelReturnReasons objects
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
				* Filling Movement type
					And I click Select button of "Send financial movement type" field
					And I go to line in "List" table
						| 'Description'     | 
						| 'Movement type 1' | 
					And I select current line in "List" table
					And I click Select button of "Receive financial movement type" field
					And I go to line in "List" table
						| 'Description'     |
						| 'Movement type 1' |
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
				* Filling Movement type
					And I click Select button of "Send financial movement type" field
					And I go to line in "List" table
						| 'Description'     |
						| 'Movement type 1' |
					And I select current line in "List" table
					And I click Select button of "Receive financial movement type" field
					And I go to line in "List" table
						| 'Description'     |
						| 'Movement type 1' |
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
						| 'Number'                              | 'Company'      | 'Sender'       | 'Receiver'     |
						| '$$NumberCashTransferOrder01541002$$' | 'Main Company' | 'Cash desk №2' | 'Cash desk №1' |
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
				* Filling Movement type
					And I click Select button of "Send financial movement type" field
					And I go to line in "List" table
						| 'Description'     |
						| 'Movement type 1' |
					And I select current line in "List" table
					And I click Select button of "Receive financial movement type" field
					And I go to line in "List" table
						| 'Description'     |
						| 'Movement type 1' |
					And I select current line in "List" table
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
					* Filling Movement type
						And I click Select button of "Send financial movement type" field
						And I go to line in "List" table
							| 'Description'     |
							| 'Movement type 1' |
						And I select current line in "List" table
						And I click Select button of "Receive financial movement type" field
						And I go to line in "List" table
							| 'Description'     |
							| 'Movement type 1' |
						And I select current line in "List" table
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
	* Price list (work)
		And Delay 10
		When Create document PriceList objects (works)
		And I execute 1C:Enterprise script at server
			| "Documents.PriceList.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PriceList.FindByNumber(22).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _01541001 check preparation
	When check preparation

Scenario: _01541002 check filters in the PI list form
	And I close all client application windows
	* Open PI list form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Add filter by currency
		And I click "Configure list..." button
		Then "List Options" window is opened
		And I go to line in "SettingsComposerUserSettingsItem0AvailableFieldsTable" table
			| 'Available fields' |
			| 'Currency'         |
		And I select current line in "SettingsComposerUserSettingsItem0AvailableFieldsTable" table
		And I change checkbox named "SettingsComposerUserSettingsItem0FilterUse" in "SettingsComposerUserSettingsItem0Filter" table
		And I finish line editing in "SettingsComposerUserSettingsItem0Filter" table
		And I click "Finish editing" button
	* Check filter
		And I set checkbox named "SettingsComposerUserSettingsItem4Use"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem4Value"
		Then "Currencies" window is opened
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And "List" table became equal
			| 'Partner'   | 'Amount'   | 'Currency' |
			| 'Ferron BP' | '4 000,00' | 'USD'      |
		And I click Choice button of the field named "SettingsComposerUserSettingsItem4Value"
		Then "Currencies" window is opened
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And "List" table became equal
			| 'Partner'   | 'Amount'    | 'Currency' |
			| 'Ferron BP' | '13 000,00' | 'TRY'      |
		And I remove checkbox named "SettingsComposerUserSettingsItem4Use"
		And "List" table became equal
			| 'Partner'   | 'Amount'    | 'Currency' |
			| 'Ferron BP' | '13 000,00' | 'TRY'      |
			| 'Ferron BP' | '4 000,00'  | 'USD'      |
		And I close all client application windows
						

Scenario: _0154101 check filling in and refilling Sales order
	And I close all client application windows
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Procurement method' | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | 'Stock'              | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | 'Stock'              | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Procurement method' | 'Tax amount'  | 'SalesTax'  | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
			Then "Update item list info" window is opened
			And I click "OK" button
		* Tax calculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And I click "Save" button
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '303,02' |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '1 770'  |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '1 770'  |
			And I close current window	
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
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '5,45'       | '1%'       | '1,000' | 'pcs'  | '544,55'     | '550,00'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 566,37"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "203,63"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
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
					| 'Item'  | 'Item key' | 'Price'  | 'Quantity'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '7,00'       | '1%'       | '2,000' | 'pcs'  | '700,00'     | '707,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1%'       | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1%'       | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
				And I click "Post" button
				And I delete "$$NumberSalesOrder0154101$$" variable
				And I save the value of "Number" field as "$$NumberSalesOrder0154101$$"					
		* Cancel second line (Dress/L Green) and check totals
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key' |
				| 'Dress'    | 'L/Green'  |
			And I activate "Cancel" field in "ItemList" table
			And I set "Cancel" checkbox in "ItemList" table
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'not available'    |
			And I select current line in "List" table			
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "105,80"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 325,80"
			And Delay 2
		* Add new line with procurement Purchase and check totals
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
		* Delete line and check totals 
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And in the table "ItemList" I click "Delete" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "105,80"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 325,80"
		* Add new line with procurement No reserve and check totals
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
			And I click "Post" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
			And I click "Post and close" button
			And "List" table contains lines
				| 'Number'                     | 'Σ'        |
				| '$$NumberSalesOrder0154101$$'| '1 980,30' |
			And Delay 2
		* Unchecking the cancellation checkbox and check totals	
			And I go to line in "List" table
				| 'Number'                     | 'Σ'        |
				| '$$NumberSalesOrder0154101$$'| '1 980,30' |
			And I select current line in "List" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key' |
				| 'Dress'    | 'L/Green'  |
			And I activate "Cancel" field in "ItemList" table
			And I remove "Cancel" checkbox in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "2 320,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "314,80"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "2 634,80"
			And I click "Post and close" button
			And "List" table contains lines
				| 'Number'                     | 'Σ'        |
				| '$$NumberSalesOrder0154101$$'| '2 634,80' |
		* Check manual price when quantity in base unit different from quantity
			And I go to line in "List" table
				| 'Number'                     |
				| '$$NumberSalesOrder0154101$$'|
			And I select current line in "List" table
			And in the table "ItemList" I click "Add" button
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    | 'Price type'        | 'Item'       |
				| '37/19SD'  | '2,000'    | 'pcs'  | '205,20'     | '540,00' | '18%' | '1 080,00'   | '1 285,20'     | 'Store 01' | 'Basic Price Types' | 'High shoes' |
			And I go to line in "ItemList" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |	
			And I select current line in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'High shoes box (8 pcs)' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Item key' | 'Quantity' | 'Unit'                   | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    | 'Price type'              | 'Item'       |
				| '37/19SD'  | '2,000'    | 'High shoes box (8 pcs)' | '190,00'     | '500,00' | '18%' | '1 000,00'   | '1 190,00'     | 'Store 01' | 'en description is empty' | 'High shoes' |
			And I close all client application windows
			

Scenario: _0154102 check filling in and refilling Sales invoice
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'SalesTax'  | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
			#-> new step
			Then "Update item list info" window is opened
			And I click "OK" button
			#<-
		* Tax calculation check
			If window with "Update item list info" header has appeared Then
				And I click "OK" button
			And "ItemList" table contains lines
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '303,02' |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '1 770'  |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '1 770'  |
			And I close current window
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
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '5,45'       | '1%'       | '1,000' | 'pcs'  | '544,55'     | '550,00'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 566,37"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "203,63"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
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
					| 'Item'  | 'Item key' | 'Price'  | 'Quantity'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '7,00'       | '1%'       | '2,000' | 'pcs'  | '700,00'     | '707,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1%'       | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1%'       | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
		* Check manual price when quantity in base unit different from quantity
			And in the table "ItemList" I click "Add" button
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Item key' | 'Quantity' | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    | 'Price type'        | 'Item'       |
				| '37/19SD'  | '2,000'    | 'pcs'  | '205,20'     | '540,00' | '18%' | '1 080,00'   | '1 285,20'     | 'Store 01' | 'Basic Price Types' | 'High shoes' |
			And I go to line in "ItemList" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |	
			And I select current line in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'High shoes box (8 pcs)' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Item key' | 'Quantity' | 'Unit'                   | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    | 'Price type'              | 'Item'       |
				| '37/19SD'  | '2,000'    | 'High shoes box (8 pcs)' | '190,00'     | '500,00' | '18%' | '1 000,00'   | '1 190,00'     | 'Store 01' | 'en description is empty' | 'High shoes' |
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
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
			| 'Item'  | 'Price'    | 'Item key' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | '1 000,00' | 'M/Brown'  | '1,000' | 'pcs'  | '1 000,00'     | '1 000,00'     | 'Store 01' |
		If "ItemList" table does not contain "Tax amount" column Then
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
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,2000' | '200,00' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '1 000'  |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '1 000'  |
		
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
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Dress' | '18%' | 'M/Brown'  | '81,22'      | '1%'       | '1,000' | 'pcs'  | '418,78'     | '500,00'       | 'Store 01' |
	* Change of date and check of price and tax recalculation
		And I move to "Other" tab
		And I expand "More" group
		And I input "01.11.2018 10:00:00" text in "Date" field
		And I move to "Item list" tab
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Price'    | 'Item key' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | '1 000,00' | 'M/Brown'  | '1,000' | 'pcs'  | '1 000,00'     | '1 000,00'     | 'Store 01' |
		If "ItemList" table does not contain "Tax amount" column Then
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
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,2000' | '200,00' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '1 000'  |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '1 000'  |
		
Scenario: _0154105 check filling in and refilling Purchase order
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And Delay 2
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '*'      | '38/Yellow' | '1,000' |
			And Delay 2
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling in currency tab
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'  |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '357,57'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '2 088,6' |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '2 088,6' |
			And I close current window
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
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | ''           | '1,000' | 'pcs'  | '550,00'     | '550,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 583,90"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "186,10"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
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
					| 'Item'  | 'Item key' | 'Price'  | 'Quantity'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | ''           | '2,000' | 'pcs'  | '700,00'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | '99,00'      | '1,000' | 'pcs'  | '550,00'     | '649,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '93,60'      | '1,000' | 'pcs'  | '520,00'     | '613,60'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
	* Check filling in Partner bank account
		And I move to "Other" tab
		And I click Select button of "Partner bank account" field
		And "List" table contains lines
			| 'Bank name' | 'Number'           | 'Currency' |
			| 'Bank name' | '56788888888888689' | 'EUR'      |
		Then the number of "List" table lines is "равно" "1"
		And I select current line in "List" table
		Then the form attribute named "PartnerBankAccount" became equal to "Partner bank account (Partner Kalipso)"
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseOrder0154101$$"	
	* Cancel second line (Dress/L Green) and check totals
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key' |
				| 'Dress'    | 'L/Green'  |
			And I activate "Cancel" field in "ItemList" table
			And I set "Cancel" checkbox in "ItemList" table
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'not available'    |
			And I select current line in "List" table	
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "93,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 313,60"
		* Add new line and check totals
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
		* Delete line and check totals 
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And I click "Delete" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "93,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 313,60"
			And I click "Post and close" button
			And "List" table contains lines
				| 'Number'                         | 'Amount'   |
				| '$$NumberPurchaseOrder0154101$$' | '1 313,60' |
		* Unchecking the cancellation checkbox and check totals	
			And I go to line in "List" table
				| 'Number'                         | 'Amount'   |
				| '$$NumberPurchaseOrder0154101$$' | '1 313,60' |
			And I select current line in "List" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key' |
				| 'Dress'    | 'L/Green'  |
			And I activate "Cancel" field in "ItemList" table
			And I remove "Cancel" checkbox in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
			And I click "Post and close" button
			And "List" table contains lines
				| 'Number'                         | 'Amount'   |
				| '$$NumberPurchaseOrder0154101$$' | '1 962,60' |
			And I close all client application windows
		
		


Scenario: _0154106 check filling in and refilling Purchase invoice
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling in currency tab
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'  |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '357,57'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '2 088,6' |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '2 088,6' |
			And I close current window
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
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | ''           | '1,000' | 'pcs'  | '550,00'     | '550,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 583,90"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "186,10"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
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
					| 'Item'  | 'Item key' | 'Price'  | 'Quantity'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | ''           | '2,000' | 'pcs'  | '700,00'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | '99,00'      | '1,000' | 'pcs'  | '550,00'     | '649,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '93,60'      | '1,000' | 'pcs'  | '520,00'     | '613,60'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"

Scenario: _0154107 check filling in and refilling Cash receipt (transaction type Payment from customer)
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
			| 'Partner' | 'Partner term' | 'Total amount' | 'Payer'           | 'Basis document' |
			| 'Kalipso' | ''             | '11 000,00'    | 'Company Kalipso' | ''               |
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
			| 'Description'                               |
			| 'Posting by Standard Partner term Customer' |
		And I select current line in "List" table
	* Check the addition of a base document without selecting a base document
		When I Check the steps for Exception
			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		When I Check the steps for Exception
			|'Given form with "Documents for incoming payment" header is opened in the active window'|
	* Check the currency form connection
		And I go to line in "PaymentList" table
			| 'Partner' | 'Payer'           |
			| 'Kalipso' | 'Company Kalipso' |
		And I select current line in "PaymentList" table
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '17,12'  |	
		And I close current window	
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
		And I close current window	
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,2000' | '40,00'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
		And I close current window	
		And I go to line in "PaymentList" table
			| 'Partner' | 'Payer'           |
			| 'Kalipso' | 'Company Kalipso' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,2000' | '20,00'  |
		And I close current window	
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
	* Update currency form
		And in the table "PaymentList" I click "Edit currencies" button
		Then "Edit currencies" window is opened
		And I click "Update" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,2000' | '20,00'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |			
		And I click "Currency rates" button
		And "List" table became equal
			| 'Currency from' | 'Currency to' | 'Source'       | 'Multiplicity' | 'Rate'   |
			| 'TRY'           | 'USD'         | 'Forex Seling' | '1'            | '0,2000' |
			| 'TRY'           | 'USD'         | 'Forex Seling' | '1'            | '0,1712' |	
		If user messages contain "Specify a base document for line 1." string Then
		And I close all client application windows
		

Scenario: _0154108 total amount calculation in Cash receipt
	* Open form Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №1' |
		And I select current line in "List" table			
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                      |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click "Select" button	
		And the editing text of form attribute named "DocumentAmount" became equal to "984,66"		
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
			| 'Total amount' |
			| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "934,66"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "1 014,66"
	* Copy line and check Total amount calculation
		And I go to line in "PaymentList" table
			| 'Total amount' | 'Partner' | 'Partner term'                     | 'Payer'           |
			| '554,66'       | 'Kalipso' | 'Basic Partner terms, without VAT' | 'Company Kalipso' |
		And I activate "Partner term" field in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListContextMenuCopy"
		And the editing text of form attribute named "DocumentAmount" became equal to "1 569,32"
		And I close all client application windows


Scenario: _0154109 check filling in and refilling Bank receipt (transaction type Payment from customer)
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
			| 'Partner'   | 'Partner term' | 'Total amount' | 'Payer'             | 'Basis document' |
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
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner' | 'Payer'           |
			| 'Kalipso' | 'Company Kalipso' |
		And I select current line in "PaymentList" table
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '17,12'  |	
		And I close current window	
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
		And I close current window
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payer'             |
			| 'Nicoletta' | 'Company Nicoletta' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,2000' | '40,00'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
		And I close current window	
		And I go to line in "PaymentList" table
			| 'Partner' | 'Payer'           |
			| 'Kalipso' | 'Company Kalipso' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,2000' | '20,00'  |
		And I close current window	
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
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'  |
			| 'Bank account, TRY' |
		And I select current line in "List" table			
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                      |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click "Select" button	
		And the editing text of form attribute named "DocumentAmount" became equal to "984,66"		
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Total amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "934,66"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "1 014,66"
	* Copy line and check Total amount calculation
		And I go to line in "PaymentList" table
			| 'Total amount' | 'Partner' | 'Partner term'                     | 'Payer'           |
			| '554,66'       | 'Kalipso' | 'Basic Partner terms, without VAT' | 'Company Kalipso' |
		And I activate "Partner term" field in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListContextMenuCopy"
		And the editing text of form attribute named "DocumentAmount" became equal to "1 569,32"
		And I close all client application windows
		
		
				



Scenario: _0154111 check filling in and refilling Cash payment (transaction type Payment to the vendor)
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
			| 'Partner'   | 'Partner term' | 'Total amount' | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''             | '13 000,00'    | 'Company Ferron BP' | ''               |
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
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Veritas'   | 'Company Veritas '  |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '17,12'  |
		And I close current window		
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |		
		And I close current window	
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,2000' | '20,00'  |
		And I close current window	
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,2000' | '40,00'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
		And I close current window		
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
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №1' |
		And I select current line in "List" table
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I finish line editing in "PaymentList" table
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I activate "Payee" field in "PaymentList" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click "Select" button
		And the editing text of form attribute named "DocumentAmount" became equal to "13 430,00"		
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Total amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "13 380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "13 460,00"
	* Copy line and check Total amount calculation
		And I go to line in "PaymentList" table
			| 'Total amount' | 'Partner'   | 'Partner term'       | 'Payee'             |
			| '13 000,00'    | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' |
		And I activate "Partner term" field in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListContextMenuCopy"
		And the editing text of form attribute named "DocumentAmount" became equal to "26 460,00"
		And I close all client application windows


Scenario: _0154113 check filling in and refilling Bank payment (transaction type Payment to the vendor)
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
			| 'Document' 	                | 'Amount'   | 'Company'      | 'Legal name'        | 'Partner'   |
			| '$$PurchaseInvoice30004$$'	| '4 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		And I go to line in "List" table
		| 'Document' 	                | 'Amount'    | 'Company'      | 'Legal name'        | 'Partner'   |
		| '$$PurchaseInvoice29604$$'	| '13 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
		And I click "Select" button
	* Check clearing basis document when clearing partner term
		And I select current line in "PaymentList" table
		And I click Clear button of "Partner term" field
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term' | 'Total amount'    | 'Payee'             | 'Basis document' |
			| 'Ferron BP' | ''             | '13 000,00'       | 'Company Ferron BP' | ''               |
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
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   | 'Payee'             |
			| 'Veritas'   | 'Company Veritas '  |
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '17,12'  |
		And I close current window		
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |		
		And I close current window	
	* Check the recalculation at the rate in case of date change
		And I move to "Other" tab
		And I input "01.11.2018  0:00:00" text in "Date" field
		And I move to "Payments" tab
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Ferron BP' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '100'    |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,2000' | '20,00'  |
		And I close current window	
		And I go to line in "PaymentList" table
			| 'Partner'   |
			| 'Veritas' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,2000' | '40,00'  |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
		And I close current window
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
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'  |
			| 'Bank account, TRY' |
		And I select current line in "List" table
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "180,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "430,00"
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I finish line editing in "PaymentList" table
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I activate "Payee" field in "PaymentList" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click "Select" button
		And the editing text of form attribute named "DocumentAmount" became equal to "13 430,00"		
	* Check the Total amount re-calculation when deleting rows
		And I go to line in "PaymentList" table
		| 'Total amount' |
		| '50,00'  |
		And I delete a line in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "13 380,00"
	* Check the Total amount calculation when adding rows
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "80,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And the editing text of form attribute named "DocumentAmount" became equal to "13 460,00"
	* Copy line and check Total amount calculation
		And I go to line in "PaymentList" table
			| 'Total amount'    | 'Partner'   | 'Partner term'       | 'Payee'             |
			| '13 000,00' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' |
		And I activate "Partner term" field in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListContextMenuCopy"
		And the editing text of form attribute named "DocumentAmount" became equal to "26 460,00"
		And I close all client application windows

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

Scenario: _0154115 check filling in and refilling Cash transfer order
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
	* Check filling in Amount in Receive amount from Send amount in the case of the same currencies
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
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description' |
			| 'First'       |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description' |
			| 'Second'       |
		And I select current line in "List" table
		Then the form attribute named "ReceivePeriod" became equal to "Second"
		Then the form attribute named "SendPeriod" became equal to "First"
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
			And I click the button named "EditCurrenciesSender"
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'USD'  | '1'            | '5,6275' | '562,75' |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'USD'  | '1'            | '1'      | '100'    |
			And I close current window
			And I click the button named "EditCurrenciesReceiver"
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '584'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '99,98'  |
			And I close all client application windows
	
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



Scenario: _0154116 check filling in and refilling Cash expence
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
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
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
		And I activate field named "PaymentListTaxAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "33,55" text in the field named "PaymentListTaxAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table	
		And I move to "Payment list" tab
		And "PaymentList" table contains lines
			| 'Net amount' | 'Expense type'               | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Telephone communications'   | 'TRY'      | '18%' | '33,55'      | '219,99'       |
	* Check the Net amount recalculation when Total amount changes and with changes in taxes
		And I input "220,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Profit loss center' | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '186,44'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,56'      | '220,00'       |
	* Check Dont calculate row
		And I activate "Dont calculate row" field in "PaymentList" table
		And I set "Dont calculate row" checkbox in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTaxAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "33,55" text in the field named "PaymentListTaxAmount" of "PaymentList" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "187,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "220,55" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Expense type'                     | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Telephone communications'         | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Check the currency form connection
		And in the table "PaymentList" I click "Edit currencies" button	
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '220,55' |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '37,76'  |
		And I close current window		
	* Add one more line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
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
		And I finish line editing in "PaymentList" table
	* Manual tax correction by line
		And I go to line in "PaymentList" table
			| 'Expense type' | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Software'     | '200,00'     | '36,00'      | '236,00'       | '18%' |
		And I select current line in "PaymentList" table
		And I input "38,00" text in the field named "PaymentListTaxAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table	
		And I move to "Payment list" tab
		And "PaymentList" table contains lines
			| 'Net amount' | 'Profit loss center'      | 'Expense type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,55'       |
			| '200,00'     | 'Front office'       | 'Software'                 | 'TRY'      | '18%' | '38,00'      | '238,00'       |
	* Delete a line and check the total amount conversion
		And I activate field named "PaymentListCurrency" in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Profit loss center' | 'Currency' | 'Expense type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
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
			| 'Net amount' | 'Profit loss center' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
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
			| 'Net amount' | 'Profit loss center' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'USD'      | '18%' | '38,00'      | '238,00'       |
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
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table contains lines
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '236'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '40,40'  |
			And I close current window
			And in the table "PaymentList" I click "Edit currencies" button
			And I activate "Amount" field in "CurrenciesTable" table
			And I select current line in "CurrenciesTable" table
			And I input "50,00" text in "Amount" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table		
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '236'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,2119' | '50,00'  |		
			And I close current window	
	* Add one more line with different cureency
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
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
			| 'Net amount' | 'Profit loss center'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'TRY'      | '18%' | '36,00'      | '236,00'       |
			| '100,00'     | 'Accountants office' | 'Software'     | 'USD'      | '0%'  | ''           | '100,00'       |
		And I go to line in "PaymentList" table
			| 'Net amount' | 'Profit loss center'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '100,00'     | 'Accountants office' | 'Software'     | 'USD'      | '0%'  | ''           | '100,00'       |
	* Check the addition of a line to the form by currency
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'USD'  | '1'            | '5,6275' | '562,75' |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'USD'  | '1'            | '1'      | '100'    |
		And I close current window
	* Change of currency on the first line and check of form on currencies
		And I go to line in "PaymentList" table
			| 'Net amount' | 'Profit loss center' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'TRY'      | '18%' | '36,00'      | '236,00'       |
		And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I go to line in "PaymentList" table
			| 'Net amount' | 'Profit loss center'      | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'USD'      | '18%' | '36,00'      | '236,00'       |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'   |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'USD'  | '1'            | '5,6275' | '1 328,09' |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'USD'  | '1'            | '1'      | '236'      |
		And I close current window
	* Manual correction of tax rate and check of tax calculations
		And I go to line in "PaymentList" table
			| 'Profit loss center' | 'Currency' | 'Expense type' | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Front office'       | 'USD'      | 'Software'     | '200,00'     | '36,00'      | '236,00'       | '18%' |
		And I select current line in "PaymentList" table
		And I select "8%" exact value from "VAT" drop-down list in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Net amount' | 'Profit loss center' | 'Expense type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '200,00'     | 'Front office'       | 'Software'     | 'USD'      | '8%'  | '16,00'      | '216,00'       |
	And I close all client application windows



Scenario: _0154117 check filling in and refilling Cash revenue
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
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
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
		And I activate field named "PaymentListTaxAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "33,55" text in the field named "PaymentListTaxAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
		| 'Net amount' | 'Revenue type'               | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '186,44'     | 'Telephone communications'   | 'TRY'      | '18%' | '33,55'      | '219,99'       |
	* Check Donr calculate row
		And I activate "Dont calculate row" field in "PaymentList" table
		And I set "Dont calculate row" checkbox in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "187,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTaxAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "33,55" text in the field named "PaymentListTaxAmount" of "PaymentList" table
		And I input "220,55" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
		| 'Net amount' | 'Profit loss center' | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
		| '187,00'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,55'       |
	* Check the currency form connection
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '220,55' |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '37,76'  |
		And I close current window
	* Add one more line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
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
		And I finish line editing in "PaymentList" table
	* Manual tax correction by line
		And I go to line in "PaymentList" table
			| 'Profit loss center' | 'Revenue type' |
			| 'Front office'       | 'Software'     |
		And I input "38,00" text in the field named "PaymentListTaxAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table	
		And I move to "Payment list" tab
		And "PaymentList" table contains lines
			| 'Net amount' | 'Profit loss center'      | 'Revenue type'             | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
			| '187,00'     | 'Accountants office' | 'Telephone communications' | 'TRY'      | '18%' | '33,55'      | '220,55'       |
			| '200,00'     | 'Front office'       | 'Software'                 | 'TRY'      | '18%' | '38,00'      | '238,00'       |
	* Delete a line and check the total amount conversion
		And I activate field named "PaymentListCurrency" in "PaymentList" table
		And I go to line in "PaymentList" table
			| 'Profit loss center'      | 'Currency' | 'Revenue type'             | 'Net amount' | 'Tax amount' | 'Total amount' | 'VAT' |
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
			| 'Net amount' | 'Profit loss center' | 'Revenue type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
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
			| 'Net amount' | 'Profit loss center' | 'Revenue type' | 'Currency' | 'VAT' | 'Tax amount' | 'Total amount' |
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
		| '#' | 'Partner'   | 'Total amount' | 'Amount exchange' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''             | ''                | ''                           |
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Partner term' | 'Total amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''             | ''             | ''      | ''               | ''                           |
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner' | 'Partner term' | 'Total amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''             | ''             | ''      | ''               | ''                           |
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
		| '#' | 'Partner'   | 'Total amount' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''             | ''                           |
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Partner term' | 'Total amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | 'Nicoletta' | ''             | ''             | ''      | ''               | ''                           |
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner' | 'Partner term' | 'Total amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''             | ''             | ''      | ''               | ''                           |
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
			| '#' | 'Total amount' | 'Amount exchange' | 'Planning transaction basis' |
			| '1' | ''             | ''                | ''                           |
		* Check filling in Transit account form Accountant
			Then the form attribute named "TransitAccount" became equal to "Transit Main"
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
			| '#' | 'Partner' | 'Partner term' | 'Total amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
			| '1' | ''        | ''             | ''             | ''      | ''               | ''                           |
		Then the form attribute named "TransitAccount" became equal to ""
	* Check clearing fields 'Partner' when re-selecting the type of operation to Cash transfer order
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
			| '#' | 'Partner' | 'Partner term' | 'Total amount' | 'Payer' | 'Basis document' | 'Planning transaction basis' |
			| '1' | ''        | ''             | ''             | ''      | ''               | ''                           |
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
		| '#' | 'Total amount' | 'Planning transaction basis' |
		| '1' | ''       | ''                          |
		* Check filling in Transit account from Accountant
			Then the form attribute named "TransitAccount" became equal to "Transit Main"
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And "PaymentList" table contains lines
		| '#' | 'Partner'   | 'Partner term' | 'Total amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
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
		| '#' | 'Partner' | 'Partner term' | 'Total amount' | 'Payee' | 'Basis document' | 'Planning transaction basis' |
		| '1' | ''        | ''          | ''       | ''      | ''               | ''                          |
		And I close all client application windows


Scenario: _0154122 check filling in and refilling Reconcilation statement
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
	* Check refilling when re-selecting a partner
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
	* Check refilling when re-selecting a currency
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
	* Check refilling when re-selecting a legal name (partner previous)
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
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number'                                  | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I go to line in "List" table
		| 'Number'                                  | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the selected document is in BankPayment
		And "PaymentList" table contains lines
		| 'Total amount' | 'Planning transaction basis'      |
		| '100,00'       | '$$CashTransferOrder01541003$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And I go to line in "List" table
		| 'Number'                                  | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when post Bank Payment
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And I go to line in "List" table
		| 'Number'                                  | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And I go to line in "List" table
		| 'Number'                                  | 'Sender'            | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'Main Company' | 'TRY'           |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
		| 'Total amount' | 'Planning transaction basis' |
		| '200,00'       | ''                          |
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
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the selected document is in BankPayment
		And "PaymentList" table contains lines
		| 'Total amount' | 'Planning transaction basis'    |
		| '100,00'       | '$$CashTransferOrder01541003$$' |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form (Bank Receipt posted)
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number'                              | 'Sender'            | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$' | 'Bank account, TRY' | 'TRY'           | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'            | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541003$$'     | 'Bank account, TRY' | 'TRY'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
		| 'Total amount' | 'Planning transaction basis' |
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
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the selected document is in Cash Payment
		And "PaymentList" table contains lines
		| 'Total amount' | 'Planning transaction basis' |
		| '100,00' | '$$CashTransferOrder01541002$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Cash Payment posted
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'       | 'Company'      | 'Send currency' |
		| '$$NumberCashTransferOrder01541002$$'     | 'Cash desk №2' | 'Main Company' | 'USD'           |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
		| 'Total amount' | 'Planning transaction basis' |
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
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
			| 'Number'                              | 'Sender'       | 'Send currency' | 'Company'      |
			| '$$NumberCashTransferOrder01541002$$' | 'Cash desk №2' | 'USD'           | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the selected document is in CashReceipt
		And "PaymentList" table contains lines
			| 'Total amount' | 'Planning transaction basis'    |
			| '100,00'       | '$$CashTransferOrder01541002$$' |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
			| 'Number'                              | 'Sender'       | 'Send currency' | 'Company'      |
			| '$$NumberCashTransferOrder01541002$$' | 'Cash desk №2' | 'USD'           | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Cash Receipt posted 
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number'                              | 'Sender'       | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541002$$' | 'Cash desk №2' | 'USD'           | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number'                              | 'Sender'       | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541002$$' | 'Cash desk №2' | 'USD'           | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
		| 'Total amount' | 'Planning transaction basis' |
		| '200,00'       | ''                           |
	And I close all client application windows

Scenario: _0154129 check the selection by Planing transaction basis in BankPayment in case of cash transfer
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
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
			| 'Number'                                  | 'Sender'              | 'Company'      | 'Send currency' |
			| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the selected document is in BankPayment
		And "PaymentList" table contains lines
			| 'Total amount' | 'Planning transaction basis'      |
			| '100,00'       | '$$CashTransferOrder01541004$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
			| 'Number'                                  | 'Sender'              | 'Company'      | 'Send currency' |
			| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Bank Payment posted
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
			| 'Number'                                  | 'Sender'              | 'Company'      | 'Send currency' |
			| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
			| 'Number'                                  | 'Sender'              | 'Company'      | 'Send currency' |
			| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'Main Company' | 'EUR'           |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
			| 'Total amount' | 'Planning transaction basis' |
			| '200,00'       | ''                          |
	And I close all client application windows

Scenario: _0154130 check the selection by Planing transaction basis in Bank Receipt in case of cash transfer
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
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number' | 'Sender'              | 'Send currency'    | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$'     | 'Bank account 2, EUR' | 'EUR'              | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
	* Check that the selected document is in BankReceipt
		And "PaymentList" table contains lines
		| 'Total amount' | 'Planning transaction basis' |
		| '100,00' | '$$CashTransferOrder01541004$$'   |
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number'                              | 'Sender'              | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$' | 'Bank account 2, EUR' | 'EUR'           | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that a document that is already selected is displayed in the Planning transaction basis selection form when Bank Receipt posted
		And I click the button named "FormPost"
		And I select current line in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number'                              | 'Sender'              | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$' | 'Bank account 2, EUR' | 'EUR'           | 'Main Company' |
		And I click the button named "FormChoose"
	* Check that the Planing transaction basis selection form displays the document that has already been selected earlier (line deleted)
		And I select current line in "PaymentList" table
		And in the table "PaymentList" I click "Delete" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I save number of "List" table lines as "Quantity"
		Then "Quantity" variable is equal to 1
		And "List" table contains lines
		| 'Number'                              | 'Sender'              | 'Send currency' | 'Company'      |
		| '$$NumberCashTransferOrder01541004$$' | 'Bank account 2, EUR' | 'EUR'           | 'Main Company' |
		And I click the button named "FormChoose"
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
		| 'Total amount' | 'Planning transaction basis' |
		| '200,00'       | ''                           |
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
			| '#' | 'Total amount' | 'Planning transaction basis' |
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
			And I input "200,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
	* Check form by currency
		* Basic recalculation at the rate
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |	
			And I close current window		
		* Recalculation of Rate presentation when changing Amount
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "35,00" text in "Amount" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1750' | '35,00'  |
			And I close current window			
		* Recount Amount when changing Multiplicity
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "2" text in "Multiplicity" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '2'            | '0,1712' | '17,12'  |
			And I close current window
		* Recount Amount when changing Multiplicity
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "0,1667" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1667' | '33,34'  |
			And I close current window
		* Recount Amount when changing payment amount
			And I input "250,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '250'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '42,80'  |
			And I close current window
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
			And I input "200,00" text in "Total amount" field of "PaymentList" table
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
			And I close current window		
		* Recount when currency changes
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			And I select current line in "List" table
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table contains lines
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'   |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'USD'  | '1'            | '5,6275' | '1 125,50' |
				| 'TRY'                | 'Partner term' | 'TRY' | 'USD'  | '1'            | '5,6275' | '1 125,50' |			
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
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |	
			And I close current window	
		* Recalculation of Rate presentation when changing Amount
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "35,00" text in "Amount" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1750' | '35,00'  |
			And I close current window			
		* Recount Amount when changing Multiplicity
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "2" text in "Multiplicity" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '2'            | '0,1712' | '17,12'  |
			And I close current window
		* Recount Amount when changing Multiplicity Rate presentation
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "0,1667" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1667' | '33,34'  |
			And I close current window
		* Recount Amount when changing payment amount
			And I input "250,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '250'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '42,80'  |
			And I close current window
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
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table contains lines
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |
			And I close current window
		* Recount when currency changes
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			And I select current line in "List" table
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table contains lines
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'   |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'USD'  | '1'            | '5,6275' | '1 125,50' |	
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
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |	
			And I close current window
		* Recalculation of Rate presentation when changing Amount
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "35,00" text in "Amount" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1750' | '35,00'  |
			And I close current window	
		* Recount Amount when changing Multiplicity
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "2" text in "Multiplicity" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '2'            | '0,1712' | '17,12'  |
			And I close current window
		* Recount Amount when changing Multiplicity Rate presentation
			And in the table "PaymentList" I click "Edit currencies" button
			And I input "0,1667" text in "Rate" field of "CurrenciesTable" table
			And I finish line editing in "CurrenciesTable" table
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '200'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1667' | '33,34'  |
			And I close current window
		* Recount Amount when changing payment amount
			And I input "250,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | '250'    |
				| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | '42,80'  |
			And I close current window
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
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table contains lines
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '34,24'  |
			And I close current window
		* Recount when currency changes
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       |
				| 'USD'      | 'Bank account, USD' |
			And I select current line in "List" table
			And in the table "PaymentList" I click "Edit currencies" button
			And "CurrenciesTable" table contains lines
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'   |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'USD'  | '1'            | '5,6275' | '1 125,50' |	
		# * Reverse rate display check 
		# 	Given double click at "reverse" picture
		# 	And I go to line in "PaymentList" table
		# 		| 'Amount' | 'Partner' | 'Payer'            |
		# 		| '200,00' | 'Veritas' | 'Company Veritas ' |
		# 	And "PaymentListCurrencies" table contains lines
		# 		| 'Movement type'  | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'   | 'Multiplicity' |
		# 		| 'Local currency' | 'Legal'     | 'USD'           | 'TRY'      | '5,6497'             | '1 129,94' | '1'            |
		And I close all client application windows


Scenario: _0154140 check filling in and refilling Sales order closing
	And I close all client application windows
	* Open the Sales order closing creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' |
				| 'Trousers' | '338,98' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Procurement method' | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | 'Stock'              | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | 'Stock'              | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Procurement method' | 'Tax amount'  | 'SalesTax'  | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
			Then "Update item list info" window is opened
			And I click "OK" button
		* Tax calculation check
			And "ItemList" table contains lines
				| 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Procurement method' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'Item key'  | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '38/Yellow' | '64,98'      | '1%'       | '1,000' | 'pcs'  | '335,02'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '38/Black'  | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | 'L/Green'   | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | 'XS/Blue'   | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an sales order closing
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
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '133,00'     | '2,000' | 'pcs'  | '700,00'     | '833,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | 'L/Green'  | '89,35'      | '1%'       | '1,000' | 'pcs'  | '460,65'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And I click "Save" button
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '303,02' |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '1 770'  |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '1 770'  |
			And I close current window			
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
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '113,71'     | '1%'       | '2,000' | 'pcs'  | '586,29'     | '700,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '5,45'       | '1%'       | '1,000' | 'pcs'  | '544,55'     | '550,00'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '84,47'      | '1%'       | '1,000' | 'pcs'  | '435,53'     | '520,00'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 566,37"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "203,63"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
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
					| 'Item'  | 'Item key' | 'Price'  | 'Quantity'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'SalesTax' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
					| '350,00' | 'Shirt' | '38/Black' | '7,00'       | '1%'       | '2,000' | 'pcs'  | '700,00'     | '707,00'       | 'Store 01' |
					| '550,00' | 'Dress' | 'L/Green'  | '104,50'     | '1%'       | '1,000' | 'pcs'  | '550,00'     | '654,50'       | 'Store 01' |
					| '520,00' | 'Dress' | 'XS/Blue'  | '98,80'      | '1%'       | '1,000' | 'pcs'  | '520,00'     | '618,80'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
				And I click "Post" button
				And I delete "$$NumberSalesOrder0154101$$" variable
				And I save the value of "Number" field as "$$NumberSalesOrder0154101$$"					
		* Cancel second line (Dress/L Green) and check totals
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key' |
				| 'Dress'    | 'L/Green'  |
			And I activate "Cancel" field in "ItemList" table
			And I set "Cancel" checkbox in "ItemList" table
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'not available'    |
			And I select current line in "List" table			
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "105,80"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 325,80"
			And Delay 2
		* Add new line with procurement Purchase and check totals
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
		* Delete line and check totals 
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And in the table "ItemList" I click "Delete" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "105,80"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 325,80"
		* Add new line with procurement No reserve and check totals
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "210,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 980,30"
			And I close all client application windows
			
Scenario: _0154141 check filling in and refilling Purchase order closing
	* Open the Purchase order closing creation form
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And Delay 2
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '*'      | '38/Yellow' | '1,000' |
			And Delay 2
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Quantity'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 03' |
				| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 03' |
				| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 03' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Quantity'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '126,00'     | 'pcs'  | '700,00'     | '826,00'       | 'Store 03' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '99,00'      | 'pcs'  | '550,00'     | '649,00'       | 'Store 03' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '93,60'      | 'pcs'  | '520,00'     | '613,60'       | 'Store 03' |
		* Check filling in currency tab
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'  |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '357,57'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '2 088,6' |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '2 088,6' |
			And I close current window
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
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | ''           | '1,000' | 'pcs'  | '550,00'     | '550,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 583,90"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "186,10"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
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
					| 'Item'  | 'Item key' | 'Price'  | 'Quantity'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
					| 'Price'  | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Net amount' | 'Total amount' |
					| '350,00' | 'Shirt' | '38/Black' | ''           | '2,000' | 'pcs'  | '700,00'     | '700,00'       |
					| '550,00' | 'Dress' | 'L/Green'  | '99,00'      | '1,000' | 'pcs'  | '550,00'     | '649,00'       |
					| '520,00' | 'Dress' | 'XS/Blue'  | '93,60'      | '1,000' | 'pcs'  | '520,00'     | '613,60'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
	* Check filling in Partner bank account
		And I move to "Other" tab
		And I click Select button of "Partner bank account" field
		And "List" table contains lines
			| 'Bank name' | 'Number'           | 'Currency' |
			| 'Bank name' | '56788888888888689' | 'EUR'      |
		Then the number of "List" table lines is "равно" "1"
		And I select current line in "List" table
		Then the form attribute named "PartnerBankAccount" became equal to "Partner bank account (Partner Kalipso)"
	* Cancel second line (Dress/L Green) and check totals
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key' |
				| 'Dress'    | 'L/Green'  |
			And I activate "Cancel" field in "ItemList" table
			And I set "Cancel" checkbox in "ItemList" table
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'not available'    |
			And I select current line in "List" table	
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "93,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 313,60"
		* Add new line and check totals
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
		* Delete line and check totals 
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XL/Green' |
			And I click "Delete" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "93,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 313,60"
		* Unchecking the cancellation checkbox and check totals	
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key' |
				| 'Dress'    | 'L/Green'  |
			And I activate "Cancel" field in "ItemList" table
			And I remove "Cancel" checkbox in "ItemList" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Purchase invoice bases on Purchase order
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'Basic Price Types' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I click the button named "FormPost"
		* Check filling the recalculation check box when creating Purchase return / Purchase return order bases on Purchase invoice
			And I click the button named "FormDocumentPurchaseReturnOrderGenerate"
			And I click "OK" button
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   |
			And I close current window
			And I click the button named "FormDocumentPurchaseReturnGenerate"
			And I click "OK" button
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     | 'Store 03' |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       | 'Store 03' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     | 'Store 03' |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     | 'Store 03' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I select "Approved" exact value from "Status" drop-down list				
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Purchase return bases on Purchase return order
		And I click the button named "FormDocumentPurchaseReturnGenerate"
		And I click "OK" button
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '129,95'     | '2,000' | 'pcs'  | 'No'                 | '670,05'     | '800,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I input "670,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Quantity'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Quantity'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "576,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '670,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "671,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 974,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00""
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "800,50" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '84,47'      | '435,53'     | '520,00'       |
		* Check calculation when remove "Price includes tax" checkbox
			And I move to "Other" tab
			And I remove checkbox "Price includes tax"	
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '98,80'      | '520,00'     | '618,80'       |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 941,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "750,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 691,80"
			And I click the button named "FormPostAndClose"
	* Check filling the recalculation check box when creating Sales invoice bases on Sales order
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '129,95'     | '2,000' | 'pcs'  | 'No'                 | '670,05'     | '800,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I input "670,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "801,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Quantity'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'VAT' | 'Item'     | 'Price'  | 'Item key'  | 'Price type'        | 'SalesTax' | 'Tax amount' | 'Quantity'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Net amount' | 'Total amount' | 'Store'    |
				| '18%' | 'Trousers' | '400,00' | '38/Yellow' | 'Basic Price Types' | '1%'       | '130,00'     | '2,000' | ''              | 'pcs'  | 'Yes'                | '670,00'     | '801,00'       | 'Store 01' |
				| '18%' | 'Dress'    | '550,00' | 'L/Green'   | 'Basic Price Types' | '1%'       | '446,72'     | '5,000' | ''              | 'pcs'  | 'No'                 | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "576,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '670,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 973,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "671,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '801,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 974,28"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "575,72"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 551,00""
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "800,50" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
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
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '446,72'     | '2 303,28'   | '2 750,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '84,47'      | '435,53'     | '520,00'       |
		* Check calculation when remove "Price includes tax" checkbox
			And I move to "Other" tab
			And I remove checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '1,000' | 'pcs'  | 'No'                 | '98,80'      | '520,00'     | '618,80'       |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 941,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "750,30"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 691,80"
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Sales return / Sales return order bases on Sales invoice
		And I click the button named "FormDocumentSalesReturnGenerate"
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'              	| '129,00'     | '671,00'     | '800,50'       |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '522,50'     | '2 750,00'   | '3 272,50'     |
		And I close current window
		And I click the button named "FormDocumentSalesReturnOrderGenerate"
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
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
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,00'     | '800,00'     | '944,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |	
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '150,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '801,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '951,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Quantity'     |
				| 'Trousers' | '38/Yellow' | '2,000' |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '187,20'     | '1 040,00'   | '1 227,20'     |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'Yes'                | '152,00'     | '800,00'     | '954,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
				| '520,00' | 'Dress'    | '18%' | 'M/White'   | '2,000' | 'pcs'  | 'No'                 | '158,64'     | '881,36'     | '1 040,00'     |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPost"
	* Check filling the recalculation check box when creating Sales return on Sales return order
		And I click the button named "FormDocumentSalesReturnGenerate"
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
		And I input "2,000" text in "Quantity" field of "ItemList" table
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
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Price type'              | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | ''              | 'en description is empty' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types'       | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Price type'              | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'en description is empty' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types'       | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Price type'              | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'en description is empty' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types'       | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I move to "More" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'              | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'en description is empty' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types'       | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'              | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'en description is empty' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types'       | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'              | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'en description is empty' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types'       | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
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
		And I input "2,000" text in "Quantity" field of "ItemList" table
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
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | ''              | 'en description is empty' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'en description is empty' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | ''              | 'en description is empty' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | ''              | 'Basic Price Types' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I move to "More" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'en description is empty' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'en description is empty' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |		 			
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | ''              | 'en description is empty' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
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
		And I input "2,000" text in "Quantity" field of "ItemList" table
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
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Offers amount' | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
		And I input "2,000" text in "Quantity" field of "ItemList" table
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
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
		And I input "2,000" text in "Quantity" field of "ItemList" table
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
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
		And I input "2,000" text in "Quantity" field of "ItemList" table
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
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '144,15'     | '800,85'     | '945,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,43' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,23'     | '1 201,29'   | '1 417,52'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '216,31'     | '1 201,69'   | '1 418,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '495,00'     | '2 750,00'   | '3 245,00'     |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,56' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,31'     | '1 018,37'   | '1 201,68'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '1 016,95'   | '1 200,00'     |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Quantity'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '2,000' | 'pcs'  | 'No'                 | '122,03'     | '677,97'     | '800,00'       |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '5,000' | 'pcs'  | 'No'                 | '419,49'     | '2 330,51'   | '2 750,00'     |
			And I close all client application windows			


Scenario: _0154167 check tax rate recalculation when change partner term (Purchase order)
	* Create PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"	
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Adel'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor, USD'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"
	* Check tax rate recalculation
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Price type'        | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity' | 'Unit' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' |
			| 'Basic Price Types' | 'Dress' | 'XS/Blue'  | ''           | '1,000'    | 'pcs'  | '89,02' | '0%'  | ''              | '89,02'      | '89,02'        |
		* Change partner term and update tax
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Vendor, TRY' |
			And I select current line in "List" table
			Then the form attribute named "TaxRates" became equal to "Yes"
			Then "Update item list info" window is opened
			And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Tax amount' | 'Quantity' | 'Unit' | 'VAT' | 'Net amount' | 'Total amount' |
			| 'Dress' | 'XS/Blue'  | '93,60'      | '1,000'    | 'pcs'  | '18%' | '520,00'     | '613,60'       |
		* Change partner term and not update tax
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Vendor, USD' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I change checkbox "Do you want to change tax rates according to the partner term?"
			And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Tax amount' | 'Quantity' | 'Unit' | 'VAT' | 'Net amount' | 'Total amount' |
			| 'Dress' | 'XS/Blue'  | '16,02'      | '1,000'    | 'pcs'  | '18%' | '89,02'      | '105,04'       |
		And I close all client application windows


Scenario: _0154168 check tax rate recalculation when change partner term (Purchase invoice)
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"	
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Adel'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Adel'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor, USD'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"
	* Check tax rate recalculation
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Price type'        | 'Item'  | 'Item key' | 'Tax amount' | 'Quantity' | 'Unit' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' |
			| 'Basic Price Types' | 'Dress' | 'XS/Blue'  | ''           | '1,000'    | 'pcs'  | '89,02' | '0%'  | ''              | '89,02'      | '89,02'        |
		* Change partner term and update tax
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Vendor, TRY' |
			And I select current line in "List" table
			Then the form attribute named "TaxRates" became equal to "Yes"
			Then "Update item list info" window is opened
			And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Tax amount' | 'Quantity'     | 'Unit' | 'VAT' | 'Net amount' | 'Total amount' |
			| 'Dress' | 'XS/Blue'  | '93,60'      | '1,000' | 'pcs'  | '18%' | '520,00'     | '613,60'       |
		* Change partner term and not update tax
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Vendor, USD' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I change checkbox "Do you want to change tax rates according to the partner term?"
			And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Tax amount' | 'Quantity' | 'Unit' | 'VAT' | 'Net amount' | 'Total amount' |
			| 'Dress' | 'XS/Blue'  | '16,02'      | '1,000'    | 'pcs'  | '18%' | '89,02'      | '105,04'       |
		And I close all client application windows		



Scenario: _0154170 select Partner items in the PO
	* Create PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"	
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor Ferron, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Select partner items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Partner item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Dress M/White Ferron' |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Partner item'         | 'Cancel' | 'Item key' | 'Price type'        | 'Item'  | 'Dont calculate row' | 'Quantity'     | 'Unit' | 'VAT' |
			| 'Dress M/White Ferron' | 'No'     | 'M/White'  | 'Vendor price, TRY' | 'Dress' | 'No'                 | '1,000' | 'pcs'  | '18%' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "xs" from "Partner item" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Partner item'         | 'Cancel' | 'Item key' | 'Price type'        | 'Item'  | 'Dont calculate row' | 'Quantity'     | 'Unit' | 'VAT' |
			| 'Dress M/White Ferron' | 'No'     | 'M/White'  | 'Vendor price, TRY' | 'Dress' | 'No'                 | '1,000' | 'pcs'  | '18%' |
			| 'Dress XS/Blue Ferron' | 'No'     | 'XS/Blue'  | 'Vendor price, TRY' | 'Dress' | 'No'                 | '1,000' | 'pcs'  | '18%' |
	And I close all client application windows
	

		

Scenario: _0154171 select Partner items in the SO
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"	
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'         |
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
	* Select partner items
		And in the table "ItemList" I click the button named "ItemListAdd"	
		And I click choice button of "Partner item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Dress M/White Ferron' |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'SalesTax' | 'Partner item'         | 'Cancel' | 'Procurement method' | 'Item key' | 'Item'  | 'Price type'        | 'Dont calculate row' | 'Quantity'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    |
			| '1%'       | 'Dress M/White Ferron' | 'No'     | 'Stock'              | 'M/White'  | 'Dress' | 'Basic Price Types' | 'No'                 | '1,000' | 'pcs'  | '84,47'      | '520,00' | '18%' | '435,53'     | '520,00'       | 'Store 01' |
		And in the table "ItemList" I click the button named "ItemListAdd"	
		And I select "xs" from "Partner item" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'SalesTax' | 'Partner item'         | 'Cancel' | 'Procurement method' | 'Item key' | 'Item'  | 'Price type'        | 'Dont calculate row' | 'Quantity'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    |
			| '1%'       | 'Dress M/White Ferron' | 'No'     | 'Stock'              | 'M/White'  | 'Dress' | 'Basic Price Types' | 'No'                 | '1,000' | 'pcs'  | '84,47'      | '520,00' | '18%' | '435,53'     | '520,00'       | 'Store 01' |
			| '1%'       | 'Dress XS/Blue Ferron' | 'No'     | 'Stock'              | 'XS/Blue'  | 'Dress' | 'Basic Price Types' | 'No'                 | '1,000' | 'pcs'  | '84,47'      | '520,00' | '18%' | '435,53'     | '520,00'       | 'Store 01' |
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
	
Scenario: _0154181 additional tables
	And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		And I go to line in "List" table
			| "Number" |
			| "$$NumberSalesInvoice024025$$" |
		And I select current line in "List" table
	* Check additional tables
		And I click "Show hidden tables" button					
		And I expand "RowIDInfo [1]" group
		And I move to "RowIDInfo [1]" tab
		And I activate "Next step" field in "RowIDInfo" table
		And I select current line in "RowIDInfo" table
		And I input "" text in "Next step" field of "RowIDInfo" table
		And I finish line editing in "RowIDInfo" table
		And I click "Save" button
		And I close "Edit hidden tables" window
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| 'Next step' |
			| ''          |
		And I close all client application windows

Scenario: _0154182 check price recalculaton in the PO (depend of currency)
	* Create PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"	
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor DFC'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Add item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
	* Check price
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Price'  |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '520,00' |
	* Change document currency and check price recalculaton
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '1,000'    | 'pcs'  | '16,02'      | '89,02' | '18%' | ''              | '89,02'      | '105,04'       | 'Store 03' |
	* Add nes item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '16,02'      | '89,02' | '18%' | ''              | '89,02'      | '105,04'       | 'Store 03' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '12,33'      | '68,48' | '18%' | ''              | '68,48'      | '80,81'        | 'Store 03' |
	* Chenge date and check price recalculation
		And I move to "Other" tab
		And I input "20.06.2019 00:00:00" text in the field named "Date"
		And I move to "Item list" tab
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Price'  | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '104,00' | '104,00'     | '104,00'       | 'Store 03' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '80,00'  | '80,00'      | '80,00'        | 'Store 03' |
		And I close all client application windows
		
Scenario: _0154183 check price recalculaton in the PI (depend of currency)
		And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"	
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor DFC'         |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'         |
		And I select current line in "List" table
	* Add item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
	* Check price
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Price'  |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '520,00' |
	* Change document currency and check price recalculaton
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '1,000'    | 'pcs'  | '16,02'      | '89,02' | '18%' | ''              | '89,02'      | '105,04'       | 'Store 03' |
	* Add nes item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '16,02'      | '89,02' | '18%' | ''              | '89,02'      | '105,04'       | 'Store 03' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '12,33'      | '68,48' | '18%' | ''              | '68,48'      | '80,81'        | 'Store 03' |
	* Chenge date and check price recalculation
		And I move to "Other" tab
		And I input "20.06.2019 00:00:00" text in the field named "Date"
		And I move to "Item list" tab
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Price'  | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '104,00' | '104,00'     | '104,00'       | 'Store 03' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '80,00'  | '80,00'      | '80,00'        | 'Store 03' |
		And I close all client application windows	
				
	
Scenario: _0154184 check price recalculaton in the SO (depend of currency)
		And I close all client application windows
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"	
		And I click the button named "FormCreate"
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
	* Add item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
	* Check price
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Price'  |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '520,00' |
	* Change document currency and check price recalculaton
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '1,000'    | 'pcs'  | '14,46'      | '89,02' | '18%' | ''              | '74,56'      | '89,02'        | 'Store 01' |
	* Add nes item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '14,46'      | '89,02' | '18%' | ''              | '74,56'      | '89,02'       | 'Store 01' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '11,13'      | '68,48' | '18%' | ''              | '57,35'      | '68,48'        | 'Store 01' |
	* Chenge date and check price recalculation
		And I move to "Other" tab
		And I input "20.06.2019 00:00:00" text in the field named "Date"
		And I move to "Item list" tab
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Price'  | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '104,00' | '104,00'     | '104,00'       | 'Store 01' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '80,00'  | '80,00'      | '80,00'        | 'Store 01' |
		And I close all client application windows		
					
	
Scenario: _0154185 check price recalculaton in the SI (depend of currency)
		And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		And I click the button named "FormCreate"
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
	* Add item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
	* Check price
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Price'  |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '520,00' |
	* Change document currency and check price recalculaton
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '1,000'    | 'pcs'  | '14,46'      | '89,02' | '18%' | ''              | '74,56'      | '89,02'        | 'Store 01' |
	* Add nes item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '14,46'      | '89,02' | '18%' | ''              | '74,56'      | '89,02'       | 'Store 01' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '11,13'      | '68,48' | '18%' | ''              | '57,35'      | '68,48'        | 'Store 01' |
	* Chenge date and check price recalculation
		And I move to "Other" tab
		And I input "20.06.2019 00:00:00" text in the field named "Date"
		And I move to "Item list" tab
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Price'  | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '104,00' | '104,00'     | '104,00'       | 'Store 01' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '80,00'  | '80,00'      | '80,00'        | 'Store 01' |
		And I close all client application windows						
		

Scenario: _0154186 check price recalculaton in the RSR (depend of currency)
		And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
		And I click the button named "FormCreate"
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
	* Add item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
	* Check price
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Price'  |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '520,00' |
	* Change document currency and check price recalculaton
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And "ItemList" table contains lines
			| 'Item key' | 'Price type'        | 'Item'  | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'  | 'Basic Price Types' | 'Dress' | '1,000'    | 'pcs'  | '13,58'      | '89,02' | '18%' | ''              | '75,44'      | '89,02'        | 'Store 01' |
	* Add new item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Tax amount' | 'Price' | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '13,58'      | '89,02' | '18%' | ''              | '75,44'      | '89,02'       | 'Store 01' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '10,45'      | '68,48' | '18%' | ''              | '58,03'      | '68,48'        | 'Store 01' |
	* Chenge date and check price recalculation
		And I move to "Other" tab
		And I input "20.06.2019 00:00:00" text in the field named "Date"
		And I move to "Item list" tab
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item key'  | 'Price type'        | 'Item'     | 'Quantity' | 'Unit' | 'Price'  | 'Net amount' | 'Total amount' | 'Store'    |
			| 'XS/Blue'   | 'Basic Price Types' | 'Dress'    | '1,000'    | 'pcs'  | '104,00' | '104,00'     | '104,00'       | 'Store 01' |
			| '38/Yellow' | 'Basic Price Types' | 'Trousers' | '1,000'    | 'pcs'  | '80,00'  | '80,00'      | '80,00'        | 'Store 01' |
		And I close all client application windows					
		
				
Scenario: _0154187 check edit currency in the StockAdjustmentAsSurplus
	And I close all client application windows
	* Create StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"	
		And I click the button named "FormCreate"	
	* Filling
		And I click Choice button of the field named "Company"
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I activate field named "ItemListItem" in "ItemList" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListItem" in "ItemList" table
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
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate "Profit loss center" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Revenue type" field in "ItemList" table
		And I click choice button of "Revenue type" attribute in "ItemList" table
		Then "Expense and revenue types" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Revenue'     |
		And I select current line in "List" table
		And I activate "Amount" field in "ItemList" table
		And I input "100,00" text in "Amount" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change unit
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'box Dress (8 pcs)' |
		And I select current line in "List" table
	* Check
		And "ItemList" table became equal
			| '#' | 'Revenue type' | 'Amount' | 'Item'  | 'Basis document' | 'Item key' | 'Profit loss center'      | 'Physical inventory' | 'Serial lot numbers' | 'Unit'              | 'Quantity' |
			| '1' | 'Revenue'      | '100,00' | 'Dress' | ''               | 'XS/Blue'  | 'Distribution department' | ''                   | ''                   | 'box Dress (8 pcs)' | '1,000'    |
	* Edit currency
		And in the table "ItemList" I click "Edit currencies" button
		Then "Edit currencies" window is opened
		And I activate "Rate" field in "CurrenciesTable" table
		And I select current line in "CurrenciesTable" table
		And I input "0,2000" text in "Rate" field of "CurrenciesTable" table
		And I finish line editing in "CurrenciesTable" table
		And I go to line in "CurrenciesTable" table
			| 'Movement type'         | 'Multiplicity' | 'To'  | 'Type'      |
			| 'Reporting currency UA' | '1'            | 'EUR' | 'Reporting' |
		And I select current line in "CurrenciesTable" table
		And I input "0,3000" text in "Rate" field of "CurrenciesTable" table
		And I finish line editing in "CurrenciesTable" table
	* Check
		And "CurrenciesTable" table became equal
			| 'Movement type'         | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency UA'     | 'Legal'     | 'UAH' | ''     | '1'            | '0,2000' | '20,00'  |
			| 'Reporting currency UA' | 'Reporting' | 'EUR' | ''     | '1'            | '0,3000' | '30,00'  |
		And I click "Ok" button
		And I close all client application windows
		

Scenario: _0154188 check edit currency in the StockAdjustmentAsWriteOff
	And I close all client application windows
	* Create StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"	
		And I click the button named "FormCreate"	
	* Filling
		And I click Choice button of the field named "Company"
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I activate field named "ItemListItem" in "ItemList" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListItem" in "ItemList" table
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
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate "Profit loss center" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Expense type" field in "ItemList" table
		And I click choice button of "Expense type" attribute in "ItemList" table
		Then "Expense and revenue types" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Expense'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Change unit
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'box Dress (8 pcs)' |
		And I select current line in "List" table
	* Check
		And "ItemList" table became equal
			| '#' | 'Expense type' | 'Item'  | 'Basis document' | 'Item key' | 'Profit loss center'      | 'Physical inventory' | 'Serial lot numbers' | 'Unit'              | 'Quantity' |
			| '1' | 'Expense'      | 'Dress' | ''               | 'XS/Blue'  | 'Distribution department' | ''                   | ''                   | 'box Dress (8 pcs)' | '1,000'    |
	* Edit currency
		And in the table "ItemList" I click "Edit currencies" button
		Then "Edit currencies" window is opened
		And I activate "Rate" field in "CurrenciesTable" table
		And I select current line in "CurrenciesTable" table
		And I input "0,2000" text in "Rate" field of "CurrenciesTable" table
		And I finish line editing in "CurrenciesTable" table
		And I go to line in "CurrenciesTable" table
			| 'Movement type'         | 'Multiplicity' | 'To'  | 'Type'      |
			| 'Reporting currency UA' | '1'            | 'EUR' | 'Reporting' |
		And I select current line in "CurrenciesTable" table
		And I input "0,3000" text in "Rate" field of "CurrenciesTable" table
		And I finish line editing in "CurrenciesTable" table
	* Check
		And "CurrenciesTable" table became equal
			| 'Movement type'         | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency UA'     | 'Legal'     | 'UAH' | ''     | '1'            | '0,2000' | ''       |
			| 'Reporting currency UA' | 'Reporting' | 'EUR' | ''     | '1'            | '0,3000' | ''       |
		And I click "Ok" button
		And I close all client application windows				
		

Scenario: _0154189 check filling in and refilling Work order
	And I close all client application windows
	* Open the Work order creation form
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
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
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Installation'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'         | 'Item key'     | 'Unit' | 'Quantity'     |
			| 'Installation' | 'Installation' | 'pcs'  | '1,000'        |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Delivery'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Delivery' | 'Delivery'  |
			And I select current line in "List" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price' | 'Item key' | 'Quantity' | 'Unit' |
				| 'Delivery' | '80,00' | 'Delivery' | '1,000'    | 'pcs'  |
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key' | 'Quantity' | 'Unit' | 'VAT' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| 'Delivery' | '110,00' | 'Delivery' | '1,000'    | 'pcs'  | '18%' | '16,78'      | '93,22'      | '110,00'       |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Assembly'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key' |
				| 'Assembly' | 'Assembly' |
			And I select current line in "List" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table became equal
				| 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order' |
				| 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | '16,78'      | '1,000'    | '110,00' | '18%' | ''              | '93,22'      | '110,00'       | ''            |
				| 'Assembly' | 'Basic Price Types' | 'Assembly' | 'Assembly'          | 'pcs'  | 'No'                 | '36,61'      | '2,000'    | '120,00' | '18%' | ''              | '203,39'     | '240,00'       | ''            |			
	* Check the re-drawing of the form for taxes at company re-selection.
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
			Then "Update item list info" window is opened
			And I click "OK" button
		* Tax calculation check
			And "ItemList" table contains lines
				| 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order' |
				| 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | '16,78'      | '1,000'    | '110,00' | '18%' | ''              | '93,22'      | '110,00'       | ''            |
				| 'Assembly' | 'Basic Price Types' | 'Assembly' | 'Assembly'          | 'pcs'  | 'No'                 | '36,61'      | '2,000'    | '120,00' | '18%' | ''              | '203,39'     | '240,00'       | ''            |			
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Assembly' | 'Assembly' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'     | 'Item key' |
			| 'Assembly' | 'Assembly' |
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "16,78"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "93,22"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "110,00"
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I remove checkbox "Price include tax"
		* Tax recalculation check
			And I move to "Works" tab
			And "ItemList" table became equal
				| '#' | 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order' |
				| '1' | 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | '19,80'      | '1,000'    | '110,00' | '18%' | ''              | '110,00'     | '129,80'       | ''            |			
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I set checkbox "Price include tax"
			And I move to "Works" tab
			And "ItemList" table became equal
				| '#' | 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order' |
				| '1' | 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | '16,78'      | '1,000'    | '110,00' | '18%' | ''              | '93,22'      | '110,00'       | ''            |			
		* Check filling in currency tab
			And I click "Save" button
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '18,83'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '110'    |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '110'    |			
			And I close current window	
		* Check recalculate Total amount and Net amount when change Tax rate
			* Price includes tax
				And I move to "Works" tab
				And I go to line in "ItemList" table
					| 'Item'     | 'Item key' |
					| 'Delivery' | 'Delivery'  |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table became equal
					| '#' | 'Item'     | 'Price type'        | 'Item key' | 'Bill of materials' | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order' |
					| '1' | 'Delivery' | 'Basic Price Types' | 'Delivery' | ''                  | 'pcs'  | 'No'                 | ''           | '1,000'    | '110,00' | '0%'  | ''              | '110,00'     | '110,00'       | ''            |				
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "110,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "0,00"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "110,00"
		* Add new line and check totals
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Installation' |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'         | 'Item key'     |
				| 'Installation' | 'Installation' |
			And I select current line in "List" table
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Installation' |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'         | 'Item key'     |
				| 'Installation' | 'Installation' |	
			And I select current line in "List" table
			Then the form attribute named "ItemListTotalNetAmount" became equal to "279,50"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "30,50"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "310,00"
		* Delete line and check totals 
			And I go to line in "ItemList" table
				| 'Item'         | 'Item key'     |
				| 'Installation' | 'Installation' |
			And in the table "ItemList" I click "Delete" button
			Then the form attribute named "ItemListTotalNetAmount" became equal to "194,75"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "15,25"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "210,00"
		* Change materials
			And I go to line in "ItemList" table
				| 'Item'         | 'Item key'     |
				| 'Installation' | 'Installation' |
			And I select current line in "ItemList" table
			And I click choice button of "Bill of materials" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'Furniture installation' |
			And I select current line in "List" table
			And I go to line in "Materials" table
				| 'Item'       | 'Item key'   |
				| 'Material 2' | 'Material 2' |
			And I activate "Procurement method" field in "Materials" table
			And I select current line in "Materials" table
			And I select "No reserve" exact value from "Procurement method" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| 'Item'       | 'Item key'   |
				| 'Material 3' | 'Material 3' |
			And I select current line in "Materials" table
			And I click choice button of "Store" attribute in "Materials" table
			Then "Stores" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| 'Item'       | 'Item key'   |
				| 'Material 1' | 'Material 1' |
			And I select current line in "Materials" table
			And I input "3,000" text in "Quantity" field of "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| 'Item'       | 'Item key'   |
				| 'Material 2' | 'Material 2' |
		* Check materials
			And "Materials" table became equal
				| '#' | 'Cost write off'       | 'Item'       | 'Item key'   | 'Procurement method' | 'Unit' | 'Store'    | 'Quantity' |
				| '1' | 'Include to work cost' | 'Material 1' | 'Material 1' | 'Stock'              | 'pcs'  | 'Store 01' | '3,000'    |
				| '2' | 'Include to work cost' | 'Material 2' | 'Material 2' | 'No reserve'         | 'pcs'  | 'Store 01' | '4,000'    |
				| '3' | 'Include to work cost' | 'Material 3' | 'Material 3' | 'Stock'              | 'kg'   | 'Store 02' | '1,521'    |
			And I click "Post" button
			And I delete "$$NumberWorkOrder1$$" variable
			And I save the value of "Number" field as "$$NumberWorkOrder1$$"
			And I click "Post and close" button
		* Reopen and check document
			Given I open hyperlink "e1cib/list/Document.WorkOrder"
			And I go to line in "List" table
				| 'Number'               |
				| '$$NumberWorkOrder1$$' |
			And I select current line in "List" table
			Then the form attribute named "Partner" became equal to "Kalipso"
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
			Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
			Then the form attribute named "Status" became equal to "Wait"
			Then the form attribute named "Company" became equal to "Main Company"
			And "ItemList" table became equal
				| '#' | 'Item'         | 'Price type'        | 'Item key'     | 'Bill of materials'      | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Sales order' |
				| '1' | 'Delivery'     | 'Basic Price Types' | 'Delivery'     | ''                       | 'pcs'  | 'No'                 | ''           | '1,000'    | '110,00' | '0%'  | ''              | '110,00'     | '110,00'       | ''            |
				| '2' | 'Installation' | 'Basic Price Types' | 'Installation' | 'Furniture installation' | 'pcs'  | 'No'                 | '15,25'      | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''            |
			
			And "Materials" table became equal
				| '#' | 'Cost write off'       | 'Item'       | 'Item key'   | 'Procurement method' | 'Unit' | 'Store'    | 'Quantity' |
				| '1' | 'Include to work cost' | 'Material 1' | 'Material 1' | 'Stock'              | 'pcs'  | 'Store 01' | '3'        |
				| '2' | 'Include to work cost' | 'Material 2' | 'Material 2' | 'No reserve'         | 'pcs'  | 'Store 01' | '4'        |
				| '3' | 'Include to work cost' | 'Material 3' | 'Material 3' | 'Stock'              | 'kg'   | 'Store 02' | '1,521'    |
			Then the form attribute named "Currency" became equal to "TRY"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "194,75"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "15,25"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "210,00"
			Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
			And I close all client application windows
			

Scenario: _0154190 check filling in and refilling Work sheet
	And I close all client application windows
	* Open the Work sheet creation form
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company NDB"
	* Check clearing legal name when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
		* Check filling in legal name after re-selection partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
	* Add works and materials
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I activate field named "MaterialsLineNumber" in "Materials" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Assembly'    |
		And I select current line in "List" table
		And I activate field named "ItemListBillOfMaterials" in "ItemList" table
		And I click choice button of the attribute named "ItemListBillOfMaterials" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Assembly'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change materials
		And I go to line in "Materials" table
			| 'Item'       | 'Item key'   |
			| 'Material 2' | 'Material 2' |
		And I select current line in "Materials" table
		And I input "3,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
		And I go to line in "Materials" table
			| 'Item'       | 'Item key'   |
			| 'Material 1' | 'Material 1' |
		And I activate "Profit loss center" field in "Materials" table
		And I select current line in "Materials" table
		And I click choice button of "Profit loss center" attribute in "Materials" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I finish line editing in "Materials" table
		And I go to line in "Materials" table
			| 'Item'       | 'Item key'   |
			| 'Material 2' | 'Material 2' |
		And I select current line in "Materials" table
		And I click choice button of "Expense type" attribute in "Materials" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'    |
		And I select current line in "List" table
		And I finish line editing in "Materials" table
	* Currency form
		And I move to "Other" tab
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'      | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Local currency'     | 'Legal'     | 'TRY' | 'TRY'  | '1'            | '1'      | ''       |
			| 'Reporting currency' | 'Reporting' | 'USD' | 'TRY'  | '1'            | '0,1712' | ''       |
		And I close current window
	* Reopen document	
		And I click "Post" button
		And I delete "$$NumberWorkSheet1$$" variable
		And I save the value of "Number" field as "$$NumberWorkSheet1$$"
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'               |
			| '$$NumberWorkSheet1$$' |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		And "ItemList" table became equal
			| '#' | 'Item'     | 'Item key' | 'Bill of materials' | 'Unit' | 'Quantity' | 'Sales invoice' | 'Sales order' | 'Work order' |
			| '1' | 'Delivery' | 'Delivery' | ''                  | 'pcs'  | '1,000'    | ''              | ''            | ''           |
			| '2' | 'Assembly' | 'Assembly' | 'Assembly'          | 'pcs'  | '1,000'    | ''              | ''            | ''           |
		
		And "Materials" table became equal
			| '#' | 'Cost write off'       | 'Item (BOM)' | 'Item key'   | 'Profit loss center' | 'Item key (BOM)' | 'Unit (BOM)' | 'Quantity (BOM)' | 'Store'    | 'Item'       | 'Unit' | 'Quantity' | 'Expense type' |
			| '1' | 'Include to work cost' | 'Material 1' | 'Material 1' | 'Front office'       | 'Material 1'     | 'pcs'        | '2'              | 'Store 01' | 'Material 1' | 'pcs'  | '2'        | 'Expense'      |
			| '2' | 'Include to work cost' | 'Material 2' | 'Material 2' | 'Workshop 1'         | 'Material 2'     | 'pcs'        | '2'              | 'Store 01' | 'Material 2' | 'pcs'  | '3'        | 'Delivery'     |
		Then the form attribute named "Currency" became equal to "TRY"
		And I close all client application windows
		
				
				
				

		
						
			
						
			
						
						
						

	
