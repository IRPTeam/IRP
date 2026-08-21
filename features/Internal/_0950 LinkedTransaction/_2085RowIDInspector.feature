#language: en
@tree
@Positive
@LinkedTransaction


# RowID Inspector (added by PR2965): a data processor opened from a Sales/Purchase
# invoice that shows the order it originates from and compares their attributes.
#
# DATA ISOLATION (sequential @LinkedTransaction tag): own documents only, built from
# the shared SalesOrder023001 fixture; scenario-local navigation by saved number.

Feature: RowID inspector

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _208500 preparation (RowID inspector)
	When set True value to the constant
	When set False value to the constant DisableLinkedRowsIntegrity
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
		When Create catalog CashAccounts objects
		When Create catalog Partners objects (Ferron BP)
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Partners objects
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	And I close all client application windows


Scenario: _2085001 check preparation
	When check preparation


# The command is built on the invoice form and the inspector opens prefilled: the
# dependent is the invoice it was called from, the basis is an order with a RowID
# balance, and both item lists are read from those two documents.
Scenario: _208502 check the RowID inspector command opens prefilled from a sales invoice
	And I close all client application windows
	* Create an order and invoice only one of its two rows, so the order keeps a balance
		When create SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                       |
			| '$$NumberSalesOrder023001$$' |
		And I select current line in "List" table
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Row presentation' |
			| 'Trousers*'        |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$SI208502$$" variable
		And I save the value of "Number" field as "$$SI208502$$"
	* The inspector opens with the invoice as the dependent and an order as the basis
		And I click the button named "FormDataProcessorRowIDInspectorRowIDInspector"
		Then "Row ID Inspector" window is opened
		Then the form attribute named "Dependent" became equal to "*ales invoice $$SI208502$$ dated*" template
		Then the form attribute named "Basis" became equal to "*ales order*" template
	* Both item lists are read from the two documents
		And "BasisItemList" table contains lines
			| 'Line number' | 'Item'     | 'Item key'  |
			| '1'           | 'Dress'    | 'L/Green'   |
			| '2'           | 'Trousers' | '36/Yellow' |
		And "DependentItemList" table contains lines
			| 'Line number' | 'Item'  | 'Item key' |
			| '1'           | 'Dress' | 'L/Green'  |
	And I close all client application windows

# The Results table compares the header attributes of the basis and the dependent plus
# the item row pair selected in the two lists. Date is a special case: it matches when
# the basis is EARLIER than the dependent, everything else matches on equality.
Scenario: _208503 check the inspector compares the basis and the dependent attributes
	And I close all client application windows
	* Open the inspector on the invoice created by the previous scenario
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'          |
			| '$$SI208502$$'    |
		And I select current line in "List" table
		And I click the button named "FormDataProcessorRowIDInspectorRowIDInspector"
		Then "Row ID Inspector" window is opened
	* Every compared attribute of the pair matches
		And "Results" table contains lines
			| 'Attribute name'   | 'Basis value'              | 'Dependent value'          | 'Is match' |
			| 'Company'          | 'Main Company'             | 'Main Company'             | 'Yes'      |
			| 'Partner'          | 'Ferron BP'                | 'Ferron BP'                | 'Yes'      |
			| 'LegalName'        | 'Company Ferron BP'        | 'Company Ferron BP'        | 'Yes'      |
			| 'Agreement'        | 'Basic Partner terms, TRY' | 'Basic Partner terms, TRY' | 'Yes'      |
			| 'Currency'         | 'TRY'                      | 'TRY'                      | 'Yes'      |
			| 'TransactionType'  | 'Sales'                    | 'Sales'                    | 'Yes'      |
			| 'ItemList.ItemKey' | 'L/Green'                  | 'L/Green'                  | 'Yes'      |
			| 'ItemList.Store'   | 'Store 01'                 | 'Store 01'                 | 'Yes'      |
	And I close all client application windows


# Documents a PR2965 defect: the command ignores the links the invoice actually carries
# (RowIDInfo.Basis / ItemList.SalesOrder) and instead runs a query over
# TM1010B_RowIDMovements filtered only by Partner and Agreement, ordered by document
# number, taking the FIRST order with a balance. When the partner has more than one open
# order, the inspector opens the invoice against a FOREIGN order and compares the wrong
# pair of documents.
Scenario: _208504 check the inspector opens the invoice against its own order
	And I close all client application windows
	* Leave an older order of the same partner open, then create a second order and invoice it
		When create SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                       |
			| '$$NumberSalesOrder023001$$'   |
		And I select current line in "List" table
		And I delete "$$SO208504$$" variable
		And I save the value of "Number" field as "$$SO208504$$"
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Row presentation' |
			| 'Trousers*'        |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The basis must be the order this invoice was generated from
		And I click the button named "FormDataProcessorRowIDInspectorRowIDInspector"
		Then "Row ID Inspector" window is opened
		Then the form attribute named "Basis" became equal to "*ales order $$SO208504$$ dated*" template
	And I close all client application windows
