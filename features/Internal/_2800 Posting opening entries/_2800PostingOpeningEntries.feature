#language: en
@tree
@Positive

Feature: check opening entry

As a developer
I want to create a document to enter the opening balance
To input the client's balance when you start working with the base

Background:
	Given I launch TestClient opening script or connect the existing one


# it's necessary to add tests to start the remainder of the documents
Scenario: _400000 preparation
	* Create SI for opening entry by documents
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from "Partner" drop-down list by "DFC" string
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Partner term DFC' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "15,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "5 900" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5 900" text in "Number" field
		And I set checkbox "Is opening entry"
		And Delay 1
		And I click "Post and close" button
	* Create PI for opening entry by documents
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I select from "Partner" drop-down list by "DFC" string
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Partner term vendor DFC' |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "15,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I input "5 900" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5 900" text in "Number" field
		And I set checkbox "Is opening entry"
		And Delay 1
		And I click "Post and close" button


Scenario: _400001 opening entry account balance
	* Open document form for opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Change the document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	* Filling in the tabular part account balance
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description  |
			| Cash desk №2 |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description  |
			| Cash desk №3 |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code | Description |
			| EUR  | Euro        |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description       |
			| Bank account, TRY |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "10 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description       |
			| Bank account, USD |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "5 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description       |
			| Bank account, EUR |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "8 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
	* Check filling in currency rate
		* Filling in currency rate Cash desk №2
			And I go to line in "AccountBalance" table
				| 'Account'      | 'Amount'   | 'Currency' |
				| 'Cash desk №2' | '1 000,00' | 'USD'      |
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'USD'  | 'Local currency' | 'TRY' | 'Legal' |
			And I input "0,1756" text in the field named "CurrenciesAccountBalanceRatePresentation" of "CurrenciesAccountBalance" table
			And I input "1" text in the field named "CurrenciesAccountBalanceMultiplicity" of "CurrenciesAccountBalance" table
			And I activate "Amount" field in "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
		* Filling in currency rate Cash desk №3
			And I go to line in "AccountBalance" table
				| 'Account'      | 'Amount'   | 'Currency' |
				| 'Cash desk №3' | '1 000,00' | 'EUR'      |
			And I activate "Account" field in "AccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'TRY' | 'Legal' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "0,1758" text in the field named "CurrenciesAccountBalanceRatePresentation" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'      | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | 'USD' | 'Reporting' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "1,1000" text in the field named "CurrenciesAccountBalanceRatePresentation" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'Legal' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "1" text in the field named "CurrenciesAccountBalanceMultiplicity" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'      | 'Rate'   | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | '1,1000' | 'USD' | 'Reporting' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "1" text in the field named "CurrenciesAccountBalanceMultiplicity" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
		* Filling in currency rate Bank account, USD
			And I go to line in "AccountBalance" table
				| 'Account'           | 'Currency' |
				| 'Bank account, USD' | 'USD'      |
			And I select current line in "CurrenciesAccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'USD'  | 'Local currency' | 'TRY' | 'Legal' |
			And I input "0,1758" text in the field named "CurrenciesAccountBalanceRatePresentation" of "CurrenciesAccountBalance" table
			And I input "1" text in the field named "CurrenciesAccountBalanceMultiplicity" of "CurrenciesAccountBalance" table
			And I activate "Amount" field in "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
		* Filling in currency rate Bank account, EUR
			And I go to line in "AccountBalance" table
				| 'Account'           | 'Currency' |
				| 'Bank account, EUR' | 'EUR'      |
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'TRY' | 'Legal' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "0,1758" text in the field named "CurrenciesAccountBalanceRatePresentation" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'      | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | 'USD' | 'Reporting' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "1,1000" text in the field named "CurrenciesAccountBalanceRatePresentation" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'  | 'To'  | 'Type'  |
				| 'EUR'  | 'Local currency' | 'TRY' | 'Legal' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "1" text in the field named "CurrenciesAccountBalanceMultiplicity" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
			And I go to line in "CurrenciesAccountBalance" table
				| 'From' | 'Movement type'      | 'Rate'   | 'To'  | 'Type'      |
				| 'EUR'  | 'Reporting currency' | '1,1000' | 'USD' | 'Reporting' |
			And I select current line in "CurrenciesAccountBalance" table
			And I input "1" text in the field named "CurrenciesAccountBalanceMultiplicity" of "CurrenciesAccountBalance" table
			And I finish line editing in "CurrenciesAccountBalance" table
	* Post document
		And I click "Post and close" button
		And Delay 5
		* Check movements
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table contains lines
			| 'Currency' | 'Recorder'         | 'Company'      | 'Account'           | 'Multi currency movement type' | 'Amount'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Local currency'         | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Reporting currency'     | '171,23'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Local currency'         | '5 694,76'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Reporting currency'     | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Local currency'         | '5 688,28'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Reporting currency'     | '909,09'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Local currency'         | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Reporting currency'     | '1 712,33'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Local currency'         | '28 441,41' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Reporting currency'     | '5 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Local currency'         | '45 506,26' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Reporting currency'     | '7 272,73'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | '*'                      | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | '*'                      | '1 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | '*'                      | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | '*'                      | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | '*'                      | '5 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | '*'                      | '8 000,00'  |
			And I close all client application windows
	* Clear movements and  check movement reversal
		* Clear movements
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I go to line in "List" table
			| 'Number' |
			| '1'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check clearing movements
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table does not contain lines
			| 'Currency' | 'Recorder'         | 'Company'      | 'Account'           | 'Multi currency movement type' | 'Amount'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Local currency'         | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Reporting currency'     | '171,23'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Local currency'         | '5 694,76'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Reporting currency'     | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Local currency'         | '5 688,28'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Reporting currency'     | '909,09'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Local currency'         | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Reporting currency'     | '1 712,33'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Local currency'         | '28 441,41' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Reporting currency'     | '5 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Local currency'         | '45 506,26' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Reporting currency'     | '7 272,73'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | '*'                      | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | '*'                      | '1 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | '*'                      | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | '*'                      | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | '*'                      | '5 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | '*'                      | '8 000,00'  |
			And I close all client application windows
	* Posting the document back and check movements
		* Post document
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I go to line in "List" table
			| 'Number' |
			| '1'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table contains lines
			| 'Currency' | 'Recorder'         | 'Company'      | 'Account'           | 'Multi currency movement type' | 'Amount'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Local currency'         | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | 'Reporting currency'     | '171,23'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Local currency'         | '5 694,76'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | 'Reporting currency'     | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Local currency'         | '5 688,28'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | 'Reporting currency'     | '909,09'    |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Local currency'         | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | 'Reporting currency'     | '1 712,33'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Local currency'         | '28 441,41' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | 'Reporting currency'     | '5 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Local currency'         | '45 506,26' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | 'Reporting currency'     | '7 272,73'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №1'      | '*'                      | '1 000,00'  |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №2'      | '*'                      | '1 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Cash desk №3'      | '*'                      | '1 000,00'  |
			| 'TRY'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, TRY' | '*'                      | '10 000,00' |
			| 'USD'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, USD' | '*'                      | '5 000,00'  |
			| 'EUR'      | 'Opening entry 1*' | 'Main Company' | 'Bank account, EUR' | '*'                      | '8 000,00'  |
			And I close all client application windows




