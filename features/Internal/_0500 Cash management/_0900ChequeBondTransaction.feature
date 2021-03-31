#language: en
@tree
@Positive
@CashManagement

Feature: cheque bond transaction

As an accountant
I want to create a Cheque bond transaction document
For settlements with partners

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _090000 preparation (Cheque bond transaction)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Partners objects
		When Create catalog Stores objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects (pcs)
		When Create catalog Agreements objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create information register PricesByItemKeys records
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Items objects
	* Tax settings
		When filling in Tax settings for company
	* Create Sales invoice for DFC
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from "Partner" drop-down list by "dfc" string
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
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice090004$$" variable
		And I delete "$$SalesInvoice090004$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice090004$$"
		And I save the window as "$$SalesInvoice090004$$"
		And I click the button named "FormPostAndClose"
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017001$$" |
			When create PurchaseOrder017001
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018001$$" |
			When create PurchaseInvoice018001 based on PurchaseOrder017001


Scenario: _090001 check for metadata ( catalog and document) availability
	Given I open "ChequeBondTransaction" document default form
	Given I open "ChequeBonds" catalog default form
	And I close all client application windows

Scenario: _090002 create statuses for Cheque bond
	* Opening of the catalog Objects status historyes and renaming of predefined elements for Cheque bond
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I expand current line in "List" table
		And I expand a line in "List" table
			| 'Predefined data name' |
			| 'ChequeBondTransaction'     |
		And I go to line in "List" table
			| 'Predefined data name' |
			| 'ChequeBondIncoming'     |
		And I activate "Predefined data name" field in "List" table
		And in the table "List" I click the button named "ListContextMenuChange"
		And I input "ChequeBondIncoming" text in the field named "Description_en"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Predefined data name' |
			| 'ChequeBondOutgoing'     |
		And I activate "Predefined data name" field in "List" table
		And in the table "List" I click the button named "ListContextMenuChange"
		And I input "ChequeBondOutgoing" text in the field named "Description_en"
		And I click "Save and close" button
	* Create statuses for Cheque bond incoming
		* Create status Taken from partner
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "01. TakenFromPartner" text in the field named "Description_en"
			And I set checkbox "Set by default"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Posting"
			And I change "Advanced" radio button value to "Posting"
			And I change "Partner account transactions" radio button value to "Posting"
			And I change "Reconciliation statement" radio button value to "Posting"
			And I change "Planning cash transactions" radio button value to "Posting"
			And I click "Save and close" button
		* Create status Payment received
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "03. PaymentReceived" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I change "Account balance" radio button value to "Posting"
			And I change "Planning cash transactions" radio button value to "Reversal"
			And I click "Save and close" button
		* Create status Protested
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "04. Protested" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Reversal"
			And I change "Advanced" radio button value to "Reversal"
			And I change "Partner account transactions" radio button value to "Reversal"
			And I change "Reconciliation statement" radio button value to "Reversal"
			And I change "Planning cash transactions" radio button value to "Reversal"
			And I click "Save and close" button
		* Create status Give to bank as assurance
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "02. GiveToBankAsAssurance" text in the field named "Description_en"
			And I click "Save and close" button
	* Create statuses for Cheque bond outgoing
		* Create status Given to partner
			And I go to line in "List" table
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			And I click the button named "FormCreate"
			And I input "01. GivenToPartner" text in the field named "Description_en"
			And I set checkbox "Set by default"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Posting"
			And I change "Advanced" radio button value to "Posting"
			And I change "Partner account transactions" radio button value to "Posting"
			And I change "Reconciliation statement" radio button value to "Posting"
			And I change "Planning cash transactions" radio button value to "Posting"
			And I click "Save and close" button
		* Create status Payed
			And I go to line in "List" table
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			And I click the button named "FormCreate"
			And I input "02. Payed" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I change "Account balance" radio button value to "Posting"
			And I change "Planning cash transactions" radio button value to "Reversal"
			And I click "Save and close" button
		* Create status Protested
			And I go to line in "List" table
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			And I click the button named "FormCreate"
			And I input "03. Protested" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Reversal"
			And I change "Advanced" radio button value to "Reversal"
			And I change "Partner account transactions" radio button value to "Reversal"
			And I change "Reconciliation statement" radio button value to "Reversal"
			And I change "Planning cash transactions" radio button value to "Reversal"
			And I click "Save and close" button
	* Setting the order of statuses for incoming cheques
		And I go to line in "List" table
			| 'Description'          |
			| '01. TakenFromPartner' |
		And I select current line in "List" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And Delay 2
		And I go to line in "List" table
			| 'Description'               |
			| '02. GiveToBankAsAssurance' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And I go to line in "List" table
			| 'Description'   |
			| '04. Protested' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And I click "Save and close" button
		And I wait "01. TakenFromPartner (Order status) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Description'               |
			| '02. GiveToBankAsAssurance' |
		And I select current line in "List" table
		And in the table "NextPossibleStatuses" I click "Add" button
		And I go to line in "List" table
			| 'Description'         |
			| '03. PaymentReceived' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click "Add" button
		And I go to line in "List" table
			| 'Description'   |
			| '04. Protested' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And I click "Save and close" button
	* Setting the order of statuses for outgoing cheques
		And I go to line in "List" table
			| 'Description'          |
			| '01. GivenToPartner' |
		And I select current line in "List" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And Delay 2
		And I go to line in "List" table
			| 'Description'               |
			| '02. Payed' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click "Add" button
		And I go to line in "List" table
			| 'Description'   |
			| '03. Protested' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And I click "Save and close" button


