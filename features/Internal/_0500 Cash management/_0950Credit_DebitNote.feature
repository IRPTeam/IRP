#language: en
@tree
@Positive
@CashManagement


Feature: Credit note and Debit note
As an accountant
I want to create a Credit_DebitNote document.
For write-off of accounts receivable and payable

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _095001 preparation
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
		When Create catalog Countries objects
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
		When Create OtherPartners objects
		When Create information register Taxes records (VAT)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Countries objects
		When Create catalog BusinessUnits objects 
		When Create catalog Projects objects
		When Create catalog LegalNameContracts objects
	* Create a Sales invoice for creating customer
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number"                           |
				| "$$NumberSalesInvoice095001$$"     |
			And I click the button named "FormCreate"
			And I select from "Partner" drop-down list by "Lunch" string
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
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
			And I activate "Quantity" field in "ItemList" table
			And I input "15,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to "Other" tab
			And I expand "More" group
			And I input "01.01.2020  10:00:00" text in "Date" field
			And Delay 1
			And I move to "Item list" tab
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice095001$$" variable
			And I delete "$$SalesInvoice095001$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice095001$$"
			And I save the window as "$$SalesInvoice095001$$"
			And I click the button named "FormPostAndClose"
	* Create Purchase invoice for creating vendor
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number"                              |
				| "$$NumberPurchaseInvoice095001$$"     |
			And I click the button named "FormCreate"
			* Filling data about vendor
				And I click Select button of "Partner" field
				And I go to line in "List" table
					| 'Description'      |
					| 'Maxim'            |
				And I select current line in "List" table
				And I click Select button of "Legal name" field
				And I go to line in "List" table
					| 'Description'        |
					| 'Company Maxim'      |
				And I select current line in "List" table
			* Adding items to Purchase Invoice
				And I move to "Item list" tab
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key'      |
					| 'L/Green'       |
				And I select current line in "List" table
				And I activate "Quantity" field in "ItemList" table
				And I input "20,000" text in "Quantity" field of "ItemList" table
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
				And I click the button named "FormPost"
				And I delete "$$NumberPurchaseInvoice095001$$" variable
				And I delete "$$PurchaseInvoice095001$$" variable
				And I save the value of "Number" field as "$$NumberPurchaseInvoice095001$$"
				And I save the window as "$$PurchaseInvoice095001$$"
				And I click the button named "FormPostAndClose"
	* Create one more Purchase invoice
		If "List" table does not contain lines Then
				| "Number"                               |
				| "$$NumberPurchaseInvoice0950011$$"     |
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			* Filling data about vendor
				And I click Select button of "Partner" field
				And I go to line in "List" table
					| 'Description'      |
					| 'Maxim'            |
				And I select current line in "List" table
				And I click Select button of "Legal name" field
				And I go to line in "List" table
					| 'Description'        |
					| 'Company Maxim'      |
				And I select current line in "List" table
			* Adding items to Purchase Invoice
				And I move to "Item list" tab
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Dress'            |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key'      |
					| 'L/Green'       |
				And I select current line in "List" table
				And I activate "Quantity" field in "ItemList" table
				And I input "20,000" text in "Quantity" field of "ItemList" table
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
				And I click the button named "FormPost"
				And I delete "$$NumberPurchaseInvoice0950011$$" variable
				And I delete "$$PurchaseInvoice0950011$$" variable
				And I save the value of "Number" field as "$$NumberPurchaseInvoice0950011$$"
				And I save the window as "$$PurchaseInvoice0950011$$"
				And I click the button named "FormPostAndClose"
		* Add VA extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"     |
				| "VAExtension"     |
			When add VAExtension
	
Scenario: _0950011 check preparation
	When check preparation

Scenario: _095002 create document Dedit Note (write off debts to the vendor)
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Maxim'          |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Company Maxim'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Partner term Maxim'    |
		And I select current line in "List" table
		And I select current line in "Transactions" table
		And I input "1 000,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Profit loss center" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Revenue type" field in "Transactions" table
		And I click choice button of "Revenue type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Software'       |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Partner term Maxim'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Maxim'          |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$DeditNote095002$$" variable
		And I delete "$$DeditNoteDate095002$$" variable
		And I save the window as "$$DeditNote095002$$"
		And I save the value of the field named "Date" as  "$$DeditNoteDate095002$$"
		And I save the value of "Number" field as "$$NumberDeditNote095002$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And "List" table contains lines
			| 'Number'                      | 'Date'                       |
			| '$$NumberDeditNote095002$$'   | '$$DeditNoteDate095002$$'    |
		And I close all client application windows


