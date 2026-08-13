#language: en
@tree
@Positive
@Discount

Feature: check discounts in the Sales return and Sales return order


Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _034801 preparation
	* Activating discount Document discount
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'          |
			| 'Document discount'    |
		And I select current line in "List" table
		And I set checkbox "Launch"
		And I click "Save and close" button
	* Create document discount 2
		When Create document discount2
	* Create test Sales invoice
		When create SalesInvoice024025
	* Calculate document discount for Sales invoice 024025
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| "Number"                          |
			| "$$NumberSalesInvoice024025$$"    |
		And I select current line in "List" table
	* Calculate Document discount for Sales invoice
		And I click "% Offers" button
		And I expand current line in "Offers" table
		And I go to line in "Offers" table
			| 'Presentation'         |
			| 'Document discount'    |
		And I select current line in "Offers" table
		And I change the radio button named "Type" value to "Percent"		
		And I input "10,00" text in "Percent" field
		And I click "Ok" button
		And in the table "Offers" I click "OK" button
	* Check the discount calculation
		And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Offers amount'   | 'Unit'   | 'Total amount'   | 'Tax amount'   | 'Net amount'    |
			| 'Dress'   | '550,00'   | 'L/Green'    | '20,000'     | '1 100,00'        | 'pcs'    | '9 900,00'       | '1 510,17'     | '8 389,83'      |
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "1 100,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "8 389,83"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 510,17"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "9 900,00"
		And I click the button named "FormPostAndClose"			
		And I close all client application windows
	
Scenario: _0348011 check preparation
	When check preparation

Scenario: _034802 check discount recalculation when change quantity in the SaLes return order
	And I close all client application windows
	* Document discount
		* Create Purchase return based on $$SalesInvoice024025$$
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number'                           |
				| '$$NumberSalesInvoice024025$$'     |
			And I click the button named "FormDocumentSalesReturnOrderGenerate"
			And I click "Ok" button	
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "1 100,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "8 389,83"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 510,17"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "9 900,00"
			And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Offers amount'   | 'Unit'   | 'Total amount'   | 'Tax amount'   | 'Net amount'    |
			| 'Dress'   | '550,00'   | 'L/Green'    | '20,000'     | '1 100,00'        | 'pcs'    | '9 900,00'       | '1 510,17'     | '8 389,83'      |
		* Change quantity and check discount recalculation
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'    | 'Quantity'     |
				| 'Dress'    | 'L/Green'     | '20,000'       |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "55,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "419,49"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "75,51"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "495,00"
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Quantity'    | 'Offers amount'    | 'Unit'    | 'Total amount'    | 'Tax amount'    | 'Net amount'     |
				| 'Dress'    | '550,00'    | 'L/Green'     | '1,000'       | '55,00'            | 'pcs'     | '495,00'          | '75,51'         | '419,49'         |
			And I click the button named "FormPostAndClose"			

Scenario: _034803 check discount recalculation when change quantity in the SaLes return order
	* Document discount
		* Create Purchase return based on $$SalesInvoice024025$$
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number'                           |
				| '$$NumberSalesInvoice024025$$'     |
			And I click the button named "FormDocumentSalesReturnGenerate"
			And I click "Ok" button	
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "1 100,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "8 389,83"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 510,17"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "9 900,00"
			And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Offers amount'   | 'Unit'   | 'Total amount'   | 'Tax amount'   | 'Net amount'    |
			| 'Dress'   | '550,00'   | 'L/Green'    | '20,000'     | '1 100,00'        | 'pcs'    | '9 900,00'       | '1 510,17'     | '8 389,83'      |
		* Change quantity and check discount recalculation
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'    | 'Quantity'     |
				| 'Dress'    | 'L/Green'     | '20,000'       |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "55,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "419,49"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "75,51"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "495,00"
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Quantity'    | 'Offers amount'    | 'Unit'    | 'Total amount'    | 'Tax amount'    | 'Net amount'     |
				| 'Dress'    | '550,00'    | 'L/Green'     | '1,000'       | '55,00'            | 'pcs'     | '495,00'          | '75,51'         | '419,49'         |
			And I click the button named "FormPostAndClose"	

