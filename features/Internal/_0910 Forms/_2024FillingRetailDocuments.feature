#language: en
@tree
@Positive
@Group12
Feature: check filling in retail documents + currency form connection



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _0154134 preparation
	* Create Retail customer
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Retail customer" text in the field named "Description_en"
		And I change checkbox "Customer"
		And I click "Save" button
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "Company Retail customer" text in the field named "Description_en"
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I click "Save and close" button
	* Create Retail Agreement for Retail customer
		And In this window I click command interface button "Partner terms"
		And I click the button named "FormCreate"
		And I input "Retail partner term" text in the field named "Description_en"
		And I click Select button of "Date" field
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description' | 'Reference' | 'Source'       | 'Type'         |
			| 'TRY'      | 'No'                   | 'TRY'         | 'TRY'       | 'Forex Seling' | 'Partner term' |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       | 'Reference'         |
			| 'TRY'      | 'Basic Price Types' | 'Basic Price Types' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I input "01.01.2020" text in "Start using" field
		And I change "AP/AR posting detail" radio button value to "By documents"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I set checkbox "Price include tax"
		And I click "Save and close" button
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Taxes"
		And I go to line in "List" table
			| 'Description' |
			| 'VAT'         |
		And I select current line in "List" table
		And I move to "Use documents" tab
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Retail sales receipt" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And I go to line in "UseDocuments" table
			| 'Document name'      |
			| 'RetailSalesReceipt' |
		And in the table "UseDocuments" I click the button named "UseDocumentsAdd"
		And I select "Retail return receipt" exact value from "Document name" drop-down list in "UseDocuments" table
		And I finish line editing in "UseDocuments" table
		And I click "Save and close" button
	* Change discount price 2
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I go to line in "List" table
			| 'Description'      |
			| 'Discount Price 2' |
		And I select current line in "List" table
		And I activate "Rule" field in "Rules" table
		And I delete a line in "Rules" table
		And I click "Save and close" button
	* Create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And I input "Payment terminal 01" text in the field named "Description_en"
		And I click Select button of "Account" field
		Then "Cash/Bank accounts" window is opened
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I input "1,00" text in "Percent" field
		And I click "Save and close" button
	* Create PaymentTypes
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		And I click the button named "FormCreate"
		And I input "Cash" text in the field named "Description_en"
		And I select "Cash" exact value from "Type" drop-down list
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Card 01" text in the field named "Description_en"
		And I select "Card" exact value from "Type" drop-down list
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Card 02" text in the field named "Description_en"
		And I select "Card" exact value from "Type" drop-down list
		And I click "Save and close" button
	* Bank terms
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And I input "Bank term 01" text in "ENG" field
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "1,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 02'     |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Transit Second' |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "2,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And I click "Save" button
	* Create Business unit for Shop
		And In this window I click command interface button "Business unit bank terms"
		And I click the button named "FormCreate"
		And I click Select button of "Business unit" field
		Then "Business units" window is opened
		And I click the button named "FormCreate"
		And I input "Shop 01" text in "ENG" field
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click Select button of "Bank term" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I close current window
	* Filling in user default settings
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login' |
			| 'CI'    |
		And I click "Settings" button
		And I go to line in "MetadataTree" table
			| 'Group name'           |
			| 'Retail sales receipt' |
		And I activate "Group name" field in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Partner'    | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail customer' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Company'    | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'   | 'Use' |
			| 'Partner term' | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Retail partner term' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Legal name' | 'No'  |
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Company Retail customer' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name'    | 'Use' |
			| 'Business unit' | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Shop 01' |
		And I select current line in "List" table
		And I finish line editing in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Group name' |
			| 'Catalogs'   |
		And I go to line in "MetadataTree" table
			| 'Group name'    | 'Use' |
			| 'Business unit' | 'No'  |
		And I activate "Value" field in "MetadataTree" table
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I go to line in "MetadataTree" table
			| 'Group name' | 'Use' |
			| 'Store'      | 'No'  |
		And I select current line in "MetadataTree" table
		And I click choice button of "Value" attribute in "MetadataTree" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I click "Ok" button
	* Workstation
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I click the button named "FormCreate"
		And I input "Workstation 01" text in "Description" field
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I click "Set current" button
		And I click "Save and close" button
		
				

