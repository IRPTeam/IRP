#language: en
@tree
@Positive
@FunctionalOptions

Feature: use simple mode


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _900000 check open company catalog (dont use company)
	* Check open Company catalog
		And In the command interface I select "Master data" "Companies"
		Then the form attribute named "Country" became equal to ""
		Then the form attribute named "MainCompany" became equal to ""
		Then the form attribute named "Partner" became equal to ""
		And I close all client application windows
		

Scenario: _900001 Check Company creation
	When set True value to the constant UseSimpleMode
	Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
	And I click "Update defaults" button
	And I click "Update all user settings" button
	And I close "Functional option settings" window
	* Check Company creation
		And In the command interface I select "Master data" "Companies"
		Then the form attribute named "Country" became equal to ""
		Then the form attribute named "MainCompany" became equal to ""
		Then the form attribute named "Partner" became equal to ""
		Then the form attribute named "Type" became equal to "Company"
		Then the form attribute named "OurCompany" became equal to "Yes"
		Then the form attribute named "Code" became equal to "1"
		Then the form attribute named "Description_en" became equal to "My Company"
		And "Currencies" table became equal
			| '#'   | 'Movement type'         | 'Type'    | 'Currency'    |
			| '1'   | 'Legal currency type'   | 'Legal'   | 'USD'         |
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to ""
		Then the number of "CompanyTaxes" table lines is "равно" 0
	And I close all client application windows
		
Scenario: _900002 check preparation
	When check preparation

Scenario: _900003 create items
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
			| 'Description'   | 'Item type'    |
			| 'Product 1'     | 'Product'      |
			| 'Service 1'     | 'Service'      |
		And I close all client application windows

Scenario: _900004 create partners (vendor and customer)
	* Create vendor
		And In the command interface I select "Purchase  - A/P" "Vendors"
		Then "Vendors" window is opened
		And I click the button named "FormCreate"
		And I input "Vendor 1" text in "ENG" field
		And I click "Save and close" button
	* Check creation
		And "List" table became equal
			| 'Description'    |
			| 'Vendor 1'       |
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
			| 'Description'            |
			| 'Customer 1'             |
			| 'Vendor and customer'    |

Scenario: _900005 create price list (customer price type)
	* Open price list
		And In the command interface I select "Purchase  - A/P" "Price lists"
		Then "Price lists" window is opened
		And I click the button named "FormCreate"
	* Select price type
		And I click Select button of "Price type" field
		Then "Price types" window is opened
		And I go to line in "List" table
			| 'Description'            |
			| 'Customer price type'    |
		And I select current line in "List" table
	* Select items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service 1'      |
		And I select current line in "List" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "100,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Product 1'      |
		And I select current line in "List" table
		And I activate field named "ItemListPrice" in "ItemList" table
		And I input "200,00" text in the field named "ItemListPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check creation
		And I click "Post and close" button
		And "List" table became equal
			| 'Number'   | 'Price type'            | 'Price list type'    |
			| '1'        | 'Customer price type'   | 'Price by items'     |


Scenario: _900006 create Cash account
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
			| 'Description'    |
			| 'Cash 1'         |
		And I close all client application windows

