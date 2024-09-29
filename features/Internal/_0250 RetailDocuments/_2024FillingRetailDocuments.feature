#language: en
@tree
@Positive
@RetailDocuments

Feature: check filling in retail documents + currency form connection

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _0154100 preparation ( filling documents)
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
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I select current line in "List" table
		And I change checkbox "Postpone with reserve"
		And I change checkbox "Postpone without reserve"
		And I click "Save and close" button				
	* Load RSR
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"    |
	
Scenario: _01541001 check preparation
	When check preparation	


Scenario: _0154135 create document Retail Sales Receipt
	And I close all client application windows
	* Open the Retail Sales Receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Retail customer'    |
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
			| 'Description'    |
			| 'Router'         |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'   | 'Unit'   | 'Store'       |
			| 'Router'   | 'Router'     | 'pcs'    | 'Store 01'    |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'     |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'      |
	* Check filling in prices on new lines at agreement reselection
		* Add line
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'    | 'Store'        |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'     | 'Store 01'     |
				| 'Shirt'       | '350,00'    | '38/Black'     | '2,000'       | 'pcs'     | 'Store 01'     |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And in the table "ItemList" I click "SearchByBarcode" button
			And I input "2202283739" text in the field named "Barcode"
			And I move to the next attribute		
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Tax amount'    | 'Quantity'    | 'Unit'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '61,02'         | '1,000'       | 'pcs'     | '338,98'        | '400,00'          | 'Store 01'     |
				| '350,00'    | 'Shirt'       | '18%'    | '38/Black'     | '106,78'        | '2,000'       | 'pcs'     | '593,22'        | '700,00'          | 'Store 01'     |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '83,90'         | '1,000'       | 'pcs'     | '466,10'        | '550,00'          | 'Store 01'     |
			And Delay 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And in the table "ItemList" I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title'     |
				| 'Dress'     |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'     | 'Title'      | 'Unit'     |
				| '520,00'    | 'XS/Blue'    | 'pcs'      |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Tax amount'    | 'Quantity'    | 'Unit'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '61,02'         | '1,000'       | 'pcs'     | '338,98'        | '400,00'          | 'Store 01'     |
				| '350,00'    | 'Shirt'       | '18%'    | '38/Black'     | '106,78'        | '2,000'       | 'pcs'     | '593,22'        | '700,00'          | 'Store 01'     |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '83,90'         | '1,000'       | 'pcs'     | '466,10'        | '550,00'          | 'Store 01'     |
				| '520,00'    | 'Dress'       | '18%'    | 'XS/Blue'      | '79,32'         | '1,000'       | 'pcs'     | '440,68'        | '520,00'          | 'Store 01'     |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Tax amount'    | 'Quantity'    | 'Unit'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| '350,00'    | 'Shirt'    | '18%'    | '38/Black'    | '126,00'        | '2,000'       | 'pcs'     | '700,00'        | '826,00'          | 'Store 01'     |
				| '550,00'    | 'Dress'    | '18%'    | 'L/Green'     | '99,00'         | '1,000'       | 'pcs'     | '550,00'        | '649,00'          | 'Store 01'     |
				| '520,00'    | 'Dress'    | '18%'    | 'XS/Blue'     | '93,60'         | '1,000'       | 'pcs'     | '520,00'        | '613,60'          | 'Store 01'     |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Tax amount'    | 'Quantity'    | 'Unit'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| '350,00'    | 'Shirt'    | '18%'    | '38/Black'    | '106,78'        | '2,000'       | 'pcs'     | '593,22'        | '700,00'          | 'Store 01'     |
				| '550,00'    | 'Dress'    | '18%'    | 'L/Green'     | '83,90'         | '1,000'       | 'pcs'     | '466,10'        | '550,00'          | 'Store 01'     |
				| '520,00'    | 'Dress'    | '18%'    | 'XS/Blue'     | '79,32'         | '1,000'       | 'pcs'     | '440,68'        | '520,00'          | 'Store 01'     |
		* Payment
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Card 01'         |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'             |
				| 'Payment terminal 01'     |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 770,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table			
		* Check filling in currency tab
			And I click "Save" button
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'         | 'Type'            | 'To'     | 'From'    | 'Multiplicity'    | 'Rate'      | 'Amount'     |
				| 'Reporting currency'    | 'Reporting'       | 'USD'    | 'TRY'     | '1'               | '0,171200'    | '303,02'     |
				| 'Local currency'        | 'Legal'           | 'TRY'    | 'TRY'     | '1'               | '1'         | '1 770'      |
				| 'TRY'                   | 'Partner term'    | 'TRY'    | 'TRY'     | '1'               | '1'         | '1 770'      |
			And I close current window
		* Post Retail sales receipt
			And I delete "$$NumberRetailSalesReceipt0154135$$" variable
			And I delete "$$RetailSalesReceipt015413$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt0154135$$"
			And I click the button named "FormPost"
			And I save the window as "$$RetailSalesReceipt015413$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number'                                 |
			| '$$NumberRetailSalesReceipt0154135$$'    |
			And I close all client application windows
	* Check auto filling inventory origin (FO Use commission trading switched off)
		When set True value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberRetailSalesReceipt0154135$$'    |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Inventory origin'   | 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Tax amount'   | 'Quantity'   | 'Unit'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| 'Own stocks'         | '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '106,78'       | '2,000'      | 'pcs'    | '593,22'       | '700,00'         | 'Store 01'    |
			| 'Own stocks'         | '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '83,90'        | '1,000'      | 'pcs'    | '466,10'       | '550,00'         | 'Store 01'    |
			| 'Own stocks'         | '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '79,32'        | '1,000'      | 'pcs'    | '440,68'       | '520,00'         | 'Store 01'    |
		And I close all client application windows	
		When set False value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberRetailSalesReceipt0154135$$'    |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I activate "Inventory origin" field in "ItemList" table'    |
		And I close all client application windows		
		


			
						


Scenario: _0154136 create document Retail Return Receipt based on RetailSalesReceipt
	* Select Retail sales receipt for Retail Return Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberRetailSalesReceipt0154135$$'    |
	* Create Retail Return Receipt
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I click "Ok" button		
	* Check filling in
		Then the form attribute named "DecorationGroupTitleCollapsedPicture" became equal to "Decoration group title collapsed picture"
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Partner: Retail customer   Legal name: Company Retail customer   Partner term: Retail partner term   Posting status: New   "
		Then the form attribute named "DecorationGroupTitleUncollapsedPicture" became equal to "DecorationGroupTitleUncollapsedPicture"
		Then the form attribute named "DecorationGroupTitleUncollapsedLabel" became equal to "Company: Main Company   Partner: Retail customer   Legal name: Company Retail customer   Partner term: Retail partner term   Posting status: New   "
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Retail sales receipt'            |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | ''                | '106,78'       | 'pcs'    | '593,22'       | '700,00'         | 'Store 01'   | '$$RetailSalesReceipt015413$$'    |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | ''                | '83,90'        | 'pcs'    | '466,10'       | '550,00'         | 'Store 01'   | '$$RetailSalesReceipt015413$$'    |
			| '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | ''                | '79,32'        | 'pcs'    | '440,68'       | '520,00'         | 'Store 01'   | '$$RetailSalesReceipt015413$$'    |
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
			| 'Payment type'   | 'Payment terminal'      | 'Account'        | 'Commission'   | 'Amount'   | 'Percent'    |
			| 'Card 01'        | 'Payment terminal 01'   | 'Transit Main'   | '9,00'         | '900,00'   | '1,00'       |
	* Change quantity and post document
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'    |
			| 'Shirt'   | '38/Black'   | '350,00'   | '2,000'       |
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'    |
			| 'Dress'   | 'XS/Blue'    | '520,00'   | '1,000'       |
		And I delete a line in "ItemList" table
		And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Retail sales receipt'            |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '1,000'      | ''                | '53,39'        | 'pcs'    | '296,61'       | '350,00'         | 'Store 01'   | '$$RetailSalesReceipt015413$$'    |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | ''                | '83,90'        | 'pcs'    | '466,10'       | '550,00'         | 'Store 01'   | '$$RetailSalesReceipt015413$$'    |
	* Post Retail return receipt
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt0154136$$" variable
		And I delete "$$RetailReturnReceipt0154136$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt0154136$$"
		And I save the window as "$$RetailReturnReceipt0154136$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And "List" table contains lines
			| 'Number'                                  |
			| '$$NumberRetailReturnReceipt0154136$$'    |
		And I close all client application windows

Scenario: _01541361 check filling in Row Id info table in the RRR (RSR-RRR)
		And I close all client application windows
	* Select Retail sales receipt for Retail Return Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Create Retail Return Receipt
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table became equal
			| 'Row presentation'                                     | 'Use'   | 'Quantity'   | 'Unit'             | 'Price'      | 'Currency'    |
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | 'Yes'   | ''           | ''                 | ''           | ''            |
			| 'Dress (XS/Blue)'                                      | 'Yes'   | '1,000'      | 'pcs'              | '520,00'     | 'TRY'         |
			| 'Trousers (38/Yellow)'                                 | 'Yes'   | '2,000'      | 'pcs'              | '400,00'     | 'TRY'         |
			| 'Boots (36/18SD)'                                      | 'Yes'   | '1,000'      | 'Boots (12 pcs)'   | '8 400,00'   | 'TRY'         |
		And I go to line in "BasisesTree" table
			| 'Row presentation'    |
			| 'Boots (36/18SD)'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check filling in RRR
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'                                 | 'Item'       | 'Sales person'   | 'Profit loss center'   | 'Item key'    | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Quantity'   | 'Price'    | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Return reason'   | 'Revenue type'   | 'Detail'   | 'VAT'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | 'Dress'      | ''               | 'Shop 01'              | 'XS/Blue'     | 'No'                   | ''                     | 'pcs'    | '79,32'        | '1,000'      | '520,00'   | '440,68'       | '520,00'         | ''                      | 'Store 01'   | ''                | 'Revenue'        | ''         | '18%'   | ''                | ''               |
			| '2'   | 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | 'Trousers'   | ''               | 'Shop 01'              | '38/Yellow'   | 'No'                   | ''                     | 'pcs'    | '122,03'       | '2,000'      | '400,00'   | '677,97'       | '800,00'         | ''                      | 'Store 01'   | ''                | 'Revenue'        | ''         | '18%'   | ''                | ''               |
		Then the form attribute named "Branch" became equal to "Shop 01"
	* Save row key
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1RetailReturnReceipt1$$" variable
		And I save the current field value as "$$Rov1RetailReturnReceipt1$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2RetailReturnReceipt1$$" variable
		And I save the current field value as "$$Rov2RetailReturnReceipt1$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| '#' | 'Key'                          | 'Basis'                                              | 'Row ID'                               | 'Next step' | 'Quantity' | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''          | '1,000'    | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | 'RRR&RGR'      | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
			| '2' | '$$Rov2RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''          | '2,000'    | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | 'RRR&RGR'      | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'XS/Blue'    | '1,000'       |
		And in the table "ItemList" I click "Copy" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3RetailReturnReceipt1$$" variable
		And I save the current field value as "$$Rov3RetailReturnReceipt1$$"
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "5 480,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post" button	
		And I move to "Row ID Info" tab	
		And "RowIDInfo" table became equal
			| '#' | 'Key'                          | 'Basis'                                              | 'Row ID'                               | 'Next step' | 'Quantity' | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''          | '1,000'    | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | 'RRR&RGR'      | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
			| '2' | '$$Rov2RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''          | '2,000'    | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | 'RRR&RGR'      | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
			| '3' | '$$Rov3RetailReturnReceipt1$$' | ''                                                   | '$$Rov3RetailReturnReceipt1$$'         | ''          | '8,000'    | '                                    ' | ''             | '$$Rov3RetailReturnReceipt1$$'         |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "RowIDInfo" table does not contain lines
			| 'Key'                            | 'Quantity'    |
			| '$$Rov1RetailReturnReceipt1$$'   | '8,000'       |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '3'   | 'Dress'   | 'XS/Blue'    | '8,000'       |
		And in the table "ItemList" I click "Delete" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| '#' | 'Key'                          | 'Basis'                                              | 'Row ID'                               | 'Next step' | 'Quantity' | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''          | '1,000'    | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | 'RRR&RGR'      | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
			| '2' | '$$Rov2RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''          | '2,000'    | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | 'RRR&RGR'      | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'       | 'Item key'    | 'Quantity'    |
			| '2'   | 'Trousers'   | '38/Yellow'   | '2,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table			
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| '#' | 'Key'                          | 'Basis'                                              | 'Row ID'                               | 'Next step' | 'Quantity' | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''          | '1,000'    | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | 'RRR&RGR'      | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
			| '2' | '$$Rov2RetailReturnReceipt1$$' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''          | '1,000'    | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | 'RRR&RGR'      | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
		And I click the button named "FormUndoPosting"	
		And I close all client application windows

	
