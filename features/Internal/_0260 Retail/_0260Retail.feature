#language: en
@tree
@Positive
@Retail

Feature: check filling in retail documents + currency form connection

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _0260100 preparation (retail)
	When set True value to the constant
	When set True value to the constant Use consolidated retail sales
	* Load info
		When Create catalog BusinessUnits objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog Partners and Payment type (Bank)
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (Customer)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
		When Create PaymentType (advance)	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog Users objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create POS cash account objects
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog UserGroups objects
	* Create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And I input "Payment terminal 01" text in the field named "Description_en"
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
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
		And I select current line in "List" table
		And I delete "$$MoneyTransfer11$$" variable
		And I save the window as "$$MoneyTransfer11$$" 
		And I close all client application windows
		

Scenario: _0260101 check preparation
	When check preparation

Scenario: _0260102 сheck that the buttons in POS are inactive if session closed
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	When I Check the steps for Exception
		| 'And I click "Close session" button'   |
	When I Check the steps for Exception
		| 'And I click "Cancel session" button'   |
	When I Check the steps for Exception
		| 'And I click "Create cash in" button'   |
	When I Check the steps for Exception
		| 'And I click "Create cash out" button'   |
	And I click "Print X Report" button

Scenario: _0260105 open session
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	And I click "Open session" button
	* Check
	When I Check the steps for Exception
		| 'And I click "Open session" button'   |
	Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
	And I go to line in "List" table
		| 'Status'   |
		| 'Open'     |
	And I select current line in "List" table
	And I save the window as "$$ConsolidatedRetailSales2$$" 
	And I close all client application windows		



Scenario: _0260106 create cash in
	And I close all client application windows
	* Open POS and open session		
		And In the command interface I select "Retail" "Point of sale"
	* Create cash in
		And I click "Create cash in" button		
		Then the number of "CashInList" table lines is "равно" 1
		And I go to line in "CashInList" table
			| 'Money transfer'        | 'Currency'   | 'Amount'      |
			| '$$MoneyTransfer11$$'   | 'TRY'        | '1 000,00'    |
		And I select current line in "CashInList" table
	* Check Cash receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Pos cash account 1"
		Then the form attribute named "TransactionType" became equal to "Cash in"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#'   | 'Total amount'   | 'Financial movement type'   | 'Money transfer'         |
			| '1'   | '1 000,00'       | 'Movement type 1'           | '$$MoneyTransfer11$$'    |
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Branch" became equal to "Shop 02"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "1 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post Cash receipt
		And I click "Post" button
		And I delete "$$NumberCashReceipt1$$" variable
		And I delete "$$CashReceipt1$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt1$$"
		And I save the window as "$$CashReceipt1$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashReceipt"		
		And "List" table contains lines
			| 'Number'                   | 'Amount'     | 'Company'        | 'Cash account'         | 'Currency'   | 'Transaction type'    |
			| '$$NumberCashReceipt1$$'   | '1 000,00'   | 'Main Company'   | 'Pos cash account 1'   | 'TRY'        | 'Cash in'             |
		Then the number of "List" table lines is "равно" 2
		When in opened panel I select "Point of sales"
		And in the table "CashInList" I click "Update money transfers" button
		Then the number of "CashInList" table lines is "равно" 0
		And I close all client application windows

Scenario: _0260107 create RSR and check Consolidated retail sales filling
	* Check preparation
		Try
			And the previous scenario executed successfully
		Except
			Then I stop the execution of scripts for this feature
		And I close all client application windows
	* Open POS and create first RSR (card)
		And In the command interface I select "Retail" "Point of sale"
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, L/Green'    |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'   | 'Total'     |
			| 'Dress'   | 'XS/Blue'    | '520,00'   | '1,000'      | '520,00'    |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 02'      |
		And I select current line in "BankPaymentTypeList" table	
		And I click the button named "Enter"
	* Create second RSR (card)
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemsPickup" table
			| 'Item'                       |
			| '(10001) Dress, S/Yellow'    |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table	
		Then "Payment" window is opened
		And I click the button named "Enter"
	* Create third RSR (card)
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemsPickup" table
			| 'Item'                       |
			| '(10001) Dress, S/Yellow'    |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 02'      |
		And I select current line in "BankPaymentTypeList" table	
		And I click the button named "Enter"
	* Create first RSR (cash)
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemsPickup" table
			| 'Item'                       |
			| '(10001) Dress, S/Yellow'    |
		And I select current line in "ItemsPickup" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		And I click "Cash (/)" button	
		And I click the button named "Enter"
	* Create second RSR (cash)
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemsPickup" table
			| 'Item'                       |
			| '(10001) Dress, S/Yellow'    |
		And I select current line in "ItemsPickup" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click the button named "Enter"				
	* Check filling field Consolidated retail sales and workstation in the RSR
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account'         | 'Status'    |
			| 'Pos cash account 1'   | 'Open'      |
		And I select current line in "List" table	
		And I delete "$$ConsolidatedRetailSales2$$" variable
		And I save the window as "$$ConsolidatedRetailSales2$$" 	
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
		And I select current line in "List" table
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		And I delete "$$RetailSalesReceiptNew$$" variable
		And I save the window as "$$RetailSalesReceiptNew$$" 
		And I close current window
	* Check filling Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account'         | 'Status'    |
			| 'Pos cash account 1'   | 'Open'      |
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Pos cash account 1"
		Then the form attribute named "Status" became equal to "Open"
		And "Documents" table contains lines
			| 'Document'                    | 'Company'        | 'Amount'   | 'Branch'    | 'Currency'   | 'Author'    |
			| '$$RetailSalesReceiptNew$$'   | 'Main Company'   | '1 590'    | 'Shop 02'   | 'TRY'        | 'CI'        |
		And "Documents" table contains lines
			| 'Document'   | 'Company'        | 'Amount'   | 'Branch'    | 'Currency'   | 'Author'    |
			| '*'          | 'Main Company'   | '1 590'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'          | 'Main Company'   | '3 180'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'          | 'Main Company'   | '3 180'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'          | 'Main Company'   | '2 110'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'          | 'Main Company'   | '5 440'    | 'Shop 02'   | 'TRY'        | 'CI'        |
		Then the number of "Documents" table lines is "равно" "6"	
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Author" became equal to "CI"
		And I delete "$$OpeningDate$$" variable
		And I save the value of the field named "OpeningDate" as "$$OpeningDate$$"
		And I close all client application windows
		
		
