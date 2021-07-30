#language: en
@tree
@Positive
@RetailDocuments

Feature: check filling in retail documents + currency form connection



Background:
	Given I launch TestClient opening script or connect the existing one





		
Scenario: _0154100 preparation ( filling documents)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create catalog Users objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail document)
		When Create catalog ExpenseAndRevenueTypes objects
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When Create catalog RetailCustomers objects (check POS)
	* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Taxes"
		And I go to line in "List" table
			| 'Description' |
			| 'VAT'         |
		And I select current line in "List" table
		And I move to "Use documents" tab
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Retail sales receipt" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And I go to line in "UseDocuments" table
			| 'Document name'      |
			| 'RetailSalesReceipt' |
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Retail return receipt" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And I click "Save and close" button
	* Create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And I input "Payment terminal 01" text in the field named "Description_en"
		And I click Select button of "Account" field
		Then "Cash/Bank accounts" window is opened
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I input "1,00" text in "Percent" field
		And I click "Save and close" button
	* Create PaymentTypes
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		And I click the button named "FormCreate"
		And I input "Cash" text in the field named "Description_en"
		And I select "Cash" exact value from "Type" drop-down list
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Card 01" text in the field named "Description_en"
		And I select "Card" exact value from "Type" drop-down list
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Card 02" text in the field named "Description_en"
		And I select "Card" exact value from "Type" drop-down list
		And I click "Save and close" button
	* Bank terms
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And I input "Bank term 01" text in "ENG" field
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "1,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 02'     |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Transit Second' |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "2,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And I click "Save" button
		And In this window I click command interface button "Branch bank terms"
		And I click the button named "FormCreate"
		Then "Branch bank terms (create)" window is opened
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I click Select button of "Bank term" field
		Then "Bank terms" window is opened
		And I select current line in "List" table
		And I click "Save and close" button			
	* Workstation
		When create Workstation
	
	

Scenario: _0154135 create document Retail Sales Receipt
	And I close all client application windows
	* Open the Retail Sales Receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail customer'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
	* Check filling in Partner term if the partner has only one
		Then the form attribute named "Agreement" became equal to "Retail partner term"
	* Check filling in Store from Partner term
		Then the form attribute named "Store" became equal to "Store 01"
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 01' |
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
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  |
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
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And in the table "ItemList" I click "SearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 4
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '61,02'      | '1,000' | 'pcs'  | '338,98'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '83,90'      | '1,000' | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' |
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
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '61,02'      | '1,000' | 'pcs'  | '338,98'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '83,90'      | '1,000' | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '126,00'     | '2,000' | 'pcs'  | '700,00'     | '826,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '99,00'      | '1,000' | 'pcs'  | '550,00'     | '649,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '93,60'      | '1,000' | 'pcs'  | '520,00'     | '613,60'       | 'Store 01' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '83,90'      | '1,000' | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And I click "Save" button
			And I move to the tab named "GroupCurrencies"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '0,1712'            | '303,02' | '1'            |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 290,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I delete "$$NumberRetailSalesReceipt0154135$$" variable
			And I delete "$$RetailSalesReceipt015413$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt0154135$$"
			And I click the button named "FormPost"
			And I save the window as "$$RetailSalesReceipt015413$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt0154135$$'      |
			And I close all client application windows


			
						


Scenario: _0154136 create document Retail Return Receipt based on RetailSalesReceipt
	* Select Retail sales receipt for Retail Return Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt0154135$$'      |
	* Create Retail Return Receipt
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
		And I click "Ok" button		
	* Check filling in
		Then the form attribute named "DecorationGroupTitleCollapsedPicture" became equal to "Decoration group title collapsed picture"
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Partner: Retail customer   Legal name: Company Retail customer   Partner term: Retail partner term   "
		Then the form attribute named "DecorationGroupTitleUncollapsedPicture" became equal to "DecorationGroupTitleUncollapsedPicture"
		Then the form attribute named "DecorationGroupTitleUncollapsedLabel" became equal to "Company: Main Company   Partner: Retail customer   Legal name: Company Retail customer   Partner term: Retail partner term   "
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Retail sales receipt'         |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | ''              | '106,78'     | 'pcs'  | '593,22'     | '700,00'        | 'Store 01' | '$$RetailSalesReceipt015413$$' |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | ''              | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | ''              | '79,32'      | 'pcs'  | '440,68'     | '520,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "1 500,00"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "270,00"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
		Then the form attribute named "Currency" became equal to "TRY"
	* Check filling in Payments type from Retail sales receipt
		And I move to "Payments" tab
		And I select current line in "Payments" table
		And I input "900,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I activate "Commission" field in "Payments" table
		And I select current line in "Payments" table
		And I input "9,00" text in "Commission" field of "Payments" table
		And I finish line editing in "Payments" table	
		And "Payments" table became equal
			| 'Payment type' | 'Payment terminal'    | 'Account'      | 'Commission' | 'Amount'   | 'Percent' |
			| 'Card 01'      | 'Payment terminal 01' | 'Transit Main' | '9,00'      | '900,00' | '1,00'    |
	* Change quantity and post document
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
			| 'Shirt' | '38/Black' | '350,00' | '2,000' |
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
			| 'Dress' | 'XS/Blue'  | '520,00' | '1,000' |
		And I delete a line in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Retail sales receipt'         |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '1,000' | ''              | '53,39'      | 'pcs'  | '296,61'     | '350,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | ''              | '83,90'      | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
		And I move to "Other" tab
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Shop 01' |
		And I select current line in "List" table
	* Post Retail return receipt
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt0154136$$" variable
		And I delete "$$RetailReturnReceipt0154136$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt0154136$$"
		And I save the window as "$$RetailReturnReceipt0154136$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And "List" table contains lines
		| 'Number' |
		| '$$NumberRetailReturnReceipt0154136$$'      |
		And I close all client application windows
	
		




