#language: en
@tree
@Positive
@SimpleBatches


Feature: simple batches

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _998001 filling in test data base (simple batches)
When set True value to the constant
When set True value to the constant Use consolidated retail sales
When set True value to the constant Use commission trading
When set True value to the constant Use accounting
When set True value to the constant Use salary
When set True value to the constant Use retail orders
When set True value to the constant Use fixed assets
When set True value to the constant Use simple batch
When Create catalog ExternalDataProc objects (test data base)
* Add ExternalDataProc
		* Discount
				Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				And I go to line in "List" table
						| 'Description'            |
						| 'DocumentDiscount'       |
				And I select current line in "List" table
				And I select external file "$Path$/DataProcessor/DocumentDiscount.epf"
				And I click the button named "FormAddExtDataProc"
				And I input "" text in "Path to plugin for test" field
				And I click "Save and close" button
				And I wait "Plugins (create)" window closing in 5 seconds
When Create catalog AddAttributeAndPropertySets objects (test data base)
When Create catalog AddAttributeAndPropertyValues objects (test data base)
When Create catalog IDInfoAddresses objects (test data base)
When Create catalog RowIDs objects (test data base)
When Create catalog BankTerms objects (test data base)
When Create catalog BusinessUnits objects (test data base)
When Create catalog CancelReturnReasons objects (test data base)
When Create catalog CashStatementStatuses objects (test data base)
When Create catalog CashAccounts objects (test data base)
When Create catalog BillOfMaterials objects (test data base)
When Create catalog Companies objects (test data base)
When Create catalog ConfigurationMetadata objects (test data base)
When Create catalog IDInfoSets objects (test data base)
When Create catalog Countries objects (test data base)
When Create catalog Currencies objects (test data base)
When Create catalog DataBaseStatus objects (test data base)
When Create catalog ExpenseAndRevenueTypes objects (test data base)
When Create catalog IntegrationSettings objects (test data base)
When Create catalog ItemKeys objects (test data base)
When Create catalog ItemTypes objects (test data base)
When Create catalog Units objects (test data base)
When Create catalog Items objects (test data base)
When Create catalog ObjectStatuses objects (test data base)
When Create catalog CurrencyMovementSets objects (test data base)
When Create catalog PartnerSegments objects (test data base)
When Create catalog Agreements objects (test data base)
When Create catalog Partners objects (test data base)
When Create catalog PartnersBankAccounts objects (test data base)
When Create catalog PaymentTerminals objects (test data base)
When Create catalog PaymentSchedules objects (test data base)
When Create catalog PaymentTypes objects (test data base)
When Create catalog PriceTypes objects (test data base)
When Create catalog RetailCustomers objects (test data base)	
When Create catalog SpecialOfferTypes objects (test data base)
When Create catalog SpecialOffers objects (test data base)
When Create catalog Specifications objects (test data base)
When Create catalog Stores objects (test data base)
When Create catalog TaxRates objects (test data base)
When Create catalog Taxes objects (test data base)
When Create catalog SerialLotNumbers objects (test data base)
When Create information register Taxes records (test data base)
When Create catalog AccrualAndDeductionTypes objects (test data base)
When Create catalog EmployeePositions objects (test data base)
When Create catalog FixedAssetsLedgerTypes objects (test data base)
When Create catalog DepreciationSchedules objects (test data base)
When Create catalog FixedAssets objects (test data base)
When Create catalog ItemSegments objects (test data base)
When Create catalog EmployeeSchedule objects (test data base)
When Create catalog LegalNameContracts objects (test data base)
When Create catalog ObjectLocations objects (test data base)
When Create catalog Projects objects (test data base)
When Create catalog UnitsOfMeasurement objects (test data base)
When Create catalog Vehicles objects (test data base)
* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
						| 'Description'         |
						| 'Own company 2'       |
		And I select current line in "List" table
		And I move to "Tax types" tab
		And I go to line in "CompanyTaxes" table
						| 'Tax'       |
						| 'VAT'       |
		And I select current line in "CompanyTaxes" table
		And I click Open button of "Tax" field
		And I select "VAT" exact value from the drop-down list named "Kind"
		And I click "Save and close" button
		And I close all client application windows
