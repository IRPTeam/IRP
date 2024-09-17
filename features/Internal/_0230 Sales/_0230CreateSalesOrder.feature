#language: en
@tree
@Positive
@Sales


Feature: create document Sales order


As a sales manager
I want to create a Sales order document
To track the items ordered by the customer

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one





Scenario: _023000 preparation (Sales order)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog CashAccounts objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Partners objects
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)


Scenario: _0230001 check preparation
	When check preparation


Scenario: _023001 create document Sales order
	When create SalesOrder023001
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And "List" table contains lines
		| 'Number'                       |
		| '$$NumberSalesOrder023001$$'   |
	And I close all client application windows

Scenario: _023002 check filling in Row Id info table in the SO
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder023001$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1SalesOrder023001$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2SalesOrder023001$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                        | 'Basis'   | 'Row ID'                     | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                     |
			| '$$Rov1SalesOrder023001$$'   | ''        | '$$Rov1SalesOrder023001$$'   | 'SI&SC'       | '5,000'      | ''            | ''               | '$$Rov1SalesOrder023001$$'    |
			| '$$Rov2SalesOrder023001$$'   | ''        | '$$Rov2SalesOrder023001$$'   | 'SI&SC'       | '4,000'      | ''            | ''               | '$$Rov2SalesOrder023001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'L/Green'    | '5,000'       |
		And in the table "ItemList" I click "Copy" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3SalesOrder023001$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                        | 'Basis'   | 'Row ID'                     | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                     |
			| '$$Rov1SalesOrder023001$$'   | ''        | '$$Rov1SalesOrder023001$$'   | 'SI&SC'       | '5,000'      | ''            | ''               | '$$Rov1SalesOrder023001$$'    |
			| '$$Rov2SalesOrder023001$$'   | ''        | '$$Rov2SalesOrder023001$$'   | 'SI&SC'       | '4,000'      | ''            | ''               | '$$Rov2SalesOrder023001$$'    |
			| '$$Rov3SalesOrder023001$$'   | ''        | '$$Rov3SalesOrder023001$$'   | 'SI&SC'       | '8,000'      | ''            | ''               | '$$Rov3SalesOrder023001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "RowIDInfo" table does not contain lines
			| 'Key'                        | 'Basis'   | 'Row ID'                     | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                     |
			| '$$Rov1SalesOrder023001$$'   | ''        | '$$Rov1SalesOrder023001$$'   | 'SI&SC'       | '8,000'      | ''            | ''               | '$$Rov1SalesOrder023001$$'    |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '3'   | 'Dress'   | 'L/Green'    | '8,000'       |
		And in the table "ItemList" I click "Delete" button
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                        | 'Basis'   | 'Row ID'                     | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                     |
			| '$$Rov1SalesOrder023001$$'   | ''        | '$$Rov1SalesOrder023001$$'   | 'SI&SC'       | '5,000'      | ''            | ''               | '$$Rov1SalesOrder023001$$'    |
			| '$$Rov2SalesOrder023001$$'   | ''        | '$$Rov2SalesOrder023001$$'   | 'SI&SC'       | '4,000'      | ''            | ''               | '$$Rov2SalesOrder023001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'L/Green'    | '5,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                        | 'Basis'   | 'Row ID'                     | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                     |
			| '$$Rov1SalesOrder023001$$'   | ''        | '$$Rov1SalesOrder023001$$'   | 'SI&SC'       | '7,000'      | ''            | ''               | '$$Rov1SalesOrder023001$$'    |
			| '$$Rov2SalesOrder023001$$'   | ''        | '$$Rov2SalesOrder023001$$'   | 'SI&SC'       | '4,000'      | ''            | ''               | '$$Rov2SalesOrder023001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'L/Green'    | '7,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
		
	