Scenario: _01541362 create RSR using form link/unlink (different company, store, branch)
		And I close all client application windows
	* Open RSR form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table	
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Select items from basis documents
		And I move to "Item list" tab		
		And I click the button named "AddBasisDocuments"
		And "BasisesTree" table became equal
			| 'Row presentation'                                   | 'Use' | 'Company'      | 'Branch'  | 'Quantity' | 'Unit'           | 'Price'    | 'Currency' |
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'No'  | 'Main Company' | 'Shop 01' | ''         | ''               | ''         | ''         |
			| 'Dress (XS/Blue)'                                    | 'No'  | 'Main Company' | 'Shop 01' | '1,000'    | 'pcs'            | '520,00'   | 'TRY'      |
			| 'Trousers (38/Yellow)'                               | 'No'  | 'Main Company' | 'Shop 01' | '2,000'    | 'pcs'            | '400,00'   | 'TRY'      |
			| 'Boots (36/18SD)'                                    | 'No'  | 'Main Company' | 'Shop 01' | '1,000'    | 'Boots (12 pcs)' | '8 400,00' | 'TRY'      |
			| '$$RetailSalesReceipt015413$$'                       | 'No'  | 'Main Company' | 'Shop 01' | ''         | ''               | ''         | ''         |
			| 'Shirt (38/Black)'                                   | 'No'  | 'Main Company' | 'Shop 01' | '1,000'    | 'pcs'            | '350,00'   | 'TRY'      |
			| 'Dress (XS/Blue)'                                    | 'No'  | 'Main Company' | 'Shop 01' | '1,000'    | 'pcs'            | '520,00'   | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '1,000'      | 'Dress (XS/Blue)'    | 'pcs'    | 'No'     |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'       | 'Unit'   | 'Use'    |
			| 'TRY'        | '400,00'   | '2,000'      | 'Trousers (38/Yellow)'   | 'pcs'    | 'No'     |
		And I set "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button				
	* Check filling
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'                                 | 'Revenue type'   | 'Item'       | 'Sales person'   | 'Item key'    | 'Profit loss center'   | 'Serial lot numbers'   | 'Unit'   | 'Dont calculate row'   | 'Quantity'   | 'Price'    | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Return reason'   | 'Detail'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | 'Revenue'        | 'Dress'      | ''               | 'XS/Blue'     | 'Shop 01'              | ''                     | 'pcs'    | 'No'                   | '1,000'      | '520,00'   | '520,00'         | ''                      | 'Store 01'   | ''                | ''         | ''                | ''               |
			| '2'   | 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | 'Revenue'        | 'Trousers'   | ''               | '38/Yellow'   | 'Shop 01'              | ''                     | 'pcs'    | 'No'                   | '2,000'      | '400,00'   | '800,00'         | ''                      | 'Store 01'   | ''                | ''         | ''                | ''               |
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Second Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Branch" became equal to "Distribution department"
	* Check RowIDInfo
		And I click "Show row key" button		
		And "RowIDInfo" table contains lines
			| '#' | 'Basis'                                              | 'Next step' | 'Quantity' | 'Current step' |
			| '1' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''          | '1,000'    | 'RRR&RGR'      |
			| '2' | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''          | '2,000'    | 'RRR&RGR'      |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I click "Save" button
		And I close all client application windows					


Scenario: _0154137 create document Retail Sales Receipt from Point of sale (payment by cash)
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '1,000'      | '550,00'   | ''         | '550,00'    |
	* Add product (pick up)
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10002) Trousers'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                                 |
			| '(10002) Trousers, (899) 38/Yellow'    |
		And I select current line in "ItemsPickup" table		
		And "ItemList" table became equal
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'      | 'L/Green'     | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
		Then the form attribute named "ItemListTotalQuantity" became equal to "2"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "950"
	* Change quantity and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '550,00'   | '1,000'      | '550,00'    |
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
		And "Payments" table became equal
			| 'Payment type'   | 'Amount'      |
			| 'Cash'           | '2 051,00'    |
		Then the form attribute named "Cashback" became equal to "1"
		And I click "OK" button
		And "ItemList" table does not contain lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'      | 'L/Green'     | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
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
			| 'Profit loss center'   | 'Revenue type'   | 'Item'       | 'Price type'          | 'Item key'    | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Detail'    |
			| 'Shop 01'              | ''               | 'Dress'      | 'Basic Price Types'   | 'L/Green'     | '3,000'      | 'pcs'    | '251,69'       | '550,00'   | '18%'   | ''                | '1 398,31'     | '1 650,00'       | ''                      | 'Store 01'   | ''          |
			| 'Shop 01'              | ''               | 'Trousers'   | 'Basic Price Types'   | '38/Yellow'   | '1,000'      | 'pcs'    | '61,02'        | '400,00'   | '18%'   | ''                | '338,98'       | '400,00'         | ''                      | 'Store 01'   | ''          |
		And "Payments" table contains lines
			| 'Payment type'   | 'Payment terminal'   | 'Bank term'   | 'Amount'     | 'Account'        | 'Commission'   | 'Percent'    |
			| 'Cash'           | ''                   | ''            | '2 051,00'   | 'Cash desk №2'   | ''             | ''           |
			| 'Cash'           | ''                   | ''            | '-1,00'      | 'Cash desk №2'   | ''             | ''           |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "1 737,29"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "312,71"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "2 050,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows
	* Check auto filling inventory origin (FO Use commission trading switched off)
		When set True value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Inventory origin'   | 'Profit loss center'   | 'Revenue type'   | 'Item'       | 'Price type'          | 'Item key'    | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Detail'    |
			| 'Own stocks'         | 'Shop 01'              | ''               | 'Dress'      | 'Basic Price Types'   | 'L/Green'     | '3,000'      | 'pcs'    | '251,69'       | '550,00'   | '18%'   | ''                | '1 398,31'     | '1 650,00'       | ''                      | 'Store 01'   | ''          |
			| 'Own stocks'         | 'Shop 01'              | ''               | 'Trousers'   | 'Basic Price Types'   | '38/Yellow'   | '1,000'      | 'pcs'    | '61,02'        | '400,00'   | '18%'   | ''                | '338,98'       | '400,00'         | ''                      | 'Store 01'   | ''          |
		And I close all client application windows	
		When set False value to the constant Use commission trading
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I activate "Inventory origin" field in "ItemList" table'    |
		And I close all client application windows		
		


Scenario: _0154138 create document Retail Sales Receipt from Point of sale (payment by card)
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '1,000'      | '550,00'   | ''         | '550,00'    |
	* Add product (pick up)
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10002) Trousers'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                                 |
			| '(10002) Trousers, (899) 38/Yellow'    |
		And I select current line in "ItemsPickup" table
		And "ItemList" table became equal
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'      | 'L/Green'     | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
		Then the form attribute named "ItemListTotalQuantity" became equal to "2"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "950"
	* Change quantity and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '550,00'   | '1,000'      | '550,00'    |
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
		// And I click "[2] Card 01" button	
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table		
		And I click "2" button
		And I click "0" button
		And I click "5" button
		And I click "0" button
		Then the form attribute named "Amount" became equal to "2 050"
		And "Payments" table became equal
			| 'Payment type'   | 'Amount'      |
			| 'Card 01'        | '2 050,00'    |
		And I click "OK" button
		And Delay 4
		And "ItemList" table does not contain lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'      | 'L/Green'     | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
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
			| 'Profit loss center'   | 'Revenue type'   | 'Item'       | 'Price type'          | 'Item key'    | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Detail'    |
			| 'Shop 01'              | ''               | 'Dress'      | 'Basic Price Types'   | 'L/Green'     | '3,000'      | 'pcs'    | '251,69'       | '550,00'   | '18%'   | ''                | '1 398,31'     | '1 650,00'       | ''                      | 'Store 01'   | ''          |
			| 'Shop 01'              | ''               | 'Trousers'   | 'Basic Price Types'   | '38/Yellow'   | '1,000'      | 'pcs'    | '61,02'        | '400,00'   | '18%'   | ''                | '338,98'       | '400,00'         | ''                      | 'Store 01'   | ''          |
		And "Payments" table contains lines
			| 'Amount'     | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Bank term'      | 'Account'        | 'Percent'    |
			| '2 050,00'   | '20,50'        | 'Card 01'        | ''                   | 'Bank term 01'   | 'Transit Main'   | '1,00'       |
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
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                              |
			| '(10001) Dress, (BN898) M/White'    |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10002) Trousers'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                                 |
			| '(10002) Trousers, (899) 38/Yellow'    |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                  |
			| '(10005) High shoes'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                           |
			| '(10005) High shoes, 37/19SD'    |
		And I select current line in "ItemsPickup" table
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
			And I click "•" button	
			And I click "1" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'       |
				| 'Cash'            | '1 520,10'     |
			Then the form attribute named "Cashback" became equal to "60,1"
		* Cash 1500.25
			And I click "C" button
			And I click "1" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "2" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'       |
				| 'Cash'            | '1 500,25'     |
			Then the form attribute named "Cashback" became equal to "40,25"
		* Cash 2000.99
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "9" button
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'       |
				| 'Cash'            | '2 000,99'     |
			Then the form attribute named "Cashback" became equal to "540,99"
		* Cash 20 000.01
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "0" button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'        |
				| 'Cash'            | '20 000,01'     |
			Then the form attribute named "Cashback" became equal to "18 540,01"
		* Cash 200 000.00
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'         |
				| 'Cash'            | '200 000,00'     |
			Then the form attribute named "Cashback" became equal to "198 540"
		* Cash 200 000.50
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "5" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'         |
				| 'Cash'            | '200 000,50'     |
			Then the form attribute named "Cashback" became equal to "198 540,5"
		* Cash 200 000.55
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "5" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'         |
				| 'Cash'            | '200 000,55'     |
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
				| 'Payment type'    | 'Amount'         |
				| 'Cash'            | '200 000,00'     |
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
				| 'Payment type'    | 'Amount'           |
				| 'Cash'            | '2 000 000,00'     |
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
			And I click "•" button	
			And I click "0" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'            |
				| 'Cash'            | '20 000 000,05'     |
			Then the form attribute named "Cashback" became equal to "19 998 540,05"
		* Cash 0.950076
			And I click "C" button
			And I click "0" button
			And I click "•" button	
			And I click "9" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "7" button
			And I click "6" button
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'     |
				| 'Cash'            | '0,95'       |
		* Cash 09500.73
			And I click "C" button
			And I click "0" button
			And I click "9" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "7" button
			And I click "3" button
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'       |
				| 'Cash'            | '9 500,73'     |
			Then the form attribute named "Cashback" became equal to "8 040,73"
		* Card 100.12 + Cash 2500.88
			And I click "C" button
			And I click "2" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "8" button
			And I click "8" button
			And I click "Card (*)" button
			And I go to line in "BankPaymentTypeList" table
				| 'Reference'     |
				| 'Card 01'       |
			And I select current line in "BankPaymentTypeList" table
			And I click "1" button
			And I click "0" button
			And I click "0" button
			And I click "•" button	
			And I click "1" button
			And I click "2" button
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'       |
				| 'Cash'            | '2 500,88'     |
				| 'Card 01'         | '100,12'       |
			Then the form attribute named "Cashback" became equal to "1 141"
		* Card 1459.10 + Cash 0.90
			And I go to line in "Payments" table
				| 'Payment type'     |
				| 'Cash'             |
			And I click "C" button
			And I click "0" button
			And I click "•" button	
			And I click "9" button
			And I click "9" button
			And I go to line in "Payments" table
				| 'Payment type'     |
				| 'Card 01'          |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And I click "•" button	
			And I click "1" button
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'      |
				| 'Cash'            | '0,99'        |
				| 'Card 01'         | '1 459,1'     |
			Then the form attribute named "Cashback" became equal to "0,09"
		* Card 1459.10 + Cash 1.00
			And I go to line in "Payments" table
				| 'Payment type'     |
				| 'Cash'             |
			And I click "C" button
			And I click "1" button
			And I go to line in "Payments" table
				| 'Payment type'     |
				| 'Card 01'          |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And I click "•" button	
			And I click "1" button
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'      |
				| 'Cash'            | '1,00'        |
				| 'Card 01'         | '1 459,1'     |
			Then the form attribute named "Cashback" became equal to "0,1"
		* Card 1459.00 + Cash 1.00
			And I go to line in "Payments" table
				| 'Payment type'     |
				| 'Cash'             |
			And I click "C" button
			And I click "1" button
			And I go to line in "Payments" table
				| 'Payment type'     |
				| 'Card 01'          |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'     |
				| 'Cash'            | '1,00'       |
				| 'Card 01'         | '1 459'      |
			Then the form attribute named "Cashback" became equal to "0"
		* Auto calculation balance of payment
			* Card 560 + Cash 900
				And I go to line in "Payments" table
					| 'Payment type'      |
					| 'Card 01'           |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type'      |
					| 'Cash'              |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "BankPaymentTypeList" table
					| 'Reference'      |
					| 'Card 01'        |
				And I select current line in "BankPaymentTypeList" table
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type'     | 'Amount'      |
					| 'Card 01'          | '560,00'      |
					| 'Cash'             | '900,00'      |
				Then the form attribute named "Cashback" became equal to "0"
			* Card 560,12 + Cash 899,88
				And I go to line in "Payments" table
					| 'Payment type'      |
					| 'Card 01'           |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type'      |
					| 'Cash'              |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button				
				And I go to line in "BankPaymentTypeList" table
					| 'Reference'      |
					| 'Card 01'        |
				And I select current line in "BankPaymentTypeList" table
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "•" button	
				And I click "1" button
				And I click "2" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type'     | 'Amount'      |
					| 'Card 01'          | '560,12'      |
					| 'Cash'             | '899,88'      |
				Then the form attribute named "Cashback" became equal to "0"
			* Card 560,40 + Cash 899,60
				And I go to line in "Payments" table
					| 'Payment type'      |
					| 'Card 01'           |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type'      |
					| 'Cash'              |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button
				And I go to line in "BankPaymentTypeList" table
					| 'Reference'      |
					| 'Card 01'        |
				And I select current line in "BankPaymentTypeList" table
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "•" button	
				And I click "4" button
				And I click "0" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type'     | 'Amount'      |
					| 'Card 01'          | '560,40'      |
					| 'Cash'             | '899,60'      |
				Then the form attribute named "Cashback" became equal to "0"
			* Clean cash amount and check auto filling
				And I go to line in "Payments" table
					| 'Amount'     | 'Payment type'      |
					| '899,60'     | 'Cash'              |
				And I click "C" button
				And "Payments" table became equal
					| 'Payment type'     | 'Amount'      |
					| 'Card 01'          | '560,40'      |
					| 'Cash'             | '0'           |
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type'     | 'Amount'      |
					| 'Card 01'          | '560,40'      |
					| 'Cash'             | '899,60'      |
				And I close "Payment" window
	* New retail sales receipt with amount 1 299 754,89
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
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
				| 'Payment type'    | 'Amount'           |
				| 'Cash'            | '1 400 000,00'     |
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
			And I click "•" button	
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'           |
				| 'Cash'            | '1 301 215,90'     |
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
			And I click "•" button	
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'           |
				| 'Cash'            | '1 301 214,90'     |
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
			And I click "•" button	
			And I click "9" button
			And I click "8" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'            |
				| 'Cash'            | '10 000 000,98'     |
			Then the form attribute named "Cashback" became equal to "8 698 786,09"
			And I close "Payment" window
	* New retail sales receipt with amount 0,4
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"

		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '37/19SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
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
				| 'Payment type'    | 'Amount'     |
				| 'Cash'            | '1,00'       |
			Then the form attribute named "Cashback" became equal to "0,6"
			And I close "Payment" window
	* New retail sales receipt with amount 0,41
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
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
				| 'Payment type'    | 'Amount'     |
				| 'Cash'            | '1,00'       |
			Then the form attribute named "Cashback" became equal to "0,59"
			And I close "Payment" window
	* New retail sales receipt with amount 0,09
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
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
			And I click "•" button	
			And I click "1" button
			Then the form attribute named "Amount" became equal to "0,09"
			And "Payments" table became equal
				| 'Payment type'    | 'Amount'     |
				| 'Cash'            | '0,10'       |
			Then the form attribute named "Cashback" became equal to "0,01"
			And I click "OK" button
		And I close all client application windows
		
