#language: en
@tree
@Positive
@CommissionTrade


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
		When Create catalog Companies objects (own Second company)
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
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
	* Setting for Company
		When settings for Company (commission trade)
	* Load documents
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		When Create document InventoryTransfer objects (comission trade)
		When Create document SalesInvoice and SalesReturn objects (comission trade)
	* Post document
		* Posting Purchase invoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesInvoice
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting PurchaseReturn
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesReturn
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting Inventory transfer
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	And I close all client application windows
	
						


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
		And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
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
			| 'en description is empty' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | '76,27'      | 'pcs'  | '09987897977889; 09987897977890' | '100,00' | '18%' | ''              | '500,00'       | ''                    | ''                        | 'Store 02' | ''              | '5,000'    | ''             | ''               | ''            | '423,73'     | 'No'                |
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
			| 'Item'  | 'Item key' | 'Net amount' | 'Price'  | 'Purchase invoice'                               | 'Quantity' | 'Store'    | 'Tax amount' | 'Total amount' | 'Unit' | 'VAT' |
			| 'Dress' | 'S/Yellow' | '6 525,42'   | '550,00' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '14,000'   | 'Store 02' | '1 174,58'   | '7 700,00'     | 'pcs'  | '18%' |
		And I select current line in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check item tab
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Quantity' | 'Expense type' | 'Use shipment confirmation' | 'Detail' | 'Return reason' | 'Net amount' | 'Purchase invoice'                               | 'Purchase return order' |
			| '1' | 'Product 4 with SLN' | 'ODS'      | ''                   | 'No'                 | '30,51'      | '899007790088'       | 'pcs'  | '200,00' | '18%' | ''              | '200,00'       | ''                    | 'Store 02' | '1,000'    | ''             | 'Yes'                       | ''       | ''              | '169,49'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | ''                      |
			| '2' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '251,69'     | ''                   | 'pcs'  | '550,00' | '18%' | ''              | '1 650,00'     | ''                    | 'Store 02' | '3,000'    | ''             | 'Yes'                       | ''       | ''              | '1 398,31'   | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | ''                      |
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

Scenario: _050010 create SI (commission products sales)
	And I close all client application windows
	* Open SI form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'      |
			| 'Partner term DFC' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I set checkbox "Price includes tax"		
	* Add items
		* First item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 3 with SLN' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'               | 'Item key' |
				| 'Product 3 with SLN' | 'UNIQ'     |
			And I select current line in "List" table
			And I activate "Inventory origin" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table			
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner' | 'Serial number'  |
				| 'UNIQ'  | '09987897977889' |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "4,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I select current line in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "120,00" text in "Price" field of "ItemList" table
			And I activate "Use shipment confirmation" field in "ItemList" table
			And I remove "Use shipment confirmation" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table
		* Second item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'        |
				| 'Dress' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Inventory origin" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "4,000" text in "Quantity" field of "ItemList" table		
			And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
			And I activate "Use shipment confirmation" field in "ItemList" table
			And I remove "Use shipment confirmation" checkbox in "ItemList" table
			And I finish line editing in "ItemList" table		
	* Post SI
		And I click "Post" button
		And I delete "$$NumberSI10$$" variable
		And I delete "$$SI10$$" variable
		And I delete "$$DateSI10$$" variable
		And I save the value of "Number" field as "$$NumberSI10$$"
		And I save the window as "$$SI10$$"
		And I save the value of the field named "Date" as "$$DateSI10$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberSI10$$' |
		And I close all client application windows			

Scenario: _050012 сheck the message when selling commission goods more than there is in the balance
	And I close all client application windows
	* Open SI form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'      |
			| 'Partner term DFC' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Add item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'        |
			| 'Dress' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
		And I activate "Inventory origin" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table	
		And I activate "Use shipment confirmation" field in "ItemList" table
		And I remove "Use shipment confirmation" checkbox in "ItemList" table
		And I select current line in "ItemList" table
		And I input "50,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post and check message
		And I click "Post" button	
		Then there are lines in TestClient message log
			|'Consignor batch shortage Item key: S/Yellow Store: Store 02 Required:50,000 Remaining:32,000 Lack:18,000\n'|				
	* Clear posting
		And I click "Clear posting" button
	And I close all client application windows
	