Scenario: _090003 create an incoming and outgoing check in the Cheque bonds catalog
	* Open catalog form
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And I click the button named "FormCreate"
	* Create an incoming check
		And I input "Partner cheque 1" text in "Cheque No" field
		And I input "AA" text in "Cheque serial No" field
		And I select "Partner cheque" exact value from "Type" drop-down list
		And I input end of the current month date in "Due date" field
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I input "2 000,00" text in "Amount" field
		And I click "Save and close" button
	* Create an outgoing check
		And I click the button named "FormCreate"
		And I input "Own cheque 1" text in "Cheque No" field
		And I input "BB" text in "Cheque serial No" field
		And I select "Own cheque" exact value from "Type" drop-down list
		And I input end of the current month date in "Due date" field
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I input "5 000,00" text in "Amount" field
		And I click "Save and close" button
	* Create cheque bond
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And "List" table contains lines
		| 'Cheque No'        | 'Cheque serial No' | 'Amount'   | 'Type'           | 'Currency' |
		| 'Own cheque 1'     | 'BB'               | '5 000,00' | 'Own cheque'     | 'TRY'      |
		| 'Partner cheque 1' | 'AA'               | '2 000,00' | 'Partner cheque' | 'TRY'      |
		And I close all client application windows
	* Check that fields are required to be filled in
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And I click the button named "FormCreate"
		And I click "Save" button
		Then I wait that in user messages the "\"Cheque No\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Type\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Due date\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Currency\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Amount\" is a required field" substring will appear in 5 seconds
		And I close all client application windows