Scenario: _0154140 check filling in retail customer from the POS (without partner)
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add products
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                              |
			| '(10001) Dress, (BN898) M/White'    |
		And I select current line in "ItemsPickup" table
	* Create Retail customer
		And I click "Search customer" button
		And I input "9088090889980" text in "ID" field
		And I input "Olga" text in "Name" field
		And I input "Olhovska" text in "Surname" field
		And I click "OK" button
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
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

Scenario: _0154188 check customer on change in POS 
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add items and payment
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                              |
			| '(10001) Dress, (BN898) M/White'    |
		And I select current line in "ItemsPickup" table
	* Select retail customer with own partner term
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'                                     |
			| 'Name Retail customer Surname Retail customer'    |
		And I select current line in "List" table
		And I click "OK" button
		#Then "Update item list info" window is opened
		#And I click "OK" button
	* Check price
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Serials'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'M/White'    | ''          | '1,000'      | '440,68'   | ''         | '520,00'    |
	* Delete retail customer and check price change
		And I click the button named "ClearRetailCustomer"
		#Then "Update item list info" window is opened
		#And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Serials'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'M/White'    | ''          | '1,000'      | '520,00'   | ''         | '520,00'    |
	* Select retail customer with own partner term again and check price change
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'                                     |
			| 'Name Retail customer Surname Retail customer'    |
		And I select current line in "List" table
		And I click "OK" button
		#Then "Update item list info" window is opened
		#And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Serials'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'M/White'    | ''          | '1,000'      | '440,68'   | ''         | '520,00'    |
	* Change retail customer and check price change
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'               |
			| 'Retail customer Second'    |
		And I select current line in "List" table
		And I click "OK" button
		#Then "Update item list info" window is opened
		#And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Serials'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'M/White'    | ''          | '1,000'      | '520,00'   | ''         | '520,00'    |
		And I close all client application windows

Scenario: _0154141 manual price adjustment in the POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '1,000'      | '550,00'   | ''         | '550,00'    |
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10002) Trousers'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                                 |
			| '(10002) Trousers, (899) 38/Yellow'    |
		And I select current line in "ItemsPickup" table
	* Select retail customer with own partner term
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'      | 'L/Green'     | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
	* Price adjustment
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add one more items and check price filling
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'      | 'L/Green'     | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '200,00'   | ''         | '200,00'    |
			| 'Dress'      | 'S/Yellow'    | '1,000'      | '550,00'   | ''         | '550,00'    |
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10002) Trousers'    |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                           |
			| '(10002) Trousers, 36/Yellow'    |
		And I select current line in "ItemsPickup" table
	* Select retail customer with own partner term
		And "ItemList" table contains lines
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'      | 'L/Green'     | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '200,00'   | ''         | '200,00'    |
			| 'Dress'      | 'S/Yellow'    | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Trousers'   | '36/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I close all client application windows

Scenario:  _0154142 change comment in POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add products
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                              |
			| '(10001) Dress, (BN898) M/White'    |
		And I select current line in "ItemsPickup" table
		And I finish line editing in "ItemList" table	
	* Filling comment
		And I move to "Additional" tab
		And I input "test" text in the field named "Comment"		
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Comment" became equal to "test"
		Then the form attribute named "UsePartnerTransactions" became equal to "No"
		And I delete "$$NumberRetailSalesReceipt0154142$$" variable
		And I delete "$$RetailSalesReceipt0154142$$" variable
		And I save the value of "Number" field as "$$NumberRetailSalesReceipt0154142$$"
		And I click the button named "FormPost"
		And I save the window as "$$RetailSalesReceipt0154142$$"
	And I close all client application windows	

Scenario:  _0154143 change payment term in POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add products
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                              |
			| '(10001) Dress, (BN898) M/White'    |
		And I select current line in "ItemsPickup" table
	* Select retail customer with own partner term
	* Change partner term
		And I move to "Additional" tab
		And I click Select button of "Partner term" field	
		If "List" table does not contain lines Then
			| 'Description'              |
			| 'Retail partner term 2'    |
			And I click the button named "FormCreate"
			And I expand "Agreement info" group
			And I expand "Price settings" group
			And I expand "Store and delivery" group
			And I input "Retail partner term 2" text in "ENG" field
			And I click Select button of "Multi currency movement type" field
			Then "Multi currency movement types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'TRY'             |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Description'              |
				| 'Discount Price TRY 1'     |
			And I select current line in "List" table
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Retail partner term 2'    |
		And I select current line in "List" table
	* Check price change
		And "ItemList" table became equal
			| 'Item'    | 'Sales person'   | 'Item key'   | 'Serials'   | 'Price'    | 'Quantity'   | 'Offers'   | 'Total'     |
			| 'Dress'   | ''               | 'M/White'    | ''          | '494,00'   | '1,000'      | ''         | '582,92'    |
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term 2"
		And "ItemList" table contains lines
			| 'Price type'             | 'Item'    | 'Profit loss center'   | 'Item key'   | 'Dont calculate row'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| 'Discount Price TRY 1'   | 'Dress'   | 'Shop 01'              | 'M/White'    | 'No'                   | '1,000'      | 'pcs'    | '88,92'        | '494,00'   | '18%'   | '494,00'       | '582,92'         | 'Store 01'    |
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "582,92"		
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "UsePartnerTransactions" became equal to "No"
		And I delete "$$NumberRetailSalesReceipt0154143$$" variable
		And I delete "$$RetailSalesReceipt0154143$$" variable
		And I save the value of "Number" field as "$$NumberRetailSalesReceipt0154143$$"
		And I click the button named "FormPost"
		And I save the window as "$$RetailSalesReceipt0154143$$"
	And I close all client application windows	
		
				
		
				