Scenario: _0154137 create document Retail Sales Receipt from Point of sale (payment by cash)
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Quantity'  | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'     | '550,00' | ''              | '550,00'       |
	* Add product (pick up)
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table became equal
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		Then the form attribute named "ItemListTotalQuantity" became equal to "2"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "950"
	* Change quantity and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity'  | 'Total amount' |
			| 'Dress' | 'L/Green'  | '550,00' | '1,000'     | '550,00'       |
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalQuantity" became equal to "4"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "2 050"
		And Delay 2
	* Payment (Cash)
		And I click "Payment (+)" button
		And I click "2" button
		And I click "0" button
		And I click "5" button
		And I click "1" button
		Then the form attribute named "Amount" became equal to "2 050"
		Then the form attribute named "DecorationAmountAfter" became equal to "Decoration amount after"
		And "Payments" table became equal
			| 'Payment type' | 'Amount'   |
			| 'Cash'         | '2 051,00' |
		Then the form attribute named "Cashback" became equal to "1"
		And I click "Enter" button
		And "ItemList" table does not contain lines
			| 'Item'     | 'Item key'  | 'Quantity'  | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'     | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'     | '400,00' | ''              | '400,00'       |
		And I close current window
		And Delay 2
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Profit loss center' | 'Revenue type' | 'Item'     | 'Price type'        | 'Item key'  | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' |
			| 'Shop 01'       | ''             | 'Dress'    | 'Basic Price Types' | 'L/Green'   | '3,000' | 'pcs'  | '251,69'     | '550,00' | '18%' | ''              | '1 398,31'   | '1 650,00'     | ''                    | 'Store 01' | ''       |
			| 'Shop 01'       | ''             | 'Trousers' | 'Basic Price Types' | '38/Yellow' | '1,000' | 'pcs'  | '61,02'      | '400,00' | '18%' | ''              | '338,98'     | '400,00'       | ''                    | 'Store 01' | ''       |
		And "Payments" table contains lines
			| 'Payment type' | 'Payment terminal' | 'Bank term' | 'Amount'   | 'Account'      | 'Commission' | 'Percent' |
			| 'Cash'         | ''                 | ''          | '2 051,00' | 'Cash desk №2' | ''           | ''        |
			| 'Cash'         | ''                 | ''          | '-1,00'    | 'Cash desk №2' | ''           | ''        |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "1 737,29"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "312,71"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "2 050,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows
		


Scenario: _0154138 create document Retail Sales Receipt from Point of sale (payment by card)
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Quantity'| 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'   | '550,00' | ''              | '550,00'       |
	* Add product (pick up)
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table became equal
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		Then the form attribute named "ItemListTotalQuantity" became equal to "2"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "950"
	* Change quantity and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '550,00' | '1,000'    | '550,00'       |
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And Delay 4
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalQuantity" became equal to "4"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "2 050"
		And Delay 4
	* Payment (Card)
		And I click "Payment (+)" button
		And I click "Card (*)" button
		And I click "Card 01" button
		And I click "2" button
		And I click "0" button
		And I click "5" button
		And I click "0" button
		Then the form attribute named "Amount" became equal to "2 050"
		Then the form attribute named "DecorationAmountAfter" became equal to "Decoration amount after"
		And "Payments" table became equal
			| 'Payment type'    | 'Amount'   |
			| 'Card 01'         | '2 050,00' |
		And I click "Enter" button
		And Delay 4
		And "ItemList" table does not contain lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		And I close current window
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Profit loss center' | 'Revenue type' | 'Item'     | 'Price type'        | 'Item key'  | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' |
			| 'Shop 01'       | ''             | 'Dress'    | 'Basic Price Types' | 'L/Green'   | '3,000' | 'pcs'  | '251,69'     | '550,00' | '18%' | ''              | '1 398,31'   | '1 650,00'     | ''                    | 'Store 01' | ''       |
			| 'Shop 01'       | ''             | 'Trousers' | 'Basic Price Types' | '38/Yellow' | '1,000' | 'pcs'  | '61,02'      | '400,00' | '18%' | ''              | '338,98'     | '400,00'       | ''                    | 'Store 01' | ''       |
		And "Payments" table contains lines
			| 'Amount'   | 'Commission'      | 'Payment type'    | 'Payment terminal' | 'Bank term'             | 'Account'             | 'Percent'     |
			| '2 050,00' | '20,50'           | 'Card 01'         | ''                 | 'Bank term 01'          | 'Transit Main'        | '1,00'        |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "1 737,29"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "312,71"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "2 050,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows

Scenario: _0154139 check payments form in the Point of sale
		And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add products
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'M/White'      |
		And I select current line in "ItemKeysPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow'    |
		And I select current line in "ItemKeysPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'       |
			| 'High shoes' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '37/19SD'      |
		And I select current line in "ItemKeysPickup" table
	* Check amount calculation
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "ItemListTotalQuantity" became equal to "3"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "1 460"
	* Check payments calculation
		* Cash 1520.10
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			And I click "5" button
			And I click "2" button
			And I click "0" button
			And I click "." button
			And I click "1" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 520,10' |
			Then the form attribute named "Cashback" became equal to "60,1"
		* Cash 1500.25
			And I click "C" button
			And I click "1" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "2" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 500,25' |
			Then the form attribute named "Cashback" became equal to "40,25"
		* Cash 2000.99
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '2 000,99' |
			Then the form attribute named "Cashback" became equal to "540,99"
		* Cash 20 000.01
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "0" button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '20 000,01' |
			Then the form attribute named "Cashback" became equal to "18 540,01"
		* Cash 200 000.00
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,00' |
			Then the form attribute named "Cashback" became equal to "198 540"
		* Cash 200 000.50
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "5" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,50' |
			Then the form attribute named "Cashback" became equal to "198 540,5"
		* Cash 200 000.55
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "5" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,55' |
			Then the form attribute named "Cashback" became equal to "198 540,55"
		* Cash 200 000
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,00' |
			Then the form attribute named "Cashback" became equal to "198 540"
		* Cash 2 000 000
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '2 000 000,00' |
			Then the form attribute named "Cashback" became equal to "1 998 540"
		* Cash 20 000 000.05
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "0" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '20 000 000,05' |
			Then the form attribute named "Cashback" became equal to "19 998 540,05"
		* Cash 0.950076
			And I click "C" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "7" button
			And I click "6" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '0,95' |
		* Cash 09500.73
			And I click "C" button
			And I click "0" button
			And I click "9" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "7" button
			And I click "3" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '9 500,73' |
			Then the form attribute named "Cashback" became equal to "8 040,73"
		* Card 100.12 + Cash 2500.88
			And I click "C" button
			And I click "2" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "8" button
			And I click "8" button
			And I click "Card (*)" button
			And I click "Card 01" button
			And I click "1" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "1" button
			And I click "2" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '2 500,88' |
				| 'Card 01'      | '100,12' |
			Then the form attribute named "Cashback" became equal to "1 141"
		* Card 1459.10 + Cash 0.90
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Cash'         |
			And I click "C" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "9" button
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Card 01'      |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And I click "." button
			And I click "1" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '0,99'     |
				| 'Card 01'      | '1 459,1'   |
			Then the form attribute named "Cashback" became equal to "0,09"
		* Card 1459.10 + Cash 1.00
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Cash'         |
			And I click "C" button
			And I click "1" button
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Card 01'      |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And I click "." button
			And I click "1" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00'     |
				| 'Card 01'      | '1 459,1'   |
			Then the form attribute named "Cashback" became equal to "0,1"
		* Card 1459.00 + Cash 1.00
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Cash'         |
			And I click "C" button
			And I click "1" button
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Card 01'      |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00'     |
				| 'Card 01'      | '1 459'   |
			Then the form attribute named "Cashback" became equal to "0"
		* Auto calculation balance of payment
			* Card 560 + Cash 900
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Card 01'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Cash'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button
				And I click "Card 01" button
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,00'   |
					| 'Cash'         | '900,00'     |
				Then the form attribute named "Cashback" became equal to "0"
			* Card 560,12 + Cash 899,88
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Card 01'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Cash'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button
				And I click "Card 01" button
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "." button
				And I click "1" button
				And I click "2" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,12'   |
					| 'Cash'         | '899,88'     |
				Then the form attribute named "Cashback" became equal to "0"
			* Card 560,40 + Cash 899,60
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Card 01'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Cash'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button
				And I click "Card 01" button
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "." button
				And I click "4" button
				And I click "0" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,40'   |
					| 'Cash'         | '899,60'     |
				Then the form attribute named "Cashback" became equal to "0"
			* Clean cash amount and check auto filling
				And I go to line in "Payments" table
					| 'Amount' | 'Payment type' |
					| '899,60' | 'Cash'         |
				And I click "C" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,40'   |
					| 'Cash'         | '0'     |
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,40'   |
					| 'Cash'         | '899,60'     |
				And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 1 299 754,89
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I input "2 499,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "520,11" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 1 400 000
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			And I click "4" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 400 000,00' |
			Then the form attribute named "Cashback" became equal to "98 785,11"
		* Cash 1 301 215,90
			And I click "C" button
			And I click "1" button
			And I click "3" button
			And I click "0" button
			And I click "1" button
			And I click "2" button
			And I click "1" button
			And I click "5" button
			And I click "." button
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 301 215,90' |
			Then the form attribute named "Cashback" became equal to "1,01"
		* Cash 1 301 214,90
			And I click "C" button
			And I click "1" button
			And I click "3" button
			And I click "0" button
			And I click "1" button
			And I click "2" button
			And I click "1" button
			And I click "4" button
			And I click "." button
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 301 214,90' |
			Then the form attribute named "Cashback" became equal to "0,01"
		* Cash 10 000 000,98
			And I click "C" button
			And I click "1" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "8" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '10 000 000,98' |
			Then the form attribute named "Cashback" became equal to "8 698 786,09"
			And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 0,4
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"

		And I go to line in "ItemList" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "0,4" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 1,00
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "0,4"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00' |
			Then the form attribute named "Cashback" became equal to "0,6"
			And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 0,41
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "0,41" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 1,00
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "0,41"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00' |
			Then the form attribute named "Cashback" became equal to "0,59"
			And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 0,09
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "0,09" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 0,1
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "0" button
			And I click "." button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "0,09"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '0,10' |
			Then the form attribute named "Cashback" became equal to "0,01"
			And I close "Payment: Point of sale" window
		And I close all client application windows
		
Scenario: _0154140 check filling in retail customer from the POS (without partner)
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add products
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
				| 'Item'  |
				| 'Dress' |
		And I go to line in "ItemKeysPickup" table
				| 'Presentation' |
				| 'M/White'      |
		And I select current line in "ItemKeysPickup" table
	* Create Retail customer
		And I click "Search customer" button
		And I input "9088090889980" text in "ID" field
		And I input "Olga" text in "Name" field
		And I input "Olhovska" text in "Surname" field
		And I click "OK" button
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "Enter" button
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "RetailCustomer" became equal to "Olga Olhovska"
		Then the form attribute named "UsePartnerTransactions" became equal to "No"
		And I delete "$$NumberRetailSalesReceipt0154140$$" variable
		And I delete "$$RetailSalesReceipt0154140$$" variable
		And I save the value of "Number" field as "$$NumberRetailSalesReceipt0154140$$"
		And I click the button named "FormPost"
		And I save the window as "$$RetailSalesReceipt0154140$$"
	And I close all client application windows	

Scenario:  _0154141 manual price adjustment in the POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'  | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'     | '550,00' | ''              | '550,00'       |
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
	* Price adjustment
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add one more items and check price filling
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '200,00' | ''              | '200,00'       |
			| 'Dress'    | 'S/Yellow'  | '1,000'    | '550,00' | ''              | '550,00'       |
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '36/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '200,00' | ''              | '200,00'       |
			| 'Dress'    | 'S/Yellow'  | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '36/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		And I close all client application windows

