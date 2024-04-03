#language: en
@tree
@Positive
@Advance

Feature: vendors advances closing

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _1002000 preparation (vendors advances closing)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
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
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog SerialLotNumbers objects
		When Create catalog Projects objects
		When Create information register Taxes records (VAT)
	* Load documents
		When Create document BankPayment objects (check movements, advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.BankPayment.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.BankPayment.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment (advance)
		When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		* Load PO
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server	
				| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"     |
		* Load GR
		When Create document GoodsReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server	
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
				// | "Documents.GoodsReceipt.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"     |
		* Load PI
		When Create document PurchaseInvoice objects (test advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashPayment objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.CashPayment.FindByNumber(22).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(23).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.CashPayment.FindByNumber(24).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseInvoice objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(121).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(122).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(123).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(124).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(125).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(126).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(127).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(120).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseReturn objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseReturn.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseReturn.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document DebitNote objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents. DebitNote.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CreditNote objects (vendor, advance)
		And I execute 1C:Enterprise script at server
			| "Documents. CreditNote.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document VendorsAdvancesClosing objects
		And I execute 1C:Enterprise script at server
			| "Documents.VendorsAdvancesClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.VendorsAdvancesClosing.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows			

Scenario: _10020001 check preparation
	When check preparation

Scenario: _1002002 create VendorsAdvancesClosing
	Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
	And I click the button named "FormCreate"
	And I input "11.02.2021 12:00:00" text in "Date" field
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	And I click Select button of "Begin of period" field
	And I input "11.02.2021" text in "Begin of period" field
	And I input "11.02.2021" text in "End of period" field
	And I click Choice button of the field named "Branch"
	And I go to line in "List" table
		| 'Description'    |
		| 'Front office'   |
	And I select current line in "List" table
	And I click the button named "FormPost"
	And I delete "$$NumberVendorsAdvancesClosing11022021$$" variable
	And I delete "$$VendorsAdvancesClosing11022021$$" variable
	And I delete "$$DateVendorsAdvancesClosing11022021$$" variable
	And I save the value of "Number" field as "$$NumberVendorsAdvancesClosing11022021$$"
	And I save the window as "$$VendorsAdvancesClosing11022021$$"
	And I save the value of the field named "Date" as "$$DateVendorsAdvancesClosing11022021$$"
	And I click "Post and close" button
	And I click the button named "FormCreate"
	And I input "15.03.2021 12:00:00" text in "Date" field
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	And I click Select button of "Begin of period" field
	And I input "15.03.2021" text in "Begin of period" field
	And I input "15.03.2021" text in "End of period" field
	And I click Choice button of the field named "Branch"
	And I go to line in "List" table
		| 'Description'    |
		| 'Front office'   |
	And I select current line in "List" table
	And I click the button named "FormPost"
	And I delete "$$NumberVendorsAdvancesClosing15032021$$" variable
	And I delete "$$VendorsAdvancesClosing15032021$$" variable
	And I delete "$$DateVendorsAdvancesClosing15032021$$" variable
	And I save the value of "Number" field as "$$NumberVendorsAdvancesClosing15032021$$"
	And I save the window as "$$VendorsAdvancesClosing15032021$$"
	And I save the value of the field named "Date" as "$$DateVendorsAdvancesClosing15032021$$"
	And I click "Post and close" button
	* Check creation
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And "List" table contains lines
			| 'Number'                                     | 'Date'                  | 'Company'        | 'Begin of period'   | 'End of period'    |
			| '$$NumberVendorsAdvancesClosing11022021$$'   | '11.02.2021 12:00:00'   | 'Main Company'   | '11.02.2021'        | '11.02.2021'       |
			| '$$NumberVendorsAdvancesClosing15032021$$'   | '15.03.2021 12:00:00'   | 'Main Company'   | '15.03.2021'        | '15.03.2021'       |
	* Post all vendors advance closing
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay 5	
		And I close all client application windows
		
	

Scenario: _1002003 check PI closing by advance (Ap-Ar by documents, payment first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                          | 'Order'                                        | 'Amount'   | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '2 070,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '2 070,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '354,38'   | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '2 400,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '2 400,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '410,88'   | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '2 070,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '2 400,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '2 400,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '2 400,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '410,88'   | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '2 070,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '2 070,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '354,38'   | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | '2 400,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '2 070,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '2 300,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '2 300,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '393,76'   | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '2 300,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '1 030,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '1 030,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '176,34'   | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '1 030,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '2 300,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '2 300,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '393,76'   | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '2 300,00' | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '2 070,00' | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '2 070,00' | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '354,38'   | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '2 070,00' | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '1 600,00' | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '1 600,00' | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '273,92'   | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '1 600,00' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '2 070,00' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '2 070,00' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '354,38'   | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | '2 070,00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '1 270,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '217,42'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '1 270,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '1 230,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '210,58'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '1 230,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | '1 270,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '1 230,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '1 070,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '183,18'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '1 070,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '1 600,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '273,92'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '1 600,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '1 070,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | '1 600,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |	
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"	
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement' | 'Project' | 'Amount'   | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 251,00' | 'No'                   | ''                                                     |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '400,00'   | 'No'                   | ''                                                     |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '400,00'   | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 000,00' | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '342,40'   | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 000,00' | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '500,00'   | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '85,60'    | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '500,00'   | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '3 000,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '513,60'   | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '3 000,00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 400,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '410,88'   | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 070,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '354,38'   | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 400,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 070,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 030,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '176,34'   | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 030,00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 500,00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '428,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 500,00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 270,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '217,42'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 230,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '210,58'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 270,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 230,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '3 000,00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '513,60'   | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '100,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '17,12'    | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '3 000,00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '100,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 070,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '183,18'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 600,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '273,92'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 070,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '1 600,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '500,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '85,60'    | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '500,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 251,00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '400,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '400,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 000,00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '342,40'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 000,00' | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '2 251,00' | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '400,00'   | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | '400,00'   | 'No'                   | ''                                                     |
	And I close all client application windows
		

Scenario: _1002004 check PI movements when unpost document and post it back (closing by advance)
	* Check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | ''                     | ''                                                     |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | ''                     | ''                                                     |
			| 'Register  "R1021 Vendors transactions"'         | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | ''                     | ''                                                     |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | 'Attributes'           | ''                                                     |
			| ''                                               | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                          | 'Order'                                        | 'Project' | 'Deferred calculation' | 'Vendors advances closing'                             |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '354,38'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '410,88'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '354,38'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '410,88'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |		
		And I close all client application windows
	* Unpost PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'    |
			| 'Document registrations records'                    |
		And I close all client application windows
	* Post PI back and check it movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | ''                     | ''                                                     |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | ''                     | ''                                                     |
			| 'Register  "R1021 Vendors transactions"'         | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | ''                     | ''                                                     |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                               | ''                                             | ''        | 'Attributes'           | ''                                                     |
			| ''                                               | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                          | 'Order'                                        | 'Project' | 'Deferred calculation' | 'Vendors advances closing'                             |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '354,38'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '410,88'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '354,38'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '410,88'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |		
		And I close all client application windows

Scenario: _1002008 check PI closing by advance (Ap-Ar by partner term, payment first)
	* Repost Vendors advance closing
		Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"	
		And in the table "List" I click the button named "ListContextMenuPost"		
		And Delay 5
		Then user message window does not contain messages
		And I close all client application windows
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
		And "List" table contains lines
			| 'Period'                | 'Branch'         | 'Recorder'                                         | 'Currency'   | 'Company'        | 'Partner'   | 'Amount'    | 'Multi currency movement type'   | 'Legal name'   | 'Agreement'                     | 'Basis'   | 'Order'   | 'Deferred calculation'   | 'Vendors advances closing'                                |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'TRY'        | 'Main Company'   | 'DFC'       | '100,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'TRY'        | 'Main Company'   | 'DFC'       | '100,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'USD'        | 'Main Company'   | 'DFC'       | '17,12'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'TRY'        | 'Main Company'   | 'DFC'       | '100,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'TRY'        | 'Main Company'   | 'DFC'       | '-100,00'   | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'TRY'        | 'Main Company'   | 'DFC'       | '-100,00'   | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'USD'        | 'Main Company'   | 'DFC'       | '-17,12'    | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '12.02.2021 15:00:00'   | 'Front office'   | 'Cash payment 21 dated 12.02.2021 15:00:00'        | 'TRY'        | 'Main Company'   | 'DFC'       | '-100,00'   | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '170,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '170,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'USD'        | 'Main Company'   | 'DFC'       | '29,10'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '170,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '100,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '100,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'USD'        | 'Main Company'   | 'DFC'       | '17,12'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '12.02.2021 15:40:00'   | 'Front office'   | 'Purchase invoice 120 dated 12.02.2021 15:40:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '100,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 1 dated 12.02.2021 22:00:00'    |
			| '15.03.2021 12:00:01'   | 'Front office'   | 'Purchase invoice 122 dated 15.03.2021 12:00:01'   | 'TRY'        | 'Main Company'   | 'DFC'       | '110,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '15.03.2021 12:00:01'   | 'Front office'   | 'Purchase invoice 122 dated 15.03.2021 12:00:01'   | 'TRY'        | 'Main Company'   | 'DFC'       | '110,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '15.03.2021 12:00:01'   | 'Front office'   | 'Purchase invoice 122 dated 15.03.2021 12:00:01'   | 'USD'        | 'Main Company'   | 'DFC'       | '18,83'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '15.03.2021 12:00:01'   | 'Front office'   | 'Purchase invoice 122 dated 15.03.2021 12:00:01'   | 'TRY'        | 'Main Company'   | 'DFC'       | '110,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '15.03.2021 19:00:00'   | 'Front office'   | 'Purchase invoice 123 dated 15.03.2021 19:00:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '190,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '15.03.2021 19:00:00'   | 'Front office'   | 'Purchase invoice 123 dated 15.03.2021 19:00:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '190,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '15.03.2021 19:00:00'   | 'Front office'   | 'Purchase invoice 123 dated 15.03.2021 19:00:00'   | 'USD'        | 'Main Company'   | 'DFC'       | '32,53'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '15.03.2021 19:00:00'   | 'Front office'   | 'Purchase invoice 123 dated 15.03.2021 19:00:00'   | 'TRY'        | 'Main Company'   | 'DFC'       | '190,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '28.04.2021 16:38:07'   | 'Front office'   | 'Bank payment 12 dated 28.04.2021 16:38:07'        | 'TRY'        | 'Main Company'   | 'DFC'       | '280,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:38:07'   | 'Front office'   | 'Bank payment 12 dated 28.04.2021 16:38:07'        | 'USD'        | 'Main Company'   | 'DFC'       | '47,94'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:38:07'   | 'Front office'   | 'Bank payment 12 dated 28.04.2021 16:38:07'        | 'TRY'        | 'Main Company'   | 'DFC'       | '280,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:38:07'   | 'Front office'   | 'Bank payment 12 dated 28.04.2021 16:38:07'        | 'TRY'        | 'Main Company'   | 'DFC'       | '280,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:12'   | 'Front office'   | 'Bank payment 15 dated 28.04.2021 16:40:12'        | 'TRY'        | 'Main Company'   | 'DFC'       | '90,00'     | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:12'   | 'Front office'   | 'Bank payment 15 dated 28.04.2021 16:40:12'        | 'USD'        | 'Main Company'   | 'DFC'       | '15,41'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:12'   | 'Front office'   | 'Bank payment 15 dated 28.04.2021 16:40:12'        | 'TRY'        | 'Main Company'   | 'DFC'       | '90,00'     | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:12'   | 'Front office'   | 'Bank payment 15 dated 28.04.2021 16:40:12'        | 'TRY'        | 'Main Company'   | 'DFC'       | '90,00'     | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'TRY'        | 'Main Company'   | 'DFC'       | '200,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'TRY'        | 'Main Company'   | 'DFC'       | '200,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'USD'        | 'Main Company'   | 'DFC'       | '34,24'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'TRY'        | 'Main Company'   | 'DFC'       | '200,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                                                        |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'TRY'        | 'Main Company'   | 'DFC'       | '200,00'    | 'TRY'                            | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'TRY'        | 'Main Company'   | 'DFC'       | '200,00'    | 'Local currency'                 | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'USD'        | 'Main Company'   | 'DFC'       | '34,24'     | 'Reporting currency'             | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
			| '28.04.2021 16:40:13'   | 'Front office'   | 'Purchase invoice 124 dated 28.04.2021 16:40:13'   | 'TRY'        | 'Main Company'   | 'DFC'       | '200,00'    | 'en description is empty'        | 'DFC'          | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
		And "List" table contains lines
			| 'Period'              | 'Branch'       | 'Recorder'                                       | 'Currency' | 'Company'      | 'Partner' | 'Amount'  | 'Multi currency movement type' | 'Legal name' | 'Order' | 'Deferred calculation' | 'Vendors advances closing'                             |
			| '12.02.2021 15:00:00' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'DFC'     | '-100,00' | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:00:00' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'USD'      | 'Main Company' | 'DFC'     | '-17,12'  | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:00:00' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'DFC'     | '-100,00' | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:00:00' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'USD'      | 'Main Company' | 'DFC'     | '-17,12'  | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:00:00' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'DFC'     | '-100,00' | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:00:00' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'USD'      | 'Main Company' | 'DFC'     | '-17,12'  | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:00:00' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'DFC'     | '-100,00' | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:40:00' | 'Front office' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | 'TRY'      | 'Main Company' | 'DFC'     | '100,00'  | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:40:00' | 'Front office' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | 'USD'      | 'Main Company' | 'DFC'     | '17,12'   | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '12.02.2021 15:40:00' | 'Front office' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | 'TRY'      | 'Main Company' | 'DFC'     | '100,00'  | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'   | 'Local currency'               | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'USD'      | 'Main Company' | 'DFC'     | '13,70'   | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'DFC'     | '200,00'  | 'Local currency'               | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'USD'      | 'Main Company' | 'DFC'     | '34,24'   | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'   | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'DFC'     | '200,00'  | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'DFC'     | '280,00'  | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'USD'      | 'Main Company' | 'DFC'     | '47,94'   | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:38:07' | 'Front office' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'DFC'     | '280,00'  | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'DFC'     | '300,00'  | 'Local currency'               | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'DFC'     | '51,36'   | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'DFC'     | '300,00'  | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | ''                                                     |
			| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'DFC'     | '90,00'   | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'DFC'     | '15,41'   | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'DFC'     | '90,00'   | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:40:13' | 'Front office' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | 'TRY'      | 'Main Company' | 'DFC'     | '200,00'  | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:40:13' | 'Front office' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | 'USD'      | 'Main Company' | 'DFC'     | '34,24'   | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 16:40:13' | 'Front office' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | 'TRY'      | 'Main Company' | 'DFC'     | '200,00'  | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 21:50:00' | 'Front office' | 'Debit note 21 dated 28.04.2021 21:50:00'        | 'TRY'      | 'Main Company' | 'DFC'     | '-90,00'  | 'Local currency'               | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 21:50:00' | 'Front office' | 'Debit note 21 dated 28.04.2021 21:50:00'        | 'USD'      | 'Main Company' | 'DFC'     | '-15,41'  | 'Reporting currency'           | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '28.04.2021 21:50:00' | 'Front office' | 'Debit note 21 dated 28.04.2021 21:50:00'        | 'TRY'      | 'Main Company' | 'DFC'     | '-90,00'  | 'en description is empty'      | 'DFC'        | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		And I close all client application windows

	
Scenario: _1002012 check PI closing by advance (Ap-Ar by documents, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines	
		| 'Period'              | 'Branch'       | 'Recorder'                                       | 'Currency' | 'Company'      | 'Partner' | 'Amount'  | 'Multi currency movement type' | 'Legal name'    | 'Agreement'          | 'Basis'                                          | 'Order' | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 12:00:00' | ''             | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | ''             | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | ''             | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | ''             | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Front office' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Front office' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Front office' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'USD'      | 'Main Company' | 'Maxim'   | '32,53'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Front office' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Maxim'   | '15,41'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'USD'      | 'Main Company' | 'Maxim'   | '-17,12'  | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'USD'      | 'Main Company' | 'Maxim'   | '-17,12'  | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	And "List" table contains lines
		| 'Period'              | 'Branch'       | 'Recorder'                                       | 'Currency' | 'Company'      | 'Partner' | 'Amount'  | 'Multi currency movement type' | 'Legal name'    | 'Order' | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '200,00'  | 'Local currency'               | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Maxim'   | '34,24'   | 'Reporting currency'           | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'Local currency'               | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Maxim'   | '15,41'   | 'Reporting currency'           | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '200,00'  | 'en description is empty'      | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'en description is empty'      | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'Local currency'               | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Maxim'   | '15,41'   | 'Reporting currency'           | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'en description is empty'      | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Front office' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Front office' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'Local currency'               | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'USD'      | 'Main Company' | 'Maxim'   | '-17,12'  | 'Reporting currency'           | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Front office' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'en description is empty'      | 'Company Maxim' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '30.04.2021 12:00:00' | 'Front office' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'TRY'      | 'Main Company' | 'Maxim'   | '56,28'   | 'Local currency'               | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Front office' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'USD'      | 'Main Company' | 'Maxim'   | '10,00'   | 'Reporting currency'           | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Front office' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'USD'      | 'Main Company' | 'Maxim'   | '10,00'   | 'en description is empty'      | 'Company Maxim' | ''      | 'No'                   | ''                                                     |
	And I close all client application windows
	
	
Scenario: _1002014 check PI closing by advance (Ap-Ar by partner term, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines	
		| 'Period'               | 'Recorder'                                        | 'Currency'  | 'Company'       | 'Branch'        | 'Partner'  | 'Amount'     | 'Multi currency movement type'  | 'Legal name'    | 'Agreement'    | 'Basis'  | 'Deferred calculation'  | 'Vendors advances closing'                               |
		| '12.02.2021 10:21:24'  | 'Purchase return 11 dated 12.02.2021 10:21:24'    | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '-190,00'    | 'USD'                           | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 10:21:24'  | 'Purchase return 11 dated 12.02.2021 10:21:24'    | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '-1 069,23'  | 'Local currency'                | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 10:21:24'  | 'Purchase return 11 dated 12.02.2021 10:21:24'    | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '-190,00'    | 'Reporting currency'            | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 10:21:24'  | 'Purchase return 11 dated 12.02.2021 10:21:24'    | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '-190,00'    | 'en description is empty'       | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 14:00:00'  | 'Credit note 11 dated 12.02.2021 14:00:00'        | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '170,00'     | 'USD'                           | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 14:00:00'  | 'Credit note 11 dated 12.02.2021 14:00:00'        | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '956,68'     | 'Local currency'                | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 14:00:00'  | 'Credit note 11 dated 12.02.2021 14:00:00'        | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '170,00'     | 'Reporting currency'            | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 14:00:00'  | 'Credit note 11 dated 12.02.2021 14:00:00'        | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '170,00'     | 'en description is empty'       | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 15:40:00'  | 'Purchase invoice 121 dated 12.02.2021 15:40:00'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '170,00'     | 'USD'                           | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 15:40:00'  | 'Purchase invoice 121 dated 12.02.2021 15:40:00'  | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '956,68'     | 'Local currency'                | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 15:40:00'  | 'Purchase invoice 121 dated 12.02.2021 15:40:00'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '170,00'     | 'Reporting currency'            | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '12.02.2021 15:40:00'  | 'Purchase invoice 121 dated 12.02.2021 15:40:00'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '170,00'     | 'en description is empty'       | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | ''                                                       |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'       | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '844,13'     | 'Local currency'                | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'   |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'       | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '150,00'     | 'Reporting currency'            | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'   |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'       | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '150,00'     | 'USD'                           | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'   |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'       | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '150,00'     | 'en description is empty'       | 'Company Adel'  | 'Vendor, USD'  | ''       | 'No'                    | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'   |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	And "List" table contains lines
		| 'Period'               | 'Recorder'                                   | 'Currency'  | 'Company'       | 'Branch'        | 'Partner'  | 'Amount'    | 'Multi currency movement type'  | 'Legal name'    | 'Deferred calculation'  | 'Vendors advances closing'                               |
		| '28.04.2021 16:38:07'  | 'Bank payment 12 dated 28.04.2021 16:38:07'  | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '200,00'    | 'Local currency'                | 'Company Adel'  | 'No'                    | ''                                                       |
		| '28.04.2021 16:38:07'  | 'Bank payment 12 dated 28.04.2021 16:38:07'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '34,24'     | 'Reporting currency'            | 'Company Adel'  | 'No'                    | ''                                                       |
		| '28.04.2021 16:38:07'  | 'Bank payment 12 dated 28.04.2021 16:38:07'  | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '200,00'    | 'en description is empty'       | 'Company Adel'  | 'No'                    | ''                                                       |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'  | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '1 125,50'  | 'Local currency'                | 'Company Adel'  | 'No'                    | ''                                                       |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '200,00'    | 'Reporting currency'            | 'Company Adel'  | 'No'                    | ''                                                       |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '200,00'    | 'en description is empty'       | 'Company Adel'  | 'No'                    | ''                                                       |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'  | 'TRY'       | 'Main Company'  | 'Front office'  | 'Adel'     | '844,13'    | 'Local currency'                | 'Company Adel'  | 'No'                    | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'   |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '150,00'    | 'Reporting currency'            | 'Company Adel'  | 'No'                    | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'   |
		| '28.04.2021 16:38:55'  | 'Bank payment 13 dated 28.04.2021 16:38:55'  | 'USD'       | 'Main Company'  | 'Front office'  | 'Adel'     | '150,00'    | 'en description is empty'       | 'Company Adel'  | 'No'                    | 'Vendors advances closing 4 dated 28.04.2021 22:00:00'   |
	And I close all client application windows


	

Scenario: _1002052 check VendorsAdvancesClosing movements when unpost document and post it back
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
	And I go to line in "List" table
		| 'Number'   |
		| '4'        |
	* Unpost
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
		And "List" table does not contain lines
			| 'Vendors advances closing'                                |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
		And "List" table does not contain lines
			| 'Vendors advances closing'                                |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
		And I close current window
	* Post VendorsAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
		And "List" table contains lines
			| 'Vendors advances closing'                                |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
		And "List" table contains lines
			| 'Vendors advances closing'                                |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00'    |
		And I close all client application windows
		

Scenario: _1002062 generate Offset of advance report based on VendorsAdvancesClosing
	And I close all client application windows
	* Select VendorsAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Generate report
		And I click "Offset of advances" button
		Then "R5012 Offset of advances" window is opened
		And I click "Run" button
	* Check
		And "Doc" spreadsheet document contains "OffsetOfAdvanceVendor" template lines by template
		And I close all client application windows
		
				
Scenario: _1002064 check advance closing when PI has two same strings
	And I close all client application windows
	* Preparation
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(194).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(17).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.VendorsAdvancesClosing.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Check advance closing
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '7'        |
		And I click "Offset of advances" button
	* Check
		And "Doc" spreadsheet document contains "OffsetOfAdvanceVendorMaxim" template lines by template
	And I close all client application windows				
		
							
// Scenario: _1002070 check payment status for PI
// 	And I close all client application windows
// 	* Open PI list form
// 		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
// 	* Add payment status to the PI list form
// 		And I click "Change form..." button
// 		And I go to line in "" table
// 			| 'Column1'        |
// 			| 'Payment status' | 
// 		And Delay 2
// 		And I activate current test client window
// 		And I select current line in "" table
// 		And Delay 2
// 		And I press keyboard shortcut "SPACE"
// 		And I click "Apply" button
// 		And I click "OK" button
// 	* Check
// 		And "List" table contains lines
// 			| 'Number' | 'Date'                | 'Partner'   | 'Amount'   | 'Legal name'        | 'Status'   | 'Store'    | 'Payment status' |
// 			| '191'    | '27.01.2021 19:50:43' | 'Ferron BP' | ''         | 'Company Ferron BP' | 'Closed'   | 'Store 02' | 'Not tracked'    |
// 			| '125'    | '12.02.2021 12:00:00' | 'Maxim'     | '100,00'   | 'Company Maxim'     | 'Closed'   | 'Store 01' | 'Not paid'       |
// 			| '117'    | '12.02.2021 15:12:15' | 'Ferron BP' | '4 470,00' | 'Company Ferron BP' | 'Shipping' | 'Store 02' | 'Fully paid'     |
// 			| '116'    | '12.02.2021 15:13:37' | 'Ferron BP' | '2 300,00' | 'Company Ferron BP' | 'Closed'   | 'Store 02' | 'Fully paid'     |
// 			| '115'    | '12.02.2021 15:13:56' | 'Ferron BP' | '2 300,00' | 'Company Ferron BP' | 'Closed'   | 'Store 02' | 'Fully paid'     |
// 			| '120'    | '12.02.2021 15:40:00' | 'DFC'       | '170,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'    |
// 			| '121'    | '12.02.2021 15:40:00' | 'Adel'      | '170,00'   | 'Company Adel'      | 'Closed'   | 'Store 02' | 'Not tracked'    |
// 			| '118'    | '12.02.2021 16:08:41' | 'Ferron BP' | '2 070,00' | 'Company Ferron BP' | 'Shipping' | 'Store 02' | 'Fully paid'     |
// 			| '119'    | '12.02.2021 16:21:23' | 'Ferron BP' | '1 600,00' | 'Company Ferron BP' | 'Closed'   | 'Store 02' | 'Fully paid'     |
// 			| '126'    | '15.03.2021 12:00:00' | 'Maxim'     | '190,00'   | 'Company Maxim'     | 'Closed'   | 'Store 01' | 'Fully paid'     |
// 			| '122'    | '15.03.2021 12:00:01' | 'DFC'       | '110,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'    |
// 			| '123'    | '15.03.2021 19:00:00' | 'DFC'       | '190,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'    |
// 			| '124'    | '28.04.2021 16:40:13' | 'DFC'       | '200,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'    |
// 			| '127'    | '28.04.2021 21:50:01' | 'Maxim'     | '100,00'   | 'Company Maxim'     | 'Closed'   | 'Store 01' | 'Fully paid'     |
// 			| '194'    | '04.09.2023 13:50:38' | 'Maxim'     | '1 800,00' | 'Company Aldis'     | 'Closed'   | 'Store 01' | 'Fully paid'     |
// 	And I close all client application windows