Scenario: _095003 create document Credit Note (increase in debt to the vendor)
	* Create document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in document
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Maxim'          |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Company Maxim'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Partner term Maxim'    |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Profit loss center" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Expense type" field in "Transactions" table
		And I click choice button of "Expense type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Software'       |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Partner term Maxim'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Maxim'          |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$CreditNote095003$$" variable
		And I delete "$$CreditNoteDate095003$$" variable
		And I save the window as "$$CreditNote095003$$"
		And I save the value of the field named "Date" as  "$$CreditNoteDate095003$$"
		And I save the value of "Number" field as "$$NumberCreditNote095003$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And "List" table contains lines
			| 'Number'                       | 'Date'                        |
			| '$$NumberCreditNote095003$$'   | '$$CreditNoteDate095003$$'    |
		And I close all client application windows



Scenario: _095004 create document Credit Note (write off customers debts)
	* Create document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in document 
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lunch'          |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Company Lunch'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "1 000,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Profit loss center" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Expense type" field in "Transactions" table
		And I click choice button of "Expense type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Software'       |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lunch'          |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$CreditNote095004$$" variable
		And I delete "$$CreditNoteDate095004$$" variable
		And I save the window as "$$CreditNote095004$$"
		And I save the value of the field named "Date" as  "$$CreditNoteDate095004$$"
		And I save the value of "Number" field as "$$NumberCreditNote095004$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And "List" table contains lines
			| 'Number'                       | 'Date'                        |
			| '$$NumberCreditNote095004$$'   | '$$CreditNoteDate095004$$'    |
		And I close all client application windows


Scenario: _095005 create document Debit Note (increase in customers debt)
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in document
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lunch'          |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Company Lunch'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Profit loss center" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Revenue type" field in "Transactions" table
		And I click choice button of "Revenue type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Software'       |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lunch'          |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$DeditNote095005$$" variable
		And I delete "$$DeditNoteDate095005$$" variable
		And I delete "$$DeditNoteDate095005$$" variable
		And I save the window as "$$DeditNote095005$$"
		And I save the value of the field named "Date" as  "$$DeditNoteDate095005$$"
		And I save the value of "Number" field as "$$DeditNoteNumber095005$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And "List" table contains lines
			| 'Number'                      | 'Date'                       |
			| '$$DeditNoteNumber095005$$'   | '$$DeditNoteDate095005$$'    |
		And I close all client application windows


Scenario: _095006 check Reconcilation statement
	* Create document
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click the button named "FormCreate"
	* Check for Maxim
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Maxim'          |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Company Maxim'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Turkish lira'    |
		And I select current line in "List" table
		Then "Reconciliation statement (create) *" window is opened
		And I input "01.01.2020" text in "Begin period" field
		And I input end of the current month date in "End period" field
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table contains lines
		| 'Date'                      | 'Document'                    | 'Credit'     | 'Debit'      |
		| '01.01.2020 10:00:00'       | '$$PurchaseInvoice095001$$'   | '11 000,00'  | ''           |
		| '01.01.2020 10:00:00'       | '$$PurchaseInvoice0950011$$'  | '10 000,00'  | ''           |
		| '$$DeditNoteDate095002$$'   | '$$DeditNote095002$$'         | ''           | '1 000,00'   |
		| '$$CreditNoteDate095003$$'  | '$$CreditNote095003$$'        | '100,00'     | ''           |
	* Check for Lunch
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Lunch'          |
		And I select current line in "List" table
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table contains lines
		| 'Date'                      | 'Document'                | 'Credit'    | 'Debit'       |
		| '01.01.2020 10:00:00'       | '$$SalesInvoice095001$$'  | ''          | '10 500,00'   |
		| '$$CreditNoteDate095004$$'  | '$$CreditNote095004$$'    | '1 000,00'  | ''            |
		| '$$DeditNoteDate095005$$'   | '$$DeditNote095005$$'     | ''          | '100,00'      |
		And I close all client application windows
		

