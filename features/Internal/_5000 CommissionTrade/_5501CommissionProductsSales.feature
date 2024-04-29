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
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)	
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records
		When Create catalog ItemTypes objects
		When Create catalog RetailCustomers objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Users objects
		When Create catalog Countries objects
		When Create catalog SourceOfOrigins objects
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
		When Create catalog Agreements objects (commision trade, own companies)
		When Create information register PricesByItemKeys records
		When Create information register PricesByItems records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create information register UserSettings records (Retail)
		When create consignors Items with SLN
		When Create catalog Partners objects
		When Create catalog CashAccounts objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
		When Create information register TaxSettings records (Concignor 2)
		When Create catalog SerialLotNumbers objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		When Create catalog Items objects (commission trade)
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Setting for Company
		When settings for Company (commission trade)
	* Load documents
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		When Create document SalesInvoice and SalesReturn objects (comission trade)
	* Post document
		* Posting Purchase invoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting PurchaseReturn
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting Sales invoice and Sales return
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(194).GetObject().Write(DocumentWriteMode.Posting);"    |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"    |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(193).GetObject().Write(DocumentWriteMode.Posting);"    |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(194).GetObject().Write(DocumentWriteMode.Posting);"    |
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
			| 'Description'    |
			| 'Ferron BP'      |
		And I go to line in "List" table
			| 'Description'    |
			| 'Consignor 1'    |
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
			| 'Description'          |
			| 'Product 11 with SLN (Main Company - Consignor 1)'   |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                 | 'Item key'    |
			| 'Product 11 with SLN (Main Company - Consignor 1)'   | 'UNIQ'        |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Serial number'     |
			| '11111111111111'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		Then "Item serial/lot numbers" window is opened
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Serial number' |
			| '0514'          |
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
			| 'Description'                                                           |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                                                  | 'Item key' |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' | 'ODS'      |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Serial number' |
			| '1123'          |
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
			| 'Description'                                                              |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                                                     | 'Item key' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
		And I select current line in "List" table
		And I select current line in "ItemList" table
		And I input "14,000" text in "Quantity" field of "ItemList" table
		And I input "550,00" text in "Price" field of "ItemList" table
		And I activate "Use goods receipt" field in "ItemList" table
		And I remove "Use goods receipt" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'                                                              |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'                                                                     | 'Item key' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'XL/Red'   |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I input "650,00" text in "Price" field of "ItemList" table
		And I activate "Use goods receipt" field in "ItemList" table
		And I remove "Use goods receipt" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check item tab
		And "ItemList" table became equal
			| 'Price type'              | 'Item'                                                                     | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'   | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Internal supply request' | 'Store'    | 'Delivery date' | 'Quantity' | 'Expense type' | 'Purchase order' | 'Sales order' | 'Net amount' | 'Use goods receipt' |
			| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | ''                   | 'No'                 | '76,27'      | 'pcs'  | '11111111111111; 0514' | '100,00' | '18%' | ''              | '500,00'       | ''                    | ''                        | 'Store 02' | ''              | '5,000'    | ''             | ''               | ''            | '423,73'     | 'No'                |
			| 'en description is empty' | 'Product 12 with SLN (Main Company - different consignor for item key)'    | 'ODS'      | ''                   | 'No'                 | '61,02'      | 'pcs'  | '1123'                 | '200,00' | '18%' | ''              | '400,00'       | ''                    | ''                        | 'Store 02' | ''              | '2,000'    | ''             | ''               | ''            | '338,98'     | 'No'                |
			| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | ''                   | 'No'                 | '1 174,58'   | 'pcs'  | ''                     | '550,00' | '18%' | ''              | '7 700,00'     | ''                    | ''                        | 'Store 02' | ''              | '14,000'   | ''             | ''               | ''            | '6 525,42'   | 'No'                |
			| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'XL/Red'   | ''                   | 'No'                 | '991,53'     | 'pcs'  | ''                     | '650,00' | '18%' | ''              | '6 500,00'     | ''                    | ''                        | 'Store 02' | ''              | '10,000'   | ''             | ''               | ''            | '5 508,47'   | 'No'                |
	* Fill branch and post PI
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I click "Post" button
		And I delete "$$NumberPI3$$" variable
		And I delete "$$PI3$$" variable
		And I delete "$$DatePI3$$" variable
		And I save the value of "Number" field as "$$NumberPI3$$"
		And I save the window as "$$PI3$$"
		And I save the value of the field named "Date" as "$$DatePI3$$"
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'           |
			| '$$NumberPI3$$'    |
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
			| 'Description'    |
			| 'Ferron BP'      |
		And I go to line in "List" table
			| 'Description'    |
			| 'Consignor 1'    |
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
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'                                                            | 'Unit' | 'Use' |
			| 'TRY'      | '200,00' | '2,000'    | 'Product 12 with SLN (Main Company - different consignor for item key) (ODS)' | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'                                                                   | 'Unit' | 'Use' |
			| 'TRY'      | '550,00' | '14,000'   | 'Product 13 without SLN (Main Company - different consignor for item key) (M/Black)' | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I select current line in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                                                  | 'Item key' |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' | 'ODS'      |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button	
		And I go to line in "ItemList" table
			| 'Item'                                                                     | 'Item key' | 'Net amount' | 'Price'  | 'Purchase invoice'                               | 'Quantity' | 'Store'    | 'Tax amount' | 'Total amount' | 'Unit' | 'VAT' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '6 525,42'   | '550,00' | '$$PI3$$' | '14,000'   | 'Store 02' | '1 174,58'   | '7 700,00'     | 'pcs'  | '18%' |
		And I select current line in "ItemList" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check item tab
		And "ItemList" table became equal
			| '#' | 'Item'                                                                     | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Serial lot numbers' | 'Unit' | 'Price'  | 'VAT' | 'Offers amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Quantity' | 'Expense type' | 'Use shipment confirmation' | 'Detail' | 'Return reason' | 'Net amount' | 'Purchase invoice' | 'Purchase return order' |
			| '1' | 'Product 12 with SLN (Main Company - different consignor for item key)'    | 'ODS'      | ''                   | 'No'                 | '30,51'      | '1123'               | 'pcs'  | '200,00' | '18%' | ''              | '200,00'       | ''                    | 'Store 02' | '1,000'    | ''             | 'Yes'                       | ''       | ''              | '169,49'     | '$$PI3$$'          | ''                      |
			| '2' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | ''                   | 'No'                 | '251,69'     | ''                   | 'pcs'  | '550,00' | '18%' | ''              | '1 650,00'     | ''                    | 'Store 02' | '3,000'    | ''             | 'Yes'                       | ''       | ''              | '1 398,31'   | '$$PI3$$'          | ''                      |
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
			| 'Number'           |
			| '$$NumberPR1$$'    |
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
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'         |
			| 'Partner term DFC'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
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
				| 'Description'                                      |
				| 'Product 11 with SLN (Main Company - Consignor 1)' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                                             | 'Item key' |
				| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     |
			And I select current line in "List" table
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '11111111111111'     |
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
				| 'Description'                                                              |
				| 'Product 13 without SLN (Main Company - different consignor for item key)' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                                                                     | 'Item key' |
				| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
			And I select current line in "List" table
			And I input "4,000" text in "Quantity" field of "ItemList" table	
			And I input "400,00" text in "Price" field of "ItemList" table	
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
		And "ItemList" table became equal
			| '#' | 'Inventory origin' | 'Price type'              | 'Item'                                                                     | 'Item key' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Source of origins' | 'Quantity' | 'Price'  | 'VAT' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other period revenue type'   | 'Store'    | 'Use shipment confirmation' |
			| '1' | 'Consignor stocks' | 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | 'No'                 | '73,22'      | 'pcs'  | '11111111111111'     | ''                  | '4,000'    | '120,00' | '18%' | '406,78'     | '480,00'       | 'No'             | ''                     | 'Store 02' | 'No'                        |
			| '2' | 'Consignor stocks' | 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | 'No'                 | '244,07'     | 'pcs'  | ''                   | ''                  | '4,000'    | '400,00' | '18%' | '1 355,93'   | '1 600,00'     | 'No'             | ''                     | 'Store 02' | 'No'                        |
		And I click "Post and close" button
	* Check creation
		And "List" table contains lines
			| 'Number'            |
			| '$$NumberSI10$$'    |
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
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'         |
			| 'Partner term DFC'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Branch"
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
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
				| 'Description'                                      |
				| 'Product 11 with SLN (Main Company - Consignor 1)' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                                             | 'Item key' |
				| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     |
			And I select current line in "List" table		
			And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
			And I activate field named "Owner" in "List" table
			And I go to line in "List" table
				| 'Owner'    | 'Serial number'      |
				| 'UNIQ'     | '11111111111111'     |
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
				| 'Description'                                                              |
				| 'Product 13 without SLN (Main Company - different consignor for item key)' |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                                                                     | 'Item key' |
				| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
			And I select current line in "List" table
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table		
			And I finish line editing in "ItemList" table
	* Link
		And in the table "ItemList" I click "Link unlink basis documents" button
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'                                                                   | 'Unit' |
			| 'TRY'      | '400,00' | '4,000'    | 'Product 13 without SLN (Main Company - different consignor for item key) (M/Black)' | 'pcs'  |
		And I click the button named "Link"
		And I go to line in "ItemListRows" table
			| '#' | 'Quantity' | 'Row presentation'                                        | 'Store'    | 'Unit' |
			| '1' | '1,000'    | 'Product 11 with SLN (Main Company - Consignor 1) (UNIQ)' | 'Store 02' | 'pcs'  |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency' | 'Price'  | 'Quantity' | 'Row presentation'                                        | 'Unit' |
			| 'TRY'      | '120,00' | '4,000'    | 'Product 11 with SLN (Main Company - Consignor 1) (UNIQ)' | 'pcs'  |
		And I click the button named "Link"
		And I click "Ok" button
	* Check filling
		And "ItemList" table became equal
			| '#' | 'Item'                                                                     | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Quantity' | 'Sales invoice' | 'Price'  | 'Net amount' | 'Use goods receipt' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Sales return order' | 'Return reason' | 'Revenue type' | 'VAT' | 'Offers amount' | 'Landed cost' | 'Sales person' |
			| '1' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | ''                   | 'No'                 | '18,31'      | 'pcs'  | '11111111111111'     | '1,000'    | '$$SI10$$'      | '120,00' | '101,69'     | 'Yes'               | '120,00'       | ''                    | 'Store 02' | ''                   | ''              | ''             | '18%' | ''              | ''            | ''             |
			| '2' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | ''                   | 'No'                 | '122,04'     | 'pcs'  | ''                   | '2,000'    | '$$SI10$$'      | '400,00' | '677,97'     | 'Yes'               | '800,00'       | ''                    | 'Store 02' | ''                   | ''              | ''             | '18%' | ''              | ''            | ''             |
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
			| 'Number'            |
			| '$$NumberSR10$$'    |
		And I close all client application windows