Scenario:  _0154148 check that the Retail return receipt amount and the amount of payment must match
	* Create Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail customer' |
		And I select current line in "List" table
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
		And I activate "Price" field in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "600,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Payment amount [600,00] and return amount [500,00] not match" substring will appear in 10 seconds
		And I move to "Item list" tab
		And I select current line in "ItemList" table
		And I input "700,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
	* Check that the Retail return receipt amount and the amount of payment match
		Then I wait that in user messages the "Payment amount [600,00] and return amount [700,00] not match" substring will appear in 10 seconds
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And I finish line editing in "Payments" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "120,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Payment amount [720,00] and return amount [700,00] not match" substring will appear in 10 seconds
		And I move to "Item list" tab
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
		And I activate "Price" field in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Payment amount [720,00] and return amount [900,00] not match" substring will appear in 10 seconds
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "FormPost"
		Then I wait that in user messages the "Payment amount [720,00] and return amount [700,00] not match" substring will appear in 10 seconds
		And I close all client application windows
		
Scenario:  _0154149 create Cash statement
	* Delete variables
		And I delete '$$NumberRetailSalesReceipt01541491$$' variable
		And I delete '$$RetailSalesReceipt01541491$$' variable
		And I delete '$$NumberRetailSalesReceipt01541492$$' variable
		And I delete '$$RetailSalesReceipt01541492$$' variable
		And I delete '$$NumberRetailSalesReceipt01541493$$' variable
		And I delete '$$RetailSalesReceipt01541493$$' variable
		And I delete '$$NumberRetailSalesReceipt01541494$$' variable
		And I delete '$$RetailSalesReceipt01541494$$' variable
		And I delete '$$NumberRetailReturnReceipt01541491$$' variable
		And I delete '$$RetailReturnReceipt01541491$$' variable
		And I delete '$$NumberRetailReturnReceipt01541493$$' variable
		And I delete '$$RetailReturnReceipt01541493$$' variable
		And I delete '$$NumberRetailReturnReceipt01541494$$' variable
		And I delete '$$RetailReturnReceipt01541494$$' variable
	* Filling in POS account
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №4' |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I change "Type" radio button value to "POS"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I change "Currency" radio button value to "Fixed"
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click "Save and close" button		
	* Create Cash statement statuses
		* Done
			Given I open hyperlink "e1cib/list/Catalog.CashStatementStatuses"
			If "List" table does not contain lines Then
				| "Description" |
				| "Done" |
				And I click the button named "FormCreate"
				And I input "Done" text in "ENG" field
				And I change checkbox "Forbid corrections"
				And I click "Save and close" button
		* Create
			If "List" table does not contain lines Then
				| "Description" |
				| "Create" |
				And I click the button named "FormCreate"
				And I input "Create" text in "ENG" field
				And I click "Save and close" button
	* Create RetailSalesReceipt01541491
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
			Then the form attribute named "Agreement" became equal to "Retail partner term"
			Then the form attribute named "Store" became equal to "Store 01"
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
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "400,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 00:00:00" text in "Date" field
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt01541491$$" variable
			And I delete "$$RetailSalesReceipt01541491$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541491$$"
			And I save the window as "$$RetailSalesReceipt01541491$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541491$$'      |
			And I close all client application windows
	* Create RetailSalesReceipt01541492
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Dress' | '550,00' | 'L/Green'  | '2,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Cash'        |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 100,00" text in "Amount" field of "Payments" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №4' |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 12:50:00" text in "Date" field
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt01541492$$" variable
			And I delete "$$RetailSalesReceipt01541492$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541492$$"
			And I save the window as "$$RetailSalesReceipt01541492$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541492$$'      |
			And I close all client application windows
	* Create RetailSalesReceipt01541493
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "4,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Shirt' | '350,00' | '38/Black'  | '4,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Cash'        |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 200,00" text in "Amount" field of "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №4' |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "200,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 16:40:04" text in "Date" field
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt01541493$$" variable
			And I delete "$$RetailSalesReceipt01541493$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541493$$"
			And I save the window as "$$RetailSalesReceipt01541493$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541493$$'      |
			And I close all client application windows
		* Create RetailSalesReceipt01541494
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "4,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Shirt' | '350,00' | '38/Black'  | '4,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Cash'        |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 200,00" text in "Amount" field of "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №4' |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "200,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "31.08.2020 12:40:04" text in "Date" field
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt01541494$$" variable
			And I delete "$$RetailSalesReceipt01541494$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541494$$"
			And I save the window as "$$RetailSalesReceipt01541494$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541494$$'      |
			And I close all client application windows
	* Create RetailSalesReceipt01541495
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
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
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "400,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 00:00:00" text in "Date" field
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt01541495$$" variable
			And I delete "$$RetailSalesReceipt01541495$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541495$$"
			And I save the window as "$$RetailSalesReceipt01541495$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541495$$'      |
			And I close all client application windows
	* Create Retail return receipt based on RetailSalesReceipt01541494
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541494$$'      |
		And I activate "Date" field in "List" table
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
		And I click "Ok" button		
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "500,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I go to line in "Payments" table
			| '#' | 'Account'      | 'Amount' | 'Commission' | 'Payment terminal'    | 'Payment type' | 'Percent' |
			| '2' | 'Transit Main' | '200,00' | '12,90'      | 'Payment terminal 01' | 'Card 01'      | '1,00'    |
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I input "01.09.2020 13:40:04" text in "Date" field
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt01541494$$" variable
		And I delete "$$RetailReturnReceipt01541494$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541494$$"
		And I save the window as "$$RetailReturnReceipt01541494$$"
		And I click the button named "FormPostAndClose"
	* Create Retail return receipt based on RetailSalesReceipt01541493
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541493$$'      |
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
		And I click "Ok" button	
		Then "Retail return receipt (create)" window is opened
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "350,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I go to line in "Payments" table
			| '#' | 'Account'      | 'Amount' | 'Commission' | 'Payment terminal'    | 'Payment type' | 'Percent' |
			| '2' | 'Transit Main' | '200,00' | '12,90'      | 'Payment terminal 01' | 'Card 01'      | '1,00'    |
		And I delete a line in "Payments" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I input "01.09.2020 15:31:04" text in "Date" field
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt01541493$$" variable
		And I delete "$$RetailReturnReceipt01541493$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541493$$"
		And I save the window as "$$RetailReturnReceipt01541493$$"
		And I click the button named "FormPostAndClose"
	* Create Retail return receipt based on RetailSalesReceipt01541491
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541491$$'      |
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
		And I click "Ok" button	
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I input "01.09.2020 16:55:04" text in "Date" field
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt01541491$$" variable
		And I delete "$$RetailReturnReceipt01541491$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541491$$"
		And I save the window as "$$RetailReturnReceipt01541491$$"
		And I click the button named "FormPostAndClose"
	* Create Cash Statement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Status" field
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Done'        | 'Done'      |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, TRY' |
		And I select current line in "List" table
		And I click Select button of "Transaction period" field
		Then "Select period" window is opened
		And I input "01.09.2020" text in "DateBegin" field
		And I input "01.09.2020" text in "DateEnd" field
		And I click "Select" button
		And I click "Fill transactions" button
		* Check filling in Cash transaction tab
			And I move to "Cash transaction" tab
			And "CashTransactionList" table contains lines
				| 'Document'                        | 'Receipt'  | 'Expense' |
				| '$$RetailSalesReceipt01541492$$'  | '1 100,00' | ''        |
				| '$$RetailReturnReceipt01541494$$' | ''         | '500,00'  |
				| '$$RetailReturnReceipt01541493$$' | ''         | '350,00'  |
				| '$$RetailSalesReceipt01541493$$'  | '1 200,00' | ''        |
			Then the number of "CashTransactionList" table lines is "меньше или равно" 4
			And "PaymentList" table contains lines
				| 'Payment type' | 'Account'      | 'Commission' | 'Amount'   |'Currency'   |
				| 'Cash'         | 'Cash desk №4' | ''           | '1 450,00' |'TRY'        |
				| 'Card 01'      | 'Transit Main' | '64,50'      | '400,00'   |'TRY'        |
			Then the number of "PaymentList" table lines is "меньше или равно" 2 
		* Filling in movement type
			And I go to line in "PaymentList" table
				| '#' | 'Account'      | 'Amount'   | 'Currency' | 'Payment type' |
				| '2' | 'Cash desk №4' | '1 450,00' | 'TRY'      | 'Cash'         |
			And I activate "Movement type" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click choice button of "Movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     | 'Type'          |
				| 'Movement type 1' | 'Cash movement' |	
			And I select current line in "List" table	
			And I finish line editing in "PaymentList" table
			And I go to line in "PaymentList" table
				| '#' | 'Account'      | 'Amount' | 'Commission' | 'Currency' | 'Payment type' |
				| '1' | 'Transit Main' | '400,00' | '64,50'      | 'TRY'      | 'Card 01'      |
			And I select current line in "PaymentList" table
			And I click choice button of "Movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     | 'Type'          |
				| 'Movement type 1' | 'Cash movement' |
			And I select current line in "List" table				
		And I delete "$$NumberCashStatement01541491$$" variable
		And I delete "$$CashStatement01541491$$" variable
		And I delete "$$DateCashStatement01541491$$" variable
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberCashStatement01541491$$"
		And I save the window as "$$CashStatement01541491$$"
		And I save the value of the field named "Date" as  "$$DateCashStatement01541491$$"
		And I close current window
		And "List" table contains lines
				| 'Number'                        |
				| '$$NumberCashStatement01541491$$'  |
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberCashStatement01541491$$'  |
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Document registrations records'  | ''                              | ''          | ''             | ''        | ''                          | ''                  | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| 'Register  "R3035 Cash planning"' | ''                              | ''          | ''             | ''        | ''                          | ''                  | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| ''                                | 'Period'                        | 'Resources' | 'Dimensions'   | ''        | ''                          | ''                  | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | 'Attributes'           |
			| ''                                | ''                              | 'Amount'    | 'Company'      | 'Branch'  | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Movement type'   | 'Planning period' | 'Deferred calculation' |
			| ''                                | '$$DateCashStatement01541491$$' | '68,48'     | 'Main Company' | 'Shop 01' | '$$CashStatement01541491$$' | 'Bank account, TRY' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1' | ''                | 'No'                   |
			| ''                                | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | '$$CashStatement01541491$$' | 'Bank account, TRY' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1' | ''                | 'No'                   |
			| ''                                | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | '$$CashStatement01541491$$' | 'Bank account, TRY' | 'TRY'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1' | ''                | 'No'                   |
		And I select "Cash in transit" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Cash in transit"' | ''            | ''                              | ''          | ''             | ''        | ''                          | ''             | ''                  | ''         | ''                             | ''                     | '' |
			| ''                            | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''        | ''                          | ''             | ''                  | ''         | ''                             | 'Attributes'           | '' |
			| ''                            | ''            | ''                              | 'Amount'    | 'Company'      | 'Branch'  | 'Basis document'            | 'From account' | 'To account'        | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' |
			| ''                            | 'Receipt'     | '$$DateCashStatement01541491$$' | '68,48'     | 'Main Company' | 'Shop 01' | '$$CashStatement01541491$$' | 'Transit Main' | 'Bank account, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   | '' |
			| ''                            | 'Receipt'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | '$$CashStatement01541491$$' | 'Transit Main' | 'Bank account, TRY' | 'TRY'      | 'Local currency'               | 'No'                   | '' |
			| ''                            | 'Receipt'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | '$$CashStatement01541491$$' | 'Transit Main' | 'Bank account, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   | '' |
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$CashStatement01541491$$'      | ''            | ''                              | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| 'Document registrations records' | ''            | ''                              | ''          | ''             |  ''       |''             | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"' | ''            | ''                              | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| ''                               | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''        | ''             | ''         | ''                             | 'Attributes'           |
			| ''                               | ''            | ''                              | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                               | 'Expense'     | '$$DateCashStatement01541491$$' | '68,48'     | 'Main Company' | 'Shop 01' | 'Transit Main' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                               | 'Expense'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | 'Transit Main' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                               | 'Expense'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | 'Transit Main' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I close all client application windows
		
		
