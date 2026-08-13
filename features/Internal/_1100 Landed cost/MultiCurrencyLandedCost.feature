#language: en
@tree
@LandedCost

Feature: Multi currency landed cost

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _100 test data (multi currency landed cost)
	When set True value to the constant
	* Load base data
		When Create catalog AddAttributeAndPropertySets objects (LC)
		When Create catalog CancelReturnReasons objects (LC)
		When Create catalog AddAttributeAndPropertyValues objects (LC)
		When Create catalog IDInfoAddresses objects (LC)
		When Create catalog BusinessUnits objects (LC)
		When Create catalog Companies objects (LC)
		When Create catalog ConfigurationMetadata objects (LC)
		When Create catalog Countries objects (LC)
		When Create catalog Currencies objects (LC)
		When Create catalog ExpenseAndRevenueTypes objects (LC)
		When Create catalog IntegrationSettings objects (LC)
		When Create catalog ItemKeys objects (LC)
		When Create catalog ItemSegments objects (LC)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ReportOptions objects
		When Create catalog SerialLotNumbers objects (LC)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog ItemTypes objects (LC)
		When Create catalog Units objects (LC)
		When Create catalog Countries objects
		When Create catalog Items objects (LC)
		When Create catalog CurrencyMovementSets objects (LC)
		When Create catalog ObjectStatuses objects (LC)
		When Create catalog PartnerSegments objects (LC)
		When Create catalog Agreements objects (LC)
		When Create catalog Partners objects (LC)
		When Create catalog ExternalDataProc objects (LC)
		When Create catalog PriceKeys objects (LC)
		When Create catalog PriceTypes objects (LC)
		When Create catalog Specifications objects (LC)
		When Create catalog Stores objects (LC)
		When Create catalog TaxRates objects (LC)
		When Create catalog Taxes objects (LC)
		When Create catalog InterfaceGroups objects (LC)
		When Create information register Barcodes records
		When Create catalog AccessGroups objects (LC)
		When Create catalog AccessProfiles objects (LC)
		When Create catalog UserGroups objects (LC)
		When Create catalog Users objects (LC)
		When Create chart of characteristic types AddAttributeAndProperty objects (LC)
		When Create chart of characteristic types CustomUserSettings objects (LC)
		When Create chart of characteristic types CurrencyMovementType objects (LC)
		When Create information register Taxes records (LC)
		When Create information register CurrencyRates records (LC)
		When Create information register TaxSettings records (LC)
		When Create information register UserSettings records (LC)
	* Multi currency rates (fixed rate 40 from 01.02.2025 so that all expected amounts are deterministic)
		When Create information register CurrencyRates records (MC)
	* Multi currency items (isolated items so that other scenarios never touch these batches)
		When Create catalog Items objects (MC)
		When Create catalog ItemKeys objects (MC)
	* Enable preliminary stock
		And I set "True" value to the constant "UsePreliminaryStock"
	* Classic numbering so that manual document numbers stay editable
		And I set "False" value to the constant "UseNumberingRules"
	* Allow manual numbers - force the OnChange so the session parameter is refreshed even if the box already looks checked
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I remove checkbox "Number editing available"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	And I close all client application windows


Scenario: _1001 check preparation (multi currency landed cost)
	When check preparation