Scenario: _050014 create SR (return commission products that was sailed our customer)
	And I close all client application windows
	* Open SR form
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'      |
			| 'Partner term DFC' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I set checkbox "Price includes tax"	
	* Select items
		* First item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'        |
				| 'Product 3 with SLN' |
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
				| 'Owner' | 'Serial number'  |
				| 'UNIQ'  | '09987897977889' |
			And I select current line in "List" table
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I select current line in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "120,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Second item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate field named "ItemListItem" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Dress' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table		
			And I finish line editing in "ItemList" table
	* Link
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation' | 'Unit' |
			| 'TRY'      | '466,10' | '4,000'    | 'Dress (S/Yellow)' | 'pcs'  |
		And in the table "BasisesTree" I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation'          | 'Store'    | 'Unit' |
			| '1' | '1,000'    | 'Product 3 with SLN (UNIQ)' | 'Store 02' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'          | 'Unit' |
			| 'TRY'      | '120,00' | '4,000'    | 'Product 3 with SLN (UNIQ)' | 'pcs'  |
		And in the table "BasisesTree" I click the button named "Link"
		And I click "Ok" button
	* Temporarily
		And I select current line in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 3 with SLN' | 'UNIQ'     |
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		Then "Select serial lot numbers" window is opened
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check filling
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Sales invoice' | 'Price'  | 'Net amount' | 'Use goods receipt' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Sales return order' | 'Return reason' | 'Revenue type' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Sales person' |
			| '1' | 'Product 3 with SLN' | 'UNIQ'     | ''                   | 'No'                 | '18,31'      | 'pcs'  | '09987897977889'     | '1,000'    | '$$SI10$$'      | '120,00' | '101,69'     | 'Yes'               | '120,00'       | ''                    | 'Store 02' | ''                   | ''              | ''             | '18%' | ''              | ''            | ''             |
			| '2' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '142,20'     | 'pcs'  | ''                   | '2,000'    | '$$SI10$$'      | '466,10' | '790,00'     | 'Yes'               | '932,20'       | ''                    | 'Store 02' | ''                   | ''              | ''             | '18%' | ''              | ''            | ''             |
	* Post	
		And I click "Post" button
		And I delete "$$NumberSR10$$" variable
		And I delete "$$SR10$$" variable
		And I delete "$$DateSR10$$" variable
		And I save the value of "Number" field as "$$NumberSR10$$"
		And I save the window as "$$SR10$$"
		And I save the value of the field named "Date" as "$$DateSR10$$"
		And I click "Post and close" button 
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberSR10$$' |
		And I close all client application windows

Scenario: _050015 create IT for (Consignor stocks)
	And I close all client application windows
	* Open IT form
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Product 3 with SLN' |
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
			| 'Owner' | 'Reference'      | 'Serial number'  |
			| 'UNIQ'  | '09987897977889' | '09987897977889' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate "Inventory origin" field in "ItemList" table
		And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Inventory origin" attribute in "ItemList" table
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
		And I activate "Inventory origin" field in "ItemList" table
		And I select "Consignor stocks" exact value from "Inventory origin" drop-down list in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I move to "Other" tab
		And I remove checkbox "Use shipment confirmation"
		And I move to "Items" tab
		And I click "Post" button
		And I delete "$$NumberIT10$$" variable
		And I delete "$$IT10$$" variable
		And I delete "$$DateIT10$$" variable
		And I save the value of "Number" field as "$$NumberIT10$$"
		And I save the window as "$$IT10$$"
		And I save the value of the field named "Date" as "$$DateIT10$$"
		And I click "Post and close" button 
	* Check creation
		And "List" table contains lines
			| 'Number'        |
			| '$$NumberIT10$$' |
		And I close all client application windows		
						