Scenario:  _0154148 check that the Retail return receipt amount and the amount of payment must match
	* Create Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Retail customer'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Cash'           |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "600,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table		
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
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I finish line editing in "Payments" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "120,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Payment amount [720,00] and return amount [700,00] not match" substring will appear in 10 seconds
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I input "100,00" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Payment amount [720,00] and return amount [900,00] not match" substring will appear in 10 seconds
		And I input "100,00" text in "Landed cost" field of "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Total amount'    |
			| 'Trousers'   | '38/Yellow'   | '200,00'          |
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
			| 'Description'     |
			| 'Cash desk №4'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 01'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'     |
			| 'Transit Main'    |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 01'        |
		And I select current line in "List" table
		And I change "Type" radio button value to "POS"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'     |
			| 'Transit Main'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click "Save and close" button		
	* Create Cash statement statuses
		* Done
			Given I open hyperlink "e1cib/list/Catalog.CashStatementStatuses"
			If "List" table does not contain lines Then
				| "Description"     |
				| "Done"            |
				And I click the button named "FormCreate"
				And I input "Done" text in "ENG" field
				And I change checkbox "Forbid corrections"
				And I click "Save and close" button
		* Create
			If "List" table does not contain lines Then
				| "Description"     |
				| "Create"          |
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
				| 'Description'         |
				| 'Retail customer'     |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
			Then the form attribute named "Agreement" became equal to "Retail partner term"
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'     |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'      |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Card 01'         |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'             |
				| 'Payment terminal 01'     |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
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
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541491$$'    |
			And I close all client application windows
	* Create RetailSalesReceipt01541492
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Retail customer'     |
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
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'L/Green'      |
			And I select current line in "List" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Quantity'    | 'Unit'     |
				| 'Dress'    | '550,00'    | 'L/Green'     | '2,000'       | 'pcs'      |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Cash'            |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 100,00" text in "Amount" field of "Payments" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash desk №4'     |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 23:59:59" text in "Date" field
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt01541492$$" variable
			And I delete "$$RetailSalesReceipt01541492$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541492$$"
			And I save the window as "$$RetailSalesReceipt01541492$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541492$$'    |
			And I close all client application windows
	* Create RetailSalesReceipt01541493
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Retail customer'     |
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
				| 'Description'     |
				| 'Shirt'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '38/Black'     |
			And I select current line in "List" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Quantity'    | 'Unit'     |
				| 'Shirt'    | '350,00'    | '38/Black'    | '4,000'       | 'pcs'      |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Cash'            |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 200,00" text in "Amount" field of "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash desk №4'     |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Card 01'         |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'             |
				| 'Payment terminal 01'     |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
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
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541493$$'    |
			And I close all client application windows
		* Create RetailSalesReceipt01541494
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Retail customer'     |
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
				| 'Description'     |
				| 'Shirt'           |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'     |
				| 'Shirt'    | '38/Black'     |
			And I select current line in "List" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Quantity'    | 'Unit'     |
				| 'Shirt'    | '350,00'    | '38/Black'    | '4,000'       | 'pcs'      |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Cash'            |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 200,00" text in "Amount" field of "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash desk №4'     |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Card 01'         |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'             |
				| 'Payment terminal 01'     |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
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
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541494$$'    |
			And I close all client application windows
	* Create RetailSalesReceipt01541495
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Retail customer'     |
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
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'     |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'      |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Card 01'         |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'             |
				| 'Payment terminal 01'     |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
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
			And I input "01.09.2020 23:59:59" text in "Date" field
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt01541495$$" variable
			And I delete "$$RetailSalesReceipt01541495$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541495$$"
			And I save the window as "$$RetailSalesReceipt01541495$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541495$$'    |
			And I close all client application windows
	* Create Retail return receipt based on RetailSalesReceipt01541494
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541494$$'    |
		And I activate "Date" field in "List" table
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I click "Ok" button		
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "500,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I go to line in "Payments" table
			| '#'   | 'Account'        | 'Amount'   | 'Commission'   | 'Payment terminal'      | 'Payment type'   | 'Percent'    |
			| '2'   | 'Transit Main'   | '200,00'   | '12,90'        | 'Payment terminal 01'   | 'Card 01'        | '6,45'       |
		And I input "01.09.2020 13:40:04" text in "Date" field
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt01541494$$" variable
		And I delete "$$RetailReturnReceipt01541494$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541494$$"
		And I save the window as "$$RetailReturnReceipt01541494$$"
		And I click the button named "FormPostAndClose"
	* Create Retail return receipt based on RetailSalesReceipt01541493
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541493$$'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I click "Ok" button	
		Then "Retail return receipt (create)" window is opened
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "350,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I go to line in "Payments" table
			| '#'   | 'Account'        | 'Amount'   | 'Commission'   | 'Payment terminal'      | 'Payment type'   | 'Percent'    |
			| '2'   | 'Transit Main'   | '200,00'   | '12,90'        | 'Payment terminal 01'   | 'Card 01'        | '6,45'       |
		And I delete a line in "Payments" table
		And I input "01.09.2020 17:31:04" text in "Date" field
		And I click the button named "FormPost"
		And I delete "$$NumberRetailReturnReceipt01541493$$" variable
		And I delete "$$RetailReturnReceipt01541493$$" variable
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541493$$"
		And I save the window as "$$RetailReturnReceipt01541493$$"
		And I click the button named "FormPostAndClose"
	* Create Retail return receipt based on RetailSalesReceipt01541491
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberRetailSalesReceipt01541491$$'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I click "Ok" button	
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
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Status" field
		And I go to line in "List" table
			| 'Description'   |
			| 'Done'          |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 01'        |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
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
				| 'Document'                           | 'Receipt'     | 'Expense'     |
				| '$$RetailSalesReceipt01541492$$'     | '1 100,00'    | ''            |
				| '$$RetailReturnReceipt01541494$$'    | ''            | '500,00'      |
				| '$$RetailReturnReceipt01541493$$'    | ''            | '350,00'      |
				| '$$RetailSalesReceipt01541493$$'     | '1 200,00'    | ''            |
			Then the number of "CashTransactionList" table lines is "меньше или равно" 4
			And "PaymentList" table contains lines
				| 'Payment type'    | 'Account'         | 'Commission'    | 'Amount'      | 'Currency'     |
				| 'Cash'            | 'Cash desk №4'    | ''              | '1 450,00'    | 'TRY'          |
				| 'Card 01'         | 'Transit Main'    | '12,90'         | '400,00'      | 'TRY'          |
			Then the number of "PaymentList" table lines is "меньше или равно" 2 
		* Filling in movement type
			And I go to line in "PaymentList" table
				| '#'    | 'Account'         | 'Amount'      | 'Currency'    | 'Payment type'     |
				| '2'    | 'Cash desk №4'    | '1 450,00'    | 'TRY'         | 'Cash'             |
			And I activate "Financial movement type" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click choice button of "Financial movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table	
			And I finish line editing in "PaymentList" table
			And I go to line in "PaymentList" table
				| '#'    | 'Account'         | 'Amount'    | 'Commission'    | 'Currency'    | 'Payment type'     |
				| '1'    | 'Transit Main'    | '400,00'    | '12,90'         | 'TRY'         | 'Card 01'          |
			And I select current line in "PaymentList" table
			And I click choice button of "Financial movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table		
			And I set "Use basis document" checkbox in "PaymentList" table
			And I click choice button of "Receipting account" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Bank account, TRY'   |
			And I select current line in "List" table
			And I finish line editing in "PaymentList" table
			And I go to the last line in "PaymentList" table
			And I set "Use basis document" checkbox in "PaymentList" table
			And I finish line editing in "PaymentList" table			
		And I delete "$$NumberCashStatement01541491$$" variable
		And I delete "$$CashStatement01541491$$" variable
		And I delete "$$DateCashStatement01541491$$" variable
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberCashStatement01541491$$"
		And I save the window as "$$CashStatement01541491$$"
		And I save the value of the field named "Date" as  "$$DateCashStatement01541491$$"
		And I close current window
		And "List" table contains lines
				| 'Number'                              |
				| '$$NumberCashStatement01541491$$'     |
	* Check movements
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberCashStatement01541491$$'    |
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Document registrations records'  | ''                              | ''          | ''             | ''        | ''                  | ''                          | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"' | ''                              | ''          | ''             | ''        | ''                  | ''                          | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                | 'Period'                        | 'Resources' | 'Dimensions'   | ''        | ''                  | ''                          | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                | ''                              | 'Amount'    | 'Company'      | 'Branch'  | 'Account'           | 'Basis document'            | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                | '$$DateCashStatement01541491$$' | '68,48'     | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | '$$CashStatement01541491$$' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | '$$CashStatement01541491$$' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | '$$CashStatement01541491$$' | 'TRY'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$CashStatement01541491$$'        | ''              | ''                                | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'   | ''              | ''                                | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'   | ''              | ''                                | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                 | 'Record type'   | 'Period'                          | 'Resources'   | 'Dimensions'     | ''          | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                 | ''              | ''                                | 'Amount'      | 'Company'        | 'Branch'    | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                 | 'Expense'       | '$$DateCashStatement01541491$$'   | '68,48'       | 'Main Company'   | 'Shop 01'   | 'Transit Main'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                 | 'Expense'       | '$$DateCashStatement01541491$$'   | '400'         | 'Main Company'   | 'Shop 01'   | 'Transit Main'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                 | 'Expense'       | '$$DateCashStatement01541491$$'   | '400'         | 'Main Company'   | 'Shop 01'   | 'Transit Main'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$CashStatement01541491$$'                    | ''            | ''                              | ''          | ''             | ''                   | ''                  | ''                             | ''         | ''                     | ''                          | ''                     |
			| 'Document registrations records'               | ''            | ''                              | ''          | ''             | ''                   | ''                  | ''                             | ''         | ''                     | ''                          | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                              | ''          | ''             | ''                   | ''                  | ''                             | ''         | ''                     | ''                          | ''                     |
			| ''                                             | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''                   | ''                  | ''                             | ''         | ''                     | ''                          | 'Attributes'           |
			| ''                                             | ''            | ''                              | 'Amount'    | 'Company'      | 'Branch'             | 'Account'           | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                     | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '$$DateCashStatement01541491$$' | '68,48'     | 'Main Company' | 'Front office'       | 'Bank account, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | '$$CashStatement01541491$$' | 'No'                   |
			| ''                                             | 'Receipt'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Front office'       | 'Bank account, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | '$$CashStatement01541491$$' | 'No'                   |
			| ''                                             | 'Receipt'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | 'Front office'       | 'Bank account, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | '$$CashStatement01541491$$' | 'No'                   |
		And I select "Cash in transit" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$CashStatement01541491$$'      | ''            | ''                              | ''          | ''             | ''                          | ''             | ''                  | ''         | ''                             | ''                     |
			| 'Document registrations records' | ''            | ''                              | ''          | ''             | ''                          | ''             | ''                  | ''         | ''                             | ''                     |
			| 'Register  "Cash in transit"'    | ''            | ''                              | ''          | ''             | ''                          | ''             | ''                  | ''         | ''                             | ''                     |
			| ''                               | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''                          | ''             | ''                  | ''         | ''                             | 'Attributes'           |
			| ''                               | ''            | ''                              | 'Amount'    | 'Company'      | 'Basis document'            | 'From account' | 'To account'        | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                               | 'Receipt'     | '$$DateCashStatement01541491$$' | '68,48'     | 'Main Company' | '$$CashStatement01541491$$' | 'Transit Main' | 'Bank account, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                               | 'Receipt'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | '$$CashStatement01541491$$' | 'Transit Main' | 'Bank account, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                               | 'Receipt'     | '$$DateCashStatement01541491$$' | '400'       | 'Main Company' | '$$CashStatement01541491$$' | 'Transit Main' | 'Bank account, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I close all client application windows
		
		