When Create catalog InterfaceGroups objects (test data base)
When Create catalog AccessGroups objects (test data base)
When Create catalog AccessProfiles objects (test data base)
When Create catalog UserGroups objects (test data base)
When Create catalog Users objects (test data base)
When Create catalog Workstations objects (test data base)
When Create catalog PlanningPeriods objects (test data base)
When Create chart of characteristic types AddAttributeAndProperty objects (test data base)
When Create chart of characteristic types IDInfoTypes objects (test data base)
When Create chart of characteristic types CustomUserSettings objects (test data base)
When Create chart of characteristic types CurrencyMovementType objects (test data base)
When Create information register BundleContents records (test data base)
When Create information register BranchBankTerms records (test data base)
When Create information register CurrencyRates records (test data base)
When Create information register Barcodes records (test data base)
When Create information register PartnerSegments records (test data base)
When Create information register TaxSettings records (test data base)
When Create information register UserSettings records (test data base)
When Create catalog PartnerItems objects (test data base)
When Create catalog SimpleBatch objects
* Load data for Accounting system
	When Create chart of characteristic types AccountingExtraDimensionTypes objects (test data base)
	When Create chart of accounts Basic objects with LedgerTypeVariants (Basic LTV) (test data base)
	When Create information register T9011S_AccountsCashAccount records (Basic LTV) (test data base)
	When Create information register T9014S_AccountsExpenseRevenue records (Basic LTV) (test data base)
	When Create information register T9010S_AccountsItemKey records (Basic LTV) (test data base)
	When Create information register T9012S_AccountsPartner records (Basic LTV) (test data base)
	When Create information register T9013S_AccountsTax records (Basic LTV) (test data base)
* Additional table control
	Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"	
	And I go to line in "FunctionalOptions" table
		| "Option"                                |
		| "Use additional table control document" |
	And I set "Use" checkbox in "FunctionalOptions" table
	And I click "Save" button
When set False value to the constant DisableLinkedRowsIntegrity
And I close all client application windows

Scenario: _998002 check preparation (transformation system)
	When check preparation

Scenario: _998003 two write-offs at the same time
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "120,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P001" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string		
		And I click the button named "FormPost"
		And I delete "$$NumberPI1$$" variable
		And I delete "$$PI1$$" variable
		And I delete "$$DatePI1$$" variable
		And I save the value of "Number" field as "$$NumberPI1$$"
		And I save the window as "$$PI1$$"
		And I save the value of the field named "Date" as  "$$DatePI1$$"
		And I click the button named "FormPostAndClose"
	* Create two SI
		* First SI
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I select from the drop-down list named "Partner" by "Customer 3" string
			And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
			And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| "Item"               | "Item key"   |
				| "Item with item key" | "XS/Color 2" |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "150,00" text in the field named "ItemListPrice" of "ItemList" table
			And I select "P001" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
			And I finish line editing in "ItemList" table
			And I select from the drop-down list named "Branch" by "Business unit 2" string
			And I click the button named "FormPost"
			And I delete "$$NumberSI1$$" variable
			And I delete "$$SI1$$" variable
			And I delete "$$DateSI1$$" variable
			And I save the value of "Number" field as "$$NumberSI1$$"
			And I save the window as "$$SI1$$"
			And I save the value of the field named "Date" as  "$$DateSI1$$"
			And I click the button named "FormPostAndClose"
		* Second SI
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I select from the drop-down list named "Partner" by "Customer 3" string
			And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
			And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| "Item"               | "Item key"   |
				| "Item with item key" | "XS/Color 2" |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "150,00" text in the field named "ItemListPrice" of "ItemList" table
			And I select "P001" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
			And I finish line editing in "ItemList" table
			And I select from the drop-down list named "Branch" by "Business unit 2" string
			And I click the button named "FormPost"
			And I delete "$$NumberSI2$$" variable
			And I delete "$$SI2$$" variable
			And I delete "$$DateSI2$$" variable
			And I save the value of "Number" field as "$$NumberSI2$$"
			And I save the window as "$$SI2$$"
			And I save the value of the field named "Date" as  "$$DateSI2$$"
			And I click the button named "FormPostAndClose"
	* Check
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6025B_SimpleBatch"
		And "List" table became equal
			| 'Period'      | 'Recorder' | 'Line number' | 'Simple batch' | 'Quantity' | 'Amount' |
			| '$$DatePI1$$' | '$$PI1$$'  | '1'           | 'P001'         | '3,000'    | '432,00' |
			| '$$DateSI1$$' | '$$SI1$$'  | '1'           | 'P001'         | '2,000'    | '288,00' |
			| '$$DateSI2$$' | '$$SI2$$'  | '1'           | 'P001'         | '1,000'    | '144,00' |
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI2$$' | '$$SI2$$'  | 'P001'         | '$$DateSI2$$; $$SI2$$'                | '$$SI2$$'                          |
		And I close all client application windows
		

