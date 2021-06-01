#language: en
@tree
@Positive
@Movements
@MovementsOutgoingPaymentOrder


Feature: check Outgoing payment order movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045000 preparation (Outgoing payment order)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '115' |
			When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document PurchaseInvoice objects
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '115' |
			| '116' |
			When Create document PurchaseInvoice objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '115' |
			| '116' |
			When Create document GoodsReceipt objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document CashTransferOrder objects
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document PurchaseOrder objects (with aging, prepaid, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document PurchaseInvoice objects (with aging, prepaid, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseInvoice.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load OutgoingPaymentOrder
		When Create document OutgoingPaymentOrder objects (Cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.OutgoingPaymentOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);" |
	
Scenario: _045001 check Outgoing payment order movements by the Register "R3034 Cash planning (outgoing)"
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '323' |
	* Check movements by the Register  "R3034 Cash planning (outgoing)" 
		And I click "Registrations report" button
		And I select "R3034 Cash planning (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''                                               | ''              | ''                     |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''                                               | ''              | ''                     |
			| 'Register  "R3034 Cash planning (outgoing)"'           | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''                                               | ''              | ''                     |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''                                               | ''              | 'Attributes'           |
			| ''                                                     | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Account'           | 'Basis'                                          | 'Movement type' | 'Deferred calculation' |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '85,6'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Bank account, TRY' | ''                                               | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '154,08'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Bank account, TRY' | 'Purchase invoice 324 dated 30.05.2021 15:09:00' | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '171,2'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Bank account, TRY' | 'Purchase order 323 dated 30.05.2021 12:55:44'   | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '500'       | 'Main Company' | 'Local currency'               | 'TRY'      | 'Bank account, TRY' | ''                                               | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '500'       | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Bank account, TRY' | ''                                               | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '900'       | 'Main Company' | 'Local currency'               | 'TRY'      | 'Bank account, TRY' | 'Purchase invoice 324 dated 30.05.2021 15:09:00' | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '900'       | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Bank account, TRY' | 'Purchase invoice 324 dated 30.05.2021 15:09:00' | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '1 000'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Bank account, TRY' | 'Purchase order 323 dated 30.05.2021 12:55:44'   | 'Expense'       | 'No'                   |
			| ''                                                     | 'Receipt'     | '07.09.2020 19:23:44' | '1 000'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Bank account, TRY' | 'Purchase order 323 dated 30.05.2021 12:55:44'   | 'Expense'       | 'No'                   |
	And I close all client application windows

Scenario: _045002 check Outgoing payment order movements by the Register "R1022 Vendors payment planning" (lines with basis)
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '323' |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | ''            | ''                    | ''          | ''             | ''                                               | ''                  | ''          | ''                   |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''             | ''                                               | ''                  | ''          | ''                   |
			| 'Register  "R1022 Vendors payment planning"'           | ''            | ''                    | ''          | ''             | ''                                               | ''                  | ''          | ''                   |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                               | ''                  | ''          | ''                   |
			| ''                                                     | ''            | ''                    | 'Amount'    | 'Company'      | 'Basis'                                          | 'Legal name'        | 'Partner'   | 'Agreement'          |
			| ''                                                     | 'Expense'     | '07.09.2020 19:23:44' | '900'       | 'Main Company' | 'Purchase invoice 324 dated 30.05.2021 15:09:00' | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' |
			| ''                                                     | 'Expense'     | '07.09.2020 19:23:44' | '1 000'     | 'Main Company' | 'Purchase order 323 dated 30.05.2021 12:55:44'   | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' |
	And I close all client application windows