Scenario: _034804 check 2 Document Discount (percent)
	And I close all client application windows
	* Create SI (one line)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
	* Filling SI
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '37/18SD'     |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check 2 Document discount for one line
		* First discount
			And in the table "ItemList" I click "% Offers" button
			Then "Pickup special offers" window is opened
			And I go to line in "Offers" table
				| 'Is select'    | 'Presentation'          |
				| '☐'            | 'Document discount'     |
			And I activate "Presentation" field in "Offers" table
			And I select current line in "Offers" table
			And I change the radio button named "Type" value to "Percent"
			And I input "10,00" text in the field named "Percent"
			And I click the button named "Ok"
			And in the table "Offers" I click "OK" button
			And "ItemList" table contains lines
				| 'Item key'    | 'Tax amount'    | 'Price'     | 'Offers amount'    | 'Net amount'    | 'Total amount'     |
				| '37/18SD'     | '192,20'        | '700,00'    | '140,00'           | '1 067,80'      | '1 260,00'         |
		* Second discount
			And in the table "ItemList" I click "% Offers" button
			Then "Pickup special offers" window is opened
			And I go to line in "Offers" table
				| 'Is select'    | 'Presentation'            |
				| '☐'            | 'Document discount 2'     |
			And I activate "Presentation" field in "Offers" table
			And I select current line in "Offers" table
			And I change the radio button named "Type" value to "Percent"
			And I input "15,00" text in the field named "Percent"
			And I click the button named "Ok"
			And in the table "Offers" I click "OK" button
			And "ItemList" table contains lines
				| 'Item key'    | 'Tax amount'    | 'Price'     | 'Offers amount'    | 'Net amount'    | 'Total amount'     |
				| '37/18SD'     | '160,17'        | '700,00'    | '350,00'           | '889,83'        | '1 050,00'         |
		* Check offers tab
			And I move to "Special offers" tab
			And "SpecialOffers" table contains lines
				| 'Amount'    | 'Special offer'           |
				| '140,00'    | 'Document discount'       |
				| '210,00'    | 'Document discount 2'     |
			Then the number of "SpecialOffers" table lines is "равно" "2"
		* Post document
			And I click "Post" button		
			And I save the value of "Number" field as "NumberSI"
			And I click "Post and close" button
		* Reopen document and check discount
			And I close all client application windows
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number'         |
				| '$NumberSI$'     |
			And I select current line in "List" table
			And "SpecialOffers" table contains lines
				| 'Amount'    | 'Special offer'           |
				| '140,00'    | 'Document discount'       |
				| '210,00'    | 'Document discount 2'     |
			Then the number of "SpecialOffers" table lines is "равно" "2"
			And I close all client application windows


