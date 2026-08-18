#language: en
@tree
@Positive
@LinkedTransaction

# IRP-775: the order closing must stay EMPTY when everything ordered is shipped and invoiced,
# even with identical order rows and an aggregated invoice row. Own documents only (LT2080-*).

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


# Baseline: identical order rows invoiced 1:1 leave the closing empty.
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
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_02_SO$$" variable
		And I save the window as "$$LT2080_02_SO$$"
		And I delete "$$LT2080_02_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_02_SO_Number$$"
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
			| 'Number'                  |
			| '$$LT2080_02_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# IRP-775 main case: one invoice row of 8 carrying TWO links (7 + 1) - the closing must be EMPTY.
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


# EXPECTED FAILURE (B1): a row in packages books the register amount multiplied by the
# package factor - 2 boxes x 8 pcs at 100 must give amount 200, not 1600.
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
		Then the number of "ItemList" table lines is "equal" "1"
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


# EXPECTED FAILURE (B3): an Incoming reserve row is offered TWICE in the closing -
# one order row must produce exactly one closing row.
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


# EXPECTED FAILURE (B4, currently masked by B3): saving the closing document twice must
# not change its quantities.
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


# Guard: an amount that does not split evenly between the links leaves rounding leftovers
# in the register - the closing must still be EMPTY.
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
			And I input "7,000" text in the field named "ItemListQuantity" of "ItemList" table
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
			And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
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
		Then the number of "ItemList" table lines is "equal" "2"
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
			| '7,000'    | '100,01' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '1,000'    | '100,01' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Relinking resets the quantity - set 8 again and a total of 100,01 that does not split evenly
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
	* The posted row really is aggregated - it carries TWO links (7 + 1)
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		Then the number of "RowIDInfo" table lines is "equal" "2"
		And I close all client application windows
	* The whole ordered quantity is invoiced: the closing must be EMPTY, with no rounding leftovers
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_07_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# EXPECTED FAILURE (B2): with a substituted item key the invoice must expense the ORDERED
# key too; the register check is the evidence - the closing itself nets by RowKey and stays green.
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
		And I delete "$$LT2080_08_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_08_SO_Number$$"
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
	* The invoice must clear the order on the ORDERED item key too
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines
			| '' | 'Expense' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'XS/Blue' | '*' |
			| '' | 'Receipt' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
			| '' | 'Expense' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
		And I close all client application windows
	* The order is fully invoiced: the Sales order closing has NOTHING to offer
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_08_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# Guard: unlink + relink rebuilds RowIDInfo - the rebuilt link must book the quantity
# exactly once and still close the order.
Scenario: _2080009 relinked invoice row books the ordered quantity exactly once
	And I close all client application windows
	* Create and post SO_LT2080_09 (Ferron BP, Dress XS/Blue, qty 6)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-09" text in the field named "Text"
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
		And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "158,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_09_SO$$" variable
		And I save the window as "$$LT2080_09_SO$$"
		And I delete "$$LT2080_09_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_09_SO_Number$$"
	* Generate and post the Shipment confirmation (5)
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '6,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Sales invoice from the shipment confirmation
		And Delay "2"
		And I click "Sales invoice" button
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '6,000'    | 'Store 02' |
	* Link the same invoice row to the order row as well - two links on one row
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I set checkbox "Linked documents"
		And I go to the first line in "ResultsTree" table
		And I activate field named "ResultsTreeRowPresentation" in "ResultsTree" table
		And in the table "ResultsTree" I click "Unlink all" button
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '6,000'    | '158,00' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I click "Ok" button
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "6,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post the invoice and check the rebuilt link
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		Then the number of "RowIDInfo" table lines is "equal" "1"
	* The quantity must reach the register ONCE, not once per RowIDInfo record
		And I move to "Item list" tab
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                                 | ''            | ''       | ''          | ''       | ''           | ''             | ''       | ''      | ''         | ''         | ''        |
			| 'Document registrations records'                    | ''            | ''       | ''          | ''       | ''           | ''             | ''       | ''      | ''         | ''         | ''        |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''       | ''          | ''       | ''           | ''             | ''       | ''      | ''         | ''         | ''        |
			| ''                                                  | 'Record type' | 'Period' | 'Resources' | ''       | ''           | 'Dimensions'   | ''       | ''      | ''         | ''         | ''        |
			| ''                                                  | ''            | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Branch' | 'Order' | 'Currency' | 'Item key' | 'Row key' |
			| ''                                                  | 'Expense'     | '*'      | '6'         | '*'      | '*'          | 'Main Company' | ''       | '*'     | 'TRY'      | 'XS/Blue'  | '*'       |
		And I close all client application windows
	* The order is invoiced exactly once: the Sales order closing has NOTHING to offer
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_09_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# Three order rows (5 + 3 + 2) aggregated into one invoice row of 10 - the closing must be EMPTY.
Scenario: _2080010 one invoice row aggregating three order rows fully closes the order
	And I close all client application windows
	* Create and post SO_LT2080_10 (Ferron BP, Dress XS/Blue, rows 5 + 3 + 2)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-10" text in the field named "Text"
		And I click "OK" button
		* Row 1 - Dress XS/Blue, qty 5
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
			And I input "142,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Row 2 - Dress XS/Blue, qty 3
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
			And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "142,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		* Row 3 - Dress XS/Blue, qty 2
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
			And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "142,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_10_SO$$" variable
		And I save the window as "$$LT2080_10_SO$$"
		And I delete "$$LT2080_10_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_10_SO_Number$$"
	* Generate and post the Shipment confirmation - it mirrors the order (5 + 3 + 2)
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '5,000'    | 'Store 02' |
			| 'XS/Blue'  | '3,000'    | 'Store 02' |
			| 'XS/Blue'  | '2,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Sales invoice - three rows before the merge
		And Delay "2"
		And I click "Sales invoice" button
		And I click "Ok" button
		Then the number of "ItemList" table lines is "equal" "3"
	* Merge the three invoice rows into one row of 10
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '5,000'    |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '3,000'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '2,000'    |
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
	* Link the single row to ALL THREE shipment rows (5, 3 and 2)
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '5,000'    | '142,00' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '3,000'    | '142,00' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Price'  | 'Row presentation' |
			| '2,000'    | '142,00' | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Relinking resets the row quantity - set the aggregated quantity again
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '10,000'   | 'Store 02' |
	* Post the aggregated invoice
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* The single posted invoice row carries THREE links (5 + 3 + 2)
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		Then the number of "RowIDInfo" table lines is "equal" "3"
		And "RowIDInfo" table contains lines
			| 'Quantity' |
			| '5,000'    |
		And "RowIDInfo" table contains lines
			| 'Quantity' |
			| '3,000'    |
		And "RowIDInfo" table contains lines
			| 'Quantity' |
			| '2,000'    |
		And I close all client application windows
	* Everything ordered is invoiced: the Sales order closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_10_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows




# Partial invoicing (7 of 8): the closing must offer exactly the remaining 1.
Scenario: _2080011 partially invoiced order keeps the uninvoiced remainder in the closing
	And I close all client application windows
	* Create and post SO_LT2080_11 (Ferron BP, Dress XS/Blue, rows 7 + 1)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-11" text in the field named "Text"
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
			And I input "143,00" text in the field named "ItemListPrice" of "ItemList" table
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
			And I input "143,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_11_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_11_SO_Number$$"
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
	* Invoice only the 7-row and drop the 1-row
		And I go to line in "ItemList" table
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '1,000'    |
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '7,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_11_SI$$" variable
		And I save the value of "Number" field as "$$LT2080_11_SI$$"
		And I close all client application windows
	* The posted invoice really exists and is worth 7 x 143,00
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'           | 'Amount'   |
			| '$$LT2080_11_SI$$' | '1 001,00' |
		And I close all client application windows
	* Only 7 of the ordered 8 are invoiced: the closing must offer the remaining 1
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_11_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "1"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity' |
			| 'Dress' | 'XS/Blue'  | '1,000'    |
		And I close all client application windows


# One order row shipped in two parts (5 + 3): the invoice collapses into one aggregated row -
# the closing must be EMPTY.
Scenario: _2080012 order shipped in two parts is invoiced by one aggregated row and closes fully
	And I close all client application windows
	* Create and post SO_LT2080_12 (Ferron BP, Dress XS/Blue, one row of 8)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2080-12" text in the field named "Text"
		And I click "OK" button
		* The single ordered row - Dress XS/Blue, qty 8
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
			And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I activate field named "ItemListPrice" in "ItemList" table
			And I input "147,00" text in the field named "ItemListPrice" of "ItemList" table
			And I finish line editing in "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2080_12_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2080_12_SO_Number$$"
	* Ship the order in two parts - first shipment confirmation of 5
		And Delay "2"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '5,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I close all client application windows
	* Second shipment confirmation takes the remaining 3
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_12_SO_Number$$' |
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '3,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I close all client application windows
	* One invoice covers both shipments - IRP collapses them into ONE aggregated row of 8
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_12_SO_Number$$' |
		And I click "Sales invoice" button
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'XS/Blue'  | '8,000'    | 'Store 02' |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		Then the number of "RowIDInfo" table lines is "equal" "2"
		And "RowIDInfo" table contains lines
			| 'Quantity' |
			| '5,000'    |
		And "RowIDInfo" table contains lines
			| 'Quantity' |
			| '3,000'    |
		And I close all client application windows
	* The whole ordered quantity is invoiced: the closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2080_12_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows
