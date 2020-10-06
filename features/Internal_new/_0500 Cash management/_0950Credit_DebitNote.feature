#language: en
@tree
@Positive
@CashManagement


Feature: Credit note and Debit note
As an accountant
I want to create a Credit_DebitNote document.
For write-off of accounts receivable and payable

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _095001 preparation
	* Constants
		When set True value to the constant
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
		When Create catalog Partners objects
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Countries objects
		When Create catalog BusinessUnits objects 
	* Tax settings
		When filling in Tax settings for company
	* Create a Sales invoice for creating customer
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice095001$$" |
			And I click the button named "FormCreate"
			And I select from "Partner" drop-down list by "Lunch" string
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "15,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Other" tab
			And I expand "Currency" group
			And I move to the tab named "GroupCurrency"
			And I expand "More" group
			// And I input "2 900" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "2 900" text in "Number" field
			And I input "01.01.2020  10:00:00" text in "Date" field
			And Delay 1
			And I move to "Item list" tab
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberSalesInvoice095001$$"
			And I save the window as "$$SalesInvoice095001$$"
			And I click the button named "FormPostAndClose"
	* Create Purchase invoice for creating vendor
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice095001$$" |
			And I click the button named "FormCreate"
			* Filling data about vendor
				And I click Select button of "Partner" field
				And I go to line in "List" table
					| 'Description' |
					| 'Maxim'     |
				And I select current line in "List" table
				And I click Select button of "Legal name" field
				And I go to line in "List" table
					| 'Description'   |
					| 'Company Maxim' |
				And I select current line in "List" table
			// * Change the document number to 601
			// 	And I move to "Other" tab
			// 	And I input "2 900" text in "Number" field
			// 	Then "1C:Enterprise" window is opened
			// 	And I click "Yes" button
			// 	And I input "2 900" text in "Number" field
			* Adding items to Purchase Invoice
				And I move to "Item list" tab
				And I click the button named "Add"
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key' |
					| 'L/Green'  |
				And I select current line in "List" table
				And I activate "Q" field in "ItemList" table
				And I input "20,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I input "550,00" text in "Price" field of "ItemList" table
			* Change of date in Purchase invoice
				And I move to "Other" tab
				And I input "01.01.2020  10:00:00" text in "Date" field
				And Delay 1
				And I move to "Item list" tab
				And Delay 5
				Then "Update item list info" window is opened
				And I change checkbox "Do you want to update filled price types on Vendor price, TRY?"
				And I change checkbox "Do you want to update filled prices?"
				And I click "OK" button
				And I click the button named "FormPost"
				And I save the value of "Number" field as "$$NumberPurchaseInvoice095001$$"
				And I save the window as "$$PurchaseInvoice095001$$"
				And I click the button named "FormPostAndClose"
	* Create one more Purchase invoice
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice0950011$$" |
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			* Filling data about vendor
				And I click Select button of "Partner" field
				And I go to line in "List" table
					| 'Description' |
					| 'Maxim'     |
				And I select current line in "List" table
				And I click Select button of "Legal name" field
				And I go to line in "List" table
					| 'Description'   |
					| 'Company Maxim' |
				And I select current line in "List" table
			// * Change the document number to 2901
			// 	And I move to "Other" tab
			// 	And I input "2 901" text in "Number" field
			// 	Then "1C:Enterprise" window is opened
			// 	And I click "Yes" button
			// 	And I input "2 901" text in "Number" field
			* Adding items to Purchase Invoice
				And I move to "Item list" tab
				And I click the button named "Add"
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Dress'       |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key' |
					| 'L/Green'  |
				And I select current line in "List" table
				And I activate "Q" field in "ItemList" table
				And I input "20,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I input "500,00" text in "Price" field of "ItemList" table
			* Change of date in Purchase invoice
				And I move to "Other" tab
				And I input "01.01.2020  10:00:00" text in "Date" field
				And Delay 1
				And I move to "Item list" tab
				And Delay 5
				Then "Update item list info" window is opened
				And I change checkbox "Do you want to update filled price types on Vendor price, TRY?"
				And I change checkbox "Do you want to update filled prices?"
				And I click "OK" button
				And I click the button named "FormPost"
				And I save the value of "Number" field as "$$NumberPurchaseInvoice0950011$$"
				And I save the window as "$$PurchaseInvoice0950011$$"
				And I click the button named "FormPostAndClose"
	