Scenario: _050025 create Sales report co consignor
	And I close all client application windows
	* Open Sales report co consignor form
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"	
	* Create Sales report co consignor for Concignor 1
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Consignor 1' |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Consignor 1"
		Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
		And I input "01.11.2022" text in "Start date" field
		And I input "04.11.2022" text in "End date" field
		* Filling sales (sales and return)
			And in the table "ItemList" I click "Fill sales" button
			Then the form attribute named "SalesPeriod" became equal to "01.11.2022 - 04.11.2022"
			And in the table "Sales" I click "Fill sales" button
			And "Sales" table became equal
				| 'Use' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Quantity' | 'Sales invoice'                               | 'Unit' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| 'Yes' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '2,000'    | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'pcs'  | '200,00' | '338,98'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '400,00'       |
				| 'Yes' | 'Dress'              | 'Basic Price Types'       | 'S/Yellow' | '550,00'          | '2,000'    | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'pcs'  | '550,00' | '932,20'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '1 100,00'     |
		* Filling sales (only return)
			And I click Select button of "Sales period" field			
			And I input "05.11.2022" text in the field named "DateBegin"
			And I input "05.11.2022" text in the field named "DateEnd"
			And I click the button named "Select"
			And in the table "Sales" I click "Fill sales" button
			And "Sales" table became equal
				| 'Use' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Quantity' | 'Sales invoice'                               | 'Unit' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| 'Yes' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '-1,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'pcs'  | '200,00' | '-169,49'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-200,00'      |
				| 'Yes' | 'Dress'              | 'Basic Price Types'       | 'S/Yellow' | '550,00'          | '-2,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'pcs'  | '550,00' | '-932,20'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-1 100,00'    |
			And I go to line in "Sales" table
				| 'Consignor price' | 'Item'               | 'Item key' | 'Net amount' | 'Price'  | 'Price type'              | 'Purchase invoice'                               | 'Quantity' | 'Sales invoice'                               | 'Total amount' | 'Unit' | 'Use' |
				| '100,00'          | 'Product 3 with SLN' | 'UNIQ'     | '-169,49'    | '200,00' | 'en description is empty' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-1,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '-200,00'      | 'pcs'  | 'Yes' |
			And I activate "Use" field in "Sales" table
			And I change "Use" checkbox in "Sales" table
			And I finish line editing in "Sales" table
			And I click "Ok" button	
			And "ItemList" table became equal
				| '#' | 'Item'  | 'Price type'        | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Sales invoice'                               | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| '1' | 'Dress' | 'Basic Price Types' | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '-2,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '550,00' | '-932,20'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-1 100,00'    |
			And the editing text of form attribute named "EndDate" became equal to "05.11.2022"
			And the editing text of form attribute named "StartDate" became equal to "05.11.2022"						
		* Filling sales (previous period return and sale)
			And in the table "ItemList" I click "Fill sales" button
			And I click Select button of "Sales period" field
			Then "Select period" window is opened
			And I input current date in the field named "DateEnd"
			And I click the button named "Select"
			And in the table "Sales" I click "Fill sales" button
			And I click "Ok" button
			And "ItemList" table became equal
				| '#' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Sales invoice'                               | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| '1' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '-1,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-20,00'                 | '200,00' | '-169,49'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-200,00'      |
				| '2' | 'Dress'              | 'Basic Price Types'       | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '-2,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-110,00'                | '550,00' | '-932,20'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-1 100,00'    |
				| '3' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '3,000'    | '$$SI10$$' | '10,00'                   | '36,00'                  | '120,00' | '305,09'     | '$$PI3$$' | '360,00'       |
				| '4' | 'Dress'              | 'Basic Price without VAT' | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '2,000'    | '$$SI10$$' | '10,00'                   | '93,22'                  | '466,10' | '790,00'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '932,20'       |	
		* Change period and update sales
			And I input "01.11.2022" text in "Start date" field
			And in the table "ItemList" I click "Fill sales" button
			And in the table "Sales" I click "Fill sales" button
			And I click "Ok" button
			And "ItemList" table became equal
				| '#' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Sales invoice'                               | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| '1' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '1,000'    | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '20,00'                  | '200,00' | '169,49'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '200,00'       |
				| '2' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '3,000'    | '$$SI10$$' | '10,00'                   | '36,00'                  | '120,00' | '305,09'     | '$$PI3$$' | '360,00'       |
				| '3' | 'Dress'              | 'Basic Price without VAT' | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '2,000'    | '$$SI10$$' | '10,00'                   | '93,22'                  | '466,10' | '790,00'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '932,20'       |
			And I input "05.11.2022" text in "Start date" field
			And in the table "ItemList" I click "Fill sales" button
			And in the table "Sales" I click "Fill sales" button
			And I click "Ok" button	
			And "ItemList" table became equal
				| '#' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Sales invoice'                               | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| '1' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '-1,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-20,00'                 | '200,00' | '-169,49'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-200,00'      |
				| '2' | 'Dress'              | 'Basic Price Types'       | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '-2,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-110,00'                | '550,00' | '-932,20'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-1 100,00'    |
				| '3' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '3,000'    | '$$SI10$$' | '10,00'                   | '36,00'                  | '120,00' | '305,09'     | '$$PI3$$' | '360,00'       |
				| '4' | 'Dress'              | 'Basic Price without VAT' | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '2,000'    | '$$SI10$$' | '10,00'                   | '93,22'                  | '466,10' | '790,00'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '932,20'       |									
		* Update sales
			And in the table "ItemList" I click "Fill sales" button
			And in the table "Sales" I click "Fill sales" button
			And in the table "Sales" I click "Uncheck all" button
			And "Sales" table became equal
				| 'Use' | 'Item'               |
				| 'No'  | 'Product 3 with SLN' |
				| 'No'  | 'Dress'              |
				| 'No'  | 'Product 3 with SLN' |
				| 'No'  | 'Dress'              |
			And in the table "Sales" I click "Check all" button
			And "Sales" table became equal
				| 'Use' | 'Item'               |
				| 'Yes' | 'Product 3 with SLN' |
				| 'Yes' | 'Dress'              |
				| 'Yes' | 'Product 3 with SLN' |
				| 'Yes' | 'Dress'              |
			And I click "Ok" button
			And "ItemList" table became equal
				| '#' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Sales invoice'                               | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| '1' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '-1,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-20,00'                 | '200,00' | '-169,49'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-200,00'      |
				| '2' | 'Dress'              | 'Basic Price Types'       | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '-2,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-110,00'                | '550,00' | '-932,20'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-1 100,00'    |
				| '3' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '3,000'    | '$$SI10$$' | '10,00'                   | '36,00'                  | '120,00' | '305,09'     | '$$PI3$$' | '360,00'       |
				| '4' | 'Dress'              | 'Basic Price without VAT' | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '2,000'    | '$$SI10$$' | '10,00'                   | '93,22'                  | '466,10' | '790,00'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '932,20'       |	
		* Check currency form
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '-1,34'  |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '-7,8'   |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '-7,8'   |	
			And I click "Ok" button	
		* Post with a negative amount
			And I click "Post" button
			Then user message window does not contain messages
			And I delete "$$NumberSRC1$$" variable
			And I delete "$$SRC1$$" variable
			And I delete "$$DateSRC1$$" variable
			And I delete "$$EndDateSRC1$$" variable
			And I save the value of "Number" field as "$$NumberSRC1$$"
			And I save the window as "$$SRC1$$"
			And I save the value of the field named "Date" as "$$DateSRC1$$"
			And I save the value of the field named "EndDate" as "$$EndDateSRC1$$"
			And I click "Post and close" button 
		* Check creation
			And I go to line in "List" table
				| 'Number'         |
				| '$$NumberSRC1$$' |
			And I select current line in "List" table
		* Check filling
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			Then the form attribute named "Partner" became equal to "Consignor 1"
			Then the form attribute named "LegalName" became equal to "Consignor 1"
			Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
			Then the form attribute named "LegalNameContract" became equal to ""
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "TradeAgentFeeType" became equal to "Percent"
			And the editing text of form attribute named "StartDate" became equal to "05.11.2022"	
			And the editing text of form attribute named "EndDate" became equal to "$$EndDateSRC1$$"
			And "ItemList" table became equal
				| '#' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Sales invoice'                               | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| '1' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '-1,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-20,00'                 | '200,00' | '-169,49'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-200,00'      |
				| '2' | 'Dress'              | 'Basic Price Types'       | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '-2,000'   | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '10,00'                   | '-110,00'                | '550,00' | '-932,20'    | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-1 100,00'    |
				| '3' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '100,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '3,000'    | '$$SI10$$'                                    | '10,00'                   | '36,00'                  | '120,00' | '305,09'     | '$$PI3$$'                                        | '360,00'       |
				| '4' | 'Dress'              | 'Basic Price without VAT' | 'S/Yellow' | '550,00'          | ''                   | 'pcs'  | 'No'                 | '2,000'    | '$$SI10$$'                                    | '10,00'                   | '93,22'                  | '466,10' | '790,00'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '932,20'       |
			
			And "SerialLotNumbersTree" table became equal
				| 'Item'               | 'Item key' | 'Serial lot number' | 'Item key quantity' | 'Quantity' |
				| 'Product 3 with SLN' | 'UNIQ'     | ''                  | '-1,000'            | '-1,000'   |
				| ''                   | ''         | '09987897977889'    | ''                  | '-1,000'   |
				| 'Product 3 with SLN' | 'UNIQ'     | ''                  | '3,000'             | '3,000'    |
				| ''                   | ''         | '09987897977889'    | ''                  | '3,000'    |
			
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
			Then the form attribute named "Currency" became equal to "TRY"
			Then the form attribute named "Branch" became equal to ""
			Then the form attribute named "Author" became equal to "en description is empty"
			Then the form attribute named "ItemListTotalTradeAgentFeeAmount" became equal to "-0,78"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "-6,60"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "0,00"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "-7,80"
			Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
			And I close all client application windows
			
						
