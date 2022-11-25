#language: en
@tree
@Positive
@LoadInfo

Functionality: load data form

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _020100 preparation (LoadDataForm)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Items objects (serial lot numbers)
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Users objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog FileStorageVolumes objects
		When Create catalog Files objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company

Scenario: _0201001 check preparation
	When check preparation

Scenario: _020110 load data in the SI
		And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling SI
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
	* Open load date form	
		And in the table "ItemList" I click "LoadDataFromTable" button
		Then "Load data from table" window is opened
		And I click "Show images" button
		Then "Load data from table" window is opened
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283705"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "67789997777801"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And I click "Next" button
	* Check
		// Given in "Result" Spreadsheet document and "LoadDataWithPicture" template contain the same pictures
		Given "Result" spreadsheet document is equal to "LoadDataWithPicture" by template
	* Add barcode with serial lot number
		And I click "Back" button
		And Delay 5
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "23455677788976667"
		And Delay 5
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "23455677788976667"
	* Add wrong barcode
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "234500000"
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "234500000"
		And Delay 5
	* Add the same barcode
		And in "Template" spreadsheet document I move to "R7C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283705"
		And in "Template" spreadsheet document I move to "R7C2" cell
		And in "Template" spreadsheet document I input text "5"
	* Check
		And I click "Show images" button
		And I click "Next" button
		Then "Template" spreadsheet document is equal
			| 'Barcode'           | 'Quantity' |
			| 'Barcode'           | 'Quantity' |
			| '2202283705'        | ''         |
			| '67789997777801'    | '2'        |
			| '23455677788976667' | ''         |
			| '234500000'         | ''         |
			| '2202283705'        | '5'        |
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then "Result" spreadsheet document is equal by template
			| 'Key' | 'Image'                                    | 'ItemType'                                    | 'Item'               | 'ItemKey'   | 'SerialLotNumber'         | 'Unit'       | 'hasSpecification' | 'UseSerialLotNumber'    | 'Quantity' | 'Barcode'           |
			| 'Key' | ''                                         | 'Item types'                                  | 'Items'              | 'Item keys' | 'Item serial/lot numbers' | 'Item units' | 'Item types'       | 'Use serial lot number' | 'Quantity' | 'Barcode'           |
			| '0'   | 'f82457a7c91f5d12beec5826930cb235blue.jpg' | 'Clothes'                                     | 'Dress'              | 'XS/Blue'   | ''                        | 'pcs'        | '*'                | '*'                     | '1,000'    | '2202283705'        |
			| '1'   | ''                                         | 'With serial lot numbers (use stock control)' | 'Product 1 with SLN' | 'ODS'       | ''                        | 'pcs'        | '*'                | '*'                     | '2,000'    | '67789997777801'    |
			| '2'   | ''                                         | 'With serial lot numbers (use stock control)' | 'Product 1 with SLN' | 'PZU'       | '8908899877'              | 'pcs'        | '*'                | '*'                     | '1,000'    | '23455677788976667' |
			| '3'   | ''                                         | ''                                            | ''                   | ''          | ''                        | ''           | '*'                | '*'                     | '1,000'    | '234500000'         |
			| '4'   | 'f82457a7c91f5d12beec5826930cb235blue.jpg' | 'Clothes'                                     | 'Dress'              | 'XS/Blue'   | ''                        | 'pcs'        | '*'                | '*'                     | '5,000'    | '2202283705'        |
		And "ErrorList" table became equal
			| 'Row' | 'Column' | 'Error text'   |
			| '4'   | '6'      | '[Not filled]' |
			| '6'   | '4'      | '[Not filled]' |
			| '6'   | '5'      | '[Not filled]' |
	* Fix barcode and check loading
		And I click "Back" button
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283713"
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283713"
		And in "Template" spreadsheet document I move to "R6C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "3"
		And I click "Next" button
		And I click "Next" button
	* Check
		And "ItemList" table contains lines
			| '#' | 'Price type'        | 'Item'               | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Tax amount' | 'Unit' | 'Serial lot numbers'           | 'Quantity' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Is additional item revenue' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order' | 'Revenue type' | 'Sales person' |
			| '1' | 'Basic Price Types' | 'Dress'              | 'XS/Blue'  | ''                   | 'No'                 | '475,93'     | 'pcs'  | ''                             | '6,000'    | '520,00' | '18%' | ''              | '2 644,07'   | '3 120,00'     | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
			| '2' | 'Basic Price Types' | 'Product 1 with SLN' | 'ODS'      | ''                   | 'No'                 | ''           | 'pcs'  | ''                             | '2,000'    | ''       | '18%' | ''              | ''           | ''             | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
			| '3' | 'Basic Price Types' | 'Product 1 with SLN' | 'PZU'      | ''                   | 'No'                 | ''           | 'pcs'  | '8908899877'                   | '1,000'    | ''       | '18%' | ''              | ''           | ''             | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
			| '4' | 'Basic Price Types' | 'Dress'              | 'S/Yellow' | ''                   | 'No'                 | '251,69'     | 'pcs'  | ''                             | '3,000'    | '550,00' | '18%' | ''              | '1 398,31'   | '1 650,00'     | 'No'                         | ''                    | 'Store 01' | ''              | 'No'                        | ''       | ''            | ''             | ''             |
		And I close all client application windows
		
		