Scenario: _0154154 check filling in and refilling Retail return receipt
	And I close all client application windows
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'            |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'NDB'            |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company NDB"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'NDB'            |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Partner term NDB"
	* Check filling in Company from Partner term
		* Change company in Retail sales receipt
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Second Company'     |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I remove checkbox named "FilterCompanyUse"
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			And I click Open button of "Partner term" field
			And I expand "Agreement info" group
			And I expand "Price settings" group
			And I expand "Store and delivery" group
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 03'        |
			And I select current line in "List" table
			And I click "Save and close" button
		* Re-selection of the agreement and check of the store refill (items not added)
			And I click Select button of "Partner term" field
			And I select current line in "List" table
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selection partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                          |
				| 'Basic Partner terms, without VAT'     |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Router'         |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'   | 'Unit'   | 'Store'       |
			| 'Router'   | 'Router'     | 'pcs'    | 'Store 02'    |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'     |
				| 'Trousers'    | '338,98'    | '38/Yellow'    | '1,000'       | 'pcs'      |
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'    | 'Store'        |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'     | 'Store 01'     |
	* Check filling in prices on new lines at agreement reselection
		* Add line
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'    | 'Store'        |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'     | 'Store 01'     |
				| 'Shirt'       | '350,00'    | '38/Black'     | '2,000'       | 'pcs'     | 'Store 01'     |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Serial lot numbers'    | 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Offers amount'    | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| ''                      | '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | ''                 | '1,000'       | 'pcs'     | 'No'                    | '61,02'         | '338,98'        | '400,00'          | 'Store 01'     |
				| ''                      | '350,00'    | 'Shirt'       | '18%'    | '38/Black'     | ''                 | '2,000'       | 'pcs'     | 'No'                    | '106,78'        | '593,22'        | '700,00'          | 'Store 01'     |
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Second Company'     |
			And I select current line in "List" table
			If "ItemList" table does not contain "VAT" column Then
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I remove checkbox named "FilterCompanyUse"
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Tax calculation check
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '400,00'   | 'Trousers'   | '18%'   | '38/Yellow'   | '1,000'      | 'pcs'    | 'No'                   | '61,02'        | '338,98'       | '400,00'         | 'Store 01'    |
			| '350,00'   | 'Shirt'      | '18%'   | '38/Black'    | '2,000'      | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 01'    |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And I click "SearchByBarcode" button
			And I input "2202283739" text in the field named "Barcode"
			And I move to the next attribute
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '400,00'   | 'Trousers'   | '18%'   | '38/Yellow'   | '1,000'      | 'pcs'    | '61,02'        | '338,98'       | '400,00'         | 'Store 01'    |
			| '350,00'   | 'Shirt'      | '18%'   | '38/Black'    | '2,000'      | 'pcs'    | '106,78'       | '593,22'       | '700,00'         | 'Store 01'    |
			| '550,00'   | 'Dress'      | '18%'   | 'L/Green'     | '1,000'      | 'pcs'    | '83,90'        | '466,10'       | '550,00'         | 'Store 01'    |
			And Delay 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title'     |
				| 'Dress'     |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'     | 'Title'      | 'Unit'     |
				| '520,00'    | 'XS/Blue'    | 'pcs'      |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '400,00'   | 'Trousers'   | '18%'   | '38/Yellow'   | '1,000'      | 'pcs'    | '61,02'        | '338,98'       | '400,00'         | 'Store 01'    |
			| '350,00'   | 'Shirt'      | '18%'   | '38/Black'    | '2,000'      | 'pcs'    | '106,78'       | '593,22'       | '700,00'         | 'Store 01'    |
			| '550,00'   | 'Dress'      | '18%'   | 'L/Green'     | '1,000'      | 'pcs'    | '83,90'        | '466,10'       | '550,00'         | 'Store 01'    |
			| '520,00'   | 'Dress'      | '18%'   | 'XS/Blue'     | '1,000'      | 'pcs'    | '79,32'        | '440,68'       | '520,00'         | 'Store 01'    |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'pcs'    | 'No'                   | '126,00'       | '700,00'       | '826,00'         | 'Store 01'    |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'pcs'    | 'No'                   | '99,00'        | '550,00'       | '649,00'         | 'Store 01'    |
			| '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'pcs'    | 'No'                   | '93,60'        | '520,00'       | '613,60'         | 'Store 01'    |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 01'    |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'pcs'    | 'No'                   | '83,90'        | '466,10'       | '550,00'         | 'Store 01'    |
			| '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'pcs'    | 'No'                   | '79,32'        | '440,68'       | '520,00'         | 'Store 01'    |
	* Check filling in the Price includes tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price includes tax is not ticked 
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                          |
				| 'Basic Partner terms, without VAT'     |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check that the Price includes tax checkbox value has been filled out from the partner term
			Then the form attribute named "PriceIncludeTax" became equal to "No"
		* Check tax recalculation 
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '296,61'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 02'    |
			| '466,10'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'pcs'    | 'No'                   | '83,90'        | '466,10'       | '550,00'         | 'Store 02'    |
			| '440,68'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'pcs'    | 'No'                   | '79,32'        | '440,68'       | '520,00'         | 'Store 02'    |
		* Change of partner term to what was earlier
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		* Tax recalculation check
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 01'    |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'pcs'    | 'No'                   | '83,90'        | '466,10'       | '550,00'         | 'Store 01'    |
			| '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'pcs'    | 'No'                   | '79,32'        | '440,68'       | '520,00'         | 'Store 01'    |
		* Check filling in currency tab
			And I click "Save" button
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'         | 'Type'            | 'To'     | 'From'    | 'Multiplicity'    | 'Rate'      | 'Amount'     |
				| 'Reporting currency'    | 'Reporting'       | 'USD'    | 'TRY'     | '1'               | '0,171200'    | '303,02'     |
				| 'Local currency'        | 'Legal'           | 'TRY'    | 'TRY'     | '1'               | '1'         | '1 770'      |
				| 'TRY'                   | 'Partner term'    | 'TRY'    | 'TRY'     | '1'               | '1'         | '1 770'      |
			And I close current window
		* Check recalculate Total amount and Net amount when change Tax rate
			* Price includes tax
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'      | 'Item key'     | 'Price'       |
					| 'Dress'     | 'L/Green'      | '550,00'      |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| '350,00'    | 'Shirt'    | '18%'    | '38/Black'    | '2,000'       | 'pcs'     | '106,78'        | '593,22'        | '700,00'          | 'Store 01'     |
				| '550,00'    | 'Dress'    | '0%'     | 'L/Green'     | '1,000'       | 'pcs'     | ''              | '550,00'        | '550,00'          | 'Store 01'     |
				| '520,00'    | 'Dress'    | '18%'    | 'XS/Blue'     | '1,000'       | 'pcs'     | '79,32'         | '440,68'        | '520,00'          | 'Store 01'     |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 583,90"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "186,10"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
				And I go to line in "ItemList" table
					| 'Item'      | 'Item key'     | 'Price'       |
					| 'Dress'     | 'L/Green'      | '550,00'      |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
				And I move to "Other" tab
				And I remove checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'      | 'Item key'     | 'Price'      | 'Quantity'      |
					| 'Shirt'     | '38/Black'     | '350,00'     | '2,000'         |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| '350,00'    | 'Shirt'    | '0%'     | '38/Black'    | '2,000'       | 'pcs'     | 'No'                    | ''              | '700,00'        | '700,00'          | 'Store 01'     |
				| '550,00'    | 'Dress'    | '18%'    | 'L/Green'     | '1,000'       | 'pcs'     | 'No'                    | '99,00'         | '550,00'        | '649,00'          | 'Store 01'     |
				| '520,00'    | 'Dress'    | '18%'    | 'XS/Blue'     | '1,000'       | 'pcs'     | 'No'                    | '93,60'         | '520,00'        | '613,60'          | 'Store 01'     |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
		* Change unit and check price re-calculation
			And I go to line in "ItemList" table
				| 'Dont calculate row'    | 'Item'     | 'Item key'    | 'Net amount'    | 'Price'     | 'Quantity'    | 'Store'       | 'Tax amount'    | 'Total amount'    | 'Unit'    | 'VAT'     |
				| 'No'                    | 'Dress'    | 'L/Green'     | '550,00'        | '550,00'    | '1,000'       | 'Store 01'    | '99,00'         | '649,00'          | 'pcs'     | '18%'     |
			And I select current line in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And "List" table does not contain lines
				| 'Description'     |
				| 'box (8 pcs)'     |
			And "List" table contains lines
				| 'Description'           |
				| 'pcs'                   |
				| 'box Dress (8 pcs)'     |
			Then the number of "List" table lines is "равно" "2"
			And I go to line in "List" table
				| 'Description'           |
				| 'box Dress (8 pcs)'     |
			And I select current line in "List" table
			And "ItemList" table contains lines
				| 'Item'     | 'Item key'    | 'Dont calculate row'    | 'Quantity'    | 'Unit'                 | 'Tax amount'    | 'Price'       | 'VAT'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| 'Dress'    | 'L/Green'     | 'No'                    | '1,000'       | 'box Dress (8 pcs)'    | '792,00'        | '4 400,00'    | '18%'    | '4 400,00'      | '5 192,00'        | 'Store 01'     |
			And I close all client application windows			