Scenario: _023003 copy SO and check filling in Row Id info table
	* Copy SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberSalesOrder023001$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "DecorationClosingOrder" became equal to "This order is closed by:"
		Then the form attribute named "ClosingOrder" became equal to ""
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "Status" became equal to "Approved"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Profit loss center'        | 'Price type'          | 'Item'       | 'Dont calculate row'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Revenue type'   | 'Detail'   | 'Procurement method'   | 'Item key'    | 'Cancel'   | 'Cancel reason'   | 'Sales person'       |
			| '1'   | 'Distribution department'   | 'Basic Price Types'   | 'Dress'      | 'No'                   | '5,000'      | 'pcs'    | '419,49'       | '550,00'   | '18%'   | ''                | '2 330,51'     | '2 750,00'       | 'Store 01'   | 'Revenue'        | '123'      | 'Stock'                | 'L/Green'     | 'No'       | ''                | 'Anna Petrova'       |
			| '2'   | 'Distribution department'   | 'Basic Price Types'   | 'Trousers'   | 'No'                   | '4,000'      | 'pcs'    | '244,07'       | '400,00'   | '18%'   | ''                | '1 355,93'     | '1 600,00'       | 'Store 01'   | 'Revenue'        | ''         | 'Stock'                | '36/Yellow'   | 'No'       | ''                | 'Alexander Orlov'    |
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'    |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200' | '744,72'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '4 350'     |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '4 350'     |
		And I close current window		
		Then the form attribute named "Branch" became equal to ""
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "Manager" became equal to "Region 1"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "UseItemsShipmentScheduling" became equal to "No"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "3 686,44"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "663,56"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "4 350,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post SO and check Row ID Info tab
		And I click "Show row key" button
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                        | 'Basis'   | 'Row ID'                     | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                     |
			| '$$Rov1SalesOrder023001$$'   | ''        | '$$Rov1SalesOrder023001$$'   | 'SI&SC'       | '5,000'      | ''            | ''               | '$$Rov1SalesOrder023001$$'    |
			| '$$Rov2SalesOrder023001$$'   | ''        | '$$Rov2SalesOrder023001$$'   | 'SI&SC'       | '4,000'      | ''            | ''               | '$$Rov2SalesOrder023001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I close all client application windows
				
Scenario: _023007 check filling in Delivery date/Reservation date and Use items shipment scheduling
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		Then "Partner terms" window is opened
		And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
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
				| 'L/Green'      |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	* Filling in delivery date
		And I input current date in the field named "DeliveryDate"
		And I go to line in "ItemList" table
				| 'Item key'     |
				| 'L/Green'      |
		And I save the value of the field named "DeliveryDate" as "$$DeliveryDate023007$$"
		And "ItemList" table contains lines
			| '#'   | 'Profit loss center'   | 'Price type'          | 'Item'    | 'Dont calculate row'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Revenue type'   | 'Detail'   | 'Procurement method'   | 'Item key'   | 'Cancel'   | 'Delivery date'            | 'Cancel reason'    |
			| '1'   | ''                     | 'Basic Price Types'   | 'Dress'   | 'No'                   | '5,000'      | 'pcs'    | '419,49'       | '550,00'   | '18%'   | ''                | '2 330,51'     | '2 750,00'       | 'Store 01'   | ''               | ''         | 'Stock'                | 'L/Green'    | 'No'       | '$$DeliveryDate023007$$'   | ''                 |
	* Filling in reservation date
		And I save "Format((EndOfDay(CurrentDate()) + 432000), \"DF=dd.MM.yyyy\")" in "$$$$DateCurrentDayPluSFive$$$$" variable
		And I input "$$$$DateCurrentDayPluSFive$$$$" text in "Reservation date" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| '#'   | 'Profit loss center'   | 'Price type'          | 'Item'    | 'Dont calculate row'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Revenue type'   | 'Detail'   | 'Procurement method'   | 'Item key'   | 'Cancel'   | 'Reservation date'                 | 'Cancel reason'    |
			| '1'   | ''                     | 'Basic Price Types'   | 'Dress'   | 'No'                   | '5,000'      | 'pcs'    | '419,49'       | '550,00'   | '18%'   | ''                | '2 330,51'     | '2 750,00'       | 'Store 01'   | ''               | ''         | 'Stock'                | 'L/Green'    | 'No'       | '$$$$DateCurrentDayPluSFive$$$$'   | ''                 |
	* Use items shipment scheduling
		And I move to "Other" tab
		And I set checkbox "Use items shipment scheduling"
		And I remove checkbox "Use items shipment scheduling"
	And I close all client application windows
	
		