Scenario: _400002 opening entry inventory balance
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Change the document number
		And I move to "Other" tab
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	* Filling in the tabular part Inventory
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | XS/Blue  |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "500,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | S/Yellow |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "400,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | XS/Blue  |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table
		And I activate "Quantity" field in "Inventory" table
		And I select current line in "Inventory" table
		And I input "400,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item     | Item key  |
			| Trousers | 38/Yellow |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Shirt | 36/Red   |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Shirt | 36/Red   |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 36/18SD  |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "200,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 36/18SD  |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "300,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | L/Green  |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "500,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | L/Green  |
		And I select current line in "List" table
		And I activate "Store" field in "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table
		And I go to line in "Inventory" table
			| 'Item key' | 'Quantity' | 'Store'    |
			| 'L/Green'  | '500,000'  | 'Store 01' |
		And I activate "Quantity" field in "Inventory" table
		And I go to line in "Inventory" table
			| Item key | Store    |
			| L/Green  | Store 02 |
		And I select current line in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
	* Post document
		And I click "Post" button
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
		And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Company'      | 'Item key'  |
		| '500,000'  | 'Opening entry 2*' | 'Main Company' | 'XS/Blue'   |
		| '400,000'  | 'Opening entry 2*' | 'Main Company' | 'S/Yellow'  |
		| '400,000'  | 'Opening entry 2*' | 'Main Company' | 'XS/Blue'   |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '36/Red'    |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | '36/Red'    |
		| '200,000'  | 'Opening entry 2*' | 'Main Company' | '36/18SD'   |
		| '300,000'  | 'Opening entry 2*' | 'Main Company' | '36/18SD'   |
		| '500,000'  | 'Opening entry 2*' | 'Main Company' | 'L/Green'   |
		| '100,000'  | 'Opening entry 2*' | 'Main Company' | 'L/Green'   |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '400,000'  | 'Opening entry 2*' | 'Store 02' | 'S/Yellow'  |
		| '400,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '36/Red'    |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '36/Red'    |
		| '200,000'  | 'Opening entry 2*' | 'Store 02' | '36/18SD'   |
		| '300,000'  | 'Opening entry 2*' | 'Store 01' | '36/18SD'   |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'L/Green'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | 'L/Green'   |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '400,000'  | 'Opening entry 2*' | 'Store 02' | 'S/Yellow'  |
		| '400,000'  | 'Opening entry 2*' | 'Store 01' | 'XS/Blue'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '38/Yellow' |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | '36/Red'    |
		| '100,000'  | 'Opening entry 2*' | 'Store 01' | '36/Red'    |
		| '200,000'  | 'Opening entry 2*' | 'Store 02' | '36/18SD'   |
		| '300,000'  | 'Opening entry 2*' | 'Store 01' | '36/18SD'   |
		| '500,000'  | 'Opening entry 2*' | 'Store 01' | 'L/Green'   |
		| '100,000'  | 'Opening entry 2*' | 'Store 02' | 'L/Green'   |
		And I close all client application windows

