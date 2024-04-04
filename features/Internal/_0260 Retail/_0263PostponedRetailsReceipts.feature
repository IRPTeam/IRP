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
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create Certificate
		When Create POS cash account objects
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail)
		When Create catalog ExpenseAndRevenueTypes objects
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
		And I select "Marking code" exact value from "Control code string type" drop-down list
		And I click "Save and close" button		
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b7a0d8de1a1c04c611ee174b1c02bb67"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
		And I select "Marking code" exact value from "Control code string type" drop-down list
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


Scenario: _0263102 create postponed RSR with a reservation (CRS used)
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
		* Add one more Service
			And I click "Search by barcode (F7)" button
			And I input "89908" text in the field named "Barcode"
			And I move to the next attribute
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
			| '6' | 'en description is empty' | 'Service'                                                 | ''             | 'Rent'     | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |		
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed with reserve"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "864,43"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "155,57"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 020,00"
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
		
			
				
Scenario: _0263103 create postponed RSR without a reservation (CRS used)
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
		And I delete "$$DatePostponedRSR2$$" variable
		And I delete "$$ConsolidatedRetailSales1$$" variable
		And I save the value of "Number" field as "$$NumberPostponedRSR2$$"
		And I save the window as "$$PostponedRSR2$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR2$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR2$$"
		And I save the value of the field named "ConsolidatedRetailSales" as "$$ConsolidatedRetailSales1$$"
	* Check 
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRSR2$$'              |
			| 'Document registrations records' |
		And I close current window

		
Scenario: _0263104 create postponed RRR without a reservation and without bases (CRS used)
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
		And I click the button named "Return"		
	* Add items
		When add different items in POS
		* Product without SLN
			And I click "Search by barcode (F7)" button
			And I input "2202283705" text in the field named "Barcode"
			And I move to the next attribute
	* Postponed RSR without a reservation
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Check RSR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
			| '#' | 'Item'                                                    | 'Sales person' | 'Item key' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Revenue type' |
			| '1' | 'Product 1 with SLN'                                      | ''             | 'PZU'      | 'No'                 | '8908899877'         | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''             |
			| '2' | 'Product 6 with SLN'                                      | ''             | 'PZU'      | 'No'                 | '57897909799'        | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''             |
			| '3' | 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | 'No'                 | '999999999'          | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''             |
			| '4' | 'Dress'                                                   | ''             | 'XS/Blue'  | 'No'                 | ''                   | 'pcs'  | '158,64'     | ''                  | '2,000'    | '520,00' | '18%' | ''              | '881,36'     | '1 040,00'     | ''                    | 'Store 01' | ''       | ''             |
			| '5' | 'Service'                                                 | ''             | 'Rent'     | 'No'                 | ''                   | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''             |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "StatusType" became equal to "Postponed"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "1 220,36"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "219,64"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "1 440,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I delete "$$NumberPostponedRRR1$$" variable
		And I delete "$$PostponedRRR1$$" variable
		And I delete "$$DatePostponedRRR1$$" variable
		And I save the value of "Number" field as "$$NumberPostponedRRR1$$"
		And I save the window as "$$PostponedRRR1$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRRR1$$"
	* Check 
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRRR1$$'              |
			| 'Document registrations records' |
		And I close current window