Scenario: _998004 receipt and write-off at the same time
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "150,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P002" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberPI2$$" variable
		And I delete "$$PI2$$" variable
		And I delete "$$DatePI2$$" variable
		And I save the value of "Number" field as "$$NumberPI2$$"
		And I save the window as "$$PI2$$"
		And I save the value of the field named "Date" as  "$$DatePI2$$"
		And I click the button named "FormPostAndClose"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 3" string
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "160,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P002" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I input "$$DatePI2$$" text in the field named "Date"
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click the button named "UncheckAll"
			And I click the button named "FormOK"	
		And I click the button named "FormPost"
		And I delete "$$NumberSI3$$" variable
		And I delete "$$SI3$$" variable
		And I delete "$$DateSI3$$" variable
		And I save the value of "Number" field as "$$NumberSI3$$"
		And I save the window as "$$SI3$$"
		And I save the value of the field named "Date" as  "$$DateSI3$$"
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6025B_SimpleBatch"
		And I go to line in "List" table
			| "Amount" | "Recorder" | "Simple batch" |
			| "540,00" | "$$PI2$$"  | "P002"         |	
		And I activate field named "SimpleBatch" in "List" table
		And in the table "List" I click the button named "ListContextMenuFindByCurrentValue"
		And "List" table became equal
			| 'Period'      | 'Recorder' | 'Line number' | 'Simple batch' | 'Quantity' | 'Amount' |
			| '$$DatePI2$$' | '$$PI2$$'  | '1'           | 'P002'         | '3,000'    | '540,00' |
			| '$$DateSI2$$' | '$$SI2$$'  | '1'           | 'P002'         | '2,000'    | '360,00' |
		And I close all client application windows
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI3$$' | '$$SI3$$'  | 'P002'         | '$$DateSI3$$; $$SI3$$'                | '$$SI3$$'                          |
		And I close all client application windows
		
		
Scenario: _998005 cancel receipt posting – batch should show error
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "155,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P003" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberPI3$$" variable
		And I delete "$$PI3$$" variable
		And I delete "$$DatePI3$$" variable
		And I save the value of "Number" field as "$$NumberPI3$$"
		And I save the window as "$$PI3$$"
		And I save the value of the field named "Date" as  "$$DatePI3$$"
		And I click the button named "FormPostAndClose"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 3" string
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "162,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P003" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberSI4$$" variable
		And I delete "$$SI4$$" variable
		And I delete "$$DateSI4$$" variable
		And I save the value of "Number" field as "$$NumberSI4$$"
		And I save the window as "$$SI4$$"
		And I save the value of the field named "Date" as  "$$DateSI4$$"
		And I click the button named "FormPostAndClose"	
	* Unpost PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| "Number"        |
			| "$$NumberPI3$$" |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'No'              | '$$DatePI3$$' | '$$PI3$$'  | 'P003'         | '$$DatePI3$$; $$PI3$$'                | '$$SI4$$'                          |
		And in the table "List" I click the button named "ListRestoreSelected"	
		Then there are lines in TestClient message log
			|'Not enough batch P003: On stock: 0; In document: 3.'|		
		And I close all client application windows	


