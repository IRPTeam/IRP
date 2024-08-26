#language: en
@tree
@Positive
@Advance

Feature: customers advances closing

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _1003000 preparation (customers advances closing)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
	* Load documents
		When Create document BankReceipt objects (advance)
		When Create document BankReceipt objects (advance, BR-SI)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashReceipt objects (advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		* Load SO
		When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
		When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
		When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server	
				| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"     |
		* Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrder objects (SI more than SO)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"     |
		* Load SI
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashReceipt objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CreditNote objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.CreditNote.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document DebitNote objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.DebitNote.FindByNumber(22).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.DebitNote.FindByNumber(23).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesReturn objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (advance, customers)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CustomersAdvancesClosing objects
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(17).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(18).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
		
Scenario: _10030001 check preparation
	When check preparation


Scenario: _1003002 create CustomersAdvancesClosing
	Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
	And I click the button named "FormCreate"
	And I input "12.01.2021 12:00:00" text in "Date" field
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	And I click Select button of "Begin of period" field
	And I input "12.01.2021" text in "Begin of period" field
	And I input "12.01.2021" text in "End of period" field
	And I click Choice button of the field named "Branch"
	And I go to line in "List" table
		| 'Description'               |
		| 'Distribution department'   |
	And I select current line in "List" table
	And I click the button named "FormPost"
	And I delete "$$NumberCustomersAdvancesClosing12012021$$" variable
	And I delete "$$CustomersAdvancesClosing12012021$$" variable
	And I delete "$$DateCustomersAdvancesClosing11022021$$" variable
	And I save the value of "Number" field as "$$NumberCustomersAdvancesClosing12012021$$"
	And I save the window as "$$CustomersAdvancesClosing12012021$$"
	And I save the value of the field named "Date" as "$$DateCustomersAdvancesClosing12012021$$"
	And I click "Post and close" button
	And I click the button named "FormCreate"
	And I input "27.01.2021 12:00:00" text in "Date" field
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	And I click Select button of "Begin of period" field
	And I input "27.01.2021" text in "Begin of period" field
	And I input "27.01.2021" text in "End of period" field
	And I click Choice button of the field named "Branch"
	And I go to line in "List" table
		| 'Description'               |
		| 'Distribution department'   |
	And I select current line in "List" table
	And I click the button named "FormPost"
	And I delete "$$NumberCustomersAdvancesClosing27012021$$" variable
	And I delete "$$CustomersAdvancesClosing27012021$$" variable
	And I delete "$$DateCustomersAdvancesClosing27012021$$" variable
	And I save the value of "Number" field as "$$NumberCustomersAdvancesClosing27012021$$"
	And I save the window as "$$CustomersAdvancesClosing27012021$$"
	And I save the value of the field named "Date" as "$$DateCustomersAdvancesClosing27012021$$"
	And I click "Post and close" button
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And "List" table contains lines
			| 'Number'                                       | 'Date'                  | 'Company'        | 'Begin of period'   | 'End of period'    |
			| '$$NumberCustomersAdvancesClosing12012021$$'   | '12.01.2021 12:00:00'   | 'Main Company'   | '12.01.2021'        | '12.01.2021'       |
			| '$$NumberCustomersAdvancesClosing27012021$$'   | '27.01.2021 12:00:00'   | 'Main Company'   | '27.01.2021'        | '27.01.2021'       |
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I close all client application windows
		
	

Scenario: _1003003 check SI closing by advance (Ap-Ar by documents, payment first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                  | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                      | 'Order'                                   | 'Project' | 'Amount'    | 'Deferred calculation' | 'Customers advances closing'                            |
		| '27.01.2021 19:50:46' | 'Sales return 12 dated 27.01.2021 19:50:46' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales return 12 dated 27.01.2021 19:50:46'  | ''                                        | ''        | '-500,00'   | 'No'                   | ''                                                      |
		| '27.01.2021 19:50:46' | 'Sales return 12 dated 27.01.2021 19:50:46' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales return 12 dated 27.01.2021 19:50:46'  | ''                                        | ''        | '-85,60'    | 'No'                   | ''                                                      |
		| '27.01.2021 19:50:46' | 'Sales return 12 dated 27.01.2021 19:50:46' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales return 12 dated 27.01.2021 19:50:46'  | ''                                        | ''        | '-500,00'   | 'No'                   | ''                                                      |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914,00'  | 'No'                   | ''                                                      |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '670,08'    | 'No'                   | ''                                                      |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914,00'  | 'No'                   | ''                                                      |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914,00'  | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '670,08'    | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914,00'  | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '5 795,00'  | 'No'                   | ''                                                      |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '992,10'    | 'No'                   | ''                                                      |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                        | ''        | '95,00'     | 'No'                   | ''                                                      |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                        | ''        | '16,26'     | 'No'                   | ''                                                      |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '5 795,00'  | 'No'                   | ''                                                      |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                        | ''        | '95,00'     | 'No'                   | ''                                                      |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                        | ''        | '95,00'     | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                        | ''        | '16,26'     | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '391,00'    | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '66,94'     | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                        | ''        | '95,00'     | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '391,00'    | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
		| '28.01.2021 18:50:57' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45' | ''        | '35 834,00' | 'No'                   | ''                                                      |
		| '28.01.2021 18:50:57' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45' | ''        | '6 134,78'  | 'No'                   | ''                                                      |
		| '28.01.2021 18:50:57' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45' | ''        | '35 834,00' | 'No'                   | ''                                                      |
		| '18.02.2021 10:48:46' | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'Sales order 5 dated 18.02.2021 10:48:33' | ''        | '13 000,00' | 'No'                   | ''                                                      |
		| '18.02.2021 10:48:46' | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'Sales order 5 dated 18.02.2021 10:48:33' | ''        | '2 225,60'  | 'No'                   | ''                                                      |
		| '18.02.2021 10:48:46' | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'Sales order 5 dated 18.02.2021 10:48:33' | ''        | '13 000,00' | 'No'                   | ''                                                      |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '1 000,00'  | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00' |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '171,20'    | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00' |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '1 000,00'  | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00' |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '1 000,00'  | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00' |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '171,20'    | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00' |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45' | ''        | '1 000,00'  | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                        | ''        | '3 914,00'  | 'No'                   | ''                                                      |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                        | ''        | '670,08'    | 'No'                   | ''                                                      |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                        | ''        | '3 914,00'  | 'No'                   | ''                                                      |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'DFC'               | 'DFC'       | 'Partner term DFC'         | 'Sales invoice 9 dated 15.04.2021 14:53:05'  | ''                                        | ''        | '980,00'    | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'DFC'               | 'DFC'       | 'Partner term DFC'         | 'Sales invoice 9 dated 15.04.2021 14:53:05'  | ''                                        | ''        | '167,78'    | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Lomaniti'  | 'Lomaniti'  | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''                                        | ''        | '10 000,00' | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Lomaniti'  | 'Lomaniti'  | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''                                        | ''        | '1 712,00'  | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'DFC'               | 'DFC'       | 'Partner term DFC'         | 'Sales invoice 9 dated 15.04.2021 14:53:05'  | ''                                        | ''        | '980,00'    | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti'  | 'Lomaniti'  | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''                                        | ''        | '10 000,00' | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |	
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                  | 'Line number' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'                        | 'Project' | 'Amount'   | 'Deferred calculation' | 'Customers advances closing'                             |
		| '27.01.2021 19:50:47' | 'Cash receipt 6 dated 27.01.2021 19:50:47'  | '1'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '3 900,00' | 'No'                   | ''                                                       |
		| '27.01.2021 19:50:47' | 'Cash receipt 6 dated 27.01.2021 19:50:47'  | '2'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '667,68'   | 'No'                   | ''                                                       |
		| '27.01.2021 19:50:47' | 'Cash receipt 6 dated 27.01.2021 19:50:47'  | '3'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '3 900,00' | 'No'                   | ''                                                       |
		| '27.01.2021 19:50:47' | 'Cash receipt 6 dated 27.01.2021 19:50:47'  | '4'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '-500,00'  | 'No'                   | 'Customers advance closing 23 dated 27.01.2021 12:00:00' |
		| '27.01.2021 19:50:47' | 'Cash receipt 6 dated 27.01.2021 19:50:47'  | '5'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '-85,60'   | 'No'                   | 'Customers advance closing 23 dated 27.01.2021 12:00:00' |
		| '27.01.2021 19:50:47' | 'Cash receipt 6 dated 27.01.2021 19:50:47'  | '6'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '-500,00'  | 'No'                   | 'Customers advance closing 23 dated 27.01.2021 12:00:00' |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '1'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '3 914,00' | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '2'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '670,08'   | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  |
		| '28.01.2021 18:48:53' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '3'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '3 914,00' | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '1'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '486,00'   | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '2'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '83,20'    | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  |
		| '28.01.2021 18:49:39' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '3'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '486,00'   | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | '1'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | ''                                                       |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | '2'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '171,20'   | 'No'                   | ''                                                       |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | '3'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | ''                                                       |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | '4'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | '5'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '171,20'   | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  |
		| '27.04.2021 11:31:10' | 'Cash receipt 4 dated 27.04.2021 11:31:10'  | '6'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '1'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | ''                                                       |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '2'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '171,20'   | 'No'                   | ''                                                       |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '3'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, without VAT' | ''        | '1 000,00' | 'No'                   | ''                                                       |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '4'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, without VAT' | ''        | '171,20'   | 'No'                   | ''                                                       |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '5'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | ''                                                       |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '6'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, without VAT' | ''        | '1 000,00' | 'No'                   | ''                                                       |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '7'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '8'           | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '171,20'   | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  |
		| '27.04.2021 11:32:10' | 'Cash receipt 5 dated 27.04.2021 11:32:10'  | '9'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY'         | ''        | '1 000,00' | 'No'                   | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  |
	
		
	And I close all client application windows
	

Scenario: _1003004 check SI movements when unpost document and post it back (closing by advance)
	* Check movements
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                                        | ''        | ''       | ''                     | ''                                                      |
			| 'Register  "R2021 Customer transactions"'   | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                                        | ''        | ''       | ''                     | ''                                                      |
			| ''                                          | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Order'                                   | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing'                            |
			| ''                                          | '28.01.2021 18:48:53' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | ''                                                      |
			| ''                                          | '28.01.2021 18:48:53' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '670,08' | 'No'                   | ''                                                      |
			| ''                                          | '28.01.2021 18:48:53' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | ''                                                      |
			| ''                                          | '28.01.2021 18:48:53' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
			| ''                                          | '28.01.2021 18:48:53' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '670,08' | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
			| ''                                          | '28.01.2021 18:48:53' | 'Expense'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |		
		And I close all client application windows
	* Unpost SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report info" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'    |
		And I close all client application windows
	* Post SI back and check it movements
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                                        | ''        | ''       | ''                     | ''                                                      |
			| 'Register  "R2021 Customer transactions"'   | ''                    | ''           | ''             | ''                        | ''                             | ''         | ''                     | ''                  | ''          | ''                         | ''                                          | ''                                        | ''        | ''       | ''                     | ''                                                      |
			| ''                                          | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Order'                                   | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing'                            |
			| ''                                          | '28.01.2021 18:48:53' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | ''                                                      |
			| ''                                          | '28.01.2021 18:48:53' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '670,08' | 'No'                   | ''                                                      |
			| ''                                          | '28.01.2021 18:48:53' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | ''                                                      |
			| ''                                          | '28.01.2021 18:48:53' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
			| ''                                          | '28.01.2021 18:48:53' | 'Expense'    | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '670,08' | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |
			| ''                                          | '28.01.2021 18:48:53' | 'Expense'    | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Sales order 1 dated 27.01.2021 19:50:45' | ''        | '3 914'  | 'No'                   | 'Customers advance closing 9 dated 28.01.2021 12:00:00' |		
		And I close all client application windows


	
Scenario: _1003012 check SI closing by advance (Ap-Ar by documents, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table contains lines	
		| 'Period'              | 'Recorder'                                   | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'       | 'Partner'  | 'Agreement'                | 'Basis'                                      | 'Order'                                                     | 'Project' | 'Amount'    | 'Deferred calculation' | 'Customers advances closing'                            |
		| '16.02.2021 12:14:54' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''                                                          | ''        | '12 400,00' | 'No'                   | ''                                                      |
		| '17.02.2021 10:33:31' | 'Sales invoice 5 dated 17.02.2021 10:33:31'  | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 5 dated 17.02.2021 10:33:31'  | '<Object not found> (218:b76197e183b782dc11eb70fac68f8cd6)' | ''        | '26 400,00' | 'No'                   | ''                                                      |
		| '17.02.2021 10:43:29' | 'Sales invoice 6 dated 17.02.2021 10:43:29'  | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 6 dated 17.02.2021 10:43:29'  | '<Object not found> (218:b76197e183b782dc11eb70fac68f8cd8)' | ''        | '26 400,00' | 'No'                   | ''                                                      |
		| '12.04.2021 12:00:01' | 'Sales invoice 15 dated 12.04.2021 12:00:01' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 15 dated 12.04.2021 12:00:01' | ''                                                          | ''        | '20 000,00' | 'No'                   | ''                                                      |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'   | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 5 dated 17.02.2021 10:33:31'  | ''                                                          | ''        | '26 400,00' | 'No'                   | 'Customers advance closing 3 dated 15.04.2021 12:00:00' |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'   | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 6 dated 17.02.2021 10:43:29'  | ''                                                          | ''        | '26 400,00' | 'No'                   | 'Customers advance closing 3 dated 15.04.2021 12:00:00' |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'   | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''                                                          | ''        | '2 000,00'  | 'No'                   | 'Customers advance closing 3 dated 15.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''                                                          | ''        | '10 000,00' | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	And "List" table contains lines
		| 'Period'              | 'Recorder'                                  | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'       | 'Partner'  | 'Order' | 'Agreement'                | 'Project' | 'Amount'    | 'Deferred calculation' | 'Customers advances closing'                            |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'  | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '54 800,00' | 'No'                   | ''                                                      |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'  | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '9 381,76'  | 'No'                   | ''                                                      |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'  | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '54 800,00' | 'No'                   | ''                                                      |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'  | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '54 800,00' | 'No'                   | 'Customers advance closing 3 dated 15.04.2021 12:00:00' |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'  | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '9 381,76'  | 'No'                   | 'Customers advance closing 3 dated 15.04.2021 12:00:00' |
		| '15.04.2021 10:21:22' | 'Bank receipt 5 dated 15.04.2021 10:21:22'  | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '54 800,00' | 'No'                   | 'Customers advance closing 3 dated 15.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '10 000,00' | 'No'                   | ''                                                      |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '1 712,00'  | 'No'                   | ''                                                      |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '10 000,00' | 'No'                   | ''                                                      |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '10 000,00' | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '1 712,00'  | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
		| '28.04.2021 21:50:03' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Lomaniti' | 'Lomaniti' | ''      | 'Basic Partner terms, TRY' | ''        | '10 000,00' | 'No'                   | 'Customers advance closing 6 dated 28.04.2021 12:00:00' |
	And I close all client application windows
	
		

Scenario: _1003052 check CustomersAdvancesClosing movements when unpost document and post it back
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
	And I go to line in "List" table
		| 'Number'   |
		| '9'        |
	* Unpost
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
		And "List" table does not contain lines
			| 'Customers advances closing'                               |
			| 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table does not contain lines
			| 'Customers advances closing'                               |
			| 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
		And I close current window
	* Post CustomersAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
		And "List" table contains lines
			| 'Customers advances closing'                               |
			| 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
		And "List" table contains lines
			| 'Customers advances closing'                               |
			| 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
		And I close all client application windows
		
		
Scenario: _1003062 check CustomersAdvancesClosing movements
	And I close all client application windows
	* Select CustomersAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '6'         |
	// * Generate report
	// 	And I click "Offset of advances" button
	// 	Then "R5012 Offset of advances" window is opened
	// 	And I click "Run" button
	* T2010S Offset of advances
		And I click "Registrations report info" button
		And I select "T2010S Offset of advances" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Customers advance closing 6 dated 28.04.2021 12:00:00' | ''                    | ''             | ''                        | ''                                          | ''            | ''                   | ''         | ''         | ''                 | ''                         | ''                                           | ''                             | ''                         | ''              | ''                  | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | ''                                     | ''       |
			| 'Register  "T2010S Offset of advances"'                 | ''                    | ''             | ''                        | ''                                          | ''            | ''                   | ''         | ''         | ''                 | ''                         | ''                                           | ''                             | ''                         | ''              | ''                  | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | ''                                     | ''       |
			| ''                                                      | 'Period'              | 'Company'      | 'Branch'                  | 'Document'                                  | 'Record type' | 'Is advance release' | 'Currency' | 'Partner'  | 'Legal name'       | 'Agreement'                | 'Transaction document'                       | 'DELETE transaction agreement' | 'DELETE advance agreement' | 'Advance order' | 'Transaction order' | 'DELETE from advance key' | 'DELETE to transaction key' | 'DELETE from transaction key' | 'DELETE to advance key' | 'Advance project' | 'Transaction project' | 'Key'                                  | 'Amount' |
			| ''                                                      | '28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Expense'     | 'No'                 | 'TRY'      | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''                             | ''                         | ''              | ''                  | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | 'b1bdc5c8-4458-48fc-a29f-1fb871cc60a2' | '10 000' |
			| ''                                                      | '28.04.2021 21:50:03' | 'Main Company' | 'Distribution department' | 'Bank receipt 13 dated 28.04.2021 21:50:03' | 'Expense'     | 'No'                 | 'TRY'      | 'DFC'      | 'DFC'              | 'Partner term DFC'         | 'Sales invoice 9 dated 15.04.2021 14:53:05'  | ''                             | ''                         | ''              | ''                  | ''                        | ''                          | ''                            | ''                      | ''                | ''                    | '5192a149-064d-46d4-ac7d-18e5733c0e8b' | '980'    |		
	* TM1020 Advances key
		And I select "TM1020 Advances key" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Customers advance closing 6 dated 28.04.2021 12:00:00' | ''                    | ''           | ''                   | ''             | ''                        | ''         | ''         | ''                 | ''                         | ''      | ''        | ''                  | ''                    | ''       |
			| 'Register  "TM1020 Advances key"'                       | ''                    | ''           | ''                   | ''             | ''                        | ''         | ''         | ''                 | ''                         | ''      | ''        | ''                  | ''                    | ''       |
			| ''                                                      | 'Period'              | 'RecordType' | 'DELETE advance key' | 'Company'      | 'Branch'                  | 'Currency' | 'Partner'  | 'Legal name'       | 'Agreement'                | 'Order' | 'Project' | 'Is vendor advance' | 'Is customer advance' | 'Amount' |
			| ''                                                      | '28.04.2021 21:50:03' | 'Receipt'    | ''                   | 'Main Company' | 'Distribution department' | 'TRY'      | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | ''      | ''        | 'No'                | 'Yes'                 | '10 000' |
			| ''                                                      | '28.04.2021 21:50:03' | 'Receipt'    | ''                   | 'Main Company' | 'Distribution department' | 'TRY'      | 'DFC'      | 'DFC'              | 'Partner term DFC'         | ''      | ''        | 'No'                | 'Yes'                 | '2 000'  |
			| ''                                                      | '28.04.2021 21:50:03' | 'Expense'    | ''                   | 'Main Company' | 'Distribution department' | 'TRY'      | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | ''      | ''        | 'No'                | 'Yes'                 | '10 000' |
			| ''                                                      | '28.04.2021 21:50:03' | 'Expense'    | ''                   | 'Main Company' | 'Distribution department' | 'TRY'      | 'DFC'      | 'DFC'              | 'Partner term DFC'         | ''      | ''        | 'No'                | 'Yes'                 | '980'    |		
	* TM1030 Transactions key
		And I select "TM1030 Transactions key" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| 'Customers advance closing 6 dated 28.04.2021 12:00:00' | ''                    | ''           | ''                       | ''             | ''                        | ''         | ''          | ''                  | ''                         | ''                                           | ''      | ''        | ''                      | ''                        | ''       |
			| 'Register  "TM1030 Transactions key"'                   | ''                    | ''           | ''                       | ''             | ''                        | ''         | ''          | ''                  | ''                         | ''                                           | ''      | ''        | ''                      | ''                        | ''       |
			| ''                                                      | 'Period'              | 'RecordType' | 'DELETE transaction key' | 'Company'      | 'Branch'                  | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'                | 'Transaction basis'                          | 'Order' | 'Project' | 'Is vendor transaction' | 'Is customer transaction' | 'Amount' |
			| ''                                                      | '28.04.2021 21:50:03' | 'Expense'    | ''                       | 'Main Company' | 'Distribution department' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''      | ''        | 'No'                    | 'Yes'                     | '3 914'  |
			| ''                                                      | '28.04.2021 21:50:03' | 'Expense'    | ''                       | 'Main Company' | 'Distribution department' | 'TRY'      | 'Lomaniti'  | 'Company Lomaniti'  | 'Basic Partner terms, TRY' | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''      | ''        | 'No'                    | 'Yes'                     | '10 000' |
			| ''                                                      | '28.04.2021 21:50:03' | 'Expense'    | ''                       | 'Main Company' | 'Distribution department' | 'TRY'      | 'DFC'       | 'DFC'               | 'Partner term DFC'         | 'Sales invoice 9 dated 15.04.2021 14:53:05'  | ''      | ''        | 'No'                    | 'Yes'                     | '980'    |		
		And I close all client application windows
						
	
Scenario: _1003064 check advance closing when SI has two same strings
	And I close all client application windows
	* Preparation
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(16).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.CustomersAdvancesClosing.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"     |
	// * Check advance closing
	// 	Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
	// 	And I go to line in "List" table
	// 		| 'Number'    |
	// 		| '21'        |
	// 	And I click "Offset of advances" button
	// * Check
	// 	And "Doc" spreadsheet document contains "OffsetOfAdvanceCustomerLunch" template lines by template
	// And I close all client application windows

// Scenario: _1003070 check payment status for SI
// 	And I close all client application windows
// 	* Open SI list form
// 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
// 	* Check
// 		And "List" table became equal
// 			| 'Number' | 'Amount'    | 'Date'                | 'Partner'         | 'Company'      | 'Legal name'        | 'Status'   | 'Currency' | 'Store'    | 'PaymentStatusUnit' |
// 			| '1'      | '3 914,00'  | '28.01.2021 18:48:53' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Closed'   | 'TRY'      | 'Store 02' | 'Fully paid'        |
// 			| '2'      | '5 890,00'  | '28.01.2021 18:49:39' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Closed'   | 'TRY'      | 'Store 02' | 'Fully paid'        |
// 			| '3'      | '35 834,00' | '28.01.2021 18:50:57' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Shipping' | 'TRY'      | 'Store 02' | 'Partially paid'    |
// 			| '10'     | '2 000,00'  | '28.01.2021 18:52:06' | 'DFC'             | 'Main Company' | 'DFC'               | 'Closed'   | 'TRY'      | 'Store 03' | 'Not tracked'       |
// 			| '12'     | '1 000,00'  | '28.01.2021 18:52:07' | 'Partner Kalipso' | 'Main Company' | 'Company Kalipso'   | 'Closed'   | 'TRY'      | 'Store 02' | 'Not tracked'       |
// 			| '4'      | '23 374,00' | '16.02.2021 10:59:49' | 'Kalipso'         | 'Main Company' | 'Company Kalipso'   | 'Shipping' | 'USD'      | 'Store 02' | 'Fully paid'        |
// 			| '13'     | '2 000,00'  | '16.02.2021 12:14:53' | 'Partner Kalipso' | 'Main Company' | 'Company Kalipso'   | 'Closed'   | 'TRY'      | 'Store 02' | 'Not tracked'       |
// 			| '14'     | '12 400,00' | '16.02.2021 12:14:54' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 01' | 'Fully paid'        |
// 			| '5'      | '26 400,00' | '17.02.2021 10:33:31' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 01' | 'Fully paid'        |
// 			| '6'      | '26 400,00' | '17.02.2021 10:43:29' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 02' | 'Partially paid'    |
// 			| '8'      | '13 000,00' | '18.02.2021 10:48:46' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Awaiting' | 'TRY'      | 'Store 02' | 'Not paid'          |
// 			| '11'     | '944,00'    | '12.04.2021 12:00:00' | 'DFC'             | 'Main Company' | 'DFC'               | 'Closed'   | 'TRY'      | 'Store 03' | 'Not tracked'       |
// 			| '15'     | '20 000,00' | '12.04.2021 12:00:01' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 01' | 'Not paid'          |
// 			| '9'      | '1 180,00'  | '15.04.2021 14:53:05' | 'DFC'             | 'Main Company' | 'DFC'               | 'Closed'   | 'TRY'      | 'Store 03' | 'Fully paid'        |
// 			| '16'     | '5 200,00'  | '04.09.2023 13:04:13' | 'Lunch'           | 'Main Company' | 'Company Lunch'     | 'Closed'   | 'TRY'      | 'Store 01' | 'Not paid'          |
// 	And I close all client application windows