Scenario: _095002 check movements of the document Dedit Note (write off debts to the vendor)
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Maxim' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Partner term Maxim' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		* Check the selection of basis documents for the specified partner
		And "List" table contains lines
			| 'Reference'                        | 'Legal name'    | 'Partner' | 'Document amount' |
			| '$$PurchaseInvoice095001$$'  | 'Company Maxim' | 'Maxim'   | '11 000,00'       |
			| '$$PurchaseInvoice0950011$$' | 'Company Maxim' | 'Maxim'   | '10 000,00'       |
		And I go to line in "List" table
			| 'Reference' |
			| '$$PurchaseInvoice095001$$'  |
		And I click "Select" button
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "1 000,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Business unit" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Business unit" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I activate "Revenue type" field in "Transactions" table
		And I click choice button of "Revenue type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Software'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term Maxim'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'    |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I save the window as "$$DeditNote095002$$"
		And I save the value of "Date" field as "$$DeditNoteDate095002$$"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$DeditNote095002$$'                  | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Document registrations records'       | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'       | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | ''                        | ''                          | ''               | 'Dimensions'    | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                        | ''                        | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers'    | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | ''                     | '-1 000'                  | ''                          | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'                | '$$PurchaseInvoice095001$$'    | 'TRY'                  |
			| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Reconciliation statement"' | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Legal name'                | 'Currency'       | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '1 000'                | 'Main Company'            | 'Company Maxim'             | 'TRY'            | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Revenues turnovers"'       | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Period'                  | 'Resources'               | 'Dimensions'           | ''                        | ''                          | ''               | ''              | ''                    | ''                             | 'Attributes'                   | ''                     |
			| ''                                     | ''                        | 'Amount'                  | 'Company'              | 'Business unit'           | 'Revenue type'              | 'Item key'       | 'Currency'      | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '171,23'                  | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'USD'           | ''                    | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '1 000'                   | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'TRY'           | ''                    | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '1 000'                   | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'TRY'           | ''                    | 'Local currency'               | 'No'                           | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '1 000'                   | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'TRY'           | ''                    | 'TRY'                          | 'No'                           | ''                     |
			| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Partner AP transactions"'  | ''                        | ''                        | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                          | ''               | ''              | ''                    | ''                             | ''                             | 'Attributes'           |
			| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Basis document'            | 'Partner'        | 'Legal name'    | 'Partner term'        | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-1 000'               | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'en description is empty'      | 'No'                   |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-1 000'               | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'Local currency'               | 'No'                   |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-1 000'               | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'TRY'                          | 'No'                   |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-171,23'              | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'USD'                          | 'Reporting currency'           | 'No'                   |
		And I close all client application windows


