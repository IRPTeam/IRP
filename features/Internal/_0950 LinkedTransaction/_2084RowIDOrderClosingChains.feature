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