Scenario: _0263104 postponed list form (POS)
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Open postponed list form
		And I click "Open postponed receipt" button
	* Check postponed list form
		And "Receipts" table became equal
			| 'Type'                 | 'Date'                  | 'Number'                  | 'Amount'   | 'Currency' | 'Retail customer' | 'Workstation'    | 'Fiscal printer' | 'Company'      | 'Consolidated retail sales'    | 'Branch'  | 'Author' | 'Status type'            | 'Receipt'           |
			| 'Retail sales'         | '$$DatePostponedRSR1$$' | '$$NumberPostponedRSR1$$' | '1 020,00' | 'TRY'      | 'Sam Jons'        | 'Workstation 01' | ''               | 'Main Company' | '$$ConsolidatedRetailSales1$$' | 'Shop 02' | 'CI'     | 'Postponed with reserve' | '$$PostponedRSR1$$' |
			| 'Retail sales'         | '$$DatePostponedRSR2$$' | '$$NumberPostponedRSR2$$' | '920,00'   | 'TRY'      | 'Sam Jons'        | 'Workstation 01' | ''               | 'Main Company' | '$$ConsolidatedRetailSales1$$' | 'Shop 02' | 'CI'     | 'Postponed'              | '$$PostponedRSR2$$' |
			| 'Return from customer' | '$$DatePostponedRRR1$$' | '$$NumberPostponedRRR1$$' | '1 440,00' | 'TRY'      | 'Sam Jons'        | 'Workstation 01' | ''               | 'Main Company' | '$$ConsolidatedRetailSales1$$' | 'Shop 02' | 'CI'     | 'Postponed'              | '$$PostponedRRR1$$' |
		And "ItemList" table became equal
			| 'Item'                                                    | 'Item key' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' |
			| 'Product 1 with SLN'                                      | 'PZU'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
			| 'Product 6 with SLN'                                      | 'PZU'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
			| 'Product 9 with SLN (control code string, without check)' | 'ODS'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
			| 'Dress'                                                   | 'XS/Blue'  | 'pcs'  | '79,32'      | '1,000'    | '520,00' | '440,68'     | '520,00'       |
			| 'Service'                                                 | 'Rent'     | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
			| 'Service'                                                 | 'Rent'     | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
		Then "Select postponed receipt" window is opened
		And I go to line in "Receipts" table
			| 'Number'                  |
			| '$$NumberPostponedRSR2$$' |
		And "ItemList" table became equal
			| 'Item'                                                    | 'Item key' | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' |
			| 'Product 1 with SLN'                                      | 'PZU'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
			| 'Product 6 with SLN'                                      | 'PZU'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
			| 'Product 9 with SLN (control code string, without check)' | 'ODS'      | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |
			| 'Dress'                                                   | 'XS/Blue'  | 'pcs'  | '79,32'      | '1,000'    | '520,00' | '440,68'     | '520,00'       |
			| 'Service'                                                 | 'Rent'     | 'pcs'  | '15,25'      | '1,000'    | '100,00' | '84,75'      | '100,00'       |	
		And I go to line in "Receipts" table
			| 'Number'                  |
			| '$$NumberPostponedRRR1$$' |	
		And "ItemList" table became equal
			| 'Item'                                                    | 'Item key' | 'Unit' | 'Quantity' | 'Price'  | 'Net amount' | 'Tax amount' | 'Total amount' |
			| 'Product 1 with SLN'                                      | 'PZU'      | 'pcs'  | '1,000'    | '100,00' | '84,75'      | '15,25'      | '100,00'       |
			| 'Product 6 with SLN'                                      | 'PZU'      | 'pcs'  | '1,000'    | '100,00' | '84,75'      | '15,25'      | '100,00'       |
			| 'Product 9 with SLN (control code string, without check)' | 'ODS'      | 'pcs'  | '1,000'    | '100,00' | '84,75'      | '15,25'      | '100,00'       |
			| 'Dress'                                                   | 'XS/Blue'  | 'pcs'  | '2,000'    | '520,00' | '881,36'     | '158,64'     | '1 040,00'     |
			| 'Service'                                                 | 'Rent'     | 'pcs'  | '1,000'    | '100,00' | '84,75'      | '15,25'      | '100,00'       |		
	* Select postponed receipt
		And I go to line in "Receipts" table
			| 'Number'                  |
			| '$$NumberPostponedRSR2$$' |
		And I click "Select" button
		And "ItemList" table became equal
			| 'Item'                                                    | 'Sales person' | 'Item key' | 'Serials'     | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Product 1 with SLN'                                      | ''             | 'PZU'      | '8908899877'  | '100,00' | '1,000'    | ''       | '100,00' |
			| 'Product 6 with SLN'                                      | ''             | 'PZU'      | '57897909799' | '100,00' | '1,000'    | ''       | '100,00' |
			| 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | '999999999'   | '100,00' | '1,000'    | ''       | '100,00' |
			| 'Dress'                                                   | ''             | 'XS/Blue'  | ''            | '520,00' | '1,000'    | ''       | '520,00' |
			| 'Service'                                                 | ''             | 'Rent'     | ''            | '100,00' | '1,000'    | ''       | '100,00' |
		// And I go to line in "ItemList" table
		// 	| 'Item'               |
		// 	| 'Product 6 with SLN' |
		// And I select current line in "ItemList" table
		// And I activate "Control code string state" field in "ItemList" table
		// And Delay 1
		// And I press keyboard shortcut "Enter"
		// And "CurrentCodes" table became equal
		// 	| 'Scanned codes'                                | 'Code is approved' | 'Not check' |
		// 	| 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0' | 'Yes'              | 'Yes'       |
		// And I close current window
		// And I go to line in "ItemList" table
		// 	| 'Item'               |
		// 	| 'Product 9 with SLN (control code string, without check)' |
		// And I select current line in "ItemList" table
		// And I press keyboard shortcut "Enter"
		// And "CurrentCodes" table became equal
		// 	| 'Scanned codes'                                | 'Code is approved' | 'Not check' |
		// 	| 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1' | 'Yes'              | 'Yes'       |
		// And I close current window
		And I click "Clear current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"


