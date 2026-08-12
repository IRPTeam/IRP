#language: en
@tree
@Positive
@NegativeBalanceControlByRegisters


Feature: check cash on hand and other period expense and revenue control

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario:_892300 preparation (cash on hand and other period expense and revenue control)
	When set True value to the constant
	* Load info
		When Create catalog CancelReturnReasons objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Units objects
		When Create catalog Items objects (serial lot numbers)
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects (with remaining stock control)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
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
		When Create catalog Countries objects
		When Create information register Barcodes records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When create items for work order
		When Create catalog BillOfMaterials objects
		When Create information register Taxes records (VAT)	
	* Load documents
		When Remove stock control for store 05
		When Create document BankReceipt, CashReceipt, SalesInvoice and PurchaseInvoice objects (cash on hand and expense_revenue control)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(8010).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(8010).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(8010).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(8010).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseInvoice, GoodsReceipt and SalesInvoice objects (stock inventory control)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1253).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1114).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2122).GetObject().Write(DocumentWriteMode.Posting);"    |
		And Delay 5
	* Control settings
		When Create information register UserSettings records (R3010B_CashOnHand control)
		When Create information register UserSettings records (R6070T_OtherPeriodsExpenses control)
		When Create information register UserSettings records (R6080T_OtherPeriodsRevenues control)
	* Setting for cash/bank account
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| "Description"  |
			| "Cash desk №1" |
		And I select current line in "List" table	
		And I set checkbox "Negative balance control"
		And I click "Save and close" button
		And I go to line in "List" table
			| "Description"       |
			| "Bank account, TRY" |
		And I select current line in "List" table	
		And I set checkbox "Negative balance control"
		And I click "Save and close" button
	And I close all client application windows
	
				
Scenario:_8923001 check preparation (cash on hand and other period expense and revenue control)
	When check preparation 	

Scenario:_8923002 check cash on hand control in the CashPayment (cash account with negative balance control)
		And I close all client application windows
		* Create Cash payment 
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			And I click "Create" button
			And I select from the drop-down list named "Company" by "Main Company" string
			And I select from "Cash account" drop-down list by "Cash desk №1" string
			And I activate field named "PaymentListPartner" in "PaymentList" table
			And I select "TRY" exact value from the drop-down list named "Currency"
			And I click the button named "PaymentListAdd"
			And I select "dfc" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
			And I activate field named "PaymentListAgreement" in "PaymentList" table
			And I click choice button of the attribute named "PaymentListAgreement" in "PaymentList" table
			And I go to line in "List" table
				| "Description"                 |
				| "DFC Vendor by Partner terms" |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "1 200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Account [Cash desk №1] [TRY]. Lacking: 1 200 TRY.'|	
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Account [Cash desk №1] [TRY]. Lacking: 1 200 TRY.'|	
			And I click "Save" button
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Account [Cash desk №1] [TRY]. Lacking: 1 200 TRY.'|								
		* Change amount and post Cash payment
			And I select current line in "PaymentList" table
			And I input "900,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table			
			And I click "Post" button
			Then user message window does not contain messages
		And I close all client application windows	

Scenario:_8923003 check cash on hand control in the CashPayment (without negative balance control)
		And I close all client application windows
		* Create Cash payment 
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			And I click "Create" button
			And I select from the drop-down list named "Company" by "Main Company" string
			And I select from "Cash account" drop-down list by "Cash desk №2" string
			And I select "TRY" exact value from the drop-down list named "Currency"
			And I activate field named "PaymentListPartner" in "PaymentList" table
			And I click the button named "PaymentListAdd"
			And I select "dfc" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
			And I activate field named "PaymentListAgreement" in "PaymentList" table
			And I click choice button of the attribute named "PaymentListAgreement" in "PaymentList" table
			And I go to line in "List" table
				| "Description"                 |
				| "DFC Vendor by Partner terms" |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "1 200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click "Post" button
			Then user message window does not contain messages
		And I close all client application windows	

