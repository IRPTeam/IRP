#language: en
@tree
@Positive


Feature: check that the item marked for deletion is not displayed


As a developer
I want to hide the items marked for deletion from the product selection form.
So the user can't select it in the sales and purchase documents


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _092001 checkbox Use serial lot number in the Item type
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot number"
		And I click "Save and close" button	
	* Check saving
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "Yes"
	And I close all client application windows
	
Scenario: _092002 check serial lot number in the Retail sales receipt
	* Create Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail customer' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Retail customer' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail partner term' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Store 01'    | 'Store 01'  |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1.000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1.000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1.000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		And I save the window as "$$RetailSalesReceipt092002$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                     | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                                    | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '400.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '400.00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '68.49'  |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '650.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '650.00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '111.30' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '400.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '650.00' |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$RetailSalesReceipt092002$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1.000' |
		And I input "3.000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			* Create serial lot number for item
				And I click the button named "FormCreate"
				And I input "99098809009998" text in "Serial number" field
				And I click "Save and close" button
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3.000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click "Post" button
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3.000'    | '99098809009998'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2.000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click "Post" button
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                     | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                                    | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '400.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '400.00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '68.49'  |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '650.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '650.00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '111.30' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1.000'    | '400.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1.000'    | '650.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2.000'    | '800.00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2.000'    | '800.00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2.000'    | '136.99' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2.000'    | '800.00' |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$RetailSalesReceipt092002$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that doesn't use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Change item that doesn't use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then I wait that in user messages the "Field [Serial lot number] is empty." substring will appear in "30" seconds
	And I close all client application windows
	

Scenario: _092010 uncheck checkbox Use serial lot number in the Item type
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I remove checkbox "Use serial lot number"
		And I click "Save and close" button	
	* Check saving
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "No"
	And I close all client application windows




		







	