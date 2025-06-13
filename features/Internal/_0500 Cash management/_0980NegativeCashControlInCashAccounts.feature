#language: en
@tree
@Positive
@CashManagement

Functionality: negative cash control in cash accounts


Variables:
import "Variables.feature"


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _098000 preparation (negative cash control in cash accounts)
	When set True value to the constant
	* Load info
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
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog CashAccounts objects (Second Company)
	* Settings for negative cash control in cash accounts
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'                   |
			| 'Cash desk №1 (Second Company)' |
		And I select current line in "List" table
		And I set checkbox "Negative balance control"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'                        |
			| 'Bank account, TRY (Second Company)' |
		And I select current line in "List" table
		And I set checkbox "Negative balance control"
		And I click "Save and close" button
		When Create information register UserSettings records (negative cash control in cash accounts)
	* Load documents
		When Data preparation for negative cash control in cash accounts
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"     |
	
		
Scenario: _0980001 check preparation
	When check preparation


Scenario: _0980002 check negative balance control for cash funds in BankPayment document
	And I close all client application windows
	* Create Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"		
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I activate field named "PaymentListPartner" in "PaymentList" table
		And I select from the drop-down list named "Account" by "Bank account, TRY (Second Company)" string
		And I activate field named "PaymentListPartner" in "PaymentList" table
		And I click the button named "PaymentListAdd"
		And I select "dfc" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And I activate field named "PaymentListAgreement" in "PaymentList" table
		And I select "DFC Vendor by Partner terms" by string from the drop-down list named "PaymentListAgreement" in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "2 200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
	* Check posting
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		And user message window does not contain messages
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text
	* Change amount and try post document (over the limit)
		And I move to "Payments" tab	
		And I select current line in "PaymentList" table
		And I input "2 700,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Bank account, TRY (Second Company)] [TRY]. Lacking: 200 TRY.'|
	* Unpost BP and try to post it  (over the limit)
		And I click "Cancel posting" button
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Bank account, TRY (Second Company)] [TRY]. Lacking: 200 TRY.'|
	* Change amount (within the limit) and Branch (no available cash balance)
		And I select current line in "PaymentList" table
		And I input "2 200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Accountants office" string
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Bank account, TRY (Second Company)] [TRY]. Lacking: 2 200 TRY.'|
	* Change Branch (with available cash balance)
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text
	And I close all client application windows
	
Scenario: _0980003 check negative balance control for cash funds in CashPayment document
	And I close all client application windows
	* Create Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"		
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I activate field named "PaymentListPartner" in "PaymentList" table
		And I select from the drop-down list named "CashAccount" by "Cash desk №1 (Second Company)" string
		And I activate field named "PaymentListPartner" in "PaymentList" table
		And I click the button named "PaymentListAdd"
		And I select "dfc" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And I activate field named "PaymentListAgreement" in "PaymentList" table
		And I select "DFC Vendor by Partner terms" by string from the drop-down list named "PaymentListAgreement" in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "800,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
	* Check posting
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		And user message window does not contain messages
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text
	* Change amount and try post document (over the limit)
		And I move to "Payments" tab
		And I select current line in "PaymentList" table
		And I input "1 200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Cash desk №1 (Second Company)] [TRY]. Lacking: 200 TRY.'|
	* Unpost CP and try to post it  (over the limit)
		And I click "Cancel posting" button
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Cash desk №1 (Second Company)] [TRY]. Lacking: 200 TRY.'|
	* Change amount (within the limit) and Branch (no available cash balance)
		And I select current line in "PaymentList" table
		And I input "800,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Accountants office" string
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Cash desk №1 (Second Company)] [TRY]. Lacking: 800 TRY.'|
	* Change Branch (with available cash balance)
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text
	And I close all client application windows
		
				

Scenario: _0980004 check negative balance control for cash funds in CashExpense document
	And I close all client application windows
	* Create Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"		
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I select from the drop-down list named "Account" by "Bank account, TRY (Second Company)" string
		And in the table "PaymentList" I click "Add" button
		And I activate "Profit loss center" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "PaymentList" table
		And I activate "Expense type" field in "PaymentList" table
		And I select "Expense" from "Expense type" drop-down list by string in "PaymentList" table
		And I activate "Cash flow center" field in "PaymentList" table
		And I select "Front office" from "Cash flow center" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
	* Check posting
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		And user message window does not contain messages
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text				
	* Change amount and try post document (over the limit)
		And I move to "Payment list" tab
		And I select current line in "PaymentList" table
		And I input "400,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Bank account, TRY (Second Company)] [TRY]. Lacking: 100 TRY.'|					
	* Unpost Cash expense and try to post it (over the limit)
		And I click "Cancel posting" button
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Bank account, TRY (Second Company)] [TRY]. Lacking: 100 TRY.'|
	* Change amount (within the limit) and Branch (no available cash balance)
		And I select current line in "PaymentList" table
		And I input "200,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Accountants office" string
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Bank account, TRY (Second Company)] [TRY]. Lacking: 200 TRY.'|				
	* Change Branch (with available cash balance)
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text
	And I close all client application windows
		
				
Scenario: _0980005 check negative balance control for cash funds in RetailReturnReceipt document
	And I close all client application windows
	* Create Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"		
		And I click "Create" button
		And I select from the drop-down list named "Partner" by "Retail customer" string
		And I select from the drop-down list named "Company" by "Second Company" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "dress" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "XS/Blue" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "180,00" text in "Price" field of "ItemList" table
		And I input "150,00" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I move to "Payments" tab
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I select "Cash" from "Payment type" drop-down list by string in "Payments" table
		And I activate "Account" field in "Payments" table
		And I select "Cash desk №1 (Second Company)" from "Account" drop-down list by string in "Payments" table
		And I input "180,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I select from the drop-down list named "Branch" by "Front office" string
	* Check posting
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		And user message window does not contain messages
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text				
	* Change amount and try post document (over the limit)
		And I move to "Item list" tab		
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "300,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Cash desk №1 (Second Company)] [TRY]. Lacking: 100 TRY.'|					
	* Unpost RSR and try to post it (over the limit)
		And I click "Cancel posting" button
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Cash desk №1 (Second Company)] [TRY]. Lacking: 100 TRY.'|
	* Change amount (within the limit) and Branch (no available cash balance)
		And I move to "Item list" tab
		And I select current line in "ItemList" table
		And I input "198,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "198,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Accountants office" string
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Account [Cash desk №1 (Second Company)] [TRY]. Lacking: 198 TRY.'|				
	* Change Branch (with available cash balance)
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
		And I click "Post" button
		When I Check the steps for Exception
			|"Then "1C:Enterprise" window is opened"|
		Then the field named "DecorationGroupTitleCollapsedLabel" value contains "Posting status: Posted   " text
	And I close all client application windows