Scenario: _050015 create IT for (Consignor stocks)
	And I close all client application windows
	* Open IT form
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'                                      |
			| 'Product 11 with SLN (Main Company - Consignor 1)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                             | 'Item key' |
			| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number'     |
			| 'UNIQ'    | '11111111111111'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Product 13 without SLN (Main Company - different consignor for item key)'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Product 13 without SLN (Main Company - different consignor for item key)'   | 'M/Black'    |
		And I select current line in "List" table
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
		And "ItemList" table became equal
			| '#' | 'Item'                                                                     | 'Inventory origin' | 'Item key' | 'Serial lot numbers' | 'Unit' | 'Quantity' |
			| '1' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'Consignor stocks' | 'UNIQ'     | '11111111111111'     | 'pcs'  | '1,000'    |
			| '2' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'Consignor stocks' | 'M/Black'  | ''                   | 'pcs'  | '2,000'    |		
		And I click "Post and close" button 
	* Check creation
		And "List" table contains lines
			| 'Number'            |
			| '$$NumberIT10$$'    |
		And I close all client application windows		
						

Scenario: _050020 commission items batches calculation 
	And I close all client application windows
	* Create calculation movement cost
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I select "Landed cost (batch reallocate)" exact value from "Calculation mode" drop-down list
		And I input "01.10.2022" text in "Begin date" field
		And I input current date in "End date" field
		And I click "Post" button 
		And I delete "$$NumberCMC1$$" variable
		And I save the value of "Number" field as "$$NumberCMC1$$"
		And I click "Post and close" button 
	* Check creation
		And "List" table contains lines
			| 'Number'    |
			| '$$NumberCMC1$$' |
		


