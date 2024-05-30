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
		When Create document OpeningEntry objects (multicurrency revaluation)
		When Create document SalesInvoice objects (multicurrency revaluation)
		When Create document BankPayment objects (multicurrency revaluation)
		When Create document BankReceipt objects (multicurrency revaluation)
		When Create document DebitNote objects (multicurrency revaluation)
		When Create document CustomersAdvancesClosing and VendorsAdvancesClosing objects (multicurrency revaluation)
		When Create document ForeignCurrencyRevaluation objects (multicurrency revaluation)
	* Post documents
		* Posting OpeningEntry
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
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
		* Posting DebitNote
			Given I open hyperlink "e1cib/list/Document.DebitNote"
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


Scenario: _0978010 Sales (SI) and payment (BR) on the same date - no exchange difference - (R1021 Vendors transactions)
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

Scenario: _0978011 Sales (SI) and payment (BR) on the same date - no exchange difference - (R2021 Customer transactions)
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

Scenario: _0978012 Sales (SI) and payment (BR) on the same date - no exchange difference - (R5022 Expenses)
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

Scenario: _0978013 Sales (SI) and payment (BR) on the same date - no exchange difference - (R5021 Revenues)
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

Scenario: _0978014 Sales (SI) and payment (BR) on the same date - no exchange difference - (R3010 Cash on hand)
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

Scenario: _0978016 Sales (SI) and payment (BR) on the same date - no exchange difference - (T1040 Accounting amounts)
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
Scenario: _0978020 revaluation of currency balance (customer) - exchange rate decreased - (R5020B_PartnersBalance)	
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
			| 'Total'                                     | ''                                                                    | '100 982,76' | '16 949,15' | '84 033,61' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 040,00' | '1 840,00' | '9 200,00' | ''                        | ''          | ''         | ''          |
			| 'USD'                                       | ''                                                                    | '100 982,76' | '16 949,15' | '84 033,61' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 040,00' | '1 840,00' | '9 200,00' | ''                        | '12 000,00' | '2 000,00' | '10 000,00' |
			| 'Kalipso'                                   | ''                                                                    | '100 982,76' | '16 949,15' | '84 033,61' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 040,00' | '1 840,00' | '9 200,00' | ''                        | '12 000,00' | '2 000,00' | '10 000,00' |
			| 'Personal Partner terms, $'                 | ''                                                                    | '100 982,76' | '16 949,15' | '84 033,61' | ''                   | '12 000,00' | '2 000,00' | '10 000,00' | ''                        | '11 040,00' | '1 840,00' | '9 200,00' | ''                        | '12 000,00' | '2 000,00' | '10 000,00' |
			| 'Sales invoice 2 dated 02.02.2023 12:00:00' | ''                                                                    | '16 949,15'  | '16 949,15' | ''          | ''                   | '2 000,00'  | '2 000,00' | ''          | ''                        | '1 840,00'  | '1 840,00' | ''         | ''                        | '2 000,00'  | '2 000,00' | ''          |
			| 'Sales invoice 3 dated 03.02.2023 12:00:00' | ''                                                                    | '84 033,61'  | ''          | '84 033,61' | ''                   | '10 000,00' | ''         | '10 000,00' | ''                        | '9 200,00'  | ''         | '9 200,00' | ''                        | '10 000,00' | ''         | '10 000,00' |	
		And I close all client application windows
					

Scenario: _0978021 revaluation of currency balance (vendor) - exchange rate decreased 
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
			| 'Transaction currency' | 'Local currency'                                                        | ''          | ''          | ''           | 'Reporting currency' | ''         | ''         | ''          | 'Reporting currency Euro' | ''         | ''         | ''          | 'en description is empty' | ''         | ''         | ''          |
			| 'Partner'              | 'Total'                                                                 | ''          | ''          | ''           | 'Total'              | ''         | ''         | ''          | 'Total'                   | ''         | ''         | ''          | 'Total'                   | ''         | ''         | ''          |
			| 'Partner terms'        | 'Opening'                                                               | 'Receipt'   | 'Expense'   | 'Balance'    | 'Opening'            | 'Receipt'  | 'Expense'  | 'Balance'   | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance'   | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance'   |
			| 'Basis'                | ''                                                                      | ''          | ''          | ''           | ''                   | ''         | ''         | ''          | ''                        | ''         | ''         | ''          | ''                        | ''         | ''         | ''          |
			| 'Total'                | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | ''         | ''         | ''          |
			| 'USD'                  | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | '2 000,00' | '7 000,00' | '-5 000,00' |
			| 'Ferron BP'            | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | '2 000,00' | '7 000,00' | '-5 000,00' |
			| 'Vendor Ferron, USD'   | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | '2 000,00' | '7 000,00' | '-5 000,00' |
			| ''                     | ''                                                                      | '16 949,16' | '58 965,96' | '-42 016,80' | ''                   | '2 000,00' | '7 000,00' | '-5 000,00' | ''                        | '1 840,00' | '6 440,00' | '-4 600,00' | ''                        | '2 000,00' | '7 000,00' | '-5 000,00' |	
		And I close all client application windows


