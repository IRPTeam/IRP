#language: en
@tree
@Positive
@Group12
Feature: cheque filling

As a QA
I want to check the Cheque bond transaction form.
For ease of filling


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _2020001 test data creation
	* create a check and marking it for deletion
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
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I finish line editing in "ChequeBonds" table
		* Change the document number
			And I move to "Other" tab
			And I input "2" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "11" text in "Number" field
			And I click "Post and close" button
			And "List" table contains lines
			| 'Number' |
			| '11'      |
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
	* Preparation
		# Removing a DFC partner from all segments and creating an individual partner term
			Given I open hyperlink "e1cib/list/Catalog.Partners"
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
			And In this window I click command interface button "Partner segments content"
			And I delete a line in "List" table
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And In this window I click command interface button "Partner terms"
			And I click the button named "FormCreate"
			And I input "Partner term DFC" text in the field named "Description_en"
			And I change "Type" radio button value to "Customer"
			And I change "AP/AR posting detail" radio button value to "By documents"
			And I input "121" text in "Number" field
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Type'      |
				| 'TRY'      | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| 'Currency' | 'Description'             |
				| 'TRY'      | 'Basic Price without VAT' |
			And I select current line in "List" table
			And I input "01.01.2019" text in "Start using" field
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click "Save and close" button
	* Open document form ChequeBondTransaction
			Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
			And I click the button named "FormCreate"
	* Add a partner with one Partner term
			And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
			And I click choice button of "Partner" attribute in "ChequeBonds" table
			And I go to line in "List" table
				| 'Description' |
				| 'DFC'         |
			And I select current line in "List" table
	* Check filling in Partner term
			And "ChequeBonds" table contains lines
				| 'Partner' | 'Partner term'     |
				| 'DFC'     | 'Partner term DFC' |
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
			| 'DFC'         |
		And I select current line in "List" table
	* Check availability to select only one partner term
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And "List" table became equal
			| 'Description'   |
			| 'Partner term DFC' |
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
			| 'DFC'         |
		And I select current line in "List" table
	* Filling in Partner term
		And I click choice button of "Partner term" attribute in "ChequeBonds" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Partner term DFC' |
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
		
Scenario: _2020007 check filter by cheque in the form of 'Cheque bonds' selection depending on the selected currency (re-selection) and separation of cheques by Partners/Own
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

Scenario: _2020008 not displaying checks marked for deletion in the selection form 'Cheque bonds'
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

Scenario: _2020009 check the selection of status checks in the 'Cheque bonds' selection form
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
		
Scenario: _2020010 check to delete selected cheques in the 'Cheque bonds' selection form
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
	* Check for sales invoice 3000
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
		| 'Number'          |
		| '1'  |
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
		Then 'Select base documents in "Cheque bond transaction" document' window is opened
		And I go to line in "DocumentsList" table
			| 'Currency' | 'Document amount' |
			| 'TRY'      | '137 000'         |
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
		And I click "Post" button
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Cheque bond transaction *'             | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond statuses"'      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'          | 'Dimensions'   | 'Attributes'     | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | 'Status'             | 'Cheque'       | 'Author'         | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | '*'           | '01. GivenToPartner' | 'Own cheque 2' | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Own cheque 2'                          | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources'          | 'Dimensions'   | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | 'Amount'             | 'Company'      | 'Basis document' | 'Account'             | 'Currency'          | 'Cash flow direction' | 'Partner'            | 'Legal name'               | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'           | '1 712,33'           | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'USD'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'en description is empty' | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'Local currency'           | 'No'                   |
		| ''                                      | '*'           | '10 000'             | 'Main Company' | 'Own cheque 2'   | 'Bank account, TRY'   | 'TRY'               | 'Outgoing'            | 'Ferron BP'          | 'Company Ferron BP'        | 'TRY'                      | 'No'                   |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'                       | ''                    | ''                    | ''                    | ''               | ''                                             | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                                     | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                  | 'Dimensions'          | ''                   | ''                         | ''                         | ''                     |
		| ''                                                     | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'    | 'Company'             | 'Partner'            | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                                     | 'Receipt'             | '*'                   | ''                    | ''               | '-1 000'                                       | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'        | ''                         | 'TRY'                  |
		| ''                                                     | 'Receipt'             | '*'                   | '1 000'               | ''               | ''                                             | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'        | ''                         | 'TRY'                  |
		| ''                                                     | 'Expense'             | '*'                   | ''                    | '9 000'          | ''                                             | ''                  | 'Main Company'        | 'Ferron BP'          | 'Company Ferron BP'        | 'Purchase invoice 1*'      | 'TRY'                  |
		| ''                                                     | ''                    | ''                    | ''                    | ''               | ''                                             | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Cheque bond balance"'       | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Cheque'              | 'Partner'           | 'Legal name'          | 'Currency'           | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 712,33'     | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'USD'                | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Own cheque 2'        | 'Ferron BP'         | 'Company Ferron BP'   | 'TRY'                | 'TRY'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Legal name'          | 'Currency'          | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '10 000'       | 'Main Company'   | 'Company Ferron BP'   | 'TRY'               | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Advance to suppliers"'      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Partner'             | 'Legal name'        | 'Currency'            | 'Payment document'   | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '171,23'       | 'Main Company'   | 'Ferron BP'           | 'Company Ferron BP' | 'USD'                 | 'Own cheque 2'       | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 000'        | 'Main Company'   | 'Ferron BP'           | 'Company Ferron BP' | 'TRY'                 | 'Own cheque 2'       | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | 'Receipt'     | '*'                  | '1 000'        | 'Main Company'   | 'Ferron BP'           | 'Company Ferron BP' | 'TRY'                 | 'Own cheque 2'       | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'   | ''            | ''                   | ''             | ''               | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'             | 'Resources'    | 'Dimensions'     | ''                    | ''                  | ''                    | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''                   | 'Amount'       | 'Company'        | 'Basis document'      | 'Partner'           | 'Legal name'          | 'Partner term'          | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Expense'     | '*'                  | '1 541,1'      | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'        | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                      | 'en description is empty' | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'        | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | 'Expense'     | '*'                  | '9 000'        | 'Main Company'   | 'Purchase invoice 1*' | 'Ferron BP'         | 'Company Ferron BP'   | 'Vendor Ferron, TRY' | 'TRY'                      | 'TRY'                      | 'No'                   |
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
			| '1'  |
	* Clear movements Cheque bond transaction and  check movement reversal
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document does not contain values
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Reconciliation statement" |
			| Register  "Advance from customers" |
		And I close current window
	* Re-post cheque bond transaction again and checking the movements
		And I go to line in "List" table
			| 'Number' |
			| '1'  |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document contains values
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Reconciliation statement" |
			| Register  "Advance from customers" |
		And I close current window
	* Marked for deletion Cheque bond transaction and check movement reversal
		And I go to line in "List" table
			| 'Number' |
			| '1'  |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click "Registrations report" button
		Then "Document registrations report" window is opened
		And "ResultTable" spreadsheet document does not contain values
			| Register  "Cheque bond statuses" |
			| Register  "Planing cash transactions" |
			| Register  "Cheque bond balance" |
			| Register  "Reconciliation statement" |
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
			| Register  "Reconciliation statement" |
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
			