Scenario: _102 preliminary receipt and multi currency sales (case 14, 33)
	And I close all client application windows
	* Enable manual numbers for this scenario - the session parameter does not survive across scenario boundaries
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I remove checkbox "Number editing available"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	* Create Goods receipt 251 with preliminary amount 196 USD for 7 pcs
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I select "Purchase" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "Partner" by "DFC" string
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 07'     |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item A'    |
		And I select current line in "List" table
		And I input "7" text in "Quantity" field of "ItemList" table
		And I change "Is prelim." checkbox in "ItemList" table
		And I input "196" text in "Amount (prelim.)" field of "ItemList" table
		And I activate field named "ItemListCurrency" in "ItemList" table
		And I select "USD" exact value from the drop-down list named "ItemListCurrency" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "251" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "251" text in "Number" field
		And I input "03.02.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Create Sales invoice 252 in USD (5 pcs x 100 USD)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from "Partner" drop-down list by "Ka" string
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 07'     |
		And I select current line in "List" table
		And I select "USD" exact value from "Currency" drop-down list
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		Then the form attribute named "Currency" became equal to "USD"
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item A'    |
		And I select current line in "List" table
		And I input "5" text in "Quantity" field of "ItemList" table
		And I input "100" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "252" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "252" text in "Number" field
		And I input "05.02.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Create Sales invoice 253 in TRY (2 pcs x 5000 TRY)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from "Partner" drop-down list by "Ka" string
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 07'     |
		And I select current line in "List" table
		And I select "TRY" exact value from "Currency" drop-down list
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		Then the form attribute named "Currency" became equal to "TRY"
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item A'    |
		And I select current line in "List" table
		And I input "2" text in "Quantity" field of "ItemList" table
		And I input "5000" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "253" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "253" text in "Number" field
		And I input "05.02.2025 12:10:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Create Calculation movement costs 201 (01.02-15.02.2025)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "01.02.2025" text in "Begin date" field
		And I input "15.02.2025" text in "End date" field
		And I input "15.02.2025 23:00:00" text in "Date" field
		And I input "201" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "201" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list
		And I click "Post and close" button
		And Delay 10
	* Check Sales invoice 252 movements by R5022 Expenses (Local = settlement, no rate inflation)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '252'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '05.02.2025 12:00:00' | '140' | '140' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
		And I close all client application windows
	* Check Sales invoice 253 movements by R5022 Expenses (TRY sale untouched by currency logic)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '253'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '05.02.2025 12:10:00' | '56' | '56' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:10:00' | '2 240' | '2 240' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:10:00' | '2 240' | '2 240' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
	And I close all client application windows


Scenario: _103 purchase invoice in USD with service generated from preliminary receipt (case 31 baseline)
	And I close all client application windows
	* Enable manual numbers for this scenario - the session parameter does not survive across scenario boundaries
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I remove checkbox "Number editing available"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	* Generate Purchase invoice from Goods receipt 251
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '251'     |
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I click "Ok" button
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Agreement vendor DFC'  |
		And I select current line in "List" table
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
	* Switch to USD and set actual price 30
		And I select "USD" exact value from "Currency" drop-down list
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		Then the form attribute named "Currency" became equal to "USD"
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I go to line in "ItemList" table
			| 'Item'       |
			| 'MC Item A'  |
		And I activate field named "ItemListPrice" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "30" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add service row 100 USD
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Work'      |
		And I select current line in "List" table
		And I input "1" text in "Quantity" field of "ItemList" table
		And I input "100" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post as 254 dated 20.02.2025
		And I move to "Other" tab
		And I input "254" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "254" text in "Number" field
		And I input "20.02.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Check own service rows in R5022 Expenses (document currency fan, no CMC yet)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '254'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '20.02.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '4 000' | '4 720' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'TRY' | '' | 'Local currency' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'en description is empty' | '' | '' |
	And I close all client application windows


Scenario: _104 calculation for second half writes correction and keeps own service rows (case 31, 34, 18)
	And I close all client application windows
	* Enable manual numbers for this scenario - the session parameter does not survive across scenario boundaries
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I remove checkbox "Number editing available"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	* Create Calculation movement costs 202 (16.02-28.02.2025)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "16.02.2025" text in "Begin date" field
		And I input "28.02.2025" text in "End date" field
		And I input "28.02.2025 23:00:00" text in "Date" field
		And I input "202" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "202" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list
		And I click "Post and close" button
		And Delay 10
	* Check Purchase invoice 254: own service rows unchanged and Expense correction added (560 TRY = 14 USD x 40)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '254'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '20.02.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '4 000' | '4 720' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'TRY' | '' | 'Local currency' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'en description is empty' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '14' | '51,8' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 202 dated 28.02.2025 23:00:00' |
			| '' | '20.02.2025 12:00:00' | '560' | '2 072' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 202 dated 28.02.2025 23:00:00' |
			| '' | '20.02.2025 12:00:00' | '560' | '2 072' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 202 dated 28.02.2025 23:00:00' |
		And I close all client application windows
	* Check Sales invoice 252 rows are not touched by the second calculation (case 34: cross-CMC isolation)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '252'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '05.02.2025 12:00:00' | '140' | '140' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
	And I close all client application windows