Scenario: _050025 create Sales report co consignor
	And I close all client application windows
	* Open Sales report co consignor form
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"	
	* Create Sales report co consignor for Concignor 1
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Consignor 1'    |
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
				| 'Use' | 'Item'                                                                     | 'Price type'              | 'Item key' | 'Consignor price' | 'Quantity' | 'Sales invoice'                               | 'Unit' | 'Price'  | 'Net amount' | 'Purchase invoice'                               | 'Total amount' |
				| 'Yes' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'en description is empty' | 'UNIQ'     | '100,00'          | '2,000'    | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'pcs'  | '200,00' | '338,98'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '400,00'       |
				| 'Yes' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'en description is empty' | 'M/Black'  | '650,00'          | '2,000'    | 'Sales invoice 194 dated 04.11.2022 16:33:38' | 'pcs'  | '550,00' | '932,20'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '1 100,00'     |
		* Filling sales (only return)
			And I click Select button of "Sales period" field			
			And I input "05.11.2022" text in the field named "DateBegin"
			And I input "05.11.2022" text in the field named "DateEnd"
			And I click the button named "Select"
			And in the table "Sales" I click "Fill sales" button
			And "Sales" table became equal
				| 'Use' | 'Item'                                             | 'Item key' | 'Serial lot number' | 'Source of origin'     | 'Quantity'  | 'Price type'              | 'Unit' | 'Consignor price' | 'Price'  | 'Net amount'  | 'Total amount' | 'Purchase invoice'                               | 'Sales invoice'                               |
				| 'Yes' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | '11111111111111'    | 'Source of origin 909' | '-2,000'    | 'en description is empty' | 'pcs'  | '100,00'          | '200,00' | '-400,00'     | '-400,00'      | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Sales invoice 194 dated 04.11.2022 16:33:38' |
			And I click "Ok" button	
			And "ItemList" table became equal
				| 'Price type'              | 'Item'                                             | 'Item key' | 'Consignor price' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'    | 'Sales invoice'                               | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT' | 'Purchase invoice'                               | 'Net amount' | 'Total amount' |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '-61,02'     | 'Source of origin 909' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '-2,000'   | '10,00'                   | '-40,00'                 | '200,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-400,00'    | '-400,00'      |
			And the editing text of form attribute named "EndDate" became equal to "05.11.2022"
			And the editing text of form attribute named "StartDate" became equal to "05.11.2022"						
		* Filling sales (previous period return and sale)
			And in the table "ItemList" I click "Fill sales" button
			And I click Select button of "Sales period" field
			Then "Select period" window is opened
			And I input "05.11.2022" text in the field named "DateBegin"
			And I input current date in the field named "DateEnd"
			And I click the button named "Select"
			And in the table "Sales" I click "Fill sales" button
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Price type'              | 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'    | 'Sales invoice'                               | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT' | 'Purchase invoice'                               | 'Net amount' | 'Total amount' |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '650,00'          | 'No'                 | ''                   | 'pcs'  | '183,05'     | ''                     | '$$SI10$$'                                    | '3,000'    | '10,00'                   | '120,00'                 | '400,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '1 016,94'   | '1 200,00'     |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '550,00'          | 'No'                 | ''                   | 'pcs'  | '61,02'      | ''                     | '$$SI10$$'                                    | '1,000'    | '10,00'                   | '40,00'                  | '400,00' | '18%' | '$$PI3$$'                                        | '338,98'     | '400,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '51,25'      | 'Source of origin 909' | 'Sales invoice 195 dated 19.12.2022 19:26:35' | '3,000'    | '10,00'                   | '33,60'                  | '112,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '284,76'     | '336,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '-61,02'     | 'Source of origin 909' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '-2,000'   | '10,00'                   | '-40,00'                 | '200,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-400,00'    | '-400,00'      |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '73,22'      | ''                     | '$$SI10$$'                                    | '4,000'    | '10,00'                   | '48,00'                  | '120,00' | '18%' | '$$PI3$$'                                        | '406,79'     | '480,00'       |
			Then the number of "ItemList" table lines is "равно" "5"
		* Change period and update sales
			And I input "01.11.2022" text in "Start date" field
			And in the table "ItemList" I click "Fill sales" button
			And in the table "Sales" I click "Fill sales" button
			And I click "Ok" button
			And "ItemList" table became equal
				| 'Price type'              | 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'    | 'Sales invoice'                               | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT' | 'Purchase invoice'                               | 'Net amount' | 'Total amount' |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '650,00'          | 'No'                 | ''                   | 'pcs'  | '167,80'     | ''                     | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '2,000'    | '10,00'                   | '110,00'                 | '550,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '932,20'     | '1 100,00'     |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '650,00'          | 'No'                 | ''                   | 'pcs'  | '183,05'     | ''                     | '$$SI10$$'                                    | '3,000'    | '10,00'                   | '120,00'                 | '400,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '1 016,94'   | '1 200,00'     |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '550,00'          | 'No'                 | ''                   | 'pcs'  | '61,02'      | ''                     | '$$SI10$$'                                    | '1,000'    | '10,00'                   | '40,00'                  | '400,00' | '18%' | '$$PI3$$'                                        | '338,98'     | '400,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '51,25'      | 'Source of origin 909' | 'Sales invoice 195 dated 19.12.2022 19:26:35' | '3,000'    | '10,00'                   | '33,60'                  | '112,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '284,76'     | '336,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '73,22'      | ''                     | '$$SI10$$'                                    | '4,000'    | '10,00'                   | '48,00'                  | '120,00' | '18%' | '$$PI3$$'                                        | '406,79'     | '480,00'       |
			And I input "05.11.2022" text in "Start date" field
			And in the table "ItemList" I click "Fill sales" button
			And in the table "Sales" I click "Fill sales" button
			And I click "Ok" button	
			And "ItemList" table contains lines
				| 'Price type'              | 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'    | 'Sales invoice'                               | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT' | 'Purchase invoice'                               | 'Net amount' | 'Total amount' |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '650,00'          | 'No'                 | ''                   | 'pcs'  | '183,05'     | ''                     | '$$SI10$$'                                    | '3,000'    | '10,00'                   | '120,00'                 | '400,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '1 016,94'   | '1 200,00'     |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '550,00'          | 'No'                 | ''                   | 'pcs'  | '61,02'      | ''                     | '$$SI10$$'                                    | '1,000'    | '10,00'                   | '40,00'                  | '400,00' | '18%' | '$$PI3$$'                                        | '338,98'     | '400,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '51,25'      | 'Source of origin 909' | 'Sales invoice 195 dated 19.12.2022 19:26:35' | '3,000'    | '10,00'                   | '33,60'                  | '112,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '284,76'     | '336,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '-61,02'     | 'Source of origin 909' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '-2,000'   | '10,00'                   | '-40,00'                 | '200,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-400,00'    | '-400,00'      |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '73,22'      | ''                     | '$$SI10$$'                                    | '4,000'    | '10,00'                   | '48,00'                  | '120,00' | '18%' | '$$PI3$$'                                        | '406,79'     | '480,00'       |
			Then the number of "ItemList" table lines is "равно" "5"
		* Update sales
			And in the table "ItemList" I click "Fill sales" button
			And in the table "Sales" I click "Fill sales" button
			And in the table "Sales" I click "Uncheck all" button
			And "Sales" table contains lines
				| 'Use' | 'Item'                                                                     | 'Item key' | 'Serial lot number' | 'Source of origin'     | 'Quantity' | 'Price type'              | 'Unit' | 'Consignor price' | 'Price'  | 'Net amount' | 'Total amount' | 'Purchase invoice'                               | 'Sales invoice'                               |
				| 'No'  | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '11111111111111'    | 'Source of origin 909' | '3,000'    | 'en description is empty' | 'pcs'  | '100,00'          | '112,00' | '284,76'     | '336,00'       | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Sales invoice 195 dated 19.12.2022 19:26:35' |
				| 'No'  | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '11111111111111'    | 'Source of origin 909' | '-2,000'   | 'en description is empty' | 'pcs'  | '100,00'          | '200,00' | '-400,00'    | '-400,00'      | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Sales invoice 194 dated 04.11.2022 16:33:38' |
				| 'No'  | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '11111111111111'    | ''                     | '4,000'    | 'en description is empty' | 'pcs'  | '100,00'          | '120,00' | '406,79'     | '480,00'       | '$$PI3$$'                                        | '$$SI10$$'                                    |
				| 'No'  | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | ''                  | ''                     | '3,000'    | 'en description is empty' | 'pcs'  | '650,00'          | '400,00' | '1 016,94'   | '1 200,00'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '$$SI10$$'                                    |
				| 'No'  | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | ''                  | ''                     | '1,000'    | 'en description is empty' | 'pcs'  | '550,00'          | '400,00' | '338,98'     | '400,00'       | '$$PI3$$'                                        | '$$SI10$$'                                    |
			Then the number of "Sales" table lines is "равно" "5"
			And in the table "Sales" I click "Check all" button
			And "Sales" table contains lines
				| 'Use' | 'Item'                                                                     | 'Item key' | 'Serial lot number' | 'Source of origin'     | 'Quantity' | 'Price type'              | 'Unit' | 'Consignor price' | 'Price'  | 'Net amount' | 'Total amount' | 'Purchase invoice'                               | 'Sales invoice'                               |
				| 'Yes' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '11111111111111'    | 'Source of origin 909' | '3,000'    | 'en description is empty' | 'pcs'  | '100,00'          | '112,00' | '284,76'     | '336,00'       | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Sales invoice 195 dated 19.12.2022 19:26:35' |
				| 'Yes' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '11111111111111'    | 'Source of origin 909' | '-2,000'   | 'en description is empty' | 'pcs'  | '100,00'          | '200,00' | '-400,00'    | '-400,00'      | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Sales invoice 194 dated 04.11.2022 16:33:38' |
				| 'Yes' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '11111111111111'    | ''                     | '4,000'    | 'en description is empty' | 'pcs'  | '100,00'          | '120,00' | '406,79'     | '480,00'       | '$$PI3$$'                                        | '$$SI10$$'                                    |
				| 'Yes' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | ''                  | ''                     | '3,000'    | 'en description is empty' | 'pcs'  | '650,00'          | '400,00' | '1 016,94'   | '1 200,00'     | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '$$SI10$$'                                    |
				| 'Yes' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | ''                  | ''                     | '1,000'    | 'en description is empty' | 'pcs'  | '550,00'          | '400,00' | '338,98'     | '400,00'       | '$$PI3$$'                                        | '$$SI10$$'                                    |
			Then the number of "Sales" table lines is "равно" "5"
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Price type'              | 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'    | 'Sales invoice'                               | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT' | 'Purchase invoice'                               | 'Net amount' | 'Total amount' |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '650,00'          | 'No'                 | ''                   | 'pcs'  | '183,05'     | ''                     | '$$SI10$$'                                    | '3,000'    | '10,00'                   | '120,00'                 | '400,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '1 016,94'   | '1 200,00'     |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '550,00'          | 'No'                 | ''                   | 'pcs'  | '61,02'      | ''                     | '$$SI10$$'                                    | '1,000'    | '10,00'                   | '40,00'                  | '400,00' | '18%' | '$$PI3$$'                                        | '338,98'     | '400,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '51,25'      | 'Source of origin 909' | 'Sales invoice 195 dated 19.12.2022 19:26:35' | '3,000'    | '10,00'                   | '33,60'                  | '112,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '284,76'     | '336,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '-61,02'     | 'Source of origin 909' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '-2,000'   | '10,00'                   | '-40,00'                 | '200,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-400,00'    | '-400,00'      |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '73,22'      | ''                     | '$$SI10$$'                                    | '4,000'    | '10,00'                   | '48,00'                  | '120,00' | '18%' | '$$PI3$$'                                        | '406,79'     | '480,00'       |
			Then the number of "ItemList" table lines is "равно" "5"
		* Check currency form
			And in the table "ItemList" I click "Edit currencies" button
			And "CurrenciesTable" table became equal
				| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
				| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,171200' | '345,14' |
				| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '2 016'  |
				| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '2 016'  |			
			And I click "Ok" button	
		* Post
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
				| 'Number'             |
				| '$$NumberSRC1$$'     |
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
			And "ItemList" table contains lines
				| 'Price type'              | 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'    | 'Sales invoice'                               | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT' | 'Purchase invoice'                               | 'Net amount' | 'Total amount' |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '650,00'          | 'No'                 | ''                   | 'pcs'  | '183,05'     | ''                     | '$$SI10$$'                                    | '3,000'    | '10,00'                   | '120,00'                 | '400,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '1 016,94'   | '1 200,00'     |
				| 'en description is empty' | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '550,00'          | 'No'                 | ''                   | 'pcs'  | '61,02'      | ''                     | '$$SI10$$'                                    | '1,000'    | '10,00'                   | '40,00'                  | '400,00' | '18%' | '$$PI3$$'                                        | '338,98'     | '400,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '51,25'      | 'Source of origin 909' | 'Sales invoice 195 dated 19.12.2022 19:26:35' | '3,000'    | '10,00'                   | '33,60'                  | '112,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '284,76'     | '336,00'       |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '-61,02'     | 'Source of origin 909' | 'Sales invoice 194 dated 04.11.2022 16:33:38' | '-2,000'   | '10,00'                   | '-40,00'                 | '200,00' | '18%' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | '-400,00'    | '-400,00'      |
				| 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '100,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '73,22'      | ''                     | '$$SI10$$'                                    | '4,000'    | '10,00'                   | '48,00'                  | '120,00' | '18%' | '$$PI3$$'                                        | '406,79'     | '480,00'       |
			Then the number of "ItemList" table lines is "равно" "5"
			And in the table "ItemList" I click "Open serial lot number tree" button
			And "SerialLotNumbersTree" table contains lines
				| 'Item'                                             | 'Item key' | 'Serial lot number' | 'Quantity' | 'Item key quantity' |
				| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | ''                  | '3,000'    | '3,000'             |
				| ''                                                 | ''         | '11111111111111'    | '3,000'    | ''                  |
				| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | ''                  | '-2,000'   | '-2,000'            |
				| ''                                                 | ''         | '11111111111111'    | '-2,000'   | ''                  |
				| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | ''                  | '4,000'    | '4,000'             |
				| ''                                                 | ''         | '11111111111111'    | '4,000'    | ''                  |		
			Then the number of "SerialLotNumbersTree" table lines is "равно" "6"
			And I close "Serial lot numbers tree" window
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
			Then the form attribute named "Currency" became equal to "TRY"
			Then the form attribute named "Branch" became equal to ""
			Then the form attribute named "Author" became equal to "CI"
			Then the form attribute named "ItemListTotalTradeAgentFeeAmount" became equal to "201,60"
			Then the form attribute named "ItemListTotalNetAmount" became equal to "1 647,47"
			Then the form attribute named "ItemListTotalTaxAmount" became equal to "307,52"
			Then the form attribute named "ItemListTotalTotalAmount" became equal to "2 016,00"
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
			| 'Description'    |
			| 'Consignor 1'    |
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
			| 'Description'                                      |
			| 'Product 11 with SLN (Main Company - Consignor 1)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                             | 'Item key' |
			| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     |
		And I select current line in "List" table
		And I activate field named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I activate field named "Owner" in "List" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number'     |
			| 'UNIQ'    | '11111111111111'    |
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
			| 'Description'                                                              |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                                                     | 'Item key' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'                                             | 'Item key' |
			| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     |
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I activate "Consignor price" field in "ItemList" table
		And I input "190,00" text in "Consignor price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                                                     | 'Item key' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
		And I select current line in "ItemList" table
		And I input "400,00" text in "Consignor price" field of "ItemList" table
		And I activate "Trade agent fee percent" field in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                             | 'Item key' |
			| 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     |
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Consignor partner term 1'    |
		And I select current line in "List" table
	* Check filling trade agent fee
		And "ItemList" table became equal
			| '#' | 'Price type'              | 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins' | 'Sales invoice' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  | 'VAT' | 'Purchase invoice' | 'Net amount' | 'Total amount' |
			| '1' | 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '190,00'          | 'No'                 | '11111111111111'     | 'pcs'  | '61,02'      | ''                  | ''              | '2,000'    | '10,00'                   | '40,00'                  | '200,00' | '18%' | ''                 | '338,98'     | '400,00'       |
			| '2' | 'Basic Price Types'       | 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '400,00'          | 'No'                 | ''                   | 'pcs'  | '16,93'      | ''                  | ''              | '1,000'    | '10,00'                   | '11,10'                  | '111,00' | '18%' | ''                 | '94,07'      | '111,00'       |
	* Change price
		And I activate "Price" field in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                                                     | 'Item key' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
		And I select current line in "ItemList" table
		And I input "560,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '190,00'          | '2,000'    | '10,00'                   | '40,00'                  | '200,00' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '400,00'          | '1,000'    | '10,00'                   | '56,00'                  | '560,00' |
	* Change quantity
		And I go to line in "ItemList" table
			| 'Item'                                                                     | 'Item key' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
		And I select current line in "ItemList" table
		And I input "3,00" text in "Quantity" field of "ItemList" table	
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '190,00'          | '2,000'    | '10,00'                   | '40,00'                  | '200,00' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '400,00'          | '3,000'    | '10,00'                   | '168,00'                 | '560,00' |
	* Change trade agent fee percent
		And I go to line in "ItemList" table
			| 'Item'                                                                     | 'Item key' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  |
		And I select current line in "ItemList" table	
		And I input "20,00" text in "Trade agent fee percent" field of "ItemList" table	
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee percent' | 'Trade agent fee amount' | 'Price'  |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '190,00'          | '2,000'    | '10,00'                   | '40,00'                  | '200,00' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '400,00'          | '3,000'    | '20,00'                   | '336,00'                 | '560,00' |
	* Change trade agent fee type
		And I select "Difference price consignor price" exact value from "Trade agent fee type" drop-down list
		And "ItemList" table became equal
			| 'Item'                                                                     | 'Item key' | 'Consignor price' | 'Quantity' | 'Trade agent fee amount' | 'Price'  |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'UNIQ'     | '190,00'          | '2,000'    | '20,00'                  | '200,00' |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'M/Black'  | '400,00'          | '3,000'    | '480,00'                 | '560,00' |
		And I close all client application windows
		
		
				
