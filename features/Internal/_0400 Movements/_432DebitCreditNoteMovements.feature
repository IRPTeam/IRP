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


Scenario: check DebitCreditNote movements by the register "R2020 Advances from customer" (CA-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''      | ''                            | ''        | ''                     | ''                           |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''      | ''                            | ''        | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'      | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''      | ''                            | ''        | ''                     | ''                           |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''      | ''                            | ''        | 'Attributes'           | ''                           |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                             | 'Partner'                                | 'Order' | 'Agreement'                   | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '85,6'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | ''      | 'Customer (by partner terms)' | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '500'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | ''      | 'Customer (by partner terms)' | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '500'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | ''      | 'Customer (by partner terms)' | ''        | 'No'                   | ''                           |
	And I close all client application windows
	
Scenario: check DebitCreditNote movements by the register "R2021 Customer transactions" (CA-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''                            | ''      | ''      | ''        | ''                     | ''                           |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''                            | ''      | ''      | ''        | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'       | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''                            | ''      | ''      | ''        | ''                     | ''                           |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                       | ''                                       | ''                            | ''      | ''      | ''        | 'Attributes'           | ''                           |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                             | 'Partner'                                | 'Agreement'                   | 'Basis' | 'Order' | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '85,6'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | 'Customer (by partner terms)' | ''      | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '500'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | 'Customer (by partner terms)' | ''      | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 10:01:09' | '500'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | 'Customer (by partner terms)' | ''      | ''      | ''        | 'No'                   | ''                           |	
	And I close all client application windows					

Scenario: check DebitCreditNote movements by the register "T2014 Advances info" (CA-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''      | ''                  | ''                    | ''          | ''                            | ''        |
			| 'Document registrations records'                | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''      | ''                  | ''                    | ''          | ''                            | ''        |
			| 'Register  "T2014 Advances info"'               | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''      | ''                  | ''                    | ''          | ''                            | ''        |
			| ''                                              | 'Resources' | ''                        | ''                     | ''            | 'Dimensions'   | ''             | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''      | ''                  | ''                    | ''          | ''                            | ''        |
			| ''                                              | 'Amount'    | 'Is purchase order close' | 'Is sales order close' | 'Record type' | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                                | 'Legal name'                             | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'           | 'Project' |
			| ''                                              | '500'       | 'No'                      | 'No'                   | ''            | 'Main Company' | 'Front office' | '20.02.2024 10:01:09' | '                                    ' | 'TRY'      | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | ''      | 'No'                | 'Yes'                 | '*'         | 'Customer (by partner terms)' | ''        |
	And I close all client application windows

Scenario: check DebitCreditNote movements by the register  "T2015 Transactions info" (CA-CT, by partner terms, same partner)
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
			| 'Debit/Credit note 1 dated 20.02.2024 10:01:09' | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''                            | ''                      | ''                        | ''                  | ''          | ''        |
			| 'Document registrations records'                | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''                            | ''                      | ''                        | ''                  | ''          | ''        |
			| 'Register  "T2015 Transactions info"'           | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''                            | ''                      | ''                        | ''                  | ''          | ''        |
			| ''                                              | 'Resources' | ''       | ''        | 'Dimensions'   | ''             | ''      | ''                    | ''                                     | ''         | ''                                       | ''                                       | ''                            | ''                      | ''                        | ''                  | ''          | ''        |
			| ''                                              | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                                | 'Legal name'                             | 'Agreement'                   | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' | 'Project' |
			| ''                                              | '500'       | 'No'     | 'Yes'     | 'Main Company' | 'Front office' | ''      | '20.02.2024 10:01:09' | '                                    ' | 'TRY'      | 'Vendor and Customer (by partner terms)' | 'Vendor and Customer (by partner terms)' | 'Customer (by partner terms)' | 'No'                    | 'Yes'                     | ''                  | '*'         | ''        |
	And I close all client application windows

Scenario: check DebitCreditNote movements by the register "R2020 Advances from customer" (CA-CT, by documents, same partner)
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
	
Scenario: check DebitCreditNote movements by the register "R2021 Customer transactions" (CA-CT, by documents, same partner)
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

Scenario: check DebitCreditNote movements by the register "T2014 Advances info" (CA-CT, by documents, same partner)
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
			| ''                                              | '500'       | 'No'                      | 'No'                   | ''            | 'Main Company' | 'Front office' | '20.02.2024 13:27:56' | '                                    ' | 'TRY'      | 'Vendor and Customer (by documents)' | 'Vendor and Customer (by documents)' | ''      | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, TRY' | ''        |
	And I close all client application windows

Scenario: check DebitCreditNote movements by the register  "T2015 Transactions info" (CA-CT, by documents, same partner)
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


Scenario: check DebitCreditNote movements by the register "R2020 Advances from customer" (CA-CT, by partner terms, diferent partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register "R2020 Advances from customer" 
		And I click "Registrations report info" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 3 dated 20.02.2024 20:53:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                     | ''                                     | ''      | ''                                     | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'      | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                                     | ''                                     | ''      | ''                                     | ''        | ''       | ''                     | ''                           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                           | 'Partner'                              | 'Order' | 'Agreement'                            | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | '20.02.2024 20:53:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer (Advance, by partner terms)' | 'Customer (Advance, by partner terms)' | ''      | 'Customer (Advance, by partner terms)' | ''        | '500'    | 'No'                   | ''                           |
			| ''                                              | '20.02.2024 20:53:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer (Advance, by partner terms)' | 'Customer (Advance, by partner terms)' | ''      | 'Customer (Advance, by partner terms)' | ''        | '85,6'   | 'No'                   | ''                           |
			| ''                                              | '20.02.2024 20:53:00' | 'Expense'    | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer (Advance, by partner terms)' | 'Customer (Advance, by partner terms)' | ''      | 'Customer (Advance, by partner terms)' | ''        | '500'    | 'No'                   | ''                           |
	And I close all client application windows
	
Scenario: check DebitCreditNote movements by the register "R2021 Customer transactions" (CA-CT, by partner terms, diferent partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 3 dated 20.02.2024 20:53:00' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                          | ''                                          | ''                                          | ''      | ''      | ''        | ''                     | ''                           |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                          | ''                                          | ''                                          | ''      | ''      | ''        | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'       | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                                          | ''                                          | ''                                          | ''      | ''      | ''        | ''                     | ''                           |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                                          | ''                                          | ''                                          | ''      | ''      | ''        | 'Attributes'           | ''                           |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'                                | 'Partner'                                   | 'Agreement'                                 | 'Basis' | 'Order' | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                              | 'Expense'     | '20.02.2024 20:53:00' | '85,6'      | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 20:53:00' | '500'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | 'No'                   | ''                           |
			| ''                                              | 'Expense'     | '20.02.2024 20:53:00' | '500'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer (Transacrions, by partner terms)' | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | ''      | ''      | ''        | 'No'                   | ''                           |		
	And I close all client application windows					

Scenario: check DebitCreditNote movements by the register "T2014 Advances info" (CA-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "T2014 Advances info"
		And I click "Registrations report" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 3 dated 20.02.2024 20:53:00' | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                     | ''                                     | ''      | ''                  | ''                    | ''          | ''                                     | ''        |
			| 'Document registrations records'                | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                     | ''                                     | ''      | ''                  | ''                    | ''          | ''                                     | ''        |
			| 'Register  "T2014 Advances info"'               | ''          | ''                        | ''                     | ''            | ''             | ''             | ''                    | ''                                     | ''         | ''                                     | ''                                     | ''      | ''                  | ''                    | ''          | ''                                     | ''        |
			| ''                                              | 'Resources' | ''                        | ''                     | ''            | 'Dimensions'   | ''             | ''                    | ''                                     | ''         | ''                                     | ''                                     | ''      | ''                  | ''                    | ''          | ''                                     | ''        |
			| ''                                              | 'Amount'    | 'Is purchase order close' | 'Is sales order close' | 'Record type' | 'Company'      | 'Branch'       | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                              | 'Legal name'                           | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'                    | 'Project' |
			| ''                                              | '500'       | 'No'                      | 'No'                   | ''            | 'Main Company' | 'Front office' | '20.02.2024 20:53:00' | '                                    ' | 'TRY'      | 'Customer (Advance, by partner terms)' | 'Customer (Advance, by partner terms)' | ''      | 'No'                | 'Yes'                 | '*'         | 'Customer (Advance, by partner terms)' | ''        |
	And I close all client application windows

Scenario: check DebitCreditNote movements by the register  "T2015 Transactions info" (CA-CT, by partner terms, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit/Credit note 3 dated 20.02.2024 20:53:00' | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                          | ''                                          | ''                                          | ''                      | ''                        | ''                  | ''          | ''        |
			| 'Document registrations records'                | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                          | ''                                          | ''                                          | ''                      | ''                        | ''                  | ''          | ''        |
			| 'Register  "T2015 Transactions info"'           | ''          | ''       | ''        | ''             | ''             | ''      | ''                    | ''                                     | ''         | ''                                          | ''                                          | ''                                          | ''                      | ''                        | ''                  | ''          | ''        |
			| ''                                              | 'Resources' | ''       | ''        | 'Dimensions'   | ''             | ''      | ''                    | ''                                     | ''         | ''                                          | ''                                          | ''                                          | ''                      | ''                        | ''                  | ''          | ''        |
			| ''                                              | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'                                   | 'Legal name'                                | 'Agreement'                                 | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' | 'Project' |
			| ''                                              | '500'       | 'No'     | 'Yes'     | 'Main Company' | 'Front office' | ''      | '20.02.2024 20:53:00' | '                                    ' | 'TRY'      | 'Customer (Transactions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | 'Customer (Transacrions, by partner terms)' | 'No'                    | 'Yes'                     | ''                  | '*'         | ''        |	
	And I close all client application windows