Scenario: _090005 create a document Cheque bond transaction (Cheque bond from partner + Cheque bond written to another partner)
	* Open a document form Cheque bond transaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Filling in basic details
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Add Cheque bonds to the table part
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of "Cheque" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Amount'   | 'Cheque No'        |
			| '2 000,00' | 'Partner cheque 1' |
		And I select current line in "List" table
		And I activate "New status" field in "ChequeBonds" table
		And I select "01. TakenFromPartner" exact value from "New status" drop-down list in "ChequeBonds" table
		And I move to the next attribute
		And I click choice button of the attribute named "ChequeBondsPartner" in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC' |
		And I select current line in "List" table
		And I activate "Legal name" field in "ChequeBonds" table
		And I click choice button of "Legal name" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'      |
			| 'DFC' |
		And I select current line in "List" table
		And I activate "Partner term" field in "ChequeBonds" table
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Partner term DFC' |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of "Cheque" attribute in "ChequeBonds" table
		And I select current line in "List" table
		And I activate "New status" field in "ChequeBonds" table
		And I select "01. GivenToPartner" exact value from "New status" drop-down list in "ChequeBonds" table
		And I move to the next attribute
		And I activate field named "ChequeBondsPartner" in "ChequeBonds" table
		And I click choice button of the attribute named "ChequeBondsPartner" in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Big foot'    |
		And I select current line in "List" table
		And I activate "Legal name" field in "ChequeBonds" table
		And I click choice button of "Legal name" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Big foot'    |
		And I select current line in "List" table
		And I activate "Cash/Bank accounts" field in "ChequeBonds" table
		And I click choice button of "Cash/Bank accounts" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
		And I go to line in "ChequeBonds" table
			| 'Cheque'           | 'Partner' |
			| 'Partner cheque 1' | 'DFC'     |
		And I select current line in "ChequeBonds" table
		And I click choice button of "Cash/Bank accounts" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
	* Add bases dpcuments
		And in the table "PaymentList" I click "Fill" button
		And I select current line in "DocumentsList" table
		And I activate "Amount balance" field in "PickedDocuments" table
		And I select current line in "PickedDocuments" table
		And I input "1 800,00" text in "Amount balance" field of "PickedDocuments" table
		And I finish line editing in "PickedDocuments" table
		And in the table "DocumentsList" I click "Transfer to document" button
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberChequeBondTransaction090005$$" variable
		And I delete "$$ChequeBondTransaction090005$$" variable
		And I save the value of "Number" field as "$$NumberChequeBondTransaction090005$$"
		And I save the window as "$$ChequeBondTransaction090005$$"
	* Check movements
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$ChequeBondTransaction090005$$'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Document registrations records'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | 'Attributes'       | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | ''            | 'Status'               | 'Cheque'               | 'Author'           | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'         | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Partner cheque 1'                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Basis document'         | 'Partner'        | 'Legal name'          | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | 'Expense'     | '*'                    | '308,16'               | 'Main Company'     | '$$SalesInvoice090004$$'   | 'DFC'            | 'DFC'                 | 'Partner term DFC' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'                | 'Main Company'     | '$$SalesInvoice090004$$'   | 'DFC'            | 'DFC'                 | 'Partner term DFC' | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'                | 'Main Company'     | '$$SalesInvoice090004$$'   | 'DFC'            | 'DFC'                 | 'Partner term DFC' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'                | 'Main Company'     | '$$SalesInvoice090004$$'   | 'DFC'            | 'DFC'                 | 'Partner term DFC' | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'              | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'                  | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | '*'           | '342,4'               | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'                      | 'DFC'                          | 'Reporting currency'           | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'                      | 'DFC'                          | 'en description is empty'      | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'                      | 'DFC'                          | 'Local currency'               | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'                      | 'DFC'                          | 'TRY'                          | 'No'                   |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | ''                 | ''                       | ''               | 'Dimensions'          | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                      | 'Receipt'     | '*'                    | '-200'                 | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'                      | 'DFC'                          | ''                             | 'TRY'                  |
		| ''                                      | 'Receipt'     | '*'                    | ''                     | ''                 | '200'                    | ''               | 'Main Company'        | 'DFC'                      | 'DFC'                          | ''                             | 'TRY'                  |
		| ''                                      | 'Expense'     | '*'                    | ''                     | ''                 | ''                       | '1 800'          | 'Main Company'        | 'DFC'                      | 'DFC'                          | '$$SalesInvoice090004$$'         | 'TRY'                  |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                         | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,4'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'                      | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'                      | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'                      | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'                      | 'TRY'                          | 'No'                           | ''                     |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Advance from customers"'    | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                         | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document'         | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '34,24'                | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1'         | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '200'                  | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1'         | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '200'                  | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1'         | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Own cheque 1'                          | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'              | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'                  | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | '*'           | '856'               | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'                 | 'Big foot'                     | 'Reporting currency'           | 'No'                   |
		| ''                                      | '*'           | '5 000'                | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'                 | 'Big foot'                     | 'en description is empty'      | 'No'                   |
		| ''                                      | '*'           | '5 000'                | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'                 | 'Big foot'                     | 'Local currency'               | 'No'                   |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | ''                 | ''                       | ''               | 'Dimensions'          | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                      | 'Receipt'     | '*'                    | ''                     | ''                 | '-5 000'                 | ''               | 'Main Company'        | 'Big foot'                 | 'Big foot'                     | ''                             | 'TRY'                  |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'                | ''                 | ''                       | ''               | 'Main Company'        | 'Big foot'                 | 'Big foot'                     | ''                             | 'TRY'                  |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                         | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '856'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'                      | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'                      | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'                      | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                         | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                         | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document'         | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '856'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'             | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'             | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'             | 'Local currency'               | 'No'                           | ''                     |
		And I close all client application windows
	* Check the deleting of the added bases document
		* Open document form Cheque bond transaction
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			Then "Cheque bond transactions" window is opened
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberChequeBondTransaction090005$$'      |
			And I select current line in "List" table
			And I activate "Partner ar basis document" field in "PaymentList" table
			And I delete a line in "PaymentList" table
			And I click the button named "FormPost"
		* Check for movement changes
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$ChequeBondTransaction090005$$'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Document registrations records'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | 'Status'               | 'Cheque'              | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'        | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Partner cheque 1'                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '342,4'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'en description is empty' | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Local currency'           | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'TRY'                      | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | '-2 000'              | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                      | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,4'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,4'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '856'               | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'en description is empty' | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Local currency'           | 'No'                   |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'               | 'Basis document'           | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | ''                    | ''                 | '-5 000'                 | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | ''                 | ''                       | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                 | ''                         | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856'              | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856'              | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'           | 'No'                       | ''                     |
			And I close all client application windows
	* Clear movements Cheque bond transactions and check that there is no movements on the registers
		* Unpost Cheque bond transactions
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberChequeBondTransaction090005$$'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.ChequeBondBalance"
			And "List" table does not contain lines
			| 'Cheque'           |
			| 'Partner cheque 1' |
			| 'Own cheque 1'     |
			Given I open hyperlink "e1cib/list/InformationRegister.ChequeBondStatuses"
			And "List" table does not contain lines
			| 'Cheque'           | 'Recorder'                        | 'Status'               |
			| 'Partner cheque 1' | '$$ChequeBondTransaction090005$$' | '01. TakenFromPartner' |
			| 'Own cheque 1'     | '$$ChequeBondTransaction090005$$' | '01. GivenToPartner'   |
			Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
			And "List" table does not contain lines
			| 'Recorder'           |
			| 'Partner cheque 1' |
			| 'Own cheque 1'     |
			And I close all client application windows
	* Re-Posting the document and check movements
		* Post Cheque bond transactions
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberChequeBondTransaction090005$$'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$ChequeBondTransaction090005$$'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Document registrations records'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | 'Status'               | 'Cheque'               | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'         | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Partner cheque 1'                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'              | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                      | '*'           | '342,4'               | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'Reporting currency'           | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'en description is empty'      | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'Local currency'               | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'TRY'                          | 'No'                   |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | '-2 000'               | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                          | ''                             | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | ''                     | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                          | ''                             | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,4'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'               | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                          | 'No'                           | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,4'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'               | 'No'                           | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'              | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                      | '*'           | '856'               | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                     | 'Reporting currency'           | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                     | 'en description is empty'      | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                     | 'Local currency'               | 'No'                   |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | ''                     | ''                 | '-5 000'                 | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                     | ''                             | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | ''                 | ''                       | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                     | ''                             | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'               | 'No'                           | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'               | 'No'                           | ''                     |
			And I close all client application windows