Scenario: _050028 check Sales invoice generate for trade agent fee (based on Sales report co consignor)
	And I close all client application windows
	* Create SRC
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Consignor 1'    |
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
			| '#'   | 'Inventory origin'   | 'Sales person'   | 'Price type'          | 'Item'   | 'Item key'   | 'Profit loss center'        | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Use work sheet'   | 'Other period revenue type'   | 'Additional analytic'   | 'Store'   | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'   | 'Work order'   | 'Revenue type'    |
			| '1'   | 'Own stocks'         | ''               | 'Basic Price Types'   | 'Fee'    | 'Fee'        | 'Distribution department'   | 'No'                   | '22,88'        | 'pcs'    | ''                     | '1,000'      | '150,00'   | '18%'   | ''                | '127,12'       | '150,00'         | 'No'               | ''                     | ''                      | ''        | ''                | 'No'                          | ''         | ''              | ''             | 'Expense'         |
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
		And I delete "$$DateSIFee1$$" variable
		And I save the value of "Number" field as "$$NumberSIFee1$$"
		And I save the window as "$$SIFee1$$"
		And I save the value of the field named "Date" as "$$DateSIFee1$$"
		And I click "Post and close" button 
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"			
		And "List" table contains lines
			| 'Number'              |
			| '$$NumberSIFee1$$'    |
		And I close all client application windows			

				
