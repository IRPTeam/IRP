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
			| "Documents.CreditNote.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
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
		| 'Period'               | 'Branch'                   | 'Recorder'                                   | 'Currency'  | 'Customers advances closing'                             | 'Company'       | 'Partner'    | 'Amount'     | 'Multi currency movement type'  | 'Legal name'         | 'Agreement'                 | 'Basis'                                      | 'Order'                                    | 'Deferred calculation'   |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 914,00'   | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 914,00'   | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '670,08'     | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 914,00'   | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '3 900,00'   | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '3 900,00'   | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'USD'       | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '667,68'     | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '3 900,00'   | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '5 795,00'   | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '5 795,00'   | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '992,10'     | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '95,00'      | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                         | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '95,00'      | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                         | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '16,26'      | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                         | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '5 795,00'   | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:49:39'  | 'Distribution department'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '95,00'      | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''                                         | 'No'                     |
		| '28.01.2021 18:50:57'  | 'Distribution department'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '35 834,00'  | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:50:57'  | 'Distribution department'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '35 834,00'  | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:50:57'  | 'Distribution department'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '6 134,78'   | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.01.2021 18:50:57'  | 'Distribution department'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '35 834,00'  | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '18.02.2021 10:48:46'  | 'Distribution department'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '13 000,00'  | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'Sales order 5 dated 18.02.2021 10:48:33'  | 'No'                     |
		| '18.02.2021 10:48:46'  | 'Distribution department'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '13 000,00'  | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'Sales order 5 dated 18.02.2021 10:48:33'  | 'No'                     |
		| '18.02.2021 10:48:46'  | 'Distribution department'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '2 225,60'   | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'Sales order 5 dated 18.02.2021 10:48:33'  | 'No'                     |
		| '18.02.2021 10:48:46'  | 'Distribution department'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '13 000,00'  | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 8 dated 18.02.2021 10:48:46'  | 'Sales order 5 dated 18.02.2021 10:48:33'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '14,00'      | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'USD'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2,40'       | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '14,00'      | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '891,00'     | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'USD'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '152,54'     | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '891,00'     | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '14,00'      | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'Sales order 1 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '891,00'     | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2 000,00'   | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'USD'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '342,40'     | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2 000,00'   | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2 000,00'   | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 914,00'   | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 914,00'   | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '670,08'     | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 914,00'   | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '-3 914,00'  | 'TRY'                           | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '-3 914,00'  | 'Local currency'                | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'USD'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '-670,08'    | 'Reporting currency'            | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '-3 914,00'  | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''                                         | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2 904,00'   | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 2 dated 28.01.2021 18:49:39'  | 'Sales order 2 dated 27.01.2021 19:50:45'  | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '1 010,00'   | 'en description is empty'       | 'Company Ferron BP'  | 'Basic Partner terms, TRY'  | 'Sales invoice 3 dated 28.01.2021 18:50:57'  | 'Sales order 3 dated 27.01.2021 19:50:45'  | 'No'                     |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	And "List" table contains lines
		| 'Period'               | 'Branch'                   | 'Recorder'                                   | 'Currency'  | 'Customers advances closing'                             | 'Company'       | 'Partner'    | 'Amount'     | 'Multi currency movement type'  | 'Legal name'         | 'Order'  | 'Deferred calculation'   |
		| '27.01.2021 19:50:47'  | 'Distribution department'  | 'Cash receipt 6 dated 27.01.2021 19:50:47'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 900,00'   | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.01.2021 19:50:47'  | 'Distribution department'  | 'Cash receipt 6 dated 27.01.2021 19:50:47'   | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '667,68'     | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.01.2021 19:50:47'  | 'Distribution department'  | 'Cash receipt 6 dated 27.01.2021 19:50:47'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '3 900,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '3 900,00'   | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'USD'       | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '667,68'     | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.01.2021 18:48:53'  | 'Distribution department'  | 'Sales invoice 1 dated 28.01.2021 18:48:53'  | 'TRY'       | 'Customers advance closing 9 dated 28.01.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '3 900,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '1 000,00'   | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '171,20'     | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '1 000,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '14,00'      | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'USD'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2,40'       | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '891,00'     | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'USD'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '152,54'     | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '14,00'      | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:31:10'  | 'Distribution department'  | 'Cash receipt 4 dated 27.04.2021 11:31:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '891,00'     | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '1 000,00'   | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '171,20'     | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '1 000,00'   | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'USD'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '171,20'     | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '1 000,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Ferron BP'  | '1 000,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2 000,00'   | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'USD'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '342,40'     | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Distribution department'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2 000,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '-3 914,00'  | 'Local currency'                | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'USD'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '-670,08'    | 'Reporting currency'            | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '-3 914,00'  | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '2 904,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Distribution department'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Ferron BP'  | '1 010,00'   | 'en description is empty'       | 'Company Ferron BP'  | ''       | 'No'                     |
	And I close all client application windows
	