Scenario: _0978022 revaluation of currency balance - USD to TRY falls, USD to EUR rise - (R1021 Vendors transactions) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report info" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 3 dated 03.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''      | ''      | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'                   | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''      | ''      | ''        | ''       | ''                     | ''                         |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis' | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                                         | '03.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''      | ''      | ''        | '20'     | 'No'                   | ''                         |
			| ''                                                         | '03.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''      | ''      | ''        | '142,44' | 'No'                   | ''                         |	
		And I close all client application windows

Scenario: _0978023 revaluation of currency balance - USD to TRY falls, USD to EUR rise - (R2021 Customer transactions) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 3 dated 03.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                | ''        | ''                          | ''                                          | ''      | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'                  | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                | ''        | ''                          | ''                                          | ''      | ''        | ''       | ''                     | ''                           |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'      | 'Partner' | 'Agreement'                 | 'Basis'                                     | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                         | '03.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'USD'                  | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 2 dated 02.02.2023 12:00:00' | ''      | ''        | '20'     | 'No'                   | ''                           |
			| ''                                                         | '03.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 2 dated 02.02.2023 12:00:00' | ''      | ''        | '142,43' | 'No'                   | ''                           |	
		And I close all client application windows

Scenario: _0978024 revaluation of currency balance - USD to TRY falls, USD to EUR rise - (R3010 Cash on hand) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report info" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 3 dated 03.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| 'Register  "R3010 Cash on hand"'                           | ''                    | ''           | ''             | ''             | ''                  | ''         | ''                     | ''                             | ''       | ''                     |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                                         | '03.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, USD' | 'EUR'      | 'USD'                  | 'Reporting currency Euro'      | '6,26'   | 'No'                   |
			| ''                                                         | '03.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'TRY'      | 'EUR'                  | 'Local currency'               | '53,09'  | 'No'                   |
			| ''                                                         | '03.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Bank account, USD' | 'TRY'      | 'USD'                  | 'Local currency'               | '44,53'  | 'No'                   |
			| ''                                                         | '03.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'USD'      | 'EUR'                  | 'Reporting currency'           | '69,14'  | 'No'                   |		
		And I close all client application windows

Scenario: _0978025 revaluation of currency balance - USD to TRY falls, USD to EUR rise - (R5020 Partners balance) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 3 dated 03.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''          | ''                  | ''                          | ''                                          | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'                       | ''                    | ''           | ''             | ''             | ''          | ''                  | ''                          | ''                                          | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Partner'   | 'Legal name'        | 'Agreement'                 | 'Document'                                  | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                                         | '03.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD'        | ''                                          | 'TRY'      | 'Local currency'               | 'USD'                  | '142,44' | ''                     | ''                 | '142,44'             | ''               | ''                  | ''                 |
			| ''                                                         | '03.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Kalipso'   | 'Company Kalipso'   | 'Personal Partner terms, $' | 'Sales invoice 2 dated 02.02.2023 12:00:00' | 'EUR'      | 'Reporting currency Euro'      | 'USD'                  | '20'     | '20'                   | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                                         | '03.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD'        | ''                                          | 'EUR'      | 'Reporting currency Euro'      | 'USD'                  | '20'     | ''                     | ''                 | '20'                 | ''               | ''                  | ''                 |
			| ''                                                         | '03.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Kalipso'   | 'Company Kalipso'   | 'Personal Partner terms, $' | 'Sales invoice 2 dated 02.02.2023 12:00:00' | 'TRY'      | 'Local currency'               | 'USD'                  | '142,43' | '142,43'               | ''                 | ''                   | ''               | ''                  | ''                 |	
		And I close all client application windows

Scenario: _0978026 revaluation of currency balance - USD to TRY falls, USD to EUR rise - (R5021 Revenues) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 3 dated 03.02.2023 23:59:00' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| 'Register  "R5021 Revenues"'                               | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| ''                                                         | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '53,09'  | ''                  |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '142,44' | ''                  |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '1'      | ''                  |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '1'      | ''                  |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '6,26'   | ''                  |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '20'     | ''                  |	
		And I close all client application windows