Scenario: _050041 check filling source of origin in the SI (consignors products)
	And I close all client application windows
	* Open SI form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I move to "Other" tab	
	* Add items	
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111112" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "9000009" text in the field named "Barcode"
		And I move to the next attribute
	* Check filling
		And "ItemList" table became equal
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                             | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers' | 'Source of origins'   | 'Quantity' | 'Price' | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Use work sheet' | 'Other period revenue type'   | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Work order' | 'Revenue type' |
			| '1' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '11111111111111'     | 'Source of origin 10' | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | 'No'             | ''                     | ''                    | 'Store 02' | ''              | 'Yes'                       | ''       | ''            | ''           | ''             |
			| '2' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '11111111111111'     | 'Source of origin 10' | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | 'No'             | ''                     | ''                    | 'Store 02' | ''              | 'Yes'                       | ''       | ''            | ''           | ''             |
			| '3' | 'Own stocks'       | ''             | 'Basic Price without VAT' | 'Product 6 with SLN'                               | 'PZU'      | ''                   | 'No'                 | ''           | 'pcs'  | '57897909799'        | ''                    | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | 'No'             | ''                     | ''                    | 'Store 02' | ''              | 'Yes'                       | ''       | ''            | ''           | ''             |
			| '4' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'PZU'      | ''                   | 'No'                 | ''           | 'pcs'  | '11111111111112'     | 'Source of origin 10' | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | 'No'             | ''                     | ''                    | 'Store 02' | ''              | 'Yes'                       | ''       | ''            | ''           | ''             |
			| '5' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 16 with SLN (Main Company - Consignor 2)' | 'UNIQ'     | ''                   | 'No'                 | ''           | 'pcs'  | '9000009'            | 'Source of origin 9'  | '1,000'    | ''      | 'Without VAT' | ''              | ''           | ''             | 'No'             | ''                     | ''                    | 'Store 02' | ''              | 'Yes'                       | ''       | ''            | ''           | ''             |		
		And I close all client application windows
		
				
		
		
Scenario: _050042 check filling source of origin in the RSR (consignors products)
	And I close all client application windows
	* Open RSR form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I move to "Other" tab	
	* Add items	
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111112" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "9000009" text in the field named "Barcode"
		And I move to the next attribute
	* Check filling
		And "ItemList" table contains lines
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                             | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'   | 'Quantity' | 'Price' | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '11111111111111'     | 'pcs'  | ''           | 'Source of origin 10' | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | ''                    | 'Store 02' | ''       | ''            | ''             |
			| '2' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '11111111111111'     | 'pcs'  | ''           | 'Source of origin 10' | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | ''                    | 'Store 02' | ''       | ''            | ''             |
			| '3' | 'Own stocks'       | ''             | 'Basic Price without VAT' | 'Product 6 with SLN'                               | 'PZU'      | 'Shop 02'            | 'No'                 | '57897909799'        | 'pcs'  | ''           | ''                    | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | ''                    | 'Store 02' | ''       | ''            | ''             |
			| '4' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '11111111111112'     | 'pcs'  | ''           | 'Source of origin 10' | '1,000'    | ''      | '18%'         | ''              | ''           | ''             | ''                    | 'Store 02' | ''       | ''            | ''             |
			| '5' | 'Consignor stocks' | ''             | 'Basic Price without VAT' | 'Product 16 with SLN (Main Company - Consignor 2)' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000009'            | 'pcs'  | ''           | 'Source of origin 9'  | '1,000'    | ''      | 'Without VAT' | ''              | ''           | ''             | ''                    | 'Store 02' | ''       | ''            | ''             |
		And I close all client application windows
		
				
		
				

Scenario: _050043 check filling source of origin in the RSR POS (consignors products)
	And I close all client application windows
	* Open POS and create RSR
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
	* Scan items
		And I click "Search by barcode (F7)" button
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "9000009" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Cash (/)" button
		And I click the button named "Enter"
	* Check filling source of origin
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
		And I go to line in "List" table
			| 'Amount'         |
			| '300,00'    |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Inventory origin' | 'Price type'              | 'Item'                                             | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers' | 'Unit' | 'Tax amount' | 'Source of origins'   | 'Quantity' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' | 'Store'    |
			| 'Consignor stocks' | 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '11111111111111'     | 'pcs'  | '15,25'      | 'Source of origin 10' | '1,000'    | '100,00' | '18%'         | '84,75'      | '100,00'       | 'Store 01' |
			| 'Consignor stocks' | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000009'            | 'pcs'  | ''           | 'Source of origin 9'  | '1,000'    | '100,00' | 'Without VAT' | '100,00'     | '100,00'       | 'Store 01' |
			| 'Consignor stocks' | 'en description is empty' | 'Product 11 with SLN (Main Company - Consignor 1)' | 'UNIQ'     | 'Shop 02'            | 'No'                 | '11111111111111'     | 'pcs'  | '15,25'      | 'Source of origin 10' | '1,000'    | '100,00' | '18%'         | '84,75'      | '100,00'       | 'Store 01' |	
		And I close all client application windows
		
				
						
