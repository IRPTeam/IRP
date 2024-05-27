#language: en
@tree
@Positive
@MultiCurrencyRevaluation

Functionality: foreign currency revaluation

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _0978001 preparation (foreign currency revaluation)
	When set True value to the constant
	When set True value to the constant Use commission trading
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create OtherPartners objects
		When Create information register Taxes records (VAT)
		When Create catalog ReportOptions objects (A1010_PartnersBalance)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create catalog LegalNameContracts objects
	When Create catalog CancelReturnReasons objects
	When Create catalog CashAccounts objects
	When Create catalog SerialLotNumbers objects
	When settings for Main Company (commission trade)
	When Create catalog RetailCustomers objects (check POS)
	When Create POS cash account objects
	When Create information register CurrencyRates records (multicurrency revaluation)
	* Add one more reporting currency for Main Company
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I move to "Currencies" tab
		And in the table "Currencies" I click the button named "CurrenciesAdd"
		And I click choice button of "Movement type" attribute in "Currencies" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Reporting currency Euro' |
		And I select current line in "List" table
		And I finish line editing in "Currencies" table
		And I click the button named "FormWriteAndClose"		
	* Workstation
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Load documents
		When Create document PurchaseInvoice objects (multicurrency revaluation)
		When Create document SalesInvoice objects (multicurrency revaluation)
		When Create document BankPayment objects (multicurrency revaluation)
		When Create document BankReceipt objects (multicurrency revaluation)
		When Create document CustomersAdvancesClosing and VendorsAdvancesClosing objects (multicurrency revaluation)
		When Create document ForeignCurrencyRevaluation objects (multicurrency revaluation)
	* Post documents
		* Posting PurchaseInvoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesInvoice
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting BankPayment
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting BankReceipt
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting CustomersAdvancesClosing
			Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting VendorsAdvancesClosing
			Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting ForeignCurrencyRevaluation
			Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	And I close all client application windows


Scenario: _0978002 check preparation
	When check preparation

Scenario: _0978003 check foreign currency revaluation
	And I close all client application windows
	* Create first document foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click "Create" button
		And I input "11.02.2023 23:59:59" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "(Expense) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I click Select button of "(Expense) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$Number1$$" variable
		And I save the value of "Number" field as "$$Number1$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And "List" table contains lines
			| 'Number'         |
			| '$$Number1$$'    |
		And I close all client application windows
	
# revaluation of settlement balances (R5020B_PartnersBalance) 

