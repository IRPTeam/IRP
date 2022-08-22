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
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog BusinessUnits objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
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
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog Users objects
		When update ItemKeys
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail)
		When Create catalog ExpenseAndRevenueTypes objects
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
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
		When create Workstation
	* Retail documents
		When Create document RSR, RRR with ConsolidatedRetailSales
		And I execute 1C:Enterprise script at server
			| "Documents.ConsolidatedRetailSales.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |


Scenario: _0260101 check preparation
	When check preparation

Scenario: _0260105 open session
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	And I click "Open session" button
	And I move to "Session" tab
	* Check
		Then the field named "ConsolidatedRetailSales" is filled
		And I delete "$$ConsolidatedRetailSales$$" variable
		And I save the value of the field named "ConsolidatedRetailSales" as "$$ConsolidatedRetailSales$$"
	And I close all client application windows

Scenario: _0260107 create RSR and check Consolidated retail sales filling
	* Check preparation
		Try
			And the previous scenario executed successfully
		Except
			Then I stop the execution of scripts for this feature
		And I close all client application windows
	* Open POS and create RSR (card)
		And In the command interface I select "Retail" "Point of sale"
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'           |
			| 'Dress, L/Green' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Total'  |
			| 'Dress' | 'XS/Blue'  | '520,00' | '1,000'    | '520,00' |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		And I click "Card (*)" button
		Then "Payment types" window is opened
		And I click the hyperlink named "Page_0"
		And I click the button named "Enter"
	* Check filling field Consolidated retail sales and workstation in the RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Σ'        |
			| '1 590,00' |	
		And I select current line in "List" table
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales$$"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		And I delete "$$RetailSalesReceiptNew$$" variable
		And I save the window as "$$RetailSalesReceiptNew$$" 
		And I close current window
	* Check filling Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account' | 'Status' |
			| 'Cash desk №2' | 'Open'   |	
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "Status" became equal to "Open"
		And "Documents" table became equal
			| 'Document'                  | 'Company'      | 'Amount' | 'Branch'  | 'Currency' | 'Author' |
			| '$$RetailSalesReceiptNew$$' | 'Main Company' | '1 590'  | 'Shop 02' | 'TRY'      | 'CI'     |
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Author" became equal to "CI"
		And I delete "$$OpeningDate$$" variable
		And I save the value of the field named "OpeningDate" as "$$OpeningDate$$"
		And I close all client application windows
		
		
Scenario: _0260111 create RRR day to day and check Consolidated retail sales filling							
	And I close all client application windows
	* Select RSR and create RRR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Σ'        |
			| '1 590,00' |	
		And I click "Sales return" button
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '520,00' | '2,000'    | 'Dress (XS/Blue)'  | 'pcs'  | 'Yes' |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check filling RRR
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ConsolidatedRetailSales" became equal to "$$ConsolidatedRetailSales$$"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'      | 'Item'  | 'Sales person' | 'Profit loss center' | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Return reason' | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' |
			| '1' | '$$RetailSalesReceiptNew$$' | 'Dress' | ''             | 'Shop 02'            | 'L/Green'  | 'No'                 | ''                   | 'pcs'  | '83,90'      | '1,000'    | '550,00' | '466,10'     | '550,00'       | ''                    | 'Store 01' | ''              | ''             | ''       | '18%' | ''              | ''            |
		And "Payments" table became equal
			| '#' | 'Amount'   | 'Commission' | 'Payment type' | 'Payment terminal' | 'Postponed payment' | 'Bank term'    | 'Account'        | 'Percent' |
			| '1' | '1 590,00' | '31,80'      | 'Card 02'      | ''                 | 'No'                | 'Bank term 02' | 'Transit Second' | '2,00'    |
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
			| 'Cash account' | 'Status' |
			| 'Cash desk №2' | 'Open'   |	
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "Status" became equal to "Open"
		And "Documents" table became equal
			| 'Document'                  | 'Company'      | 'Amount' | 'Branch'  | 'Currency' | 'Author' |
			| '$$RetailSalesReceiptNew$$' | 'Main Company' | '1 590'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '$$RetailReturnReceiptNew$$'| 'Main Company' | '-550'   | 'Shop 02' | 'TRY'      | 'CI'     |
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Author" became equal to "CI"
		And I close all client application windows			
		
				

Scenario: _0260115 create RRR prior periods and check Consolidated retail sales filling							
	And I close all client application windows
	* Select RSR and create RRR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Σ'        |
			| '1 040,00' |	
		And I click "Sales return" button
		And I click "Ok" button
	* Check filling RRR
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ConsolidatedRetailSales" became equal to ""
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt'                             | 'Item'  | 'Sales person' | 'Profit loss center' | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Return reason' | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' |
			| '1' | 'Retail sales receipt 2 dated 21.08.2022 22:47:54' | 'Dress' | ''             | 'Shop 02'            | 'XS/Blue'  | 'No'                 | ''                   | 'pcs'  | '158,64'     | '2,000'    | '520,00' | '881,36'     | '1 040,00'     | ''                    | 'Store 01' | ''              | ''             | ''       | '18%' | ''              | ''            |
		And "Payments" table became equal
			| '#' | 'Amount'   | 'Commission' | 'Payment type' | 'Payment terminal' | 'Postponed payment' | 'Bank term' | 'Account'      | 'Percent' |
			| '1' | '1 040,00' | ''           | 'Cash'         | ''                 | 'No'                | ''          | 'Cash desk №2' | ''        |		
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
			| 'Cash account' | 'Status' |
			| 'Cash desk №2' | 'Open'   |	
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "Status" became equal to "Open"
		And "Documents" table became equal
			| 'Document'                  | 'Company'      | 'Amount' | 'Branch'  | 'Currency' | 'Author' |
			| '$$RetailSalesReceiptNew$$' | 'Main Company' | '1 590'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '$$RetailReturnReceiptNew$$'| 'Main Company' | '-550'   | 'Shop 02' | 'TRY'      | 'CI'     |
		Then the number of "Documents" table lines is "equal" "2"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Author" became equal to "CI"
		And I close all client application windows
				
		
							
Scenario: _0260135 close session and check Consolidated retail sales filling	
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"
	* Close session
		And I move to "Session" tab
		And I click "Close session" button
		And I close all client application windows
	* Check filling Consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Cash account' | 'Status' | 'Opening date'    |
			| 'Cash desk №2' | 'Close'  | '$$OpeningDate$$' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "Status" became equal to "Close"
		And "Documents" table became equal
			| 'Document'                  | 'Company'      | 'Amount' | 'Branch'  | 'Currency' | 'Author' |
			| '$$RetailSalesReceiptNew$$' | 'Main Company' | '1 590'  | 'Shop 02' | 'TRY'      | 'CI'     |
			| '$$RetailReturnReceiptNew$$'| 'Main Company' | '-550'   | 'Shop 02' | 'TRY'      | 'CI'     |
		Then the number of "Documents" table lines is "equal" "2"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Author" became equal to "CI"
		And I close all client application windows		

				
				

		
				

			
					



		
		
				



	

		
				

