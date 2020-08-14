#language: en
@tree
@Positive
Feature: cheque bond transaction

As an accountant
I want to create a Cheque bond transaction document
For settlements with partners

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _090001 check for metadata ( catalog and document) availability
	Given I open "ChequeBondTransaction" document default form
	Given I open "ChequeBonds" catalog default form
	And I close all client application windows

Scenario: _090002 create statuses for Cheque bond
	* Opening of the catalog Objects status historyes and renaming of predefined elements for Cheque bond
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I expand current line in "List" table
		And I expand a line in "List" table
			| 'Predefined data item name' |
			| 'ChequeBondTransaction'     |
		And I go to line in "List" table
			| 'Predefined data item name' |
			| 'ChequeBondIncoming'     |
		And I activate "Predefined data item name" field in "List" table
		And in the table "List" I click the button named "ListContextMenuChange"
		And I input "ChequeBondIncoming" text in the field named "Description_en"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Predefined data item name' |
			| 'ChequeBondOutgoing'     |
		And I activate "Predefined data item name" field in "List" table
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


Scenario: _090004 preparation
	* Create a partner and legal name from whom the cheque bond was received and to whom the heque bond was issued
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "DFC" text in the field named "Description_en"
		And I change checkbox "Vendor"
		And I change checkbox "Customer"
		And I change checkbox "Shipment confirmations before sales invoice"
		And I change checkbox "Goods receipt before purchase invoice"
		And I click "Save" button
		And In this window I click command interface button "Partner segments content"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		
		And I go to line in "List" table
			| 'Description' |
			| 'Retail'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Partner segments content (create) *" window closing in 20 seconds
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "DFC" text in the field named "Description_en"
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		Then "Company (create) *" window is opened
		And I click "Save and close" button
		And I wait "Company (create) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I wait "DFC (Partner)" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I input "Big foot" text in the field named "Description_en"
		And I change checkbox "Customer"
		And I change checkbox "Vendor"
		And I change checkbox "Shipment confirmations before sales invoice"
		And I change checkbox "Goods receipt before purchase invoice"
		And I click "Save" button
		And In this window I click command interface button "Partner segments content"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		
		And I go to line in "List" table
			| 'Description' |
			| 'Retail'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Partner segments content (create) *" window closing in 20 seconds
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "Big foot" text in the field named "Description_en"
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		Then "Company (create) *" window is opened
		And I click "Save and close" button
		And I wait "Company (create) *" window closing in 20 seconds
		Then "Big foot (Partner)" window is opened
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I wait "Big foot (Partner)" window closing in 20 seconds
	* Create test Sales invoice for DFC
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from "Partner" drop-down list by "dfc" string
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
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
		And I expand "Currency" group
		And I move to the tab named "GroupCurrency"
		And I expand "More" group
		And I input "3 000" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "3 000" text in "Number" field
		And I click "Post and close" button


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
			| 'Basic Partner terms, TRY' |
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
	* Change the document number
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	* Post document
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'       | 'Attributes'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | 'Status'               | 'Cheque'           | 'Author'           | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1' | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. GivenToPartner'   | 'Own cheque 1'     | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Partner cheque 1'                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Basis document'       | 'Partner'    | 'Legal name'          | 'Partner term'             | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Expense'     | '*'                    | '308,22'           | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Partner terms, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'            | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Partner terms, TRY' | 'TRY'                      | 'en description is empty' | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'            | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Partner terms, TRY' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | 'Expense'     | '*'                    | '1 800'            | 'Main Company'     | 'Sales invoice 3 000*' | 'DFC'        | 'DFC'                 | 'Basic Partner terms, TRY' | 'TRY'                      | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'       | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'          | 'Basis document'   | 'Account'              | 'Currency'   | 'Cash flow direction' | 'Partner'               | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '342,47'               | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'USD'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'TRY'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'en description is empty' | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'TRY'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '2 000'                | 'Main Company'     | 'Partner cheque 1' | 'Bank account, TRY'    | 'TRY'        | 'Incoming'            | 'DFC'                   | 'DFC'                      | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                      | ''                    | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                                    | 'Record type'         | 'Period'               | 'Resources'           | ''                 | ''                                              | ''               | 'Dimensions'          | ''                      | ''                         | ''                         | ''                     |
		| ''                                                    | ''                    | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers'                        | 'Transaction AR' | 'Company'             | 'Partner'               | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                                    | 'Receipt'             | '*'                    | '-200'                | ''                 | ''                                              | ''               | 'Main Company'     | 'DFC'                   | 'DFC'                      | ''                         | 'TRY'                  |
		| ''                                                    | 'Receipt'             | '*'                    | ''                    | ''                 | '200'                                           | ''               | 'Main Company'     | 'DFC'                   | 'DFC'                      | ''                         | 'TRY'                  |
		| ''                                                    | 'Expense'             | '*'                    | ''                    | ''                 | ''                                              | '1 800'          | 'Main Company'     | 'DFC'                   | 'DFC'                      | 'Sales invoice 3 000*'     | 'TRY'                  |
		| ''                                                    | ''                    | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Cheque'               | 'Partner'    | 'Legal name'          | 'Currency'              | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,47'           | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'USD'                   | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'            | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'TRY'                   | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'            | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'TRY'                   | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'            | 'Main Company'     | 'Partner cheque 1'     | 'DFC'        | 'DFC'                 | 'TRY'                   | 'TRY'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Legal name'           | 'Currency'   | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'                    | '2 000'            | 'Main Company'     | 'DFC'                  | 'TRY'        | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Advance from customers"'    | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Partner'              | 'Legal name' | 'Currency'            | 'Receipt document'      | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '34,25'            | 'Main Company'     | 'DFC'                  | 'DFC'        | 'USD'                 | 'Partner cheque 1'      | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '200'              | 'Main Company'     | 'DFC'                  | 'DFC'        | 'TRY'                 | 'Partner cheque 1'      | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '200'              | 'Main Company'     | 'DFC'                  | 'DFC'        | 'TRY'                 | 'Partner cheque 1'      | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Own cheque 1'                          | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'       | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'          | 'Basis document'   | 'Account'              | 'Currency'   | 'Cash flow direction' | 'Partner'               | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '856,16'               | 'Main Company'     | 'Own cheque 1'     | 'Bank account, TRY'    | 'USD'        | 'Outgoing'            | 'Big foot'              | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '5 000'                | 'Main Company'     | 'Own cheque 1'     | 'Bank account, TRY'    | 'TRY'        | 'Outgoing'            | 'Big foot'              | 'Big foot'                 | 'en description is empty' | 'No'                   |
		| ''                                      | '*'           | '5 000'                | 'Main Company'     | 'Own cheque 1'     | 'Bank account, TRY'    | 'TRY'        | 'Outgoing'            | 'Big foot'              | 'Big foot'                 | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                     | ''                   | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                                              | ''                     |
		| ''                                                   | 'Record type'        | 'Period'               | 'Resources'           | ''                 | ''                                              | ''               | 'Dimensions'          | ''                      | ''                         | ''                                              | ''                     |
		| ''                                                   | ''                   | ''                     | 'Advance to suppliers' | 'Transaction AP'   | 'Advance from customers'                        | 'Transaction AR' | 'Company'             | 'Partner'               | 'Legal name'               | 'Basis document'                                | 'Currency'             |
		| ''                                                   | 'Receipt'            | '*'                    | ''                    | ''                 | '-5 000'                                        | ''               | 'Main Company'        | 'Big foot'              | 'Big foot'                 | ''                                              | 'TRY'                  |
		| ''                                                   | 'Receipt'            | '*'                    | '5 000'               | ''                 | ''                                              | ''               | 'Main Company'        | 'Big foot'              | 'Big foot'                 | ''                                              | 'TRY'                  |
		| ''                                                   | ''                   | ''                     | ''                    | ''                 | ''                                              | ''               | ''                    | ''                      | ''                         | ''                                              | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Cheque'               | 'Partner'    | 'Legal name'          | 'Currency'              | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '856,16'           | 'Main Company'     | 'Own cheque 1'         | 'Big foot'   | 'Big foot'            | 'USD'                   | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Own cheque 1'         | 'Big foot'   | 'Big foot'            | 'TRY'                   | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Own cheque 1'         | 'Big foot'   | 'Big foot'            | 'TRY'                   | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Legal name'           | 'Currency'   | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Big foot'             | 'TRY'        | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                 | ''                 | ''                     | ''           | ''                    | ''                      | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'        | 'Dimensions'       | ''                     | ''           | ''                    | ''                      | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'           | 'Company'          | 'Partner'              | 'Legal name' | 'Currency'            | 'Payment document'      | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '856,16'           | 'Main Company'     | 'Big foot'             | 'Big foot'   | 'USD'                 | 'Own cheque 1'          | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Big foot'             | 'Big foot'   | 'TRY'                 | 'Own cheque 1'          | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '5 000'            | 'Main Company'     | 'Big foot'             | 'Big foot'   | 'TRY'                 | 'Own cheque 1'          | 'Local currency'           | 'No'                       | ''                     |
		And I close all client application windows
	* Check the deleting of the added bases document
		* Open document form Cheque bond transaction
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			Then "Cheque bond transactions" window is opened
			And I go to line in "List" table
				| 'Number' |
				| '1'      |
			And I select current line in "List" table
			And I activate "Partner ar basis document" field in "PaymentList" table
			And I delete a line in "PaymentList" table
			And I click "Post" button
		* Check for movement changes
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
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
			| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
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
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '856,16'               | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
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
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'           | 'No'                       | ''                     |
			And I close all client application windows
	* Clear movements Cheque bond transactions and check that there is no movements on the registers
		* Unpost Cheque bond transactions
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			And I go to line in "List" table
				| 'Number' |
				| '1'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.ChequeBondBalance"
			And "List" table does not contain lines
			| 'Cheque'           |
			| 'Partner cheque 1' |
			| 'Own cheque 1'     |
			Given I open hyperlink "e1cib/list/InformationRegister.ChequeBondStatuses"
			And "List" table does not contain lines
			| 'Cheque'           | 'Recorder'                   | 'Status'               |
			| 'Partner cheque 1' | 'Cheque bond transaction 1*' | '01. TakenFromPartner' |
			| 'Own cheque 1'     | 'Cheque bond transaction 1*' | '01. GivenToPartner'   |
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
				| '1'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
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
			| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
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
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '856,16'               | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
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
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'           | 'No'                       | ''                     |
			And I close all client application windows