Scenario: _090006 motion check when removing a cheque from document Cheque bond transaction
	* Select Cheque bond transaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberChequeBondTransaction090005$$'      |
		And I select current line in "List" table
	* Delete cheque bond
		And I go to line in "ChequeBonds" table
		| 'Amount'   | 'Cash/Bank accounts' | 'Cheque'       | 'Currency' | 'Legal name' | 'New status'         | 'Partner'  |
		| '5 000,00' | 'Bank account, TRY'  | 'Own cheque 1' | 'TRY'      | 'Big foot'   | '01. GivenToPartner' | 'Big foot' |
		And I activate "Status" field in "ChequeBonds" table
		And in the table "ChequeBonds" I click "Delete" button
		And I click the button named "FormPost"
	* Check movements
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document contains lines:
		| '$$ChequeBondTransaction090005$$'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| 'Document registrations records'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | ''            | 'Status'               | 'Cheque'               | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| 'Partner cheque 1'                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'              | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | '*'           | '342,4'               | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'Reporting currency'           | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'en description is empty'      | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'Local currency'               | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'TRY'                          | 'No'                   |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                      | 'Receipt'     | '*'                    | '-2 000'               | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                          | ''                             | 'TRY'                  |
		| ''                                      | 'Receipt'     | '*'                    | ''                     | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                          | ''                             | 'TRY'                  |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,4'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                          | 'No'                           | ''                     |
		| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| 'Register  "Advance from customers"'    | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,4'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'               | 'No'                           | ''                     |
	* Returning the second check bond recording and motion check
		And I close "Document registrations report" window
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of "Cheque" attribute in "ChequeBonds" table
		And I select current line in "List" table
		And I activate "New status" field in "ChequeBonds" table
		And I select "01. GivenToPartner" exact value from "New status" drop-down list in "ChequeBonds" table
		And I move to the next attribute
		And I activate field named "ChequeBondsPartner" in "ChequeBonds" table
		And I click choice button of the attribute named "ChequeBondsPartner" in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Big foot'    |
		And I select current line in "List" table
		And I activate "Legal name" field in "ChequeBonds" table
		And I click choice button of "Legal name" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Big foot'    |
		And I select current line in "List" table
		And I activate "Cash/Bank accounts" field in "ChequeBonds" table
		And I click choice button of "Cash/Bank accounts" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		And I finish line editing in "ChequeBonds" table
		And I click the button named "FormPost"
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document contains lines:
			| '$$ChequeBondTransaction090005$$'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Document registrations records'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | 'Status'               | 'Cheque'               | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'         | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Partner cheque 1'                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'              | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                      | '*'           | '342,4'               | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'Reporting currency'           | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'en description is empty'      | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'Local currency'               | 'No'                   |
			| ''                                      | '*'           | '2 000'                | 'Main Company'         | 'Partner cheque 1' | 'Bank account, TRY'      | 'TRY'            | 'Incoming'            | 'DFC'              | 'DFC'                          | 'TRY'                          | 'No'                   |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | '-2 000'               | ''                 | ''                       | ''               | 'Main Company'        | 'DFC'              | 'DFC'                          | ''                             | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | ''                     | ''                 | '2 000'                  | ''               | 'Main Company'        | 'DFC'              | 'DFC'                          | ''                             | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,4'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'               | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                          | 'No'                           | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,4'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'                | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'               | 'No'                           | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'           | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'              | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                      | '*'           | '856'               | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                     | 'Reporting currency'           | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                     | 'en description is empty'      | 'No'                   |
			| ''                                      | '*'           | '5 000'                | 'Main Company'         | 'Own cheque 1'     | 'Bank account, TRY'      | 'TRY'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                     | 'Local currency'               | 'No'                   |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | ''                 | ''                       | ''               | 'Dimensions'          | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | ''            | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers' | 'Transaction AR' | 'Company'             | 'Partner'          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
			| ''                                      | 'Receipt'     | '*'                    | ''                     | ''                 | '-5 000'                 | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                     | ''                             | 'TRY'                  |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | ''                 | ''                       | ''               | 'Main Company'        | 'Big foot'         | 'Big foot'                     | ''                             | 'TRY'                  |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Cheque'                 | 'Partner'        | 'Legal name'          | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'               | 'No'                           | ''                     |
			| ''                                      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                     | ''                 | ''                       | ''               | ''                    | ''                 | ''                             | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'            | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                             | 'Attributes'                   | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'               | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'           | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en description is empty'      | 'No'                           | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'                | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'               | 'No'                           | ''                     |
		And I close all client application windows