Scenario: _998006 change batch in document
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "155,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P004" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberPI4$$" variable
		And I delete "$$PI4$$" variable
		And I delete "$$DatePI4$$" variable
		And I save the value of "Number" field as "$$NumberPI4$$"
		And I save the window as "$$PI4$$"
		And I save the value of the field named "Date" as  "$$DatePI4$$"
		And I click the button named "FormPostAndClose"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 3" string
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "162,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P004" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberSI5$$" variable
		And I delete "$$SI5$$" variable
		And I delete "$$DateSI5$$" variable
		And I save the value of "Number" field as "$$NumberSI5$$"
		And I save the window as "$$SI5$$"
		And I save the value of the field named "Date" as  "$$DateSI5$$"
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI5$$' | '$$SI5$$'  | 'P004'         | '$$DateSI5$$; $$SI5$$'                | '$$SI5$$'                          |
	* Change batch in the SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| "Number"        |
			| "$$NumberSI5$$" |
		And I select current line in "List" table
		And I select "P002" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And in the table "List" I click the button named "ListRestoreSelected"	
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI5$$' | '$$SI5$$'  | 'P002'         | '$$DateSI5$$; $$SI5$$'                | '$$SI5$$'                          |
		And I close all client application windows		
				
				
Scenario: _998007 remove batch from receipt document (PI)
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "159,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P006" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberPI5$$" variable
		And I delete "$$PI5$$" variable
		And I delete "$$DatePI5$$" variable
		And I save the value of "Number" field as "$$NumberPI5$$"
		And I save the window as "$$PI5$$"
		And I save the value of the field named "Date" as  "$$DatePI5$$"
		And I click the button named "FormPostAndClose"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 3" string
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "167,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P006" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberSI6$$" variable
		And I delete "$$SI6$$" variable
		And I delete "$$DateSI6$$" variable
		And I save the value of "Number" field as "$$NumberSI6$$"
		And I save the window as "$$SI6$$"
		And I save the value of the field named "Date" as  "$$DateSI6$$"
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI6$$' | '$$SI6$$'  | 'P006'         | '$$DateSI6$$; $$SI6$$'                | '$$SI6$$'                          |
	* Delete batch from PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| "Number"        |
			| "$$NumberPI5$$" |
		And I select current line in "List" table
		And I activate "Simple batch" field in "ItemList" table		
		And I input "" text in the field named "ItemListBatch" of "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And in the table "List" I click the button named "ListRestoreSelected"	
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'No'              | '$$DatePI5$$' | '$$PI5$$'  | 'P006'         | '$$DatePI5$$; $$PI5$$'                | '$$SI6$$'                          |
		Then there are lines in TestClient message log
			|'Not enough batch P006: On stock: 0; In document: 4.'|		
		And I close all client application windows							
				
				