Scenario: _023004 check filling in procurement method using the button Fill in SO
	And I close all client application windows
	* Open a creation form Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
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
	* Adding items to Sales order (4 string)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '38/18SD'     |
		And I activate "Item" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'High shoes'     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'         | 'Item key'    |
			| 'High shoes'   | '37/19SD'     |
		And I activate "Item" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I activate "Item" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check the button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Shirt'   | '38/Black'   | '5,000'       |
		And I move one line down in "ItemList" table and select line
		And in the table "ItemList" I click "Procurement" button
		And I set checkbox "Stock"
		And I click "OK" button
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'   | 'Quantity'    |
			| 'High shoes'   | '37/19SD'    | '2,000'       |
		And I move one line down in "ItemList" table and select line
		And in the table "ItemList" I click "Procurement" button
		And I change checkbox "Purchase"
		And I click "OK" button
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'    |
			| 'Boots'   | '38/18SD'    | '8,000'       |
		And I move one line down in "ItemList" table and select line
		And in the table "ItemList" I click "Procurement" button
		And I change checkbox "No reserve"
		And I click "OK" button
	* Check filling in Procurement method in the Sales order
		And "ItemList" table contains lines
		| 'Item'        | 'Item key'   | 'Procurement method'  | 'Quantity'   |
		| 'Shirt'       | '38/Black'   | 'Stock'               | '5,000'      |
		| 'Boots'       | '38/18SD'    | 'No reserve'          | '8,000'      |
		| 'High shoes'  | '37/19SD'    | 'No reserve'          | '2,000'      |
		| 'Trousers'    | '38/Yellow'  | 'Purchase'            | '3,000'      |
	* Add a line with the service
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service'        |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'      | 'Item key'    |
			| 'Service'   | 'Rent'        |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		When I Check the steps for Exception
									| 'And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table'          |
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
	* Check the cleaning method on the line with the product
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Procurement method'    |
			| 'Trousers'   | '38/Yellow'   | 'Purchase'              |
		And I click Clear button of "Procurement method" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'   | 'Procurement method'    |
			| 'High shoes'   | '37/19SD'    | 'No reserve'            |
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Procurement method] is empty." substring will appear in 30 seconds
		And I close all client application windows		
							
Scenario: _0154012 check autofilling the Partner term field in Sales order
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by customer) in the documents of sales/returns 
	And I close all client application windows		
				
				
Scenario: _0154016 check autofilling item key in Sales order by item only with one item key
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	When check item key autofilling in sales/returns documents for an item that has only one item key		
				

Scenario: _0154034 check item key selection in the form of item key
	* Open the item key selection form from the Sales order document.
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description        |
			| Partner Kalipso    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
	* Check the selection by properties
	# Single item key + item key specifications that contain this property should be displayed
		And I select from "Color" drop-down list by "yellow" string
		And I click Select button of "Color" field
		And I go to line in "List" table
			| Additional attribute   | Description    |
			| Color                  | Yellow         |
		And I select current line in "List" table
		And "List" table became equal
			| Item key    | Item     |
			| S/Yellow    | Dress    |
			| Dress/A-8   | Dress    |
	* Check the filter by single item key and by specifications
		And I change "IsSpecificationFilter" radio button value to "Single"
		And "List" table became equal
			| Item key   | Item     |
			| S/Yellow   | Dress    |
		And I change "IsSpecificationFilter" radio button value to "Specification"
		And "List" table became equal
			| Item key    | Item     |
			| Dress/A-8   | Dress    |
		And I change "IsSpecificationFilter" radio button value to "All"
		And "List" table became equal
			| Item key    | Item     |
			| S/Yellow    | Dress    |
			| Dress/A-8   | Dress    |
	And I close all client application windows


Scenario: _0154037 check impossibility deleting of the store field by line with the product in a Sales order
	* Open a creation form Sales Order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows


Scenario: _023014 check movements by status and status history of a Sales Order document
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number'                      | 'Partner'     |
		| '$$NumberSalesOrder023001$$'  | 'Ferron BP'   |
	And I select current line in "List" table
	* Change status to Wait (does not post)
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Wait" exact value from "Status" drop-down list
	And I click the button named "FormPostAndClose"
	* Check the absence of movements Sales Order
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4011B_FreeStocks"
		And "List" table does not contain lines
			| 'Recorder'                |
			| '$$SalesOrder023001$$'    |
			| '$$SalesOrder023001$$'    |
		And I close current window
	* Opening a previously created order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                       | 'Partner'      |
			| '$$NumberSalesOrder023001$$'   | 'Ferron BP'    |
		And I select current line in "List" table
	* Change sales order status to Approved
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                 | 'Status'      |
			| '$$SalesOrder023001$$'   | 'Wait'        |
			| '$$SalesOrder023001$$'   | 'Approved'    |
		And I close current window
		And I click the button named "FormPostAndClose"
	* Check document movements
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R4011B_FreeStocks"
		And "List" table contains lines
			| 'Recorder'                |
			| '$$SalesOrder023001$$'    |
			| '$$SalesOrder023001$$'    |
		And I close current window
		
Scenario: _012013 check the selection of the segment manager in the sales order
	And I close all client application windows
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in Partner and Legal name
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I select current line in "List" table
		And I move to "Other" tab
		And I expand "More" group
		And I click Select button of "Manager segment" field
	* Check the display of manager segments
		And "List" table became equal
		| 'Description'   |
		| 'Region 1'      |
		| 'Region 2'      |


Scenario: _023101 displaying in the Sales order only available valid Partner terms for the selected customer
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And "List" table became equal
		| 'Description'                        |
		| 'Basic Partner terms, TRY'           |
		| 'Basic Partner terms, without VAT'   |
		| 'Ferron, USD'                        |
	And I select current line in "List" table
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And "List" table became equal
		| 'Description'                        |
		| 'Basic Partner terms, TRY'           |
		| 'Basic Partner terms, without VAT'   |
		| 'Personal Partner terms, $'          |
	And I close current window
	And I close current window
	And I click "No" button




Scenario: _023103 filling in Company field from the Partner term
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                |
		| 'Basic Partner terms, TRY'   |
	And I select current line in "List" table
	Then the form attribute named "Company" became equal to "Main Company"
	And I close current window
	And I click "No" button


Scenario: _023104 filling in Store field from the Partner term
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                        |
		| 'Basic Partner terms, without VAT'   |
	And I select current line in "List" table
	Then the form attribute named "Store" became equal to "Store 02"
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                |
		| 'Basic Partner terms, TRY'   |
	And I select current line in "List" table
	Then the form attribute named "Store" became equal to "Store 01"
	And I close current window
	And I click "No" button




# Scenario: _023106 check the form of selection of items (sales order)
# 	Given I open hyperlink "e1cib/list/Document.SalesOrder"
# 	And I click the button named "FormCreate"
# 	* Filling in the details
# 		And I click Select button of "Partner" field
# 		And I go to line in "List" table
# 			| 'Description' |
# 			| 'Ferron BP'  |
# 		And I select current line in "List" table
# 		And I click Select button of "Partner term" field
# 		And I go to line in "List" table
# 				| 'Description'       |
# 				| 'Basic Partner terms, TRY' |
# 		And I select current line in "List" table
# 		And I click Select button of "Legal name" field
# 		And I go to line in "List" table
# 			| 'Description' |
# 			| 'Company Ferron BP'  |
# 		And I select current line in "List" table
# 	When check the product selection form with price information in Sales order
# 	And in the table "ItemList" I click "% Offers" button
# 	And in the table "Offers" I click the button named "FormOK"
# 	And I click the button named "FormPostAndClose"
# 	* Check Sales order Saving
# 		And "List" table contains lines
# 		| 'Currency'  | 'Partner'     | 'Status'   | 'Amount'         |
# 		| 'TRY'       | 'Ferron BP'   | 'Approved' | '2 050,00'  |
# 	And I close all client application windows


				
Scenario: _023105 filling in Account field in the SO
	And I close all client application windows
	* Open SO and fill main details
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'    |
				| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                        |
			| 'Basic Partner terms, without VAT'   |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select current line in "ItemList" table
		And I select "scarf" from "Item" drop-down list by string in "ItemList" table
		And I input "10,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Fill Account for payment
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| "Currency" | "Description"       |
			| "TRY"      | "Bank account, TRY" |
		And I select current line in "List" table
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		And I select from the drop-down list named "Account" by "Bank account, TRY" string
		Then the form attribute named "Account" became equal to "Bank account, TRY"
	And I close all client application windows	
		


Scenario: _300504 check connection to Sales order report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number                       |
		| $$NumberSalesOrder023001$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows 
