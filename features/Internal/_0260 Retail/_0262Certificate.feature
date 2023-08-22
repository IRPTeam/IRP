#language: en
@tree
@Positive
@Retail

Feature: certificate (POS)


Variables:
import "Variables.feature"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _0262100 certificate (POS)
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
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Open session
		And In the command interface I select "Retail" "Point of sale"
		And I click "Open session" button
	And I close all client application windows
	

Scenario: _0262101 check preparation
	When check preparation


Scenario: _0262102 attempt to sell a certificate and a product in one receipt
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Scan product then certificate
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute
		Then there are lines in TestClient message log
			|'In the document, there can be either goods or certificates.'|
		And I delete all lines of "ItemList" table
		And I close all client application windows
	// * Scan certificate then product
	// 	And In the command interface I select "Retail" "Point of sale"
	// 	And I click "Search by barcode (F7)" button
	// 	And I input "99999999999" text in the field named "Barcode"
	// 	And I move to the next attribute
	// 	And I click "Search by barcode (F7)" button
	// 	And I input "2202283713" text in the field named "Barcode"
	// 	And I move to the next attribute
	// 	Then there are lines in TestClient message log
	// 		|'In the document, there can be either goods or certificates.'|
	// 	And I delete all lines of "ItemList" table


Scenario: _0262103 certificate sale (POS, without retail customer)
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"	
	* Certificate sale
		And I click "Search by barcode (F7)" button
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check RSR creation
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table	
		And I select current line in "List" table	
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "RetailCustomer" became equal to ""
		Then the field named "ConsolidatedRetailSales" is filled
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'                          | 'Sales person' | 'Item key'                      | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'en description is empty' | 'Certificate without denominal' | ''             | 'Certificate without denominal' | 'Shop 02'            | 'No'                 | '99999999999'        | 'pcs'  | '76,27'      | ''                  | '1,000'    | '500,00' | '18%' | ''              | '423,73'     | '500,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'            | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '500,00' | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Pos cash account 1' | ''        | ''         | ''                      | ''                         | ''                            |
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		Then the form attribute named "Author" became equal to "CI"
	And I close all client application windows
	

Scenario: _0262105 attempt to sell the same certificate twice
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add certificate
		And I click "Search by barcode (F7)" button
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute 
		Then there are lines in TestClient message log
			|'Certificate 99999999999 cannot be issued again.'|
		And I delete all lines of "ItemList" table
	

Scenario: _0262106 try modify sum when pay by certificate
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add item
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
	* Payment 
		And I click "Payment (+)" button
		And I click the button named "SearchByBarcode"
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "5" button
		And I click "2" button
		And I click "⌫" button
		And "Payments" table became equal
			| 'Payment done' | 'Payment type' | 'Amount' |
			| ' '            | 'Certificate'  | '500,00' |
		And I delete all lines of "Payments" table
		And I close current window	
		If "Point of sales *" window is opened Then
			And I delete all lines of "ItemList" table
				

Scenario: _0262107 payment by certificate and cash (POS, without retail customer)	
	* Preparation 
		If "Payment" window is opened Then
			And I delete all lines of "Payments" table
			And I close current window
		If "Point of sales *" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add item
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
	* Payment 
		And I click "Payment (+)" button
		And I click the button named "SearchByBarcode"
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Cash (/)" button
		And "Payments" table became equal
			| 'Payment done' | 'Payment type' | 'Amount' |
			| ' '            | 'Certificate'  | '500,00' |
			| ' '            | 'Cash'         | '50,00'  |
		And I click "OK" button
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table	
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Price type'        | 'Item'  | 'Sales person' | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'Basic Price Types' | 'Dress' | ''             | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                   | 'pcs'  | '83,90'      | ''                  | '1,000'    | '550,00' | '18%' | ''              | '466,10'     | '550,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'            | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '500,00' | ''           | '99999999999' | 'Certificate'  | 'Movement type 1'         | ''                                  | ''                 | ''          | ''                   | ''        | ''         | ''                      | ''                         | ''                            |
			| '2' | '50,00'  | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Pos cash account 1' | ''        | ''         | ''                      | ''                         | ''                            |
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
	And I close all client application windows