Scenario: _400003 opening entry advance balance
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Change the document number
		And I input "3" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "3" text in "Number" field
	* Filling in AdvanceFromCustomers
		And in the table "AdvanceFromCustomers" I click the button named "AdvanceFromCustomersAdd"
		And I click choice button of the attribute named "AdvanceFromCustomersPartner" in "AdvanceFromCustomers" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I click choice button of the attribute named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersAmount" in "AdvanceFromCustomers" table
		And I input "100,00" text in the field named "AdvanceFromCustomersAmount" of "AdvanceFromCustomers" table
		And I finish line editing in "AdvanceFromCustomers" table
	* Filling in AdvanceToSuppliers
		And I move to "To suppliers" tab
		And in the table "AdvanceToSuppliers" I click the button named "AdvanceToSuppliersAdd"
		And I click choice button of the attribute named "AdvanceToSuppliersPartner" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "AdvanceToSuppliers" table
		And I activate field named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I select current line in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersAmount" in "AdvanceToSuppliers" table
		And I input "100,00" text in the field named "AdvanceToSuppliersAmount" of "AdvanceToSuppliers" table
		And I finish line editing in "AdvanceToSuppliers" table
	* Post document
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Opening entry 3*'                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Document registrations records'       | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Accounts statement"'       | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | ''               | ''                       | ''                  | 'Dimensions'   | ''                 | ''                         | ''                     | ''         |
		| ''                                     | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'    | 'Company'      | 'Partner'          | 'Legal name'               | 'Basis document'       | 'Currency' |
		| ''                                     | 'Receipt'     | '*'      | ''                    | ''               | '100'                    | ''                  | 'Main Company' | 'Kalipso'          | 'Company Kalipso'          | ''                     | 'TRY'      |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | ''               | ''                       | ''                  | 'Main Company' | 'Ferron BP'        | 'Company Ferron BP'        | ''                     | 'TRY'      |
		| ''                                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | 'Dimensions'     | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | ''            | ''       | 'Amount'              | 'Company'        | 'Legal name'             | 'Currency'          | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Company Ferron BP'      | 'TRY'               | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Expense'     | '*'      | '100'                 | 'Main Company'   | 'Company Kalipso'        | 'TRY'               | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Advance from customers"'   | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | 'Dimensions'     | ''                       | ''                  | ''             | ''                 | ''                         | 'Attributes'           | ''         |
		| ''                                     | ''            | ''       | 'Amount'              | 'Company'        | 'Partner'                | 'Legal name'        | 'Currency'     | 'Receipt document' | 'Multi currency movement type'   | 'Deferred calculation' | ''         |
		| ''                                     | 'Receipt'     | '*'      | '17,12'               | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'   | 'USD'          | 'Opening entry 3*' | 'Reporting currency'       | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'   | 'TRY'          | 'Opening entry 3*' | 'en descriptions is empty' | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'   | 'TRY'          | 'Opening entry 3*' | 'Local currency'           | 'No'                   | ''         |
		| ''                                     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| 'Register  "Advance to suppliers"'     | ''            | ''       | ''                    | ''               | ''                       | ''                  | ''             | ''                 | ''                         | ''                     | ''         |
		| ''                                     | 'Record type' | 'Period' | 'Resources'           | 'Dimensions'     | ''                       | ''                  | ''             | ''                 | ''                         | 'Attributes'           | ''         |
		| ''                                     | ''            | ''       | 'Amount'              | 'Company'        | 'Partner'                | 'Legal name'        | 'Currency'     | 'Payment document' | 'Multi currency movement type'   | 'Deferred calculation' | ''         |
		| ''                                     | 'Receipt'     | '*'      | '17,12'               | 'Main Company'   | 'Ferron BP'              | 'Company Ferron BP' | 'USD'          | 'Opening entry 3*' | 'Reporting currency'       | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Ferron BP'              | 'Company Ferron BP' | 'TRY'          | 'Opening entry 3*' | 'en descriptions is empty' | 'No'                   | ''         |
		| ''                                     | 'Receipt'     | '*'      | '100'                 | 'Main Company'   | 'Ferron BP'              | 'Company Ferron BP' | 'TRY'          | 'Opening entry 3*' | 'Local currency'           | 'No'                   | ''         |
		And I close all client application windows