Scenario: _1003004 check SI movements when unpost document and post it back (closing by advance)
	* Check movements
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | ''                       | ''                                                         |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | ''                       | ''                                                         |
			| 'Register  "R2021 Customer transactions"'     | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | ''                       | ''                                                         |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | 'Attributes'             | ''                                                         |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                       | 'Order'                                     | 'Project'   | 'Deferred calculation'   | 'Customers advances closing'                               |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '670,08'      | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '667,68'      | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '3 900'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '3 900'       | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '3 900'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
		And I close all client application windows
	* Unpost SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'    |
			| 'Document registrations records'               |
		And I close all client application windows
	* Post SI back and check it movements
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | ''                       | ''                                                         |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | ''                       | ''                                                         |
			| 'Register  "R2021 Customer transactions"'     | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | ''                       | ''                                                         |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''                    | ''            | ''                           | ''                                            | ''                                          | ''          | 'Attributes'             | ''                                                         |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'                  | 'Basis'                                       | 'Order'                                     | 'Project'   | 'Deferred calculation'   | 'Customers advances closing'                               |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '670,08'      | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Receipt'       | '28.01.2021 18:48:53'   | '3 914'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | ''                                                         |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '667,68'      | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '3 900'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '3 900'       | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
			| ''                                            | 'Expense'       | '28.01.2021 18:48:53'   | '3 900'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Basic Partner terms, TRY'   | 'Sales invoice 1 dated 28.01.2021 18:48:53'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | ''          | 'No'                     | 'Customers advance closing 9 dated 28.01.2021 12:00:00'    |
		And I close all client application windows


	