Scenario: _0154135 create document Retail Sales Receipt
	And I close all client application windows
	* Open the Retail Sales Receipt creation form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Retail customer'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
	* Check filling in Partner term if the partner has only one
		Then the form attribute named "Agreement" became equal to "Retail partner term"
	* Check filling in Store from Partner term
		Then the form attribute named "Store" became equal to "Store 01"
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 01' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  |
	* Check filling in prices on new lines at agreement reselection
		* Add line
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
				| 'Shirt'    | '350,00' | '38/Black'  | '2,000' | 'pcs'  | 'Store 01' |
	* Check filling in prices and calculate taxes when adding items via barcode search
		* Add item via barcodes
			And in the table "ItemList" I click "SearchByBarcode" button
			And I input "2202283739" text in "InputFld" field
			And Delay 4
			And I click "OK" button
			And Delay 4
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '61,02'      | '1,000' | 'pcs'  | '338,98'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '83,90'      | '1,000' | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' |
			And Delay 4
	* Check filling in prices and calculation of taxes when adding items through the goods selection form
		* Add items via Pickup form
			And in the table "ItemList" I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title' |
				| 'Dress' |
			And I select current line in "ItemList" table
			And I go to line in "ItemKeyList" table
				| 'Price'  | 'Title'   | 'Unit' |
				| '520,00' | 'XS/Blue' | 'pcs'  |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
		* Check filling in prices and tax calculation
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '61,02'      | '1,000' | 'pcs'  | '338,98'     | '400,00'       | 'Store 01' |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '83,90'      | '1,000' | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       | 'Store 01' |
	* Check the line clearing in the tax tree when deleting a line from an order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		Then the form attribute named "ItemListTotalNetAmount" became equal to "1 500"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "270,00"
	* Check tax recalculation when uncheck/re-check Price include Tax
		* Unchecking box Price include Tax
			And I move to "Other" tab
			And I expand "More" group
			And I remove checkbox "Price include tax"
		* Tax recalculation check
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '126,00'     | '2,000' | 'pcs'  | '700,00'     | '826,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '99,00'      | '1,000' | 'pcs'  | '550,00'     | '649,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '93,60'      | '1,000' | 'pcs'  | '520,00'     | '613,60'       | 'Store 01' |
		* Tick Price include Tax and check the calculation
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Price include tax"
			And I move to "Item list" tab
			And "ItemList" table contains lines
				| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Tax amount' | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
				| '350,00' | 'Shirt'    | '18%' | '38/Black'  | '106,78'     | '2,000' | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' |
				| '550,00' | 'Dress'    | '18%' | 'L/Green'   | '83,90'      | '1,000' | 'pcs'  | '466,10'     | '550,00'       | 'Store 01' |
				| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '79,32'      | '1,000' | 'pcs'  | '440,68'     | '520,00'       | 'Store 01' |
		* Check filling in currency tab
			And I click "Save" button
			And I move to the tab named "GroupCurrency"
			And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Local currency'     | 'Legal'     | 'TRY'           | 'TRY'      | '1'                 | '1 770'  | '1'            |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '303,08' | '1'            |
		* Check discount calculation
			And I move to "Item list" tab
			And in the table "ItemList" I click "% Offers" button
			Then "Pickup special offers" window is opened
			And I go to line in "Offers" table
				| 'Presentation'     |
				| 'Discount Price 2' |
			And I activate "Is select" field in "Offers" table
			And I select current line in "Offers" table
			And in the table "Offers" I click "OK" button
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'     | 'Offers amount' | 'Unit' |
				| 'Shirt' | '350,00' | '38/Black' | '2,000' | '212,00'        | 'pcs'  |
				| 'Dress' | '550,00' | 'L/Green'  | '1,000' | '137,00'        | 'pcs'  |
				| 'Dress' | '520,00' | 'XS/Blue'  | '1,000' | '131,00'        | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 290,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt0154135$$"
			And I click "Post" button
			And I save the window as "$$RetailSalesReceipt015413$$"
			And I click "Post and close" button
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt0154135$$'      |
			And I close all client application windows
			