Scenario: _0262108 attempt to pay with a previously used certificate
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add item
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
	* Payment 
		And I click "Payment (+)" button
		And I click the button named "SearchByBarcode"
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute	
		Then there are lines in TestClient message log
			|'Certificate 99999999999 has already been used before and cannot be used again.'|
		And I close current window
		And I delete all lines of "ItemList" table

Scenario: _0262111 attempt to return a previously used certificate
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
		And I click the button named "Return"		
	* Add certificate
		And I click "Search by barcode (F7)" button
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute 
		Then there are lines in TestClient message log
			|'Certificate 99999999999 has already been used before and cannot be used again.'|
		And I close all client application windows

Scenario: _0262115 return items that was paid by certificate
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Return
		And I click the button named "Return"	
	* Add item
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
	* Select basis
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Amount' |
			| '550,00' |
		And I select current line in "List" table
		And "BasisPayments" table became equal
			| 'Payment type' | 'Amount' |
			| 'Certificate'  | '500,00' |
			| 'Cash'         | '50,00'  |
	* Payment return
		And I click "Payment Return" button
		And I click "5" button
		And I click "Cash (/)" button
		And "Payments" table became equal
			| 'Payment done' | 'Payment type' | 'Amount' | 'RRNCode' |
			| ' '            | 'Certificate'  | '500,00' | ''        |
			| ' '            | 'Cash'         | '50,00'  | ''        |
		And I click "OK" button
	* Check 
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to the last line in "List" table	
		And I select current line in "List" table
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Postponed payment' | 'Bank term' | 'Account'            | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '500,00' | ''           | '99999999999' | 'Certificate'  | ''                        | ''                                  | ''                 | 'No'                | ''          | ''                   | ''        | ''         | ''                      | ''                         | ''                            |
			| '2' | '50,00'  | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | 'No'                | ''          | 'Pos cash account 1' | ''        | ''         | ''                      | ''                         | ''                            |
		And I close all client application windows

Scenario: _0262116 attempt to return a certificate for which the product has already been refunded
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
		And I click the button named "Return"		
	* Add certificate
		And I click "Search by barcode (F7)" button
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute 			
		Then there are lines in TestClient message log
			|'Certificate 99999999999 has already been used before and cannot be used again.'|
		And I close all client application windows

Scenario: _0262117 return certificate
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"	
	* Sales
		And I click "Search by barcode (F7)" button
		And I input "99999999998" text in the field named "Barcode"
		And I move to the next attribute
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Return
		And I click the button named "Return"
		And I click "Search by barcode (F7)" button
		And I input "99999999998" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to the last line in "List" table	
		And I select current line in "List" table
		And "ItemList" table became equal
			| '#' | 'Retail sales receipt' | 'Item'                          | 'Sales person' | 'Item key'                      | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Return reason' | 'Source of origins' | 'Quantity' | 'Price'  | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Revenue type' | 'Detail' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Landed cost tax' |
			| '1' | ''                     | 'Certificate without denominal' | ''             | 'Certificate without denominal' | ''                   | 'No'                 | '45,76'      | '99999999998'        | 'pcs'  | ''              | ''                  | '1,000'    | '300,00' | '254,24'     | '300,00'       | ''                    | 'Store 01' | ''             | ''       | '18%' | ''              | ''            | ''                |		
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Postponed payment' | 'Bank term' | 'Account'            | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '300,00' | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | 'No'                | ''          | 'Pos cash account 1' | ''        | ''         | ''                      | ''                         | ''                            |		
		And I close all client application windows
		
				
				
Scenario: _0262108 check that certificate are not available in the item tab in POS
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Check filter
		And I move to "Items" tab
		And "ItemsPickup" table does not contain lines
			| 'Item'                          |
			| 'Certificate without denominal' |
	And I close all client application windows
	