Scenario: _095007 check the legal name filling if the partner has only one
	* Create Credit note
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
		And in the table "Transactions" I click the button named "TransactionsAdd"
	* Filling in legal name
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lunch'          |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner'   | 'Legal name'       |
			| 'Lunch'     | 'Company Lunch'    |
	* Check legal name refilling at partner re-selection.
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner'   | 'Legal name'    |
			| 'DFC'       | 'DFC'           |
	* Create Dedit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
		And in the table "Transactions" I click the button named "TransactionsAdd"
	* Filling in legal name
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lunch'          |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner'   | 'Legal name'       |
			| 'Lunch'     | 'Company Lunch'    |
	* Check legal name refilling at partner re-selection.
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And "Transactions" table contains lines
			| 'Partner'   | 'Legal name'    |
			| 'DFC'       | 'DFC'           |
		And I close all client application windows

Scenario: _095008 create DebitNote (OtherPartnersTransactions)
	And I close all client application windows
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in document
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Other partner 1'    |
		And I select current line in "List" table
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Profit loss center" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Revenue type" field in "Transactions" table
		And I click choice button of "Revenue type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I finish line editing in "Transactions" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I select "Other partner 1" from "Partner term" drop-down list by string in "Transactions" table	
	* Check creation
		And I click the button named "FormPost"
		And "Transactions" table became equal
			| '#'   | 'Partner'           | 'Amount'   | 'Revenue type'   | 'Legal name'        | 'Partner term'      | 'Legal name contract'   | 'Currency'   | 'Profit loss center'        | 'Additional analytic'    |
			| '1'   | 'Other partner 1'   | '100,00'   | 'Revenue'        | 'Other partner 1'   | 'Other partner 1'   | ''                      | 'TRY'        | 'Distribution department'   | ''                       |
		Then the form attribute named "Branch" became equal to "Front office"
		And I delete "$$DeditNote095008$$" variable
		And I delete "$$DeditNoteDate095008$$" variable
		And I delete "$$DeditNoteDate095008$$" variable
		And I save the window as "$$DeditNote095008$$"
		And I save the value of the field named "Date" as  "$$DeditNoteDate095008$$"
		And I save the value of "Number" field as "$$DeditNoteNumber095008$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And "List" table contains lines
			| 'Number'                      | 'Date'                       |
			| '$$DeditNoteNumber095008$$'   | '$$DeditNoteDate095008$$'    |
		And I close all client application windows


Scenario: _095009 create CreditNote (OtherPartnersTransactions)
	And I close all client application windows
	* Create document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in document
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Other partner 2'    |
		And I select current line in "List" table
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I click choice button of "Profit loss center" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Expense type" field in "Transactions" table
		And I click choice button of "Expense type" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I select "Other partner 2" from "Partner term" drop-down list by string in "Transactions" table	
		And I finish line editing in "Transactions" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Check creation
		And I click the button named "FormPost"
		Then the form attribute named "Company" became equal to "Main Company"
		And "Transactions" table became equal
			| '#'   | 'Partner'           | 'Amount'   | 'Legal name'        | 'Partner term'      | 'Legal name contract'   | 'Currency'   | 'Profit loss center'        | 'Expense type'   | 'Additional analytic'    |
			| '1'   | 'Other partner 2'   | '100,00'   | 'Other partner 2'   | 'Other partner 2'   | ''                      | 'TRY'        | 'Distribution department'   | 'Expense'        | ''                       |
		Then the form attribute named "Branch" became equal to "Front office"	
		And I delete "$$CreditNote095009$$" variable
		And I delete "$$CreditNoteDate095009$$" variable
		And I delete "$$CreditNoteDate095009$$" variable
		And I save the window as "$$CreditNote095009$$"
		And I save the value of the field named "Date" as  "$$CreditNoteDate095009$$"
		And I save the value of "Number" field as "$$CreditNoteNumber095009$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And "List" table contains lines
			| 'Number'                       | 'Date'                        |
			| '$$CreditNoteNumber095009$$'   | '$$CreditNoteDate095009$$'    |
		And I close all client application windows