Scenario: _900007 create Opening entry
	* Open OE form
		And In the command interface I select "Master data" "Opening entries"
	* Filling Inventory tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I select "pr" from "Item" drop-down list by string in "Inventory" table
		And I activate "Quantity" field in "Inventory" table
		And I input "100,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
	* Filling Account balance tab
		And I move to "Account balance" tab
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I select "cash" from "Account" drop-down list by string in "AccountBalance" table
		And I activate field named "AccountBalanceAmount" in "AccountBalance" table
		And I input "5 000,00" text in the field named "AccountBalanceAmount" of "AccountBalance" table
		And I finish line editing in "AccountBalance" table
	* Filling Account payable tab
		And I move to "Account payable" tab
		And in the table "AccountPayableByAgreements" I click the button named "AccountPayableByAgreementsAdd"
		And I select "vendor" by string from the drop-down list named "AccountPayableByAgreementsPartner" in "AccountPayableByAgreements" table
		And I activate field named "AccountPayableByAgreementsAmount" in "AccountPayableByAgreements" table
		And I input "500,00" text in the field named "AccountPayableByAgreementsAmount" of "AccountPayableByAgreements" table
		And I finish line editing in "AccountPayableByAgreements" table
	* Filling Account receivable tab
		And I move to "Account receivable" tab
		And in the table "AccountReceivableByAgreements" I click the button named "AccountReceivableByAgreementsAdd"
		And I select "cu" by string from the drop-down list named "AccountReceivableByAgreementsPartner" in "AccountReceivableByAgreements" table
		And I activate field named "AccountReceivableByAgreementsAmount" in "AccountReceivableByAgreements" table
		And I input "150,00" text in the field named "AccountReceivableByAgreementsAmount" of "AccountReceivableByAgreements" table
		And I finish line editing in "AccountReceivableByAgreements" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberOpeningEntry01$$" variable
		And I delete "$$OpeningEntry01$$" variable
		And I save the value of "Number" field as "$$NumberOpeningEntry01$$"
		And I save the window as "$$OpeningEntry01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		And In the command interface I select "Master data" "Opening entries"
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "Description" became equal to "Click to enter description"
		And "Inventory" table became equal
			| '#'   | 'Item'        | 'Quantity'    |
			| '1'   | 'Product 1'   | '100,000'     |
		// And "AccountBalance" table became equal
		// 	| '#' | 'Amount'   | 'Account' | 'Currency' |
		// 	| '1' | '5 000,00' | 'Cash 1'  | 'USD'      |	
		And "AccountPayableByAgreements" table became equal
			| '#'   | 'Partner'    | 'Amount'   | 'Legal name'   | 'Currency'    |
			| '1'   | 'Vendor 1'   | '500,00'   | 'Vendor 1'     | 'USD'         |
		And "AccountReceivableByAgreements" table became equal
			| '#'   | 'Partner'      | 'Amount'   | 'Legal name'   | 'Currency'    |
			| '1'   | 'Customer 1'   | '150,00'   | 'Customer 1'   | 'USD'         |
		Then the form attribute named "Branch" became equal to ""
		And I close all client application windows
		
				

Scenario: _900008 create PI
	And I close all client application windows
	* Open PI form
		And In the command interface I select "Purchase  - A/P" "Purchase invoices"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'            |
			| 'Vendor and customer'    |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
	* Select items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "" text in "Item" field of "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service 1'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I finish line editing in "ItemList" table
		And I delete a line in "ItemList" table
		And in the table "ItemList" I click "Pickup" button
		And I go to line in "ItemList" table
			| 'Title'        |
			| 'Product 1'    |
		And I select current line in "ItemList" table
		And I click "Transfer to document" button		
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'         |
			| 'Service 1'    |
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
			| 'Number'                         |
			| '$$NumberPurchaseInvoice01$$'    |
		And I close all client application windows


Scenario: _900009 create SI
	And I close all client application windows
	* Open SI form
		And In the command interface I select "Sales - A/R" "Sales invoices"		
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Customer 1'     |
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
			| '#'   | 'Item'        | 'Price type'            | 'Quantity'   | 'Dont calculate row'   | 'Price'    | 'Offers amount'   | 'Total amount'    |
			| '1'   | 'Product 1'   | 'Customer price type'   | '1,000'      | 'No'                   | '200,00'   | ''                | '200,00'          |
			| '2'   | 'Service 1'   | 'Customer price type'   | '1,000'      | 'No'                   | '100,00'   | ''                | '100,00'          |
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice01$$" variable
		And I delete "$$SalesInvoice01$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice01$$"
		And I save the window as "$$SalesInvoice01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And "List" table contains lines
			| 'Number'                      |
			| '$$NumberSalesInvoice01$$'    |
		And I close all client application windows
		