Scenario: _0154136 create document Retail Return Receipt based on RetailSalesReceipt
	* Select Retail sales receipt for Retail Return Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt0154135$$'      |
	* Create Retail Return Receipt
		And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
	* Check filling in
		Then the form attribute named "DecorationGroupTitleCollapsedPicture" became equal to "Decoration group title collapsed picture"
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Partner: Retail customer   Legal name: Company Retail customer   Partner term: Retail partner term   "
		Then the form attribute named "DecorationGroupTitleUncollapsedPicture" became equal to "DecorationGroupTitleUncollapsedPicture"
		Then the form attribute named "DecorationGroupTitleUncollapsedLabel" became equal to "Company: Main Company   Partner: Retail customer   Legal name: Company Retail customer   Partner term: Retail partner term   "
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Retail sales receipt'          |
			| '350,00' | 'Shirt' | '18%' | '38/Black' | '2,000' | '212,00'        | '74,44'      | 'pcs'  | '413,56'     | '488,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '137,00'        | '63,00'      | 'pcs'  | '350,00'     | '413,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
			| '520,00' | 'Dress' | '18%' | 'XS/Blue'  | '1,000' | '131,00'        | '59,34'      | 'pcs'  | '329,66'     | '389,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
		Then the form attribute named "IsOpeningEntry" became equal to "No"
		Then the form attribute named "Currency" became equal to "TRY"
	* Check filling in Payments type from Retail sales receipt
		And "Payments" table became equal
			| 'Payment type' | 'Payment terminal'    | 'Account'      | 'Commission' | 'Amount'   | 'Percent' |
			| 'Card 01'      | 'Payment terminal 01' | 'Transit Main' | '12,90'      | '1 290,00' | '1,00'    |
	* Change quantity and post document
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
			| 'Shirt' | '38/Black' | '350,00' | '2,000' |
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Q'     |
			| 'Dress' | 'XS/Blue'  | '520,00' | '1,000' |
		And I delete a line in "ItemList" table
		And "ItemList" table contains lines
		| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Retail sales receipt'          |
		| '350,00' | 'Shirt' | '18%' | '38/Black' | '1,000' | '106,00'        | '35,69'      | 'pcs'  | '198,31'     | '234,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
		| '550,00' | 'Dress' | '18%' | 'L/Green'  | '1,000' | '137,00'        | '63,00'      | 'pcs'  | '350,00'     | '413,00'       | 'Store 01' | '$$RetailSalesReceipt015413$$' |
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "657,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
	* Post Retail return receipt
		And I move to "Other" tab
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt0154136$$"
		And I save the window as "$$RetailReturnReceipt0154136$$"
		And I click "Post and close" button
		And "List" table contains lines
		| 'Number' |
		| '$$NumberRetailReturnReceipt0154136$$'      |
		And I close all client application windows


Scenario: _0154137 create document Retail Sales Receipt from Point of sale (payment by cash)
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Quantity'  | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'     | '550,00' | ''              | '550,00'       |
	* Add product (pick up)
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table became equal
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		Then the form attribute named "ItemListTotalQuantity" became equal to "2"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "950"
	* Change quantity and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity'  | 'Total amount' |
			| 'Dress' | 'L/Green'  | '550,00' | '1,000'     | '550,00'       |
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalQuantity" became equal to "4"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "2 050"
		And Delay 2
	* Payment (Cash)
		And I click "Payment (+)" button
		And I click "2" button
		And I click "0" button
		And I click "5" button
		And I click "1" button
		Then the form attribute named "Amount" became equal to "2 050"
		Then the form attribute named "DecorationAmountAfter" became equal to "Decoration amount after"
		And "Payments" table became equal
			| 'Payment type' | 'Amount'   |
			| 'Cash'         | '2 051,00' |
		Then the form attribute named "Cashback" became equal to "1"
		And I click "Enter" button
		And "ItemList" table does not contain lines
			| 'Item'     | 'Item key'  | 'Quantity'  | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'     | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'     | '400,00' | ''              | '400,00'       |
		And I close current window
		And Delay 2
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Business unit' | 'Revenue type' | 'Item'     | 'Price type'        | 'Item key'  | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' |
			| 'Shop 01'       | ''             | 'Dress'    | 'Basic Price Types' | 'L/Green'   | '3,000' | 'pcs'  | '251,69'     | '550,00' | '18%' | ''              | '1 398,31'   | '1 650,00'     | ''                    | 'Store 01' | ''       |
			| 'Shop 01'       | ''             | 'Trousers' | 'Basic Price Types' | '38/Yellow' | '1,000' | 'pcs'  | '61,02'      | '400,00' | '18%' | ''              | '338,98'     | '400,00'       | ''                    | 'Store 01' | ''       |
		And "Payments" table contains lines
			| 'Amount'   | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term' | 'Account' | 'Percent' |
			| '2 050,00' | ''           | 'Cash'         | ''                 | ''          | 'Cash desk №2'        | ''        |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "1 737,29"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "312,71"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "2 050,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows
		


