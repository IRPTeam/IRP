#language: en
@tree
@Positive
@Movements2
@MovementsOutgoingPaymentOrder


Feature: check Outgoing payment order movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045000 preparation (Outgoing payment order)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When create catalog PlanningPeriods objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Countries objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog PlanningPeriods objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseInvoice objects
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			| '116'       |
			When Create document PurchaseInvoice objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			| '116'       |
			When Create document GoodsReceipt objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document CashTransferOrder objects
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseOrder objects (with aging, prepaid, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseInvoice objects (with aging, prepaid, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(323).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(324).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load OutgoingPaymentOrder
		When Create document OutgoingPaymentOrder objects (Cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.OutgoingPaymentOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
	
Scenario: _0450001 check preparation
	When check preparation

Scenario: _045002 check Outgoing payment order movements by the Register "R1022 Vendors payment planning" (lines with basis)
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report info" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | ''                    | ''           | ''             | ''             | ''                                               | ''                  | ''          | ''                   | ''       |
			| 'Register  "R1022 Vendors payment planning"'           | ''                    | ''           | ''             | ''             | ''                                               | ''                  | ''          | ''                   | ''       |
			| ''                                                     | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Basis'                                          | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Amount' |
			| ''                                                     | '07.09.2020 19:23:44' | 'Expense'    | 'Main Company' | 'Front office' | 'Purchase invoice 324 dated 30.05.2021 15:09:00' | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | '900'    |
			| ''                                                     | '07.09.2020 19:23:44' | 'Expense'    | 'Main Company' | 'Front office' | 'Purchase order 323 dated 30.05.2021 12:55:44'   | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | '1 000'  |	
	And I close all client application windows

Scenario: _045003 check Outgoing payment order movements by the Register "R3035 Cash planning"
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | ''                    | ''          | ''             | ''             | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'                       | ''                    | ''          | ''             | ''             | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'                      | ''                    | ''          | ''             | ''             | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| ''                                                     | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                                     | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Basis document'                                       | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                                     | '07.09.2020 19:23:44' | '85,6'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'USD'      | 'Outgoing'            | 'Kalipso'   | 'Company Kalipso'   | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '154,08'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '171,2'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '500'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Kalipso'   | 'Company Kalipso'   | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '500'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Kalipso'   | 'Company Kalipso'   | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '900'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '900'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '1 000'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '07.09.2020 19:23:44' | '1 000'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
	And I close all client application windows



Scenario: _045012 Outgoing payment order clear posting/mark for deletion
	And I close all client application windows
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Outgoing payment order 323 dated 07.09.2020 19:23:44'    |
			| 'Document registrations records'                          |
		And I close current window
	* Post Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Outgoing payment order 323 dated 07.09.2020 19:23:44'    |
			| 'Document registrations records'                          |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'    |
		And I close all client application windows		