Scenario: _0154155 check filling in and refilling Retail sales receipt
	And I close all client application windows
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'NDB'            |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company NDB"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'NDB'            |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Partner term NDB"
	* Check filling in Company from Partner term
		* Change company in Retail sales receipt
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Second Company'     |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I remove checkbox named "FilterCompanyUse"
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		* Change of store in the selected partner term
			And I click Open button of "Partner term" field
			And I expand "Agreement info" group
			And I expand "Price settings" group
			And I expand "Store and delivery" group
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 03'        |
			And I select current line in "List" table
			And I click "Save and close" button
		* Re-selection of the agreement and check of the store refill (items not added)
			And I click Select button of "Partner term" field
			And I select current line in "List" table
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selection partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                          |
				| 'Basic Partner terms, without VAT'     |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Router'         |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'   | 'Unit'   | 'Store'       |
			| 'Router'   | 'Router'     | 'pcs'    | 'Store 02'    |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'     |
				| 'Trousers'    | '338,98'    | '38/Yellow'    | '1,000'       | 'pcs'      |
	* Check refilling  price when reselection partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store and price refilling in the added line
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'    | 'Store'        |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'     | 'Store 01'     |
	* Check filling in prices on new lines at agreement reselection
		* Add line
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Unit'    | 'Store'        |
				| 'Trousers'    | '400,00'    | '38/Yellow'    | '1,000'       | 'pcs'     | 'Store 01'     |
				| 'Shirt'       | '350,00'    | '38/Black'     | '2,000'       | 'pcs'     | 'Store 01'     |
	* Check the re-drawing of the form for taxes at company re-selection.
			And "ItemList" table contains lines
				| 'Serial lot numbers'    | 'Price'     | 'Detail'    | 'Item'        | 'VAT'    | 'Item key'     | 'Offers amount'    | 'Quantity'    | 'Price type'           | 'Unit'    | 'Revenue type'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Profit loss center'    | 'Additional analytic'     |
				| ''                      | '400,00'    | ''          | 'Trousers'    | '18%'    | '38/Yellow'    | ''                 | '1,000'       | 'Basic Price Types'    | 'pcs'     | ''                | 'No'                    | '61,02'         | '338,98'        | '400,00'          | 'Store 01'    | 'Shop 01'               | ''                        |
				| ''                      | '350,00'    | ''          | 'Shirt'       | '18%'    | '38/Black'     | ''                 | '2,000'       | 'Basic Price Types'    | 'pcs'     | ''                | 'No'                    | '106,78'        | '593,22'        | '700,00'          | 'Store 01'    | 'Shop 01'               | ''                        |
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Second Company'     |
			And I select current line in "List" table
			If "ItemList" table does not contain "VAT" column Then
	* Tax calculation check when filling in the company at reselection of the partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I remove checkbox named "FilterCompanyUse"
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
		* Tax calculation check
			Then "Update item list info" window is opened
			And I click "OK" button
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Price type'          | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Profit loss center'    |
			| '400,00'   | 'Trousers'   | '18%'   | '38/Yellow'   | '1,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '61,02'        | '338,98'       | '400,00'         | 'Store 01'   | 'Shop 01'               |
			| '350,00'   | 'Shirt'      | '18%'   | '38/Black'    | '2,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 01'   | 'Shop 01'               |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And in the table "ItemList" I click "SearchByBarcode" button
			And I input "2202283739" text in the field named "Barcode"
			And I move to the next attribute
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Price type'          | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Profit loss center'    |
			| '400,00'   | 'Trousers'   | '18%'   | '38/Yellow'   | '1,000'      | 'Basic Price Types'   | 'pcs'    | '61,02'        | '338,98'       | '400,00'         | 'Store 01'   | 'Shop 01'               |
			| '350,00'   | 'Shirt'      | '18%'   | '38/Black'    | '2,000'      | 'Basic Price Types'   | 'pcs'    | '106,78'       | '593,22'       | '700,00'         | 'Store 01'   | 'Shop 01'               |
			| '550,00'   | 'Dress'      | '18%'   | 'L/Green'     | '1,000'      | 'Basic Price Types'   | 'pcs'    | '83,90'        | '466,10'       | '550,00'         | 'Store 01'   | 'Shop 01'               |
			And Delay 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And in the table "ItemList" I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title'     |
				| 'Dress'     |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'     | 'Title'      | 'Unit'     |
				| '520,00'    | 'XS/Blue'    | 'pcs'      |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Price type'          | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Profit loss center'    |
			| '400,00'   | 'Trousers'   | '18%'   | '38/Yellow'   | '1,000'      | 'Basic Price Types'   | 'pcs'    | '61,02'        | '338,98'       | '400,00'         | 'Store 01'   | 'Shop 01'               |
			| '350,00'   | 'Shirt'      | '18%'   | '38/Black'    | '2,000'      | 'Basic Price Types'   | 'pcs'    | '106,78'       | '593,22'       | '700,00'         | 'Store 01'   | 'Shop 01'               |
			| '550,00'   | 'Dress'      | '18%'   | 'L/Green'     | '1,000'      | 'Basic Price Types'   | 'pcs'    | '83,90'        | '466,10'       | '550,00'         | 'Store 01'   | 'Shop 01'               |
			| '520,00'   | 'Dress'      | '18%'   | 'XS/Blue'     | '1,000'      | 'Basic Price Types'   | 'pcs'    | '79,32'        | '440,68'       | '520,00'         | 'Store 01'   | 'Shop 01'               |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I delete a line in "ItemList" table
		And "ItemList" table does not contain lines
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
	* Check tax recalculation when uncheck/re-check Price includes tax
		* Unchecking box Price includes tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price includes tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'          | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Profit loss center'    |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '126,00'       | '700,00'       | '826,00'         | 'Store 01'   | 'Shop 01'               |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '99,00'        | '550,00'       | '649,00'         | 'Store 01'   | 'Shop 01'               |
			| '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '93,60'        | '520,00'       | '613,60'         | 'Store 01'   | 'Shop 01'               |
		* Tick Price includes tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'          | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Profit loss center'    |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 01'   | 'Shop 01'               |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '83,90'        | '466,10'       | '550,00'         | 'Store 01'   | 'Shop 01'               |
			| '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '79,32'        | '440,68'       | '520,00'         | 'Store 01'   | 'Shop 01'               |
	* Check filling in the Price includes tax check boxes when re-selecting an agreement and check tax recalculation
		* Re-select partner term for which Price includes tax is not ticked 
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                          |
				| 'Basic Partner terms, without VAT'     |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check that the Price includes tax checkbox value has been filled out from the partner term
			Then the form attribute named "PriceIncludeTax" became equal to "No"
		* Check tax recalculation 
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'                | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Profit loss center'    |
			| '296,61'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'Basic Price without VAT'   | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 02'   | 'Shop 01'               |
			| '466,10'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'Basic Price without VAT'   | 'pcs'    | 'No'                   | '83,90'        | '466,10'       | '550,00'         | 'Store 02'   | 'Shop 01'               |
			| '440,68'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'Basic Price without VAT'   | 'pcs'    | 'No'                   | '79,32'        | '440,68'       | '520,00'         | 'Store 02'   | 'Shop 01'               |
		* Change of partner term to what was earlier
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		* Tax recalculation check
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'          | 'Unit'   | 'Dont calculate row'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Profit loss center'    |
			| '350,00'   | 'Shirt'   | '18%'   | '38/Black'   | '2,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '106,78'       | '593,22'       | '700,00'         | 'Store 01'   | 'Shop 01'               |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '1,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '83,90'        | '466,10'       | '550,00'         | 'Store 01'   | 'Shop 01'               |
			| '520,00'   | 'Dress'   | '18%'   | 'XS/Blue'    | '1,000'      | 'Basic Price Types'   | 'pcs'    | 'No'                   | '79,32'        | '440,68'       | '520,00'         | 'Store 01'   | 'Shop 01'               |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Cash'            |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 770,00" text in "Amount" field of "Payments" table
		* Check filling in currency tab
			And I click "Save" button
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'         | 'Type'            | 'To'     | 'From'    | 'Multiplicity'    | 'Rate'      | 'Amount'     |
				| 'Reporting currency'    | 'Reporting'       | 'USD'    | 'TRY'     | '1'               | '0,171200'    | '303,02'     |
				| 'Local currency'        | 'Legal'           | 'TRY'    | 'TRY'     | '1'               | '1'         | '1 770'      |
				| 'TRY'                   | 'Partner term'    | 'TRY'    | 'TRY'     | '1'               | '1'         | '1 770'      |
			And I close current window
		* Check recalculate Total amount and Net amount when change Tax rate
			* Price includes tax
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'      | 'Item key'     | 'Price'       |
					| 'Dress'     | 'L/Green'      | '550,00'      |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Quantity'    | 'Price type'           | 'Unit'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Profit loss center'     |
				| '350,00'    | 'Shirt'    | '18%'    | '38/Black'    | '2,000'       | 'Basic Price Types'    | 'pcs'     | '106,78'        | '593,22'        | '700,00'          | 'Store 01'    | 'Shop 01'                |
				| '550,00'    | 'Dress'    | '0%'     | 'L/Green'     | '1,000'       | 'Basic Price Types'    | 'pcs'     | ''              | '550,00'        | '550,00'          | 'Store 01'    | 'Shop 01'                |
				| '520,00'    | 'Dress'    | '18%'    | 'XS/Blue'     | '1,000'       | 'Basic Price Types'    | 'pcs'     | '79,32'         | '440,68'        | '520,00'          | 'Store 01'    | 'Shop 01'                |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 583,90"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "186,10"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 770,00"
			* Price does not include tax
				And I go to line in "ItemList" table
					| 'Item'      | 'Item key'     | 'Price'       |
					| 'Dress'     | 'L/Green'      | '550,00'      |
				And I select current line in "ItemList" table
				And I activate "VAT" field in "ItemList" table
				And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
				And I move to "Other" tab
				And I remove checkbox "Price includes tax"
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| 'Item'      | 'Item key'     | 'Price'      | 'Quantity'      |
					| 'Shirt'     | '38/Black'     | '350,00'     | '2,000'         |
				And I select current line in "ItemList" table
				And I select "0%" exact value from "VAT" drop-down list in "ItemList" table
				And I finish line editing in "ItemList" table
				And "ItemList" table contains lines
				| 'Price'     | 'Item'     | 'VAT'    | 'Item key'    | 'Quantity'    | 'Price type'           | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Profit loss center'     |
				| '350,00'    | 'Shirt'    | '0%'     | '38/Black'    | '2,000'       | 'Basic Price Types'    | 'pcs'     | 'No'                    | ''              | '700,00'        | '700,00'          | 'Store 01'    | 'Shop 01'                |
				| '550,00'    | 'Dress'    | '18%'    | 'L/Green'     | '1,000'       | 'Basic Price Types'    | 'pcs'     | 'No'                    | '99,00'         | '550,00'        | '649,00'          | 'Store 01'    | 'Shop 01'                |
				| '520,00'    | 'Dress'    | '18%'    | 'XS/Blue'     | '1,000'       | 'Basic Price Types'    | 'pcs'     | 'No'                    | '93,60'         | '520,00'        | '613,60'          | 'Store 01'    | 'Shop 01'                |
				And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
				Then the form attribute named "ItemListTotalNetAmount" became equal to "1 770,00"
				Then the form attribute named "ItemListTotalTaxAmount" became equal to "192,60"
				And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 962,60"
		* Change price type
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'    | 'Price'     | 'Price type'           | 'Quantity'     |
				| 'Dress'    | 'XS/Blue'     | '520,00'    | 'Basic Price Types'    | '1,000'        |
			And I select current line in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'                 |
				| 'Basic Price without VAT'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Profit loss center'    | 'Price type'                 | 'Item'     | 'Item key'    | 'Dont calculate row'    | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Price'     | 'VAT'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| 'Shop 01'               | 'Basic Price Types'          | 'Shirt'    | '38/Black'    | 'No'                    | '2,000'       | 'pcs'     | ''              | '350,00'    | '0%'     | '700,00'        | '700,00'          | 'Store 01'     |
				| 'Shop 01'               | 'Basic Price Types'          | 'Dress'    | 'L/Green'     | 'No'                    | '1,000'       | 'pcs'     | '99,00'         | '550,00'    | '18%'    | '550,00'        | '649,00'          | 'Store 01'     |
				| 'Shop 01'               | 'Basic Price without VAT'    | 'Dress'    | 'XS/Blue'     | 'No'                    | '1,000'       | 'pcs'     | '79,32'         | '440,68'    | '18%'    | '440,68'        | '520,00'          | 'Store 01'     |
		* Change unit and check price re-calculation
			And I go to line in "ItemList" table
				| 'Profit loss center'    | 'Dont calculate row'    | 'Item'     | 'Item key'    | 'Net amount'    | 'Price'     | 'Price type'           | 'Quantity'    | 'Store'       | 'Tax amount'    | 'Total amount'    | 'Unit'    | 'VAT'     |
				| 'Shop 01'               | 'No'                    | 'Dress'    | 'L/Green'     | '550,00'        | '550,00'    | 'Basic Price Types'    | '1,000'       | 'Store 01'    | '99,00'         | '649,00'          | 'pcs'     | '18%'     |
			And I select current line in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And "List" table does not contain lines
				| 'Description'     |
				| 'box (8 pcs)'     |
			And "List" table contains lines
				| 'Description'           |
				| 'pcs'                   |
				| 'box Dress (8 pcs)'     |
			Then the number of "List" table lines is "равно" "2"
			And I go to line in "List" table
				| 'Description'           |
				| 'box Dress (8 pcs)'     |
			And I select current line in "List" table
			And "ItemList" table contains lines
				| 'Profit loss center'    | 'Price type'                 | 'Item'     | 'Item key'    | 'Dont calculate row'    | 'Quantity'    | 'Unit'                 | 'Tax amount'    | 'Price'       | 'VAT'    | 'Net amount'    | 'Total amount'    | 'Store'        |
				| 'Shop 01'               | 'Basic Price Types'          | 'Shirt'    | '38/Black'    | 'No'                    | '2,000'       | 'pcs'                  | ''              | '350,00'      | '0%'     | '700,00'        | '700,00'          | 'Store 01'     |
				| 'Shop 01'               | 'Basic Price Types'          | 'Dress'    | 'L/Green'     | 'No'                    | '1,000'       | 'box Dress (8 pcs)'    | '792,00'        | '4 400,00'    | '18%'    | '4 400,00'      | '5 192,00'        | 'Store 01'     |
				| 'Shop 01'               | 'Basic Price without VAT'    | 'Dress'    | 'XS/Blue'     | 'No'                    | '1,000'       | 'pcs'                  | '79,32'         | '440,68'      | '18%'    | '440,68'        | '520,00'          | 'Store 01'     |
			And I close all client application windows
			
						
							

Scenario: _0154156 check Retail sales receipt when changing date
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling in partner and Legal name
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I select current line in "List" table
	* Filling in an Partner term
		And I click Select button of "Partner term" field
		Then the number of "List" table lines is "меньше или равно" 4
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Add items and check prices on the current date
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/Brown'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Price'   | 'Item'   | 'VAT'  | 'Item key'  | 'Quantity'  | 'Price type'         | 'Unit'  | 'Dont calculate row'  | 'Tax amount'  | 'Net amount'  | 'Total amount'  | 'Store'     | 'Profit loss center'   |
		| '500,00'  | 'Dress'  | '18%'  | 'M/Brown'   | '1,000'     | 'Basic Price Types'  | 'pcs'   | 'No'                  | '76,27'       | '423,73'      | '500,00'        | 'Store 01'  | 'Shop 01'              |
	* Change of date and check of price and tax recalculation
		And I move to "Other" tab
		And I expand "More" group
		And I input "01.11.2018 10:00:00" text in "Date" field
		And I move to "Item list" tab
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'    | 'Price'      | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Store'       |
			| 'Dress'   | '1 000,00'   | 'M/Brown'    | '1,000'      | 'pcs'    | '1 000,00'       | 'Store 01'    |
	* Check the list of partner terms
		And I click Select button of "Partner term" field
		And "List" table contains lines
		| 'Description'                        |
		| 'Basic Partner terms, TRY'           |
		| 'Basic Partner terms, $'             |
		| 'Basic Partner terms, without VAT'   |
		| 'Personal Partner terms, $'          |
		| 'Sale autum, TRY'                    |
		And I close "Partner terms" window
	* Check the recount of the currency table when the date is changed
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'    |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,200000' | '200,00'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '1 000'     |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '1 000'     |
		And I close all client application windows
		
		

Scenario: _0154158 check function DontCalculateRow in the Retail sales receipt
	And I close all client application windows
	* Open the Retail sales receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'                |
			| 'Company Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'            |
			| 'Retail partner term'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"		
		And I move to "Item list" tab
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
				| 'Dress'    | 'L/Green'      |
			And I select current line in "List" table
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '144,00'        | '800,00'        | '944,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
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
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '150,00'        | '801,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Cash'            |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'      |
				| 'Transit Main'     |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "4 196,00" text in "Amount" field of "Payments" table
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '150,00'        | '801,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '801,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '954,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '954,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
				| '520,00'    | 'Dress'       | '18%'    | 'M/White'      | '2,000'       | 'pcs'     | 'No'                    | '187,20'        | '1 040,00'      | '1 227,20'         |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '954,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
				| '520,00'    | 'Dress'       | '18%'    | 'M/White'      | '2,000'       | 'pcs'     | 'No'                    | '158,64'        | '881,36'        | '1 040,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "4 011,87"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "730,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 744,00"
		* Change payment
			And I move to "Payments" tab
			And I select current line in "Payments" table
			And I input "4 744,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table	
			And I click the button named "FormPostAndClose"