Scenario: _0978027 revaluation of currency balance - USD to TRY falls, USD to EUR rise - (R5022 Expenses) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 3 dated 03.02.2023 23:59:00' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                               | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                                         | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '7,12'   | ''                  | ''            | ''                          |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '7,12'   | ''                  | ''            | ''                          |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '44,53'  | ''                  | ''            | ''                          |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '142,43' | ''                  | ''            | ''                          |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '69,14'  | ''                  | ''            | ''                          |
			| ''                                                         | '03.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '20'     | ''                  | ''            | ''                          |		
		And I close all client application windows

Scenario: _0978028 revaluation of currency balance - USD to TRY falls, USD to EUR rise - (R3027 Employee cash advance) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report info" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 3 dated 03.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''         | ''                     | ''                | ''                             | ''       | ''                     |
			| 'Register  "R3027 Employee cash advance"'                  | ''                    | ''           | ''             | ''             | ''         | ''                     | ''                | ''                             | ''       | ''                     |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Currency' | 'Transaction currency' | 'Partner'         | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                                         | '03.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'EUR'      | 'USD'                  | 'Alexander Orlov' | 'Reporting currency Euro'      | '1'      | 'No'                   |
			| ''                                                         | '03.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'TRY'      | 'USD'                  | 'Alexander Orlov' | 'Local currency'               | '7,12'   | 'No'                   |		
		And I close all client application windows

