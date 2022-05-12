#language: en
@tree
@Positive
@FunctionalOptionsSimpleMode

Feature: use simple mode


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _900000 preparation
	And I set "True" value to the constant "UseSimpleMode"
	Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
	And I click "Update defaults" button
	And I close "Functional option settings" window
	* Check Coompany creation
		And In the command interface I select "Master data" "Companies"
		Then the form attribute named "Country" became equal to ""
		Then the form attribute named "MainCompany" became equal to ""
		Then the form attribute named "Partner" became equal to ""
		Then the form attribute named "Type" became equal to "Company"
		Then the form attribute named "OurCompany" became equal to "Yes"
		Then the form attribute named "Code" became equal to "1"
		Then the form attribute named "Description_en" became equal to "My Company"
		And "Currencies" table became equal
			| '#' | 'Movement type'       | 'Type'  | 'Currency' |
			| '1' | 'Legal currency type' | 'Legal' | 'USD'      |
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to ""
		Then the number of "CompanyTaxes" table lines is "равно" 0
	And I close all client application windows
		

Scenario: _900001 create items
	* Create Product 1
		And In the command interface I select "Purchase  - A/P" "Items"
		Then "Items" window is opened
		And I click the button named "FormCreate"
		And I input "Product 1" text in "ENG" field
		And I click Select button of "Item type" field
		And I click the button named "FormCreate"
		Then "Item type (create)" window is opened
		And I input "Product" text in "ENG" field
		And I click "Save and close" button
		And I wait "Item type (create) *" window closing in 20 seconds
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And I wait "Item (create) *" window closing in 20 seconds
	* Create Service 1
		And I click the button named "FormCreate"
		And I input "Service 1" text in "ENG" field
		And I click Select button of "Item type" field
		And I click the button named "FormCreate"
		And I input "Service" text in "ENG" field
		And I change the radio button named "Type" value to "Service"
		And I click "Save and close" button
		And I wait "Item type (create) *" window closing in 20 seconds
		Then "Item types" window is opened
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And I wait "Item (create) *" window closing in 20 seconds
	* Check
		And "List" table became equal
			| 'Description' | 'Item type' |
			| 'Product 1'   | 'Product'   |
			| 'Service 1'   | 'Service'   |
		And I close all client application windows

Scenario: _900002 create partners (vendor and customer)
	* Create vendor
		And In the command interface I select "Purchase  - A/P" "Vendors"
		Then "Vendors" window is opened
		And I click the button named "FormCreate"
		And I input "Vendor 1" text in "ENG" field
		And I click "Save and close" button
	* Check creation
		And "List" table became equal
			| 'Description' |
			| 'Vendor 1'    |
	* Create customer
		And In the command interface I select "Sales - A/R" "Customers"
		Then "Customers" window is opened
		And I click "Create" button
		And I input "Customer 1" text in "ENG" field
		And I click "Save and close" button
	* Create vendor and customer
		And I click "Create" button
		And I input "Vendor and customer" text in "ENG" field
		And I change checkbox named "Vendor"
		And I click "Save and close" button
	* Check creation
		And "List" table became equal
			| 'Description'         |
			| 'Customer 1'          |
			| 'Vendor and customer' |

Scenario: _900003 create price list (customer price type)
	* Open price list
		And In the command interface I select "Purchase  - A/P" "Price lists"
		Then "Price lists" window is opened
		And I click the button named "FormCreate"
	* Select price type
		And I click Select button of "Price type" field
		Then "Price types" window is opened
		And I go to line in "List" table
			| 'Description'         |
			| 'Customer price type' |
		And I select current line in "List" table
	* Select items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Service 1'   |
		And I select current line in "List" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Product 1'      |
		And I select current line in "List" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "200,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check creation
		And I click "Post and close" button
		And "List" table became equal
			| 'Number' | 'Price type'          | 'Price list type' |
			| '1'      | 'Customer price type' | 'Price by items'  |


Scenario: _900004 create Cash account
	* Open creation form
		And In the command interface I select "Treasury" "Cash/Bank accounts"
		Then "Cash/Bank accounts" window is opened
	* Create Cash account
		And I click the button named "FormCreate"
		And I input "Cash 1" text in "ENG" field
		And I select from the drop-down list named "Company" by "my company" string
		And I change the radio button named "CurrencyType" value to "Fixed"
		And I click Choice button of the field named "Currency"
		And I activate field named "Code" in "List" table
		And I select current line in "List" table
		And I click "Save and close" button
	* Check creation
		And "List" table became equal
			| 'Description' |
			| 'Cash 1'      |
		And I close all client application windows
		
Scenario: _900008 create PI
	And I close all client application windows
	* Open PI form
		And In the command interface I select "Purchase  - A/P" "Purchase invoices"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'         |
			| 'Vendor and customer' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
	* Select items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "" text in "Item" field of "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Service 1'   |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I finish line editing in "ItemList" table
		And I delete a line in "ItemList" table
		And in the table "ItemList" I click "Pickup" button
		And I go to line in "ItemList" table
			| 'Title'     |
			| 'Product 1' |
		And I select current line in "ItemList" table
		And I click "Transfer to document" button		
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'      |
			| 'Service 1' |
		And I select current line in "ItemList" table
		And I input "90,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice01$$" variable
		And I delete "$$PurchaseInvoice01$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice01$$"
		And I save the window as "$$PurchaseInvoice01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And "List" table contains lines
			| 'Number'  |
			| '$$NumberPurchaseInvoice01$$' |
		And I close all client application windows


Scenario: _900009 create SI
	And I close all client application windows
	* Open SI form
		And In the command interface I select "Sales - A/R" "Sales invoices"		
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'         |
			| 'Customer 1' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
	* Select items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "pro" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "ser" from "Item" drop-down list by string in "ItemList" table
	* Check filling
		And "ItemList" table became equal
			| '#' | 'Item'      | 'Price type'          | 'Q'     | 'Dont calculate row' | 'Price'  | 'Offers amount' | 'Net amount' | 'Total amount' |
			| '1' | 'Product 1' | 'Customer price type' | '1,000' | 'No'                 | '200,00' | ''              | '200,00'     | '200,00'       |
			| '2' | 'Service 1' | 'Customer price type' | '1,000' | 'No'                 | '100,00' | ''              | '100,00'     | '100,00'       |
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice01$$" variable
		And I delete "$$SalesInvoice01$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice01$$"
		And I save the window as "$$SalesInvoice01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'  |
			| '$$NumberSalesInvoice01$$' |
		And I close all client application windows
		
Scenario: _900010 create Cash receipt based on SI
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberSalesInvoice01$$' |
	* Create CR
		And I click "Cash receipt" button
	* Check filling
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Cash account: Cash 1   Currency: USD   Transaction type: Payment from customer   "
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "CashAccount" became equal to "Cash 1"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "CurrencyExchange" became equal to ""
		And "PaymentList" table became equal
			| '#' | 'Partner'    | 'Total amount' |
			| '1' | 'Customer 1' | '300,00'       |
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "DocumentAmount" became equal to "300,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
	* Change amount
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt01$$" variable
		And I delete "$$CashReceipt01$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt01$$"
		And I save the window as "$$CashReceipt01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And "List" table contains lines
			| 'Number'  |
			| '$$NumberCashReceipt01$$' |
		And I close all client application windows
		
	



		
				
		
				

				
		
				

		
				



		
				




		
				
		
				
	


		
				


		
		
		
				


	
		

	