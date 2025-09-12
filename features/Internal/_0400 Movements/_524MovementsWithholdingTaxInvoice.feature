#language: en
@tree
@Positive
@Movements3
@MovementsWithholdingTaxInvoice

Feature: check With holding Tax Invoice Movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _052401 preparation (WithholdingTaxInvoice)
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
		When Create catalog Partners, Companies, Agreements for Tax authority
		When create documnets for WithholdingTaxInvoice (Movements)
		And I execute 1C:Enterprise script at server
			| "Documents.WithholdingTaxInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.WithholdingTaxInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.WithholdingTaxInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.WithholdingTaxInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.WithholdingTaxInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashPayment.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.CashPayment.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.CashPayment.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.CashPayment.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.BankPayment.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.BankPayment.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.BankPayment.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.BankPayment.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"           |
			| "Documents.BankPayment.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"           |
	And I close all client application windows
		
Scenario: _052402 check preparation
	When check preparation		

Scenario: _052403 check With holding Tax Invoice movements by register "Posted documents registry"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "Posted documents registry" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                                                    | ''                    | ''       | ''            | ''            | ''       | ''       | ''                      |
			| 'Register  "Posted documents registry"'               | ''                                                    | ''                    | ''       | ''            | ''            | ''       | ''       | ''                      |
			| ''                                                    | 'Document'                                            | 'Date'                | 'Number' | 'Create date' | 'Modify date' | 'Author' | 'Editor' | 'Manual movements edit' |
			| ''                                                    | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | '01.05.2025 13:00:00' | '1'      | '*'           | '*'           | 'CI'     | 'CI'     | 'No'                    |
		And I close all client application windows

Scenario: _052404 check With holding Tax Invoice movements by register "R1001 Purchases"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''             | ''       | ''                             | ''         | ''                                                    | ''             | ''                  | ''                                     | ''         | ''       | ''           | ''              | ''                     |
			| 'Register  "R1001 Purchases"'                         | ''                    | ''             | ''       | ''                             | ''         | ''                                                    | ''             | ''                  | ''                                     | ''         | ''       | ''           | ''              | ''                     |
			| ''                                                    | 'Period'              | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice'                                             | 'Item key'     | 'Serial lot number' | 'Row key'                              | 'Quantity' | 'Amount' | 'Net amount' | 'Offers amount' | 'Deferred calculation' |
			| ''                                                    | '01.05.2025 13:00:00' | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'Installation' | ''                  | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | '1'        | '150'    | '150'        | ''              | 'No'                   |
			| ''                                                    | '01.05.2025 13:00:00' | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'Installation' | ''                  | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | '1'        | '25,68'  | '25,68'      | ''              | 'No'                   |
			| ''                                                    | '01.05.2025 13:00:00' | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'Installation' | ''                  | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | '1'        | '150'    | '150'        | ''              | 'No'                   |
		And I close all client application windows

Scenario: _052405 check With holding Tax Invoice movements by register "R1021 Vendors transactions"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                                    | ''      | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'              | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                                    | ''      | ''        | ''       | ''                     | ''                         |
			| ''                                                    | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                               | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                                    | '01.05.2025 13:00:00' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''      | ''        | '150'    | 'No'                   | ''                         |
			| ''                                                    | '01.05.2025 13:00:00' | 'Receipt'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''      | ''        | '25,68'  | 'No'                   | ''                         |
			| ''                                                    | '01.05.2025 13:00:00' | 'Receipt'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''      | ''        | '150'    | 'No'                   | ''                         |
		And I close all client application windows

Scenario: _052406 check With holding Tax Invoice movements by register "R1040 Taxes outgoing"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "R1040 Taxes outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''           | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     | ''       |
			| 'Register  "R1040 Taxes outgoing"'                    | ''                    | ''           | ''             | ''       | ''    | ''         | ''             | ''                             | ''         | ''                     | ''       |
			| ''                                                    | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Tax' | 'Tax rate' | 'Invoice type' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Amount' |
			| ''                                                    | '01.05.2025 13:00:00' | 'Receipt'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Local currency'               | 'TRY'      | 'TRY'                  | '22,88'  |
			| ''                                                    | '01.05.2025 13:00:00' | 'Receipt'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'Reporting currency'           | 'USD'      | 'TRY'                  | '3,92'   |
			| ''                                                    | '01.05.2025 13:00:00' | 'Receipt'    | 'Main Company' | ''       | 'VAT' | '18%'      | 'Invoice'      | 'en description is empty'      | 'TRY'      | 'TRY'                  | '22,88'  |
		And I close all client application windows


Scenario: _052408 check With holding Tax Invoice movements by register "R5010 Reconciliation statement"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''           | ''             | ''       | ''         | ''                  | ''                    | ''       |
			| 'Register  "R5010 Reconciliation statement"'          | ''                    | ''           | ''             | ''       | ''         | ''                  | ''                    | ''       |
			| ''                                                    | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Currency' | 'Legal name'        | 'Legal name contract' | 'Amount' |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'TRY'      | 'Company Ferron BP' | ''                    | '150'    |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'TRY'      | 'Tax authority'     | ''                    | '37,5'   |		
		And I close all client application windows

