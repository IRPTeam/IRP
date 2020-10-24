#language: en
@tree
@Positive
@Discount

Feature: check discounts in the Retail sales receipt


Background:
	Given I launch TestClient opening script or connect the existing one
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one


Scenario: _034501 check discount in Retail sales receipt
	* Create Retail sales receipt
		* Open a form to create Retail sales receipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Filling in customers info
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
				| Basic Partner terms, TRY |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
		* Filling in items table
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "100" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I input "10" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Discount price 1	
			And in the table "ItemList" I click "% Offers" button
			And I go to line in "Offers" table
				| 'Presentation'     |
				| 'Discount Price 1' |
			And I activate "Is select" field in "Offers" table
			And I select current line in "Offers" table
			And in the table "Offers" I click "OK" button
			And "ItemList" table contains lines
				| 'Price'  | 'Detail' | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'       | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | ''       | 'Dress' | '18%' | 'M/White'  | '2 600,00'      | '100,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '7 535,59'   | '41 864,41'  | '49 400,00'    | 'Store 01' |
				| '550,00' | ''       | 'Dress' | '18%' | 'L/Green'  | '275,00'        | '10,000'  | 'Basic Price Types' | 'pcs'  | 'No'                 | '797,03'     | '4 427,97'   | '5 225,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "2 875,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "46 292,38"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "8 332,62"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "54 625,00"
		* Document discount
			And in the table "ItemList" I click "% Offers" button
			Then "Pickup special offers" window is opened
			And I go to line in "Offers" table
				| '%'    | 'Is select' | 'Presentation'     | '∑'        |
				| '5,00' | '✔'         | 'Discount Price 1' | '2 875,00' |
			And I activate "Is select" field in "Offers" table
			And I select current line in "Offers" table
			And I go to line in "Offers" table
				| 'Presentation'      |
				| 'Document discount' |
			And I activate "Presentation" field in "Offers" table
			And I select current line in "Offers" table
			And I input "10,00" text in "Percent" field
			And I click "Ok" button
			Then "Pickup special offers" window is opened
			And in the table "Offers" I click "OK" button
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "5 750,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "43 855,94"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "7 894,06"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "51 750,00"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'       | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | 'Dress' | '18%' | 'M/White'  | '5 200,00'      | '100,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '7 138,98'   | '39 661,02'  | '46 800,00'    | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '550,00'        | '10,000'  | 'Basic Price Types' | 'pcs'  | 'No'                 | '755,08'     | '4 194,92'   | '4 950,00'     | 'Store 01' |
			And I click the button named "FormPost"
			And I delete "$$NumberRetailSalesReceipt034501$$" variable
			And I delete "$$RetailSalesReceipt034501$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt034501$$"
			And I save the window as "$$RetailSalesReceipt034501$$"
			And I click the button named "FormPostAndClose"


Scenario: _034502 check discount in Retail sales receipt 5+1
	* Create Retail sales receipt
		* Open a form to create Retail sales receipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I click the button named "FormCreate"
		* Filling in customers info
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
				| Basic Partner terms, TRY |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
		* Filling in items table
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "100" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I input "10" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Discount 5+1
			And in the table "ItemList" I click "% Offers" button
			And I go to line in "Offers" table
				| 'Presentation'     |
				| 'All items 5+1, Discount on Basic Partner terms' |
			And I activate "Is select" field in "Offers" table
			And I select current line in "Offers" table
			And in the table "Offers" I click "OK" button
			And "ItemList" table contains lines
				| 'Price'  | 'Detail' | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'       | 'Price type'        | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | ''       | 'Dress' | '18%' | 'M/White'  | '8 320,00'      | '100,000' | 'Basic Price Types' | 'pcs'  | 'No'                 | '6 663,05'   | '37 016,95'  | '43 680,00'    | 'Store 01' |
				| '550,00' | ''       | 'Dress' | '18%' | 'L/Green'  | '550,00'        | '10,000'  | 'Basic Price Types' | 'pcs'  | 'No'                 | '755,08'     | '4 194,92'   | '4 950,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "8 870,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "41 211,87"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "7 418,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "48 630,00"
			And I click the button named "FormPost"
			And Delay 5
			And I delete "$$NumberRetailSalesReceipt034502$$" variable
			And I delete "$$RetailSalesReceipt034502$$" variable
			And I save the value of "Number" field as "$$NumberRetailSalesReceipt034502$$"
			And I save the window as "$$RetailSalesReceipt034502$$"
			And I click the button named "FormPostAndClose"		
			