Scenario: _0154138 create document Retail Sales Receipt from Point of sale (payment by card)
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product (scan)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Quantity'| 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'   | '550,00' | ''              | '550,00'       |
	* Add product (pick up)
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table became equal
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		Then the form attribute named "ItemListTotalQuantity" became equal to "2"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "950"
	* Change quantity and check amount recalculate
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '550,00' | '1,000'    | '550,00'       |
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And Delay 4
		And I finish line editing in "ItemList" table
		Then the form attribute named "ItemListTotalQuantity" became equal to "4"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "2 050"
		And Delay 4
	* Payment (Card)
		And I click "Payment (+)" button
		And I click "Card (*)" button
		And I click "Card 01" button
		And I click "2" button
		And I click "0" button
		And I click "5" button
		And I click "0" button
		Then the form attribute named "Amount" became equal to "2 050"
		Then the form attribute named "DecorationAmountAfter" became equal to "Decoration amount after"
		And "Payments" table became equal
			| 'Payment type'    | 'Amount'   |
			| 'Card 01'         | '2 050,00' |
		And I click "Enter" button
		And Delay 4
		And "ItemList" table does not contain lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		And I close current window
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Business unit' | 'Revenue type' | 'Item'     | 'Price type'        | 'Item key'  | 'Q'     | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' |
			| 'Shop 01'       | ''             | 'Dress'    | 'Basic Price Types' | 'L/Green'   | '3,000' | 'pcs'  | '251,69'     | '550,00' | '18%' | ''              | '1 398,31'   | '1 650,00'     | ''                    | 'Store 01' | ''       |
			| 'Shop 01'       | ''             | 'Trousers' | 'Basic Price Types' | '38/Yellow' | '1,000' | 'pcs'  | '61,02'      | '400,00' | '18%' | ''              | '338,98'     | '400,00'       | ''                    | 'Store 01' | ''       |
		And "Payments" table contains lines
			| 'Amount'   | 'Commission'      | 'Payment type'    | 'Payment terminal' | 'Bank term'             | 'Account'             | 'Percent'     |
			| '2 050,00' | '20,50'           | 'Card 01'         | ''                 | 'Bank term 01'          | 'Transit Main'        | '1,00'        |
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "1 737,29"
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "312,71"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "2 050,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows

Scenario: _0154139 check payments form in the Point of sale
		And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add products
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'M/White'      |
		And I select current line in "ItemKeysPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow'    |
		And I select current line in "ItemKeysPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'       |
			| 'High shoes' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '37/19SD'      |
		And I select current line in "ItemKeysPickup" table
	* Check amount calculation
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "ItemListTotalQuantity" became equal to "3"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "1 460"
	* Check payments calculation
		* Cash 1520.10
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			And I click "5" button
			And I click "2" button
			And I click "0" button
			And I click "." button
			And I click "1" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 520,10' |
			Then the form attribute named "Cashback" became equal to "60,1"
		* Cash 1500.25
			And I click "C" button
			And I click "1" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "2" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 500,25' |
			Then the form attribute named "Cashback" became equal to "40,25"
		* Cash 2000.99
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '2 000,99' |
			Then the form attribute named "Cashback" became equal to "540,99"
		* Cash 20 000.01
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "0" button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '20 000,01' |
			Then the form attribute named "Cashback" became equal to "18 540,01"
		* Cash 200 000.00
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,00' |
			Then the form attribute named "Cashback" became equal to "198 540"
		* Cash 200 000.50
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "5" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,50' |
			Then the form attribute named "Cashback" became equal to "198 540,5"
		* Cash 200 000.55
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "5" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,55' |
			Then the form attribute named "Cashback" became equal to "198 540,55"
		* Cash 200 000
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '200 000,00' |
			Then the form attribute named "Cashback" became equal to "198 540"
		* Cash 2 000 000
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '2 000 000,00' |
			Then the form attribute named "Cashback" became equal to "1 998 540"
		* Cash 20 000 000.05
			And I click "C" button
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "0" button
			And I click "5" button
			Then the form attribute named "Amount" became equal to "1 460"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '20 000 000,05' |
			Then the form attribute named "Cashback" became equal to "19 998 540,05"
		* Cash 0.950076
			And I click "C" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "7" button
			And I click "6" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '0,95' |
		* Cash 09500.73
			And I click "C" button
			And I click "0" button
			And I click "9" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "7" button
			And I click "3" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '9 500,73' |
			Then the form attribute named "Cashback" became equal to "8 040,73"
		* Card 100.12 + Cash 2500.88
			And I click "C" button
			And I click "2" button
			And I click "5" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "8" button
			And I click "8" button
			And I click "Card (*)" button
			And I click "Card 01" button
			And I click "1" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "1" button
			And I click "2" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '2 500,88' |
				| 'Card 01'      | '100,12' |
			Then the form attribute named "Cashback" became equal to "1 141"
		* Card 1459.10 + Cash 0.90
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Cash'         |
			And I click "C" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "9" button
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Card 01'      |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And I click "." button
			And I click "1" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '0,99'     |
				| 'Card 01'      | '1 459,1'   |
			Then the form attribute named "Cashback" became equal to "0,09"
		* Card 1459.10 + Cash 1.00
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Cash'         |
			And I click "C" button
			And I click "1" button
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Card 01'      |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And I click "." button
			And I click "1" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00'     |
				| 'Card 01'      | '1 459,1'   |
			Then the form attribute named "Cashback" became equal to "0,1"
		* Card 1459.00 + Cash 1.00
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Cash'         |
			And I click "C" button
			And I click "1" button
			And I go to line in "Payments" table
				| 'Payment type' |
				| 'Card 01'      |
			And I click "C" button
			And I click "1" button
			And I click "4" button
			And I click "5" button
			And I click "9" button
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00'     |
				| 'Card 01'      | '1 459'   |
			Then the form attribute named "Cashback" became equal to "0"
		* Auto calculation balance of payment
			* Card 560 + Cash 900
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Card 01'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Cash'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button
				And I click "Card 01" button
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,00'   |
					| 'Cash'         | '900,00'     |
				Then the form attribute named "Cashback" became equal to "0"
			* Card 560,12 + Cash 899,88
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Card 01'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Cash'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button
				And I click "Card 01" button
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "." button
				And I click "1" button
				And I click "2" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,12'   |
					| 'Cash'         | '899,88'     |
				Then the form attribute named "Cashback" became equal to "0"
			* Card 560,40 + Cash 899,60
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Card 01'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I go to line in "Payments" table
					| 'Payment type' |
					| 'Cash'      |
				And I click the button named "PaymentsContextMenuDelete"
				And I click "Card (*)" button
				And I click "Card 01" button
				And I click "5" button
				And I click "6" button
				And I click "0" button
				And I click "." button
				And I click "4" button
				And I click "0" button
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,40'   |
					| 'Cash'         | '899,60'     |
				Then the form attribute named "Cashback" became equal to "0"
			* Clean cash amount and check auto filling
				And I go to line in "Payments" table
					| 'Amount' | 'Payment type' |
					| '899,60' | 'Cash'         |
				And I click "C" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,40'   |
					| 'Cash'         | '0'     |
				And I click "Cash (/)" button
				And "Payments" table became equal
					| 'Payment type' | 'Amount'   |
					| 'Card 01'      | '560,40'   |
					| 'Cash'         | '899,60'     |
				And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 1 299 754,89
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I input "2 499,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "520,11" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 1 400 000
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			And I click "4" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 400 000,00' |
			Then the form attribute named "Cashback" became equal to "98 785,11"
		* Cash 1 301 215,90
			And I click "C" button
			And I click "1" button
			And I click "3" button
			And I click "0" button
			And I click "1" button
			And I click "2" button
			And I click "1" button
			And I click "5" button
			And I click "." button
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 301 215,90' |
			Then the form attribute named "Cashback" became equal to "1,01"
		* Cash 1 301 214,90
			And I click "C" button
			And I click "1" button
			And I click "3" button
			And I click "0" button
			And I click "1" button
			And I click "2" button
			And I click "1" button
			And I click "4" button
			And I click "." button
			And I click "9" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1 301 214,90' |
			Then the form attribute named "Cashback" became equal to "0,01"
		* Cash 10 000 000,98
			And I click "C" button
			And I click "1" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "0" button
			And I click "." button
			And I click "9" button
			And I click "8" button
			Then the form attribute named "Amount" became equal to "1 301 214,89"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '10 000 000,98' |
			Then the form attribute named "Cashback" became equal to "8 698 786,09"
			And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 0,4
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"

		And I go to line in "ItemList" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "0,4" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 1,00
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "0,4"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00' |
			Then the form attribute named "Cashback" became equal to "0,6"
			And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 0,41
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "0,41" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 1,00
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "0,41"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '1,00' |
			Then the form attribute named "Cashback" became equal to "0,59"
			And I close "Payment: Point of sale" window
	* New retail sales receipt with amount 0,09
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| 'XS/Blue'      |
		And I select current line in "ItemKeysPickup" table
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "0,09" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check payments calculation
		* Cash 0,1
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "0" button
			And I click "." button
			And I click "1" button
			Then the form attribute named "Amount" became equal to "0,09"
			And "Payments" table became equal
				| 'Payment type' | 'Amount'   |
				| 'Cash'         | '0,10' |
			Then the form attribute named "Cashback" became equal to "0,01"
			And I close "Payment: Point of sale" window
		And I close all client application windows
		