Scenario: _090006 motion check when removing a cheque from document Cheque bond transaction
	* Select Cheque bond transaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
	* Delete cheque bond
		And I go to line in "ChequeBonds" table
		| 'Amount'   | 'Cash/Bank accounts'      | 'Cheque'       | 'Currency' | 'Legal name' | 'New status'         | 'Partner'  |
		| '5 000,00' | 'Bank account, TRY' | 'Own cheque 1' | 'TRY'      | 'Big foot'   | '01. GivenToPartner' | 'Big foot' |
		And I activate "Status" field in "ChequeBonds" table
		And in the table "ChequeBonds" I click "Delete" button
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		Then "ResultTable" spreadsheet document is equal by template
		| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | 'Attributes'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | 'Status'               | 'Cheque'              | 'Author'           | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. TakenFromPartner' | 'Partner cheque 1'    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Partner cheque 1'                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
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
		| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
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
		And I click "Post" button
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		Then "ResultTable" spreadsheet document is equal by template
			| 'Cheque bond transaction 1*'            | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
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
			| ''                                      | '*'           | '342,47'               | 'Main Company'        | 'Partner cheque 1' | 'Bank account, TRY'      | 'USD'            | 'Incoming'            | 'DFC'              | 'DFC'                      | 'Reporting currency'       | 'No'                   |
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
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'Partner cheque 1'       | 'DFC'            | 'DFC'                 | 'TRY'              | 'TRY'                      | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance from customers"'    | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Receipt document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '342,47'              | 'Main Company'     | 'DFC'                    | 'DFC'            | 'USD'                 | 'Partner cheque 1' | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '2 000'               | 'Main Company'     | 'DFC'                    | 'DFC'            | 'TRY'                 | 'Partner cheque 1' | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Own cheque 1'                          | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Planing cash transactions"' | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources'            | 'Dimensions'          | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'               | 'Company'             | 'Basis document'   | 'Account'                | 'Currency'       | 'Cash flow direction' | 'Partner'          | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '856,16'               | 'Main Company'        | 'Own cheque 1'     | 'Bank account, TRY'      | 'USD'            | 'Outgoing'            | 'Big foot'         | 'Big foot'                 | 'Reporting currency'       | 'No'                   |
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
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'USD'              | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Own cheque 1'           | 'Big foot'       | 'Big foot'            | 'TRY'              | 'Local currency'           | 'No'                       | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Legal name'             | 'Currency'       | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'TRY'            | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| 'Register  "Advance to suppliers"'      | ''            | ''                     | ''                    | ''                 | ''                       | ''               | ''                    | ''                 | ''                         | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'               | 'Resources'           | 'Dimensions'       | ''                       | ''               | ''                    | ''                 | ''                         | 'Attributes'               | ''                     |
			| ''                                      | ''            | ''                     | 'Amount'              | 'Company'          | 'Partner'                | 'Legal name'     | 'Currency'            | 'Payment document' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '856,16'              | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'USD'                 | 'Own cheque 1'     | 'Reporting currency'       | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'en description is empty' | 'No'                       | ''                     |
			| ''                                      | 'Receipt'     | '*'                    | '5 000'               | 'Main Company'     | 'Big foot'               | 'Big foot'       | 'TRY'                 | 'Own cheque 1'     | 'Local currency'           | 'No'                       | ''                     |
		And I close all client application windows








			












	