Scenario: _2020001 test data creation
	* Create a check and marking it for deletion
		* Open catalog form
			Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
			And I click the button named "FormCreate"
		* Create an incoming check
			And I input "Partner cheque 101" text in "Cheque No" field
			And I input "AN" text in "Cheque serial No" field
			And I select "Partner cheque" exact value from "Type" drop-down list
			And I input end of the current month date in "Due date" field
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I input "10 000,00" text in "Amount" field
			And I click "Save and close" button
		* Mark the created check for deletion
			Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
			And I go to line in "List" table
			| 'Amount'    | 'Cheque No'          |
			| '10 000,00' | 'Partner cheque 101' |
			And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I go to line in "List" table
			| 'Amount'    | 'Cheque No'          |
			| '10 000,00' | 'Partner cheque 101' |
	* Create one more partner cheque bond
		* Open catalog form
			Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
			And I click the button named "FormCreate"
		* Create an incoming check
			And I input "Partner cheque 102" text in "Cheque No" field
			And I input "AN" text in "Cheque serial No" field
			And I select "Partner cheque" exact value from "Type" drop-down list
			And I input end of the current month date in "Due date" field
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I input "15 000,00" text in "Amount" field
			And I click "Save and close" button
	* Create a cheque bond transaction for change the status of Partner cheque 1
		* Open document form ChequeBondTransaction
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			And I click the button named "FormCreate"
		* Filling in basic details
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Adding cheques to the table part
			And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
			And I click choice button of "Cheque" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Amount'   | 'Cheque No'        |
				| '2 000,00' | 'Partner cheque 1' |
			And I select current line in "List" table
			And I activate "New status" field in "ChequeBonds" table
			And I select "02. GiveToBankAsAssurance" exact value from "New status" drop-down list in "ChequeBonds" table
			And I move to the next attribute
			And I click choice button of the attribute named "ChequeBondsPartner" in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC' |
			And I select current line in "List" table
			And I activate "Legal name" field in "ChequeBonds" table
			And I click choice button of "Legal name" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description'      |
				| 'DFC' |
			And I select current line in "List" table
			And I activate "Partner term" field in "ChequeBonds" table
			And I click choice button of "Partner term" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term DFC' |
			And I select current line in "List" table
			And I finish line editing in "ChequeBonds" table
		* Change the document number
			And I click the button named "FormPost"
			And I delete "$$NumberChequeBondTransaction2020001$$" variable
			And I delete "$$ChequeBondTransaction2020001$$" variable
			And I save the value of "Number" field as "$$NumberChequeBondTransaction2020001$$"
			And I save the window as "$$ChequeBondTransaction2020001$$"
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
			| 'Number' |
			| '$$NumberChequeBondTransaction2020001$$'      |
	* Create an outgoing check for vendor
		* Open catalog form
			Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
			And I click the button named "FormCreate"
		* Create an outgoing check
			And I input "Own cheque 2" text in "Cheque No" field
			And I input "AL" text in "Cheque serial No" field
			And I select "Own cheque" exact value from "Type" drop-down list
			And I input end of the current month date in "Due date" field
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| 'Code' |
				| 'TRY'  |
			And I select current line in "List" table
			And I input "10 000,00" text in "Amount" field
			And I click "Save and close" button

Scenario: _2020001 check selection for own companies in the document Cheque bond transaction
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Filter check
		When check the filter by my own company in Cheque bond transaction
		And I close all client application windows

Scenario: _2020002 check automatic filling Legal name (the partner has only one Legal name) in the document Cheque bond transaction
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Add partner with one Legal name
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of the attribute named "ChequeBondsPartner" in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
	* Check filling in legal name
		And "ChequeBonds" table contains lines
		| 'Legal name' | 'Partner' |
		| 'DFC'        | 'DFC'     |
		| 'DFC'        | 'DFC'     |
		And I close all client application windows

Scenario: _2020003 check automatic filling Partner (the partner has only one Legal name) in the document Cheque bond transaction
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Add legal name with one partner
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of "Legal name" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
	* Check filling in legal name
		And "ChequeBonds" table contains lines
		| 'Legal name' | 'Partner' |
		| 'DFC'        | 'DFC'     |
		And I close all client application windows

Scenario: _2020004 check the automatic filling in of Partner term (partner has only one Partner term) in Cheque bond transaction document
	* Open document form ChequeBondTransaction
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			And I click the button named "FormCreate"
	* Add a partner with one Partner term
			And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
			And I click choice button of "Partner" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description' |
				| 'NDB'         |
			And I select current line in "List" table
	* Check filling in Partner term
			And "ChequeBonds" table contains lines
				| 'Partner' | 'Partner term'     |
				| 'NDB'     | 'Partner term NDB' |
			And I close all client application windows

Scenario: _2020005 check the selection of only partner partner terms available in the Cheque bond transaction
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Add a partner with one partner term
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
	* Check availability to select only one partner term
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And "List" table became equal
			| 'Description'   |
			| 'Partner term NDB' |
		And I close all client application windows

Scenario: _2020006 check to clear the agreement field after partner re-selection (new partner does not have the selected agreement)
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Add a partner with one partner term
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'NDB'         |
		And I select current line in "List" table
	* Filling in Partner term
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Partner term NDB' |
		And I select current line in "List" table
	* Re-selection partner
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Big foot'         |
		And I select current line in "List" table
	* Check field cleaning Partner term
		And "ChequeBonds" table contains lines
			| 'Partner'  | 'Partner term' |
			| 'Big foot' | ''          |
		And I close all client application windows
		
Scenario: _2020007 check filter by cheque in the form of Cheque bonds selection depending on the selected currency (re-selection) and separation of cheques by Partners/Own
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Select currency USD and check that no cheques are in the selection list with TRY currency
		* Select currency
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And in the table "ChequeBonds" I click "Fill cheques" button
		* Check that there are no checks in the selection form
			And I change "ChequeBondType" radio button value to "Partner"
			Then the number of "List" table lines is "равно" 0
			And I change "ChequeBondType" radio button value to "Own"
			Then the number of "List" table lines is "равно" 0
			And I close "Cheque bonds" window
	* Check that cheques with TRY currency are displayed in the selection form after re-selection and divide the cheques into Partners/Own
		* Select currency
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
		* Check that receipts are displayed in the selection form
			And in the table "ChequeBonds" I click "Fill cheques" button
			And I change "ChequeBondType" radio button value to "Partner"
			And "List" table contains lines
				| 'Cheque No'        | 'Currency' |
				| 'Partner cheque 1' | 'TRY'      |
			And "List" table does not contain lines
				| 'Cheque No'    | 'Currency' |
				| 'Own cheque 1' | 'TRY'      |
			And I change "ChequeBondType" radio button value to "Own"
			And "List" table contains lines
				| 'Cheque No'    | 'Currency' |
				| 'Own cheque 1' | 'TRY'      |
			And "List" table does not contain lines
				| 'Cheque No'        | 'Currency' |
				| 'Partner cheque 1' | 'TRY'      |
			And I close "Cheque bonds" window
	And I close all client application windows