Scenario: _0154140 check filling in retail customer from the POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add products
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
				| 'Item'  |
				| 'Dress' |
			And I go to line in "ItemKeysPickup" table
				| 'Presentation' |
				| 'M/White'      |
			And I select current line in "ItemKeysPickup" table
	* Create Retail customer
		And I click "Search customer" button
		And I input "9088090889980" text in "ID" field
		And I input "Olga" text in "Name" field
		And I input "Olhovska" text in "Surname" field
		And I click "OK" button
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "Enter" button
	* Check Retail Sales Receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "RetailCustomer" became equal to "Olga Olhovska"
	And I close all client application windows	

Scenario:  _0154141 manual price adjustment in the POS
	And I close all client application windows
	* Open Point of sale
		And In the command interface I select "Retail" "Point of sale"
	* Add product
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity'  | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress' | 'L/Green'  | '1,000'     | '550,00' | ''              | '550,00'       |
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '38/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
	* Price adjustment
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Trousers' | '38/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Add one more items and check price filling
		And I click "Search by barcode (F7)" button
		And I input "2202283713" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '200,00' | ''              | '200,00'       |
			| 'Dress'    | 'S/Yellow'  | '1,000'    | '550,00' | ''              | '550,00'       |
		And I go to line in "ItemsPickup" table
			| 'Item'     |
			| 'Trousers' |
		And I activate field named "ItemsPickupItem" in "ItemsPickup" table
		And I go to line in "ItemKeysPickup" table
			| 'Presentation' |
			| '36/Yellow' |
		And I select current line in "ItemKeysPickup" table
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Quantity' | 'Price'  | 'Offers amount' | 'Total amount' |
			| 'Dress'    | 'L/Green'   | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '38/Yellow' | '1,000'    | '200,00' | ''              | '200,00'       |
			| 'Dress'    | 'S/Yellow'  | '1,000'    | '550,00' | ''              | '550,00'       |
			| 'Trousers' | '36/Yellow' | '1,000'    | '400,00' | ''              | '400,00'       |
		And I close all client application windows

Scenario:  _0154148 check that the Retail return receipt amount and the amount of payment must match
	* Create Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail customer' |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "600,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post" button
		Then I wait that in user messages the "Payment amount [600,00] and return amount [500,00] not match" substring will appear in 10 seconds
		And I move to "Item list" tab
		And I select current line in "ItemList" table
		And I input "700,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
	* Check that the Retail return receipt amount and the amount of payment match
		Then I wait that in user messages the "Payment amount [600,00] and return amount [700,00] not match" substring will appear in 10 seconds
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And I finish line editing in "Payments" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "120,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post" button
		Then I wait that in user messages the "Payment amount [720,00] and return amount [700,00] not match" substring will appear in 10 seconds
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Payment amount [720,00] and return amount [900,00] not match" substring will appear in 10 seconds
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click "Post" button
		Then I wait that in user messages the "Payment amount [720,00] and return amount [700,00] not match" substring will appear in 10 seconds
		And I close all client application windows
		