Scenario: _095003 check movements of the document Credit Note (increase in debt to the vendor)
	* Create document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Maxim' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Partner term Maxim' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
	* Check the selection of basis documents for the specified partner
		And "List" table contains lines
			| 'Reference'                  | 'Legal name'    | 'Partner' | 'Document amount' |
			| '$$PurchaseInvoice095001$$'  | 'Company Maxim' | 'Maxim'   | '11 000,00'       |
			| '$$PurchaseInvoice0950011$$' | 'Company Maxim' | 'Maxim'   | '10 000,00'       |
		And I go to line in "List" table
			| 'Reference' |
			| '$$PurchaseInvoice095001$$'  |
		And I click "Select" button
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Business unit" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Business unit" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I activate "Expense type" field in "Transactions" table
		And I click choice button of "Expense type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Software'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term Maxim'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'    |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I save the window as "$$CreditNote095003$$"
		And I save the value of "Date" field as "$$CreditNoteDate095003$$"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$CreditNote095003$$'                 | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Document registrations records'       | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Expenses turnovers"'       | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Period'                   | 'Resources'                | 'Dimensions'           | ''                        | ''                          | ''               | ''              | ''                    | ''                             | 'Attributes'                   | ''                     |
			| ''                                     | ''                         | 'Amount'                   | 'Company'              | 'Business unit'           | 'Expense type'              | 'Item key'       | 'Currency'      | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '17,12'                    | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'USD'           | ''                    | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '100'                      | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'TRY'           | ''                    | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '100'                      | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'TRY'           | ''                    | 'Local currency'               | 'No'                           | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '100'                      | 'Main Company'         | 'Distribution department' | 'Software'                  | ''               | 'TRY'           | ''                    | 'TRY'                          | 'No'                           | ''                     |
			| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'       | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | ''                        | ''                          | ''               | 'Dimensions'    | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                         | ''                         | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers'    | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | ''                     | '100'                     | ''                          | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'                | '$$PurchaseInvoice095001$$'    | 'TRY'                  |
			| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Reconciliation statement"' | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Legal name'                | 'Currency'       | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Expense'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | 'Company Maxim'             | 'TRY'            | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Partner AP transactions"'  | ''                         | ''                         | ''                     | ''                        | ''                          | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                          | ''               | ''              | ''                    | ''                             | ''                             | 'Attributes'           |
			| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Basis document'            | 'Partner'        | 'Legal name'    | 'Partner term'        | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '17,12'                | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'USD'                          | 'Reporting currency'           | 'No'                   |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'en description is empty'      | 'No'                   |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'Local currency'               | 'No'                   |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | '$$PurchaseInvoice095001$$' | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'TRY'                          | 'No'                   |
		And I close all client application windows




Scenario: _095004 check movements of the document Credit Note (write off customers debts)
	* Create document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Lunch' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		* Check the selection of basis documents for the specified partner
		And delay 2
		And I go to line in "List" table
			| 'Reference' |
			| '$$SalesInvoice095001$$'  |
		And I click "Select" button
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "1 000,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Business unit" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Business unit" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I activate "Expense type" field in "Transactions" table
		And I click choice button of "Expense type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Software'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'    |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I save the window as "$$CreditNote095004$$"
		And I save the value of "Date" field as "$$CreditNoteDate095004$$"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$CreditNote095004$$'                 | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Document registrations records'       | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'  | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                         | ''                             | ''                             | 'Attributes'           |
		| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Basis document'         | 'Partner'        | 'Legal name'    | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-1 000'               | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-1 000'               | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-1 000'               | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-171,23'              | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Expenses turnovers"'       | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Period'                   | 'Resources'                | 'Dimensions'           | ''                        | ''                       | ''               | ''              | ''                         | ''                             | 'Attributes'                   | ''                     |
		| ''                                     | ''                         | 'Amount'                   | 'Company'              | 'Business unit'           | 'Expense type'           | 'Item key'       | 'Currency'      | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '171,23'                   | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'USD'           | ''                         | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '1 000'                    | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                         | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '1 000'                    | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                         | 'Local currency'               | 'No'                           | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '1 000'                    | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                         | 'TRY'                          | 'No'                           | ''                     |
		| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | ''                        | ''                       | ''               | 'Dimensions'    | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | ''                         | ''                         | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | ''                     | ''                        | ''                       | '-1 000'         | 'Main Company'  | 'Lunch'                    | 'Company Lunch'                | '$$SalesInvoice095001$$'       | 'TRY'                  |
		| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Legal name'             | 'Currency'       | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Expense'                  | '$$CreditNoteDate095004$$' | '1 000'                | 'Main Company'            | 'Company Lunch'          | 'TRY'            | ''              | ''                         | ''                             | ''                             | ''                     |
	And I close all client application windows


