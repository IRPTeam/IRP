#language: en
@tree
@Positive
@LinkedTransaction

# RowID in the RETAIL chain (PR IRPTeam/IRP#2947 made the Retail documents RowID
# recorders): a Sales order with the "Retail sales" transaction type issues its RowID
# quota, and the Retail shipment confirmation generated on its basis consumes it and
# writes its own row-attribute snapshot into RowIDStamps (new registerRecords of the PR).
#
# DATA ISOLATION (sequential @LinkedTransaction tag): own documents only, Comment
# marker LT2083-*, scenario-local navigation. Shared catalog loaders are idempotent.

Feature: RowID in the retail chain

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _2083001 preparation (RowID retail)
	When set True value to the constant
	When set False value to the constant DisableLinkedRowsIntegrity
	When set True value to the constant Use retail orders
	When set True value to the constant Use consolidated retail sales
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog PaymentTypes objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
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
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog CancelReturnReasons objects
		When Create catalog Partners objects (Customer)
		When Create catalog RetailCustomers objects (check POS)
		When create PaymentTypes
	And I close all client application windows

Scenario: _20830011 check preparation
	When check preparation


# A retail Sales order (transaction type "Retail sales") issues its RowID quota on the
# retail step RSR&RSC; the Retail shipment confirmation generated on its basis consumes
# it (Expense on RSR&RSC), issues its own onward quota (Receipt on RSR&RGR) and - being
# a NEW RowIDStamps recorder of PR#2947 - writes its full row-attribute snapshot
# (including RetailCustomer and TransactionTypeRSC/TransactionTypeSales).
# NOTE: the retail customer must carry partner links (fixture "Name Retail customer
# Surname Retail customer"); Company is NOT auto-filled and is set explicitly.
Scenario: _2083002 a retail Sales order issues the RowID quota and the Retail shipment confirmation consumes it
	And I close all client application windows
	* Create and post SO_LT2083_02 (Retail sales, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select "Retail sales" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "RetailCustomer" by "Name Retail customer Surname Retail customer" string
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click the hyperlink named "Comment"
		And I input "LT2083-02" text in the field named "Text"
		And I click "OK" button
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
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2083_02_SO$$" variable
		And I save the window as "$$LT2083_02_SO$$"
	* Harvest SO TM1010B from the list (the retail order form stays modified after
	* posting, so the form-based report would ask to save - the list is clean)
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2083-02' |
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''        | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'    | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'RSR&RSC' | '*'     | '*'         |
		And I close current window
	* Generate and post the Retail shipment confirmation from the list
		And I click the button named "FormDocumentRetailShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The RSC consumes the order quota (Expense 5 on RSR&RSC) and issues its own onward
	* quota (Receipt 5 on RSR&RGR) - exactly these two rows
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''        | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'    | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'RSR&RGR' | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '5'         | '*'          | '*'      | 'RSR&RSC' | '*'     | '*'         |
	* The RSC writes its full row-attribute snapshot into RowIDStamps (new recorder of PR#2947)
		And I select "Row IDStamps" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              | ''       | ''                                             | ''           | ''                         |
			| 'Document registrations records' | ''       | ''                                             | ''           | ''                         |
			| 'Register  "Row IDStamps"'       | ''       | ''                                             | ''           | ''                         |
			| ''                               | 'Period' | 'Resources'                                    | 'Dimensions' | ''                         |
			| ''                               | ''       | 'Value'                                        | 'Row ref'    | 'Attribute'                |
			| ''                               | '*'      | 'No'                                           | '*'          | 'IsFixedItemKey'           |
			| ''                               | '*'      | 'No'                                           | '*'          | 'IsFixedStore'             |
			| ''                               | '*'      | 'No'                                           | '*'          | 'IsVariableItemKey'        |
			| ''                               | '*'      | 'No'                                           | '*'          | 'IsVariableStore'          |
			| ''                               | '*'      | 'No'                                           | '*'          | 'PriceIncludeTaxPurchases' |
			| ''                               | '*'      | 'No'                                           | '*'          | 'PriceIncludeTaxSales'     |
			| ''                               | '*'      | 'Main Company'                                 | '*'          | 'Company'                  |
			| ''                               | '*'      | 'TRY'                                          | '*'          | 'CurrencySales'            |
			| ''                               | '*'      | 'XS/Blue'                                      | '*'          | 'ItemKey'                  |
			| ''                               | '*'      | 'Dress'                                        | '*'          | 'Item'                     |
			| ''                               | '*'      | 'Name Retail customer Surname Retail customer' | '*'          | 'RetailCustomer'           |
			| ''                               | '*'      | 'Store 02'                                     | '*'          | 'Store'                    |
			| ''                               | '*'      | 'pcs'                                          | '*'          | 'Unit'                     |
			| ''                               | '*'      | '*'                                            | '*'          | 'Basis'                    |
			| ''                               | '*'      | '*'                                            | '*'          | 'Requester'                |
			| ''                               | '*'      | 'Stock'                                        | '*'          | 'ProcurementMethod'        |
			| ''                               | '*'      | 'Pickup'                                       | '*'          | 'TransactionTypeRSC'       |
			| ''                               | '*'      | 'Retail sales'                                 | '*'          | 'TransactionTypeSales'     |
		And I close all client application windows

# Undoing the retail order while the Retail shipment confirmation lives must be
# blocked by the RowID quota control (the RSC has consumed the order quota).
Scenario: _2083003 undo of a retail Sales order with a living Retail shipment confirmation is blocked
	And I close all client application windows
	* Create and post SO_LT2083_03 (Retail sales, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select "Retail sales" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "RetailCustomer" by "Name Retail customer Surname Retail customer" string
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click the hyperlink named "Comment"
		And I input "LT2083-03" text in the field named "Text"
		And I click "OK" button
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
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I close all client application windows
	* Generate and post the Retail shipment confirmation from the list (consumes the quota)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2083-03' |
		And I click the button named "FormDocumentRetailShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I close all client application windows
	* Undoing the retail order is blocked: the quota is consumed by the living RSC
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2083-03' |
		And I select current line in "List" table
		And I click the button named "FormUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then there are lines in TestClient message log
			| 'Line No. [1] [Dress XS/Blue] RowID movements remaining: 5 . Required: 0 . Lacking: 5 .' |
		And I close all client application windows

# Retail min-split: a Retail shipment confirmation RAISED above the order quantity is
# legal - it consumes only the available order quota (Expense = 5) and issues its own
# onward quota for the full shipped quantity (Receipt = 8); the extra 3 is a free
# untracked tail, not an over-consumption (mirror of the SI min-split _2076004).
Scenario: _2083004 a Retail shipment confirmation larger than the order consumes only the available quota
	And I close all client application windows
	* Create and post SO_LT2083_04 (Retail sales, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select "Retail sales" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "RetailCustomer" by "Name Retail customer Surname Retail customer" string
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click the hyperlink named "Comment"
		And I input "LT2083-04" text in the field named "Text"
		And I click "OK" button
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
		And I activate field named "ItemListStore" in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I close all client application windows
	* Generate the Retail shipment confirmation, raise its quantity to 8 and post
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2083-04' |
		And I click the button named "FormDocumentRetailShipmentConfirmationGenerate"
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Only 5 are consumed from the order (Expense 5 on RSR&RSC); the own onward quota
	* covers the full 8, SPLIT into the free tail (Receipt 3) and the linked part
	* (Receipt 5), both on RSR&RGR - exactly these three rows
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''        | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''        | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'    | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '3'         | '*'          | '*'      | 'RSR&RGR' | '*'     | '*'         |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'RSR&RGR' | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '5'         | '*'          | '*'      | 'RSR&RSC' | '*'     | '*'         |
		And I close all client application windows