Scenario: _400004 opening entry AP balance by partner terms (vendors)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Change the document number
		And I input "4" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "4" text in "Number" field
	* Filling in Account payable
		* Filling in partner and Legal name
			And I move to "Account payable" tab
			And in the table "AccountPayableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check filling in legal name
				And "AccountPayableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Create test partner term with AP/AR posting detail - By partner terms (type Vendor)
			And I click choice button of "Partner term" attribute in "AccountPayableByAgreements" table
			And I click the button named "FormCreate"
			And I change "AP/AR posting detail" radio button value to "By partner terms"
			And I change "Type" radio button value to "Vendor"
			And I input "DFC Vendor by Partner terms" text in the field named "Description_en"
			And I input "01.12.2019" text in "Date" field
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Description' | 'Source'       | 'Type'      |
				| 'TRY'      | 'TRY'         | 'Forex Seling' | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Currency' | 'Description'       | 'Reference'         |
				| 'TRY'      | 'Vendor price, TRY' | 'Vendor price, TRY' |
			And I select current line in "List" table
			And I input "01.12.2019" text in "Start using" field
			And I click "Save and close" button
			And I go to line in "List" table
			| 'Description'              |
			| 'DFC Vendor by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountPayableByAgreements" table
			And I select current line in "AccountPayableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountPayableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountPayableByAgreements" table
			And I input "100,00" text in "Amount" field of "AccountPayableByAgreements" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check calculation Reporting currency
			And I go to line in "CurrenciesAccountPayableByAgreements" table
			| 'Movement type'      | 'Type'      |
			| 'Reporting currency' | 'Reporting' |
			And I select current line in "CurrenciesAccountPayableByAgreements" table
			And I input "5,8400" text in the field named "CurrenciesAccountPayableByAgreementsRatePresentation" of "CurrenciesAccountPayableByAgreements" table
			And I input "1" text in the field named "CurrenciesAccountPayableByAgreementsMultiplicity" of "CurrenciesAccountPayableByAgreements" table
			And I finish line editing in "CurrenciesAccountPayableByAgreements" table
			And "CurrenciesAccountPayableByDocuments" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate'   | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400' | '17,12'  | '1'            |
	* Post document
		And I click "Post and close" button
		And Delay 5
		* Check movements
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| 'Opening entry 4*'                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                         | ''           | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'             | 'Resources'           | ''               | ''                       | ''               | 'Dimensions'   | ''                         | ''           | ''                         | ''                     |
			| ''                                         | ''            | ''                   | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'                  | 'Legal name' | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Receipt'     | '*'                  | ''                    | '100'            | ''                       | ''               | 'Main Company' | 'DFC'                      | 'DFC'        | ''                         | 'TRY'                  |
			| ''                                         | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                         | ''           | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'     | 'Currency' | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company' | 'DFC'            | 'TRY'      | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| 'Register  "Partner AP transactions"'  | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                         | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                         | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'  | 'Legal name' | 'Partner term'                | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by Partner terms' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by Partner terms' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by Partner terms' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Vendor by Partner terms' | 'TRY'      | 'TRY'                      | 'No'                   |


	
