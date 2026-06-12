#language: en
@tree
@Positive
@UserDataCorrection

Functionality: edit date of document locked by order closing (user data correction)

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

# PR #2946: when a document (SI/PI/SC/GR) is linked to a posted Sales/Purchase order closing,
# the Date field becomes read only and the "Edit date" hyperlink opens CommonForm.EditOrderClosingDate,
# which moves the closing date forward together with the document date in one transaction.
# Stock balance control is active (TestDB Store 1 has NegativeStockControl = True),
# linked rows integrity control is enabled at the end of preparation.
Scenario: _2970000 preparation (edit order closing date)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects (test data base)
		When Create catalog RowIDs objects (test data base)
		When Create catalog BusinessUnits objects (test data base)
		When Create catalog CancelReturnReasons objects (test data base)
		When Create catalog Companies objects (test data base)
		When Create catalog Countries objects (test data base)
		When Create catalog Currencies objects (test data base)
		When Create catalog ExpenseAndRevenueTypes objects (test data base)
		When Create catalog IntegrationSettings objects (test data base)
		When Create catalog ItemKeys objects (test data base)
		When Create catalog ItemTypes objects (test data base)
		When Create catalog Units objects (test data base)
		When Create catalog UnitsOfMeasurement objects (test data base)
		When Create catalog Items objects (test data base)
		When Create catalog CurrencyMovementSets objects (test data base)
		When Create catalog PartnerSegments objects (test data base)
		When Create catalog Agreements objects (test data base)
		When Create catalog Partners objects (test data base)
		When Create catalog PartnersBankAccounts objects (test data base)
		When Create catalog PriceTypes objects (test data base)
		When Create catalog SpecialOfferTypes objects (test data base)
		When Create catalog SpecialOffers objects (test data base)
		When Create catalog Specifications objects (test data base)
		When Create catalog Stores objects (test data base)
		When Create catalog TaxRates objects (test data base)
		When Create catalog Taxes objects (test data base)
		When Create information register Taxes records (test data base)
		When Create catalog LegalNameContracts objects (test data base)
		When Create catalog AccessGroups objects (test data base)
		When Create catalog AccessProfiles objects (test data base)
		When Create catalog UserGroups objects (test data base)
		When Create catalog Users objects (test data base)
		When Create chart of characteristic types AddAttributeAndProperty objects (test data base)
		When Create catalog AddAttributeAndPropertySets objects (test data base)
		When Create catalog AddAttributeAndPropertyValues objects (test data base)
		When Create chart of characteristic types CurrencyMovementType objects (test data base)
		When Create information register CurrencyRates records (test data base)
		When Create information register PartnerSegments records (test data base)
		When Create information register TaxSettings records (test data base)
	* Load documents
		When Create document OpeningEntry objects (test data base)
		When Create document GoodsReceipt objects (test data base)
		When Create document PurchaseOrder objects (test data base)
		When Create document PurchaseInvoice objects (test data base)
		When Create document SalesOrder objects (test data base)
		When Create document ShipmentConfirmation objects (test data base)
		When Create document SalesInvoice objects (test data base)
		When Create document SalesOrderClosing objects (test data base)
	* Posting documents chain
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrderClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
	* Enable linked rows integrity control
		When set False value to the constant DisableLinkedRowsIntegrity
	And I close all client application windows


Scenario: _2970001 check preparation
	When check preparation


Scenario: _2970002 check Date is read only on SalesInvoice with posted closing and Edit date moves SalesOrderClosing forward
	And I close all client application windows
	* Open SalesInvoice 1 linked to SalesOrder 1 closed by posted SalesOrderClosing 1
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' | 'Date'       |
			| '1'      | '24.02.2023' |
		And I select current line in "List" table
	* Check Date field is read only
		When I Check the steps for Exception
			| 'And I input "01.08.2023" text in the field named "Date"' |
	* Open Edit order closing date form and set new date after the closing date
		And I click the hyperlink named "EditDate"
		Then the form attribute named "Date" became equal to "24.02.2023 10:14:47"
		And "OrderClosingTable" table became equal
			| 'Doc ref'                                         |
			| 'Sales order closing 1 dated 22.07.2023 09:15:12' |
		And I input "01.08.2023" text in the field named "Date"
		And I click the button named "Save"
		And I wait "Edit order closing date" window closing in "20" seconds
	* Check SalesInvoice date is changed
		Then the editing text of form attribute named "Date" became equal to "01.08.2023 00:00:00"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number' | 'Date'       |
			| '1'      | '01.08.2023' |
	* Check SalesOrderClosing is moved 1 second after the new document date
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number' | 'Date'       |
			| '1'      | '01.08.2023' |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "01.08.2023 00:00:01"
		Then the form attribute named "SalesOrder" became equal to "Sales order 1 dated 24.02.2023 10:13:53"
	And I close all client application windows