Scenario: _2020008 not displaying checks marked for deletion in the selection form Cheque bonds
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Select currency TRY
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And in the table "ChequeBonds" I click "Fill cheques" button
	* Check that a cheque marked for deletion is not displayed in the selection list
		And I change "ChequeBondType" radio button value to "Partner"
		And "List" table does not contain lines
			| 'Cheque No'          | 'Currency' |
			| 'Partner cheque 101' | 'TRY'      |
	And I close all client application windows

Scenario: _2020009 check the selection of status checks in the Cheque bonds selection form
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Select currency TRY
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
		And in the table "ChequeBonds" I click "Fill cheques" button
	* Status check
		Then "Cheque bonds" window is opened
		And I change "ChequeBondType" radio button value to "Own"
		And I set checkbox "StatusCheck"
		And I click Choice button of the field named "StatusSelection"
		And I go to line in "List" table
			| 'Description' |
			| '02. Payed'   |
		And I select current line in "List" table
		And "List" table does not contain lines
			| 'Cheque No'    | 'Currency' |
			| 'Own cheque 1' | 'TRY'      |
		And I change "ChequeBondType" radio button value to "Partner"
		And I set checkbox "StatusCheck"
		And I click Choice button of the field named "StatusSelection"
		And I go to line in "List" table
			| 'Description' |
			| '02. GiveToBankAsAssurance'   |
		And I select current line in "List" table
		And "List" table contains lines
		| 'Cheque No'        | 'Status'                    | 'Type'           |
		| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | 'Partner cheque' |
		And "List" table does not contain lines
		| 'Cheque No'          | 'Status'                    | 'Type'           |
		| 'Partner cheque 102' | ''                          | 'Partner cheque' |
	* Check the status reset of the selection filter
		And I remove checkbox "StatusCheck"
		And "List" table contains lines
		| 'Cheque No'          | 'Status'                    |
		| 'Partner cheque 1'   | '02. GiveToBankAsAssurance' |
		| 'Partner cheque 102' | ''                          |
	And I close all client application windows
		
Scenario: _2020010 check to delete selected cheques in the Cheque bonds selection form
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Select currency TRY
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
	* Open the check selection form and checking the deletion of added checks
		And in the table "ChequeBonds" I click "Fill cheques" button
		And I change "ChequeBondType" radio button value to "Partner"
		And I go to line in "List" table
			| 'Amount'    | 'Cheque No'          |
			| '15 000,00' | 'Partner cheque 102' |
		And I select current line in "List" table
		And I go to line in "List" table
			| 'Amount'   | 'Cheque No'        |
			| '2 000,00' | 'Partner cheque 1' |
		And I select current line in "List" table
		And "PickedCheckBonds" table contains lines
			| 'Cheque No'          | 'Cheque serial No' | 'Amount'    | 'Type'           | 'Currency' |
			| 'Partner cheque 102' | 'AN'               | '15 000,00' | 'Partner cheque' | 'TRY'      |
			| 'Partner cheque 1'   | 'AA'               | '2 000,00'  | 'Partner cheque' | 'TRY'      |
		And I go to line in "PickedCheckBonds" table
			| 'Amount'   | 'Cheque No'        | 'Cheque serial No' | 'Currency' | 'Type'           |
			| '2 000,00' | 'Partner cheque 1' | 'AA'               | 'TRY'      | 'Partner cheque' |
		And I activate field named "PickedCheckBondsChequeBondType" in "PickedCheckBonds" table
		And I delete a line in "PickedCheckBonds" table
		And "PickedCheckBonds" table does not contain lines
			| 'Cheque No'          | 'Cheque serial No' | 'Amount'    | 'Type'           | 'Currency' |
			| 'Partner cheque 1'   | 'AA'               | '2 000,00'  | 'Partner cheque' | 'TRY'      |
	And I close all client application windows

Scenario: _2020011 check filter under valid agreements depending on the date of the Cheque bond transaction
	* Create a cheque bond transaction to change the status of Partner cheque 1
		* Open document form ChequeBondTransaction
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			And I click the button named "FormCreate"
		* Filling in basic details
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'  |
				| 'TRY'  | 'Turkish lira' |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Adding cheques to the table part
			And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
			And I click choice button of "Cheque" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Amount'   | 'Cheque No'        |
				| '2 000,00' | 'Partner cheque 1' |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of the attribute named "ChequeBondsPartner" in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC' |
			And I select current line in "List" table
			And I activate "Legal name" field in "ChequeBonds" table
			And I click choice button of "Legal name" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description'      |
				| 'DFC' |
			And I select current line in "List" table
			And I activate "Partner term" field in "ChequeBonds" table
			And I click choice button of "Partner term" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term DFC' |
			And I select current line in "List" table
			And I finish line editing in "ChequeBonds" table
		* Check available agreements at date re-selection
			And I move to "Other" tab
			And I input "17.01.2016  0:00:00" text in "Date" field
			And I move to "Cheques" tab
			And I activate "Legal name" field in "ChequeBonds" table
			And I activate "Partner term" field in "ChequeBonds" table
			And I select current line in "ChequeBonds" table
			And I click choice button of "Partner term" attribute in "ChequeBonds" table
			Then the number of "List" table lines is "равно" 0
		And I close all client application windows