// Scenario: _998008 remove batch from write off document (SI)
// 	And I close all client application windows
// 	* Create PI
// 		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
// 		And I click the button named "FormCreate"
// 	* Filling PI
// 		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
// 		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
// 		And in the table "ItemList" I click the button named "ItemListAdd"
// 		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
// 		And I activate field named "ItemListItemKey" in "ItemList" table
// 		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
// 		And I go to line in "List" table
// 			| "Item"               | "Item key"   |
// 			| "Item with item key" | "XS/Color 2" |
// 		And I select current line in "List" table
// 		And I activate field named "ItemListQuantity" in "ItemList" table
// 		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
// 		And I input "190,00" text in the field named "ItemListPrice" of "ItemList" table
// 		And I select "P007" by string from the drop-down list named "ItemListBatch" in "ItemList" table
// 		And I finish line editing in "ItemList" table
// 		And I select from the drop-down list named "Branch" by "Business unit 2" string
// 		And I click the button named "FormPost"
// 		And I delete "$$NumberPI6$$" variable
// 		And I delete "$$PI6$$" variable
// 		And I delete "$$DatePI6$$" variable
// 		And I save the value of "Number" field as "$$NumberPI6$$"
// 		And I save the window as "$$PI6$$"
// 		And I save the value of the field named "Date" as  "$$DatePI6$$"
// 		And I click the button named "FormPostAndClose"
// 	* Create SI
// 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
// 		And I click the button named "FormCreate"
// 		And I select from the drop-down list named "Partner" by "Customer 3" string
// 		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
// 		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
// 		And in the table "ItemList" I click the button named "ItemListAdd"
// 		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
// 		And I activate field named "ItemListItemKey" in "ItemList" table
// 		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
// 		And I go to line in "List" table
// 			| "Item"               | "Item key"   |
// 			| "Item with item key" | "XS/Color 2" |
// 		And I select current line in "List" table
// 		And I activate field named "ItemListQuantity" in "ItemList" table
// 		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
// 		And I input "192,00" text in the field named "ItemListPrice" of "ItemList" table
// 		And I select "P007" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
// 		And I finish line editing in "ItemList" table
// 		And I select from the drop-down list named "Branch" by "Business unit 2" string
// 		And I click the button named "FormPost"
// 		And I delete "$$NumberSI7$$" variable
// 		And I delete "$$SI7$$" variable
// 		And I delete "$$DateSI7$$" variable
// 		And I save the value of "Number" field as "$$NumberSI7$$"
// 		And I save the window as "$$SI7$$"
// 		And I save the value of the field named "Date" as  "$$DateSI7$$"
// 		And I click the button named "FormPostAndClose"	
// 	* Check
// 		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
// 		And "List" table contains lines
// 			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
// 			| 'Yes'             | '$$DateSI7$$' | '$$SI7$$'  | 'P007'         | '$$DateSI7$$; $$SI7$$'                | '$$SI7$$'                          |
// 	* Delete batch from SI
// 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
// 		And I go to line in "List" table
// 			| "Number"        |
// 			| "$$NumberSI7$$" |
// 		And I select current line in "List" table
// 		And I activate field named "ItemListSimpleBatch" in "ItemList" table	
// 		And I input "" text in the field named "ItemListSimpleBatch" of "ItemList" table
// 		And I finish line editing in "ItemList" table			
// 		And I click the button named "FormPostAndClose"	
// 	* Check
// 		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
// 		And in the table "List" I click the button named "ListRestoreSelected"	
// 		And "List" table contains lines
// 			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
// 			| 'No'              | '$$DateSI7$$' | '$$SI7$$'  | 'P007'         | '$$DateSI7$$; $$SI7$$'                | '$$SI7$$'                          |	
// 		And I close all client application windows			
				
Scenario: _998009 repost document without cost impact – batch must not reset
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "195,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P008" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberPI7$$" variable
		And I delete "$$PI7$$" variable
		And I delete "$$DatePI7$$" variable
		And I save the value of "Number" field as "$$NumberPI7$$"
		And I save the window as "$$PI7$$"
		And I save the value of the field named "Date" as  "$$DatePI7$$"
		And I click the button named "FormPostAndClose"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 3" string
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "197,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P008" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberSI8$$" variable
		And I delete "$$SI8$$" variable
		And I delete "$$DateSI8$$" variable
		And I save the value of "Number" field as "$$NumberSI8$$"
		And I save the window as "$$SI8$$"
		And I save the value of the field named "Date" as  "$$DateSI8$$"
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI8$$' | '$$SI8$$'  | 'P008'         | '$$DateSI8$$; $$SI8$$'                | '$$SI8$$'                          |
	* Repost PI (change comment)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| "Number"        |
			| "$$NumberPI7$$" |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedLabel"
		And I click the hyperlink named "Comment"
		And I input "test comment" text in the field named "Text"
		And I click the button named "FormOK"				
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI8$$' | '$$SI8$$'  | 'P008'         | '$$DateSI8$$; $$SI8$$'                | '$$SI8$$'                          |
		And I close all client application windows	