Scenario: _0154154 check filling in and refilling Retail return receipt
	And I close all client application windows
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
		* Change company in Retail sales receipt
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
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
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
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Serial lot numbers' | 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Offers amount' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| ''                   | '400,00' | 'Trousers' | '18%' | '38/Yellow' | ''              | '1,000' | 'pcs'  | 'No'                 | '61,02'      | '338,98'     | '400,00'       | 'Store 01' |
				| ''                   | '350,00' | 'Shirt'    | '18%' | '38/Black'  | ''              | '2,000' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' |
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
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'pcs'  | 'No'                 | '61,02'      | '338,98'     | '400,00'       | 'Store 01' |
			| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And I click "SearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 4
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'pcs'  | '61,02'      | '338,98'     | '400,00'       | 'Store 01' |
			| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | 'pcs'  | '106,78'     | '593,22'     | '700,00'       | 'Store 01' |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | 'pcs'  | '83,90'      | '466,10'     | '550,00'       | 'Store 01' |
			And Delay 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And I click "Pickup" button
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
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'pcs'  | '61,02'      | '338,98'     | '400,00'       | 'Store 01' |
			| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | 'pcs'  | '106,78'     | '593,22'     | '700,00'       | 'Store 01' |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | 'pcs'  | '83,90'      | '466,10'     | '550,00'       | 'Store 01' |
			| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | 'pcs'  | '79,32'      | '440,68'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'pcs'  | 'No'                 | '126,00'     | '700,00'     | '826,00'       | 'Store 01' |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'pcs'  | 'No'                 | '99,00'      | '550,00'     | '649,00'       | 'Store 01' |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'pcs'  | 'No'                 | '93,60'      | '520,00'     | '613,60'       | 'Store 01' |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'pcs'  | 'No'                 | '83,90'      | '466,10'     | '550,00'       | 'Store 01' |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'pcs'  | 'No'                 | '79,32'      | '440,68'     | '520,00'       | 'Store 01' |
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
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 02' |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'pcs'  | 'No'                 | '83,90'      | '466,10'     | '550,00'       | 'Store 02' |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'pcs'  | 'No'                 | '79,32'      | '440,68'     | '520,00'       | 'Store 02' |
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
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'pcs'  | 'No'                 | '83,90'      | '466,10'     | '550,00'       | 'Store 01' |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'pcs'  | 'No'                 | '79,32'      | '440,68'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And I click "Save" button
			And I move to the tab named "GroupCurrencies"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '0,1712'            | '303,02' | '1'            |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'pcs'  | '106,78'     | '593,22'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | '0%'  | 'L/Green'  | '1,000' | 'pcs'  | ''           | '550,00'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'pcs'  | '79,32'      | '440,68'     | '520,00'       | 'Store 01' |
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
					| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt' | '0%'  | '38/Black' | '2,000' | 'pcs'  | 'No'                 | ''           | '700,00'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'pcs'  | 'No'                 | '99,00'      | '550,00'     | '649,00'       | 'Store 01' |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'pcs'  | 'No'                 | '93,60'      | '520,00'     | '613,60'       | 'Store 01' |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
		* Change unit and check price re-calculation
			And I go to line in "ItemList" table
				| 'Dont calculate row' | 'Item'  | 'Item key' | 'Net amount' | 'Price'  | 'Q'     | 'Store'    | 'Tax amount' | 'Total amount' | 'Unit' | 'VAT' |
				| 'No'                 | 'Dress' | 'L/Green'  | '550,00'     | '550,00' | '1,000' | 'Store 01' | '99,00'      | '649,00'       | 'pcs'  | '18%' |
			And I select current line in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And "List" table does not contain lines
				| 'Description' |
				| 'box (8 pcs)' |
			And "List" table contains lines
				| 'Description' |
				| 'pcs' |
				| 'box Dress (8 pcs)' |
			Then the number of "List" table lines is "равно" "2"
			And I go to line in "List" table
				| 'Description' |
				| 'box Dress (8 pcs)' |
			And I select current line in "List" table
			And "ItemList" table contains lines
				| 'Item'  | 'Item key' | 'Dont calculate row' | 'Q'     | 'Unit'        | 'Tax amount' | 'Price'    | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Dress' | 'L/Green'  | 'No'                 | '1,000' | 'box Dress (8 pcs)' | '792,00'     | '4 400,00' | '18%' | '4 400,00'   | '5 192,00'     | 'Store 01' |
			And I close all client application windows			



