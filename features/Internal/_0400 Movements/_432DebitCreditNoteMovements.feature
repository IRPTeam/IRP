#language: en
@tree
@Positive
@Movements2
@MovementsDebitCreditNote

Feature: check Credit note movements


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _043200 preparation (DebitCreditNote)
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
		When Create catalog LegalNameContracts objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create OtherPartners objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create information register Taxes records (VAT)
		When Create catalog ReportOptions objects (R5020_PartnersBalance)
		* Create test data for DebitCreditNote
			When import data for debit credit note
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(325).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(326).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(327).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(328).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(114).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.BankReceipt.FindByNumber(526).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.BankPayment.FindByNumber(526).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"      |
			And I execute 1C:Enterprise script at server
				| "Documents.DebitCreditNote.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"      |
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	

Scenario: _0432001 check preparation
	When check preparation


Scenario: _0432002 check DebitCreditNote movements by the register "R2020 Advances from customer" (CA-CT, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 2 dated 20.02.2024 13:27:56' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                         | ''        | ''                     | ''                           |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                         | ''        | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'      | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                         | ''        | ''                     | ''                           |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                         | ''        | 'Attributes'           | ''                           |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                         | 'Partner'                            | 'Order' | 'Agreement'                | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | 'Expense'     | '20.02.2024 13:27:56' | '85,6'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 13:27:56' | '500'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 13:27:56' | '500'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |		
	And I close all client application windows
	
Scenario: _0432003 check DebitCreditNote movements by the register "R2021 Customer transactions" (CA-CT, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 2 dated 20.02.2024 13:27:56' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''                                            | ''      | ''        | ''                     | ''                           |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''                                            | ''      | ''        | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'       | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''                                            | ''      | ''        | ''                     | ''                           |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''                                            | ''      | ''        | 'Attributes'           | ''                           |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                         | 'Partner'                            | 'Agreement'                | 'Basis'                                       | 'Order' | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | 'Expense'     | '20.02.2024 13:27:56' | '85,6'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'Sales invoice 116 dated 19.02.2024 19:49:32' | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 13:27:56' | '500'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'Sales invoice 116 dated 19.02.2024 19:49:32' | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 13:27:56' | '500'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'Sales invoice 116 dated 19.02.2024 19:49:32' | ''      | ''        | 'No'                   | ''                           |		
	And I close all client application windows					

Scenario: _0432004 check DebitCreditNote movements by the register "T2014 Advances info" (CA-CT, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 2 dated 20.02.2024 13:27:56' | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                         | ''        |
			| 'Document registrations records'                | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                         | ''        |
			| 'Register  "T2014 Advances info"'               | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                         | ''        |
			| ''                                              | 'Resources' | ''                        | ''                     | ''            | 'Dimensions'   | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                         | ''        |
			| ''                                              | 'Amount'    | 'Is purchase order close' | 'Is sales order close' | 'Record type' | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                            | 'Legal name'                         | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'        | 'Project' |
			| ''                                              | '500'       | 'No'                      | 'No'                   | 'Expense'     | 'Main Company' | 'Front office' | '20.02.2024 13:27:56' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, TRY' | ''        |
	And I close all client application windows

Scenario: _0432005 check DebitCreditNote movements by the register  "T2015 Transactions info" (CA-CT, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 2 dated 20.02.2024 13:27:56' | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                                            | ''          | ''        |
			| 'Document registrations records'                | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                                            | ''          | ''        |
			| 'Register  "T2015 Transactions info"'           | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                                            | ''          | ''        |
			| ''                                              | 'Resources' | ''       | ''        | 'Dimensions'   | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                                            | ''          | ''        |
			| ''                                              | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                            | 'Legal name'                         | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                           | 'Unique ID' | 'Project' |
			| ''                                              | '500'       | 'No'     | 'Yes'     | 'Main Company' | 'Front office' | ''      | '20.02.2024 13:27:56' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | 'Sales invoice 116 dated 19.02.2024 19:49:32' | '*'         | ''        |
	And I close all client application windows

Scenario: _0432006 check DebitCreditNote movements by the register  "R5020 Partners balance" (CA-CT, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R5020 Partners balance"
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 2 dated 20.02.2024 13:27:56' | ''                    | ''           | ''             | ''             | ''                                   | ''                                   | ''                         | ''                                            | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''                    | ''           | ''             | ''             | ''                                   | ''                                   | ''                         | ''                                            | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Partner'                            | 'Legal name'                         | 'Agreement'                | 'Document'                                    | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                              | '20.02.2024 13:27:56' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'Local currency'               | 'TRY'                  | '500'    | ''                     | '500'              | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '20.02.2024 13:27:56' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'en description is empty'      | 'TRY'                  | '500'    | ''                     | '500'              | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '20.02.2024 13:27:56' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''                                            | 'USD'      | 'Reporting currency'           | 'TRY'                  | '85,6'   | ''                     | '85,6'             | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '20.02.2024 13:27:56' | 'Expense'    | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'Sales invoice 116 dated 19.02.2024 19:49:32' | 'TRY'      | 'Local currency'               | 'TRY'                  | '500'    | '500'                  | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '20.02.2024 13:27:56' | 'Expense'    | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'Sales invoice 116 dated 19.02.2024 19:49:32' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '500'    | '500'                  | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '20.02.2024 13:27:56' | 'Expense'    | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'Sales invoice 116 dated 19.02.2024 19:49:32' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '85,6'   | '85,6'                 | ''                 | ''                   | ''               | ''                  | ''                 |		
	And I close all client application windows

Scenario: _0432007 check DebitCreditNote absence movements by the register  "R5010 Reconciliation statement" (same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement"'    |
	And I close all client application windows

#
Scenario: _0432008 check DebitCreditNote movements by the register "R2021 Customer transactions" (CT-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''      | ''      | ''        | ''                     | ''                           |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''      | ''      | ''        | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'       | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''      | ''      | ''        | ''                     | ''                           |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''                         | ''      | ''      | ''        | 'Attributes'           | ''                           |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                         | 'Partner'                            | 'Agreement'                | 'Basis' | 'Order' | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '20,72'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''      | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '121'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''      | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '121'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''      | ''      | ''        | 'No'                   | ''                           |	
	And I close all client application windows
	
Scenario: _0432009 check DebitCreditNote movements by the register "R1020 Advances to vendors" (CT-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R1020 Advances to vendors"
		And I click "Registrations report" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                      | ''        | ''                     | ''                         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                      | ''        | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'         | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                      | ''        | ''                     | ''                         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                      | ''        | 'Attributes'           | ''                         |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                         | 'Partner'                            | 'Order' | 'Agreement'             | 'Project' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | 'Receipt'     | '20.02.2024 10:01:09' | '20,72'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents)' | ''        | 'No'                   | ''                         |
			| ''                                              | 'Receipt'     | '20.02.2024 10:01:09' | '121'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents)' | ''        | 'No'                   | ''                         |
			| ''                                              | 'Receipt'     | '20.02.2024 10:01:09' | '121'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents)' | ''        | 'No'                   | ''                         |	
	And I close all client application windows					

Scenario: _0432010 check DebitCreditNote movements by the register "T2014 Advances info" (CT-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                      | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'               | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                      | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                              | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                            | 'Legal name'                         | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'     | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                              | 'Main Company' | 'Front office' | '20.02.2024 10:01:09' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Yes'               | 'No'                  | '*'         | 'Vendor (by documents)' | ''        | '121'    | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0432011 check DebitCreditNote movements by the register  "T2015 Transactions info" (CT-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                  | ''          | ''        |
			| 'Document registrations records'                | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                  | ''          | ''        |
			| 'Register  "T2015 Transactions info"'           | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                  | ''          | ''        |
			| ''                                              | 'Resources' | ''       | ''        | 'Dimensions'   | ''             | ''      | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''                         | ''                      | ''                        | ''                  | ''          | ''        |
			| ''                                              | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                            | 'Legal name'                         | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' | 'Project' |
			| ''                                              | '121'       | 'No'     | 'Yes'     | 'Main Company' | 'Front office' | ''      | '20.02.2024 10:01:09' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | 'No'                    | 'Yes'                     | ''                  | '*'         | ''        |
	And I close all client application windows

Scenario: _0432012 check DebitCreditNote movements by the register  "R5020 Partners balance" (CT-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5020 Partners balance"
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                         | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                         | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                         | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'   | ''             | ''                                   | ''                                   | ''                         | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'      | 'Branch'       | 'Partner'                            | 'Legal name'                         | 'Agreement'                | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                              | 'Receipt'     | '20.02.2024 10:01:09' | '20,72'     | ''                     | ''                 | ''                   | '20,72'          | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents)'    | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                              | 'Receipt'     | '20.02.2024 10:01:09' | '121'       | ''                     | ''                 | ''                   | '121'            | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents)'    | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | ''                 |
			| ''                                              | 'Receipt'     | '20.02.2024 10:01:09' | '121'       | ''                     | ''                 | ''                   | '121'            | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents)'    | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '20,72'     | '20,72'                | ''                 | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '121'       | '121'                  | ''                 | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '121'       | '121'                  | ''                 | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |	
	And I close all client application windows

#
Scenario: _0432013 check DebitCreditNote movements by the register "R2020 Advances from customer" (CA-CA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 3 dated 30.03.2024 11:34:17' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                                 | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'      | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                                 | ''        | ''       | ''                     | ''                           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                         | 'Partner'                            | 'Order' | 'Agreement'                        | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | '30.03.2024 11:34:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, without VAT' | ''        | '128'    | 'No'                   | ''                           |
			| ''                                              | '30.03.2024 11:34:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, without VAT' | ''        | '21,91'  | 'No'                   | ''                           |
			| ''                                              | '30.03.2024 11:34:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, without VAT' | ''        | '128'    | 'No'                   | ''                           |
			| ''                                              | '30.03.2024 11:34:17' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, TRY'         | ''        | '128'    | 'No'                   | ''                           |
			| ''                                              | '30.03.2024 11:34:17' | 'Expense'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, TRY'         | ''        | '21,91'  | 'No'                   | ''                           |
			| ''                                              | '30.03.2024 11:34:17' | 'Expense'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Basic Partner terms, TRY'         | ''        | '128'    | 'No'                   | ''                           |	
	And I close all client application windows
					
Scenario: _0432014 check DebitCreditNote movements by the register "T2014 Advances info" (CA-CA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 3 dated 30.03.2024 11:34:17' | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                                 | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'               | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                                 | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                              | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                            | 'Legal name'                         | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'                | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                              | 'Main Company' | 'Front office' | '30.03.2024 11:34:17' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, TRY'         | ''        | '128'    | 'No'                      | 'No'                   | 'Expense'     |
			| ''                                              | 'Main Company' | 'Front office' | '30.03.2024 11:34:17' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, without VAT' | ''        | '128'    | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0432015 check DebitCreditNote movements by the register  "R5020 Partners balance" (CA-CA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5020 Partners balance"
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 3 dated 30.03.2024 11:34:17' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                                 | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                                 | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                                 | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'   | ''             | ''                                   | ''                                   | ''                                 | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'      | 'Branch'       | 'Partner'                            | 'Legal name'                         | 'Agreement'                        | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                              | 'Receipt'     | '30.03.2024 11:34:17' | '21,91'     | ''                     | '21,91'            | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY'         | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                              | 'Receipt'     | '30.03.2024 11:34:17' | '128'       | ''                     | '128'              | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY'         | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | ''                 |
			| ''                                              | 'Receipt'     | '30.03.2024 11:34:17' | '128'       | ''                     | '128'              | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, TRY'         | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '30.03.2024 11:34:17' | '21,91'     | ''                     | '21,91'            | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, without VAT' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '30.03.2024 11:34:17' | '128'       | ''                     | '128'              | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, without VAT' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '30.03.2024 11:34:17' | '128'       | ''                     | '128'              | ''                   | ''               | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Basic Partner terms, without VAT' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |	
	And I close all client application windows

#
Scenario: _0432016 check DebitCreditNote movements by the register "R1020 Advances to vendors" (VA-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register "R1020 Advances to vendors" 
		And I click "Registrations report" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 4 dated 01.04.2024 11:48:58' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                        | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'         | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                   | ''                                   | ''      | ''                        | ''        | ''       | ''                     | ''                         |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                         | 'Partner'                            | 'Order' | 'Agreement'               | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | '01.04.2024 11:48:58' | 'Receipt'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents) 2' | ''        | '127'    | 'No'                   | ''                         |
			| ''                                              | '01.04.2024 11:48:58' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents) 2' | ''        | '21,74'  | 'No'                   | ''                         |
			| ''                                              | '01.04.2024 11:48:58' | 'Receipt'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents) 2' | ''        | '127'    | 'No'                   | ''                         |
			| ''                                              | '01.04.2024 11:48:58' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents)'   | ''        | '127'    | 'No'                   | ''                         |
			| ''                                              | '01.04.2024 11:48:58' | 'Expense'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents)'   | ''        | '21,74'  | 'No'                   | ''                         |
			| ''                                              | '01.04.2024 11:48:58' | 'Expense'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Vendor (by documents)'   | ''        | '127'    | 'No'                   | ''                         |	
	And I close all client application windows
					
Scenario: _0432017 check DebitCreditNote movements by the register "T2014 Advances info" (VA-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 4 dated 01.04.2024 11:48:58' | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                        | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'               | ''             | ''             | ''                    | ''                                     | ''         | ''                                   | ''                                   | ''      | ''                  | ''                    | ''          | ''                        | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                              | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                            | 'Legal name'                         | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'       | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                              | 'Main Company' | 'Front office' | '01.04.2024 11:48:58' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Yes'               | 'No'                  | '*'         | 'Vendor (by documents)'   | ''        | '127'    | 'No'                      | 'No'                   | 'Expense'     |
			| ''                                              | 'Main Company' | 'Front office' | '01.04.2024 11:48:58' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'Yes'               | 'No'                  | '*'         | 'Vendor (by documents) 2' | ''        | '127'    | 'No'                      | 'No'                   | 'Receipt'     |
	And I close all client application windows

Scenario: _0432018 check DebitCreditNote movements by the register  "R5020 Partners balance" (VA-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R5020 Partners balance"
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 4 dated 01.04.2024 11:48:58' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''             | ''                                   | ''                                   | ''                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'   | ''             | ''                                   | ''                                   | ''                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'      | 'Branch'       | 'Partner'                            | 'Legal name'                         | 'Agreement'               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                              | 'Receipt'     | '01.04.2024 11:48:58' | '21,74'     | ''                     | ''                 | ''                   | '21,74'          | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents) 2' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                              | 'Receipt'     | '01.04.2024 11:48:58' | '127'       | ''                     | ''                 | ''                   | '127'            | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents) 2' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | ''                 |
			| ''                                              | 'Receipt'     | '01.04.2024 11:48:58' | '127'       | ''                     | ''                 | ''                   | '127'            | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents) 2' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '01.04.2024 11:48:58' | '21,74'     | ''                     | ''                 | ''                   | '21,74'          | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents)'   | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '01.04.2024 11:48:58' | '127'       | ''                     | ''                 | ''                   | '127'            | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents)'   | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | ''                 |
			| ''                                              | 'Expense'     | '01.04.2024 11:48:58' | '127'       | ''                     | ''                 | ''                   | '127'            | ''                  | 'Main Company' | 'Front office' | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | 'Vendor (by documents)'   | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
	And I close all client application windows

#
Scenario: _0432019 check DebitCreditNote movements by the register "R2021 Customer transactions" (CT-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 5 dated 02.04.2024 13:06:46' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                                          | ''                                          | ''                                          | ''      | ''      | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'       | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                                          | ''                                          | ''                                          | ''      | ''      | ''        | ''       | ''                     | ''                           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                                | 'Partner'                                   | 'Agreement'                                 | 'Basis' | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | '02.04.2024 13:06:46' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | '111'    | 'No'                   | ''                           |
			| ''                                              | '02.04.2024 13:06:46' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | '19'     | 'No'                   | ''                           |
			| ''                                              | '02.04.2024 13:06:46' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | '111'    | 'No'                   | ''                           |
			| ''                                              | '02.04.2024 13:06:46' | 'Expense'    | 'Main Company' | 'Front office'            | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | '111'    | 'No'                   | ''                           |
			| ''                                              | '02.04.2024 13:06:46' | 'Expense'    | 'Main Company' | 'Front office'            | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | '19'     | 'No'                   | ''                           |
			| ''                                              | '02.04.2024 13:06:46' | 'Expense'    | 'Main Company' | 'Front office'            | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | '111'    | 'No'                   | ''                           |		
	And I close all client application windows
					
Scenario: _0432020 check DebitCreditNote movements by the register "T2015 Transactions info" (CT-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 5 dated 02.04.2024 13:06:46' | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''                                          | ''                                          | ''                                          | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'           | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''                                          | ''                                          | ''                                          | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| ''                                              | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                                   | 'Legal name'                                | 'Agreement'                                 | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                              | 'Main Company' | 'Front office'            | ''      | '02.04.2024 13:06:46' | '                                    ' | 'TRY'      | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | 'No'                    | 'Yes'                     | ''                  | '*'         | ''        | '111'    | 'No'     | 'Yes'     |
			| ''                                              | 'Main Company' | 'Distribution department' | ''      | '02.04.2024 13:06:46' | '                                    ' | 'TRY'      | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | 'No'                    | 'Yes'                     | ''                  | '*'         | ''        | '111'    | 'Yes'    | 'No'      |
	And I close all client application windows

#
Scenario: _0432021 check DebitCreditNote movements by the register "R1021 Vendors transactions" (CT-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '6'         |
	* Check movements by the Register "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 6 dated 26.04.2024 13:20:20' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                                       | ''                                       | ''            | ''      | ''      | ''        | ''                     | ''                         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                                       | ''                                       | ''            | ''      | ''      | ''        | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'        | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''                                       | ''                                       | ''            | ''      | ''      | ''        | ''                     | ''                         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                     | ''                                       | ''                                       | ''            | ''      | ''      | ''        | 'Attributes'           | ''                         |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                             | 'Partner'                                | 'Agreement'   | 'Basis' | 'Order' | 'Project' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | 'Receipt'     | '26.04.2024 13:20:20' | '18,66'     | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | ''      | ''      | ''        | 'No'                   | ''                         |
			| ''                                              | 'Receipt'     | '26.04.2024 13:20:20' | '109'       | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | ''      | ''      | ''        | 'No'                   | ''                         |
			| ''                                              | 'Receipt'     | '26.04.2024 13:20:20' | '109'       | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | ''      | ''      | ''        | 'No'                   | ''                         |
			| ''                                              | 'Expense'     | '26.04.2024 13:20:20' | '18,66'     | 'Main Company' | 'Front office'            | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | ''      | ''      | ''        | 'No'                   | ''                         |
			| ''                                              | 'Expense'     | '26.04.2024 13:20:20' | '109'       | 'Main Company' | 'Front office'            | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | ''      | ''      | ''        | 'No'                   | ''                         |
			| ''                                              | 'Expense'     | '26.04.2024 13:20:20' | '109'       | 'Main Company' | 'Front office'            | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | ''      | ''      | ''        | 'No'                   | ''                         |		
	And I close all client application windows
					
Scenario: _0432022 check DebitCreditNote movements by the register "T2015 Transactions info" (VT-VT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '6'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 6 dated 26.04.2024 13:20:20' | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''            | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'           | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''            | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| ''                                              | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                                | 'Legal name'                             | 'Agreement'   | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                              | 'Main Company' | 'Front office'            | ''      | '26.04.2024 13:20:20' | '                                    ' | 'TRY'      | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | 'Yes'                   | 'No'                      | ''                  | '*'         | ''        | '109'    | 'No'     | 'Yes'     |
			| ''                                              | 'Main Company' | 'Distribution department' | ''      | '26.04.2024 13:20:20' | '                                    ' | 'TRY'      | 'Vendor (Transactions, by partner term)' | 'Vendor (Transactions, by partner term)' | 'Vendor, TRY' | 'Yes'                   | 'No'                      | ''                  | '*'         | ''        | '109'    | 'Yes'    | 'No'      |
	And I close all client application windows

#
Scenario: _0432021 check DebitCreditNote movements by the register "R1021 Vendors transactions" (VA-VT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '7'         |
	* Check movements by the Register "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 7 dated 26.04.2024 13:31:41' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'        | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | ''       | ''                     | ''                         |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                          | 'Partner'                             | 'Agreement'                           | 'Basis' | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | '21'     | 'No'                   | ''                         |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | '3,6'    | 'No'                   | ''                         |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | '21'     | 'No'                   | ''                         |		
	And I close all client application windows
					
Scenario: _0432022 check DebitCreditNote movements by the register "R1020 Advances to vendors" (VA-VT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '7'         |
	* Check movements by the Register  "R1020 Advances to vendors"
		And I click "Registrations report info" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 7 dated 26.04.2024 13:31:41' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                               | ''                               | ''      | ''                               | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'         | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                               | ''                               | ''      | ''                               | ''        | ''       | ''                     | ''                         |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                     | 'Partner'                        | 'Order' | 'Agreement'                      | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor (Advance, by documents)' | 'Vendor (Advance, by documents)' | ''      | 'Vendor (Advance, by documents)' | ''        | '21'     | 'No'                   | ''                         |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor (Advance, by documents)' | 'Vendor (Advance, by documents)' | ''      | 'Vendor (Advance, by documents)' | ''        | '3,6'    | 'No'                   | ''                         |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor (Advance, by documents)' | 'Vendor (Advance, by documents)' | ''      | 'Vendor (Advance, by documents)' | ''        | '21'     | 'No'                   | ''                         |	
	And I close all client application windows

Scenario: _0432022 check DebitCreditNote movements by the register "R5020 Partners balance" (VA-VT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '7'         |
	* Check movements by the Register  "R5020 Partners balance"
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 7 dated 26.04.2024 13:31:41' | ''                    | ''           | ''             | ''             | ''                                    | ''                                    | ''                                    | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''                    | ''           | ''             | ''             | ''                                    | ''                                    | ''                                    | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Partner'                             | 'Legal name'                          | 'Agreement'                           | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                              | '26.04.2024 13:31:41' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '21'     | ''                     | ''                 | '21'                 | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 13:31:41' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '21'     | ''                     | ''                 | '21'                 | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 13:31:41' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '3,6'    | ''                     | ''                 | '3,6'                | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'Vendor (Advance, by documents)'      | 'Vendor (Advance, by documents)'      | 'Vendor (Advance, by documents)'      | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '21'     | ''                     | ''                 | ''                   | '21'             | ''                  | ''                 |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'Vendor (Advance, by documents)'      | 'Vendor (Advance, by documents)'      | 'Vendor (Advance, by documents)'      | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '21'     | ''                     | ''                 | ''                   | '21'             | ''                  | ''                 |
			| ''                                              | '26.04.2024 13:31:41' | 'Expense'    | 'Main Company' | 'Front office' | 'Vendor (Advance, by documents)'      | 'Vendor (Advance, by documents)'      | 'Vendor (Advance, by documents)'      | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '3,6'    | ''                     | ''                 | ''                   | '3,6'            | ''                  | ''                 |		
	And I close all client application windows

Scenario: _0432023 check DebitCreditNote movements by the register "T2014 Advances info" (VA-VT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '7'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 7 dated 26.04.2024 13:31:41' | ''             | ''             | ''                    | ''                                     | ''         | ''                               | ''                               | ''      | ''                  | ''                    | ''                                     | ''                               | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'               | ''             | ''             | ''                    | ''                                     | ''         | ''                               | ''                               | ''      | ''                  | ''                    | ''                                     | ''                               | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                              | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                        | 'Legal name'                     | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID'                            | 'Advance agreement'              | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                              | 'Main Company' | 'Front office' | '26.04.2024 13:31:41' | '                                    ' | 'TRY'      | 'Vendor (Advance, by documents)' | 'Vendor (Advance, by documents)' | ''      | 'Yes'               | 'No'                  | '0659f197-5430-4cb3-8196-58d99398ce12' | 'Vendor (Advance, by documents)' | ''        | '21'     | 'No'                      | 'No'                   | 'Expense'     |		
	And I close all client application windows

Scenario: _0432023 check DebitCreditNote movements by the register "T2015 Transactions info" (VA-VT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '7'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 7 dated 26.04.2024 13:31:41' | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                    | ''                                    | ''                                    | ''                      | ''                        | ''                  | ''                                     | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'           | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                    | ''                                    | ''                                    | ''                      | ''                        | ''                  | ''                                     | ''        | ''       | ''       | ''        |
			| ''                                              | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                             | 'Legal name'                          | 'Agreement'                           | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID'                            | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                              | 'Main Company' | 'Front office' | ''      | '26.04.2024 13:31:41' | '                                    ' | 'TRY'      | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Yes'                   | 'No'                      | ''                  | '993354d6-fa9b-4681-92fb-af045c23cdb2' | ''        | '21'     | 'No'     | 'Yes'     |		
	And I close all client application windows

#
Scenario: _0432021 check DebitCreditNote movements by the register "R1021 Vendors transactions" (VT-CA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 8 dated 03.04.2024 14:19:17' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'        | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | ''       | ''                     | ''                         |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                          | 'Partner'                             | 'Agreement'                           | 'Basis' | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | '03.04.2024 14:19:17' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | '41'     | 'No'                   | ''                         |
			| ''                                              | '03.04.2024 14:19:17' | 'Expense'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | '7,02'   | 'No'                   | ''                         |
			| ''                                              | '03.04.2024 14:19:17' | 'Expense'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | '41'     | 'No'                   | ''                         |		
	And I close all client application windows
					
Scenario: _0432022 check DebitCreditNote movements by the register "R2020 Advances from customer" (VT-CA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R1020 Advances to vendors"
		And I click "Registrations report info" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 8 dated 03.04.2024 14:19:17' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                 | ''                                 | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'      | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                 | ''                                 | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                       | 'Partner'                          | 'Order' | 'Agreement'                | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | '03.04.2024 14:19:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer (Advance, by documents)' | 'Customer (Advance, by documents)' | ''      | 'Basic Partner terms, TRY' | ''        | '41'     | 'No'                   | ''                           |
			| ''                                              | '03.04.2024 14:19:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer (Advance, by documents)' | 'Customer (Advance, by documents)' | ''      | 'Basic Partner terms, TRY' | ''        | '7,02'   | 'No'                   | ''                           |
			| ''                                              | '03.04.2024 14:19:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer (Advance, by documents)' | 'Customer (Advance, by documents)' | ''      | 'Basic Partner terms, TRY' | ''        | '41'     | 'No'                   | ''                           |		
	And I close all client application windows

Scenario: _0432022 check DebitCreditNote movements by the register "R5020 Partners balance" (VT-CA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R5020 Partners balance"
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 8 dated 03.04.2024 14:19:17' | ''                    | ''           | ''             | ''             | ''                                    | ''                                    | ''                                    | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''                    | ''           | ''             | ''             | ''                                    | ''                                    | ''                                    | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Partner'                             | 'Legal name'                          | 'Agreement'                           | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                              | '03.04.2024 14:19:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '41'     | ''                     | ''                 | '41'                 | ''               | ''                  | ''                 |
			| ''                                              | '03.04.2024 14:19:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '41'     | ''                     | ''                 | '41'                 | ''               | ''                  | ''                 |
			| ''                                              | '03.04.2024 14:19:17' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '7,02'   | ''                     | ''                 | '7,02'               | ''               | ''                  | ''                 |
			| ''                                              | '03.04.2024 14:19:17' | 'Expense'    | 'Main Company' | 'Front office' | 'Customer (Advance, by documents)'    | 'Customer (Advance, by documents)'    | 'Basic Partner terms, TRY'            | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '41'     | ''                     | '41'               | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '03.04.2024 14:19:17' | 'Expense'    | 'Main Company' | 'Front office' | 'Customer (Advance, by documents)'    | 'Customer (Advance, by documents)'    | 'Basic Partner terms, TRY'            | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '41'     | ''                     | '41'               | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '03.04.2024 14:19:17' | 'Expense'    | 'Main Company' | 'Front office' | 'Customer (Advance, by documents)'    | 'Customer (Advance, by documents)'    | 'Basic Partner terms, TRY'            | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '7,02'   | ''                     | '7,02'             | ''                   | ''               | ''                  | ''                 |		
	And I close all client application windows

Scenario: _0432023 check DebitCreditNote movements by the register "T2014 Advances info" (VT-CA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 8 dated 03.04.2024 14:19:17' | ''             | ''             | ''                    | ''                                     | ''         | ''                                 | ''                                 | ''      | ''                  | ''                    | ''                                     | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'               | ''             | ''             | ''                    | ''                                     | ''         | ''                                 | ''                                 | ''      | ''                  | ''                    | ''                                     | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                              | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                          | 'Legal name'                       | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID'                            | 'Advance agreement'        | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                              | 'Main Company' | 'Front office' | '03.04.2024 14:19:17' | '                                    ' | 'TRY'      | 'Customer (Advance, by documents)' | 'Customer (Advance, by documents)' | ''      | 'No'                | 'Yes'                 | 'eafca00f-1f08-4972-8605-d72b8527e3b3' | 'Basic Partner terms, TRY' | ''        | '41'     | 'No'                      | 'No'                   | 'Receipt'     |	
	And I close all client application windows

Scenario: _0432023 check DebitCreditNote movements by the register "T2015 Transactions info" (VT-CA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 8 dated 03.04.2024 14:19:17' | ''             | ''             | ''                    | ''                                     | ''         | ''                                 | ''                                 | ''      | ''                  | ''                    | ''                                     | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'               | ''             | ''             | ''                    | ''                                     | ''         | ''                                 | ''                                 | ''      | ''                  | ''                    | ''                                     | ''                         | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                              | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                          | 'Legal name'                       | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID'                            | 'Advance agreement'        | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                              | 'Main Company' | 'Front office' | '03.04.2024 14:19:17' | '                                    ' | 'TRY'      | 'Customer (Advance, by documents)' | 'Customer (Advance, by documents)' | ''      | 'No'                | 'Yes'                 | 'eafca00f-1f08-4972-8605-d72b8527e3b3' | 'Basic Partner terms, TRY' | ''        | '41'     | 'No'                      | 'No'                   | 'Receipt'     |	
	And I close all client application windows

##
Scenario: _0432021 check DebitCreditNote movements by the register "R1021 Vendors transactions" (VT-CT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 9 dated 26.04.2024 16:15:09' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | ''                     | ''                         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'        | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | ''                     | ''                         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                    | ''                                    | ''                                    | ''      | ''      | ''        | 'Attributes'           | ''                         |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                          | 'Partner'                             | 'Agreement'                           | 'Basis' | 'Order' | 'Project' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                              | 'Expense'     | '26.04.2024 16:15:09' | '8,73'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | 'No'                   | ''                         |
			| ''                                              | 'Expense'     | '26.04.2024 16:15:09' | '51'        | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | 'No'                   | ''                         |
			| ''                                              | 'Expense'     | '26.04.2024 16:15:09' | '51'        | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | 'Vendor (Transactions, by documents)' | ''      | ''      | ''        | 'No'                   | ''                         |		
	And I close all client application windows
					
Scenario: _0432022 check DebitCreditNote movements by the register "R2021 Customer transactions" (VT-CT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 9 dated 26.04.2024 16:15:09' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                      | ''                                      | ''                         | ''      | ''      | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'       | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                      | ''                                      | ''                         | ''      | ''      | ''        | ''       | ''                     | ''                           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                            | 'Partner'                               | 'Agreement'                | 'Basis' | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | '26.04.2024 16:15:09' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer (Transactions, by documents)' | 'Customer (Transactions, by documents)' | 'Basic Partner terms, TRY' | ''      | ''      | ''        | '51'     | 'No'                   | ''                           |
			| ''                                              | '26.04.2024 16:15:09' | 'Expense'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer (Transactions, by documents)' | 'Customer (Transactions, by documents)' | 'Basic Partner terms, TRY' | ''      | ''      | ''        | '8,73'   | 'No'                   | ''                           |
			| ''                                              | '26.04.2024 16:15:09' | 'Expense'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer (Transactions, by documents)' | 'Customer (Transactions, by documents)' | 'Basic Partner terms, TRY' | ''      | ''      | ''        | '51'     | 'No'                   | ''                           |		
	And I close all client application windows

Scenario: _0432022 check DebitCreditNote movements by the register "R5020 Partners balance" (VT-CT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R5020 Partners balance"
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 9 dated 26.04.2024 16:15:09' | ''                    | ''           | ''             | ''             | ''                                      | ''                                      | ''                                    | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'            | ''                    | ''           | ''             | ''             | ''                                      | ''                                      | ''                                    | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Partner'                               | 'Legal name'                            | 'Agreement'                           | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                              | '26.04.2024 16:15:09' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '51'     | ''                     | ''                 | '51'                 | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 16:15:09' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '51'     | ''                     | ''                 | '51'                 | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 16:15:09' | 'Receipt'    | 'Main Company' | 'Front office' | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '8,73'   | ''                     | ''                 | '8,73'               | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 16:15:09' | 'Expense'    | 'Main Company' | 'Front office' | 'Customer (Transactions, by documents)' | 'Customer (Transactions, by documents)' | 'Basic Partner terms, TRY'            | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '51'     | '51'                   | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 16:15:09' | 'Expense'    | 'Main Company' | 'Front office' | 'Customer (Transactions, by documents)' | 'Customer (Transactions, by documents)' | 'Basic Partner terms, TRY'            | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '51'     | '51'                   | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                              | '26.04.2024 16:15:09' | 'Expense'    | 'Main Company' | 'Front office' | 'Customer (Transactions, by documents)' | 'Customer (Transactions, by documents)' | 'Basic Partner terms, TRY'            | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '8,73'   | '8,73'                 | ''                 | ''                   | ''               | ''                  | ''                 |		
	And I close all client application windows


Scenario: _0432023 check DebitCreditNote movements by the register "T2015 Transactions info" (VT-CT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 9 dated 26.04.2024 16:15:09' | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                      | ''                                      | ''                                    | ''                      | ''                        | ''                  | ''                                     | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'           | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                      | ''                                      | ''                                    | ''                      | ''                        | ''                  | ''                                     | ''        | ''       | ''       | ''        |
			| ''                                              | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                               | 'Legal name'                            | 'Agreement'                           | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID'                            | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                              | 'Main Company' | 'Front office' | ''      | '26.04.2024 16:15:09' | '                                    ' | 'TRY'      | 'Customer (Transactions, by documents)' | 'Customer (Transactions, by documents)' | 'Basic Partner terms, TRY'            | 'No'                    | 'Yes'                     | ''                  | 'b5e9a76b-1cff-4ccd-8363-32ee8b3ac699' | ''        | '51'     | 'No'     | 'Yes'     |
			| ''                                              | 'Main Company' | 'Front office' | ''      | '26.04.2024 16:15:09' | '                                    ' | 'TRY'      | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)'   | 'Vendor (Transactions, by documents)' | 'Yes'                   | 'No'                      | ''                  | '509a6815-edab-405e-b07c-9b688d7f65ad' | ''        | '51'     | 'No'     | 'Yes'     |
	And I close all client application windows