Scenario:_8923004 check cash on hand control in the BankPayment (bank account with negative balance control)
		And I close all client application windows
		* Create Bank payment 
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I click "Create" button
			And I select from the drop-down list named "Company" by "Main Company" string
			And I activate field named "PaymentListPartner" in "PaymentList" table
			And I move to the next attribute
			And I select from "Account" drop-down list by "Bank account, TRY" string
			And I click the button named "PaymentListAdd"
			And I select "dfc" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
			And I activate field named "PaymentListAgreement" in "PaymentList" table
			And I click choice button of the attribute named "PaymentListAgreement" in "PaymentList" table
			And I go to line in "List" table
				| "Description"                 |
				| "DFC Vendor by Partner terms" |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "1 200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Account [Bank account, TRY] [TRY]. Lacking: 1 200 TRY.'|	
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Account [Bank account, TRY] [TRY]. Lacking: 1 200 TRY.'|	
			And I click "Save" button
			And I click "Post and close" button
			Then "1C:Enterprise" window is opened
			And I click the button named "OK"
			Then there are lines in TestClient message log
				|'Account [Bank account, TRY] [TRY]. Lacking: 1 200 TRY.'|								
		* Change amount and post Bank payment
			And I select current line in "PaymentList" table
			And I input "900,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table			
			And I click "Post" button
			Then user message window does not contain messages
		And I close all client application windows

Scenario:_8923005 check cash on hand control in the BankPayment (without negative balance control)
		And I close all client application windows
		* Create Bank payment 
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I click "Create" button
			And I select from the drop-down list named "Company" by "Main Company" string
			And I select from "Account" drop-down list by "Bank account, USD" string
			And I activate field named "PaymentListPartner" in "PaymentList" table
			And I click the button named "PaymentListAdd"
			And I select "dfc" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
			And I activate field named "PaymentListAgreement" in "PaymentList" table
			And I click choice button of the attribute named "PaymentListAgreement" in "PaymentList" table
			And I go to line in "List" table
				| "Description"                 |
				| "DFC Vendor by Partner terms" |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "1 200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click "Post" button
			Then user message window does not contain messages
		And I close all client application windows

Scenario:_8923006 check other periods expenses control in the Additional revenue allocation
	And I close all client application windows
	* Create Additional revenue allocation 
		Given I open hyperlink "e1cib/list/Document.AdditionalRevenueAllocation"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select "By documents" exact value from "Allocation mode" drop-down list
		And I select "By amount" exact value from "Allocation method" drop-down list
		And in the table "RevenueDocuments" I click "Add" button
		And I click choice button of "Document" attribute in "RevenueDocuments" table
		And I go to line in "List" table
			| "Basis"                                         |
			| "Sales invoice 8 010 dated 01.09.2025 17:32:55" |
		And I select current line in "List" table
		And I finish line editing in "RevenueDocuments" table
		And in the table "AllocationDocuments" I click "Add" button
		And I select current line in "AllocationDocuments" table
		And I click choice button of "Document" attribute in "AllocationDocuments" table
		And I go to line in "List" table
			| "Basis"                                          | "Company"      |
			| "Purchase invoice 251 dated 12.03.2021 14:41:51" | "Main Company" |
		And I select current line in "List" table
	* Check negative balance
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'By document [Sales invoice 8 010 dated 01.09.2025 17:32:55]. Lacking: 847,46 TRY.'|	
		And I click "Save" button
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'By document [Sales invoice 8 010 dated 01.09.2025 17:32:55]. Lacking: 847,46 TRY.'|	
	* Post
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
		And I click "Post" button
		Then user message window does not contain messages
	And I close all client application windows

Scenario:_8923006 check other periods expenses control in the Additional cost allocation
	And I close all client application windows
	* Create Additional cost allocation 
		Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select "By documents" exact value from "Allocation mode" drop-down list
		And I select "By amount" exact value from "Allocation method" drop-down list
		And in the table "CostDocuments" I click "Add" button
		And I click choice button of "Document" attribute in "CostDocuments" table
		And I go to line in "List" table
			| "Basis"                                            |
			| "Purchase invoice 8 010 dated 01.09.2025 17:34:07" |
		And I select current line in "List" table
		And I finish line editing in "CostDocuments" table
		And in the table "AllocationDocuments" I click "Add" button
		And I select current line in "AllocationDocuments" table
		And I click choice button of "Document" attribute in "AllocationDocuments" table
		And I go to line in "List" table
			| "Basis"                                            | "Company"      |
			| "Purchase invoice 1 253 dated 27.08.2024 09:58:57" | "Main Company" |
		And I select current line in "List" table
	* Check negative balance
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'By document [Purchase invoice 8 010 dated 01.09.2025 17:34:07]. Lacking: 847,46 TRY.'|	
		And I click "Save" button
		And I click "Post and close" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'By document [Purchase invoice 8 010 dated 01.09.2025 17:34:07]. Lacking: 847,46 TRY.'|	
	* Post
		And I move to "Other" tab
		And I select from the drop-down list named "Branch" by "Front office" string
		And I click "Post" button
		Then user message window does not contain messages
	And I close all client application windows
				
				