Scenario:  _0154149 create Cash statement
	* Delete variables
		And I delete '$$NumberRetailSalesReceipt01541491$$' variable
		And I delete '$$RetailSalesReceipt01541491$$' variable
		And I delete '$$NumberRetailSalesReceipt01541492$$' variable
		And I delete '$$RetailSalesReceipt01541492$$' variable
		And I delete '$$NumberRetailSalesReceipt01541493$$' variable
		And I delete '$$RetailSalesReceipt01541493$$' variable
		And I delete '$$NumberRetailSalesReceipt01541494$$' variable
		And I delete '$$RetailSalesReceipt01541494$$' variable
		And I delete '$$NumberRetailReturnReceipt01541491$$' variable
		And I delete '$$RetailReturnReceipt01541491$$' variable
		And I delete '$$NumberRetailReturnReceipt01541493$$' variable
		And I delete '$$RetailReturnReceipt01541493$$' variable
		And I delete '$$NumberRetailReturnReceipt01541494$$' variable
		And I delete '$$RetailReturnReceipt01541494$$' variable
	* Create Cash statement statuses
		* Done
			Given I open hyperlink "e1cib/list/Catalog.CashStatementStatuses"
			And I click the button named "FormCreate"
			And I input "Done" text in "ENG" field
			And I change checkbox "Forbid corrections"
			And I click "Save and close" button
		* Create
			And I click the button named "FormCreate"
			And I input "Create" text in "ENG" field
			And I click "Save and close" button
	* Create RetailSalesReceipt01541491
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' |
				| 'Trousers' | '400,00' | '38/Yellow' | '1,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "400,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 00:00:00" text in "Date" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541491$$"
			And I save the window as "$$RetailSalesReceipt01541491$$"
			And I click "Post and close" button
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541491$$'      |
			And I close all client application windows
	* Create RetailSalesReceipt01541492
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Dress' | 'L/Green' |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Dress' | '550,00' | 'L/Green'  | '2,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Cash'        |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 100,00" text in "Amount" field of "Payments" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №4' |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 12:50:00" text in "Date" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541492$$"
			And I save the window as "$$RetailSalesReceipt01541492$$"
			And I click "Post and close" button
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541492$$'      |
			And I close all client application windows
	* Create RetailSalesReceipt01541493
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "4,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Shirt' | '350,00' | '38/Black'  | '4,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Cash'        |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 200,00" text in "Amount" field of "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №4' |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "200,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "01.09.2020 16:40:04" text in "Date" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541493$$"
			And I save the window as "$$RetailSalesReceipt01541493$$"
			And I click "Post and close" button
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541493$$'      |
			And I close all client application windows
		* Create RetailSalesReceipt01541494
			And I close all client application windows
		* Open the Retail Sales Receipt creation form
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Check filling in legal name if the partner has only one
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Retail customer'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
		* Check filling in Partner term if the partner has only one
			Then the form attribute named "Agreement" became equal to "Retail partner term"
		* Check filling in Store from Partner term
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I input "4,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Check filling in prices
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'     | 'Unit' |
				| 'Shirt' | '350,00' | '38/Black'  | '4,000' | 'pcs'  |
		* Filling in payment tab
			And I move to "Payments" tab
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Cash'        |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "1 200,00" text in "Amount" field of "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №4' |
			And I select current line in "List" table
			And I finish line editing in "Payments" table
			And in the table "Payments" I click "Add" button
			And I click choice button of "Payment type" attribute in "Payments" table
			Then "Payment types" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Card 01'        |
			And I select current line in "List" table
			And I activate "Payment terminal" field in "Payments" table
			And I click choice button of "Payment terminal" attribute in "Payments" table
			Then "Payment terminals" window is opened
			And I go to line in "List" table
				| 'Description'         |
				| 'Payment terminal 01' |
			And I select current line in "List" table
			And I activate "Account" field in "Payments" table
			And I click choice button of "Account" attribute in "Payments" table
			Then "Cash/Bank accounts" window is opened
			And I go to line in "List" table
				| 'Description'  |
				| 'Transit Main' |
			And I select current line in "List" table
			And I activate "Amount" field in "Payments" table
			And I input "200,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Percent" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1,00" text in "Percent" field of "Payments" table
			And I finish line editing in "Payments" table
			And I activate "Commission" field in "Payments" table
			And I select current line in "Payments" table
			And I input "12,90" text in "Commission" field of "Payments" table
			And I finish line editing in "Payments" table
		* Post Retail sales receipt
			And I input "31.08.2020 12:40:04" text in "Date" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt01541494$$"
			And I save the window as "$$RetailSalesReceipt01541494$$"
			And I click "Post and close" button
			And "List" table contains lines
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541494$$'      |
			And I close all client application windows
	* Create Retail return receipt based on RetailSalesReceipt01541494
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541494$$'      |
		And I activate "Date" field in "List" table
		And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "500,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I go to line in "Payments" table
			| '#' | 'Account'      | 'Amount' | 'Commission' | 'Payment terminal'    | 'Payment type' | 'Percent' |
			| '2' | 'Transit Main' | '200,00' | '12,90'      | 'Payment terminal 01' | 'Card 01'      | '1,00'    |
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I input "01.09.2020 13:40:04" text in "Date" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541494$$"
		And I save the window as "$$RetailReturnReceipt01541494$$"
		And I click "Post and close" button
	* Create Retail return receipt based on RetailSalesReceipt01541493
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541493$$'      |
		And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
		Then "Retail return receipt (create)" window is opened
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "350,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I go to line in "Payments" table
			| '#' | 'Account'      | 'Amount' | 'Commission' | 'Payment terminal'    | 'Payment type' | 'Percent' |
			| '2' | 'Transit Main' | '200,00' | '12,90'      | 'Payment terminal 01' | 'Card 01'      | '1,00'    |
		And I delete a line in "Payments" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I input "01.09.2020 15:31:04" text in "Date" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541493$$"
		And I save the window as "$$RetailReturnReceipt01541493$$"
		And I click "Post and close" button
	* Create Retail return receipt based on RetailSalesReceipt01541491
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberRetailSalesReceipt01541491$$'      |
		And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
		And I move to "Payments" tab
		And I click "Post and close" button
		And I click Select button of "Business unit" field
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I input "01.09.2020 16:55:04" text in "Date" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberRetailReturnReceipt01541491$$"
		And I save the window as "$$RetailReturnReceipt01541491$$"
		And I click "Post and close" button
	* Create Cash Statement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Status" field
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Done'        | 'Done'      |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table
		And I click Select button of "Transaction period" field
		Then "Select period" window is opened
		And I input "01.09.2020" text in "DateBegin" field
		And I input "01.09.2020" text in "DateEnd" field
		And I click "Select" button
		And I click "Fill transactions" button
		* Check filling in Cash transaction tab
			And I move to "Cash transaction" tab
			And "CashTransactionList" table contains lines
				| 'Document'                        | 'Receipt'  | 'Expense' |
				| '$$RetailSalesReceipt01541492$$'  | '1 100,00' | ''        |
				| '$$RetailReturnReceipt01541494$$' | ''         | '700,00'  |
				| '$$RetailReturnReceipt01541493$$' | ''         | '350,00'  |
				| '$$RetailSalesReceipt01541493$$'  | '1 400,00' | ''        |
				| '$$RetailSalesReceipt01541491$$'  | '400,00'   | ''        |
				| '$$RetailReturnReceipt01541491$$' | ''         | '400,00'  |
			And "Payments" table contains lines
				| 'Payment type' | 'Account'      | 'Commission' | 'Amount'   |
				| 'Cash'         | 'Cash desk №4' | ''           | '1 450,00' |
				| 'Card 01'      | 'Transit Main' | '51,60'      | ''         |
			Then the number of "Payments" table lines is "меньше или равно" 2
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberCashStatement01541491$$"
		And I save the window as "$$CashStatement01541491$$"
		And I click "Post and close" button
		And "List" table contains lines
				| 'Number'                        |
				| '$$NumberCashStatement01541491$$'  |