Scenario: _095005 check movements of the document Debit Note (increase in customers debt)
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Lunch' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		* Check the selection of basis documents for the specified partner
		And delay 2
		And "List" table contains lines
			| 'Reference' |
			| '$$SalesInvoice095001$$'  |
		And I go to line in "List" table
			| 'Reference' |
			| '$$SalesInvoice095001$$'  |
		And I click "Select" button
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Business unit" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Business unit" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I activate "Revenue type" field in "Transactions" table
		And I click choice button of "Revenue type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Software'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'    |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I save the window as "$$DeditNote095005$$"
		And I save the value of "Date" field as "$$DeditNoteDate095005$$"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$DeditNote095005$$'                  | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Document registrations records'       | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'  | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                         | ''                             | ''                             | 'Attributes'           |
		| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Basis document'         | 'Partner'        | 'Legal name'    | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '17,12'                | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | '$$SalesInvoice095001$$' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | ''                        | ''                       | ''               | 'Dimensions'    | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | ''                        | ''                        | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | ''                     | ''                        | ''                       | '100'            | 'Main Company'  | 'Lunch'                    | 'Company Lunch'                | '$$SalesInvoice095001$$'       | 'TRY'                  |
		| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Legal name'             | 'Currency'       | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | 'Company Lunch'          | 'TRY'            | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'       | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                         | ''                             | ''                             | ''                     |
		| ''                                     | 'Period'                  | 'Resources'               | 'Dimensions'           | ''                        | ''                       | ''               | ''              | ''                         | ''                             | 'Attributes'                   | ''                     |
		| ''                                     | ''                        | 'Amount'                  | 'Company'              | 'Business unit'           | 'Revenue type'           | 'Item key'       | 'Currency'      | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '17,12'                   | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'USD'           | ''                         | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '100'                     | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                         | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '100'                     | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                         | 'Local currency'               | 'No'                           | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '100'                     | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                         | 'TRY'                          | 'No'                           | ''                     |
		And I close all client application windows


Scenario: _095006 check Reconcilation statement
	* Create document
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click the button named "FormCreate"
	* Check for Maxim
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'       |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Maxim' |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		Then "Reconciliation statement (create) *" window is opened
		And I input "01.01.2020" text in "Begin period" field
		And I input end of the current month date in "End period" field
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table contains lines
		| 'Date'                     | 'Document'                   | 'Credit'    | 'Debit'    |
		| '01.01.2020 10:00:00'      | '$$PurchaseInvoice095001$$'  | '11 000,00' | ''         |
		| '01.01.2020 10:00:00'      | '$$PurchaseInvoice0950011$$' | '10 000,00' | ''         |
		| '$$DeditNoteDate095002$$'  | '$$DeditNote095002$$'        | ''          | '1 000,00' |
		| '$$CreditNoteDate095003$$' | '$$CreditNote095003$$'       | '100,00'    | ''         |
	* Check for Lunch
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'       |
		And I select current line in "List" table
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table contains lines
		| 'Date'                     | 'Document'               | 'Credit'   | 'Debit'     |
		| '01.01.2020 10:00:00'      | '$$SalesInvoice095001$$' | ''         | '10 500,00' |
		| '$$CreditNoteDate095004$$' | '$$CreditNote095004$$'   | '1 000,00' | ''          |
		| '$$DeditNoteDate095005$$'  | '$$DeditNote095005$$'    | ''         | '100,00'    |
		And I close all client application windows
		

Scenario: _095007 check the legal name filling if the partner has only one
	* Create Credit note
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
		And in the table "Transactions" I click the button named "TransactionsAdd"
	* Filling in legal name
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'    |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner' | 'Legal name'    |
			| 'Lunch'   | 'Company Lunch' |
	* Check legal name re-filling at partner re-selection.
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'    |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner' | 'Legal name'    |
			| 'DFC'     | 'DFC' |
	* Create Dedit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
		And in the table "Transactions" I click the button named "TransactionsAdd"
	* Filling in legal name
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'       |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner' | 'Legal name'    |
			| 'Lunch'   | 'Company Lunch' |
	* Check legal name re-filling at partner re-selection.
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner' | 'Legal name'    |
			| 'DFC'     | 'DFC' |
		And I close all client application windows