Scenario: _2020012 check input of cheque statuses by line
	And I close all client application windows
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Data filling and cheque selection
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I click choice button of "Cheque" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Amount'   | 'Cheque No'        | 'Cheque serial No' |
			| '2 000,00' | 'Partner cheque 1' | 'AA'               |
		And I select current line in "List" table
	* Check input of cheque statuses by line
		And I activate "New status" field in "ChequeBonds" table
		And I click choice button of "New status" attribute in "ChequeBonds" table
		And I select "03" from "New status" drop-down list by string in "ChequeBonds" table
		And "ChequeBonds" table contains lines
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		And I select "04" from "New status" drop-down list by string in "ChequeBonds" table
		And "ChequeBonds" table contains lines
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '04. Protested' |
		And I select "re" from "New status" drop-down list by string in "ChequeBonds" table
		And "ChequeBonds" table contains lines
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		And I select "03" from "New status" drop-down list by string in "ChequeBonds" table
		And "ChequeBonds" table contains lines
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		And I finish line editing in "ChequeBonds" table
		And I select "03" from "New status" drop-down list by string in "ChequeBonds" table
		And "ChequeBonds" table contains lines
			| 'Cheque'           | 'Status'                    | 'New status'          |
			| 'Partner cheque 1' | '02. GiveToBankAsAssurance' | '03. PaymentReceived' |
		And I finish line editing in "ChequeBonds" table
		And I close all client application windows

Scenario: _2020013 check the selection of documents for distribution of the amount of the cheque issued to the vendor
	* Check for Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
		| 'Number'          |
		| '$$NumberPurchaseInvoice018001$$'  |
		And I close all client application windows
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Select currency TRY
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
	* Select Company
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Add cheque
		And in the table "ChequeBonds" I click "Fill cheques" button
		And I go to line in "List" table
			| 'Cheque No'    | 
			| 'Own cheque 2' |
		And I select current line in "List" table
		And I click "Transfer to document" button
		And I go to line in "ChequeBonds" table
			| 'Amount'    | 'Cheque'       | 'Currency' | 'New status'         |
			| '10 000,00' | 'Own cheque 2' | 'TRY'      | '01. GivenToPartner' |
		And I activate "Partner" field in "ChequeBonds" table
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I activate "Partner term" field in "ChequeBonds" table
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I activate "Legal name" field in "ChequeBonds" table
		And I click choice button of "Legal name" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
	* Filling in the distribution document
		And in the table "PaymentList" I click "Fill" button
		Then 'Select base documents in the "Cheque bond transaction" document.' window is opened
		And I go to line in "DocumentsList" table
			| 'Basis document' | 'Currency' | 'Amount' |
			| '$$PurchaseInvoice018001$$'| 'TRY'      | '137 000'         |
		And I select current line in "DocumentsList" table
		And I input "9 000,00" text in "Amount balance" field of "PickedDocuments" table
		And I finish line editing in "PickedDocuments" table
		And in the table "DocumentsList" I click "Transfer to document" button
	* Filling in Cash/Bank accounts
		And I click choice button of "Cash/Bank accounts" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
	* Post a ChequeBondTransaction and checking movements
		And I click the button named "FormPost"
		And I delete "$$NumberChequeBondTransaction2020013$$" variable
		And I delete "$$ChequeBondTransaction2020013$$" variable
		And I save the value of "Number" field as "$$NumberChequeBondTransaction2020013$$"
		And I save the window as "$$ChequeBondTransaction2020013$$"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$ChequeBondTransaction2020013$$'      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Document registrations records'        | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources'          | 'Dimensions'           | 'Attributes'     | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | 'Status'             | 'Cheque'               | 'Author'         | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | '*'           | '01. GivenToPartner' | 'Own cheque 2'         | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Own cheque 2'                          | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources'          | 'Dimensions'           | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | 'Amount'             | 'Company'              | 'Basis document' | 'Account'                   | 'Currency'          | 'Cash flow direction' | 'Partner'            | 'Legal name'                   | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | '*'           | '1 712'           | 'Main Company'         | 'Own cheque 2'   | 'Bank account, TRY'         | 'USD'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'            | 'Reporting currency'           | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company'         | 'Own cheque 2'   | 'Bank account, TRY'         | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'            | 'en description is empty'      | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company'         | 'Own cheque 2'   | 'Bank account, TRY'         | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'            | 'Local currency'               | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company'         | 'Own cheque 2'   | 'Bank account, TRY'         | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'            | 'TRY'                          | 'No'                   |
		| ''                                      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'            | ''               | ''                          | ''                  | 'Dimensions'          | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''                   | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'    | 'Transaction AR'    | 'Company'             | 'Partner'            | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                      | 'Receipt'     | '*'                  | ''                     | ''               | '-1 000'                    | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'            | ''                             | 'TRY'                  |
		| ''                                      | 'Receipt'     | '*'                  | '1 000'                | ''               | ''                          | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'            | ''                             | 'TRY'                  |
		| ''                                      | 'Expense'     | '*'                  | ''                     | '9 000'          | ''                          | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'            | '$$PurchaseInvoice018001$$'    | 'TRY'                  |
		| ''                                      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'            | 'Dimensions'     | ''                          | ''                  | ''                    | ''                   | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'               | 'Company'        | 'Cheque'                    | 'Partner'           | 'Legal name'          | 'Currency'           | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 712'             | 'Main Company'   | 'Own cheque 2'              | 'Ferron BP'         | 'Company Ferron BP'   | 'USD'                | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'               | 'Main Company'   | 'Own cheque 2'              | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'               | 'Main Company'   | 'Own cheque 2'              | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'               | 'Main Company'   | 'Own cheque 2'              | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'TRY'                          | 'No'                           | ''                     |
		| ''                                      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Advance to suppliers"'      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'            | 'Dimensions'     | ''                          | ''                  | ''                    | ''                   | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'               | 'Company'        | 'Partner'                   | 'Legal name'        | 'Currency'            | 'Payment document'   | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '171,2'               | 'Main Company'   | 'Ferron BP'                 | 'Company Ferron BP' | 'USD'                 | 'Own cheque 2'       | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 000'                | 'Main Company'   | 'Ferron BP'                 | 'Company Ferron BP' | 'TRY'                 | 'Own cheque 2'       | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 000'                | 'Main Company'   | 'Ferron BP'                 | 'Company Ferron BP' | 'TRY'                 | 'Own cheque 2'       | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Partner AP transactions"'   | ''            | ''                   | ''                     | ''               | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'            | 'Dimensions'     | ''                          | ''                  | ''                    | ''                   | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | ''                   | 'Amount'               | 'Company'        | 'Basis document'            | 'Partner'           | 'Legal name'          | 'Partner term'       | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | 'Expense'     | '*'                  | '1 540,8'              | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                          | 'TRY'                          | 'No'                   |
		And I close all client application windows