Scenario: _105 reposting CMC, FX purchase invoice and FX sales invoice keeps all amounts (case 35, 36)
	And I close all client application windows
	* Repost Calculation movement costs 202
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Number'  |
			| '202'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay 10
	* Repost Purchase invoice 254 (USD)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '254'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay 4
	* Repost Sales invoice 252 (USD)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '252'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay 4
	* Check Purchase invoice 254 amounts survived all reposts
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '254'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '20.02.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '4 000' | '4 720' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'TRY' | '' | 'Local currency' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'en description is empty' | '' | '' |
			| '' | '20.02.2025 12:00:00' | '14' | '51,8' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 202 dated 28.02.2025 23:00:00' |
			| '' | '20.02.2025 12:00:00' | '560' | '2 072' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 202 dated 28.02.2025 23:00:00' |
			| '' | '20.02.2025 12:00:00' | '560' | '2 072' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 202 dated 28.02.2025 23:00:00' |
		And I close all client application windows
	* Check Sales invoice 252 amounts survived repost
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '252'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '05.02.2025 12:00:00' | '140' | '140' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
			| '' | '05.02.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item A' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 201 dated 15.02.2025 23:00:00' |
	And I close all client application windows


Scenario: _106 duplicate calculation for overlapping period is refused (case 30 interactive control)
	And I close all client application windows
	* Enable manual numbers for this scenario - the session parameter does not survive across scenario boundaries
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I remove checkbox "Number editing available"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	* Try to create Calculation movement costs copy for 01.02-15.02.2025
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select "Landed cost" exact value from "Calculation mode" drop-down list
		And I input "206" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "206" text in "Number" field
		And I input "01.02.2025" text in "Begin date" field
		And I input "15.02.2025" text in "End date" field
		And I click the button named "FormPost"
	* Check refusal message
		Given Recent TestClient message contains "Overlapping period*" string by template
	* The rejected document was not even written - the filling check fires before the write
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And "List" table does not contain lines
			| 'Number'  |
			| '206'     |
	And I close all client application windows


Scenario: _107 write-off and worksheet consume batches with RowID (case 38 baseline)
	And I close all client application windows
	* Enable manual numbers for this scenario - the session parameter does not survive across scenario boundaries
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I remove checkbox "Number editing available"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	* Create Purchase invoice 255 in TRY for MC Item B (10 x 1000 TRY)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'  |
			| 'DFC'          |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'  |
			| 'DFC'          |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Agreement vendor DFC'  |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 04'     |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item B'    |
		And I select current line in "List" table
		And I input "10" text in "Quantity" field of "ItemList" table
		And I input "1000" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "255" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "255" text in "Number" field
		And I input "01.03.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Create Stock adjustment as write-off 256 (2 pcs MC Item B)
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 04'     |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item B'    |
		And I select current line in "List" table
		And I input "2" text in "Quantity" field of "ItemList" table
		And I activate "Expense type" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Expense type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Expense'      |
		And I select current line in "List" table
		And I activate "Profit loss center" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Front office'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I input "256" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "256" text in "Number" field
		And I input "05.03.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		And I click "Post and close" button
	* Create Work sheet 257 with material MC Item B (2 pcs)
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'  |
			| 'DFC'          |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Work'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I select "TRY" exact value from "Currency" drop-down list
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		Then the form attribute named "Currency" became equal to "TRY"
		And I move to "Materials" tab
		And in the table "Materials" I click the button named "MaterialsAdd"
		And I activate field named "MaterialsItem" in "Materials" table
		And I click choice button of the attribute named "MaterialsItem" in "Materials" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item B'    |
		And I select current line in "List" table
		And I select "Store 04" from "Store" drop-down list by string in "Materials" table
		And I input "2" text in "Quantity" field of "Materials" table
		And I select "Include to work cost" from "Cost write off" drop-down list by string in "Materials" table
		And I activate "Expense type" field in "Materials" table
		And I select current line in "Materials" table
		And I click choice button of "Expense type" attribute in "Materials" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Expense'      |
		And I select current line in "List" table
		And I activate "Profit loss center" field in "Materials" table
		And I select current line in "Materials" table
		And I click choice button of "Profit loss center" attribute in "Materials" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Front office'  |
		And I select current line in "List" table
		And I finish line editing in "Materials" table
		And I input "257" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "257" text in "Number" field
		And I input "07.03.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		And I click "Post and close" button
	* Create Calculation movement costs 203 (01.03-15.03.2025)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "01.03.2025" text in "Begin date" field
		And I input "15.03.2025" text in "End date" field
		And I input "15.03.2025 23:00:00" text in "Date" field
		And I input "203" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "203" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list
		And I click "Post and close" button
		And Delay 10
	* Check write-off 256 full currency fan (2 000 TRY)
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'  |
			| '256'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '05.03.2025 12:00:00' | '50' | '59' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '05.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '05.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
		And I close all client application windows
	* Check worksheet 257 full currency fan (2 000 TRY)
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'  |
			| '257'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '07.03.2025 12:00:00' | '50' | '59' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '07.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '07.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
	And I close all client application windows


