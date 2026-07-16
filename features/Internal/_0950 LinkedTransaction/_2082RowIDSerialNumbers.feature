#language: en
@tree
@Positive
@LinkedTransaction

# RowID x serial lot numbers (AccumulationRegister.T1040T_RowIDSerialLotNumbers):
# a document that carries serial lot numbers binds each serial to the row's RowID /
# basis / step, so the serials travel with the linked-rows thread. Undo posting
# clears the binding together with the quota.
#
# T1040T is a TURNOVER register (no Record type column in the D0009 report).
#
# DATA ISOLATION (sequential @LinkedTransaction tag): own documents only, Comment
# marker LT2082-*, scenario-local navigation. Shared catalog loaders are idempotent.

Feature: RowID serial lot numbers binding

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _2082001 preparation (RowID serial lot numbers)
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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers, single row)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
	When Create Item with SerialLotNumbers (Phone)
	And I close all client application windows

Scenario: _20820011 check preparation
	When check preparation


# A Purchase invoice generated from an approved Purchase order carries the serial lot
# numbers (the order itself has none - serials appear on the invoice) and binds EACH
# serial to the row's RowID thread in T1040T on every next step (GR for the goods
# receipt leg, PRO&PR for the return leg) - 2 serials x 2 steps = exactly 4 rows.
Scenario: _2082002 a Purchase invoice binds its serial numbers to the RowID thread in T1040T
	And I close all client application windows
	* Create and post PO_LT2082_02 (approved; Phone A Brown, qty 2, serials 13456778 + 12345678)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2082-02" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Phone A'     |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key' |
			| 'Phone A' | 'Brown'    |
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
		And I input "500,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Purchase invoice on the basis, fill the serial numbers and post it
		And I click "Purchase invoice" button
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item key' |
			| 'Brown'    |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '13456778'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '12345678'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The invoice binds both serials to the thread on both next steps - exactly 4 rows
		And I click "Registrations report" button
		And I select "T 1040 Row ID Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                             | ''       | ''          | ''           | ''          | ''       | ''      | ''                  |
			| 'Document registrations records'                | ''       | ''          | ''           | ''          | ''       | ''      | ''                  |
			| 'Register  "T 1040 Row ID Serial lot numbers"'  | ''       | ''          | ''           | ''          | ''       | ''      | ''                  |
			| ''                                              | 'Period' | 'Resources' | 'Dimensions' | ''          | ''       | ''      | ''                  |
			| ''                                              | ''       | 'Quantity'  | 'Row ID'     | 'Basis key' | 'Step'   | 'Basis' | 'Serial lot number' |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'GR'     | '*'     | '12345678'          |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'GR'     | '*'     | '13456778'          |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'PRO&PR' | '*'     | '12345678'          |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'PRO&PR' | '*'     | '13456778'          |
		And I close all client application windows


# Undo posting must clear the serial binding together with the quota: after the undo
# the invoice's T1040T report is EMPTY (no register block at all).
Scenario: _2082003 undo posting clears the T1040T serial binding
	And I close all client application windows
	* Create and post PO_LT2082_03 (approved; Phone A Brown, qty 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2082-03" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Phone A'     |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key' |
			| 'Phone A' | 'Brown'    |
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
		And I input "500,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Generate the Purchase invoice on the basis, fill the serial numbers and post it
		And I click "Purchase invoice" button
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item key' |
			| 'Brown'    |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '13456778'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '12345678'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* Undo posting: the serial binding disappears together with the quota
		And I click the button named "FormUndoPosting"
		And I click "Registrations report" button
		And I select "T 1040 Row ID Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                              |
			| 'Document registrations records' |
		And I close all client application windows


# Sales side, self-contained: the serials are first purchased into Store 02 (PO->PI),
# then sold through SO->SI. The Sales invoice binds the same serials to ITS RowID
# thread in T1040T.
Scenario: _2082004 a Sales invoice binds the sold serial numbers to its RowID thread in T1040T
	And I close all client application windows
	* Purchase the serials into Store 02 (PO_LT2082_04 approved -> PI with serials, qty 2)
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Vendor Ferron, TRY" string
		And I select from the drop-down list named "Status" by "Approved" string
		And I click the hyperlink named "Comment"
		And I input "LT2082-04" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Phone A'     |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key' |
			| 'Phone A' | 'Brown'    |
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
		And I input "500,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Purchase invoice" button
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item key' |
			| 'Brown'    |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '13456778'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '12345678'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I click the button named "FormPostAndClose"
	* Sell them: SO_LT2082_04 (Phone A Brown, qty 2) -> Sales invoice with the same serials
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Agreement" by "Basic Partner terms, TRY" string
		And I click the hyperlink named "Comment"
		And I input "LT2082-04" text in the field named "Text"
		And I click "OK" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Phone A'     |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key' |
			| 'Phone A' | 'Brown'    |
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
		And I input "700,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click "Sales invoice" button
		And I click "Ok" button
		And I go to line in "ItemList" table
			| 'Item key' |
			| 'Brown'    |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '13456778'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number' |
			| 'Brown' | '12345678'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
	* The Sales invoice binds both sold serials to its thread on both next steps
	* (SC for the shipment leg, SRO&SR for the return leg) - exactly 4 rows
		And I click "Registrations report" button
		And I select "T 1040 Row ID Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '*'                                             | ''       | ''          | ''           | ''          | ''       | ''      | ''                  |
			| 'Document registrations records'                | ''       | ''          | ''           | ''          | ''       | ''      | ''                  |
			| 'Register  "T 1040 Row ID Serial lot numbers"'  | ''       | ''          | ''           | ''          | ''       | ''      | ''                  |
			| ''                                              | 'Period' | 'Resources' | 'Dimensions' | ''          | ''       | ''      | ''                  |
			| ''                                              | ''       | 'Quantity'  | 'Row ID'     | 'Basis key' | 'Step'   | 'Basis' | 'Serial lot number' |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'SC'     | '*'     | '12345678'          |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'SC'     | '*'     | '13456778'          |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'SRO&SR' | '*'     | '12345678'          |
			| ''                                              | '*'      | '1'         | '*'          | '*'         | 'SRO&SR' | '*'     | '13456778'          |
		And I close all client application windows
