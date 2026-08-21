#language: en
@tree
@Positive
@LinkedTransaction

# IRP-775: purchase mirror of the aggregated-invoice case and the full back-to-back chain -
# both order closings must stay empty once everything is invoiced. Own documents only (LT2084-*).

Feature: RowID order closing for aggregated purchase rows and procurement chains

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _2084001 preparation (RowID order closing chains)
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

Scenario: _20840011 check preparation
	When check preparation


# Purchase mirror: one invoice row of 8 linked to both receipt rows (7 + 1) - the Purchase
# order closing must be EMPTY.
Scenario: _2084002 aggregated purchase invoice row with two links fully closes the purchase order
	And I close all client application windows
	* Create PO_LT2084_02 (Ferron BP, Dress XS/Blue, rows 7 + 1)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		Then "Purchase orders" window is opened
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2084-02" text in the field named "Text"
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
	* Post the order - only an Approved order offers a goods receipt and an invoice
		And I select "Approved" exact value from the drop-down list named "Status"
		Then the form attribute named "Status" became equal to "Approved"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_02_PO_Number$$" variable
		And I save the value of "Number" field as "$$LT2084_02_PO_Number$$"
	* Generate and post the Goods receipt - its rows mirror the order (7 + 1)
		And I click "Goods receipt" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Check all" button
		And I click "Ok" button
		Then "Goods receipt (create)" window is opened
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '7,000'    |
			| 'XS/Blue'  | '1,000'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Purchase invoice from the goods receipt - the dialog tree needs both levels expanded
		And I click "Purchase invoice" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Check all" button
		And I click "Ok" button
		Then "Purchase invoice (create)" window is opened
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '7,000'    |
			| 'XS/Blue'  | '1,000'    |
	* Replace the two generated rows with a single fresh row
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		Then the number of "ItemList" table lines is "equal" "0"
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
		And I finish line editing in "ItemList" table
	* Link the fresh row to BOTH receipt rows (7 and 1)
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' |
			| '7,000'    | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' |
			| '1,000'    | 'Dress (XS/Blue)'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Linking resets the row quantity - set the aggregated quantity again
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '8,000'    |
	* Post the aggregated invoice
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_02_PI$$" variable
		And I save the value of "Number" field as "$$LT2084_02_PI$$"
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
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'           |
			| '$$LT2084_02_PI$$' |
		And I close all client application windows
	* The whole ordered quantity is invoiced: the Purchase order closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_02_PO_Number$$' |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# Back-to-back chain SO-PO-GR-PI-SC-SI: one RowID feeds both closing registers -
# neither order closing may offer anything once both invoices are posted.
Scenario: _2084003 back-to-back chain SO-PO-GR-PI-SC-SI leaves both order closings empty
	And I close all client application windows
	* Create and post SO_LT2084_03 (Ferron BP, Dress XS/Blue, 8 pcs, procured by purchase)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		Then "Sales orders" window is opened
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2084-03" text in the field named "Text"
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
		And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "150,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_03_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2084_03_SO_Number$$"
		And I delete "$$LT2084_03_SO$$" variable
		And I save the window as "$$LT2084_03_SO$$"
	* Generate the Purchase order from the sales order, approve and post it
		And I click "Purchase order" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Check all" button
		And I click "Ok" button
		Then "Purchase order (create)" window is opened
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		If "Update item list info" window is opened Then
			And I click "OK" button
		EndIf
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '8,000'    |
		Then the number of "ItemList" table lines is "equal" "1"
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I select "Approved" exact value from the drop-down list named "Status"
		Then the form attribute named "Status" became equal to "Approved"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_03_PO_Number$$" variable
		And I save the value of "Number" field as "$$LT2084_03_PO_Number$$"
	* Generate the Goods receipt from the purchase order and post it
		And I click "Goods receipt" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Check all" button
		And I click "Ok" button
		Then "Goods receipt (create)" window is opened
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '8,000'    |
		Then the number of "ItemList" table lines is "equal" "1"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Purchase invoice from the goods receipt and post it
		And I click "Purchase invoice" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '8,000'    |
		Then the number of "ItemList" table lines is "equal" "1"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Shipment confirmation from the sales order and post it
		When in opened panel I select "$$LT2084_03_SO$$"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '8,000'    |
		Then the number of "ItemList" table lines is "equal" "1"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Sales invoice from the shipment confirmation and post it
		And I click "Sales invoice" button
		And I click "Ok" button
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '8,000'    |
		Then the number of "ItemList" table lines is "equal" "1"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_03_SI$$" variable
		And I save the value of "Number" field as "$$LT2084_03_SI$$"
		And I close all client application windows
	* The posted sales invoice really exists
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'           |
			| '$$LT2084_03_SI$$' |
		And I close all client application windows
	* The purchase side is fully invoiced: the Purchase order closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_03_PO_Number$$' |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows
	* The sales side is fully invoiced: the Sales order closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_03_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


# Purchase mirror of the item key substitution guard: the purchase order row allows a variable
# item key, the goods receipt substitutes it, and the purchase invoice must expense the
# ORDERED key too - otherwise the order receipt on R1012B is never cleared. The closing itself
# nets by RowKey and stays blind, so the register check is the evidence.
Scenario: _2084004 purchase invoice with a substituted item key clears the ordered key in the closing register
	And I close all client application windows
	* Create and post PO_LT2084_04 (Ferron BP, Dress XS/Blue, qty 5, variable item key)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		Then "Purchase orders" window is opened
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2084-04" text in the field named "Text"
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
		And I input "131,00" text in the field named "ItemListPrice" of "ItemList" table
		And I set "Is variable item key" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Is variable item key' |
			| 'XS/Blue'  | '5,000'    | 'Yes'                  |
		And I select "Approved" exact value from the drop-down list named "Status"
		Then the form attribute named "Status" became equal to "Approved"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_04_PO_Number$$" variable
		And I save the value of "Number" field as "$$LT2084_04_PO_Number$$"
	* Generate the Goods receipt and substitute the item key with M/White
		And I click "Goods receipt" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Check all" button
		And I click "Ok" button
		Then "Goods receipt (create)" window is opened
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '5,000'    |
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I select "M/White" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '5,000'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* Generate and post the Purchase invoice - it carries the substituted item key
		And I click "Purchase invoice" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		Then "Purchase invoice (create)" window is opened
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '5,000'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* The invoice must clear the order on the ORDERED item key too
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines
			| '' | 'Expense' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'XS/Blue' | '*' |
			| '' | 'Receipt' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
			| '' | 'Expense' | '*' | '5' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
		And I close all client application windows
	* The order is fully invoiced: the Purchase order closing has NOTHING to offer
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_04_PO_Number$$' |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows



# The full variable-item-key chain: the Sales order allows a variable item key and is procured
# back-to-back through a Purchase order that buys a DIFFERENT
# item key - substituted right in the PO row (the GR of a back-to-back chain does not offer
# the substitution) - then received, invoiced (PI) and sold (SC -> SI). ONE inherited RowID
# feeds both closing registers: the purchase side must clear on the purchased key alone, the
# sales side must expense the SO ordered key besides the substituted one.
Scenario: _2084005 variable item key survives the back-to-back chain and clears both closing registers
	And I close all client application windows
	* Create and post SO_LT2084_05 (Ferron BP, Dress XS/Blue, qty 4, variable item key, procured by purchase)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		Then "Sales orders" window is opened
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2084-05" text in the field named "Text"
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
		And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "149,00" text in the field named "ItemListPrice" of "ItemList" table
		And I set "Is variable item key" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Is variable item key' |
			| 'XS/Blue'  | '4,000'    | 'Yes'                  |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_05_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2084_05_SO_Number$$"
	* Generate the Purchase order and buy a DIFFERENT item key - substitute M/White in its row
		And I click "Purchase order" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Check all" button
		And I click "Ok" button
		Then "Purchase order (create)" window is opened
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		If "Update item list info" window is opened Then
			And I click "OK" button
		EndIf
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'XS/Blue'  | '4,000'    |
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I select "M/White" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I set "Is variable item key" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '4,000'    |
		And I select "Approved" exact value from the drop-down list named "Status"
		Then the form attribute named "Status" became equal to "Approved"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_05_PO_Number$$" variable
		And I save the value of "Number" field as "$$LT2084_05_PO_Number$$"
	* The Goods receipt inherits the substituted key
		And I click "Goods receipt" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Check all" button
		And I click "Ok" button
		Then "Goods receipt (create)" window is opened
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '4,000'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* The Purchase invoice matches the purchase order key - a single expense, no XS/Blue rows
		And I click "Purchase invoice" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		Then "Purchase invoice (create)" window is opened
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '4,000'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines
			| '' | 'Expense' | '*' | '4' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
		And "ResultTable" spreadsheet document does not contain values
			| 'XS/Blue' |
		And I close all client application windows
	* The Shipment confirmation fills the pinned substituted key automatically
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_05_SO_Number$$' |
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '4,000'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* The Sales invoice sells the substituted key and must expense the SO ordered key too
		And I click "Sales invoice" button
		And I click "Ok" button
		Then "ItemList" table became equal
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '4,000'    |
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines
			| '' | 'Expense' | '*' | '4' | '*' | '*' | '*' | '*' | '*' | '*' | 'XS/Blue' | '*' |
			| '' | 'Receipt' | '*' | '4' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
			| '' | 'Expense' | '*' | '4' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
		And I close all client application windows
	* Everything is received and invoiced: the Purchase order closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_05_PO_Number$$' |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows
	* Everything is shipped and invoiced: the Sales order closing must be EMPTY
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_05_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows


Scenario: _2084006 retail sales receipt with a substituted item key clears the ordered key in the closing register
	And I close all client application windows
	* Create and post a retail Sales order (Dress XS/Blue, qty 2, variable item key)
		When set True value to the constant Use retail orders
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		Then "Sales orders" window is opened
		And I click the button named "FormCreate"
		And I select "Retail sales" exact value from "Transaction type" drop-down list
		And I select "Main Company" exact value from the drop-down list named "Company"
		And I click Select button of "Retail customer" field
		And I go to line in "List" table
			| 'Description'                                  |
			| 'Name Retail customer Surname Retail customer' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		Then the form attribute named "Partner" became equal to "Customer"
		Then the form attribute named "Agreement" became equal to "Customer partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		And I click the hyperlink named "Comment"
		And I input "LT2084-06" text in the field named "Text"
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
			| 'Store 06'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I set "Is variable item key" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' | 'Is variable item key' |
			| 'XS/Blue'  | '2,000'    | 'Yes'                  |
		And I select "Approved" exact value from the drop-down list named "Status"
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2084_06_SO_Number$$" variable
		And I save the value of "Number" field as "$$LT2084_06_SO_Number$$"
	* Generate the Retail sales receipt and substitute the item key XS/Blue -> M/White
		And I click the button named "FormDocumentRetailSalesReceiptGenerate"
		And I click "Ok" button
		Then "Retail sales receipt (create)" window is opened
		And I go to the first line in "ItemList" table
		And I select current line in "ItemList" table
		And I select "M/White" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table
		Then "ItemList" table contains lines
			| 'Item key' | 'Quantity' |
			| 'M/White'  | '2,000'    |
	* Pay the full amount in cash and post the receipt
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "1 040,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I wait "Number" field will be filled in "30" seconds
	* The receipt must expense the ORDERED key too - the register check is the evidence
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines
			| '' | 'Expense' | '*' | '2' | '*' | '*' | '*' | '*' | '*' | '*' | 'XS/Blue' | '*' |
			| '' | 'Receipt' | '*' | '2' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
			| '' | 'Expense' | '*' | '2' | '*' | '*' | '*' | '*' | '*' | '*' | 'M/White' | '*' |
		And I close all client application windows
	* The Sales order closing is blind (nets by RowKey) and must be EMPTY
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$LT2084_06_SO_Number$$' |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		Then the number of "ItemList" table lines is "equal" "0"
		And I close all client application windows
