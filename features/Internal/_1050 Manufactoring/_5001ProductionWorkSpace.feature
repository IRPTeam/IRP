#language: en
@tree
@ProductionWorkSpace

Feature: production work space

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I open new TestClient session or connect the existing one

Scenario: _5001 preparation
	When set True value to the constant
	When Create catalog AddAttributeAndPropertySets objects
	When Create catalog AddAttributeAndPropertyValues objects
	When Create catalog Partners objects (Ferron BP)
	When Create catalog Companies objects (partners company)
	When Create information register PartnerSegments records
	When Create catalog Agreements objects
	When Create catalog TaxRates objects
	When Create catalog Taxes objects	
	When Create information register TaxSettings records
	When Create catalog IntegrationSettings objects
	When Create catalog Companies objects (Main company)
	When Create catalog ItemTypes objects (MF)
	When Create catalog Stores objects
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects (MF)
	When Create catalog Countries objects
	When Create catalog Items objects (MF)
	When Create catalog Units objects
	When Create catalog Units objects (MF)
	When Create catalog ItemKeys objects (MF)
	When Create chart of characteristic types AddAttributeAndProperty objects
	When Create information register CurrencyRates records
	When Create information register UserSettings records (store receiver in IT)
	When Create information register Taxes records (VAT)
	When Create catalog MFBillOfMaterials objects
	When Create catalog PlanningPeriods objects (MF)
	When Create information register Barcodes records (MF)
	When Create catalog ObjectStatuses objects
	When Create catalog ObjectStatuses objects (MF)
	When Create document ProductionPlanning objects
	And Delay 5
	When Create document Production objects
	And Delay 5
	And I execute 1C:Enterprise script at server
		| "Documents.Production.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		| "Documents.Production.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		| "Documents.Production.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		| "Documents.Production.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document ProductionPlanningCorrection objects
	And Delay 5

Scenario: _5002 check preparation
	When check preparation

