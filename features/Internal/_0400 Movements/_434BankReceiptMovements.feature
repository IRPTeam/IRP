#language: en
@tree
@Positive
@Movements2
@MovementsBankReceipt

Feature: check Bank receipt movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043400 preparation (Bank receipt)
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
		When Create catalog Countries objects
		When Create catalog LegalNameContracts objects
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
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
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
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '1'         |
			| '3'         |
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '2'         |
			| '3'         |
			When Create document ShipmentConfirmation objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '1'         |
			| '3'         |
			When Create document SalesInvoice objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '102'       |
			When Create document SalesReturnOrder objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturnOrder.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '101'       |
			| '104'       |
			When Create document SalesReturn objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(104).GetObject().Write(DocumentWriteMode.Posting);"     |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);"     |
		When create RetailSalesOrder objects
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Bank receipt
		When Create document BankReceipt objects
		When Create document BankReceipt objects (exchange and transfer)
		When Create document BankReceipt objects (advance)
		When Create document BankReceipt objects (POS)
		When Create document Bank receipt (Customer advance)
		When Create document BankReceipt objects (retail customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1519).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1520).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1521).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1522).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		If "List" table contains lines Then
				| 'Number'     |
				| '11'         |
				And I execute 1C:Enterprise script at server
					| "Documents.BankReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.UndoPosting);"      |
		And I close all client application windows
	* Load SO, SI, IPO
		When Create document SalesOrder objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrder objects (with aging, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (with aging, Post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document IncomingPaymentOrder objects (Cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.IncomingPaymentOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.IncomingPaymentOrder.FindByNumber(114).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Cash transfer order
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
		When Create document BankReceipt objects (cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(513).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(514).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(515).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (cash transfer)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(331).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load PR
		When Create document PurchaseReturn objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseReturn.FindByNumber(21).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseReturn.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (Return from vendor)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(516).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(517).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (with partner term by document, without basis)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(518).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create BankReceipt (OtherPartnersTransactions)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(51).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create BankReceipt (Other income)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1525).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _0434001 check preparation
	When check preparation

Scenario: _043401 check Bank receipt movements by the Register "R3010 Cash on hand"
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 2 dated 05.04.2021 14:27:40'   | ''              | ''                      | ''            | ''               | ''               | ''                      | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''               | ''                      | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'             | ''              | ''                      | ''            | ''               | ''               | ''                      | ''           | ''                       | ''                               | ''                        |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                      | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'               | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                           | 'Receipt'       | '05.04.2021 14:27:40'   | '500'         | 'Main Company'   | 'Front office'   | 'Bank account 2, EUR'   | 'EUR'        | 'EUR'                    | 'en description is empty'        | 'No'                      |
			| ''                                           | 'Receipt'       | '05.04.2021 14:27:40'   | '550'         | 'Main Company'   | 'Front office'   | 'Bank account 2, EUR'   | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
			| ''                                           | 'Receipt'       | '05.04.2021 14:27:40'   | '2 500'       | 'Main Company'   | 'Front office'   | 'Bank account 2, EUR'   | 'TRY'        | 'EUR'                    | 'Local currency'                 | 'No'                      |
	And I close all client application windows

	
Scenario: _043402 check Bank receipt movements by the Register "R5010 Reconciliation statement" (payment to vendor)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '1'        | '07.09.2020 19:14:59'    |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 dated 07.09.2020 19:14:59'     | ''              | ''                      | ''            | ''               | ''         | ''           | ''                    | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''         | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''         | ''           | ''                    | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''           | ''                    | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                             | 'Expense'       | '07.09.2020 19:14:59'   | '100'         | 'Main Company'   | ''         | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP'     |
	And I close all client application windows

Scenario: _043403 check Bank receipt movements by the Register "R5010 Reconciliation statement" (cash transfer, currency exchange)
	And I close all client application windows
	* Select Bank receipt (cash transfer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement'    |
	And I close all client application windows
	* Select Bank receipt (currency exchange)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement'    |
	And I close all client application windows

Scenario: _043404 check Bank receipt movements by the Register "R5010 Reconciliation statement" (Return from vendor)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '516'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 516 dated 02.09.2021 14:30:07'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                    | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                             | 'Expense'       | '02.09.2021 14:30:07'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'Company Ferron BP'   | ''                       |
			| ''                                             | 'Expense'       | '02.09.2021 14:30:07'   | '200'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'DFC'                 | ''                       |
	And I close all client application windows


Scenario: _043410 check Bank receipt movements by the Register "R2021 Customer transactions" (basis document exist)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 dated 07.09.2020 19:14:59'   | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''                       | ''                              |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'    | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''                       | ''                              |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | 'Attributes'             | ''                              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                       | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                           | 'Expense'       | '07.09.2020 19:14:59'   | '17,12'       | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''        | 'No'                     | ''                              |
			| ''                                           | 'Expense'       | '07.09.2020 19:14:59'   | '100'         | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''        | 'No'                     | ''                              |
			| ''                                           | 'Expense'       | '07.09.2020 19:14:59'   | '100'         | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''        | 'No'                     | ''                              |
			| ''                                           | 'Expense'       | '07.09.2020 19:14:59'   | '100'         | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''        | 'No'                     | ''                              |
		
	And I close all client application windows
	


Scenario: _043412 check Bank receipt movements by the Register "R2020 Advances from customer" (without basis document)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 5 dated 15.04.2021 10:21:22'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''        | ''                       | ''                              |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''        | ''                       | ''                              |
			| 'Register  "R2020 Advances from customer"'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''        | ''                       | ''                              |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                   | ''           | ''        | 'Attributes'             | ''                              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'         | 'Partner'    | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                           | 'Receipt'       | '15.04.2021 10:21:22'   | '9 381,76'    | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | ''        | 'No'                     | ''                              |
			| ''                                           | 'Receipt'       | '15.04.2021 10:21:22'   | '54 800'      | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | ''        | 'No'                     | ''                              |
			| ''                                           | 'Receipt'       | '15.04.2021 10:21:22'   | '54 800'      | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Lomaniti'   | 'Lomaniti'   | ''        | 'No'                     | ''                              |
	And I close all client application windows

Scenario: _043413 check absence Bank receipt movements by the Register "R2021 Customer transactions" (advance)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2021 Customer transactions'    |
	And I close all client application windows

Scenario: _043420 check Bank receipt movements by the Register "R3035 Cash planning" (Payment from customer, with planning transaction basis)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '513'       |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 513 dated 04.06.2021 12:27:04' | ''                    | ''          | ''             | ''             | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Basis document'                                       | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'       | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:27:04' | '-600'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '-600'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '-400'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '-400'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '-102,72'   | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'USD'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '-68,48'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
	And I close all client application windows

Scenario: _043421 check Bank receipt movements by the Register "R3035 Cash planning" (Currency exchange, with planning transaction basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '514'       |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 514 dated 04.06.2021 12:29:34' | ''                    | ''          | ''             | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Basis document'                                  | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:29:34' | '-1 620'    | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:29:34' | '-198'      | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:29:34' | '-180'      | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
	And I close all client application windows

Scenario: _043422 check Bank receipt movements by the Register "R3035 Cash planning" (Cash transfer order, with planning transaction basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '515'       |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 515 dated 04.06.2021 12:30:23' | ''                    | ''          | ''             | ''             | ''                    | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                    | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                    | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Basis document'                                  | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:30:23' | '-4 500'    | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:30:23' | '-550'      | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:30:23' | '-500'      | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
	And I close all client application windows

Scenario: _043423 check absence Bank receipt movements by the Register "R3035 Cash planning" (without planning transaction basis)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R3035 Cash planning'    |
	And I close all client application windows

Scenario: _043424 check Bank receipt movements by the Register "R5022 Expenses" (with comission)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '513'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 513 dated 04.06.2021 12:27:04'   | ''                      | ''            | ''                    | ''              | ''               | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                               | ''                             |
			| 'Document registrations records'               | ''                      | ''            | ''                    | ''              | ''               | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                               | ''                             |
			| 'Register  "R5022 Expenses"'                   | ''                      | ''            | ''                    | ''              | ''               | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                               | ''                             |
			| ''                                             | 'Period'                | 'Resources'   | ''                    | ''              | 'Dimensions'     | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                               | 'Attributes'                   |
			| ''                                             | ''                      | 'Amount'      | 'Amount with taxes'   | 'Amount cost'   | 'Company'        | 'Branch'         | 'Profit loss center'   | 'Expense type'   | 'Item key'   | 'Currency'   | 'Additional analytic'   | 'Multi currency movement type'   | 'Calculation movement cost'    |
			| ''                                             | '04.06.2021 12:27:04'   | '1,8'         | '1,8'                 | ''              | 'Main Company'   | 'Front office'   | ''                     | 'Expense'        | ''           | 'USD'        | ''                      | 'Reporting currency'             | ''                             |
			| ''                                             | '04.06.2021 12:27:04'   | '10,51'       | '10,51'               | ''              | 'Main Company'   | 'Front office'   | ''                     | 'Expense'        | ''           | 'TRY'        | ''                      | 'Local currency'                 | ''                             |
			| ''                                             | '04.06.2021 12:27:04'   | '10,51'       | '10,51'               | ''              | 'Main Company'   | 'Front office'   | ''                     | 'Expense'        | ''           | 'TRY'        | ''                      | 'en description is empty'        | ''                             |
	And I close all client application windows

Scenario: _043425 check Bank receipt movements by the Register "R3010 Cash on hand" (Return from vendor, without basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '516'       |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 516 dated 02.09.2021 14:30:07'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Receipt'       | '02.09.2021 14:30:07'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Receipt'       | '02.09.2021 14:30:07'   | '34,24'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Receipt'       | '02.09.2021 14:30:07'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Receipt'       | '02.09.2021 14:30:07'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                             | 'Receipt'       | '02.09.2021 14:30:07'   | '200'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Receipt'       | '02.09.2021 14:30:07'   | '200'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _043426 check Bank receipt movements by the Register "R1021 Vendors transactions" (Return from vendor, with basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '517'       |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 517 dated 08.02.2022 12:44:01'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | ''                       | ''                            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'       | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | ''                       | ''                            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | 'Attributes'             | ''                            |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'      | 'Partner'   | 'Agreement'            | 'Basis'                                          | 'Order'   | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                             | 'Expense'       | '08.02.2022 12:44:01'   | '-50'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'   | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''        | 'No'                     | ''                            |
			| ''                                             | 'Expense'       | '08.02.2022 12:44:01'   | '-50'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'   | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''        | 'No'                     | ''                            |
			| ''                                             | 'Expense'       | '08.02.2022 12:44:01'   | '-50'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'   | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''        | 'No'                     | ''                            |
			| ''                                             | 'Expense'       | '08.02.2022 12:44:01'   | '-8,56'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'   | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''        | 'No'                     | ''                            |
	And I close all client application windows


Scenario: _043427 check Bank receipt movements by the Register "R2020 Advances from customer" (with partner term by document, without basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '518'       |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 518 dated 08.02.2022 13:39:01'   | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                              |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                              |
			| 'Register  "R2020 Advances from customer"'     | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                              |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''        | 'Attributes'             | ''                              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                             | 'Receipt'       | '08.02.2022 13:39:01'   | '8,56'        | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                              |
			| ''                                             | 'Receipt'       | '08.02.2022 13:39:01'   | '50'          | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                              |
			| ''                                             | 'Receipt'       | '08.02.2022 13:39:01'   | '50'          | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                              |
	And I close all client application windows


Scenario: _0434281 check Bank receipt movements by the Register "R2020 Advances from customer" (Payment from customer by POS, without bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 520'     |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                              |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                              |
			| 'Register  "R2020 Advances from customer"'       | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                              |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''        | 'Attributes'             | ''                              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                               | 'Receipt'       | '23.06.2022 19:41:15'   | '17,12'       | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                              |
			| ''                                               | 'Receipt'       | '23.06.2022 19:41:15'   | '100'         | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                              |
			| ''                                               | 'Receipt'       | '23.06.2022 19:41:15'   | '100'         | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                              |
	And I close all client application windows

Scenario: _0434282 check Bank receipt movements by the Register "R3010 Cash on hand" (Payment from customer by POS, without bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 520'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15'   | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                                       | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'                                | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Receipt'       | '23.06.2022 19:41:15'   | '17,12'       | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Receipt'       | '23.06.2022 19:41:15'   | '100'         | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Receipt'       | '23.06.2022 19:41:15'   | '100'         | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                               | 'Expense'       | '23.06.2022 19:41:15'   | '1,71'        | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Expense'       | '23.06.2022 19:41:15'   | '10'          | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Expense'       | '23.06.2022 19:41:15'   | '10'          | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows		
			


Scenario: _0434284 check Bank receipt movements by the Register "R3050 Pos cash balances" (Payment from customer by POS, without bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 520'     |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15' | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| 'Document registrations records'               | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| 'Register  "R3050 Pos cash balances"'          | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| ''                                             | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''                        | ''                                     | ''             | ''                    |
			| ''                                             | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'                  | 'Account'                              | 'Payment type' | 'Payment terminal'    |
			| ''                                             | '23.06.2022 19:41:15' | '100'       | '10'         | 'Main Company' | 'Distribution department' | 'POS account, Comission separate, TRY' | 'Card 01'      | 'Payment terminal 01' |
		And I close all client application windows



Scenario: _0434285 check Bank receipt movements by the Register "R5010 Reconciliation statement" (Payment from customer by POS, without bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 520'     |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'     | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                    | ''                       |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                               | 'Expense'       | '23.06.2022 19:41:15'   | '100'         | 'Main Company'   | 'Distribution department'   | 'TRY'        | 'Company Ferron BP'   | ''                       |
		And I close all client application windows
		
Scenario: _0434286 check Bank receipt movements by the Register "R2021 Customer transactions" (Payment from customer by POS, with bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 519'     |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''                       | ''                              |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'        | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''                       | ''                              |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | 'Attributes'             | ''                              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                       | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '17,12'       | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''        | 'No'                     | ''                              |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''        | 'No'                     | ''                              |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''        | 'No'                     | ''                              |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''        | 'No'                     | ''                              |
		And I close all client application windows

Scenario: _0434287 check Bank receipt movements by the Register "R3010 Cash on hand" (Payment from customer by POS, with bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 519'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08'   | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                                       | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'                                | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Receipt'       | '23.06.2022 17:50:08'   | '17,12'       | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Receipt'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Receipt'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '1,71'        | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '10'          | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '10'          | 'Main Company'   | 'Distribution department'   | 'POS account, Comission separate, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows
		

Scenario: _0434289 check Bank receipt movements by the Register "R3050 Pos cash balances" (Payment from customer by POS, with bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 519'     |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button		
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08' | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| 'Document registrations records'               | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| 'Register  "R3050 Pos cash balances"'          | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| ''                                             | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''                        | ''                                     | ''             | ''                    |
			| ''                                             | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'                  | 'Account'                              | 'Payment type' | 'Payment terminal'    |
			| ''                                             | '23.06.2022 17:50:08' | '100'       | '10'         | 'Main Company' | 'Distribution department' | 'POS account, Comission separate, TRY' | 'Card 01'      | 'Payment terminal 01' |
		And I close all client application windows
		
Scenario: _0434290 check Bank receipt movements by the Register "R5010 Reconciliation statement" (Payment from customer by POS, with bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 519'     |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'     | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                    | ''                       |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                    | ''                       |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'TRY'        | 'Company Ferron BP'   | ''                       |
		And I close all client application windows

		
		
					
Scenario: _0434291 check Bank receipt movements by the Register "R3010 Cash on hand" (Transfer from POS, comission is separate true)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 521'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 521 dated 24.06.2022 15:19:35'   | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Receipt'       | '24.06.2022 15:19:35'   | '17,12'       | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Receipt'       | '24.06.2022 15:19:35'   | '100'         | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Receipt'       | '24.06.2022 15:19:35'   | '100'         | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows				
						
Scenario: _0434292 check Bank receipt movements by the Register "R3021 Cash in transit (incoming)" (Transfer from POS, comission is separate true)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 521'     |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 521 dated 24.06.2022 15:19:35' | ''            | ''                    | ''          | ''           | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''                        | ''                  | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'                  | 'Account'           | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:35' | '18,83'     | '1,71'       | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:35' | '110'       | '10'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:35' | '110'       | '10'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
		And I close all client application windows

Scenario: _04342921 check Bank receipt movements by the Register  "R3011 Cash flow" (Transfer from POS, comission is separate true)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 521'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 521 dated 24.06.2022 15:19:35' | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Direction' | 'Financial movement type' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '24.06.2022 15:19:35' | '17,12'     | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '24.06.2022 15:19:35' | '100'       | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '24.06.2022 15:19:35' | '100'       | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _04342922 check Bank receipt movements by the Register  "R5022 Expenses" (Transfer from POS, comission is separate true)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 521'     |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 521 dated 24.06.2022 15:19:35' | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''                          |
			| 'Document registrations records'               | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''                          |
			| 'Register  "R5022 Expenses"'                   | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''                          |
			| ''                                             | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | 'Attributes'                |
			| ''                                             | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'                  | 'Profit loss center' | 'Expense type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Calculation movement cost' |
			| ''                                             | '24.06.2022 15:19:35' | '1,71'      | '1,71'              | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''                          |
			| ''                                             | '24.06.2022 15:19:35' | '10'        | '10'                | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''                          |
			| ''                                             | '24.06.2022 15:19:35' | '10'        | '10'                | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''                          |		
		And I close all client application windows

Scenario: _0434293 check Bank receipt movements by the Register "R3021 Cash in transit (incoming)" (Transfer from POS, comission is separate false)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 522'     |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''            | ''                    | ''          | ''           | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''                        | ''                  | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'                  | 'Account'           | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:39' | '8,56'      | '0,86'       | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:39' | '50'        | '5'          | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:39' | '50'        | '5'          | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
		And I close all client application windows
		
Scenario: _0434294 check Bank receipt movements by the Register "R3010 Cash on hand" (Transfer from POS, comission is separate false)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 522'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39'   | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Receipt'       | '24.06.2022 15:19:39'   | '8,56'        | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Receipt'       | '24.06.2022 15:19:39'   | '50'          | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Receipt'       | '24.06.2022 15:19:39'   | '50'          | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                               | 'Expense'       | '24.06.2022 15:19:39'   | '0,86'        | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Expense'       | '24.06.2022 15:19:39'   | '5'           | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Expense'       | '24.06.2022 15:19:39'   | '5'           | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows	
		
Scenario: _04342941 check Bank receipt movements by the Register  "R3011 Cash flow" (Transfer from POS, comission is separate false)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 522'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''          | ''                        | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Direction' | 'Financial movement type' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '24.06.2022 15:19:39' | '0,86'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '8,56'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '50'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '50'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |	
	And I close all client application windows	

Scenario: _04342942 check Bank receipt movements by the Register  "R5022 Expenses" (Transfer from POS, comission is separate false)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 522'     |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''                          |
			| 'Document registrations records'               | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''                          |
			| 'Register  "R5022 Expenses"'                   | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''                          |
			| ''                                             | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''                        | ''                   | ''             | ''         | ''         | ''                    | ''                             | 'Attributes'                |
			| ''                                             | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'                  | 'Profit loss center' | 'Expense type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Calculation movement cost' |
			| ''                                             | '24.06.2022 15:19:39' | '0,86'      | '0,86'              | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''                          |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | '5'                 | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''                          |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | '5'                 | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''                          |	
	And I close all client application windows	
		

Scenario: _0434295 check Bank receipt movements by the Register  "R2023 Advances from retail customers" (advance from retail customer)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
	* Check movements by the Register  "R2023 Advances from retail customers" 
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 10 dated 29.12.2022 15:11:54'          | ''              | ''                      | ''            | ''               | ''          | ''                   |
			| 'Document registrations records'                     | ''              | ''                      | ''            | ''               | ''          | ''                   |
			| 'Register  "R2023 Advances from retail customers"'   | ''              | ''                      | ''            | ''               | ''          | ''                   |
			| ''                                                   | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''                   |
			| ''                                                   | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Retail customer'    |
			| ''                                                   | 'Receipt'       | '29.12.2022 15:11:54'   | '100'         | 'Main Company'   | 'Shop 02'   | 'Sam Jons'           |
	And I close all client application windows	

Scenario: _0434296 check Bank receipt movements by the Register  "R3010 Cash on hand" (advance from retail customer)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 10 dated 29.12.2022 15:11:54'   | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'              | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                            | 'Receipt'       | '29.12.2022 15:11:54'   | '17,12'       | 'Main Company'   | 'Shop 02'   | 'Transit Main'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '29.12.2022 15:11:54'   | '100'         | 'Main Company'   | 'Shop 02'   | 'Transit Main'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '29.12.2022 15:11:54'   | '100'         | 'Main Company'   | 'Shop 02'   | 'Transit Main'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _0434297 check Bank receipt movements by the Register  "R3050 Pos cash balances" (advance from retail customer)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 10 dated 29.12.2022 15:11:54' | ''                    | ''          | ''           | ''             | ''        | ''             | ''             | ''                 |
			| 'Document registrations records'            | ''                    | ''          | ''           | ''             | ''        | ''             | ''             | ''                 |
			| 'Register  "R3050 Pos cash balances"'       | ''                    | ''          | ''           | ''             | ''        | ''             | ''             | ''                 |
			| ''                                          | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''        | ''             | ''             | ''                 |
			| ''                                          | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'  | 'Account'      | 'Payment type' | 'Payment terminal' |
			| ''                                          | '29.12.2022 15:11:54' | '100'       | ''           | 'Main Company' | 'Shop 02' | 'Transit Main' | 'Card 01'      | ''                 |
	And I close all client application windows

Scenario: _0434298 check Bank receipt movements by the Register  "R3026 Sales orders customer advance" (advance from retail customer, sales order)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R3026 Sales orders customer advance" 
		And I click "Registrations report" button
		And I select "R3026 Sales orders customer advance" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 314 dated 09.01.2023 13:12:24'        | ''              | ''                      | ''            | ''             | ''               | ''         | ''                    | ''           | ''                  | ''                                            | ''                    | ''               | ''                   | ''             |
			| 'Document registrations records'                    | ''              | ''                      | ''            | ''             | ''               | ''         | ''                    | ''           | ''                  | ''                                            | ''                    | ''               | ''                   | ''             |
			| 'Register  "R3026 Sales orders customer advance"'   | ''              | ''                      | ''            | ''             | ''               | ''         | ''                    | ''           | ''                  | ''                                            | ''                    | ''               | ''                   | ''             |
			| ''                                                  | 'Record type'   | 'Period'                | 'Resources'   | ''             | 'Dimensions'     | ''         | ''                    | ''           | ''                  | ''                                            | ''                    | ''               | ''                   | ''             |
			| ''                                                  | ''              | ''                      | 'Amount'      | 'Commission'   | 'Company'        | 'Branch'   | 'Payment type enum'   | 'Currency'   | 'Retail customer'   | 'Order'                                       | 'Account'             | 'Payment type'   | 'Payment terminal'   | 'Bank term'    |
			| ''                                                  | 'Expense'       | '09.01.2023 13:12:24'   | '1 000'       | '20'           | 'Main Company'   | ''         | 'Card'                | 'TRY'        | 'Sam Jons'          | 'Sales order 314 dated 09.01.2023 12:49:08'   | 'Bank account, TRY'   | 'Card 02'        | ''                   | 'Test01'       |
	And I close all client application windows

Scenario: _0434299 check Bank receipt movements by the Register  "R3010 Cash on hand" (Other partner)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '51'        |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 51 dated 12.06.2023 15:25:57'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'              | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                            | 'Receipt'       | '12.06.2023 15:25:57'   | '8,56'        | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _0434300 check Bank receipt movements by the Register  "R3011 Cash flow" (Other partner)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '51'        |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 51 dated 12.06.2023 15:25:57'   | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| 'Document registrations records'              | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| 'Register  "R3011 Cash flow"'                 | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| ''                                            | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | 'Attributes'              |
			| ''                                            | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Direction'   | 'Financial movement type'   | 'Planning period'   | 'Currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                            | '12.06.2023 15:25:57'   | '8,56'        | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | ''                  | 'USD'        | 'Reporting currency'             | 'No'                      |
			| ''                                            | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | ''                  | 'TRY'        | 'Local currency'                 | 'No'                      |
			| ''                                            | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | ''                  | 'TRY'        | 'TRY'                            | 'No'                      |
			| ''                                            | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | ''                  | 'TRY'        | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _0434301 check Bank receipt movements by the Register  "R5010 Reconciliation statement" (Other partner)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '51'        |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 51 dated 12.06.2023 15:25:57'    | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                  | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'        | 'Legal name contract'    |
			| ''                                             | 'Expense'       | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'TRY'        | 'Other partner 2'   | ''                       |
	And I close all client application windows

Scenario: _0434302 check Bank receipt movements by the Register  "R5015 Other partners transactions" (Other partner)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '51'        |
	* Check movements by the Register  "R5015 Other partners transactions" 
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 51 dated 12.06.2023 15:25:57'       | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| 'Register  "R5015 Other partners transactions"'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | 'Attributes'              |
			| ''                                                | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'           | 'Agreement'         | 'Basis'             | 'Deferred calculation'    |
			| ''                                                | 'Expense'       | '12.06.2023 15:25:57'   | '8,56'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
			| ''                                                | 'Expense'       | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
			| ''                                                | 'Expense'       | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
			| ''                                                | 'Expense'       | '12.06.2023 15:25:57'   | '50'          | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
	And I close all client application windows

Scenario: _043430 Bank receipt clear posting/mark for deletion
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 2 dated 05.04.2021 14:27:40'    |
			| 'Document registrations records'              |
		And I close current window
	* Post Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
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
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
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
			| 'Bank receipt 2 dated 05.04.2021 14:27:40'    |
			| 'Document registrations records'              |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
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

Scenario: _0434299 check Bank receipt movements by the Register  "R3011 Cash flow"
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '513'       |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 513 dated 04.06.2021 12:27:04'   | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| 'Document registrations records'               | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| 'Register  "R3011 Cash flow"'                  | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| ''                                             | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | 'Attributes'              |
			| ''                                             | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Direction'   | 'Financial movement type'   | 'Planning period'   | 'Currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | '04.06.2021 12:27:04'   | '68,48'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | 'First'             | 'USD'        | 'Reporting currency'             | 'No'                      |
			| ''                                             | '04.06.2021 12:27:04'   | '102,72'      | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | 'First'             | 'USD'        | 'Reporting currency'             | 'No'                      |
			| ''                                             | '04.06.2021 12:27:04'   | '400'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | 'First'             | 'TRY'        | 'Local currency'                 | 'No'                      |
			| ''                                             | '04.06.2021 12:27:04'   | '400'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | 'First'             | 'TRY'        | 'en description is empty'        | 'No'                      |
			| ''                                             | '04.06.2021 12:27:04'   | '600'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | 'First'             | 'TRY'        | 'Local currency'                 | 'No'                      |
			| ''                                             | '04.06.2021 12:27:04'   | '600'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | 'First'             | 'TRY'        | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _0434303 check Bank receipt movements by the Register  "R3010 Cash on hand" (Other income)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 525'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 525 dated 12.06.2023 17:31:38'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Receipt'       | '12.06.2023 17:31:38'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Receipt'       | '12.06.2023 17:31:38'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Receipt'       | '12.06.2023 17:31:38'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _0434304 check Bank receipt movements by the Register  "R3011 Cash flow" (Other income)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 525'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 525 dated 12.06.2023 17:31:38'   | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| 'Document registrations records'                 | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| 'Register  "R3011 Cash flow"'                    | ''                      | ''            | ''               | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | ''                        |
			| ''                                               | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''            | ''                          | ''                  | ''           | ''                               | 'Attributes'              |
			| ''                                               | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Direction'   | 'Financial movement type'   | 'Planning period'   | 'Currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | '12.06.2023 17:31:38'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | ''                  | 'USD'        | 'Reporting currency'             | 'No'                      |
			| ''                                               | '12.06.2023 17:31:38'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | ''                  | 'TRY'        | 'Local currency'                 | 'No'                      |
			| ''                                               | '12.06.2023 17:31:38'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'Incoming'    | 'Movement type 1'           | ''                  | 'TRY'        | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _0434305 check Bank receipt movements by the Register  "R5021 Revenues" (Other income)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 525'     |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 525 dated 12.06.2023 17:31:38'   | ''                      | ''            | ''                    | ''               | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                                |
			| 'Document registrations records'                 | ''                      | ''            | ''                    | ''               | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                                |
			| 'Register  "R5021 Revenues"'                     | ''                      | ''            | ''                    | ''               | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                                |
			| ''                                               | 'Period'                | 'Resources'   | ''                    | 'Dimensions'     | ''               | ''                     | ''               | ''           | ''           | ''                      | ''                                |
			| ''                                               | ''                      | 'Amount'      | 'Amount with taxes'   | 'Company'        | 'Branch'         | 'Profit loss center'   | 'Revenue type'   | 'Item key'   | 'Currency'   | 'Additional analytic'   | 'Multi currency movement type'    |
			| ''                                               | '12.06.2023 17:31:38'   | '17,12'       | '17,12'               | 'Main Company'   | 'Front office'   | ''                     | 'Revenue'        | ''           | 'USD'        | ''                      | 'Reporting currency'              |
			| ''                                               | '12.06.2023 17:31:38'   | '100'         | '100'                 | 'Main Company'   | 'Front office'   | ''                     | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  |
			| ''                                               | '12.06.2023 17:31:38'   | '100'         | '100'                 | 'Main Company'   | 'Front office'   | ''                     | 'Revenue'        | ''           | 'TRY'        | ''                      | 'en description is empty'         |
	And I close all client application windows

Scenario: _0434306 check Bank receipt movements by the Register  "R3010 Cash on hand" (cash transfer without CTO)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '331'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 331 dated 03.07.2023 14:20:56' | ''            | ''                    | ''          | ''             | ''             | ''                    | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''                    | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''             | ''                    | ''         | ''                     | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Receipt'     | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'TRY'      | 'EUR'                  | 'Local currency'               | 'No'                   |
			| ''                                           | 'Receipt'     | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'USD'      | 'EUR'                  | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Receipt'     | '03.07.2023 14:20:56' | '1 000'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'EUR'      | 'EUR'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434307 check Bank receipt movements by the Register  "R3011 Cash flow" (cash transfer without CTO)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '331'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 331 dated 03.07.2023 14:20:56' | ''                    | ''          | ''             | ''             | ''                    | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                    | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''             | ''                    | ''          | ''                        | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''          | ''                        | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Direction' | 'Financial movement type' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Incoming'  | 'Movement type 1'         | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Incoming'  | 'Movement type 1'         | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '03.07.2023 14:20:56' | '1 000'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Incoming'  | 'Movement type 1'         | ''                | 'EUR'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434308 check Bank receipt movements by the Register  "R3021 Cash in transit (incoming)" (cash transfer without CTO)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '331'     |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 331 dated 03.07.2023 14:20:56'   | ''            | ''                    | ''          | ''           | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''           | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''             | ''                    | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'       | 'Account'             | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '03.07.2023 14:20:56' | ''          | ''           | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Local currency'               | 'TRY'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '03.07.2023 14:20:56' | ''          | ''           | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Reporting currency'           | 'USD'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '03.07.2023 14:20:56' | '1 000'     | ''           | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'en description is empty'      | 'EUR'      | 'EUR'                  | ''      | 'No'                   |		
	And I close all client application windows