Scenario: _095010 create DebitCreditNote (check amount control CurrencyFrom=CurrencyTo)
	And I close all client application windows
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I select from the drop-down list named "Currency" by "Turkish lira" string
		And I select from the drop-down list named "Branch" by "Accountants office" string
		And I select from "Expense type" drop-down list by "Expense" string
		And I select from "Loss center" drop-down list by "Front office" string
		And I select from "Revenue type" drop-down list by "Revenue" string
		And I select from "Profit center" drop-down list by "Front office" string
	* Filling FROM-TO
		And I select "Advance (Customer)" exact value from "Debt type (send)" drop-down list
		And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list
		And I select "Lunch" exact value from "Partner (send)" drop-down list
		And I select "Maxim" exact value from "Partner (receive)" drop-down list
		And I select from "Partner term (send)" drop-down list by "Basic Partner terms, TRY" string
		And I select from "Partner term (receive)" drop-down list by "Basic Partner terms, without VAT" string
		And I input "50,00" text in "Amount (send)" field
		And I input "60,00" text in "Amount (receive)" field
	* Try post and check message
		And I click "Post" button
		Then there are lines in TestClient message log
			|"Debit\Credit note is available only when amounts are equal."|
		And I input "50,00" text in "Amount (receive)" field
		And I click "Post" button
		Then user message window does not contain messages
	And I close all client application windows
	

Scenario: _095011 check possible and impossible operations for DebitCreditNote (Parter/LegalNameSend=Parter/LegalNameReceive)
	And I close all client application windows
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I select from the drop-down list named "Currency" by "Turkish lira" string
		And I select from the drop-down list named "Branch" by "Accountants office" string
		And I select from "Expense type" drop-down list by "Expense" string
		And I select from "Loss center" drop-down list by "Front office" string
		And I select from "Revenue type" drop-down list by "Revenue" string
		And I select from "Profit center" drop-down list by "Front office" string
	* Filling FROM-TO
		* (CA) - (CT)
			And I select "Advance (Customer)" exact value from "Debt type (send)" drop-down list
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner (send)" drop-down list by "Ferron BP" string
			And I select from "Partner (receive)" drop-down list by "Ferron BP" string
			And I select from "Partner term (send)" drop-down list by "Basic Partner terms, TRY" string
			And I select from "Partner term (receive)" drop-down list by "Basic Partner terms, TRY" string	
			And I select from "Branch (send)" drop-down list by "Accountants office" string
			And I select from "Branch (receive)" drop-down list by "Front office" string	
			And I select from "Project (send)" drop-down list by "Project 01" string
			And I select from "Project (receive)" drop-down list by "Project 02" string	
			And I select from "Contract (send)" drop-down list by "Contract Ferron BP" string
			And I select from "Contract (receive)" drop-down list by "Contract Ferron BP New" string			
			And I input "50,00" text in "Amount (send)" field
			And I input "50,00" text in "Amount (receive)" field
			And I click "Post" button
			Then user message window does not contain messages
		* (CT) - (CA)
			And I select "Transaction (Customer)" exact value from "Debt type (send)" drop-down list
			And I select "Advance (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CA) - (CA)
			And I select "Advance (Customer)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button
			Then user message window does not contain messages
		* (CT) - (CT)
			And I select "Transaction (Customer)" exact value from "Debt type (send)" drop-down list
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list	
			And I click "Post" button
			Then user message window does not contain messages	
		* (CT) - (VA)	
			And I select "Advance (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner term (receive)" drop-down list by "Vendor Ferron, TRY" string	
			And I click "Post" button
			Then user message window does not contain messages	
		* (CA) - (VA)
			And I select "Advance (Customer)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CA) - (VT)	
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CA) - (VT)	
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CT) - (VT)	
			And I select "Transaction (Customer)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (VA) - (CA)	
			And I select "Advance (Vendor)" exact value from "Debt type (send)" drop-down list
			And I select from "Partner term (send)" drop-down list by "Vendor Ferron, TRY" string
			And I select "Advance (Customer)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner term (receive)" drop-down list by "Basic Partner terms, TRY" string
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (VA) - (CT)	
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (VT) - (CA)	
			And I select "Transaction (Vendor)" exact value from "Debt type (send)" drop-down list
			And I select "Advance (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then user message window does not contain messages
		* (VT) - (CT)	 
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then user message window does not contain messages
		* (VT) - (VA)				
			And I select "Advance (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner term (receive)" drop-down list by "Vendor Ferron, TRY" string
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|	
		* (VT) - (VT)				
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button	
			Then user message window does not contain messages
		* (VA) - (VA)				
			And I select "Advance (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I select "Advance (Vendor)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button	
			Then user message window does not contain messages
		* (VA) - (VT)				
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button	
			Then user message window does not contain messages
						
	