Scenario: _050053 check filling consignor from serial lot number in the RetailSalesReceipt
	And I close all client application windows
	* Create RSR and filling main details
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	* Add items (scan barcode)
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898789" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898790" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898791" text in the field named "Barcode"
		And I move to the next attribute
	* Add items (input by line)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Product 12 with SLN (Main Company - different consignor for item key)" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I select "ODS" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click choice button of "Serial lot numbers" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Serial number' |
			| '1123'          |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button			
	* Select from list
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                                      |
			| 'Product 16 with SLN (Main Company - Consignor 2)' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                             | 'Item key' |
			| 'Product 16 with SLN (Main Company - Consignor 2)' | 'PZU'      |
		And I activate "Item key" field in "List" table
		And I select current line in "List" table
		And I click choice button of "Serial lot numbers" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number'   |
			| 'PZU'   | '900889900900777' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button	
		* Add one more item (consignor in the SLN)
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Product with Unique SLN' |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                    | 'Item key' |
				| 'Product with Unique SLN' | 'ODS'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I click Select button of "Serial lot number" field
			Then "Item serial/lot numbers" window is opened
			And I go to line in "List" table
				| 'Owner' | 'Serial number'       |
				| 'ODS'   | '0909088998998898789' |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			And I click "Ok" button
	* Check consignor
		And I click "Show row key" button
		And "ItemList" table became equal
			| 'Item'                                                                  | 'Consignor'   | 'Serial lot numbers'  | 'Unit' | 'Item key' | 'Quantity' |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 6 with SLN'                                                    | ''            | '57897909799'         | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 2' | '0909088998998898790' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898791' | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' | 'Consignor 1' | '1123'                | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product 16 with SLN (Main Company - Consignor 2)'                      | 'Consignor 2' | '900889900900777'     | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    |	
	* Post document and check consignor
		And I go to the last line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"		
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I activate "Payment type" field in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Cash'           |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "908,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I activate "Account" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №4'    |
		And I select current line in "List" table
		And I finish line editing in "Payments" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table became equal
			| 'Item'                                                                  | 'Consignor'   | 'Serial lot numbers'  | 'Unit' | 'Item key' | 'Quantity' |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 6 with SLN'                                                    | ''            | '57897909799'         | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 2' | '0909088998998898790' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898791' | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' | 'Consignor 1' | '1123'                | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product 16 with SLN (Main Company - Consignor 2)'                      | 'Consignor 2' | '900889900900777'     | 'pcs'  | 'PZU'      | '1,000'    |
		And I close all client application windows

		
Scenario: _050054 check filling consignor from serial lot number in the SalesInvoice (scan barcode)
	And I close all client application windows
	* Create SI and filling main details
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in the details
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	* Add items (scan barcode)
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898789" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898790" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898791" text in the field named "Barcode"
		And I move to the next attribute
	* Add items (input by line)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Product 12 with SLN (Main Company - different consignor for item key)" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I select "ODS" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click choice button of "Serial lot numbers" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Serial number'   |
			| '1123' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button			
	* Select from list
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                                      |
			| 'Product 16 with SLN (Main Company - Consignor 2)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                             | 'Item key' |
			| 'Product 16 with SLN (Main Company - Consignor 2)' | 'PZU'      |
		And I select current line in "List" table
		And I click choice button of "Serial lot numbers" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number'   |
			| 'PZU'   | '900889900900777' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		* Add one more item (consignor in the SLN)
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Product with Unique SLN' |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                    | 'Item key' |
				| 'Product with Unique SLN' | 'ODS'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I click Select button of "Serial lot number" field
			Then "Item serial/lot numbers" window is opened
			And I go to line in "List" table
				| 'Owner' | 'Serial number'       |
				| 'ODS'   | '0909088998998898789' |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			And I click "Ok" button
	* Check consignor
		And I click "Show row key" button
		And "ItemList" table became equal
			| 'Item'                                                                  | 'Consignor'   | 'Serial lot numbers'  | 'Unit' | 'Item key' | 'Quantity' |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 6 with SLN'                                                    | ''            | '57897909799'         | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 2' | '0909088998998898790' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898791' | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' | 'Consignor 1' | '1123'                | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product 16 with SLN (Main Company - Consignor 2)'                      | 'Consignor 2' | '900889900900777'     | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    |	
		And I go to the last line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
	* Post document and check consignor
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And "ItemList" table became equal
			| 'Item'                                                                  | 'Consignor'   | 'Serial lot numbers'  | 'Unit' | 'Item key' | 'Quantity' |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | 'Consignor 1' | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    |
			| 'Product 6 with SLN'                                                    | ''            | '57897909799'         | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 2' | '0909088998998898790' | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product with Unique SLN'                                               | 'Consignor 1' | '0909088998998898791' | 'pcs'  | 'PZU'      | '1,000'    |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' | 'Consignor 1' | '1123'                | 'pcs'  | 'ODS'      | '1,000'    |
			| 'Product 16 with SLN (Main Company - Consignor 2)'                      | 'Consignor 2' | '900889900900777'     | 'pcs'  | 'PZU'      | '1,000'    |	
		And I close all client application windows

Scenario: _050055 check filling consignor from serial lot number in the IT (scan barcode)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	* Filling in the details
		And I select from the drop-down list named "Company" by "main company" string
		And I select from "Store sender" drop-down list by "01" string
		And I select from "Store receiver" drop-down list by "02" string
	* Add items (scan barcode)
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "11111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898789" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898790" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "0909088998998898791" text in the field named "Barcode"
		And I move to the next attribute
	* Add items (input by line)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Product 12 with SLN (Main Company - different consignor for item key)" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I select "ODS" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click choice button of "Serial lot numbers" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Serial number'   |
			| '1123' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button			
	* Select from list
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                                      |
			| 'Product 16 with SLN (Main Company - Consignor 2)' |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'                                             | 'Item key' |
			| 'Product 16 with SLN (Main Company - Consignor 2)' | 'PZU'      |
		And I select current line in "List" table
		And I click choice button of "Serial lot numbers" attribute in "ItemList" table
		And in the table "SerialLotNumbers" I click "Add" button
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number'   |
			| 'PZU'   | '900889900900777' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		* Add one more item (consignor in the SLN)
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Product with Unique SLN' |
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'                    | 'Item key' |
				| 'Product with Unique SLN' | 'ODS'      |
			And I activate "Item key" field in "List" table
			And I select current line in "List" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I click Select button of "Serial lot number" field
			Then "Item serial/lot numbers" window is opened
			And I go to line in "List" table
				| 'Owner' | 'Serial number'       |
				| 'ODS'   | '0909088998998898789' |
			And I activate "Serial number" field in "List" table
			And I select current line in "List" table
			And I click "Ok" button
	* Check consignor
		And "ItemList" table became equal
			| 'Item'                                                                  | 'Serial lot numbers'  | 'Unit' | 'Item key' | 'Quantity' |'Inventory origin'     |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    | 'Consignor stocks'    |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                      | '11111111111111'      | 'pcs'  | 'UNIQ'     | '1,000'    | 'Consignor stocks'    |
			| 'Product 6 with SLN'                                                    | '57897909799'         | 'pcs'  | 'PZU'      | '1,000'    | 'Own stocks'          |
			| 'Product with Unique SLN'                                               | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    | 'Consignor stocks'    |
			| 'Product with Unique SLN'                                               | '0909088998998898790' | 'pcs'  | 'ODS'      | '1,000'    | 'Consignor stocks'    |
			| 'Product with Unique SLN'                                               | '0909088998998898791' | 'pcs'  | 'PZU'      | '1,000'    | 'Consignor stocks'    |
			| 'Product 12 with SLN (Main Company - different consignor for item key)' | '1123'                | 'pcs'  | 'ODS'      | '1,000'    | 'Consignor stocks'    |
			| 'Product 16 with SLN (Main Company - Consignor 2)'                      | '900889900900777'     | 'pcs'  | 'PZU'      | '1,000'    | 'Consignor stocks'    |
			| 'Product with Unique SLN'                                               | '0909088998998898789' | 'pcs'  | 'ODS'      | '1,000'    | 'Consignor stocks'    |
		And I close all client application windows			
	