Scenario: _2970003 check new date earlier than basis SalesOrder is blocked by linked rows control
	And I close all client application windows
	* Open SalesInvoice 1 and remember its current date
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I delete "$$SIDateBefore2970003$$" variable
		And I save the value of the field named "Date" as "$$SIDateBefore2970003$$"
	* Try to set date earlier than the basis SalesOrder 1 dated 24.02.2023
		And I click the hyperlink named "EditDate"
		And I input "01.01.2023" text in the field named "Date"
		And I click the button named "Save"
	* Check the save is rejected and the form stays opened
		And I click "Post" button
		When TestClient log message contains "Wrong linked row" string
	* Check SalesInvoice date is not changed
		Then the editing text of form attribute named "Date" became equal to "$$SIDateBefore2970003$$"
	And I close all client application windows


Scenario: _2970004 check Edit date is hidden without closing and moves PurchaseOrderClosing created for PurchaseInvoice
	And I close all client application windows
	* Check Edit date is hidden on PurchaseInvoice 1 while no posted closing exists
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' | 'Date'       |
			| '1'      | '24.02.2023' |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I click the hyperlink named "EditDate"' |
		And I close all client application windows
	* Create Purchase order closing for PurchaseOrder 1
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' | 'Date'       |
			| '1'      | '01.02.2023' |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		And for each line of "ItemList" table I do
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberPOC2970004$$" variable
		And I save the value of "Number" field as "$$NumberPOC2970004$$"
		And I click "Post and close" button
		And I close all client application windows
	* Check Date field of PurchaseInvoice 1 became read only
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' | 'Date'       |
			| '1'      | '24.02.2023' |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I input "01.01.2030" text in the field named "Date"' |
	* Open Edit order closing date form and set new date after the closing date
		And I click the hyperlink named "EditDate"
		And I input "01.01.2030" text in the field named "Date"
		And I click the button named "Save"
	* Check PurchaseInvoice date is changed
		Then the editing text of form attribute named "Date" became equal to "01.01.2030 00:00:00"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "01.01.2030 00:00:00"	
	* Check PurchaseOrderClosing is moved 1 second after the new document date
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberPOC2970004$$'    |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "01.01.2030 00:00:01"
		Then the form attribute named "PurchaseOrder" became equal to "Purchase order 1 dated 01.02.2023 09:49:47"
	And I close all client application windows


# Indirect free-stocks window case: moving SI forward drags the closing forward and delays
# the reserve release on R4011B_FreeStocks; SO-2 reserved the quantity released by the closing
# in the window between the old and the new closing date. After the move the chain must stay
# consistent: SO-2 reposts without stock control messages.
# Chain on Store 1 (NegativeStockControl = True), item "Item with item key" / "S/Color 1":
#   01.01.2022 surplus +10 -> 02.01.2022 SO-1 reserve 10 -> 03.01.2022 SI-1 ship 6
#   -> 04.01.2022 SOC-1 close 4 (free +4) -> 05.01.2022 SO-2 reserve 4 (free 0)
Scenario: _2970005 check stock stays consistent when Edit date moves closing over a window used by another order
	And I close all client application windows
	* Create stock surplus 10 pcs on 01.01.2022
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Date"
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I select from the drop-down list named "Store" by "Store 1 (with balance control)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Item with item key'   |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Color 1'   |
		And I select current line in "List" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I click the button named "FormPostAndClose"
	* Create SalesOrder SO-1 with stock reservation 10 pcs on 02.01.2022
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I input "02.01.2022" text in the field named "Date"
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'                    |
			| 'Customer 2 (2 partner term)'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		Then "Partner terms" window is opened
		And I go to line in "List" table
			| 'Description'                                |
			| 'Individual partner term 1 (by partner term)' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Item with item key'   |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Color 1'   |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate "Store" field in "ItemList" table
		And I select "Store 1 (with balance control)" from "Store" drop-down list by string in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$NumberSO1_2970005$$" variable
		And I save the value of "Number" field as "$$NumberSO1_2970005$$"
	* Create SalesInvoice SI-1 from SO-1 with partial shipment 6 pcs on 03.01.2022
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button	
		And I input "03.01.2022" text in the field named "Date"
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button	
		And I go to line in "ItemList" table
			| 'Item key'    |
			| 'S/Color 1'   |
		And I input "6,000" text in "Quantity" field of "ItemList" table
		And I remove "Use shipment confirmation" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		And I delete "$$NumberSI2970005$$" variable
		And I save the value of "Number" field as "$$NumberSI2970005$$"
		And I close all client application windows
	* Create SalesOrderClosing SOC-1 for the remaining 4 pcs on 04.01.2022
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberSO1_2970005$$'   |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I input "04.01.2022" text in the field named "Date"
		And for each line of "ItemList" table I do
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberSOC2970005$$" variable
		And I save the value of "Number" field as "$$NumberSOC2970005$$"
		And I click "Post and close" button
		And I close all client application windows
	* Create SalesOrder SO-2 reserving the released 4 pcs on 05.01.2022
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I input "05.01.2022" text in the field named "Date"
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'                    |
			| 'Customer 2 (2 partner term)'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		Then "Partner terms" window is opened
		And I go to line in "List" table
			| 'Description'                                |
			| 'Individual partner term 1 (by partner term)' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Item with item key'   |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Color 1'   |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "4,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate "Store" field in "ItemList" table
		And I select "Store 1 (with balance control)" from "Store" drop-down list by string in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		Then user message window does not contain messages
		And I delete "$$NumberSO2_2970005$$" variable
		And I save the value of "Number" field as "$$NumberSO2_2970005$$"
		And I close all client application windows
	* Move SI-1 date to 20.01.2022 via Edit date
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                 |
			| '$$NumberSI2970005$$'    |
		And I select current line in "List" table
		And I click the hyperlink named "EditDate"
		And I input "20.01.2022" text in the field named "Date"
		And I click the button named "Save"
		Then the editing text of form attribute named "Date" became equal to "20.01.2022 00:00:00"
		And I close all client application windows
	* Check SOC-1 is moved 1 second after the new SI-1 date
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberSOC2970005$$'    |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "20.01.2022 00:00:01"
		And I close all client application windows
	* Check SO-2 stays consistent - repost passes the stock balance control without messages
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberSO2_2970005$$'   |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
	And I close all client application windows