Scenario: _400005 opening entry AR balance by partner terms (customers)
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Change the document number
		And I input "5" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5" text in "Number" field
	* Filling in Account receivable
		* Filling in partner and Legal name
			And I move to "Account receivable" tab
			And in the table "AccountReceivableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check filling in legal name
				And "AccountReceivableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Create test partner term with AP/AR posting detail - By partner terms (type Customer)
			And I click choice button of "Partner term" attribute in "AccountReceivableByAgreements" table
			And I click the button named "FormCreate"
			And I change "AP/AR posting detail" radio button value to "By partner terms"
			And I change "Type" radio button value to "Customer"
			And I input "DFC Customer by Partner terms" text in the field named "Description_en"
			And I input "01.12.2019" text in "Date" field
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Description' | 'Source'       | 'Type'      |
				| 'TRY'      | 'TRY'         | 'Forex Seling' | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I input "01.12.2019" text in "Start using" field
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description'              |
				| 'DFC Customer by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountReceivableByAgreements" table
			And I select current line in "AccountReceivableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountReceivableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountReceivableByAgreements" table
			And I input "100,00" text in "Amount" field of "AccountReceivableByAgreements" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check calculation Reporting currency
			And I go to line in "CurrenciesAccountReceivableByAgreements" table
				| 'Movement type'      | 'Type'      |
				| 'Reporting currency' | 'Reporting' |
			And I select current line in "CurrenciesAccountReceivableByAgreements" table
			And I input "5,8400" text in the field named "CurrenciesAccountReceivableByAgreementsRatePresentation" of "CurrenciesAccountReceivableByAgreements" table
			And I input "1" text in the field named "CurrenciesAccountReceivableByAgreementsMultiplicity" of "CurrenciesAccountReceivableByAgreements" table
			And I finish line editing in "CurrenciesAccountReceivableByAgreements" table
			And "CurrenciesAccountReceivableByDocuments" table contains lines
				| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate'   | 'Amount' | 'Multiplicity' |
				| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400' | '17,12'  | '1'            |
	* Post document
		And I click "Post and close" button
		And Delay 5
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
			| 'Opening entry 5*'                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                           | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'  | 'Legal name' | 'Partner term'                  | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by Partner terms' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by Partner terms' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by Partner terms' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | ''               | 'DFC'      | 'DFC'        | 'DFC Customer by Partner terms' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'           | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                           | ''           | ''                         | ''                     |
			| ''                                         | 'Record type' | 'Period'             | 'Resources'           | ''               | ''                       | ''               | 'Dimensions'   | ''                           | ''           | ''                         | ''                     |
			| ''                                         | ''            | ''                   | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'                    | 'Legal name' | 'Basis document'           | 'Currency'             |
			| ''                                         | 'Receipt'     | '*'                  | ''                    | ''               | ''                       | '100'            | 'Main Company' | 'DFC'                        | 'DFC'        | ''                         | 'TRY'                  |
			| ''                                         | ''            | ''                   | ''                    | ''               | ''                       | ''               | ''             | ''                           | ''           | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''         | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'     | 'Currency' | ''           | ''                           | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company' | 'DFC'            | 'TRY'      | ''           | ''                           | ''         | ''                         | ''                     |



