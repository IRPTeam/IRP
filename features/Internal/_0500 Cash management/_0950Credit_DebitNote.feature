#language: en
@tree
@Positive
@Group9


Feature: Credit note and Debit note
As an accountant
I want to create a Credit_DebitNote document.
For write-off of accounts receivable and payable

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _095001 preparation
	* Create customer and vendor
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Lunch" text in the field named "Description_en"
		And I change checkbox "Vendor"
		And I change checkbox "Customer"
		And I click "Save" button
		And In this window I click command interface button "Partner segments content"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Partner segments content (create) *" window closing in 20 seconds
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "Company Lunch" text in the field named "Description_en"
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save and close" button
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Maxim" text in the field named "Description_en"
		And I change checkbox "Customer"
		And I change checkbox "Vendor"
		And I click "Save" button
		And In this window I click command interface button "Partner segments content"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		
		And I go to line in "List" table
			| 'Description' |
			| 'Retail'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "Company Maxim" text in the field named "Description_en"
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Company Aldis" text in the field named "Description_en"
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save and close" button
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Create vendor Partner term for Maxim, Ap-Ar - posting details (by Partner terms)
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I input "Partner term Maxim" text in the field named "Description_en"
		And I change "Type" radio button value to "Vendor"
		And I input "01.12.2019" text in "Date" field
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Currency' |
			| 'TRY'      |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Maxim'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Vendor price, TRY' |
		And I select current line in "List" table
		And I change checkbox "Price include tax"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I input "01.11.2019" text in "Start using" field
		And I click "Save and close" button
	And Delay 30
	* Create a Sales invoice for creating customer
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
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
		And I input "2 900" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2 900" text in "Number" field
		And I input "01.01.2020  10:00:00" text in "Date" field
		And Delay 1
		And I move to "Item list" tab
		And I click "Post and close" button
	* Create Purchase invoice for creating vendor
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
		* Change the document number to 601
			And I move to "Other" tab
			And I input "2 900" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2 900" text in "Number" field
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
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
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click "Post and close" button
	* Create one more Purchase invoice
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
		* Change the document number to 2901
			And I move to "Other" tab
			And I input "2 901" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2 901" text in "Number" field
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
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
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			And I click "Post and close" button
	

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
		And I click choice button of "Basis document" attribute in "Transactions" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''                 |
			| 'Purchase invoice' |
		And I select current line in "" table
		* Check the selection of basis documents for the specified partner
		And "List" table contains lines
			| 'Number' | 'Legal name'    | 'Partner' | 'Document amount'   | 'Currency' |
			| '2 900'  | 'Company Maxim' | 'Maxim'   | '11 000,00'         | 'TRY'      |
			| '2 901'  | 'Company Maxim' | 'Maxim'   | '10 000,00'         | 'TRY'      |
		And I go to line in "List" table
			| 'Number' |
			| '2 900'  |
		And I select current line in "List" table
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
		And I click "Post" button
		And I save the window as "$$DeditNote095002$$"
		And I save the value of "Date" field as "$$DeditNoteDate095002$$"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
			| '$$DeditNote095002$$'                  | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Document registrations records'       | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'       | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | ''                        | ''                       | ''               | 'Dimensions'    | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                        | ''                        | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | ''                     | '-1 000'                  | ''                       | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'                | ''                             | 'TRY'                  |
			| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Reconciliation statement"' | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Legal name'             | 'Currency'       | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '1 000'                | 'Main Company'            | 'Company Maxim'          | 'TRY'            | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Revenues turnovers"'       | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Period'                  | 'Resources'               | 'Dimensions'           | ''                        | ''                       | ''               | ''              | ''                    | ''                             | 'Attributes'                   | ''                     |
			| ''                                     | ''                        | 'Amount'                  | 'Company'              | 'Business unit'           | 'Revenue type'           | 'Item key'       | 'Currency'      | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '171,23'                  | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'USD'           | ''                    | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '1 000'                   | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                    | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '1 000'                   | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                    | 'Local currency'               | 'No'                           | ''                     |
			| ''                                     | '$$DeditNoteDate095002$$' | '1 000'                   | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                    | 'TRY'                          | 'No'                           | ''                     |
			| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Partner AP transactions"'  | ''                        | ''                        | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                    | ''                             | ''                             | 'Attributes'           |
			| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Basis document'         | 'Partner'        | 'Legal name'    | 'Partner term'        | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-1 000'               | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'en description is empty'      | 'No'                   |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-1 000'               | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'Local currency'               | 'No'                   |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-1 000'               | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'TRY'                          | 'No'                   |
			| ''                                     | 'Receipt'                 | '$$DeditNoteDate095002$$' | '-171,23'              | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'USD'                          | 'Reporting currency'           | 'No'                   |
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
		And I click choice button of "Basis document" attribute in "Transactions" table
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''                 |
			| 'Purchase invoice' |
		And I select current line in "" table
	* Check the selection of basis documents for the specified partner
		And "List" table contains lines
			| 'Number' | 'Legal name'    | 'Partner' | 'Document amount'   | 'Currency' |
			| '2 900'  | 'Company Maxim' | 'Maxim'   | '11 000,00'         | 'TRY'      |
			| '2 901'  | 'Company Maxim' | 'Maxim'   | '10 000,00'         | 'TRY'      |
		And I go to line in "List" table
			| 'Number' |
			| '2 900'  |
		And I select current line in "List" table
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
		And I click "Post" button
		And I save the window as "$$CreditNote095003$$"
		And I save the value of "Date" field as "$$CreditNoteDate095003$$"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
			| '$$CreditNote095003$$'                 | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Document registrations records'       | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Expenses turnovers"'       | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Period'                   | 'Resources'                | 'Dimensions'           | ''                        | ''                       | ''               | ''              | ''                    | ''                             | 'Attributes'                   | ''                     |
			| ''                                     | ''                         | 'Amount'                   | 'Company'              | 'Business unit'           | 'Expense type'           | 'Item key'       | 'Currency'      | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '17,12'                    | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'USD'           | ''                    | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '100'                      | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                    | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '100'                      | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                    | 'Local currency'               | 'No'                           | ''                     |
			| ''                                     | '$$CreditNoteDate095003$$' | '100'                      | 'Main Company'         | 'Distribution department' | 'Software'               | ''               | 'TRY'           | ''                    | 'TRY'                          | 'No'                           | ''                     |
			| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'       | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | ''                        | ''                       | ''               | 'Dimensions'    | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                         | ''                         | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers' | 'Transaction AR' | 'Company'       | 'Partner'             | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | ''                     | '100'                     | ''                       | ''               | 'Main Company'  | 'Maxim'               | 'Company Maxim'                | ''                             | 'TRY'                  |
			| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Reconciliation statement"' | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Legal name'             | 'Currency'       | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Expense'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | 'Company Maxim'          | 'TRY'            | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| 'Register  "Partner AP transactions"'  | ''                         | ''                         | ''                     | ''                        | ''                       | ''               | ''              | ''                    | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                       | ''               | ''              | ''                    | ''                             | ''                             | 'Attributes'           |
			| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Basis document'         | 'Partner'        | 'Legal name'    | 'Partner term'        | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '17,12'                | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'USD'                          | 'Reporting currency'           | 'No'                   |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'en description is empty'      | 'No'                   |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'Local currency'               | 'No'                   |
			| ''                                     | 'Receipt'                  | '$$CreditNoteDate095003$$' | '100'                  | 'Main Company'            | ''                       | 'Maxim'          | 'Company Maxim' | 'Partner term Maxim'  | 'TRY'                          | 'TRY'                          | 'No'                   |
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
		And I click choice button of "Basis document" attribute in "Transactions" table
		And I go to line in "" table
			| ''                 |
			| 'Sales invoice' |
		And I select current line in "" table
		* Check the selection of basis documents for the specified partner
		And delay 2
		And I go to line in "List" table
			| 'Number' |
			| '2 900'  |
		And I select current line in "List" table
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
		And I click "Post" button
		And I save the window as "$$CreditNote095004$$"
		And I save the value of "Date" field as "$$CreditNoteDate095004$$"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| '$$CreditNote095004$$'                 | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Document registrations records'       | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Partner AR transactions"'  | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | 'Attributes'           |
		| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Basis document'                                | 'Partner'        | 'Legal name'    | 'Partner term'             | 'Currency'                     | 'Multi currency movement type'                  | 'Deferred calculation' |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-1 000'               | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'                       | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-1 000'               | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'                                | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-1 000'               | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                                           | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | '-171,23'              | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'                            | 'No'                   |
		| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Expenses turnovers"'       | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Period'                   | 'Resources'                | 'Dimensions'           | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | 'Attributes'                                    | ''                     |
		| ''                                     | ''                         | 'Amount'                   | 'Company'              | 'Business unit'           | 'Expense type'                                  | 'Item key'       | 'Currency'      | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'                          | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '171,23'                   | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'USD'           | ''                         | 'Reporting currency'           | 'No'                                            | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '1 000'                    | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'TRY'           | ''                         | 'en description is empty'      | 'No'                                            | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '1 000'                    | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'TRY'           | ''                         | 'Local currency'               | 'No'                                            | ''                     |
		| ''                                     | '$$CreditNoteDate095004$$' | '1 000'                    | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'TRY'           | ''                         | 'TRY'                          | 'No'                                            | ''                     |
		| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Accounts statement"'       | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | ''                        | ''                                              | ''               | 'Dimensions'    | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | ''                         | ''                         | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers'                        | 'Transaction AR' | 'Company'       | 'Partner'                  | 'Legal name'                   | 'Basis document'                                | 'Currency'             |
		| ''                                     | 'Receipt'                  | '$$CreditNoteDate095004$$' | ''                     | ''                        | ''                                              | '-1 000'         | 'Main Company'  | 'Lunch'                    | 'Company Lunch'                | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'TRY'                  |
		| ''                                     | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Reconciliation statement"' | ''                         | ''                         | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Record type'              | 'Period'                   | 'Resources'            | 'Dimensions'              | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | ''                         | ''                         | 'Amount'               | 'Company'                 | 'Legal name'                                    | 'Currency'       | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Expense'                  | '$$CreditNoteDate095004$$' | '1 000'                | 'Main Company'            | 'Company Lunch'                                 | 'TRY'            | ''              | ''                         | ''                             | ''                                              | ''                     |
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
		And I click choice button of "Basis document" attribute in "Transactions" table
		And I go to line in "" table
			| ''                 |
			| 'Sales invoice' |
		And I select current line in "" table
		* Check the selection of basis documents for the specified partner
		And delay 2
		And "List" table contains lines
			| 'Number' |
			| '2 900'  |
		And I go to line in "List" table
			| 'Number' |
			| '2 900'  |
		And I select current line in "List" table
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
		And I click "Post" button
		And I save the window as "$$DeditNote095005$$"
		And I save the value of "Date" field as "$$DeditNoteDate095005$$"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| '$$DeditNote095005$$'                  | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Document registrations records'       | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Partner AR transactions"'  | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | 'Attributes'           |
		| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Basis document'                                | 'Partner'        | 'Legal name'    | 'Partner term'             | 'Currency'                     | 'Multi currency movement type'                  | 'Deferred calculation' |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '17,12'                | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'                            | 'No'                   |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'                       | 'No'                   |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'                                | 'No'                   |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'Lunch'          | 'Company Lunch' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                                           | 'No'                   |
		| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Accounts statement"'       | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | ''                        | ''                                              | ''               | 'Dimensions'    | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | ''                        | ''                        | 'Advance to suppliers' | 'Transaction AP'          | 'Advance from customers'                        | 'Transaction AR' | 'Company'       | 'Partner'                  | 'Legal name'                   | 'Basis document'                                | 'Currency'             |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | ''                     | ''                        | ''                                              | '100'            | 'Main Company'  | 'Lunch'                    | 'Company Lunch'                | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | 'TRY'                  |
		| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Reconciliation statement"' | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Record type'             | 'Period'                  | 'Resources'            | 'Dimensions'              | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | ''                        | ''                        | 'Amount'               | 'Company'                 | 'Legal name'                                    | 'Currency'       | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Receipt'                 | '$$DeditNoteDate095005$$' | '100'                  | 'Main Company'            | 'Company Lunch'                                 | 'TRY'            | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| 'Register  "Revenues turnovers"'       | ''                        | ''                        | ''                     | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | ''                                              | ''                     |
		| ''                                     | 'Period'                  | 'Resources'               | 'Dimensions'           | ''                        | ''                                              | ''               | ''              | ''                         | ''                             | 'Attributes'                                    | ''                     |
		| ''                                     | ''                        | 'Amount'                  | 'Company'              | 'Business unit'           | 'Revenue type'                                  | 'Item key'       | 'Currency'      | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'                          | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '17,12'                   | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'USD'           | ''                         | 'Reporting currency'           | 'No'                                            | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '100'                     | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'TRY'           | ''                         | 'en description is empty'      | 'No'                                            | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '100'                     | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'TRY'           | ''                         | 'Local currency'               | 'No'                                            | ''                     |
		| ''                                     | '$$DeditNoteDate095005$$' | '100'                     | 'Main Company'         | 'Distribution department' | 'Software'                                      | ''               | 'TRY'           | ''                         | 'TRY'                          | 'No'                                            | ''                     |
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
		| 'Date'                     | 'Document'                                         | 'Credit'    | 'Debit'    |
		| '01.01.2020 10:00:00'      | 'Purchase invoice 2 900 dated 01.01.2020 10:00:00' | '11 000,00' | ''         |
		| '01.01.2020 10:00:00'      | 'Purchase invoice 2 901 dated 01.01.2020 10:00:00' | '10 000,00' | ''         |
		| '$$DeditNoteDate095002$$'  | '$$DeditNote095002$$'                              | ''          | '1 000,00' |
		| '$$CreditNoteDate095003$$' | '$$CreditNote095003$$'                             | '100,00'    | ''         |
	* Check for Lunch
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Lunch'       |
		And I select current line in "List" table
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table contains lines
		| 'Date'                     | 'Document'                                      | 'Credit'   | 'Debit'     |
		| '01.01.2020 10:00:00'      | 'Sales invoice 2 900 dated 01.01.2020 10:00:00' | ''         | '10 500,00' |
		| '$$CreditNoteDate095004$$' | '$$CreditNote095004$$'                          | '1 000,00' | ''          |
		| '$$DeditNoteDate095005$$'  | '$$DeditNote095005$$'                           | ''         | '100,00'    |
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