Scenario: _5003 create IT + PR from Production Workspace (product)
		And I close all client application windows
	* Open Production workspace
		Given I open hyperlink "e1cib/app/DataProcessor.ProductionWorkspace"
	* Add item info (product, add by barcode)
		And I click "Input barcode" button
		And I input "5678900009900990" text in the field named "InputFld"	
		And I click "OK" button
	* Check filling item info
		Then the form attribute named "Item" became equal to "Стремянка номер 6 ступенчатая"
		Then the form attribute named "ItemKey" became equal to "Стремянка номер 6 ступенчатая"
		And "PlanningPresentation" table became equal
			| 'Production planning'                               | 'Planning period'   | 'Left to produce'    |
			| 'Production planning 1 dated 29.04.2022 09:40:47'   | 'First month'       | '80,000'             |
			| 'Production planning 2 dated 29.04.2022 09:42:27'   | 'Second month'      | '122,000'            |
		Then the form attribute named "Unit" became equal to "pcs"
	* Create IT + PR
		And I input "2,000" text in the field named "Quantity"
		And I move to the next attribute
		And "PlanningPresentation" table became equal
			| 'Production planning'                               | 'Planning period'   | 'Left to produce'    |
			| 'Production planning 1 dated 29.04.2022 09:40:47'   | 'First month'       | '80,000'             |
			| 'Production planning 2 dated 29.04.2022 09:42:27'   | 'Second month'      | '122,000'            |
		And I click "PR+IT" button
	* Check creation Production
		Given I open hyperlink "e1cib/list/Document.Production"		
		And I go to line in "List" table
			| 'Number' |
			| '13'     |
		And I select current line in "List" table		
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Production store 05"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "PlanningPeriod" became equal to "First month"
		Then the form attribute named "ProductionPlanning" became equal to "Production planning 1 dated 29.04.2022 09:40:47"
		And the field named "PlanningPeriodStartDate" is filled
		And the field named "PlanningPeriodEndDate" is filled
		Then the form attribute named "StoreProduction" became equal to "Store 01"
		Then the form attribute named "Item" became equal to "Стремянка номер 6 ступенчатая"
		Then the form attribute named "ItemKey" became equal to "Стремянка номер 6 ступенчатая"
		Then the form attribute named "BillOfMaterials" became equal to "Стремянка номер 6 ступенчатая"
		And the editing text of form attribute named "ExtraCostAmountByRatio" became equal to "0,00"
		Then the form attribute named "Unit" became equal to "pcs"
		And the editing text of form attribute named "Quantity" became equal to "2,000"
		And "Materials" table became equal
			| '#'   | '(BOM) Item'                                | '(BOM) Item key'                            | '(BOM) Unit'   | '(BOM) Q'   | 'Item'                                      | 'Item key'                                  | 'Material type'   | 'Writeoff store'   | 'Unit'   | 'Q'         |
			| '1'   | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'          | '30,000'    | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'Material'        | 'Store 07'         | 'pcs'    | '30,000'    |
			| '2'   | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'           | '4,000'     | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'Material'        | 'Store 07'         | 'кг'     | '4,000'     |
			| '3'   | 'Краска порошковая серая 9006'              | 'Краска порошковая серая 9006'              | 'кг'           | '2,000'     | 'Краска порошковая серая 9006'              | 'Краска порошковая серая 9006'              | 'Material'        | 'Store 07'         | 'кг'     | '2,000'     |
			| '4'   | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'          | '4,000'     | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'Material'        | 'Store 07'         | 'pcs'    | '4,000'     |
			| '5'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'          | '10,000'    | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'Material'        | 'Store 07'         | 'pcs'    | '10,000'    |
			| '6'   | 'Коврик для стремянок Класс, черный'        | 'Коврик для стремянок Класс, черный'        | 'pcs'          | '2,000'     | 'Коврик для стремянок Класс, черный'        | 'Коврик для стремянок Класс, черный'        | 'Material'        | 'Store 07'         | 'pcs'    | '2,000'     |
			| '7'   | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'          | '20,000'    | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'Material'        | 'Store 07'         | 'pcs'    | '20,000'    |
			| '8'   | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'          | '4,000'     | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'Semiproduct'     | 'Store 04'         | 'pcs'    | '4,000'     |
			| '9'   | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'          | '4,000'     | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'Semiproduct'     | 'Store 04'         | 'pcs'    | '4,000'     |
		Then the form attribute named "ProductionType" became equal to "Product"
		Then the form attribute named "Finished" became equal to "Yes"
		Then the form attribute named "Branch" became equal to ""
		And field "Author" is filled
	* Check creation IT
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"	
		And I go to the last line in "List" table
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 01"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "StoreTransit" became equal to ""
		Then the form attribute named "StoreReceiver" became equal to "Store 06"
		And "ItemList" table became equal
			| '#'   | 'Item'                            | 'Item key'                        | 'Serial lot numbers'   | 'Unit'   | 'Quantity'   | 'Inventory transfer order'   | 'Production planning'                                |
			| '1'   | 'Стремянка номер 6 ступенчатая'   | 'Стремянка номер 6 ступенчатая'   | ''                     | 'pcs'    | '2,000'      | ''                           | 'Production planning 1 dated 29.04.2022 09:40:47'    |
		And in the table "ItemList" I click "Open serial lot number tree" button
		Then the number of "SerialLotNumbersTree" table lines is "равно" 0
		And I close "Serial lot numbers tree" window
		Then the form attribute named "UseShipmentConfirmation" became equal to "No"
		Then the form attribute named "UseGoodsReceipt" became equal to "No"
		Then the form attribute named "Branch" became equal to "Production store 05"
		And field "Author" is filled
	And I close all client application windows
	
Scenario: _5004 create IT from Production Workspace (product) and check filling inventory origin							
	And I close all client application windows
	* Open Production workspace
		Given I open hyperlink "e1cib/app/DataProcessor.ProductionWorkspace"
	* Add item info (product)	
		And I select from the drop-down list named "Item" by "Стремянка номер 6 ступенчатая" string
		And I select from the drop-down list named "ItemKey" by "Стремянка номер 6 ступенчатая" string
		And I input "2,000" text in the field named "Quantity"
		And I select from the drop-down list named "Unit" by "pcs" string
		And I move to the tab named "GroupInventoryTransfer"
		And "PlanningPresentation" table became equal
			| 'Production planning'                               | 'Planning period'   | 'Left to produce'    |
			| 'Production planning 1 dated 29.04.2022 09:40:47'   | 'First month'       | '78,000'             |
			| 'Production planning 2 dated 29.04.2022 09:42:27'   | 'Second month'      | '122,000'            |
		And I click "IT" button
	* Check creation
		* Set Use commission trading for inventory origin check 
			Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
			And I go to line in "FunctionalOptions" table
				| 'Option'                 |
				| 'Use commission trading' |
			And I set "Use" checkbox in "FunctionalOptions" table
			And I finish line editing in "FunctionalOptions" table
			And I click "Save" button	
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"	
		And I go to the last line in "List" table
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 01"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "StoreTransit" became equal to ""
		Then the form attribute named "StoreReceiver" became equal to "Store 06"
		And "ItemList" table became equal
			| '#'   | 'Item'                            | 'Item key'                        | 'Serial lot numbers'   | 'Unit'   | 'Quantity'   | 'Inventory transfer order'   | 'Production planning'                                | 'Inventory origin'   |
			| '1'   | 'Стремянка номер 6 ступенчатая'   | 'Стремянка номер 6 ступенчатая'   | ''                     | 'pcs'    | '2,000'      | ''                           | 'Production planning 1 dated 29.04.2022 09:40:47'    | 'Own stocks'         |
		And in the table "ItemList" I click "Open serial lot number tree" button
		Then the number of "SerialLotNumbersTree" table lines is "равно" 0
		And I close "Serial lot numbers tree" window
		Then the form attribute named "UseShipmentConfirmation" became equal to "No"
		Then the form attribute named "UseGoodsReceipt" became equal to "No"
		Then the form attribute named "Branch" became equal to "Production store 05"
		And field "Author" is filled
	And I close all client application windows


