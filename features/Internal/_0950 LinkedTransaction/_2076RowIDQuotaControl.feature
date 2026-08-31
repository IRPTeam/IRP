#language: en
@tree
@Positive
@LinkedTransaction

# RowID quota control (AccumulationRegister.TM1010B_RowIDMovements): a Sales order
# ISSUES a quota (Receipt on its NextStep), a consuming Sales invoice CONSUMES it
# (Expense = min(remaining balance, row quantity)). The excess of a consumer over its
# basis is a LEGAL untracked free tail (min-split semantics), not an error. This file
# pins the full quota lifecycle through the UI (generate-on-basis form + the document's
# own TM1010B registrations report):
#   - issue / consume / min-split boundaries (_2076002.._2076006);
#   - document COPY starts an independent thread (_2076007, _2076008 - ex _2077);
#   - order CLOSING releases the unconsumed remainder as a negative Receipt on the
#     same step, on BOTH chains SO->SI->SOC and PO->PI->POC, and undoing the closing
#     returns the quota (_2076009.._2076013 - ex _2078);
#   - picker boundaries: the remainder after a partial invoice is offered EXACTLY, and
#     an unposted invoice holds no quota (_2076014, _2076015).
#
# TM1010B report layout (D0009): '' | Record type | Period | Quantity | Row ref |
# Row ID | Step | Basis | Basis key. All movement checks are EXACT (is equal on the
# full report layout); non-deterministic cells (period, row UUIDs, basis presentation)
# are masked with '*'. An extra or duplicated movement row fails the check.
#
# DATA ISOLATION (sequential @LinkedTransaction tag): own documents only, Comment
# markers LT2076-* / LT2077-* / LT2078-*, scenario-local navigation. Shared catalog
# loaders are idempotent.

Feature: RowID quota control, copy threads and closing release

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _2076001 preparation (RowID quota control)
	When set True value to the constant
	When set False value to the constant DisableLinkedRowsIntegrity
	* Load info
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
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
	And I close all client application windows

Scenario: _20760011 check preparation
	When check preparation


Scenario: _2076002 posting a Sales order issues the RowID quota on register TM1010B
	And I close all client application windows
	* Create and post SO_LT2076_02 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2076-02" text in the field named "Text"
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
	* The Sales order issues a quota of 5 on TM1010B (Receipt on its NextStep)
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


