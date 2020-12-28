#language: en
@tree
@Positive
@Filters

Feature: check expence and revenue type filter



Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _203100 preparation (expence and revenue type filter)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
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

Scenario: _0203101 check filters in the Sales order
	Given I open hyperlink 'e1cib/list/Document.SalesOrder'
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I activate "Revenue type" field in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Revenue type" attribute in "ItemList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Delivery'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Deletion'                 | 'Both'    |
	And I close all client application windows
	


Scenario: _0203102 check filters in the Sales invoice
	Given I open hyperlink 'e1cib/list/Document.SalesInvoice'
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I activate "Revenue type" field in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Revenue type" attribute in "ItemList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Delivery'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Deletion'                 | 'Both'    |
	And I close all client application windows


Scenario: _0203103 check filters in the Purchase order
	Given I open hyperlink 'e1cib/list/Document.PurchaseOrder'
	And I click the button named "FormCreate"
	And I click the button named "Add"
	And I activate "Expense type" field in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Expense type" attribute in "ItemList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Delivery'                 | 'Both'    |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Deletion'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And I close all client application windows


Scenario: _0203104 check filters in the Purchase invoice
	Given I open hyperlink 'e1cib/list/Document.PurchaseInvoice'
	And I click the button named "FormCreate"
	And I click the button named "Add"
	And I activate "Expense type" field in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Expense type" attribute in "ItemList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Delivery'                 | 'Both'    |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Deletion'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And I close all client application windows


Scenario: _0203105 check filters in the Stock adjustment as surplus
	Given I open hyperlink 'e1cib/list/Document.StockAdjustmentAsSurplus'
	And I click the button named "FormCreate"
	And I click the button named "Add"
	And I activate "Revenue type" field in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Revenue type" attribute in "ItemList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Delivery'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Deletion'                 | 'Both'    |
	And I close all client application windows
	

Scenario: _0203106 check filters in the Stock adjustment as write off
	Given I open hyperlink 'e1cib/list/Document.StockAdjustmentAsWriteOff'
	And I click the button named "FormCreate"
	And I click the button named "Add"
	And I activate "Expense type" field in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Expense type" attribute in "ItemList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Delivery'                 | 'Both'    |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Deletion'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And I close all client application windows


Scenario: _0203107 check filters in the Cash expense
	Given I open hyperlink 'e1cib/list/Document.CashExpense'
	And I click the button named "FormCreate"
	And in the table "PaymentList" I click the button named "PaymentListAdd"
	And I activate "Expense type" field in "PaymentList" table
	And I select current line in "PaymentList" table
	And I click choice button of "Expense type" attribute in "PaymentList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Delivery'                 | 'Both'    |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Deletion'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And I close all client application windows



Scenario: _0203108 check filters in the Cash revenue
	Given I open hyperlink 'e1cib/list/Document.CashRevenue'
	And I click the button named "FormCreate"
	And in the table "PaymentList" I click the button named "PaymentListAdd"
	And I activate "Revenue type" field in "PaymentList" table
	And I select current line in "PaymentList" table
	And I click choice button of "Revenue type" attribute in "PaymentList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Delivery'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Deletion'                 | 'Both'    |
	And I close all client application windows	

Scenario: _0203109 check filters in the Retail sales receipt
	Given I open hyperlink 'e1cib/list/Document.RetailSalesReceipt'
	And I click the button named "FormCreate"
	And I click the button named "ItemListAdd"
	And I activate "Revenue type" field in "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Revenue type" attribute in "ItemList" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Delivery'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Deletion'                 | 'Both'    |
	And I close all client application windows


Scenario: _0203110 check filters in the Credit note
	Given I open hyperlink 'e1cib/list/Document.CreditNote'
	And I click the button named "FormCreate"
	And in the table "Transactions" I click the button named "TransactionsAdd"
	And I activate "Expense type" field in "Transactions" table
	And I select current line in "Transactions" table
	And I click choice button of "Expense type" attribute in "Transactions" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Delivery'                 | 'Both'    |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Deletion'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And I close all client application windows



Scenario: _0203111 check filters in the Debit note
	Given I open hyperlink 'e1cib/list/Document.DebitNote'
	And I click the button named "FormCreate"
	And in the table "Transactions" I click the button named "TransactionsAdd"
	And I activate "Revenue type" field in "Transactions" table
	And I select current line in "Transactions" table
	And I click choice button of "Revenue type" attribute in "Transactions" table
	And "List" table contains lines
		| 'Description'              | 'Type'    |
		| 'Delivery'                 | 'Both'    |
		| 'Revenue'                  | 'Revenue' |
	And "List" table does not contain lines	
		| 'Description'              | 'Type'    |
		| 'Expense'                  | 'Expense' |
		| 'Deletion'                 | 'Both'    |
	And I close all client application windows
	