Scenario: _0978008 Sales (PI) and receipt of money (BP) on the same date - no exchange difference - (R5020B_PartnersBalance)
	And I close all client application windows
	* Open report A1010_PartnersBalance
		Given I open hyperlink "e1cib/app/Report.A1010_PartnersBalance"
		And I click "Select option..." button
		And I go to line in "OptionsList" table
			| 'Report option'   |
			| 'ForTest'         |
		And I select current line in "OptionsList" table
	* Settings
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "01.02.2023" text in the field named "DateBegin"
		And I input "01.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "ferron" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "dollar" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency' | 'Local currency'                                                        | ''         | ''         | ''        | 'Reporting currency' | ''        | ''        | ''        | 'Reporting currency Euro' | ''        | ''        | ''        | 'en description is empty' | ''        | ''        | ''        |
			| 'Partner'              | 'Total'                                                                 | ''         | ''         | ''        | 'Total'              | ''        | ''        | ''        | 'Total'                   | ''        | ''        | ''        | 'Total'                   | ''        | ''        | ''        |
			| 'Partner terms'        | 'Opening'                                                               | 'Receipt'  | 'Expense'  | 'Balance' | 'Opening'            | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense' | 'Balance' |
			| 'Basis'                | ''                                                                      | ''         | ''         | ''        | ''                   | ''        | ''        | ''        | ''                        | ''        | ''        | ''        | ''                        | ''        | ''        | ''        |
			| 'Total'                | ''                                                                      | '5 950,00' | '5 950,00' | ''        | ''                   | '700,00'  | '700,00'  | ''        | ''                        | '630,00'  | '630,00'  | ''        | ''                        | ''        | ''        | ''        |
			| 'USD'                  | ''                                                                      | '5 950,00' | '5 950,00' | ''        | ''                   | '700,00'  | '700,00'  | ''        | ''                        | '630,00'  | '630,00'  | ''        | ''                        | '700,00'  | '700,00'  | ''        |
			| 'Ferron BP'            | ''                                                                      | '5 950,00' | '5 950,00' | ''        | ''                   | '700,00'  | '700,00'  | ''        | ''                        | '630,00'  | '630,00'  | ''        | ''                        | '700,00'  | '700,00'  | ''        |
			| 'Vendor Ferron, USD'   | ''                                                                      | '5 950,00' | '5 950,00' | ''        | ''                   | '700,00'  | '700,00'  | ''        | ''                        | '630,00'  | '630,00'  | ''        | ''                        | '700,00'  | '700,00'  | ''        |
	And I close all client application windows
	
Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (R5020B_PartnersBalance)
	And I close all client application windows
	* Open report A1010_PartnersBalance
		Given I open hyperlink "e1cib/app/Report.A1010_PartnersBalance"
		And I click "Select option..." button
		And I go to line in "OptionsList" table
			| 'Report option'   |
			| 'ForTest'         |
		And I select current line in "OptionsList" table
	* Settings
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "01.02.2023" text in the field named "DateBegin"
		And I input "01.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Kalipso" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "dollar" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                      | 'Local currency'                                                      | ''          | ''          | ''        | 'Reporting currency' | ''         | ''         | ''        | 'Reporting currency Euro' | ''         | ''         | ''        | 'en description is empty' | ''         | ''         | ''        |
			| 'Partner'                                   | 'Total'                                                               | ''          | ''          | ''        | 'Total'              | ''         | ''         | ''        | 'Total'                   | ''         | ''         | ''        | 'Total'                   | ''         | ''         | ''        |
			| 'Partner terms'                             | 'Opening'                                                             | 'Receipt'   | 'Expense'   | 'Balance' | 'Opening'            | 'Receipt'  | 'Expense'  | 'Balance' | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance' | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance' |
			| 'Basis'                                     | ''                                                                    | ''          | ''          | ''        | ''                   | ''         | ''         | ''        | ''                        | ''         | ''         | ''        | ''                        | ''         | ''         | ''        |
			| 'Total'                                     | ''                                                                    | '11 265,14' | '11 265,14' | ''        | ''                   | '1 325,31' | '1 325,31' | ''        | ''                        | '1 192,78' | '1 192,78' | ''        | ''                        | ''         | ''         | ''        |
			| 'USD'                                       | ''                                                                    | '11 265,14' | '11 265,14' | ''        | ''                   | '1 325,31' | '1 325,31' | ''        | ''                        | '1 192,78' | '1 192,78' | ''        | ''                        | '1 325,31' | '1 325,31' | ''        |
			| 'Kalipso'                                   | ''                                                                    | '11 265,14' | '11 265,14' | ''        | ''                   | '1 325,31' | '1 325,31' | ''        | ''                        | '1 192,78' | '1 192,78' | ''        | ''                        | '1 325,31' | '1 325,31' | ''        |
			| 'Personal Partner terms, $'                 | ''                                                                    | '11 265,14' | '11 265,14' | ''        | ''                   | '1 325,31' | '1 325,31' | ''        | ''                        | '1 192,78' | '1 192,78' | ''        | ''                        | '1 325,31' | '1 325,31' | ''        |
			| 'Sales invoice 1 dated 01.02.2023 12:00:00' | ''                                                                    | '11 265,14' | '11 265,14' | ''        | ''                   | '1 325,31' | '1 325,31' | ''        | ''                        | '1 192,78' | '1 192,78' | ''        | ''                        | '1 325,31' | '1 325,31' | ''        |
		And I close all client application windows


Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (R1021 Vendors transactions)
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report info" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1021 Vendors transactions"'    |
		And I close all client application windows

Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (R2021 Customer transactions)
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2021 Customer transactions"'    |
		And I close all client application windows

Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (R5022 Expenses)
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5022 Expenses"'    |
		And I close all client application windows

Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (R5021 Revenues)
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5021 Revenues"'    |
		And I close all client application windows

Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (R3010 Cash on hand)
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report info" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R3010 Cash on hand"'    |
		And I close all client application windows

Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (R3010 Cash on hand)
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report info" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R3010 Cash on hand"'    |
		And I close all client application windows

