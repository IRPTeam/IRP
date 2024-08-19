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
		When Create catalog ReportOptions objects (R5020_PartnersBalance)
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
		| 'Period'              | 'Recorder'                                       | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                          | 'Order'                                        | 'Project' | 'Amount'    | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | '170,00'    | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | '29,10'     | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | '170,00'    | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | '170,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | '29,10'     | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | '170,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | '2 070,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | '354,38'    | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | '2 400,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | '410,88'    | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | '2 070,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | '2 400,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | '2 400,00'  | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | '410,88'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | '2 070,00'  | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | '354,38'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | '2 400,00'  | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | '2 070,00'  | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '2 300,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '393,76'    | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '2 300,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '860,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '147,23'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '860,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '2 300,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '393,76'    | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '2 300,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | ''        | '2 070,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | ''        | '354,38'    | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | ''        | '2 070,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | ''        | '1 600,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | ''        | '273,92'    | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | ''        | '1 600,00'  | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | ''        | '2 070,00'  | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | ''        | '354,38'    | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | ''        | '2 070,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '1 440,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '246,53'    | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '1 060,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '181,47'    | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | '1 440,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '1 060,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '1 240,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '212,29'    | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | ''        | '1 600,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | ''        | '273,92'    | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | '1 240,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:01' | 'Cash payment 23 dated 28.04.2021 00:00:01'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | ''        | '1 600,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '2 251,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '400,00'    | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '400,00'    | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '-2 251,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '-400,00'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '-400,00'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '2 251,00'  | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '400,00'    | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                               | ''                                             | ''        | '400,00'    | 'No'                   | ''                                                     |
	
			
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"	
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'          | 'Project' | 'Amount'    | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 251,00'  | 'No'                   | ''                                                     |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '400,00'    | 'No'                   | ''                                                     |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 251,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 000,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '342,40'    | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 000,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '170,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '29,10'     | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '170,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '500,00'    | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '85,60'     | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '500,00'    | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '3 000,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '513,60'    | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '3 000,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '4 470,00'  | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '765,26'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '4 470,00'  | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '860,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '147,23'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '860,00'    | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 500,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '428,00'    | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 500,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 500,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '428,00'    | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 500,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '500,00'    | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '85,60'     | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '500,00'    | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, USD' | ''        | '-2 251,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, USD' | ''        | '-400,00'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, USD' | ''        | '-400,00'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 000,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '342,40'    | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 000,00'  | 'No'                   | ''                                                     |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "Local currency"               | "TRY"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "3 000,00"  | "No"                   | ""                                                     |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "Reporting currency"           | "USD"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "513,60"    | "No"                   | ""                                                     |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "Local currency"               | "TRY"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "100,00"    | "No"                   | ""                                                     |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "Reporting currency"           | "USD"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "17,12"     | "No"                   | ""                                                     |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "en description is empty"      | "TRY"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "3 000,00"  | "No"                   | ""                                                     |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "en description is empty"      | "TRY"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "100,00"    | "No"                   | ""                                                     |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "Local currency"               | "TRY"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "2 840,00"  | "No"                   | "Vendors advances closing 4 dated 28.04.2021 22:00:00" |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "Reporting currency"           | "USD"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "486,21"    | "No"                   | "Vendors advances closing 4 dated 28.04.2021 22:00:00" |
		| "28.04.2021 00:00:01" | "Cash payment 23 dated 28.04.2021 00:00:01"      | "Main Company" | "Front office" | "en description is empty"      | "TRY"      | "TRY"                  | "Company Ferron BP" | "Ferron BP" | ""      | "Vendor Ferron, TRY" | ""        | "2 840,00"  | "No"                   | "Vendors advances closing 4 dated 28.04.2021 22:00:00" |
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
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '354,38'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '410,88'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
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
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | ''                                                     |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '354,38'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '410,88'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 070'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 400'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |			
		And I close all client application windows