Scenario: _050026 check trade agent fee calculation
	And I close all client application windows
	* Open Sales report co consignor form
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"	
	* Create Sales report co consignor for Concignor 1
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Consignor 1' |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Consignor 1"
		Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
		And I input "01.11.2022" text in "Start date" field
		And I input "04.11.2022" text in "End date" field
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Product 3 with SLN' |
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
			| 'Owner' | 'Reference'      | 'Serial number'  |
			| 'UNIQ'  | '09987897977889' | '09987897977889' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Dress'       | 'Dress'     |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 3 with SLN' | 'UNIQ'     |
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I activate "Consignor price" field in "ItemList" table
		And I input "190,00" text in "Consignor price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "ItemList" table
		And I input "400,00" text in "Consignor price" field of "ItemList" table
		And I activate "Trade agent fee percent" field in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' |
			| 'Product 3 with SLN' | 'UNIQ'     |
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Consignor partner term 1'       |
		And I select current line in "List" table
	* Check filling trade agent fee
		And "ItemList" table became equal
			| '#' | 'Item'               | 'Price type'              | 'Item key' | 'Consignor price' | 'Serial lot numbers' | 'Unit' | 'Dont calculate row' | 'Quantity' | 'Sales invoice' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'Net amount' | 'Purchase invoice' | 'Total amount' |
			| '1' | 'Product 3 with SLN' | 'en description is empty' | 'UNIQ'     | '190,00'          | '09987897977889'     | 'pcs'  | 'No'                 | '2,000'    | ''              | '10,00'                   | '40,00'                  | '200,00' | '400,00'     | ''                 | '400,00'       |
			| '2' | 'Dress'              | 'Basic Price Types'       | 'S/Yellow' | '400,00'          | ''                   | 'pcs'  | 'No'                 | '1,000'    | ''              | '10,00'                   | '55,00'                  | '550,00' | '550,00'     | ''                 | '550,00'       |
	* Change price
		And I activate "Price" field in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "ItemList" table
		And I input "560,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'               | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  |
			| 'Product 3 with SLN' | 'UNIQ'     | '190,00'          | '2,000'    | '10,00'                   | '40,00'                  | '200,00' |
			| 'Dress'              | 'S/Yellow' | '400,00'          | '1,000'    | '10,00'                   | '56,00'                  | '560,00' |
	* Change quantity
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "ItemList" table
		And I input "3,00" text in "Quantity" field of "ItemList" table	
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'               | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'    |
			| 'Product 3 with SLN' | 'UNIQ'     | '190,00'          | '2,000'    | '10,00'                   | '40,00'                  | '200,00'   |
			| 'Dress'              | 'S/Yellow' | '400,00'          | '3,000'    | '10,00'                   | '168,00'                 | '560,00'   |
	* Change trade agent fee percent
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow' |
		And I select current line in "ItemList" table	
		And I input "20,00" text in "Trade agent fee percent" field of "ItemList" table	
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'               | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'    |
			| 'Product 3 with SLN' | 'UNIQ'     | '190,00'          | '2,000'    | '10,00'                   | '40,00'                  | '200,00'   |
			| 'Dress'              | 'S/Yellow' | '400,00'          | '3,000'    | '20,00'                   | '336,00'                 | '560,00'   |
	* Change trade agent fee type
		And I select "Difference price consignor price" exact value from "Trade agent fee type" drop-down list
		And "ItemList" table became equal
			| 'Item'               | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee amount' | 'Price'  |
			| 'Product 3 with SLN' | 'UNIQ'     | '190,00'          | '2,000'    | '20,00'                  | '200,00' |
			| 'Dress'              | 'S/Yellow' | '400,00'          | '3,000'    | '480,00'                 | '560,00' |
		And I close all client application windows
		
		
				