Scenario: _2020014 check clearing of cheques from a Cheque bond transaction when currency changes
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Select currency TRY
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
	* Add cheque
		And in the table "ChequeBonds" I click "Fill cheques" button
		And I go to line in "List" table
			| 'Cheque No'    | 
			| 'Own cheque 2' |
		And I select current line in "List" table
		And I click "Transfer to document" button
		And I go to line in "ChequeBonds" table
			| 'Amount'    | 'Cheque'       | 'Currency' |
			| '10 000,00' | 'Own cheque 2' | 'TRY'      |
		And I activate "Partner" field in "ChequeBonds" table
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I activate "Partner term" field in "ChequeBonds" table
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I activate "Legal name" field in "ChequeBonds" table
		And I click choice button of "Legal name" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
	* Currency re-selection
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'USD'  |
		And I select current line in "List" table
	* Check that the currency is not refilled by clicking No in the warning window
		Then "1C:Enterprise" window is opened
		And I click "No" button
		Then the form attribute named "Currency" became equal to "TRY"
	* Check the removal of the check from the tabular part in case of currency re-selection
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'USD'  |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then the number of "ChequeBonds" table lines is "равно" 0
		And I close all client application windows

Scenario: _2020015 cancel a Cheque bond transaction and check that cancelled Cheque bond items movements
	* Select Cheque bond transaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberChequeBondTransaction090005$$'  |
	* Clear movements Cheque bond transaction and  check movement reversal
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document does not contain values
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Advance from customers" |
		And I close current window
	* Re-post cheque bond transaction again and checking the movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberChequeBondTransaction090005$$'  |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document contains values
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Advance from customers" |
		And I close current window
	* Marked for deletion Cheque bond transaction and check movement reversal
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberChequeBondTransaction090005$$'  |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document does not contain values
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Advance from customers" |
		And I close current window
	* Re-post cheque bond transaction (with deletion mark) again and checking the movements
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "Cheque bond transactions" window is opened
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document contains values
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Advance from customers" |
		And I close all client application windows

Scenario: _2020016 check cleaning of cheques from a Cheque bond transaction document in the case of a company change
	* Open document form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Select company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'  |
		And I select current line in "List" table
	* Select currency TRY
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' |
			| 'TRY'  |
		And I select current line in "List" table
	* Add cheque
		And in the table "ChequeBonds" I click "Fill cheques" button
		And I go to line in "List" table
			| 'Cheque No'    | 
			| 'Own cheque 2' |
		And I select current line in "List" table
		And I click "Transfer to document" button
		And I go to line in "ChequeBonds" table
			| 'Amount'    | 'Cheque'       | 'Currency' |
			| '10 000,00' | 'Own cheque 2' | 'TRY'      |
		And I activate "Partner" field in "ChequeBonds" table
		And I click choice button of "Partner" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I activate "Partner term" field in "ChequeBonds" table
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I activate "Legal name" field in "ChequeBonds" table
		And I click choice button of "Legal name" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
	* Re-select company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company'  |
		And I select current line in "List" table
	* Check the company is not refilled by clicking No in the warning window
		Then "1C:Enterprise" window is opened
		And I click "No" button
		Then the form attribute named "Company" became equal to "Main Company"
	* Check to remove the cheque from the tabular part in case the company is re-selected
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description' |
			| 'Second Company'  |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then the number of "ChequeBonds" table lines is "равно" 0
		And I close all client application windows
			






			












	