Scenario: _034805 check 2 Document Discount (sum)
	And I close all client application windows
	* Create SI (one line)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
	* Filling SI
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '37/18SD'     |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check 2 Document discount for one line
		* First discount
			And in the table "ItemList" I click "% Offers" button
			Then "Pickup special offers" window is opened
			And I go to line in "Offers" table
				| 'Is select'    | 'Presentation'          |
				| '☐'            | 'Document discount'     |
			And I activate "Presentation" field in "Offers" table
			And I select current line in "Offers" table
			And I change the radio button named "Type" value to "Amount"			
			And I input "10,00" text in the field named "Amount"
			And I click the button named "Ok"
			And in the table "Offers" I click "OK" button
			And "ItemList" table contains lines
				| 'Item key'    | 'Tax amount'    | 'Price'     | 'Offers amount'    | 'Net amount'    | 'Total amount'     |
				| '37/18SD'     | '212,03'        | '700,00'    | '10,00'            | '1 177,97'      | '1 390,00'         |
		* Second discount
			And in the table "ItemList" I click "% Offers" button
			Then "Pickup special offers" window is opened
			And I go to line in "Offers" table
				| 'Is select'    | 'Presentation'            |
				| '☐'            | 'Document discount 2'     |
			And I activate "Presentation" field in "Offers" table
			And I select current line in "Offers" table
			And I change the radio button named "Type" value to "Amount"
			And I input "20,00" text in the field named "Amount"
			And I click the button named "Ok"
			And in the table "Offers" I click "OK" button
			And "ItemList" table contains lines
				| 'Item key'    | 'Tax amount'    | 'Price'     | 'Offers amount'    | 'Net amount'    | 'Total amount'     |
				| '37/18SD'     | '208,98'        | '700,00'    | '30,00'            | '1 161,02'      | '1 370,00'         |
		* Check offers tab
			And I move to "Special offers" tab
			And "SpecialOffers" table contains lines
				| 'Amount'    | 'Special offer'           |
				| '10,00'     | 'Document discount'       |
				| '20,00'     | 'Document discount 2'     |
			Then the number of "SpecialOffers" table lines is "равно" "2"
		* Post document
			And I click "Post" button		
			And I save the value of "Number" field as "NumberSI"
			And I click "Post and close" button
		* Reopen document and check discount
			And I close all client application windows
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number'         |
				| '$NumberSI$'     |
			And I select current line in "List" table
			And "SpecialOffers" table contains lines
				| 'Amount'    | 'Special offer'           |
				| '10,00'     | 'Document discount'       |
				| '20,00'     | 'Document discount 2'     |
			Then the number of "SpecialOffers" table lines is "равно" "2"
			And I close all client application windows
			
