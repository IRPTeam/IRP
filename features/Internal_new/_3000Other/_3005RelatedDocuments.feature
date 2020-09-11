#language: en
@tree
@Positive
@Group18

Feature: related documents



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _300501 check connection to Internal Supply Request report "Related documents"
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300502 check connection to Purchase order report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 2      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300503 check connection to Purchase invoice report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 2      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300504 check connection to Sales order report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300505 check connection to Sales invoice report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300506 check connection to Shipment Confirmation report "Related documents"
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 181      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows


Scenario: _300507 check connection to GoodsReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300508 check connection to PurchaseReturnOrder report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300509 check connection to PurchaseReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300510 check connection to SalesReturnOrder report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300511 check connection to SalesReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 2      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300512 check connection to CashPayment report "Related documents"
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300513 check connection to CashReciept report "Related documents"
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300514 check connection to BankPayment report "Related documents"
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300515 check connection to BankReciept report "Related documents"
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows


Scenario: _300516 check connection to CashTransferOrder report "Related documents" and generating a report for the current item (Cash receipt)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
		And "DocumentsTree" table contains lines
		| 'Ref'                    | 'Amount' |
		| '$$CashTransferOrder054001$$' | '*'      |
		| '$$CashPayment054003$$'        | '500,00' |
		| '$$CashReceipt054003$$'        | '400,00' |
		| '$$CashReceipt0540031$$'        | '100,00' |
	*  Check the report generation from list
		And I go to the last line in "DocumentsTree" table
		And in the table "DocumentsTree" I click the button named "DocumentsTreeGenerateForCurrent"
		And "DocumentsTree" table contains lines
		| 'Ref'                    | 'Amount' |
		| '$$CashTransferOrder054001$$' | ''       |
		| '$$CashReceipt0540031$$'        | '100,00' |
	And I close all client application windows





Scenario: _300519 check connection to Bundling report "Related documents"
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _300520 check connection to Unbundling report "Related documents"
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| 1      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows


Scenario: _300521 check post/unpost/mark for deletion from report "Related documents"
	* Preparation
		* Create Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02 TR' |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers TR' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'     |
				| 'Trousers TR' | '38/Yellow TR' |
			And I select current line in "List" table
			And I click Select button of "Manager segment" field
			And I go to line in "List" table
				| 'Description' |
				| '2 Region'    |
			And I select current line in "List" table
			And I move to "Other" tab
			And I set checkbox "Shipment confirmations before sales invoice"
			And I input "9 092" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "9 092" text in "Number" field
			And I click "Post" button
		* Create Shipment confirmation based on SO
			And I click "Shipment confirmation" button
			And I move to "Other" tab
			And I input "9 092" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "9 092" text in "Number" field
			And I click "Post and close" button
			And Delay 5
		* Create Sales invoice based on created SC
			And I click "Sales invoice" button
			And I click the button named "FormSelectAll"
			And I click "Ok" button
			And I move to "Other" tab
			And I input "9 012" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "9 012" text in "Number" field
			And I click "Post and close" button
			And Delay 5
		* Open Related documents
			When in opened panel I select "Sales order 9 092*"
			And I click "Related documents" button
			And "DocumentsTree" table contains lines
			| 'Ref'                          |
			| 'Sales order 9 092*'           |
			| 'Shipment confirmation 9 092*' |
			| 'Sales invoice 9 012*'         |
		* Check unpost Sales invoice from report Related documents
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreeUnpost"
			Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
			And Delay 10
			And "List" table does not contain lines
			| 'Recorder'             |
			| 'Sales invoice 9 012*' |
		* Check post Sales invoice from report Related documents
			When in opened panel I select "Related documents"
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreePost"
			Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
			And I click "Refresh" button
			And Delay 10
			And "List" table contains lines
			| 'Recorder'             |
			| 'Sales invoice 9 012*' |
		* Mark for deletion Sales invoice from report Related documents
			When in opened panel I select "Related documents"
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreeDelete"
			And I go to the last line in "DocumentsTree" table
		* Unmark for deletion  Sales invoice from report Related documents
			When in opened panel I select "Related documents"
			And I go to the last line in "DocumentsTree" table
			And in the table "DocumentsTree" I click the button named "DocumentsTreeDelete"
			And I go to the last line in "DocumentsTree" table
		And I close all client application windows






