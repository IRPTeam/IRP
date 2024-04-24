#language: en
@tree
@Positive
@Movements
@MovementsPurchaseReturn

Functionality: check Purchase return movements

Variables:
import "Variables.feature"

Scenario: _041600 preparation (Purchase return)
	When set True value to the constant
	When set True value to the constant Use commission trading
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Taxes records (VAT)
		When settings for Main Company (commission trade)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create catalog CancelReturnReasons objects
	When Create catalog CashAccounts objects
	When Create catalog LegalNameContracts objects
	When Create catalog SerialLotNumbers objects
	When Create catalog LegalNameContracts objects
	* Load Bank payment
	When Create document BankPayment objects (check movements, advance)
	And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load PO
	When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
	When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
	When Create document InternalSupplyRequest objects (check movements)
	And I execute 1C:Enterprise script at server
			| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
	When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load GR
	When Create document GoodsReceipt objects (check movements)
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server	
			| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
			// | "Documents.GoodsReceipt.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load PI
	When Create document PurchaseInvoice objects (check movements)
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
	When Create document PurchaseReturnOrder objects (check movements)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseReturnOrder.FindByNumber(231).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document ShipmentConfirmation objects (check movements, SC-PR)
	And I execute 1C:Enterprise script at server
		| "Documents.ShipmentConfirmation.FindByNumber(233).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document PurchaseReturn objects (check movements)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseReturn.FindByNumber(231).GetObject().Write(DocumentWriteMode.Write);"     |
		| "Documents.PurchaseReturn.FindByNumber(231).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server	
		| "Documents.PurchaseReturn.FindByNumber(232).GetObject().Write(DocumentWriteMode.Write);"     |
		| "Documents.PurchaseReturn.FindByNumber(232).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseReturn.FindByNumber(233).GetObject().Write(DocumentWriteMode.Write);"     |
		| "Documents.PurchaseReturn.FindByNumber(233).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document PurchaseReturn objects (advance)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseReturn.FindByNumber(11).GetObject().Write(DocumentWriteMode.Write);"     |
		| "Documents.PurchaseReturn.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I close all client application windows
	* Load PI and PR comission trade 
	When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
	And I execute 1C:Enterprise script at server	
		| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server	
		| "Documents.PurchaseReturn.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I close all client application windows

Scenario: _0416001 check preparation
	When check preparation

Scenario: _041601 check Purchase return movements by the Register  "R1002 Purchase returns"
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1002 Purchase returns" 
		And I click "Registrations report" button
		And I select "R1002 Purchase returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                | ''                        |
			| 'Document registrations records'                  | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                | ''                        |
			| 'Register  "R1002 Purchase returns"'              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                | ''                        |
			| ''                                                | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                | 'Attributes'              |
			| ''                                                | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                                          | 'Item key'    | 'Row key'                                | 'Return reason'   | 'Deferred calculation'    |
			| ''                                                | '14.03.2021 18:53:34'   | '1'           | '30,82'    | '26,11'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '1'           | '180'      | '152,54'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '1'           | '180'      | '152,54'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '1'           | '180'      | '152,54'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '2'           | '46,22'    | '39,17'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '2'           | '270'      | '228,81'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '2'           | '270'      | '228,81'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '2'           | '270'      | '228,81'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | ''                | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '5'           | '77,04'    | '65,29'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'not available'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '5'           | '450'      | '381,36'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'not available'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '5'           | '450'      | '381,36'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'not available'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '5'           | '450'      | '381,36'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'not available'   | 'No'                      |
	And I close all client application windows


Scenario: _041603 check Purchase return movements by the Register  "R1005 Special offers of purchases" (with special offer)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1005 Special offers of purchases" 
		And I click "Registrations report" button
		And I select "R1005 Special offers of purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''                      | ''                | ''               | ''               | ''                               | ''           | ''                                                | ''            | ''                                       | ''                   | ''                        |
			| 'Document registrations records'                  | ''                      | ''                | ''               | ''               | ''                               | ''           | ''                                                | ''            | ''                                       | ''                   | ''                        |
			| 'Register  "R1005 Special offers of purchases"'   | ''                      | ''                | ''               | ''               | ''                               | ''           | ''                                                | ''            | ''                                       | ''                   | ''                        |
			| ''                                                | 'Period'                | 'Resources'       | 'Dimensions'     | ''               | ''                               | ''           | ''                                                | ''            | ''                                       | ''                   | 'Attributes'              |
			| ''                                                | ''                      | 'Offers amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                                         | 'Item key'    | 'Row key'                                | 'Special offer'      | 'Deferred calculation'    |
			| ''                                                | '14.03.2021 18:53:34'   | '3,42'            | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '5,14'            | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '8,56'            | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '20'              | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '20'              | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '20'              | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '30'              | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '30'              | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '30'              | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '50'              | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '50'              | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '50'              | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'DocumentDiscount'   | 'No'                      |
	And I close all client application windows


