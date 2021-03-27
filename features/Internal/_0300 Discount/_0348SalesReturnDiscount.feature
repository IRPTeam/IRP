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
			| 'Description'              |
			| 'Document discount' |
		And I select current line in "List" table
		And I set checkbox "Launch"
		And I click "Save and close" button
	* Create test Sales invoice
		When create SalesInvoice024025
	* Calculate document discount for Sales invoice 024025
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| "Number" |
			| "$$NumberSalesInvoice024025$$" |
		And I select current line in "List" table
	* Calculate Document discount for Sales invoice
		And I click "% Offers" button
		And I expand current line in "Offers" table
		And I go to line in "Offers" table
			| 'Presentation'      |
			| 'Document discount' |
		And I select current line in "Offers" table
		And I input "10,00" text in "Percent" field
		And I click "Ok" button
		And in the table "Offers" I click "OK" button
	* Check the discount calculation
		And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' | 'Tax amount' | 'Net amount' |
			| 'Dress' | '550,00' | 'L/Green'  | '20,000' | '1 100,00'      | 'pcs'  | '9 900,00'     | '1 510,17'   | '8 389,83'   |
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "1 100,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "8 389,83"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 510,17"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "9 900,00"
		And I click the button named "FormPostAndClose"			
		And I close all client application windows
	
Scenario: _034802 check discount recalculation when change quantity in the SaLes return order
	* Document discount
		* Create Purchase return based on $$SalesInvoice024025$$
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice024025$$'  |
			And I click the button named "FormDocumentSalesReturnOrderGenerate"
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "1 100,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "8 389,83"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 510,17"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "9 900,00"
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' | 'Tax amount' | 'Net amount' |
			| 'Dress' | '550,00' | 'L/Green'  | '20,000' | '1 100,00'      | 'pcs'  | '9 900,00'     | '1 510,17'   | '8 389,83'   |
		* Change quantity and check discount recalculation
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'       |
				| 'Dress' | 'L/Green'  | '20,000' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "55,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "419,49"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "75,51"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "495,00"
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' | 'Tax amount' | 'Net amount' |
				| 'Dress' | '550,00' | 'L/Green'  | '1,000' | '55,00'         | 'pcs'  | '495,00'       | '75,51'      | '419,49'     |
			And I click the button named "FormPostAndClose"			

Scenario: _034803 check discount recalculation when change quantity in the SaLes return order
	* Document discount
		* Create Purchase return based on $$SalesInvoice024025$$
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice024025$$'  |
			And I click the button named "FormDocumentSalesReturnGenerate"
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "1 100,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "8 389,83"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "1 510,17"
			And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "9 900,00"
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' | 'Tax amount' | 'Net amount' |
			| 'Dress' | '550,00' | 'L/Green'  | '20,000' | '1 100,00'      | 'pcs'  | '9 900,00'     | '1 510,17'   | '8 389,83'   |
		* Change quantity and check discount recalculation
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'       |
				| 'Dress' | 'L/Green'  | '20,000' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "55,00"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "419,49"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "75,51"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "495,00"
			And "ItemList" table contains lines
				| 'Item'  | 'Price'  | 'Item key' | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' | 'Tax amount' | 'Net amount' |
				| 'Dress' | '550,00' | 'L/Green'  | '1,000' | '55,00'         | 'pcs'  | '495,00'       | '75,51'      | '419,49'     |
			And I click the button named "FormPostAndClose"	