# Transaction +10, Reporting +100 (Trans*Rate < Rep - Expense) только инвойс
Scenario: _0978032 revaluation of currency balance (customer) - exchange rate increased (only invoice)
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
		And I input "04.02.2023" text in the field named "DateBegin"
		And I input "04.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "DFC" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Turkish lira" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                      | 'Local currency'                                                  | ''          | ''        | ''          | 'Reporting currency' | ''         | ''        | ''         | 'Reporting currency Euro' | ''         | ''        | ''         | 'en description is empty' | ''          | ''        | ''          |
			| 'Partner'                                   | 'Total'                                                           | ''          | ''        | ''          | 'Total'              | ''         | ''        | ''         | 'Total'                   | ''         | ''        | ''         | 'Total'                   | ''          | ''        | ''          |
			| 'Partner terms'                             | 'Opening'                                                         | 'Receipt'   | 'Expense' | 'Balance'   | 'Opening'            | 'Receipt'  | 'Expense' | 'Balance'  | 'Opening'                 | 'Receipt'  | 'Expense' | 'Balance'  | 'Opening'                 | 'Receipt'   | 'Expense' | 'Balance'   |
			| 'Basis'                                     | ''                                                                | ''          | ''        | ''          | ''                   | ''         | ''        | ''         | ''                        | ''         | ''        | ''         | ''                        | ''          | ''        | ''          |
			| 'Total'                                     | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 200,00' | ''        | '1 200,00' | ''                        | '1 125,00' | ''        | '1 125,00' | ''                        | ''          | ''        | ''          |
			| 'TRY'                                       | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 200,00' | ''        | '1 200,00' | ''                        | '1 125,00' | ''        | '1 125,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'DFC'                                       | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 200,00' | ''        | '1 200,00' | ''                        | '1 125,00' | ''        | '1 125,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'Partner term DFC'                          | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 200,00' | ''        | '1 200,00' | ''                        | '1 125,00' | ''        | '1 125,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'Sales invoice 4 dated 04.02.2023 12:00:00' | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 200,00' | ''        | '1 200,00' | ''                        | '1 125,00' | ''        | '1 125,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "04.02.2023" text in the field named "DateBegin"
		And I input "05.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click "Generate" button
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                      | 'Local currency'                                                  | ''          | ''        | ''          | 'Reporting currency' | ''         | ''        | ''         | 'Reporting currency Euro' | ''         | ''        | ''         | 'en description is empty' | ''          | ''        | ''          |
			| 'Partner'                                   | 'Total'                                                           | ''          | ''        | ''          | 'Total'              | ''         | ''        | ''         | 'Total'                   | ''         | ''        | ''         | 'Total'                   | ''          | ''        | ''          |
			| 'Partner terms'                             | 'Opening'                                                         | 'Receipt'   | 'Expense' | 'Balance'   | 'Opening'            | 'Receipt'  | 'Expense' | 'Balance'  | 'Opening'                 | 'Receipt'  | 'Expense' | 'Balance'  | 'Opening'                 | 'Receipt'   | 'Expense' | 'Balance'   |
			| 'Basis'                                     | ''                                                                | ''          | ''        | ''          | ''                   | ''         | ''        | ''         | ''                        | ''         | ''        | ''         | ''                        | ''          | ''        | ''          |
			| 'Total'                                     | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 210,00' | ''        | '1 210,00' | ''                        | '1 130,00' | ''        | '1 130,00' | ''                        | ''          | ''        | ''          |
			| 'TRY'                                       | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 210,00' | ''        | '1 210,00' | ''                        | '1 130,00' | ''        | '1 130,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'DFC'                                       | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 210,00' | ''        | '1 210,00' | ''                        | '1 130,00' | ''        | '1 130,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'Partner term DFC'                          | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 210,00' | ''        | '1 210,00' | ''                        | '1 130,00' | ''        | '1 130,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'Sales invoice 4 dated 04.02.2023 12:00:00' | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 210,00' | ''        | '1 210,00' | ''                        | '1 130,00' | ''        | '1 130,00' | ''                        | '10 000,00' | ''        | '10 000,00' |	
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "04.02.2023" text in the field named "DateBegin"
		And I input "06.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click "Generate" button
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                      | 'Local currency'                                                  | ''          | ''        | ''          | 'Reporting currency' | ''         | ''        | ''         | 'Reporting currency Euro' | ''         | ''        | ''         | 'en description is empty' | ''          | ''        | ''          |
			| 'Partner'                                   | 'Total'                                                           | ''          | ''        | ''          | 'Total'              | ''         | ''        | ''         | 'Total'                   | ''         | ''        | ''         | 'Total'                   | ''          | ''        | ''          |
			| 'Partner terms'                             | 'Opening'                                                         | 'Receipt'   | 'Expense' | 'Balance'   | 'Opening'            | 'Receipt'  | 'Expense' | 'Balance'  | 'Opening'                 | 'Receipt'  | 'Expense' | 'Balance'  | 'Opening'                 | 'Receipt'   | 'Expense' | 'Balance'   |
			| 'Basis'                                     | ''                                                                | ''          | ''        | ''          | ''                   | ''         | ''        | ''         | ''                        | ''         | ''        | ''         | ''                        | ''          | ''        | ''          |
			| 'Total'                                     | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 220,00' | ''        | '1 220,00' | ''                        | '1 135,00' | ''        | '1 135,00' | ''                        | ''          | ''        | ''          |
			| 'TRY'                                       | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 220,00' | ''        | '1 220,00' | ''                        | '1 135,00' | ''        | '1 135,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'DFC'                                       | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 220,00' | ''        | '1 220,00' | ''                        | '1 135,00' | ''        | '1 135,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'Partner term DFC'                          | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 220,00' | ''        | '1 220,00' | ''                        | '1 135,00' | ''        | '1 135,00' | ''                        | '10 000,00' | ''        | '10 000,00' |
			| 'Sales invoice 4 dated 04.02.2023 12:00:00' | ''                                                                | '10 000,00' | ''        | '10 000,00' | ''                   | '1 220,00' | ''        | '1 220,00' | ''                        | '1 135,00' | ''        | '1 135,00' | ''                        | '10 000,00' | ''        | '10 000,00' |	
		And I close all client application windows