Scenario: _0260111 create RRR day to day and check Consolidated retail sales filling							
	And I close all client application windows
	* Select RSR and create first RRR (card)
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
		And I click "Sales return" button
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '2,000'      | 'Dress (XS/Blue)'    | 'pcs'    | 'Yes'    |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check filling RRR
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'        | 'Item'    | 'Sales person'   | 'Profit loss center'   | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Quantity'   | 'Price'    | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Return reason'   | 'Revenue type'   | 'Detail'   | 'VAT'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | '$$RetailSalesReceiptNew$$'   | 'Dress'   | ''               | 'Shop 02'              | 'L/Green'    | 'No'                   | ''                     | 'pcs'    | '83,90'        | '1,000'      | '550,00'   | '466,10'       | '550,00'         | ''                      | 'Store 01'   | ''                | ''               | ''         | '18%'   | ''                | ''               |
		And "Payments" table became equal
			| '#'   | 'Amount'     | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'      | 'Account'          | 'Percent'    |
			| '1'   | '1 590,00'   | '31,80'        | 'Card 02'        | ''                   | 'No'                  | 'Bank term 02'   | 'Transit Second'   | '2,00'       |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "Author" became equal to "CI"
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "550,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post" button
		And I delete "$$RetailReturnReceiptNew$$" variable
		And I save the window as "$$RetailReturnReceiptNew$$" 
		And I close current window
	* Check filling Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account'         | 'Status'    |
			| 'Pos cash account 1'   | 'Open'      |
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Pos cash account 1"
		Then the form attribute named "Status" became equal to "Open"
		And "Documents" table became equal
			| 'Document'                   | 'Company'      | 'Amount' | 'Branch'  | 'Currency' | 'Author' |
			| '*'                          | 'Main Company' | '1 000'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '$$RetailSalesReceiptNew$$'  | 'Main Company' | '1 590'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '*'                          | 'Main Company' | '3 180'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '*'                          | 'Main Company' | '3 180'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '*'                          | 'Main Company' | '2 110'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '*'                          | 'Main Company' | '5 440'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '$$RetailReturnReceiptNew$$' | 'Main Company' | '-550'   | 'Shop 02' | 'TRY'      | 'CI'     |
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Author" became equal to "CI"
		And I close all client application windows	
	* Select RSR and create second RRR (cash)
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '5 440,00'    |
		And I click "Sales return" button
		Then "Add linked document rows" window is opened
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '550,00'   | '8,000'      | 'Dress (S/Yellow)'   | 'pcs'    | 'Yes'    |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "520,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post and close" button
	* Select RSR and create third RRR (cash)	
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '5 440,00'    |
		And I click "Sales return" button
		Then "Add linked document rows" window is opened
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '1,000'      | 'Dress (XS/Blue)'    | 'pcs'    | 'Yes'    |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "550,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post and close" button
				
				

Scenario: _0260115 create RRR prior periods and check Consolidated retail sales filling							
	And I close all client application windows
	* Select RSR and create RRR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 040,00'    |
		And I click "Sales return" button
		And I click "Ok" button
	* Check filling RRR
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'                               | 'Item'    | 'Sales person'   | 'Profit loss center'   | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Quantity'   | 'Price'    | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Return reason'   | 'Revenue type'   | 'Detail'   | 'VAT'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | 'Retail sales receipt 2 dated 21.08.2022 22:47:54'   | 'Dress'   | ''               | 'Shop 02'              | 'XS/Blue'    | 'No'                   | ''                     | 'pcs'    | '158,64'       | '2,000'      | '520,00'   | '881,36'       | '1 040,00'       | ''                      | 'Store 01'   | ''                | ''               | ''         | '18%'   | ''                | ''               |
		And "Payments" table became equal
			| '#'   | 'Amount'     | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'   | 'Account'              | 'Percent'    |
			| '1'   | '1 040,00'   | ''             | 'Cash'           | ''                   | 'No'                  | ''            | 'Pos cash account 1'   | ''           |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "Author" became equal to "CI"
		And I click "Post" button
		And I delete "$$RetailReturnReceiptOld$$" variable
		And I save the window as "$$RetailReturnReceiptOld$$" 
		And I close current window
	* Check filling Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account'         | 'Status'    |
			| 'Pos cash account 1'   | 'Open'      |
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Pos cash account 1"
		Then the form attribute named "Status" became equal to "Open"
		And "Documents" table became equal
			| 'Document'                     | 'Company'        | 'Amount'   | 'Branch'    | 'Currency'   | 'Author'    |
			| '*'                            | 'Main Company'   | '1 000'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '$$RetailSalesReceiptNew$$'    | 'Main Company'   | '1 590'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '3 180'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '3 180'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '2 110'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '5 440'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '$$RetailReturnReceiptNew$$'   | 'Main Company'   | '-550'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-520'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-550'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '$$RetailReturnReceiptOld$$'   | 'Main Company'   | '-1 040'   | 'Shop 02'   | 'TRY'        | 'CI'        |
		Then the number of "Documents" table lines is "equal" "10"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Author" became equal to "CI"
		And I close all client application windows
				
Scenario: _0260130 create cash out
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"	
	* Create cash out
		And I click "Create cash out" button
	* Check filling money transfer
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Sender" became equal to "Pos cash account 1"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SenderCurrency" became equal to "TRY"
		And the editing text of form attribute named "TotalAtPOS" became equal to "7 880,00"
		Then the form attribute named "Receiver" became equal to "Cash desk №2"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiverCurrency" became equal to "TRY"
		And the editing text of form attribute named "SendAmount" became equal to "7 880,00"
		And I input "3 480,00" text in "Send amount" field
		And I click "Create money transfer" button
		// Then in the TestClient message log contains lines by template:
		// 	|'Object Money transfer* created.'|		
	* Check creation
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Author'   | 'Company'        | 'Receive amount'   | 'Receive currency'   | 'Receiver'       | 'Send amount'   | 'Send currency'   | 'Sender'                |
			| 'CI'       | 'Main Company'   | '3 480,00'         | 'TRY'                | 'Cash desk №2'   | '3 480,00'      | 'TRY'             | 'Pos cash account 1'    |
		And I select current line in "List" table
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"		
		And I delete "$$NumberMoneyTransfer3$$" variable
		And I delete "$$MoneyTransfer3$$" variable
		And I save the value of "Number" field as "$$NumberMoneyTransfer3$$"
		And I save the window as "$$MoneyTransfer3$$"				
	* Create Cash receipt
		And I click "Cash receipt" button
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Cash in"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#'   | 'Total amount'   | 'Financial movement type'   | 'Money transfer'        |
			| '1'   | '3 480,00'       | 'Movement type 1'           | '$$MoneyTransfer3$$'    |
		Then the form attribute named "Branch" became equal to "Shop 02"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "3 480,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I click "Post" button
		And I delete "$$NumberCashReceipt2$$" variable
		And I delete "$$CashReceipt2$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt2$$"
		And I save the window as "$$CashReceipt2$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And "List" table contains lines
			| 'Number'                 | 'Amount'   | 'Company'      | 'Cash account' | 'Currency' | 'Transaction type' | 'Author' |
			| '$$NumberCashReceipt2$$' | '3 480,00' | 'Main Company' | 'Cash desk №2' | 'TRY'      | 'Cash in'          | 'CI'     |
		And I close all client application windows

Scenario: _0260132 create RSR (payment by bank credit)
		And I close all client application windows
	* Open POS and create RSR
		And In the command interface I select "Retail" "Point of sale"
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, L/Green'    |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'   | 'Total'     |
			| 'Dress'   | 'XS/Blue'    | '520,00'   | '1,000'      | '520,00'    |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
	* Payment by bank credit
		And I click "P\A" button
		And "Payments" table became equal
			| 'Payment type'   | 'Amount'      |
			| 'Bank credit'    | '5 750,00'    |
		And I click the button named "Enter"
		And Delay 2
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '5 750,00'    |
		And I select current line in "List" table
		And I move to "Payments" tab
		And "Payments" table became equal
			| '#' | 'Amount'   | 'Commission' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'     | 'Account' | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '5 750,00' | '575,00'     | 'Bank credit'  | ''                        | ''                                  | ''                 | 'Payment agent' | ''        | '10,00'   | ''         | 'Bank 1'                | 'Bank 1'                   | 'Bank 1'                      |	
		And I close all client application windows
		

Scenario: _0260133 create advance payment from POS (Cash, Card)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer (cash advance)
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I click "OK" button	
	* Advance payment
		And I click the button named "Advance"
		Then "Payment" window is opened
		And I click "4" button
		And I click "0" button
		And I click "0" button
		And I click the button named "Enter"
	* Select retail customer (cash advance)
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I click "OK" button	
	* Advance payment (card advance)
		And I click the button named "Advance"
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table	
		And I click "1" button
		And I click "0" button
		And I click "0" button
		And I click the button named "Enter"
	* Check cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Amount' | 'Transaction type'        |
			| '400,00' | 'Retail customer advance' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Pos cash account 1"
		Then the form attribute named "TransactionType" became equal to "Retail customer advance"
		And "PaymentList" table became equal
			| '#'   | 'Retail customer'   | 'Total amount'    |
			| '1'   | 'Daniel Smith'      | '400,00'          |
		Then the form attribute named "Branch" became equal to "Shop 02"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "400,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Check bank receipt  
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Amount' | 'Transaction type'        |
			| '100,00' | 'Retail customer advance' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Transit Main"
		Then the form attribute named "TransactionType" became equal to "Retail customer advance"
		And "PaymentList" table became equal
			| '#'   | 'Retail customer'   | 'Total amount'    |
			| '1'   | 'Daniel Smith'      | '100,00'          |
		Then the form attribute named "Branch" became equal to "Shop 02"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "100,00"
		And I close all client application windows
	* Create RSR and check using advance 
		And In the command interface I select "Retail" "Point of sale"
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, XS/Blue'    |
		And I select current line in "ItemsPickup" table
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I click "OK" button	
		And I click "Payment (+)" button
		And "Payments" table became equal
			| 'Payment type'   | 'Amount'    |
			| 'Advance'        | '500,00'    |
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table	
		And "Payments" table became equal
			| 'Payment type'   | 'Amount'    |
			| 'Advance'        | '500,00'    |
			| 'Card 01'        | '20,00'     |
		And I click the button named "Enter"
		And Delay 2
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'         |
			| '520,00'    |
		And I select current line in "List" table
		And I move to "Payments" tab	
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Bank term'      | 'Account'        | 'Percent'    |
			| '1'   | '500,00'   | ''             | 'Advance'        | ''                   | ''               | ''               | ''           |
			| '2'   | '20,00'    | '0,20'         | 'Card 01'        | ''                   | 'Bank term 02'   | 'Transit Main'   | '1,00'       |
		And I close all client application windows
		
				
Scenario: _0260137 return advance payment (cash)	
	And I close all client application windows
	* Create Cash payment (customer advance)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"	
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Retail customer advance" exact value from "Transaction type" drop-down list
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Retail customer" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Retail customer" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click "Post" button
	* Check creation
		And I delete "$$NumberCashPayment1$$" variable
		And I delete "$$CashPayment1$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment1$$"
		And I save the window as "$$CashPayment1$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberCashPayment1$$'    |
		And I close all client application windows		
								
				
	
Scenario: _0260138 return advance payment (card)	
	And I close all client application windows
	* Create Bank payment (customer advance)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"	
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Retail customer advance" exact value from "Transaction type" drop-down list
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Retail customer" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Retail customer" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click choice button of "Payment type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "PaymentList" table
		And I click choice button of "Payment terminal" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Payment terminal 01'    |
		And I select current line in "List" table
		And I activate "Bank term" field in "PaymentList" table
		And I click choice button of "Bank term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Bank term 02'    |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table	
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 02'        |
		And I select current line in "List" table	
		And I click "Post" button
	* Check creation
		And I delete "$$NumberBankPayment1$$" variable
		And I delete "$$BankPayment1$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment1$$"
		And I save the window as "$$BankPayment1$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberBankPayment1$$'    |
		And I close all client application windows				
						
Scenario: _02601381 create advance return from POS
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer (cash advance)
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I click "OK" button	
	* Return advance payment
		And I click the button named "Return"
		And I click the button named "Advance"
		Then the form attribute named "Advance" became equal to "400"
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table	
		And I click "7" button
		And I click "7" button
		And I click "Cash (/)" button
		And I click "3" button
		And I click "3" button
		And I click the button named "Enter"
	* Check
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And "List" table contains lines
			| 'Amount'    |
			| '77,00'     |
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And "List" table contains lines
			| 'Amount'    |
			| '33,00'     |
		And I close all client application windows
		
				

Scenario: _0260139 create RRR from POS (first select basis document)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
		And I click the button named "Return"
	* Select basis document for retail return
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Retail sales receipt'                                |
			| 'Retail sales receipt 3 dated 21.08.2022 10:00:00'    |
		And I select current line in "List" table
	* Check payments type
		And "BasisPayments" table became equal
			| 'Payment type'   | 'Amount'      |
			| 'Cash'           | '1 040,00'    |
			| 'Card 01'        | '550,00'      |
	* Check filling items from retail sales receipt
		And "ItemList" table became equal
			| 'Item'                 | 'Sales person'   | 'Item key'   | 'Serials'      | 'Price'    | 'Quantity'   | 'Offers'   | 'Total'       |
			| 'Dress'                | ''               | 'XS/Blue'    | ''             | '520,00'   | '2,000'      | ''         | '1 040,00'    |
			| 'Shirt'                | ''               | '38/Black'   | ''             | '350,00'   | '1,000'      | ''         | '350,00'      |
			| 'Product 1 with SLN'   | ''               | 'ODS'        | '9090098908'   | '100,00'   | '2,000'      | ''         | '200,00'      |
	* Delete unnecessary lines and change quantity
		And I go to line in "ItemList" table
			| 'Item'     |
			| 'Shirt'    |
		And I delete a line in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Price'    | 'Quantity'   | 'Total'       |
			| 'Dress'   | 'XS/Blue'    | '520,00'   | '2,000'      | '1 040,00'    |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post return
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click the button named "Enter"
	* Check return document
		And I close current window
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '720,00'    |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Daniel Smith"
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'                               | 'Item'                 | 'Sales person'   | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Return reason'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Revenue type'   | 'Detail'   | 'VAT'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | 'Retail sales receipt 3 dated 21.08.2022 10:00:00'   | 'Dress'                | ''               | 'XS/Blue'    | 'Shop 02'              | 'No'                   | ''                     | 'pcs'    | '79,32'        | ''                | ''                    | '1,000'      | '520,00'   | '440,68'       | '520,00'         | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
			| '2'   | 'Retail sales receipt 3 dated 21.08.2022 10:00:00'   | 'Product 1 with SLN'   | ''               | 'ODS'        | 'Shop 02'              | 'No'                   | '9090098908'           | 'pcs'    | '30,51'        | ''                | ''                    | '2,000'      | '100,00'   | '169,49'       | '200,00'         | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
		
		Then the number of "SpecialOffers" table lines is "равно" 0
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'   | 'Account'              | 'Percent'    |
			| '1'   | '720,00'   | ''             | 'Cash'           | ''                   | 'No'                  | ''            | 'Pos cash account 1'   | ''           |
		And in the table "ItemList" I click "Open serial lot number tree" button
		And "SerialLotNumbersTree" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot number'   | 'Item key quantity'   | 'Quantity'    |
			| 'Product 1 with SLN'   | 'ODS'        | ''                    | '2,000'               | '2,000'       |
			| ''                     | ''           | '9090098908'          | ''                    | '2,000'       |
		And I close "Serial lot numbers tree" window	
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "610,17"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "109,83"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "720,00"
	And I close all client application windows
	
			
Scenario: _02601391 create RRR from POS (first select basis document, different workstation)	
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
		And I click the button named "Return"
	* Select basis document for retail return
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Retail sales receipt'                                |
			| 'Retail sales receipt 6 dated 21.08.2022 11:21:19'    |
		And I select current line in "List" table
	* Check payment info
		And "BasisPayments" table became equal
			| 'Payment type'   | 'Amount'    |
			| 'Card 01'        | '750,00'    |
	* Check item tab
		And "ItemList" table became equal
			| 'Item'                 | 'Sales person'   | 'Item key'   | 'Serials'          | 'Price'    | 'Quantity'   | 'Offers'   | 'Total'     |
			| 'Shirt'                | ''               | '38/Black'   | ''                 | '350,00'   | '1,000'      | ''         | '350,00'    |
			| 'Product 1 with SLN'   | ''               | 'ODS'        | '9090098908'       | '100,00'   | '2,000'      | ''         | '200,00'    |
			| 'Product 3 with SLN'   | ''               | 'UNIQ'       | '09987897977891'   | '200,00'   | '1,000'      | ''         | '200,00'    |
	* Post return
		And I click "Payment Return" button		
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table	
		And I click the button named "Enter"
	* Check return document
		And I close current window
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '750,00'    |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'                               | 'Item'                 | 'Sales person'   | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Return reason'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Revenue type'   | 'Detail'   | 'VAT'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | 'Retail sales receipt 6 dated 21.08.2022 11:21:19'   | 'Shirt'                | ''               | '38/Black'   | 'Shop 02'              | 'No'                   | ''                     | 'pcs'    | '53,39'        | ''                | ''                    | '1,000'      | '350,00'   | '296,61'       | '350,00'         | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
			| '2'   | 'Retail sales receipt 6 dated 21.08.2022 11:21:19'   | 'Product 1 with SLN'   | ''               | 'ODS'        | 'Shop 02'              | 'No'                   | '9090098908'           | 'pcs'    | '30,51'        | ''                | ''                    | '2,000'      | '100,00'   | '169,49'       | '200,00'         | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
			| '3'   | 'Retail sales receipt 6 dated 21.08.2022 11:21:19'   | 'Product 3 with SLN'   | ''               | 'UNIQ'       | 'Shop 02'              | 'No'                   | '09987897977891'       | 'pcs'    | '30,51'        | ''                | ''                    | '1,000'      | '200,00'   | '169,49'       | '200,00'         | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
		
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'      | 'Account'        | 'Percent'    |
			| '1'   | '750,00'   | ''             | 'Card 01'        | ''                   | 'No'                  | 'Bank term 02'   | 'Transit Main'   | '1,00'       |
		And in the table "ItemList" I click "Open serial lot number tree" button
		And "SerialLotNumbersTree" table became equal
			| 'Item'                 | 'Item key'   | 'Serial lot number'   | 'Item key quantity'   | 'Quantity'    |
			| 'Product 1 with SLN'   | 'ODS'        | ''                    | '2,000'               | '2,000'       |
			| ''                     | ''           | '9090098908'          | ''                    | '2,000'       |
			| 'Product 3 with SLN'   | 'UNIQ'       | ''                    | '1,000'               | '1,000'       |
			| ''                     | ''           | '09987897977891'      | ''                    | '1,000'       |
		And I close "Serial lot numbers tree" window	
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "635,59"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "114,41"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "750,00"
	And I close all client application windows
	
Scenario: _0260140 create RRR from POS (add items than select basis document)	
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select items
		And I move to the tab named "ButtonPage"
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I move to "Items" tab	
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, L/Green'    |
		And I select current line in "ItemsPickup" table
		And I move to the tab named "ButtonPage"
		And I click the button named "Return"		
		And I click Select button of "Retail sales receipt (basis)" field
	* Select basis document
		And I go to line in "List" table
			| 'Retail sales receipt'         |
			| '$$RetailSalesReceiptNew$$'    |
		And I select current line in "List" table
	* Check item and payment tabs
		And "ItemList" table became equal
			| 'Item'    | 'Sales person'   | 'Item key'   | 'Serials'   | 'Price'    | 'Quantity'   | 'Offers'   | 'Total'       |
			| 'Dress'   | ''               | 'XS/Blue'    | ''          | '520,00'   | '2,000'      | ''         | '1 040,00'    |
		And "BasisPayments" table became equal
			| 'Payment type'   | 'Amount'      |
			| 'Card 02'        | '1 590,00'    |
	* Post return
		And I click "Payment Return" button		
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table	
		And I click the button named "Enter"
	* Check return document
		And I close current window
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'      |
			| '1 040,00'    |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to ""
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'        | 'Item'    | 'Sales person'   | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Return reason'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Revenue type'   | 'Detail'   | 'VAT'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | '$$RetailSalesReceiptNew$$'   | 'Dress'   | ''               | 'XS/Blue'    | 'Shop 02'              | 'No'                   | ''                     | 'pcs'    | '158,64'       | ''                | ''                    | '2,000'      | '520,00'   | '881,36'       | '1 040,00'       | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
		Then the number of "SpecialOffers" table lines is "равно" 0
		And "Payments" table became equal
			| '#'   | 'Amount'     | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'      | 'Account'        | 'Percent'    |
			| '1'   | '1 040,00'   | ''             | 'Card 01'        | ''                   | 'No'                  | 'Bank term 02'   | 'Transit Main'   | '1,00'       |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "881,36"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "158,64"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 040,00"
	And I close all client application windows
	
				
Scenario: _0260141 return from POS (without basis document)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select items
		And I move to the tab named "ButtonPage"
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I move to "Items" tab	
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                      |
			| '(10001) Dress, L/Green'    |
		And I select current line in "ItemsPickup" table
		And I move to the tab named "ButtonPage"
		And I click the button named "Return"		
	* Post return
		And I click "Payment Return" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 01'      |
		And I select current line in "BankPaymentTypeList" table	
		Then "Payment" window is opened
		And I click "1" button
		And I click "0" button
		And I click "0" button
		And I click "0" button
		And I click "Cash (/)" button
		And "Payments" table became equal
			| 'Payment type'   | 'Amount'      |
			| 'Card 01'        | '1 000,00'    |
			| 'Cash'           | '70,00'       |
		And I click the button named "Enter"
	* Check return document
		And I close current window
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'      |
			| '1 070,00'    |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales2$$"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Retail sales receipt'   | 'Item'    | 'Sales person'   | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Unit'   | 'Tax amount'   | 'Return reason'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Revenue type'   | 'Detail'   | 'VAT'   | 'Offers amount'   | 'Landed cost'    |
			| '1'   | ''                       | 'Dress'   | ''               | 'XS/Blue'    | ''                     | 'No'                   | ''                     | 'pcs'    | '79,32'        | ''                | ''                    | '1,000'      | '520,00'   | '440,68'       | '520,00'         | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
			| '2'   | ''                       | 'Dress'   | ''               | 'L/Green'    | ''                     | 'No'                   | ''                     | 'pcs'    | '83,90'        | ''                | ''                    | '1,000'      | '550,00'   | '466,10'       | '550,00'         | ''                      | 'Store 01'   | ''               | ''         | '18%'   | ''                | ''               |
		
		Then the number of "SpecialOffers" table lines is "равно" 0
		And "Payments" table became equal
			| '#'   | 'Amount'     | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'      | 'Account'              | 'Percent'    |
			| '1'   | '1 000,00'   | ''             | 'Card 01'        | ''                   | 'No'                  | 'Bank term 02'   | 'Transit Main'         | '1,00'       |
			| '2'   | '70,00'      | ''             | 'Cash'           | ''                   | 'No'                  | ''               | 'Pos cash account 1'   | ''           |
		
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "906,78"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "163,22"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 070,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	And I close all client application windows
	
						
Scenario: _0260142 filters in the Retail sales receipt (basis) form (POS)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Check filters by retail customer
		And I move to the tab named "ButtonPage"
		And I click the button named "Return"
		Then "Point of sales: Return" window is opened
		And I click Select button of "Retail sales receipt (basis)" field
		Then "Selection retail basis for return" window is opened
		And I select from the drop-down list named "RetailCustomer" by "da" string
		And "List" table contains lines
			| 'Retail sales receipt'                               | 'Amount'     | 'Date'                  | 'Fiscal data'   | 'Retail customer'    |
			| 'Retail sales receipt 5 dated 21.08.2022 11:00:00'   | '550,00'     | '21.08.2022 11:00:00'   | ''              | 'Daniel Smith'       |
			| 'Retail sales receipt 3 dated 21.08.2022 10:00:00'   | '1 590,00'   | '21.08.2022 10:00:00'   | ''              | 'Daniel Smith'       |
		Then the number of "List" table lines is "равно" "3"	
	* Check filters by item key
		And I click Clear button of the field named "RetailCustomer"
		And I select from the drop-down list named "ItemKey" by "ods" string
		And I click Clear button of the field named "ItemKey"
		And I select from the drop-down list named "ItemKey" by "blue" string
		And "List" table does not contain lines
			| 'Retail sales receipt'                                |
			| 'Retail sales receipt 4 dated 21.08.2022 10:20:00'    |
			| 'Retail sales receipt 5 dated 21.08.2022 11:00:00'    |
			| 'Retail sales receipt 7 dated 21.08.2022 11:23:34'    |
	* Button choose
		And I go to line in "List" table
			| 'Retail sales receipt'                                |
			| 'Retail sales receipt 3 dated 21.08.2022 10:00:00'    |
		And I click "Choose" button
		And "ItemList" table became equal
			| 'Item'    | 'Sales person'   | 'Item key'   | 'Serials'   | 'Price'    | 'Quantity'   | 'Offers'   | 'Total'     |
			| 'Dress'   | ''               | 'XS/Blue'    | ''          | '520,00'   | '1,000'      | ''         | '520,00'    |
			| 'Shirt'   | ''               | '38/Black'   | ''          | '350,00'   | '1,000'      | ''         | '350,00'    |
		And I delete a line in "ItemList" table
		And I delete a line in "ItemList" table
		And I close all client application windows
		
							
Scenario: _0260135 close session and check Consolidated retail sales filling	
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"
	* Close session
		And I click "Close session" button
		* Filling cash part
			And "CashTable" table became equal
				| 'Operation'    | 'Payment type'    | 'In Base'     | 'In Register'     |
				| 'Sales'        | 'Cash'            | '7 550,00'    | ''                |
				| 'Returns'      | 'Cash'            | '2 900,00'    | ''                |
			And I go to line in "CashTable" table
				| 'Operation'    | 'Payment type'    | 'In Base'     | 'In Register'     |
				| 'Returns'      | 'Cash'            | '2 900,00'    | ''                |
			And I select current line in "CashTable" table
			And I input "2 900,02" text in "In Register" field of "CashTable" table
			And I finish line editing in "CashTable" table
			And I go to line in "CashTable" table
				| 'In Base'     | 'Operation'    | 'Payment type'     |
				| '7 550,00'    | 'Sales'        | 'Cash'             |
			And I select current line in "CashTable" table
			And I input "7 550,00" text in "In Register" field of "CashTable" table
			And I finish line editing in "CashTable" table
			And I go to line in "CashTable" table
				| 'In Base'     | 'In Register'    | 'Operation'    | 'Payment type'     |
				| '2 900,00'    | '2 900,02'       | 'Returns'      | 'Cash'             |
			And I set checkbox named "CashConfirm"
		* Filling card part		
			Then "Terminals: Session closing" window is opened
			And I go to line in "TerminalTable" table
				| 'In Base'     | 'Operation'    | 'Payment type'     |
				| '4 770,00'    | 'Sales'        | 'Card 02'          |
			And I activate "In Terminal" field in "TerminalTable" table
			And I select current line in "TerminalTable" table
			And I input "4 770,00" text in "In Terminal" field of "TerminalTable" table
			And I finish line editing in "TerminalTable" table
			And I go to line in "TerminalTable" table
				| 'In Base'     | 'Operation'    | 'Payment type'     |
				| '3 200,00'    | 'Sales'        | 'Card 01'          |
			And I select current line in "TerminalTable" table
			And I input "3 200,00" text in "In Terminal" field of "TerminalTable" table
			And I finish line editing in "TerminalTable" table
			And I go to line in "TerminalTable" table
				| 'In Base'    | 'Operation'    | 'Payment type'     |
				| '550,00'     | 'Returns'      | 'Card 02'          |
			And I select current line in "TerminalTable" table
			And I input "550,00" text in "In Terminal" field of "TerminalTable" table
			And I finish line editing in "TerminalTable" table	
		* Check balance
			Then the form attribute named "Workstation" became equal to "Workstation 01"
			Then the form attribute named "CashAccount" became equal to "Pos cash account 1"
			And the editing text of form attribute named "BalanceBeginning" became equal to "1 440,00"
			And the editing text of form attribute named "BalanceIncoming" became equal to "8 950,00"
			And the editing text of form attribute named "BalanceOutcoming" became equal to "6 413,00"
			And the editing text of form attribute named "BalanceEnd" became equal to "3 977,00"
			And the editing text of form attribute named "BalanceReal" became equal to "0,00"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Branch" became equal to "Shop 02"
		* Filling real cash and close session
			And I input "4 000,00" text in "Real cash" field
			And I move to the next attribute
			And I click "Close session" button						
	* Check filling Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account'         | 'Status'   | 'Opening date'       |
			| 'Pos cash account 1'   | 'Close'    | '$$OpeningDate$$'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Pos cash account 1"
		Then the form attribute named "Status" became equal to "Close"
		And "Documents" table contains lines
			| 'Document'                     | 'Company'        | 'Amount'   | 'Branch'    | 'Currency'   | 'Author'    |
			| '$$RetailSalesReceiptNew$$'    | 'Main Company'   | '1 590'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '3 180'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '3 180'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '2 110'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '5 440'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '$$RetailReturnReceiptNew$$'   | 'Main Company'   | '-550'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-520'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-550'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '$$RetailReturnReceiptOld$$'   | 'Main Company'   | '-1 040'   | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '5 750'    | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '520'      | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-720'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-750'     | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-1 040'   | 'Shop 02'   | 'TRY'        | 'CI'        |
			| '*'                            | 'Main Company'   | '-1 070'   | 'Shop 02'   | 'TRY'        | 'CI'        |
		Then the number of "Documents" table lines is "equal" "23"
		Then the form attribute named "Branch" became equal to "Shop 02"
		And the editing text of form attribute named "BalanceEnd" became equal to "3 977,00"
		And the editing text of form attribute named "BalanceReal" became equal to "4 000,00"
		And "PaymentList" table became equal
			| '#'   | 'Amount'     | 'Is return'   | 'Payment type'   | 'Payment terminal'   | 'Real amount'    |
			| '1'   | '7 550,00'   | 'No'          | 'Cash'           | ''                   | '7 550,00'       |
			| '2'   | '2 900,00'   | 'Yes'         | 'Cash'           | ''                   | '2 900,02'       |
			| '3'   | '3 200,00'   | 'No'          | 'Card 01'        | ''                   | '3 200,00'       |
			| '4'   | '4 770,00'   | 'No'          | 'Card 02'        | ''                   | '4 770,00'       |
			| '5'   | '2 790,00'   | 'Yes'         | 'Card 01'        | ''                   | ''               |
			| '6'   | '550,00'     | 'Yes'         | 'Card 02'        | ''                   | '550,00'         |
		And I delete "$$NumberConsolidatedRetailSales0260135$$" variable
		And I save the value of "Number" field as "$$NumberConsolidatedRetailSales0260135$$"
		And I close all client application windows	

Scenario: _0260137 check connection to Consolidated retail sales report "Related documents"
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
	And I go to line in "List" table
		| 'Number'                                   |
		| '$$NumberConsolidatedRetailSales0260135$$' |
	And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
	And Delay 1
	And "DocumentsTree" table contains lines
		| 'Presentation'           |
		| 'Cash receipt*'          |
		| 'Retail sales receipt*'  |
		| 'Retail return receipt*' |
		| 'Money transfer*'        |
		| 'Bank receipt*'          |
		| 'Cash payment*'          |
		| 'Bank payment*'          |
	And I close all client application windows
	


Scenario: _0260145 check block RSR form if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
		And I select current line in "List" table 
	* Check form
		* Header	
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Partner"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "LegalName"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Agreement"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Company"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "RetailCustomer"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Partner"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Workstation"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Branch"'     |
		* ItemList
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'XS/Blue'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Quantity" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Price" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Unit" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Price type" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
		And I close all client application windows
			

Scenario: _0260146 try unpost RSR if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
	* Try unpost
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			| 'Cannot unpost, document is closed by [ $$ConsolidatedRetailSales2$$ ]\n'    |
		And I close all client application windows
		
Scenario: _0260147 try mark for deletion RSR if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
	* Try mark for deletion
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			| 'Cannot set deletion mark, document is closed by [ $$ConsolidatedRetailSales2$$ ]\n'    |
		And I close all client application windows
			
Scenario: _0260148 post RSR if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
	* Post
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
		And I close all client application windows

Scenario: _0260150 check block RRR form if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'   | 'Number'    |
			| '550,00'   | '1'         |
		And I select current line in "List" table 
	* Check form
		* Header	
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Partner"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "LegalName"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Agreement"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Company"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "RetailCustomer"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Partner"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Workstation"'     |
			When I Check the steps for Exception
				| 'And I click Choice button of the field named "Branch"'     |
		* ItemList
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'L/Green'      |
			When I Check the steps for Exception
				| 'And I click choice button of "Item" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Item key" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Quantity" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Price" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Unit" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Price type" attribute in "ItemList" table'     |
			When I Check the steps for Exception
				| 'And I click choice button of "Store" attribute in "ItemList" table'     |
		And I close all client application windows
		

Scenario: _0260152 try unpost RRR if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '550,00'    |
	* Try unpost
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			| 'Cannot unpost, document is closed by [ $$ConsolidatedRetailSales2$$ ]\n'    |
		And I close all client application windows
		
Scenario: _0260153 try mark for deletion RRR if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '550,00'    |
	* Try mark for deletion
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			| 'Cannot set deletion mark, document is closed by [ $$ConsolidatedRetailSales2$$ ]\n'    |
		And I close all client application windows					
				
Scenario: _0260154 post RRR if Consolidated retail sales is closed
	And I close all client application windows	
	* Select RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '550,00'    |
	* Post
		And in the table "List" I click the button named "ListContextMenuPost"
		Then user message window does not contain messages
		And I close all client application windows
		
				


Scenario: _0260160 check RSR changing if Consolidated retail sales is unpost
	And I close all client application windows	
	* Unpost Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account'         | 'Status'   | 'Opening date'       |
			| 'Pos cash account 1'   | 'Close'    | '$$OpeningDate$$'    |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
	* Try change RSR
		* Select RSR
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I go to line in "List" table
				| 'Amount'            |
				| '1 590,00'     |
			And I select current line in "List" table 
		* Header	
			And I click "Decoration group title collapsed picture" hyperlink		
			And I click Choice button of the field named "Partner"
			And I close current window	
			And I click Choice button of the field named "LegalName"	
			And I close current window
			And I click Choice button of the field named "Agreement"
			And I close current window	
			And I click Choice button of the field named "Company"
			And I close current window
			And I click Choice button of the field named "RetailCustomer"
			And I close current window
			And I click Choice button of the field named "Partner"
			And I close current window
			And I click Choice button of the field named "Workstation"
			And I close current window
			And I click Choice button of the field named "Branch"
			And I close current window
		* ItemList
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'L/Green'      |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
			And I click choice button of "Unit" attribute in "ItemList" table
			And I close current window
			And I click choice button of "Price type" attribute in "ItemList" table
			And I close current window	
			And I click choice button of "Store" attribute in "ItemList" table	
			And I close current window	
		

Scenario: _0260162 check RRR changing if Consolidated retail sales is unpost
	And I close all client application windows	
	* Unpost Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account'         | 'Status'   | 'Opening date'       |
			| 'Pos cash account 1'   | 'Close'    | '$$OpeningDate$$'    |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
	* Try change RRR
		* Select RRR
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
			And I go to line in "List" table
				| 'Amount'    | 'Number'     |
				| '550,00'    | '1'          |
			And I select current line in "List" table 
		* Header	
			And I click "Decoration group title collapsed picture" hyperlink		
			And I click Choice button of the field named "Partner"
			And I close current window	
			And I click Choice button of the field named "LegalName"	
			And I close current window
			And I click Choice button of the field named "Agreement"
			And I close current window	
			And I click Choice button of the field named "Company"
			And I close current window
			And I click Choice button of the field named "RetailCustomer"
			And I close current window
			And I click Choice button of the field named "Partner"
			And I close current window
			And I click Choice button of the field named "Workstation"
			And I close current window
			And I click Choice button of the field named "Branch"
			And I close current window
		* ItemList
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'     |
				| 'Dress'    | 'L/Green'      |
			And I click choice button of "Item" attribute in "ItemList" table
			And I close current window
			And I click choice button of "Item key" attribute in "ItemList" table
			And I close current window
			And I click choice button of "Unit" attribute in "ItemList" table
			And I close current window
			And I click choice button of "Store" attribute in "ItemList" table	
			And I close current window						
					
Scenario: _0260165 check RSR unpost and deletion mark if Consolidated retail sales is unpost
		And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
	* Unpost
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows
			
Scenario: _0260166 check RSR deletion mark if Consolidated retail sales is unpost
		And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'           |
			| '1 590,00'    |
	* Unpost
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And the current row in "List" table is marked for deletion
		And I close all client application windows
		
			
Scenario: _0260168 check RRR unpost and deletion mark if Consolidated retail sales is unpost
		And I close all client application windows
	* Select RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '550,00'    |
	* Unpost
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I close all client application windows
			
Scenario: _0260169 check RRR deletion mark if Consolidated retail sales is unpost
		And I close all client application windows
	* Select RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '550,00'    |
	* Unpost
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And the current row in "List" table is marked for deletion
		Then user message window does not contain messages
		And I close all client application windows	
				
Scenario: _0260170 check filling payment agent in RSR
	And I close all client application windows
	* Open RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check filling bank term (payment agent)
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bank credit' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button		
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'     | 'Account' | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | ''       | ''           | 'Bank credit'  | ''                        | ''                                  | ''                 | 'Payment agent' | ''        | '10,00'   | ''         | 'Bank 1'                | 'Bank 1'                   | 'Bank 1'                      |
	* Change payment type - card 01
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button		
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'    | 'Account'      | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | ''       | ''           | 'Card 01'      | ''                        | ''                                  | ''                 | 'Bank term 02' | 'Transit Main' | '1,00'    | ''         | ''                      | ''                         | ''                            |
	And I close all client application windows
		
				
				
Scenario: _0260171 check filling payment agent in RRR
	And I close all client application windows
	* Open RSR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling bank term (payment agent)
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bank credit' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button	
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'     | 'Account' | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | ''       | ''           | 'Bank credit'  | ''                        | ''                                  | ''                 | 'Payment agent' | ''        | '10,00'   | ''         | 'Bank 1'                | 'Bank 1'                   | 'Bank 1'                      |
	* Check filter by bank term
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button		
		And I finish line editing in "Payments" table
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'    | 'Account'      | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | ''       | ''           | 'Card 01'      | ''                        | ''                                  | ''                 | 'Bank term 02' | 'Transit Main' | '1,00'    | ''         | ''                      | ''                         | ''                            |
	And I close all client application windows					
		
Scenario: _0260172 check filling Account from Workstation when select payment type - cash (RSR)
	And I close all client application windows
	* Open RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling payment type
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I select "cash" from "Payment type" drop-down list by string in "Payments" table
	* Check
		And "Payments" table contains lines
			| 'Payment type' | 'Account'            |
			| 'Cash'         | 'Pos cash account 1' |
	* Change payment type - card 01
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term'    | 'Account'      | 'Percent' |
			| 'Card 01'      | 'Bank term 02' | 'Transit Main' | '1,00'    |
	* Change payment type - Bank credit		
		And I select current line in "Payments" table
		And I select "Bank credit" from "Payment type" drop-down list by string in "Payments" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term'     | 'Account'      | 'Percent' |
			| 'Bank credit'  | 'Payment agent' | 'Transit Main' | '10,00'   |
	* Change payment type - card 01
		And I select current line in "Payments" table
		And I select "card 01" from "Payment type" drop-down list by string in "Payments" table	
		Then "Update item list info" window is opened
		And I click "OK" button	
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term'    | 'Account'      | 'Percent' |
			| 'Card 01'      | 'Bank term 02' | 'Transit Main' | '1,00'    |
	* Change payment type - cash
		And I select current line in "Payments" table
		And I select "cash" from "Payment type" drop-down list by string in "Payments" table				
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term' | 'Account'            | 'Percent' |
			| 'Cash'         | ''          | 'Pos cash account 1' | ''        |
		
Scenario: _0260173 check filling Account from Workstation when select payment type - cash (RRR)
	And I close all client application windows
	* Open RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Filling payment type
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I select "cash" from "Payment type" drop-down list by string in "Payments" table
	* Check
		And "Payments" table contains lines
			| 'Payment type' | 'Account'            |
			| 'Cash'         | 'Pos cash account 1' |				
	* Change payment type - card 01
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term'    | 'Account'      | 'Percent' |
			| 'Card 01'      | 'Bank term 02' | 'Transit Main' | '1,00'    |
	* Change payment type - Bank credit		
		And I select current line in "Payments" table
		And I select "Bank credit" from "Payment type" drop-down list by string in "Payments" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term'     | 'Account'      | 'Percent' |
			| 'Bank credit'  | 'Payment agent' | 'Transit Main' | '10,00'   |
	* Change payment type - card 01
		And I select current line in "Payments" table
		And I select "card 01" from "Payment type" drop-down list by string in "Payments" table	
		Then "Update item list info" window is opened
		And I click "OK" button	
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term'    | 'Account'      | 'Percent' |
			| 'Card 01'      | 'Bank term 02' | 'Transit Main' | '1,00'    |
	* Change payment type - cash
		And I select current line in "Payments" table
		And I select "cash" from "Payment type" drop-down list by string in "Payments" table				
		And "Payments" table contains lines
			| 'Payment type' | 'Bank term' | 'Account'            | 'Percent' |
			| 'Cash'         | ''          | 'Pos cash account 1' | ''        |					

Scenario: _0260180 create document Visitor counter	
	And I close all client application windows
	* Open document Visitor counter
		Given I open hyperlink "e1cib/list/Document.VisitorCounter"
		And I click the button named "FormCreate"
	* Filling main attributes
		And I select from the drop-down list named "Company" by "main" string
		And I move to the next attribute
		And I select from the drop-down list named "Store" by "store" string
		And I move to the next attribute
		And in the table "CounterData" I click the button named "CounterDataAdd"
		And I input "18:00:00" text in "Time" field of "CounterData" table
		And I activate "In" field in "CounterData" table
		And I input "1" text in "In" field of "CounterData" table
		And I activate "Out" field in "CounterData" table
		And I input "2" text in "Out" field of "CounterData" table
		And I finish line editing in "CounterData" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I click "Post" button
		And I save the value of the field named "Number" as "NumberVisitorCounter"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                 |
			| '$NumberVisitorCounter$' |
	And I close all client application windows
		
				
					
				
		
				
						
				
				

				

			
			
					

		
				
		
				
		
				
		
						
	
		
				
		
						
		
				
		
				
		
		
		
				
		
				

	

		
				

