#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: create discount Message Dialog Box 2 (Message 3)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreate"
	And I click Select button of "Special offer type" field
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
			| 'Description'                   |
			| 'ExternalSpecialMessage' |
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I select "DialogBox" exact value from "Message type" drop-down list
	And I input "Message 3" text in "Message Description_en" field
	And I input "Message 3" text in "Message Description_tr" field
	And I click "Save settings" button
	And I click "Save and close" button
	And I wait "DialogBox2 (Special offer types) *" window closing in 20 seconds
	And I click the button named "FormChoose"
	And I input "8" text in "Priority" field
	And I input "01.01.2019  0:00:00" text in "Start of" field
	And I select "Sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And in the table "Rules" I click the button named "RulesAdd"
	And I click choice button of "Rule" attribute in "Rules" table
	And I go to line in "List" table
			| 'Description'                                |
			| 'Discount on Basic Partner terms without Vat' |
	And I select current line in "List" table
	And I finish line editing in "Rules" table
	And I click "Save and close" button
	And Delay 2
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 2 without Vat' |
	And I go to line in "List" table
			| 'Description'  |
			| 'DialogBox2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I click "List" button
	And I go to line in "List" table
			| 'Priority' | 'Special offer type' |
			| '1'        | 'Sum'                |
	And I click the button named "FormChoose"

Scenario: transfer the discount Discount 1 without Vat from Sum to Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I expand a line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '1'        | 'Special Offers'     |
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	And I click the button named "FormChoose"



Scenario: changing the auto apply of Discount 1 without Vat
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 1 without Vat' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: create an order for MIO Basic Partner terms, without VAT (High shoes and Boots)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'High shoes' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '39/19SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Boots' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "4,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post" button



Scenario: transfer the Discount 1 without Vat discount from Maximum to Minimum.
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And in the table "List" I click the button named "ListContextMenuLevelDown"
	And Delay 2
	And I move one level down in "List" table
	And Delay 1
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	And I click the button named "FormChoose"





Scenario: choose the unit of measurement pcs
		And I click choice button of "Unit" attribute in "ItemKeyList" table
		And I go to line in "List" table
		| Description |
		| pcs         |
		And I select current line in "List" table



Scenario: filling in Tax settings for company
	Given I open hyperlink "e1cib/list/Catalog.Companies"
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I move to "Tax types" tab
	If "CompanyTaxes" table does not contain lines Then
		| 'Period'     | 'Use' | 'Tax' | 'Priority' |
		| '01.01.2020' | 'Yes' | 'VAT' | '5'         |
		And in the table "CompanyTaxes" I click the button named "CompanyTaxesAdd"
		And I input "01.01.2020" text in "Period" field of "CompanyTaxes" table
		And I activate "Tax" field in "CompanyTaxes" table
		And I click choice button of "Tax" attribute in "CompanyTaxes" table
		And I select current line in "List" table
		And I finish line editing in "CompanyTaxes" table
		And I activate "Priority" field in "CompanyTaxes" table
		And I select current line in "CompanyTaxes" table
		And I input "5" text in "Priority" field of "CompanyTaxes" table
		And I finish line editing in "CompanyTaxes" table
		And I click "Save" button
	And I activate "Tax" field in "CompanyTaxes" table
	And I select current line in "CompanyTaxes" table
	And I click Open button of "Tax" field
	Then "VAT (Tax type)" window is opened
	And I click "Settings" button
	And I click "Ok" button
	And I click "Save and close" button
	And I close all client application windows
	

Scenario: create PurchaseOrder017001
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Status filling
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description        |
			| Vendor Ferron, TRY |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100" text in "Q" field of "ItemList" table
		And I input "200" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200" text in "Q" field of "ItemList" table
		And I input "210" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		And I select current line in "ItemList" table
		And I input "300" text in "Q" field of "ItemList" table
		And I input "250" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Q' | 'Item key'  | 'Store' | 'Unit' |
			| 'Dress'    | '100,000'  | 'M/White'   | 'Store 01'      | 'pcs' |
	* Post document
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseOrder017001$$"
		And I save the window as "$$PurchaseOrder017001$$"
		And I click "Post and close" button

Scenario: create PurchaseOrder017003
		* Opening a form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in the details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description  |
			| Main Company |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor information
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "500,000" text in "Q" field of "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Post document
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberPurchaseOrder017003$$"
			And I save the window as "$$PurchaseOrder017003$$"
			And I click "Post and close" button

Scenario: create PurchaseInvoice018001 based on PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberPurchaseOrder017001$$' |
		And I select current line in "List" table
		* Check filling of elements upon entry based on
			And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I select current line in "List" table
		* Check filling items table
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'     | 'Purchase order'          | 'Item key'  | 'Unit' | 'Q'       |
			| 'Dress'    | '$$PurchaseOrder017001$$' | 'M/White'   | 'pcs'  | '100,000' |
			| 'Dress'    | '$$PurchaseOrder017001$$' | 'L/Green'   | 'pcs'  | '200,000' |
			| 'Trousers' | '$$PurchaseOrder017001$$' | '36/Yellow' | 'pcs'  | '300,000' |
		* Check filling prices
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'Item key'  | 'Q'       | 'Price type'                         | 'Store'    |
			| '200,00' | 'Dress'    | 'M/White'   | '100,000' | 'en description is empty'           | 'Store 01' |
			| '210,00' | 'Dress'    | 'L/Green'   | '200,000' | 'en description is empty'           | 'Store 01' |
			| '250,00' | 'Trousers' | '36/Yellow' | '300,000' | 'en description is empty'           | 'Store 01' |
		* Check addition of the store in tabular part
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Store'    | 'Unit' | 'Q'       |
			| 'Dress' | 'M/White'  | 'Store 01' | 'pcs'  | '100,000' |
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018001$$"
		And I save the window as "$$PurchaseInvoice018001$$"
		And I click "Post and close" button

Scenario: create PurchaseInvoice018006 based on PurchaseOrder017003
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberPurchaseOrder017003$$' |
		And I select current line in "List" table
		And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		* Check filling of elements upon entry based on
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
			Then the form attribute named "Store" became equal to "Store 02"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I select current line in "List" table
		* Check filling items table
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit' | 'Q'       |
			| 'Dress'    | '$$PurchaseOrder017003$$' | 'L/Green'  | 'pcs' | '500,000' |
		* Filling prices
			And "ItemList" table contains lines
			| 'Price' | 'Item'  | 'Item key' | 'Q'       | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '40,00' | 'Dress' | 'L/Green'  | '500,000' | 'en description is empty' | 'pcs'  | '3 050,85'   | '16 949,15'  | '20 000,00'    |
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018006$$"
		And I save the window as "$$PurchaseInvoice018006$$"
		And I click "Post and close" button

Scenario: set True value to the constant
		And I set "True" value to the constant "ShowBetaTesting"
		And I set "True" value to the constant "ShowAlphaTestingSaas"
		And I set "True" value to the constant "UseItemKey"
		And I set "True" value to the constant "UseCompanies"



	