Scenario: _998010 move write-off document (SI) between receipts dpcuments (PI) by changing date
	And I close all client application windows
	* Create PI
		* First
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
			And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| "Item"               | "Item key"   |
				| "Item with item key" | "XS/Color 2" |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "199,00" text in the field named "ItemListPrice" of "ItemList" table
			And I select "P009" by string from the drop-down list named "ItemListBatch" in "ItemList" table
			And I finish line editing in "ItemList" table
			And I select from the drop-down list named "Branch" by "Business unit 2" string
			And I click the button named "FormPost"
			And I delete "$$NumberPI8$$" variable
			And I delete "$$PI8$$" variable
			And I delete "$$DatePI8$$" variable
			And I save the value of "Number" field as "$$NumberPI8$$"
			And I save the window as "$$PI8$$"
			And I save the value of the field named "Date" as  "$$DatePI8$$"
			And I click the button named "FormPostAndClose"
		* Second
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
			And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| "Item"               | "Item key"   |
				| "Item with item key" | "XS/Color 2" |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "210,00" text in the field named "ItemListPrice" of "ItemList" table
			And I select "P009" by string from the drop-down list named "ItemListBatch" in "ItemList" table
			And I finish line editing in "ItemList" table
			And I select from the drop-down list named "Branch" by "Business unit 2" string
			And I save "Format((EndOfDay(CurrentDate()) + 300000), \"DF=dd.MM.yyyy\")" in "$$$$DateForPI$$$$" variable
			And I input "$$$$DateForPI$$$$" text in the field named "Date"
			And I move to the next attribute
			If "Update item list info" window is opened Then
				And I click the button named "UncheckAll"
				And I click the button named "FormOK"	
			And I click the button named "FormPost"
			And I delete "$$NumberPI9$$" variable
			And I delete "$$PI9$$" variable
			And I delete "$$DatePI9$$" variable
			And I save the value of "Number" field as "$$NumberPI9$$"
			And I save the window as "$$PI9$$"
			And I save the value of the field named "Date" as  "$$DatePI9$$"
			And I click the button named "FormPostAndClose"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 3" string
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "210,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P009" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I save "Format((EndOfDay(CurrentDate()) + 432000), \"DF=dd.MM.yyyy\")" in "$$$$DateNextDay$$$$" variable
		And I input "$$$$DateNextDay$$$$" text in the field named "Date"
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click the button named "UncheckAll"
			And I click the button named "FormOK"
		And I click the button named "FormPost"
		And I delete "$$NumberSI9$$" variable
		And I delete "$$SI9$$" variable
		And I delete "$$DateSI9$$" variable
		And I save the value of "Number" field as "$$NumberSI9$$"
		And I save the window as "$$SI9$$"
		And I save the value of the field named "Date" as  "$$DateSI9$$"
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/app/DataProcessor.SimpleBatchSequence"
		And "List" table contains lines
			| 'Is actual batch' | 'Period'      | 'Recorder' | 'Simple batch' | 'Current document point presentation' | 'Last document point presentation' |
			| 'Yes'             | '$$DateSI9$$' | '$$SI9$$'  | 'P009'         | '$$DateSI9$$; $$SI9$$'                | '$$SI9$$'                          |
	* Change date in the SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| "Number"        |
			| "$$NumberSI9$$" |
		And I select current line in "List" table
		And I save "Format((EndOfDay(CurrentDate()) + 200000), \"DF=dd.MM.yyyy\")" in "$$$$DateNew$$$$" variable
		And I input "$$$$DateNew$$$$" text in the field named "Date"
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click the button named "UncheckAll"
			And I click the button named "FormOK"
		And I click the button named "FormPost"
		If "1C:Enterprise" window is opened Then
			And I click the button named "OK"		
		And I delete "$$DateSI9$$" variable
		And I save the value of the field named "Date" as  "$$DateSI9$$"
		Then there are lines in TestClient message log
			|'Not enough batch P009: On stock: 4; In document: 6.'|

Scenario: _998011 receipt with zero amount
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I select "P010" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberPI10$$" variable
		And I delete "$$PI10$$" variable
		And I delete "$$DatePI10$$" variable
		And I save the value of "Number" field as "$$NumberPI10$$"
		And I save the window as "$$PI10$$"
		And I save the value of the field named "Date" as  "$$DatePI10$$"
		And I click the button named "FormPostAndClose"
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 3" string
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I input "167,00" text in the field named "ItemListPrice" of "ItemList" table
		And I select "P010" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberSI10$$" variable
		And I delete "$$SI10$$" variable
		And I delete "$$DateSI10$$" variable
		And I save the value of "Number" field as "$$NumberSI10$$"
		And I save the window as "$$SI10$$"
		And I save the value of the field named "Date" as  "$$DateSI10$$"
		And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6025B_SimpleBatch"
		And I go to line in "List" table
			| "Amount" | "Recorder" | "Simple batch" |
			| ""       | "$$PI10$$" | "P010"         |
		And I activate field named "SimpleBatch" in "List" table
		And in the table "List" I click the button named "ListContextMenuFindByCurrentValue"
		And "List" table became equal
			| 'Period'       | 'Recorder' | 'Line number' | 'Simple batch' | 'Quantity' | 'Amount' |
			| '$$DatePI10$$' | '$$PI10$$' | '1'           | 'P010'         | '3,000'    | ''       |
			| '$$DateSI10$$' | '$$SI10$$' | '1'           | 'P010'         | '3,000'    | ''       |
		And I close all client application windows