Scenario: _0978033 revaluation of currency balance (vendor) - exchange rate increased
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
		And I input "04.02.2023" text in the field named "DateBegin"
		And I input "04.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Maxim" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Turkish lira" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                         | 'Local currency'                                                    | ''        | ''         | ''          | 'Reporting currency' | ''        | ''        | ''        | 'Reporting currency Euro' | ''        | ''        | ''        | 'en description is empty' | ''        | ''         | ''          |
			| 'Partner'                                      | 'Total'                                                             | ''        | ''         | ''          | 'Total'              | ''        | ''        | ''        | 'Total'                   | ''        | ''        | ''        | 'Total'                   | ''        | ''         | ''          |
			| 'Partner terms'                                | 'Opening'                                                           | 'Receipt' | 'Expense'  | 'Balance'   | 'Opening'            | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense'  | 'Balance'   |
			| 'Basis'                                        | ''                                                                  | ''        | ''         | ''          | ''                   | ''        | ''        | ''        | ''                        | ''        | ''        | ''        | ''                        | ''        | ''         | ''          |
			| 'Total'                                        | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '600,00'  | '-600,00' | ''                        | ''        | '562,50'  | '-562,50' | ''                        | ''        | ''         | ''          |
			| 'TRY'                                          | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '600,00'  | '-600,00' | ''                        | ''        | '562,50'  | '-562,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Maxim'                                        | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '600,00'  | '-600,00' | ''                        | ''        | '562,50'  | '-562,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Partner term Maxim'                           | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '600,00'  | '-600,00' | ''                        | ''        | '562,50'  | '-562,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Purchase invoice 4 dated 04.02.2023 12:00:00' | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '600,00'  | '-600,00' | ''                        | ''        | '562,50'  | '-562,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |	
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "04.02.2023" text in the field named "DateBegin"
		And I input "05.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Maxim" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Turkish lira" string
		And I click "Generate" button
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                         | 'Local currency'                                                    | ''        | ''         | ''          | 'Reporting currency' | ''        | ''        | ''        | 'Reporting currency Euro' | ''        | ''        | ''        | 'en description is empty' | ''        | ''         | ''          |
			| 'Partner'                                      | 'Total'                                                             | ''        | ''         | ''          | 'Total'              | ''        | ''        | ''        | 'Total'                   | ''        | ''        | ''        | 'Total'                   | ''        | ''         | ''          |
			| 'Partner terms'                                | 'Opening'                                                           | 'Receipt' | 'Expense'  | 'Balance'   | 'Opening'            | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense'  | 'Balance'   |
			| 'Basis'                                        | ''                                                                  | ''        | ''         | ''          | ''                   | ''        | ''        | ''        | ''                        | ''        | ''        | ''        | ''                        | ''        | ''         | ''          |
			| 'Total'                                        | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '605,00'  | '-605,00' | ''                        | ''        | '565,00'  | '-565,00' | ''                        | ''        | ''         | ''          |
			| 'TRY'                                          | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '605,00'  | '-605,00' | ''                        | ''        | '565,00'  | '-565,00' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Maxim'                                        | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '605,00'  | '-605,00' | ''                        | ''        | '565,00'  | '-565,00' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Partner term Maxim'                           | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '605,00'  | '-605,00' | ''                        | ''        | '565,00'  | '-565,00' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Purchase invoice 4 dated 04.02.2023 12:00:00' | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '605,00'  | '-605,00' | ''                        | ''        | '565,00'  | '-565,00' | ''                        | ''        | '5 000,00' | '-5 000,00' |	
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "04.02.2023" text in the field named "DateBegin"
		And I input "06.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Maxim" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Turkish lira" string
		And I click "Generate" button
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                         | 'Local currency'                                                    | ''        | ''         | ''          | 'Reporting currency' | ''        | ''        | ''        | 'Reporting currency Euro' | ''        | ''        | ''        | 'en description is empty' | ''        | ''         | ''          |
			| 'Partner'                                      | 'Total'                                                             | ''        | ''         | ''          | 'Total'              | ''        | ''        | ''        | 'Total'                   | ''        | ''        | ''        | 'Total'                   | ''        | ''         | ''          |
			| 'Partner terms'                                | 'Opening'                                                           | 'Receipt' | 'Expense'  | 'Balance'   | 'Opening'            | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense' | 'Balance' | 'Opening'                 | 'Receipt' | 'Expense'  | 'Balance'   |
			| 'Basis'                                        | ''                                                                  | ''        | ''         | ''          | ''                   | ''        | ''        | ''        | ''                        | ''        | ''        | ''        | ''                        | ''        | ''         | ''          |
			| 'Total'                                        | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '610,00'  | '-610,00' | ''                        | ''        | '567,50'  | '-567,50' | ''                        | ''        | ''         | ''          |
			| 'TRY'                                          | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '610,00'  | '-610,00' | ''                        | ''        | '567,50'  | '-567,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Maxim'                                        | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '610,00'  | '-610,00' | ''                        | ''        | '567,50'  | '-567,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Partner term Maxim'                           | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '610,00'  | '-610,00' | ''                        | ''        | '567,50'  | '-567,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |
			| 'Purchase invoice 4 dated 04.02.2023 12:00:00' | ''                                                                  | ''        | '5 000,00' | '-5 000,00' | ''                   | ''        | '610,00'  | '-610,00' | ''                        | ''        | '567,50'  | '-567,50' | ''                        | ''        | '5 000,00' | '-5 000,00' |	
		And I close all client application windows

Scenario: _0978034 revaluation of currency balance - exchange rate increased - (R5021 Revenues) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 5 dated 05.02.2023 23:59:00' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| 'Register  "R5021 Revenues"'                               | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| ''                                                         | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '54,49'  | ''                  |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '344,35' | ''                  |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '10'     | ''                  |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '1'      | ''                  |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '1'      | ''                  |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '5'      | ''                  |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '6,25'   | ''                  |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '100'    | ''                  |	
		And I close all client application windows

