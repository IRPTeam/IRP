#language: en
@tree
@Positive
@Movements3
@MovementsCashStatement


Feature: check Cash statement movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045400 preparation (CashStatement)
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
		When Create catalog CashAccounts objects
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
		When Create catalog Countries objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create Document discount
		When Create catalog CashStatementStatuses objects (Test)
		When Create POS cash account objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
		When Create catalog CashAccounts objects (POS)
		* Add plugin for discount
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			If "List" table does not contain lines Then
					| "Description"           |
					| "DocumentDiscount"      |
				When add Plugin for document discount
		When Create information register Taxes records (VAT)
	* Load RetailSalesReceipt
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load RetailReturnReceipt
		When Create document RetailReturnReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailReturnReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailReturnReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailReturnReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt and RetailRetutnReceipt objects (with discount) 
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailSalesReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailReturnReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailReturnReceipt objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailReturnReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (POS)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1519).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(1520).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashStatement (payment by POS)
		And I execute 1C:Enterprise script at server
			| "Documents.CashStatement.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
		
Scenario: _0454001 check preparation
	When check preparation

Scenario: _045401 check CashStatement movements by the Register  "R3010 Cash on hand"
		And I close all client application windows
	* Select CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash statement 11 dated 23.06.2022 22:53:32'   | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                | ''              | ''                      | ''            | ''               | ''                          | ''                                       | ''           | ''                       | ''                               | ''                        |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                                       | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'                                | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                              | 'Expense'       | '23.06.2022 22:53:32'   | '34,24'       | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                              | 'Expense'       | '23.06.2022 22:53:32'   | '200'         | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                              | 'Expense'       | '23.06.2022 22:53:32'   | '200'         | 'Main Company'   | 'Distribution department'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _045402 check CashStatement movements by the Register  "Cash in transit"
		And I close all client application windows
	* Select CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "Cash in transit"
		And I click "Registrations report" button
		And I select "Cash in transit" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash statement 11 dated 23.06.2022 22:53:32'   | ''              | ''                      | ''            | ''               | ''                                              | ''                                       | ''                    | ''           | ''                               | ''                        |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''                                              | ''                                       | ''                    | ''           | ''                               | ''                        |
			| 'Register  "Cash in transit"'                   | ''              | ''                      | ''            | ''               | ''                                              | ''                                       | ''                    | ''           | ''                               | ''                        |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                                              | ''                                       | ''                    | ''           | ''                               | 'Attributes'              |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Basis document'                                | 'From account'                           | 'To account'          | 'Currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                              | 'Receipt'       | '23.06.2022 22:53:32'   | '34,24'       | 'Main Company'   | 'Cash statement 11 dated 23.06.2022 22:53:32'   | 'POS account 1, TRY'   | 'Bank account, TRY'   | 'USD'        | 'Reporting currency'             | 'No'                      |
			| ''                                              | 'Receipt'       | '23.06.2022 22:53:32'   | '200'         | 'Main Company'   | 'Cash statement 11 dated 23.06.2022 22:53:32'   | 'POS account 1, TRY'   | 'Bank account, TRY'   | 'TRY'        | 'Local currency'                 | 'No'                      |
			| ''                                              | 'Receipt'       | '23.06.2022 22:53:32'   | '200'         | 'Main Company'   | 'Cash statement 11 dated 23.06.2022 22:53:32'   | 'POS account 1, TRY'   | 'Bank account, TRY'   | 'TRY'        | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _045403 check CashStatement movements by the Register  "R3021 Cash in transit (incoming)"
		And I close all client application windows
	* Select CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R3021 Cash in transit (incoming)"
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash statement 11 dated 23.06.2022 22:53:32'  | ''            | ''                    | ''          | ''             | ''                   | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                   | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''                   | ''                  | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                   | ''                  | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'             | 'Account'           | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '23.06.2022 22:53:32' | '34,24'     | 'Main Company' | 'Front office'       | 'Bank account, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '23.06.2022 22:53:32' | '200'       | 'Main Company' | 'Front office'       | 'Bank account, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '23.06.2022 22:53:32' | '200'       | 'Main Company' | 'Front office'       | 'Bank account, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
		And I close all client application windows

Scenario: _045404 check CashStatement movements by the Register  "R3035 Cash planning"
		And I close all client application windows
	* Select CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R3035 Cash planning"
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash statement 11 dated 23.06.2022 22:53:32' | ''                    | ''          | ''             | ''                        | ''             | ''                                            | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'              | ''                    | ''          | ''             | ''                        | ''             | ''                                            | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'             | ''                    | ''          | ''             | ''                        | ''             | ''                                            | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                            | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''             | ''                                            | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'      | 'Basis document'                              | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                            | '23.06.2022 22:53:32' | '34,24'     | 'Main Company' | 'Distribution department' | 'Cash desk №1' | 'Cash statement 11 dated 23.06.2022 22:53:32' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                            | '23.06.2022 22:53:32' | '200'       | 'Main Company' | 'Distribution department' | 'Cash desk №1' | 'Cash statement 11 dated 23.06.2022 22:53:32' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | ''                | 'No'                   |
			| ''                                            | '23.06.2022 22:53:32' | '200'       | 'Main Company' | 'Distribution department' | 'Cash desk №1' | 'Cash statement 11 dated 23.06.2022 22:53:32' | 'TRY'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | ''                | 'No'                   |
		And I close all client application windows

Scenario: _045405 check absence CashStatement movements by the Register "R3050 Pos cash balances"
	And I close all client application windows
	* Select CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'R3050 Pos cash balances'    |
	And I close all client application windows


Scenario: _045406 check CashStatement movements by the Register  "R3011 Cash flow"
		And I close all client application windows
	* Select CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R3011 Cash flow"
		And I click "Registrations report info" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash statement 11 dated 23.06.2022 22:53:32' | ''                    | ''             | ''                        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| 'Register  "R3011 Cash flow"'                 | ''                    | ''             | ''                        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| ''                                            | 'Period'              | 'Company'      | 'Branch'                  | 'Account'            | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                            | '23.06.2022 22:53:32' | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | '200'    | 'No'                   |
			| ''                                            | '23.06.2022 22:53:32' | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | '200'    | 'No'                   |
			| ''                                            | '23.06.2022 22:53:32' | 'Main Company' | 'Distribution department' | 'POS account 1, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | '34,24'  | 'No'                   |	
		And I close all client application windows

Scenario: _045430 Cash statement clear posting/mark for deletion
	And I close all client application windows
	* Select CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash statement 11 dated 23.06.2022 22:53:32'    |
			| 'Document registrations records'                 |
		And I close current window
	* Post Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'                  |
			| 'R3021 Cash in transit (incoming)'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash statement 11 dated 23.06.2022 22:53:32'    |
			| 'Document registrations records'                 |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'                  |
			| 'R3021 Cash in transit (incoming)'    |
		And I close all client application windows