Scenario: _0978009 Sales (SI) and payment (BR) on the same date - no exchange difference - (T1040 Accounting amounts)
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "T1040 Accounting amounts" 
		And I click "Registrations report info" button
		And I select "T1040 Accounting amounts" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T1040 Accounting amounts"'    |
		And I close all client application windows

# Purchase/Sale and Payment on different dates - USD to TRY falls, USD to EUR rise										
Scenario: _0978004 revaluation of currency balance (customer) - exchange rate decreased - (R5020B_PartnersBalance)	
	And I close all client application windows
	* Open report A1010_PartnersBalance
		Given I open hyperlink "e1cib/app/Report.A1010_PartnersBalance"
		And I click "Select option..." button
		And I go to line in "OptionsList" table
			| 'Report option'   |
			| 'ForTest'         |
		And I select current line in "OptionsList" table
	* Settings
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.02.2023" text in the field named "DateBegin"
		And I input "03.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Kalipso" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "dollar" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                      | 'Local currency'                                                      | ''           | ''          | ''          | 'Reporting currency' | ''          | ''         | ''          | 'Reporting currency Euro' | ''          | ''         | ''         | 'en description is empty' | ''          | ''         | ''          |
			| 'Partner'                                   | 'Total'                                                               | ''           | ''          | ''          | 'Total'              | ''          | ''         | ''          | 'Total'                   | ''          | ''         | ''         | 'Total'                   | ''          | ''         | ''          |
			| 'Partner terms'                             | 'Opening'                                                             | 'Receipt'    | 'Expense'   | 'Balance'   | 'Opening'            | 'Receipt'   | 'Expense'  | 'Balance'   | 'Opening'                 | 'Receipt'   | 'Expense'  | 'Balance'  | 'Opening'                 | 'Receipt'   | 'Expense'  | 'Balance'   |
			| 'Basis'                                     | ''                                                                    | ''           | ''          | ''          | ''                   | ''          | ''         | ''          | ''                        | ''          | ''         | ''         | ''                        | ''          | ''         | ''          |
			| 'Total'                                     | ''                                                                    | '100 982,76' | '16 806,72' | '84 176,04' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 020,00' | '1 840,00' | '9 180,00' | ''                        | ''          | ''         | ''          |
			| 'USD'                                       | ''                                                                    | '100 982,76' | '16 806,72' | '84 176,04' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 020,00' | '1 840,00' | '9 180,00' | ''                        | '12 000,00' | '2 000,00' | '10 000,00' |
			| 'Kalipso'                                   | ''                                                                    | '100 982,76' | '16 806,72' | '84 176,04' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 020,00' | '1 840,00' | '9 180,00' | ''                        | '12 000,00' | '2 000,00' | '10 000,00' |
			| 'Personal Partner terms, $'                 | ''                                                                    | '100 982,76' | '16 806,72' | '84 176,04' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 020,00' | '1 840,00' | '9 180,00' | ''                        | '12 000,00' | '2 000,00' | '10 000,00' |
			| 'Sales invoice 2 dated 02.02.2023 12:00:00' | ''                                                                    | '16 949,15'  | '16 806,72' | '142,43'    | ''                   | '2 000,00'  | '2 000,00' | ''          | ''                        | '1 820,00'  | '1 840,00' | '-20,00'   | ''                        | '2 000,00'  | '2 000,00' | ''          |
			| 'Sales invoice 3 dated 03.02.2023 12:00:00' | ''                                                                    | '84 033,61'  | ''          | '84 033,61' | ''                   | '10 000,00' | ''         | '10 000,00' | ''                        | '9 200,00'  | ''         | '9 200,00' | ''                        | '10 000,00' | ''         | '10 000,00' |		
		And I close all client application windows
					