Scenario: _0154170 check function DontCalculateRow in the Retail return receipt
	* Open the Retail return receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'                |
			| 'Company Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'            |
			| 'Retail partner term'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"		
		And I move to "Item list" tab
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And in the table "ItemList" I click the button named "ItemListAdd"	
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
				| 'Dress'    | 'L/Green'      |
			And I select current line in "List" table
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '144,00'        | '800,00'        | '944,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Check function DontCalculateRow 
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I activate "Dont calculate row" field in "ItemList" table
			And I set "Dont calculate row" checkbox in "ItemList" table			
			And I finish line editing in "ItemList" table
			And I activate "Tax amount" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select current line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
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
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '150,00'        | '801,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And I click the button named "FormPost"
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '150,00'        | '801,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "645,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change tax amount
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I input "152,00" text in "Tax amount" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '801,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 551,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"			
		* Change net amount
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I input "800,00" text in the field named "ItemListNetAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '951,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 196,00"
		* Change total amount
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'     | 'Quantity'     |
				| 'Trousers'    | '38/Yellow'    | '2,000'        |
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I input "954,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '954,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
			And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "3 550,00"
			And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "647,00"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 199,00"
		* Add new line and check calculation
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
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table	
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '954,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
				| '520,00'    | 'Dress'       | '18%'    | 'M/White'      | '2,000'       | 'pcs'     | 'No'                    | '187,20'        | '1 040,00'      | '1 227,20'         |
		* Check calculation when set "Price includes tax" checkbox
			And I move to "Other" tab
			And I set checkbox "Price includes tax"		
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'Yes'                   | '152,00'        | '800,00'        | '954,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
				| '520,00'    | 'Dress'       | '18%'    | 'M/White'      | '2,000'       | 'pcs'     | 'No'                    | '158,64'        | '881,36'        | '1 040,00'         |
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
			| 'Description'        |
			| 'Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'                |
			| 'Company Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'            |
			| 'Retail partner term'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"
		And I move to "Item list" tab			
	* Filling in item and item key
		And in the table "ItemList" I click the button named "ItemListAdd"	
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
		And I select current line in "List" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '144,00'        | '800,00'        | '944,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,43'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '144,15'        | '800,85'        | '945,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,43'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '216,23'        | '1 201,29'      | '1 417,52'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,56'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '216,31'        | '1 201,69'      | '1 418,00'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,56'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '183,31'        | '1 018,37'      | '1 201,68'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '183,05'        | '1 016,95'      | '1 200,00'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '122,03'        | '677,97'        | '800,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
			And I close all client application windows	



Scenario: _0154172 check tax and net amount calculation when change total amount in the Retail return receipt
	* Open the Retail return receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'                |
			| 'Company Retail customer'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'            |
			| 'Retail partner term'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I remove checkbox "Price includes tax"
		And I move to "Item list" tab			
	* Filling in item and item key
		And in the table "ItemList" I click the button named "ItemListAdd"	
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"	
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
		And I select current line in "List" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '144,00'        | '800,00'        | '944,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Check tax and net amount calculation when change total amount (Price does not include tax)
			And I activate field named "ItemListTotalAmount" in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "945,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,43'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '144,15'        | '800,85'        | '945,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "3,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,43'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '216,23'        | '1 201,29'      | '1 417,52'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Change total amount and check tax and net amount calculation (Price does not include tax)
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "1418,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,56'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '216,31'        | '1 201,69'      | '1 418,00'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '495,00'        | '2 750,00'      | '3 245,00'         |
		* Set checkbox Price includes tax and check tax and net amount calculation when change total amount
			And I move to "Other" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,56'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '183,31'        | '1 018,37'      | '1 201,68'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "1200,00" text in the field named "ItemListTotalAmount" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '3,000'       | 'pcs'     | 'No'                    | '183,05'        | '1 016,95'      | '1 200,00'         |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
		* Change quantity and check tax and net amount calculation 
			And I go to line in "ItemList" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And "ItemList" table contains lines
				| 'Price'     | 'Item'        | 'VAT'    | 'Item key'     | 'Quantity'    | 'Unit'    | 'Dont calculate row'    | 'Tax amount'    | 'Net amount'    | 'Total amount'     |
				| '400,00'    | 'Trousers'    | '18%'    | '38/Yellow'    | '2,000'       | 'pcs'     | 'No'                    | '122,03'        | '677,97'        | '800,00'           |
				| '550,00'    | 'Dress'       | '18%'    | 'L/Green'      | '5,000'       | 'pcs'     | 'No'                    | '419,49'        | '2 330,51'      | '2 750,00'         |
			And I close all client application windows	

Scenario: _0154175 check change amount in POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '1,000'      | '550,00'   | ''         | '550,00'    |
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '1,000'      | '550,00'   | ''         | '550,00'    |
			| 'Dress'   | 'S/Yellow'   | '1,000'      | '550,00'   | ''         | '550,00'    |
	* Change AMOUNT and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'   | 'Total'     |
			| 'Dress'   | 'L/Green'    | '550,00'   | '1,000'      | '550,00'    |
		And I select current line in "ItemList" table
		And I input "500,00" text in "Total" field of "ItemList" table
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "1 050"
		And Delay 2
	* Payment (Cash)
		And I click "Payment (+)" button
		And I click "1" button
		And I click "0" button
		And I click "5" button
		And I click "0" button
		And I click "OK" button
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
			| 'Profit loss center'   | 'Item'    | 'Price type'                | 'Item key'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'       |
			| 'Shop 01'              | 'Dress'   | 'en description is empty'   | 'L/Green'    | '1,000'      | 'pcs'    | '76,27'        | '500,00'   | '18%'   | ''                | '423,73'       | '500,00'         | ''                      | 'Store 01'    |
			| 'Shop 01'              | 'Dress'   | 'Basic Price Types'         | 'S/Yellow'   | '1,000'      | 'pcs'    | '83,90'        | '550,00'   | '18%'   | ''                | '466,10'       | '550,00'         | ''                      | 'Store 01'    |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "889,83"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "160,17"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 050,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows


Scenario: _0154182 check filling in Retail sales when select retail customer (with partner) in POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"	
	* Add items and payment
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'             |
			| '(10001) Dress'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                              |
			| '(10001) Dress, (BN898) M/White'    |
		And I select current line in "ItemsPickup" table
	* Select retail customer with own partner term
	* Select retail customer
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'                                     |
			| 'Name Retail customer Surname Retail customer'    |
		And I select current line in "List" table
		And I click "OK" button
		#Then "Update item list info" window is opened
		#And I click "OK" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Serials'   | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Dress'   | 'M/White'    | ''          | '1,000'      | '440,68'   | ''         | '520,00'    |
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
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
			| 'Price type'                | 'Item'    | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Revenue type'   | 'Detail'    |
			| 'Basic Price without VAT'   | 'Dress'   | 'M/White'    | 'Shop 01'              | 'No'                   | ''                     | '1,000'      | 'pcs'    | '79,32'        | '440,68'   | '18%'   | ''                | '440,68'       | '520,00'         | ''                      | 'Store 01'   | ''               | ''          |
		And "Payments" table contains lines
			| 'Amount'   | 'Payment type'    |
			| '520,00'   | 'Cash'            |
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
			| 'Number'                                 |
			| '$$NumberRetailSalesReceipt0154140$$'    |
	* Copy Retail sales receipt and check filling in
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Olga Olhovska"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| 'Profit loss center'   | 'Price type'          | 'Item'    | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Revenue type'   | 'Detail'    |
			| 'Shop 01'              | 'Basic Price Types'   | 'Dress'   | 'M/White'    | 'No'                   | ''                     | '1,000'      | 'pcs'    | '79,32'        | '520,00'   | '18%'   | ''                | '440,68'       | '520,00'         | ''                      | 'Store 01'   | ''               | ''          |
		And "Payments" table became equal
			| 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Bank term'   | 'Account'        | 'Percent'    |
			| '520,00'   | ''             | 'Cash'           | ''                   | ''            | 'Cash desk №2'   | ''           |
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'    |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '89,02'     |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '520'       |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '520'       |
		And I close current window
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
		

Scenario: _0154191 create payment type group
	* Open payment type catalog
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
	* Create payment type group
		And I click "Create" button
		And I input "Bank 01" text in "ENG" field
		And I click "Save and close" button
		And I click "Create" button
		And I input "Bank 02" text in "ENG" field
		And I click "Save and close" button
	* Create 2 payment type in group
		And I click "Create" button
		And I input "Card 03" text in "ENG" field
		And I select "Card" exact value from the drop-down list named "Type"
		And I click Choice button of the field named "Parent"
		Then "Payment types" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank 02'        |
		And I select current line in "List" table		
		And I click "Save and close" button
		And I click "Create" button
		And I input "Card 04" text in "ENG" field
		And I select "Card" exact value from the drop-down list named "Type"
		And I click Choice button of the field named "Parent"
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank 02'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I close all client application windows
		

Scenario: _0154192 create document Retail Sales Receipt from Point of sale (payment by card)
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I go to line in "List" table
			| 'Description'     |
			| 'Bank term 01'    |
		And I select current line in "List" table
		Then "Bank term * (Bank term)" window is opened
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		Then "Payment types" window is opened
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 03'        |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		Then "Bank term * (Bank term) *" window is opened
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		Then "Cash/Bank accounts" window is opened
		And I go to line in "List" table
			| 'Description'     |
			| 'Transit Main'    |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		Then "Bank term * (Bank term) *" window is opened
		And I activate "Percent" field in "PaymentTypes" table
		And I input "1,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		Then "Payment types" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 04'        |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		Then "Bank term * (Bank term) *" window is opened
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		Then "Cash/Bank accounts" window is opened
		And I go to line in "List" table
			| 'Description'     |
			| 'Transit Main'    |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		Then "Bank term * (Bank term) *" window is opened
		And I activate "Percent" field in "PaymentTypes" table
		And I input "1,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And I click "Save and close" button		
		And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (pick up)
		And I move to "Items" tab	
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10002) Trousers'    |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                                 |
			| '(10002) Trousers, (899) 38/Yellow'    |
		And I select current line in "ItemsPickup" table
	* Select retail customer with own partner term
		And "ItemList" table became equal
			| 'Item'       | 'Item key'    | 'Quantity'   | 'Price'    | 'Offers'   | 'Total'     |
			| 'Trousers'   | '38/Yellow'   | '1,000'      | '400,00'   | ''         | '400,00'    |
	* Payment (Card)
		And I click "Payment (+)" button
		And I click "Card (*)" button
	* Select payment type from group					
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table
		And I click "2" button
		And I click "0" button
		And I click "0" button
		And I move to the next attribute		
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 02'      |
		And I select current line in "BankPaymentTypeList" table	
		And I click "2" button
		And I click "0" button
		And I click "0" button
		And I move to the next attribute
		And I click "OK" button
		And I close all client application windows
		
Scenario: _0154193 check print last receipt from POS
		And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Print receipt
		And I click "Print last receipt" button
		And in "Result" spreadsheet document I move to "R2C2" cell
		Then "Print form" window is opened
		And I click the button named "FormEditResult"
		And I click the button named "FormShow"		
		And "PrintFormConfig" table contains lines
			| 'Print'   | 'Object'                  | 'Template'   | 'Count copy'    |
			| 'Yes'     | 'Retail sales receipt*'   | ''           | '1'             |
		And in "Result" spreadsheet document I move to "R16C4" cell
		And in "Result" spreadsheet document I double-click the current cell
		And in "Result" spreadsheet document I input text "111"
		And in "Result" spreadsheet document I move to "R21C4" cell
		And I activate "Count copy" field in "PrintFormConfig" table
		And I select current line in "PrintFormConfig" table
		And I input "2" text in "Count copy" field of "PrintFormConfig" table
		And I finish line editing in "PrintFormConfig" table	
		Then user message window does not contain messages
		And I close all client application windows