Scenario: _095012 check possible and impossible operations for DebitCreditNote (Parter/LegalNameSend not equal Parter/LegalNameReceive)
	And I close all client application windows
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I select from the drop-down list named "Currency" by "Turkish lira" string
		And I select from the drop-down list named "Branch" by "Accountants office" string
		And I select from "Expense type" drop-down list by "Expense" string
		And I select from "Loss center" drop-down list by "Front office" string
		And I select from "Revenue type" drop-down list by "Revenue" string
		And I select from "Profit center" drop-down list by "Front office" string
	* Filling FROM-TO
		* (CA) - (CT)
			And I select "Advance (Customer)" exact value from "Debt type (send)" drop-down list
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner (send)" drop-down list by "Ferron BP" string
			And I select from "Partner (receive)" drop-down list by "DFC" string
			And I select from "Partner term (send)" drop-down list by "Basic Partner terms, TRY" string
			And I select from "Partner term (receive)" drop-down list by "Partner term DFC" string	
			And I select from "Branch (send)" drop-down list by "Accountants office" string
			And I select from "Branch (receive)" drop-down list by "Front office" string	
			And I select from "Project (send)" drop-down list by "Project 01" string
			And I select from "Project (receive)" drop-down list by "Project 02" string	
			And I select from "Contract (send)" drop-down list by "Contract Ferron BP" string
			And I select from "Contract (receive)" drop-down list by "DFC Legal name contract" string			
			And I input "50,00" text in "Amount (send)" field
			And I input "50,00" text in "Amount (receive)" field
			And I click "Post" button
			Then user message window does not contain messages
		* (CT) - (CA)
			And I select "Transaction (Customer)" exact value from "Debt type (send)" drop-down list
			And I select "Advance (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CA) - (CA)
			And I select "Advance (Customer)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button
			Then user message window does not contain messages
		* (CT) - (CT)
			And I select "Transaction (Customer)" exact value from "Debt type (send)" drop-down list
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list	
			And I click "Post" button
			Then user message window does not contain messages	
		* (CT) - (VA)	
			And I select "Advance (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner term (receive)" drop-down list by "Vendor Ferron, TRY" string	
			And I click "Post" button
			Then user message window does not contain messages	
		* (CA) - (VA)
			And I select "Advance (Customer)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CA) - (VT)	
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CA) - (VT)	
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (CT) - (VT)	
			And I select "Transaction (Customer)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (VA) - (CA)	
			And I select "Advance (Vendor)" exact value from "Debt type (send)" drop-down list
			And I select from "Partner term (send)" drop-down list by "Vendor Ferron, TRY" string
			And I select "Advance (Customer)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner term (receive)" drop-down list by "Basic Partner terms, TRY" string
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (VA) - (CT)	
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|
		* (VT) - (CA)	
			And I select "Transaction (Vendor)" exact value from "Debt type (send)" drop-down list
			And I select "Advance (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then user message window does not contain messages
		* (VT) - (CT)	 
			And I select "Transaction (Customer)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button
			Then user message window does not contain messages
		* (VT) - (VA)				
			And I select "Advance (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I select from "Partner term (receive)" drop-down list by "Vendor Ferron, TRY" string
			And I click "Post" button
			Then there are lines in TestClient message log
				|"Wrong combination of send and receive debt type"|	
		* (VT) - (VT)				
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button	
			Then user message window does not contain messages
		* (VA) - (VA)				
			And I select "Advance (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I select "Advance (Vendor)" exact value from "Debt type (send)" drop-down list
			And I click "Post" button	
			Then user message window does not contain messages
		* (VA) - (VT)				
			And I select "Transaction (Vendor)" exact value from "Debt type (receive)" drop-down list
			And I click "Post" button	
			Then user message window does not contain messages				

				
