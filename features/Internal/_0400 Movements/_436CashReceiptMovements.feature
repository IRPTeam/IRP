﻿#language: en
@tree
@Positive
@Movements
@MovementsCashReceipt

Feature: check Cash receipt movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043600 preparation (Cash receipt)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create catalog PlanningPeriods objects
		When Create POS cash account objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
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
	When Create catalog LegalNameContracts objects
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '1' |
			| '3' |	
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '2' |
			| '3' |	
			When Create document ShipmentConfirmation objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '1' |
			| '3' |	
			When Create document SalesInvoice objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '102' |
			When Create document SalesReturnOrder objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturnOrder.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
			And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '101' |
			| '104' |
			When Create document SalesReturn objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(104).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Cash receipt
		When Create document CashReceipt objects (check movements)
		When Create document Cash receipt (Customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document CashReceipt objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load SO, SI, IPO
		When create RetailSalesOrder objects
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document SalesOrder objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document SalesOrder objects (with aging, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document SalesInvoice objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document SalesInvoice objects (with aging, Post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document IncomingPaymentOrder objects (Cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.IncomingPaymentOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.IncomingPaymentOrder.FindByNumber(114).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Cash transfer order
		When Create document CashTransferOrder objects
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load PR
		When Create document PurchaseReturn objects (advance)
		And I execute 1C:Enterprise script at server
		| "Documents.PurchaseReturn.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Cash receipt (cash planning)
		When Create document CashReceipt objects (cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(513).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(514).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(515).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document CashReceipt objects (return from vendor)
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(516).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(517).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document CashReceipt objects advance from retail customer
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);" |	
	When Create document CashReceipt objects (with partner term by document, without basis)
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(518).GetObject().Write(DocumentWriteMode.Posting);" |
	And I close all client application windows
	When Create document MoneyTransfer and CashReceipt objects (for cash in, movements)
	And I execute 1C:Enterprise script at server
		| "Documents.MoneyTransfer.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.MoneyTransfer.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
		
Scenario: _0436001 check preparation
	When check preparation

Scenario: _043601 check Cash receipt movements by the Register "R3010 Cash on hand"
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 2 dated 05.04.2021 14:34:09' | ''            | ''                    | ''          | ''             | ''             | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''             | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'           | ''            | ''                    | ''          | ''             | ''             | ''             | ''         | ''                     | ''                             | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''             | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'      | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                         | 'Receipt'     | '05.04.2021 14:34:09' | '500'       | 'Main Company' | 'Front office' | 'Cash desk №2' | 'USD'      | 'USD'                  | 'Reporting currency'           | 'No'                   |
			| ''                                         | 'Receipt'     | '05.04.2021 14:34:09' | '500'       | 'Main Company' | 'Front office' | 'Cash desk №2' | 'USD'      | 'USD'                  | 'en description is empty'      | 'No'                   |
			| ''                                         | 'Receipt'     | '05.04.2021 14:34:09' | '2 813,75'  | 'Main Company' | 'Front office' | 'Cash desk №2' | 'TRY'      | 'USD'                  | 'Local currency'               | 'No'                   |
	And I close all client application windows

	
Scenario: _043602 check Cash receipt movements by the Register "R5010 Reconciliation statement" (payment from customer)
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 1 dated 05.04.2021 14:33:49'   | ''            | ''                    | ''          | ''             | ''             | ''         | ''                  | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''         | ''                  | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''             | ''             | ''         | ''                  | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''         | ''                  | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Currency' | 'Legal name'        |'Legal name contract'|
			| ''                                           | 'Expense'     | '05.04.2021 14:33:49' | '100'       | 'Main Company' | 'Front office' | 'TRY'      | 'Company Ferron BP' |'Contract Ferron BP New'|
	And I close all client application windows


	
Scenario: _043603 check Cash receipt movements by the Register "R5010 Reconciliation statement" (return from vendor)
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '516' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 516 dated 02.09.2021 14:17:00' | ''            | ''                    | ''          | ''             | ''             | ''         | ''                  | ''                    |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''         | ''                  | ''                    |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''             | ''             | ''         | ''                  | ''                    |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''         | ''                  | ''                    |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Currency' | 'Legal name'        | 'Legal name contract' |
			| ''                                           | 'Expense'     | '02.09.2021 14:17:00' | '100'       | 'Main Company' | 'Front office' | 'TRY'      | 'Company Ferron BP' | ''                    |		
	And I close all client application windows





Scenario: _043610 check Cash receipt movements by the Register "R2021 Customer transactions" (basis document exist)
	And I close all client application windows
	* Select Cash receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And I select current line in "List" table
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 1 dated 05.04.2021 14:33:49' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                           | ''                     | ''                           |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                           | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'  | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                           | ''                     | ''                           |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                           | 'Attributes'           | ''                           |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Order'                      | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                         | 'Expense'     | '05.04.2021 14:33:49' | '17,12'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                           | 'No'                   | ''                           |
			| ''                                         | 'Expense'     | '05.04.2021 14:33:49' | '100'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                           | 'No'                   | ''                           |
			| ''                                         | 'Expense'     | '05.04.2021 14:33:49' | '100'       | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                           | 'No'                   | ''                           |
			| ''                                         | 'Expense'     | '05.04.2021 14:33:49' | '100'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                           | 'No'                   | ''                           |
	And I close all client application windows

Scenario: _043611 check absence Cash receipt movements by the Register "R2021 Customer transactions" (without basis document)
	And I close all client application windows
	* Select Cash receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2021 Customer transactions'   |     
	And I close all client application windows

Scenario: _043612 check Cash receipt movements by the Register "R2020 Advances from customer" (without basis document)
	And I close all client application windows
	* Select Cash receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
		And I select current line in "List" table	
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 4 dated 27.04.2021 11:31:10' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                                         | ''                     | ''                           |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                                         | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                                         | ''                     | ''                           |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                                         | 'Attributes'           | ''                           |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order'                                    | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                         | 'Receipt'     | '27.04.2021 11:31:10' | '171,2'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''                                         | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '27.04.2021 11:31:10' | '1 000'     | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''                                         | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '27.04.2021 11:31:10' | '1 000'     | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''                                         | 'No'                   | ''                           |
	And I close all client application windows



Scenario: _043613 check absence Cash receipt movements by the Register "R2020 Advances from customer" (with basis document)
	And I close all client application windows
	* Select Cash receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer'   |     
	And I close all client application windows

Scenario: _043617 check Cash receipt movements by the Register "R3035 Cash planning" (Payment from customer, with planning transaction basis)
	And I close all client application windows
	* Select Cash receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '513' |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 513 dated 04.06.2021 12:50:14' | ''                    | ''          | ''             | ''             | ''                                                     | ''             | ''         | ''                    | ''         | ''                 | ''                             | ''                | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                                                     | ''             | ''         | ''                    | ''         | ''                 | ''                             | ''                | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                                                     | ''             | ''         | ''                    | ''         | ''                 | ''                             | ''                | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                                     | ''             | ''         | ''                    | ''         | ''                 | ''                             | ''                | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Basis document'                                       | 'Account'      | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'       | 'Multi currency movement type' | 'Financial movement type'   | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:50:14' | '-900'      | 'Main Company' | 'Front office' | 'Incoming payment order 114 dated 04.06.2021 10:36:34' | 'Cash desk №1' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Local currency'               | 'Movement type 1' | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 12:50:14' | '-900'      | 'Main Company' | 'Front office' | 'Incoming payment order 114 dated 04.06.2021 10:36:34' | 'Cash desk №1' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'en description is empty'      | 'Movement type 1' | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 12:50:14' | '-450'      | 'Main Company' | 'Front office' | 'Incoming payment order 114 dated 04.06.2021 10:36:34' | 'Cash desk №1' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Local currency'               | 'Movement type 1' | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 12:50:14' | '-450'      | 'Main Company' | 'Front office' | 'Incoming payment order 114 dated 04.06.2021 10:36:34' | 'Cash desk №1' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'en description is empty'      | 'Movement type 1' | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 12:50:14' | '-154,08'   | 'Main Company' | 'Front office' | 'Incoming payment order 114 dated 04.06.2021 10:36:34' | 'Cash desk №1' | 'USD'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Reporting currency'           | 'Movement type 1' | 'Second'          | 'No'                   |
			| ''                                           | '04.06.2021 12:50:14' | '-77,04'    | 'Main Company' | 'Front office' | 'Incoming payment order 114 dated 04.06.2021 10:36:34' | 'Cash desk №1' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Reporting currency'           | 'Movement type 1' | 'Second'          | 'No'                   |
	And I close all client application windows

Scenario: _043618 check Cash receipt movements by the Register "R3035 Cash planning" (Cash transfer order, with planning transaction basis)
	And I close all client application windows
	* Select Cash receipt (Cash transfer order)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '514' |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 514 dated 04.06.2021 12:51:22' | ''                    | ''          | ''             | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Basis document'                                  | 'Account'      | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type'   | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:51:22' | '-2 532,38' | 'Main Company' | 'Front office' | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'Cash desk №2' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1' | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:51:22' | '-450'      | 'Main Company' | 'Front office' | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'Cash desk №2' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1' | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:51:22' | '-450'      | 'Main Company' | 'Front office' | 'Cash transfer order 1 dated 07.09.2020 19:18:16' | 'Cash desk №2' | 'USD'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1' | ''                | 'No'                   |
	And I close all client application windows

Scenario: _043619 check Cash receipt movements by the Register "R3035 Cash planning" (Currency exchange, with planning transaction basis)
	And I close all client application windows
	* Select Cash receipt (Currency exchange)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '515' |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 515 dated 04.06.2021 12:51:33' | ''                    | ''          | ''             | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                                | ''             | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Basis document'                                  | 'Account'      | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type'   | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:51:33' | '-1 620'    | 'Main Company' | 'Front office' | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'Cash desk №2' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1' | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:51:33' | '-198'      | 'Main Company' | 'Front office' | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'Cash desk №2' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1' | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:51:33' | '-180'      | 'Main Company' | 'Front office' | 'Cash transfer order 4 dated 05.04.2021 12:24:12' | 'Cash desk №2' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1' | ''                | 'No'                   |
	And I close all client application windows

Scenario: _043620 check absence Cash receipt movements by the Register "R3035 Cash planning" (without planning transaction basis)
	And I close all client application windows
	* Select Cash receipt (Currency exchange)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R3035 Cash planning'   |   
	And I close all client application windows

Scenario: _043621 check Cash receipt movements by the Register "R3010 Cash on hand" (Return from vendor, without basis)
	And I close all client application windows
	* Select Cash receipt (Currency exchange)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '516' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 516 dated 02.09.2021 14:17:00' | ''            | ''                    | ''          | ''             | ''             | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''             | ''             | ''         | ''                     | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''             | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'      | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Receipt'     | '02.09.2021 14:17:00' | '17,12'     | 'Main Company' | 'Front office' | 'Cash desk №4' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Receipt'     | '02.09.2021 14:17:00' | '100'       | 'Main Company' | 'Front office' | 'Cash desk №4' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                           | 'Receipt'     | '02.09.2021 14:17:00' | '100'       | 'Main Company' | 'Front office' | 'Cash desk №4' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |			
	And I close all client application windows


Scenario: _043622 check absence Cash receipt movements by the Register "R5010 Reconciliation statement" (Currency exchange)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
		And I select current line in "List" table
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R5010 Reconciliation statement'   | 
	And I close all client application windows

Scenario: _043623 check absence Cash receipt movements by the Register "R5010 Reconciliation statement" (Cash transfer order)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
		And I select current line in "List" table
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R5010 Reconciliation statement'   | 
	And I close all client application windows

Scenario: _043624 check Cash receipt movements by the Register "R1021 Vendors transactions" (Return from vendor, with basis)
	And I close all client application windows
	* Select Cash receipt (Currency exchange)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '517' |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 517 dated 08.02.2022 13:18:32' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''              | ''        | ''                   | ''                                             | ''      | ''                     | ''                         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''              | ''        | ''                   | ''                                             | ''      | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'     | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''              | ''        | ''                   | ''                                             | ''      | ''                     | ''                         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''              | ''        | ''                   | ''                                             | ''      | 'Attributes'           | ''                         |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'    | 'Partner' | 'Agreement'          | 'Basis'                                        | 'Order' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                           | 'Expense'     | '08.02.2022 13:18:32' | '-50'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02' | ''      | 'No'                   | ''                         |
			| ''                                           | 'Expense'     | '08.02.2022 13:18:32' | '-50'       | 'Main Company' | 'Front office' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02' | ''      | 'No'                   | ''                         |
			| ''                                           | 'Expense'     | '08.02.2022 13:18:32' | '-50'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02' | ''      | 'No'                   | ''                         |
			| ''                                           | 'Expense'     | '08.02.2022 13:18:32' | '-8,56'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | 'Partner term Maxim' | 'Purchase return 21 dated 28.04.2021 21:50:02' | ''      | 'No'                   | ''                         |			
	And I close all client application windows

Scenario: _043625 check Cash receipt movements by the Register "R2020 Advances from customer" (with partner term by document, without basis)
	And I close all client application windows
	* Select Cash receipt (Currency exchange)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '518' |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 518 dated 08.02.2022 13:39:52' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                     | ''                           |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'   | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                     | ''                           |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | 'Attributes'           | ''                           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                           | 'Receipt'     | '08.02.2022 13:39:52' | '8,56'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'No'                   | ''                           |
			| ''                                           | 'Receipt'     | '08.02.2022 13:39:52' | '50'        | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'No'                   | ''                           |
			| ''                                           | 'Receipt'     | '08.02.2022 13:39:52' | '50'        | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'No'                   | ''                           |		
	And I close all client application windows


Scenario: _043626 check Cash receipt movements by the Register "R3010 Cash on hand" (cash in)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '11' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 11 dated 25.08.2022 16:46:16' | ''            | ''                    | ''          | ''             | ''        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'            | ''            | ''                    | ''          | ''             | ''        | ''                   | ''         | ''                     | ''                             | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                   | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'            | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '25.08.2022 16:46:16' | '171,2'     | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                          | 'Receipt'     | '25.08.2022 16:46:16' | '1 000'     | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                          | 'Receipt'     | '25.08.2022 16:46:16' | '1 000'     | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
	And I close all client application windows

Scenario: _043627 check Cash receipt movements by the Register "R3021 Cash in transit (incoming)" (cash in)
	And I close all client application windows
	* Select Cash receipt 
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '11' |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 11 dated 25.08.2022 16:46:16'    | ''            | ''                    | ''          | ''           | ''             | ''        | ''                             | ''         | ''             | ''                   | ''                                            | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''             | ''        | ''                             | ''         | ''             | ''                   | ''                                            | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''             | ''        | ''                             | ''         | ''             | ''                   | ''                                            | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''        | ''                             | ''         | ''             | ''                   | ''                                            | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Account'      | 'Receipting account' | 'Basis'                                       | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '25.08.2022 16:46:16' | '171,2'     | ''           | 'Main Company' | 'Shop 02' | 'Reporting currency'           | 'USD'      | 'Cash desk №2' | 'Pos cash account 1' | 'Money transfer 11 dated 25.08.2022 16:45:16' | 'No'                   |
			| ''                                             | 'Expense'     | '25.08.2022 16:46:16' | '1 000'     | ''           | 'Main Company' | 'Shop 02' | 'Local currency'               | 'TRY'      | 'Cash desk №2' | 'Pos cash account 1' | 'Money transfer 11 dated 25.08.2022 16:45:16' | 'No'                   |
			| ''                                             | 'Expense'     | '25.08.2022 16:46:16' | '1 000'     | ''           | 'Main Company' | 'Shop 02' | 'en description is empty'      | 'TRY'      | 'Cash desk №2' | 'Pos cash account 1' | 'Money transfer 11 dated 25.08.2022 16:45:16' | 'No'                   |	
	And I close all client application windows


Scenario: _043628 check Cash receipt movements by the Register "R3010 Cash on hand" (cash out)
	And I close all client application windows
	* Select Cash receipt 
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '12' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 12 dated 25.08.2022 16:46:40' | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'            | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                     | ''                             | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '25.08.2022 16:46:40' | '171,2'     | 'Main Company' | 'Shop 02' | 'Cash desk №2' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                          | 'Receipt'     | '25.08.2022 16:46:40' | '1 000'     | 'Main Company' | 'Shop 02' | 'Cash desk №2' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                          | 'Receipt'     | '25.08.2022 16:46:40' | '1 000'     | 'Main Company' | 'Shop 02' | 'Cash desk №2' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |	
	And I close all client application windows

Scenario: _043629 check Cash receipt movements by the Register "R3021 Cash in transit (incoming)" (cash out)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '12' |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 12 dated 25.08.2022 16:46:40'    | ''            | ''                    | ''          | ''           | ''             | ''        | ''                             | ''         | ''                   | ''                   | ''                                            | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''             | ''        | ''                             | ''         | ''                   | ''                   | ''                                            | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''             | ''        | ''                             | ''         | ''                   | ''                   | ''                                            | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''        | ''                             | ''         | ''                   | ''                   | ''                                            | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Account'            | 'Receipting account' | 'Basis'                                       | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '25.08.2022 16:46:40' | '171,2'     | ''           | 'Main Company' | 'Shop 02' | 'Reporting currency'           | 'USD'      | 'Pos cash account 1' | 'Cash desk №2'       | 'Money transfer 13 dated 25.08.2022 16:46:25' | 'No'                   |
			| ''                                             | 'Expense'     | '25.08.2022 16:46:40' | '1 000'     | ''           | 'Main Company' | 'Shop 02' | 'Local currency'               | 'TRY'      | 'Pos cash account 1' | 'Cash desk №2'       | 'Money transfer 13 dated 25.08.2022 16:46:25' | 'No'                   |
			| ''                                             | 'Expense'     | '25.08.2022 16:46:40' | '1 000'     | ''           | 'Main Company' | 'Shop 02' | 'en description is empty'      | 'TRY'      | 'Pos cash account 1' | 'Cash desk №2'       | 'Money transfer 13 dated 25.08.2022 16:46:25' | 'No'                   |
	And I close all client application windows


Scenario: _043631 check Cash receipt movements by the Register  "R2023 Advances from retail customers" (advance from retail customer)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '10' |
	* Check movements by the Register  "R2023 Advances from retail customers" 
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 10 dated 29.12.2022 15:09:05'        | ''            | ''                    | ''          | ''             | ''        | ''                |
			| 'Document registrations records'                   | ''            | ''                    | ''          | ''             | ''        | ''                |
			| 'Register  "R2023 Advances from retail customers"' | ''            | ''                    | ''          | ''             | ''        | ''                |
			| ''                                                 | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                |
			| ''                                                 | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Retail customer' |
			| ''                                                 | 'Receipt'     | '29.12.2022 15:09:05' | '400'       | 'Main Company' | 'Shop 02' | 'Sam Jons'        |	
	And I close all client application windows

Scenario: _043632 check Cash receipt movements by the Register  "R3010 Cash on hand" (advance from retail customer)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '10' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 10 dated 29.12.2022 15:09:05' | ''            | ''                    | ''          | ''             | ''        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'            | ''            | ''                    | ''          | ''             | ''        | ''                   | ''         | ''                     | ''                             | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                   | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'            | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '29.12.2022 15:09:05' | '68,48'     | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                          | 'Receipt'     | '29.12.2022 15:09:05' | '400'       | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                          | 'Receipt'     | '29.12.2022 15:09:05' | '400'       | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _043633 check Cash receipt movements by the Register  "R3026 Sales orders customer advance" (advance from retail customer, sales order)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '315' |
	* Check movements by the Register  "R3026 Sales orders customer advance" 
		And I click "Registrations report" button
		And I select "R3026 Sales orders customer advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 315 dated 09.01.2023 13:20:51'      | ''            | ''                    | ''          | ''           | ''             | ''       | ''                  | ''         | ''                | ''                                          | ''             | ''             | ''                 | ''          |
			| 'Document registrations records'                  | ''            | ''                    | ''          | ''           | ''             | ''       | ''                  | ''         | ''                | ''                                          | ''             | ''             | ''                 | ''          |
			| 'Register  "R3026 Sales orders customer advance"' | ''            | ''                    | ''          | ''           | ''             | ''       | ''                  | ''         | ''                | ''                                          | ''             | ''             | ''                 | ''          |
			| ''                                                | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''       | ''                  | ''         | ''                | ''                                          | ''             | ''             | ''                 | ''          |
			| ''                                                | ''            | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch' | 'Payment type enum' | 'Currency' | 'Retail customer' | 'Order'                                     | 'Account'      | 'Payment type' | 'Payment terminal' | 'Bank term' |
			| ''                                                | 'Expense'     | '09.01.2023 13:20:51' | '1 000'     | ''           | 'Main Company' | ''       | 'Cash'              | 'TRY'      | 'Sam Jons'        | 'Sales order 315 dated 09.01.2023 13:02:11' | 'Cash desk №1' | ''             | ''                 | ''          |		
	And I close all client application windows

Scenario: _043634 check absence Cash receipt movements by the Register "R3026 Sales orders customer advance" (not advance from retail customer, sales order)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '10' |
		And I select current line in "List" table
	* Check movements by the Register  "R3026 Sales orders customer advance" 
		And I click "Registrations report" button
		And I select "R3026 Sales orders customer advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R3026 Sales orders customer advance'   | 
	And I close all client application windows

Scenario: _043630 Cash receipt clear posting/mark for deletion
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 2 dated 05.04.2021 14:34:09' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 2 dated 05.04.2021 14:34:09' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand' |
		And I close all client application windows		