Scenario: _0154155 check filling in and refilling Retail sales receipt
	And I close all client application windows
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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
		* Change company in Retail sales receipt
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
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
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
				| 'Serial lot numbers' | 'Price'  | 'Detail' | 'Item'     | 'VAT' | 'Item key'  | 'Offers amount' | 'Q'     | 'Price type'        | 'Unit' | 'Revenue type' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' | 'Additional analytic' |
				| ''                   | '400,00' | ''       | 'Trousers' | '18%' | '38/Yellow' | ''              | '1,000' | 'Basic Price Types' | 'pcs'  | ''             | 'No'                 | '61,02'      | '338,98'     | '400,00'       | 'Store 01' | 'Shop 01'       | ''                    |
				| ''                   | '350,00' | ''       | 'Shirt'    | '18%' | '38/Black'  | ''              | '2,000' | 'Basic Price Types' | 'pcs'  | ''             | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' | 'Shop 01'       | ''                    |
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
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '61,02'      | '338,98'     | '400,00'       | 'Store 01' | 'Shop 01'       |
			| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' | 'Shop 01'       |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And in the table "ItemList" I click "SearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 4
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'Basic Price Types' | 'pcs'  | '61,02'      | '338,98'     | '400,00'       | 'Store 01' | 'Shop 01'       |
			| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | 'Basic Price Types' | 'pcs'  | '106,78'     | '593,22'     | '700,00'       | 'Store 01' | 'Shop 01'       |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | 'Basic Price Types' | 'pcs'  | '83,90'      | '466,10'     | '550,00'       | 'Store 01' | 'Shop 01'       |
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
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
			| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '1,000' | 'Basic Price Types' | 'pcs'  | '61,02'      | '338,98'     | '400,00'       | 'Store 01' | 'Shop 01'       |
			| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '2,000' | 'Basic Price Types' | 'pcs'  | '106,78'     | '593,22'     | '700,00'       | 'Store 01' | 'Shop 01'       |
			| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '1,000' | 'Basic Price Types' | 'pcs'  | '83,90'      | '466,10'     | '550,00'       | 'Store 01' | 'Shop 01'       |
			| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '1,000' | 'Basic Price Types' | 'pcs'  | '79,32'      | '440,68'     | '520,00'       | 'Store 01' | 'Shop 01'       |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '126,00'     | '700,00'     | '826,00'       | 'Store 01' | 'Shop 01'       |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '99,00'      | '550,00'     | '649,00'       | 'Store 01' | 'Shop 01'       |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '93,60'      | '520,00'     | '613,60'       | 'Store 01' | 'Shop 01'       |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' | 'Shop 01'       |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '83,90'      | '466,10'     | '550,00'       | 'Store 01' | 'Shop 01'       |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '79,32'      | '440,68'     | '520,00'       | 'Store 01' | 'Shop 01'       |
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
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Price type'              | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
			| '296,61' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'Basic Price without VAT' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 02' | 'Shop 01'       |
			| '466,10' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'Basic Price without VAT' | 'pcs'  | 'No'                 | '83,90'      | '466,10'     | '550,00'       | 'Store 02' | 'Shop 01'       |
			| '440,68' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'Basic Price without VAT' | 'pcs'  | 'No'                 | '79,32'      | '440,68'     | '520,00'       | 'Store 02' | 'Shop 01'       |
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
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '106,78'     | '593,22'     | '700,00'       | 'Store 01' | 'Shop 01'       |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '83,90'      | '466,10'     | '550,00'       | 'Store 01' | 'Shop 01'       |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '79,32'      | '440,68'     | '520,00'       | 'Store 01' | 'Shop 01'       |
		* Check filling in currency tab
			And I click "Save" button
			And I move to the tab named "GroupCurrencies"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '0,1712'            | '303,02' | '1'            |
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
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
				| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | 'Basic Price Types' | 'pcs'  | '106,78'     | '593,22'     | '700,00'       | 'Store 01' | 'Shop 01'       |
				| '550,00' | 'Dress' | '0%'  | 'L/Green'  | '1,000' | 'Basic Price Types' | 'pcs'  | ''           | '550,00'     | '550,00'       | 'Store 01' | 'Shop 01'       |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'Basic Price Types' | 'pcs'  | '79,32'      | '440,68'     | '520,00'       | 'Store 01' | 'Shop 01'       |
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
					| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
					| 'Shirt' | '38/Black' | '350,00' | '2,000' |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
				| '350,00' | 'Shirt' | '0%'  | '38/Black' | '2,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | ''           | '700,00'     | '700,00'       | 'Store 01' | 'Shop 01'       |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '99,00'      | '550,00'     | '649,00'       | 'Store 01' | 'Shop 01'       |
				| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '93,60'      | '520,00'     | '613,60'       | 'Store 01' | 'Shop 01'       |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
		* Change price type
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Price'  | 'Price type'        | 'Q'     |
				| 'Dress' | 'XS/Blue'  | '520,00' | 'Basic Price Types' | '1,000' |
			And I select current line in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Profit loss center' | 'Price type'              | 'Item'  | 'Item key' | 'Dont calculate row' | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Shop 01'       | 'Basic Price Types'       | 'Shirt' | '38/Black' | 'No'                 | '2,000' | 'pcs'  | ''           | '350,00' | '0%'  | '700,00'     | '700,00'       | 'Store 01' |
				| 'Shop 01'       | 'Basic Price Types'       | 'Dress' | 'L/Green'  | 'No'                 | '1,000' | 'pcs'  | '99,00'      | '550,00' | '18%' | '550,00'     | '649,00'       | 'Store 01' |
				| 'Shop 01'       | 'Basic Price without VAT' | 'Dress' | 'XS/Blue'  | 'No'                 | '1,000' | 'pcs'  | '79,32'      | '440,68' | '18%' | '440,68'     | '520,00'       | 'Store 01' |
		* Change unit and check price re-calculation
			And I go to line in "ItemList" table
				| 'Profit loss center' | 'Dont calculate row' | 'Item'  | 'Item key' | 'Net amount' | 'Price'  | 'Price type'        | 'Q'     | 'Store'    | 'Tax amount' | 'Total amount' | 'Unit' | 'VAT' |
				| 'Shop 01'       | 'No'                 | 'Dress' | 'L/Green'  | '550,00'     | '550,00' | 'Basic Price Types' | '1,000' | 'Store 01' | '99,00'      | '649,00'       | 'pcs'  | '18%' |
			And I select current line in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And "List" table does not contain lines
				| 'Description' |
				| 'box (8 pcs)' |
			And "List" table contains lines
				| 'Description' |
				| 'pcs' |
				| 'box Dress (8 pcs)' |
			Then the number of "List" table lines is "равно" "2"
			And I go to line in "List" table
				| 'Description' |
				| 'box Dress (8 pcs)' |
			And I select current line in "List" table
			And "ItemList" table contains lines
				| 'Profit loss center' | 'Price type'              | 'Item'  | 'Item key' | 'Dont calculate row' | 'Q'     | 'Unit'        | 'Tax amount' | 'Price'    | 'VAT' | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Shop 01'       | 'Basic Price Types'       | 'Shirt' | '38/Black' | 'No'                 | '2,000' | 'pcs'         | ''           | '350,00'   | '0%'  | '700,00'     | '700,00'       | 'Store 01' |
				| 'Shop 01'       | 'Basic Price Types'       | 'Dress' | 'L/Green'  | 'No'                 | '1,000' | 'box Dress (8 pcs)' | '792,00'     | '4 400,00' | '18%' | '4 400,00'   | '5 192,00'     | 'Store 01' |
				| 'Shop 01'       | 'Basic Price without VAT' | 'Dress' | 'XS/Blue'  | 'No'                 | '1,000' | 'pcs'         | '79,32'      | '440,68'   | '18%' | '440,68'     | '520,00'       | 'Store 01' |
			And I close all client application windows
			
						
							