Scenario: _0978035 revaluation of currency balance - exchange rate increased - (R5022 Expenses) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 5 dated 05.02.2023 23:59:00' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                               | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                                         | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '6,88'   | ''                  | ''            | ''                          |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '6,88'   | ''                  | ''            | ''                          |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '43,07'  | ''                  | ''            | ''                          |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '688,7'  | ''                  | ''            | ''                          |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '5'      | ''                  | ''            | ''                          |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '68,63'  | ''                  | ''            | ''                          |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '2,5'    | ''                  | ''            | ''                          |
			| ''                                                         | '05.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '50'     | ''                  | ''            | ''                          |	
		And I close all client application windows

Scenario: _0978036 revaluation of currency balance - exchange rate increased - (R1021 Vendors transactions) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report info" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 5 dated 05.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                             | ''      | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'                   | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''                   | ''                                             | ''      | ''        | ''       | ''                     | ''                         |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                                        | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                                         | '05.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim'     | 'Maxim'     | 'Partner term Maxim' | 'Purchase invoice 4 dated 04.02.2023 12:00:00' | ''      | ''        | '5'      | 'No'                   | ''                         |
			| ''                                                         | '05.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'TRY'                  | 'Company Maxim'     | 'Maxim'     | 'Partner term Maxim' | 'Purchase invoice 4 dated 04.02.2023 12:00:00' | ''      | ''        | '2,5'    | 'No'                   | ''                         |
			| ''                                                         | '05.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                             | ''      | ''        | '50'     | 'No'                   | ''                         |
			| ''                                                         | '05.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, USD' | ''                                             | ''      | ''        | '344,35' | 'No'                   | ''                         |		
		And I close all client application windows

Scenario: _0978037 revaluation of currency balance - exchange rate increased - (R2021 Customer transactions) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 5 dated 05.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                | ''        | ''                          | ''                                          | ''      | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'                  | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                | ''        | ''                          | ''                                          | ''      | ''        | ''       | ''                     | ''                           |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'      | 'Partner' | 'Agreement'                 | 'Basis'                                     | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                         | '05.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'DFC'             | 'DFC'     | 'Partner term DFC'          | 'Sales invoice 4 dated 04.02.2023 12:00:00' | ''      | ''        | '10'     | 'No'                   | ''                           |
			| ''                                                         | '05.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'TRY'                  | 'DFC'             | 'DFC'     | 'Partner term DFC'          | 'Sales invoice 4 dated 04.02.2023 12:00:00' | ''      | ''        | '5'      | 'No'                   | ''                           |
			| ''                                                         | '05.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'USD'                  | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 3 dated 03.02.2023 12:00:00' | ''      | ''        | '100'    | 'No'                   | ''                           |
			| ''                                                         | '05.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 3 dated 03.02.2023 12:00:00' | ''      | ''        | '688,7'  | 'No'                   | ''                           |	
		And I close all client application windows

Scenario: _0978038 revaluation of currency balance - (R3021 Cash in transit (incoming)) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report info" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 5 dated 05.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                  | ''                             | ''         | ''                     | ''                                            | ''       | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"'             | ''                    | ''           | ''             | ''             | ''                  | ''                             | ''         | ''                     | ''                                            | ''       | ''                     |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Account'           | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                       | 'Amount' | 'Deferred calculation' |
			| ''                                                         | '05.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Bank account, USD' | 'Reporting currency Euro'      | 'EUR'      | 'USD'                  | 'Opening entry 112 dated 02.02.2023 12:00:00' | '1'      | 'No'                   |
			| ''                                                         | '05.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Bank account, USD' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Opening entry 112 dated 02.02.2023 12:00:00' | '6,88'   | 'No'                   |		
		And I close all client application windows

#Transaction -10, Reporting 5 (PI 20 USD R:10, BP 10 USD R:20,5)

