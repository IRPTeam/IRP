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
	When set True value to the constant Use salary
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
		When Create catalog SerialLotNumbers objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog CashAccounts objects
		When Create catalog PlanningPeriods objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
		When Create OtherPartners objects
		When Create information register Taxes records (VAT)
		When Create catalog CashStatementStatuses objects (Test)
		When Create catalog BankTerms objects
		When Create catalog BankTerms objects (for Shop 02)
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
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (check cash planning, cash transfer order and OPO)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
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
		When create BankReceipt (Transfer from POS with Planning transaction basis)
		And I execute 1C:Enterprise script at server
			| "Documents.CashStatement.FindByNumber(114).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashStatement.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1528).GetObject().Write(DocumentWriteMode.Posting);"    |
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
		When Create document PurchaseReturn objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseReturn.FindByNumber(21).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseReturn.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (Return from vendor)
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
		When create BankReceipt (Other partner)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1527).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create BankReceipt (Customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1526).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create BankReceipt (Salary return)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1529).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1530).GetObject().Write(DocumentWriteMode.Posting);"    |
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
			| 'Bank receipt 1 dated 07.09.2020 19:14:59'   | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'    | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | ''                       | ''                              |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                       | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                           | 'Expense'       | '07.09.2020 19:14:59'   | '17,12'       | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                           | 'Expense'       | '07.09.2020 19:14:59'   | '100'         | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                           | 'Expense'       | '07.09.2020 19:14:59'   | '100'         | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''        | ''        | 'No'                     | ''                              |
		
	And I close all client application windows
	


Scenario: _043412 check Bank receipt movements by the Register "R2020 Advances from customer" (without basis document)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report info" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 5 dated 15.04.2021 10:21:22' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                 | ''         | ''      | ''                         | ''        | ''         | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                 | ''         | ''      | ''                         | ''        | ''         | ''                     | ''                           |
			| ''                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'       | 'Partner'  | 'Order' | 'Agreement'                | 'Project' | 'Amount'   | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                         | '15.04.2021 10:21:22' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '54 800'   | 'No'                   | ''                           |
			| ''                                         | '15.04.2021 10:21:22' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '9 381,76' | 'No'                   | ''                           |
			| ''                                         | '15.04.2021 10:21:22' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '54 800'   | 'No'                   | ''                           |		
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
			| ''                                           | '04.06.2021 12:29:34' | '-1 665'    | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:29:34' | '-203,5'    | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '04.06.2021 12:29:34' | '-185'      | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
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
			| 'Bank receipt 517 dated 08.02.2022 12:44:01'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'       | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | ''        | ''                       | ''                            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                     | ''                                               | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'      | 'Partner'   | 'Agreement'            | 'Basis'                                          | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                             | 'Expense'       | '08.02.2022 12:44:01'   | '-50'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'   | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                             | 'Expense'       | '08.02.2022 12:44:01'   | '-50'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'   | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                             | 'Expense'       | '08.02.2022 12:44:01'   | '-8,56'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'   | 'Purchase return 21 dated 28.04.2021 21:50:02'   | ''        | ''        | 'No'                     | ''                            |
	And I close all client application windows


Scenario: _043427 check Bank receipt movements by the Register "R2020 Advances from customer" (with partner term by document, without basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '518'       |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report info" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 518 dated 08.02.2022 13:39:01' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'   | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| ''                                           | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'                | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                           | '08.02.2022 13:39:01' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '50'     | 'No'                   | ''                           |
			| ''                                           | '08.02.2022 13:39:01' | 'Receipt'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '8,56'   | 'No'                   | ''                           |
			| ''                                           | '08.02.2022 13:39:01' | 'Receipt'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '50'     | 'No'                   | ''                           |		
	And I close all client application windows


Scenario: _0434281 check Bank receipt movements by the Register "R2020 Advances from customer" (Payment from customer by POS, without bases)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 520'     |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report info" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'     | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'                | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                             | '23.06.2022 19:41:15' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '100'    | 'No'                   | ''                           |
			| ''                                             | '23.06.2022 19:41:15' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '17,12'  | 'No'                   | ''                           |
			| ''                                             | '23.06.2022 19:41:15' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '100'    | 'No'                   | ''                           |				
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
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15' | ''            | ''                    | ''          | ''             | ''                        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''            | ''                    | ''          | ''             | ''                        | ''                   | ''         | ''                     | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                   | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'            | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '23.06.2022 19:41:15' | '17,12'     | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '23.06.2022 19:41:15' | '100'       | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '23.06.2022 19:41:15' | '100'       | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
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
			| ''                                             | '23.06.2022 19:41:15' | '100'       | '10'         | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Card 01'      | 'Payment terminal 01' |
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
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'        | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | ''                       | ''                              |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                       | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '17,12'       | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                               | 'Expense'       | '23.06.2022 17:50:08'   | '100'         | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 3 dated 28.01.2021 18:50:57'   | ''        | ''        | 'No'                     | ''                              |
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
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08' | ''            | ''                    | ''          | ''             | ''                        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                        | ''                   | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''            | ''                    | ''          | ''             | ''                        | ''                   | ''         | ''                     | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                   | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'            | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '23.06.2022 17:50:08' | '17,12'     | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '23.06.2022 17:50:08' | '100'       | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '23.06.2022 17:50:08' | '100'       | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
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
			| ''                                             | '23.06.2022 17:50:08' | '100'       | '10'         | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Card 01'      | 'Payment terminal 01' |
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


		
Scenario: _04342941 check Bank receipt movements by the Register  "R3011 Cash flow" (Transfer from POS, with comission)
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
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center'        | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '24.06.2022 15:19:39' | '0,86'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Distribution department' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Distribution department' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Distribution department' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '9,42'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Distribution department' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '55'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Distribution department' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '55'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Distribution department' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows	

Scenario: _04342942 check Bank receipt movements by the Register  "R5022 Expenses" (Transfer from POS with comission)
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
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Document registrations records'               | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Register  "R5022 Expenses"'                   | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| ''                                             | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | 'Attributes'                |
			| ''                                             | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'                  | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Calculation movement cost' |
			| ''                                             | '24.06.2022 15:19:39' | '0,86'      | '0,86'              | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | ''                          |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | '5'                 | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | ''                          |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | '5'                 | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | ''                          |
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
			| 'Bank receipt 51 dated 12.06.2023 15:25:57' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'            | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'               | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                          | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                          | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                          | '12.06.2023 15:25:57' | '8,56'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '12.06.2023 15:25:57' | '50'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '12.06.2023 15:25:57' | '50'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
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
			| 'Bank receipt 513 dated 04.06.2021 12:27:04' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '04.06.2021 12:27:04' | '68,48'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | 'First'           | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '102,72'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | 'First'           | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '400'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | 'First'           | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '400'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | 'First'           | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '600'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | 'First'           | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '04.06.2021 12:27:04' | '600'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | 'First'           | 'TRY'      | 'en description is empty'      | 'No'                   |	
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
			| 'Bank receipt 1 525 dated 12.06.2023 17:31:38' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '12.06.2023 17:31:38' | '17,12'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '12.06.2023 17:31:38' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '12.06.2023 17:31:38' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
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
			| 'Bank receipt 1 525 dated 12.06.2023 17:31:38' | ''                    | ''          | ''                  | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Document registrations records'               | ''                    | ''          | ''                  | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Register  "R5021 Revenues"'                   | ''                    | ''          | ''                  | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                             | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                             | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'       | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' |
			| ''                                             | '12.06.2023 17:31:38' | '17,12'     | '17,12'             | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                             | '12.06.2023 17:31:38' | '100'       | '100'               | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                             | '12.06.2023 17:31:38' | '100'       | '100'               | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        |
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
			| 'Bank receipt 331 dated 03.07.2023 14:20:56' | ''                    | ''          | ''             | ''             | ''                    | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                    | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''             | ''                    | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '03.07.2023 14:20:56' | '1 000'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'EUR'      | 'en description is empty'      | 'No'                   |		
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
			| 'Bank receipt 331 dated 03.07.2023 14:20:56'   | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Local currency'               | 'TRY'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '03.07.2023 14:20:56' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Reporting currency'           | 'USD'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '03.07.2023 14:20:56' | '1 000'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'en description is empty'      | 'EUR'      | 'EUR'                  | ''      | 'No'                   |		
	And I close all client application windows

Scenario: _0434309 check absence Bank receipt movements by the Register "R5022 Expenses" (Payment from customer by POS, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 520'     |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5022 Expenses'    |
		And I close all client application windows

Scenario: _0434310 check Bank receipt movements by the Register  "R3011 Cash flow" (Payment from customer by POS, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 520'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15' | ''                    | ''          | ''             | ''                        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''                        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''                        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'            | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '23.06.2022 19:41:15' | '1,71'      | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '23.06.2022 19:41:15' | '10'        | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '23.06.2022 19:41:15' | '10'        | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '23.06.2022 19:41:15' | '18,83'     | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '23.06.2022 19:41:15' | '110'       | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '23.06.2022 19:41:15' | '110'       | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |	
	And I close all client application windows

Scenario: _0434310 check Bank receipt movements by the Register  "R2021 Customer transactions" (Payment from customer by POS, with bank comission)
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
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''      | ''        | ''                     | ''                           |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''      | ''        | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'      | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''      | ''        | ''                     | ''                           |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''      | ''        | 'Attributes'           | ''                           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Order' | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                             | 'Expense'     | '23.06.2022 17:50:08' | '17,12'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''      | ''        | 'No'                   | ''                           |
			| ''                                             | 'Expense'     | '23.06.2022 17:50:08' | '100'       | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''      | ''        | 'No'                   | ''                           |
			| ''                                             | 'Expense'     | '23.06.2022 17:50:08' | '100'       | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''      | ''        | 'No'                   | ''                           |		
	And I close all client application windows

Scenario: _0434314 check Bank receipt movements by the Register "R3010 Cash on hand" (Currency exchange, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '514'       |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 514 dated 04.06.2021 12:29:34' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Receipt'     | '04.06.2021 12:29:34' | '180'       | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'EUR'      | 'EUR'                  | 'en description is empty'      | 'No'                   |
			| ''                                           | 'Receipt'     | '04.06.2021 12:29:34' | '198'       | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'USD'      | 'EUR'                  | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Receipt'     | '04.06.2021 12:29:34' | '1 620'     | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'TRY'      | 'EUR'                  | 'Local currency'               | 'No'                   |		
	And I close all client application windows


Scenario: _0434315 check Bank receipt movements by the Register "R5022 Expenses" (Currency exchange, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '514'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 514 dated 04.06.2021 12:29:34' | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Document registrations records'             | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Register  "R5022 Expenses"'                 | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| ''                                           | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | 'Attributes'                |
			| ''                                           | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Calculation movement cost' |
			| ''                                           | '04.06.2021 12:29:34' | '5'         | '5'                 | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'en description is empty'      | ''        | ''                          |
			| ''                                           | '04.06.2021 12:29:34' | '5,5'       | '5,5'               | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | ''                          |
			| ''                                           | '04.06.2021 12:29:34' | '45'        | '45'                | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | ''                          |		
	And I close all client application windows

Scenario: _0434316 check Bank receipt movements by the Register "R5022 Expenses" (Currency exchange, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '514'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 514 dated 04.06.2021 12:29:34' | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Document registrations records'             | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Register  "R5022 Expenses"'                 | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| ''                                           | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | 'Attributes'                |
			| ''                                           | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Calculation movement cost' |
			| ''                                           | '04.06.2021 12:29:34' | '5'         | '5'                 | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'en description is empty'      | ''        | ''                          |
			| ''                                           | '04.06.2021 12:29:34' | '5,5'       | '5,5'               | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | ''                          |
			| ''                                           | '04.06.2021 12:29:34' | '45'        | '45'                | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | ''                          |		
	And I close all client application windows


Scenario: _0434320 check Bank receipt movements by the Register "R3010 Cash on hand" (Cash transfer order, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '515'       |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 515 dated 04.06.2021 12:30:23' | ''            | ''                    | ''          | ''             | ''             | ''                    | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''                    | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''             | ''                    | ''         | ''                     | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Receipt'     | '04.06.2021 12:30:23' | '498'       | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'EUR'      | 'EUR'                  | 'en description is empty'      | 'No'                   |
			| ''                                           | 'Receipt'     | '04.06.2021 12:30:23' | '547,8'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'USD'      | 'EUR'                  | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Receipt'     | '04.06.2021 12:30:23' | '4 482'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'TRY'      | 'EUR'                  | 'Local currency'               | 'No'                   |		
	And I close all client application windows

Scenario: _0434321 check Bank receipt movements by the Register "R3021 Cash in transit (incoming)" (Cash transfer order, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '515'       |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 515 dated 04.06.2021 12:30:23'   | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''                                                | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''                                                | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''                                                | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''                             | ''         | ''                     | ''                                                | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                           | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '04.06.2021 12:30:23' | '500'       | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'en description is empty'      | 'EUR'      | 'EUR'                  | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'No'                   |
			| ''                                             | 'Expense'     | '04.06.2021 12:30:23' | '550'       | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Reporting currency'           | 'USD'      | 'EUR'                  | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'No'                   |
			| ''                                             | 'Expense'     | '04.06.2021 12:30:23' | '4 500'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Local currency'               | 'TRY'      | 'EUR'                  | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'No'                   |		
	And I close all client application windows

Scenario: _0434326 check Bank receipt movements by the Register "R3010 Cash on hand" (Transfer from POS, with bank comission)
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
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '24.06.2022 15:19:39' | '8,56'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '24.06.2022 15:19:39' | '50'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '24.06.2022 15:19:39' | '50'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
	And I close all client application windows

Scenario: _0434327 check Bank receipt movements by the Register "R3011 Cash flow" (Transfer from POS, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 522'       |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center'        | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '24.06.2022 15:19:39' | '0,86'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Distribution department' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Distribution department' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Distribution department' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '9,42'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Distribution department' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '55'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Distribution department' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '24.06.2022 15:19:39' | '55'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Distribution department' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434328 check Bank receipt movements by the Register "R5022 Expenses" (Transfer from POS, with bank comission)
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
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Document registrations records'               | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Register  "R5022 Expenses"'                   | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| ''                                             | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | 'Attributes'                |
			| ''                                             | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'                  | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Calculation movement cost' |
			| ''                                             | '24.06.2022 15:19:39' | '0,86'      | '0,86'              | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | ''                          |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | '5'                 | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | ''                          |
			| ''                                             | '24.06.2022 15:19:39' | '5'         | '5'                 | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | ''                          |		
	And I close all client application windows

Scenario: _0434329 check Bank receipt movements by the Register "R3021 Cash in transit (incoming)" (Transfer from POS, with bank comission)
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
			| 'Bank receipt 1 522 dated 24.06.2022 15:19:39' | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:39' | '9,42'      | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:39' | '55'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Expense'     | '24.06.2022 15:19:39' | '55'        | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | ''      | 'No'                   |		
	And I close all client application windows

Scenario: _0434332 check Bank receipt movements by the Register "R3010 Cash on hand" (Customer advance, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 526'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 526 dated 05.03.2024 16:17:01' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '05.03.2024 16:17:01' | '17,12'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '05.03.2024 16:17:01' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '05.03.2024 16:17:01' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434333 check Bank receipt movements by the Register "R3010 Cash on hand" (Customer advance, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 526'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 526 dated 05.03.2024 16:17:01' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '05.03.2024 16:17:01' | '17,12'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '05.03.2024 16:17:01' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '05.03.2024 16:17:01' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434334 check Bank receipt movements by the Register "R2023 Advances from retail customers" (Customer advance, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 526'     |
	* Check movements by the Register  "R2023 Advances from retail customers" 
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 526 dated 05.03.2024 16:17:01'     | ''            | ''                    | ''          | ''             | ''             | ''                       |
			| 'Document registrations records'                   | ''            | ''                    | ''          | ''             | ''             | ''                       |
			| 'Register  "R2023 Advances from retail customers"' | ''            | ''                    | ''          | ''             | ''             | ''                       |
			| ''                                                 | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                       |
			| ''                                                 | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Retail customer'        |
			| ''                                                 | 'Receipt'     | '05.03.2024 16:17:01' | '100'       | 'Main Company' | 'Front office' | 'Retail customer Second' |		
	And I close all client application windows



Scenario: _0434335 check Bank receipt movements by the Register "R3011 Cash flow" (Customer advance, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 526'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 526 dated 05.03.2024 16:17:01' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '05.03.2024 16:17:01' | '17,12'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '05.03.2024 16:17:01' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '05.03.2024 16:17:01' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434340 check Bank receipt movements by the Register "R3010 Cash on hand" (Other partner, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 527'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 527 dated 05.03.2024 16:24:49' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '05.03.2024 16:24:49' | '8,56'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '05.03.2024 16:24:49' | '50'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '05.03.2024 16:24:49' | '50'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434341 check Bank receipt movements by the Register "R3011 Cash flow" (Other partner, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 527'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 527 dated 05.03.2024 16:24:49' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '05.03.2024 16:24:49' | '0,86'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '05.03.2024 16:24:49' | '5'         | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '05.03.2024 16:24:49' | '5'         | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '05.03.2024 16:24:49' | '9,42'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '05.03.2024 16:24:49' | '55'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '05.03.2024 16:24:49' | '55'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434342 check Bank receipt movements by the Register "R5022 Expenses" (Other partner, with bank comission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 527'     |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 527 dated 05.03.2024 16:24:49' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                   | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                             | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                             | '05.03.2024 16:24:49' | 'Main Company' | 'Front office' | 'Front office'       | 'Rent'         | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '5'      | '5'                 | ''            | ''                          |
			| ''                                             | '05.03.2024 16:24:49' | 'Main Company' | 'Front office' | 'Front office'       | 'Rent'         | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '5'      | '5'                 | ''            | ''                          |
			| ''                                             | '05.03.2024 16:24:49' | 'Main Company' | 'Front office' | 'Front office'       | 'Rent'         | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '0,86'   | '0,86'              | ''            | ''                          |		
	And I close all client application windows


Scenario: _0434344 check Bank receipt movements by the Register "R3010 Cash on hand" (Transfer from POS, with basis documents, 2 lines + commission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 528'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 528 dated 09.07.2022 10:44:39' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '09.07.2022 10:44:39' | '25,17'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '09.07.2022 10:44:39' | '33,56'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Receipt'     | '09.07.2022 10:44:39' | '147'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '09.07.2022 10:44:39' | '147'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
			| ''                                             | 'Receipt'     | '09.07.2022 10:44:39' | '196'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                             | 'Receipt'     | '09.07.2022 10:44:39' | '196'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434345 check Bank receipt movements by the Register "R3011 Cash flow" (Transfer from POS, with basis documents, 2 lines + commission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 528'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 528 dated 09.07.2022 10:44:39' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '09.07.2022 10:44:39' | '0,34'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '0,51'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '2'         | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '2'         | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '3'         | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '3'         | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 3'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '25,68'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '33,9'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '150'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '150'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '198'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '198'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _0434346 check Bank receipt movements by the Register "Cash in transit" (Transfer from POS, with basis documents, 2 lines + commission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 528'     |
	* Check movements by the Register  "Cash in transit" 
		And I click "Registrations report" button
		And I select "Cash in transit" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 528 dated 09.07.2022 10:44:39' | ''            | ''                    | ''          | ''             | ''                                             | ''                   | ''                  | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                                             | ''                   | ''                  | ''         | ''                             | ''                     |
			| 'Register  "Cash in transit"'                  | ''            | ''                    | ''          | ''             | ''                                             | ''                   | ''                  | ''         | ''                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                             | ''                   | ''                  | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Basis document'                               | 'From account'       | 'To account'        | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '25,68'     | 'Main Company' | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'POS account 1, TRY' | 'Bank account, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '33,9'      | 'Main Company' | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'POS account 1, TRY' | 'Bank account, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '150'       | 'Main Company' | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'POS account 1, TRY' | 'Bank account, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '150'       | 'Main Company' | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'POS account 1, TRY' | 'Bank account, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '198'       | 'Main Company' | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'POS account 1, TRY' | 'Bank account, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '198'       | 'Main Company' | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'POS account 1, TRY' | 'Bank account, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows


Scenario: _0434348 check Bank receipt movements by the Register "R3021 Cash in transit (incoming)" (Transfer from POS, with basis documents, 2 lines + commission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 528'     |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 528 dated 09.07.2022 10:44:39' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''                             | ''         | ''                     | ''                                             | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                  | ''                             | ''         | ''                     | ''                                             | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''                             | ''         | ''                     | ''                                             | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''                             | ''         | ''                     | ''                                             | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                        | 'Deferred calculation' |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '25,68'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '33,9'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '150'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '150'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '198'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'No'                   |
			| ''                                             | 'Expense'     | '09.07.2022 10:44:39' | '198'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'No'                   |		
	And I close all client application windows

Scenario: _0434349 check Bank receipt movements by the Register "R3035 Cash planning" (Transfer from POS, with basis documents, 2 lines + commission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 528'     |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 528 dated 09.07.2022 10:44:39' | ''                    | ''          | ''             | ''             | ''                  | ''                                             | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''             | ''                  | ''                                             | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'              | ''                    | ''          | ''             | ''             | ''                  | ''                                             | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''                                             | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Basis document'                               | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                             | '09.07.2022 10:44:39' | '-198'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '-198'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'TRY'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '-150'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '-150'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'TRY'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '-33,9'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash statement 114 dated 07.07.2022 16:33:55' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                             | '09.07.2022 10:44:39' | '-25,68'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash statement 115 dated 08.07.2022 10:47:16' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |		
	And I close all client application windows

Scenario: _0434350 check Bank receipt movements by the Register "R5022 Expenses" (Transfer from POS, with basis documents, 2 lines + commission)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 528'     |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 528 dated 09.07.2022 10:44:39' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                   | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                             | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                             | '09.07.2022 10:44:39' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '2'      | '2'                 | ''            | ''                          |
			| ''                                             | '09.07.2022 10:44:39' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '3'      | '3'                 | ''            | ''                          |
			| ''                                             | '09.07.2022 10:44:39' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '2'      | '2'                 | ''            | ''                          |
			| ''                                             | '09.07.2022 10:44:39' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '3'      | '3'                 | ''            | ''                          |
			| ''                                             | '09.07.2022 10:44:39' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '0,34'   | '0,34'              | ''            | ''                          |
			| ''                                             | '09.07.2022 10:44:39' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '0,51'   | '0,51'              | ''            | ''                          |		
	And I close all client application windows

Scenario: _0434351 check Bank receipt movements by the Register  "T2015 Transactions info" (Payment from customer, advance=false)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1'     |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 dated 07.09.2020 19:14:59' | ''             | ''       | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'      | ''             | ''       | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| ''                                         | 'Company'      | 'Branch' | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                         | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                         | 'Main Company' | ''       | ''      | '07.09.2020 19:14:59' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '*'         | ''        | '100'    | 'No'     | 'Yes'     |	
	And I close all client application windows

Scenario: _0434352 check Bank receipt movements by the Register  "T2014 Advances info" (Payment from customer, advance=true)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '6'     |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 6 dated 21.04.2021 13:09:56' | ''             | ''                        | ''                    | ''    | ''         | ''        | ''                | ''      | ''                  | ''                    | ''          | ''                          | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'          | ''             | ''                        | ''                    | ''    | ''         | ''        | ''                | ''      | ''                  | ''                    | ''          | ''                          | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                         | 'Company'      | 'Branch'                  | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name'      | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'         | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                         | 'Main Company' | 'Distribution department' | '21.04.2021 13:09:56' | '*'   | 'USD'      | 'Kalipso' | 'Company Kalipso' | ''      | 'No'                | 'Yes'                 | '*'         | 'Personal Partner terms, $' | ''        | '25 000' | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0401053 check absence Bank receipt movements by the Register  "T2015 Transactions info" (Payment from customer, advance=true)
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '6'       |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows

Scenario: _0401054 check absence Bank receipt movements by the Register  "T2014 Advances info" (Payment from customer, advance=false)
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1'       |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2014 Advances info"'    |
		And I close all client application windows

Scenario: _0434355 check Bank receipt movements by the Register  "T2015 Transactions info" (Return from vendor, with basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '517'   |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 517 dated 08.02.2022 12:44:01' | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''              | ''                   | ''                      | ''                        | ''                                             | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'        | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''              | ''                   | ''                      | ''                        | ''                                             | ''          | ''        | ''       | ''       | ''        |
			| ''                                           | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name'    | 'Agreement'          | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                            | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                           | 'Main Company' | 'Front office' | ''      | '08.02.2022 12:44:01' | '*'   | 'TRY'      | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim' | 'Yes'                   | 'No'                      | 'Purchase return 21 dated 28.04.2021 21:50:02' | '*'         | ''        | '-50'    | 'No'     | 'Yes'     |
	And I close all client application windows

Scenario: _0401056 check absence Bank receipt movements by the Register  "T2014 Advances info" (Return from vendor, with basis)
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '517'       |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2014 Advances info"'    |
		And I close all client application windows

Scenario: _0434357 check Bank receipt movements by the Register  "T2014 Advances info" (Return from vendor, without basis)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '516'   |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 516 dated 02.09.2021 14:30:07' | ''             | ''             | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                        | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'            | ''             | ''             | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                        | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                           | 'Company'      | 'Branch'       | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'       | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                           | 'Main Company' | 'Front office' | '02.09.2021 14:30:07' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | ''      | 'Yes'               | 'No'                  | '*'         | 'Vendor Ferron, TRY'      | ''        | '-100'   | 'No'                      | 'No'                   | 'Receipt'     |
			| ''                                           | 'Main Company' | 'Front office' | '02.09.2021 14:30:07' | '*'   | 'TRY'      | 'DFC'       | 'DFC'               | ''      | 'Yes'               | 'No'                  | '*'         | 'Partner term vendor DFC' | ''        | '-200'   | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0401058 check absence Bank receipt movements by the Register  "T2015 Transactions info" (Return from vendor, without basis)
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '516'     |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows

Scenario: _0434357 check Bank receipt movements by the Register  "T2014 Advances info" (Payment from customer by POS, advance=true)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 520' |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 520 dated 23.06.2022 19:41:15' | ''             | ''                        | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'              | ''             | ''                        | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                             | 'Company'      | 'Branch'                  | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'        | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                             | 'Main Company' | 'Distribution department' | '23.06.2022 19:41:15' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | ''      | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, TRY' | ''        | '100'    | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0401058 check absence Bank receipt movements by the Register  "T2015 Transactions info" (Payment from customer by POS, advance=true)
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 520'   |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows

Scenario: _0434355 check Bank receipt movements by the Register  "T2015 Transactions info" (Payment from customer by POS,  advance=false)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 519' |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 519 dated 23.06.2022 17:50:08' | ''             | ''                        | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'          | ''             | ''                        | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| ''                                             | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                         | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                             | 'Main Company' | 'Distribution department' | ''      | '23.06.2022 17:50:08' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '*'         | ''        | '100'    | 'No'     | 'Yes'     |
	And I close all client application windows

Scenario: _0401056 check absence Bank receipt movements by the Register  "T2014 Advances info" (Return from vendor, advance=false)
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 519'   |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2014 Advances info"'    |
		And I close all client application windows

Scenario: _0434357 check Bank receipt movements by the Register  "R3010 Cash on hand" (Salary return,  Branch in lines)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 529' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report info" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 529 dated 02.09.2024 17:20:24' | ''                    | ''           | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''                    | ''           | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | '17,12'  | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | '17,12'  | 'No'                   |		
	And I close all client application windows

Scenario: _0434358 check Bank receipt movements by the Register  "R3011 Cash flow" (Salary return,  Branch in lines)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 529' |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report info" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 529 dated 02.09.2024 17:20:24' | ''                    | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''       | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''             | ''                        | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''       | ''                     |
			| ''                                             | 'Period'              | 'Company'      | 'Branch'                  | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center'        | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                             | '02.09.2024 17:20:24' | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'Incoming'  | 'Movement type 2'         | 'Distribution department' | ''                | 'TRY'      | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'Incoming'  | 'Movement type 2'         | 'Distribution department' | ''                | 'TRY'      | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'Incoming'  | 'Movement type 2'         | 'Distribution department' | ''                | 'USD'      | 'Reporting currency'           | '17,12'  | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Accountants office'      | ''                | 'TRY'      | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Accountants office'      | ''                | 'TRY'      | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:20:24' | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Accountants office'      | ''                | 'USD'      | 'Reporting currency'           | '17,12'  | 'No'                   |		
	And I close all client application windows

Scenario: _0434359 check Bank receipt movements by the Register  "R9510 Salary payment" (Salary return,  Branch in lines)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 529' |
	* Check movements by the Register  "R9510 Salary payment" 
		And I click "Registrations report info" button
		And I select "R9510 Salary payment" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 529 dated 02.09.2024 17:20:24' | ''                    | ''           | ''             | ''                        | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| 'Register  "R9510 Salary payment"'             | ''                    | ''           | ''             | ''                        | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Employee'        | 'Payment period' | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Calculation type' | 'Amount' |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Accountants office'      | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Accountants office'      | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Accountants office'      | 'Anna Petrova'    | 'Second'         | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '17,12'  |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:20:24' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Alexander Orlov' | 'First'          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '17,12'  |		
	And I close all client application windows

Scenario: _0434360 check Bank receipt movements by the Register  "R3010 Cash on hand" (Salary return,  Branch in header)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 530' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report info" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 530 dated 02.09.2024 17:23:53' | ''                    | ''           | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''                    | ''           | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | '17,12'  | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | '17,12'  | 'No'                   |		
	And I close all client application windows

Scenario: _0434358 check Bank receipt movements by the Register  "R3011 Cash flow" (Salary return,  Branch in header)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 530' |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report info" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 530 dated 02.09.2024 17:23:53' | ''                    | ''             | ''             | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''       | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''             | ''             | ''                  | ''          | ''                        | ''                        | ''                | ''         | ''                             | ''       | ''                     |
			| ''                                             | 'Period'              | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center'        | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                             | '02.09.2024 17:23:53' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Accountants office'      | ''                | 'TRY'      | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Accountants office'      | ''                | 'TRY'      | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 3'         | 'Accountants office'      | ''                | 'USD'      | 'Reporting currency'           | '17,12'  | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 2'         | 'Distribution department' | ''                | 'TRY'      | 'Local currency'               | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 2'         | 'Distribution department' | ''                | 'TRY'      | 'en description is empty'      | '100'    | 'No'                   |
			| ''                                             | '02.09.2024 17:23:53' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 2'         | 'Distribution department' | ''                | 'USD'      | 'Reporting currency'           | '17,12'  | 'No'                   |		
	And I close all client application windows

Scenario: _0434359 check Bank receipt movements by the Register  "R9510 Salary payment" (Salary return,  Branch in header)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '1 530' |
	* Check movements by the Register  "R9510 Salary payment" 
		And I click "Registrations report info" button
		And I select "R9510 Salary payment" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 530 dated 02.09.2024 17:23:53' | ''                    | ''           | ''             | ''             | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| 'Register  "R9510 Salary payment"'             | ''                    | ''           | ''             | ''             | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Employee'        | 'Payment period' | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Calculation type' | 'Amount' |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '17,12'  |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '100'    |
			| ''                                             | '02.09.2024 17:23:53' | 'Receipt'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'Second'         | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '17,12'  |		
	And I close all client application windows