Scenario: _400008 check the entry of the account balance, inventory balance, Ap/Ar balance, advance in one document
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Change the document number
		And I input "8" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "8" text in "Number" field
	* Filling in the tabular part Account Balance
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I click choice button of "Account" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Description  |
			| Cash desk №2 |
		And I select current line in "List" table
		And I activate field named "AccountBalanceCurrency" in "AccountBalance" table
		And I click choice button of "Currency" attribute in "AccountBalance" table
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "1 000,00" text in "Amount" field of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
		And I go to line in "AccountBalance" table
			| 'Account'      | 'Amount'   | 'Currency' |
			| 'Cash desk №2' | '1 000,00' | 'USD'      |
		And I go to line in "CurrenciesAccountBalance" table
			| 'From' | 'Movement type'  | 'To'  | 'Type'  |
			| 'USD'  | 'Local currency' | 'TRY' | 'Legal' |
		And I input "0,1756" text in the field named "CurrenciesAccountBalanceRatePresentation" of "CurrenciesAccountBalance" table
		And I input "1" text in the field named "CurrenciesAccountBalanceMultiplicity" of "CurrenciesAccountBalance" table
		And I activate "Amount" field in "CurrenciesAccountBalance" table
		And I finish line editing in "CurrenciesAccountBalance" table
	* Filling in the tabular part Inventory
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of "Item" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "Inventory" table
		And I go to line in "List" table
			| Item  | Item key |
			| Dress | XS/Blue  |
		And I select current line in "List" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| Description |
			| Store 01    |
		And I select current line in "List" table
		And I activate "Quantity" field in "Inventory" table
		And I input "10,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
	* Filling in Advance from Customers
		And in the table "AdvanceFromCustomers" I click the button named "AdvanceFromCustomersAdd"
		And I click choice button of the attribute named "AdvanceFromCustomersPartner" in "AdvanceFromCustomers" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I click choice button of the attribute named "AdvanceFromCustomersCurrency" in "AdvanceFromCustomers" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "AdvanceFromCustomersAmount" in "AdvanceFromCustomers" table
		And I input "525,00" text in the field named "AdvanceFromCustomersAmount" of "AdvanceFromCustomers" table
		And I finish line editing in "AdvanceFromCustomers" table
	* Filling in Advance to suppliers
		And I move to "To suppliers" tab
		And in the table "AdvanceToSuppliers" I click the button named "AdvanceToSuppliersAdd"
		And I click choice button of the attribute named "AdvanceToSuppliersPartner" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I finish line editing in "AdvanceToSuppliers" table
		And I activate field named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I select current line in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersLegalName" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I click choice button of the attribute named "AdvanceToSuppliersCurrency" in "AdvanceToSuppliers" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "AdvanceToSuppliersAmount" in "AdvanceToSuppliers" table
		And I input "811,00" text in the field named "AdvanceToSuppliersAmount" of "AdvanceToSuppliers" table
		And I finish line editing in "AdvanceToSuppliers" table
	* Filling in Account payable by agreements
		* Filling in partner and Legal name
			And I move to "Account payable" tab
			And in the table "AccountPayableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check filling in legal name
				And "AccountPayableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Select partner term
			And I click choice button of "Partner term" attribute in "AccountPayableByAgreements" table
			And I go to line in "List" table
			| 'Description'              |
			| 'DFC Vendor by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountPayableByAgreements" table
			And I select current line in "AccountPayableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountPayableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountPayableByAgreements" table
			And I input "111,00" text in "Amount" field of "AccountPayableByAgreements" table
			And I finish line editing in "AccountPayableByAgreements" table
		* Check calculation Reporting currency
			And I go to line in "CurrenciesAccountPayableByAgreements" table
			| 'Movement type'      | 'Type'      |
			| 'Reporting currency' | 'Reporting' |
			And I select current line in "CurrenciesAccountPayableByAgreements" table
			And I input "5,8400" text in the field named "CurrenciesAccountPayableByAgreementsRatePresentation" of "CurrenciesAccountPayableByAgreements" table
			And I input "1" text in the field named "CurrenciesAccountPayableByAgreementsMultiplicity" of "CurrenciesAccountPayableByAgreements" table
			And I finish line editing in "CurrenciesAccountPayableByAgreements" table
	* Filling in Account receivable by agreements
		* Filling in partner and Legal name
			And I move to "Account receivable" tab
			And in the table "AccountReceivableByAgreements" I click "Add" button
			And I click choice button of "Partner" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check filling in legal name
				And "AccountReceivableByAgreements" table contains lines
				| 'Partner' | 'Legal name' |
				| 'DFC'     | 'DFC'        |
		* Select partner term
			And I click choice button of "Partner term" attribute in "AccountReceivableByAgreements" table
			And I go to line in "List" table
				| 'Description'              |
				| 'DFC Customer by Partner terms' |
			And I click the button named "FormChoose"
		* Filling in amount and currency
			And I activate "Currency" field in "AccountReceivableByAgreements" table
			And I select current line in "AccountReceivableByAgreements" table
			And I click choice button of "Currency" attribute in "AccountReceivableByAgreements" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I activate "Amount" field in "AccountReceivableByAgreements" table
			And I input "151,00" text in "Amount" field of "AccountReceivableByAgreements" table
			And I finish line editing in "AccountReceivableByAgreements" table
		* Check calculation Reporting currency
			And I go to line in "CurrenciesAccountReceivableByAgreements" table
				| 'Movement type'      | 'Type'      |
				| 'Reporting currency' | 'Reporting' |
			And I select current line in "CurrenciesAccountReceivableByAgreements" table
			And I input "5,8400" text in the field named "CurrenciesAccountReceivableByAgreementsRatePresentation" of "CurrenciesAccountReceivableByAgreements" table
			And I input "1" text in the field named "CurrenciesAccountReceivableByAgreementsMultiplicity" of "CurrenciesAccountReceivableByAgreements" table
			And I finish line editing in "CurrenciesAccountReceivableByAgreements" table