Scenario: _0978039 Purchase (PI) and payment (BP), debt repaid in EUR, overpayment in local currency
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
		And I input "02.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Ferron BP" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "EUR" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency' | 'Local currency'                                                        | ''          | ''          | ''        | 'Reporting currency' | ''         | ''         | ''        | 'Reporting currency Euro' | ''         | ''         | ''        | 'en description is empty' | ''         | ''         | ''        |
			| 'Partner'              | 'Total'                                                                 | ''          | ''          | ''        | 'Total'              | ''         | ''         | ''        | 'Total'                   | ''         | ''         | ''        | 'Total'                   | ''         | ''         | ''        |
			| 'Partner terms'        | 'Opening'                                                               | 'Receipt'   | 'Expense'   | 'Balance' | 'Opening'            | 'Receipt'  | 'Expense'  | 'Balance' | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance' | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance' |
			| 'Basis'                | ''                                                                      | ''          | ''          | ''        | ''                   | ''         | ''         | ''        | ''                        | ''         | ''         | ''        | ''                        | ''         | ''         | ''        |
			| 'Total'                | ''                                                                      | '36 036,04' | '36 036,04' | ''        | ''                   | '4 395,60' | '4 395,60' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        | ''                        | ''         | ''         | ''        |
			| 'EUR'                  | ''                                                                      | '36 036,04' | '36 036,04' | ''        | ''                   | '4 395,60' | '4 395,60' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        |
			| 'Ferron BP'            | ''                                                                      | '36 036,04' | '36 036,04' | ''        | ''                   | '4 395,60' | '4 395,60' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        |
			| 'Vendor Ferron, EUR'   | ''                                                                      | '36 036,04' | '36 036,04' | ''        | ''                   | '4 395,60' | '4 395,60' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        |
			| ''                     | ''                                                                      | '36 036,04' | '36 036,04' | ''        | ''                   | '4 395,60' | '4 395,60' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        | ''                        | '4 000,00' | '4 000,00' | ''        |
		And I close all client application windows

Scenario: _0978040 Sales (SI) and payment (BR) in TRY, customer advace closing 
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
		And I input "07.02.2023" text in the field named "DateBegin"
		And I input "09.02.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Maxim" string
		And I set checkbox named "SettingsComposerUserSettingsItem2Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Turkish lira" string
		And I click "Generate" button
	* Check currency revaluation
		Then "Result" spreadsheet document contains lines:
			| 'Transaction currency'                         | 'Local currency'                                                    | ''          | ''          | ''          | 'Reporting currency' | ''         | ''         | ''        | 'Reporting currency Euro' | ''         | ''         | ''        | 'en description is empty' | ''          | ''          | ''          |
			| 'Partner'                                      | 'Total'                                                             | ''          | ''          | ''          | 'Total'              | ''         | ''         | ''        | 'Total'                   | ''         | ''         | ''        | 'Total'                   | ''          | ''          | ''          |
			| 'Partner terms'                                | 'Opening'                                                           | 'Receipt'   | 'Expense'   | 'Balance'   | 'Opening'            | 'Receipt'  | 'Expense'  | 'Balance' | 'Opening'                 | 'Receipt'  | 'Expense'  | 'Balance' | 'Opening'                 | 'Receipt'   | 'Expense'   | 'Balance'   |
			| 'Basis'                                        | ''                                                                  | ''          | ''          | ''          | ''                   | ''         | ''         | ''        | ''                        | ''         | ''         | ''        | ''                        | ''          | ''          | ''          |
			| 'Total'                                        | '-5 000,00'                                                         | '10 000,00' | '10 000,00' | '-5 000,00' | '-610,00'            | '1 250,00' | '1 265,00' | '-625,00' | '-567,50'                 | '1 150,00' | '1 157,50' | '-575,00' | ''                        | ''          | ''          | ''          |
			| 'TRY'                                          | '-5 000,00'                                                         | '10 000,00' | '10 000,00' | '-5 000,00' | '-610,00'            | '1 250,00' | '1 265,00' | '-625,00' | '-567,50'                 | '1 150,00' | '1 157,50' | '-575,00' | '-5 000,00'               | '10 000,00' | '10 000,00' | '-5 000,00' |
			| 'Maxim'                                        | '-5 000,00'                                                         | '10 000,00' | '10 000,00' | '-5 000,00' | '-610,00'            | '1 250,00' | '1 265,00' | '-625,00' | '-567,50'                 | '1 150,00' | '1 157,50' | '-575,00' | '-5 000,00'               | '10 000,00' | '10 000,00' | '-5 000,00' |
			| 'Basic Partner terms, TRY'                     | ''                                                                  | '10 000,00' | '10 000,00' | ''          | ''                   | '1 250,00' | '1 250,00' | ''        | ''                        | '1 150,00' | '1 150,00' | ''        | ''                        | '10 000,00' | '10 000,00' | ''          |
			| ''                                             | ''                                                                  | ''          | '5 000,00'  | '-5 000,00' | ''                   | ''         | '625,00'   | '-625,00' | ''                        | ''         | '575,00'   | '-575,00' | ''                        | ''          | '5 000,00'  | '-5 000,00' |
			| 'Sales invoice 5 dated 07.02.2023 12:00:00'    | ''                                                                  | '10 000,00' | '5 000,00'  | '5 000,00'  | ''                   | '1 250,00' | '625,00'   | '625,00'  | ''                        | '1 150,00' | '575,00'   | '575,00'  | ''                        | '10 000,00' | '5 000,00'  | '5 000,00'  |
			| 'Partner term Maxim'                           | '-5 000,00'                                                         | ''          | ''          | '-5 000,00' | '-610,00'            | ''         | '15,00'    | '-625,00' | '-567,50'                 | ''         | '7,50'     | '-575,00' | '-5 000,00'               | ''          | ''          | '-5 000,00' |
			| 'Purchase invoice 4 dated 04.02.2023 12:00:00' | '-5 000,00'                                                         | ''          | ''          | '-5 000,00' | '-610,00'            | ''         | '15,00'    | '-625,00' | '-567,50'                 | ''         | '7,50'     | '-575,00' | '-5 000,00'               | ''          | ''          | '-5 000,00' |	
		And I close all client application windows