Scenario: _0263105 processing a postponed RSR with a reservation	
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Open postponed list form
		And I click "Open postponed receipt" button
	* Select postponed receipt
		And I go to line in "Receipts" table
			| 'Number'                  |
			| '$$NumberPostponedRSR1$$' |
		And I click "Select" button	
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberPostponedRSR1$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'                                                    | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'en description is empty' | 'Product 1 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '8908899877'         | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'en description is empty' | 'Product 6 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '57897909799'        | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'en description is empty' | 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | 'Shop 02'            | 'No'                 | '999999999'          | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Basic Price Types'       | 'Dress'                                                   | ''             | 'XS/Blue'  | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'en description is empty' | 'Service'                                                 | ''             | 'Rent'     | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '6' | 'en description is empty' | 'Service'                                                 | ''             | 'Rent'     | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |		
		Then the form attribute named "StatusType" became equal to "Completed"
		And "Payments" table contains lines
			| 'Amount'   | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'            | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '*'        | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Pos cash account 1' | ''        | ''         | ''                      | ''                         | ''                            |
		And I delete "$$PostponedRSR1$$" variable
		And I delete "$$DatePostponedRSR1$$" variable
		And I save the window as "$$PostponedRSR1$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR1$$"
	* Check stock reservation
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PostponedRSR1$$'              |
			| 'Document registrations records' |
		And I close current window
	
				

Scenario: _0263107 processing a postponed RSR without a reservation	
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Open postponed list form
		And I click "Open postponed receipt" button
	* Select postponed receipt
		And "Receipts" table does not contain lines
			| 'Number'                  | 'Receipt'           |
			| '$$NumberPostponedRSR1$$' | '$$PostponedRSR1$$' |
		And I go to line in "Receipts" table
			| 'Number'                  |
			| '$$NumberPostponedRSR2$$' |
		And I click "Select" button	
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberPostponedRSR2$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'                                                    | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'en description is empty' | 'Product 1 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '8908899877'         | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'en description is empty' | 'Product 6 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '57897909799'        | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'en description is empty' | 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | 'Shop 02'            | 'No'                 | '999999999'          | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Basic Price Types'       | 'Dress'                                                   | ''             | 'XS/Blue'  | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '79,32'      | ''                  | '1,000'    | '520,00' | '18%' | ''              | '440,68'     | '520,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'en description is empty' | 'Service'                                                 | ''             | 'Rent'     | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '15,25'      | ''                  | '1,000'    | '100,00' | '18%' | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		Then the form attribute named "StatusType" became equal to "Completed"
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'            | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '920,00' | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Pos cash account 1' | ''        | ''         | ''                      | ''                         | ''                            |
		And I delete "$$PostponedRSR2$$" variable
		And I delete "$$DatePostponedRSR2$$" variable
		And I save the window as "$$PostponedRSR2$$"
		And I save the value of the field named "Date" as  "$$DatePostponedRSR2$$"
	* Check movements
		And I click "Registrations report" button
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Register  "R2001 Sales"'             |
			| 'Register  "R2050 Retail sales"'      |
			| 'Register  "R3010 Cash on hand"'      |
			| 'Register  "R3011 Cash flow"'         |
			| 'Register  "R3050 Pos cash balances"' |
			| 'Register  "R4010 Actual stocks"'     |
			| 'Register  "R4011 Free stocks"'       |
		And I close current window				
		
				
			