Scenario: _998012 partial write-Off with fractional cost
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling PI
		And I select from the drop-down list named "Partner" by "Vendor 4 (1 partner term)" string
		And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| "Item"               | "Item key"   |
			| "Item with item key" | "XS/Color 2" |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListTotalAmount" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in the field named "ItemListTotalAmount" of "ItemList" table
		And I select "P011" by string from the drop-down list named "ItemListBatch" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I select from the drop-down list named "Branch" by "Business unit 2" string
		And I click the button named "FormPost"
		And I delete "$$NumberPI11$$" variable
		And I delete "$$PI11$$" variable
		And I delete "$$DatePI11$$" variable
		And I save the value of "Number" field as "$$NumberPI11$$"
		And I save the window as "$$PI11$$"
		And I save the value of the field named "Date" as  "$$DatePI11$$"
		And I click the button named "FormPostAndClose"
	* Create SI
		* First SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I select from the drop-down list named "Partner" by "Customer 3" string
			And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
			And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| "Item"               | "Item key"   |
				| "Item with item key" | "XS/Color 2" |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "167,00" text in the field named "ItemListPrice" of "ItemList" table
			And I select "P011" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
			And I finish line editing in "ItemList" table
			And I select from the drop-down list named "Branch" by "Business unit 2" string
			And I click the button named "FormPost"
			And I delete "$$NumberSI11$$" variable
			And I delete "$$SI11$$" variable
			And I delete "$$DateSI11$$" variable
			And I save the value of "Number" field as "$$NumberSI11$$"
			And I save the window as "$$SI11$$"
			And I save the value of the field named "Date" as  "$$DateSI11$$"
			And I click the button named "FormPostAndClose"	
		* Second SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I select from the drop-down list named "Partner" by "Customer 3" string
			And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
			And I select from the drop-down list named "Store" by "Store 2 (without balance control)" string
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I select "Item with item key" by string from the drop-down list named "ItemListItem" in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| "Item"               | "Item key"   |
				| "Item with item key" | "XS/Color 2" |
			And I select current line in "List" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I input "167,00" text in the field named "ItemListPrice" of "ItemList" table
			And I select "P011" by string from the drop-down list named "ItemListSimpleBatch" in "ItemList" table
			And I finish line editing in "ItemList" table
			And I select from the drop-down list named "Branch" by "Business unit 2" string
			And I click the button named "FormPost"
			And I delete "$$NumberSI12$$" variable
			And I delete "$$SI12$$" variable
			And I delete "$$DateSI12$$" variable
			And I save the value of "Number" field as "$$NumberSI12$$"
			And I save the window as "$$SI12$$"
			And I save the value of the field named "Date" as  "$$DateSI12$$"
			And I click the button named "FormPostAndClose"	
	* Check
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6025B_SimpleBatch"
		And I go to line in "List" table
			| "Amount" | "Recorder" | "Simple batch" |
			| "100,00" | "$$PI11$$" | "P011"         |
		And I activate field named "SimpleBatch" in "List" table
		And in the table "List" I click the button named "ListContextMenuFindByCurrentValue"
		And "List" table became equal
			| 'Period'       | 'Recorder' | 'Line number' | 'Simple batch' | 'Quantity' | 'Amount' |
			| '$$DatePI11$$' | '$$PI11$$' | '1'           | 'P011'         | '3,000'    | '100,00' |
			| '$$DateSI11$$' | '$$SI11$$' | '1'           | 'P011'         | '2,000'    | '66,67'  |
			| '$$DateSI12$$' | '$$SI12$$' | '1'           | 'P011'         | '1,000'    | '33,33'  |	
		And I close all client application windows