Scenario: _0154195 set sales person from POS
	* Filling RetailWorkers register
		Given I open hyperlink "e1cib/list/InformationRegister.RetailWorkers"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Worker"
		And I go to line in "List" table
			| 'Description'    |
			| 'Arina Brown'    |
		And I select current line in "List" table
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Worker"
		And I go to line in "List" table
			| 'Description'     |
			| 'Anna Petrova'    |
		And I select current line in "List" table
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Worker"
		And I go to line in "List" table
			| 'Description'      |
			| 'David Romanov'    |
		And I select current line in "List" table
		And I click "Save and close" button
	* Filling RetailPerson from POS
		* Open Point of sale
			And In the command interface I select "Retail" "Point of sale"
		* Add item and select Retail person
			And I expand a line in "ItemsPickup" table
				| 'Item'              |
				| '(10003) Shirt'     |
			And I go to line in "ItemsPickup" table
				| 'Item'                        |
				| '(10003) Shirt, 38/Black'     |
			And I select current line in "ItemsPickup" table
			And "Table1" table became equal
				| 'Column1'           |
				| 'Anna Petrova'      |
				| 'David Romanov'     |
			And I go to line in "" table
				| 'Column1'          |
				| 'Anna Petrova'     |
			And I select current line in "" table
			And I click "Search by barcode (F7)" button
			And I input "2202283739" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Set sales person" button
			And I go to line in "" table
				| 'Column1'           |
				| 'David Romanov'     |
			And I select current line in "" table
		* Check 
			And "ItemList" table became equal
				| 'Item'     | 'Sales person'     | 'Item key'    | 'Serials'    | 'Price'     | 'Quantity'    | 'Offers'    | 'Total'      |
				| 'Shirt'    | 'Anna Petrova'     | '38/Black'    | ''           | '350,00'    | '1,000'       | ''          | '350,00'     |
				| 'Dress'    | 'David Romanov'    | 'L/Green'     | ''           | '550,00'    | '1,000'       | ''          | '550,00'     |
			And I click "Clear current receipt" button
			And I close all client application windows

Scenario: _0154196 check comission calculation in the Retail sales receipt
		And I close all client application windows
	* Open RSR form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling payments tab
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Bank term" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Bank term" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Bank term 01'    |
		And I select current line in "List" table
		And I activate "Payment type" field in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "Payments" table
		And I click choice button of "Payment terminal" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Payment terminal 01'    |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		And I finish line editing in "Payments" table	
	* Check comission calculation (sum and commision percent)
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "333,33" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '333,33'   | '3,33'         | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
	* Change comission percent
		And I activate "Percent" field in "Payments" table
		And I select current line in "Payments" table
		And I input "5,00" text in "Percent" field of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '333,33'   | '16,67'        | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '5,00'       |
	* Change comission sum
		And I activate "Commission" field in "Payments" table
		And I select current line in "Payments" table
		And I input "22,52" text in "Commission" field of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '333,33'   | '22,52'        | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '6,76'       |
	* Change payment type
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 02'        |
		And I select current line in "List" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '333,33'   | '6,67'         | 'Card 02'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Transit Second'      | '2,00'       |
	* Change sum
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "999,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'          | 'Percent'    |
			| '1'   | '999,00'   | '19,98'        | 'Card 02'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Transit Second'   | '2,00'       |
		And I close all client application windows
		
		

Scenario: _0154197 check comission calculation in the Retail return receipt
		And I close all client application windows
	* Open RRR form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling payments tab
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Bank term" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Bank term" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Bank term 01'    |
		And I select current line in "List" table
		And I activate "Payment type" field in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "Payments" table
		And I click choice button of "Payment terminal" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Payment terminal 01'    |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		And I finish line editing in "Payments" table	
	* Check comission calculation (sum and commision percent)
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "333,33" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '333,33'   | '3,33'         | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
	* Change comission percent
		And I activate "Percent" field in "Payments" table
		And I select current line in "Payments" table
		And I input "5,00" text in "Percent" field of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '333,33'   | '16,67'        | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '5,00'       |
	* Change comission sum
		And I activate "Commission" field in "Payments" table
		And I select current line in "Payments" table
		And I input "22,52" text in "Commission" field of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '333,33'   | '22,52'        | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '6,76'       |
	* Change payment type
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 02'        |
		And I select current line in "List" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'          | 'Percent'    |
			| '1'   | '333,33'   | '6,67'         | 'Card 02'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Transit Second'   | '2,00'       |
	* Change sum
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "999,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Postponed payment'   | 'Bank term'      | 'Account'          | 'Percent'    |
			| '1'   | '999,00'   | '19,98'        | 'Card 02'        | 'Payment terminal 01'   | 'No'                  | 'Bank term 01'   | 'Transit Second'   | '2,00'       |
		
		And I close all client application windows				
		
					
Scenario: _0154198 copy line in Payment tab in the Retail return receipt	
	And I close all client application windows
	* Open RRR form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling payments tab
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Bank term" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Bank term" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Bank term 01'    |
		And I select current line in "List" table
		And I activate "Payment type" field in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "Payments" table
		And I click choice button of "Payment terminal" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Payment terminal 01'    |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		And I finish line editing in "Payments" table	
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "100,33" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table	
	* Check line copy
		And I activate "Bank term" field in "Payments" table
		And in the table "Payments" I click the button named "PaymentsContextMenuCopy"
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Postponed payment'   | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '100,33'   | '1,00'         | 'Card 01'        | 'Payment terminal 01'   | 'No'                  | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
			| '2'   | '100,33'   | '1,00'         | 'Card 01'        | 'Payment terminal 01'   | 'No'                  | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
	* Delete line
		And I go to line in "Payments" table
			| '#'   | 'Account'             | 'Amount'   | 'Bank term'      | 'Commission'   | 'Payment terminal'      | 'Payment type'   | 'Percent'    |
			| '2'   | 'Bank account, TRY'   | '100,33'   | 'Bank term 01'   | '1,00'         | 'Payment terminal 01'   | 'Card 01'        | '1,00'       |
		And I delete a line in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '100,33'   | '1,00'         | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
		And I close all client application windows
		
	

Scenario: _0154199 copy line in Payment tab in the Retail sales receipt	
	And I close all client application windows
	* Open RSR form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling payments tab
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Bank term" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Bank term" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Bank term 01'    |
		And I select current line in "List" table
		And I activate "Payment type" field in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "Payments" table
		And I click choice button of "Payment terminal" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Payment terminal 01'    |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		And I finish line editing in "Payments" table	
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "100,33" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table	
	* Check line copy
		And I activate "Bank term" field in "Payments" table
		And in the table "Payments" I click the button named "PaymentsContextMenuCopy"
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '100,33'   | '1,00'         | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
			| '2'   | '100,33'   | '1,00'         | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
	* Delete line
		And I go to line in "Payments" table
			| '#'   | 'Account'             | 'Amount'   | 'Bank term'      | 'Commission'   | 'Payment terminal'      | 'Payment type'   | 'Percent'    |
			| '2'   | 'Bank account, TRY'   | '100,33'   | 'Bank term 01'   | '1,00'         | 'Payment terminal 01'   | 'Card 01'        | '1,00'       |
		And I delete a line in "Payments" table
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'      | 'Account'             | 'Percent'    |
			| '1'   | '100,33'   | '1,00'         | 'Card 01'        | 'Payment terminal 01'   | 'Bank term 01'   | 'Bank account, TRY'   | '1,00'       |
		And I close all client application windows
		
		

Scenario: _0154200 create postponed RSR with a reservation (CRS not used)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I click "OK" button	
	* Add items
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute	
		If "Select sales person" window is opened Then
			And I go to line in "" table
				| 'Column1'       |
				| 'David Romanov' |
			And I select current line in "" table	
	* Postponed RSR with a reservation
		And I click "Postpone current receipt with reserve" button
		Then the number of "ItemList" table lines is "равно" "0"		
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| 'Price type'        | 'Item'  | 'Item key' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | 'Store 01' |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed with reserve"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "440,68"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "79,32"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "520,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I delete "$$NumberPostponedRSR1$$" variable
		And I delete "$$PostponedRSR1$$" variable
		And I delete "$$DatePostponedRSR1$$" variable
		And I save the value of "Number" field as "$$NumberPostponedRSR1$$"
		And I save the window as "$$PostponedRSR1$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR1$$"
	* Check reservation
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRSR1$$'                   | ''            | ''                      | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'      | ''            | ''                      | ''          | ''           | ''         | ''                  |
			| 'Register  "R4012 Stock Reservation"' | ''            | ''                      | ''          | ''           | ''         | ''                  |
			| ''                                    | 'Record type' | 'Period'                | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                    | ''            | ''                      | 'Quantity'  | 'Store'      | 'Item key' | 'Order'             |
			| ''                                    | 'Receipt'     | '$$DatePostponedRSR1$$' | '1'         | 'Store 01'   | 'XS/Blue'  | '$$PostponedRSR1$$' |
		And I close all client application windows

Scenario: _0154201 create postponed RSR without a reservation (CRS not used)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I click "OK" button	
	* Add items
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		If "Select sales person" window is opened Then
			And I go to line in "" table
				| 'Column1'       |
				| 'David Romanov' |
			And I select current line in "" table
	* Postponed RSR with a reservation
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"	
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| 'Price type'        | 'Item'  | 'Item key' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | 'Store 01' |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "440,68"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "79,32"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "520,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I delete "$$NumberPostponedRSR2$$" variable
		And I delete "$$PostponedRSR2$$" variable
		And I delete "$$DatePostponedRSR2$$" variable
		And I save the value of "Number" field as "$$NumberPostponedRSR2$$"
		And I save the window as "$$PostponedRSR2$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR2$$"
	* Check 
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRSR2$$'                     | ''                  | ''                      | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| 'Document registrations records'        | ''                  | ''                      | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| 'Register  "Posted documents registry"' | ''                  | ''                      | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| ''                                      | 'Dimensions'        | 'Attributes'            | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| ''                                      | 'Document'          | 'Date'                  | 'Number'                  | 'Create date'           | 'Modify date' | 'Author' | 'Editor' | 'Manual movements edit' |
			| ''                                      | '$$PostponedRSR2$$' | '$$DatePostponedRSR2$$' | '$$NumberPostponedRSR2$$' | '$$DatePostponedRSR2$$' | ''            | 'CI'     | ''       | 'No'                    |
		And I close current window


Scenario: _0154202 create postponed RRR (CRS not used)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I click "OK" button	
	* Add items
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		If "Select sales person" window is opened Then
			And I go to line in "" table
				| 'Column1'       |
				| 'David Romanov' |
			And I select current line in "" table	
	* Postponed RSR with a reservation
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"	
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| 'Price type'        | 'Item'  | 'Item key' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | 'Store 01' |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "440,68"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "79,32"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "520,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I delete "$$NumberPostponedRSR2$$" variable
		And I delete "$$PostponedRSR2$$" variable
		And I delete "$$DatePostponedRSR2$$" variable
		And I save the value of "Number" field as "$$NumberPostponedRSR2$$"
		And I save the window as "$$PostponedRSR2$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR2$$"
	* Check 
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRSR2$$'                     | ''                  | ''                      | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| 'Document registrations records'        | ''                  | ''                      | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| 'Register  "Posted documents registry"' | ''                  | ''                      | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| ''                                      | 'Dimensions'        | 'Attributes'            | ''                        | ''                      | ''            | ''       | ''       | ''                      |
			| ''                                      | 'Document'          | 'Date'                  | 'Number'                  | 'Create date'           | 'Modify date' | 'Author' | 'Editor' | 'Manual movements edit' |
			| ''                                      | '$$PostponedRSR2$$' | '$$DatePostponedRSR2$$' | '$$NumberPostponedRSR2$$' | '$$DatePostponedRSR2$$' | ''            | 'CI'     | ''       | 'No'                    |			
		And I close current window

Scenario: _0154203 create postponed RRR without a reservation and without bases (CRS not used)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I click "OK" button	
		And I click the button named "Return"		
	* Add items
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		If "Select sales person" window is opened Then
			And I go to line in "" table
				| 'Column1'       |
				| 'David Romanov' |
			And I select current line in "" table
	* Postponed RSR without a reservation
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "440,68"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "79,32"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "520,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | 'Store 01' |
	And I close all client application windows


Scenario: _0154205 cancel postponed receipt (CRS not used)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Open postponed receipt
		And I click "Open postponed receipt" button
	* Cancel postponed receipt
		And I select all lines of "Receipts" table
		And in the table "Receipts" I click "Cancel receipts" button
		Then the number of "Receipts" table lines is "равно" "0"
		Then in the TestClient message log contains lines by template:
			|'* postponed receipts cancelled'|
	And I close all client application windows
	
		