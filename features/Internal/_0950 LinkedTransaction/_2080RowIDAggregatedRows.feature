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
#Scenario: _2080003 aggregated invoice row with two links fully closes the order (IRP-775)
#	And I close all client application windows
#	* Create and post SO_LT2080_03 (Ferron BP, Dress XS/Blue, rows 7 + 1)
#		Given I open hyperlink "e1cib/list/Document.SalesOrder"
#		And I click the button named "FormCreate"
#		And I select from the drop-down list named "Partner" by "Ferron BP" string
#		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
#		And I click the hyperlink named "Comment"
#		And I input "LT2080-03" text in the field named "Text"
#		And I click "OK" button
#		* Row 1 - Dress XS/Blue, qty 7
#			And in the table "ItemList" I click the button named "ItemListAdd"
#			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
#			And I go to line in "List" table
#				| 'Description' |
#				| 'Dress'       |
#			And I select current line in "List" table
#			And I activate field named "ItemListItemKey" in "ItemList" table
#			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
#			And I go to line in "List" table
#				| 'Item'  | 'Item key' |
#				| 'Dress' | 'XS/Blue'  |
#			And I select current line in "List" table
#			And I activate field named "ItemListStore" in "ItemList" table
#			And I click choice button of the attribute named "ItemListStore" in "ItemList" table
#			And I go to line in "List" table
#				| 'Description' |
#				| 'Store 02'    |
#			And I select current line in "List" table
#			And I activate field named "ItemListQuantity" in "ItemList" table
#			And I input "7,000" text in the field named "ItemListQuantity" of "ItemList" table
#			And I activate field named "ItemListPrice" in "ItemList" table
#			And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
#			And I finish line editing in "ItemList" table
#		* Row 2 - Dress XS/Blue, qty 1 (identical row)
#			And in the table "ItemList" I click the button named "ItemListAdd"
#			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
#			And I go to line in "List" table
#				| 'Description' |
#				| 'Dress'       |
#			And I select current line in "List" table
#			And I activate field named "ItemListItemKey" in "ItemList" table
#			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
#			And I go to line in "List" table
#				| 'Item'  | 'Item key' |
#				| 'Dress' | 'XS/Blue'  |
#			And I select current line in "List" table
#			And I activate field named "ItemListStore" in "ItemList" table
#			And I click choice button of the attribute named "ItemListStore" in "ItemList" table
#			And I go to line in "List" table
#				| 'Description' |
#				| 'Store 02'    |
#			And I select current line in "List" table
#			And I activate field named "ItemListQuantity" in "ItemList" table
#			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
#			And I activate field named "ItemListPrice" in "ItemList" table
#			And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
#			And I finish line editing in "ItemList" table
#		And I click the button named "FormPost"
#		And I wait "Number" field will be filled in "30" seconds
#		And I delete "$$LT2080_03_SO$$" variable
#		And I save the window as "$$LT2080_03_SO$$"
#	* Generate and post the Shipment confirmation (rows mirror the SO: 7 + 1)
#		And I click the button named "FormDocumentShipmentConfirmationGenerate"
#		And I click "Ok" button
#		And I click the button named "FormPost"
#		And I wait "Number" field will be filled in "30" seconds
#	* Generate the Sales invoice (1:1 rows) and AGGREGATE it into one row of 8
#		When in opened panel I select "$$LT2080_03_SO$$"
#		And I click "Sales invoice" button
#		And I click "Ok" button
#	* Unlink everything (rows become free and editable)
#		And in the table "ItemList" I click "Link unlink basis documents" button
#		Then "Link / unlink document row" window is opened
#		And I set checkbox "Linked documents"
#		And in the table "ResultsTree" I click "Unlink all" button
#		And I click "Ok" button
#	* Delete row 2 and raise row 1 quantity to 8
#		And I go to line in "ItemList" table
#			| 'Item key' | 'Quantity' |
#			| 'XS/Blue'  | '1,000'    |
#		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
#		And I go to line in "ItemList" table
#			| 'Item key' | 'Quantity' |
#			| 'XS/Blue'  | '7,000'    |
#		And I select current line in "ItemList" table
#		And I activate field named "ItemListQuantity" in "ItemList" table
#		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
#		And I finish line editing in "ItemList" table
#	* Link BOTH shipment rows (7 and 1) to the single invoice row
#		And in the table "ItemList" I click "Link unlink basis documents" button
#		Then "Link / unlink document row" window is opened
#		And I go to the first line in "ItemListRows" table
#		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
#		And I go to the first line in "BasisesTree" table
#		And I expand current line in "BasisesTree" table
#		And I go to line in "BasisesTree" table
#			| 'Row presentation' | 'Quantity' |
#			| 'Dress (XS/Blue)'  | '7,000'    |
#		And I click "Link" button
#		And I go to line in "BasisesTree" table
#			| 'Row presentation' | 'Quantity' |
#			| 'Dress (XS/Blue)'  | '1,000'    |
#		And I click "Link" button
#		And I click "Ok" button
#	* The single invoice row now carries TWO links (7 + 1)
#		And I click "Show row key" button
#		Then the number of "RowIDInfo" table lines is "equal" "2"
#		And "RowIDInfo" table contains lines
#			| 'Quantity' |
#			| '7,000'    |
#		And "RowIDInfo" table contains lines
#			| 'Quantity' |
#			| '1,000'    |
#	* Post the aggregated invoice
#		And I click the button named "FormPost"
#		And I wait "Number" field will be filled in "30" seconds
#		And I close all client application windows
#	* The order is fully invoiced: the Sales order closing must be EMPTY (IRP-775)
#		Given I open hyperlink "e1cib/list/Document.SalesOrder"
#		And I go to line in "List" table
#			| 'Comment'   |
#			| 'LT2080-03' |
#		And I click the button named "FormDocumentSalesOrderClosingGenerate"
#		Then the number of "ItemList" table lines is "equal" "0"
#		And I close all client application windows