# Covers the ShipmentConfirmation form and the else-branch of EditOrderClosingDate.SaveAtServer:
# when the new document date is EARLIER than the closing date, only the document date changes
# and the closing keeps its date.
Scenario: _2970006 check Edit date on ShipmentConfirmation with date before closing does not move the closing
	And I close all client application windows
	* Remember the current SalesOrderClosing 1 date
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I delete "$$SOCDateBefore2970006$$" variable
		And I save the value of "Date" field as "$$SOCDateBefore2970006$$"
		And I close all client application windows
	* Open ShipmentConfirmation 1 linked to SalesOrder 1 closed by posted SalesOrderClosing 1
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
	* Check Date field is read only
		When I Check the steps for Exception
			| 'And I input "01.03.2023" text in the field named "Date"' |
	* Set new date after the basis SalesOrder but before the closing date
		And I click the hyperlink named "EditDate"
		And I input "01.03.2023" text in the field named "Date"
		And I click the button named "Save"
		And I wait "Edit order closing date" window closing in "20" seconds
	* Check ShipmentConfirmation date is changed
		Then the editing text of form attribute named "Date" became equal to "01.03.2023 00:00:00"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And "List" table contains lines
			| 'Number' | 'Date'       |
			| '1'      | '01.03.2023' |
	* Check SalesOrderClosing 1 keeps its date
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "$$SOCDateBefore2970006$$"
	And I close all client application windows


Scenario: _2970007 check closing Edit order closing date form without Save keeps the document date
	And I close all client application windows
	* Open SalesInvoice 1 and remember its current date
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I delete "$$SIDateBefore2970007$$" variable
		And I save the value of the field named "Date" as "$$SIDateBefore2970007$$"
	* Open Edit order closing date form, input new date and close without saving
		And I click the hyperlink named "EditDate"
		And I input "15.09.2023" text in the field named "Date"
		And I close current window
	* Check SalesInvoice date is not changed
		Then the editing text of form attribute named "Date" became equal to "$$SIDateBefore2970007$$"
	And I close all client application windows