Scenario: _900010 create Cash receipt based on SI (Payment from customer)
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberSalesInvoice01$$'    |
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
			| '#'   | 'Partner'      | 'Total amount'    |
			| '1'   | 'Customer 1'   | '300,00'          |
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "300,00"
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
			| 'Number'                     |
			| '$$NumberCashReceipt01$$'    |
		And I close all client application windows
		
	
Scenario: _900011 create Cash receipt without SI (Payment from customer)
	And I close all client application windows
	* Open CR form
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Filling
		And in the table "PaymentList" I click "Add" button
		And I select "customer" from "Partner" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check filling
		And "PaymentList" table became equal
			| '#'   | 'Partner'      | 'Total amount'    |
			| '1'   | 'Customer 1'   | '100,00'          |
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt02$$" variable
		And I delete "$$CashReceipt02$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt02$$"
		And I save the window as "$$CashReceipt02$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberCashReceipt02$$'    |
		And I close all client application windows
		
Scenario: _900015 create Cash payment based on PI (Payment to the vendor)	
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberPurchaseInvoice01$$'    |
	* Create CP
		And I click "Cash payment" button
	* Check filling
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Cash account: Cash 1   Currency: USD   Transaction type: Payment to the vendor   "
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "CashAccount" became equal to "Cash 1"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And "PaymentList" table became equal
			| '#'   | 'Partner'               | 'Total amount'    |
			| '1'   | 'Vendor and customer'   | '590,00'          |
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "590,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
	* Change amount
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment01$$" variable
		And I delete "$$CashPayment01$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment01$$"
		And I save the window as "$$CashPayment01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberCashPayment01$$'    |
		And I close all client application windows			
		

Scenario: _900016 create Cash payment without PI (Payment to the vendor)
	And I close all client application windows
	* Open CP form
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Filling
		And in the table "PaymentList" I click "Add" button
		And I select "Vendor and customer" from "Partner" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check filling
		And "PaymentList" table became equal
			| '#'   | 'Partner'               | 'Total amount'    |
			| '1'   | 'Vendor and customer'   | '100,00'          |
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment02$$" variable
		And I delete "$$CashPayment02$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment02$$"
		And I save the window as "$$CashPayment02$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberCashPayment02$$'    |
		And I close all client application windows				

Scenario: _900020 create Purchase return based on PI		
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberPurchaseInvoice01$$'    |
	* Create PR
		And I click "Purchase return" button
		And "BasisesTree" table became equal
			| 'Row presentation'        | 'Use'   | 'Quantity'   | 'Price'    | 'Currency'    |
			| '$$PurchaseInvoice01$$'   | 'Yes'   | ''           | ''         | ''            |
			| 'Service 1 (Service 1)'   | 'Yes'   | '1,000'      | '90,00'    | 'USD'         |
			| 'Product 1 (Product 1)'   | 'Yes'   | '5,000'      | '100,00'   | 'USD'         |
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'   | 'Quantity'   | 'Row presentation'        | 'Use'    |
			| 'USD'        | '90,00'   | '1,000'      | 'Service 1 (Service 1)'   | 'Yes'    |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I activate "Quantity" field in "BasisesTree" table
		And I select current line in "BasisesTree" table
		And I click "Ok" button		
	* Check creation
		Then the form attribute named "Partner" became equal to "Vendor and customer"
		Then the form attribute named "LegalName" became equal to "Vendor and customer"
		Then the form attribute named "Agreement" became equal to "Vendor standard term"
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "Store" became equal to "My Store"
		And "ItemList" table became equal
			| '#'   | 'Item'        | 'Quantity'   | 'Dont calculate row'   | 'Price'    | 'Offers amount'   | 'Purchase invoice'        | 'Total amount'   | 'Detail'   | 'Additional analytic'   | 'Return reason'    |
			| '1'   | 'Product 1'   | '5,000'      | 'No'                   | '100,00'   | ''                | '$$PurchaseInvoice01$$'   | '500,00'         | ''         | ''                      | ''                 |
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "Branch" became equal to ""
		Then the form attribute named "Author" became equal to "en description is empty"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "500,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
	* Change quantity
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "200,00"
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn01$$" variable
		And I delete "$$PurchaseReturn01$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn01$$"
		And I save the window as "$$PurchaseReturn01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And "List" table contains lines
			| 'Number'                        |
			| '$$NumberPurchaseReturn01$$'    |
		And I close all client application windows
		