Scenario: _034510 check discount recalculation when change quantity in Retail return receipt
	* Document discount
		* Create Retail return receipt based on $$RetailSalesReceipt034501$$
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberRetailSalesReceipt034501$$'  |
			And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "5 750,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "43 855,94"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "7 894,06"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "51 750,00"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'       | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | 'Dress' | '18%' | 'M/White'  | '5 200,00'      | '100,000' | 'pcs'  | 'No'                 | '7 138,98'   | '39 661,02'  | '46 800,00'    | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '550,00'        | '10,000'  | 'pcs'  | 'No'                 | '755,08'     | '4 194,92'   | '4 950,00'     | 'Store 01' |
		* Change quantity and check discount recalculation
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'       |
				| 'Dress' | 'L/Green'  | '10,000' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'       |
				| 'Dress' | 'M/White'  | '100,000' |
			And I select current line in "ItemList" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "315,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "2 402,54"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "432,46"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "2 835,00"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | 'Dress' | '18%' | 'M/White'  | '260,00'        | '5,000' | 'pcs'  | 'No'                 | '356,95'     | '1 983,05'   | '2 340,00'     | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '55,00'         | '1,000' | 'pcs'  | 'No'                 | '75,51'      | '419,49'     | '495,00'       | 'Store 01' |
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'       |
				| 'Dress' | 'M/White'  | '5,000' |
			And I select current line in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table		
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "575,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "4 385,59"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "789,41"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "5 175,00"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | 'Dress' | '18%' | 'M/White'  | '520,00'        | '10,000' | 'pcs'  | 'No'                 | '713,90'     | '3 966,10'   | '4 680,00'     | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '55,00'         | '1,000' | 'pcs'  | 'No'                 | '75,51'      | '419,49'     | '495,00'       | 'Store 01' |	
			And I click the button named "FormPost"
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "575,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "4 385,59"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "789,41"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "5 175,00"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | 'Dress' | '18%' | 'M/White'  | '520,00'        | '10,000' | 'pcs'  | 'No'                 | '713,90'     | '3 966,10'   | '4 680,00'     | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '55,00'         | '1,000' | 'pcs'  | 'No'                 | '75,51'      | '419,49'     | '495,00'       | 'Store 01' |	
			And I click the button named "FormPostAndClose"		
	* Discount 5+1
		* Create Retail return receipt based on $$RetailSalesReceipt034502$$
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberRetailSalesReceipt034502$$'  |
			And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'       | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | 'Dress' | '18%' | 'M/White'  | '8 320,00'      | '100,000' | 'pcs'  | 'No'                 | '6 663,05'   | '37 016,95'  | '43 680,00'    | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '550,00'        | '10,000'  | 'pcs'  | 'No'                 | '755,08'     | '4 194,92'   | '4 950,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "8 870,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "41 211,87"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "7 418,13"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "48 630,00"
		* Change quantity and check discount recalculation	
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'       |
				| 'Dress' | 'M/White'  | '100,000' |
			And I select current line in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table		
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'       | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '520,00' | 'Dress' | '18%' | 'M/White'  | '832,00'        | '10,000' | 'pcs'  | 'No'                 | '666,31'     | '3 701,69'   | '4 368,00'     | 'Store 01' |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '550,00'        | '10,000'  | 'pcs'  | 'No'                 | '755,08'     | '4 194,92'   | '4 950,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "1 382,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "7 896,61"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 421,39"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "9 318,00"
		* Delete string and check discount recalculation
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'       |
				| 'Dress' | 'M/White'  | '10,000' |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And "ItemList" table contains lines
				| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Offers amount' | 'Q'       | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
				| '550,00' | 'Dress' | '18%' | 'L/Green'  | '550,00'        | '10,000'  | 'pcs'  | 'No'                 | '755,08'     | '4 194,92'   | '4 950,00'     | 'Store 01' |
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "550,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "4 194,92"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "755,08"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 950,00"
			And I click the button named "FormPostAndClose"				
			
						
			


Scenario: _999999 close TestClient session
	And I close TestClient session