Scenario: _1003012 check SI closing by advance (Ap-Ar by documents, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table contains lines	
		| 'Period'               | 'Recorder'                                    | 'Currency'  | 'Customers advances closing'                             | 'Company'       | 'Branch'                   | 'Partner'   | 'Amount'     | 'Multi currency movement type'  | 'Legal name'        | 'Agreement'                 | 'Basis'                                       | 'Deferred calculation'   |
		| '16.02.2021 12:14:54'  | 'Sales invoice 14 dated 16.02.2021 12:14:54'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '12 400,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 14 dated 16.02.2021 12:14:54'  | 'No'                     |
		| '17.02.2021 10:33:31'  | 'Sales invoice 5 dated 17.02.2021 10:33:31'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '26 400,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 5 dated 17.02.2021 10:33:31'   | 'No'                     |
		| '17.02.2021 10:43:29'  | 'Sales invoice 6 dated 17.02.2021 10:43:29'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '26 400,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 6 dated 17.02.2021 10:43:29'   | 'No'                     |
		| '12.04.2021 12:00:01'  | 'Sales invoice 15 dated 12.04.2021 12:00:01'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '20 000,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 15 dated 12.04.2021 12:00:01'  | 'No'                     |
		| '15.04.2021 10:21:22'  | 'Bank receipt 5 dated 15.04.2021 10:21:22'    | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '12 400,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 14 dated 16.02.2021 12:14:54'  | 'No'                     |
		| '15.04.2021 10:21:22'  | 'Bank receipt 5 dated 15.04.2021 10:21:22'    | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '26 400,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 5 dated 17.02.2021 10:33:31'   | 'No'                     |
		| '15.04.2021 10:21:22'  | 'Bank receipt 5 dated 15.04.2021 10:21:22'    | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '16 000,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 6 dated 17.02.2021 10:43:29'   | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'   | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '10 000,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'Basic Partner terms, TRY'  | 'Sales invoice 6 dated 17.02.2021 10:43:29'   | 'No'                     |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	And "List" table contains lines
		| 'Period'               | 'Recorder'                                   | 'Currency'  | 'Customers advances closing'                             | 'Company'       | 'Branch'                   | 'Partner'   | 'Amount'     | 'Multi currency movement type'  | 'Legal name'        | 'Deferred calculation'   |
		| '15.04.2021 10:21:22'  | 'Bank receipt 5 dated 15.04.2021 10:21:22'   | 'TRY'       | ''                                                       | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '54 800,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'No'                     |
		| '15.04.2021 10:21:22'  | 'Bank receipt 5 dated 15.04.2021 10:21:22'   | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '12 400,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'No'                     |
		| '15.04.2021 10:21:22'  | 'Bank receipt 5 dated 15.04.2021 10:21:22'   | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '26 400,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'No'                     |
		| '15.04.2021 10:21:22'  | 'Bank receipt 5 dated 15.04.2021 10:21:22'   | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '16 000,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | ''                                                       | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '10 000,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'No'                     |
		| '28.04.2021 21:50:03'  | 'Bank receipt 13 dated 28.04.2021 21:50:03'  | 'TRY'       | 'Customers advance closing 6 dated 28.04.2021 12:00:00'  | 'Main Company'  | 'Distribution department'  | 'Lomaniti'  | '10 000,00'  | 'en description is empty'       | 'Company Lomaniti'  | 'No'                     |
	And I close all client application windows
	
	
Scenario: _1003014 check SI, Debit note closing by advance (Ap-Ar by partner term, invoice first)
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	And "List" table contains lines	
		| 'Period'              | 'Branch'                  | 'Recorder'                                   | 'Currency' | 'Customers advances closing'                             | 'Company'      | 'Partner'         | 'Amount'   | 'Multi currency movement type' | 'Legal name'      | 'Agreement'                | 'Basis' | 'Order' | 'Deferred calculation' |
		| '28.01.2021 18:52:07' | 'Distribution department' | 'Sales invoice 12 dated 28.01.2021 18:52:07' | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '1 000,00' | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '28.01.2021 18:52:07' | 'Distribution department' | 'Sales invoice 12 dated 28.01.2021 18:52:07' | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '1 000,00' | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '28.01.2021 18:52:07' | 'Distribution department' | 'Sales invoice 12 dated 28.01.2021 18:52:07' | 'USD'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '171,20'   | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '28.01.2021 18:52:07' | 'Distribution department' | 'Sales invoice 12 dated 28.01.2021 18:52:07' | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '1 000,00' | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 00:00:00' | 'Distribution department' | 'Credit note 12 dated 16.02.2021 00:00:00'   | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '-900,00'  | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 00:00:00' | 'Distribution department' | 'Credit note 12 dated 16.02.2021 00:00:00'   | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '-900,00'  | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 00:00:00' | 'Distribution department' | 'Credit note 12 dated 16.02.2021 00:00:00'   | 'USD'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '-154,08'  | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 00:00:00' | 'Distribution department' | 'Credit note 12 dated 16.02.2021 00:00:00'   | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '-900,00'  | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 12:14:53' | 'Distribution department' | 'Sales invoice 13 dated 16.02.2021 12:14:53' | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '2 000,00' | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 12:14:53' | 'Distribution department' | 'Sales invoice 13 dated 16.02.2021 12:14:53' | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '2 000,00' | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 12:14:53' | 'Distribution department' | 'Sales invoice 13 dated 16.02.2021 12:14:53' | 'USD'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '342,40'   | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '16.02.2021 12:14:53' | 'Distribution department' | 'Sales invoice 13 dated 16.02.2021 12:14:53' | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '2 000,00' | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '800,00'   | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '800,00'   | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'USD'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '136,96'   | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '800,00'   | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'      | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '200,00'   | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'      | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '200,00'   | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'USD'      | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '34,24'    | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '15.04.2021 14:53:06' | 'Distribution department' | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'      | 'Customers advance closing 3 dated 15.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '200,00'   | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '27.04.2021 11:32:10' | 'Distribution department' | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'      | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '1 100,00' | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '27.04.2021 11:32:10' | 'Distribution department' | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'USD'      | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '188,32'   | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '27.04.2021 11:32:10' | 'Distribution department' | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'      | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '1 100,00' | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '27.04.2021 11:32:10' | 'Distribution department' | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'      | 'Customers advance closing 5 dated 27.04.2021 12:00:00'  | 'Main Company' | 'Partner Kalipso' | '1 100,00' | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '200,00'   | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '200,00'   | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'USD'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '34,24'    | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '200,00'   | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'TRY'      | 'Customers advance closing 12 dated 14.05.2021 12:45:05' | 'Main Company' | 'Partner Kalipso' | '100,00'   | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'TRY'      | 'Customers advance closing 12 dated 14.05.2021 12:45:05' | 'Main Company' | 'Partner Kalipso' | '100,00'   | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'USD'      | 'Customers advance closing 12 dated 14.05.2021 12:45:05' | 'Main Company' | 'Partner Kalipso' | '17,12'    | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '14.05.2021 10:35:27' | 'Distribution department' | 'Debit note 22 dated 14.05.2021 10:35:27'    | 'TRY'      | 'Customers advance closing 12 dated 14.05.2021 12:45:05' | 'Main Company' | 'Partner Kalipso' | '100,00'   | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '24.05.2021 00:00:00' | 'Distribution department' | 'Debit note 23 dated 24.05.2021 00:00:00'    | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '50,00'    | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '24.05.2021 00:00:00' | 'Distribution department' | 'Debit note 23 dated 24.05.2021 00:00:00'    | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '50,00'    | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '24.05.2021 00:00:00' | 'Distribution department' | 'Debit note 23 dated 24.05.2021 00:00:00'    | 'USD'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '8,56'     | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '24.05.2021 00:00:00' | 'Distribution department' | 'Debit note 23 dated 24.05.2021 00:00:00'    | 'TRY'      | ''                                                       | 'Main Company' | 'Partner Kalipso' | '50,00'    | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '25.05.2021 09:27:13' | 'Distribution department' | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'TRY'      | 'Customers advance closing 17 dated 25.05.2021 09:49:46' | 'Main Company' | 'Partner Kalipso' | '150,00'   | 'Local currency'               | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '25.05.2021 09:27:13' | 'Distribution department' | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'USD'      | 'Customers advance closing 17 dated 25.05.2021 09:49:46' | 'Main Company' | 'Partner Kalipso' | '25,68'    | 'Reporting currency'           | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '25.05.2021 09:27:13' | 'Distribution department' | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'TRY'      | 'Customers advance closing 17 dated 25.05.2021 09:49:46' | 'Main Company' | 'Partner Kalipso' | '150,00'   | 'TRY'                          | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
		| '25.05.2021 09:27:13' | 'Distribution department' | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'TRY'      | 'Customers advance closing 17 dated 25.05.2021 09:49:46' | 'Main Company' | 'Partner Kalipso' | '150,00'   | 'en description is empty'      | 'Company Kalipso' | 'Partner Kalipso Customer' | ''      | ''      | 'No'                   |
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	And "List" table contains lines
		| 'Period'               | 'Recorder'                                   | 'Currency'  | 'Customers advances closing'                              | 'Company'       | 'Branch'                   | 'Partner'          | 'Amount'      | 'Multi currency movement type'  | 'Legal name'       | 'Deferred calculation'   |
		| '15.04.2021 10:14:37'  | 'Bank receipt 4 dated 15.04.2021 10:14:37'   | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '140 687,50'  | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 10:14:37'  | 'Bank receipt 4 dated 15.04.2021 10:14:37'   | 'USD'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '25 000,00'   | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 10:14:37'  | 'Bank receipt 4 dated 15.04.2021 10:14:37'   | 'USD'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '25 000,00'   | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 10:14:37'  | 'Bank receipt 4 dated 15.04.2021 10:14:37'   | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '131 537,19'  | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 10:14:37'  | 'Bank receipt 4 dated 15.04.2021 10:14:37'   | 'USD'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '23 374,00'   | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 10:14:37'  | 'Bank receipt 4 dated 15.04.2021 10:14:37'   | 'USD'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '23 374,00'   | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 14:53:06'  | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '200,00'      | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 14:53:06'  | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'USD'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '34,24'       | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 14:53:06'  | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '200,00'      | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 14:53:06'  | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '200,00'      | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 14:53:06'  | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'USD'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '34,24'       | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '15.04.2021 14:53:06'  | 'Cash receipt 7 dated 15.04.2021 14:53:06'   | 'TRY'       | 'Customers advance closing 3 dated 15.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '200,00'      | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '21.04.2021 13:09:56'  | 'Bank receipt 6 dated 21.04.2021 13:09:56'   | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '140 687,50'  | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '21.04.2021 13:09:56'  | 'Bank receipt 6 dated 21.04.2021 13:09:56'   | 'USD'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '25 000,00'   | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '21.04.2021 13:09:56'  | 'Bank receipt 6 dated 21.04.2021 13:09:56'   | 'USD'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Kalipso'          | '25 000,00'   | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '1 200,00'    | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'USD'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '205,44'      | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '1 100,00'    | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'USD'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '188,32'      | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '1 200,00'    | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '27.04.2021 11:32:10'  | 'Cash receipt 5 dated 27.04.2021 11:32:10'   | 'TRY'       | 'Customers advance closing 5 dated 27.04.2021 12:00:00'   | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '1 100,00'    | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '25.05.2021 09:27:13'  | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '200,00'      | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '25.05.2021 09:27:13'  | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'USD'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '34,24'       | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '25.05.2021 09:27:13'  | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'TRY'       | ''                                                        | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '200,00'      | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
		| '25.05.2021 09:27:13'  | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'TRY'       | 'Customers advance closing 17 dated 25.05.2021 09:49:46'  | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '150,00'      | 'Local currency'                | 'Company Kalipso'  | 'No'                     |
		| '25.05.2021 09:27:13'  | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'USD'       | 'Customers advance closing 17 dated 25.05.2021 09:49:46'  | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '25,68'       | 'Reporting currency'            | 'Company Kalipso'  | 'No'                     |
		| '25.05.2021 09:27:13'  | 'Bank receipt 14 dated 25.05.2021 09:27:13'  | 'TRY'       | 'Customers advance closing 17 dated 25.05.2021 09:49:46'  | 'Main Company'  | 'Distribution department'  | 'Partner Kalipso'  | '150,00'      | 'en description is empty'       | 'Company Kalipso'  | 'No'                     |
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
		
		
Scenario: _1003062 generate Offset of advance report based on CustomersAdvancesClosing
	And I close all client application windows
	* Select CustomersAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '6'         |
	* Generate report
		And I click "Offset of advances" button
		Then "R5012 Offset of advances" window is opened
		And I click "Run" button
	* Check
		And "Doc" spreadsheet document contains "OffsetOfAdvanceCustomer" template lines by template
	* Change type and generate report
		And I change "Report type" radio button value to "Vendors"
		And I click "Run" button	
		Then user message window does not contain messages
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
	* Check advance closing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
		And I click "Offset of advances" button
	* Check
		And "Doc" spreadsheet document contains "OffsetOfAdvanceCustomerLunch" template lines by template
	And I close all client application windows

// Scenario: _1003070 check payment status for SI
// 	And I close all client application windows
// 	* Open SI list form
// 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
// 	* Add payment status to the SI list form
// 		And I click "Change form..." button
// 		And I go to line in "" table
// 			| 'Column1'        |
// 			| 'Payment status' |
// 		And I select current line in "" table
// 		And Delay 2
// 		And I activate current test client window
// 		And I select current line in "" table
// 		And Delay 2
// 		And I press keyboard shortcut "SPACE"
// 		And I click "Apply" button
// 		And I click "OK" button
// 	* Check
// 		And "List" table became equal
// 			| 'Number' | 'Amount'         | 'Date'                | 'Partner'         | 'Company'      | 'Legal name'        | 'Status'   | 'Currency' | 'Store'    | 'Payment status' |
// 			| '1'      | '3 914,00'  | '28.01.2021 18:48:53' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Closed'   | 'TRY'      | 'Store 02' | 'Fully paid'     |
// 			| '2'      | '5 890,00'  | '28.01.2021 18:49:39' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Closed'   | 'TRY'      | 'Store 02' | 'Fully paid'     |
// 			| '3'      | '35 834,00' | '28.01.2021 18:50:57' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Shipping' | 'TRY'      | 'Store 02' | 'Partially paid' |
// 			| '10'     | '2 000,00'  | '28.01.2021 18:52:06' | 'DFC'             | 'Main Company' | 'DFC'               | 'Closed'   | 'TRY'      | 'Store 03' | 'Not tracked'    |
// 			| '12'     | '1 000,00'  | '28.01.2021 18:52:07' | 'Partner Kalipso' | 'Main Company' | 'Company Kalipso'   | 'Closed'   | 'TRY'      | 'Store 02' | 'Not tracked'    |
// 			| '4'      | '23 374,00' | '16.02.2021 10:59:49' | 'Kalipso'         | 'Main Company' | 'Company Kalipso'   | 'Shipping' | 'USD'      | 'Store 02' | 'Fully paid'     |
// 			| '13'     | '2 000,00'  | '16.02.2021 12:14:53' | 'Partner Kalipso' | 'Main Company' | 'Company Kalipso'   | 'Closed'   | 'TRY'      | 'Store 02' | 'Not tracked'    |
// 			| '14'     | '12 400,00' | '16.02.2021 12:14:54' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 01' | 'Fully paid'     |
// 			| '5'      | '26 400,00' | '17.02.2021 10:33:31' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 01' | 'Fully paid'     |
// 			| '6'      | '26 400,00' | '17.02.2021 10:43:29' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 02' | 'Partially paid' |
// 			| '8'      | '13 000,00' | '18.02.2021 10:48:46' | 'Ferron BP'       | 'Main Company' | 'Company Ferron BP' | 'Awaiting' | 'TRY'      | 'Store 02' | 'Not paid'       |
// 			| '11'     | '944,00'    | '12.04.2021 12:00:00' | 'DFC'             | 'Main Company' | 'DFC'               | 'Closed'   | 'TRY'      | 'Store 03' | 'Not tracked'    |
// 			| '15'     | '20 000,00' | '12.04.2021 12:00:01' | 'Lomaniti'        | 'Main Company' | 'Company Lomaniti'  | 'Closed'   | 'TRY'      | 'Store 01' | 'Not paid'       |
// 			| '9'      | '1 180,00'  | '15.04.2021 14:53:05' | 'DFC'             | 'Main Company' | 'DFC'               | 'Closed'   | 'TRY'      | 'Store 03' | 'Fully paid'     |
// 			| '16'     | '5 200,00'  | '04.09.2023 13:04:13' | 'Lunch'           | 'Main Company' | 'Company Lunch'     | 'Closed'   | 'TRY'      | 'Store 01' | 'Not paid'       |	
// 	And I close all client application windows