Scenario: _108 reposting write-off keeps the currency fan (case 38, RED until fixed)
	And I close all client application windows
	* Repost Stock adjustment as write-off 256
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'  |
			| '256'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay 4
	* Check the fan survived (Local and Reporting rows must still exist)
		And I go to line in "List" table
			| 'Number'  |
			| '256'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '05.03.2025 12:00:00' | '50' | '59' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '05.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '05.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
	And I close all client application windows


Scenario: _109 reposting worksheet keeps the currency fan (case 38, RED until fixed)
	And I close all client application windows
	* Repost Work sheet 257
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I go to line in "List" table
			| 'Number'  |
			| '257'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay 4
	* Check the fan survived (Local and Reporting rows must still exist)
		And I go to line in "List" table
			| 'Number'  |
			| '257'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '07.03.2025 12:00:00' | '50' | '59' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '07.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
			| '' | '07.03.2025 12:00:00' | '2 000' | '2 360' | '' | 'Main Company' | '' | 'Front office' | 'Expense' | 'MC Item B' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 203 dated 15.03.2025 23:00:00' |
	And I close all client application windows


Scenario: _110 revenue correction for cheaper invoice keeps service rows (case 32)
	And I close all client application windows
	* Enable manual numbers for this scenario - the session parameter does not survive across scenario boundaries
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I remove checkbox "Number editing available"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	* Create Goods receipt 258 with preliminary amount 140 USD for 5 pcs MC Item C
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I select "Purchase" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "Partner" by "DFC" string
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 07'     |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item C'    |
		And I select current line in "List" table
		And I input "5" text in "Quantity" field of "ItemList" table
		And I change "Is prelim." checkbox in "ItemList" table
		And I input "140" text in "Amount (prelim.)" field of "ItemList" table
		And I activate field named "ItemListCurrency" in "ItemList" table
		And I select "USD" exact value from the drop-down list named "ItemListCurrency" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "258" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "258" text in "Number" field
		And I input "01.04.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Create Sales invoice 259 in USD (5 pcs x 100 USD)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from "Partner" drop-down list by "Ka" string
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 07'     |
		And I select current line in "List" table
		And I select "USD" exact value from "Currency" drop-down list
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		Then the form attribute named "Currency" became equal to "USD"
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Item C'    |
		And I select current line in "List" table
		And I input "5" text in "Quantity" field of "ItemList" table
		And I input "100" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "259" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "259" text in "Number" field
		And I input "03.04.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Create Calculation movement costs 204 (01.04-15.04.2025)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "01.04.2025" text in "Begin date" field
		And I input "15.04.2025" text in "End date" field
		And I input "15.04.2025 23:00:00" text in "Date" field
		And I input "204" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "204" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list
		And I click "Post and close" button
		And Delay 10
	* Check Sales invoice 259 movements: preliminary cost converted to the full currency fan
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '259'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '03.04.2025 12:00:00' | '140' | '140' | '' | 'Main Company' | '' | '' | '' | 'MC Item C' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | 'Calculation movement costs 204 dated 15.04.2025 23:00:00' |
			| '' | '03.04.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item C' | '' | '' | 'TRY' | '' | 'Local currency' | '' | 'Calculation movement costs 204 dated 15.04.2025 23:00:00' |
			| '' | '03.04.2025 12:00:00' | '5 600' | '5 600' | '' | 'Main Company' | '' | '' | '' | 'MC Item C' | '' | '' | 'TRY' | '' | 'en description is empty' | '' | 'Calculation movement costs 204 dated 15.04.2025 23:00:00' |
		And I close all client application windows
	* Generate Purchase invoice from Goods receipt 258, cheaper price 27 USD plus service
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '258'     |
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I click "Ok" button
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Agreement vendor DFC'  |
		And I select current line in "List" table
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I select "USD" exact value from "Currency" drop-down list
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		Then the form attribute named "Currency" became equal to "USD"
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I go to line in "ItemList" table
			| 'Item'       |
			| 'MC Item C'  |
		And I activate field named "ItemListPrice" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "27" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'MC Work'      |
		And I select current line in "List" table
		And I input "1" text in "Quantity" field of "ItemList" table
		And I input "100" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "260" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "260" text in "Number" field
		And I input "20.04.2025 12:00:00" text in "Date" field
		And I move to the next attribute
		If "Update item list info" window is opened Then
			And I click "Uncheck all" button
			And I click "OK" button
		And I click "Post and close" button
	* Create Calculation movement costs 205 (16.04-30.04.2025)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "16.04.2025" text in "Begin date" field
		And I input "30.04.2025" text in "End date" field
		And I input "30.04.2025 23:00:00" text in "Date" field
		And I input "205" text in "Number" field
		If "1C:Enterprise" window is opened Then
			And I click "Yes" button
			And I input "205" text in "Number" field
		And I select "Landed cost" exact value from "Calculation mode" drop-down list
		And I click "Post and close" button
		And Delay 10
	* Check Revenue correction in R5021 Revenues on Purchase invoice 260 (200 TRY = 5 USD x 40, revenue is positive)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '260'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '20.04.2025 12:00:00' | '5'      | '5'    | 'Main Company' | '' | '' | '' | 'MC Item C' | 'USD' | '' | 'Reporting currency'       | '' | 'Calculation movement costs 205 dated 30.04.2025 23:00:00' |
			| '' | '20.04.2025 12:00:00' | '200'    | '200'  | 'Main Company' | '' | '' | '' | 'MC Item C' | 'TRY' | '' | 'Local currency'           | '' | 'Calculation movement costs 205 dated 30.04.2025 23:00:00' |
			| '' | '20.04.2025 12:00:00' | '200'    | '200'  | 'Main Company' | '' | '' | '' | 'MC Item C' | 'TRY' | '' | 'en description is empty'  | '' | 'Calculation movement costs 205 dated 30.04.2025 23:00:00' |
		And I close all client application windows
	* Check service rows in R5022 Expenses untouched by the Revenue correction
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '260'     |
		And I click "Registrations report" button
		And in "ResultTable" spreadsheet document I move to "R1C1" cell
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines:
			| '' | '20.04.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'Reporting currency' | '' | '' |
			| '' | '20.04.2025 12:00:00' | '4 000' | '4 720' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'TRY' | '' | 'Local currency' | '' | '' |
			| '' | '20.04.2025 12:00:00' | '100' | '118' | '' | 'Main Company' | '' | '' | '' | 'MC Work' | '' | '' | 'USD' | '' | 'en description is empty' | '' | '' |
	And I close all client application windows


Scenario: _199 teardown (multi currency landed cost)
	And I set "False" value to the constant "UsePreliminaryStock"