Scenario: _050057 check filling consignor RGR-RRR (scan barcode)
	And I close all client application windows
	* Create RGR (return from customer)
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "main" string
		And I click Select button of "Retail customer" field
		And I go to line in "List" table
			| 'Description'   |
			| 'Test01 Test01' |
		And I select current line in "List" table
		And I select "Return from customer" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		* Add items
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898789" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898790" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "11111111111111" text in the field named "Barcode"
			And I move to the next attribute
		* Check
			And "ItemList" table became equal
				| 'Item'                                             | 'Inventory origin' | 'Item key' | 'Serial lot numbers'  | 'Unit' | 'Source of origins'   | 'Quantity' | 'Store'    |
				| 'Product with Unique SLN'                          | 'Consignor stocks' | 'ODS'      | '0909088998998898789' | 'pcs'  | ''                    | '1,000'    | 'Store 02' |
				| 'Product with Unique SLN'                          | 'Consignor stocks' | 'ODS'      | '0909088998998898790' | 'pcs'  | ''                    | '1,000'    | 'Store 02' |
				| 'Product 11 with SLN (Main Company - Consignor 1)' | 'Consignor stocks' | 'UNIQ'     | '11111111111111'      | 'pcs'  | 'Source of origin 10' | '1,000'    | 'Store 02' |
		* Post
			And I click the button named "FormPost"
			And I delete "$$RGR050057$$" variable
			And I delete "$$NumberRGR050057$$" variable
			And I save the window as "$$RGR050057$$"
	* Create RRR
		And I click "Sales return" button
		Then "Add linked document rows" window is opened
		And I click "Ok" button
		And I click "Show row key" button
		And "ItemList" table became equal
			| 'Store'    | 'Use serial lot number' | 'Item'                                             | 'Consignor'   | 'Inventory origin' | 'Unit' | 'Serial lot numbers'  | 'Item key' | 'Source of origins' | 'Quantity' | 'VAT'         |
			| 'Store 02' | 'Yes'                   | 'Product with Unique SLN'                          | 'Consignor 1' | 'Consignor stocks' | 'pcs'  | '0909088998998898789' | 'ODS'      | ''                  | '1,000'    | '18%'         |
			| 'Store 02' | 'Yes'                   | 'Product with Unique SLN'                          | 'Consignor 2' | 'Consignor stocks' | 'pcs'  | '0909088998998898790' | 'ODS'      | ''                  | '1,000'    | 'Without VAT' |
			| 'Store 02' | 'Yes'                   | 'Product 11 with SLN (Main Company - Consignor 1)' | 'Consignor 1' | 'Consignor stocks' | 'pcs'  | '11111111111111'      | 'UNIQ'     | ''                  | '1,000'    | '18%'         |
		* Unlink and link back
			And in the table "ItemList" I click "Link unlink basis documents" button
			Then "Link / unlink document row" window is opened
			And I change checkbox "Linked documents"
			And in the table "ResultsTree" I click "Unlink all" button
			And I click "Ok" button
			And "ItemList" table became equal
				| 'Store'    | 'Use serial lot number' | 'Item'                                             | 'Consignor'   | 'Inventory origin' | 'Unit' | 'Serial lot numbers'  | 'Item key' | 'Source of origins' | 'Quantity' | 'VAT'         |
				| 'Store 02' | 'Yes'                   | 'Product with Unique SLN'                          | 'Consignor 1' | 'Consignor stocks' | 'pcs'  | '0909088998998898789' | 'ODS'      | ''                  | '1,000'    | '18%'         |
				| 'Store 02' | 'Yes'                   | 'Product with Unique SLN'                          | 'Consignor 2' | 'Consignor stocks' | 'pcs'  | '0909088998998898790' | 'ODS'      | ''                  | '1,000'    | 'Without VAT' |
				| 'Store 02' | 'Yes'                   | 'Product 11 with SLN (Main Company - Consignor 1)' | 'Consignor 1' | 'Consignor stocks' | 'pcs'  | '11111111111111'      | 'UNIQ'     | ''                  | '1,000'    | '18%'         |
			And in the table "ItemList" I click "Goods receipts" button
			Then the number of "DocumentsTree" table lines is "равно" 0
			And I close current window								
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I go to line in "ItemListRows" table
				| 'Quantity' | 'Row presentation'                                    |
				| '1,000'    | 'Product with Unique SLN (ODS) (0909088998998898790)' |
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation'                                    | 'Unit' | 'Price' |
				| '1,000'    | 'Product with Unique SLN (ODS) (0909088998998898790)' | 'pcs'  | ''      |
			And I click the button named "Link"
			And I go to line in "ItemListRows" table
				| 'Row presentation'                                    | 'Store'    | 'Unit' |
				| 'Product with Unique SLN (ODS) (0909088998998898789)' | 'Store 02' | 'pcs'  |
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation'                                    | 'Unit' | 'Price' |
				| '1,000'    | 'Product with Unique SLN (ODS) (0909088998998898789)' | 'pcs'  | ''      |
			And I click the button named "Link"
			And I go to line in "ItemListRows" table
				| 'Quantity' | 'Row presentation'                                        | 'Store'    | 'Unit' |
				| '1,000'    | 'Product 11 with SLN (Main Company - Consignor 1) (UNIQ)' | 'Store 02' | 'pcs'  |
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation'                                        | 'Unit' | 'Price' |
				| '1,000'    | 'Product 11 with SLN (Main Company - Consignor 1) (UNIQ)' | 'pcs'  | ''      |
			And I click the button named "Link"
			And I click "Ok" button
		* Check
			And in the table "ItemList" I click "Goods receipts" button
			And "DocumentsTree" table became equal
				| 'Presentation'                                            | 'Invoice' | 'QuantityInDocument' | 'Quantity' |
				| 'Product with Unique SLN (ODS)'                           | '1,000'   | '1,000'              | '1,000'    |
				| '$$RGR050057$$'                                           | ''        | '1,000'              | '1,000'    |
				| 'Product with Unique SLN (ODS)'                           | '1,000'   | '1,000'              | '1,000'    |
				| '$$RGR050057$$'                                           | ''        | '1,000'              | '1,000'    |
				| 'Product 11 with SLN (Main Company - Consignor 1) (UNIQ)' | '1,000'   | '1,000'              | '1,000'    |
				| '$$RGR050057$$'                                           | ''        | '1,000'              | '1,000'    |
			And I close current window
			And "ItemList" table became equal
				| 'Store'    | 'Use serial lot number' | 'Item'                                             | 'Consignor'   | 'Inventory origin' | 'Unit' | 'Serial lot numbers'  | 'Item key' | 'Source of origins' | 'Quantity' | 'VAT'         |
				| 'Store 02' | 'Yes'                   | 'Product with Unique SLN'                          | 'Consignor 1' | 'Consignor stocks' | 'pcs'  | '0909088998998898789' | 'ODS'      | ''                  | '1,000'    | '18%'         |
				| 'Store 02' | 'Yes'                   | 'Product with Unique SLN'                          | 'Consignor 2' | 'Consignor stocks' | 'pcs'  | '0909088998998898790' | 'ODS'      | ''                  | '1,000'    | 'Without VAT' |
				| 'Store 02' | 'Yes'                   | 'Product 11 with SLN (Main Company - Consignor 1)' | 'Consignor 1' | 'Consignor stocks' | 'pcs'  | '11111111111111'      | 'UNIQ'     | ''                  | '1,000'    | '18%'         |
		And I close all client application windows
		
			
						