Scenario: _900021 create Purchase return
	And I close all client application windows
	* Open PR form	
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Filling
		And I select from the drop-down list named "Partner" by "vendor and" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "product 1" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I click "Auto link" button
		And I click "Ok" button
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'        | 'Use'    |
			| 'USD'        | '100,00'   | '3,000'      | 'Product 1 (Product 1)'   | 'Yes'    |
		And I click "Ok" button
	* Check filling
		Then the form attribute named "Partner" became equal to "Vendor and customer"
		Then the form attribute named "LegalName" became equal to "Vendor and customer"
		Then the form attribute named "Agreement" became equal to "Vendor standard term"
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "Store" became equal to "My Store"
		And "ItemList" table became equal
			| '#'   | 'Item'        | 'Quantity'   | 'Dont calculate row'   | 'Price'    | 'Offers amount'   | 'Purchase invoice'        | 'Total amount'   | 'Detail'   | 'Return reason'    |
			| '1'   | 'Product 1'   | '1,000'      | 'No'                   | '100,00'   | ''                | '$$PurchaseInvoice01$$'   | '100,00'         | ''         | ''                 |
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "100,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn02$$" variable
		And I delete "$$PurchaseReturn02$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn02$$"
		And I save the window as "$$PurchaseReturn02$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And "List" table contains lines
			| 'Number'                        |
			| '$$NumberPurchaseReturn02$$'    |
		And I close all client application windows
				
		

Scenario: _900028 create Sales return based on SI		
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberSalesInvoice01$$'    |
	* Create SR
		And I click "Sales return" button
		And "BasisesTree" table became equal
			| 'Row presentation'        | 'Use'   | 'Quantity'   | 'Price'    | 'Currency'    |
			| '$$SalesInvoice01$$'      | 'Yes'   | ''           | ''         | ''            |
			| 'Product 1 (Product 1)'   | 'Yes'   | '1,000'      | '200,00'   | 'USD'         |
			| 'Service 1 (Service 1)'   | 'Yes'   | '1,000'      | '100,00'   | 'USD'         |
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'        | 'Use'    |
			| 'USD'        | '200,00'   | '1,000'      | 'Product 1 (Product 1)'   | 'Yes'    |
		And I remove "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		Then "Add linked document rows" window is opened
		And I click "Ok" button
	* Check filling
		Then the form attribute named "Partner" became equal to "Customer 1"
		Then the form attribute named "LegalName" became equal to "Customer 1"
		Then the form attribute named "Agreement" became equal to "Customer standard term"
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "Store" became equal to "My Store"
		And "ItemList" table became equal
			| '#'   | 'Item'        | 'Quantity'   | 'Dont calculate row'   | 'Price'    | 'Offers amount'   | 'Total amount'   | 'Sales invoice'        | 'Return reason'    |
			| '1'   | 'Service 1'   | '1,000'      | 'No'                   | '100,00'   | ''                | '100,00'         | '$$SalesInvoice01$$'   | ''                 |
		Then the form attribute named "PriceIncludeTax" became equal to "No"
		Then the form attribute named "Currency" became equal to "USD"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "100,00"
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn01$$" variable
		And I delete "$$SalesReturn01$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn01$$"
		And I save the window as "$$SalesReturn01$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberSalesReturn01$$'    |
		And I close all client application windows
				

