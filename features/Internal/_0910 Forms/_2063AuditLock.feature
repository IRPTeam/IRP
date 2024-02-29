﻿#language: en
@tree
@Positive
@Forms

Feature: audit lock

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _206300 preparation (audit lock)
	When set True value to the constant
	When set True value to the constant Use commission trading
	When set True value to the constant Use consolidated retail sales
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog Countries objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create PaymentType (advance)
		When Create catalog Partners and Payment type (Bank)
		When Create POS cash account objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
		When Create catalog Partners objects
		When Create catalog Partners objects (Kalipso)
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog ItemTypes objects
		When Create catalog Items objects
		When Create catalog ItemKeys objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
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
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog BankTerms objects
		When Create catalog SpecialOfferRules objects (Test)
		When Create catalog SpecialOfferTypes objects (Test)
		When Create catalog SpecialOffers objects (Test)
		When Create catalog CashStatementStatuses objects (Test)
		When Create catalog Hardware objects  (Test)
		When Create catalog Workstations objects  (Test)
		When Create catalog ItemSegments objects
		When Create catalog PaymentTypes objects
		When Create catalog AccessGroups and AccessProfiles objects (audit lock)
		When Create information register Taxes records (VAT)
	* Load documents
		When Create document PurchaseInvoice objects
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And I input "Payment terminal 01" text in the field named "Description_en"
		And I click "Save and close" button
	* Access group
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I go to line in "List" table
			| 'Description'           |
			| 'Audit lock control'    |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create PaymentTypes
		When Create catalog PaymentTypes objects
	* Bank terms
		When Create catalog BankTerms objects (for Shop 02)		
	* Workstation
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one			
	* Retail documents
		When Create document RSR, RRR with ConsolidatedRetailSales
		And I execute 1C:Enterprise script at server
			| "Documents.ConsolidatedRetailSales.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Cash receipt (Customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Bank receipt (Customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Money transfer
		When Create document MoneyTransfer objects (for cash in)
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document MoneyTransfer objects (for cash out)
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _2063001 check preparation
	When check preparation


Scenario: _2063004 check audit lock (PI)
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And I select current line in "List" table
		And I click "Post" button
		Then user message window does not contain messages
	* Lock document
		And I click "Audit lock (set lock)" button
		Then user message window does not contain messages
	* Check lock document
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Document is locked by audit lock'|
		

Scenario: _2063007 check audit unlock
	And I close all client application windows
	* Preparation	
		Try
			And the previous scenario executed successfully
		Except
			Then I stop the execution of scripts for this feature
	* Try unlock without permission
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And I select current line in "List" table
		And I click "Audit lock (unlock)" button
		Then there are lines in TestClient message log
			|'Access is denied'|	
	* Allowing CI to capture the audit log	
		Given I open hyperlink "e1cib/data/Catalog.AccessGroups?ref=b7b6cb8aa66608cf11eed54b0e7af6b7"
		And in the table "Profiles" I click "Add" button
		And I select "Audit unlock" from "Profile" drop-down list by string in "Profiles" table
		And I finish line editing in "Profiles" table
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
	* Check audit unlock
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And I select current line in "List" table
		And I click "Audit lock (unlock)" button
		And I click "Post" button
		When I Check the steps for Exception
			| 'Then "1C:Enterprise" window is opened'    |
		Then user message window does not contain messages	


Scenario: _2063008 check audit lock for linked documents
	And I close all client application windows
	* Lock CRS
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Number' |
			| '2'     |
		And I select current line in "List" table
		And I click "Post" button
		Then user message window does not contain messages
	* Lock document
		And I click "Audit lock (set lock)" button
		Then user message window does not contain messages	
	* Try change RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '3'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Document is locked by audit lock'|
	* Unlock CRS
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Number' |
			| '2'     |
		And I select current line in "List" table		
		And I click "Audit lock (unlock)" button
	* Try change RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'|
			| '3'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		When I Check the steps for Exception
			| 'Then "1C:Enterprise" window is opened'    |
		Then user message window does not contain messages	
	And I close all client application windows
	
			
				
Scenario: _2063020 check audit lock	without permisson
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/data/Catalog.AccessGroups?ref=b7b6cb8aa66608cf11eed54b0e7af6b7"
		Then "Audit lock control (User access group)" window is opened
		And I go to line in "Profiles" table
			| 'Profile'    |
			| 'Audit lock' |
		And in the table "Profiles" I click "Delete" button
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
	* Check audit lock
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And I select current line in "List" table
		And I click "Audit lock (set lock)" button
		Then there are lines in TestClient message log
			|'Access is denied'|		
	And I close all client application windows	

Scenario: _2063023 check audit lock history
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.AuditLockHistory"
	And "List" table became equal
		| 'User'                    | 'Date' | 'Document'                                              | 'Action' |
		| 'en description is empty' | '*'    | 'Purchase invoice 12 dated 07.09.2020 17:53:38'         | 'Lock'   |
		| 'en description is empty' | '*'    | 'Purchase invoice 12 dated 07.09.2020 17:53:38'         | 'Unlock' |
		| 'en description is empty' | '*'    | 'Consolidated retail sales 2 dated 21.08.2022 08:14:58' | 'Lock'   |
		| 'en description is empty' | '*'    | 'Consolidated retail sales 2 dated 21.08.2022 08:14:58' | 'Unlock' |
	And I close all client application windows	