Scenario: _050059 check sequence of filling consignor from item, item key and SLN
	And I close all client application windows
	* Preparation (filling consignor for item)
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b7aa9f63eb85c76911ee6827f4884c13"
		And I expand "Consignors info" group
		If "ConsignorsInfo" table does not contain lines Then
			| 'Company'      | 'Consignor'   |
			| 'Main Company' | 'Consignor 2' |
			And in the table "ConsignorsInfo" I click "Add" button	
			And I click choice button of "Company" attribute in "ConsignorsInfo" table
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company' |
			And I select current line in "List" table		
			And I click choice button of "Consignor" attribute in "ConsignorsInfo" table
			And I go to line in "List" table
				| 'Description' |
				| 'Consignor 2' |
			And I select current line in "List" table
			And I finish line editing in "ConsignorsInfo" table
			And I click "Save and close" button
	* Check filling consignor from SLN in RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click "Create" button
		* Scan SLN
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
		* Select SLN 
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I select "Product with Unique SLN" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I select from the drop-down list named "SerialLotNumberSingle" by "0909088998998898791" string
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Product with Unique SLN" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "pzu" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I click the button named "FormSearchByBarcode"
			Then "Barcode" window is opened
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898790" text in the field named "Barcode"
			And I move to the next attribute
		* Check
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'              | 'Item'                    | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
		And I close all client application windows
	* Check filling consignor from SLN in POS
		And In the command interface I select "Retail" "Point of sale"
		* Scan SLN
			And I click "Search by barcode (F7)" button
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
			And I finish line editing in "ItemList" table
		* Select SLN 
			And I move to "Items" tab
			And I go to line in "ItemsPickup" table
				| 'Item'                    |
				| 'Product with Unique SLN' |
			And I expand current line in "ItemsPickup" table
			And I go to line in "ItemsPickup" table
				| 'Item'                         |
				| 'Product with Unique SLN, PZU' |
			And I select current line in "ItemsPickup" table
			And I click the button named "FormSearchByBarcode"
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
			And I go to line in "ItemsPickup" table
				| 'Item'                         |
				| 'Product with Unique SLN, PZU' |
			And I select current line in "ItemsPickup" table
			And I select from the drop-down list named "SerialLotNumberSingle" by "0909088998998898791" string
			And I click "Ok" button
			And I click "Search by barcode (F7)" button
			And I input "0909088998998898790" text in the field named "Barcode"
			And I move to the next attribute
			And I finish line editing in "ItemList" table
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "OK" button
		* Check
			And I save message text as "RSRNumber"
			And I execute 1C:Enterprise script
        		| "Контекст.Insert("RSRNumber", TrimR(Контекст["RSRNumber"]))" |
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"									
			And I go to line in "List" table
				| 'Number'      |
				| '$RSRNumber$' |
			And I select current line in "List" table
		* Check
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'              | 'Item'                    | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types'       | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
		And I close all client application windows

Scenario: _050060 check sequence of filling consignor from item key and SLN
		And I close all client application windows
	* Change consignor for item key 
		Given I open hyperlink "e1cib/data/Catalog.ItemKeys?ref=b7aa9f63eb85c76911ee6827f4884c14"
		And I expand "Consignors info" group		
		And I change the radio button named "ConsignorInfoMode" value to "Own"	
		If "ConsignorsInfo" table contains lines Then
			| 'Company'      | 'Consignor'   |
			| 'Main Company' | 'Consignor 2' |	
			And I click choice button of "Company" attribute in "ConsignorsInfo" table
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company' |
			And I select current line in "List" table	
			And I click choice button of "Consignor" attribute in "ConsignorsInfo" table
			And I go to line in "List" table
				| 'Description' |
				| 'Consignor 1' |
			And I select current line in "List" table
			And I finish line editing in "ConsignorsInfo" table
			And I click "Save and close" button
	* Check filling consignor from SLN
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click "Create" button
		* Scan SLN
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898790" text in the field named "Barcode"
			And I move to the next attribute
		* Select SLN 
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I select "Product with Unique SLN" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I select from the drop-down list named "SerialLotNumberSingle" by "0909088998998898790" string
			And I click "Ok" button
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Product with Unique SLN" from "Item" drop-down list by string in "ItemList" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I select "ods" by string from the drop-down list named "ItemListItemKey" in "ItemList" table
			And I activate "Serial lot numbers" field in "ItemList" table
			And I click choice button of "Serial lot numbers" attribute in "ItemList" table
			And I click the button named "FormSearchByBarcode"
			And I input "0909088998998898790" text in the field named "Barcode"
			And I move to the next attribute
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898789" text in the field named "Barcode"
			And I move to the next attribute
		* Check
			And Delay 2
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'        | 'Item'                    | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
			And I close all client application windows
	* Check filling consignor from SLN in POS
		And In the command interface I select "Retail" "Point of sale"
		* Scan SLN
			And I click "Search by barcode (F7)" button
			And I input "0909088998998898790" text in the field named "Barcode"
			And I move to the next attribute
			And I finish line editing in "ItemList" table
		* Select SLN 
			And I move to "Items" tab
			And I go to line in "ItemsPickup" table
				| 'Item'                    |
				| 'Product with Unique SLN' |
			And I expand current line in "ItemsPickup" table
			And I go to line in "ItemsPickup" table
				| 'Item'                         |
				| 'Product with Unique SLN, ODS' |
			And I select current line in "ItemsPickup" table
			And I click the button named "FormSearchByBarcode"
			And I input "0909088998998898790" text in the field named "Barcode"
			And I move to the next attribute
			And I go to line in "ItemsPickup" table
				| 'Item'                         |
				| 'Product with Unique SLN, ODS' |
			And I select current line in "ItemsPickup" table
			And I select from the drop-down list named "SerialLotNumberSingle" by "0909088998998898790" string
			And I click "Ok" button
			And I click "Search by barcode (F7)" button
			And I input "0909088998998898789" text in the field named "Barcode"
			And I move to the next attribute
			And I finish line editing in "ItemList" table
			And I click "Payment (+)" button
			And I click "Cash (/)" button
			And I click "OK" button
		* Check
			And I save message text as "RSRNumber"
			And I execute 1C:Enterprise script
        		| "Контекст.Insert("RSRNumber", TrimR(Контекст["RSRNumber"]))" |
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"									
			And I go to line in "List" table
				| 'Number'      |
				| '$RSRNumber$' |
			And I select current line in "List" table
		* Check
			And "ItemList" table became equal
				| 'Inventory origin' | 'Price type'        | 'Item'                    | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Quantity' | 'Price'  | 'VAT'         | 'Net amount' | 'Total amount' | 'Store'    |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898790' | 'pcs'  | ''           | '1,000'    | '111,00' | 'Without VAT' | '111,00'     | '111,00'       | 'Store 01' |
				| 'Consignor stocks' | 'Basic Price Types' | 'Product with Unique SLN' | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '16,93'      | '1,000'    | '111,00' | '18%'         | '94,07'      | '111,00'       | 'Store 01' |
		And I close all client application windows
	And I close all client application windows
		
						
		
						

						


						

						
						


						
		
				
				
				
				

						


				


