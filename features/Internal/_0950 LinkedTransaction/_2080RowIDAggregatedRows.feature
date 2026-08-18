#language: en
@tree
@Positive
@LinkedTransaction

# IRP-775: order closing must stay EMPTY when the full ordered quantity is shipped and
# invoiced, even when the order holds two IDENTICAL rows (7 + 1 of the same item key)
# and the invoice rows are AGGREGATED (one row of 8 linked to both basis rows), so the
# invoice row structure no longer mirrors the order/shipment rows.
#
# DATA ISOLATION (sequential @LinkedTransaction tag): own documents only, Comment
# marker LT2080-*, scenario-local navigation. Shared catalog loaders are idempotent.

Feature: RowID with duplicated order rows and aggregated invoice rows

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _2080001 preparation (RowID aggregated rows)
	When set True value to the constant
	When set False value to the constant DisableLinkedRowsIntegrity
	* Load info
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
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

Scenario: _20800011 check preparation
	When check preparation


# Baseline (green): the same two identical order rows (7 + 1), shipped by an SC that
# mirrors them and invoiced by an SI generated 1:1 (two rows, one link each). The
# whole quantity is invoiced, so the Sales order closing has nothing to offer.
Scenario: _2080002 identical order rows invoiced one-to-one leave nothing for the order closing
	And I close all client application windows
	* Create and post SO_LT2080_02 (Ferron BP, Dress XS/Blue, rows 7 + 1)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-02" text in the field named "Text"
		And I click "OK" button
		* Row 1 - Dress XS/Blue, qty 7
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
			And I input "7,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Row 2 - Dress XS/Blue, qty 1 (identical row)
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
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_02_SO$$" variable
		And I save the window as "$$LT2080_02_SO$$"
	* Generate and post the Shipment confirmation - its rows mirror the SO exactly (7 + 1)
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '7,000'    | 'Store 02' |
			| 'XS/Blue'  | '1,000'    | 'Store 02' |
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Sales invoice - rows stay one-to-one (7 + 1, no aggregation) - and post it
		When in opened panel I select "$$LT2080_02_SO$$"
		And Delay "2"
		And I click "Sales invoice" button
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '7,000'    | 'Store 02' |
			| 'XS/Blue'  | '1,000'    | 'Store 02' |
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The SI consumes both shipment rows on SI&GR - exactly two Expense rows (1 and 7)
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Expense'     | '*'      | '1'         | '*'          | '*'      | 'SI&GR' | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '7'         | '*'          | '*'      | 'SI&GR' | '*'     | '*'         |
		And I close all client application windows
	* Everything is invoiced: the Sales order closing has NOTHING to offer
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2080-02' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# IRP-775 regression (RED until fixed): the same chain, but the Sales invoice rows are
# AGGREGATED - one ItemList row of 8 carrying TWO RowIDInfo links (7 + 1). Built via
# the Link/unlink form: unlink all -> delete row 2 -> row 1 quantity 8 -> link both
# basis rows to row 1. Everything ordered is shipped and invoiced, so the Sales order
# closing must be EMPTY; the bug makes the posting pick only ONE RowIDInfo row per
# ItemList row, and the closing wrongly offers the remainder.
Scenario: _2080003 aggregated invoice row with two links fully closes the order (IRP-775)
	And I close all client application windows
	* Create and post SO_LT2080_03 (Ferron BP, Dress XS/Blue, rows 7 + 1)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-03" text in the field named "Text"
		And I click "OK" button
		* Row 1 - Dress XS/Blue, qty 7
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
			And I input "7,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "137,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Row 2 - Dress XS/Blue, qty 1 (identical row)
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
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "137,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_03_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_03_SO_Number$$"
	* Generate and post the Shipment confirmation - its rows mirror the order (7 + 1)
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '7,000'    | 'Store 02' |
			| 'XS/Blue'  | '1,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Sales invoice from the shipment confirmation - it repeats the rows one to one
		And Delay "2"
		And I click "Sales invoice" button
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '7,000'    | 'Store 02' |
			| 'XS/Blue'  | '1,000'    | 'Store 02' |
	* Merge the two invoice rows into one row of 8
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '7,000'    |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '1,000'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		Then the number of "ItemList" table lines is "equal" "1"
	* Unlink the basis rows - the unlink and the link are two separate form sessions
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to the first line in "ResultsTree" table
		And I activate field named "ResultsTreeRowPresentation" in "ResultsTree" table
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
	* Link the single row to BOTH shipment rows (7 and 1)
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '7,000'    | '137,00' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '1,000'    | '137,00' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Relinking resets the row quantity - set the aggregated quantity again
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '8,000'    | 'Store 02' |
	* Post the aggregated invoice
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_03_SI$$" variable
		And I save the value of "Number" field as "$$LT2080_03_SI$$"
	* The single posted invoice row carries TWO links (7 + 1)
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		Then the number of "RowIDInfo" table lines is "equal" "2"
		And "RowIDInfo" table contains lines
			| 'Quantity' |
			| '7,000'    |
		And "RowIDInfo" table contains lines
			| 'Quantity' |
			| '1,000'    |
		And I close all client application windows
	* The posted aggregated invoice really exists
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'           | 'Amount' |
			| '$$LT2080_03_SI$$' | '1 096,00' |
		And I close all client application windows
	* The whole ordered quantity is invoiced: the Sales order closing must be EMPTY (IRP-775)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_03_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# IRP-775 (PR 2969) rewrote the R2012B posting query to split the invoice row by RowID:
#   Amount = ItemList.TotalAmount / ItemList.Quantity * RowIDInfo.Quantity
# ItemList.Quantity is the quantity in the DOCUMENT unit, while RowIDInfo.Quantity is
# stored in BASE units (RowIDInfoServer.FillRowID writes QuantityInBaseUnit). For a row
# measured in packages the two differ by the package factor, so the amount is multiplied
# by it. Here: 2 boxes x 8 pcs at 100 per box = 200, and the register must record
# quantity 16 with amount 200 - not 1600.
Scenario: _2080004 invoice row in packages keeps the ordered amount in the closing register
	And I close all client application windows
	* Create and post SO_LT2080_04 (Ferron BP, Dress XS/Blue, 2 boxes of 8 pcs)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-04" text in the field named "Text"
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
		And I select "box Dress (8 pcs)" exact value from "Unit" drop-down list in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Unit'              | 'Total amount' |
			| 'XS/Blue'  | '2,000'    | 'box Dress (8 pcs)' | '200,00'       |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_04_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_04_SO_Number$$"
	* Generate and post the Shipment confirmation
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Sales invoice from the shipment confirmation and post it
		And Delay "2"
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* The closing register keeps the ordered amount, not the amount scaled by the package factor
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| ''  | 'Expense'  | '*'  | '16'  | '200'  | '*'  | 'Main Company'  | '*'  | '*'  | 'TRY'  | 'XS/Blue'  | '*'  |
		And I close all client application windows
	* The whole ordered quantity is invoiced: the Sales order closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_04_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# IRP-775 (PR 2969) made the order-closing filling join the R2012B balance by RowID:
#   Document.SalesOrder.RowIDInfo INNER JOIN R2012B.Balance ON RowIDInfo.RowID = Balance.RowKey
# A row with ProcurementMethod = Incoming reserve carries TWO RowIDInfo records with the
# SAME Key and the SAME RowID (RowIDInfoServer.FillRowID_SO adds a second one with
# NextStep = PRR), so the join multiplies the balance and the closing offers the ordered
# quantity twice. One order row must produce exactly one closing row.
Scenario: _2080005 incoming reserve row is offered once in the order closing
	And I close all client application windows
	* Create and post SO_LT2080_05 (Ferron BP, Dress XS/Blue, 10 pcs, incoming reserve)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-05" text in the field named "Text"
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
		And I select "Incoming reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "141,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_05_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_05_SO_Number$$"
	* The order row carries two RowIDInfo records with the same RowID - that is by design
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		Then the number of "RowIDInfo" table lines is "equal" "2"
		And I close all client application windows
	* Nothing is invoiced yet: the closing offers the ordered quantity ONCE, not twice
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_05_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "1"
		And "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '10,000'   |
		And I close all client application windows


# IRP-775 (PR 2969): DocOrderClosingServer.RefreshClosing matches a filling row to an
# existing document row by SalesOrderKey alone and always takes ClosingRows[0]. Since the
# new filling query can return several rows for one order row (one per open RowID), every
# filling row overwrites the same first document row on each write, and the remaining rows
# keep their previous values. RefreshClosing runs on every BeforeWrite, so simply saving
# the closing document twice must not change its quantities.
#
# NOTE: on the current build this already fails on the very first filling because of the
# duplicated closing rows proven by _2080005 - the Incoming reserve setup is the only way to
# get several open RowIDs on one order row. Once that duplication is fixed, this scenario
# becomes the isolated regression test for the RefreshClosing collapse.
Scenario: _2080006 saving the order closing twice keeps its quantities
	And I close all client application windows
	* Create and post SO_LT2080_06 (Ferron BP, Dress XS/Blue, 10 pcs, incoming reserve)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-06" text in the field named "Text"
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
		And I select "Incoming reserve" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "143,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_06_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_06_SO_Number$$"
		And I close all client application windows
	* Create the closing and save it - RefreshClosing runs on every write
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_06_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I click the button named "FormWrite"
		And I wait "Number" field will be filled in "30" seconds
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '10,000'   |
	* Saving it a second time must not change the quantities
		And I click the button named "FormWrite"
		Then user message window does not contain messages
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '10,000'   |
		Then the number of "ItemList" table lines is "equal" "1"
		And I close all client application windows