Scenario: _0978005 revaluation of currency balance (vendor) - exchange rate decreased
	And I close all client application windows
	* Open report A1010_PartnersBalance
		Given I open hyperlink "e1cib/app/Report.A1010_PartnersBalance"
		And I click "Select option..." button
		And I go to line in "OptionsList" table
			| 'Report option'   |
			| 'ForTest'         |
		And I select current line in "OptionsList" table
	* Settings
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.02.2023" text in the field named "DateBegin"
		And I input "03.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Ferron BP" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "dollar" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency' | 'Local currency'                                                        | ''          | ''          | ''           | 'Reporting currency' | ''         | ''         | ''          | 'Reporting currency Euro' | ''         | ''         | ''          | 'ru description is empty' | ''         | ''         | ''          |
			| 'Partner'              | 'Total'                                                                 | ''          | ''          | ''           | 'Total'              | ''         | ''         | ''          | 'Total'                   | ''         | ''         | ''          | 'Total'                   | ''         | ''         | ''          |
			| 'Partner terms'        | 'Opening'                                                               | 'Receipt'   | 'Expense'   | 'Balance'    | 'Opening'            | 'Receipt'  | 'Expense'  | 'Balance'   | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance'   | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance'   |
			| 'Basis'                | ''                                                                      | ''          | ''          | ''           | ''                   | ''         | ''         | ''          | ''                        | ''         | ''         | ''          | ''                        | ''         | ''         | ''          |
			| 'Total'                | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | ''         | ''         | ''          |
			| 'USD'                  | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | '2 000,00' | '7 000,00' | '-5 000,00' |
			| 'Ferron BP'            | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | '2 000,00' | '7 000,00' | '-5 000,00' |
			| 'Vendor Ferron, USD'   | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | '2 000,00' | '7 000,00' | '-5 000,00' |	
		And I close all client application windows



# Transaction +10, Reporting +100 (Trans*Rate < Rep - Expense) только инвойс
Scenario: _0978006 revaluation of currency balance (customer) - exchange rate increased - SI 4 в лирах
Scenario: _0978007 revaluation of currency balance (vendor) - exchange rate increased - PI 4 в лирах

#Transaction 0, Reporting 5 (SI 10 USD R:10, BR 10 USD R:9,5) - PI 5, BP 3

Scenario: _0978010 Sales (SI) and receipt of money (BR), debt repaid in USD, there is a balance of debt in local currency

#Transaction 0, Reporting -5 (PI 10 USD R:10, BP 10 USD R:9,5) - exchange rate decreased  USD закрылось, евро -минус, локальная плюс PI 2, BP 2

Scenario: _0978011 Purchase (PI) and payment (BP), debt repaid in USD, there is a balance of debt in local currency

#Transaction +10, Reporting -5 (SI 20 USD R:10, BR 10 USD R:20,5) - только инвойс SI 2, BR -2, USD закрылось, евро -минус, локальная плюс

Scenario: _0978012 Sales (SI) and receipt of money (BR), debt repaid in USD, overpayment in local currency

#Transaction -10, Reporting 5 (PI 20 USD R:10, BP 10 USD R:20,5) - PI 6, BP 4

Scenario: _0978013 Purchase (SI) and payment (BP), debt repaid in USD, overpayment in local currency

#дописать проверку с закрытием аванса