Scenario: _050028 check Sales invoice generate for trade agent fee (based on Sales report co consignor)
	And I close all client application windows
	* Create SRC
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Consignor 1' |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Consignor 1"
		Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
		And I input "01.11.2022" text in "Start date" field
		And I input "04.11.2022" text in "End date" field
		* Filling sales (sales and return)
			And in the table "ItemList" I click "Fill sales" button
			Then the form attribute named "SalesPeriod" became equal to "01.11.2022 - 04.11.2022"
			And in the table "Sales" I click "Fill sales" button
			And I click "Ok" button
			And I click "Post" button			
	* Create SI
		And Delay 3
		And I click "Sales invoice" button
		Then the form attribute named "Partner" became equal to "Consignor 1"
		Then the form attribute named "LegalName" became equal to "Consignor 1"
		Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
		Then the form attribute named "LegalNameContract" became equal to ""
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Sales"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'        | 'Item' | 'Item key' | 'Profit loss center'      | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Is additional item revenue' | 'Additional analytic' | 'Store' | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Work order' | 'Revenue type' |
			| '1' | 'Own stocks'       | ''             | 'Basic Price Types' | 'Fee'  | 'Fee'      | 'Distribution department' | 'No'                 | '22,88'      | 'pcs'  | ''                   | '1,000'    | '150,00' | '18%' | ''              | '127,12'     | '150,00'       | 'No'             | 'No'                         | ''                    | ''      | ''              | 'No'                        | ''       | ''            | ''           | 'Expense'      |
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "127,12"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "22,88"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "150,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post SI 
		And I click "Post" button 
		Then user message window does not contain messages
		And I delete "$$NumberSIFee1$$" variable
		And I delete "$$SIFee1$$" variable
		And I delete "$$DateSSIFee1$$" variable
		And I save the value of "Number" field as "$$NumberSIFee1$$"
		And I save the window as "$$SIFee1$$"
		And I save the value of the field named "Date" as "$$DateSIFee1$$"
		And I click "Post and close" button 
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"			
		And "List" table contains lines
			| 'Number'           |
			| '$$NumberSIFee1$$' |
		And I close all client application windows			

				

				
				
				
							
						
							
			
						
						
			
						
							
						
						

						
						
						

						
			
						
			
			
						
						
						
						
										