Scenario: _5005 create IT from Production Workspace (product)	
	And I close all client application windows
	* Open Production workspace
		Given I open hyperlink "e1cib/app/DataProcessor.ProductionWorkspace"
	* Add item info (semiproduct)		
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'                                |
			| 'Копыта на стремянки Класс 20х20, черный'    |
		And I select current line in "List" table
		And I click Choice button of the field named "ItemKey"
		And I go to line in "List" table
			| 'Item key'                                   |
			| 'Копыта на стремянки Класс 20х20, черный'    |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And "PlanningPresentation" table contains lines
			| 'Planning period'   | 'Left to produce'   | 'Production planning'                                |
			| 'First month'       | '680,000'           | 'Production planning 1 dated 29.04.2022 09:40:47'    |
	* Create PR and check
		And I move to the tab named "GroupProductions"
		And I click "PR" button
		Given I open hyperlink "e1cib/list/Document.Production"		
		And I go to line in "List" table
			| 'Number' |
			| '14'     |
		And I select current line in "List" table	
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Production store 05"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "PlanningPeriod" became equal to "First month"
		Then the form attribute named "ProductionPlanning" became equal to "Production planning 1 dated 29.04.2022 09:40:47"
		And the field named "PlanningPeriodStartDate" is filled
		And the field named "PlanningPeriodEndDate" is filled
		Then the form attribute named "StoreProduction" became equal to "Store 01"
		Then the form attribute named "Item" became equal to "Копыта на стремянки Класс 20х20, черный"
		Then the form attribute named "ItemKey" became equal to "Копыта на стремянки Класс 20х20, черный"
		Then the form attribute named "BillOfMaterials" became equal to "01 Копыта на стремянки Класс 20х20"
		And the editing text of form attribute named "ExtraCostAmountByRatio" became equal to "0,00"
		Then the form attribute named "Unit" became equal to "pcs"
		And the editing text of form attribute named "Quantity" became equal to "2,000"
		And "Materials" table became equal
			| '#'   | '(BOM) Item'   | '(BOM) Item key'   | '(BOM) Unit'   | '(BOM) Q'   | 'Item'      | 'Item key'   | 'Material type'   | 'Writeoff store'   | 'Unit'   | 'Q'        |
			| '1'   | 'ПВД 158'      | 'ПВД 158'          | 'кг'           | '1,960'     | 'ПВД 158'   | 'ПВД 158'    | 'Material'        | 'Store 07'         | 'кг'     | '1,960'    |
		
		Then the form attribute named "ProductionType" became equal to "Semiproduct"
		Then the form attribute named "Finished" became equal to "Yes"
		Then the form attribute named "Branch" became equal to ""
		And field "Author" is filled
	And I close all client application windows

Scenario: _5006 check change item key if change unit in the Production workspace
	And I close all client application windows
	* Open Production workspace
		Given I open hyperlink "e1cib/app/DataProcessor.ProductionWorkspace"
	* Add item info (semiproduct)		
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'                                |
			| 'Копыта на стремянки Класс 20х20, черный'    |
		And I select current line in "List" table
		And I click Choice button of the field named "ItemKey"
		And I go to line in "List" table
			| 'Item key'                                   |
			| 'Копыта на стремянки Класс 20х20, черный'    |
		And I select current line in "List" table	
		Then the form attribute named "ItemKey" became equal to "Копыта на стремянки Класс 20х20, черный"
	* Change item
		And I select from the drop-down list named "Item" by "Катанка Ст3сп 6,5" string
		Then the form attribute named "ItemKey" became equal to ""
		Then the form attribute named "Unit" became equal to ""
	* Check that button for create documents are not available
		When I Check the steps for Exception
			| 'And I click "PR" button'    |
		When I Check the steps for Exception
			| 'And I click "IT" button'    |
		When I Check the steps for Exception
			| 'And I click "PR+IT" button'    |
		And I close all client application windows
		
		
				
				
				
				
					
								
				


	

				
				
		
				