Scenario: _0154156 check Retail sales receipt when changing date
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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
		| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Profit loss center' |
		| '500,00' | 'Dress' | '18%' | 'M/Brown'  | '1,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '76,27'      | '423,73'     | '500,00'       | 'Store 01' | 'Shop 01'       |
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
		And I move to the tab named "GroupCurrencies"
		And "ObjectCurrencies" table became equal
		| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
		| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 000'  | '1'            |
		| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '0,2000'            | '200,00' | '1'            |



Scenario: _0154158 check function DontCalculateRow in the Retail sales receipt
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail partner term'         |
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
			And I click the button named "FormPostAndClose"



Scenario: _0154170 check function DontCalculateRow in the Retail return receipt
	* Open the Retail return receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail partner term'         |
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
			And I close all client application windows
			


Scenario: _0154171 check tax and net amount calculation when change total amount in the Retail sales receipt
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail partner term'         |
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



Scenario: _0154172 check tax and net amount calculation when change total amount in the Retail return receipt
	* Open the Retail return receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Retail customer'         |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail partner term'         |
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

Scenario: _0154175 check change amount in POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Quantity'  | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'     | '550,00' | ''              | '550,00'       |
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Dress' | 'S/Yellow' | '1,000'    | '550,00' | ''              | '550,00'       |
	* Change AMOUNT and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity'  | 'Total amount' |
			| 'Dress' | 'L/Green'  | '550,00' | '1,000'     | '550,00'       |
		And I select current line in "ItemList" table
		And I input "500,00" text in "Total amount" field of "ItemList" table
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "1 050"
		And Delay 2
	* Payment (Cash)
		And I click "Payment (+)" button
		And I click "1" button
		And I click "0" button
		And I click "5" button
		And I click "0" button
		And I click "Enter" button
		And I close current window
		And Delay 2
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Profit loss center' | 'Item'  | 'Price type'        | 'Item key' | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    |
			| 'Shop 01'       | 'Dress' | 'Basic Price Types' | 'L/Green'  | '1,000' | 'pcs'  | '76,27'      | '500,00' | '18%' | ''              | '423,73'     | '500,00'       | ''                    | 'Store 01' |
			| 'Shop 01'       | 'Dress' | 'Basic Price Types' | 'S/Yellow' | '1,000' | 'pcs'  | '83,90'      | '550,00' | '18%' | ''              | '466,10'     | '550,00'       | ''                    | 'Store 01' |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "889,83"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "160,17"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 050,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows


Scenario: _0154182 check filling in Retail sales when select retail customer (with partner) in POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"	
	* Select retail customer
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'                  |
			| 'Retail customer with partner' |
		And I select current line in "List" table
		And I click "OK" button
	* Add items and payment
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'M/White'      |
		And I select current line in "ItemKeysPickup" table
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "Enter" button
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Customer"
		Then the form attribute named "LegalName" became equal to "Customer"
		Then the form attribute named "Agreement" became equal to "Customer partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "UsePartnerTransactions" became equal to "Yes"
		Then the form attribute named "RetailCustomer" became equal to "Name Retail customer Surname Retail customer"
		And "ItemList" table contains lines
			| 'Profit loss center' | 'Price type'              | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' |
			| 'Shop 01'       | 'Basic Price without VAT' | 'Dress' | 'M/White'  | 'No'                 | ''                   | '1,000' | 'pcs'  | '67,22'      | '440,68' | '18%' | ''              | '373,46'     | '440,68'       | ''                    | 'Store 01' | ''             | ''       |
		And "Payments" table contains lines
			| 'Amount' | 'Payment type' |
			| '440,68' | 'Cash'         |
		And I delete "$$NumberRetailSalesReceipt0154182$$" variable
		And I delete "$$RetailSalesReceipt0154182$$" variable
		And I save the value of "Number" field as "$$NumberRetailSalesReceipt0154182$$"
		And I click the button named "FormPost"
		And I save the window as "$$RetailSalesReceipt0154182$$"




Scenario: _0154190 check filling in Retail sales receipt when copying
	* Select Retail sales receipt
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt0154140$$'      |
	* Copy Retail sales receipt and check filling in
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Olga Olhovska"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| 'Profit loss center' | 'Price type'        | 'Item'  | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' |
			| 'Shop 01'       | 'Basic Price Types' | 'Dress' | 'M/White'  | 'No'                 | ''                   | '1,000' | 'pcs'  | '79,32'      | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | ''                    | 'Store 01' | ''             | ''       |
		And "Payments" table became equal
			| 'Amount' | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term' | 'Account'      | 'Percent' |
			| '520,00' | ''           | 'Cash'         | ''                 | ''          | 'Cash desk №2' | ''        |
		And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'         | 'Currency from' | 'Currency' | 'Rate presentation' | 'Multiplicity' | 'Amount' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1'            | '520'    |
			| 'Local currency'     | 'Legal'        | 'TRY'           | 'TRY'      | '1'                 | '1'            | '520'    |
			| 'Reporting currency' | 'Reporting'    | 'TRY'           | 'USD'      | '0,1712'            | '1'            | '89,02'  |
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Manager" became equal to ""
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "440,68"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "79,32"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "520,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows
		



		
							

Scenario: _999999 close TestClient session
	And I close TestClient session