Scenario: _020112 load data in the Physical inventory
		And I close all client application windows
	* Open Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Filling Physical inventory
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot"	
	* Open load date form	
		And in the table "ItemList" I click "LoadDataFromTable" button
		Then "Load data from table" window is opened
		And I click "Show images" button
		Then "Load data from table" window is opened
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283705"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "67789997777801"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And I click "Next" button
	* Check
		// Given in "Result" Spreadsheet document and "LoadDataWithPicture" template contain the same pictures
		Given "Result" spreadsheet document is equal to "LoadDataWithPicture" by template
	* Add barcode with serial lot number
		And I click "Back" button
		And Delay 5
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "23455677788976667"
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "23455677788976667"
	* Add wrong barcode
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "234500000"
	* Add the same barcode
		And in "Template" spreadsheet document I move to "R7C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283705"
		And in "Template" spreadsheet document I move to "R7C2" cell
		And in "Template" spreadsheet document I input text "5"
	* Check
		And I click "Show images" button
		And I click "Next" button
		Then "Template" spreadsheet document is equal
			| 'Barcode'           | 'Quantity' |
			| 'Barcode'           | 'Quantity' |
			| '2202283705'        | ''         |
			| '67789997777801'    | '2'        |
			| '23455677788976667' | ''         |
			| '234500000'         | ''         |
			| '2202283705'        | '5'        |
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then "Result" spreadsheet document is equal
			| 'Key' | 'Image'                                    | 'ItemType'                                    | 'Item'               | 'ItemKey'   | 'SerialLotNumber'         | 'Unit'       | 'hasSpecification' | 'UseSerialLotNumber'    | 'Quantity' | 'Barcode'           |
			| 'Key' | ''                                         | 'Item types'                                  | 'Items'              | 'Item keys' | 'Item serial/lot numbers' | 'Item units' | 'Item types'       | 'Use serial lot number' | 'Quantity' | 'Barcode'           |
			| '0'   | 'f82457a7c91f5d12beec5826930cb235blue.jpg' | 'Clothes'                                     | 'Dress'              | 'XS/Blue'   | ''                        | 'pcs'        | 'No'               | 'No'                    | '1,000'    | '2202283705'        |
			| '1'   | ''                                         | 'With serial lot numbers (use stock control)' | 'Product 1 with SLN' | 'ODS'       | ''                        | 'pcs'        | 'No'               | 'Yes'                   | '2,000'    | '67789997777801'    |
			| '2'   | ''                                         | 'With serial lot numbers (use stock control)' | 'Product 1 with SLN' | 'PZU'       | '8908899877'              | 'pcs'        | 'No'               | 'Yes'                   | '1,000'    | '23455677788976667' |
			| '3'   | ''                                         | ''                                            | ''                   | ''          | ''                        | ''           | 'No'               | 'No'                    | '1,000'    | '234500000'         |
			| '4'   | 'f82457a7c91f5d12beec5826930cb235blue.jpg' | 'Clothes'                                     | 'Dress'              | 'XS/Blue'   | ''                        | 'pcs'        | 'No'               | 'No'                    | '5,000'    | '2202283705'        |
		And "ErrorList" table became equal
			| 'Row' | 'Column' | 'Error text'   |
			| '4'   | '6'      | '[Not filled]' |
			| '6'   | '4'      | '[Not filled]' |
			| '6'   | '5'      | '[Not filled]' |
	* Fix barcode and check loading
		And I click "Back" button
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283713"
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283713"
		And in "Template" spreadsheet document I move to "R6C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "3"
		And I click "Next" button
		And I click "Next" button
	* Check
		And "ItemList" table became equal
			| '#' | 'Exp. count' | 'Item'               | 'Item key' | 'Serial lot number' | 'Unit' | 'Difference' | 'Phys. count' | 'Manual fixed count' | 'Description' |
			| '1' | ''           | 'Dress'              | 'XS/Blue'  | ''                  | 'pcs'  | '6,000'      | '6,000'       | ''                   | ''            |
			| '2' | ''           | 'Product 1 with SLN' | 'ODS'      | ''                  | 'pcs'  | '2,000'      | '2,000'       | ''                   | ''            |
			| '3' | ''           | 'Product 1 with SLN' | 'PZU'      | '8908899877'        | 'pcs'  | '1,000'      | '1,000'       | ''                   | ''            |
			| '4' | ''           | 'Dress'              | 'S/Yellow' | ''                  | 'pcs'  | '3,000'      | '3,000'       | ''                   | ''            |		
		And I close all client application windows				
		
				

		
				
		
		
				
		
		
				
		
				
	
				
		
				
		
		
				
		
				
				
		