Scenario: _900029 create Sales return
	And I close all client application windows
	* Open SR form	
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling
		And I select from the drop-down list named "Partner" by "Customer 1" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "product 1" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I click "Auto link" button
		And I click "Ok" button
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table				
		And "BasisesTree" table became equal
			| 'Row presentation'        | 'Use'   | 'Quantity'   | 'Price'    | 'Currency'    |
			| '$$SalesInvoice01$$'      | 'No'    | ''           | ''         | ''            |
			| 'Product 1 (Product 1)'   | 'Yes'   | '1,000'      | '200,00'   | 'USD'         |
		And I click "Ok" button
	* Check filling	
		Then the form attribute named "Partner" became equal to "Customer 1"
		Then the form attribute named "LegalName" became equal to "Customer 1"
		Then the form attribute named "Agreement" became equal to "Customer standard term"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "Store" became equal to "My Store"
		And "ItemList" table became equal
			| '#'   | 'Item'        | 'Quantity'   | 'Dont calculate row'   | 'Price'    | 'Offers amount'   | 'Total amount'   | 'Sales invoice'        | 'Return reason'   | 'Additional analytic'    |
			| '1'   | 'Product 1'   | '1,000'      | 'No'                   | '200,00'   | ''                | '200,00'         | '$$SalesInvoice01$$'   | ''                | ''                       |
		Then the form attribute named "PriceIncludeTax" became equal to "No"
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "200,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn02$$" variable
		And I delete "$$SalesReturn02$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn02$$"
		And I save the window as "$$SalesReturn02$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberSalesReturn02$$'    |
		And I close all client application windows
		
Scenario: _900031 return money to customer based on Sales return
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberSalesReturn01$$'    |
	* Create CP
		And I click "Cash payment" button
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "CashAccount" became equal to "Cash 1"
		Then the form attribute named "TransactionType" became equal to "Return to customer"
		Then the form attribute named "Currency" became equal to "USD"
		And "PaymentList" table became equal
			| '#'   | 'Partner'      | 'Total amount'    |
			| '1'   | 'Customer 1'   | '100,00'          |
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "100,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment03$$" variable
		And I delete "$$CashPayment03$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment03$$"
		And I save the window as "$$CashPayment03$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberCashPayment03$$'    |
		And I close all client application windows

		
Scenario: _900032 return money to customer
	And I close all client application windows
	* Open CP
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Filling CP
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "CashAccount" became equal to "Cash 1"
		And I select "Return to customer" exact value from "Transaction type" drop-down list	
		Then the form attribute named "Currency" became equal to "USD"
		And in the table "PaymentList" I click "Add" button
		And I select "customer" from "Partner" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "50,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table	
		And "PaymentList" table became equal
			| '#'   | 'Partner'      | 'Total amount'    |
			| '1'   | 'Customer 1'   | '50,00'           |
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "50,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment04$$" variable
		And I delete "$$CashPayment04$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment04$$"
		And I save the window as "$$CashPayment04$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberCashPayment04$$'    |
		And I close all client application windows
				
		

Scenario: _900035 return money from vendor
	And I close all client application windows
	* Open CR
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Filling CR
		And I select "Return from vendor" exact value from "Transaction type" drop-down list
		And I activate "Partner" field in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "vendor and" from "Partner" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check filling
		Then the form attribute named "Company" became equal to "My Company"
		Then the form attribute named "CashAccount" became equal to "Cash 1"
		Then the form attribute named "TransactionType" became equal to "Return from vendor"
		Then the form attribute named "Currency" became equal to "USD"
		And "PaymentList" table became equal
			| '#'   | 'Partner'               | 'Total amount'    |
			| '1'   | 'Vendor and customer'   | '100,00'          |
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "100,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "USD"
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt03$$" variable
		And I delete "$$CashReceipt03$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt03$$"
		And I save the window as "$$CashReceipt03$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And "List" table contains lines
			| 'Number'                     |
			| '$$NumberCashReceipt03$$'    |
		And I close all client application windows
		
				
Scenario: _900090 change functional options use company and check users settings
	* Change functional option
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'          | 'Use'    |
			| 'Use companies'   | 'No'     |
		And I activate "Use" field in "FunctionalOptions" table
		And I change "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I click "Update all user settings" button
		And I click "Save" button
		And I close "Functional option settings" window


		

	
		
			
				
		
				
		
				
		
										
		
				
		
				
				
		
				
		
								

				

		

		
				
		
				

				
		
				

		
				



		
				




		
				
		
				
	


		
				


		
		
		
				


	
		

	
