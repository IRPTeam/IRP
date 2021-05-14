#language: en
@tree
@Positive
@AgingAndCreditLimit

Feature: vendors advances closing



Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _1002000 preparation (vendors advances closing)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Load documents
		When Create document BankPayment objects (check movements, advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankPayment.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"  |
			| "Documents.BankPayment.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.BankPayment.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.BankPayment.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankPayment.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankPayment.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);" |
		* Load PO
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |	
				| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	
		* Load GR
		When Create document GoodsReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |	
				| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
				// | "Documents.GoodsReceipt.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.GoodsReceipt.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.GoodsReceipt.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);" |
		* Load PI
		When Create document PurchaseInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseInvoice.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document CashPayment objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.CashPayment.FindByNumber(22).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashPayment.FindByNumber(23).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.CashPayment.FindByNumber(24).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document PurchaseInvoice objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(121).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(122).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseInvoice.FindByNumber(123).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(124).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(125).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(126).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(127).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(120).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document PurchaseReturn objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseReturn.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseReturn.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document DebitNote objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents. DebitNote.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document CreditNote objects (vendor, advance)
		And I execute 1C:Enterprise script at server
			| "Documents. CreditNote.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document VendorsAdvancesClosing objects
		And I execute 1C:Enterprise script at server
			| "Documents.VendorsAdvancesClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.VendorsAdvancesClosing.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows			

Scenario: _1002002 create VendorsAdvancesClosing
	Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
	And I click the button named "FormCreate"
	And I input "11.02.2021 12:00:00" text in "Date" field
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I click Select button of "Begin of period" field
	And I input "11.02.2021" text in "Begin of period" field
	And I input "11.02.2021" text in "End of period" field
	And I delete "$$NumberVendorsAdvancesClosing11022021$$" variable
	And I delete "$VendorsAdvancesClosing11022021$$" variable
	And I delete "$$DateVendorsAdvancesClosing11022021$$" variable
	And I save the value of "Number" field as "$$NumberVendorsAdvancesClosing11022021$$"
	And I save the window as "$$VendorsAdvancesClosing11022021$$"
	And I save the value of the field named "Date" as "$$DateVendorsAdvancesClosing11022021$$"
	And I click "Post and close" button
	And I click the button named "FormCreate"
	And I input "15.03.2021 12:00:00" text in "Date" field
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I click Select button of "Begin of period" field
	And I input "15.03.2021" text in "Begin of period" field
	And I input "15.03.2021" text in "End of period" field
	And I delete "$$NumberVendorsAdvancesClosing15032021$$" variable
	And I delete "$VendorsAdvancesClosing15032021$$" variable
	And I delete "$$DateVendorsAdvancesClosing15032021$$" variable
	And I save the value of "Number" field as "$$NumberVendorsAdvancesClosing15032021$$"
	And I save the window as "$$VendorsAdvancesClosing15032021$$"
	And I save the value of the field named "Date" as "$$DateVendorsAdvancesClosing15032021$$"
	And I click "Post and close" button
	* Check creation
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And "List" table contains lines
			| 'Number'                                   | 'Date'                | 'Company'      | 'Begin of period' | 'End of period' |
			| '$$NumberVendorsAdvancesClosing11022021$$' | '11.02.2021 12:00:00' | 'Main Company' | '11.02.2021'      | '11.02.2021'    |
			| '$$NumberVendorsAdvancesClosing15032021$$' | '15.03.2021 12:00:00' | 'Main Company' | '15.03.2021'      | '15.03.2021'    |
		And I close all client application windows
		
	

Scenario: _1002003 check PI closing by advance (Ap-Ar by documents, payment first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Currency' | 'Company'      | 'Partner'   | 'Amount'   | 'Multi currency movement type' | 'Legal name'        | 'Agreement'          | 'Basis'                                          | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 470,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 470,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'USD'      | 'Main Company' | 'Ferron BP' | '765,26'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 470,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'USD'      | 'Main Company' | 'Ferron BP' | '342,40'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'USD'      | 'Main Company' | 'Ferron BP' | '85,60'    | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 970,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 970,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'USD'      | 'Main Company' | 'Ferron BP' | '337,26'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 970,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 300,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 300,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'USD'      | 'Main Company' | 'Ferron BP' | '393,76'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 300,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 030,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 030,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'USD'      | 'Main Company' | 'Ferron BP' | '176,34'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 030,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 300,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 300,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'USD'      | 'Main Company' | 'Ferron BP' | '393,76'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'No'                   | ''                                                     |
		| '12.02.2021 15:13:56' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 300,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 070,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 070,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'USD'      | 'Main Company' | 'Ferron BP' | '354,38'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
		| '12.02.2021 16:08:41' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 070,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 600,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 600,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'USD'      | 'Main Company' | 'Ferron BP' | '273,92'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'No'                   | ''                                                     |
		| '12.02.2021 16:21:23' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 600,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 119 dated 12.02.2021 16:21:23' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 070,00' | 'TRY'                          | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 070,00' | 'Local currency'               | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'USD'      | 'Main Company' | 'Ferron BP' | '354,38'   | 'Reporting currency'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Cash payment 24 dated 15.03.2021 12:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 070,00' | 'en description is empty'      | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 118 dated 12.02.2021 16:08:41' | 'No'                   | ''                                                     |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Currency' | 'Company'      | 'Partner'   | 'Amount'   | 'Multi currency movement type' | 'Legal name'        | 'Basis'                                     | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 251,00' | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 3 dated 11.02.2021 16:38:19'  | 'No'                   | ''                                                     |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'USD'      | 'Main Company' | 'Ferron BP' | '400,00'   | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 3 dated 11.02.2021 16:38:19'  | 'No'                   | ''                                                     |
		| '11.02.2021 16:38:19' | 'Bank payment 3 dated 11.02.2021 16:38:19'       | 'USD'      | 'Main Company' | 'Ferron BP' | '400,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 3 dated 11.02.2021 16:38:19'  | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 10 dated 12.02.2021 11:24:13' | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'USD'      | 'Main Company' | 'Ferron BP' | '342,40'   | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 10 dated 12.02.2021 11:24:13' | 'No'                   | ''                                                     |
		| '12.02.2021 11:24:13' | 'Bank payment 10 dated 12.02.2021 11:24:13'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 10 dated 12.02.2021 11:24:13' | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 11 dated 12.02.2021 14:38:39' | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'USD'      | 'Main Company' | 'Ferron BP' | '85,60'    | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 11 dated 12.02.2021 14:38:39' | 'No'                   | ''                                                     |
		| '12.02.2021 14:38:39' | 'Bank payment 11 dated 12.02.2021 14:38:39'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 11 dated 12.02.2021 14:38:39' | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '3 000,00' | 'Local currency'               | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'USD'      | 'Main Company' | 'Ferron BP' | '513,60'   | 'Reporting currency'           | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'Kalipso'   | '800,00'   | 'Local currency'               | 'Company Kalipso'   | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'USD'      | 'Main Company' | 'Kalipso'   | '136,96'   | 'Reporting currency'           | 'Company Kalipso'   | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '3 000,00' | 'en description is empty'      | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | 'TRY'      | 'Main Company' | 'Kalipso'   | '800,00'   | 'en description is empty'      | 'Company Kalipso'   | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 10 dated 12.02.2021 11:24:13' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'USD'      | 'Main Company' | 'Ferron BP' | '342,40'   | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 10 dated 12.02.2021 11:24:13' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 11 dated 12.02.2021 14:38:39' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'USD'      | 'Main Company' | 'Ferron BP' | '85,60'    | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 11 dated 12.02.2021 14:38:39' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 970,00' | 'Local currency'               | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'USD'      | 'Main Company' | 'Ferron BP' | '337,26'   | 'Reporting currency'           | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 10 dated 12.02.2021 11:24:13' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 11 dated 12.02.2021 14:38:39' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:12:15' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 970,00' | 'en description is empty'      | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 030,00' | 'Local currency'               | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'USD'      | 'Main Company' | 'Ferron BP' | '176,34'   | 'Reporting currency'           | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '12.02.2021 15:13:37' | 'Purchase invoice 116 dated 12.02.2021 15:13:37' | 'TRY'      | 'Main Company' | 'Ferron BP' | '1 030,00' | 'en description is empty'      | 'Company Ferron BP' | 'Cash payment 21 dated 12.02.2021 15:00:00' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 500,00' | 'Local currency'               | 'Company Ferron BP' | 'Cash payment 22 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'USD'      | 'Main Company' | 'Ferron BP' | '428,00'   | 'Reporting currency'           | 'Company Ferron BP' | 'Cash payment 22 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 22 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 500,00' | 'en description is empty'      | 'Company Ferron BP' | 'Cash payment 22 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '3 000,00' | 'Local currency'               | 'Company Ferron BP' | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'USD'      | 'Main Company' | 'Ferron BP' | '513,60'   | 'Reporting currency'           | 'Company Ferron BP' | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Kalipso'   | '800,00'   | 'Local currency'               | 'Company Kalipso'   | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'USD'      | 'Main Company' | 'Kalipso'   | '136,96'   | 'Reporting currency'           | 'Company Kalipso'   | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '100,00'   | 'Local currency'               | 'Company Ferron BP' | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'USD'      | 'Main Company' | 'Ferron BP' | '17,12'    | 'Reporting currency'           | 'Company Ferron BP' | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '3 000,00' | 'en description is empty'      | 'Company Ferron BP' | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Kalipso'   | '800,00'   | 'en description is empty'      | 'Company Kalipso'   | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 00:00:00' | 'Cash payment 23 dated 28.04.2021 00:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '100,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Cash payment 23 dated 28.04.2021 00:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'USD'      | 'Main Company' | 'Ferron BP' | '85,60'    | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '500,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 251,00' | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'USD'      | 'Main Company' | 'Ferron BP' | '400,00'   | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | 'USD'      | 'Main Company' | 'Ferron BP' | '400,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Ferron BP' | '342,40'   | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Kalipso'   | '900,00'   | 'Local currency'               | 'Company Kalipso'   | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'USD'      | 'Main Company' | 'Kalipso'   | '154,08'   | 'Reporting currency'           | 'Company Kalipso'   | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 000,00' | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | 'TRY'      | 'Main Company' | 'Kalipso'   | '900,00'   | 'en description is empty'      | 'Company Kalipso'   | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '2 251,00' | 'Local currency'               | 'Company Ferron BP' | 'Bank payment 14 dated 30.04.2021 12:00:00' | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'USD'      | 'Main Company' | 'Ferron BP' | '400,00'   | 'Reporting currency'           | 'Company Ferron BP' | 'Bank payment 14 dated 30.04.2021 12:00:00' | 'No'                   | ''                                                     |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00'      | 'USD'      | 'Main Company' | 'Ferron BP' | '400,00'   | 'en description is empty'      | 'Company Ferron BP' | 'Bank payment 14 dated 30.04.2021 12:00:00' | 'No'                   | ''                                                     |
	And I close all client application windows
	

Scenario: _1002004 check PI movements when unpost document and post it back (closing by advance)
	* Check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '117'    |
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | ''                     | ''                                                     |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | ''                     | ''                                                     |
			| 'Register  "R1021 Vendors transactions"'         | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | ''                     | ''                                                     |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | 'Attributes'           | ''                                                     |
			| ''                                               | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                          | 'Deferred calculation' | 'Vendors advances closing'                             |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '765,26'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '4 470'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '4 470'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '4 470'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '85,6'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '337,26'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '342,4'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '500'       | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '500'       | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '500'       | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '1 970'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '1 970'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '1 970'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 000'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 000'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 000'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		And I close all client application windows
	* Unpost PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '117'    |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' |
			| 'Document registrations records'                 |
		And I close all client application windows
	* Post PI back and check it movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '117'    |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | ''                     | ''                                                     |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | ''                     | ''                                                     |
			| 'Register  "R1021 Vendors transactions"'         | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | ''                     | ''                                                     |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                   | ''                                               | 'Attributes'           | ''                                                     |
			| ''                                               | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                          | 'Deferred calculation' | 'Vendors advances closing'                             |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '765,26'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '4 470'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '4 470'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Receipt'     | '12.02.2021 15:12:15' | '4 470'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | ''                                                     |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '85,6'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '337,26'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '342,4'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '500'       | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '500'       | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '500'       | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '1 970'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '1 970'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '1 970'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 000'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 000'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '2 000'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'No'                   | 'Vendors advances closing 1 dated 12.02.2021 22:00:00' |
		And I close all client application windows

Scenario: _1002008 check PI closing by advance (Ap-Ar by partner term, payment first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Line number' | 'Currency' | 'Company'      | 'Partner' | 'Amount' | 'Multi currency movement type' | 'Legal name' | 'Agreement'                   | 'Basis' | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '100,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | '2'           | 'TRY'      | 'Main Company' | 'DFC'     | '100,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | '3'           | 'USD'      | 'Main Company' | 'DFC'     | '17,12'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:00:00' | 'Cash payment 21 dated 12.02.2021 15:00:00'      | '4'           | 'TRY'      | 'Main Company' | 'DFC'     | '100,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '170,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | '2'           | 'TRY'      | 'Main Company' | 'DFC'     | '170,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | '3'           | 'USD'      | 'Main Company' | 'DFC'     | '29,10'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 120 dated 12.02.2021 15:40:00' | '4'           | 'TRY'      | 'Main Company' | 'DFC'     | '170,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:01' | 'Purchase invoice 122 dated 15.03.2021 12:00:01' | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '110,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:01' | 'Purchase invoice 122 dated 15.03.2021 12:00:01' | '2'           | 'TRY'      | 'Main Company' | 'DFC'     | '110,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:01' | 'Purchase invoice 122 dated 15.03.2021 12:00:01' | '3'           | 'USD'      | 'Main Company' | 'DFC'     | '18,83'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:01' | 'Purchase invoice 122 dated 15.03.2021 12:00:01' | '4'           | 'TRY'      | 'Main Company' | 'DFC'     | '110,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 19:00:00' | 'Purchase invoice 123 dated 15.03.2021 19:00:00' | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '190,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 19:00:00' | 'Purchase invoice 123 dated 15.03.2021 19:00:00' | '2'           | 'TRY'      | 'Main Company' | 'DFC'     | '190,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 19:00:00' | 'Purchase invoice 123 dated 15.03.2021 19:00:00' | '3'           | 'USD'      | 'Main Company' | 'DFC'     | '32,53'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '15.03.2021 19:00:00' | 'Purchase invoice 123 dated 15.03.2021 19:00:00' | '4'           | 'TRY'      | 'Main Company' | 'DFC'     | '190,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'  | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '2'           | 'USD'      | 'Main Company' | 'DFC'     | '13,70'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '3'           | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'  | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '4'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '5'           | 'USD'      | 'Main Company' | 'DFC'     | '34,24'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '6'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '7'           | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'  | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '8'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '5'           | 'TRY'      | 'Main Company' | 'DFC'     | '90,00'  | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '6'           | 'USD'      | 'Main Company' | 'DFC'     | '15,41'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '7'           | 'TRY'      | 'Main Company' | 'DFC'     | '90,00'  | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '14'          | 'TRY'      | 'Main Company' | 'DFC'     | '90,00'  | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '2'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '3'           | 'USD'      | 'Main Company' | 'DFC'     | '34,24'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '4'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '5'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '6'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '7'           | 'USD'      | 'Main Company' | 'DFC'     | '34,24'  | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '8'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:00' | 'Debit note 21 dated 28.04.2021 21:50:00'        | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '-90,00' | 'TRY'                          | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:00' | 'Debit note 21 dated 28.04.2021 21:50:00'        | '2'           | 'TRY'      | 'Main Company' | 'DFC'     | '-90,00' | 'Local currency'               | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:00' | 'Debit note 21 dated 28.04.2021 21:50:00'        | '3'           | 'USD'      | 'Main Company' | 'DFC'     | '-15,41' | 'Reporting currency'           | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:00' | 'Debit note 21 dated 28.04.2021 21:50:00'        | '4'           | 'TRY'      | 'Main Company' | 'DFC'     | '-90,00' | 'en description is empty'      | 'DFC'        | 'DFC Vendor by Partner terms' | ''      | 'No'                   | ''                                                     |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                       | 'Line number' | 'Currency' | 'Company'      | 'Partner' | 'Amount' | 'Multi currency movement type' | 'Legal name' | 'Basis'                                     | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '3'           | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'  | 'Local currency'               | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '4'           | 'USD'      | 'Main Company' | 'DFC'     | '13,70'  | 'Reporting currency'           | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '7'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'Local currency'               | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '8'           | 'USD'      | 'Main Company' | 'DFC'     | '34,24'  | 'Reporting currency'           | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '10'          | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'  | 'en description is empty'      | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '12'          | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'en description is empty'      | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '13'          | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'  | 'Local currency'               | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '14'          | 'USD'      | 'Main Company' | 'DFC'     | '13,70'  | 'Reporting currency'           | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '15'          | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'Local currency'               | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '16'          | 'USD'      | 'Main Company' | 'DFC'     | '34,24'  | 'Reporting currency'           | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '17'          | 'TRY'      | 'Main Company' | 'DFC'     | '80,00'  | 'en description is empty'      | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07'      | '18'          | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'en description is empty'      | 'DFC'        | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '5'           | 'TRY'      | 'Main Company' | 'DFC'     | '300,00' | 'Local currency'               | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '6'           | 'USD'      | 'Main Company' | 'DFC'     | '51,36'  | 'Reporting currency'           | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '11'          | 'TRY'      | 'Main Company' | 'DFC'     | '300,00' | 'en description is empty'      | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '13'          | 'TRY'      | 'Main Company' | 'DFC'     | '90,00'  | 'Local currency'               | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '14'          | 'USD'      | 'Main Company' | 'DFC'     | '15,41'  | 'Reporting currency'           | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '19'          | 'TRY'      | 'Main Company' | 'DFC'     | '90,00'  | 'en description is empty'      | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '1'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'Local currency'               | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '2'           | 'USD'      | 'Main Company' | 'DFC'     | '34,24'  | 'Reporting currency'           | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:13' | 'Purchase invoice 124 dated 28.04.2021 16:40:13' | '3'           | 'TRY'      | 'Main Company' | 'DFC'     | '200,00' | 'en description is empty'      | 'DFC'        | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
	And I close all client application windows

	
Scenario: _1002012 check PI closing by advance (Ap-Ar by documents, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines	
		| 'Period'              | 'Recorder'                                       | 'Line number' | 'Currency' | 'Company'      | 'Partner' | 'Amount'  | 'Multi currency movement type' | 'Legal name'    | 'Agreement'          | 'Basis'                                          | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 12:00:00' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | '1'           | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | '2'           | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | '3'           | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '12.02.2021 12:00:00' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | '4'           | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | '1'           | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | '2'           | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | '3'           | 'USD'      | 'Main Company' | 'Maxim'   | '32,53'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | ''                                                     |
		| '15.03.2021 12:00:00' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | '4'           | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '1'           | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '2'           | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '3'           | 'USD'      | 'Main Company' | 'Maxim'   | '15,41'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '4'           | 'TRY'      | 'Main Company' | 'Maxim'   | '90,00'   | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '8'           | 'TRY'      | 'Main Company' | 'Maxim'   | '10,00'   | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '9'           | 'TRY'      | 'Main Company' | 'Maxim'   | '10,00'   | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '10'          | 'USD'      | 'Main Company' | 'Maxim'   | '1,71'    | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '11'          | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '12'          | 'USD'      | 'Main Company' | 'Maxim'   | '32,53'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '13'          | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '15'          | 'TRY'      | 'Main Company' | 'Maxim'   | '10,00'   | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12'      | '16'          | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | '1'           | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | '2'           | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | '3'           | 'USD'      | 'Main Company' | 'Maxim'   | '17,12'   | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:01' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | '4'           | 'TRY'      | 'Main Company' | 'Maxim'   | '100,00'  | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | '1'           | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'TRY'                          | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | '2'           | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'Local currency'               | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | '3'           | 'USD'      | 'Main Company' | 'Maxim'   | '-17,12'  | 'Reporting currency'           | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
		| '28.04.2021 21:50:02' | 'Purchase return 21 dated 28.04.2021 21:50:02'   | '4'           | 'TRY'      | 'Main Company' | 'Maxim'   | '-100,00' | 'en description is empty'      | 'Company Maxim' | 'Partner term Maxim' | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'No'                   | ''                                                     |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                  | 'Line number' | 'Currency' | 'Company'      | 'Partner' | 'Amount' | 'Multi currency movement type' | 'Legal name'    | 'Basis'                                     | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12' | '12'          | 'TRY'      | 'Main Company' | 'Maxim'   | '200,00' | 'en description is empty'      | 'Company Maxim' | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | ''                                                     |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12' | '20'          | 'TRY'      | 'Main Company' | 'Maxim'   | '10,00'  | 'en description is empty'      | 'Company Maxim' | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:40:12' | 'Bank payment 15 dated 28.04.2021 16:40:12' | '21'          | 'TRY'      | 'Main Company' | 'Maxim'   | '190,00' | 'en description is empty'      | 'Company Maxim' | 'Bank payment 15 dated 28.04.2021 16:40:12' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '30.04.2021 12:00:00' | 'Bank payment 14 dated 30.04.2021 12:00:00' | '6'           | 'USD'      | 'Main Company' | 'Maxim'   | '10,00'  | 'en description is empty'      | 'Company Maxim' | 'Bank payment 14 dated 30.04.2021 12:00:00' | 'No'                   | ''                                                     |
	And I close all client application windows
	
	
Scenario: _1002014 check PI closing by advance (Ap-Ar by partner term, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	And "List" table contains lines	
		| 'Period'              | 'Recorder'                                       | 'Line number' | 'Currency' | 'Company'      | 'Partner' | 'Amount'    | 'Multi currency movement type' | 'Legal name'   | 'Agreement'   | 'Basis' | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '12.02.2021 10:21:24' | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '1'           | 'USD'      | 'Main Company' | 'Adel'    | '-190,00'   | 'USD'                          | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 10:21:24' | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '2'           | 'TRY'      | 'Main Company' | 'Adel'    | '-1 069,23' | 'Local currency'               | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 10:21:24' | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '3'           | 'USD'      | 'Main Company' | 'Adel'    | '-190,00'   | 'Reporting currency'           | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 10:21:24' | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '4'           | 'USD'      | 'Main Company' | 'Adel'    | '-190,00'   | 'en description is empty'      | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | '1'           | 'USD'      | 'Main Company' | 'Adel'    | '170,00'    | 'USD'                          | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | '2'           | 'TRY'      | 'Main Company' | 'Adel'    | '956,68'    | 'Local currency'               | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | '3'           | 'USD'      | 'Main Company' | 'Adel'    | '170,00'    | 'Reporting currency'           | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 14:00:00' | 'Credit note 11 dated 12.02.2021 14:00:00'       | '4'           | 'USD'      | 'Main Company' | 'Adel'    | '170,00'    | 'en description is empty'      | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 121 dated 12.02.2021 15:40:00' | '1'           | 'USD'      | 'Main Company' | 'Adel'    | '170,00'    | 'USD'                          | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 121 dated 12.02.2021 15:40:00' | '2'           | 'TRY'      | 'Main Company' | 'Adel'    | '956,68'    | 'Local currency'               | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 121 dated 12.02.2021 15:40:00' | '3'           | 'USD'      | 'Main Company' | 'Adel'    | '170,00'    | 'Reporting currency'           | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '12.02.2021 15:40:00' | 'Purchase invoice 121 dated 12.02.2021 15:40:00' | '4'           | 'USD'      | 'Main Company' | 'Adel'    | '170,00'    | 'en description is empty'      | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | '1'           | 'TRY'      | 'Main Company' | 'Adel'    | '844,13'    | 'Local currency'               | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | '2'           | 'USD'      | 'Main Company' | 'Adel'    | '150,00'    | 'Reporting currency'           | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | '3'           | 'USD'      | 'Main Company' | 'Adel'    | '150,00'    | 'USD'                          | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55'      | '4'           | 'USD'      | 'Main Company' | 'Adel'    | '150,00'    | 'en description is empty'      | 'Company Adel' | 'Vendor, USD' | ''      | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                  | 'Line number' | 'Currency' | 'Company'      | 'Partner' | 'Amount'   | 'Multi currency movement type' | 'Legal name'   | 'Basis'                                     | 'Deferred calculation' | 'Vendors advances closing'                             |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07' | '5'           | 'TRY'      | 'Main Company' | 'Adel'    | '200,00'   | 'Local currency'               | 'Company Adel' | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07' | '6'           | 'USD'      | 'Main Company' | 'Adel'    | '34,24'    | 'Reporting currency'           | 'Company Adel' | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:07' | 'Bank payment 12 dated 28.04.2021 16:38:07' | '11'          | 'TRY'      | 'Main Company' | 'Adel'    | '200,00'   | 'en description is empty'      | 'Company Adel' | 'Bank payment 12 dated 28.04.2021 16:38:07' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55' | '3'           | 'TRY'      | 'Main Company' | 'Adel'    | '1 125,50' | 'Local currency'               | 'Company Adel' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55' | '4'           | 'USD'      | 'Main Company' | 'Adel'    | '200,00'   | 'Reporting currency'           | 'Company Adel' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55' | '6'           | 'USD'      | 'Main Company' | 'Adel'    | '200,00'   | 'en description is empty'      | 'Company Adel' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | ''                                                     |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55' | '7'           | 'TRY'      | 'Main Company' | 'Adel'    | '844,13'   | 'Local currency'               | 'Company Adel' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55' | '8'           | 'USD'      | 'Main Company' | 'Adel'    | '150,00'   | 'Reporting currency'           | 'Company Adel' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		| '28.04.2021 16:38:55' | 'Bank payment 13 dated 28.04.2021 16:38:55' | '9'           | 'USD'      | 'Main Company' | 'Adel'    | '150,00'   | 'en description is empty'      | 'Company Adel' | 'Bank payment 13 dated 28.04.2021 16:38:55' | 'No'                   | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
	And I close all client application windows

Scenario: _1002052 check VendorsAdvancesClosing movements when unpost document and post it back
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
	And I go to line in "List" table
		| 'Number' |
		| '4'      |
	* Unpost
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
		And "List" table does not contain lines
			| 'Vendors advances closing'                             |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
		And "List" table does not contain lines
			| 'Vendors advances closing'                             |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		And I close current window
	* Post VendorsAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
		And "List" table contains lines
			| 'Vendors advances closing'                             |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
		And "List" table contains lines
			| 'Vendors advances closing'                             |
			| 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		And I close all client application windows
		
		
				
	


	
		

	
		
	
	
		