Scenario: _0263106 processing a postponed RRR
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Open postponed list form
		And I click "Open postponed receipt" button
	* Select postponed receipt
		And I go to line in "Receipts" table
			| 'Number'                  |
			| '$$NumberPostponedRRR1$$' |
		And I click "Select" button	
	* Payment
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'                  |
			| '$$NumberPostponedRRR1$$' |
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt' | 'Item'                                                    | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | ''                     | 'Product 1 with SLN'                                      | ''             | 'PZU'      | ''                   | 'No'                 | '15,25'      | '8908899877'         | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '2' | ''                     | 'Product 6 with SLN'                                      | ''             | 'PZU'      | ''                   | 'No'                 | '15,25'      | '57897909799'        | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '3' | ''                     | 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | ''                   | 'No'                 | '15,25'      | '999999999'          | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '4' | ''                     | 'Dress'                                                   | ''             | 'XS/Blue'  | ''                   | 'No'                 | '158,64'     | ''                   | 'pcs'  | ''              | ''                  | '2,000'    | '520,00' | '881,36'     | '1 040,00'     | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '5' | ''                     | 'Service'                                                 | ''             | 'Rent'     | ''                   | 'No'                 | '15,25'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
		Then the form attribute named "StatusType" became equal to "Completed"
	* Check movements
		And I click "Registrations report" button
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Register  "R2001 Sales"'             |
			| 'Register  "R2050 Retail sales"'      |
			| 'Register  "R3010 Cash on hand"'      |
			| 'Register  "R3011 Cash flow"'         |
			| 'Register  "R3050 Pos cash balances"' |
			| 'Register  "R4010 Actual stocks"'     |
			| 'Register  "R4011 Free stocks"'       |
		And I close current window			
				

		
Scenario: _0263110 cancel postponed RSR
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Create Postponed RSR with reserve (without price)
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "0,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Postponed RSR with a reservation
		And I click "Postpone current receipt with reserve" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Create Postponed RSR without reserve
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I finish line editing in "ItemList" table	
	* Postponed RSR without reserve	
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Create Postponed RRR
		And I click the button named "Return"
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I finish line editing in "ItemList" table	
	* Postponed RRR
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Open postponed list form
		And I click "Open postponed receipt" button	
	* Cancel Postponed RSR and RRR
		And I select all lines of "Receipts" table
		And in the table "Receipts" I click "Cancel receipts" button
		Then the number of "Receipts" table lines is "равно" "0"
		Then there are lines in TestClient message log
			|'3 postponed receipts cancelled'|
		And I close all client application windows
		