Scenario: _041604 check Purchase return movements by the Register  "R1005 Special offers of purchases" (without special offer)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '233'       |
	* Check movements by the Register  "R1005 Special offers of purchases" 
		And I click "Registrations report" button
		And I select "R1005 Special offers of purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1005 Special offers of purchases"'    |
	And I close all client application windows


Scenario: _041605 check Purchase return movements by the Register  "R5010 Reconciliation statement"
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| 'Register  "R5010 Reconciliation statement"'      | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                    | ''                          |
			| ''                                                | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'          | 'Legal name contract'       |
			| ''                                                | 'Expense'       | '14.03.2021 18:53:34'   | '-900'        | 'Main Company'   | 'Front office'   | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP New'    |
	And I close all client application windows


Scenario: _041606 check Purchase return movements by the Register  "R4050 Stock inventory"
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R4050 Stock inventory" 
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''              | ''                      | ''            | ''               | ''           | ''             |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''           | ''             |
			| 'Register  "R4050 Stock inventory"'               | ''              | ''                      | ''            | ''               | ''           | ''             |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''             |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'     |
			| ''                                                | 'Expense'       | '14.03.2021 18:53:34'   | '1'           | 'Main Company'   | 'Store 02'   | '36/Yellow'    |
			| ''                                                | 'Expense'       | '14.03.2021 18:53:34'   | '5'           | 'Main Company'   | 'Store 02'   | 'S/Yellow'     |
	And I close all client application windows

Scenario: _041607 check Purchase return movements by the Register  "R1040 Taxes outgoing"
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1040 Taxes outgoing" 
		And I click "Registrations report" button
		And I select "R1040 Taxes outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''              | ''                      | ''                 | ''             | ''               | ''               | ''      | ''           | ''                     |
			| 'Document registrations records'                  | ''              | ''                      | ''                 | ''             | ''               | ''               | ''      | ''           | ''                     |
			| 'Register  "R1040 Taxes outgoing"'                | ''              | ''                      | ''                 | ''             | ''               | ''               | ''      | ''           | ''                     |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'        | ''             | 'Dimensions'     | ''               | ''      | ''           | ''                     |
			| ''                                                | ''              | ''                      | 'Taxable amount'   | 'Tax amount'   | 'Company'        | 'Branch'         | 'Tax'   | 'Tax rate'   | 'Tax movement type'    |
			| ''                                                | 'Receipt'       | '14.03.2021 18:53:34'   | '152,54'           | '27,46'        | 'Main Company'   | 'Front office'   | 'VAT'   | '18%'        | ''                     |
			| ''                                                | 'Receipt'       | '14.03.2021 18:53:34'   | '228,81'           | '41,19'        | 'Main Company'   | 'Front office'   | 'VAT'   | '18%'        | ''                     |
			| ''                                                | 'Receipt'       | '14.03.2021 18:53:34'   | '381,36'           | '68,64'        | 'Main Company'   | 'Front office'   | 'VAT'   | '18%'        | ''                     |
	And I close all client application windows

Scenario: _041608 check Purchase return movements by the Register  "R1012 Invoice closing of purchase orders" (with PRO)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders" 
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'          | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                                      | ''           | ''            | ''                                        |
			| 'Document registrations records'                         | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                                      | ''           | ''            | ''                                        |
			| 'Register  "R1012 Invoice closing of purchase orders"'   | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                                      | ''           | ''            | ''                                        |
			| ''                                                       | 'Record type'   | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''               | ''                                                      | ''           | ''            | ''                                        |
			| ''                                                       | ''              | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'         | 'Order'                                                 | 'Currency'   | 'Item key'    | 'Row key'                                 |
			| ''                                                       | 'Expense'       | '14.03.2021 18:53:34'   | '1'           | '180'      | '152,54'       | 'Main Company'   | 'Front office'   | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'TRY'        | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'    |
			| ''                                                       | 'Expense'       | '14.03.2021 18:53:34'   | '2'           | '270'      | '228,81'       | 'Main Company'   | 'Front office'   | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'TRY'        | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'    |
			| ''                                                       | 'Expense'       | '14.03.2021 18:53:34'   | '5'           | '450'      | '381,36'       | 'Main Company'   | 'Front office'   | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'TRY'        | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'    |
	And I close all client application windows

