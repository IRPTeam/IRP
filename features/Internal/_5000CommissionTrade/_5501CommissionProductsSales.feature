#language: en
@tree
@Positive
@Commission


Feature: commission products sales



Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _05502 preparation (commission products sales)
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
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
		When update ItemKeys
		When Create catalog Partners objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company


Scenario: _055002 check preparation
	When check preparation


// PI-PR-SalesReportToConsignor

Scenario: _055003 create PI (Receipt from consignor)
		And I close all client application windows
	* Open PI form
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I select "Receipt from consignor" exact value from "Transaction type" drop-down list
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And "List" table does not contain lines
			| 'Description'|
			| 'Ferron BP'  |
		And I go to line in "List" table
			| 'Description' |
			| 'Consignor 1' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
	* Check filling legal name, partner term, company, store
		Then the form attribute named "Partner" became equal to "Consignor 1"
		Then the form attribute named "LegalName" became equal to "Consignor 1"
		Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Receipt from consignor"
		Then the form attribute named "Store" became equal to "Store 02"
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'        | 'Reference'          |
			| 'Product 3 with SLN' | 'Product 3 with SLN' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'               | 'Item key' |
			| 'Product 3 with SLN' | 'UNIQ'     |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Serial number'  |
			| '09987897977889' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		Then "Item serial/lot numbers" window is opened
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Serial number'  |
			| '09987897977890' |
		And I select current line in "List" table
		And I finish line editing in "SerialLotNumbers" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate "Use goods receipt" field in "ItemList" table
		And I remove "Use goods receipt" checkbox in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Code' | 'Description'        | 'Reference'          |
			| '164'  | 'Product 4 with SLN' | 'Product 4 with SLN' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'               | 'Item key' |
			| 'Product 4 with SLN' | 'ODS'      |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I activate "Serial number" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate "Price" field in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I activate "Use goods receipt" field in "ItemList" table
		And I remove "Use goods receipt" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Code' | 'Description' | 'Reference' |
			| '1'    | 'Dress'       | 'Dress'     |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "14,000" text in "Quantity" field of "ItemList" table
		And I activate "Use goods receipt" field in "ItemList" table
		And I remove "Use goods receipt" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Code' | 'Description' | 'Reference' |
			| '4'    | 'Boots'       | 'Boots'     |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I activate "Use goods receipt" field in "ItemList" table
		And I remove "Use goods receipt" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check item tab
		And "ItemList" table became equal
			| 'Price type'              | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'             | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Quantity' | 'Expense type' | 'Purchase order' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | '61,02'      | 'pcs'  | '09987897977889; 09987897977890' | '100,00' | '18%' | ''              | '400,00'       | ''                    | ''                        | 'Store 02' | ''              | '4,000'    | ''             | ''               | ''            | '338,98'     | 'No'                |
			| 'en description is empty' | 'Product 4 with SLN' | 'ODS'      | ''                   | 'No'                 | '61,02'      | 'pcs'  | '899007790088'                   | '200,00' | '18%' | ''              | '400,00'       | ''                    | ''                        | 'Store 02' | ''              | '2,000'    | ''             | ''               | ''            | '338,98'     | 'No'                |
			| 'Basic Price Types'       | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '1 174,58'   | 'pcs'  | ''                               | '550,00' | '18%' | ''              | '7 700,00'     | ''                    | ''                        | 'Store 02' | ''              | '14,000'   | ''             | ''               | ''            | '6 525,42'   | 'No'                |
			| 'Basic Price Types'       | 'Boots'              | '38/18SD'  | ''                   | 'No'                 | '991,53'     | 'pcs'  | ''                               | '650,00' | '18%' | ''              | '6 500,00'     | ''                    | ''                        | 'Store 02' | ''              | '10,000'   | ''             | ''               | ''            | '5 508,47'   | 'No'                |		
	* Fill branch and post PI
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Code' | 'Department' | 'Description'             | 'Workshop' |
			| '3'    | 'Yes'        | 'Distribution department' | 'No'       |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I click "Post" button
		And I delete "$$NumberPI3$$" variable
		And I delete "$$PI3$$" variable
		And I delete "$$DatePI33$$" variable
		And I save the value of "Number" field as "$$NumberPI3$$"
		And I save the window as "$$PI3$$"
		And I save the value of the field named "Date" as "$$DatePI3$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberPI3$$' |
		And I close all client application windows
		
		
				
Scenario: _050006 creare PR (Return to consignor)
	And I close all client application windows
	* Open PR form
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Filling in the details
		And I select "Return to consignor" exact value from "Transaction type" drop-down list
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And "List" table does not contain lines
			| 'Description'|
			| 'Ferron BP'  |
		And I go to line in "List" table
			| 'Description'   |
			| 'Consignor 1' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
	* Check filling legal name, partner term, company, store
		Then the form attribute named "Partner" became equal to "Consignor 1"
		Then the form attribute named "LegalName" became equal to "Consignor 1"
		Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Return to consignor"
		Then the form attribute named "Store" became equal to "Store 02"
	* Branch
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'         | 'Unit' | 'Use' |
			| 'TRY'      | '200,00' | '2,000'    | 'Product 4 with SLN (ODS)' | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| 'TRY'      | '550,00' | '14,000'   | 'Dress (S/Yellow)' | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I expand a line in "SerialLotNumbersTree" table
			| 'Item'               | 'Item key' | 'Item key quantity' | 'Quantity' |
			| 'Product 4 with SLN' | 'ODS'      | '1,000'             | '2,000'    |
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 4 with SLN' | 'ODS'      |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button	
		And I go to line in "ItemList" table
			| 'Dont calculate row' | 'Item'  | 'Item key' | 'Net amount' | 'Price'  | 'Purchase invoice' | 'Quantity' | 'Store'    | 'Tax amount' | 'Total amount' | 'Unit' | 'Use shipment confirmation' | 'VAT' |
			| 'No'                 | 'Dress' | 'S/Yellow' | '6 525,42'   | '550,00' | '$$PI3$$'          | '14,000'   | 'Store 02' | '1 174,58'   | '7 700,00'     | 'pcs'  | 'Yes'                       | '18%' |
		And I select current line in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check item tab
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Quantity' | 'Expense type' | 'Use shipment confirmation' | 'Detail' | 'Return reason' | 'Net amount' | 'Purchase invoice' | 'Purchase return order' |
			| '1' | 'Product 4 with SLN' | 'ODS'      | ''                   | 'No'                 | '30,51'      | '899007790088'       | 'pcs'  | '200,00' | '18%' | ''              | '200,00'       | ''                    | 'Store 02' | '1,000'    | ''             | 'Yes'                       | ''       | ''              | '169,49'     | '$$PI3$$'          | ''                      |
			| '2' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '251,69'     | ''                   | 'pcs'  | '550,00' | '18%' | ''              | '1 650,00'     | ''                    | 'Store 02' | '3,000'    | ''             | 'Yes'                       | ''       | ''              | '1 398,31'   | '$$PI3$$'          | ''                      |
		And I click "Post" button
		And I delete "$$NumberPR1$$" variable
		And I delete "$$PR1$$" variable
		And I delete "$$DatePR1$$" variable
		And I save the value of "Number" field as "$$NumberPR1$$"
		And I save the window as "$$PR1$$"
		And I save the value of the field named "Date" as "$$DatePR1$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberPR1$$' |
		And I close all client application windows

