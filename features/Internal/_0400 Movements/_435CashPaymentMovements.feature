#language: en
@tree
@Positive
@Movements2
@MovementsCashPayment

Feature: check Cash payment movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043500 preparation (Cash payment)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog PlanningPeriods objects
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
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog SalaryCalculationType objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog PlanningPeriods objects
		When Create OtherPartners objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
			When Create catalog LegalNameContracts objects
	* Load documents
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
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
	* Load PO, PI, OPO
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
		When Create document OutgoingPaymentOrder objects (Cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.OutgoingPaymentOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OutgoingPaymentOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Cash payment
		When Create document CashPayment objects (payment to vendor without basis document)
		When Create document CashPayment objects (exchange and transfer)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(331).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
		When Create document CashPayment objects (cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(325).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(326).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashPayment objects (return to customer)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(327).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashPayment objects (with partner term by document, without basis)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(328).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashPayment objects (return retail customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(311).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashPayment objects (salary payment)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(329).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create CashPayment (OtherPartnersTransactions)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(801).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
		
Scenario: _0435001 check preparation
	When check preparation


Scenario: _043501 check Cash payment movements by the Register "R3010 Cash on hand"
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 2 dated 05.04.2021 12:40:18'   | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'             | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                           | 'Expense'       | '05.04.2021 12:40:18'   | '500'         | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'USD'        | 'USD'                    | 'Reporting currency'             | 'No'                      |
			| ''                                           | 'Expense'       | '05.04.2021 12:40:18'   | '500'         | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'USD'        | 'USD'                    | 'en description is empty'        | 'No'                      |
			| ''                                           | 'Expense'       | '05.04.2021 12:40:18'   | '2 813,75'    | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
	And I close all client application windows

	
Scenario: _043502 check Cash payment movements by the Register "R5010 Reconciliation statement" (payment to vendor)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 1 dated 05.04.2021 12:40:00'     | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                          |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                    | ''                          |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'          | 'Legal name contract'       |
			| ''                                             | 'Receipt'       | '05.04.2021 12:40:00'   | '1 000'       | 'Main Company'   | 'Front office'   | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP New'    |
	And I close all client application windows

Scenario: _043503 check Cash payment movements by the Register "R1020 Advances to vendors" (payment to vendor, without basis document)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 1 dated 05.04.2021 12:40:00' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''                     | ''                         |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'    | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''                     | ''                         |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | 'Attributes'           | ''                         |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'                | 'Project' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                         | 'Receipt'     | '05.04.2021 12:40:00' | '171,2'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                         |
			| ''                                         | 'Receipt'     | '05.04.2021 12:40:00' | '1 000'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                         |
			| ''                                         | 'Receipt'     | '05.04.2021 12:40:00' | '1 000'     | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                         |
	And I close all client application windows

Scenario: _043504 check Cash payment movements by the Register "Return to customer" (return to customer)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '327'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 327 dated 02.09.2021 14:09:26'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                    | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                             | 'Receipt'       | '02.09.2021 14:09:26'   | '450'         | 'Main Company'   | 'Front office'   | 'USD'        | 'Company Ferron BP'   | ''                       |
	And I close all client application windows



Scenario: _043514 check Cash payment movements by the Register "R3035 Cash planning" (payment to vendor, with planning transaction basis)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '324'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 324 dated 04.06.2021 11:30:02' | ''                    | ''          | ''             | ''             | ''             | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''             | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''             | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''             | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'      | 'Basis document'                                       | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 11:30:02' | '-960'      | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing payment order 324 dated 04.06.2021 10:38:24' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'               | 'Movement type 1'         | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 11:30:02' | '-960'      | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing payment order 324 dated 04.06.2021 10:38:24' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'TRY'                          | 'Movement type 1'         | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 11:30:02' | '-960'      | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing payment order 324 dated 04.06.2021 10:38:24' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en description is empty'      | 'Movement type 1'         | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 11:30:02' | '-164,35'   | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing payment order 324 dated 04.06.2021 10:38:24' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'           | 'Movement type 1'         | 'Second'          | 'No'                   |	
	And I close all client application windows

Scenario: _043515 check Cash payment movements by the Register "R3035 Cash planning" (Currency exchange, with planning transaction basis)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '325'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 325 dated 04.06.2021 12:43:40' | ''                    | ''          | ''             | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'      | 'Basis document'                                  | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:43:40' | '-1 000'    | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:43:40' | '-1 000'    | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:43:40' | '-171,2'    | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'USD'      | 'Outgoing'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
	And I close all client application windows

Scenario: _043516 check Cash payment movements by the Register "R3035 Cash planning" (Cash transfer order, with planning transaction basis)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '326'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 326 dated 04.06.2021 12:44:31' | ''                    | ''          | ''             | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''             | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'      | 'Basis document'                                  | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:44:31' | '-2 532,38' | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:44:31' | '-450'      | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'USD'      | 'Outgoing'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:44:31' | '-450'      | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'USD'      | 'Outgoing'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
	And I close all client application windows


Scenario: _043517 check Cash payment movements by the Register "R3021 Cash in transit (incoming)" (Cash transfer order, with planning transaction basis)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '326'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 326 dated 04.06.2021 12:44:31'   | ''            | ''                    | ''          | ''             | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'             | 'Account'      | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                           | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '04.06.2021 12:44:31' | '450'       | 'Main Company' | 'Accountants office' | 'Cash desk №2' | 'Reporting currency'           | 'USD'      | 'USD'                  | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'No'                   |
			| ''                                             | 'Receipt'     | '04.06.2021 12:44:31' | '450'       | 'Main Company' | 'Accountants office' | 'Cash desk №2' | 'en description is empty'      | 'USD'      | 'USD'                  | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'No'                   |
			| ''                                             | 'Receipt'     | '04.06.2021 12:44:31' | '2 532,38'  | 'Main Company' | 'Accountants office' | 'Cash desk №2' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'No'                   |
	And I close all client application windows

Scenario: _043518 check absence Cash payment movements by the Register "R3035 Cash planning" (payment to vendor, without planning transaction basis)
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I select current line in "List" table
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R3035 Cash planning'    |
	And I close all client application windows

Scenario: _043520 check Cash payment movements by the Register "R3010 Cash on hand" (Return to customer, without basis)
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '327'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 327 dated 02.09.2021 14:09:26'   | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Expense'       | '02.09.2021 14:09:26'   | '450'         | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'USD'        | 'USD'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '02.09.2021 14:09:26'   | '450'         | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'USD'        | 'USD'                    | 'en description is empty'        | 'No'                      |
			| ''                                             | 'Expense'       | '02.09.2021 14:09:26'   | '2 532,38'    | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
	And I close all client application windows


Scenario: _043521 check absence Cash payment movements by the Register "R5010 Reconciliation statement" (cash transfer order)
	And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And I select current line in "List" table
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R5010 Reconciliation statement'    |
	And I close all client application windows

Scenario: _043522 check absence Cash payment movements by the Register "R5010 Reconciliation statement" (Currency exchange)
	And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '325'       |
		And I select current line in "List" table
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R5010 Reconciliation statement'    |
	And I close all client application windows

Scenario: _043528 check Cash payment movements by the Register "R3021 Cash in transit (incoming)" (Currency exchange)
		And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '325'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 325 dated 04.06.2021 12:43:40'   | ''            | ''                    | ''          | ''             | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                   | ''             | ''                             | ''         | ''                     | ''                                                | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'             | 'Account'      | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                           | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '04.06.2021 12:43:40' | '171,2'     | 'Main Company' | 'Accountants office' | 'Cash desk №2' | 'Reporting currency'           | 'USD'      | 'EUR'                  | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'No'                   |
			| ''                                             | 'Receipt'     | '04.06.2021 12:43:40' | '1 000'     | 'Main Company' | 'Accountants office' | 'Cash desk №2' | 'Local currency'               | 'TRY'      | 'EUR'                  | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'No'                   |
			| ''                                             | 'Receipt'     | '04.06.2021 12:43:40' | '1 000'     | 'Main Company' | 'Accountants office' | 'Cash desk №2' | 'en description is empty'      | 'EUR'      | 'EUR'                  | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'No'                   |
	And I close all client application windows

Scenario: _043523 check Cash payment movements by the Register "R1020 Advances to vendors" (with partner term by document, without basis)
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '328'       |
		And I select current line in "List" table
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 328 dated 08.02.2022 13:44:32' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''                | ''                     | ''                         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''                | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'      | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''                | ''                     | ''                         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''                | 'Attributes'           | ''                         |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'          | 'Project'         | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                           | 'Receipt'     | '08.02.2022 13:44:32' | '8,56'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''                | 'No'                   | ''                         |
			| ''                                           | 'Receipt'     | '08.02.2022 13:44:32' | '50'        | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''                | 'No'                   | ''                         |
			| ''                                           | 'Receipt'     | '08.02.2022 13:44:32' | '50'        | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''                | 'No'                   | ''                         |
	And I close all client application windows


Scenario: _043524 check Cash payment movements by the Register  "R2023 Advances from retail customers" (return retail customer advance)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '311'       |
		And I select current line in "List" table
	* Check movements by the Register  "R2023 Advances from retail customers" 
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 311 dated 18.01.2023 11:53:32'         | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| 'Document registrations records'                     | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| 'Register  "R2023 Advances from retail customers"'   | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| ''                                                   | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                   |
			| ''                                                   | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Retail customer'    |
			| ''                                                   | 'Expense'       | '18.01.2023 11:53:32'   | '200'         | 'Main Company'   | ''         | 'Sam Jons'           |
	And I close all client application windows


Scenario: _043525 check Cash payment movements by the Register  "R3010 Cash on hand" (return retail customer advance)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '311'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 311 dated 18.01.2023 11:53:32'   | ''              | ''                      | ''            | ''               | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Expense'       | '18.01.2023 11:53:32'   | '34,24'       | 'Main Company'   | ''         | 'Cash desk №2'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '18.01.2023 11:53:32'   | '200'         | 'Main Company'   | ''         | 'Cash desk №2'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '18.01.2023 11:53:32'   | '200'         | 'Main Company'   | ''         | 'Cash desk №2'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _043526 check Cash payment movements by the Register  "R3010 Cash on hand" (return retail customer advance)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '329'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 329 dated 08.02.2023 13:10:49'   | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '171,2'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '256,8'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 500'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 500'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _043527 check Cash payment movements by the Register  "R9510 Salary payment" (return retail customer advance)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '329'       |
		And I select current line in "List" table
	* Check movements by the Register  "R9510 Salary payment" 
		And I click "Registrations report info" button
		And I select "R9510 Salary payment" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 329 dated 08.02.2023 13:10:49' | ''                    | ''           | ''             | ''             | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| 'Register  "R9510 Salary payment"'           | ''                    | ''           | ''             | ''             | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| ''                                           | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Employee'        | 'Payment period' | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Calculation type' | 'Amount' |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '1 000'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '1 000'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '171,2'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'First'          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '1 500'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'First'          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '1 500'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'First'          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '256,8'  |
	And I close all client application windows

Scenario: _043530 Cash payment clear posting/mark for deletion
	And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 2 dated 05.04.2021 12:40:18'    |
			| 'Document registrations records'              |
		And I close current window
	* Post Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 2 dated 05.04.2021 12:40:18'    |
			| 'Document registrations records'              |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'    |
		And I close all client application windows		

Scenario: _043528 check Cash payment movements by the Register  "R3011 Cash flow"
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '324'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 324 dated 04.06.2021 11:30:02' | ''                    | ''          | ''             | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 11:30:02' | '164,35'    | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | 'Second'          | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '04.06.2021 11:30:02' | '960'       | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | 'Second'          | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '04.06.2021 11:30:02' | '960'       | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | 'Second'          | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                           | '04.06.2021 11:30:02' | '960'       | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | 'Second'          | 'TRY'      | 'en description is empty'      | 'No'                   |	
	And I close all client application windows

Scenario: _043531 check Cash payment movements by the Register  "R3011 Cash flow" (Other partner)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '801'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 801 dated 12.06.2023 15:24:47' | ''                    | ''          | ''             | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '12.06.2023 15:24:47' | '8,56'      | 'Main Company' | 'Front office' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '12.06.2023 15:24:47' | '50'        | 'Main Company' | 'Front office' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '12.06.2023 15:24:47' | '50'        | 'Main Company' | 'Front office' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                           | '12.06.2023 15:24:47' | '50'        | 'Main Company' | 'Front office' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _043531 check Cash payment movements by the Register  "R5010 Reconciliation statement" (Other partner)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '801'       |
		And I select current line in "List" table
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 801 dated 12.06.2023 15:24:47'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                  | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'        | 'Legal name contract'    |
			| ''                                             | 'Receipt'       | '12.06.2023 15:24:47'   | '50'          | 'Main Company'   | 'Front office'   | 'TRY'        | 'Other partner 2'   | ''                       |
	And I close all client application windows

Scenario: _043533 check Cash payment movements by the Register  "R3010 Cash on hand" (Other partner)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '801'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 801 dated 12.06.2023 15:24:47'   | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''               | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Expense'       | '12.06.2023 15:24:47'   | '8,56'        | 'Main Company'   | 'Front office'   | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '12.06.2023 15:24:47'   | '50'          | 'Main Company'   | 'Front office'   | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '12.06.2023 15:24:47'   | '50'          | 'Main Company'   | 'Front office'   | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _043534 check Cash payment movements by the Register  "R5015 Other partners transactions" (Other partner)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '801'       |
		And I select current line in "List" table
	* Check movements by the Register  "R5015 Other partners transactions" 
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 801 dated 12.06.2023 15:24:47'      | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  |''                  | ''                        |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  |''                  | ''                        |
			| 'Register  "R5015 Other partners transactions"'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  |''                  | ''                        |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  |''                  | 'Attributes'              |
			| ''                                                | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'           | 'Agreement'         |'Basis'             | 'Deferred calculation'    |
			| ''                                                | 'Receipt'       | '12.06.2023 15:24:47'   | '8,56'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   |''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 15:24:47'   | '50'          | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   |''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 15:24:47'   | '50'          | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   |''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 15:24:47'   | '50'          | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   |''                  | 'No'                      |
	And I close all client application windows

Scenario: _043535 check Cash payment movements by the Register  "R3010 Cash on hand" (cash transfer without CTO)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '331'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 331 dated 03.07.2023 14:21:00' | ''            | ''                    | ''          | ''             | ''                        | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''                        | ''             | ''         | ''                     | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''             | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'      | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Expense'     | '03.07.2023 14:21:00' | '171,2'     | 'Main Company' | 'Distribution department' | 'Cash desk №4' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Expense'     | '03.07.2023 14:21:00' | '1 000'     | 'Main Company' | 'Distribution department' | 'Cash desk №4' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                           | 'Expense'     | '03.07.2023 14:21:00' | '1 000'     | 'Main Company' | 'Distribution department' | 'Cash desk №4' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _043536 check Cash payment movements by the Register  "R3011 Cash flow" (cash transfer without CTO)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '331'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3011 Cash flow"
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 331 dated 03.07.2023 14:21:00' | ''                    | ''          | ''             | ''                        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''                        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''                        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '03.07.2023 14:21:00' | '171,2'     | 'Main Company' | 'Distribution department' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '03.07.2023 14:21:00' | '1 000'     | 'Main Company' | 'Distribution department' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '03.07.2023 14:21:00' | '1 000'     | 'Main Company' | 'Distribution department' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _043537 check Cash payment movements by the Register  "R3021 Cash in transit (incoming)" (cash transfer without CTO)
		And I close all client application windows
	* Select Cash payment
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '331'       |
		And I select current line in "List" table
	* Check movements by the Register  "R3021 Cash in transit (incoming)"
		And I click "Registrations report info" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 331 dated 03.07.2023 14:21:00'   | ''                    | ''           | ''             | ''             | ''             | ''                             | ''         | ''                     | ''      | ''       | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''                    | ''           | ''             | ''             | ''             | ''                             | ''         | ''                     | ''      | ''       | ''                     |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Account'      | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Amount' | 'Deferred calculation' |
			| ''                                             | '03.07.2023 14:21:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Local currency'               | 'TRY'      | 'TRY'                  | ''      | '1 000'  | 'No'                   |
			| ''                                             | '03.07.2023 14:21:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Cash desk №1' | 'Reporting currency'           | 'USD'      | 'TRY'                  | ''      | '171,2'  | 'No'                   |
			| ''                                             | '03.07.2023 14:21:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Cash desk №1' | 'en description is empty'      | 'TRY'      | 'TRY'                  | ''      | '1 000'  | 'No'                   |	
	And I close all client application windows