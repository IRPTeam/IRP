﻿#language: en
@tree
@Positive
@Movements2
@MovementsBankPayment

Feature: check Bank payment movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043300 preparation (Bank payment)
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
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog PlanningPeriods objects
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
		When Create OtherPartners objects
		When Create catalog SalaryCalculationType objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	When Create catalog LegalNameContracts objects
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
			| 'Number'    |
			| '115'       |
			When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseInvoice objects
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
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
	* Load Bank payment
		When Create document BankPayment objects (check movements, advance)
		When Create document BankPayment objects
		When Create document BankPayment objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesReturn objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (check cash planning, cash transfer order and OPO)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(325).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(331).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (return to customer)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(326).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (return to customer by POS)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(1329).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(1330).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (with partner term by document, without basis)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(328).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (return retail customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(311).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankPayment objects (salary payment)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(329).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(1333).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create BankPayment (OtherPartnersTransactions)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(1331).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create BankPayment (Other expense)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(1332).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _0433001 check preparation
	When check preparation

Scenario: _043301 check Bank payment movements by the Register "R3010 Cash on hand"
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 2 dated 05.04.2021 12:28:47'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'             | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                           | 'Expense'       | '05.04.2021 12:28:47'   | '500'         | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'EUR'        | 'EUR'                    | 'en description is empty'        | 'No'                      |
			| ''                                           | 'Expense'       | '05.04.2021 12:28:47'   | '550'         | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
			| ''                                           | 'Expense'       | '05.04.2021 12:28:47'   | '2 500'       | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'TRY'        | 'EUR'                    | 'Local currency'                 | 'No'                      |
	And I close all client application windows

	
Scenario: _043302 check Bank payment movements by the Register "R5010 Reconciliation statement" (payment to vendor)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '1'        | '07.09.2020 19:16:43'    |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 dated 07.09.2020 19:16:43'     | ''              | ''                      | ''            | ''               | ''         | ''           | ''                    | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''         | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''         | ''           | ''                    | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''           | ''                    | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                             | 'Receipt'       | '07.09.2020 19:16:43'   | '1 000'       | 'Main Company'   | ''         | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP'     |
	And I close all client application windows

Scenario: _043303 check absence Bank payment movements by the Register "R5010 Reconciliation statement" (cash transfer, currency exchange)
	And I close all client application windows
	* Select Bank payment (cash transfer)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
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
	* Select Bank payment (currency exchange)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '324'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement'    |
	And I close all client application windows

	
Scenario: _043304 check Bank payment movements by the Register "R1021 Vendors transactions" (payment to vendor, basis document exist)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '1'        | '07.09.2020 19:16:43'    |
		And I select current line in "List" table		
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 dated 07.09.2020 19:16:43'   | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'     | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                | ''        | ''        | ''                       | ''                            |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'            | 'Basis'                                           | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                           | 'Expense'       | '07.09.2020 19:16:43'   | '171,2'       | 'Main Company'   | ''         | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | 'Purchase invoice 12 dated 07.09.2020 17:53:38'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                           | 'Expense'       | '07.09.2020 19:16:43'   | '1 000'       | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | 'Purchase invoice 12 dated 07.09.2020 17:53:38'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                           | 'Expense'       | '07.09.2020 19:16:43'   | '1 000'       | 'Main Company'   | ''         | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | 'Purchase invoice 12 dated 07.09.2020 17:53:38'   | ''        | ''        | 'No'                     | ''                            |
	And I close all client application windows

Scenario: _043305 check absence Bank payment movements by the Register "R1021 Vendors transactions" (payment to vendor, without basis document)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '10'       | '12.02.2021 11:24:13'    |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R1021 Vendors transactions'    |
	And I close all client application windows

Scenario: _043306 check Bank payment movements by the Register "R1020 Advances to vendors" (payment to vendor, without basis document )
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '10'       | '12.02.2021 11:24:13'    |
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report info" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 10 dated 12.02.2021 11:24:13' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'     | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''        | ''       | ''                     | ''                         |
			| ''                                          | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'          | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                          | '12.02.2021 11:24:13' | 'Receipt'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 000'  | 'No'                   | ''                         |
			| ''                                          | '12.02.2021 11:24:13' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '342,4'  | 'No'                   | ''                         |
			| ''                                          | '12.02.2021 11:24:13' | 'Receipt'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '2 000'  | 'No'                   | ''                         |		
	And I close all client application windows

Scenario: _043307 check absence Bank payment movements by the Register "R1020 Advances to vendors" (payment to vendor, without basis document)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '1'        | '07.09.2020 19:16:43'    |
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R1020 Advances to vendors'    |
	And I close all client application windows


Scenario: _043315 check Bank payment movements by the Register "R3035 Cash planning" (payment to vendor, with planning transaction basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '323'      | '03.06.2021 17:01:44'    |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 323 dated 03.06.2021 17:01:44' | ''                    | ''          | ''             | ''       | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''       | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''       | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                  | ''                                                     | ''         | ''                    | ''          | ''                  | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Account'           | 'Basis document'                                       | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '03.06.2021 17:01:44' | '-1 500'    | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '03.06.2021 17:01:44' | '-1 500'    | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '03.06.2021 17:01:44' | '-400'      | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'DFC'       | 'DFC'               | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '03.06.2021 17:01:44' | '-400'      | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'TRY'      | 'Outgoing'            | 'DFC'       | 'DFC'               | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '03.06.2021 17:01:44' | '-256,8'    | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '03.06.2021 17:01:44' | '-68,48'    | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing payment order 323 dated 07.09.2020 19:23:44' | 'USD'      | 'Outgoing'            | 'DFC'       | 'DFC'               | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |	
	And I close all client application windows

Scenario: _043316 check Bank payment movements by the Register "R3035 Cash planning" (currency exchange, with planning transaction basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '324'       |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 324 dated 03.06.2021 17:05:34' | ''                    | ''          | ''             | ''       | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''       | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''       | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Account'           | 'Basis document'                                  | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '03.06.2021 17:05:34' | '-1 000'    | 'Main Company' | ''       | 'Bank account, TRY' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '03.06.2021 17:05:34' | '-1 000'    | 'Main Company' | ''       | 'Bank account, TRY' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                           | '03.06.2021 17:05:34' | '-171,2'    | 'Main Company' | ''       | 'Bank account, TRY' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'USD'      | 'Outgoing'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
	And I close all client application windows

Scenario: _043317 check Bank payment movements by the Register "R3035 Cash planning" (cash transfer order, with planning transaction basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '325'       |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 325 dated 03.06.2021 17:04:49'   | ''                      | ''            | ''               | ''         | ''                    | ''                                                  | ''           | ''                      | ''          | ''             | ''                               | ''                          | ''                  | ''                        |
			| 'Document registrations records'               | ''                      | ''            | ''               | ''         | ''                    | ''                                                  | ''           | ''                      | ''          | ''             | ''                               | ''                          | ''                  | ''                        |
			| 'Register  "R3035 Cash planning"'              | ''                      | ''            | ''               | ''         | ''                    | ''                                                  | ''           | ''                      | ''          | ''             | ''                               | ''                          | ''                  | ''                        |
			| ''                                             | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                    | ''                                                  | ''           | ''                      | ''          | ''             | ''                               | ''                          | ''                  | 'Attributes'              |
			| ''                                             | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Account'             | 'Basis document'                                    | 'Currency'   | 'Cash flow direction'   | 'Partner'   | 'Legal name'   | 'Multi currency movement type'   | 'Financial movement type'   | 'Planning period'   | 'Deferred calculation'    |
			| ''                                             | '03.06.2021 17:04:49'   | '-4 500'      | 'Main Company'   | ''         | 'Bank account, EUR'   | 'Cash transfer order 2 dated 05.04.2021 12:09:54'   | 'TRY'        | 'Outgoing'              | ''          | ''             | 'Local currency'                 | 'Movement type 1'           | ''                  | 'No'                      |
			| ''                                             | '03.06.2021 17:04:49'   | '-550'        | 'Main Company'   | ''         | 'Bank account, EUR'   | 'Cash transfer order 2 dated 05.04.2021 12:09:54'   | 'USD'        | 'Outgoing'              | ''          | ''             | 'Reporting currency'             | 'Movement type 1'           | ''                  | 'No'                      |
			| ''                                             | '03.06.2021 17:04:49'   | '-500'        | 'Main Company'   | ''         | 'Bank account, EUR'   | 'Cash transfer order 2 dated 05.04.2021 12:09:54'   | 'EUR'        | 'Outgoing'              | ''          | ''             | 'en description is empty'        | 'Movement type 1'           | ''                  | 'No'                      |
	And I close all client application windows

	
		

Scenario: _043318 check absence Bank payment movements by the Register "R3035 Cash planning" (without planning transaction basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '1'        | '07.09.2020 19:16:43'    |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R3035 Cash planning'    |
	And I close all client application windows


Scenario: _043320 check Bank payment movements by the Register "R3010 Cash on hand" (Return to customer, without basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '326'       |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 326 dated 02.09.2021 14:24:44'   | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''                          | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Expense'       | '02.09.2021 14:24:44'   | '17,12'       | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '02.09.2021 14:24:44'   | '100'         | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '02.09.2021 14:24:44'   | '100'         | 'Main Company'   | 'Distribution department'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _043321 check Bank payment movements by the Register "R5010 Reconciliation statement" (return to customer)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '326'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 326 dated 02.09.2021 14:24:44'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                  | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                  | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                  | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                  | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Currency'   | 'Legal name'        | 'Legal name contract'    |
			| ''                                             | 'Receipt'       | '02.09.2021 14:24:44'   | '100'         | 'Main Company'   | 'Distribution department'   | 'TRY'        | 'Company Kalipso'   | ''                       |
	And I close all client application windows

Scenario: _043322 check Bank payment movements by the Register "R1020 Advances to vendors" (with partner term by document, without basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '328'       |
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report info" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 328 dated 08.02.2022 13:43:58' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'      | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''        | ''       | ''                     | ''                         |
			| ''                                           | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'          | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                           | '08.02.2022 13:43:58' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '50'     | 'No'                   | ''                         |
			| ''                                           | '08.02.2022 13:43:58' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '8,56'   | 'No'                   | ''                         |
			| ''                                           | '08.02.2022 13:43:58' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '50'     | 'No'                   | ''                         |		
	And I close all client application windows

Scenario: _043323 check Bank payment movements by the Register "R3010 Cash on hand" (Return to customer by POS, with basis document)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 329'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 329 dated 24.06.2022 18:06:56'   | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                                       | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'                                | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Expense'       | '24.06.2022 18:06:56'   | '8,56'        | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Expense'       | '24.06.2022 18:06:56'   | '50'          | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Expense'       | '24.06.2022 18:06:56'   | '50'          | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _043324 check Bank payment movements by the Register "R3050 Pos cash balances" (Return to customer by POS, with basis document)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 329'     |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 329 dated 24.06.2022 18:06:56' | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| 'Document registrations records'               | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| 'Register  "R3050 Pos cash balances"'          | ''                    | ''          | ''           | ''             | ''                        | ''                                     | ''             | ''                    |
			| ''                                             | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''                        | ''                                     | ''             | ''                    |
			| ''                                             | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'                  | 'Account'                              | 'Payment type' | 'Payment terminal'    |
			| ''                                             | '24.06.2022 18:06:56' | '-50'       | ''           | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Card 01'      | 'Payment terminal 01' |
	And I close all client application windows

Scenario: _043325 check Bank payment movements by the Register "R2021 Customer transactions" (Return to customer by POS, with basis document)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 329'     |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 329 dated 24.06.2022 18:06:56'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'        | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''        | ''                       | ''                              |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                             | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                        | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                               | 'Expense'       | '24.06.2022 18:06:56'   | '-50'         | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales return 103 dated 12.03.2021 08:59:52'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                               | 'Expense'       | '24.06.2022 18:06:56'   | '-50'         | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales return 103 dated 12.03.2021 08:59:52'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                               | 'Expense'       | '24.06.2022 18:06:56'   | '-8,56'       | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales return 103 dated 12.03.2021 08:59:52'   | ''        | ''        | 'No'                     | ''                              |
		And I close all client application windows

Scenario: _043327 check Bank payment movements by the Register "R2020 Advances from customer" (Return to customer by POS, without basis document)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 330'     |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report info" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 330 dated 24.06.2022 18:07:02' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'     | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'                | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                             | '24.06.2022 18:07:02' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '-50'    | 'No'                   | ''                           |
			| ''                                             | '24.06.2022 18:07:02' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '-8,56'  | 'No'                   | ''                           |
			| ''                                             | '24.06.2022 18:07:02' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | '-50'    | 'No'                   | ''                           |		
	And I close all client application windows

Scenario: _043328 check Bank payment movements by the Register "R3010 Cash on hand" (Return to customer by POS, without basis document)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 330'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 330 dated 24.06.2022 18:07:02'   | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                                       | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'                                | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Expense'       | '24.06.2022 18:07:02'   | '8,56'        | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Expense'       | '24.06.2022 18:07:02'   | '50'          | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Expense'       | '24.06.2022 18:07:02'   | '50'          | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _043329 check Bank payment movements by the Register "R3050 Pos cash balances" (Return to customer by POS, without basis document)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 330'     |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 330 dated 24.06.2022 18:07:02'   | ''                      | ''            | ''             | ''               | ''                          | ''                                       | ''               | ''                       |
			| 'Document registrations records'                 | ''                      | ''            | ''             | ''               | ''                          | ''                                       | ''               | ''                       |
			| 'Register  "R3050 Pos cash balances"'            | ''                      | ''            | ''             | ''               | ''                          | ''                                       | ''               | ''                       |
			| ''                                               | 'Period'                | 'Resources'   | ''             | 'Dimensions'     | ''                          | ''                                       | ''               | ''                       |
			| ''                                               | ''                      | 'Amount'      | 'Commission'   | 'Company'        | 'Branch'                    | 'Account'                                | 'Payment type'   | 'Payment terminal'       |
			| ''                                               | '24.06.2022 18:07:02'   | '-50'         | ''             | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'Card 01'        | 'Payment terminal 01'    |
		And I close all client application windows

Scenario: _0433291 check absence Bank payment movements by the Register R5022 Expenses" (Return to customer by POS)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 330'     |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R5022 Expenses'    |
	And I close all client application windows

Scenario: _0433292 check Bank payment movements by the Register  "R2023 Advances from retail customers" (return retail customer advance)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '311'       |
	* Check movements by the Register  "R2023 Advances from retail customers" 
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 311 dated 18.01.2023 12:02:58'         | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| 'Document registrations records'                     | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| 'Register  "R2023 Advances from retail customers"'   | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| ''                                                   | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                   |
			| ''                                                   | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Retail customer'    |
			| ''                                                   | 'Expense'       | '18.01.2023 12:02:58'   | '100'         | 'Main Company'   | ''         | 'Sam Jons'           |
		And I close all client application windows

Scenario: _0433293 check Bank payment movements by the Register  "R3010 Cash on hand" (return retail customer advance)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '311'       |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 311 dated 18.01.2023 12:02:58'   | ''              | ''                      | ''            | ''               | ''         | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''         | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''         | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Expense'       | '18.01.2023 12:02:58'   | '17,12'       | 'Main Company'   | ''         | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '18.01.2023 12:02:58'   | '100'         | 'Main Company'   | ''         | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '18.01.2023 12:02:58'   | '100'         | 'Main Company'   | ''         | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows

	
Scenario: _0433295 check Bank payment movements by the Register  "R3010 Cash on hand" (return retail customer advance)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '329'       |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 329 dated 08.02.2023 13:10:49'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '171,2'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '256,8'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 500'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '08.02.2023 13:10:49'   | '1 500'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _0433296 check Bank payment movements by the Register  "R9510 Salary payment" (return retail customer advance)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '329'       |
	* Check movements by the Register  "R9510 Salary payment" 
		And I click "Registrations report info" button
		And I select "R9510 Salary payment" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 329 dated 08.02.2023 13:10:49' | ''                    | ''           | ''             | ''             | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| 'Register  "R9510 Salary payment"'           | ''                    | ''           | ''             | ''             | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| ''                                           | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Employee'        | 'Payment period' | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Calculation type' | 'Amount' |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '1 000'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '1 000'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Alexander Orlov' | 'First'          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '171,2'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '1 500'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '1 500'  |
			| ''                                           | '08.02.2023 13:10:49' | 'Expense'    | 'Main Company' | 'Front office' | 'Anna Petrova'    | 'Second'         | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '256,8'  |	
		And I close all client application windows


Scenario: _0433297 check Bank payment movements by the Register  "R3011 Cash flow" (return retail customer advance)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '311'       |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 311 dated 18.01.2023 12:02:58' | ''                    | ''          | ''             | ''       | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''       | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''       | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '18.01.2023 12:02:58' | '17,12'     | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing'  | ''                        | ''                 | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '18.01.2023 12:02:58' | '100'       | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing'  | ''                        | ''                 | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '18.01.2023 12:02:58' | '100'       | 'Main Company' | ''       | 'Bank account, TRY' | 'Outgoing'  | ''                        | ''                 | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I close all client application windows

Scenario: _0433298 check Bank payment movements by the Register  "R3010 Cash on hand" (Other partner)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 331'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 331 dated 12.06.2023 15:22:24'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Expense'       | '12.06.2023 15:22:24'   | '8,56'        | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Expense'       | '12.06.2023 15:22:24'   | '50'          | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Expense'       | '12.06.2023 15:22:24'   | '50'          | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _0433299 check Bank payment movements by the Register  "R3011 Cash flow" (Other partner)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 331'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 331 dated 12.06.2023 15:22:24' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '12.06.2023 15:22:24' | '8,56'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '12.06.2023 15:22:24' | '50'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '12.06.2023 15:22:24' | '50'        | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _0433300 check Bank payment movements by the Register  "R5010 Reconciliation statement" (Other partner)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 331'     |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 331 dated 12.06.2023 15:22:24'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| 'Register  "R5010 Reconciliation statement"'     | ''              | ''                      | ''            | ''               | ''               | ''           | ''                  | ''                       |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                  | ''                       |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'        | 'Legal name contract'    |
			| ''                                               | 'Receipt'       | '12.06.2023 15:22:24'   | '50'          | 'Main Company'   | 'Front office'   | 'TRY'        | 'Other partner 2'   | ''                       |
		And I close all client application windows

Scenario: _0433301 check Bank payment movements by the Register  "R5015 Other partners transactions" (Other partner)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 331'     |
	* Check movements by the Register  "R5015 Other partners transactions" 
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 331 dated 12.06.2023 15:22:24'    | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| 'Register  "R5015 Other partners transactions"'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | 'Attributes'              |
			| ''                                                | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'           | 'Agreement'         | 'Basis'             | 'Deferred calculation'    |
			| ''                                                | 'Receipt'       | '12.06.2023 15:22:24'   | '8,56'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 15:22:24'   | '50'          | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '12.06.2023 15:22:24'   | '50'          | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
		And I close all client application windows

Scenario: _043330 Bank payment clear posting/mark for deletion
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 2 dated 05.04.2021 12:28:47'    |
			| 'Document registrations records'              |
		And I close current window
	* Post Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
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
		Given I open hyperlink "e1cib/list/Document.BankPayment"
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
			| 'Bank payment 2 dated 05.04.2021 12:28:47'    |
			| 'Document registrations records'              |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.BankPayment"
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
	
Scenario: _0433302 check Bank payment movements by the Register  "R3010 Cash on hand" (Other expense)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 332'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 332 dated 12.06.2023 17:34:39'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                 | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                               | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                               | 'Expense'       | '12.06.2023 17:34:39'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                               | 'Expense'       | '12.06.2023 17:34:39'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                               | 'Expense'       | '12.06.2023 17:34:39'   | '100'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _0433303 check Bank payment movements by the Register  "R3011 Cash flow" (Other expense)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 332'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 332 dated 12.06.2023 17:34:39' | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'               | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''          | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                             | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                             | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                             | '12.06.2023 17:34:39' | '17,12'     | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                             | '12.06.2023 17:34:39' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                             | '12.06.2023 17:34:39' | '100'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _0433304 check Bank payment movements by the Register  "R5022 Expenses" (Other expense)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '1 332'     |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 332 dated 12.06.2023 17:34:39' | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Document registrations records'               | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Register  "R5022 Expenses"'                   | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| ''                                             | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | 'Attributes'                |
			| ''                                             | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Calculation movement cost' |
			| ''                                             | '12.06.2023 17:34:39' | '17,12'     | '17,12'             | ''            | 'Main Company' | 'Front office' | ''                   | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | ''                          |
			| ''                                             | '12.06.2023 17:34:39' | '100'       | '100'               | ''            | 'Main Company' | 'Front office' | ''                   | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | ''                          |
			| ''                                             | '12.06.2023 17:34:39' | '100'       | '100'               | ''            | 'Main Company' | 'Front office' | ''                   | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | ''                          |
		And I close all client application windows


Scenario: _0433305 check Bank payment movements by the Register  "R3010 Cash on hand" (cash transfer without CTO)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '331'     |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 331 dated 03.07.2023 14:20:52' | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Expense'     | '03.07.2023 14:20:52' | ''          | 'Main Company' | 'Distribution department' | 'Bank account, EUR' | 'TRY'      | 'EUR'                  | 'Local currency'               | 'No'                   |
			| ''                                           | 'Expense'     | '03.07.2023 14:20:52' | ''          | 'Main Company' | 'Distribution department' | 'Bank account, EUR' | 'USD'      | 'EUR'                  | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Expense'     | '03.07.2023 14:20:52' | '1 000'     | 'Main Company' | 'Distribution department' | 'Bank account, EUR' | 'EUR'      | 'EUR'                  | 'en description is empty'      | 'No'                   |		
		And I close all client application windows


Scenario: _0433306 check Bank payment movements by the Register  "R3011 Cash flow" (cash transfer without CTO)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '331'     |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 331 dated 03.07.2023 14:20:52' | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''          | ''             | ''                        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | '03.07.2023 14:20:52' | ''          | 'Main Company' | 'Distribution department' | 'Bank account, EUR' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | '03.07.2023 14:20:52' | ''          | 'Main Company' | 'Distribution department' | 'Bank account, EUR' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | '03.07.2023 14:20:52' | '1 000'     | 'Main Company' | 'Distribution department' | 'Bank account, EUR' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'EUR'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _0433307 check Bank payment movements by the Register  "R3021 Cash in transit (incoming)" (cash transfer without CTO)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '331'     |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 331 dated 03.07.2023 14:20:52'   | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''             | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                    | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'             | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '03.07.2023 14:20:52' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Local currency'               | 'TRY'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '03.07.2023 14:20:52' | ''          | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'Reporting currency'           | 'USD'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '03.07.2023 14:20:52' | '1 000'     | 'Main Company' | 'Front office' | 'Bank account 2, EUR' | 'en description is empty'      | 'EUR'      | 'EUR'                  | ''      | 'No'                   |		
		And I close all client application windows

Scenario: _0433308 check Bank payment movements by the Register  "R3021 Cash in transit (incoming)" (cash transfer - currency exchange)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '324'     |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report info" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 324 dated 03.06.2021 17:05:34'   | ''                    | ''           | ''             | ''       | ''             | ''                             | ''         | ''                     | ''                                                | ''       | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''                    | ''           | ''             | ''       | ''             | ''                             | ''         | ''                     | ''                                                | ''       | ''                     |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Account'      | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                           | 'Amount' | 'Deferred calculation' |
			| ''                                             | '03.06.2021 17:05:34' | 'Receipt'    | 'Main Company' | ''       | 'Transit Main' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | '1 000'  | 'No'                   |
			| ''                                             | '03.06.2021 17:05:34' | 'Receipt'    | 'Main Company' | ''       | 'Transit Main' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | '171,2'  | 'No'                   |
			| ''                                             | '03.06.2021 17:05:34' | 'Receipt'    | 'Main Company' | ''       | 'Transit Main' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | '1 000'  | 'No'                   |	
		And I close all client application windows

#
Scenario: _0433309 check Bank payment movements by the Register  "T2015 Transactions info" (Payment to the vendor, advance=false)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '1'     |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 dated 07.09.2020 19:16:43' | ''             | ''       | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                              | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'      | ''             | ''       | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                              | ''          | ''        | ''       | ''       | ''        |
			| ''                                         | 'Company'      | 'Branch' | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                             | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                         | 'Main Company' | ''       | ''      | '07.09.2020 19:16:43' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Yes'                   | 'No'                      | 'Purchase invoice 12 dated 07.09.2020 17:53:38' | '*'         | ''        | '1 000'  | 'No'     | 'Yes'     |
	And I close all client application windows

Scenario: _0433310 check Bank payment movements by the Register  "T2014 Advances info" (Payment to the vendor, advance=true)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '10'    |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 10 dated 12.02.2021 11:24:13' | ''             | ''             | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                   | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'           | ''             | ''             | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                   | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                          | 'Company'      | 'Branch'       | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'  | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                          | 'Main Company' | 'Front office' | '12.02.2021 11:24:13' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | ''      | 'Yes'               | 'No'                  | '*'         | 'Vendor Ferron, TRY' | ''        | '2 000'  | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0433311 check absence Bank payment movements by the Register  "T2015 Transactions info" (Payment to the vendor, advance=true)
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '10'      |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows

Scenario: _0433312 check absence Bank payment movements by the Register  "T2014 Advances info" (Payment to the vendor, advance=false)
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
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

Scenario: _0433313 check Bank payment movements by the Register  "T2014 Advances info" (Return to customer, without basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '326'   |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 326 dated 02.09.2021 14:24:44' | ''             | ''                        | ''                    | ''    | ''         | ''        | ''                | ''      | ''                  | ''                    | ''          | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'            | ''             | ''                        | ''                    | ''    | ''         | ''        | ''                | ''      | ''                  | ''                    | ''          | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                           | 'Company'      | 'Branch'                  | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name'      | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'        | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                           | 'Main Company' | 'Distribution department' | '02.09.2021 14:24:44' | '*'   | 'TRY'      | 'Kalipso' | 'Company Kalipso' | ''      | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, TRY' | ''        | '-100'   | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0433314 check absence Bank payment movements by the Register  "T2015 Transactions info" (Return to customer, without basis)
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '326'     |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows


Scenario: _0433315 check Bank payment movements by the Register  "T2014 Advances info" (Return to customer by POS, without basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '1 330'   |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 330 dated 24.06.2022 18:07:02' | ''             | ''                        | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'              | ''             | ''                        | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                             | 'Company'      | 'Branch'                  | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'        | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                             | 'Main Company' | 'Distribution department' | '24.06.2022 18:07:02' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | ''      | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, TRY' | ''        | '-50'    | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows


Scenario: _0433316 check absence Bank payment movements by the Register  "T2015 Transactions info" (Return to customer by POS, without basis)
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '1 330'   |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows

Scenario: _0433317 check Bank payment movements by the Register  "T2015 Transactions info" (Return to customer by POS, with basis)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '1 329' |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 329 dated 24.06.2022 18:06:56' | ''             | ''                        | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                           | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'          | ''             | ''                        | ''      | ''                    | ''    | ''         | ''          | ''                  | ''                         | ''                      | ''                        | ''                                           | ''          | ''        | ''       | ''       | ''        |
			| ''                                             | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                          | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                             | 'Main Company' | 'Distribution department' | ''      | '24.06.2022 18:06:56' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | 'Sales return 103 dated 12.03.2021 08:59:52' | '*'         | ''        | '-50'    | 'No'     | 'Yes'     |
	And I close all client application windows

Scenario: _0433319 check Bank payment movements by the Register  "R3010 Cash on hand" (Salary payment, Branch in lines)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '1 333' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report info" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 333 dated 02.09.2024 17:14:47' | ''                    | ''           | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| 'Register  "R3010 Cash on hand"'               | ''                    | ''           | ''             | ''                        | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | '1 000'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | '1 000'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | '171,2'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'Local currency'               | '1 500'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'TRY'      | 'TRY'                  | 'en description is empty'      | '1 500'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | '256,8'  | 'No'                   |		
	And I close all client application windows


Scenario: _0433320 check Bank payment movements by the Register  "R3011 Cash flow" (Salary payment, Branch in lines)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '1 333' |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report info" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 333 dated 02.09.2024 17:14:47' | ''                    | ''             | ''                        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| 'Register  "R3011 Cash flow"'                  | ''                    | ''             | ''                        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| ''                                             | 'Period'              | 'Company'      | 'Branch'                  | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                             | '02.09.2024 17:14:47' | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                 | ''                | 'TRY'      | 'Local currency'               | '1 000'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                 | ''                | 'TRY'      | 'en description is empty'      | '1 000'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Main Company' | 'Accountants office'      | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                 | ''                | 'USD'      | 'Reporting currency'           | '171,2'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                 | ''                | 'TRY'      | 'Local currency'               | '1 500'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                 | ''                | 'TRY'      | 'en description is empty'      | '1 500'  | 'No'                   |
			| ''                                             | '02.09.2024 17:14:47' | 'Main Company' | 'Distribution department' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | ''                 | ''                | 'USD'      | 'Reporting currency'           | '256,8'  | 'No'                   |		
	And I close all client application windows

Scenario: _0433321 check Bank payment movements by the Register  "R9510 Salary payment" (Salary payment, Branch in lines)
	And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'|
			| '1 333' |
	* Check movements by the Register  "R9510 Salary payment" 
		And I click "Registrations report info" button
		And I select "R9510 Salary payment" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 1 333 dated 02.09.2024 17:14:47' | ''                    | ''           | ''             | ''                        | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| 'Register  "R9510 Salary payment"'             | ''                    | ''           | ''             | ''                        | ''                | ''               | ''         | ''                     | ''                             | ''                 | ''       |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Employee'        | 'Payment period' | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Calculation type' | 'Amount' |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Accountants office'      | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '1 000'  |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Accountants office'      | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '1 000'  |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Accountants office'      | 'Alexander Orlov' | 'First'          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '171,2'  |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           | '1 500'  |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           | '1 500'  |
			| ''                                             | '02.09.2024 17:14:47' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Anna Petrova'    | 'Second'         | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           | '256,8'  |		
	And I close all client application windows

Scenario: _0433318 check absence Bank payment movements by the Register  "T2014 Advances info" (Return to customer by POS, with basis)
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'  |
			| '1 329'   |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2014 Advances info"'    |
		And I close all client application windows