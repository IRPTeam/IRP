#language: en
@tree
@Positive
@Movements
@MovementsBankReceipt

Feature: check Bank receipt movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043400 preparation (Bank receipt)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '1' |
			| '3' |	
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
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
				| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
			| 'Number'  |
			| '1' |
			| '3' |	
			When Create document SalesInvoice objects (check movements)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.SalesInvoice.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);" |
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
				| "Documents.SalesReturn.FindByNumber(104).GetObject().Write(DocumentWriteMode.Posting);" |
				| "Documents.SalesReturn.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Bank receipt
		When Create document BankReceipt objects
		When Create document BankReceipt objects (exchange and transfer)
		When Create document BankReceipt objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankReceipt.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankReceipt.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankReceipt.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		If "List" table contains lines Then
				| 'Number'  |
				| '11' |
				And I execute 1C:Enterprise script at server
					| "Documents.BankReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		And I close all client application windows
		
		

Scenario: _043401 check Bank receipt movements by the Register "R3010 Cash on hand"
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 2 dated 05.04.2021 14:27:40' | ''            | ''                    | ''          | ''             | ''                    | ''         | ''                             | ''                     |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''                    | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'           | ''            | ''                    | ''          | ''             | ''                    | ''         | ''                             | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                    | ''         | ''                             | 'Attributes'           |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Account'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                         | 'Receipt'     | '05.04.2021 14:27:40' | '500'       | 'Main Company' | 'Bank account 2, EUR' | 'EUR'      | 'en description is empty'      | 'No'                   |
			| ''                                         | 'Receipt'     | '05.04.2021 14:27:40' | '550'       | 'Main Company' | 'Bank account 2, EUR' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                         | 'Receipt'     | '05.04.2021 14:27:40' | '2 500'     | 'Main Company' | 'Bank account 2, EUR' | 'TRY'      | 'Local currency'               | 'No'                   |
	And I close all client application windows

	
Scenario: _043402 check Bank receipt movements by the Register "R5010 Reconciliation statement" (payment to vendor)
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  | 'Date'               |
			| '1'       |'07.09.2020 19:14:59' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 dated 07.09.2020 19:14:59'   | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''             | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Currency'   | 'Company'      | 'Legal name'        |
			| ''                                           | 'Expense'     | '07.09.2020 19:14:59' | '100'       | 'TRY'        | 'Main Company' | 'Company Ferron BP' |
	And I close all client application windows

Scenario: _043403 check Bank receipt movements by the Register "R5010 Reconciliation statement" (cash transfer, currency exchange)
	And I close all client application windows
	* Select Bank receipt (cash transfer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement'   |                  
	And I close all client application windows
	* Select Bank receipt (currency exchange)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement'   |                  
	And I close all client application windows

Scenario: _043410 check Bank receipt movements by the Register "R2021 Customer transactions" (basis document exist)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 1 dated 07.09.2020 19:14:59' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     | ''                  |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     | ''                  |
			| 'Register  "R2021 Customer transactions"'  | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     | ''                  |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | 'Attributes'           | ''                  |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                         | 'Expense'     | '07.09.2020 19:14:59' | '100'       | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
			| ''                                         | 'Expense'     | '07.09.2020 19:14:59' | '100'       | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
			| ''                                         | 'Expense'     | '07.09.2020 19:14:59' | '100'       | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
			| ''                                         | 'Expense'     | '07.09.2020 19:14:59' | '584'       | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
	And I close all client application windows
	


Scenario: _043412 check Bank receipt movements by the Register "R2020 Advances from customer" (without basis document)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '5' |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 5 dated 15.04.2021 10:21:22' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                 | ''         | ''                                         | ''                     | ''                  |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                 | ''         | ''                                         | ''                     | ''                  |
			| 'Register  "R2020 Advances from customer"' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                 | ''         | ''                                         | ''                     | ''                  |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                 | ''         | ''                                         | 'Attributes'           | ''                  |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'       | 'Partner'  | 'Basis'                                    | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                         | 'Receipt'     | '15.04.2021 10:21:22' | '9 381,76'  | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Lomaniti' | 'Lomaniti' | 'Bank receipt 5 dated 15.04.2021 10:21:22' | 'No'                   | ''                |
			| ''                                         | 'Receipt'     | '15.04.2021 10:21:22' | '54 800'    | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Bank receipt 5 dated 15.04.2021 10:21:22' | 'No'                   | ''                |
			| ''                                         | 'Receipt'     | '15.04.2021 10:21:22' | '54 800'    | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Lomaniti' | 'Lomaniti' | 'Bank receipt 5 dated 15.04.2021 10:21:22' | 'No'                   | ''                |
	And I close all client application windows

Scenario: _043413 check absence Bank receipt movements by the Register "R2021 Customer transactions" (advance)
	And I close all client application windows
	* Select Bank receipt (payment from customer)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '5' |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2021 Customer transactions'   |     
	And I close all client application windows



Scenario: _043430 Bank receipt clear posting/mark for deletion
	And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 2 dated 05.04.2021 14:27:40' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
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
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
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
			| 'Bank receipt 2 dated 05.04.2021 14:27:40' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
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