Scenario: _0978042 revaluation of currency balance - (R2020 Advances from customer) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report info" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 9 dated 09.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''              | ''        | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'                 | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''              | ''        | ''      | ''                         | ''        | ''       | ''                     | ''                           |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'    | 'Partner' | 'Order' | 'Agreement'                | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                         | '09.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Basic Partner terms, TRY' | ''        | '5'      | 'No'                   | ''                           |
			| ''                                                         | '09.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'TRY'                  | 'Company Maxim' | 'Maxim'   | ''      | 'Basic Partner terms, TRY' | ''        | '2,5'    | 'No'                   | ''                           |		
		And I close all client application windows

Scenario: _0978043 revaluation of currency balance - (R1020 Advances to vendors) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report info" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 9 dated 09.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'                    | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                   | ''        | ''       | ''                     | ''                         |
			| ''                                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'          | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                                         | '09.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '6'      | 'No'                   | ''                         |
			| ''                                                         | '09.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Vendor Ferron, TRY' | ''        | '3'      | 'No'                   | ''                         |		
		And I close all client application windows

Scenario: _0978044 revaluation of currency balance - (R5015 Other partners transactions) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '10'         |
	* Check movements by the Register  "R5015 Other partners transactions" 
		And I click "Registrations report info" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 10 dated 10.02.2023 23:59:00' | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                | ''                | ''                     | ''      | ''       | ''                     |
			| 'Register  "R5015 Other partners transactions"'             | ''                    | ''           | ''             | ''             | ''                             | ''         | ''                     | ''                | ''                | ''                     | ''      | ''       | ''                     |
			| ''                                                          | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'      | 'Partner'         | 'Agreement'            | 'Basis' | 'Amount' | 'Deferred calculation' |
			| ''                                                          | '10.02.2023 23:59:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Reporting currency Euro'      | 'EUR'      | 'USD'                  | 'Other partner 1' | 'Other partner 1' | 'Other partner 1, USD' | ''      | '2'      | 'No'                   |
			| ''                                                          | '10.02.2023 23:59:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'USD'                  | 'Other partner 1' | 'Other partner 1' | 'Other partner 1, USD' | ''      | '12,7'   | 'No'                   |
		And I close all client application windows

Scenario: _0978045 revaluation of currency balance - (R5021 Revenues, include Other partner transaction) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 10 dated 10.02.2023 23:59:00' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| 'Register  "R5021 Revenues"'                                | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| ''                                                          | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '10,17'  | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '317,46' | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '4'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '5'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '6'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '10'     | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '1'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '1'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '2'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '2'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '2,5'    | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '3'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '5'      | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '6,26'   | ''                  |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '100'    | ''                  |
		And I close all client application windows

Scenario: _0978046 revaluation of currency balance - (R5022 Expenses, include Other partner transaction) 
	And I close all client application windows	
	* Select Foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Foreign currency revaluation 10 dated 10.02.2023 23:59:00' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                                | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                                          | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '6,35'   | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '6,35'   | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '12,7'   | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '39,7'   | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '634,92' | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '5'      | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '5'      | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '6'      | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '10,31'  | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '2,5'    | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '2,5'    | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '3'      | ''                  | ''            | ''                          |
			| ''                                                          | '10.02.2023 23:59:00' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'EUR'      | ''                    | 'Reporting currency Euro'      | ''        | '50'     | ''                  | ''            | ''                          |	
		And I close all client application windows