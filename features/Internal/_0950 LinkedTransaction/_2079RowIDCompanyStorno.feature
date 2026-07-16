#language: en
@tree
@Positive
@LinkedTransaction

# RowID behaviour under Company change (M2 procedure) and Storno (PR IRPTeam/IRP#2947).
# - Storno of a consuming Sales invoice reverses its TM1010B quota consumption, so the
#   Sales order row quota is released again (mirror of an undo, but via a Storno doc).
# - Changing the Company of a linked chain is guarded: re-posting a child (e.g. a
#   Shipment confirmation) with a Company different from its linked parent must fail
#   with "Wrong linked row [N]" (the linked-rows integrity check). IMPORTANT: use an
#   item WITHOUT serial-lot numbers - empty serials trigger an earlier Cancel that masks
#   the linked-row check.
#
# DATA ISOLATION (sequential @LinkedTransaction tag): own documents only, Comment
# marker LT2079-*, scenario-local navigation. Shared catalog loaders are idempotent.

Feature: RowID under company change and storno

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _2079001 preparation (RowID company change and storno)
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

Scenario: _20790011 check preparation
	When check preparation


# Storno of a consuming Sales invoice reverses its TM1010B consumption (harvest first).
Scenario: _2079002 storno of a consuming Sales invoice reverses its RowID quota consumption
	And I close all client application windows
	* Create and post SO_LT2079_02 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2079-02" text in the field named "Text"
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
	* Generate the Sales invoice on the basis and post it (consumes 5)
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Storno the Sales invoice and post the storno
		And I click the button named "FormDocumentStornoStorno"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The storno fully reverses the SI RowID footprint: Expense -5 (SI&SC, quota released)
	* and Receipt -5 (SC, shipment quota cancelled)
		And I click "Registrations report" button
		And I select "TM1010B Row ID movements" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                    | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Document registrations records'       | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| 'Register  "TM1010B Row ID movements"' | ''            | ''       | ''          | ''           | ''       | ''      | ''      | ''          |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''       | ''      | ''      | ''          |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Row ref'    | 'Row ID' | 'Step'  | 'Basis' | 'Basis key' |
			| ''                                     | 'Receipt'     | '*'      | '-5'        | '*'          | '*'      | 'SC'    | '*'     | '*'         |
			| ''                                     | 'Expense'     | '*'      | '-5'        | '*'          | '*'      | 'SI&SC' | '*'     | '*'         |
		And I close all client application windows


# M2 procedure: the Company of a posted linked chain cannot be edited directly (the
# fields are locked), so it is changed via a TEMPORARY UNDO: unpost the invoice (the
# quota returns), unpost the order (balance is 0, the control lets it through), change
# the order's Company, repost the order. After that:
#   - NEGATIVE: reposting the OLD invoice (still carrying the old Company) is refused
#     by the linked-rows integrity check with "Wrong linked row [N] [Item] [ItemKey]"
#     (FillCheckProcessing recomputes the basis with the invoice's Company filter and
#     finds nothing). Item WITHOUT serial lot numbers - an earlier serial-numbers
#     Cancel would mask the linked-row check.
#   - POSITIVE: a NEW invoice generated from the reposted order inherits the new
#     Company and consumes the quota normally - the chain lives on under the new company.
Scenario: _2079003 changing the order company via temporary undo invalidates the old invoice, a new invoice inherits the new company
	And I close all client application windows
	* Create and post SO_LT2079_03 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2079-03" text in the field named "Text"
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
		And I delete "$$LT2079_03_SO$$" variable
		And I save the window as "$$LT2079_03_SO$$"
	* Generate the Sales invoice on the basis and post it (consumes 5)
		And I click "Sales invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2079_03_SI$$" variable
		And I save the window as "$$LT2079_03_SI$$"
	* Temporary undo: first the invoice (quota returns), then the order (balance 0)
		And I click the button named "FormUndoPosting"
		When in opened panel I select "$$LT2079_03_SO$$"
		And I click the button named "FormUndoPosting"
	* Change the order company to the second company and repost the order
		And I select from the drop-down list named "Company" by "Second Company" string
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* NEGATIVE: reposting the old invoice with the OLD company fails with Wrong linked row
		When in opened panel I select "$$LT2079_03_SI$$"
		And I click the button named "FormPost"
		Then there are lines in TestClient message log
			| 'Wrong linked row [1] [Dress] [XS/Blue]' |
	* POSITIVE: a new invoice from the reposted order inherits the new company and consumes the quota
		When in opened panel I select "$$LT2079_03_SO$$"
		And I click "Sales invoice" button
		And I click "Ok" button
		Then the form attribute named "Company" became equal to "Second Company"
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


# PURCHASE mirror of the M2 negative: an approved Purchase order consumed by a
# Purchase invoice; the chain company is changed via the same temporary undo, and
# reposting the old Purchase invoice (old Company) is refused with Wrong linked row.
Scenario: _2079004 reposting a linked Purchase invoice after the order company changed fails with Wrong linked row
	And I close all client application windows
	* Create and post PO_LT2079_04 (approved; Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2079-04" text in the field named "Text"
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
		And I delete "$$LT2079_04_PO$$" variable
		And I save the window as "$$LT2079_04_PO$$"
	* Generate the Purchase invoice on the basis and post it (consumes 5)
		And I click "Purchase invoice" button
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$LT2079_04_PI$$" variable
		And I save the window as "$$LT2079_04_PI$$"
	* Temporary undo: first the invoice (quota returns), then the order (balance 0)
		And I click the button named "FormUndoPosting"
		When in opened panel I select "$$LT2079_04_PO$$"
		And I click the button named "FormUndoPosting"
	* Change the order company to the second company and repost the order
		And I select from the drop-down list named "Company" by "Second Company" string
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Reposting the old Purchase invoice with the OLD company fails with Wrong linked row
		When in opened panel I select "$$LT2079_04_PI$$"
		And I click the button named "FormPost"
		Then there are lines in TestClient message log
			| 'Wrong linked row [1] [Dress] [XS/Blue]' |
		And I close all client application windows


# Storno of the ORDER itself (the quota issuer): the storno must reverse the order's
# TM1010B quota issue - a single Receipt -5 on SI&SC - so the thread nets to zero and
# nothing can be generated from the stornoed order afterwards.
Scenario: _2079005 storno of a Sales order reverses its issued RowID quota
	And I close all client application windows
	* Create and post SO_LT2079_05 (Ferron BP, Dress XS/Blue, qty 5)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2079-05" text in the field named "Text"
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
	* Storno the Sales order and post the storno
		And I click the button named "FormDocumentStornoStorno"
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The storno fully reverses the order's quota issue: a single Receipt -5 on SI&SC
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
		And I close all client application windows