Scenario: _052409 check With holding Tax Invoice movements by register "R5020 Partners balance" 
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''           | ''             | ''       | ''              | ''                  | ''                   | ''                                                    | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'                  | ''                    | ''           | ''             | ''       | ''              | ''                  | ''                   | ''                                                    | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                                    | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Partner'       | 'Legal name'        | 'Agreement'          | 'Document'                                            | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP'     | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'TRY'      | 'Local currency'               | 'TRY'                  | '150'    | ''                     | ''                 | '150'                | ''               | ''                  | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP'     | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '150'    | ''                     | ''                 | '150'                | ''               | ''                  | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Ferron BP'     | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '25,68'  | ''                     | ''                 | '25,68'              | ''               | ''                  | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Tax authority' | 'Tax authority'     | 'Tax'                | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'TRY'      | 'Local currency'               | 'TRY'                  | '37,5'   | ''                     | ''                 | ''                   | ''               | '37,5'              | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Tax authority' | 'Tax authority'     | 'Tax'                | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '37,5'   | ''                     | ''                 | ''                   | ''               | '37,5'              | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Tax authority' | 'Tax authority'     | 'Tax'                | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '6,42'   | ''                     | ''                 | ''                   | ''               | '6,42'              | ''                 |				
		And I close all client application windows

Scenario: _052410 check With holding Tax Invoice movements by register "R5022 Expenses"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''             | ''       | ''                        | ''             | ''             | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                          | ''                    | ''             | ''       | ''                        | ''             | ''             | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                                    | 'Period'              | 'Company'      | 'Branch' | 'Profit loss center'      | 'Expense type' | 'Item key'     | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                                    | '01.05.2025 13:00:00' | 'Main Company' | ''       | 'Distribution department' | ''             | 'Installation' | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '187,5'  | '150'               | ''            | ''                          |
			| ''                                                    | '01.05.2025 13:00:00' | 'Main Company' | ''       | 'Distribution department' | ''             | 'Installation' | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '187,5'  | '150'               | ''            | ''                          |
			| ''                                                    | '01.05.2025 13:00:00' | 'Main Company' | ''       | 'Distribution department' | ''             | 'Installation' | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '32,1'   | '25,68'             | ''            | ''                          |		
		And I close all client application windows

Scenario: _052411 check With holding Tax Invoice movements by register "T1040 Accounting amounts"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "T1040 Accounting amounts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''                                     | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''       | ''                   | ''                   | ''                     | ''                 |
			| 'Register  "T1040 Accounting amounts"'                | ''                    | ''                                     | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''       | ''                   | ''                   | ''                     | ''                 |
			| ''                                                    | 'Period'              | 'Row key'                              | 'Operation'               | 'Multi currency movement type' | 'Currency' | 'Revaluated currency' | 'Dr currency' | 'Cr currency' | 'Amount' | 'Dr currency amount' | 'Cr currency amount' | 'Deferred calculation' | 'Advances closing' |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | ''            | ''            | '150'    | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | ''            | ''            | '25,68'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | ''            | ''            | '150'    | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | ''            | ''            | '22,88'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | ''            | ''            | '3,92'   | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | ''            | ''            | '22,88'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | ''            | 'TRY'         | '37,5'   | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | ''            | 'TRY'         | '6,42'   | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '01.05.2025 13:00:00' | '6b2d9f85-c6d7-43b6-98d1-19eb1f80424a' | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | ''            | 'TRY'         | '37,5'   | ''                   | ''                   | 'No'                   | ''                 |
		And I close all client application windows

Scenario: _052412 check With holding Tax Invoice movements by register "T2015 Transactions info"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                                                    | ''                                     | ''                        | ''                             | ''                                     | ''                                                    | ''                             | ''                                                    | ''                                     | ''                             | ''                                                    | ''                                                    | ''                     | ''                     | ''                     | ''                          | ''                  |
			| 'Register  "T2015 Transactions info"'                 | ''                                                    | ''                                     | ''                        | ''                             | ''                                     | ''                                                    | ''                             | ''                                                    | ''                                     | ''                             | ''                                                    | ''                                                    | ''                     | ''                     | ''                     | ''                          | ''                  |
			| ''                                                    | 'Company'                                             | 'Branch'                               | 'Order'                   | 'Date'                         | 'Key'                                  | 'Currency'                                            | 'Partner'                      | 'Legal name'                                          | 'Agreement'                            | 'Is vendor transaction'        | 'Is customer transaction'                             | 'Transaction basis'                                   | 'Unique ID'            | 'Project'              | 'Amount'               | 'Is due'                    | 'Is paid'           |
			| ''                                                    | 'Main Company'                                        | ''                                     | ''                        | '01.05.2025 13:00:00'          | '                                    ' | 'TRY'                                                 | 'Ferron BP'                    | 'Company Ferron BP'                                   | 'Vendor Ferron, TRY'                   | 'Yes'                          | 'No'                                                  | 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | '*'                    | ''                     | '150'                  | 'Yes'                       | 'No'                |
	And I close all client application windows		

Scenario: _052413 check With holding Tax Invoice movements by register "R5015 Other partners transactions"
	And I close all client application windows
	* Open WithholdingTaxInvoice
		Given I open hyperlink "e1cib/list/Document.WithholdingTaxInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Withholding tax invoice 1 dated 01.05.2025 13:00:00' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''              | ''              | ''          | ''      | ''       | ''                     |
			| 'Register  "R5015 Other partners transactions"'       | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''              | ''              | ''          | ''      | ''       | ''                     |
			| ''                                                    | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'    | 'Partner'       | 'Agreement' | 'Basis' | 'Amount' | 'Deferred calculation' |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Tax authority' | 'Tax authority' | 'Tax'       | ''      | '37,5'   | 'No'                   |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Tax authority' | 'Tax authority' | 'Tax'       | ''      | '6,42'   | 'No'                   |
			| ''                                                    | '01.05.2025 13:00:00' | 'Expense'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Tax authority' | 'Tax authority' | 'Tax'       | ''      | '37,5'   | 'No'                   |		
	And I close all client application windows