Scenario: _034806 check additional manual discount (SO-SI-SR)
	And I close all client application windows
	* Create SO (document discount)
		* Open form for creating Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling in customer's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'      |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'            |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'M/White'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '1'    | 'Dress'    | 'M/White'     | 'pcs'      |
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "100" text in "Quantity" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '2'    | 'Dress'    | 'L/Green'     | 'pcs'      |
			And I select current line in "ItemList" table
			And I input "200" text in "Quantity" field of "ItemList" table
			And I input "210" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'        | 'Item key'     | 'Unit'     |
				| '3'    | 'Trousers'    | '36/Yellow'    | 'pcs'      |
			And I select current line in "ItemList" table
			And I input "300" text in "Quantity" field of "ItemList" table
			And I input "250" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Dicount calculation
			And I go to line in "ItemList" table
				| "#" | "Item"  | "Item key" | "Net amount" | "Price"  | "Quantity" | "Tax amount" | "Total amount" | "Unit" | "VAT" |
				| "1" | "Dress" | "M/White"  | "16 949,15"  | "200,00" | "100,000"  | "3 050,85"   | "20 000,00"    | "pcs"  | "18%" |
			And I move one line down in "ItemList" table and select line
			And in the table "ItemList" I click "% Discount" button
			Then "Pickup special offers" window is opened
			And I activate "Amount" field in "Offers" table
			And I go to line in "Offers" table
				| 'Presentation'              |
				| 'Discount for selected row' |
			And I select current line in "Offers" table
			And I change the radio button named "Type" value to "Percent"
			And I input "10,00" text in the field named "Percent"
			And I click the button named "Ok"
			Then "Pickup special offers" window is opened
			And in the table "Offers" I click "OK" button
		* Check discount calculation
			And "ItemList" table became equal
				| '#' | 'Item'     | 'Item key'  | 'Quantity' | 'Unit' | 'Price'  | 'VAT' | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
				| '1' | 'Dress'    | 'M/White'   | '100,000'  | 'pcs'  | '200,00' | '18%' | '2 000,00'      | '2 745,76'   | '15 254,24'  | '18 000,00'    |
				| '2' | 'Dress'    | 'L/Green'   | '200,000'  | 'pcs'  | '210,00' | '18%' | '4 200,00'      | '5 766,10'   | '32 033,90'  | '37 800,00'    |
				| '3' | 'Trousers' | '36/Yellow' | '300,000'  | 'pcs'  | '250,00' | '18%' | ''              | '11 440,68'  | '63 559,32'  | '75 000,00'    |
			And I click "Save" button
			And I click "Post" button
	* Create SI based on SO
		And I click "Sales invoice" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		And I activate "Manual offer type" field in "ItemList" table
		And I go to line in "ItemList" table
			| "Item"  | "Item key" | "Offers amount" | "Price"  | "Quantity" |
			| "Dress" | "M/White"  | "2 000,00"      | "200,00" | "100,000"  |
		And I select current line in "ItemList" table
		And I select "Percent" exact value from "Manual offer type" drop-down list in "ItemList" table
		And I input "10,00" text in "Manual offer percent" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| "Item"  | "Item key" | "Offers amount" | "Price"  | "Quantity" |
			| "Dress" | "L/Green"  | "4 200,00"      | "210,00" | "200,000"  |
		And I activate "Manual offer type" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Amount" exact value from "Manual offer type" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Manual offer percent" field in "ItemList" table
		And I select current line in "ItemList" table
		And I activate "Manual offer amount" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1 000,00" text in "Manual offer amount" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| "Item"     | "Item key"  | "Price"  | "Quantity" |
			| "Trousers" | "36/Yellow" | "250,00" | "300,000"  |
		And I activate "Manual offer type" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Percent" exact value from "Manual offer type" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Manual offer percent" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,00" text in "Manual offer percent" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I select current line in "ItemList" table
		And I input "10,00" text in "Manual offer percent" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check discount
		And "ItemList" table became equal
			| 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Manual offer amount' | 'Quantity' | 'Price'  | 'Manual offer type' | 'Offers amount' | 'VAT' | 'Manual offer percent' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order' |
			| 'Dress'    | 'M/White'   | 'No'                 | '2 440,68'   | 'pcs'  | '2 000,00'            | '100,000'  | '200,00' | 'Percent'           | '2 000,00'      | '18%' | '10,00'                | '13 559,32'  | '16 000,00'    | 'Store 01' | '*'           |
			| 'Dress'    | 'L/Green'   | 'No'                 | '5 613,56'   | 'pcs'  | '1 000,00'            | '200,000'  | '210,00' | 'Amount'            | '4 200,00'      | '18%' | ''                     | '31 186,44'  | '36 800,00'    | 'Store 01' | '*'           |
			| 'Trousers' | '36/Yellow' | 'No'                 | '10 296,61'  | 'pcs'  | '7 500,00'            | '300,000'  | '250,00' | 'Percent'           | ''              | '18%' | '10,00'                | '57 203,39'  | '67 500,00'    | 'Store 01' | '*'           |
		And I click "Post" button
	* Create SR and check discount
		And I click "Sales return" button
		Then "Add linked document rows" window is opened
		And I click "Ok" button
		And "ItemList" table became equal
			| 'Item'     | 'Item key'  | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Manual offer amount' | 'Quantity' | 'Price'  | 'Manual offer type' | 'Offers amount' | 'VAT' | 'Manual offer percent' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales invoice' |
			| 'Dress'    | 'M/White'   | 'No'                 | '2 440,68'   | 'pcs'  | '2 000,00'            | '100,000'  | '200,00' | 'Percent'           | '2 000,00'      | '18%' | '10,00'                | '13 559,32'  | '16 000,00'    | 'Store 01' | '*'             |
			| 'Dress'    | 'L/Green'   | 'No'                 | '5 613,56'   | 'pcs'  | '1 000,00'            | '200,000'  | '210,00' | 'Amount'            | '4 200,00'      | '18%' | ''                     | '31 186,44'  | '36 800,00'    | 'Store 01' | '*'             |
			| 'Trousers' | '36/Yellow' | 'No'                 | '10 296,61'  | 'pcs'  | '7 500,00'            | '300,000'  | '250,00' | 'Percent'           | ''              | '18%' | '10,00'                | '57 203,39'  | '67 500,00'    | 'Store 01' | '*'             |
		And I close all client application windows
		
							
			
			
						
						
		
				
				

				

				