Scenario: _400009 check the entry of the Ap/Ar balance by documents
	* Open document form opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Filling in company info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	* Change the document number
		And I input "9" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "9" text in "Number" field
	* Filling in AP by documents
		And I move to "Account payable" tab
		And I move to the tab named "GroupAccountPayableByDocuments"
		And in the table "AccountPayableByDocuments" I click the button named "AccountPayableByDocumentsAdd"
		And I click choice button of the attribute named "AccountPayableByDocumentsPartner" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I finish line editing in "AccountPayableByDocuments" table
		And I move to the next attribute
		And I activate field named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term vendor DFC'         |
		And I select current line in "List" table
		And I select current line in "AccountPayableByDocuments" table
		And I activate field named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "AccountPayableByDocumentsBasisDocument" in "AccountPayableByDocuments" table
		And I click choice button of the attribute named "AccountPayableByDocumentsBasisDocument" in "AccountPayableByDocuments" table
		And I go to line in "" table
			| ''                 |
			| 'Purchase invoice' |
		And I select current line in "" table
		Then the number of "List" table lines is "меньше или равно" 1
		And I go to line in "List" table
			| 'Legal name' | 'Number' |
			| 'DFC'        | '5 900'  |
		And I select current line in "List" table
		And I activate field named "AccountPayableByDocumentsAmount" in "AccountPayableByDocuments" table
		And I input "100,00" text in the field named "AccountPayableByDocumentsAmount" of "AccountPayableByDocuments" table
		And I finish line editing in "AccountPayableByDocuments" table
	* Filling in AR by documents
		And I move to "Account receivable" tab
		And I move to the tab named "GroupAccountReceivableByDocuments"
		And in the table "AccountReceivableByDocuments" I click the button named "AccountReceivableByDocumentsAdd"
		And I click choice button of the attribute named "AccountReceivableByDocumentsPartner" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I move to the next attribute
		And I activate field named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsAgreement" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner term DFC'         |
		And I select current line in "List" table
		And I activate field named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I click choice button of the attribute named "AccountReceivableByDocumentsBasisDocument" in "AccountReceivableByDocuments" table
		And I go to line in "" table
			| ''              |
			| 'Sales invoice' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number' |
			| '5 900'  |
		And I select current line in "List" table
		And I finish line editing in "AccountReceivableByDocuments" table
		And I activate field named "AccountReceivableByDocumentsAmount" in "AccountReceivableByDocuments" table
		And I select current line in "AccountReceivableByDocuments" table
		And I input "200,00" text in the field named "AccountReceivableByDocumentsAmount" of "AccountReceivableByDocuments" table
		And I finish line editing in "AccountReceivableByDocuments" table
	* Post and check movements
		And I click "Post" button
	# AccountByDocumentsMainTablePartnerOnChange
	# AccountPayableByDocumentsPartnerOnChange
	# AccountReceivableByDocumentsPartnerOnChange
	# MainTableLegalNameEditTextChange
	# AccountReceivableByDocumentsPartner termStartChoice
	# AccountPayableByDocumentsPartner termStartChoice
	# AccountReceivableByAgreementsPartner termEditTextChange
	# AccountReceivableByDocumentsPartner termEditTextChange
	# Partner termEditTextChange