# Realistic "several closings" case: an order can have more than one closing only when the old one
# is marked for deletion (unposted). GetArrayOfClosingOrders filters Posted, so an unposted closing
# must unlock the document, and Edit date must work with the NEW active closing only.
Scenario: _2970008 check deletion-marked closing unlocks the document and Edit date moves only the new active closing
	And I close all client application windows
	* Remember the current SalesOrderClosing 1 date
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I delete "$$OldSOCDate2970008$$" variable
		And I save the value of "Date" field as "$$OldSOCDate2970008$$"
		And I close all client application windows
	* Undo posting of SalesOrderClosing 1
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormUndoPosting"
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
		And I close all client application windows
	* Check SalesInvoice 1 is unlocked - Edit date is hidden and Date is editable
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I click the hyperlink named "EditDate"' |
		And I input "01.08.2023" text in the field named "Date"
		And I close current window
		If "1C:Enterprise" window is opened Then
			And I click "No" button
		And I close all client application windows
	* Mark SalesOrderClosing 1 for deletion
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormSetDeletionMark"
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
		And I close all client application windows
	* Create new SalesOrderClosing for SalesOrder 1
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormDocumentSalesOrderClosingGenerate"
		And I input "01.09.2023" text in the field named "Date"
		And for each line of "ItemList" table I do
			And I click choice button of "Cancel reason" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		And I click "Post" button
		And I delete "$$NumberSOC2970008$$" variable
		And I save the value of "Number" field as "$$NumberSOC2970008$$"
		And I click "Post and close" button
		And I close all client application windows
	* Check SalesInvoice 1 is locked again and move its date via Edit date
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'And I input "01.10.2023" text in the field named "Date"' |
		And I click the hyperlink named "EditDate"
		And I input "01.10.2023" text in the field named "Date"
		And I click the button named "Save"
		Then the editing text of form attribute named "Date" became equal to "01.10.2023 00:00:00"
		And I close all client application windows
	* Check the new closing is moved 1 second after the new document date
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberSOC2970008$$'    |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "01.10.2023 00:00:01"
		And I close all client application windows
	* Check the deletion-marked closing keeps its date
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "$$OldSOCDate2970008$$"
	And I close all client application windows


# Transaction atomicity: the closing is rewritten in the loop BEFORE the document itself.
# When the document write then fails (posted child earlier than the new date -> Error_186),
# the whole transaction must roll back, including the already-shifted closing.
# Uses the chain built in _2970005 (SI-1 at 20.01.2022, SOC at 20.01.2022 0:00:01).
Scenario: _2970009 check closing date shift is rolled back when the document write fails
	And I close all client application windows
	* Create posted SalesReturn from SI-1 dated 25.01.2022
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                 |
			| '$$NumberSI2970005$$'    |
		And I select current line in "List" table
		And I click the button named "FormDocumentSalesReturnGenerate"
		And I click "Ok" button	
		And I input "25.01.2022" text in the field named "Date"
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button	
		And I click the button named "FormPost"
		And I wait "Number" field will be filled in "30" seconds
		Then user message window does not contain messages
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Remember the current dates of SI-1 and its closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberSOC2970005$$'    |
		And I select current line in "List" table
		And I delete "$$SOCDateBefore2970009$$" variable
		And I save the value of "Date" field as "$$SOCDateBefore2970009$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                 |
			| '$$NumberSI2970005$$'    |
		And I select current line in "List" table
		And I delete "$$SIDateBefore2970009$$" variable
		And I save the value of the field named "Date" as "$$SIDateBefore2970009$$"
	* Try to move SI-1 past both the closing and the posted child return
		And I click the hyperlink named "EditDate"
		And I input "01.02.2022" text in the field named "Date"
		And I click the button named "Save"
	* Check the save is rejected by the child document date control
		Then there are lines in TestClient message log
			|'Line No. [1] [Item with item key S/Color 1] RowID movements remaining: 4 . Required: 6 . Lacking: 2 .'|
			|'{CommonForm.EditOrderClosingDate.Form(61)}: Error calling context method (Write): Failed to post "Sales invoice 22 dated 01.02.2022 00:00:00"!'|				
		And I close current window
	* Check SI-1 date is not changed
		Then the editing text of form attribute named "Date" became equal to "$$SIDateBefore2970009$$"
		And I close all client application windows
	* Check the closing date is rolled back together with the document
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberSOC2970005$$'    |
		And I select current line in "List" table
		Then the editing text of form attribute named "Date" became equal to "$$SOCDateBefore2970009$$"
	And I close all client application windows


//# After Edit date the closing is REPOSTED, not just re-dated: its register movements must be
//# recalculated to the new period and nothing must remain on the old date 04.01.2022.
//# Uses the chain built in _2970005 (SOC at 20.01.2022 0:00:01, closing 4 pcs of S/Color 1).
//Scenario: _2970010 check closing movements are recalculated to the new date after Edit date
//	And I close all client application windows
//	* Select the closing moved by Edit date in _2970005
//		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
//		And I go to line in "List" table
//			| 'Number'                  |
//			| '$$NumberSOC2970005$$'    |
//	* Check movements by the Register "R4011 Free stocks" are on the new period
//		And I click "Registrations report" button
//		And I select "R4011 Free stocks" exact value from "Register" drop-down list
//		And I click "Generate report" button
//		And "ResultTable" spreadsheet document contains lines:
//			| ''   | 'Expense'   | '20.01.2022 0:00:01'   | '-4'   | 'Store 1 (with balance control)'   | 'S/Color 1'   |
//		And "ResultTable" spreadsheet document does not contain values
//			| '04.01.2022'   |
//	And I close all client application windows