# IRP-775 (PR 2969) splits the invoice amount across the linked order rows as
#   Amount = TotalAmount / Quantity * RowIDInfo.Quantity
# without redistributing the rounding remainder. With a price that does not divide evenly
# the split amounts no longer add up to the invoiced amount, so the order keeps a non-zero
# AMOUNT balance while its quantity balance is zero - and the closing, which joins the
# balance without filtering on quantity, then offers a zero-quantity row.
Scenario: _2080007 aggregated invoice with an uneven price leaves nothing for the order closing
	And I close all client application windows
	* Create and post SO_LT2080_07 (Ferron BP, Dress XS/Blue, rows 7 + 1 at 100,01)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-07" text in the field named "Text"
		And I click "OK" button
		* Row 1 - Dress XS/Blue, qty 7
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
			And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "100,01" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Row 2 - Dress XS/Blue, qty 1 (identical row)
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
			And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "100,01" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_07_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_07_SO_Number$$"
	* Generate and post the Shipment confirmation
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Sales invoice from the shipment confirmation
		And Delay "2"
		And I click "Sales invoice" button
		And I click "Ok" button
	* Merge the two invoice rows into one row of 8
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '4,000'    |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '4,000'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		Then the number of "ItemList" table lines is "equal" "1"
	* Unlink the basis rows - the unlink and the link are two separate form sessions
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to the first line in "ResultsTree" table
		And I activate field named "ResultsTreeRowPresentation" in "ResultsTree" table
		And in the table "ResultsTree" I click "Unlink all" button
		And I click "Ok" button
	* Link the single row to BOTH shipment rows (7 and 1)
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '4,000'    | '100,01' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '4,000'    | '100,01' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Relinking resets the row quantity - set the aggregated quantity, then an amount
	* that does not split evenly between the two equal basis rows (100,01 / 2 = 50,005)
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListTotalAmount" in "ItemList" table
		And I input "100,01" text in the field named "ItemListTotalAmount" of "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Total amount' |
			| 'XS/Blue'  | '8,000'    | '100,01'       |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I close all client application windows
	* The whole ordered quantity is invoiced: the closing must be EMPTY, with no rounding leftovers
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_07_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# B2 (High): a Sales order row whose item key is unlocked must still be fully closed by the
# downstream chain even when a substituted item key is used. ItemKey is a dimension of
# R2012B_SalesOrdersInvoiceClosing and the order books its Receipt on the ORDERED item key,
# so the invoice has to expense the ordered key as well. Before the PR the SalesInvoice wrote
# Expense(ordered key) + Receipt(substituted key) + Expense(substituted key); the PR writes a
# single Expense on the substituted key, so the ordered key stays open forever and the order
# closing keeps offering the whole quantity.
# Confirmed live on the PR build: the register keeps Receipt(XS/Blue) +5 and Expense(M/White) -5,
# i.e. the ordered key is never cleared. The Sales order CLOSING is blind to it, because
# DocOrderClosingServer joins the balance on RowKey only and 5 + (-5) nets to zero - so the
# closing check below stays green while the register is already corrupted. The register check
# is what fails.
# EXPECTED FAILURE until the item key substitution is restored in the R2012B query of
# SalesInvoice.ManagerModule - this is regression evidence, do NOT wrap it in XFAIL.
Scenario: _2080008 invoice with a substituted item key closes an order row with an unlocked item key
	And I close all client application windows
	* Create and post SO_LT2080_08 (Ferron BP, Dress XS/Blue, qty 5, variable item key)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-08" text in the field named "Text"
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
		And I input "123,00" text in the field named "ItemListPrice" of "ItemList" table
		And I set "Is variable item key" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Is variable item key' |
			| 'XS/Blue'  | '5,000'    | 'Yes'                  |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_08_SO$$" variable
		And I save the window as "$$LT2080_08_SO$$"
	* Generate the Shipment confirmation and substitute the item key with M/White
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '5,000'    | 'Store 02' |
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I select "M/White" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'M/White' | '5,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate and post the Sales invoice - it carries the substituted item key
		When in opened panel I select "$$LT2080_08_SO$$"
		And Delay "2"
		And I click "Sales invoice" button
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'M/White' | '5,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* The invoice must clear the order on the ORDERED item key too - ItemKey is a dimension
	* of R2012B, so an expense booked only on the substituted key leaves the order open
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines
			| '' | 'Expense' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'XS/Blue' | '*' |
			| '' | 'Receipt' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
		And I close all client application windows
	* The order is fully invoiced: the Sales order closing has NOTHING to offer
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Comment'   |
			| 'LT2080-08' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows
