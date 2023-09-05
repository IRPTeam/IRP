#language: en
@tree
@Positive
@Retail

Feature: postponed retails receipts


Variables:
import "Variables.feature"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _0263100 preparation postponed retails receipts
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
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
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
		When Create catalog Users objects (change rights)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When update ItemKeys
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create Certificate
		When Create POS cash account objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
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
	* Delete CI from manager group
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| "Description" |
			| "CI"          |
		And I select current line in "List" table
		And I input "" text in "User group" field
		And I click "Save" button
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'             |
			| 'Disable - Change price' |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'              |
			| 'Disable - Create return' |
		And I select current line in "MetadataTree" table
		And I select "No" exact value from "Value" drop-down list in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And I click "Ok" button	
		And I click "Save and close" button	
	* Enable control code string for Product 6 with SLN and Product 1 with SLN
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b78db8d3fd6dff8b11ed7f8d992046ee"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
		And I click "Save and close" button		
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b7a0d8de1a1c04c611ee174b1c02bb67"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
		And I click "Save and close" button		
	* Create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		If "List" table does not contain lines Then
				| "Description"             |
				| "Payment terminal 01"     |
			And I click the button named "FormCreate"
			And I input "Payment terminal 01" text in the field named "Description_en"
			And I click "Save and close" button
	* Create PaymentTypes
		When Create catalog PaymentTypes objects
	* Bank terms
		When Create catalog BankTerms objects (for Shop 02)	
	* Check open consolidated retail sales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		If "List" table contains lines Then
				| "Status"   |
				| "Open"     | 
			And I go to line in "List" table
				| "Status"   |
				| "Open"     | 
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Close" exact value from the drop-down list named "Status"
			And I input current date in "Closing date" field			
			And I click "Post and close" button			
	* Workstation
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I select current line in "List" table
		* Postponed with reserve
			And I set checkbox "Postpone with reserve"
			And I set checkbox "Postpone without reserve"
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Open session
		And In the command interface I select "Retail" "Point of sale"
		And I click "Open session" button
	And I close all client application windows

Scenario: _0263101 check preparation
	When check preparation


Scenario: _0263102 create postponed RSR with a reservation and the use of CRS
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I click "OK" button	
	* Add items
		When add different items in POS
	* Postponed RSR with a reservation
		And I click "Postpone current receipt with reserve" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the field named "ConsolidatedRetailSales" is filled
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'                                                    | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'en description is empty' | 'Product 1 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '8908899877'         | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'en description is empty' | 'Product 6 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '57897909799'        | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'en description is empty' | 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | 'Shop 02'            | 'No'                 | '999999999'          | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Basic Price Types'       | 'Dress'                                                   | ''             | 'XS/Blue'  | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'en description is empty' | 'Service'                                                 | ''             | 'Rent'     | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed with reserve"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "779,68"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "140,32"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "920,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I delete "$$NumberPostponedRSR1$$" variable
		And I delete "$$PostponedRSR1$$" variable
		And I delete "$$DatePostponedRSR1$$" variable
		And I save the value of "Number" field as "$$NumberPostponedRSR1$$"
		And I save the window as "$$PostponedRSR1$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR1$$"
	* Check reservation
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRSR1$$'                   | ''            | ''                      | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'      | ''            | ''                      | ''          | ''           | ''         | ''                  |
			| 'Register  "R4012 Stock Reservation"' | ''            | ''                      | ''          | ''           | ''         | ''                  |
			| ''                                    | 'Record type' | 'Period'                | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                    | ''            | ''                      | 'Quantity'  | 'Store'      | 'Item key' | 'Order'             |
			| ''                                    | 'Receipt'     | '$$DatePostponedRSR1$$' | '1'         | 'Store 01'   | 'XS/Blue'  | '$$PostponedRSR1$$' |
			| ''                                    | 'Receipt'     | '$$DatePostponedRSR1$$' | '1'         | 'Store 01'   | 'PZU'      | '$$PostponedRSR1$$' |
			| ''                                    | 'Receipt'     | '$$DatePostponedRSR1$$' | '1'         | 'Store 01'   | 'PZU'      | '$$PostponedRSR1$$' |
			| ''                                    | 'Receipt'     | '$$DatePostponedRSR1$$' | '1'         | 'Store 01'   | 'ODS'      | '$$PostponedRSR1$$' |
		And I close all client application windows
		
			
				
Scenario: _0263103 create postponed RSR without a reservation and the use of CRS
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I move to the tab named "ButtonPage"
		And I click "Search customer" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Sam Jons'       |
		And I select current line in "List" table
		And I click "OK" button	
	* Add items
		When add different items in POS
	* Postponed RSR without a reservation
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to "Sam Jons"
		Then the field named "ConsolidatedRetailSales" is filled
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'                                                    | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'en description is empty' | 'Product 1 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '8908899877'         | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'en description is empty' | 'Product 6 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '57897909799'        | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'en description is empty' | 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | 'Shop 02'            | 'No'                 | '999999999'          | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Basic Price Types'       | 'Dress'                                                   | ''             | 'XS/Blue'  | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'en description is empty' | 'Service'                                                 | ''             | 'Rent'     | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "779,68"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "140,32"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "920,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I delete "$$NumberPostponedRSR2$$" variable
		And I delete "$$PostponedRSR2$$" variable
		And I delete "$$DatePostponedRSR1$$" variable
		And I save the value of "Number" field as "$$NumberPostponedRSR2$$"
		And I save the window as "$$PostponedRSR2$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR2$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR2$$"
	* Check 
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRSR2$$'              |
			| 'Document registrations records' |
		And I close current window



// Scenario: _0263104 try close session with deferred receipts
// 	And I close all client application windows
// 	* Open POS
// 		And In the command interface I select "Retail" "Point of sale"
// 	* Try close session
// 		And I click "Close session" button
// 	* Check postponed list form
// 		And "Receipts" table became equal
// 			| 'Type'         | 'Branch'  | 'Date'                | 'Amount' | 'Fiscal printer' | 'Company'      | 'Number' | 'Currency' | 'Retail customer' | 'Workstation'    | 'Consolidated retail sales' | 'Receipt'                                          | 'Author' | 'Status type'            |
// 			| 'Retail sales' | 'Shop 02' | '05.09.2023 16:00:59' | '920,00' | ''               | 'Main Company' | '1'      | 'TRY'      | 'Sam Jons'        | 'Workstation 01' | '*'                         | 'Retail sales receipt 1 dated 05.09.2023 16:00:59' | 'CI'     | 'Postponed with reserve' |
// 			| 'Retail sales' | 'Shop 02' | '05.09.2023 16:10:46' | '920,00' | ''               | 'Main Company' | '2'      | 'TRY'      | 'Sam Jons'        | 'Workstation 01' | '*'                         | 'Retail sales receipt 2 dated 05.09.2023 16:10:46' | 'CI'     | 'Postponed'              |
// 		And "ItemList" table became equal
// 			| 'Item'                                                    | 'Item key' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' |
// 			| 'Product 1 with SLN'                                      | 'PZU'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
// 			| 'Product 6 with SLN'                                      | 'PZU'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
// 			| 'Product 9 with SLN (control code string, without check)' | 'ODS'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
// 			| 'Dress'                                                   | 'XS/Blue'  | 'pcs'  | '79,32'      | '1,000'    | '520,00' | '440,68'     | '520,00'       |
// 			| 'Service'                                                 | 'Rent'     | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
		
				
								
		
				
				
		
		
				