Scenario: _1002012 check PI closing by advance (Ap-Ar by documents, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines	
		| 'Period'              | 'Recorder'                                       | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'    | 'Partner' | 'Agreement'          | 'Basis'                                          | 'Order' | 'Project' | 'Amount'  | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 12:00:00' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'Main Company' | ''             | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''      | ''        | '100,00'  | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'Main Company' | ''             | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''      | ''        | '17,12'   | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'Main Company' | ''             | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''      | ''        | '100,00'  | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | ''        | '190,00'  | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | ''        | '32,53'   | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | ''        | '190,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | ''        | '190,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | ''        | '32,53'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''      | ''        | '190,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | ''        | '100,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | ''        | '17,12'   | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | ''        | '100,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | ''        | '100,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | ''        | '17,12'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''      | ''        | '100,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | ''        | '-100,00' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | ''        | '-17,12'  | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | ''        | '-100,00' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | ''        | '-100,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | ''        | '-17,12'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''      | ''        | '-100,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'    | 'Partner' | 'Order' | 'Agreement'          | 'Project' | 'Amount'  | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '200,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '34,24'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '90,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '15,41'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '200,00'  | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '90,00'   | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '190,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '32,53'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '190,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '100,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '17,12'   | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '100,00'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '-100,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '-17,12'  | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '-100,00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '56,28'   | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '10,00'   | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Partner term Maxim' | ''        | '56,28'   | 'No'                   | ''                                                     |
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
		

Scenario: _1002062 check VendorsAdvancesClosing movements
	And I close all client application windows
	* Select VendorsAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	// * Generate report
	// 	And I click "Offset of advances" button
	// 	Then "R5012 Offset of advances" window is opened
	// 	And I click "Run" button
	* Check VendorsAdvancesClosing movements
		* T2010S Offset of advances
			And I click "Registrations report info" button
			And I select "T2010S Offset of advances" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| 'Vendors advances closing 1 dated 12.02.2021 22:00:00' | ''                    | ''             | ''             | ''                                               | ''            | ''                   | ''         | ''          | ''                  | ''                            | ''                                               | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | ''                                     | ''       |
				| 'Register  "T2010S Offset of advances"'                | ''                    | ''             | ''             | ''                                               | ''            | ''                   | ''         | ''          | ''                  | ''                            | ''                                               | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | ''                                     | ''       |
				| ''                                                     | 'Period'              | 'Company'      | 'Branch'       | 'Document'                                       | 'Record type' | 'Is advance release' | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                   | 'Transaction document'                           | 'DELETE transaction agreement' | 'DELETE advance agreement' | 'Advance order' | 'Transaction order'                            | 'DELETE from advance key' | 'DELETE to transaction key' | 'DELETE from transaction key' | 'DELETE to advance key' | 'Advance project' | 'Transaction project' | 'Key'                                  | 'Amount' |
				| ''                                                     | '12.02.2021 10:21:24' | 'Main Company' | 'Front office' | 'Purchase return 11 dated 12.02.2021 10:21:24'   | 'Expense'     | 'No'                 | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''                                               | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | '                                    ' | '-190'   |
				| ''                                                     | '12.02.2021 14:00:00' | 'Main Company' | 'Front office' | 'Credit note 11 dated 12.02.2021 14:00:00'       | 'Expense'     | 'No'                 | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | 'b1ee5efe-6362-425c-b912-15faedf5b630' | '170'    |
				| ''                                                     | '12.02.2021 15:00:00' | 'Main Company' | 'Front office' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'Expense'     | 'No'                 | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''                                               | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | 'a67ade78-8752-4a7c-8b2e-1fb5879968ce' | '-100'   |
				| ''                                                     | '12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Expense'     | 'No'                 | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | '                                    ' | '2 400'  |
				| ''                                                     | '12.02.2021 15:12:15' | 'Main Company' | 'Front office' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Expense'     | 'No'                 | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                             | ''                         | ''              | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | '                                    ' | '2 070'  |
				| ''                                                     | '12.02.2021 15:13:37' | 'Main Company' | 'Front office' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Expense'     | 'No'                 | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | ''                             | ''                         | ''              | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | '                                    ' | '860'    |
				| ''                                                     | '12.02.2021 15:40:00' | 'Main Company' | 'Front office' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | 'Expense'     | 'No'                 | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''                                               | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | '                                    ' | '100'    |
				| ''                                                     | '12.02.2021 15:40:00' | 'Main Company' | 'Front office' | 'Purchase invoice 121 dated 12.02.2021 15:40:00' | 'Expense'     | 'No'                 | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''                                               | ''                             | ''                         | ''              | ''                                             | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | '                                    ' | '170'    |
		* T2013S Offset of aging
			And I select "T2013S Offset of aging" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| 'Vendors advances closing 1 dated 12.02.2021 22:00:00' | ''                    | ''             | ''             | ''                                         | ''            | ''         | ''          | ''                   | ''                                         | ''                    | ''       |
				| 'Register  "T2013S Offset of aging"'                   | ''                    | ''             | ''             | ''                                         | ''            | ''         | ''          | ''                   | ''                                         | ''                    | ''       |
				| ''                                                     | 'Period'              | 'Company'      | 'Branch'       | 'Document'                                 | 'Record type' | 'Currency' | 'Partner'   | 'Agreement'          | 'Invoice'                                  | 'Payment date'        | 'Amount' |
				| ''                                                     | '12.02.2021 14:00:00' | 'Main Company' | 'Front office' | 'Credit note 11 dated 12.02.2021 14:00:00' | 'Expense'     | 'TRY'      | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Credit note 11 dated 12.02.2021 14:00:00' | '12.02.2021 00:00:00' | '170'    |
		* TM1020 Advances key
			And I select "TM1020 Advances key" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| 'Vendors advances closing 1 dated 12.02.2021 22:00:00' | ''                    | ''           | ''                   | ''             | ''             | ''         | ''          | ''                  | ''                            | ''      | ''        | ''                  | ''                    | ''       |
				| 'Register  "TM1020 Advances key"'                      | ''                    | ''           | ''                   | ''             | ''             | ''         | ''          | ''                  | ''                            | ''      | ''        | ''                  | ''                    | ''       |
				| ''                                                     | 'Period'              | 'RecordType' | 'DELETE advance key' | 'Company'      | 'Branch'       | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                   | 'Order' | 'Project' | 'Is vendor advance' | 'Is customer advance' | 'Amount' |
				| ''                                                     | '12.02.2021 10:21:24' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''      | ''        | 'Yes'               | 'No'                  | '-190'   |
				| ''                                                     | '12.02.2021 11:24:13' | 'Receipt'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | ''      | ''        | 'Yes'               | 'No'                  | '2 000'  |
				| ''                                                     | '12.02.2021 14:00:00' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | ''      | ''        | 'Yes'               | 'No'                  | '170'    |
				| ''                                                     | '12.02.2021 14:38:39' | 'Receipt'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | ''      | ''        | 'Yes'               | 'No'                  | '500'    |
				| ''                                                     | '12.02.2021 15:00:00' | 'Receipt'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | ''      | ''        | 'Yes'               | 'No'                  | '3 000'  |
				| ''                                                     | '12.02.2021 15:00:00' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''      | ''        | 'Yes'               | 'No'                  | '-100'   |
				| ''                                                     | '12.02.2021 15:12:15' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | ''      | ''        | 'Yes'               | 'No'                  | '2 070'  |
				| ''                                                     | '12.02.2021 15:12:15' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | ''      | ''        | 'Yes'               | 'No'                  | '2 400'  |
				| ''                                                     | '12.02.2021 15:13:37' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | ''      | ''        | 'Yes'               | 'No'                  | '860'    |
				| ''                                                     | '12.02.2021 15:40:00' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''      | ''        | 'Yes'               | 'No'                  | '100'    |
				| ''                                                     | '12.02.2021 15:40:00' | 'Expense'    | ''                   | 'Main Company' | 'Front office' | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''      | ''        | 'Yes'               | 'No'                  | '170'    |			
		* TM1030 Transactions key
			And I select "TM1030 Transactions key" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| 'Vendors advances closing 1 dated 12.02.2021 22:00:00' | ''                    | ''           | ''                       | ''             | ''             | ''         | ''          | ''                  | ''                            | ''                                               | ''                                             | ''        | ''                      | ''                        | ''       |
				| 'Register  "TM1030 Transactions key"'                  | ''                    | ''           | ''                       | ''             | ''             | ''         | ''          | ''                  | ''                            | ''                                               | ''                                             | ''        | ''                      | ''                        | ''       |
				| ''                                                     | 'Period'              | 'RecordType' | 'DELETE transaction key' | 'Company'      | 'Branch'       | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                   | 'Transaction basis'                              | 'Order'                                        | 'Project' | 'Is vendor transaction' | 'Is customer transaction' | 'Amount' |
				| ''                                                     | '12.02.2021 10:21:24' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '-190'   |
				| ''                                                     | '12.02.2021 10:21:24' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '-190'   |
				| ''                                                     | '12.02.2021 14:00:00' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | 'Yes'                   | 'No'                      | '170'    |
				| ''                                                     | '12.02.2021 14:00:00' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Credit note 11 dated 12.02.2021 14:00:00'       | ''                                             | ''        | 'Yes'                   | 'No'                      | '170'    |
				| ''                                                     | '12.02.2021 15:00:00' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '-100'   |
				| ''                                                     | '12.02.2021 15:00:00' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '100'    |
				| ''                                                     | '12.02.2021 15:12:15' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'Yes'                   | 'No'                      | '2 400'  |
				| ''                                                     | '12.02.2021 15:12:15' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'Yes'                   | 'No'                      | '2 070'  |
				| ''                                                     | '12.02.2021 15:12:15' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                                             | ''        | 'Yes'                   | 'No'                      | '2 400'  |
				| ''                                                     | '12.02.2021 15:12:15' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'Purchase order 117 dated 12.02.2021 12:45:05' | ''        | 'Yes'                   | 'No'                      | '2 070'  |
				| ''                                                     | '12.02.2021 15:13:37' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | 'Yes'                   | 'No'                      | '2 300'  |
				| ''                                                     | '12.02.2021 15:13:37' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'Purchase order 116 dated 12.02.2021 12:44:59' | ''        | 'Yes'                   | 'No'                      | '860'    |
				| ''                                                     | '12.02.2021 15:13:56' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Purchase order 115 dated 12.02.2021 12:44:43' | ''        | 'Yes'                   | 'No'                      | '2 300'  |
				| ''                                                     | '12.02.2021 15:40:00' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '170'    |
				| ''                                                     | '12.02.2021 15:40:00' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '170'    |
				| ''                                                     | '12.02.2021 15:40:00' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'DFC'       | 'DFC'               | 'DFC Vendor by Partner terms' | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '100'    |
				| ''                                                     | '12.02.2021 15:40:00' | 'Expense'    | ''                       | 'Main Company' | 'Front office' | 'USD'      | 'Adel'      | 'Company Adel'      | 'Vendor, USD'                 | ''                                               | ''                                             | ''        | 'Yes'                   | 'No'                      | '170'    |
				| ''                                                     | '12.02.2021 16:08:41' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | ''                                             | ''        | 'Yes'                   | 'No'                      | '2 070'  |
				| ''                                                     | '12.02.2021 16:21:23' | 'Receipt'    | ''                       | 'Main Company' | 'Front office' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY'          | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | ''                                             | ''        | 'Yes'                   | 'No'                      | '1 600'  |			
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
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "04.09.2023" text in the field named "DateBegin"
		And I input "05.09.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I remove checkbox "Multi currency movement type"	
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Maxim" string		
		And I click "Generate" button
	* Check	
		And "Result" spreadsheet document contains lines:
			| 'Company'                                        | ''                                              | ''         | ''                             | 'Amount'   | ''         | ''          | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'       | ''         | ''        | 'VT'       | ''         | ''          | 'Other'   | ''        | ''        |
			| 'Partner'                                        | 'Legal name'                                    | ''         | ''                             | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt'  | 'Expense'  | 'Closing' | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                       | 'Agreement'                                     | 'Currency' | 'Multi currency movement type' | ''         | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | ''         | ''          | ''        | ''        | ''        |
			| 'Main Company'                                   | ''                                              | ''         | ''                             | '3 908,16' | '3 908,16' | ''          | ''        | ''        | ''        | ''        | ''        | ''        | '3 908,16' | '3 908,16' | ''        | '3 908,16' | '3 908,16' | ''          | ''        | ''        | ''        |
			| 'Maxim'                                          | 'Company Aldis'                                 | ''         | ''                             | '3 908,16' | '3 908,16' | ''          | ''        | ''        | ''        | ''        | ''        | ''        | '3 908,16' | '3 908,16' | ''        | '3 908,16' | '3 908,16' | ''          | ''        | ''        | ''        |
			| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Partner term Maxim'                            | 'TRY'      | 'Local currency'               | ''         | '1 800,00' | '-1 800,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | '1 800,00' | '-1 800,00' | ''        | ''        | ''        |
			| 'Bank payment 17 dated 04.09.2023 13:50:54'      | 'Partner term Maxim'                            | 'TRY'      | 'Local currency'               | '1 800,00' | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | '1 800,00' | '1 800,00' | ''        | '1 800,00' | ''         | ''          | ''        | ''        | ''        |
			| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Partner term Maxim'                            | 'TRY'      | 'en description is empty'      | ''         | '1 800,00' | '-1 800,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | '1 800,00' | '-1 800,00' | ''        | ''        | ''        |
			| 'Bank payment 17 dated 04.09.2023 13:50:54'      | 'Partner term Maxim'                            | 'TRY'      | 'en description is empty'      | '1 800,00' | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | '1 800,00' | '1 800,00' | ''        | '1 800,00' | ''         | ''          | ''        | ''        | ''        |
			| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Partner term Maxim'                            | 'USD'      | 'Reporting currency'           | ''         | '308,16'   | '-308,16'   | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | '308,16'   | '-308,16'   | ''        | ''        | ''        |
			| 'Bank payment 17 dated 04.09.2023 13:50:54'      | 'Partner term Maxim'                            | 'USD'      | 'Reporting currency'           | '308,16'   | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | '308,16'   | '308,16'   | ''        | '308,16'   | ''         | ''          | ''        | ''        | ''        |
			| 'Total'                                          | ''                                              | ''         | ''                             | '3 908,16' | '3 908,16' | ''          | ''        | ''        | ''        | ''        | ''        | ''        | '3 908,16' | '3 908,16' | ''        | '3 908,16' | '3 908,16' | ''          | ''        | ''        | ''        |	
	And I close all client application windows				
		
							
Scenario: _1002070 check payment status for PI
	And I close all client application windows
	* Open PI list form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check
		And "List" table contains lines
			| 'Number' | 'Date'                | 'Partner'   | 'Amount'   | 'Legal name'        | 'Status'   | 'Store'    | 'PaymentStatusUnit' |
			| '125'    | '12.02.2021 12:00:00' | 'Maxim'     | '100,00'   | 'Company Maxim'     | 'Closed'   | 'Store 01' | 'Not paid'          |
			| '117'    | '12.02.2021 15:12:15' | 'Ferron BP' | '4 470,00' | 'Company Ferron BP' | 'Shipping' | 'Store 02' | 'Fully paid'        |
			| '116'    | '12.02.2021 15:13:37' | 'Ferron BP' | '2 300,00' | 'Company Ferron BP' | 'Closed'   | 'Store 02' | 'Fully paid'        |
			| '115'    | '12.02.2021 15:13:56' | 'Ferron BP' | '2 300,00' | 'Company Ferron BP' | 'Closed'   | 'Store 02' | 'Fully paid'        |
			| '120'    | '12.02.2021 15:40:00' | 'DFC'       | '170,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'       |
			| '121'    | '12.02.2021 15:40:00' | 'Adel'      | '170,00'   | 'Company Adel'      | 'Closed'   | 'Store 02' | 'Not tracked'       |
			| '118'    | '12.02.2021 16:08:41' | 'Ferron BP' | '2 070,00' | 'Company Ferron BP' | 'Shipping' | 'Store 02' | 'Fully paid'        |
			| '119'    | '12.02.2021 16:21:23' | 'Ferron BP' | '1 600,00' | 'Company Ferron BP' | 'Closed'   | 'Store 02' | 'Fully paid'        |
			| '126'    | '15.03.2021 12:00:00' | 'Maxim'     | '190,00'   | 'Company Maxim'     | 'Closed'   | 'Store 01' | 'Fully paid'        |
			| '122'    | '15.03.2021 12:00:01' | 'DFC'       | '110,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'       |
			| '123'    | '15.03.2021 19:00:00' | 'DFC'       | '190,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'       |
			| '124'    | '28.04.2021 16:40:13' | 'DFC'       | '200,00'   | 'DFC'               | 'Awaiting' | 'Store 02' | 'Not tracked'       |
			| '127'    | '28.04.2021 21:50:01' | 'Maxim'     | '100,00'   | 'Company Maxim'     | 'Closed'   | 'Store 01' | 'Fully paid'        |
			| '194'    | '04.09.2023 13:50:38' | 'Maxim'     | '1 800,00' | 'Company Aldis'     | 'Closed'   | 'Store 01' | 'Fully paid'        |
	And I close all client application windows