Scenario: _2076003 a consuming Sales invoice writes the quota expense on TM1010B
	And I close all client application windows
	* Create and post SO_LT2076_03 (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2076-03" text in the field named "Text"
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
	* Generate a Sales invoice on the basis of the SO and post it (consumes all 5)
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The SI consumes the SO quota (Expense 5 on SI&SC) and issues its own shipment
	* quota (Receipt 5 on SC) - exactly these two rows, nothing else
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '5'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


# min-split: a consumer larger than its basis is LEGAL. The Sales invoice of qty 10
# against a Sales order of qty 5 consumes exactly 5 (Expense = min(balance, qty)); the
# excess 5 is an untracked free tail, NOT an over-consumption and NOT an error.
Scenario: _2076004 a Sales invoice larger than the Sales order consumes only the available quota
	And I close all client application windows
	* Create and post SO_LT2076_04 (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2076-04" text in the field named "Text"
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
	* Generate the Sales invoice, raise its quantity to 10 (5 over the SO) and post
		And I click "Sales invoice" button
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Only 5 are consumed from the SO (Expense 5 on SI&SC, not 10); the SI's own
	* shipment quota is issued for the full 10 (Receipt 10 on SC) - the extra 5 is a
	* free untracked tail, not an over-consumption
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '10'        | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '5'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


# Boundary: quantity consumed == quota. Once a Sales invoice has consumed all 5, a
# second Sales invoice CANNOT be generated from the same Sales order: the linked-rows
# picker (Add linked document rows) opens with an EMPTY basis tree - there is nothing
# left to link, and Ok creates no document.
Scenario: _2076005 a fully consumed Sales order offers no rows for a second Sales invoice
	And I close all client application windows
	* Create and post SO_LT2076_05 (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2076-05" text in the field named "Text"
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
		And I delete "$$LT2076_05_SO$$" variable
		And I save the window as "$$LT2076_05_SO$$"
	* First Sales invoice consumes all 5
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPostAndClose"
	* A second Sales invoice can no longer be generated: the linked-rows picker opens
	* with an EMPTY basis tree - the whole quota is consumed, nothing left to link
		When in opened panel I select "$$LT2076_05_SO$$"
		And I click "Sales invoice" button
		Then "Add linked document rows" window is opened
		Then the number of "BasisesTree" table lines is "equal" "0"
		And I click the button named "FormCancel"
		And I close all client application windows


# Undo posting of the consuming invoice RETURNS the quota to the Sales order:
# a new invoice generated afterwards is proposed the full 5 again.
Scenario: _2076006 undo posting of the Sales invoice returns the quota to the Sales order
	And I close all client application windows
	* Create and post SO_LT2076_06 (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2076-06" text in the field named "Text"
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
		And I delete "$$LT2076_06_SO$$" variable
		And I save the window as "$$LT2076_06_SO$$"
	* Generate + post a Sales invoice (consumes all 5), then undo its posting (returns the quota)
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click the button named "FormUndoPosting"
	* A new Sales invoice from the SO consumes the returned quota (Expense 5 on TM1010B)
		When in opened panel I select "$$LT2076_06_SO$$"
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '5'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows

# NOTE: the hard-control negatives (undo SO / reduce a linked row below the consumed
# quantity -> "RowID movements remaining ... Lacking ...") are already covered by
# _2065 (_2065010 change quantity in a linked row, _2065019 unpost SO with linked
# strings) and _2066 for purchases; not duplicated here per the dedup charter.



# Copying a posted Sales order starts an independent thread: fully consuming the COPY
# leaves the ORIGINAL still fully consumable (its quota was untouched).
Scenario: _2076007 a copy of a Sales order has an independent quota thread
	And I close all client application windows
	* Create and post the ORIGINAL SO_LT2077_02A (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2077-02A" text in the field named "Text"
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
		And I delete "$$LT2077_02A$$" variable
		And I save the window as "$$LT2077_02A$$"
	* Copy it (FormCopy) and post the copy - a fresh unposted SO opens
		And I click the button named "FormCopy"
		Then "Update item list info" window is opened
		And I click the button named "FormOK"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Fully consume the COPY with a Sales invoice
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPostAndClose"
	* The ORIGINAL is still fully consumable - its invoice consumes 5 (thread untouched)
		When in opened panel I select "$$LT2077_02A$$"
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '5'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


# A copy of a linked Sales invoice must NOT inherit the basis link: the copy is a
# free invoice that consumes no quota (no Expense on TM1010B). If the copy kept the
# basis it would over-consume / be blocked.
Scenario: _2076008 a copy of a linked Sales invoice carries no basis link and consumes no quota
	And I close all client application windows
	* Create and post SO_LT2077_03 (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2077-03" text in the field named "Text"
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
	* Generate the linked Sales invoice and post it (consumes 5)
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Copy the invoice and post the copy - a free invoice: ONLY its own shipment quota
	* (Receipt 5 on SC), no Expense (the basis link was not inherited)
		And I click the button named "FormCopy"
		Then "Update item list info" window is opened
		And I click the button named "FormOK"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'SC'    | '*'     | '*'         |
		And I close all client application windows



# A Sales order closing releases the FULL remaining quota when nothing was consumed:
# SO issues Receipt 5 (SI&SC), the closing posts Receipt -5 (SI&SC) -> net 0. The
# release is a negative receipt, NOT an expense; the SO becomes Closed and its
# ClosingOrder points at the closing.
Scenario: _2076009 posting a Sales order closing releases the full remaining RowID quota
	And I close all client application windows
	* Create and post SO_LT2078_02 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2078-02" text in the field named "Text"
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
	* The Sales order issues a quota of 5 (Receipt on SI&SC) and nothing is consumed yet
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close current window
	* Generate the Sales order closing from the SO and post it
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2078-02' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2078_02_SOC$$" variable
		And I save the window as "$$LT2078_02_SOC$$"
	* The closing releases the full remaining quota (Receipt -5 on SI&SC), and nothing else
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '-5'        | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close current window
	* The Sales order is now Closed and its ClosingOrder points at the closing
		And I click Open button of "Sales order" field
		Then the form attribute named "ClosingOrder" became equal to "$$LT2078_02_SOC$$"
		And I close all client application windows


# A partially consuming Sales invoice leaves the closing to release ONLY the unconsumed
# remainder: SO issues Receipt 5, an SI of qty 2 consumes Expense 2, so the closing
# releases Receipt -3 (the remaining balance), NOT -5.
Scenario: _2076010 a Sales order closing releases only the quota left after a partial invoice
	And I close all client application windows
	* Create and post SO_LT2078_03 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2078-03" text in the field named "Text"
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
	* Generate a Sales invoice, reduce its quantity to 2 (partial) and post it
		And I click "Sales invoice" button
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The Sales invoice consumes 2 of the SO quota (Expense 2 on SI&SC) and issues its
	* own shipment quota of 2 (Receipt 2 on the SC step)
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '2'         | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '2'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows
	* Generate the Sales order closing from the SO and post it
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2078-03' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The closing releases ONLY the remaining 3 (Receipt -3 on SI&SC), not -5. It does
	* not consume (no Expense); the 2 already invoiced keep their shipment quota.
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '-3'        | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


# Boundary: closing a FULLY consumed Sales order releases nothing. SO issues Receipt 5,
# an SI of qty 5 consumes Expense 5 (balance 0); the generated closing has an empty
# ItemList and posts NO TM1010B movement at all.
Scenario: _2076011 closing a fully consumed Sales order releases no quota
	And I close all client application windows
	* Create and post SO_LT2078_04 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2078-04" text in the field named "Text"
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
	* Generate a Sales invoice for the full 5 and post it (consumes all)
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPostAndClose"
	* Generate the Sales order closing from the SO: its ItemList is empty (nothing to cancel)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2078-04' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The closing posts NO RowID movement (empty report: no register block at all)
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              |
			| 'Document registrations records' |
		And I close all client application windows


# Undoing a Sales order closing RETURNS the released quota: the closing posts Receipt
# -5 (balance 0); undoing it removes that record (balance back to 5), so a Sales
# invoice generated afterwards consumes the returned quota (Expense 5). This proves the
# closing's release is a real, reversible hold - not a one-way write-off.
Scenario: _2076012 undoing a Sales order closing returns the released quota to the order
	And I close all client application windows
	* Create and post SO_LT2078_05 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2078-05" text in the field named "Text"
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
	* Close the SO from its list (the closing releases Receipt -5), then undo the closing
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2078-05' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '-5'        | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close current window
		And I click the button named "FormUndoPosting"
	* After undo the closing holds no quota (unposted: empty report, no register block)
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              |
			| 'Document registrations records' |
		And I close current window
	* Reopen the SO from the closing and consume the returned quota with a Sales invoice
		And I click Open button of "Sales order" field
		And I click the button named "FormReread"
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '5'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


# PURCHASE mirror: an APPROVED Purchase order issues the RowID quota on TM1010B as a
# Receipt on its NextStep PI&GR (a Wait-status PO issues nothing - approval is the gate).
# The Purchase order closing releases the unconsumed remainder as a Receipt with a
# negative quantity on PI&GR, exactly mirroring the sales side.
Scenario: _2076013 an approved Purchase order closing releases the RowID quota on PI&GR
	And I close all client application windows
	* Create and post PO_LT2078_06 (approved; Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2078-06" text in the field named "Text"
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
		And I delete "$$LT2078_06_PO$$" variable
		And I save the window as "$$LT2078_06_PO$$"
	* The approved Purchase order issues a quota of 5 (Receipt on PI&GR), nothing consumed
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '5'         | '*'          | '*'      | 'PI&GR' | '*'     | '*'         |
		And I close current window
	* Generate the Purchase order closing from the PO and post it
		When in opened panel I select "$$LT2078_06_PO$$"
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The closing releases the remaining quota (Receipt -5 on PI&GR), and nothing else
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '-5'        | '*'          | '*'      | 'PI&GR' | '*'     | '*'         |
		And I close all client application windows


# Boundary: the remainder after a partial invoice is offered EXACTLY (не больше и не
# меньше) to the next invoice: SI1 takes 2 of 5, the second generation picker offers
# exactly 3, and the second invoice consumes exactly that remainder.
Scenario: _2076014 the remainder after a partial invoice is offered exactly to the second invoice
	And I close all client application windows
	* Create and post SO_LT2076_14 (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2076-14" text in the field named "Text"
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
		And I delete "$$LT2076_14_SO$$" variable
		And I save the window as "$$LT2076_14_SO$$"
	* First Sales invoice takes only 2 of 5
		And I click "Sales invoice" button
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
	* The second generation picker offers EXACTLY the remainder of 3
		When in opened panel I select "$$LT2076_14_SO$$"
		And I click "Sales invoice" button
		Then "Add linked document rows" window is opened
		And I go to line in "BasisesTree" table
			| 'Row presentation' | 'Quantity' |
			| 'Dress (XS/Blue)'  | '3,000'    |
		And I click "Ok" button
	* The second invoice consumes exactly the remainder (Receipt 3 on SC, Expense 3 on SI&SC)
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '3'         | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '3'         | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


# Boundary: the quota is consumed by POSTING, not by generation - an UNPOSTED invoice
# holds nothing, so a second generation from the same order is still offered the full 5.
Scenario: _2076015 an unposted invoice holds no quota - the picker still offers the full quantity
	And I close all client application windows
	* Create and post SO_LT2076_15 (Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2076-15" text in the field named "Text"
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
		And I delete "$$LT2076_15_SO$$" variable
		And I save the window as "$$LT2076_15_SO$$"
	* Generate the first Sales invoice and leave it UNPOSTED
		And I click "Sales invoice" button
		And I click "Ok" button
	* The second generation from the same order is still offered the FULL 5
		When in opened panel I select "$$LT2076_15_SO$$"
		And I click "Sales invoice" button
		Then "Add linked document rows" window is opened
		And I go to line in "BasisesTree" table
			| 'Row presentation' | 'Quantity' |
			| 'Dress (XS/Blue)'  | '5,000'    |
		And I click the button named "FormCancel"
		And I close all client application windows