Scenario: _0263111 create postponed return with basis document
	And I close all client application windows
	* Create RSR
		And In the command interface I select "Retail" "Point of sale"
		When add different items in POS	
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Create postponed RRR
		And I click the button named "Return"	
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Amount' | 'Retail customer' |
			| '920,00' | ''                |
		And I select current line in "List" table
		And I click "Postpone current receipt" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Processing a postponed RRR 	
		And I click "Open postponed receipt" button
		And I go to line in "Receipts" table
			| 'Amount' |'Retail customer' |
			| '920,00' |''                |
		And I select current line in "Receipts" table
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I save message text as "RRRNumber"
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		// And I go to line in "List" table
		// 	| 'Number'      |
		// 	| '$RRRNumber$' |
		And I go to the last line in "List" table
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt' | 'Item'                                                    | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | '*'                    | 'Product 1 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '15,25'      | '8908899877'         | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '2' | '*'                    | 'Product 6 with SLN'                                      | ''             | 'PZU'      | 'Shop 02'            | 'No'                 | '15,25'      | '57897909799'        | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '3' | '*'                    | 'Product 9 with SLN (control code string, without check)' | ''             | 'ODS'      | 'Shop 02'            | 'No'                 | '15,25'      | '999999999'          | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '4' | '*'                    | 'Dress'                                                   | ''             | 'XS/Blue'  | 'Shop 02'            | 'No'                 | '79,32'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '520,00' | '440,68'     | '520,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
			| '5' | '*'                    | 'Service'                                                 | ''             | 'Rent'     | 'Shop 02'            | 'No'                 | '15,25'      | ''                   | 'pcs'  | ''              | ''                  | '1,000'    | '100,00' | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (2)" tab
		And "ControlCodeStrings" table contains lines
			| 'Code string'                                 | 'Code is approved' | 'Not check' |
			| 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0' | 'No'               | 'No'        |
			| 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1' | 'No'               | 'No'        |
	And I close all client application windows
	
		

Scenario: _0263112 check open Postponed receipt form in POS when close session
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
		And I click "Postpone current receipt with reserve" button
		Then the number of "ItemList" table lines is "равно" "0"
	* Close session
		And I click "Close session" button
		Then the number of "Receipts" table lines is "равно" "1"
	And I close all client application windows
	
	

Scenario: _0263113 check filter by branch in the Postponed receipt form in POS	
	And I close all client application windows
	* Create Postponed RSR for Shop 01
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And in the table "List" I click "Copy" button
		And I click "Uncheck all" button
		And I click "OK" button
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 6 with SLN' | 'PZU'      |
		And I delete a line in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                                    | 'Item key' |
			| 'Product 9 with SLN (control code string, without check)' | 'ODS'      |
		And I delete a line in "ItemList" table
		And I select from the drop-down list named "Branch" by "01" string
		And I select from the drop-down list named "Workstation" by "02" string
		And I select "Postponed" exact value from "Status type" drop-down list
		And I click "Post" button
	* Check filter by branch
		And In the command interface I select "Retail" "Point of sale"	
		And I click "Open postponed receipt" button	
		Then the number of "Receipts" table lines is "равно" "1"
	And I close all client application windows


Scenario: _0263115 сheck the display of deferred receipt commands in POS depending on the settings in Workstation
	And I close all client application windows
	* Disabling the ability to create deferred receipts with reservations
		Given I open hyperlink "e1cib/list/Catalog.Workstations"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I select current line in "List" table
		And I remove checkbox "Postpone with reserve"
		And I set checkbox "Postpone without reserve"
		And I click "Save and close" button
	* Check
		And In the command interface I select "Retail" "Point of sale"
		When I Check the steps for Exception
			| 'And I click "Postpone current receipt with reserve" button'    |
		And I close current window
	* Disabling the ability to create deferred receipts without reservations
		Given I open hyperlink "e1cib/list/Catalog.Workstations"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I select current line in "List" table
		And I remove checkbox "Postpone without reserve"
		And I click "Save and close" button	
	* Check
		And In the command interface I select "Retail" "Point of sale"
		When I Check the steps for Exception
			| 'And I click "Postpone without reserve" button'    |
		When I Check the steps for Exception
			| 'And I click "Postpone current receipt with reserve" button'    |
		And I close current window
	* Enable ability to create deferred receipts with reserve
		Given I open hyperlink "e1cib/list/Catalog.Workstations"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I select current line in "List" table
		And I set checkbox "Postpone with reserve"
		And I click "Save and close" button
	* Check
		And In the command interface I select "Retail" "Point of sale"	
		And I click "Postpone current receipt with reserve" button
		Then there are lines in TestClient message log
			|'Document is empty.'|
		And I close all client application windows
