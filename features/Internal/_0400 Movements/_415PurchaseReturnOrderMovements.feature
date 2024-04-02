#language: en
@tree
@Positive
@Movements
@MovementsPurchaseReturnOrder

Functionality: check Purchase return order movements

Variables:
import "Variables.feature"

Scenario: _041500 preparation (Purchase return order)
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
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create catalog CancelReturnReasons objects
	When Create catalog CashAccounts objects
	When Create catalog SerialLotNumbers objects
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
		| "Documents.PurchaseReturnOrder.FindByNumber(231).GetObject().Write(DocumentWriteMode.Write);"     |
		| "Documents.PurchaseReturnOrder.FindByNumber(231).GetObject().Write(DocumentWriteMode.Posting);"   |
	// * Check query for Purchase return order movements
	// 	Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
	// 	And in the table "Info" I click "Fill movements" button
	And I close all client application windows

Scenario: _0415001 check preparation
	When check preparation

Scenario: _041501 check Purchase return order movements by the Register "R1010 Purchase orders"
	* Select Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1010 Purchase orders" 
		And I click "Registrations report" button
		And I select "R1010 Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return order 231 dated 14.03.2021 18:52:33'   | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                                      | ''            | ''                                       | ''                        |
			| 'Document registrations records'                        | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                                      | ''            | ''                                       | ''                        |
			| 'Register  "R1010 Purchase orders"'                     | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                                      | ''            | ''                                       | ''                        |
			| ''                                                      | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''               | ''                               | ''           | ''                                                      | ''            | ''                                       | 'Attributes'              |
			| ''                                                      | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Order'                                                 | 'Item key'    | 'Row key'                                | 'Deferred calculation'    |
			| ''                                                      | '14.03.2021 18:52:33'   | '1'           | '30,82'    | '26,11'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '1'           | '180'      | '152,54'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '1'           | '180'      | '152,54'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '1'           | '180'      | '152,54'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '2'           | '46,22'    | '39,17'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '2'           | '270'      | '228,81'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '2'           | '270'      | '228,81'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '2'           | '270'      | '228,81'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '5'           | '77,04'    | '65,29'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '5'           | '450'      | '381,36'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '5'           | '450'      | '381,36'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
			| ''                                                      | '14.03.2021 18:52:33'   | '5'           | '450'      | '381,36'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase return order 231 dated 14.03.2021 18:52:33'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'No'                      |
	And I close all client application windows

Scenario: _041502 check Purchase return order movements by the Register "R1012 Invoice closing of purchase orders"
	* Select Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders" 
		And I click "Registrations report info" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return order 231 dated 14.03.2021 18:52:33'  | ''                    | ''           | ''             | ''             | ''                                                    | ''         | ''          | ''                                     | ''         | ''       | ''           |
			| 'Register  "R1012 Invoice closing of purchase orders"' | ''                    | ''           | ''             | ''             | ''                                                    | ''         | ''          | ''                                     | ''         | ''       | ''           |
			| ''                                                     | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Order'                                               | 'Currency' | 'Item key'  | 'Row key'                              | 'Quantity' | 'Amount' | 'Net amount' |
			| ''                                                     | '14.03.2021 18:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'Purchase return order 231 dated 14.03.2021 18:52:33' | 'TRY'      | 'S/Yellow'  | '4fcbb4cf-3824-47fb-89b5-50d151315d4d' | '5'        | '450'    | '381,36'     |
			| ''                                                     | '14.03.2021 18:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'Purchase return order 231 dated 14.03.2021 18:52:33' | 'TRY'      | '36/Yellow' | '923e7825-c20f-4a3e-a983-2b85d80e475a' | '1'        | '180'    | '152,54'     |
			| ''                                                     | '14.03.2021 18:52:33' | 'Receipt'    | 'Main Company' | 'Front office' | 'Purchase return order 231 dated 14.03.2021 18:52:33' | 'TRY'      | 'Internet'  | '1b90516b-b3ac-4ca5-bb47-44477975f242' | '2'        | '270'    | '228,81'     |	
	And I close all client application windows


Scenario: _041530 Purchase return order clear posting/mark for deletion
	And I close all client application windows
	* Select Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return order 231 dated 14.03.2021 18:52:33'    |
			| 'Document registrations records'                         |
		And I close current window
	* Post Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '231'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1012 Invoice closing of purchase orders'    |
			| 'R1010 Purchase orders'                       |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
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
			| 'Purchase return order 231 dated 14.03.2021 18:52:33'    |
			| 'Document registrations records'                         |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
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
			| 'R1012 Invoice closing of purchase orders'    |
			| 'R1010 Purchase orders'                       |
		And I close all client application windows