Scenario: _041609 check Purchase return movements by the Register  "R1012 Invoice closing of purchase orders" (without PRO)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '233'       |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders" 
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1012 Invoice closing of purchase orders"'    |
	And I close all client application windows

Scenario: _041610 check Purchase return movements by the Register  "R4014 Serial lot numbers"
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '232'       |
	* Check movements by the Register  "R4014 Serial lot numbers" 
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 232 dated 14.03.2021 19:21:16'   | ''              | ''                      | ''            | ''               | ''               | ''        | ''           | ''                     |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''        | ''           | ''                     |
			| 'Register  "R4014 Serial lot numbers"'            | ''              | ''                      | ''            | ''               | ''               | ''        | ''           | ''                     |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''        | ''           | ''                     |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'   | 'Item key'   | 'Serial lot number'    |
			| ''                                                | 'Expense'       | '14.03.2021 19:21:16'   | '10'          | 'Main Company'   | 'Front office'   | ''        | 'S/Yellow'   | '0512'                 |
	And I close all client application windows

Scenario: _041611 check Purchase return movements by the Register  "R4010 Actual stocks" (not use SC, PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'                 | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                                | 'Expense'       | '14.03.2021 18:53:34'   | '1'           | 'Store 02'     | '36/Yellow'   | ''                     |
	And I close all client application windows

Scenario: _041612 check Purchase return movements by the Register  "R4010 Actual stocks" (SC - PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '233'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'    |
	And I close all client application windows

Scenario: _041613 check Purchase return movements by the Register  "R4011 Free stocks" (not use SC, PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                   | ''              | ''                      | ''            | ''             | ''             |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                                | 'Expense'       | '14.03.2021 18:53:34'   | '1'           | 'Store 02'     | '36/Yellow'    |
	And I close all client application windows

Scenario: _041614 check Purchase return movements by the Register  "R4011 Free stocks" (SC - PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '233'       |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'    |
	And I close all client application windows

Scenario: _041615 check Purchase return with serial lot numbers movements by the Register  "R4010 Actual stocks" (not use SC, PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '232'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 232 dated 14.03.2021 19:21:16'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                 | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                | 'Expense'       | '14.03.2021 19:21:16'   | '10'          | 'Store 02'     | 'S/Yellow'   | '0512'                 |
			| ''                                                | 'Expense'       | '14.03.2021 19:21:16'   | '12'          | 'Store 02'     | '37/18SD'    | ''                     |
		And I close all client application windows
		
			

Scenario: _041619 check Purchase return movements by the Register  "R4032 Goods in transit (outgoing) (use SC, PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)" 
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''              | ''                      | ''            | ''             | ''                                                | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                                | ''            |
			| 'Register  "R4032 Goods in transit (outgoing)"'   | ''              | ''                      | ''            | ''             | ''                                                | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                                | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                           | 'Item key'    |
			| ''                                                | 'Receipt'       | '14.03.2021 18:53:34'   | '5'           | 'Store 02'     | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'S/Yellow'    |
	And I close all client application windows

Scenario: _041615 check Purchase return movements by the Register  "R4032 Goods in transit (outgoing)" (SC - PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '233'       |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)" 
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 233 dated 14.03.2021 19:26:51'   | ''              | ''                      | ''            | ''             | ''                                                      | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''                                                      | ''            |
			| 'Register  "R4032 Goods in transit (outgoing)"'   | ''              | ''                      | ''            | ''             | ''                                                      | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                                      | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                                 | 'Item key'    |
			| ''                                                | 'Receipt'       | '14.03.2021 19:26:51'   | '4'           | 'Store 02'     | 'Shipment confirmation 233 dated 14.03.2021 19:22:58'   | 'S/Yellow'    |
	And I close all client application windows

Scenario: _041616 check Purchase return movements by the Register  "R1031 Receipt invoicing" (SC - PR)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '233'       |
	* Check movements by the Register  "R1031 Receipt invoicing" 
		And I click "Registrations report" button
		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 233 dated 14.03.2021 19:26:51'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                      | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                      | ''            |
			| 'Register  "R1031 Receipt invoicing"'             | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                      | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                                      | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Basis'                                                 | 'Item key'    |
			| ''                                                | 'Expense'       | '14.03.2021 19:26:51'   | '4'           | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Shipment confirmation 233 dated 14.03.2021 19:22:58'   | 'S/Yellow'    |
	And I close all client application windows


Scenario: _041617 check Purchase return movements by the Register  "R1031 Receipt invoicing" (PR-SC)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1031 Receipt invoicing" 
		And I click "Registrations report" button
		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                | ''            |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                | ''            |
			| 'Register  "R1031 Receipt invoicing"'             | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                | ''            |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                                | ''            |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Basis'                                           | 'Item key'    |
			| ''                                                | 'Receipt'       | '14.03.2021 18:53:34'   | '5'           | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Purchase return 231 dated 14.03.2021 18:53:34'   | 'S/Yellow'    |
	And I close all client application windows

Scenario: _041618 check Purchase return movements by the Register  "R5022 Expenses"
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34' | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| 'Document registrations records'                | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| 'Register  "R5022 Expenses"'                    | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| ''                                              | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | 'Attributes'                |
			| ''                                              | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project'    | 'Calculation movement cost' |
			| ''                                              | '14.03.2021 18:53:34' | '-228,81'   | '-270'              | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | 'Internet' | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | 'Project 01' | ''                          |
			| ''                                              | '14.03.2021 18:53:34' | '-228,81'   | '-270'              | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | 'Internet' | ''            | ''            | 'TRY'      | ''                    | 'TRY'                          | 'Project 01' | ''                          |
			| ''                                              | '14.03.2021 18:53:34' | '-228,81'   | '-270'              | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | 'Internet' | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | 'Project 01' | ''                          |
			| ''                                              | '14.03.2021 18:53:34' | '-39,17'    | '-46,22'            | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | 'Internet' | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | 'Project 01' | ''                          |
	And I close all client application windows

Scenario: _041620 check Purchase return movements by the Register  "R1001 Purchases"
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1001 Purchases" 
		And I click "Registrations report" button
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'   | ''                      | ''            | ''         | ''             | ''                | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                        |
			| 'Document registrations records'                  | ''                      | ''            | ''         | ''             | ''                | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                        |
			| 'Register  "R1001 Purchases"'                     | ''                      | ''            | ''         | ''             | ''                | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                        |
			| ''                                                | 'Period'                | 'Resources'   | ''         | ''             | ''                | 'Dimensions'     | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | 'Attributes'              |
			| ''                                                | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                                          | 'Item key'    | 'Row key'                                | 'Deferred calculation'    |
			| ''                                                | '14.03.2021 18:53:34'   | '-5'          | '-450'     | '-381,36'      | '-50'             | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-5'          | '-450'     | '-381,36'      | '-50'             | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-5'          | '-450'     | '-381,36'      | '-50'             | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-5'          | '-77,04'   | '-65,29'       | '-8,56'           | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-2'          | '-270'     | '-228,81'      | '-30'             | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-2'          | '-270'     | '-228,81'      | '-30'             | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-2'          | '-270'     | '-228,81'      | '-30'             | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-2'          | '-46,22'   | '-39,17'       | '-5,14'           | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-1'          | '-180'     | '-152,54'      | '-20'             | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-1'          | '-180'     | '-152,54'      | '-20'             | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-1'          | '-180'     | '-152,54'      | '-20'             | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
			| ''                                                | '14.03.2021 18:53:34'   | '-1'          | '-30,82'   | '-26,11'       | '-3,42'           | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
	And I close all client application windows

Scenario: _041621 check Purchase return movements by the Register  "R1001 Purchases" (without PI)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R1001 Purchases" 
		And I click "Registrations report" button
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 11 dated 12.02.2021 10:21:24'   | ''                      | ''            | ''            | ''             | ''                | ''               | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | ''                        |
			| 'Document registrations records'                 | ''                      | ''            | ''            | ''             | ''                | ''               | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | ''                        |
			| 'Register  "R1001 Purchases"'                    | ''                      | ''            | ''            | ''             | ''                | ''               | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | ''                        |
			| ''                                               | 'Period'                | 'Resources'   | ''            | ''             | ''                | 'Dimensions'     | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | 'Attributes'              |
			| ''                                               | ''                      | 'Quantity'    | 'Amount'      | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                                        | 'Item key'    | 'Row key'                                | 'Deferred calculation'    |
			| ''                                               | '12.02.2021 10:21:24'   | '-1'          | '-1 069,23'   | '-1 069,23'    | ''                | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '36/Yellow'   | 'febad533-cba1-43bc-afb1-80b0a6bdef77'   | 'No'                      |
			| ''                                               | '12.02.2021 10:21:24'   | '-1'          | '-190'        | '-190'         | ''                | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '36/Yellow'   | 'febad533-cba1-43bc-afb1-80b0a6bdef77'   | 'No'                      |
			| ''                                               | '12.02.2021 10:21:24'   | '-1'          | '-190'        | '-190'         | ''                | 'Main Company'   | 'Front office'   | 'USD'                            | 'USD'        | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '36/Yellow'   | 'febad533-cba1-43bc-afb1-80b0a6bdef77'   | 'No'                      |
			| ''                                               | '12.02.2021 10:21:24'   | '-1'          | '-190'        | '-190'         | ''                | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'USD'        | 'Purchase return 11 dated 12.02.2021 10:21:24'   | '36/Yellow'   | 'febad533-cba1-43bc-afb1-80b0a6bdef77'   | 'No'                      |
	And I close all client application windows

Scenario: _041622 check Purchase return movements by the Register  "R4014 Serial lot numbers" (Return to consignor)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R4014 Serial lot numbers" 
		And I click "Registrations report info" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 195 dated 02.11.2022 16:31:47' | ''                    | ''           | ''             | ''                        | ''      | ''         | ''                  | ''         |
			| 'Register  "R4014 Serial lot numbers"'          | ''                    | ''           | ''             | ''                        | ''      | ''         | ''                  | ''         |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Store' | 'Item key' | 'Serial lot number' | 'Quantity' |
			| ''                                              | '02.11.2022 16:31:47' | 'Expense'    | 'Main Company' | 'Distribution department' | ''      | 'ODS'      | '1123'              | '1'        |	
	And I close all client application windows

Scenario: _041623 check Purchase return movements by the Register  "T2015 Transactions info" (Return to vendor)
	And I close all client application windows 
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '233'       |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 233 dated 14.03.2021 19:26:51' | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                              | ''                                     | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'           | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                              | ''                                     | ''        | ''       | ''       | ''        |
			| ''                                              | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                             | 'Unique ID'                            | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                              | 'Main Company' | 'Front office' | ''      | '14.03.2021 19:26:51' | '                                    ' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Yes'                   | 'No'                      | 'Purchase return 233 dated 14.03.2021 19:26:51' | '*'                                    | ''        | '-400'   | 'Yes'    | 'No'      |		
	And I close all client application windows

Scenario: _041624 check absence Purchase return movements by the Register  "T2015 Transactions info" (Return to consignor)
	* Select PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows


Scenario: _041625 check there is no Purchase return movements by the Register  "R1001 Purchases" (Return to consignor)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1001 Purchases" 
		And I click "Registrations report" button
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1001 Purchases"'    |
	And I close all client application windows

Scenario: _041626 check there is no Purchase return movements by the Register  "R1002 Purchase returns" (Return to consignor)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1002 Purchase returns" 
		And I click "Registrations report" button
		And I select "R1002 Purchase returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1002 Purchase returns"'    |
	And I close all client application windows

Scenario: _041627 check there is no Purchase return movements by the Register  "R1021 Vendors transactions" (Return to consignor)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1021 Vendors transactions"'    |
	And I close all client application windows

Scenario: _041628 check there is no Purchase return movements by the Register  "R1040 Taxes outgoing" (Return to consignor)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1040 Taxes outgoing" 
		And I click "Registrations report" button
		And I select "R1040 Taxes outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1040 Taxes outgoing"'    |
	And I close all client application windows

Scenario: _041630 Purchase return clear posting/mark for deletion
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'    |
			| 'Document registrations records'                   |
		And I close current window
	* Post Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1002 Purchase returns'                      |
			| 'R1021 Vendors transactions'                  |
			| 'R1005 Special offers of purchases'           |
			| 'R5010 Reconciliation statement'              |
			| 'R4010 Actual stocks'                         |
			| 'R4050 Stock inventory'                       |
			| 'R4011 Free stocks'                           |
			| 'R4032 Goods in transit (outgoing)'           |
			| 'R1040 Taxes outgoing'                        |
			| 'R1012 Invoice closing of purchase orders'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 231 dated 14.03.2021 18:53:34'    |
			| 'Document registrations records'                   |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1002 Purchase returns'                      |
			| 'R1021 Vendors transactions'                  |
			| 'R1005 Special offers of purchases'           |
			| 'R5010 Reconciliation statement'              |
			| 'R4010 Actual stocks'                         |
			| 'R4050 Stock inventory'                       |
			| 'R4011 Free stocks'                           |
			| 'R4032 Goods in transit (outgoing)'           |
			| 'R1040 Taxes outgoing'                        |
			| 'R1012 Invoice closing of purchase orders'    |
		And I close all client application windows
